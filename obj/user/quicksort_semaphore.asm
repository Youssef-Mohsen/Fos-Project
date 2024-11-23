
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
  800042:	e8 60 21 00 00       	call   8021a7 <sys_getenvid>
  800047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  80004a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	IO_CS = create_semaphore("IO.CS", 1);
  800051:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	6a 01                	push   $0x1
  80005c:	68 80 42 80 00       	push   $0x804280
  800061:	50                   	push   %eax
  800062:	e8 32 3f 00 00       	call   803f99 <create_semaphore>
  800067:	83 c4 0c             	add    $0xc,%esp
  80006a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800070:	a3 44 50 80 00       	mov    %eax,0x805044
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800075:	e8 7d 1f 00 00       	call   801ff7 <sys_calculate_free_frames>
  80007a:	89 c3                	mov    %eax,%ebx
  80007c:	e8 8f 1f 00 00       	call   802010 <sys_calculate_modified_frames>
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
  800092:	e8 36 3f 00 00       	call   803fcd <wait_semaphore>
  800097:	83 c4 10             	add    $0x10,%esp
		{
			readline("Enter the number of elements: ", Line);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000a3:	50                   	push   %eax
  8000a4:	68 88 42 80 00       	push   $0x804288
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
  8000e2:	68 a8 42 80 00       	push   $0x8042a8
  8000e7:	e8 81 09 00 00       	call   800a6d <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 cb 42 80 00       	push   $0x8042cb
  8000f7:	e8 71 09 00 00       	call   800a6d <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 d9 42 80 00       	push   $0x8042d9
  800107:	e8 61 09 00 00       	call   800a6d <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 e8 42 80 00       	push   $0x8042e8
  800117:	e8 51 09 00 00       	call   800a6d <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 f8 42 80 00       	push   $0x8042f8
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
  80016f:	e8 73 3e 00 00       	call   803fe7 <signal_semaphore>
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
  800202:	68 04 43 80 00       	push   $0x804304
  800207:	6a 4d                	push   $0x4d
  800209:	68 26 43 80 00       	push   $0x804326
  80020e:	e8 9d 05 00 00       	call   8007b0 <_panic>
		else
		{
			wait_semaphore(IO_CS);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	ff 35 44 50 80 00    	pushl  0x805044
  80021c:	e8 ac 3d 00 00       	call   803fcd <wait_semaphore>
  800221:	83 c4 10             	add    $0x10,%esp
				cprintf("\n===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 44 43 80 00       	push   $0x804344
  80022c:	e8 3c 08 00 00       	call   800a6d <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 78 43 80 00       	push   $0x804378
  80023c:	e8 2c 08 00 00       	call   800a6d <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 ac 43 80 00       	push   $0x8043ac
  80024c:	e8 1c 08 00 00       	call   800a6d <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			signal_semaphore(IO_CS);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	ff 35 44 50 80 00    	pushl  0x805044
  80025d:	e8 85 3d 00 00       	call   803fe7 <signal_semaphore>
  800262:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		wait_semaphore(IO_CS);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 35 44 50 80 00    	pushl  0x805044
  80026e:	e8 5a 3d 00 00       	call   803fcd <wait_semaphore>
  800273:	83 c4 10             	add    $0x10,%esp
			cprintf("Freeing the Heap...\n\n") ;
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 de 43 80 00       	push   $0x8043de
  80027e:	e8 ea 07 00 00       	call   800a6d <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
		signal_semaphore(IO_CS);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 35 44 50 80 00    	pushl  0x805044
  80028f:	e8 53 3d 00 00       	call   803fe7 <signal_semaphore>
  800294:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		wait_semaphore(IO_CS);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 35 44 50 80 00    	pushl  0x805044
  8002a0:	e8 28 3d 00 00       	call   803fcd <wait_semaphore>
  8002a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Do you want to repeat (y/n): ") ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 f4 43 80 00       	push   $0x8043f4
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
  8002f3:	e8 ef 3c 00 00       	call   803fe7 <signal_semaphore>
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
  80058b:	e8 17 1c 00 00       	call   8021a7 <sys_getenvid>
  800590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	wait_semaphore(IO_CS);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 35 44 50 80 00    	pushl  0x805044
  80059c:	e8 2c 3a 00 00       	call   803fcd <wait_semaphore>
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
  8005c4:	68 12 44 80 00       	push   $0x804412
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
  8005e6:	68 14 44 80 00       	push   $0x804414
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
  800614:	68 19 44 80 00       	push   $0x804419
  800619:	e8 4f 04 00 00       	call   800a6d <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(IO_CS);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	ff 35 44 50 80 00    	pushl  0x805044
  80062a:	e8 b8 39 00 00       	call   803fe7 <signal_semaphore>
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
  800649:	e8 41 1a 00 00       	call   80208f <sys_cputc>
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
  80065a:	e8 cc 18 00 00       	call   801f2b <sys_cgetc>
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
  800677:	e8 44 1b 00 00       	call   8021c0 <sys_getenvindex>
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
  8006e5:	e8 5a 18 00 00       	call   801f44 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	68 38 44 80 00       	push   $0x804438
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
  800715:	68 60 44 80 00       	push   $0x804460
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
  800746:	68 88 44 80 00       	push   $0x804488
  80074b:	e8 1d 03 00 00       	call   800a6d <cprintf>
  800750:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800753:	a1 24 50 80 00       	mov    0x805024,%eax
  800758:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	50                   	push   %eax
  800762:	68 e0 44 80 00       	push   $0x8044e0
  800767:	e8 01 03 00 00       	call   800a6d <cprintf>
  80076c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80076f:	83 ec 0c             	sub    $0xc,%esp
  800772:	68 38 44 80 00       	push   $0x804438
  800777:	e8 f1 02 00 00       	call   800a6d <cprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80077f:	e8 da 17 00 00       	call   801f5e <sys_unlock_cons>
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
  800797:	e8 f0 19 00 00       	call   80218c <sys_destroy_env>
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
  8007a8:	e8 45 1a 00 00       	call   8021f2 <sys_exit_env>
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
  8007d1:	68 f4 44 80 00       	push   $0x8044f4
  8007d6:	e8 92 02 00 00       	call   800a6d <cprintf>
  8007db:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007de:	a1 00 50 80 00       	mov    0x805000,%eax
  8007e3:	ff 75 0c             	pushl  0xc(%ebp)
  8007e6:	ff 75 08             	pushl  0x8(%ebp)
  8007e9:	50                   	push   %eax
  8007ea:	68 f9 44 80 00       	push   $0x8044f9
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
  80080e:	68 15 45 80 00       	push   $0x804515
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
  80083d:	68 18 45 80 00       	push   $0x804518
  800842:	6a 26                	push   $0x26
  800844:	68 64 45 80 00       	push   $0x804564
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
  800912:	68 70 45 80 00       	push   $0x804570
  800917:	6a 3a                	push   $0x3a
  800919:	68 64 45 80 00       	push   $0x804564
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
  800985:	68 c4 45 80 00       	push   $0x8045c4
  80098a:	6a 44                	push   $0x44
  80098c:	68 64 45 80 00       	push   $0x804564
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
  8009df:	e8 1e 15 00 00       	call   801f02 <sys_cputs>
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
  800a56:	e8 a7 14 00 00       	call   801f02 <sys_cputs>
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
  800aa0:	e8 9f 14 00 00       	call   801f44 <sys_lock_cons>
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
  800ac0:	e8 99 14 00 00       	call   801f5e <sys_unlock_cons>
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
  800b0a:	e8 fd 34 00 00       	call   80400c <__udivdi3>
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
  800b5a:	e8 bd 35 00 00       	call   80411c <__umoddi3>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	05 34 48 80 00       	add    $0x804834,%eax
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
  800cb5:	8b 04 85 58 48 80 00 	mov    0x804858(,%eax,4),%eax
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
  800d96:	8b 34 9d a0 46 80 00 	mov    0x8046a0(,%ebx,4),%esi
  800d9d:	85 f6                	test   %esi,%esi
  800d9f:	75 19                	jne    800dba <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da1:	53                   	push   %ebx
  800da2:	68 45 48 80 00       	push   $0x804845
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
  800dbb:	68 4e 48 80 00       	push   $0x80484e
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
  800de8:	be 51 48 80 00       	mov    $0x804851,%esi
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
  801113:	68 c8 49 80 00       	push   $0x8049c8
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
  801155:	68 cb 49 80 00       	push   $0x8049cb
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
  801206:	e8 39 0d 00 00       	call   801f44 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80120b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80120f:	74 13                	je     801224 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	ff 75 08             	pushl  0x8(%ebp)
  801217:	68 c8 49 80 00       	push   $0x8049c8
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
  801259:	68 cb 49 80 00       	push   $0x8049cb
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
  801301:	e8 58 0c 00 00       	call   801f5e <sys_unlock_cons>
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
  8019fb:	68 dc 49 80 00       	push   $0x8049dc
  801a00:	68 3f 01 00 00       	push   $0x13f
  801a05:	68 fe 49 80 00       	push   $0x8049fe
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
  801a1b:	e8 8d 0a 00 00       	call   8024ad <sys_sbrk>
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
  801a96:	e8 96 08 00 00       	call   802331 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	74 16                	je     801ab5 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a9f:	83 ec 0c             	sub    $0xc,%esp
  801aa2:	ff 75 08             	pushl  0x8(%ebp)
  801aa5:	e8 d6 0d 00 00       	call   802880 <alloc_block_FF>
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ab0:	e9 8a 01 00 00       	jmp    801c3f <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801ab5:	e8 a8 08 00 00       	call   802362 <sys_isUHeapPlacementStrategyBESTFIT>
  801aba:	85 c0                	test   %eax,%eax
  801abc:	0f 84 7d 01 00 00    	je     801c3f <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801ac2:	83 ec 0c             	sub    $0xc,%esp
  801ac5:	ff 75 08             	pushl  0x8(%ebp)
  801ac8:	e8 6f 12 00 00       	call   802d3c <alloc_block_BF>
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
  801b18:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801b65:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801bbc:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  801c1e:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801c25:	83 ec 08             	sub    $0x8,%esp
  801c28:	ff 75 08             	pushl  0x8(%ebp)
  801c2b:	ff 75 f0             	pushl  -0x10(%ebp)
  801c2e:	e8 b1 08 00 00       	call   8024e4 <sys_allocate_user_mem>
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
  801c76:	e8 85 08 00 00       	call   802500 <get_block_size>
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c81:	83 ec 0c             	sub    $0xc,%esp
  801c84:	ff 75 08             	pushl  0x8(%ebp)
  801c87:	e8 b8 1a 00 00       	call   803744 <free_block>
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
  801cc1:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801cfe:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
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
  801d1e:	e8 a5 07 00 00       	call   8024c8 <sys_free_user_mem>
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
  801d2c:	68 0c 4a 80 00       	push   $0x804a0c
  801d31:	68 84 00 00 00       	push   $0x84
  801d36:	68 36 4a 80 00       	push   $0x804a36
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
  801d52:	75 07                	jne    801d5b <smalloc+0x19>
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
  801d59:	eb 64                	jmp    801dbf <smalloc+0x7d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d61:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6e:	39 d0                	cmp    %edx,%eax
  801d70:	73 02                	jae    801d74 <smalloc+0x32>
  801d72:	89 d0                	mov    %edx,%eax
  801d74:	83 ec 0c             	sub    $0xc,%esp
  801d77:	50                   	push   %eax
  801d78:	e8 a8 fc ff ff       	call   801a25 <malloc>
  801d7d:	83 c4 10             	add    $0x10,%esp
  801d80:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801d83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d87:	75 07                	jne    801d90 <smalloc+0x4e>
  801d89:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8e:	eb 2f                	jmp    801dbf <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d90:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d94:	ff 75 ec             	pushl  -0x14(%ebp)
  801d97:	50                   	push   %eax
  801d98:	ff 75 0c             	pushl  0xc(%ebp)
  801d9b:	ff 75 08             	pushl  0x8(%ebp)
  801d9e:	e8 2c 03 00 00       	call   8020cf <sys_createSharedObject>
  801da3:	83 c4 10             	add    $0x10,%esp
  801da6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801da9:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801dad:	74 06                	je     801db5 <smalloc+0x73>
  801daf:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801db3:	75 07                	jne    801dbc <smalloc+0x7a>
  801db5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dba:	eb 03                	jmp    801dbf <smalloc+0x7d>
	 return ptr;
  801dbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801dc7:	83 ec 08             	sub    $0x8,%esp
  801dca:	ff 75 0c             	pushl  0xc(%ebp)
  801dcd:	ff 75 08             	pushl  0x8(%ebp)
  801dd0:	e8 24 03 00 00       	call   8020f9 <sys_getSizeOfSharedObject>
  801dd5:	83 c4 10             	add    $0x10,%esp
  801dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801ddb:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801ddf:	75 07                	jne    801de8 <sget+0x27>
  801de1:	b8 00 00 00 00       	mov    $0x0,%eax
  801de6:	eb 5c                	jmp    801e44 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801deb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801dee:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801df5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dfb:	39 d0                	cmp    %edx,%eax
  801dfd:	7d 02                	jge    801e01 <sget+0x40>
  801dff:	89 d0                	mov    %edx,%eax
  801e01:	83 ec 0c             	sub    $0xc,%esp
  801e04:	50                   	push   %eax
  801e05:	e8 1b fc ff ff       	call   801a25 <malloc>
  801e0a:	83 c4 10             	add    $0x10,%esp
  801e0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801e10:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e14:	75 07                	jne    801e1d <sget+0x5c>
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1b:	eb 27                	jmp    801e44 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801e1d:	83 ec 04             	sub    $0x4,%esp
  801e20:	ff 75 e8             	pushl  -0x18(%ebp)
  801e23:	ff 75 0c             	pushl  0xc(%ebp)
  801e26:	ff 75 08             	pushl  0x8(%ebp)
  801e29:	e8 e8 02 00 00       	call   802116 <sys_getSharedObject>
  801e2e:	83 c4 10             	add    $0x10,%esp
  801e31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801e34:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801e38:	75 07                	jne    801e41 <sget+0x80>
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3f:	eb 03                	jmp    801e44 <sget+0x83>
	return ptr;
  801e41:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e4c:	83 ec 04             	sub    $0x4,%esp
  801e4f:	68 44 4a 80 00       	push   $0x804a44
  801e54:	68 c1 00 00 00       	push   $0xc1
  801e59:	68 36 4a 80 00       	push   $0x804a36
  801e5e:	e8 4d e9 ff ff       	call   8007b0 <_panic>

00801e63 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	68 68 4a 80 00       	push   $0x804a68
  801e71:	68 d8 00 00 00       	push   $0xd8
  801e76:	68 36 4a 80 00       	push   $0x804a36
  801e7b:	e8 30 e9 ff ff       	call   8007b0 <_panic>

00801e80 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e86:	83 ec 04             	sub    $0x4,%esp
  801e89:	68 8e 4a 80 00       	push   $0x804a8e
  801e8e:	68 e4 00 00 00       	push   $0xe4
  801e93:	68 36 4a 80 00       	push   $0x804a36
  801e98:	e8 13 e9 ff ff       	call   8007b0 <_panic>

00801e9d <shrink>:

}
void shrink(uint32 newSize)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ea3:	83 ec 04             	sub    $0x4,%esp
  801ea6:	68 8e 4a 80 00       	push   $0x804a8e
  801eab:	68 e9 00 00 00       	push   $0xe9
  801eb0:	68 36 4a 80 00       	push   $0x804a36
  801eb5:	e8 f6 e8 ff ff       	call   8007b0 <_panic>

00801eba <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec0:	83 ec 04             	sub    $0x4,%esp
  801ec3:	68 8e 4a 80 00       	push   $0x804a8e
  801ec8:	68 ee 00 00 00       	push   $0xee
  801ecd:	68 36 4a 80 00       	push   $0x804a36
  801ed2:	e8 d9 e8 ff ff       	call   8007b0 <_panic>

00801ed7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	57                   	push   %edi
  801edb:	56                   	push   %esi
  801edc:	53                   	push   %ebx
  801edd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eec:	8b 7d 18             	mov    0x18(%ebp),%edi
  801eef:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ef2:	cd 30                	int    $0x30
  801ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801efa:	83 c4 10             	add    $0x10,%esp
  801efd:	5b                   	pop    %ebx
  801efe:	5e                   	pop    %esi
  801eff:	5f                   	pop    %edi
  801f00:	5d                   	pop    %ebp
  801f01:	c3                   	ret    

00801f02 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	83 ec 04             	sub    $0x4,%esp
  801f08:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f0e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f12:	8b 45 08             	mov    0x8(%ebp),%eax
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	52                   	push   %edx
  801f1a:	ff 75 0c             	pushl  0xc(%ebp)
  801f1d:	50                   	push   %eax
  801f1e:	6a 00                	push   $0x0
  801f20:	e8 b2 ff ff ff       	call   801ed7 <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
}
  801f28:	90                   	nop
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_cgetc>:

int
sys_cgetc(void)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 02                	push   $0x2
  801f3a:	e8 98 ff ff ff       	call   801ed7 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 03                	push   $0x3
  801f53:	e8 7f ff ff ff       	call   801ed7 <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
}
  801f5b:	90                   	nop
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 04                	push   $0x4
  801f6d:	e8 65 ff ff ff       	call   801ed7 <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	90                   	nop
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	52                   	push   %edx
  801f88:	50                   	push   %eax
  801f89:	6a 08                	push   $0x8
  801f8b:	e8 47 ff ff ff       	call   801ed7 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	56                   	push   %esi
  801f99:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f9a:	8b 75 18             	mov    0x18(%ebp),%esi
  801f9d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	56                   	push   %esi
  801faa:	53                   	push   %ebx
  801fab:	51                   	push   %ecx
  801fac:	52                   	push   %edx
  801fad:	50                   	push   %eax
  801fae:	6a 09                	push   $0x9
  801fb0:	e8 22 ff ff ff       	call   801ed7 <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
}
  801fb8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fbb:	5b                   	pop    %ebx
  801fbc:	5e                   	pop    %esi
  801fbd:	5d                   	pop    %ebp
  801fbe:	c3                   	ret    

