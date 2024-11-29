
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
  800042:	e8 b8 22 00 00       	call   8022ff <sys_getenvid>
  800047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  80004a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	IO_CS = create_semaphore("IO.CS", 1);
  800051:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	6a 01                	push   $0x1
  80005c:	68 e0 43 80 00       	push   $0x8043e0
  800061:	50                   	push   %eax
  800062:	e8 8a 40 00 00       	call   8040f1 <create_semaphore>
  800067:	83 c4 0c             	add    $0xc,%esp
  80006a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800070:	a3 48 50 80 00       	mov    %eax,0x805048
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800075:	e8 d5 20 00 00       	call   80214f <sys_calculate_free_frames>
  80007a:	89 c3                	mov    %eax,%ebx
  80007c:	e8 e7 20 00 00       	call   802168 <sys_calculate_modified_frames>
  800081:	01 d8                	add    %ebx,%eax
  800083:	89 45 ec             	mov    %eax,-0x14(%ebp)

		Iteration++ ;
  800086:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_lock_cons();
		int NumOfElements, *Elements;
		wait_semaphore(IO_CS);
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	ff 35 48 50 80 00    	pushl  0x805048
  800092:	e8 8e 40 00 00       	call   804125 <wait_semaphore>
  800097:	83 c4 10             	add    $0x10,%esp
		{
			readline("Enter the number of elements: ", Line);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000a3:	50                   	push   %eax
  8000a4:	68 e8 43 80 00       	push   $0x8043e8
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
  8000e2:	68 08 44 80 00       	push   $0x804408
  8000e7:	e8 81 09 00 00       	call   800a6d <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 2b 44 80 00       	push   $0x80442b
  8000f7:	e8 71 09 00 00       	call   800a6d <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 39 44 80 00       	push   $0x804439
  800107:	e8 61 09 00 00       	call   800a6d <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 48 44 80 00       	push   $0x804448
  800117:	e8 51 09 00 00       	call   800a6d <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 58 44 80 00       	push   $0x804458
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
  800169:	ff 35 48 50 80 00    	pushl  0x805048
  80016f:	e8 cb 3f 00 00       	call   80413f <signal_semaphore>
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
  800202:	68 64 44 80 00       	push   $0x804464
  800207:	6a 4d                	push   $0x4d
  800209:	68 86 44 80 00       	push   $0x804486
  80020e:	e8 9d 05 00 00       	call   8007b0 <_panic>
		else
		{
			wait_semaphore(IO_CS);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	ff 35 48 50 80 00    	pushl  0x805048
  80021c:	e8 04 3f 00 00       	call   804125 <wait_semaphore>
  800221:	83 c4 10             	add    $0x10,%esp
				cprintf("\n===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 a4 44 80 00       	push   $0x8044a4
  80022c:	e8 3c 08 00 00       	call   800a6d <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 d8 44 80 00       	push   $0x8044d8
  80023c:	e8 2c 08 00 00       	call   800a6d <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 0c 45 80 00       	push   $0x80450c
  80024c:	e8 1c 08 00 00       	call   800a6d <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			signal_semaphore(IO_CS);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	ff 35 48 50 80 00    	pushl  0x805048
  80025d:	e8 dd 3e 00 00       	call   80413f <signal_semaphore>
  800262:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		wait_semaphore(IO_CS);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 35 48 50 80 00    	pushl  0x805048
  80026e:	e8 b2 3e 00 00       	call   804125 <wait_semaphore>
  800273:	83 c4 10             	add    $0x10,%esp
			cprintf("Freeing the Heap...\n\n") ;
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 3e 45 80 00       	push   $0x80453e
  80027e:	e8 ea 07 00 00       	call   800a6d <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
		signal_semaphore(IO_CS);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 35 48 50 80 00    	pushl  0x805048
  80028f:	e8 ab 3e 00 00       	call   80413f <signal_semaphore>
  800294:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		wait_semaphore(IO_CS);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 35 48 50 80 00    	pushl  0x805048
  8002a0:	e8 80 3e 00 00       	call   804125 <wait_semaphore>
  8002a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Do you want to repeat (y/n): ") ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 54 45 80 00       	push   $0x804554
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
  8002ed:	ff 35 48 50 80 00    	pushl  0x805048
  8002f3:	e8 47 3e 00 00       	call   80413f <signal_semaphore>
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
  80058b:	e8 6f 1d 00 00       	call   8022ff <sys_getenvid>
  800590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	wait_semaphore(IO_CS);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 35 48 50 80 00    	pushl  0x805048
  80059c:	e8 84 3b 00 00       	call   804125 <wait_semaphore>
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
  8005c4:	68 72 45 80 00       	push   $0x804572
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
  8005e6:	68 74 45 80 00       	push   $0x804574
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
  800614:	68 79 45 80 00       	push   $0x804579
  800619:	e8 4f 04 00 00       	call   800a6d <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(IO_CS);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	ff 35 48 50 80 00    	pushl  0x805048
  80062a:	e8 10 3b 00 00       	call   80413f <signal_semaphore>
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
  800649:	e8 99 1b 00 00       	call   8021e7 <sys_cputc>
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
  80065a:	e8 24 1a 00 00       	call   802083 <sys_cgetc>
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
  800677:	e8 9c 1c 00 00       	call   802318 <sys_getenvindex>
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
  8006e5:	e8 b2 19 00 00       	call   80209c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	68 98 45 80 00       	push   $0x804598
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
  800715:	68 c0 45 80 00       	push   $0x8045c0
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
  800746:	68 e8 45 80 00       	push   $0x8045e8
  80074b:	e8 1d 03 00 00       	call   800a6d <cprintf>
  800750:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800753:	a1 24 50 80 00       	mov    0x805024,%eax
  800758:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	50                   	push   %eax
  800762:	68 40 46 80 00       	push   $0x804640
  800767:	e8 01 03 00 00       	call   800a6d <cprintf>
  80076c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80076f:	83 ec 0c             	sub    $0xc,%esp
  800772:	68 98 45 80 00       	push   $0x804598
  800777:	e8 f1 02 00 00       	call   800a6d <cprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80077f:	e8 32 19 00 00       	call   8020b6 <sys_unlock_cons>
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
  800797:	e8 48 1b 00 00       	call   8022e4 <sys_destroy_env>
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
  8007a8:	e8 9d 1b 00 00       	call   80234a <sys_exit_env>
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
  8007bf:	a1 58 50 80 00       	mov    0x805058,%eax
  8007c4:	85 c0                	test   %eax,%eax
  8007c6:	74 16                	je     8007de <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007c8:	a1 58 50 80 00       	mov    0x805058,%eax
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	50                   	push   %eax
  8007d1:	68 54 46 80 00       	push   $0x804654
  8007d6:	e8 92 02 00 00       	call   800a6d <cprintf>
  8007db:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007de:	a1 00 50 80 00       	mov    0x805000,%eax
  8007e3:	ff 75 0c             	pushl  0xc(%ebp)
  8007e6:	ff 75 08             	pushl  0x8(%ebp)
  8007e9:	50                   	push   %eax
  8007ea:	68 59 46 80 00       	push   $0x804659
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
  80080e:	68 75 46 80 00       	push   $0x804675
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
  80083d:	68 78 46 80 00       	push   $0x804678
  800842:	6a 26                	push   $0x26
  800844:	68 c4 46 80 00       	push   $0x8046c4
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
  800912:	68 d0 46 80 00       	push   $0x8046d0
  800917:	6a 3a                	push   $0x3a
  800919:	68 c4 46 80 00       	push   $0x8046c4
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
  800985:	68 24 47 80 00       	push   $0x804724
  80098a:	6a 44                	push   $0x44
  80098c:	68 c4 46 80 00       	push   $0x8046c4
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
  8009c4:	a0 30 50 80 00       	mov    0x805030,%al
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
  8009df:	e8 76 16 00 00       	call   80205a <sys_cputs>
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
  800a39:	a0 30 50 80 00       	mov    0x805030,%al
  800a3e:	0f b6 c0             	movzbl %al,%eax
  800a41:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a47:	83 ec 04             	sub    $0x4,%esp
  800a4a:	50                   	push   %eax
  800a4b:	52                   	push   %edx
  800a4c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a52:	83 c0 08             	add    $0x8,%eax
  800a55:	50                   	push   %eax
  800a56:	e8 ff 15 00 00       	call   80205a <sys_cputs>
  800a5b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a5e:	c6 05 30 50 80 00 00 	movb   $0x0,0x805030
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
  800a73:	c6 05 30 50 80 00 01 	movb   $0x1,0x805030
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
  800aa0:	e8 f7 15 00 00       	call   80209c <sys_lock_cons>
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
  800ac0:	e8 f1 15 00 00       	call   8020b6 <sys_unlock_cons>
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
  800b0a:	e8 55 36 00 00       	call   804164 <__udivdi3>
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
  800b5a:	e8 15 37 00 00       	call   804274 <__umoddi3>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	05 94 49 80 00       	add    $0x804994,%eax
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
  800cb5:	8b 04 85 b8 49 80 00 	mov    0x8049b8(,%eax,4),%eax
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
  800d96:	8b 34 9d 00 48 80 00 	mov    0x804800(,%ebx,4),%esi
  800d9d:	85 f6                	test   %esi,%esi
  800d9f:	75 19                	jne    800dba <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da1:	53                   	push   %ebx
  800da2:	68 a5 49 80 00       	push   $0x8049a5
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
  800dbb:	68 ae 49 80 00       	push   $0x8049ae
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
  800de8:	be b1 49 80 00       	mov    $0x8049b1,%esi
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
  800fe0:	c6 05 30 50 80 00 00 	movb   $0x0,0x805030
			break;
  800fe7:	eb 2c                	jmp    801015 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800fe9:	c6 05 30 50 80 00 01 	movb   $0x1,0x805030
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
  801113:	68 28 4b 80 00       	push   $0x804b28
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
  801155:	68 2b 4b 80 00       	push   $0x804b2b
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
  801206:	e8 91 0e 00 00       	call   80209c <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80120b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80120f:	74 13                	je     801224 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	ff 75 08             	pushl  0x8(%ebp)
  801217:	68 28 4b 80 00       	push   $0x804b28
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
  801259:	68 2b 4b 80 00       	push   $0x804b2b
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
  801301:	e8 b0 0d 00 00       	call   8020b6 <sys_unlock_cons>
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
  8019fb:	68 3c 4b 80 00       	push   $0x804b3c
  801a00:	68 3f 01 00 00       	push   $0x13f
  801a05:	68 5e 4b 80 00       	push   $0x804b5e
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
  801a1b:	e8 e5 0b 00 00       	call   802605 <sys_sbrk>
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
  801a96:	e8 ee 09 00 00       	call   802489 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	74 16                	je     801ab5 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a9f:	83 ec 0c             	sub    $0xc,%esp
  801aa2:	ff 75 08             	pushl  0x8(%ebp)
  801aa5:	e8 2e 0f 00 00       	call   8029d8 <alloc_block_FF>
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ab0:	e9 8a 01 00 00       	jmp    801c3f <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801ab5:	e8 00 0a 00 00       	call   8024ba <sys_isUHeapPlacementStrategyBESTFIT>
  801aba:	85 c0                	test   %eax,%eax
  801abc:	0f 84 7d 01 00 00    	je     801c3f <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801ac2:	83 ec 0c             	sub    $0xc,%esp
  801ac5:	ff 75 08             	pushl  0x8(%ebp)
  801ac8:	e8 c7 13 00 00       	call   802e94 <alloc_block_BF>
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
  801b18:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801b65:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801bbc:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  801c1e:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801c25:	83 ec 08             	sub    $0x8,%esp
  801c28:	ff 75 08             	pushl  0x8(%ebp)
  801c2b:	ff 75 f0             	pushl  -0x10(%ebp)
  801c2e:	e8 09 0a 00 00       	call   80263c <sys_allocate_user_mem>
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
  801c76:	e8 dd 09 00 00       	call   802658 <get_block_size>
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c81:	83 ec 0c             	sub    $0xc,%esp
  801c84:	ff 75 08             	pushl  0x8(%ebp)
  801c87:	e8 10 1c 00 00       	call   80389c <free_block>
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
  801cc1:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
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
  801cfe:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801d05:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801d09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	83 ec 08             	sub    $0x8,%esp
  801d12:	52                   	push   %edx
  801d13:	50                   	push   %eax
  801d14:	e8 07 09 00 00       	call   802620 <sys_free_user_mem>
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
  801d2c:	68 6c 4b 80 00       	push   $0x804b6c
  801d31:	68 88 00 00 00       	push   $0x88
  801d36:	68 96 4b 80 00       	push   $0x804b96
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
  801d5a:	e9 ec 00 00 00       	jmp    801e4b <smalloc+0x108>
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
  801d8b:	75 0a                	jne    801d97 <smalloc+0x54>
  801d8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d92:	e9 b4 00 00 00       	jmp    801e4b <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d97:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d9b:	ff 75 ec             	pushl  -0x14(%ebp)
  801d9e:	50                   	push   %eax
  801d9f:	ff 75 0c             	pushl  0xc(%ebp)
  801da2:	ff 75 08             	pushl  0x8(%ebp)
  801da5:	e8 7d 04 00 00       	call   802227 <sys_createSharedObject>
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801db0:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801db4:	74 06                	je     801dbc <smalloc+0x79>
  801db6:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801dba:	75 0a                	jne    801dc6 <smalloc+0x83>
  801dbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc1:	e9 85 00 00 00       	jmp    801e4b <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801dc6:	83 ec 08             	sub    $0x8,%esp
  801dc9:	ff 75 ec             	pushl  -0x14(%ebp)
  801dcc:	68 a2 4b 80 00       	push   $0x804ba2
  801dd1:	e8 97 ec ff ff       	call   800a6d <cprintf>
  801dd6:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801dd9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ddc:	a1 24 50 80 00       	mov    0x805024,%eax
  801de1:	8b 40 78             	mov    0x78(%eax),%eax
  801de4:	29 c2                	sub    %eax,%edx
  801de6:	89 d0                	mov    %edx,%eax
  801de8:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ded:	c1 e8 0c             	shr    $0xc,%eax
  801df0:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801df6:	42                   	inc    %edx
  801df7:	89 15 28 50 80 00    	mov    %edx,0x805028
  801dfd:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801e03:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801e0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e0d:	a1 24 50 80 00       	mov    0x805024,%eax
  801e12:	8b 40 78             	mov    0x78(%eax),%eax
  801e15:	29 c2                	sub    %eax,%edx
  801e17:	89 d0                	mov    %edx,%eax
  801e19:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e1e:	c1 e8 0c             	shr    $0xc,%eax
  801e21:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801e28:	a1 24 50 80 00       	mov    0x805024,%eax
  801e2d:	8b 50 10             	mov    0x10(%eax),%edx
  801e30:	89 c8                	mov    %ecx,%eax
  801e32:	c1 e0 02             	shl    $0x2,%eax
  801e35:	89 c1                	mov    %eax,%ecx
  801e37:	c1 e1 09             	shl    $0x9,%ecx
  801e3a:	01 c8                	add    %ecx,%eax
  801e3c:	01 c2                	add    %eax,%edx
  801e3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e41:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801e48:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e53:	83 ec 08             	sub    $0x8,%esp
  801e56:	ff 75 0c             	pushl  0xc(%ebp)
  801e59:	ff 75 08             	pushl  0x8(%ebp)
  801e5c:	e8 f0 03 00 00       	call   802251 <sys_getSizeOfSharedObject>
  801e61:	83 c4 10             	add    $0x10,%esp
  801e64:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801e67:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801e6b:	75 0a                	jne    801e77 <sget+0x2a>
  801e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e72:	e9 e7 00 00 00       	jmp    801f5e <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e7d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e84:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8a:	39 d0                	cmp    %edx,%eax
  801e8c:	73 02                	jae    801e90 <sget+0x43>
  801e8e:	89 d0                	mov    %edx,%eax
  801e90:	83 ec 0c             	sub    $0xc,%esp
  801e93:	50                   	push   %eax
  801e94:	e8 8c fb ff ff       	call   801a25 <malloc>
  801e99:	83 c4 10             	add    $0x10,%esp
  801e9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801e9f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ea3:	75 0a                	jne    801eaf <sget+0x62>
  801ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eaa:	e9 af 00 00 00       	jmp    801f5e <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801eaf:	83 ec 04             	sub    $0x4,%esp
  801eb2:	ff 75 e8             	pushl  -0x18(%ebp)
  801eb5:	ff 75 0c             	pushl  0xc(%ebp)
  801eb8:	ff 75 08             	pushl  0x8(%ebp)
  801ebb:	e8 ae 03 00 00       	call   80226e <sys_getSharedObject>
  801ec0:	83 c4 10             	add    $0x10,%esp
  801ec3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801ec6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ec9:	a1 24 50 80 00       	mov    0x805024,%eax
  801ece:	8b 40 78             	mov    0x78(%eax),%eax
  801ed1:	29 c2                	sub    %eax,%edx
  801ed3:	89 d0                	mov    %edx,%eax
  801ed5:	2d 00 10 00 00       	sub    $0x1000,%eax
  801eda:	c1 e8 0c             	shr    $0xc,%eax
  801edd:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801ee3:	42                   	inc    %edx
  801ee4:	89 15 28 50 80 00    	mov    %edx,0x805028
  801eea:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801ef0:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801ef7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801efa:	a1 24 50 80 00       	mov    0x805024,%eax
  801eff:	8b 40 78             	mov    0x78(%eax),%eax
  801f02:	29 c2                	sub    %eax,%edx
  801f04:	89 d0                	mov    %edx,%eax
  801f06:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f0b:	c1 e8 0c             	shr    $0xc,%eax
  801f0e:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801f15:	a1 24 50 80 00       	mov    0x805024,%eax
  801f1a:	8b 50 10             	mov    0x10(%eax),%edx
  801f1d:	89 c8                	mov    %ecx,%eax
  801f1f:	c1 e0 02             	shl    $0x2,%eax
  801f22:	89 c1                	mov    %eax,%ecx
  801f24:	c1 e1 09             	shl    $0x9,%ecx
  801f27:	01 c8                	add    %ecx,%eax
  801f29:	01 c2                	add    %eax,%edx
  801f2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f2e:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801f35:	a1 24 50 80 00       	mov    0x805024,%eax
  801f3a:	8b 40 10             	mov    0x10(%eax),%eax
  801f3d:	83 ec 08             	sub    $0x8,%esp
  801f40:	50                   	push   %eax
  801f41:	68 b1 4b 80 00       	push   $0x804bb1
  801f46:	e8 22 eb ff ff       	call   800a6d <cprintf>
  801f4b:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801f4e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801f52:	75 07                	jne    801f5b <sget+0x10e>
  801f54:	b8 00 00 00 00       	mov    $0x0,%eax
  801f59:	eb 03                	jmp    801f5e <sget+0x111>
	return ptr;
  801f5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801f66:	8b 55 08             	mov    0x8(%ebp),%edx
  801f69:	a1 24 50 80 00       	mov    0x805024,%eax
  801f6e:	8b 40 78             	mov    0x78(%eax),%eax
  801f71:	29 c2                	sub    %eax,%edx
  801f73:	89 d0                	mov    %edx,%eax
  801f75:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f7a:	c1 e8 0c             	shr    $0xc,%eax
  801f7d:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801f84:	a1 24 50 80 00       	mov    0x805024,%eax
  801f89:	8b 50 10             	mov    0x10(%eax),%edx
  801f8c:	89 c8                	mov    %ecx,%eax
  801f8e:	c1 e0 02             	shl    $0x2,%eax
  801f91:	89 c1                	mov    %eax,%ecx
  801f93:	c1 e1 09             	shl    $0x9,%ecx
  801f96:	01 c8                	add    %ecx,%eax
  801f98:	01 d0                	add    %edx,%eax
  801f9a:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801fa4:	83 ec 08             	sub    $0x8,%esp
  801fa7:	ff 75 08             	pushl  0x8(%ebp)
  801faa:	ff 75 f4             	pushl  -0xc(%ebp)
  801fad:	e8 db 02 00 00       	call   80228d <sys_freeSharedObject>
  801fb2:	83 c4 10             	add    $0x10,%esp
  801fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801fb8:	90                   	nop
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fc1:	83 ec 04             	sub    $0x4,%esp
  801fc4:	68 c0 4b 80 00       	push   $0x804bc0
  801fc9:	68 e5 00 00 00       	push   $0xe5
  801fce:	68 96 4b 80 00       	push   $0x804b96
  801fd3:	e8 d8 e7 ff ff       	call   8007b0 <_panic>

00801fd8 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fde:	83 ec 04             	sub    $0x4,%esp
  801fe1:	68 e6 4b 80 00       	push   $0x804be6
  801fe6:	68 f1 00 00 00       	push   $0xf1
  801feb:	68 96 4b 80 00       	push   $0x804b96
  801ff0:	e8 bb e7 ff ff       	call   8007b0 <_panic>

00801ff5 <shrink>:

}
void shrink(uint32 newSize)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ffb:	83 ec 04             	sub    $0x4,%esp
  801ffe:	68 e6 4b 80 00       	push   $0x804be6
  802003:	68 f6 00 00 00       	push   $0xf6
  802008:	68 96 4b 80 00       	push   $0x804b96
  80200d:	e8 9e e7 ff ff       	call   8007b0 <_panic>

00802012 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802018:	83 ec 04             	sub    $0x4,%esp
  80201b:	68 e6 4b 80 00       	push   $0x804be6
  802020:	68 fb 00 00 00       	push   $0xfb
  802025:	68 96 4b 80 00       	push   $0x804b96
  80202a:	e8 81 e7 ff ff       	call   8007b0 <_panic>

0080202f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	57                   	push   %edi
  802033:	56                   	push   %esi
  802034:	53                   	push   %ebx
  802035:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802041:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802044:	8b 7d 18             	mov    0x18(%ebp),%edi
  802047:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80204a:	cd 30                	int    $0x30
  80204c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80204f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802052:	83 c4 10             	add    $0x10,%esp
  802055:	5b                   	pop    %ebx
  802056:	5e                   	pop    %esi
  802057:	5f                   	pop    %edi
  802058:	5d                   	pop    %ebp
  802059:	c3                   	ret    

0080205a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 04             	sub    $0x4,%esp
  802060:	8b 45 10             	mov    0x10(%ebp),%eax
  802063:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802066:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	52                   	push   %edx
  802072:	ff 75 0c             	pushl  0xc(%ebp)
  802075:	50                   	push   %eax
  802076:	6a 00                	push   $0x0
  802078:	e8 b2 ff ff ff       	call   80202f <syscall>
  80207d:	83 c4 18             	add    $0x18,%esp
}
  802080:	90                   	nop
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_cgetc>:

int
sys_cgetc(void)
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 02                	push   $0x2
  802092:	e8 98 ff ff ff       	call   80202f <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
}
  80209a:	c9                   	leave  
  80209b:	c3                   	ret    

0080209c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 03                	push   $0x3
  8020ab:	e8 7f ff ff ff       	call   80202f <syscall>
  8020b0:	83 c4 18             	add    $0x18,%esp
}
  8020b3:	90                   	nop
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 04                	push   $0x4
  8020c5:	e8 65 ff ff ff       	call   80202f <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
}
  8020cd:	90                   	nop
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	52                   	push   %edx
  8020e0:	50                   	push   %eax
  8020e1:	6a 08                	push   $0x8
  8020e3:	e8 47 ff ff ff       	call   80202f <syscall>
  8020e8:	83 c4 18             	add    $0x18,%esp
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	56                   	push   %esi
  8020f1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020f2:	8b 75 18             	mov    0x18(%ebp),%esi
  8020f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	56                   	push   %esi
  802102:	53                   	push   %ebx
  802103:	51                   	push   %ecx
  802104:	52                   	push   %edx
  802105:	50                   	push   %eax
  802106:	6a 09                	push   $0x9
  802108:	e8 22 ff ff ff       	call   80202f <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
}
  802110:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802113:	5b                   	pop    %ebx
  802114:	5e                   	pop    %esi
  802115:	5d                   	pop    %ebp
  802116:	c3                   	ret    

00802117 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80211a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	52                   	push   %edx
  802127:	50                   	push   %eax
  802128:	6a 0a                	push   $0xa
  80212a:	e8 00 ff ff ff       	call   80202f <syscall>
  80212f:	83 c4 18             	add    $0x18,%esp
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	ff 75 0c             	pushl  0xc(%ebp)
  802140:	ff 75 08             	pushl  0x8(%ebp)
  802143:	6a 0b                	push   $0xb
  802145:	e8 e5 fe ff ff       	call   80202f <syscall>
  80214a:	83 c4 18             	add    $0x18,%esp
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 0c                	push   $0xc
  80215e:	e8 cc fe ff ff       	call   80202f <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 0d                	push   $0xd
  802177:	e8 b3 fe ff ff       	call   80202f <syscall>
  80217c:	83 c4 18             	add    $0x18,%esp
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 0e                	push   $0xe
  802190:	e8 9a fe ff ff       	call   80202f <syscall>
  802195:	83 c4 18             	add    $0x18,%esp
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 0f                	push   $0xf
  8021a9:	e8 81 fe ff ff       	call   80202f <syscall>
  8021ae:	83 c4 18             	add    $0x18,%esp
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	ff 75 08             	pushl  0x8(%ebp)
  8021c1:	6a 10                	push   $0x10
  8021c3:	e8 67 fe ff ff       	call   80202f <syscall>
  8021c8:	83 c4 18             	add    $0x18,%esp
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 11                	push   $0x11
  8021dc:	e8 4e fe ff ff       	call   80202f <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
}
  8021e4:	90                   	nop
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <sys_cputc>:

void
sys_cputc(const char c)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
  8021ea:	83 ec 04             	sub    $0x4,%esp
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021f3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	50                   	push   %eax
  802200:	6a 01                	push   $0x1
  802202:	e8 28 fe ff ff       	call   80202f <syscall>
  802207:	83 c4 18             	add    $0x18,%esp
}
  80220a:	90                   	nop
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 14                	push   $0x14
  80221c:	e8 0e fe ff ff       	call   80202f <syscall>
  802221:	83 c4 18             	add    $0x18,%esp
}
  802224:	90                   	nop
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	8b 45 10             	mov    0x10(%ebp),%eax
  802230:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802233:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802236:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	6a 00                	push   $0x0
  80223f:	51                   	push   %ecx
  802240:	52                   	push   %edx
  802241:	ff 75 0c             	pushl  0xc(%ebp)
  802244:	50                   	push   %eax
  802245:	6a 15                	push   $0x15
  802247:	e8 e3 fd ff ff       	call   80202f <syscall>
  80224c:	83 c4 18             	add    $0x18,%esp
}
  80224f:	c9                   	leave  
  802250:	c3                   	ret    

00802251 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802254:	8b 55 0c             	mov    0xc(%ebp),%edx
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	52                   	push   %edx
  802261:	50                   	push   %eax
  802262:	6a 16                	push   $0x16
  802264:	e8 c6 fd ff ff       	call   80202f <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802271:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802274:	8b 55 0c             	mov    0xc(%ebp),%edx
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	51                   	push   %ecx
  80227f:	52                   	push   %edx
  802280:	50                   	push   %eax
  802281:	6a 17                	push   $0x17
  802283:	e8 a7 fd ff ff       	call   80202f <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802290:	8b 55 0c             	mov    0xc(%ebp),%edx
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	52                   	push   %edx
  80229d:	50                   	push   %eax
  80229e:	6a 18                	push   $0x18
  8022a0:	e8 8a fd ff ff       	call   80202f <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	6a 00                	push   $0x0
  8022b2:	ff 75 14             	pushl  0x14(%ebp)
  8022b5:	ff 75 10             	pushl  0x10(%ebp)
  8022b8:	ff 75 0c             	pushl  0xc(%ebp)
  8022bb:	50                   	push   %eax
  8022bc:	6a 19                	push   $0x19
  8022be:	e8 6c fd ff ff       	call   80202f <syscall>
  8022c3:	83 c4 18             	add    $0x18,%esp
}
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	50                   	push   %eax
  8022d7:	6a 1a                	push   $0x1a
  8022d9:	e8 51 fd ff ff       	call   80202f <syscall>
  8022de:	83 c4 18             	add    $0x18,%esp
}
  8022e1:	90                   	nop
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	50                   	push   %eax
  8022f3:	6a 1b                	push   $0x1b
  8022f5:	e8 35 fd ff ff       	call   80202f <syscall>
  8022fa:	83 c4 18             	add    $0x18,%esp
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 05                	push   $0x5
  80230e:	e8 1c fd ff ff       	call   80202f <syscall>
  802313:	83 c4 18             	add    $0x18,%esp
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 06                	push   $0x6
  802327:	e8 03 fd ff ff       	call   80202f <syscall>
  80232c:	83 c4 18             	add    $0x18,%esp
}
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 07                	push   $0x7
  802340:	e8 ea fc ff ff       	call   80202f <syscall>
  802345:	83 c4 18             	add    $0x18,%esp
}
  802348:	c9                   	leave  
  802349:	c3                   	ret    

0080234a <sys_exit_env>:


void sys_exit_env(void)
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 1c                	push   $0x1c
  802359:	e8 d1 fc ff ff       	call   80202f <syscall>
  80235e:	83 c4 18             	add    $0x18,%esp
}
  802361:	90                   	nop
  802362:	c9                   	leave  
  802363:	c3                   	ret    

00802364 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
  802367:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80236a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80236d:	8d 50 04             	lea    0x4(%eax),%edx
  802370:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	52                   	push   %edx
  80237a:	50                   	push   %eax
  80237b:	6a 1d                	push   $0x1d
  80237d:	e8 ad fc ff ff       	call   80202f <syscall>
  802382:	83 c4 18             	add    $0x18,%esp
	return result;
  802385:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802388:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80238b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80238e:	89 01                	mov    %eax,(%ecx)
  802390:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	c9                   	leave  
  802397:	c2 04 00             	ret    $0x4

0080239a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	ff 75 10             	pushl  0x10(%ebp)
  8023a4:	ff 75 0c             	pushl  0xc(%ebp)
  8023a7:	ff 75 08             	pushl  0x8(%ebp)
  8023aa:	6a 13                	push   $0x13
  8023ac:	e8 7e fc ff ff       	call   80202f <syscall>
  8023b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b4:	90                   	nop
}
  8023b5:	c9                   	leave  
  8023b6:	c3                   	ret    

008023b7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 1e                	push   $0x1e
  8023c6:	e8 64 fc ff ff       	call   80202f <syscall>
  8023cb:	83 c4 18             	add    $0x18,%esp
}
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	83 ec 04             	sub    $0x4,%esp
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023dc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	50                   	push   %eax
  8023e9:	6a 1f                	push   $0x1f
  8023eb:	e8 3f fc ff ff       	call   80202f <syscall>
  8023f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f3:	90                   	nop
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <rsttst>:
void rsttst()
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 21                	push   $0x21
  802405:	e8 25 fc ff ff       	call   80202f <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
	return ;
  80240d:	90                   	nop
}
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	83 ec 04             	sub    $0x4,%esp
  802416:	8b 45 14             	mov    0x14(%ebp),%eax
  802419:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80241c:	8b 55 18             	mov    0x18(%ebp),%edx
  80241f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802423:	52                   	push   %edx
  802424:	50                   	push   %eax
  802425:	ff 75 10             	pushl  0x10(%ebp)
  802428:	ff 75 0c             	pushl  0xc(%ebp)
  80242b:	ff 75 08             	pushl  0x8(%ebp)
  80242e:	6a 20                	push   $0x20
  802430:	e8 fa fb ff ff       	call   80202f <syscall>
  802435:	83 c4 18             	add    $0x18,%esp
	return ;
  802438:	90                   	nop
}
  802439:	c9                   	leave  
  80243a:	c3                   	ret    

0080243b <chktst>:
void chktst(uint32 n)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	ff 75 08             	pushl  0x8(%ebp)
  802449:	6a 22                	push   $0x22
  80244b:	e8 df fb ff ff       	call   80202f <syscall>
  802450:	83 c4 18             	add    $0x18,%esp
	return ;
  802453:	90                   	nop
}
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <inctst>:

void inctst()
{
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 23                	push   $0x23
  802465:	e8 c5 fb ff ff       	call   80202f <syscall>
  80246a:	83 c4 18             	add    $0x18,%esp
	return ;
  80246d:	90                   	nop
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <gettst>:
uint32 gettst()
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 24                	push   $0x24
  80247f:	e8 ab fb ff ff       	call   80202f <syscall>
  802484:	83 c4 18             	add    $0x18,%esp
}
  802487:	c9                   	leave  
  802488:	c3                   	ret    

00802489 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
  80248c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 25                	push   $0x25
  80249b:	e8 8f fb ff ff       	call   80202f <syscall>
  8024a0:	83 c4 18             	add    $0x18,%esp
  8024a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024a6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024aa:	75 07                	jne    8024b3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b1:	eb 05                	jmp    8024b8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 25                	push   $0x25
  8024cc:	e8 5e fb ff ff       	call   80202f <syscall>
  8024d1:	83 c4 18             	add    $0x18,%esp
  8024d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024d7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024db:	75 07                	jne    8024e4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e2:	eb 05                	jmp    8024e9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 25                	push   $0x25
  8024fd:	e8 2d fb ff ff       	call   80202f <syscall>
  802502:	83 c4 18             	add    $0x18,%esp
  802505:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802508:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80250c:	75 07                	jne    802515 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80250e:	b8 01 00 00 00       	mov    $0x1,%eax
  802513:	eb 05                	jmp    80251a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802515:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80251a:	c9                   	leave  
  80251b:	c3                   	ret    

0080251c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80251c:	55                   	push   %ebp
  80251d:	89 e5                	mov    %esp,%ebp
  80251f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 25                	push   $0x25
  80252e:	e8 fc fa ff ff       	call   80202f <syscall>
  802533:	83 c4 18             	add    $0x18,%esp
  802536:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802539:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80253d:	75 07                	jne    802546 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80253f:	b8 01 00 00 00       	mov    $0x1,%eax
  802544:	eb 05                	jmp    80254b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802546:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80254b:	c9                   	leave  
  80254c:	c3                   	ret    

0080254d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	ff 75 08             	pushl  0x8(%ebp)
  80255b:	6a 26                	push   $0x26
  80255d:	e8 cd fa ff ff       	call   80202f <syscall>
  802562:	83 c4 18             	add    $0x18,%esp
	return ;
  802565:	90                   	nop
}
  802566:	c9                   	leave  
  802567:	c3                   	ret    

00802568 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802568:	55                   	push   %ebp
  802569:	89 e5                	mov    %esp,%ebp
  80256b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80256c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80256f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802572:	8b 55 0c             	mov    0xc(%ebp),%edx
  802575:	8b 45 08             	mov    0x8(%ebp),%eax
  802578:	6a 00                	push   $0x0
  80257a:	53                   	push   %ebx
  80257b:	51                   	push   %ecx
  80257c:	52                   	push   %edx
  80257d:	50                   	push   %eax
  80257e:	6a 27                	push   $0x27
  802580:	e8 aa fa ff ff       	call   80202f <syscall>
  802585:	83 c4 18             	add    $0x18,%esp
}
  802588:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802590:	8b 55 0c             	mov    0xc(%ebp),%edx
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	52                   	push   %edx
  80259d:	50                   	push   %eax
  80259e:	6a 28                	push   $0x28
  8025a0:	e8 8a fa ff ff       	call   80202f <syscall>
  8025a5:	83 c4 18             	add    $0x18,%esp
}
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    

008025aa <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8025ad:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	6a 00                	push   $0x0
  8025b8:	51                   	push   %ecx
  8025b9:	ff 75 10             	pushl  0x10(%ebp)
  8025bc:	52                   	push   %edx
  8025bd:	50                   	push   %eax
  8025be:	6a 29                	push   $0x29
  8025c0:	e8 6a fa ff ff       	call   80202f <syscall>
  8025c5:	83 c4 18             	add    $0x18,%esp
}
  8025c8:	c9                   	leave  
  8025c9:	c3                   	ret    

008025ca <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8025ca:	55                   	push   %ebp
  8025cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	ff 75 10             	pushl  0x10(%ebp)
  8025d4:	ff 75 0c             	pushl  0xc(%ebp)
  8025d7:	ff 75 08             	pushl  0x8(%ebp)
  8025da:	6a 12                	push   $0x12
  8025dc:	e8 4e fa ff ff       	call   80202f <syscall>
  8025e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8025e4:	90                   	nop
}
  8025e5:	c9                   	leave  
  8025e6:	c3                   	ret    

008025e7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8025ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	52                   	push   %edx
  8025f7:	50                   	push   %eax
  8025f8:	6a 2a                	push   $0x2a
  8025fa:	e8 30 fa ff ff       	call   80202f <syscall>
  8025ff:	83 c4 18             	add    $0x18,%esp
	return;
  802602:	90                   	nop
}
  802603:	c9                   	leave  
  802604:	c3                   	ret    