00801fbf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	52                   	push   %edx
  801fcf:	50                   	push   %eax
  801fd0:	6a 0a                	push   $0xa
  801fd2:	e8 00 ff ff ff       	call   801ed7 <syscall>
  801fd7:	83 c4 18             	add    $0x18,%esp
}
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	ff 75 0c             	pushl  0xc(%ebp)
  801fe8:	ff 75 08             	pushl  0x8(%ebp)
  801feb:	6a 0b                	push   $0xb
  801fed:	e8 e5 fe ff ff       	call   801ed7 <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 0c                	push   $0xc
  802006:	e8 cc fe ff ff       	call   801ed7 <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 0d                	push   $0xd
  80201f:	e8 b3 fe ff ff       	call   801ed7 <syscall>
  802024:	83 c4 18             	add    $0x18,%esp
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 0e                	push   $0xe
  802038:	e8 9a fe ff ff       	call   801ed7 <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 0f                	push   $0xf
  802051:	e8 81 fe ff ff       	call   801ed7 <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	ff 75 08             	pushl  0x8(%ebp)
  802069:	6a 10                	push   $0x10
  80206b:	e8 67 fe ff ff       	call   801ed7 <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 11                	push   $0x11
  802084:	e8 4e fe ff ff       	call   801ed7 <syscall>
  802089:	83 c4 18             	add    $0x18,%esp
}
  80208c:	90                   	nop
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <sys_cputc>:

void
sys_cputc(const char c)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
  802092:	83 ec 04             	sub    $0x4,%esp
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80209b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	50                   	push   %eax
  8020a8:	6a 01                	push   $0x1
  8020aa:	e8 28 fe ff ff       	call   801ed7 <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
}
  8020b2:	90                   	nop
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 14                	push   $0x14
  8020c4:	e8 0e fe ff ff       	call   801ed7 <syscall>
  8020c9:	83 c4 18             	add    $0x18,%esp
}
  8020cc:	90                   	nop
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020db:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	6a 00                	push   $0x0
  8020e7:	51                   	push   %ecx
  8020e8:	52                   	push   %edx
  8020e9:	ff 75 0c             	pushl  0xc(%ebp)
  8020ec:	50                   	push   %eax
  8020ed:	6a 15                	push   $0x15
  8020ef:	e8 e3 fd ff ff       	call   801ed7 <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8020fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	52                   	push   %edx
  802109:	50                   	push   %eax
  80210a:	6a 16                	push   $0x16
  80210c:	e8 c6 fd ff ff       	call   801ed7 <syscall>
  802111:	83 c4 18             	add    $0x18,%esp
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802119:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	51                   	push   %ecx
  802127:	52                   	push   %edx
  802128:	50                   	push   %eax
  802129:	6a 17                	push   $0x17
  80212b:	e8 a7 fd ff ff       	call   801ed7 <syscall>
  802130:	83 c4 18             	add    $0x18,%esp
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802138:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	52                   	push   %edx
  802145:	50                   	push   %eax
  802146:	6a 18                	push   $0x18
  802148:	e8 8a fd ff ff       	call   801ed7 <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	6a 00                	push   $0x0
  80215a:	ff 75 14             	pushl  0x14(%ebp)
  80215d:	ff 75 10             	pushl  0x10(%ebp)
  802160:	ff 75 0c             	pushl  0xc(%ebp)
  802163:	50                   	push   %eax
  802164:	6a 19                	push   $0x19
  802166:	e8 6c fd ff ff       	call   801ed7 <syscall>
  80216b:	83 c4 18             	add    $0x18,%esp
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	50                   	push   %eax
  80217f:	6a 1a                	push   $0x1a
  802181:	e8 51 fd ff ff       	call   801ed7 <syscall>
  802186:	83 c4 18             	add    $0x18,%esp
}
  802189:	90                   	nop
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	50                   	push   %eax
  80219b:	6a 1b                	push   $0x1b
  80219d:	e8 35 fd ff ff       	call   801ed7 <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 05                	push   $0x5
  8021b6:	e8 1c fd ff ff       	call   801ed7 <syscall>
  8021bb:	83 c4 18             	add    $0x18,%esp
}
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 06                	push   $0x6
  8021cf:	e8 03 fd ff ff       	call   801ed7 <syscall>
  8021d4:	83 c4 18             	add    $0x18,%esp
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 07                	push   $0x7
  8021e8:	e8 ea fc ff ff       	call   801ed7 <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
}
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <sys_exit_env>:


void sys_exit_env(void)
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 1c                	push   $0x1c
  802201:	e8 d1 fc ff ff       	call   801ed7 <syscall>
  802206:	83 c4 18             	add    $0x18,%esp
}
  802209:	90                   	nop
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802212:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802215:	8d 50 04             	lea    0x4(%eax),%edx
  802218:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	52                   	push   %edx
  802222:	50                   	push   %eax
  802223:	6a 1d                	push   $0x1d
  802225:	e8 ad fc ff ff       	call   801ed7 <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
	return result;
  80222d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802230:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802233:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802236:	89 01                	mov    %eax,(%ecx)
  802238:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	c9                   	leave  
  80223f:	c2 04 00             	ret    $0x4

00802242 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	ff 75 10             	pushl  0x10(%ebp)
  80224c:	ff 75 0c             	pushl  0xc(%ebp)
  80224f:	ff 75 08             	pushl  0x8(%ebp)
  802252:	6a 13                	push   $0x13
  802254:	e8 7e fc ff ff       	call   801ed7 <syscall>
  802259:	83 c4 18             	add    $0x18,%esp
	return ;
  80225c:	90                   	nop
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <sys_rcr2>:
uint32 sys_rcr2()
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 1e                	push   $0x1e
  80226e:	e8 64 fc ff ff       	call   801ed7 <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
}
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	83 ec 04             	sub    $0x4,%esp
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802284:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	50                   	push   %eax
  802291:	6a 1f                	push   $0x1f
  802293:	e8 3f fc ff ff       	call   801ed7 <syscall>
  802298:	83 c4 18             	add    $0x18,%esp
	return ;
  80229b:	90                   	nop
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <rsttst>:
void rsttst()
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 21                	push   $0x21
  8022ad:	e8 25 fc ff ff       	call   801ed7 <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b5:	90                   	nop
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	83 ec 04             	sub    $0x4,%esp
  8022be:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022c4:	8b 55 18             	mov    0x18(%ebp),%edx
  8022c7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022cb:	52                   	push   %edx
  8022cc:	50                   	push   %eax
  8022cd:	ff 75 10             	pushl  0x10(%ebp)
  8022d0:	ff 75 0c             	pushl  0xc(%ebp)
  8022d3:	ff 75 08             	pushl  0x8(%ebp)
  8022d6:	6a 20                	push   $0x20
  8022d8:	e8 fa fb ff ff       	call   801ed7 <syscall>
  8022dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e0:	90                   	nop
}
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    

008022e3 <chktst>:
void chktst(uint32 n)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	ff 75 08             	pushl  0x8(%ebp)
  8022f1:	6a 22                	push   $0x22
  8022f3:	e8 df fb ff ff       	call   801ed7 <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8022fb:	90                   	nop
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <inctst>:

void inctst()
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 23                	push   $0x23
  80230d:	e8 c5 fb ff ff       	call   801ed7 <syscall>
  802312:	83 c4 18             	add    $0x18,%esp
	return ;
  802315:	90                   	nop
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <gettst>:
uint32 gettst()
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 24                	push   $0x24
  802327:	e8 ab fb ff ff       	call   801ed7 <syscall>
  80232c:	83 c4 18             	add    $0x18,%esp
}
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
  802334:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 25                	push   $0x25
  802343:	e8 8f fb ff ff       	call   801ed7 <syscall>
  802348:	83 c4 18             	add    $0x18,%esp
  80234b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80234e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802352:	75 07                	jne    80235b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802354:	b8 01 00 00 00       	mov    $0x1,%eax
  802359:	eb 05                	jmp    802360 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80235b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 25                	push   $0x25
  802374:	e8 5e fb ff ff       	call   801ed7 <syscall>
  802379:	83 c4 18             	add    $0x18,%esp
  80237c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80237f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802383:	75 07                	jne    80238c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802385:	b8 01 00 00 00       	mov    $0x1,%eax
  80238a:	eb 05                	jmp    802391 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80238c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
  802396:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 25                	push   $0x25
  8023a5:	e8 2d fb ff ff       	call   801ed7 <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
  8023ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023b0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023b4:	75 07                	jne    8023bd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bb:	eb 05                	jmp    8023c2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 25                	push   $0x25
  8023d6:	e8 fc fa ff ff       	call   801ed7 <syscall>
  8023db:	83 c4 18             	add    $0x18,%esp
  8023de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023e1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023e5:	75 07                	jne    8023ee <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ec:	eb 05                	jmp    8023f3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	ff 75 08             	pushl  0x8(%ebp)
  802403:	6a 26                	push   $0x26
  802405:	e8 cd fa ff ff       	call   801ed7 <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
	return ;
  80240d:	90                   	nop
}
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802414:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802417:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80241a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	6a 00                	push   $0x0
  802422:	53                   	push   %ebx
  802423:	51                   	push   %ecx
  802424:	52                   	push   %edx
  802425:	50                   	push   %eax
  802426:	6a 27                	push   $0x27
  802428:	e8 aa fa ff ff       	call   801ed7 <syscall>
  80242d:	83 c4 18             	add    $0x18,%esp
}
  802430:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	52                   	push   %edx
  802445:	50                   	push   %eax
  802446:	6a 28                	push   $0x28
  802448:	e8 8a fa ff ff       	call   801ed7 <syscall>
  80244d:	83 c4 18             	add    $0x18,%esp
}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802455:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802458:	8b 55 0c             	mov    0xc(%ebp),%edx
  80245b:	8b 45 08             	mov    0x8(%ebp),%eax
  80245e:	6a 00                	push   $0x0
  802460:	51                   	push   %ecx
  802461:	ff 75 10             	pushl  0x10(%ebp)
  802464:	52                   	push   %edx
  802465:	50                   	push   %eax
  802466:	6a 29                	push   $0x29
  802468:	e8 6a fa ff ff       	call   801ed7 <syscall>
  80246d:	83 c4 18             	add    $0x18,%esp
}
  802470:	c9                   	leave  
  802471:	c3                   	ret    

00802472 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	ff 75 10             	pushl  0x10(%ebp)
  80247c:	ff 75 0c             	pushl  0xc(%ebp)
  80247f:	ff 75 08             	pushl  0x8(%ebp)
  802482:	6a 12                	push   $0x12
  802484:	e8 4e fa ff ff       	call   801ed7 <syscall>
  802489:	83 c4 18             	add    $0x18,%esp
	return ;
  80248c:	90                   	nop
}
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    

0080248f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802492:	8b 55 0c             	mov    0xc(%ebp),%edx
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	52                   	push   %edx
  80249f:	50                   	push   %eax
  8024a0:	6a 2a                	push   $0x2a
  8024a2:	e8 30 fa ff ff       	call   801ed7 <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
	return;
  8024aa:	90                   	nop
}
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8024b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	50                   	push   %eax
  8024bc:	6a 2b                	push   $0x2b
  8024be:	e8 14 fa ff ff       	call   801ed7 <syscall>
  8024c3:	83 c4 18             	add    $0x18,%esp
}
  8024c6:	c9                   	leave  
  8024c7:	c3                   	ret    

008024c8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	ff 75 0c             	pushl  0xc(%ebp)
  8024d4:	ff 75 08             	pushl  0x8(%ebp)
  8024d7:	6a 2c                	push   $0x2c
  8024d9:	e8 f9 f9 ff ff       	call   801ed7 <syscall>
  8024de:	83 c4 18             	add    $0x18,%esp
	return;
  8024e1:	90                   	nop
}
  8024e2:	c9                   	leave  
  8024e3:	c3                   	ret    

008024e4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	ff 75 0c             	pushl  0xc(%ebp)
  8024f0:	ff 75 08             	pushl  0x8(%ebp)
  8024f3:	6a 2d                	push   $0x2d
  8024f5:	e8 dd f9 ff ff       	call   801ed7 <syscall>
  8024fa:	83 c4 18             	add    $0x18,%esp
	return;
  8024fd:	90                   	nop
}
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    

00802500 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	83 e8 04             	sub    $0x4,%eax
  80250c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80250f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802512:	8b 00                	mov    (%eax),%eax
  802514:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802517:	c9                   	leave  
  802518:	c3                   	ret    

00802519 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
  80251c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80251f:	8b 45 08             	mov    0x8(%ebp),%eax
  802522:	83 e8 04             	sub    $0x4,%eax
  802525:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802528:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80252b:	8b 00                	mov    (%eax),%eax
  80252d:	83 e0 01             	and    $0x1,%eax
  802530:	85 c0                	test   %eax,%eax
  802532:	0f 94 c0             	sete   %al
}
  802535:	c9                   	leave  
  802536:	c3                   	ret    

00802537 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
  80253a:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80253d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802544:	8b 45 0c             	mov    0xc(%ebp),%eax
  802547:	83 f8 02             	cmp    $0x2,%eax
  80254a:	74 2b                	je     802577 <alloc_block+0x40>
  80254c:	83 f8 02             	cmp    $0x2,%eax
  80254f:	7f 07                	jg     802558 <alloc_block+0x21>
  802551:	83 f8 01             	cmp    $0x1,%eax
  802554:	74 0e                	je     802564 <alloc_block+0x2d>
  802556:	eb 58                	jmp    8025b0 <alloc_block+0x79>
  802558:	83 f8 03             	cmp    $0x3,%eax
  80255b:	74 2d                	je     80258a <alloc_block+0x53>
  80255d:	83 f8 04             	cmp    $0x4,%eax
  802560:	74 3b                	je     80259d <alloc_block+0x66>
  802562:	eb 4c                	jmp    8025b0 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802564:	83 ec 0c             	sub    $0xc,%esp
  802567:	ff 75 08             	pushl  0x8(%ebp)
  80256a:	e8 11 03 00 00       	call   802880 <alloc_block_FF>
  80256f:	83 c4 10             	add    $0x10,%esp
  802572:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802575:	eb 4a                	jmp    8025c1 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802577:	83 ec 0c             	sub    $0xc,%esp
  80257a:	ff 75 08             	pushl  0x8(%ebp)
  80257d:	e8 fa 19 00 00       	call   803f7c <alloc_block_NF>
  802582:	83 c4 10             	add    $0x10,%esp
  802585:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802588:	eb 37                	jmp    8025c1 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80258a:	83 ec 0c             	sub    $0xc,%esp
  80258d:	ff 75 08             	pushl  0x8(%ebp)
  802590:	e8 a7 07 00 00       	call   802d3c <alloc_block_BF>
  802595:	83 c4 10             	add    $0x10,%esp
  802598:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80259b:	eb 24                	jmp    8025c1 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80259d:	83 ec 0c             	sub    $0xc,%esp
  8025a0:	ff 75 08             	pushl  0x8(%ebp)
  8025a3:	e8 b7 19 00 00       	call   803f5f <alloc_block_WF>
  8025a8:	83 c4 10             	add    $0x10,%esp
  8025ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025ae:	eb 11                	jmp    8025c1 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8025b0:	83 ec 0c             	sub    $0xc,%esp
  8025b3:	68 a0 4a 80 00       	push   $0x804aa0
  8025b8:	e8 b0 e4 ff ff       	call   800a6d <cprintf>
  8025bd:	83 c4 10             	add    $0x10,%esp
		break;
  8025c0:	90                   	nop
	}
	return va;
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8025c4:	c9                   	leave  
  8025c5:	c3                   	ret    

008025c6 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8025c6:	55                   	push   %ebp
  8025c7:	89 e5                	mov    %esp,%ebp
  8025c9:	53                   	push   %ebx
  8025ca:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8025cd:	83 ec 0c             	sub    $0xc,%esp
  8025d0:	68 c0 4a 80 00       	push   $0x804ac0
  8025d5:	e8 93 e4 ff ff       	call   800a6d <cprintf>
  8025da:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8025dd:	83 ec 0c             	sub    $0xc,%esp
  8025e0:	68 eb 4a 80 00       	push   $0x804aeb
  8025e5:	e8 83 e4 ff ff       	call   800a6d <cprintf>
  8025ea:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f3:	eb 37                	jmp    80262c <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8025f5:	83 ec 0c             	sub    $0xc,%esp
  8025f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8025fb:	e8 19 ff ff ff       	call   802519 <is_free_block>
  802600:	83 c4 10             	add    $0x10,%esp
  802603:	0f be d8             	movsbl %al,%ebx
  802606:	83 ec 0c             	sub    $0xc,%esp
  802609:	ff 75 f4             	pushl  -0xc(%ebp)
  80260c:	e8 ef fe ff ff       	call   802500 <get_block_size>
  802611:	83 c4 10             	add    $0x10,%esp
  802614:	83 ec 04             	sub    $0x4,%esp
  802617:	53                   	push   %ebx
  802618:	50                   	push   %eax
  802619:	68 03 4b 80 00       	push   $0x804b03
  80261e:	e8 4a e4 ff ff       	call   800a6d <cprintf>
  802623:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802626:	8b 45 10             	mov    0x10(%ebp),%eax
  802629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802630:	74 07                	je     802639 <print_blocks_list+0x73>
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 00                	mov    (%eax),%eax
  802637:	eb 05                	jmp    80263e <print_blocks_list+0x78>
  802639:	b8 00 00 00 00       	mov    $0x0,%eax
  80263e:	89 45 10             	mov    %eax,0x10(%ebp)
  802641:	8b 45 10             	mov    0x10(%ebp),%eax
  802644:	85 c0                	test   %eax,%eax
  802646:	75 ad                	jne    8025f5 <print_blocks_list+0x2f>
  802648:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264c:	75 a7                	jne    8025f5 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80264e:	83 ec 0c             	sub    $0xc,%esp
  802651:	68 c0 4a 80 00       	push   $0x804ac0
  802656:	e8 12 e4 ff ff       	call   800a6d <cprintf>
  80265b:	83 c4 10             	add    $0x10,%esp

}
  80265e:	90                   	nop
  80265f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802662:	c9                   	leave  
  802663:	c3                   	ret    

00802664 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
  802667:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80266a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80266d:	83 e0 01             	and    $0x1,%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	74 03                	je     802677 <initialize_dynamic_allocator+0x13>
  802674:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802677:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80267b:	0f 84 c7 01 00 00    	je     802848 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802681:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802688:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80268b:	8b 55 08             	mov    0x8(%ebp),%edx
  80268e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802691:	01 d0                	add    %edx,%eax
  802693:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802698:	0f 87 ad 01 00 00    	ja     80284b <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80269e:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a1:	85 c0                	test   %eax,%eax
  8026a3:	0f 89 a5 01 00 00    	jns    80284e <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8026a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026af:	01 d0                	add    %edx,%eax
  8026b1:	83 e8 04             	sub    $0x4,%eax
  8026b4:	a3 4c 50 80 00       	mov    %eax,0x80504c
     struct BlockElement * element = NULL;
  8026b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8026c0:	a1 30 50 80 00       	mov    0x805030,%eax
  8026c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c8:	e9 87 00 00 00       	jmp    802754 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8026cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d1:	75 14                	jne    8026e7 <initialize_dynamic_allocator+0x83>
  8026d3:	83 ec 04             	sub    $0x4,%esp
  8026d6:	68 1b 4b 80 00       	push   $0x804b1b
  8026db:	6a 79                	push   $0x79
  8026dd:	68 39 4b 80 00       	push   $0x804b39
  8026e2:	e8 c9 e0 ff ff       	call   8007b0 <_panic>
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 00                	mov    (%eax),%eax
  8026ec:	85 c0                	test   %eax,%eax
  8026ee:	74 10                	je     802700 <initialize_dynamic_allocator+0x9c>
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	8b 00                	mov    (%eax),%eax
  8026f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f8:	8b 52 04             	mov    0x4(%edx),%edx
  8026fb:	89 50 04             	mov    %edx,0x4(%eax)
  8026fe:	eb 0b                	jmp    80270b <initialize_dynamic_allocator+0xa7>
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 40 04             	mov    0x4(%eax),%eax
  802706:	a3 34 50 80 00       	mov    %eax,0x805034
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 40 04             	mov    0x4(%eax),%eax
  802711:	85 c0                	test   %eax,%eax
  802713:	74 0f                	je     802724 <initialize_dynamic_allocator+0xc0>
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	8b 40 04             	mov    0x4(%eax),%eax
  80271b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271e:	8b 12                	mov    (%edx),%edx
  802720:	89 10                	mov    %edx,(%eax)
  802722:	eb 0a                	jmp    80272e <initialize_dynamic_allocator+0xca>
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 00                	mov    (%eax),%eax
  802729:	a3 30 50 80 00       	mov    %eax,0x805030
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802741:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802746:	48                   	dec    %eax
  802747:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80274c:	a1 38 50 80 00       	mov    0x805038,%eax
  802751:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802754:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802758:	74 07                	je     802761 <initialize_dynamic_allocator+0xfd>
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 00                	mov    (%eax),%eax
  80275f:	eb 05                	jmp    802766 <initialize_dynamic_allocator+0x102>
  802761:	b8 00 00 00 00       	mov    $0x0,%eax
  802766:	a3 38 50 80 00       	mov    %eax,0x805038
  80276b:	a1 38 50 80 00       	mov    0x805038,%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	0f 85 55 ff ff ff    	jne    8026cd <initialize_dynamic_allocator+0x69>
  802778:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277c:	0f 85 4b ff ff ff    	jne    8026cd <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802782:	8b 45 08             	mov    0x8(%ebp),%eax
  802785:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802791:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802796:	a3 48 50 80 00       	mov    %eax,0x805048
    end_block->info = 1;
  80279b:	a1 48 50 80 00       	mov    0x805048,%eax
  8027a0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8027a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a9:	83 c0 08             	add    $0x8,%eax
  8027ac:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	83 c0 04             	add    $0x4,%eax
  8027b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027b8:	83 ea 08             	sub    $0x8,%edx
  8027bb:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c3:	01 d0                	add    %edx,%eax
  8027c5:	83 e8 08             	sub    $0x8,%eax
  8027c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027cb:	83 ea 08             	sub    $0x8,%edx
  8027ce:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8027d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8027d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8027e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027e7:	75 17                	jne    802800 <initialize_dynamic_allocator+0x19c>
  8027e9:	83 ec 04             	sub    $0x4,%esp
  8027ec:	68 54 4b 80 00       	push   $0x804b54
  8027f1:	68 90 00 00 00       	push   $0x90
  8027f6:	68 39 4b 80 00       	push   $0x804b39
  8027fb:	e8 b0 df ff ff       	call   8007b0 <_panic>
  802800:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802806:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802809:	89 10                	mov    %edx,(%eax)
  80280b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280e:	8b 00                	mov    (%eax),%eax
  802810:	85 c0                	test   %eax,%eax
  802812:	74 0d                	je     802821 <initialize_dynamic_allocator+0x1bd>
  802814:	a1 30 50 80 00       	mov    0x805030,%eax
  802819:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80281c:	89 50 04             	mov    %edx,0x4(%eax)
  80281f:	eb 08                	jmp    802829 <initialize_dynamic_allocator+0x1c5>
  802821:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802824:	a3 34 50 80 00       	mov    %eax,0x805034
  802829:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282c:	a3 30 50 80 00       	mov    %eax,0x805030
  802831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802834:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802840:	40                   	inc    %eax
  802841:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802846:	eb 07                	jmp    80284f <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802848:	90                   	nop
  802849:	eb 04                	jmp    80284f <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80284b:	90                   	nop
  80284c:	eb 01                	jmp    80284f <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80284e:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802854:	8b 45 10             	mov    0x10(%ebp),%eax
  802857:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80285a:	8b 45 08             	mov    0x8(%ebp),%eax
  80285d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802860:	8b 45 0c             	mov    0xc(%ebp),%eax
  802863:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802865:	8b 45 08             	mov    0x8(%ebp),%eax
  802868:	83 e8 04             	sub    $0x4,%eax
  80286b:	8b 00                	mov    (%eax),%eax
  80286d:	83 e0 fe             	and    $0xfffffffe,%eax
  802870:	8d 50 f8             	lea    -0x8(%eax),%edx
  802873:	8b 45 08             	mov    0x8(%ebp),%eax
  802876:	01 c2                	add    %eax,%edx
  802878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80287b:	89 02                	mov    %eax,(%edx)
}
  80287d:	90                   	nop
  80287e:	5d                   	pop    %ebp
  80287f:	c3                   	ret    

00802880 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
  802883:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802886:	8b 45 08             	mov    0x8(%ebp),%eax
  802889:	83 e0 01             	and    $0x1,%eax
  80288c:	85 c0                	test   %eax,%eax
  80288e:	74 03                	je     802893 <alloc_block_FF+0x13>
  802890:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802893:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802897:	77 07                	ja     8028a0 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802899:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028a0:	a1 28 50 80 00       	mov    0x805028,%eax
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	75 73                	jne    80291c <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ac:	83 c0 10             	add    $0x10,%eax
  8028af:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028b2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8028b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bf:	01 d0                	add    %edx,%eax
  8028c1:	48                   	dec    %eax
  8028c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8028c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8028cd:	f7 75 ec             	divl   -0x14(%ebp)
  8028d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d3:	29 d0                	sub    %edx,%eax
  8028d5:	c1 e8 0c             	shr    $0xc,%eax
  8028d8:	83 ec 0c             	sub    $0xc,%esp
  8028db:	50                   	push   %eax
  8028dc:	e8 2e f1 ff ff       	call   801a0f <sbrk>
  8028e1:	83 c4 10             	add    $0x10,%esp
  8028e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028e7:	83 ec 0c             	sub    $0xc,%esp
  8028ea:	6a 00                	push   $0x0
  8028ec:	e8 1e f1 ff ff       	call   801a0f <sbrk>
  8028f1:	83 c4 10             	add    $0x10,%esp
  8028f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8028f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028fa:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8028fd:	83 ec 08             	sub    $0x8,%esp
  802900:	50                   	push   %eax
  802901:	ff 75 e4             	pushl  -0x1c(%ebp)
  802904:	e8 5b fd ff ff       	call   802664 <initialize_dynamic_allocator>
  802909:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80290c:	83 ec 0c             	sub    $0xc,%esp
  80290f:	68 77 4b 80 00       	push   $0x804b77
  802914:	e8 54 e1 ff ff       	call   800a6d <cprintf>
  802919:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80291c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802920:	75 0a                	jne    80292c <alloc_block_FF+0xac>
	        return NULL;
  802922:	b8 00 00 00 00       	mov    $0x0,%eax
  802927:	e9 0e 04 00 00       	jmp    802d3a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80292c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802933:	a1 30 50 80 00       	mov    0x805030,%eax
  802938:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293b:	e9 f3 02 00 00       	jmp    802c33 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802946:	83 ec 0c             	sub    $0xc,%esp
  802949:	ff 75 bc             	pushl  -0x44(%ebp)
  80294c:	e8 af fb ff ff       	call   802500 <get_block_size>
  802951:	83 c4 10             	add    $0x10,%esp
  802954:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802957:	8b 45 08             	mov    0x8(%ebp),%eax
  80295a:	83 c0 08             	add    $0x8,%eax
  80295d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802960:	0f 87 c5 02 00 00    	ja     802c2b <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802966:	8b 45 08             	mov    0x8(%ebp),%eax
  802969:	83 c0 18             	add    $0x18,%eax
  80296c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80296f:	0f 87 19 02 00 00    	ja     802b8e <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802975:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802978:	2b 45 08             	sub    0x8(%ebp),%eax
  80297b:	83 e8 08             	sub    $0x8,%eax
  80297e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802981:	8b 45 08             	mov    0x8(%ebp),%eax
  802984:	8d 50 08             	lea    0x8(%eax),%edx
  802987:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80298a:	01 d0                	add    %edx,%eax
  80298c:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	83 c0 08             	add    $0x8,%eax
  802995:	83 ec 04             	sub    $0x4,%esp
  802998:	6a 01                	push   $0x1
  80299a:	50                   	push   %eax
  80299b:	ff 75 bc             	pushl  -0x44(%ebp)
  80299e:	e8 ae fe ff ff       	call   802851 <set_block_data>
  8029a3:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	8b 40 04             	mov    0x4(%eax),%eax
  8029ac:	85 c0                	test   %eax,%eax
  8029ae:	75 68                	jne    802a18 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029b0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029b4:	75 17                	jne    8029cd <alloc_block_FF+0x14d>
  8029b6:	83 ec 04             	sub    $0x4,%esp
  8029b9:	68 54 4b 80 00       	push   $0x804b54
  8029be:	68 d7 00 00 00       	push   $0xd7
  8029c3:	68 39 4b 80 00       	push   $0x804b39
  8029c8:	e8 e3 dd ff ff       	call   8007b0 <_panic>
  8029cd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029d6:	89 10                	mov    %edx,(%eax)
  8029d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029db:	8b 00                	mov    (%eax),%eax
  8029dd:	85 c0                	test   %eax,%eax
  8029df:	74 0d                	je     8029ee <alloc_block_FF+0x16e>
  8029e1:	a1 30 50 80 00       	mov    0x805030,%eax
  8029e6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029e9:	89 50 04             	mov    %edx,0x4(%eax)
  8029ec:	eb 08                	jmp    8029f6 <alloc_block_FF+0x176>
  8029ee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f1:	a3 34 50 80 00       	mov    %eax,0x805034
  8029f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8029fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a08:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a0d:	40                   	inc    %eax
  802a0e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a13:	e9 dc 00 00 00       	jmp    802af4 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	75 65                	jne    802a86 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a21:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a25:	75 17                	jne    802a3e <alloc_block_FF+0x1be>
  802a27:	83 ec 04             	sub    $0x4,%esp
  802a2a:	68 88 4b 80 00       	push   $0x804b88
  802a2f:	68 db 00 00 00       	push   $0xdb
  802a34:	68 39 4b 80 00       	push   $0x804b39
  802a39:	e8 72 dd ff ff       	call   8007b0 <_panic>
  802a3e:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802a44:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a47:	89 50 04             	mov    %edx,0x4(%eax)
  802a4a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a4d:	8b 40 04             	mov    0x4(%eax),%eax
  802a50:	85 c0                	test   %eax,%eax
  802a52:	74 0c                	je     802a60 <alloc_block_FF+0x1e0>
  802a54:	a1 34 50 80 00       	mov    0x805034,%eax
  802a59:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a5c:	89 10                	mov    %edx,(%eax)
  802a5e:	eb 08                	jmp    802a68 <alloc_block_FF+0x1e8>
  802a60:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a63:	a3 30 50 80 00       	mov    %eax,0x805030
  802a68:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a6b:	a3 34 50 80 00       	mov    %eax,0x805034
  802a70:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a79:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a7e:	40                   	inc    %eax
  802a7f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a84:	eb 6e                	jmp    802af4 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802a86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8a:	74 06                	je     802a92 <alloc_block_FF+0x212>
  802a8c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a90:	75 17                	jne    802aa9 <alloc_block_FF+0x229>
  802a92:	83 ec 04             	sub    $0x4,%esp
  802a95:	68 ac 4b 80 00       	push   $0x804bac
  802a9a:	68 df 00 00 00       	push   $0xdf
  802a9f:	68 39 4b 80 00       	push   $0x804b39
  802aa4:	e8 07 dd ff ff       	call   8007b0 <_panic>
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	8b 10                	mov    (%eax),%edx
  802aae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ab1:	89 10                	mov    %edx,(%eax)
  802ab3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ab6:	8b 00                	mov    (%eax),%eax
  802ab8:	85 c0                	test   %eax,%eax
  802aba:	74 0b                	je     802ac7 <alloc_block_FF+0x247>
  802abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abf:	8b 00                	mov    (%eax),%eax
  802ac1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ac4:	89 50 04             	mov    %edx,0x4(%eax)
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802acd:	89 10                	mov    %edx,(%eax)
  802acf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ad2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad5:	89 50 04             	mov    %edx,0x4(%eax)
  802ad8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	85 c0                	test   %eax,%eax
  802adf:	75 08                	jne    802ae9 <alloc_block_FF+0x269>
  802ae1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae4:	a3 34 50 80 00       	mov    %eax,0x805034
  802ae9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802aee:	40                   	inc    %eax
  802aef:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802af4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af8:	75 17                	jne    802b11 <alloc_block_FF+0x291>
  802afa:	83 ec 04             	sub    $0x4,%esp
  802afd:	68 1b 4b 80 00       	push   $0x804b1b
  802b02:	68 e1 00 00 00       	push   $0xe1
  802b07:	68 39 4b 80 00       	push   $0x804b39
  802b0c:	e8 9f dc ff ff       	call   8007b0 <_panic>
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	74 10                	je     802b2a <alloc_block_FF+0x2aa>
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b22:	8b 52 04             	mov    0x4(%edx),%edx
  802b25:	89 50 04             	mov    %edx,0x4(%eax)
  802b28:	eb 0b                	jmp    802b35 <alloc_block_FF+0x2b5>
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	8b 40 04             	mov    0x4(%eax),%eax
  802b30:	a3 34 50 80 00       	mov    %eax,0x805034
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 40 04             	mov    0x4(%eax),%eax
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	74 0f                	je     802b4e <alloc_block_FF+0x2ce>
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	8b 40 04             	mov    0x4(%eax),%eax
  802b45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b48:	8b 12                	mov    (%edx),%edx
  802b4a:	89 10                	mov    %edx,(%eax)
  802b4c:	eb 0a                	jmp    802b58 <alloc_block_FF+0x2d8>
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 00                	mov    (%eax),%eax
  802b53:	a3 30 50 80 00       	mov    %eax,0x805030
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b70:	48                   	dec    %eax
  802b71:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802b76:	83 ec 04             	sub    $0x4,%esp
  802b79:	6a 00                	push   $0x0
  802b7b:	ff 75 b4             	pushl  -0x4c(%ebp)
  802b7e:	ff 75 b0             	pushl  -0x50(%ebp)
  802b81:	e8 cb fc ff ff       	call   802851 <set_block_data>
  802b86:	83 c4 10             	add    $0x10,%esp
  802b89:	e9 95 00 00 00       	jmp    802c23 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802b8e:	83 ec 04             	sub    $0x4,%esp
  802b91:	6a 01                	push   $0x1
  802b93:	ff 75 b8             	pushl  -0x48(%ebp)
  802b96:	ff 75 bc             	pushl  -0x44(%ebp)
  802b99:	e8 b3 fc ff ff       	call   802851 <set_block_data>
  802b9e:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802ba1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba5:	75 17                	jne    802bbe <alloc_block_FF+0x33e>
  802ba7:	83 ec 04             	sub    $0x4,%esp
  802baa:	68 1b 4b 80 00       	push   $0x804b1b
  802baf:	68 e8 00 00 00       	push   $0xe8
  802bb4:	68 39 4b 80 00       	push   $0x804b39
  802bb9:	e8 f2 db ff ff       	call   8007b0 <_panic>
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	8b 00                	mov    (%eax),%eax
  802bc3:	85 c0                	test   %eax,%eax
  802bc5:	74 10                	je     802bd7 <alloc_block_FF+0x357>
  802bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bca:	8b 00                	mov    (%eax),%eax
  802bcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bcf:	8b 52 04             	mov    0x4(%edx),%edx
  802bd2:	89 50 04             	mov    %edx,0x4(%eax)
  802bd5:	eb 0b                	jmp    802be2 <alloc_block_FF+0x362>
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 40 04             	mov    0x4(%eax),%eax
  802bdd:	a3 34 50 80 00       	mov    %eax,0x805034
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 40 04             	mov    0x4(%eax),%eax
  802be8:	85 c0                	test   %eax,%eax
  802bea:	74 0f                	je     802bfb <alloc_block_FF+0x37b>
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 40 04             	mov    0x4(%eax),%eax
  802bf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf5:	8b 12                	mov    (%edx),%edx
  802bf7:	89 10                	mov    %edx,(%eax)
  802bf9:	eb 0a                	jmp    802c05 <alloc_block_FF+0x385>
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	a3 30 50 80 00       	mov    %eax,0x805030
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c18:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c1d:	48                   	dec    %eax
  802c1e:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802c23:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c26:	e9 0f 01 00 00       	jmp    802d3a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c2b:	a1 38 50 80 00       	mov    0x805038,%eax
  802c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c37:	74 07                	je     802c40 <alloc_block_FF+0x3c0>
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	8b 00                	mov    (%eax),%eax
  802c3e:	eb 05                	jmp    802c45 <alloc_block_FF+0x3c5>
  802c40:	b8 00 00 00 00       	mov    $0x0,%eax
  802c45:	a3 38 50 80 00       	mov    %eax,0x805038
  802c4a:	a1 38 50 80 00       	mov    0x805038,%eax
  802c4f:	85 c0                	test   %eax,%eax
  802c51:	0f 85 e9 fc ff ff    	jne    802940 <alloc_block_FF+0xc0>
  802c57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5b:	0f 85 df fc ff ff    	jne    802940 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	83 c0 08             	add    $0x8,%eax
  802c67:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c6a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802c71:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c74:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c77:	01 d0                	add    %edx,%eax
  802c79:	48                   	dec    %eax
  802c7a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802c7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c80:	ba 00 00 00 00       	mov    $0x0,%edx
  802c85:	f7 75 d8             	divl   -0x28(%ebp)
  802c88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c8b:	29 d0                	sub    %edx,%eax
  802c8d:	c1 e8 0c             	shr    $0xc,%eax
  802c90:	83 ec 0c             	sub    $0xc,%esp
  802c93:	50                   	push   %eax
  802c94:	e8 76 ed ff ff       	call   801a0f <sbrk>
  802c99:	83 c4 10             	add    $0x10,%esp
  802c9c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802c9f:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802ca3:	75 0a                	jne    802caf <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802ca5:	b8 00 00 00 00       	mov    $0x0,%eax
  802caa:	e9 8b 00 00 00       	jmp    802d3a <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802caf:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802cb6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cb9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cbc:	01 d0                	add    %edx,%eax
  802cbe:	48                   	dec    %eax
  802cbf:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802cc2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802cc5:	ba 00 00 00 00       	mov    $0x0,%edx
  802cca:	f7 75 cc             	divl   -0x34(%ebp)
  802ccd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802cd0:	29 d0                	sub    %edx,%eax
  802cd2:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cd5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cd8:	01 d0                	add    %edx,%eax
  802cda:	a3 48 50 80 00       	mov    %eax,0x805048
			end_block->info = 1;
  802cdf:	a1 48 50 80 00       	mov    0x805048,%eax
  802ce4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802cea:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802cf1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cf4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cf7:	01 d0                	add    %edx,%eax
  802cf9:	48                   	dec    %eax
  802cfa:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cfd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d00:	ba 00 00 00 00       	mov    $0x0,%edx
  802d05:	f7 75 c4             	divl   -0x3c(%ebp)
  802d08:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d0b:	29 d0                	sub    %edx,%eax
  802d0d:	83 ec 04             	sub    $0x4,%esp
  802d10:	6a 01                	push   $0x1
  802d12:	50                   	push   %eax
  802d13:	ff 75 d0             	pushl  -0x30(%ebp)
  802d16:	e8 36 fb ff ff       	call   802851 <set_block_data>
  802d1b:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802d1e:	83 ec 0c             	sub    $0xc,%esp
  802d21:	ff 75 d0             	pushl  -0x30(%ebp)
  802d24:	e8 1b 0a 00 00       	call   803744 <free_block>
  802d29:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802d2c:	83 ec 0c             	sub    $0xc,%esp
  802d2f:	ff 75 08             	pushl  0x8(%ebp)
  802d32:	e8 49 fb ff ff       	call   802880 <alloc_block_FF>
  802d37:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802d3a:	c9                   	leave  
  802d3b:	c3                   	ret    