00802605 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802608:	8b 45 08             	mov    0x8(%ebp),%eax
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	50                   	push   %eax
  802614:	6a 2b                	push   $0x2b
  802616:	e8 14 fa ff ff       	call   80202f <syscall>
  80261b:	83 c4 18             	add    $0x18,%esp
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	ff 75 0c             	pushl  0xc(%ebp)
  80262c:	ff 75 08             	pushl  0x8(%ebp)
  80262f:	6a 2c                	push   $0x2c
  802631:	e8 f9 f9 ff ff       	call   80202f <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
	return;
  802639:	90                   	nop
}
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    

0080263c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80263f:	6a 00                	push   $0x0
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	ff 75 0c             	pushl  0xc(%ebp)
  802648:	ff 75 08             	pushl  0x8(%ebp)
  80264b:	6a 2d                	push   $0x2d
  80264d:	e8 dd f9 ff ff       	call   80202f <syscall>
  802652:	83 c4 18             	add    $0x18,%esp
	return;
  802655:	90                   	nop
}
  802656:	c9                   	leave  
  802657:	c3                   	ret    

00802658 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802658:	55                   	push   %ebp
  802659:	89 e5                	mov    %esp,%ebp
  80265b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80265e:	8b 45 08             	mov    0x8(%ebp),%eax
  802661:	83 e8 04             	sub    $0x4,%eax
  802664:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802667:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80266f:	c9                   	leave  
  802670:	c3                   	ret    

00802671 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
  802674:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802677:	8b 45 08             	mov    0x8(%ebp),%eax
  80267a:	83 e8 04             	sub    $0x4,%eax
  80267d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802680:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802683:	8b 00                	mov    (%eax),%eax
  802685:	83 e0 01             	and    $0x1,%eax
  802688:	85 c0                	test   %eax,%eax
  80268a:	0f 94 c0             	sete   %al
}
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
  802692:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802695:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80269c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80269f:	83 f8 02             	cmp    $0x2,%eax
  8026a2:	74 2b                	je     8026cf <alloc_block+0x40>
  8026a4:	83 f8 02             	cmp    $0x2,%eax
  8026a7:	7f 07                	jg     8026b0 <alloc_block+0x21>
  8026a9:	83 f8 01             	cmp    $0x1,%eax
  8026ac:	74 0e                	je     8026bc <alloc_block+0x2d>
  8026ae:	eb 58                	jmp    802708 <alloc_block+0x79>
  8026b0:	83 f8 03             	cmp    $0x3,%eax
  8026b3:	74 2d                	je     8026e2 <alloc_block+0x53>
  8026b5:	83 f8 04             	cmp    $0x4,%eax
  8026b8:	74 3b                	je     8026f5 <alloc_block+0x66>
  8026ba:	eb 4c                	jmp    802708 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8026bc:	83 ec 0c             	sub    $0xc,%esp
  8026bf:	ff 75 08             	pushl  0x8(%ebp)
  8026c2:	e8 11 03 00 00       	call   8029d8 <alloc_block_FF>
  8026c7:	83 c4 10             	add    $0x10,%esp
  8026ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026cd:	eb 4a                	jmp    802719 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8026cf:	83 ec 0c             	sub    $0xc,%esp
  8026d2:	ff 75 08             	pushl  0x8(%ebp)
  8026d5:	e8 fa 19 00 00       	call   8040d4 <alloc_block_NF>
  8026da:	83 c4 10             	add    $0x10,%esp
  8026dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026e0:	eb 37                	jmp    802719 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8026e2:	83 ec 0c             	sub    $0xc,%esp
  8026e5:	ff 75 08             	pushl  0x8(%ebp)
  8026e8:	e8 a7 07 00 00       	call   802e94 <alloc_block_BF>
  8026ed:	83 c4 10             	add    $0x10,%esp
  8026f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026f3:	eb 24                	jmp    802719 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8026f5:	83 ec 0c             	sub    $0xc,%esp
  8026f8:	ff 75 08             	pushl  0x8(%ebp)
  8026fb:	e8 b7 19 00 00       	call   8040b7 <alloc_block_WF>
  802700:	83 c4 10             	add    $0x10,%esp
  802703:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802706:	eb 11                	jmp    802719 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802708:	83 ec 0c             	sub    $0xc,%esp
  80270b:	68 f8 4b 80 00       	push   $0x804bf8
  802710:	e8 58 e3 ff ff       	call   800a6d <cprintf>
  802715:	83 c4 10             	add    $0x10,%esp
		break;
  802718:	90                   	nop
	}
	return va;
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80271c:	c9                   	leave  
  80271d:	c3                   	ret    

0080271e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
  802721:	53                   	push   %ebx
  802722:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802725:	83 ec 0c             	sub    $0xc,%esp
  802728:	68 18 4c 80 00       	push   $0x804c18
  80272d:	e8 3b e3 ff ff       	call   800a6d <cprintf>
  802732:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802735:	83 ec 0c             	sub    $0xc,%esp
  802738:	68 43 4c 80 00       	push   $0x804c43
  80273d:	e8 2b e3 ff ff       	call   800a6d <cprintf>
  802742:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802745:	8b 45 08             	mov    0x8(%ebp),%eax
  802748:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274b:	eb 37                	jmp    802784 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80274d:	83 ec 0c             	sub    $0xc,%esp
  802750:	ff 75 f4             	pushl  -0xc(%ebp)
  802753:	e8 19 ff ff ff       	call   802671 <is_free_block>
  802758:	83 c4 10             	add    $0x10,%esp
  80275b:	0f be d8             	movsbl %al,%ebx
  80275e:	83 ec 0c             	sub    $0xc,%esp
  802761:	ff 75 f4             	pushl  -0xc(%ebp)
  802764:	e8 ef fe ff ff       	call   802658 <get_block_size>
  802769:	83 c4 10             	add    $0x10,%esp
  80276c:	83 ec 04             	sub    $0x4,%esp
  80276f:	53                   	push   %ebx
  802770:	50                   	push   %eax
  802771:	68 5b 4c 80 00       	push   $0x804c5b
  802776:	e8 f2 e2 ff ff       	call   800a6d <cprintf>
  80277b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80277e:	8b 45 10             	mov    0x10(%ebp),%eax
  802781:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802788:	74 07                	je     802791 <print_blocks_list+0x73>
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	eb 05                	jmp    802796 <print_blocks_list+0x78>
  802791:	b8 00 00 00 00       	mov    $0x0,%eax
  802796:	89 45 10             	mov    %eax,0x10(%ebp)
  802799:	8b 45 10             	mov    0x10(%ebp),%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	75 ad                	jne    80274d <print_blocks_list+0x2f>
  8027a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a4:	75 a7                	jne    80274d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8027a6:	83 ec 0c             	sub    $0xc,%esp
  8027a9:	68 18 4c 80 00       	push   $0x804c18
  8027ae:	e8 ba e2 ff ff       	call   800a6d <cprintf>
  8027b3:	83 c4 10             	add    $0x10,%esp

}
  8027b6:	90                   	nop
  8027b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027ba:	c9                   	leave  
  8027bb:	c3                   	ret    

008027bc <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
  8027bf:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8027c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c5:	83 e0 01             	and    $0x1,%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	74 03                	je     8027cf <initialize_dynamic_allocator+0x13>
  8027cc:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8027cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027d3:	0f 84 c7 01 00 00    	je     8029a0 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8027d9:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  8027e0:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8027e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027e9:	01 d0                	add    %edx,%eax
  8027eb:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8027f0:	0f 87 ad 01 00 00    	ja     8029a3 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	0f 89 a5 01 00 00    	jns    8029a6 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802801:	8b 55 08             	mov    0x8(%ebp),%edx
  802804:	8b 45 0c             	mov    0xc(%ebp),%eax
  802807:	01 d0                	add    %edx,%eax
  802809:	83 e8 04             	sub    $0x4,%eax
  80280c:	a3 50 50 80 00       	mov    %eax,0x805050
     struct BlockElement * element = NULL;
  802811:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802818:	a1 34 50 80 00       	mov    0x805034,%eax
  80281d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802820:	e9 87 00 00 00       	jmp    8028ac <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802825:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802829:	75 14                	jne    80283f <initialize_dynamic_allocator+0x83>
  80282b:	83 ec 04             	sub    $0x4,%esp
  80282e:	68 73 4c 80 00       	push   $0x804c73
  802833:	6a 79                	push   $0x79
  802835:	68 91 4c 80 00       	push   $0x804c91
  80283a:	e8 71 df ff ff       	call   8007b0 <_panic>
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	85 c0                	test   %eax,%eax
  802846:	74 10                	je     802858 <initialize_dynamic_allocator+0x9c>
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802850:	8b 52 04             	mov    0x4(%edx),%edx
  802853:	89 50 04             	mov    %edx,0x4(%eax)
  802856:	eb 0b                	jmp    802863 <initialize_dynamic_allocator+0xa7>
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 40 04             	mov    0x4(%eax),%eax
  80285e:	a3 38 50 80 00       	mov    %eax,0x805038
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 40 04             	mov    0x4(%eax),%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	74 0f                	je     80287c <initialize_dynamic_allocator+0xc0>
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 40 04             	mov    0x4(%eax),%eax
  802873:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802876:	8b 12                	mov    (%edx),%edx
  802878:	89 10                	mov    %edx,(%eax)
  80287a:	eb 0a                	jmp    802886 <initialize_dynamic_allocator+0xca>
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 00                	mov    (%eax),%eax
  802881:	a3 34 50 80 00       	mov    %eax,0x805034
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802899:	a1 40 50 80 00       	mov    0x805040,%eax
  80289e:	48                   	dec    %eax
  80289f:	a3 40 50 80 00       	mov    %eax,0x805040
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8028a4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8028a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b0:	74 07                	je     8028b9 <initialize_dynamic_allocator+0xfd>
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 00                	mov    (%eax),%eax
  8028b7:	eb 05                	jmp    8028be <initialize_dynamic_allocator+0x102>
  8028b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028be:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8028c3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8028c8:	85 c0                	test   %eax,%eax
  8028ca:	0f 85 55 ff ff ff    	jne    802825 <initialize_dynamic_allocator+0x69>
  8028d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d4:	0f 85 4b ff ff ff    	jne    802825 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8028da:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8028e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8028e9:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ee:	a3 4c 50 80 00       	mov    %eax,0x80504c
    end_block->info = 1;
  8028f3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028f8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8028fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802901:	83 c0 08             	add    $0x8,%eax
  802904:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	83 c0 04             	add    $0x4,%eax
  80290d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802910:	83 ea 08             	sub    $0x8,%edx
  802913:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802915:	8b 55 0c             	mov    0xc(%ebp),%edx
  802918:	8b 45 08             	mov    0x8(%ebp),%eax
  80291b:	01 d0                	add    %edx,%eax
  80291d:	83 e8 08             	sub    $0x8,%eax
  802920:	8b 55 0c             	mov    0xc(%ebp),%edx
  802923:	83 ea 08             	sub    $0x8,%edx
  802926:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802931:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802934:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80293b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80293f:	75 17                	jne    802958 <initialize_dynamic_allocator+0x19c>
  802941:	83 ec 04             	sub    $0x4,%esp
  802944:	68 ac 4c 80 00       	push   $0x804cac
  802949:	68 90 00 00 00       	push   $0x90
  80294e:	68 91 4c 80 00       	push   $0x804c91
  802953:	e8 58 de ff ff       	call   8007b0 <_panic>
  802958:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80295e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802961:	89 10                	mov    %edx,(%eax)
  802963:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802966:	8b 00                	mov    (%eax),%eax
  802968:	85 c0                	test   %eax,%eax
  80296a:	74 0d                	je     802979 <initialize_dynamic_allocator+0x1bd>
  80296c:	a1 34 50 80 00       	mov    0x805034,%eax
  802971:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802974:	89 50 04             	mov    %edx,0x4(%eax)
  802977:	eb 08                	jmp    802981 <initialize_dynamic_allocator+0x1c5>
  802979:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297c:	a3 38 50 80 00       	mov    %eax,0x805038
  802981:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802984:	a3 34 50 80 00       	mov    %eax,0x805034
  802989:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802993:	a1 40 50 80 00       	mov    0x805040,%eax
  802998:	40                   	inc    %eax
  802999:	a3 40 50 80 00       	mov    %eax,0x805040
  80299e:	eb 07                	jmp    8029a7 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8029a0:	90                   	nop
  8029a1:	eb 04                	jmp    8029a7 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8029a3:	90                   	nop
  8029a4:	eb 01                	jmp    8029a7 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8029a6:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8029a7:	c9                   	leave  
  8029a8:	c3                   	ret    

008029a9 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8029a9:	55                   	push   %ebp
  8029aa:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8029ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8029af:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8029b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029bb:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c0:	83 e8 04             	sub    $0x4,%eax
  8029c3:	8b 00                	mov    (%eax),%eax
  8029c5:	83 e0 fe             	and    $0xfffffffe,%eax
  8029c8:	8d 50 f8             	lea    -0x8(%eax),%edx
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	01 c2                	add    %eax,%edx
  8029d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029d3:	89 02                	mov    %eax,(%edx)
}
  8029d5:	90                   	nop
  8029d6:	5d                   	pop    %ebp
  8029d7:	c3                   	ret    