00802d3c <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802d3c:	55                   	push   %ebp
  802d3d:	89 e5                	mov    %esp,%ebp
  802d3f:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	83 e0 01             	and    $0x1,%eax
  802d48:	85 c0                	test   %eax,%eax
  802d4a:	74 03                	je     802d4f <alloc_block_BF+0x13>
  802d4c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802d4f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802d53:	77 07                	ja     802d5c <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802d55:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802d5c:	a1 28 50 80 00       	mov    0x805028,%eax
  802d61:	85 c0                	test   %eax,%eax
  802d63:	75 73                	jne    802dd8 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	83 c0 10             	add    $0x10,%eax
  802d6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802d6e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802d75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7b:	01 d0                	add    %edx,%eax
  802d7d:	48                   	dec    %eax
  802d7e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d84:	ba 00 00 00 00       	mov    $0x0,%edx
  802d89:	f7 75 e0             	divl   -0x20(%ebp)
  802d8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d8f:	29 d0                	sub    %edx,%eax
  802d91:	c1 e8 0c             	shr    $0xc,%eax
  802d94:	83 ec 0c             	sub    $0xc,%esp
  802d97:	50                   	push   %eax
  802d98:	e8 72 ec ff ff       	call   801a0f <sbrk>
  802d9d:	83 c4 10             	add    $0x10,%esp
  802da0:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802da3:	83 ec 0c             	sub    $0xc,%esp
  802da6:	6a 00                	push   $0x0
  802da8:	e8 62 ec ff ff       	call   801a0f <sbrk>
  802dad:	83 c4 10             	add    $0x10,%esp
  802db0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802db3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802db6:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802db9:	83 ec 08             	sub    $0x8,%esp
  802dbc:	50                   	push   %eax
  802dbd:	ff 75 d8             	pushl  -0x28(%ebp)
  802dc0:	e8 9f f8 ff ff       	call   802664 <initialize_dynamic_allocator>
  802dc5:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802dc8:	83 ec 0c             	sub    $0xc,%esp
  802dcb:	68 77 4b 80 00       	push   $0x804b77
  802dd0:	e8 98 dc ff ff       	call   800a6d <cprintf>
  802dd5:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802dd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802ddf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802de6:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802ded:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802df4:	a1 30 50 80 00       	mov    0x805030,%eax
  802df9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dfc:	e9 1d 01 00 00       	jmp    802f1e <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802e07:	83 ec 0c             	sub    $0xc,%esp
  802e0a:	ff 75 a8             	pushl  -0x58(%ebp)
  802e0d:	e8 ee f6 ff ff       	call   802500 <get_block_size>
  802e12:	83 c4 10             	add    $0x10,%esp
  802e15:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	83 c0 08             	add    $0x8,%eax
  802e1e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e21:	0f 87 ef 00 00 00    	ja     802f16 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	83 c0 18             	add    $0x18,%eax
  802e2d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e30:	77 1d                	ja     802e4f <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802e32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e35:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e38:	0f 86 d8 00 00 00    	jbe    802f16 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802e3e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802e44:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e4a:	e9 c7 00 00 00       	jmp    802f16 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	83 c0 08             	add    $0x8,%eax
  802e55:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e58:	0f 85 9d 00 00 00    	jne    802efb <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802e5e:	83 ec 04             	sub    $0x4,%esp
  802e61:	6a 01                	push   $0x1
  802e63:	ff 75 a4             	pushl  -0x5c(%ebp)
  802e66:	ff 75 a8             	pushl  -0x58(%ebp)
  802e69:	e8 e3 f9 ff ff       	call   802851 <set_block_data>
  802e6e:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802e71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e75:	75 17                	jne    802e8e <alloc_block_BF+0x152>
  802e77:	83 ec 04             	sub    $0x4,%esp
  802e7a:	68 1b 4b 80 00       	push   $0x804b1b
  802e7f:	68 2c 01 00 00       	push   $0x12c
  802e84:	68 39 4b 80 00       	push   $0x804b39
  802e89:	e8 22 d9 ff ff       	call   8007b0 <_panic>
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	8b 00                	mov    (%eax),%eax
  802e93:	85 c0                	test   %eax,%eax
  802e95:	74 10                	je     802ea7 <alloc_block_BF+0x16b>
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 00                	mov    (%eax),%eax
  802e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9f:	8b 52 04             	mov    0x4(%edx),%edx
  802ea2:	89 50 04             	mov    %edx,0x4(%eax)
  802ea5:	eb 0b                	jmp    802eb2 <alloc_block_BF+0x176>
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 40 04             	mov    0x4(%eax),%eax
  802ead:	a3 34 50 80 00       	mov    %eax,0x805034
  802eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb5:	8b 40 04             	mov    0x4(%eax),%eax
  802eb8:	85 c0                	test   %eax,%eax
  802eba:	74 0f                	je     802ecb <alloc_block_BF+0x18f>
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 40 04             	mov    0x4(%eax),%eax
  802ec2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ec5:	8b 12                	mov    (%edx),%edx
  802ec7:	89 10                	mov    %edx,(%eax)
  802ec9:	eb 0a                	jmp    802ed5 <alloc_block_BF+0x199>
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 00                	mov    (%eax),%eax
  802ed0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802eed:	48                   	dec    %eax
  802eee:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802ef3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ef6:	e9 24 04 00 00       	jmp    80331f <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efe:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f01:	76 13                	jbe    802f16 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802f03:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802f0a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802f10:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f13:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802f16:	a1 38 50 80 00       	mov    0x805038,%eax
  802f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f22:	74 07                	je     802f2b <alloc_block_BF+0x1ef>
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	eb 05                	jmp    802f30 <alloc_block_BF+0x1f4>
  802f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f30:	a3 38 50 80 00       	mov    %eax,0x805038
  802f35:	a1 38 50 80 00       	mov    0x805038,%eax
  802f3a:	85 c0                	test   %eax,%eax
  802f3c:	0f 85 bf fe ff ff    	jne    802e01 <alloc_block_BF+0xc5>
  802f42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f46:	0f 85 b5 fe ff ff    	jne    802e01 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802f4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f50:	0f 84 26 02 00 00    	je     80317c <alloc_block_BF+0x440>
  802f56:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f5a:	0f 85 1c 02 00 00    	jne    80317c <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f63:	2b 45 08             	sub    0x8(%ebp),%eax
  802f66:	83 e8 08             	sub    $0x8,%eax
  802f69:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6f:	8d 50 08             	lea    0x8(%eax),%edx
  802f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f75:	01 d0                	add    %edx,%eax
  802f77:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	83 c0 08             	add    $0x8,%eax
  802f80:	83 ec 04             	sub    $0x4,%esp
  802f83:	6a 01                	push   $0x1
  802f85:	50                   	push   %eax
  802f86:	ff 75 f0             	pushl  -0x10(%ebp)
  802f89:	e8 c3 f8 ff ff       	call   802851 <set_block_data>
  802f8e:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f94:	8b 40 04             	mov    0x4(%eax),%eax
  802f97:	85 c0                	test   %eax,%eax
  802f99:	75 68                	jne    803003 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f9b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f9f:	75 17                	jne    802fb8 <alloc_block_BF+0x27c>
  802fa1:	83 ec 04             	sub    $0x4,%esp
  802fa4:	68 54 4b 80 00       	push   $0x804b54
  802fa9:	68 45 01 00 00       	push   $0x145
  802fae:	68 39 4b 80 00       	push   $0x804b39
  802fb3:	e8 f8 d7 ff ff       	call   8007b0 <_panic>
  802fb8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fbe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fc1:	89 10                	mov    %edx,(%eax)
  802fc3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	85 c0                	test   %eax,%eax
  802fca:	74 0d                	je     802fd9 <alloc_block_BF+0x29d>
  802fcc:	a1 30 50 80 00       	mov    0x805030,%eax
  802fd1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fd4:	89 50 04             	mov    %edx,0x4(%eax)
  802fd7:	eb 08                	jmp    802fe1 <alloc_block_BF+0x2a5>
  802fd9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fdc:	a3 34 50 80 00       	mov    %eax,0x805034
  802fe1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fe4:	a3 30 50 80 00       	mov    %eax,0x805030
  802fe9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ff8:	40                   	inc    %eax
  802ff9:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ffe:	e9 dc 00 00 00       	jmp    8030df <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803006:	8b 00                	mov    (%eax),%eax
  803008:	85 c0                	test   %eax,%eax
  80300a:	75 65                	jne    803071 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80300c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803010:	75 17                	jne    803029 <alloc_block_BF+0x2ed>
  803012:	83 ec 04             	sub    $0x4,%esp
  803015:	68 88 4b 80 00       	push   $0x804b88
  80301a:	68 4a 01 00 00       	push   $0x14a
  80301f:	68 39 4b 80 00       	push   $0x804b39
  803024:	e8 87 d7 ff ff       	call   8007b0 <_panic>
  803029:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80302f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803032:	89 50 04             	mov    %edx,0x4(%eax)
  803035:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803038:	8b 40 04             	mov    0x4(%eax),%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	74 0c                	je     80304b <alloc_block_BF+0x30f>
  80303f:	a1 34 50 80 00       	mov    0x805034,%eax
  803044:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803047:	89 10                	mov    %edx,(%eax)
  803049:	eb 08                	jmp    803053 <alloc_block_BF+0x317>
  80304b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80304e:	a3 30 50 80 00       	mov    %eax,0x805030
  803053:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803056:	a3 34 50 80 00       	mov    %eax,0x805034
  80305b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80305e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803064:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803069:	40                   	inc    %eax
  80306a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80306f:	eb 6e                	jmp    8030df <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803071:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803075:	74 06                	je     80307d <alloc_block_BF+0x341>
  803077:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80307b:	75 17                	jne    803094 <alloc_block_BF+0x358>
  80307d:	83 ec 04             	sub    $0x4,%esp
  803080:	68 ac 4b 80 00       	push   $0x804bac
  803085:	68 4f 01 00 00       	push   $0x14f
  80308a:	68 39 4b 80 00       	push   $0x804b39
  80308f:	e8 1c d7 ff ff       	call   8007b0 <_panic>
  803094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803097:	8b 10                	mov    (%eax),%edx
  803099:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80309c:	89 10                	mov    %edx,(%eax)
  80309e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a1:	8b 00                	mov    (%eax),%eax
  8030a3:	85 c0                	test   %eax,%eax
  8030a5:	74 0b                	je     8030b2 <alloc_block_BF+0x376>
  8030a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030aa:	8b 00                	mov    (%eax),%eax
  8030ac:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030af:	89 50 04             	mov    %edx,0x4(%eax)
  8030b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030b8:	89 10                	mov    %edx,(%eax)
  8030ba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c0:	89 50 04             	mov    %edx,0x4(%eax)
  8030c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c6:	8b 00                	mov    (%eax),%eax
  8030c8:	85 c0                	test   %eax,%eax
  8030ca:	75 08                	jne    8030d4 <alloc_block_BF+0x398>
  8030cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030cf:	a3 34 50 80 00       	mov    %eax,0x805034
  8030d4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030d9:	40                   	inc    %eax
  8030da:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8030df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030e3:	75 17                	jne    8030fc <alloc_block_BF+0x3c0>
  8030e5:	83 ec 04             	sub    $0x4,%esp
  8030e8:	68 1b 4b 80 00       	push   $0x804b1b
  8030ed:	68 51 01 00 00       	push   $0x151
  8030f2:	68 39 4b 80 00       	push   $0x804b39
  8030f7:	e8 b4 d6 ff ff       	call   8007b0 <_panic>
  8030fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ff:	8b 00                	mov    (%eax),%eax
  803101:	85 c0                	test   %eax,%eax
  803103:	74 10                	je     803115 <alloc_block_BF+0x3d9>
  803105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803108:	8b 00                	mov    (%eax),%eax
  80310a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80310d:	8b 52 04             	mov    0x4(%edx),%edx
  803110:	89 50 04             	mov    %edx,0x4(%eax)
  803113:	eb 0b                	jmp    803120 <alloc_block_BF+0x3e4>
  803115:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803118:	8b 40 04             	mov    0x4(%eax),%eax
  80311b:	a3 34 50 80 00       	mov    %eax,0x805034
  803120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803123:	8b 40 04             	mov    0x4(%eax),%eax
  803126:	85 c0                	test   %eax,%eax
  803128:	74 0f                	je     803139 <alloc_block_BF+0x3fd>
  80312a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312d:	8b 40 04             	mov    0x4(%eax),%eax
  803130:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803133:	8b 12                	mov    (%edx),%edx
  803135:	89 10                	mov    %edx,(%eax)
  803137:	eb 0a                	jmp    803143 <alloc_block_BF+0x407>
  803139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	a3 30 50 80 00       	mov    %eax,0x805030
  803143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803146:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80314c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803156:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80315b:	48                   	dec    %eax
  80315c:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  803161:	83 ec 04             	sub    $0x4,%esp
  803164:	6a 00                	push   $0x0
  803166:	ff 75 d0             	pushl  -0x30(%ebp)
  803169:	ff 75 cc             	pushl  -0x34(%ebp)
  80316c:	e8 e0 f6 ff ff       	call   802851 <set_block_data>
  803171:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803177:	e9 a3 01 00 00       	jmp    80331f <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80317c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803180:	0f 85 9d 00 00 00    	jne    803223 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803186:	83 ec 04             	sub    $0x4,%esp
  803189:	6a 01                	push   $0x1
  80318b:	ff 75 ec             	pushl  -0x14(%ebp)
  80318e:	ff 75 f0             	pushl  -0x10(%ebp)
  803191:	e8 bb f6 ff ff       	call   802851 <set_block_data>
  803196:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803199:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80319d:	75 17                	jne    8031b6 <alloc_block_BF+0x47a>
  80319f:	83 ec 04             	sub    $0x4,%esp
  8031a2:	68 1b 4b 80 00       	push   $0x804b1b
  8031a7:	68 58 01 00 00       	push   $0x158
  8031ac:	68 39 4b 80 00       	push   $0x804b39
  8031b1:	e8 fa d5 ff ff       	call   8007b0 <_panic>
  8031b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b9:	8b 00                	mov    (%eax),%eax
  8031bb:	85 c0                	test   %eax,%eax
  8031bd:	74 10                	je     8031cf <alloc_block_BF+0x493>
  8031bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c2:	8b 00                	mov    (%eax),%eax
  8031c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031c7:	8b 52 04             	mov    0x4(%edx),%edx
  8031ca:	89 50 04             	mov    %edx,0x4(%eax)
  8031cd:	eb 0b                	jmp    8031da <alloc_block_BF+0x49e>
  8031cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d2:	8b 40 04             	mov    0x4(%eax),%eax
  8031d5:	a3 34 50 80 00       	mov    %eax,0x805034
  8031da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031dd:	8b 40 04             	mov    0x4(%eax),%eax
  8031e0:	85 c0                	test   %eax,%eax
  8031e2:	74 0f                	je     8031f3 <alloc_block_BF+0x4b7>
  8031e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ed:	8b 12                	mov    (%edx),%edx
  8031ef:	89 10                	mov    %edx,(%eax)
  8031f1:	eb 0a                	jmp    8031fd <alloc_block_BF+0x4c1>
  8031f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f6:	8b 00                	mov    (%eax),%eax
  8031f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8031fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803200:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803206:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803209:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803210:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803215:	48                   	dec    %eax
  803216:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  80321b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321e:	e9 fc 00 00 00       	jmp    80331f <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	83 c0 08             	add    $0x8,%eax
  803229:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80322c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803233:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803236:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803239:	01 d0                	add    %edx,%eax
  80323b:	48                   	dec    %eax
  80323c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80323f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803242:	ba 00 00 00 00       	mov    $0x0,%edx
  803247:	f7 75 c4             	divl   -0x3c(%ebp)
  80324a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80324d:	29 d0                	sub    %edx,%eax
  80324f:	c1 e8 0c             	shr    $0xc,%eax
  803252:	83 ec 0c             	sub    $0xc,%esp
  803255:	50                   	push   %eax
  803256:	e8 b4 e7 ff ff       	call   801a0f <sbrk>
  80325b:	83 c4 10             	add    $0x10,%esp
  80325e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803261:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803265:	75 0a                	jne    803271 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803267:	b8 00 00 00 00       	mov    $0x0,%eax
  80326c:	e9 ae 00 00 00       	jmp    80331f <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803271:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803278:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80327b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80327e:	01 d0                	add    %edx,%eax
  803280:	48                   	dec    %eax
  803281:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803284:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803287:	ba 00 00 00 00       	mov    $0x0,%edx
  80328c:	f7 75 b8             	divl   -0x48(%ebp)
  80328f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803292:	29 d0                	sub    %edx,%eax
  803294:	8d 50 fc             	lea    -0x4(%eax),%edx
  803297:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80329a:	01 d0                	add    %edx,%eax
  80329c:	a3 48 50 80 00       	mov    %eax,0x805048
				end_block->info = 1;
  8032a1:	a1 48 50 80 00       	mov    0x805048,%eax
  8032a6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8032ac:	83 ec 0c             	sub    $0xc,%esp
  8032af:	68 e0 4b 80 00       	push   $0x804be0
  8032b4:	e8 b4 d7 ff ff       	call   800a6d <cprintf>
  8032b9:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8032bc:	83 ec 08             	sub    $0x8,%esp
  8032bf:	ff 75 bc             	pushl  -0x44(%ebp)
  8032c2:	68 e5 4b 80 00       	push   $0x804be5
  8032c7:	e8 a1 d7 ff ff       	call   800a6d <cprintf>
  8032cc:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8032cf:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8032d6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032dc:	01 d0                	add    %edx,%eax
  8032de:	48                   	dec    %eax
  8032df:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8032e2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8032e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8032ea:	f7 75 b0             	divl   -0x50(%ebp)
  8032ed:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8032f0:	29 d0                	sub    %edx,%eax
  8032f2:	83 ec 04             	sub    $0x4,%esp
  8032f5:	6a 01                	push   $0x1
  8032f7:	50                   	push   %eax
  8032f8:	ff 75 bc             	pushl  -0x44(%ebp)
  8032fb:	e8 51 f5 ff ff       	call   802851 <set_block_data>
  803300:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803303:	83 ec 0c             	sub    $0xc,%esp
  803306:	ff 75 bc             	pushl  -0x44(%ebp)
  803309:	e8 36 04 00 00       	call   803744 <free_block>
  80330e:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803311:	83 ec 0c             	sub    $0xc,%esp
  803314:	ff 75 08             	pushl  0x8(%ebp)
  803317:	e8 20 fa ff ff       	call   802d3c <alloc_block_BF>
  80331c:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80331f:	c9                   	leave  
  803320:	c3                   	ret    