008029d8 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8029d8:	55                   	push   %ebp
  8029d9:	89 e5                	mov    %esp,%ebp
  8029db:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8029de:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e1:	83 e0 01             	and    $0x1,%eax
  8029e4:	85 c0                	test   %eax,%eax
  8029e6:	74 03                	je     8029eb <alloc_block_FF+0x13>
  8029e8:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8029eb:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8029ef:	77 07                	ja     8029f8 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8029f1:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8029f8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029fd:	85 c0                	test   %eax,%eax
  8029ff:	75 73                	jne    802a74 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	83 c0 10             	add    $0x10,%eax
  802a07:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a0a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a17:	01 d0                	add    %edx,%eax
  802a19:	48                   	dec    %eax
  802a1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a20:	ba 00 00 00 00       	mov    $0x0,%edx
  802a25:	f7 75 ec             	divl   -0x14(%ebp)
  802a28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2b:	29 d0                	sub    %edx,%eax
  802a2d:	c1 e8 0c             	shr    $0xc,%eax
  802a30:	83 ec 0c             	sub    $0xc,%esp
  802a33:	50                   	push   %eax
  802a34:	e8 d6 ef ff ff       	call   801a0f <sbrk>
  802a39:	83 c4 10             	add    $0x10,%esp
  802a3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a3f:	83 ec 0c             	sub    $0xc,%esp
  802a42:	6a 00                	push   $0x0
  802a44:	e8 c6 ef ff ff       	call   801a0f <sbrk>
  802a49:	83 c4 10             	add    $0x10,%esp
  802a4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a52:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802a55:	83 ec 08             	sub    $0x8,%esp
  802a58:	50                   	push   %eax
  802a59:	ff 75 e4             	pushl  -0x1c(%ebp)
  802a5c:	e8 5b fd ff ff       	call   8027bc <initialize_dynamic_allocator>
  802a61:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802a64:	83 ec 0c             	sub    $0xc,%esp
  802a67:	68 cf 4c 80 00       	push   $0x804ccf
  802a6c:	e8 fc df ff ff       	call   800a6d <cprintf>
  802a71:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802a74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a78:	75 0a                	jne    802a84 <alloc_block_FF+0xac>
	        return NULL;
  802a7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7f:	e9 0e 04 00 00       	jmp    802e92 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802a84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a8b:	a1 34 50 80 00       	mov    0x805034,%eax
  802a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a93:	e9 f3 02 00 00       	jmp    802d8b <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802a9e:	83 ec 0c             	sub    $0xc,%esp
  802aa1:	ff 75 bc             	pushl  -0x44(%ebp)
  802aa4:	e8 af fb ff ff       	call   802658 <get_block_size>
  802aa9:	83 c4 10             	add    $0x10,%esp
  802aac:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab2:	83 c0 08             	add    $0x8,%eax
  802ab5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802ab8:	0f 87 c5 02 00 00    	ja     802d83 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	83 c0 18             	add    $0x18,%eax
  802ac4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802ac7:	0f 87 19 02 00 00    	ja     802ce6 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802acd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ad0:	2b 45 08             	sub    0x8(%ebp),%eax
  802ad3:	83 e8 08             	sub    $0x8,%eax
  802ad6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	8d 50 08             	lea    0x8(%eax),%edx
  802adf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ae2:	01 d0                	add    %edx,%eax
  802ae4:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	83 c0 08             	add    $0x8,%eax
  802aed:	83 ec 04             	sub    $0x4,%esp
  802af0:	6a 01                	push   $0x1
  802af2:	50                   	push   %eax
  802af3:	ff 75 bc             	pushl  -0x44(%ebp)
  802af6:	e8 ae fe ff ff       	call   8029a9 <set_block_data>
  802afb:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 40 04             	mov    0x4(%eax),%eax
  802b04:	85 c0                	test   %eax,%eax
  802b06:	75 68                	jne    802b70 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b08:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b0c:	75 17                	jne    802b25 <alloc_block_FF+0x14d>
  802b0e:	83 ec 04             	sub    $0x4,%esp
  802b11:	68 ac 4c 80 00       	push   $0x804cac
  802b16:	68 d7 00 00 00       	push   $0xd7
  802b1b:	68 91 4c 80 00       	push   $0x804c91
  802b20:	e8 8b dc ff ff       	call   8007b0 <_panic>
  802b25:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802b2b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b2e:	89 10                	mov    %edx,(%eax)
  802b30:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b33:	8b 00                	mov    (%eax),%eax
  802b35:	85 c0                	test   %eax,%eax
  802b37:	74 0d                	je     802b46 <alloc_block_FF+0x16e>
  802b39:	a1 34 50 80 00       	mov    0x805034,%eax
  802b3e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b41:	89 50 04             	mov    %edx,0x4(%eax)
  802b44:	eb 08                	jmp    802b4e <alloc_block_FF+0x176>
  802b46:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b49:	a3 38 50 80 00       	mov    %eax,0x805038
  802b4e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b51:	a3 34 50 80 00       	mov    %eax,0x805034
  802b56:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b60:	a1 40 50 80 00       	mov    0x805040,%eax
  802b65:	40                   	inc    %eax
  802b66:	a3 40 50 80 00       	mov    %eax,0x805040
  802b6b:	e9 dc 00 00 00       	jmp    802c4c <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 00                	mov    (%eax),%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	75 65                	jne    802bde <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b79:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b7d:	75 17                	jne    802b96 <alloc_block_FF+0x1be>
  802b7f:	83 ec 04             	sub    $0x4,%esp
  802b82:	68 e0 4c 80 00       	push   $0x804ce0
  802b87:	68 db 00 00 00       	push   $0xdb
  802b8c:	68 91 4c 80 00       	push   $0x804c91
  802b91:	e8 1a dc ff ff       	call   8007b0 <_panic>
  802b96:	8b 15 38 50 80 00    	mov    0x805038,%edx
  802b9c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ba2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba5:	8b 40 04             	mov    0x4(%eax),%eax
  802ba8:	85 c0                	test   %eax,%eax
  802baa:	74 0c                	je     802bb8 <alloc_block_FF+0x1e0>
  802bac:	a1 38 50 80 00       	mov    0x805038,%eax
  802bb1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bb4:	89 10                	mov    %edx,(%eax)
  802bb6:	eb 08                	jmp    802bc0 <alloc_block_FF+0x1e8>
  802bb8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bbb:	a3 34 50 80 00       	mov    %eax,0x805034
  802bc0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc3:	a3 38 50 80 00       	mov    %eax,0x805038
  802bc8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd1:	a1 40 50 80 00       	mov    0x805040,%eax
  802bd6:	40                   	inc    %eax
  802bd7:	a3 40 50 80 00       	mov    %eax,0x805040
  802bdc:	eb 6e                	jmp    802c4c <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802bde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be2:	74 06                	je     802bea <alloc_block_FF+0x212>
  802be4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802be8:	75 17                	jne    802c01 <alloc_block_FF+0x229>
  802bea:	83 ec 04             	sub    $0x4,%esp
  802bed:	68 04 4d 80 00       	push   $0x804d04
  802bf2:	68 df 00 00 00       	push   $0xdf
  802bf7:	68 91 4c 80 00       	push   $0x804c91
  802bfc:	e8 af db ff ff       	call   8007b0 <_panic>
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	8b 10                	mov    (%eax),%edx
  802c06:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c09:	89 10                	mov    %edx,(%eax)
  802c0b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	85 c0                	test   %eax,%eax
  802c12:	74 0b                	je     802c1f <alloc_block_FF+0x247>
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 00                	mov    (%eax),%eax
  802c19:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c1c:	89 50 04             	mov    %edx,0x4(%eax)
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c25:	89 10                	mov    %edx,(%eax)
  802c27:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c2d:	89 50 04             	mov    %edx,0x4(%eax)
  802c30:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c33:	8b 00                	mov    (%eax),%eax
  802c35:	85 c0                	test   %eax,%eax
  802c37:	75 08                	jne    802c41 <alloc_block_FF+0x269>
  802c39:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c3c:	a3 38 50 80 00       	mov    %eax,0x805038
  802c41:	a1 40 50 80 00       	mov    0x805040,%eax
  802c46:	40                   	inc    %eax
  802c47:	a3 40 50 80 00       	mov    %eax,0x805040
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802c4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c50:	75 17                	jne    802c69 <alloc_block_FF+0x291>
  802c52:	83 ec 04             	sub    $0x4,%esp
  802c55:	68 73 4c 80 00       	push   $0x804c73
  802c5a:	68 e1 00 00 00       	push   $0xe1
  802c5f:	68 91 4c 80 00       	push   $0x804c91
  802c64:	e8 47 db ff ff       	call   8007b0 <_panic>
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	85 c0                	test   %eax,%eax
  802c70:	74 10                	je     802c82 <alloc_block_FF+0x2aa>
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7a:	8b 52 04             	mov    0x4(%edx),%edx
  802c7d:	89 50 04             	mov    %edx,0x4(%eax)
  802c80:	eb 0b                	jmp    802c8d <alloc_block_FF+0x2b5>
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	8b 40 04             	mov    0x4(%eax),%eax
  802c88:	a3 38 50 80 00       	mov    %eax,0x805038
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 40 04             	mov    0x4(%eax),%eax
  802c93:	85 c0                	test   %eax,%eax
  802c95:	74 0f                	je     802ca6 <alloc_block_FF+0x2ce>
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 40 04             	mov    0x4(%eax),%eax
  802c9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca0:	8b 12                	mov    (%edx),%edx
  802ca2:	89 10                	mov    %edx,(%eax)
  802ca4:	eb 0a                	jmp    802cb0 <alloc_block_FF+0x2d8>
  802ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca9:	8b 00                	mov    (%eax),%eax
  802cab:	a3 34 50 80 00       	mov    %eax,0x805034
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc3:	a1 40 50 80 00       	mov    0x805040,%eax
  802cc8:	48                   	dec    %eax
  802cc9:	a3 40 50 80 00       	mov    %eax,0x805040
				set_block_data(new_block_va, remaining_size, 0);
  802cce:	83 ec 04             	sub    $0x4,%esp
  802cd1:	6a 00                	push   $0x0
  802cd3:	ff 75 b4             	pushl  -0x4c(%ebp)
  802cd6:	ff 75 b0             	pushl  -0x50(%ebp)
  802cd9:	e8 cb fc ff ff       	call   8029a9 <set_block_data>
  802cde:	83 c4 10             	add    $0x10,%esp
  802ce1:	e9 95 00 00 00       	jmp    802d7b <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802ce6:	83 ec 04             	sub    $0x4,%esp
  802ce9:	6a 01                	push   $0x1
  802ceb:	ff 75 b8             	pushl  -0x48(%ebp)
  802cee:	ff 75 bc             	pushl  -0x44(%ebp)
  802cf1:	e8 b3 fc ff ff       	call   8029a9 <set_block_data>
  802cf6:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802cf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfd:	75 17                	jne    802d16 <alloc_block_FF+0x33e>
  802cff:	83 ec 04             	sub    $0x4,%esp
  802d02:	68 73 4c 80 00       	push   $0x804c73
  802d07:	68 e8 00 00 00       	push   $0xe8
  802d0c:	68 91 4c 80 00       	push   $0x804c91
  802d11:	e8 9a da ff ff       	call   8007b0 <_panic>
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	85 c0                	test   %eax,%eax
  802d1d:	74 10                	je     802d2f <alloc_block_FF+0x357>
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d27:	8b 52 04             	mov    0x4(%edx),%edx
  802d2a:	89 50 04             	mov    %edx,0x4(%eax)
  802d2d:	eb 0b                	jmp    802d3a <alloc_block_FF+0x362>
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	8b 40 04             	mov    0x4(%eax),%eax
  802d35:	a3 38 50 80 00       	mov    %eax,0x805038
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 40 04             	mov    0x4(%eax),%eax
  802d40:	85 c0                	test   %eax,%eax
  802d42:	74 0f                	je     802d53 <alloc_block_FF+0x37b>
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	8b 40 04             	mov    0x4(%eax),%eax
  802d4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d4d:	8b 12                	mov    (%edx),%edx
  802d4f:	89 10                	mov    %edx,(%eax)
  802d51:	eb 0a                	jmp    802d5d <alloc_block_FF+0x385>
  802d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	a3 34 50 80 00       	mov    %eax,0x805034
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d70:	a1 40 50 80 00       	mov    0x805040,%eax
  802d75:	48                   	dec    %eax
  802d76:	a3 40 50 80 00       	mov    %eax,0x805040
	            }
	            return va;
  802d7b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d7e:	e9 0f 01 00 00       	jmp    802e92 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802d83:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8f:	74 07                	je     802d98 <alloc_block_FF+0x3c0>
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	eb 05                	jmp    802d9d <alloc_block_FF+0x3c5>
  802d98:	b8 00 00 00 00       	mov    $0x0,%eax
  802d9d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802da2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	0f 85 e9 fc ff ff    	jne    802a98 <alloc_block_FF+0xc0>
  802daf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db3:	0f 85 df fc ff ff    	jne    802a98 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	83 c0 08             	add    $0x8,%eax
  802dbf:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802dc2:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802dc9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dcc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dcf:	01 d0                	add    %edx,%eax
  802dd1:	48                   	dec    %eax
  802dd2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802dd5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dd8:	ba 00 00 00 00       	mov    $0x0,%edx
  802ddd:	f7 75 d8             	divl   -0x28(%ebp)
  802de0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802de3:	29 d0                	sub    %edx,%eax
  802de5:	c1 e8 0c             	shr    $0xc,%eax
  802de8:	83 ec 0c             	sub    $0xc,%esp
  802deb:	50                   	push   %eax
  802dec:	e8 1e ec ff ff       	call   801a0f <sbrk>
  802df1:	83 c4 10             	add    $0x10,%esp
  802df4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802df7:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802dfb:	75 0a                	jne    802e07 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  802e02:	e9 8b 00 00 00       	jmp    802e92 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e07:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802e0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e14:	01 d0                	add    %edx,%eax
  802e16:	48                   	dec    %eax
  802e17:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802e1a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e1d:	ba 00 00 00 00       	mov    $0x0,%edx
  802e22:	f7 75 cc             	divl   -0x34(%ebp)
  802e25:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e28:	29 d0                	sub    %edx,%eax
  802e2a:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e2d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e30:	01 d0                	add    %edx,%eax
  802e32:	a3 4c 50 80 00       	mov    %eax,0x80504c
			end_block->info = 1;
  802e37:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e3c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e42:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e49:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e4c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e4f:	01 d0                	add    %edx,%eax
  802e51:	48                   	dec    %eax
  802e52:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e55:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e58:	ba 00 00 00 00       	mov    $0x0,%edx
  802e5d:	f7 75 c4             	divl   -0x3c(%ebp)
  802e60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e63:	29 d0                	sub    %edx,%eax
  802e65:	83 ec 04             	sub    $0x4,%esp
  802e68:	6a 01                	push   $0x1
  802e6a:	50                   	push   %eax
  802e6b:	ff 75 d0             	pushl  -0x30(%ebp)
  802e6e:	e8 36 fb ff ff       	call   8029a9 <set_block_data>
  802e73:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802e76:	83 ec 0c             	sub    $0xc,%esp
  802e79:	ff 75 d0             	pushl  -0x30(%ebp)
  802e7c:	e8 1b 0a 00 00       	call   80389c <free_block>
  802e81:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802e84:	83 ec 0c             	sub    $0xc,%esp
  802e87:	ff 75 08             	pushl  0x8(%ebp)
  802e8a:	e8 49 fb ff ff       	call   8029d8 <alloc_block_FF>
  802e8f:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802e92:	c9                   	leave  
  802e93:	c3                   	ret    

00802e94 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e94:	55                   	push   %ebp
  802e95:	89 e5                	mov    %esp,%ebp
  802e97:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9d:	83 e0 01             	and    $0x1,%eax
  802ea0:	85 c0                	test   %eax,%eax
  802ea2:	74 03                	je     802ea7 <alloc_block_BF+0x13>
  802ea4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802ea7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802eab:	77 07                	ja     802eb4 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802ead:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802eb4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802eb9:	85 c0                	test   %eax,%eax
  802ebb:	75 73                	jne    802f30 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	83 c0 10             	add    $0x10,%eax
  802ec3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802ec6:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802ecd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed3:	01 d0                	add    %edx,%eax
  802ed5:	48                   	dec    %eax
  802ed6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ed9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802edc:	ba 00 00 00 00       	mov    $0x0,%edx
  802ee1:	f7 75 e0             	divl   -0x20(%ebp)
  802ee4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee7:	29 d0                	sub    %edx,%eax
  802ee9:	c1 e8 0c             	shr    $0xc,%eax
  802eec:	83 ec 0c             	sub    $0xc,%esp
  802eef:	50                   	push   %eax
  802ef0:	e8 1a eb ff ff       	call   801a0f <sbrk>
  802ef5:	83 c4 10             	add    $0x10,%esp
  802ef8:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802efb:	83 ec 0c             	sub    $0xc,%esp
  802efe:	6a 00                	push   $0x0
  802f00:	e8 0a eb ff ff       	call   801a0f <sbrk>
  802f05:	83 c4 10             	add    $0x10,%esp
  802f08:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802f0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f0e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802f11:	83 ec 08             	sub    $0x8,%esp
  802f14:	50                   	push   %eax
  802f15:	ff 75 d8             	pushl  -0x28(%ebp)
  802f18:	e8 9f f8 ff ff       	call   8027bc <initialize_dynamic_allocator>
  802f1d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802f20:	83 ec 0c             	sub    $0xc,%esp
  802f23:	68 cf 4c 80 00       	push   $0x804ccf
  802f28:	e8 40 db ff ff       	call   800a6d <cprintf>
  802f2d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802f30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802f37:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802f3e:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802f45:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802f4c:	a1 34 50 80 00       	mov    0x805034,%eax
  802f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f54:	e9 1d 01 00 00       	jmp    803076 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802f5f:	83 ec 0c             	sub    $0xc,%esp
  802f62:	ff 75 a8             	pushl  -0x58(%ebp)
  802f65:	e8 ee f6 ff ff       	call   802658 <get_block_size>
  802f6a:	83 c4 10             	add    $0x10,%esp
  802f6d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802f70:	8b 45 08             	mov    0x8(%ebp),%eax
  802f73:	83 c0 08             	add    $0x8,%eax
  802f76:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f79:	0f 87 ef 00 00 00    	ja     80306e <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	83 c0 18             	add    $0x18,%eax
  802f85:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f88:	77 1d                	ja     802fa7 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f90:	0f 86 d8 00 00 00    	jbe    80306e <alloc_block_BF+0x1da>
				{
					best_va = va;
  802f96:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f99:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802f9c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802fa2:	e9 c7 00 00 00       	jmp    80306e <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	83 c0 08             	add    $0x8,%eax
  802fad:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fb0:	0f 85 9d 00 00 00    	jne    803053 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802fb6:	83 ec 04             	sub    $0x4,%esp
  802fb9:	6a 01                	push   $0x1
  802fbb:	ff 75 a4             	pushl  -0x5c(%ebp)
  802fbe:	ff 75 a8             	pushl  -0x58(%ebp)
  802fc1:	e8 e3 f9 ff ff       	call   8029a9 <set_block_data>
  802fc6:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802fc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fcd:	75 17                	jne    802fe6 <alloc_block_BF+0x152>
  802fcf:	83 ec 04             	sub    $0x4,%esp
  802fd2:	68 73 4c 80 00       	push   $0x804c73
  802fd7:	68 2c 01 00 00       	push   $0x12c
  802fdc:	68 91 4c 80 00       	push   $0x804c91
  802fe1:	e8 ca d7 ff ff       	call   8007b0 <_panic>
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	8b 00                	mov    (%eax),%eax
  802feb:	85 c0                	test   %eax,%eax
  802fed:	74 10                	je     802fff <alloc_block_BF+0x16b>
  802fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff2:	8b 00                	mov    (%eax),%eax
  802ff4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff7:	8b 52 04             	mov    0x4(%edx),%edx
  802ffa:	89 50 04             	mov    %edx,0x4(%eax)
  802ffd:	eb 0b                	jmp    80300a <alloc_block_BF+0x176>
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	8b 40 04             	mov    0x4(%eax),%eax
  803005:	a3 38 50 80 00       	mov    %eax,0x805038
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	8b 40 04             	mov    0x4(%eax),%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	74 0f                	je     803023 <alloc_block_BF+0x18f>
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	8b 40 04             	mov    0x4(%eax),%eax
  80301a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80301d:	8b 12                	mov    (%edx),%edx
  80301f:	89 10                	mov    %edx,(%eax)
  803021:	eb 0a                	jmp    80302d <alloc_block_BF+0x199>
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	8b 00                	mov    (%eax),%eax
  803028:	a3 34 50 80 00       	mov    %eax,0x805034
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803040:	a1 40 50 80 00       	mov    0x805040,%eax
  803045:	48                   	dec    %eax
  803046:	a3 40 50 80 00       	mov    %eax,0x805040
					return va;
  80304b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80304e:	e9 24 04 00 00       	jmp    803477 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803053:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803056:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803059:	76 13                	jbe    80306e <alloc_block_BF+0x1da>
					{
						internal = 1;
  80305b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803062:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803065:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803068:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80306b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80306e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803073:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803076:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307a:	74 07                	je     803083 <alloc_block_BF+0x1ef>
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	8b 00                	mov    (%eax),%eax
  803081:	eb 05                	jmp    803088 <alloc_block_BF+0x1f4>
  803083:	b8 00 00 00 00       	mov    $0x0,%eax
  803088:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80308d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803092:	85 c0                	test   %eax,%eax
  803094:	0f 85 bf fe ff ff    	jne    802f59 <alloc_block_BF+0xc5>
  80309a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309e:	0f 85 b5 fe ff ff    	jne    802f59 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8030a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030a8:	0f 84 26 02 00 00    	je     8032d4 <alloc_block_BF+0x440>
  8030ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030b2:	0f 85 1c 02 00 00    	jne    8032d4 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8030b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bb:	2b 45 08             	sub    0x8(%ebp),%eax
  8030be:	83 e8 08             	sub    $0x8,%eax
  8030c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	8d 50 08             	lea    0x8(%eax),%edx
  8030ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cd:	01 d0                	add    %edx,%eax
  8030cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	83 c0 08             	add    $0x8,%eax
  8030d8:	83 ec 04             	sub    $0x4,%esp
  8030db:	6a 01                	push   $0x1
  8030dd:	50                   	push   %eax
  8030de:	ff 75 f0             	pushl  -0x10(%ebp)
  8030e1:	e8 c3 f8 ff ff       	call   8029a9 <set_block_data>
  8030e6:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8030e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ec:	8b 40 04             	mov    0x4(%eax),%eax
  8030ef:	85 c0                	test   %eax,%eax
  8030f1:	75 68                	jne    80315b <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030f3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030f7:	75 17                	jne    803110 <alloc_block_BF+0x27c>
  8030f9:	83 ec 04             	sub    $0x4,%esp
  8030fc:	68 ac 4c 80 00       	push   $0x804cac
  803101:	68 45 01 00 00       	push   $0x145
  803106:	68 91 4c 80 00       	push   $0x804c91
  80310b:	e8 a0 d6 ff ff       	call   8007b0 <_panic>
  803110:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803116:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803119:	89 10                	mov    %edx,(%eax)
  80311b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 0d                	je     803131 <alloc_block_BF+0x29d>
  803124:	a1 34 50 80 00       	mov    0x805034,%eax
  803129:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80312c:	89 50 04             	mov    %edx,0x4(%eax)
  80312f:	eb 08                	jmp    803139 <alloc_block_BF+0x2a5>
  803131:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803134:	a3 38 50 80 00       	mov    %eax,0x805038
  803139:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80313c:	a3 34 50 80 00       	mov    %eax,0x805034
  803141:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803144:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314b:	a1 40 50 80 00       	mov    0x805040,%eax
  803150:	40                   	inc    %eax
  803151:	a3 40 50 80 00       	mov    %eax,0x805040
  803156:	e9 dc 00 00 00       	jmp    803237 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80315b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315e:	8b 00                	mov    (%eax),%eax
  803160:	85 c0                	test   %eax,%eax
  803162:	75 65                	jne    8031c9 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803164:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803168:	75 17                	jne    803181 <alloc_block_BF+0x2ed>
  80316a:	83 ec 04             	sub    $0x4,%esp
  80316d:	68 e0 4c 80 00       	push   $0x804ce0
  803172:	68 4a 01 00 00       	push   $0x14a
  803177:	68 91 4c 80 00       	push   $0x804c91
  80317c:	e8 2f d6 ff ff       	call   8007b0 <_panic>
  803181:	8b 15 38 50 80 00    	mov    0x805038,%edx
  803187:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80318a:	89 50 04             	mov    %edx,0x4(%eax)
  80318d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803190:	8b 40 04             	mov    0x4(%eax),%eax
  803193:	85 c0                	test   %eax,%eax
  803195:	74 0c                	je     8031a3 <alloc_block_BF+0x30f>
  803197:	a1 38 50 80 00       	mov    0x805038,%eax
  80319c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80319f:	89 10                	mov    %edx,(%eax)
  8031a1:	eb 08                	jmp    8031ab <alloc_block_BF+0x317>
  8031a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031a6:	a3 34 50 80 00       	mov    %eax,0x805034
  8031ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ae:	a3 38 50 80 00       	mov    %eax,0x805038
  8031b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031bc:	a1 40 50 80 00       	mov    0x805040,%eax
  8031c1:	40                   	inc    %eax
  8031c2:	a3 40 50 80 00       	mov    %eax,0x805040
  8031c7:	eb 6e                	jmp    803237 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8031c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031cd:	74 06                	je     8031d5 <alloc_block_BF+0x341>
  8031cf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031d3:	75 17                	jne    8031ec <alloc_block_BF+0x358>
  8031d5:	83 ec 04             	sub    $0x4,%esp
  8031d8:	68 04 4d 80 00       	push   $0x804d04
  8031dd:	68 4f 01 00 00       	push   $0x14f
  8031e2:	68 91 4c 80 00       	push   $0x804c91
  8031e7:	e8 c4 d5 ff ff       	call   8007b0 <_panic>
  8031ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ef:	8b 10                	mov    (%eax),%edx
  8031f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031f4:	89 10                	mov    %edx,(%eax)
  8031f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031f9:	8b 00                	mov    (%eax),%eax
  8031fb:	85 c0                	test   %eax,%eax
  8031fd:	74 0b                	je     80320a <alloc_block_BF+0x376>
  8031ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803202:	8b 00                	mov    (%eax),%eax
  803204:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803207:	89 50 04             	mov    %edx,0x4(%eax)
  80320a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803210:	89 10                	mov    %edx,(%eax)
  803212:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803215:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803218:	89 50 04             	mov    %edx,0x4(%eax)
  80321b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80321e:	8b 00                	mov    (%eax),%eax
  803220:	85 c0                	test   %eax,%eax
  803222:	75 08                	jne    80322c <alloc_block_BF+0x398>
  803224:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803227:	a3 38 50 80 00       	mov    %eax,0x805038
  80322c:	a1 40 50 80 00       	mov    0x805040,%eax
  803231:	40                   	inc    %eax
  803232:	a3 40 50 80 00       	mov    %eax,0x805040
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80323b:	75 17                	jne    803254 <alloc_block_BF+0x3c0>
  80323d:	83 ec 04             	sub    $0x4,%esp
  803240:	68 73 4c 80 00       	push   $0x804c73
  803245:	68 51 01 00 00       	push   $0x151
  80324a:	68 91 4c 80 00       	push   $0x804c91
  80324f:	e8 5c d5 ff ff       	call   8007b0 <_panic>
  803254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803257:	8b 00                	mov    (%eax),%eax
  803259:	85 c0                	test   %eax,%eax
  80325b:	74 10                	je     80326d <alloc_block_BF+0x3d9>
  80325d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803260:	8b 00                	mov    (%eax),%eax
  803262:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803265:	8b 52 04             	mov    0x4(%edx),%edx
  803268:	89 50 04             	mov    %edx,0x4(%eax)
  80326b:	eb 0b                	jmp    803278 <alloc_block_BF+0x3e4>
  80326d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803270:	8b 40 04             	mov    0x4(%eax),%eax
  803273:	a3 38 50 80 00       	mov    %eax,0x805038
  803278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327b:	8b 40 04             	mov    0x4(%eax),%eax
  80327e:	85 c0                	test   %eax,%eax
  803280:	74 0f                	je     803291 <alloc_block_BF+0x3fd>
  803282:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803285:	8b 40 04             	mov    0x4(%eax),%eax
  803288:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80328b:	8b 12                	mov    (%edx),%edx
  80328d:	89 10                	mov    %edx,(%eax)
  80328f:	eb 0a                	jmp    80329b <alloc_block_BF+0x407>
  803291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803294:	8b 00                	mov    (%eax),%eax
  803296:	a3 34 50 80 00       	mov    %eax,0x805034
  80329b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ae:	a1 40 50 80 00       	mov    0x805040,%eax
  8032b3:	48                   	dec    %eax
  8032b4:	a3 40 50 80 00       	mov    %eax,0x805040
			set_block_data(new_block_va, remaining_size, 0);
  8032b9:	83 ec 04             	sub    $0x4,%esp
  8032bc:	6a 00                	push   $0x0
  8032be:	ff 75 d0             	pushl  -0x30(%ebp)
  8032c1:	ff 75 cc             	pushl  -0x34(%ebp)
  8032c4:	e8 e0 f6 ff ff       	call   8029a9 <set_block_data>
  8032c9:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8032cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cf:	e9 a3 01 00 00       	jmp    803477 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8032d4:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8032d8:	0f 85 9d 00 00 00    	jne    80337b <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8032de:	83 ec 04             	sub    $0x4,%esp
  8032e1:	6a 01                	push   $0x1
  8032e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8032e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8032e9:	e8 bb f6 ff ff       	call   8029a9 <set_block_data>
  8032ee:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8032f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032f5:	75 17                	jne    80330e <alloc_block_BF+0x47a>
  8032f7:	83 ec 04             	sub    $0x4,%esp
  8032fa:	68 73 4c 80 00       	push   $0x804c73
  8032ff:	68 58 01 00 00       	push   $0x158
  803304:	68 91 4c 80 00       	push   $0x804c91
  803309:	e8 a2 d4 ff ff       	call   8007b0 <_panic>
  80330e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803311:	8b 00                	mov    (%eax),%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	74 10                	je     803327 <alloc_block_BF+0x493>
  803317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331a:	8b 00                	mov    (%eax),%eax
  80331c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80331f:	8b 52 04             	mov    0x4(%edx),%edx
  803322:	89 50 04             	mov    %edx,0x4(%eax)
  803325:	eb 0b                	jmp    803332 <alloc_block_BF+0x49e>
  803327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332a:	8b 40 04             	mov    0x4(%eax),%eax
  80332d:	a3 38 50 80 00       	mov    %eax,0x805038
  803332:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803335:	8b 40 04             	mov    0x4(%eax),%eax
  803338:	85 c0                	test   %eax,%eax
  80333a:	74 0f                	je     80334b <alloc_block_BF+0x4b7>
  80333c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333f:	8b 40 04             	mov    0x4(%eax),%eax
  803342:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803345:	8b 12                	mov    (%edx),%edx
  803347:	89 10                	mov    %edx,(%eax)
  803349:	eb 0a                	jmp    803355 <alloc_block_BF+0x4c1>
  80334b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	a3 34 50 80 00       	mov    %eax,0x805034
  803355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803358:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80335e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803361:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803368:	a1 40 50 80 00       	mov    0x805040,%eax
  80336d:	48                   	dec    %eax
  80336e:	a3 40 50 80 00       	mov    %eax,0x805040
		return best_va;
  803373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803376:	e9 fc 00 00 00       	jmp    803477 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	83 c0 08             	add    $0x8,%eax
  803381:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803384:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80338b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80338e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803391:	01 d0                	add    %edx,%eax
  803393:	48                   	dec    %eax
  803394:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803397:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80339a:	ba 00 00 00 00       	mov    $0x0,%edx
  80339f:	f7 75 c4             	divl   -0x3c(%ebp)
  8033a2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8033a5:	29 d0                	sub    %edx,%eax
  8033a7:	c1 e8 0c             	shr    $0xc,%eax
  8033aa:	83 ec 0c             	sub    $0xc,%esp
  8033ad:	50                   	push   %eax
  8033ae:	e8 5c e6 ff ff       	call   801a0f <sbrk>
  8033b3:	83 c4 10             	add    $0x10,%esp
  8033b6:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8033b9:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8033bd:	75 0a                	jne    8033c9 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8033bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c4:	e9 ae 00 00 00       	jmp    803477 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8033c9:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8033d0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033d3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8033d6:	01 d0                	add    %edx,%eax
  8033d8:	48                   	dec    %eax
  8033d9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8033dc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8033df:	ba 00 00 00 00       	mov    $0x0,%edx
  8033e4:	f7 75 b8             	divl   -0x48(%ebp)
  8033e7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8033ea:	29 d0                	sub    %edx,%eax
  8033ec:	8d 50 fc             	lea    -0x4(%eax),%edx
  8033ef:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8033f2:	01 d0                	add    %edx,%eax
  8033f4:	a3 4c 50 80 00       	mov    %eax,0x80504c
				end_block->info = 1;
  8033f9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8033fe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803404:	83 ec 0c             	sub    $0xc,%esp
  803407:	68 38 4d 80 00       	push   $0x804d38
  80340c:	e8 5c d6 ff ff       	call   800a6d <cprintf>
  803411:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803414:	83 ec 08             	sub    $0x8,%esp
  803417:	ff 75 bc             	pushl  -0x44(%ebp)
  80341a:	68 3d 4d 80 00       	push   $0x804d3d
  80341f:	e8 49 d6 ff ff       	call   800a6d <cprintf>
  803424:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803427:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80342e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803431:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803434:	01 d0                	add    %edx,%eax
  803436:	48                   	dec    %eax
  803437:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80343a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80343d:	ba 00 00 00 00       	mov    $0x0,%edx
  803442:	f7 75 b0             	divl   -0x50(%ebp)
  803445:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803448:	29 d0                	sub    %edx,%eax
  80344a:	83 ec 04             	sub    $0x4,%esp
  80344d:	6a 01                	push   $0x1
  80344f:	50                   	push   %eax
  803450:	ff 75 bc             	pushl  -0x44(%ebp)
  803453:	e8 51 f5 ff ff       	call   8029a9 <set_block_data>
  803458:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80345b:	83 ec 0c             	sub    $0xc,%esp
  80345e:	ff 75 bc             	pushl  -0x44(%ebp)
  803461:	e8 36 04 00 00       	call   80389c <free_block>
  803466:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803469:	83 ec 0c             	sub    $0xc,%esp
  80346c:	ff 75 08             	pushl  0x8(%ebp)
  80346f:	e8 20 fa ff ff       	call   802e94 <alloc_block_BF>
  803474:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803477:	c9                   	leave  
  803478:	c3                   	ret    

00803479 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803479:	55                   	push   %ebp
  80347a:	89 e5                	mov    %esp,%ebp
  80347c:	53                   	push   %ebx
  80347d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803480:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803487:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80348e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803492:	74 1e                	je     8034b2 <merging+0x39>
  803494:	ff 75 08             	pushl  0x8(%ebp)
  803497:	e8 bc f1 ff ff       	call   802658 <get_block_size>
  80349c:	83 c4 04             	add    $0x4,%esp
  80349f:	89 c2                	mov    %eax,%edx
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	01 d0                	add    %edx,%eax
  8034a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8034a9:	75 07                	jne    8034b2 <merging+0x39>
		prev_is_free = 1;
  8034ab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8034b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034b6:	74 1e                	je     8034d6 <merging+0x5d>
  8034b8:	ff 75 10             	pushl  0x10(%ebp)
  8034bb:	e8 98 f1 ff ff       	call   802658 <get_block_size>
  8034c0:	83 c4 04             	add    $0x4,%esp
  8034c3:	89 c2                	mov    %eax,%edx
  8034c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8034c8:	01 d0                	add    %edx,%eax
  8034ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034cd:	75 07                	jne    8034d6 <merging+0x5d>
		next_is_free = 1;
  8034cf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8034d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034da:	0f 84 cc 00 00 00    	je     8035ac <merging+0x133>
  8034e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034e4:	0f 84 c2 00 00 00    	je     8035ac <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8034ea:	ff 75 08             	pushl  0x8(%ebp)
  8034ed:	e8 66 f1 ff ff       	call   802658 <get_block_size>
  8034f2:	83 c4 04             	add    $0x4,%esp
  8034f5:	89 c3                	mov    %eax,%ebx
  8034f7:	ff 75 10             	pushl  0x10(%ebp)
  8034fa:	e8 59 f1 ff ff       	call   802658 <get_block_size>
  8034ff:	83 c4 04             	add    $0x4,%esp
  803502:	01 c3                	add    %eax,%ebx
  803504:	ff 75 0c             	pushl  0xc(%ebp)
  803507:	e8 4c f1 ff ff       	call   802658 <get_block_size>
  80350c:	83 c4 04             	add    $0x4,%esp
  80350f:	01 d8                	add    %ebx,%eax
  803511:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803514:	6a 00                	push   $0x0
  803516:	ff 75 ec             	pushl  -0x14(%ebp)
  803519:	ff 75 08             	pushl  0x8(%ebp)
  80351c:	e8 88 f4 ff ff       	call   8029a9 <set_block_data>
  803521:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803524:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803528:	75 17                	jne    803541 <merging+0xc8>
  80352a:	83 ec 04             	sub    $0x4,%esp
  80352d:	68 73 4c 80 00       	push   $0x804c73
  803532:	68 7d 01 00 00       	push   $0x17d
  803537:	68 91 4c 80 00       	push   $0x804c91
  80353c:	e8 6f d2 ff ff       	call   8007b0 <_panic>
  803541:	8b 45 0c             	mov    0xc(%ebp),%eax
  803544:	8b 00                	mov    (%eax),%eax
  803546:	85 c0                	test   %eax,%eax
  803548:	74 10                	je     80355a <merging+0xe1>
  80354a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80354d:	8b 00                	mov    (%eax),%eax
  80354f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803552:	8b 52 04             	mov    0x4(%edx),%edx
  803555:	89 50 04             	mov    %edx,0x4(%eax)
  803558:	eb 0b                	jmp    803565 <merging+0xec>
  80355a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80355d:	8b 40 04             	mov    0x4(%eax),%eax
  803560:	a3 38 50 80 00       	mov    %eax,0x805038
  803565:	8b 45 0c             	mov    0xc(%ebp),%eax
  803568:	8b 40 04             	mov    0x4(%eax),%eax
  80356b:	85 c0                	test   %eax,%eax
  80356d:	74 0f                	je     80357e <merging+0x105>
  80356f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803572:	8b 40 04             	mov    0x4(%eax),%eax
  803575:	8b 55 0c             	mov    0xc(%ebp),%edx
  803578:	8b 12                	mov    (%edx),%edx
  80357a:	89 10                	mov    %edx,(%eax)
  80357c:	eb 0a                	jmp    803588 <merging+0x10f>
  80357e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803581:	8b 00                	mov    (%eax),%eax
  803583:	a3 34 50 80 00       	mov    %eax,0x805034
  803588:	8b 45 0c             	mov    0xc(%ebp),%eax
  80358b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803591:	8b 45 0c             	mov    0xc(%ebp),%eax
  803594:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359b:	a1 40 50 80 00       	mov    0x805040,%eax
  8035a0:	48                   	dec    %eax
  8035a1:	a3 40 50 80 00       	mov    %eax,0x805040
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8035a6:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035a7:	e9 ea 02 00 00       	jmp    803896 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8035ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b0:	74 3b                	je     8035ed <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8035b2:	83 ec 0c             	sub    $0xc,%esp
  8035b5:	ff 75 08             	pushl  0x8(%ebp)
  8035b8:	e8 9b f0 ff ff       	call   802658 <get_block_size>
  8035bd:	83 c4 10             	add    $0x10,%esp
  8035c0:	89 c3                	mov    %eax,%ebx
  8035c2:	83 ec 0c             	sub    $0xc,%esp
  8035c5:	ff 75 10             	pushl  0x10(%ebp)
  8035c8:	e8 8b f0 ff ff       	call   802658 <get_block_size>
  8035cd:	83 c4 10             	add    $0x10,%esp
  8035d0:	01 d8                	add    %ebx,%eax
  8035d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8035d5:	83 ec 04             	sub    $0x4,%esp
  8035d8:	6a 00                	push   $0x0
  8035da:	ff 75 e8             	pushl  -0x18(%ebp)
  8035dd:	ff 75 08             	pushl  0x8(%ebp)
  8035e0:	e8 c4 f3 ff ff       	call   8029a9 <set_block_data>
  8035e5:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035e8:	e9 a9 02 00 00       	jmp    803896 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8035ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035f1:	0f 84 2d 01 00 00    	je     803724 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8035f7:	83 ec 0c             	sub    $0xc,%esp
  8035fa:	ff 75 10             	pushl  0x10(%ebp)
  8035fd:	e8 56 f0 ff ff       	call   802658 <get_block_size>
  803602:	83 c4 10             	add    $0x10,%esp
  803605:	89 c3                	mov    %eax,%ebx
  803607:	83 ec 0c             	sub    $0xc,%esp
  80360a:	ff 75 0c             	pushl  0xc(%ebp)
  80360d:	e8 46 f0 ff ff       	call   802658 <get_block_size>
  803612:	83 c4 10             	add    $0x10,%esp
  803615:	01 d8                	add    %ebx,%eax
  803617:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80361a:	83 ec 04             	sub    $0x4,%esp
  80361d:	6a 00                	push   $0x0
  80361f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803622:	ff 75 10             	pushl  0x10(%ebp)
  803625:	e8 7f f3 ff ff       	call   8029a9 <set_block_data>
  80362a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80362d:	8b 45 10             	mov    0x10(%ebp),%eax
  803630:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803633:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803637:	74 06                	je     80363f <merging+0x1c6>
  803639:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80363d:	75 17                	jne    803656 <merging+0x1dd>
  80363f:	83 ec 04             	sub    $0x4,%esp
  803642:	68 4c 4d 80 00       	push   $0x804d4c
  803647:	68 8d 01 00 00       	push   $0x18d
  80364c:	68 91 4c 80 00       	push   $0x804c91
  803651:	e8 5a d1 ff ff       	call   8007b0 <_panic>
  803656:	8b 45 0c             	mov    0xc(%ebp),%eax
  803659:	8b 50 04             	mov    0x4(%eax),%edx
  80365c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80365f:	89 50 04             	mov    %edx,0x4(%eax)
  803662:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803665:	8b 55 0c             	mov    0xc(%ebp),%edx
  803668:	89 10                	mov    %edx,(%eax)
  80366a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366d:	8b 40 04             	mov    0x4(%eax),%eax
  803670:	85 c0                	test   %eax,%eax
  803672:	74 0d                	je     803681 <merging+0x208>
  803674:	8b 45 0c             	mov    0xc(%ebp),%eax
  803677:	8b 40 04             	mov    0x4(%eax),%eax
  80367a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80367d:	89 10                	mov    %edx,(%eax)
  80367f:	eb 08                	jmp    803689 <merging+0x210>
  803681:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803684:	a3 34 50 80 00       	mov    %eax,0x805034
  803689:	8b 45 0c             	mov    0xc(%ebp),%eax
  80368c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80368f:	89 50 04             	mov    %edx,0x4(%eax)
  803692:	a1 40 50 80 00       	mov    0x805040,%eax
  803697:	40                   	inc    %eax
  803698:	a3 40 50 80 00       	mov    %eax,0x805040
		LIST_REMOVE(&freeBlocksList, next_block);
  80369d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036a1:	75 17                	jne    8036ba <merging+0x241>
  8036a3:	83 ec 04             	sub    $0x4,%esp
  8036a6:	68 73 4c 80 00       	push   $0x804c73
  8036ab:	68 8e 01 00 00       	push   $0x18e
  8036b0:	68 91 4c 80 00       	push   $0x804c91
  8036b5:	e8 f6 d0 ff ff       	call   8007b0 <_panic>
  8036ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036bd:	8b 00                	mov    (%eax),%eax
  8036bf:	85 c0                	test   %eax,%eax
  8036c1:	74 10                	je     8036d3 <merging+0x25a>
  8036c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c6:	8b 00                	mov    (%eax),%eax
  8036c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036cb:	8b 52 04             	mov    0x4(%edx),%edx
  8036ce:	89 50 04             	mov    %edx,0x4(%eax)
  8036d1:	eb 0b                	jmp    8036de <merging+0x265>
  8036d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d6:	8b 40 04             	mov    0x4(%eax),%eax
  8036d9:	a3 38 50 80 00       	mov    %eax,0x805038
  8036de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e1:	8b 40 04             	mov    0x4(%eax),%eax
  8036e4:	85 c0                	test   %eax,%eax
  8036e6:	74 0f                	je     8036f7 <merging+0x27e>
  8036e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036eb:	8b 40 04             	mov    0x4(%eax),%eax
  8036ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036f1:	8b 12                	mov    (%edx),%edx
  8036f3:	89 10                	mov    %edx,(%eax)
  8036f5:	eb 0a                	jmp    803701 <merging+0x288>
  8036f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036fa:	8b 00                	mov    (%eax),%eax
  8036fc:	a3 34 50 80 00       	mov    %eax,0x805034
  803701:	8b 45 0c             	mov    0xc(%ebp),%eax
  803704:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80370d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803714:	a1 40 50 80 00       	mov    0x805040,%eax
  803719:	48                   	dec    %eax
  80371a:	a3 40 50 80 00       	mov    %eax,0x805040
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80371f:	e9 72 01 00 00       	jmp    803896 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803724:	8b 45 10             	mov    0x10(%ebp),%eax
  803727:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80372a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80372e:	74 79                	je     8037a9 <merging+0x330>
  803730:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803734:	74 73                	je     8037a9 <merging+0x330>
  803736:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80373a:	74 06                	je     803742 <merging+0x2c9>
  80373c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803740:	75 17                	jne    803759 <merging+0x2e0>
  803742:	83 ec 04             	sub    $0x4,%esp
  803745:	68 04 4d 80 00       	push   $0x804d04
  80374a:	68 94 01 00 00       	push   $0x194
  80374f:	68 91 4c 80 00       	push   $0x804c91
  803754:	e8 57 d0 ff ff       	call   8007b0 <_panic>
  803759:	8b 45 08             	mov    0x8(%ebp),%eax
  80375c:	8b 10                	mov    (%eax),%edx
  80375e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803761:	89 10                	mov    %edx,(%eax)
  803763:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803766:	8b 00                	mov    (%eax),%eax
  803768:	85 c0                	test   %eax,%eax
  80376a:	74 0b                	je     803777 <merging+0x2fe>
  80376c:	8b 45 08             	mov    0x8(%ebp),%eax
  80376f:	8b 00                	mov    (%eax),%eax
  803771:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803774:	89 50 04             	mov    %edx,0x4(%eax)
  803777:	8b 45 08             	mov    0x8(%ebp),%eax
  80377a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80377d:	89 10                	mov    %edx,(%eax)
  80377f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803782:	8b 55 08             	mov    0x8(%ebp),%edx
  803785:	89 50 04             	mov    %edx,0x4(%eax)
  803788:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80378b:	8b 00                	mov    (%eax),%eax
  80378d:	85 c0                	test   %eax,%eax
  80378f:	75 08                	jne    803799 <merging+0x320>
  803791:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803794:	a3 38 50 80 00       	mov    %eax,0x805038
  803799:	a1 40 50 80 00       	mov    0x805040,%eax
  80379e:	40                   	inc    %eax
  80379f:	a3 40 50 80 00       	mov    %eax,0x805040
  8037a4:	e9 ce 00 00 00       	jmp    803877 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8037a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037ad:	74 65                	je     803814 <merging+0x39b>
  8037af:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037b3:	75 17                	jne    8037cc <merging+0x353>
  8037b5:	83 ec 04             	sub    $0x4,%esp
  8037b8:	68 e0 4c 80 00       	push   $0x804ce0
  8037bd:	68 95 01 00 00       	push   $0x195
  8037c2:	68 91 4c 80 00       	push   $0x804c91
  8037c7:	e8 e4 cf ff ff       	call   8007b0 <_panic>
  8037cc:	8b 15 38 50 80 00    	mov    0x805038,%edx
  8037d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d5:	89 50 04             	mov    %edx,0x4(%eax)
  8037d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037db:	8b 40 04             	mov    0x4(%eax),%eax
  8037de:	85 c0                	test   %eax,%eax
  8037e0:	74 0c                	je     8037ee <merging+0x375>
  8037e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8037e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037ea:	89 10                	mov    %edx,(%eax)
  8037ec:	eb 08                	jmp    8037f6 <merging+0x37d>
  8037ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f1:	a3 34 50 80 00       	mov    %eax,0x805034
  8037f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f9:	a3 38 50 80 00       	mov    %eax,0x805038
  8037fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803801:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803807:	a1 40 50 80 00       	mov    0x805040,%eax
  80380c:	40                   	inc    %eax
  80380d:	a3 40 50 80 00       	mov    %eax,0x805040
  803812:	eb 63                	jmp    803877 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803814:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803818:	75 17                	jne    803831 <merging+0x3b8>
  80381a:	83 ec 04             	sub    $0x4,%esp
  80381d:	68 ac 4c 80 00       	push   $0x804cac
  803822:	68 98 01 00 00       	push   $0x198
  803827:	68 91 4c 80 00       	push   $0x804c91
  80382c:	e8 7f cf ff ff       	call   8007b0 <_panic>
  803831:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803837:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80383a:	89 10                	mov    %edx,(%eax)
  80383c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80383f:	8b 00                	mov    (%eax),%eax
  803841:	85 c0                	test   %eax,%eax
  803843:	74 0d                	je     803852 <merging+0x3d9>
  803845:	a1 34 50 80 00       	mov    0x805034,%eax
  80384a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80384d:	89 50 04             	mov    %edx,0x4(%eax)
  803850:	eb 08                	jmp    80385a <merging+0x3e1>
  803852:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803855:	a3 38 50 80 00       	mov    %eax,0x805038
  80385a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80385d:	a3 34 50 80 00       	mov    %eax,0x805034
  803862:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803865:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80386c:	a1 40 50 80 00       	mov    0x805040,%eax
  803871:	40                   	inc    %eax
  803872:	a3 40 50 80 00       	mov    %eax,0x805040
		}
		set_block_data(va, get_block_size(va), 0);
  803877:	83 ec 0c             	sub    $0xc,%esp
  80387a:	ff 75 10             	pushl  0x10(%ebp)
  80387d:	e8 d6 ed ff ff       	call   802658 <get_block_size>
  803882:	83 c4 10             	add    $0x10,%esp
  803885:	83 ec 04             	sub    $0x4,%esp
  803888:	6a 00                	push   $0x0
  80388a:	50                   	push   %eax
  80388b:	ff 75 10             	pushl  0x10(%ebp)
  80388e:	e8 16 f1 ff ff       	call   8029a9 <set_block_data>
  803893:	83 c4 10             	add    $0x10,%esp
	}
}
  803896:	90                   	nop
  803897:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80389a:	c9                   	leave  
  80389b:	c3                   	ret    