00803321 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803321:	55                   	push   %ebp
  803322:	89 e5                	mov    %esp,%ebp
  803324:	53                   	push   %ebx
  803325:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80332f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803336:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80333a:	74 1e                	je     80335a <merging+0x39>
  80333c:	ff 75 08             	pushl  0x8(%ebp)
  80333f:	e8 bc f1 ff ff       	call   802500 <get_block_size>
  803344:	83 c4 04             	add    $0x4,%esp
  803347:	89 c2                	mov    %eax,%edx
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	01 d0                	add    %edx,%eax
  80334e:	3b 45 10             	cmp    0x10(%ebp),%eax
  803351:	75 07                	jne    80335a <merging+0x39>
		prev_is_free = 1;
  803353:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80335a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80335e:	74 1e                	je     80337e <merging+0x5d>
  803360:	ff 75 10             	pushl  0x10(%ebp)
  803363:	e8 98 f1 ff ff       	call   802500 <get_block_size>
  803368:	83 c4 04             	add    $0x4,%esp
  80336b:	89 c2                	mov    %eax,%edx
  80336d:	8b 45 10             	mov    0x10(%ebp),%eax
  803370:	01 d0                	add    %edx,%eax
  803372:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803375:	75 07                	jne    80337e <merging+0x5d>
		next_is_free = 1;
  803377:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80337e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803382:	0f 84 cc 00 00 00    	je     803454 <merging+0x133>
  803388:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80338c:	0f 84 c2 00 00 00    	je     803454 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803392:	ff 75 08             	pushl  0x8(%ebp)
  803395:	e8 66 f1 ff ff       	call   802500 <get_block_size>
  80339a:	83 c4 04             	add    $0x4,%esp
  80339d:	89 c3                	mov    %eax,%ebx
  80339f:	ff 75 10             	pushl  0x10(%ebp)
  8033a2:	e8 59 f1 ff ff       	call   802500 <get_block_size>
  8033a7:	83 c4 04             	add    $0x4,%esp
  8033aa:	01 c3                	add    %eax,%ebx
  8033ac:	ff 75 0c             	pushl  0xc(%ebp)
  8033af:	e8 4c f1 ff ff       	call   802500 <get_block_size>
  8033b4:	83 c4 04             	add    $0x4,%esp
  8033b7:	01 d8                	add    %ebx,%eax
  8033b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8033bc:	6a 00                	push   $0x0
  8033be:	ff 75 ec             	pushl  -0x14(%ebp)
  8033c1:	ff 75 08             	pushl  0x8(%ebp)
  8033c4:	e8 88 f4 ff ff       	call   802851 <set_block_data>
  8033c9:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8033cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033d0:	75 17                	jne    8033e9 <merging+0xc8>
  8033d2:	83 ec 04             	sub    $0x4,%esp
  8033d5:	68 1b 4b 80 00       	push   $0x804b1b
  8033da:	68 7d 01 00 00       	push   $0x17d
  8033df:	68 39 4b 80 00       	push   $0x804b39
  8033e4:	e8 c7 d3 ff ff       	call   8007b0 <_panic>
  8033e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	85 c0                	test   %eax,%eax
  8033f0:	74 10                	je     803402 <merging+0xe1>
  8033f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f5:	8b 00                	mov    (%eax),%eax
  8033f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033fa:	8b 52 04             	mov    0x4(%edx),%edx
  8033fd:	89 50 04             	mov    %edx,0x4(%eax)
  803400:	eb 0b                	jmp    80340d <merging+0xec>
  803402:	8b 45 0c             	mov    0xc(%ebp),%eax
  803405:	8b 40 04             	mov    0x4(%eax),%eax
  803408:	a3 34 50 80 00       	mov    %eax,0x805034
  80340d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803410:	8b 40 04             	mov    0x4(%eax),%eax
  803413:	85 c0                	test   %eax,%eax
  803415:	74 0f                	je     803426 <merging+0x105>
  803417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80341a:	8b 40 04             	mov    0x4(%eax),%eax
  80341d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803420:	8b 12                	mov    (%edx),%edx
  803422:	89 10                	mov    %edx,(%eax)
  803424:	eb 0a                	jmp    803430 <merging+0x10f>
  803426:	8b 45 0c             	mov    0xc(%ebp),%eax
  803429:	8b 00                	mov    (%eax),%eax
  80342b:	a3 30 50 80 00       	mov    %eax,0x805030
  803430:	8b 45 0c             	mov    0xc(%ebp),%eax
  803433:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803439:	8b 45 0c             	mov    0xc(%ebp),%eax
  80343c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803443:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803448:	48                   	dec    %eax
  803449:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80344e:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80344f:	e9 ea 02 00 00       	jmp    80373e <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803458:	74 3b                	je     803495 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80345a:	83 ec 0c             	sub    $0xc,%esp
  80345d:	ff 75 08             	pushl  0x8(%ebp)
  803460:	e8 9b f0 ff ff       	call   802500 <get_block_size>
  803465:	83 c4 10             	add    $0x10,%esp
  803468:	89 c3                	mov    %eax,%ebx
  80346a:	83 ec 0c             	sub    $0xc,%esp
  80346d:	ff 75 10             	pushl  0x10(%ebp)
  803470:	e8 8b f0 ff ff       	call   802500 <get_block_size>
  803475:	83 c4 10             	add    $0x10,%esp
  803478:	01 d8                	add    %ebx,%eax
  80347a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80347d:	83 ec 04             	sub    $0x4,%esp
  803480:	6a 00                	push   $0x0
  803482:	ff 75 e8             	pushl  -0x18(%ebp)
  803485:	ff 75 08             	pushl  0x8(%ebp)
  803488:	e8 c4 f3 ff ff       	call   802851 <set_block_data>
  80348d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803490:	e9 a9 02 00 00       	jmp    80373e <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803495:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803499:	0f 84 2d 01 00 00    	je     8035cc <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80349f:	83 ec 0c             	sub    $0xc,%esp
  8034a2:	ff 75 10             	pushl  0x10(%ebp)
  8034a5:	e8 56 f0 ff ff       	call   802500 <get_block_size>
  8034aa:	83 c4 10             	add    $0x10,%esp
  8034ad:	89 c3                	mov    %eax,%ebx
  8034af:	83 ec 0c             	sub    $0xc,%esp
  8034b2:	ff 75 0c             	pushl  0xc(%ebp)
  8034b5:	e8 46 f0 ff ff       	call   802500 <get_block_size>
  8034ba:	83 c4 10             	add    $0x10,%esp
  8034bd:	01 d8                	add    %ebx,%eax
  8034bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8034c2:	83 ec 04             	sub    $0x4,%esp
  8034c5:	6a 00                	push   $0x0
  8034c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034ca:	ff 75 10             	pushl  0x10(%ebp)
  8034cd:	e8 7f f3 ff ff       	call   802851 <set_block_data>
  8034d2:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8034d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8034d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8034db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034df:	74 06                	je     8034e7 <merging+0x1c6>
  8034e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034e5:	75 17                	jne    8034fe <merging+0x1dd>
  8034e7:	83 ec 04             	sub    $0x4,%esp
  8034ea:	68 f4 4b 80 00       	push   $0x804bf4
  8034ef:	68 8d 01 00 00       	push   $0x18d
  8034f4:	68 39 4b 80 00       	push   $0x804b39
  8034f9:	e8 b2 d2 ff ff       	call   8007b0 <_panic>
  8034fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803501:	8b 50 04             	mov    0x4(%eax),%edx
  803504:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803507:	89 50 04             	mov    %edx,0x4(%eax)
  80350a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80350d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803510:	89 10                	mov    %edx,(%eax)
  803512:	8b 45 0c             	mov    0xc(%ebp),%eax
  803515:	8b 40 04             	mov    0x4(%eax),%eax
  803518:	85 c0                	test   %eax,%eax
  80351a:	74 0d                	je     803529 <merging+0x208>
  80351c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351f:	8b 40 04             	mov    0x4(%eax),%eax
  803522:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803525:	89 10                	mov    %edx,(%eax)
  803527:	eb 08                	jmp    803531 <merging+0x210>
  803529:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80352c:	a3 30 50 80 00       	mov    %eax,0x805030
  803531:	8b 45 0c             	mov    0xc(%ebp),%eax
  803534:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803537:	89 50 04             	mov    %edx,0x4(%eax)
  80353a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80353f:	40                   	inc    %eax
  803540:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  803545:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803549:	75 17                	jne    803562 <merging+0x241>
  80354b:	83 ec 04             	sub    $0x4,%esp
  80354e:	68 1b 4b 80 00       	push   $0x804b1b
  803553:	68 8e 01 00 00       	push   $0x18e
  803558:	68 39 4b 80 00       	push   $0x804b39
  80355d:	e8 4e d2 ff ff       	call   8007b0 <_panic>
  803562:	8b 45 0c             	mov    0xc(%ebp),%eax
  803565:	8b 00                	mov    (%eax),%eax
  803567:	85 c0                	test   %eax,%eax
  803569:	74 10                	je     80357b <merging+0x25a>
  80356b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80356e:	8b 00                	mov    (%eax),%eax
  803570:	8b 55 0c             	mov    0xc(%ebp),%edx
  803573:	8b 52 04             	mov    0x4(%edx),%edx
  803576:	89 50 04             	mov    %edx,0x4(%eax)
  803579:	eb 0b                	jmp    803586 <merging+0x265>
  80357b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80357e:	8b 40 04             	mov    0x4(%eax),%eax
  803581:	a3 34 50 80 00       	mov    %eax,0x805034
  803586:	8b 45 0c             	mov    0xc(%ebp),%eax
  803589:	8b 40 04             	mov    0x4(%eax),%eax
  80358c:	85 c0                	test   %eax,%eax
  80358e:	74 0f                	je     80359f <merging+0x27e>
  803590:	8b 45 0c             	mov    0xc(%ebp),%eax
  803593:	8b 40 04             	mov    0x4(%eax),%eax
  803596:	8b 55 0c             	mov    0xc(%ebp),%edx
  803599:	8b 12                	mov    (%edx),%edx
  80359b:	89 10                	mov    %edx,(%eax)
  80359d:	eb 0a                	jmp    8035a9 <merging+0x288>
  80359f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035a2:	8b 00                	mov    (%eax),%eax
  8035a4:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035bc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035c1:	48                   	dec    %eax
  8035c2:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035c7:	e9 72 01 00 00       	jmp    80373e <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8035cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8035cf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8035d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035d6:	74 79                	je     803651 <merging+0x330>
  8035d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035dc:	74 73                	je     803651 <merging+0x330>
  8035de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e2:	74 06                	je     8035ea <merging+0x2c9>
  8035e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035e8:	75 17                	jne    803601 <merging+0x2e0>
  8035ea:	83 ec 04             	sub    $0x4,%esp
  8035ed:	68 ac 4b 80 00       	push   $0x804bac
  8035f2:	68 94 01 00 00       	push   $0x194
  8035f7:	68 39 4b 80 00       	push   $0x804b39
  8035fc:	e8 af d1 ff ff       	call   8007b0 <_panic>
  803601:	8b 45 08             	mov    0x8(%ebp),%eax
  803604:	8b 10                	mov    (%eax),%edx
  803606:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803609:	89 10                	mov    %edx,(%eax)
  80360b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80360e:	8b 00                	mov    (%eax),%eax
  803610:	85 c0                	test   %eax,%eax
  803612:	74 0b                	je     80361f <merging+0x2fe>
  803614:	8b 45 08             	mov    0x8(%ebp),%eax
  803617:	8b 00                	mov    (%eax),%eax
  803619:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80361c:	89 50 04             	mov    %edx,0x4(%eax)
  80361f:	8b 45 08             	mov    0x8(%ebp),%eax
  803622:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803625:	89 10                	mov    %edx,(%eax)
  803627:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80362a:	8b 55 08             	mov    0x8(%ebp),%edx
  80362d:	89 50 04             	mov    %edx,0x4(%eax)
  803630:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803633:	8b 00                	mov    (%eax),%eax
  803635:	85 c0                	test   %eax,%eax
  803637:	75 08                	jne    803641 <merging+0x320>
  803639:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80363c:	a3 34 50 80 00       	mov    %eax,0x805034
  803641:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803646:	40                   	inc    %eax
  803647:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80364c:	e9 ce 00 00 00       	jmp    80371f <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803651:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803655:	74 65                	je     8036bc <merging+0x39b>
  803657:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80365b:	75 17                	jne    803674 <merging+0x353>
  80365d:	83 ec 04             	sub    $0x4,%esp
  803660:	68 88 4b 80 00       	push   $0x804b88
  803665:	68 95 01 00 00       	push   $0x195
  80366a:	68 39 4b 80 00       	push   $0x804b39
  80366f:	e8 3c d1 ff ff       	call   8007b0 <_panic>
  803674:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80367a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80367d:	89 50 04             	mov    %edx,0x4(%eax)
  803680:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803683:	8b 40 04             	mov    0x4(%eax),%eax
  803686:	85 c0                	test   %eax,%eax
  803688:	74 0c                	je     803696 <merging+0x375>
  80368a:	a1 34 50 80 00       	mov    0x805034,%eax
  80368f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803692:	89 10                	mov    %edx,(%eax)
  803694:	eb 08                	jmp    80369e <merging+0x37d>
  803696:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803699:	a3 30 50 80 00       	mov    %eax,0x805030
  80369e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036a1:	a3 34 50 80 00       	mov    %eax,0x805034
  8036a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036af:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036b4:	40                   	inc    %eax
  8036b5:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036ba:	eb 63                	jmp    80371f <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8036bc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036c0:	75 17                	jne    8036d9 <merging+0x3b8>
  8036c2:	83 ec 04             	sub    $0x4,%esp
  8036c5:	68 54 4b 80 00       	push   $0x804b54
  8036ca:	68 98 01 00 00       	push   $0x198
  8036cf:	68 39 4b 80 00       	push   $0x804b39
  8036d4:	e8 d7 d0 ff ff       	call   8007b0 <_panic>
  8036d9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036e2:	89 10                	mov    %edx,(%eax)
  8036e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036e7:	8b 00                	mov    (%eax),%eax
  8036e9:	85 c0                	test   %eax,%eax
  8036eb:	74 0d                	je     8036fa <merging+0x3d9>
  8036ed:	a1 30 50 80 00       	mov    0x805030,%eax
  8036f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036f5:	89 50 04             	mov    %edx,0x4(%eax)
  8036f8:	eb 08                	jmp    803702 <merging+0x3e1>
  8036fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036fd:	a3 34 50 80 00       	mov    %eax,0x805034
  803702:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803705:	a3 30 50 80 00       	mov    %eax,0x805030
  80370a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80370d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803714:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803719:	40                   	inc    %eax
  80371a:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  80371f:	83 ec 0c             	sub    $0xc,%esp
  803722:	ff 75 10             	pushl  0x10(%ebp)
  803725:	e8 d6 ed ff ff       	call   802500 <get_block_size>
  80372a:	83 c4 10             	add    $0x10,%esp
  80372d:	83 ec 04             	sub    $0x4,%esp
  803730:	6a 00                	push   $0x0
  803732:	50                   	push   %eax
  803733:	ff 75 10             	pushl  0x10(%ebp)
  803736:	e8 16 f1 ff ff       	call   802851 <set_block_data>
  80373b:	83 c4 10             	add    $0x10,%esp
	}
}
  80373e:	90                   	nop
  80373f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803742:	c9                   	leave  
  803743:	c3                   	ret    