0080389c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80389c:	55                   	push   %ebp
  80389d:	89 e5                	mov    %esp,%ebp
  80389f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8038a2:	a1 34 50 80 00       	mov    0x805034,%eax
  8038a7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8038aa:	a1 38 50 80 00       	mov    0x805038,%eax
  8038af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038b2:	73 1b                	jae    8038cf <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8038b4:	a1 38 50 80 00       	mov    0x805038,%eax
  8038b9:	83 ec 04             	sub    $0x4,%esp
  8038bc:	ff 75 08             	pushl  0x8(%ebp)
  8038bf:	6a 00                	push   $0x0
  8038c1:	50                   	push   %eax
  8038c2:	e8 b2 fb ff ff       	call   803479 <merging>
  8038c7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038ca:	e9 8b 00 00 00       	jmp    80395a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8038cf:	a1 34 50 80 00       	mov    0x805034,%eax
  8038d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038d7:	76 18                	jbe    8038f1 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8038d9:	a1 34 50 80 00       	mov    0x805034,%eax
  8038de:	83 ec 04             	sub    $0x4,%esp
  8038e1:	ff 75 08             	pushl  0x8(%ebp)
  8038e4:	50                   	push   %eax
  8038e5:	6a 00                	push   $0x0
  8038e7:	e8 8d fb ff ff       	call   803479 <merging>
  8038ec:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038ef:	eb 69                	jmp    80395a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8038f1:	a1 34 50 80 00       	mov    0x805034,%eax
  8038f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038f9:	eb 39                	jmp    803934 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8038fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  803901:	73 29                	jae    80392c <free_block+0x90>
  803903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803906:	8b 00                	mov    (%eax),%eax
  803908:	3b 45 08             	cmp    0x8(%ebp),%eax
  80390b:	76 1f                	jbe    80392c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80390d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803910:	8b 00                	mov    (%eax),%eax
  803912:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803915:	83 ec 04             	sub    $0x4,%esp
  803918:	ff 75 08             	pushl  0x8(%ebp)
  80391b:	ff 75 f0             	pushl  -0x10(%ebp)
  80391e:	ff 75 f4             	pushl  -0xc(%ebp)
  803921:	e8 53 fb ff ff       	call   803479 <merging>
  803926:	83 c4 10             	add    $0x10,%esp
			break;
  803929:	90                   	nop
		}
	}
}
  80392a:	eb 2e                	jmp    80395a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80392c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803931:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803934:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803938:	74 07                	je     803941 <free_block+0xa5>
  80393a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393d:	8b 00                	mov    (%eax),%eax
  80393f:	eb 05                	jmp    803946 <free_block+0xaa>
  803941:	b8 00 00 00 00       	mov    $0x0,%eax
  803946:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80394b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803950:	85 c0                	test   %eax,%eax
  803952:	75 a7                	jne    8038fb <free_block+0x5f>
  803954:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803958:	75 a1                	jne    8038fb <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80395a:	90                   	nop
  80395b:	c9                   	leave  
  80395c:	c3                   	ret    

0080395d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80395d:	55                   	push   %ebp
  80395e:	89 e5                	mov    %esp,%ebp
  803960:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803963:	ff 75 08             	pushl  0x8(%ebp)
  803966:	e8 ed ec ff ff       	call   802658 <get_block_size>
  80396b:	83 c4 04             	add    $0x4,%esp
  80396e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803971:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803978:	eb 17                	jmp    803991 <copy_data+0x34>
  80397a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80397d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803980:	01 c2                	add    %eax,%edx
  803982:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803985:	8b 45 08             	mov    0x8(%ebp),%eax
  803988:	01 c8                	add    %ecx,%eax
  80398a:	8a 00                	mov    (%eax),%al
  80398c:	88 02                	mov    %al,(%edx)
  80398e:	ff 45 fc             	incl   -0x4(%ebp)
  803991:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803994:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803997:	72 e1                	jb     80397a <copy_data+0x1d>
}
  803999:	90                   	nop
  80399a:	c9                   	leave  
  80399b:	c3                   	ret    