00803744 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803744:	55                   	push   %ebp
  803745:	89 e5                	mov    %esp,%ebp
  803747:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80374a:	a1 30 50 80 00       	mov    0x805030,%eax
  80374f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803752:	a1 34 50 80 00       	mov    0x805034,%eax
  803757:	3b 45 08             	cmp    0x8(%ebp),%eax
  80375a:	73 1b                	jae    803777 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80375c:	a1 34 50 80 00       	mov    0x805034,%eax
  803761:	83 ec 04             	sub    $0x4,%esp
  803764:	ff 75 08             	pushl  0x8(%ebp)
  803767:	6a 00                	push   $0x0
  803769:	50                   	push   %eax
  80376a:	e8 b2 fb ff ff       	call   803321 <merging>
  80376f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803772:	e9 8b 00 00 00       	jmp    803802 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803777:	a1 30 50 80 00       	mov    0x805030,%eax
  80377c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80377f:	76 18                	jbe    803799 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803781:	a1 30 50 80 00       	mov    0x805030,%eax
  803786:	83 ec 04             	sub    $0x4,%esp
  803789:	ff 75 08             	pushl  0x8(%ebp)
  80378c:	50                   	push   %eax
  80378d:	6a 00                	push   $0x0
  80378f:	e8 8d fb ff ff       	call   803321 <merging>
  803794:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803797:	eb 69                	jmp    803802 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803799:	a1 30 50 80 00       	mov    0x805030,%eax
  80379e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037a1:	eb 39                	jmp    8037dc <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8037a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037a9:	73 29                	jae    8037d4 <free_block+0x90>
  8037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ae:	8b 00                	mov    (%eax),%eax
  8037b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037b3:	76 1f                	jbe    8037d4 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8037b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b8:	8b 00                	mov    (%eax),%eax
  8037ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8037bd:	83 ec 04             	sub    $0x4,%esp
  8037c0:	ff 75 08             	pushl  0x8(%ebp)
  8037c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8037c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8037c9:	e8 53 fb ff ff       	call   803321 <merging>
  8037ce:	83 c4 10             	add    $0x10,%esp
			break;
  8037d1:	90                   	nop
		}
	}
}
  8037d2:	eb 2e                	jmp    803802 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8037d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8037d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e0:	74 07                	je     8037e9 <free_block+0xa5>
  8037e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e5:	8b 00                	mov    (%eax),%eax
  8037e7:	eb 05                	jmp    8037ee <free_block+0xaa>
  8037e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ee:	a3 38 50 80 00       	mov    %eax,0x805038
  8037f3:	a1 38 50 80 00       	mov    0x805038,%eax
  8037f8:	85 c0                	test   %eax,%eax
  8037fa:	75 a7                	jne    8037a3 <free_block+0x5f>
  8037fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803800:	75 a1                	jne    8037a3 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803802:	90                   	nop
  803803:	c9                   	leave  
  803804:	c3                   	ret    

00803805 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803805:	55                   	push   %ebp
  803806:	89 e5                	mov    %esp,%ebp
  803808:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80380b:	ff 75 08             	pushl  0x8(%ebp)
  80380e:	e8 ed ec ff ff       	call   802500 <get_block_size>
  803813:	83 c4 04             	add    $0x4,%esp
  803816:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803819:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803820:	eb 17                	jmp    803839 <copy_data+0x34>
  803822:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803825:	8b 45 0c             	mov    0xc(%ebp),%eax
  803828:	01 c2                	add    %eax,%edx
  80382a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80382d:	8b 45 08             	mov    0x8(%ebp),%eax
  803830:	01 c8                	add    %ecx,%eax
  803832:	8a 00                	mov    (%eax),%al
  803834:	88 02                	mov    %al,(%edx)
  803836:	ff 45 fc             	incl   -0x4(%ebp)
  803839:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80383c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80383f:	72 e1                	jb     803822 <copy_data+0x1d>
}
  803841:	90                   	nop
  803842:	c9                   	leave  
  803843:	c3                   	ret    

00803844 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803844:	55                   	push   %ebp
  803845:	89 e5                	mov    %esp,%ebp
  803847:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80384a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80384e:	75 23                	jne    803873 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803850:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803854:	74 13                	je     803869 <realloc_block_FF+0x25>
  803856:	83 ec 0c             	sub    $0xc,%esp
  803859:	ff 75 0c             	pushl  0xc(%ebp)
  80385c:	e8 1f f0 ff ff       	call   802880 <alloc_block_FF>
  803861:	83 c4 10             	add    $0x10,%esp
  803864:	e9 f4 06 00 00       	jmp    803f5d <realloc_block_FF+0x719>
		return NULL;
  803869:	b8 00 00 00 00       	mov    $0x0,%eax
  80386e:	e9 ea 06 00 00       	jmp    803f5d <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803873:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803877:	75 18                	jne    803891 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803879:	83 ec 0c             	sub    $0xc,%esp
  80387c:	ff 75 08             	pushl  0x8(%ebp)
  80387f:	e8 c0 fe ff ff       	call   803744 <free_block>
  803884:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803887:	b8 00 00 00 00       	mov    $0x0,%eax
  80388c:	e9 cc 06 00 00       	jmp    803f5d <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803891:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803895:	77 07                	ja     80389e <realloc_block_FF+0x5a>
  803897:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80389e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038a1:	83 e0 01             	and    $0x1,%eax
  8038a4:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8038a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038aa:	83 c0 08             	add    $0x8,%eax
  8038ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8038b0:	83 ec 0c             	sub    $0xc,%esp
  8038b3:	ff 75 08             	pushl  0x8(%ebp)
  8038b6:	e8 45 ec ff ff       	call   802500 <get_block_size>
  8038bb:	83 c4 10             	add    $0x10,%esp
  8038be:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8038c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038c4:	83 e8 08             	sub    $0x8,%eax
  8038c7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8038ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cd:	83 e8 04             	sub    $0x4,%eax
  8038d0:	8b 00                	mov    (%eax),%eax
  8038d2:	83 e0 fe             	and    $0xfffffffe,%eax
  8038d5:	89 c2                	mov    %eax,%edx
  8038d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038da:	01 d0                	add    %edx,%eax
  8038dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8038df:	83 ec 0c             	sub    $0xc,%esp
  8038e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038e5:	e8 16 ec ff ff       	call   802500 <get_block_size>
  8038ea:	83 c4 10             	add    $0x10,%esp
  8038ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8038f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038f3:	83 e8 08             	sub    $0x8,%eax
  8038f6:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8038f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038fc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038ff:	75 08                	jne    803909 <realloc_block_FF+0xc5>
	{
		 return va;
  803901:	8b 45 08             	mov    0x8(%ebp),%eax
  803904:	e9 54 06 00 00       	jmp    803f5d <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803909:	8b 45 0c             	mov    0xc(%ebp),%eax
  80390c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80390f:	0f 83 e5 03 00 00    	jae    803cfa <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803915:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803918:	2b 45 0c             	sub    0xc(%ebp),%eax
  80391b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80391e:	83 ec 0c             	sub    $0xc,%esp
  803921:	ff 75 e4             	pushl  -0x1c(%ebp)
  803924:	e8 f0 eb ff ff       	call   802519 <is_free_block>
  803929:	83 c4 10             	add    $0x10,%esp
  80392c:	84 c0                	test   %al,%al
  80392e:	0f 84 3b 01 00 00    	je     803a6f <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803934:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803937:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80393a:	01 d0                	add    %edx,%eax
  80393c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80393f:	83 ec 04             	sub    $0x4,%esp
  803942:	6a 01                	push   $0x1
  803944:	ff 75 f0             	pushl  -0x10(%ebp)
  803947:	ff 75 08             	pushl  0x8(%ebp)
  80394a:	e8 02 ef ff ff       	call   802851 <set_block_data>
  80394f:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803952:	8b 45 08             	mov    0x8(%ebp),%eax
  803955:	83 e8 04             	sub    $0x4,%eax
  803958:	8b 00                	mov    (%eax),%eax
  80395a:	83 e0 fe             	and    $0xfffffffe,%eax
  80395d:	89 c2                	mov    %eax,%edx
  80395f:	8b 45 08             	mov    0x8(%ebp),%eax
  803962:	01 d0                	add    %edx,%eax
  803964:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803967:	83 ec 04             	sub    $0x4,%esp
  80396a:	6a 00                	push   $0x0
  80396c:	ff 75 cc             	pushl  -0x34(%ebp)
  80396f:	ff 75 c8             	pushl  -0x38(%ebp)
  803972:	e8 da ee ff ff       	call   802851 <set_block_data>
  803977:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80397a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80397e:	74 06                	je     803986 <realloc_block_FF+0x142>
  803980:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803984:	75 17                	jne    80399d <realloc_block_FF+0x159>
  803986:	83 ec 04             	sub    $0x4,%esp
  803989:	68 ac 4b 80 00       	push   $0x804bac
  80398e:	68 f6 01 00 00       	push   $0x1f6
  803993:	68 39 4b 80 00       	push   $0x804b39
  803998:	e8 13 ce ff ff       	call   8007b0 <_panic>
  80399d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a0:	8b 10                	mov    (%eax),%edx
  8039a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039a5:	89 10                	mov    %edx,(%eax)
  8039a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039aa:	8b 00                	mov    (%eax),%eax
  8039ac:	85 c0                	test   %eax,%eax
  8039ae:	74 0b                	je     8039bb <realloc_block_FF+0x177>
  8039b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b3:	8b 00                	mov    (%eax),%eax
  8039b5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039b8:	89 50 04             	mov    %edx,0x4(%eax)
  8039bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039be:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039c1:	89 10                	mov    %edx,(%eax)
  8039c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039c9:	89 50 04             	mov    %edx,0x4(%eax)
  8039cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039cf:	8b 00                	mov    (%eax),%eax
  8039d1:	85 c0                	test   %eax,%eax
  8039d3:	75 08                	jne    8039dd <realloc_block_FF+0x199>
  8039d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039d8:	a3 34 50 80 00       	mov    %eax,0x805034
  8039dd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039e2:	40                   	inc    %eax
  8039e3:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8039e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039ec:	75 17                	jne    803a05 <realloc_block_FF+0x1c1>
  8039ee:	83 ec 04             	sub    $0x4,%esp
  8039f1:	68 1b 4b 80 00       	push   $0x804b1b
  8039f6:	68 f7 01 00 00       	push   $0x1f7
  8039fb:	68 39 4b 80 00       	push   $0x804b39
  803a00:	e8 ab cd ff ff       	call   8007b0 <_panic>
  803a05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a08:	8b 00                	mov    (%eax),%eax
  803a0a:	85 c0                	test   %eax,%eax
  803a0c:	74 10                	je     803a1e <realloc_block_FF+0x1da>
  803a0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a11:	8b 00                	mov    (%eax),%eax
  803a13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a16:	8b 52 04             	mov    0x4(%edx),%edx
  803a19:	89 50 04             	mov    %edx,0x4(%eax)
  803a1c:	eb 0b                	jmp    803a29 <realloc_block_FF+0x1e5>
  803a1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a21:	8b 40 04             	mov    0x4(%eax),%eax
  803a24:	a3 34 50 80 00       	mov    %eax,0x805034
  803a29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2c:	8b 40 04             	mov    0x4(%eax),%eax
  803a2f:	85 c0                	test   %eax,%eax
  803a31:	74 0f                	je     803a42 <realloc_block_FF+0x1fe>
  803a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a36:	8b 40 04             	mov    0x4(%eax),%eax
  803a39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a3c:	8b 12                	mov    (%edx),%edx
  803a3e:	89 10                	mov    %edx,(%eax)
  803a40:	eb 0a                	jmp    803a4c <realloc_block_FF+0x208>
  803a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a45:	8b 00                	mov    (%eax),%eax
  803a47:	a3 30 50 80 00       	mov    %eax,0x805030
  803a4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a5f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a64:	48                   	dec    %eax
  803a65:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a6a:	e9 83 02 00 00       	jmp    803cf2 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803a6f:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803a73:	0f 86 69 02 00 00    	jbe    803ce2 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803a79:	83 ec 04             	sub    $0x4,%esp
  803a7c:	6a 01                	push   $0x1
  803a7e:	ff 75 f0             	pushl  -0x10(%ebp)
  803a81:	ff 75 08             	pushl  0x8(%ebp)
  803a84:	e8 c8 ed ff ff       	call   802851 <set_block_data>
  803a89:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8f:	83 e8 04             	sub    $0x4,%eax
  803a92:	8b 00                	mov    (%eax),%eax
  803a94:	83 e0 fe             	and    $0xfffffffe,%eax
  803a97:	89 c2                	mov    %eax,%edx
  803a99:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9c:	01 d0                	add    %edx,%eax
  803a9e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803aa1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803aa6:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803aa9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803aad:	75 68                	jne    803b17 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803aaf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ab3:	75 17                	jne    803acc <realloc_block_FF+0x288>
  803ab5:	83 ec 04             	sub    $0x4,%esp
  803ab8:	68 54 4b 80 00       	push   $0x804b54
  803abd:	68 06 02 00 00       	push   $0x206
  803ac2:	68 39 4b 80 00       	push   $0x804b39
  803ac7:	e8 e4 cc ff ff       	call   8007b0 <_panic>
  803acc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803ad2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ad5:	89 10                	mov    %edx,(%eax)
  803ad7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ada:	8b 00                	mov    (%eax),%eax
  803adc:	85 c0                	test   %eax,%eax
  803ade:	74 0d                	je     803aed <realloc_block_FF+0x2a9>
  803ae0:	a1 30 50 80 00       	mov    0x805030,%eax
  803ae5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ae8:	89 50 04             	mov    %edx,0x4(%eax)
  803aeb:	eb 08                	jmp    803af5 <realloc_block_FF+0x2b1>
  803aed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803af0:	a3 34 50 80 00       	mov    %eax,0x805034
  803af5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803af8:	a3 30 50 80 00       	mov    %eax,0x805030
  803afd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b07:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b0c:	40                   	inc    %eax
  803b0d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b12:	e9 b0 01 00 00       	jmp    803cc7 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803b17:	a1 30 50 80 00       	mov    0x805030,%eax
  803b1c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b1f:	76 68                	jbe    803b89 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b21:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b25:	75 17                	jne    803b3e <realloc_block_FF+0x2fa>
  803b27:	83 ec 04             	sub    $0x4,%esp
  803b2a:	68 54 4b 80 00       	push   $0x804b54
  803b2f:	68 0b 02 00 00       	push   $0x20b
  803b34:	68 39 4b 80 00       	push   $0x804b39
  803b39:	e8 72 cc ff ff       	call   8007b0 <_panic>
  803b3e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b47:	89 10                	mov    %edx,(%eax)
  803b49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b4c:	8b 00                	mov    (%eax),%eax
  803b4e:	85 c0                	test   %eax,%eax
  803b50:	74 0d                	je     803b5f <realloc_block_FF+0x31b>
  803b52:	a1 30 50 80 00       	mov    0x805030,%eax
  803b57:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b5a:	89 50 04             	mov    %edx,0x4(%eax)
  803b5d:	eb 08                	jmp    803b67 <realloc_block_FF+0x323>
  803b5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b62:	a3 34 50 80 00       	mov    %eax,0x805034
  803b67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b6a:	a3 30 50 80 00       	mov    %eax,0x805030
  803b6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b79:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b7e:	40                   	inc    %eax
  803b7f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b84:	e9 3e 01 00 00       	jmp    803cc7 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803b89:	a1 30 50 80 00       	mov    0x805030,%eax
  803b8e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b91:	73 68                	jae    803bfb <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b93:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b97:	75 17                	jne    803bb0 <realloc_block_FF+0x36c>
  803b99:	83 ec 04             	sub    $0x4,%esp
  803b9c:	68 88 4b 80 00       	push   $0x804b88
  803ba1:	68 10 02 00 00       	push   $0x210
  803ba6:	68 39 4b 80 00       	push   $0x804b39
  803bab:	e8 00 cc ff ff       	call   8007b0 <_panic>
  803bb0:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803bb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bb9:	89 50 04             	mov    %edx,0x4(%eax)
  803bbc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bbf:	8b 40 04             	mov    0x4(%eax),%eax
  803bc2:	85 c0                	test   %eax,%eax
  803bc4:	74 0c                	je     803bd2 <realloc_block_FF+0x38e>
  803bc6:	a1 34 50 80 00       	mov    0x805034,%eax
  803bcb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bce:	89 10                	mov    %edx,(%eax)
  803bd0:	eb 08                	jmp    803bda <realloc_block_FF+0x396>
  803bd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bd5:	a3 30 50 80 00       	mov    %eax,0x805030
  803bda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bdd:	a3 34 50 80 00       	mov    %eax,0x805034
  803be2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803beb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bf0:	40                   	inc    %eax
  803bf1:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803bf6:	e9 cc 00 00 00       	jmp    803cc7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803bfb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803c02:	a1 30 50 80 00       	mov    0x805030,%eax
  803c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c0a:	e9 8a 00 00 00       	jmp    803c99 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c12:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c15:	73 7a                	jae    803c91 <realloc_block_FF+0x44d>
  803c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c1a:	8b 00                	mov    (%eax),%eax
  803c1c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c1f:	73 70                	jae    803c91 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803c21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c25:	74 06                	je     803c2d <realloc_block_FF+0x3e9>
  803c27:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c2b:	75 17                	jne    803c44 <realloc_block_FF+0x400>
  803c2d:	83 ec 04             	sub    $0x4,%esp
  803c30:	68 ac 4b 80 00       	push   $0x804bac
  803c35:	68 1a 02 00 00       	push   $0x21a
  803c3a:	68 39 4b 80 00       	push   $0x804b39
  803c3f:	e8 6c cb ff ff       	call   8007b0 <_panic>
  803c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c47:	8b 10                	mov    (%eax),%edx
  803c49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c4c:	89 10                	mov    %edx,(%eax)
  803c4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c51:	8b 00                	mov    (%eax),%eax
  803c53:	85 c0                	test   %eax,%eax
  803c55:	74 0b                	je     803c62 <realloc_block_FF+0x41e>
  803c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5a:	8b 00                	mov    (%eax),%eax
  803c5c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c5f:	89 50 04             	mov    %edx,0x4(%eax)
  803c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c68:	89 10                	mov    %edx,(%eax)
  803c6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c70:	89 50 04             	mov    %edx,0x4(%eax)
  803c73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c76:	8b 00                	mov    (%eax),%eax
  803c78:	85 c0                	test   %eax,%eax
  803c7a:	75 08                	jne    803c84 <realloc_block_FF+0x440>
  803c7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c7f:	a3 34 50 80 00       	mov    %eax,0x805034
  803c84:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c89:	40                   	inc    %eax
  803c8a:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803c8f:	eb 36                	jmp    803cc7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803c91:	a1 38 50 80 00       	mov    0x805038,%eax
  803c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c9d:	74 07                	je     803ca6 <realloc_block_FF+0x462>
  803c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca2:	8b 00                	mov    (%eax),%eax
  803ca4:	eb 05                	jmp    803cab <realloc_block_FF+0x467>
  803ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  803cab:	a3 38 50 80 00       	mov    %eax,0x805038
  803cb0:	a1 38 50 80 00       	mov    0x805038,%eax
  803cb5:	85 c0                	test   %eax,%eax
  803cb7:	0f 85 52 ff ff ff    	jne    803c0f <realloc_block_FF+0x3cb>
  803cbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cc1:	0f 85 48 ff ff ff    	jne    803c0f <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803cc7:	83 ec 04             	sub    $0x4,%esp
  803cca:	6a 00                	push   $0x0
  803ccc:	ff 75 d8             	pushl  -0x28(%ebp)
  803ccf:	ff 75 d4             	pushl  -0x2c(%ebp)
  803cd2:	e8 7a eb ff ff       	call   802851 <set_block_data>
  803cd7:	83 c4 10             	add    $0x10,%esp
				return va;
  803cda:	8b 45 08             	mov    0x8(%ebp),%eax
  803cdd:	e9 7b 02 00 00       	jmp    803f5d <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803ce2:	83 ec 0c             	sub    $0xc,%esp
  803ce5:	68 29 4c 80 00       	push   $0x804c29
  803cea:	e8 7e cd ff ff       	call   800a6d <cprintf>
  803cef:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf5:	e9 63 02 00 00       	jmp    803f5d <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cfd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d00:	0f 86 4d 02 00 00    	jbe    803f53 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803d06:	83 ec 0c             	sub    $0xc,%esp
  803d09:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d0c:	e8 08 e8 ff ff       	call   802519 <is_free_block>
  803d11:	83 c4 10             	add    $0x10,%esp
  803d14:	84 c0                	test   %al,%al
  803d16:	0f 84 37 02 00 00    	je     803f53 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d1f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803d25:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d28:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d2b:	76 38                	jbe    803d65 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803d2d:	83 ec 0c             	sub    $0xc,%esp
  803d30:	ff 75 08             	pushl  0x8(%ebp)
  803d33:	e8 0c fa ff ff       	call   803744 <free_block>
  803d38:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803d3b:	83 ec 0c             	sub    $0xc,%esp
  803d3e:	ff 75 0c             	pushl  0xc(%ebp)
  803d41:	e8 3a eb ff ff       	call   802880 <alloc_block_FF>
  803d46:	83 c4 10             	add    $0x10,%esp
  803d49:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803d4c:	83 ec 08             	sub    $0x8,%esp
  803d4f:	ff 75 c0             	pushl  -0x40(%ebp)
  803d52:	ff 75 08             	pushl  0x8(%ebp)
  803d55:	e8 ab fa ff ff       	call   803805 <copy_data>
  803d5a:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803d5d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803d60:	e9 f8 01 00 00       	jmp    803f5d <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803d65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d68:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803d6b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803d6e:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803d72:	0f 87 a0 00 00 00    	ja     803e18 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803d78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d7c:	75 17                	jne    803d95 <realloc_block_FF+0x551>
  803d7e:	83 ec 04             	sub    $0x4,%esp
  803d81:	68 1b 4b 80 00       	push   $0x804b1b
  803d86:	68 38 02 00 00       	push   $0x238
  803d8b:	68 39 4b 80 00       	push   $0x804b39
  803d90:	e8 1b ca ff ff       	call   8007b0 <_panic>
  803d95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d98:	8b 00                	mov    (%eax),%eax
  803d9a:	85 c0                	test   %eax,%eax
  803d9c:	74 10                	je     803dae <realloc_block_FF+0x56a>
  803d9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da1:	8b 00                	mov    (%eax),%eax
  803da3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803da6:	8b 52 04             	mov    0x4(%edx),%edx
  803da9:	89 50 04             	mov    %edx,0x4(%eax)
  803dac:	eb 0b                	jmp    803db9 <realloc_block_FF+0x575>
  803dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db1:	8b 40 04             	mov    0x4(%eax),%eax
  803db4:	a3 34 50 80 00       	mov    %eax,0x805034
  803db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbc:	8b 40 04             	mov    0x4(%eax),%eax
  803dbf:	85 c0                	test   %eax,%eax
  803dc1:	74 0f                	je     803dd2 <realloc_block_FF+0x58e>
  803dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc6:	8b 40 04             	mov    0x4(%eax),%eax
  803dc9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dcc:	8b 12                	mov    (%edx),%edx
  803dce:	89 10                	mov    %edx,(%eax)
  803dd0:	eb 0a                	jmp    803ddc <realloc_block_FF+0x598>
  803dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd5:	8b 00                	mov    (%eax),%eax
  803dd7:	a3 30 50 80 00       	mov    %eax,0x805030
  803ddc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ddf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803de5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803def:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803df4:	48                   	dec    %eax
  803df5:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803dfa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803dfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e00:	01 d0                	add    %edx,%eax
  803e02:	83 ec 04             	sub    $0x4,%esp
  803e05:	6a 01                	push   $0x1
  803e07:	50                   	push   %eax
  803e08:	ff 75 08             	pushl  0x8(%ebp)
  803e0b:	e8 41 ea ff ff       	call   802851 <set_block_data>
  803e10:	83 c4 10             	add    $0x10,%esp
  803e13:	e9 36 01 00 00       	jmp    803f4e <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803e18:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e1b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e1e:	01 d0                	add    %edx,%eax
  803e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803e23:	83 ec 04             	sub    $0x4,%esp
  803e26:	6a 01                	push   $0x1
  803e28:	ff 75 f0             	pushl  -0x10(%ebp)
  803e2b:	ff 75 08             	pushl  0x8(%ebp)
  803e2e:	e8 1e ea ff ff       	call   802851 <set_block_data>
  803e33:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803e36:	8b 45 08             	mov    0x8(%ebp),%eax
  803e39:	83 e8 04             	sub    $0x4,%eax
  803e3c:	8b 00                	mov    (%eax),%eax
  803e3e:	83 e0 fe             	and    $0xfffffffe,%eax
  803e41:	89 c2                	mov    %eax,%edx
  803e43:	8b 45 08             	mov    0x8(%ebp),%eax
  803e46:	01 d0                	add    %edx,%eax
  803e48:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803e4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e4f:	74 06                	je     803e57 <realloc_block_FF+0x613>
  803e51:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803e55:	75 17                	jne    803e6e <realloc_block_FF+0x62a>
  803e57:	83 ec 04             	sub    $0x4,%esp
  803e5a:	68 ac 4b 80 00       	push   $0x804bac
  803e5f:	68 44 02 00 00       	push   $0x244
  803e64:	68 39 4b 80 00       	push   $0x804b39
  803e69:	e8 42 c9 ff ff       	call   8007b0 <_panic>
  803e6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e71:	8b 10                	mov    (%eax),%edx
  803e73:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e76:	89 10                	mov    %edx,(%eax)
  803e78:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e7b:	8b 00                	mov    (%eax),%eax
  803e7d:	85 c0                	test   %eax,%eax
  803e7f:	74 0b                	je     803e8c <realloc_block_FF+0x648>
  803e81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e84:	8b 00                	mov    (%eax),%eax
  803e86:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e89:	89 50 04             	mov    %edx,0x4(%eax)
  803e8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e8f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e92:	89 10                	mov    %edx,(%eax)
  803e94:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e9a:	89 50 04             	mov    %edx,0x4(%eax)
  803e9d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ea0:	8b 00                	mov    (%eax),%eax
  803ea2:	85 c0                	test   %eax,%eax
  803ea4:	75 08                	jne    803eae <realloc_block_FF+0x66a>
  803ea6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ea9:	a3 34 50 80 00       	mov    %eax,0x805034
  803eae:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803eb3:	40                   	inc    %eax
  803eb4:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803eb9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ebd:	75 17                	jne    803ed6 <realloc_block_FF+0x692>
  803ebf:	83 ec 04             	sub    $0x4,%esp
  803ec2:	68 1b 4b 80 00       	push   $0x804b1b
  803ec7:	68 45 02 00 00       	push   $0x245
  803ecc:	68 39 4b 80 00       	push   $0x804b39
  803ed1:	e8 da c8 ff ff       	call   8007b0 <_panic>
  803ed6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed9:	8b 00                	mov    (%eax),%eax
  803edb:	85 c0                	test   %eax,%eax
  803edd:	74 10                	je     803eef <realloc_block_FF+0x6ab>
  803edf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee2:	8b 00                	mov    (%eax),%eax
  803ee4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ee7:	8b 52 04             	mov    0x4(%edx),%edx
  803eea:	89 50 04             	mov    %edx,0x4(%eax)
  803eed:	eb 0b                	jmp    803efa <realloc_block_FF+0x6b6>
  803eef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef2:	8b 40 04             	mov    0x4(%eax),%eax
  803ef5:	a3 34 50 80 00       	mov    %eax,0x805034
  803efa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efd:	8b 40 04             	mov    0x4(%eax),%eax
  803f00:	85 c0                	test   %eax,%eax
  803f02:	74 0f                	je     803f13 <realloc_block_FF+0x6cf>
  803f04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f07:	8b 40 04             	mov    0x4(%eax),%eax
  803f0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f0d:	8b 12                	mov    (%edx),%edx
  803f0f:	89 10                	mov    %edx,(%eax)
  803f11:	eb 0a                	jmp    803f1d <realloc_block_FF+0x6d9>
  803f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f16:	8b 00                	mov    (%eax),%eax
  803f18:	a3 30 50 80 00       	mov    %eax,0x805030
  803f1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f30:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f35:	48                   	dec    %eax
  803f36:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803f3b:	83 ec 04             	sub    $0x4,%esp
  803f3e:	6a 00                	push   $0x0
  803f40:	ff 75 bc             	pushl  -0x44(%ebp)
  803f43:	ff 75 b8             	pushl  -0x48(%ebp)
  803f46:	e8 06 e9 ff ff       	call   802851 <set_block_data>
  803f4b:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803f51:	eb 0a                	jmp    803f5d <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803f53:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803f5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803f5d:	c9                   	leave  
  803f5e:	c3                   	ret    

00803f5f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803f5f:	55                   	push   %ebp
  803f60:	89 e5                	mov    %esp,%ebp
  803f62:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803f65:	83 ec 04             	sub    $0x4,%esp
  803f68:	68 30 4c 80 00       	push   $0x804c30
  803f6d:	68 58 02 00 00       	push   $0x258
  803f72:	68 39 4b 80 00       	push   $0x804b39
  803f77:	e8 34 c8 ff ff       	call   8007b0 <_panic>

00803f7c <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803f7c:	55                   	push   %ebp
  803f7d:	89 e5                	mov    %esp,%ebp
  803f7f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803f82:	83 ec 04             	sub    $0x4,%esp
  803f85:	68 58 4c 80 00       	push   $0x804c58
  803f8a:	68 61 02 00 00       	push   $0x261
  803f8f:	68 39 4b 80 00       	push   $0x804b39
  803f94:	e8 17 c8 ff ff       	call   8007b0 <_panic>

00803f99 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803f99:	55                   	push   %ebp
  803f9a:	89 e5                	mov    %esp,%ebp
  803f9c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803f9f:	83 ec 04             	sub    $0x4,%esp
  803fa2:	68 80 4c 80 00       	push   $0x804c80
  803fa7:	6a 09                	push   $0x9
  803fa9:	68 a8 4c 80 00       	push   $0x804ca8
  803fae:	e8 fd c7 ff ff       	call   8007b0 <_panic>

00803fb3 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803fb3:	55                   	push   %ebp
  803fb4:	89 e5                	mov    %esp,%ebp
  803fb6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803fb9:	83 ec 04             	sub    $0x4,%esp
  803fbc:	68 b8 4c 80 00       	push   $0x804cb8
  803fc1:	6a 10                	push   $0x10
  803fc3:	68 a8 4c 80 00       	push   $0x804ca8
  803fc8:	e8 e3 c7 ff ff       	call   8007b0 <_panic>

00803fcd <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803fcd:	55                   	push   %ebp
  803fce:	89 e5                	mov    %esp,%ebp
  803fd0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803fd3:	83 ec 04             	sub    $0x4,%esp
  803fd6:	68 e0 4c 80 00       	push   $0x804ce0
  803fdb:	6a 18                	push   $0x18
  803fdd:	68 a8 4c 80 00       	push   $0x804ca8
  803fe2:	e8 c9 c7 ff ff       	call   8007b0 <_panic>

00803fe7 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803fe7:	55                   	push   %ebp
  803fe8:	89 e5                	mov    %esp,%ebp
  803fea:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803fed:	83 ec 04             	sub    $0x4,%esp
  803ff0:	68 08 4d 80 00       	push   $0x804d08
  803ff5:	6a 20                	push   $0x20
  803ff7:	68 a8 4c 80 00       	push   $0x804ca8
  803ffc:	e8 af c7 ff ff       	call   8007b0 <_panic>

00804001 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  804001:	55                   	push   %ebp
  804002:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  804004:	8b 45 08             	mov    0x8(%ebp),%eax
  804007:	8b 40 10             	mov    0x10(%eax),%eax
}
  80400a:	5d                   	pop    %ebp
  80400b:	c3                   	ret    