0080399c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80399c:	55                   	push   %ebp
  80399d:	89 e5                	mov    %esp,%ebp
  80399f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8039a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039a6:	75 23                	jne    8039cb <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8039a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039ac:	74 13                	je     8039c1 <realloc_block_FF+0x25>
  8039ae:	83 ec 0c             	sub    $0xc,%esp
  8039b1:	ff 75 0c             	pushl  0xc(%ebp)
  8039b4:	e8 1f f0 ff ff       	call   8029d8 <alloc_block_FF>
  8039b9:	83 c4 10             	add    $0x10,%esp
  8039bc:	e9 f4 06 00 00       	jmp    8040b5 <realloc_block_FF+0x719>
		return NULL;
  8039c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8039c6:	e9 ea 06 00 00       	jmp    8040b5 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8039cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039cf:	75 18                	jne    8039e9 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8039d1:	83 ec 0c             	sub    $0xc,%esp
  8039d4:	ff 75 08             	pushl  0x8(%ebp)
  8039d7:	e8 c0 fe ff ff       	call   80389c <free_block>
  8039dc:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8039df:	b8 00 00 00 00       	mov    $0x0,%eax
  8039e4:	e9 cc 06 00 00       	jmp    8040b5 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8039e9:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8039ed:	77 07                	ja     8039f6 <realloc_block_FF+0x5a>
  8039ef:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8039f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039f9:	83 e0 01             	and    $0x1,%eax
  8039fc:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8039ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a02:	83 c0 08             	add    $0x8,%eax
  803a05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803a08:	83 ec 0c             	sub    $0xc,%esp
  803a0b:	ff 75 08             	pushl  0x8(%ebp)
  803a0e:	e8 45 ec ff ff       	call   802658 <get_block_size>
  803a13:	83 c4 10             	add    $0x10,%esp
  803a16:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a1c:	83 e8 08             	sub    $0x8,%eax
  803a1f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803a22:	8b 45 08             	mov    0x8(%ebp),%eax
  803a25:	83 e8 04             	sub    $0x4,%eax
  803a28:	8b 00                	mov    (%eax),%eax
  803a2a:	83 e0 fe             	and    $0xfffffffe,%eax
  803a2d:	89 c2                	mov    %eax,%edx
  803a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a32:	01 d0                	add    %edx,%eax
  803a34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803a37:	83 ec 0c             	sub    $0xc,%esp
  803a3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a3d:	e8 16 ec ff ff       	call   802658 <get_block_size>
  803a42:	83 c4 10             	add    $0x10,%esp
  803a45:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a4b:	83 e8 08             	sub    $0x8,%eax
  803a4e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a54:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a57:	75 08                	jne    803a61 <realloc_block_FF+0xc5>
	{
		 return va;
  803a59:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5c:	e9 54 06 00 00       	jmp    8040b5 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a64:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a67:	0f 83 e5 03 00 00    	jae    803e52 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a70:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a73:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803a76:	83 ec 0c             	sub    $0xc,%esp
  803a79:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a7c:	e8 f0 eb ff ff       	call   802671 <is_free_block>
  803a81:	83 c4 10             	add    $0x10,%esp
  803a84:	84 c0                	test   %al,%al
  803a86:	0f 84 3b 01 00 00    	je     803bc7 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803a8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a92:	01 d0                	add    %edx,%eax
  803a94:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803a97:	83 ec 04             	sub    $0x4,%esp
  803a9a:	6a 01                	push   $0x1
  803a9c:	ff 75 f0             	pushl  -0x10(%ebp)
  803a9f:	ff 75 08             	pushl  0x8(%ebp)
  803aa2:	e8 02 ef ff ff       	call   8029a9 <set_block_data>
  803aa7:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  803aad:	83 e8 04             	sub    $0x4,%eax
  803ab0:	8b 00                	mov    (%eax),%eax
  803ab2:	83 e0 fe             	and    $0xfffffffe,%eax
  803ab5:	89 c2                	mov    %eax,%edx
  803ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aba:	01 d0                	add    %edx,%eax
  803abc:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803abf:	83 ec 04             	sub    $0x4,%esp
  803ac2:	6a 00                	push   $0x0
  803ac4:	ff 75 cc             	pushl  -0x34(%ebp)
  803ac7:	ff 75 c8             	pushl  -0x38(%ebp)
  803aca:	e8 da ee ff ff       	call   8029a9 <set_block_data>
  803acf:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803ad2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ad6:	74 06                	je     803ade <realloc_block_FF+0x142>
  803ad8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803adc:	75 17                	jne    803af5 <realloc_block_FF+0x159>
  803ade:	83 ec 04             	sub    $0x4,%esp
  803ae1:	68 04 4d 80 00       	push   $0x804d04
  803ae6:	68 f6 01 00 00       	push   $0x1f6
  803aeb:	68 91 4c 80 00       	push   $0x804c91
  803af0:	e8 bb cc ff ff       	call   8007b0 <_panic>
  803af5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af8:	8b 10                	mov    (%eax),%edx
  803afa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803afd:	89 10                	mov    %edx,(%eax)
  803aff:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b02:	8b 00                	mov    (%eax),%eax
  803b04:	85 c0                	test   %eax,%eax
  803b06:	74 0b                	je     803b13 <realloc_block_FF+0x177>
  803b08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0b:	8b 00                	mov    (%eax),%eax
  803b0d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b10:	89 50 04             	mov    %edx,0x4(%eax)
  803b13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b16:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b19:	89 10                	mov    %edx,(%eax)
  803b1b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b21:	89 50 04             	mov    %edx,0x4(%eax)
  803b24:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b27:	8b 00                	mov    (%eax),%eax
  803b29:	85 c0                	test   %eax,%eax
  803b2b:	75 08                	jne    803b35 <realloc_block_FF+0x199>
  803b2d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b30:	a3 38 50 80 00       	mov    %eax,0x805038
  803b35:	a1 40 50 80 00       	mov    0x805040,%eax
  803b3a:	40                   	inc    %eax
  803b3b:	a3 40 50 80 00       	mov    %eax,0x805040
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803b40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b44:	75 17                	jne    803b5d <realloc_block_FF+0x1c1>
  803b46:	83 ec 04             	sub    $0x4,%esp
  803b49:	68 73 4c 80 00       	push   $0x804c73
  803b4e:	68 f7 01 00 00       	push   $0x1f7
  803b53:	68 91 4c 80 00       	push   $0x804c91
  803b58:	e8 53 cc ff ff       	call   8007b0 <_panic>
  803b5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b60:	8b 00                	mov    (%eax),%eax
  803b62:	85 c0                	test   %eax,%eax
  803b64:	74 10                	je     803b76 <realloc_block_FF+0x1da>
  803b66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b69:	8b 00                	mov    (%eax),%eax
  803b6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b6e:	8b 52 04             	mov    0x4(%edx),%edx
  803b71:	89 50 04             	mov    %edx,0x4(%eax)
  803b74:	eb 0b                	jmp    803b81 <realloc_block_FF+0x1e5>
  803b76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b79:	8b 40 04             	mov    0x4(%eax),%eax
  803b7c:	a3 38 50 80 00       	mov    %eax,0x805038
  803b81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b84:	8b 40 04             	mov    0x4(%eax),%eax
  803b87:	85 c0                	test   %eax,%eax
  803b89:	74 0f                	je     803b9a <realloc_block_FF+0x1fe>
  803b8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b8e:	8b 40 04             	mov    0x4(%eax),%eax
  803b91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b94:	8b 12                	mov    (%edx),%edx
  803b96:	89 10                	mov    %edx,(%eax)
  803b98:	eb 0a                	jmp    803ba4 <realloc_block_FF+0x208>
  803b9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b9d:	8b 00                	mov    (%eax),%eax
  803b9f:	a3 34 50 80 00       	mov    %eax,0x805034
  803ba4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bb7:	a1 40 50 80 00       	mov    0x805040,%eax
  803bbc:	48                   	dec    %eax
  803bbd:	a3 40 50 80 00       	mov    %eax,0x805040
  803bc2:	e9 83 02 00 00       	jmp    803e4a <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803bc7:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803bcb:	0f 86 69 02 00 00    	jbe    803e3a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803bd1:	83 ec 04             	sub    $0x4,%esp
  803bd4:	6a 01                	push   $0x1
  803bd6:	ff 75 f0             	pushl  -0x10(%ebp)
  803bd9:	ff 75 08             	pushl  0x8(%ebp)
  803bdc:	e8 c8 ed ff ff       	call   8029a9 <set_block_data>
  803be1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803be4:	8b 45 08             	mov    0x8(%ebp),%eax
  803be7:	83 e8 04             	sub    $0x4,%eax
  803bea:	8b 00                	mov    (%eax),%eax
  803bec:	83 e0 fe             	and    $0xfffffffe,%eax
  803bef:	89 c2                	mov    %eax,%edx
  803bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf4:	01 d0                	add    %edx,%eax
  803bf6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803bf9:	a1 40 50 80 00       	mov    0x805040,%eax
  803bfe:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803c01:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803c05:	75 68                	jne    803c6f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c07:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c0b:	75 17                	jne    803c24 <realloc_block_FF+0x288>
  803c0d:	83 ec 04             	sub    $0x4,%esp
  803c10:	68 ac 4c 80 00       	push   $0x804cac
  803c15:	68 06 02 00 00       	push   $0x206
  803c1a:	68 91 4c 80 00       	push   $0x804c91
  803c1f:	e8 8c cb ff ff       	call   8007b0 <_panic>
  803c24:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803c2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c2d:	89 10                	mov    %edx,(%eax)
  803c2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c32:	8b 00                	mov    (%eax),%eax
  803c34:	85 c0                	test   %eax,%eax
  803c36:	74 0d                	je     803c45 <realloc_block_FF+0x2a9>
  803c38:	a1 34 50 80 00       	mov    0x805034,%eax
  803c3d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c40:	89 50 04             	mov    %edx,0x4(%eax)
  803c43:	eb 08                	jmp    803c4d <realloc_block_FF+0x2b1>
  803c45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c48:	a3 38 50 80 00       	mov    %eax,0x805038
  803c4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c50:	a3 34 50 80 00       	mov    %eax,0x805034
  803c55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c5f:	a1 40 50 80 00       	mov    0x805040,%eax
  803c64:	40                   	inc    %eax
  803c65:	a3 40 50 80 00       	mov    %eax,0x805040
  803c6a:	e9 b0 01 00 00       	jmp    803e1f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803c6f:	a1 34 50 80 00       	mov    0x805034,%eax
  803c74:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c77:	76 68                	jbe    803ce1 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c79:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c7d:	75 17                	jne    803c96 <realloc_block_FF+0x2fa>
  803c7f:	83 ec 04             	sub    $0x4,%esp
  803c82:	68 ac 4c 80 00       	push   $0x804cac
  803c87:	68 0b 02 00 00       	push   $0x20b
  803c8c:	68 91 4c 80 00       	push   $0x804c91
  803c91:	e8 1a cb ff ff       	call   8007b0 <_panic>
  803c96:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803c9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c9f:	89 10                	mov    %edx,(%eax)
  803ca1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca4:	8b 00                	mov    (%eax),%eax
  803ca6:	85 c0                	test   %eax,%eax
  803ca8:	74 0d                	je     803cb7 <realloc_block_FF+0x31b>
  803caa:	a1 34 50 80 00       	mov    0x805034,%eax
  803caf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cb2:	89 50 04             	mov    %edx,0x4(%eax)
  803cb5:	eb 08                	jmp    803cbf <realloc_block_FF+0x323>
  803cb7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cba:	a3 38 50 80 00       	mov    %eax,0x805038
  803cbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc2:	a3 34 50 80 00       	mov    %eax,0x805034
  803cc7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cd1:	a1 40 50 80 00       	mov    0x805040,%eax
  803cd6:	40                   	inc    %eax
  803cd7:	a3 40 50 80 00       	mov    %eax,0x805040
  803cdc:	e9 3e 01 00 00       	jmp    803e1f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803ce1:	a1 34 50 80 00       	mov    0x805034,%eax
  803ce6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ce9:	73 68                	jae    803d53 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ceb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cef:	75 17                	jne    803d08 <realloc_block_FF+0x36c>
  803cf1:	83 ec 04             	sub    $0x4,%esp
  803cf4:	68 e0 4c 80 00       	push   $0x804ce0
  803cf9:	68 10 02 00 00       	push   $0x210
  803cfe:	68 91 4c 80 00       	push   $0x804c91
  803d03:	e8 a8 ca ff ff       	call   8007b0 <_panic>
  803d08:	8b 15 38 50 80 00    	mov    0x805038,%edx
  803d0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d11:	89 50 04             	mov    %edx,0x4(%eax)
  803d14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d17:	8b 40 04             	mov    0x4(%eax),%eax
  803d1a:	85 c0                	test   %eax,%eax
  803d1c:	74 0c                	je     803d2a <realloc_block_FF+0x38e>
  803d1e:	a1 38 50 80 00       	mov    0x805038,%eax
  803d23:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d26:	89 10                	mov    %edx,(%eax)
  803d28:	eb 08                	jmp    803d32 <realloc_block_FF+0x396>
  803d2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d2d:	a3 34 50 80 00       	mov    %eax,0x805034
  803d32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d35:	a3 38 50 80 00       	mov    %eax,0x805038
  803d3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d43:	a1 40 50 80 00       	mov    0x805040,%eax
  803d48:	40                   	inc    %eax
  803d49:	a3 40 50 80 00       	mov    %eax,0x805040
  803d4e:	e9 cc 00 00 00       	jmp    803e1f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803d53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803d5a:	a1 34 50 80 00       	mov    0x805034,%eax
  803d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d62:	e9 8a 00 00 00       	jmp    803df1 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d6d:	73 7a                	jae    803de9 <realloc_block_FF+0x44d>
  803d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d72:	8b 00                	mov    (%eax),%eax
  803d74:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d77:	73 70                	jae    803de9 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803d79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d7d:	74 06                	je     803d85 <realloc_block_FF+0x3e9>
  803d7f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d83:	75 17                	jne    803d9c <realloc_block_FF+0x400>
  803d85:	83 ec 04             	sub    $0x4,%esp
  803d88:	68 04 4d 80 00       	push   $0x804d04
  803d8d:	68 1a 02 00 00       	push   $0x21a
  803d92:	68 91 4c 80 00       	push   $0x804c91
  803d97:	e8 14 ca ff ff       	call   8007b0 <_panic>
  803d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d9f:	8b 10                	mov    (%eax),%edx
  803da1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803da4:	89 10                	mov    %edx,(%eax)
  803da6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803da9:	8b 00                	mov    (%eax),%eax
  803dab:	85 c0                	test   %eax,%eax
  803dad:	74 0b                	je     803dba <realloc_block_FF+0x41e>
  803daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db2:	8b 00                	mov    (%eax),%eax
  803db4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803db7:	89 50 04             	mov    %edx,0x4(%eax)
  803dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dc0:	89 10                	mov    %edx,(%eax)
  803dc2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dc8:	89 50 04             	mov    %edx,0x4(%eax)
  803dcb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dce:	8b 00                	mov    (%eax),%eax
  803dd0:	85 c0                	test   %eax,%eax
  803dd2:	75 08                	jne    803ddc <realloc_block_FF+0x440>
  803dd4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd7:	a3 38 50 80 00       	mov    %eax,0x805038
  803ddc:	a1 40 50 80 00       	mov    0x805040,%eax
  803de1:	40                   	inc    %eax
  803de2:	a3 40 50 80 00       	mov    %eax,0x805040
							break;
  803de7:	eb 36                	jmp    803e1f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803de9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803dee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803df1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803df5:	74 07                	je     803dfe <realloc_block_FF+0x462>
  803df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfa:	8b 00                	mov    (%eax),%eax
  803dfc:	eb 05                	jmp    803e03 <realloc_block_FF+0x467>
  803dfe:	b8 00 00 00 00       	mov    $0x0,%eax
  803e03:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803e08:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e0d:	85 c0                	test   %eax,%eax
  803e0f:	0f 85 52 ff ff ff    	jne    803d67 <realloc_block_FF+0x3cb>
  803e15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e19:	0f 85 48 ff ff ff    	jne    803d67 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803e1f:	83 ec 04             	sub    $0x4,%esp
  803e22:	6a 00                	push   $0x0
  803e24:	ff 75 d8             	pushl  -0x28(%ebp)
  803e27:	ff 75 d4             	pushl  -0x2c(%ebp)
  803e2a:	e8 7a eb ff ff       	call   8029a9 <set_block_data>
  803e2f:	83 c4 10             	add    $0x10,%esp
				return va;
  803e32:	8b 45 08             	mov    0x8(%ebp),%eax
  803e35:	e9 7b 02 00 00       	jmp    8040b5 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803e3a:	83 ec 0c             	sub    $0xc,%esp
  803e3d:	68 81 4d 80 00       	push   $0x804d81
  803e42:	e8 26 cc ff ff       	call   800a6d <cprintf>
  803e47:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4d:	e9 63 02 00 00       	jmp    8040b5 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e55:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803e58:	0f 86 4d 02 00 00    	jbe    8040ab <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803e5e:	83 ec 0c             	sub    $0xc,%esp
  803e61:	ff 75 e4             	pushl  -0x1c(%ebp)
  803e64:	e8 08 e8 ff ff       	call   802671 <is_free_block>
  803e69:	83 c4 10             	add    $0x10,%esp
  803e6c:	84 c0                	test   %al,%al
  803e6e:	0f 84 37 02 00 00    	je     8040ab <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e77:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803e7a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803e7d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e80:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e83:	76 38                	jbe    803ebd <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803e85:	83 ec 0c             	sub    $0xc,%esp
  803e88:	ff 75 08             	pushl  0x8(%ebp)
  803e8b:	e8 0c fa ff ff       	call   80389c <free_block>
  803e90:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803e93:	83 ec 0c             	sub    $0xc,%esp
  803e96:	ff 75 0c             	pushl  0xc(%ebp)
  803e99:	e8 3a eb ff ff       	call   8029d8 <alloc_block_FF>
  803e9e:	83 c4 10             	add    $0x10,%esp
  803ea1:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803ea4:	83 ec 08             	sub    $0x8,%esp
  803ea7:	ff 75 c0             	pushl  -0x40(%ebp)
  803eaa:	ff 75 08             	pushl  0x8(%ebp)
  803ead:	e8 ab fa ff ff       	call   80395d <copy_data>
  803eb2:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803eb5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803eb8:	e9 f8 01 00 00       	jmp    8040b5 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ec0:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803ec3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803ec6:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803eca:	0f 87 a0 00 00 00    	ja     803f70 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803ed0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ed4:	75 17                	jne    803eed <realloc_block_FF+0x551>
  803ed6:	83 ec 04             	sub    $0x4,%esp
  803ed9:	68 73 4c 80 00       	push   $0x804c73
  803ede:	68 38 02 00 00       	push   $0x238
  803ee3:	68 91 4c 80 00       	push   $0x804c91
  803ee8:	e8 c3 c8 ff ff       	call   8007b0 <_panic>
  803eed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef0:	8b 00                	mov    (%eax),%eax
  803ef2:	85 c0                	test   %eax,%eax
  803ef4:	74 10                	je     803f06 <realloc_block_FF+0x56a>
  803ef6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef9:	8b 00                	mov    (%eax),%eax
  803efb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803efe:	8b 52 04             	mov    0x4(%edx),%edx
  803f01:	89 50 04             	mov    %edx,0x4(%eax)
  803f04:	eb 0b                	jmp    803f11 <realloc_block_FF+0x575>
  803f06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f09:	8b 40 04             	mov    0x4(%eax),%eax
  803f0c:	a3 38 50 80 00       	mov    %eax,0x805038
  803f11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f14:	8b 40 04             	mov    0x4(%eax),%eax
  803f17:	85 c0                	test   %eax,%eax
  803f19:	74 0f                	je     803f2a <realloc_block_FF+0x58e>
  803f1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f1e:	8b 40 04             	mov    0x4(%eax),%eax
  803f21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f24:	8b 12                	mov    (%edx),%edx
  803f26:	89 10                	mov    %edx,(%eax)
  803f28:	eb 0a                	jmp    803f34 <realloc_block_FF+0x598>
  803f2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f2d:	8b 00                	mov    (%eax),%eax
  803f2f:	a3 34 50 80 00       	mov    %eax,0x805034
  803f34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f47:	a1 40 50 80 00       	mov    0x805040,%eax
  803f4c:	48                   	dec    %eax
  803f4d:	a3 40 50 80 00       	mov    %eax,0x805040

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803f52:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f58:	01 d0                	add    %edx,%eax
  803f5a:	83 ec 04             	sub    $0x4,%esp
  803f5d:	6a 01                	push   $0x1
  803f5f:	50                   	push   %eax
  803f60:	ff 75 08             	pushl  0x8(%ebp)
  803f63:	e8 41 ea ff ff       	call   8029a9 <set_block_data>
  803f68:	83 c4 10             	add    $0x10,%esp
  803f6b:	e9 36 01 00 00       	jmp    8040a6 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803f70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f73:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f76:	01 d0                	add    %edx,%eax
  803f78:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803f7b:	83 ec 04             	sub    $0x4,%esp
  803f7e:	6a 01                	push   $0x1
  803f80:	ff 75 f0             	pushl  -0x10(%ebp)
  803f83:	ff 75 08             	pushl  0x8(%ebp)
  803f86:	e8 1e ea ff ff       	call   8029a9 <set_block_data>
  803f8b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  803f91:	83 e8 04             	sub    $0x4,%eax
  803f94:	8b 00                	mov    (%eax),%eax
  803f96:	83 e0 fe             	and    $0xfffffffe,%eax
  803f99:	89 c2                	mov    %eax,%edx
  803f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f9e:	01 d0                	add    %edx,%eax
  803fa0:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803fa3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fa7:	74 06                	je     803faf <realloc_block_FF+0x613>
  803fa9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803fad:	75 17                	jne    803fc6 <realloc_block_FF+0x62a>
  803faf:	83 ec 04             	sub    $0x4,%esp
  803fb2:	68 04 4d 80 00       	push   $0x804d04
  803fb7:	68 44 02 00 00       	push   $0x244
  803fbc:	68 91 4c 80 00       	push   $0x804c91
  803fc1:	e8 ea c7 ff ff       	call   8007b0 <_panic>
  803fc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc9:	8b 10                	mov    (%eax),%edx
  803fcb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fce:	89 10                	mov    %edx,(%eax)
  803fd0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fd3:	8b 00                	mov    (%eax),%eax
  803fd5:	85 c0                	test   %eax,%eax
  803fd7:	74 0b                	je     803fe4 <realloc_block_FF+0x648>
  803fd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fdc:	8b 00                	mov    (%eax),%eax
  803fde:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803fe1:	89 50 04             	mov    %edx,0x4(%eax)
  803fe4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803fea:	89 10                	mov    %edx,(%eax)
  803fec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ff2:	89 50 04             	mov    %edx,0x4(%eax)
  803ff5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ff8:	8b 00                	mov    (%eax),%eax
  803ffa:	85 c0                	test   %eax,%eax
  803ffc:	75 08                	jne    804006 <realloc_block_FF+0x66a>
  803ffe:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804001:	a3 38 50 80 00       	mov    %eax,0x805038
  804006:	a1 40 50 80 00       	mov    0x805040,%eax
  80400b:	40                   	inc    %eax
  80400c:	a3 40 50 80 00       	mov    %eax,0x805040
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804011:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804015:	75 17                	jne    80402e <realloc_block_FF+0x692>
  804017:	83 ec 04             	sub    $0x4,%esp
  80401a:	68 73 4c 80 00       	push   $0x804c73
  80401f:	68 45 02 00 00       	push   $0x245
  804024:	68 91 4c 80 00       	push   $0x804c91
  804029:	e8 82 c7 ff ff       	call   8007b0 <_panic>
  80402e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804031:	8b 00                	mov    (%eax),%eax
  804033:	85 c0                	test   %eax,%eax
  804035:	74 10                	je     804047 <realloc_block_FF+0x6ab>
  804037:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80403a:	8b 00                	mov    (%eax),%eax
  80403c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80403f:	8b 52 04             	mov    0x4(%edx),%edx
  804042:	89 50 04             	mov    %edx,0x4(%eax)
  804045:	eb 0b                	jmp    804052 <realloc_block_FF+0x6b6>
  804047:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80404a:	8b 40 04             	mov    0x4(%eax),%eax
  80404d:	a3 38 50 80 00       	mov    %eax,0x805038
  804052:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804055:	8b 40 04             	mov    0x4(%eax),%eax
  804058:	85 c0                	test   %eax,%eax
  80405a:	74 0f                	je     80406b <realloc_block_FF+0x6cf>
  80405c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80405f:	8b 40 04             	mov    0x4(%eax),%eax
  804062:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804065:	8b 12                	mov    (%edx),%edx
  804067:	89 10                	mov    %edx,(%eax)
  804069:	eb 0a                	jmp    804075 <realloc_block_FF+0x6d9>
  80406b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80406e:	8b 00                	mov    (%eax),%eax
  804070:	a3 34 50 80 00       	mov    %eax,0x805034
  804075:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804078:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80407e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804081:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804088:	a1 40 50 80 00       	mov    0x805040,%eax
  80408d:	48                   	dec    %eax
  80408e:	a3 40 50 80 00       	mov    %eax,0x805040
				set_block_data(next_new_va, remaining_size, 0);
  804093:	83 ec 04             	sub    $0x4,%esp
  804096:	6a 00                	push   $0x0
  804098:	ff 75 bc             	pushl  -0x44(%ebp)
  80409b:	ff 75 b8             	pushl  -0x48(%ebp)
  80409e:	e8 06 e9 ff ff       	call   8029a9 <set_block_data>
  8040a3:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8040a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8040a9:	eb 0a                	jmp    8040b5 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8040ab:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8040b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8040b5:	c9                   	leave  
  8040b6:	c3                   	ret    

008040b7 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8040b7:	55                   	push   %ebp
  8040b8:	89 e5                	mov    %esp,%ebp
  8040ba:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8040bd:	83 ec 04             	sub    $0x4,%esp
  8040c0:	68 88 4d 80 00       	push   $0x804d88
  8040c5:	68 58 02 00 00       	push   $0x258
  8040ca:	68 91 4c 80 00       	push   $0x804c91
  8040cf:	e8 dc c6 ff ff       	call   8007b0 <_panic>

008040d4 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8040d4:	55                   	push   %ebp
  8040d5:	89 e5                	mov    %esp,%ebp
  8040d7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8040da:	83 ec 04             	sub    $0x4,%esp
  8040dd:	68 b0 4d 80 00       	push   $0x804db0
  8040e2:	68 61 02 00 00       	push   $0x261
  8040e7:	68 91 4c 80 00       	push   $0x804c91
  8040ec:	e8 bf c6 ff ff       	call   8007b0 <_panic>

008040f1 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8040f1:	55                   	push   %ebp
  8040f2:	89 e5                	mov    %esp,%ebp
  8040f4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8040f7:	83 ec 04             	sub    $0x4,%esp
  8040fa:	68 d8 4d 80 00       	push   $0x804dd8
  8040ff:	6a 09                	push   $0x9
  804101:	68 00 4e 80 00       	push   $0x804e00
  804106:	e8 a5 c6 ff ff       	call   8007b0 <_panic>

0080410b <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80410b:	55                   	push   %ebp
  80410c:	89 e5                	mov    %esp,%ebp
  80410e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  804111:	83 ec 04             	sub    $0x4,%esp
  804114:	68 10 4e 80 00       	push   $0x804e10
  804119:	6a 10                	push   $0x10
  80411b:	68 00 4e 80 00       	push   $0x804e00
  804120:	e8 8b c6 ff ff       	call   8007b0 <_panic>

00804125 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  804125:	55                   	push   %ebp
  804126:	89 e5                	mov    %esp,%ebp
  804128:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  80412b:	83 ec 04             	sub    $0x4,%esp
  80412e:	68 38 4e 80 00       	push   $0x804e38
  804133:	6a 18                	push   $0x18
  804135:	68 00 4e 80 00       	push   $0x804e00
  80413a:	e8 71 c6 ff ff       	call   8007b0 <_panic>

0080413f <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80413f:	55                   	push   %ebp
  804140:	89 e5                	mov    %esp,%ebp
  804142:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  804145:	83 ec 04             	sub    $0x4,%esp
  804148:	68 60 4e 80 00       	push   $0x804e60
  80414d:	6a 20                	push   $0x20
  80414f:	68 00 4e 80 00       	push   $0x804e00
  804154:	e8 57 c6 ff ff       	call   8007b0 <_panic>

00804159 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  804159:	55                   	push   %ebp
  80415a:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80415c:	8b 45 08             	mov    0x8(%ebp),%eax
  80415f:	8b 40 10             	mov    0x10(%eax),%eax
}
  804162:	5d                   	pop    %ebp
  804163:	c3                   	ret    