0080400c <__udivdi3>:
  80400c:	55                   	push   %ebp
  80400d:	57                   	push   %edi
  80400e:	56                   	push   %esi
  80400f:	53                   	push   %ebx
  804010:	83 ec 1c             	sub    $0x1c,%esp
  804013:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804017:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80401b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80401f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804023:	89 ca                	mov    %ecx,%edx
  804025:	89 f8                	mov    %edi,%eax
  804027:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80402b:	85 f6                	test   %esi,%esi
  80402d:	75 2d                	jne    80405c <__udivdi3+0x50>
  80402f:	39 cf                	cmp    %ecx,%edi
  804031:	77 65                	ja     804098 <__udivdi3+0x8c>
  804033:	89 fd                	mov    %edi,%ebp
  804035:	85 ff                	test   %edi,%edi
  804037:	75 0b                	jne    804044 <__udivdi3+0x38>
  804039:	b8 01 00 00 00       	mov    $0x1,%eax
  80403e:	31 d2                	xor    %edx,%edx
  804040:	f7 f7                	div    %edi
  804042:	89 c5                	mov    %eax,%ebp
  804044:	31 d2                	xor    %edx,%edx
  804046:	89 c8                	mov    %ecx,%eax
  804048:	f7 f5                	div    %ebp
  80404a:	89 c1                	mov    %eax,%ecx
  80404c:	89 d8                	mov    %ebx,%eax
  80404e:	f7 f5                	div    %ebp
  804050:	89 cf                	mov    %ecx,%edi
  804052:	89 fa                	mov    %edi,%edx
  804054:	83 c4 1c             	add    $0x1c,%esp
  804057:	5b                   	pop    %ebx
  804058:	5e                   	pop    %esi
  804059:	5f                   	pop    %edi
  80405a:	5d                   	pop    %ebp
  80405b:	c3                   	ret    
  80405c:	39 ce                	cmp    %ecx,%esi
  80405e:	77 28                	ja     804088 <__udivdi3+0x7c>
  804060:	0f bd fe             	bsr    %esi,%edi
  804063:	83 f7 1f             	xor    $0x1f,%edi
  804066:	75 40                	jne    8040a8 <__udivdi3+0x9c>
  804068:	39 ce                	cmp    %ecx,%esi
  80406a:	72 0a                	jb     804076 <__udivdi3+0x6a>
  80406c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804070:	0f 87 9e 00 00 00    	ja     804114 <__udivdi3+0x108>
  804076:	b8 01 00 00 00       	mov    $0x1,%eax
  80407b:	89 fa                	mov    %edi,%edx
  80407d:	83 c4 1c             	add    $0x1c,%esp
  804080:	5b                   	pop    %ebx
  804081:	5e                   	pop    %esi
  804082:	5f                   	pop    %edi
  804083:	5d                   	pop    %ebp
  804084:	c3                   	ret    
  804085:	8d 76 00             	lea    0x0(%esi),%esi
  804088:	31 ff                	xor    %edi,%edi
  80408a:	31 c0                	xor    %eax,%eax
  80408c:	89 fa                	mov    %edi,%edx
  80408e:	83 c4 1c             	add    $0x1c,%esp
  804091:	5b                   	pop    %ebx
  804092:	5e                   	pop    %esi
  804093:	5f                   	pop    %edi
  804094:	5d                   	pop    %ebp
  804095:	c3                   	ret    
  804096:	66 90                	xchg   %ax,%ax
  804098:	89 d8                	mov    %ebx,%eax
  80409a:	f7 f7                	div    %edi
  80409c:	31 ff                	xor    %edi,%edi
  80409e:	89 fa                	mov    %edi,%edx
  8040a0:	83 c4 1c             	add    $0x1c,%esp
  8040a3:	5b                   	pop    %ebx
  8040a4:	5e                   	pop    %esi
  8040a5:	5f                   	pop    %edi
  8040a6:	5d                   	pop    %ebp
  8040a7:	c3                   	ret    
  8040a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040ad:	89 eb                	mov    %ebp,%ebx
  8040af:	29 fb                	sub    %edi,%ebx
  8040b1:	89 f9                	mov    %edi,%ecx
  8040b3:	d3 e6                	shl    %cl,%esi
  8040b5:	89 c5                	mov    %eax,%ebp
  8040b7:	88 d9                	mov    %bl,%cl
  8040b9:	d3 ed                	shr    %cl,%ebp
  8040bb:	89 e9                	mov    %ebp,%ecx
  8040bd:	09 f1                	or     %esi,%ecx
  8040bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040c3:	89 f9                	mov    %edi,%ecx
  8040c5:	d3 e0                	shl    %cl,%eax
  8040c7:	89 c5                	mov    %eax,%ebp
  8040c9:	89 d6                	mov    %edx,%esi
  8040cb:	88 d9                	mov    %bl,%cl
  8040cd:	d3 ee                	shr    %cl,%esi
  8040cf:	89 f9                	mov    %edi,%ecx
  8040d1:	d3 e2                	shl    %cl,%edx
  8040d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040d7:	88 d9                	mov    %bl,%cl
  8040d9:	d3 e8                	shr    %cl,%eax
  8040db:	09 c2                	or     %eax,%edx
  8040dd:	89 d0                	mov    %edx,%eax
  8040df:	89 f2                	mov    %esi,%edx
  8040e1:	f7 74 24 0c          	divl   0xc(%esp)
  8040e5:	89 d6                	mov    %edx,%esi
  8040e7:	89 c3                	mov    %eax,%ebx
  8040e9:	f7 e5                	mul    %ebp
  8040eb:	39 d6                	cmp    %edx,%esi
  8040ed:	72 19                	jb     804108 <__udivdi3+0xfc>
  8040ef:	74 0b                	je     8040fc <__udivdi3+0xf0>
  8040f1:	89 d8                	mov    %ebx,%eax
  8040f3:	31 ff                	xor    %edi,%edi
  8040f5:	e9 58 ff ff ff       	jmp    804052 <__udivdi3+0x46>
  8040fa:	66 90                	xchg   %ax,%ax
  8040fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  804100:	89 f9                	mov    %edi,%ecx
  804102:	d3 e2                	shl    %cl,%edx
  804104:	39 c2                	cmp    %eax,%edx
  804106:	73 e9                	jae    8040f1 <__udivdi3+0xe5>
  804108:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80410b:	31 ff                	xor    %edi,%edi
  80410d:	e9 40 ff ff ff       	jmp    804052 <__udivdi3+0x46>
  804112:	66 90                	xchg   %ax,%ax
  804114:	31 c0                	xor    %eax,%eax
  804116:	e9 37 ff ff ff       	jmp    804052 <__udivdi3+0x46>
  80411b:	90                   	nop

0080411c <__umoddi3>:
  80411c:	55                   	push   %ebp
  80411d:	57                   	push   %edi
  80411e:	56                   	push   %esi
  80411f:	53                   	push   %ebx
  804120:	83 ec 1c             	sub    $0x1c,%esp
  804123:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804127:	8b 74 24 34          	mov    0x34(%esp),%esi
  80412b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80412f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804133:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804137:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80413b:	89 f3                	mov    %esi,%ebx
  80413d:	89 fa                	mov    %edi,%edx
  80413f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804143:	89 34 24             	mov    %esi,(%esp)
  804146:	85 c0                	test   %eax,%eax
  804148:	75 1a                	jne    804164 <__umoddi3+0x48>
  80414a:	39 f7                	cmp    %esi,%edi
  80414c:	0f 86 a2 00 00 00    	jbe    8041f4 <__umoddi3+0xd8>
  804152:	89 c8                	mov    %ecx,%eax
  804154:	89 f2                	mov    %esi,%edx
  804156:	f7 f7                	div    %edi
  804158:	89 d0                	mov    %edx,%eax
  80415a:	31 d2                	xor    %edx,%edx
  80415c:	83 c4 1c             	add    $0x1c,%esp
  80415f:	5b                   	pop    %ebx
  804160:	5e                   	pop    %esi
  804161:	5f                   	pop    %edi
  804162:	5d                   	pop    %ebp
  804163:	c3                   	ret    
  804164:	39 f0                	cmp    %esi,%eax
  804166:	0f 87 ac 00 00 00    	ja     804218 <__umoddi3+0xfc>
  80416c:	0f bd e8             	bsr    %eax,%ebp
  80416f:	83 f5 1f             	xor    $0x1f,%ebp
  804172:	0f 84 ac 00 00 00    	je     804224 <__umoddi3+0x108>
  804178:	bf 20 00 00 00       	mov    $0x20,%edi
  80417d:	29 ef                	sub    %ebp,%edi
  80417f:	89 fe                	mov    %edi,%esi
  804181:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804185:	89 e9                	mov    %ebp,%ecx
  804187:	d3 e0                	shl    %cl,%eax
  804189:	89 d7                	mov    %edx,%edi
  80418b:	89 f1                	mov    %esi,%ecx
  80418d:	d3 ef                	shr    %cl,%edi
  80418f:	09 c7                	or     %eax,%edi
  804191:	89 e9                	mov    %ebp,%ecx
  804193:	d3 e2                	shl    %cl,%edx
  804195:	89 14 24             	mov    %edx,(%esp)
  804198:	89 d8                	mov    %ebx,%eax
  80419a:	d3 e0                	shl    %cl,%eax
  80419c:	89 c2                	mov    %eax,%edx
  80419e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041a2:	d3 e0                	shl    %cl,%eax
  8041a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041ac:	89 f1                	mov    %esi,%ecx
  8041ae:	d3 e8                	shr    %cl,%eax
  8041b0:	09 d0                	or     %edx,%eax
  8041b2:	d3 eb                	shr    %cl,%ebx
  8041b4:	89 da                	mov    %ebx,%edx
  8041b6:	f7 f7                	div    %edi
  8041b8:	89 d3                	mov    %edx,%ebx
  8041ba:	f7 24 24             	mull   (%esp)
  8041bd:	89 c6                	mov    %eax,%esi
  8041bf:	89 d1                	mov    %edx,%ecx
  8041c1:	39 d3                	cmp    %edx,%ebx
  8041c3:	0f 82 87 00 00 00    	jb     804250 <__umoddi3+0x134>
  8041c9:	0f 84 91 00 00 00    	je     804260 <__umoddi3+0x144>
  8041cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041d3:	29 f2                	sub    %esi,%edx
  8041d5:	19 cb                	sbb    %ecx,%ebx
  8041d7:	89 d8                	mov    %ebx,%eax
  8041d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041dd:	d3 e0                	shl    %cl,%eax
  8041df:	89 e9                	mov    %ebp,%ecx
  8041e1:	d3 ea                	shr    %cl,%edx
  8041e3:	09 d0                	or     %edx,%eax
  8041e5:	89 e9                	mov    %ebp,%ecx
  8041e7:	d3 eb                	shr    %cl,%ebx
  8041e9:	89 da                	mov    %ebx,%edx
  8041eb:	83 c4 1c             	add    $0x1c,%esp
  8041ee:	5b                   	pop    %ebx
  8041ef:	5e                   	pop    %esi
  8041f0:	5f                   	pop    %edi
  8041f1:	5d                   	pop    %ebp
  8041f2:	c3                   	ret    
  8041f3:	90                   	nop
  8041f4:	89 fd                	mov    %edi,%ebp
  8041f6:	85 ff                	test   %edi,%edi
  8041f8:	75 0b                	jne    804205 <__umoddi3+0xe9>
  8041fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8041ff:	31 d2                	xor    %edx,%edx
  804201:	f7 f7                	div    %edi
  804203:	89 c5                	mov    %eax,%ebp
  804205:	89 f0                	mov    %esi,%eax
  804207:	31 d2                	xor    %edx,%edx
  804209:	f7 f5                	div    %ebp
  80420b:	89 c8                	mov    %ecx,%eax
  80420d:	f7 f5                	div    %ebp
  80420f:	89 d0                	mov    %edx,%eax
  804211:	e9 44 ff ff ff       	jmp    80415a <__umoddi3+0x3e>
  804216:	66 90                	xchg   %ax,%ax
  804218:	89 c8                	mov    %ecx,%eax
  80421a:	89 f2                	mov    %esi,%edx
  80421c:	83 c4 1c             	add    $0x1c,%esp
  80421f:	5b                   	pop    %ebx
  804220:	5e                   	pop    %esi
  804221:	5f                   	pop    %edi
  804222:	5d                   	pop    %ebp
  804223:	c3                   	ret    
  804224:	3b 04 24             	cmp    (%esp),%eax
  804227:	72 06                	jb     80422f <__umoddi3+0x113>
  804229:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80422d:	77 0f                	ja     80423e <__umoddi3+0x122>
  80422f:	89 f2                	mov    %esi,%edx
  804231:	29 f9                	sub    %edi,%ecx
  804233:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804237:	89 14 24             	mov    %edx,(%esp)
  80423a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80423e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804242:	8b 14 24             	mov    (%esp),%edx
  804245:	83 c4 1c             	add    $0x1c,%esp
  804248:	5b                   	pop    %ebx
  804249:	5e                   	pop    %esi
  80424a:	5f                   	pop    %edi
  80424b:	5d                   	pop    %ebp
  80424c:	c3                   	ret    
  80424d:	8d 76 00             	lea    0x0(%esi),%esi
  804250:	2b 04 24             	sub    (%esp),%eax
  804253:	19 fa                	sbb    %edi,%edx
  804255:	89 d1                	mov    %edx,%ecx
  804257:	89 c6                	mov    %eax,%esi
  804259:	e9 71 ff ff ff       	jmp    8041cf <__umoddi3+0xb3>
  80425e:	66 90                	xchg   %ax,%ax
  804260:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804264:	72 ea                	jb     804250 <__umoddi3+0x134>
  804266:	89 d9                	mov    %ebx,%ecx
  804268:	e9 62 ff ff ff       	jmp    8041cf <__umoddi3+0xb3>