00804164 <__udivdi3>:
  804164:	55                   	push   %ebp
  804165:	57                   	push   %edi
  804166:	56                   	push   %esi
  804167:	53                   	push   %ebx
  804168:	83 ec 1c             	sub    $0x1c,%esp
  80416b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80416f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804173:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804177:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80417b:	89 ca                	mov    %ecx,%edx
  80417d:	89 f8                	mov    %edi,%eax
  80417f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804183:	85 f6                	test   %esi,%esi
  804185:	75 2d                	jne    8041b4 <__udivdi3+0x50>
  804187:	39 cf                	cmp    %ecx,%edi
  804189:	77 65                	ja     8041f0 <__udivdi3+0x8c>
  80418b:	89 fd                	mov    %edi,%ebp
  80418d:	85 ff                	test   %edi,%edi
  80418f:	75 0b                	jne    80419c <__udivdi3+0x38>
  804191:	b8 01 00 00 00       	mov    $0x1,%eax
  804196:	31 d2                	xor    %edx,%edx
  804198:	f7 f7                	div    %edi
  80419a:	89 c5                	mov    %eax,%ebp
  80419c:	31 d2                	xor    %edx,%edx
  80419e:	89 c8                	mov    %ecx,%eax
  8041a0:	f7 f5                	div    %ebp
  8041a2:	89 c1                	mov    %eax,%ecx
  8041a4:	89 d8                	mov    %ebx,%eax
  8041a6:	f7 f5                	div    %ebp
  8041a8:	89 cf                	mov    %ecx,%edi
  8041aa:	89 fa                	mov    %edi,%edx
  8041ac:	83 c4 1c             	add    $0x1c,%esp
  8041af:	5b                   	pop    %ebx
  8041b0:	5e                   	pop    %esi
  8041b1:	5f                   	pop    %edi
  8041b2:	5d                   	pop    %ebp
  8041b3:	c3                   	ret    
  8041b4:	39 ce                	cmp    %ecx,%esi
  8041b6:	77 28                	ja     8041e0 <__udivdi3+0x7c>
  8041b8:	0f bd fe             	bsr    %esi,%edi
  8041bb:	83 f7 1f             	xor    $0x1f,%edi
  8041be:	75 40                	jne    804200 <__udivdi3+0x9c>
  8041c0:	39 ce                	cmp    %ecx,%esi
  8041c2:	72 0a                	jb     8041ce <__udivdi3+0x6a>
  8041c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8041c8:	0f 87 9e 00 00 00    	ja     80426c <__udivdi3+0x108>
  8041ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8041d3:	89 fa                	mov    %edi,%edx
  8041d5:	83 c4 1c             	add    $0x1c,%esp
  8041d8:	5b                   	pop    %ebx
  8041d9:	5e                   	pop    %esi
  8041da:	5f                   	pop    %edi
  8041db:	5d                   	pop    %ebp
  8041dc:	c3                   	ret    
  8041dd:	8d 76 00             	lea    0x0(%esi),%esi
  8041e0:	31 ff                	xor    %edi,%edi
  8041e2:	31 c0                	xor    %eax,%eax
  8041e4:	89 fa                	mov    %edi,%edx
  8041e6:	83 c4 1c             	add    $0x1c,%esp
  8041e9:	5b                   	pop    %ebx
  8041ea:	5e                   	pop    %esi
  8041eb:	5f                   	pop    %edi
  8041ec:	5d                   	pop    %ebp
  8041ed:	c3                   	ret    
  8041ee:	66 90                	xchg   %ax,%ax
  8041f0:	89 d8                	mov    %ebx,%eax
  8041f2:	f7 f7                	div    %edi
  8041f4:	31 ff                	xor    %edi,%edi
  8041f6:	89 fa                	mov    %edi,%edx
  8041f8:	83 c4 1c             	add    $0x1c,%esp
  8041fb:	5b                   	pop    %ebx
  8041fc:	5e                   	pop    %esi
  8041fd:	5f                   	pop    %edi
  8041fe:	5d                   	pop    %ebp
  8041ff:	c3                   	ret    
  804200:	bd 20 00 00 00       	mov    $0x20,%ebp
  804205:	89 eb                	mov    %ebp,%ebx
  804207:	29 fb                	sub    %edi,%ebx
  804209:	89 f9                	mov    %edi,%ecx
  80420b:	d3 e6                	shl    %cl,%esi
  80420d:	89 c5                	mov    %eax,%ebp
  80420f:	88 d9                	mov    %bl,%cl
  804211:	d3 ed                	shr    %cl,%ebp
  804213:	89 e9                	mov    %ebp,%ecx
  804215:	09 f1                	or     %esi,%ecx
  804217:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80421b:	89 f9                	mov    %edi,%ecx
  80421d:	d3 e0                	shl    %cl,%eax
  80421f:	89 c5                	mov    %eax,%ebp
  804221:	89 d6                	mov    %edx,%esi
  804223:	88 d9                	mov    %bl,%cl
  804225:	d3 ee                	shr    %cl,%esi
  804227:	89 f9                	mov    %edi,%ecx
  804229:	d3 e2                	shl    %cl,%edx
  80422b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80422f:	88 d9                	mov    %bl,%cl
  804231:	d3 e8                	shr    %cl,%eax
  804233:	09 c2                	or     %eax,%edx
  804235:	89 d0                	mov    %edx,%eax
  804237:	89 f2                	mov    %esi,%edx
  804239:	f7 74 24 0c          	divl   0xc(%esp)
  80423d:	89 d6                	mov    %edx,%esi
  80423f:	89 c3                	mov    %eax,%ebx
  804241:	f7 e5                	mul    %ebp
  804243:	39 d6                	cmp    %edx,%esi
  804245:	72 19                	jb     804260 <__udivdi3+0xfc>
  804247:	74 0b                	je     804254 <__udivdi3+0xf0>
  804249:	89 d8                	mov    %ebx,%eax
  80424b:	31 ff                	xor    %edi,%edi
  80424d:	e9 58 ff ff ff       	jmp    8041aa <__udivdi3+0x46>
  804252:	66 90                	xchg   %ax,%ax
  804254:	8b 54 24 08          	mov    0x8(%esp),%edx
  804258:	89 f9                	mov    %edi,%ecx
  80425a:	d3 e2                	shl    %cl,%edx
  80425c:	39 c2                	cmp    %eax,%edx
  80425e:	73 e9                	jae    804249 <__udivdi3+0xe5>
  804260:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804263:	31 ff                	xor    %edi,%edi
  804265:	e9 40 ff ff ff       	jmp    8041aa <__udivdi3+0x46>
  80426a:	66 90                	xchg   %ax,%ax
  80426c:	31 c0                	xor    %eax,%eax
  80426e:	e9 37 ff ff ff       	jmp    8041aa <__udivdi3+0x46>
  804273:	90                   	nop

00804274 <__umoddi3>:
  804274:	55                   	push   %ebp
  804275:	57                   	push   %edi
  804276:	56                   	push   %esi
  804277:	53                   	push   %ebx
  804278:	83 ec 1c             	sub    $0x1c,%esp
  80427b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80427f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804283:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804287:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80428b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80428f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804293:	89 f3                	mov    %esi,%ebx
  804295:	89 fa                	mov    %edi,%edx
  804297:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80429b:	89 34 24             	mov    %esi,(%esp)
  80429e:	85 c0                	test   %eax,%eax
  8042a0:	75 1a                	jne    8042bc <__umoddi3+0x48>
  8042a2:	39 f7                	cmp    %esi,%edi
  8042a4:	0f 86 a2 00 00 00    	jbe    80434c <__umoddi3+0xd8>
  8042aa:	89 c8                	mov    %ecx,%eax
  8042ac:	89 f2                	mov    %esi,%edx
  8042ae:	f7 f7                	div    %edi
  8042b0:	89 d0                	mov    %edx,%eax
  8042b2:	31 d2                	xor    %edx,%edx
  8042b4:	83 c4 1c             	add    $0x1c,%esp
  8042b7:	5b                   	pop    %ebx
  8042b8:	5e                   	pop    %esi
  8042b9:	5f                   	pop    %edi
  8042ba:	5d                   	pop    %ebp
  8042bb:	c3                   	ret    
  8042bc:	39 f0                	cmp    %esi,%eax
  8042be:	0f 87 ac 00 00 00    	ja     804370 <__umoddi3+0xfc>
  8042c4:	0f bd e8             	bsr    %eax,%ebp
  8042c7:	83 f5 1f             	xor    $0x1f,%ebp
  8042ca:	0f 84 ac 00 00 00    	je     80437c <__umoddi3+0x108>
  8042d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8042d5:	29 ef                	sub    %ebp,%edi
  8042d7:	89 fe                	mov    %edi,%esi
  8042d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8042dd:	89 e9                	mov    %ebp,%ecx
  8042df:	d3 e0                	shl    %cl,%eax
  8042e1:	89 d7                	mov    %edx,%edi
  8042e3:	89 f1                	mov    %esi,%ecx
  8042e5:	d3 ef                	shr    %cl,%edi
  8042e7:	09 c7                	or     %eax,%edi
  8042e9:	89 e9                	mov    %ebp,%ecx
  8042eb:	d3 e2                	shl    %cl,%edx
  8042ed:	89 14 24             	mov    %edx,(%esp)
  8042f0:	89 d8                	mov    %ebx,%eax
  8042f2:	d3 e0                	shl    %cl,%eax
  8042f4:	89 c2                	mov    %eax,%edx
  8042f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042fa:	d3 e0                	shl    %cl,%eax
  8042fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  804300:	8b 44 24 08          	mov    0x8(%esp),%eax
  804304:	89 f1                	mov    %esi,%ecx
  804306:	d3 e8                	shr    %cl,%eax
  804308:	09 d0                	or     %edx,%eax
  80430a:	d3 eb                	shr    %cl,%ebx
  80430c:	89 da                	mov    %ebx,%edx
  80430e:	f7 f7                	div    %edi
  804310:	89 d3                	mov    %edx,%ebx
  804312:	f7 24 24             	mull   (%esp)
  804315:	89 c6                	mov    %eax,%esi
  804317:	89 d1                	mov    %edx,%ecx
  804319:	39 d3                	cmp    %edx,%ebx
  80431b:	0f 82 87 00 00 00    	jb     8043a8 <__umoddi3+0x134>
  804321:	0f 84 91 00 00 00    	je     8043b8 <__umoddi3+0x144>
  804327:	8b 54 24 04          	mov    0x4(%esp),%edx
  80432b:	29 f2                	sub    %esi,%edx
  80432d:	19 cb                	sbb    %ecx,%ebx
  80432f:	89 d8                	mov    %ebx,%eax
  804331:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804335:	d3 e0                	shl    %cl,%eax
  804337:	89 e9                	mov    %ebp,%ecx
  804339:	d3 ea                	shr    %cl,%edx
  80433b:	09 d0                	or     %edx,%eax
  80433d:	89 e9                	mov    %ebp,%ecx
  80433f:	d3 eb                	shr    %cl,%ebx
  804341:	89 da                	mov    %ebx,%edx
  804343:	83 c4 1c             	add    $0x1c,%esp
  804346:	5b                   	pop    %ebx
  804347:	5e                   	pop    %esi
  804348:	5f                   	pop    %edi
  804349:	5d                   	pop    %ebp
  80434a:	c3                   	ret    
  80434b:	90                   	nop
  80434c:	89 fd                	mov    %edi,%ebp
  80434e:	85 ff                	test   %edi,%edi
  804350:	75 0b                	jne    80435d <__umoddi3+0xe9>
  804352:	b8 01 00 00 00       	mov    $0x1,%eax
  804357:	31 d2                	xor    %edx,%edx
  804359:	f7 f7                	div    %edi
  80435b:	89 c5                	mov    %eax,%ebp
  80435d:	89 f0                	mov    %esi,%eax
  80435f:	31 d2                	xor    %edx,%edx
  804361:	f7 f5                	div    %ebp
  804363:	89 c8                	mov    %ecx,%eax
  804365:	f7 f5                	div    %ebp
  804367:	89 d0                	mov    %edx,%eax
  804369:	e9 44 ff ff ff       	jmp    8042b2 <__umoddi3+0x3e>
  80436e:	66 90                	xchg   %ax,%ax
  804370:	89 c8                	mov    %ecx,%eax
  804372:	89 f2                	mov    %esi,%edx
  804374:	83 c4 1c             	add    $0x1c,%esp
  804377:	5b                   	pop    %ebx
  804378:	5e                   	pop    %esi
  804379:	5f                   	pop    %edi
  80437a:	5d                   	pop    %ebp
  80437b:	c3                   	ret    
  80437c:	3b 04 24             	cmp    (%esp),%eax
  80437f:	72 06                	jb     804387 <__umoddi3+0x113>
  804381:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804385:	77 0f                	ja     804396 <__umoddi3+0x122>
  804387:	89 f2                	mov    %esi,%edx
  804389:	29 f9                	sub    %edi,%ecx
  80438b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80438f:	89 14 24             	mov    %edx,(%esp)
  804392:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804396:	8b 44 24 04          	mov    0x4(%esp),%eax
  80439a:	8b 14 24             	mov    (%esp),%edx
  80439d:	83 c4 1c             	add    $0x1c,%esp
  8043a0:	5b                   	pop    %ebx
  8043a1:	5e                   	pop    %esi
  8043a2:	5f                   	pop    %edi
  8043a3:	5d                   	pop    %ebp
  8043a4:	c3                   	ret    
  8043a5:	8d 76 00             	lea    0x0(%esi),%esi
  8043a8:	2b 04 24             	sub    (%esp),%eax
  8043ab:	19 fa                	sbb    %edi,%edx
  8043ad:	89 d1                	mov    %edx,%ecx
  8043af:	89 c6                	mov    %eax,%esi
  8043b1:	e9 71 ff ff ff       	jmp    804327 <__umoddi3+0xb3>
  8043b6:	66 90                	xchg   %ax,%ax
  8043b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8043bc:	72 ea                	jb     8043a8 <__umoddi3+0x134>
  8043be:	89 d9                	mov    %ebx,%ecx
  8043c0:	e9 62 ff ff ff       	jmp    804327 <__umoddi3+0xb3>
