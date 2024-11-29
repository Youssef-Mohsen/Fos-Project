
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
  800042:	e8 dd 21 00 00       	call   802224 <sys_getenvid>
  800047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  80004a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	IO_CS = create_semaphore("IO.CS", 1);
  800051:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	6a 01                	push   $0x1
  80005c:	68 00 43 80 00       	push   $0x804300
  800061:	50                   	push   %eax
  800062:	e8 af 3f 00 00       	call   804016 <create_semaphore>
  800067:	83 c4 0c             	add    $0xc,%esp
  80006a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800070:	a3 44 50 80 00       	mov    %eax,0x805044
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800075:	e8 fa 1f 00 00       	call   802074 <sys_calculate_free_frames>
  80007a:	89 c3                	mov    %eax,%ebx
  80007c:	e8 0c 20 00 00       	call   80208d <sys_calculate_modified_frames>
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
  800092:	e8 b3 3f 00 00       	call   80404a <wait_semaphore>
  800097:	83 c4 10             	add    $0x10,%esp
		{
			readline("Enter the number of elements: ", Line);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000a3:	50                   	push   %eax
  8000a4:	68 08 43 80 00       	push   $0x804308
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
  8000e2:	68 28 43 80 00       	push   $0x804328
  8000e7:	e8 81 09 00 00       	call   800a6d <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 4b 43 80 00       	push   $0x80434b
  8000f7:	e8 71 09 00 00       	call   800a6d <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 59 43 80 00       	push   $0x804359
  800107:	e8 61 09 00 00       	call   800a6d <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 68 43 80 00       	push   $0x804368
  800117:	e8 51 09 00 00       	call   800a6d <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 78 43 80 00       	push   $0x804378
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
  80016f:	e8 f0 3e 00 00       	call   804064 <signal_semaphore>
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
  800202:	68 84 43 80 00       	push   $0x804384
  800207:	6a 4d                	push   $0x4d
  800209:	68 a6 43 80 00       	push   $0x8043a6
  80020e:	e8 9d 05 00 00       	call   8007b0 <_panic>
		else
		{
			wait_semaphore(IO_CS);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	ff 35 44 50 80 00    	pushl  0x805044
  80021c:	e8 29 3e 00 00       	call   80404a <wait_semaphore>
  800221:	83 c4 10             	add    $0x10,%esp
				cprintf("\n===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 c4 43 80 00       	push   $0x8043c4
  80022c:	e8 3c 08 00 00       	call   800a6d <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 f8 43 80 00       	push   $0x8043f8
  80023c:	e8 2c 08 00 00       	call   800a6d <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 2c 44 80 00       	push   $0x80442c
  80024c:	e8 1c 08 00 00       	call   800a6d <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			signal_semaphore(IO_CS);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	ff 35 44 50 80 00    	pushl  0x805044
  80025d:	e8 02 3e 00 00       	call   804064 <signal_semaphore>
  800262:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		wait_semaphore(IO_CS);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 35 44 50 80 00    	pushl  0x805044
  80026e:	e8 d7 3d 00 00       	call   80404a <wait_semaphore>
  800273:	83 c4 10             	add    $0x10,%esp
			cprintf("Freeing the Heap...\n\n") ;
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 5e 44 80 00       	push   $0x80445e
  80027e:	e8 ea 07 00 00       	call   800a6d <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
		signal_semaphore(IO_CS);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 35 44 50 80 00    	pushl  0x805044
  80028f:	e8 d0 3d 00 00       	call   804064 <signal_semaphore>
  800294:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		wait_semaphore(IO_CS);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 35 44 50 80 00    	pushl  0x805044
  8002a0:	e8 a5 3d 00 00       	call   80404a <wait_semaphore>
  8002a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Do you want to repeat (y/n): ") ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 74 44 80 00       	push   $0x804474
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
  8002f3:	e8 6c 3d 00 00       	call   804064 <signal_semaphore>
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
  80058b:	e8 94 1c 00 00       	call   802224 <sys_getenvid>
  800590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	wait_semaphore(IO_CS);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 35 44 50 80 00    	pushl  0x805044
  80059c:	e8 a9 3a 00 00       	call   80404a <wait_semaphore>
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
  8005c4:	68 92 44 80 00       	push   $0x804492
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
  8005e6:	68 94 44 80 00       	push   $0x804494
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
  800614:	68 99 44 80 00       	push   $0x804499
  800619:	e8 4f 04 00 00       	call   800a6d <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(IO_CS);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	ff 35 44 50 80 00    	pushl  0x805044
  80062a:	e8 35 3a 00 00       	call   804064 <signal_semaphore>
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
  800649:	e8 be 1a 00 00       	call   80210c <sys_cputc>
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
  80065a:	e8 49 19 00 00       	call   801fa8 <sys_cgetc>
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
  800677:	e8 c1 1b 00 00       	call   80223d <sys_getenvindex>
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
  8006e5:	e8 d7 18 00 00       	call   801fc1 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	68 b8 44 80 00       	push   $0x8044b8
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
  800715:	68 e0 44 80 00       	push   $0x8044e0
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
  800746:	68 08 45 80 00       	push   $0x804508
  80074b:	e8 1d 03 00 00       	call   800a6d <cprintf>
  800750:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800753:	a1 24 50 80 00       	mov    0x805024,%eax
  800758:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	50                   	push   %eax
  800762:	68 60 45 80 00       	push   $0x804560
  800767:	e8 01 03 00 00       	call   800a6d <cprintf>
  80076c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80076f:	83 ec 0c             	sub    $0xc,%esp
  800772:	68 b8 44 80 00       	push   $0x8044b8
  800777:	e8 f1 02 00 00       	call   800a6d <cprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80077f:	e8 57 18 00 00       	call   801fdb <sys_unlock_cons>
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
  800797:	e8 6d 1a 00 00       	call   802209 <sys_destroy_env>
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
  8007a8:	e8 c2 1a 00 00       	call   80226f <sys_exit_env>
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
  8007d1:	68 74 45 80 00       	push   $0x804574
  8007d6:	e8 92 02 00 00       	call   800a6d <cprintf>
  8007db:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007de:	a1 00 50 80 00       	mov    0x805000,%eax
  8007e3:	ff 75 0c             	pushl  0xc(%ebp)
  8007e6:	ff 75 08             	pushl  0x8(%ebp)
  8007e9:	50                   	push   %eax
  8007ea:	68 79 45 80 00       	push   $0x804579
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
  80080e:	68 95 45 80 00       	push   $0x804595
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
  80083d:	68 98 45 80 00       	push   $0x804598
  800842:	6a 26                	push   $0x26
  800844:	68 e4 45 80 00       	push   $0x8045e4
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
  800912:	68 f0 45 80 00       	push   $0x8045f0
  800917:	6a 3a                	push   $0x3a
  800919:	68 e4 45 80 00       	push   $0x8045e4
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
  800985:	68 44 46 80 00       	push   $0x804644
  80098a:	6a 44                	push   $0x44
  80098c:	68 e4 45 80 00       	push   $0x8045e4
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
  8009df:	e8 9b 15 00 00       	call   801f7f <sys_cputs>
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
  800a56:	e8 24 15 00 00       	call   801f7f <sys_cputs>
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
  800aa0:	e8 1c 15 00 00       	call   801fc1 <sys_lock_cons>
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
  800ac0:	e8 16 15 00 00       	call   801fdb <sys_unlock_cons>
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
  800b0a:	e8 7d 35 00 00       	call   80408c <__udivdi3>
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
  800b5a:	e8 3d 36 00 00       	call   80419c <__umoddi3>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	05 b4 48 80 00       	add    $0x8048b4,%eax
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
  800cb5:	8b 04 85 d8 48 80 00 	mov    0x8048d8(,%eax,4),%eax
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
  800d96:	8b 34 9d 20 47 80 00 	mov    0x804720(,%ebx,4),%esi
  800d9d:	85 f6                	test   %esi,%esi
  800d9f:	75 19                	jne    800dba <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da1:	53                   	push   %ebx
  800da2:	68 c5 48 80 00       	push   $0x8048c5
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
  800dbb:	68 ce 48 80 00       	push   $0x8048ce
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
  800de8:	be d1 48 80 00       	mov    $0x8048d1,%esi
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
  801113:	68 48 4a 80 00       	push   $0x804a48
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
  801155:	68 4b 4a 80 00       	push   $0x804a4b
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
  801206:	e8 b6 0d 00 00       	call   801fc1 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80120b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80120f:	74 13                	je     801224 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	ff 75 08             	pushl  0x8(%ebp)
  801217:	68 48 4a 80 00       	push   $0x804a48
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
  801259:	68 4b 4a 80 00       	push   $0x804a4b
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
  801301:	e8 d5 0c 00 00       	call   801fdb <sys_unlock_cons>
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
  8019fb:	68 5c 4a 80 00       	push   $0x804a5c
  801a00:	68 3f 01 00 00       	push   $0x13f
  801a05:	68 7e 4a 80 00       	push   $0x804a7e
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
  801a1b:	e8 0a 0b 00 00       	call   80252a <sys_sbrk>
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
  801a96:	e8 13 09 00 00       	call   8023ae <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	74 16                	je     801ab5 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a9f:	83 ec 0c             	sub    $0xc,%esp
  801aa2:	ff 75 08             	pushl  0x8(%ebp)
  801aa5:	e8 53 0e 00 00       	call   8028fd <alloc_block_FF>
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ab0:	e9 8a 01 00 00       	jmp    801c3f <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801ab5:	e8 25 09 00 00       	call   8023df <sys_isUHeapPlacementStrategyBESTFIT>
  801aba:	85 c0                	test   %eax,%eax
  801abc:	0f 84 7d 01 00 00    	je     801c3f <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801ac2:	83 ec 0c             	sub    $0xc,%esp
  801ac5:	ff 75 08             	pushl  0x8(%ebp)
  801ac8:	e8 ec 12 00 00       	call   802db9 <alloc_block_BF>
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
  801c2e:	e8 2e 09 00 00       	call   802561 <sys_allocate_user_mem>
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
  801c76:	e8 02 09 00 00       	call   80257d <get_block_size>
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c81:	83 ec 0c             	sub    $0xc,%esp
  801c84:	ff 75 08             	pushl  0x8(%ebp)
  801c87:	e8 35 1b 00 00       	call   8037c1 <free_block>
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
  801d1e:	e8 22 08 00 00       	call   802545 <sys_free_user_mem>
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
  801d2c:	68 8c 4a 80 00       	push   $0x804a8c
  801d31:	68 85 00 00 00       	push   $0x85
  801d36:	68 b6 4a 80 00       	push   $0x804ab6
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
  801da1:	e8 a6 03 00 00       	call   80214c <sys_createSharedObject>
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
  801dc5:	68 c2 4a 80 00       	push   $0x804ac2
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
  801e09:	e8 68 03 00 00       	call   802176 <sys_getSizeOfSharedObject>
  801e0e:	83 c4 10             	add    $0x10,%esp
  801e11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801e14:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801e18:	75 07                	jne    801e21 <sget+0x27>
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1f:	eb 7f                	jmp    801ea0 <sget+0xa6>
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
  801e54:	eb 4a                	jmp    801ea0 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801e56:	83 ec 04             	sub    $0x4,%esp
  801e59:	ff 75 e8             	pushl  -0x18(%ebp)
  801e5c:	ff 75 0c             	pushl  0xc(%ebp)
  801e5f:	ff 75 08             	pushl  0x8(%ebp)
  801e62:	e8 2c 03 00 00       	call   802193 <sys_getSharedObject>
  801e67:	83 c4 10             	add    $0x10,%esp
  801e6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801e6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e70:	a1 24 50 80 00       	mov    0x805024,%eax
  801e75:	8b 40 78             	mov    0x78(%eax),%eax
  801e78:	29 c2                	sub    %eax,%edx
  801e7a:	89 d0                	mov    %edx,%eax
  801e7c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e81:	c1 e8 0c             	shr    $0xc,%eax
  801e84:	89 c2                	mov    %eax,%edx
  801e86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e89:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801e90:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801e94:	75 07                	jne    801e9d <sget+0xa3>
  801e96:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9b:	eb 03                	jmp    801ea0 <sget+0xa6>
	return ptr;
  801e9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801ea8:	8b 55 08             	mov    0x8(%ebp),%edx
  801eab:	a1 24 50 80 00       	mov    0x805024,%eax
  801eb0:	8b 40 78             	mov    0x78(%eax),%eax
  801eb3:	29 c2                	sub    %eax,%edx
  801eb5:	89 d0                	mov    %edx,%eax
  801eb7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ebc:	c1 e8 0c             	shr    $0xc,%eax
  801ebf:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801ec9:	83 ec 08             	sub    $0x8,%esp
  801ecc:	ff 75 08             	pushl  0x8(%ebp)
  801ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed2:	e8 db 02 00 00       	call   8021b2 <sys_freeSharedObject>
  801ed7:	83 c4 10             	add    $0x10,%esp
  801eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801edd:	90                   	nop
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ee6:	83 ec 04             	sub    $0x4,%esp
  801ee9:	68 d4 4a 80 00       	push   $0x804ad4
  801eee:	68 de 00 00 00       	push   $0xde
  801ef3:	68 b6 4a 80 00       	push   $0x804ab6
  801ef8:	e8 b3 e8 ff ff       	call   8007b0 <_panic>

00801efd <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f03:	83 ec 04             	sub    $0x4,%esp
  801f06:	68 fa 4a 80 00       	push   $0x804afa
  801f0b:	68 ea 00 00 00       	push   $0xea
  801f10:	68 b6 4a 80 00       	push   $0x804ab6
  801f15:	e8 96 e8 ff ff       	call   8007b0 <_panic>

00801f1a <shrink>:

}
void shrink(uint32 newSize)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f20:	83 ec 04             	sub    $0x4,%esp
  801f23:	68 fa 4a 80 00       	push   $0x804afa
  801f28:	68 ef 00 00 00       	push   $0xef
  801f2d:	68 b6 4a 80 00       	push   $0x804ab6
  801f32:	e8 79 e8 ff ff       	call   8007b0 <_panic>

00801f37 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
  801f3a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f3d:	83 ec 04             	sub    $0x4,%esp
  801f40:	68 fa 4a 80 00       	push   $0x804afa
  801f45:	68 f4 00 00 00       	push   $0xf4
  801f4a:	68 b6 4a 80 00       	push   $0x804ab6
  801f4f:	e8 5c e8 ff ff       	call   8007b0 <_panic>

00801f54 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	57                   	push   %edi
  801f58:	56                   	push   %esi
  801f59:	53                   	push   %ebx
  801f5a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f63:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f66:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f69:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f6c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f6f:	cd 30                	int    $0x30
  801f71:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f77:	83 c4 10             	add    $0x10,%esp
  801f7a:	5b                   	pop    %ebx
  801f7b:	5e                   	pop    %esi
  801f7c:	5f                   	pop    %edi
  801f7d:	5d                   	pop    %ebp
  801f7e:	c3                   	ret    

00801f7f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	8b 45 10             	mov    0x10(%ebp),%eax
  801f88:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f8b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	52                   	push   %edx
  801f97:	ff 75 0c             	pushl  0xc(%ebp)
  801f9a:	50                   	push   %eax
  801f9b:	6a 00                	push   $0x0
  801f9d:	e8 b2 ff ff ff       	call   801f54 <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
}
  801fa5:	90                   	nop
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_cgetc>:

int
sys_cgetc(void)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 02                	push   $0x2
  801fb7:	e8 98 ff ff ff       	call   801f54 <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 03                	push   $0x3
  801fd0:	e8 7f ff ff ff       	call   801f54 <syscall>
  801fd5:	83 c4 18             	add    $0x18,%esp
}
  801fd8:	90                   	nop
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 04                	push   $0x4
  801fea:	e8 65 ff ff ff       	call   801f54 <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
}
  801ff2:	90                   	nop
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ff8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	52                   	push   %edx
  802005:	50                   	push   %eax
  802006:	6a 08                	push   $0x8
  802008:	e8 47 ff ff ff       	call   801f54 <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	56                   	push   %esi
  802016:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802017:	8b 75 18             	mov    0x18(%ebp),%esi
  80201a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80201d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802020:	8b 55 0c             	mov    0xc(%ebp),%edx
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	56                   	push   %esi
  802027:	53                   	push   %ebx
  802028:	51                   	push   %ecx
  802029:	52                   	push   %edx
  80202a:	50                   	push   %eax
  80202b:	6a 09                	push   $0x9
  80202d:	e8 22 ff ff ff       	call   801f54 <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
}
  802035:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802038:	5b                   	pop    %ebx
  802039:	5e                   	pop    %esi
  80203a:	5d                   	pop    %ebp
  80203b:	c3                   	ret    

0080203c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80203f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	52                   	push   %edx
  80204c:	50                   	push   %eax
  80204d:	6a 0a                	push   $0xa
  80204f:	e8 00 ff ff ff       	call   801f54 <syscall>
  802054:	83 c4 18             	add    $0x18,%esp
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	ff 75 0c             	pushl  0xc(%ebp)
  802065:	ff 75 08             	pushl  0x8(%ebp)
  802068:	6a 0b                	push   $0xb
  80206a:	e8 e5 fe ff ff       	call   801f54 <syscall>
  80206f:	83 c4 18             	add    $0x18,%esp
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 0c                	push   $0xc
  802083:	e8 cc fe ff ff       	call   801f54 <syscall>
  802088:	83 c4 18             	add    $0x18,%esp
}
  80208b:	c9                   	leave  
  80208c:	c3                   	ret    

0080208d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 0d                	push   $0xd
  80209c:	e8 b3 fe ff ff       	call   801f54 <syscall>
  8020a1:	83 c4 18             	add    $0x18,%esp
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 0e                	push   $0xe
  8020b5:	e8 9a fe ff ff       	call   801f54 <syscall>
  8020ba:	83 c4 18             	add    $0x18,%esp
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 0f                	push   $0xf
  8020ce:	e8 81 fe ff ff       	call   801f54 <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	ff 75 08             	pushl  0x8(%ebp)
  8020e6:	6a 10                	push   $0x10
  8020e8:	e8 67 fe ff ff       	call   801f54 <syscall>
  8020ed:	83 c4 18             	add    $0x18,%esp
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 11                	push   $0x11
  802101:	e8 4e fe ff ff       	call   801f54 <syscall>
  802106:	83 c4 18             	add    $0x18,%esp
}
  802109:	90                   	nop
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <sys_cputc>:

void
sys_cputc(const char c)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 04             	sub    $0x4,%esp
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802118:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	50                   	push   %eax
  802125:	6a 01                	push   $0x1
  802127:	e8 28 fe ff ff       	call   801f54 <syscall>
  80212c:	83 c4 18             	add    $0x18,%esp
}
  80212f:	90                   	nop
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 14                	push   $0x14
  802141:	e8 0e fe ff ff       	call   801f54 <syscall>
  802146:	83 c4 18             	add    $0x18,%esp
}
  802149:	90                   	nop
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    

0080214c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
  80214f:	83 ec 04             	sub    $0x4,%esp
  802152:	8b 45 10             	mov    0x10(%ebp),%eax
  802155:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802158:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80215b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	6a 00                	push   $0x0
  802164:	51                   	push   %ecx
  802165:	52                   	push   %edx
  802166:	ff 75 0c             	pushl  0xc(%ebp)
  802169:	50                   	push   %eax
  80216a:	6a 15                	push   $0x15
  80216c:	e8 e3 fd ff ff       	call   801f54 <syscall>
  802171:	83 c4 18             	add    $0x18,%esp
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	52                   	push   %edx
  802186:	50                   	push   %eax
  802187:	6a 16                	push   $0x16
  802189:	e8 c6 fd ff ff       	call   801f54 <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
}
  802191:	c9                   	leave  
  802192:	c3                   	ret    

00802193 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802196:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802199:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	51                   	push   %ecx
  8021a4:	52                   	push   %edx
  8021a5:	50                   	push   %eax
  8021a6:	6a 17                	push   $0x17
  8021a8:	e8 a7 fd ff ff       	call   801f54 <syscall>
  8021ad:	83 c4 18             	add    $0x18,%esp
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	52                   	push   %edx
  8021c2:	50                   	push   %eax
  8021c3:	6a 18                	push   $0x18
  8021c5:	e8 8a fd ff ff       	call   801f54 <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	6a 00                	push   $0x0
  8021d7:	ff 75 14             	pushl  0x14(%ebp)
  8021da:	ff 75 10             	pushl  0x10(%ebp)
  8021dd:	ff 75 0c             	pushl  0xc(%ebp)
  8021e0:	50                   	push   %eax
  8021e1:	6a 19                	push   $0x19
  8021e3:	e8 6c fd ff ff       	call   801f54 <syscall>
  8021e8:	83 c4 18             	add    $0x18,%esp
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <sys_run_env>:

void sys_run_env(int32 envId)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	50                   	push   %eax
  8021fc:	6a 1a                	push   $0x1a
  8021fe:	e8 51 fd ff ff       	call   801f54 <syscall>
  802203:	83 c4 18             	add    $0x18,%esp
}
  802206:	90                   	nop
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	50                   	push   %eax
  802218:	6a 1b                	push   $0x1b
  80221a:	e8 35 fd ff ff       	call   801f54 <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 05                	push   $0x5
  802233:	e8 1c fd ff ff       	call   801f54 <syscall>
  802238:	83 c4 18             	add    $0x18,%esp
}
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 06                	push   $0x6
  80224c:	e8 03 fd ff ff       	call   801f54 <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 07                	push   $0x7
  802265:	e8 ea fc ff ff       	call   801f54 <syscall>
  80226a:	83 c4 18             	add    $0x18,%esp
}
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <sys_exit_env>:


void sys_exit_env(void)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 1c                	push   $0x1c
  80227e:	e8 d1 fc ff ff       	call   801f54 <syscall>
  802283:	83 c4 18             	add    $0x18,%esp
}
  802286:	90                   	nop
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80228f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802292:	8d 50 04             	lea    0x4(%eax),%edx
  802295:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	52                   	push   %edx
  80229f:	50                   	push   %eax
  8022a0:	6a 1d                	push   $0x1d
  8022a2:	e8 ad fc ff ff       	call   801f54 <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
	return result;
  8022aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022b3:	89 01                	mov    %eax,(%ecx)
  8022b5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	c9                   	leave  
  8022bc:	c2 04 00             	ret    $0x4

008022bf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	ff 75 10             	pushl  0x10(%ebp)
  8022c9:	ff 75 0c             	pushl  0xc(%ebp)
  8022cc:	ff 75 08             	pushl  0x8(%ebp)
  8022cf:	6a 13                	push   $0x13
  8022d1:	e8 7e fc ff ff       	call   801f54 <syscall>
  8022d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d9:	90                   	nop
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <sys_rcr2>:
uint32 sys_rcr2()
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 1e                	push   $0x1e
  8022eb:	e8 64 fc ff ff       	call   801f54 <syscall>
  8022f0:	83 c4 18             	add    $0x18,%esp
}
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
  8022f8:	83 ec 04             	sub    $0x4,%esp
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802301:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	50                   	push   %eax
  80230e:	6a 1f                	push   $0x1f
  802310:	e8 3f fc ff ff       	call   801f54 <syscall>
  802315:	83 c4 18             	add    $0x18,%esp
	return ;
  802318:	90                   	nop
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <rsttst>:
void rsttst()
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 21                	push   $0x21
  80232a:	e8 25 fc ff ff       	call   801f54 <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
	return ;
  802332:	90                   	nop
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	83 ec 04             	sub    $0x4,%esp
  80233b:	8b 45 14             	mov    0x14(%ebp),%eax
  80233e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802341:	8b 55 18             	mov    0x18(%ebp),%edx
  802344:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802348:	52                   	push   %edx
  802349:	50                   	push   %eax
  80234a:	ff 75 10             	pushl  0x10(%ebp)
  80234d:	ff 75 0c             	pushl  0xc(%ebp)
  802350:	ff 75 08             	pushl  0x8(%ebp)
  802353:	6a 20                	push   $0x20
  802355:	e8 fa fb ff ff       	call   801f54 <syscall>
  80235a:	83 c4 18             	add    $0x18,%esp
	return ;
  80235d:	90                   	nop
}
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <chktst>:
void chktst(uint32 n)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	ff 75 08             	pushl  0x8(%ebp)
  80236e:	6a 22                	push   $0x22
  802370:	e8 df fb ff ff       	call   801f54 <syscall>
  802375:	83 c4 18             	add    $0x18,%esp
	return ;
  802378:	90                   	nop
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <inctst>:

void inctst()
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 23                	push   $0x23
  80238a:	e8 c5 fb ff ff       	call   801f54 <syscall>
  80238f:	83 c4 18             	add    $0x18,%esp
	return ;
  802392:	90                   	nop
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <gettst>:
uint32 gettst()
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 24                	push   $0x24
  8023a4:	e8 ab fb ff ff       	call   801f54 <syscall>
  8023a9:	83 c4 18             	add    $0x18,%esp
}
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
  8023b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 25                	push   $0x25
  8023c0:	e8 8f fb ff ff       	call   801f54 <syscall>
  8023c5:	83 c4 18             	add    $0x18,%esp
  8023c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023cb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023cf:	75 07                	jne    8023d8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d6:	eb 05                	jmp    8023dd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
  8023e2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 25                	push   $0x25
  8023f1:	e8 5e fb ff ff       	call   801f54 <syscall>
  8023f6:	83 c4 18             	add    $0x18,%esp
  8023f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023fc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802400:	75 07                	jne    802409 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802402:	b8 01 00 00 00       	mov    $0x1,%eax
  802407:	eb 05                	jmp    80240e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802409:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 25                	push   $0x25
  802422:	e8 2d fb ff ff       	call   801f54 <syscall>
  802427:	83 c4 18             	add    $0x18,%esp
  80242a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80242d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802431:	75 07                	jne    80243a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802433:	b8 01 00 00 00       	mov    $0x1,%eax
  802438:	eb 05                	jmp    80243f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80243a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
  802444:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 25                	push   $0x25
  802453:	e8 fc fa ff ff       	call   801f54 <syscall>
  802458:	83 c4 18             	add    $0x18,%esp
  80245b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80245e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802462:	75 07                	jne    80246b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802464:	b8 01 00 00 00       	mov    $0x1,%eax
  802469:	eb 05                	jmp    802470 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80246b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802470:	c9                   	leave  
  802471:	c3                   	ret    

00802472 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	ff 75 08             	pushl  0x8(%ebp)
  802480:	6a 26                	push   $0x26
  802482:	e8 cd fa ff ff       	call   801f54 <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
	return ;
  80248a:	90                   	nop
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802491:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802494:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802497:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	6a 00                	push   $0x0
  80249f:	53                   	push   %ebx
  8024a0:	51                   	push   %ecx
  8024a1:	52                   	push   %edx
  8024a2:	50                   	push   %eax
  8024a3:	6a 27                	push   $0x27
  8024a5:	e8 aa fa ff ff       	call   801f54 <syscall>
  8024aa:	83 c4 18             	add    $0x18,%esp
}
  8024ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	52                   	push   %edx
  8024c2:	50                   	push   %eax
  8024c3:	6a 28                	push   $0x28
  8024c5:	e8 8a fa ff ff       	call   801f54 <syscall>
  8024ca:	83 c4 18             	add    $0x18,%esp
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8024d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024db:	6a 00                	push   $0x0
  8024dd:	51                   	push   %ecx
  8024de:	ff 75 10             	pushl  0x10(%ebp)
  8024e1:	52                   	push   %edx
  8024e2:	50                   	push   %eax
  8024e3:	6a 29                	push   $0x29
  8024e5:	e8 6a fa ff ff       	call   801f54 <syscall>
  8024ea:	83 c4 18             	add    $0x18,%esp
}
  8024ed:	c9                   	leave  
  8024ee:	c3                   	ret    

008024ef <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	ff 75 10             	pushl  0x10(%ebp)
  8024f9:	ff 75 0c             	pushl  0xc(%ebp)
  8024fc:	ff 75 08             	pushl  0x8(%ebp)
  8024ff:	6a 12                	push   $0x12
  802501:	e8 4e fa ff ff       	call   801f54 <syscall>
  802506:	83 c4 18             	add    $0x18,%esp
	return ;
  802509:	90                   	nop
}
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80250f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	52                   	push   %edx
  80251c:	50                   	push   %eax
  80251d:	6a 2a                	push   $0x2a
  80251f:	e8 30 fa ff ff       	call   801f54 <syscall>
  802524:	83 c4 18             	add    $0x18,%esp
	return;
  802527:	90                   	nop
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80252d:	8b 45 08             	mov    0x8(%ebp),%eax
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	50                   	push   %eax
  802539:	6a 2b                	push   $0x2b
  80253b:	e8 14 fa ff ff       	call   801f54 <syscall>
  802540:	83 c4 18             	add    $0x18,%esp
}
  802543:	c9                   	leave  
  802544:	c3                   	ret    

00802545 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802545:	55                   	push   %ebp
  802546:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	ff 75 0c             	pushl  0xc(%ebp)
  802551:	ff 75 08             	pushl  0x8(%ebp)
  802554:	6a 2c                	push   $0x2c
  802556:	e8 f9 f9 ff ff       	call   801f54 <syscall>
  80255b:	83 c4 18             	add    $0x18,%esp
	return;
  80255e:	90                   	nop
}
  80255f:	c9                   	leave  
  802560:	c3                   	ret    

00802561 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	ff 75 0c             	pushl  0xc(%ebp)
  80256d:	ff 75 08             	pushl  0x8(%ebp)
  802570:	6a 2d                	push   $0x2d
  802572:	e8 dd f9 ff ff       	call   801f54 <syscall>
  802577:	83 c4 18             	add    $0x18,%esp
	return;
  80257a:	90                   	nop
}
  80257b:	c9                   	leave  
  80257c:	c3                   	ret    

0080257d <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80257d:	55                   	push   %ebp
  80257e:	89 e5                	mov    %esp,%ebp
  802580:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	83 e8 04             	sub    $0x4,%eax
  802589:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80258c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80258f:	8b 00                	mov    (%eax),%eax
  802591:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802594:	c9                   	leave  
  802595:	c3                   	ret    

00802596 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
  802599:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80259c:	8b 45 08             	mov    0x8(%ebp),%eax
  80259f:	83 e8 04             	sub    $0x4,%eax
  8025a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8025a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a8:	8b 00                	mov    (%eax),%eax
  8025aa:	83 e0 01             	and    $0x1,%eax
  8025ad:	85 c0                	test   %eax,%eax
  8025af:	0f 94 c0             	sete   %al
}
  8025b2:	c9                   	leave  
  8025b3:	c3                   	ret    

008025b4 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8025b4:	55                   	push   %ebp
  8025b5:	89 e5                	mov    %esp,%ebp
  8025b7:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8025ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8025c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c4:	83 f8 02             	cmp    $0x2,%eax
  8025c7:	74 2b                	je     8025f4 <alloc_block+0x40>
  8025c9:	83 f8 02             	cmp    $0x2,%eax
  8025cc:	7f 07                	jg     8025d5 <alloc_block+0x21>
  8025ce:	83 f8 01             	cmp    $0x1,%eax
  8025d1:	74 0e                	je     8025e1 <alloc_block+0x2d>
  8025d3:	eb 58                	jmp    80262d <alloc_block+0x79>
  8025d5:	83 f8 03             	cmp    $0x3,%eax
  8025d8:	74 2d                	je     802607 <alloc_block+0x53>
  8025da:	83 f8 04             	cmp    $0x4,%eax
  8025dd:	74 3b                	je     80261a <alloc_block+0x66>
  8025df:	eb 4c                	jmp    80262d <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8025e1:	83 ec 0c             	sub    $0xc,%esp
  8025e4:	ff 75 08             	pushl  0x8(%ebp)
  8025e7:	e8 11 03 00 00       	call   8028fd <alloc_block_FF>
  8025ec:	83 c4 10             	add    $0x10,%esp
  8025ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025f2:	eb 4a                	jmp    80263e <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8025f4:	83 ec 0c             	sub    $0xc,%esp
  8025f7:	ff 75 08             	pushl  0x8(%ebp)
  8025fa:	e8 fa 19 00 00       	call   803ff9 <alloc_block_NF>
  8025ff:	83 c4 10             	add    $0x10,%esp
  802602:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802605:	eb 37                	jmp    80263e <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802607:	83 ec 0c             	sub    $0xc,%esp
  80260a:	ff 75 08             	pushl  0x8(%ebp)
  80260d:	e8 a7 07 00 00       	call   802db9 <alloc_block_BF>
  802612:	83 c4 10             	add    $0x10,%esp
  802615:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802618:	eb 24                	jmp    80263e <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80261a:	83 ec 0c             	sub    $0xc,%esp
  80261d:	ff 75 08             	pushl  0x8(%ebp)
  802620:	e8 b7 19 00 00       	call   803fdc <alloc_block_WF>
  802625:	83 c4 10             	add    $0x10,%esp
  802628:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80262b:	eb 11                	jmp    80263e <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80262d:	83 ec 0c             	sub    $0xc,%esp
  802630:	68 0c 4b 80 00       	push   $0x804b0c
  802635:	e8 33 e4 ff ff       	call   800a6d <cprintf>
  80263a:	83 c4 10             	add    $0x10,%esp
		break;
  80263d:	90                   	nop
	}
	return va;
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802641:	c9                   	leave  
  802642:	c3                   	ret    

00802643 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
  802646:	53                   	push   %ebx
  802647:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80264a:	83 ec 0c             	sub    $0xc,%esp
  80264d:	68 2c 4b 80 00       	push   $0x804b2c
  802652:	e8 16 e4 ff ff       	call   800a6d <cprintf>
  802657:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80265a:	83 ec 0c             	sub    $0xc,%esp
  80265d:	68 57 4b 80 00       	push   $0x804b57
  802662:	e8 06 e4 ff ff       	call   800a6d <cprintf>
  802667:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80266a:	8b 45 08             	mov    0x8(%ebp),%eax
  80266d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802670:	eb 37                	jmp    8026a9 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802672:	83 ec 0c             	sub    $0xc,%esp
  802675:	ff 75 f4             	pushl  -0xc(%ebp)
  802678:	e8 19 ff ff ff       	call   802596 <is_free_block>
  80267d:	83 c4 10             	add    $0x10,%esp
  802680:	0f be d8             	movsbl %al,%ebx
  802683:	83 ec 0c             	sub    $0xc,%esp
  802686:	ff 75 f4             	pushl  -0xc(%ebp)
  802689:	e8 ef fe ff ff       	call   80257d <get_block_size>
  80268e:	83 c4 10             	add    $0x10,%esp
  802691:	83 ec 04             	sub    $0x4,%esp
  802694:	53                   	push   %ebx
  802695:	50                   	push   %eax
  802696:	68 6f 4b 80 00       	push   $0x804b6f
  80269b:	e8 cd e3 ff ff       	call   800a6d <cprintf>
  8026a0:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8026a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ad:	74 07                	je     8026b6 <print_blocks_list+0x73>
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 00                	mov    (%eax),%eax
  8026b4:	eb 05                	jmp    8026bb <print_blocks_list+0x78>
  8026b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bb:	89 45 10             	mov    %eax,0x10(%ebp)
  8026be:	8b 45 10             	mov    0x10(%ebp),%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	75 ad                	jne    802672 <print_blocks_list+0x2f>
  8026c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c9:	75 a7                	jne    802672 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8026cb:	83 ec 0c             	sub    $0xc,%esp
  8026ce:	68 2c 4b 80 00       	push   $0x804b2c
  8026d3:	e8 95 e3 ff ff       	call   800a6d <cprintf>
  8026d8:	83 c4 10             	add    $0x10,%esp

}
  8026db:	90                   	nop
  8026dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026df:	c9                   	leave  
  8026e0:	c3                   	ret    

008026e1 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8026e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ea:	83 e0 01             	and    $0x1,%eax
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	74 03                	je     8026f4 <initialize_dynamic_allocator+0x13>
  8026f1:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8026f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026f8:	0f 84 c7 01 00 00    	je     8028c5 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8026fe:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802705:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802708:	8b 55 08             	mov    0x8(%ebp),%edx
  80270b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80270e:	01 d0                	add    %edx,%eax
  802710:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802715:	0f 87 ad 01 00 00    	ja     8028c8 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	85 c0                	test   %eax,%eax
  802720:	0f 89 a5 01 00 00    	jns    8028cb <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802726:	8b 55 08             	mov    0x8(%ebp),%edx
  802729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272c:	01 d0                	add    %edx,%eax
  80272e:	83 e8 04             	sub    $0x4,%eax
  802731:	a3 4c 50 80 00       	mov    %eax,0x80504c
     struct BlockElement * element = NULL;
  802736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80273d:	a1 30 50 80 00       	mov    0x805030,%eax
  802742:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802745:	e9 87 00 00 00       	jmp    8027d1 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80274a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274e:	75 14                	jne    802764 <initialize_dynamic_allocator+0x83>
  802750:	83 ec 04             	sub    $0x4,%esp
  802753:	68 87 4b 80 00       	push   $0x804b87
  802758:	6a 79                	push   $0x79
  80275a:	68 a5 4b 80 00       	push   $0x804ba5
  80275f:	e8 4c e0 ff ff       	call   8007b0 <_panic>
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 00                	mov    (%eax),%eax
  802769:	85 c0                	test   %eax,%eax
  80276b:	74 10                	je     80277d <initialize_dynamic_allocator+0x9c>
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	8b 00                	mov    (%eax),%eax
  802772:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802775:	8b 52 04             	mov    0x4(%edx),%edx
  802778:	89 50 04             	mov    %edx,0x4(%eax)
  80277b:	eb 0b                	jmp    802788 <initialize_dynamic_allocator+0xa7>
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 40 04             	mov    0x4(%eax),%eax
  802783:	a3 34 50 80 00       	mov    %eax,0x805034
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 40 04             	mov    0x4(%eax),%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	74 0f                	je     8027a1 <initialize_dynamic_allocator+0xc0>
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 40 04             	mov    0x4(%eax),%eax
  802798:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279b:	8b 12                	mov    (%edx),%edx
  80279d:	89 10                	mov    %edx,(%eax)
  80279f:	eb 0a                	jmp    8027ab <initialize_dynamic_allocator+0xca>
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 00                	mov    (%eax),%eax
  8027a6:	a3 30 50 80 00       	mov    %eax,0x805030
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027be:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027c3:	48                   	dec    %eax
  8027c4:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8027c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8027ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d5:	74 07                	je     8027de <initialize_dynamic_allocator+0xfd>
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 00                	mov    (%eax),%eax
  8027dc:	eb 05                	jmp    8027e3 <initialize_dynamic_allocator+0x102>
  8027de:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e3:	a3 38 50 80 00       	mov    %eax,0x805038
  8027e8:	a1 38 50 80 00       	mov    0x805038,%eax
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	0f 85 55 ff ff ff    	jne    80274a <initialize_dynamic_allocator+0x69>
  8027f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f9:	0f 85 4b ff ff ff    	jne    80274a <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8027ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802802:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802808:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80280e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802813:	a3 48 50 80 00       	mov    %eax,0x805048
    end_block->info = 1;
  802818:	a1 48 50 80 00       	mov    0x805048,%eax
  80281d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802823:	8b 45 08             	mov    0x8(%ebp),%eax
  802826:	83 c0 08             	add    $0x8,%eax
  802829:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	83 c0 04             	add    $0x4,%eax
  802832:	8b 55 0c             	mov    0xc(%ebp),%edx
  802835:	83 ea 08             	sub    $0x8,%edx
  802838:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80283a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80283d:	8b 45 08             	mov    0x8(%ebp),%eax
  802840:	01 d0                	add    %edx,%eax
  802842:	83 e8 08             	sub    $0x8,%eax
  802845:	8b 55 0c             	mov    0xc(%ebp),%edx
  802848:	83 ea 08             	sub    $0x8,%edx
  80284b:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80284d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802850:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802859:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802860:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802864:	75 17                	jne    80287d <initialize_dynamic_allocator+0x19c>
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	68 c0 4b 80 00       	push   $0x804bc0
  80286e:	68 90 00 00 00       	push   $0x90
  802873:	68 a5 4b 80 00       	push   $0x804ba5
  802878:	e8 33 df ff ff       	call   8007b0 <_panic>
  80287d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802883:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802886:	89 10                	mov    %edx,(%eax)
  802888:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288b:	8b 00                	mov    (%eax),%eax
  80288d:	85 c0                	test   %eax,%eax
  80288f:	74 0d                	je     80289e <initialize_dynamic_allocator+0x1bd>
  802891:	a1 30 50 80 00       	mov    0x805030,%eax
  802896:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802899:	89 50 04             	mov    %edx,0x4(%eax)
  80289c:	eb 08                	jmp    8028a6 <initialize_dynamic_allocator+0x1c5>
  80289e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a1:	a3 34 50 80 00       	mov    %eax,0x805034
  8028a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8028ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8028bd:	40                   	inc    %eax
  8028be:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8028c3:	eb 07                	jmp    8028cc <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8028c5:	90                   	nop
  8028c6:	eb 04                	jmp    8028cc <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8028c8:	90                   	nop
  8028c9:	eb 01                	jmp    8028cc <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8028cb:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8028cc:	c9                   	leave  
  8028cd:	c3                   	ret    

008028ce <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8028ce:	55                   	push   %ebp
  8028cf:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8028d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8028d4:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8028d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028da:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028e0:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e5:	83 e8 04             	sub    $0x4,%eax
  8028e8:	8b 00                	mov    (%eax),%eax
  8028ea:	83 e0 fe             	and    $0xfffffffe,%eax
  8028ed:	8d 50 f8             	lea    -0x8(%eax),%edx
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	01 c2                	add    %eax,%edx
  8028f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028f8:	89 02                	mov    %eax,(%edx)
}
  8028fa:	90                   	nop
  8028fb:	5d                   	pop    %ebp
  8028fc:	c3                   	ret    

008028fd <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8028fd:	55                   	push   %ebp
  8028fe:	89 e5                	mov    %esp,%ebp
  802900:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	83 e0 01             	and    $0x1,%eax
  802909:	85 c0                	test   %eax,%eax
  80290b:	74 03                	je     802910 <alloc_block_FF+0x13>
  80290d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802910:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802914:	77 07                	ja     80291d <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802916:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80291d:	a1 28 50 80 00       	mov    0x805028,%eax
  802922:	85 c0                	test   %eax,%eax
  802924:	75 73                	jne    802999 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802926:	8b 45 08             	mov    0x8(%ebp),%eax
  802929:	83 c0 10             	add    $0x10,%eax
  80292c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80292f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802936:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293c:	01 d0                	add    %edx,%eax
  80293e:	48                   	dec    %eax
  80293f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802942:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802945:	ba 00 00 00 00       	mov    $0x0,%edx
  80294a:	f7 75 ec             	divl   -0x14(%ebp)
  80294d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802950:	29 d0                	sub    %edx,%eax
  802952:	c1 e8 0c             	shr    $0xc,%eax
  802955:	83 ec 0c             	sub    $0xc,%esp
  802958:	50                   	push   %eax
  802959:	e8 b1 f0 ff ff       	call   801a0f <sbrk>
  80295e:	83 c4 10             	add    $0x10,%esp
  802961:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802964:	83 ec 0c             	sub    $0xc,%esp
  802967:	6a 00                	push   $0x0
  802969:	e8 a1 f0 ff ff       	call   801a0f <sbrk>
  80296e:	83 c4 10             	add    $0x10,%esp
  802971:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802974:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802977:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80297a:	83 ec 08             	sub    $0x8,%esp
  80297d:	50                   	push   %eax
  80297e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802981:	e8 5b fd ff ff       	call   8026e1 <initialize_dynamic_allocator>
  802986:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802989:	83 ec 0c             	sub    $0xc,%esp
  80298c:	68 e3 4b 80 00       	push   $0x804be3
  802991:	e8 d7 e0 ff ff       	call   800a6d <cprintf>
  802996:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802999:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80299d:	75 0a                	jne    8029a9 <alloc_block_FF+0xac>
	        return NULL;
  80299f:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a4:	e9 0e 04 00 00       	jmp    802db7 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8029a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8029b0:	a1 30 50 80 00       	mov    0x805030,%eax
  8029b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b8:	e9 f3 02 00 00       	jmp    802cb0 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8029c3:	83 ec 0c             	sub    $0xc,%esp
  8029c6:	ff 75 bc             	pushl  -0x44(%ebp)
  8029c9:	e8 af fb ff ff       	call   80257d <get_block_size>
  8029ce:	83 c4 10             	add    $0x10,%esp
  8029d1:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d7:	83 c0 08             	add    $0x8,%eax
  8029da:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8029dd:	0f 87 c5 02 00 00    	ja     802ca8 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	83 c0 18             	add    $0x18,%eax
  8029e9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8029ec:	0f 87 19 02 00 00    	ja     802c0b <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8029f2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029f5:	2b 45 08             	sub    0x8(%ebp),%eax
  8029f8:	83 e8 08             	sub    $0x8,%eax
  8029fb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	8d 50 08             	lea    0x8(%eax),%edx
  802a04:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a07:	01 d0                	add    %edx,%eax
  802a09:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	83 c0 08             	add    $0x8,%eax
  802a12:	83 ec 04             	sub    $0x4,%esp
  802a15:	6a 01                	push   $0x1
  802a17:	50                   	push   %eax
  802a18:	ff 75 bc             	pushl  -0x44(%ebp)
  802a1b:	e8 ae fe ff ff       	call   8028ce <set_block_data>
  802a20:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 40 04             	mov    0x4(%eax),%eax
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	75 68                	jne    802a95 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a2d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a31:	75 17                	jne    802a4a <alloc_block_FF+0x14d>
  802a33:	83 ec 04             	sub    $0x4,%esp
  802a36:	68 c0 4b 80 00       	push   $0x804bc0
  802a3b:	68 d7 00 00 00       	push   $0xd7
  802a40:	68 a5 4b 80 00       	push   $0x804ba5
  802a45:	e8 66 dd ff ff       	call   8007b0 <_panic>
  802a4a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a50:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a53:	89 10                	mov    %edx,(%eax)
  802a55:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a58:	8b 00                	mov    (%eax),%eax
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	74 0d                	je     802a6b <alloc_block_FF+0x16e>
  802a5e:	a1 30 50 80 00       	mov    0x805030,%eax
  802a63:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a66:	89 50 04             	mov    %edx,0x4(%eax)
  802a69:	eb 08                	jmp    802a73 <alloc_block_FF+0x176>
  802a6b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a6e:	a3 34 50 80 00       	mov    %eax,0x805034
  802a73:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a76:	a3 30 50 80 00       	mov    %eax,0x805030
  802a7b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a85:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a8a:	40                   	inc    %eax
  802a8b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a90:	e9 dc 00 00 00       	jmp    802b71 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 00                	mov    (%eax),%eax
  802a9a:	85 c0                	test   %eax,%eax
  802a9c:	75 65                	jne    802b03 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a9e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802aa2:	75 17                	jne    802abb <alloc_block_FF+0x1be>
  802aa4:	83 ec 04             	sub    $0x4,%esp
  802aa7:	68 f4 4b 80 00       	push   $0x804bf4
  802aac:	68 db 00 00 00       	push   $0xdb
  802ab1:	68 a5 4b 80 00       	push   $0x804ba5
  802ab6:	e8 f5 dc ff ff       	call   8007b0 <_panic>
  802abb:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802ac1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac4:	89 50 04             	mov    %edx,0x4(%eax)
  802ac7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aca:	8b 40 04             	mov    0x4(%eax),%eax
  802acd:	85 c0                	test   %eax,%eax
  802acf:	74 0c                	je     802add <alloc_block_FF+0x1e0>
  802ad1:	a1 34 50 80 00       	mov    0x805034,%eax
  802ad6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ad9:	89 10                	mov    %edx,(%eax)
  802adb:	eb 08                	jmp    802ae5 <alloc_block_FF+0x1e8>
  802add:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ae5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae8:	a3 34 50 80 00       	mov    %eax,0x805034
  802aed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802af0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802afb:	40                   	inc    %eax
  802afc:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b01:	eb 6e                	jmp    802b71 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802b03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b07:	74 06                	je     802b0f <alloc_block_FF+0x212>
  802b09:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b0d:	75 17                	jne    802b26 <alloc_block_FF+0x229>
  802b0f:	83 ec 04             	sub    $0x4,%esp
  802b12:	68 18 4c 80 00       	push   $0x804c18
  802b17:	68 df 00 00 00       	push   $0xdf
  802b1c:	68 a5 4b 80 00       	push   $0x804ba5
  802b21:	e8 8a dc ff ff       	call   8007b0 <_panic>
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 10                	mov    (%eax),%edx
  802b2b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b2e:	89 10                	mov    %edx,(%eax)
  802b30:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b33:	8b 00                	mov    (%eax),%eax
  802b35:	85 c0                	test   %eax,%eax
  802b37:	74 0b                	je     802b44 <alloc_block_FF+0x247>
  802b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3c:	8b 00                	mov    (%eax),%eax
  802b3e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b41:	89 50 04             	mov    %edx,0x4(%eax)
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b4a:	89 10                	mov    %edx,(%eax)
  802b4c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b52:	89 50 04             	mov    %edx,0x4(%eax)
  802b55:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	85 c0                	test   %eax,%eax
  802b5c:	75 08                	jne    802b66 <alloc_block_FF+0x269>
  802b5e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b61:	a3 34 50 80 00       	mov    %eax,0x805034
  802b66:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b6b:	40                   	inc    %eax
  802b6c:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802b71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b75:	75 17                	jne    802b8e <alloc_block_FF+0x291>
  802b77:	83 ec 04             	sub    $0x4,%esp
  802b7a:	68 87 4b 80 00       	push   $0x804b87
  802b7f:	68 e1 00 00 00       	push   $0xe1
  802b84:	68 a5 4b 80 00       	push   $0x804ba5
  802b89:	e8 22 dc ff ff       	call   8007b0 <_panic>
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	8b 00                	mov    (%eax),%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	74 10                	je     802ba7 <alloc_block_FF+0x2aa>
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b9f:	8b 52 04             	mov    0x4(%edx),%edx
  802ba2:	89 50 04             	mov    %edx,0x4(%eax)
  802ba5:	eb 0b                	jmp    802bb2 <alloc_block_FF+0x2b5>
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 40 04             	mov    0x4(%eax),%eax
  802bad:	a3 34 50 80 00       	mov    %eax,0x805034
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 40 04             	mov    0x4(%eax),%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	74 0f                	je     802bcb <alloc_block_FF+0x2ce>
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	8b 40 04             	mov    0x4(%eax),%eax
  802bc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc5:	8b 12                	mov    (%edx),%edx
  802bc7:	89 10                	mov    %edx,(%eax)
  802bc9:	eb 0a                	jmp    802bd5 <alloc_block_FF+0x2d8>
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	8b 00                	mov    (%eax),%eax
  802bd0:	a3 30 50 80 00       	mov    %eax,0x805030
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bed:	48                   	dec    %eax
  802bee:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802bf3:	83 ec 04             	sub    $0x4,%esp
  802bf6:	6a 00                	push   $0x0
  802bf8:	ff 75 b4             	pushl  -0x4c(%ebp)
  802bfb:	ff 75 b0             	pushl  -0x50(%ebp)
  802bfe:	e8 cb fc ff ff       	call   8028ce <set_block_data>
  802c03:	83 c4 10             	add    $0x10,%esp
  802c06:	e9 95 00 00 00       	jmp    802ca0 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802c0b:	83 ec 04             	sub    $0x4,%esp
  802c0e:	6a 01                	push   $0x1
  802c10:	ff 75 b8             	pushl  -0x48(%ebp)
  802c13:	ff 75 bc             	pushl  -0x44(%ebp)
  802c16:	e8 b3 fc ff ff       	call   8028ce <set_block_data>
  802c1b:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802c1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c22:	75 17                	jne    802c3b <alloc_block_FF+0x33e>
  802c24:	83 ec 04             	sub    $0x4,%esp
  802c27:	68 87 4b 80 00       	push   $0x804b87
  802c2c:	68 e8 00 00 00       	push   $0xe8
  802c31:	68 a5 4b 80 00       	push   $0x804ba5
  802c36:	e8 75 db ff ff       	call   8007b0 <_panic>
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	85 c0                	test   %eax,%eax
  802c42:	74 10                	je     802c54 <alloc_block_FF+0x357>
  802c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c47:	8b 00                	mov    (%eax),%eax
  802c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4c:	8b 52 04             	mov    0x4(%edx),%edx
  802c4f:	89 50 04             	mov    %edx,0x4(%eax)
  802c52:	eb 0b                	jmp    802c5f <alloc_block_FF+0x362>
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 40 04             	mov    0x4(%eax),%eax
  802c5a:	a3 34 50 80 00       	mov    %eax,0x805034
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 40 04             	mov    0x4(%eax),%eax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	74 0f                	je     802c78 <alloc_block_FF+0x37b>
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 40 04             	mov    0x4(%eax),%eax
  802c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c72:	8b 12                	mov    (%edx),%edx
  802c74:	89 10                	mov    %edx,(%eax)
  802c76:	eb 0a                	jmp    802c82 <alloc_block_FF+0x385>
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 00                	mov    (%eax),%eax
  802c7d:	a3 30 50 80 00       	mov    %eax,0x805030
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c95:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c9a:	48                   	dec    %eax
  802c9b:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802ca0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ca3:	e9 0f 01 00 00       	jmp    802db7 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802ca8:	a1 38 50 80 00       	mov    0x805038,%eax
  802cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb4:	74 07                	je     802cbd <alloc_block_FF+0x3c0>
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	eb 05                	jmp    802cc2 <alloc_block_FF+0x3c5>
  802cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc2:	a3 38 50 80 00       	mov    %eax,0x805038
  802cc7:	a1 38 50 80 00       	mov    0x805038,%eax
  802ccc:	85 c0                	test   %eax,%eax
  802cce:	0f 85 e9 fc ff ff    	jne    8029bd <alloc_block_FF+0xc0>
  802cd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd8:	0f 85 df fc ff ff    	jne    8029bd <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802cde:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce1:	83 c0 08             	add    $0x8,%eax
  802ce4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ce7:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802cee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cf1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cf4:	01 d0                	add    %edx,%eax
  802cf6:	48                   	dec    %eax
  802cf7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802cfa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cfd:	ba 00 00 00 00       	mov    $0x0,%edx
  802d02:	f7 75 d8             	divl   -0x28(%ebp)
  802d05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d08:	29 d0                	sub    %edx,%eax
  802d0a:	c1 e8 0c             	shr    $0xc,%eax
  802d0d:	83 ec 0c             	sub    $0xc,%esp
  802d10:	50                   	push   %eax
  802d11:	e8 f9 ec ff ff       	call   801a0f <sbrk>
  802d16:	83 c4 10             	add    $0x10,%esp
  802d19:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802d1c:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d20:	75 0a                	jne    802d2c <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802d22:	b8 00 00 00 00       	mov    $0x0,%eax
  802d27:	e9 8b 00 00 00       	jmp    802db7 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d2c:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802d33:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d39:	01 d0                	add    %edx,%eax
  802d3b:	48                   	dec    %eax
  802d3c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802d3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d42:	ba 00 00 00 00       	mov    $0x0,%edx
  802d47:	f7 75 cc             	divl   -0x34(%ebp)
  802d4a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d4d:	29 d0                	sub    %edx,%eax
  802d4f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d52:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d55:	01 d0                	add    %edx,%eax
  802d57:	a3 48 50 80 00       	mov    %eax,0x805048
			end_block->info = 1;
  802d5c:	a1 48 50 80 00       	mov    0x805048,%eax
  802d61:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d67:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d71:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d74:	01 d0                	add    %edx,%eax
  802d76:	48                   	dec    %eax
  802d77:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d7a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d7d:	ba 00 00 00 00       	mov    $0x0,%edx
  802d82:	f7 75 c4             	divl   -0x3c(%ebp)
  802d85:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d88:	29 d0                	sub    %edx,%eax
  802d8a:	83 ec 04             	sub    $0x4,%esp
  802d8d:	6a 01                	push   $0x1
  802d8f:	50                   	push   %eax
  802d90:	ff 75 d0             	pushl  -0x30(%ebp)
  802d93:	e8 36 fb ff ff       	call   8028ce <set_block_data>
  802d98:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802d9b:	83 ec 0c             	sub    $0xc,%esp
  802d9e:	ff 75 d0             	pushl  -0x30(%ebp)
  802da1:	e8 1b 0a 00 00       	call   8037c1 <free_block>
  802da6:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802da9:	83 ec 0c             	sub    $0xc,%esp
  802dac:	ff 75 08             	pushl  0x8(%ebp)
  802daf:	e8 49 fb ff ff       	call   8028fd <alloc_block_FF>
  802db4:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802db7:	c9                   	leave  
  802db8:	c3                   	ret    

00802db9 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802db9:	55                   	push   %ebp
  802dba:	89 e5                	mov    %esp,%ebp
  802dbc:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	83 e0 01             	and    $0x1,%eax
  802dc5:	85 c0                	test   %eax,%eax
  802dc7:	74 03                	je     802dcc <alloc_block_BF+0x13>
  802dc9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802dcc:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802dd0:	77 07                	ja     802dd9 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802dd2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802dd9:	a1 28 50 80 00       	mov    0x805028,%eax
  802dde:	85 c0                	test   %eax,%eax
  802de0:	75 73                	jne    802e55 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	83 c0 10             	add    $0x10,%eax
  802de8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802deb:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802df2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802df5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df8:	01 d0                	add    %edx,%eax
  802dfa:	48                   	dec    %eax
  802dfb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802dfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e01:	ba 00 00 00 00       	mov    $0x0,%edx
  802e06:	f7 75 e0             	divl   -0x20(%ebp)
  802e09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e0c:	29 d0                	sub    %edx,%eax
  802e0e:	c1 e8 0c             	shr    $0xc,%eax
  802e11:	83 ec 0c             	sub    $0xc,%esp
  802e14:	50                   	push   %eax
  802e15:	e8 f5 eb ff ff       	call   801a0f <sbrk>
  802e1a:	83 c4 10             	add    $0x10,%esp
  802e1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802e20:	83 ec 0c             	sub    $0xc,%esp
  802e23:	6a 00                	push   $0x0
  802e25:	e8 e5 eb ff ff       	call   801a0f <sbrk>
  802e2a:	83 c4 10             	add    $0x10,%esp
  802e2d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802e30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e33:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802e36:	83 ec 08             	sub    $0x8,%esp
  802e39:	50                   	push   %eax
  802e3a:	ff 75 d8             	pushl  -0x28(%ebp)
  802e3d:	e8 9f f8 ff ff       	call   8026e1 <initialize_dynamic_allocator>
  802e42:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802e45:	83 ec 0c             	sub    $0xc,%esp
  802e48:	68 e3 4b 80 00       	push   $0x804be3
  802e4d:	e8 1b dc ff ff       	call   800a6d <cprintf>
  802e52:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802e55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802e5c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802e63:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802e6a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802e71:	a1 30 50 80 00       	mov    0x805030,%eax
  802e76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e79:	e9 1d 01 00 00       	jmp    802f9b <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802e84:	83 ec 0c             	sub    $0xc,%esp
  802e87:	ff 75 a8             	pushl  -0x58(%ebp)
  802e8a:	e8 ee f6 ff ff       	call   80257d <get_block_size>
  802e8f:	83 c4 10             	add    $0x10,%esp
  802e92:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	83 c0 08             	add    $0x8,%eax
  802e9b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e9e:	0f 87 ef 00 00 00    	ja     802f93 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	83 c0 18             	add    $0x18,%eax
  802eaa:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ead:	77 1d                	ja     802ecc <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802eb5:	0f 86 d8 00 00 00    	jbe    802f93 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802ebb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802ec1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ec4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ec7:	e9 c7 00 00 00       	jmp    802f93 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	83 c0 08             	add    $0x8,%eax
  802ed2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ed5:	0f 85 9d 00 00 00    	jne    802f78 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802edb:	83 ec 04             	sub    $0x4,%esp
  802ede:	6a 01                	push   $0x1
  802ee0:	ff 75 a4             	pushl  -0x5c(%ebp)
  802ee3:	ff 75 a8             	pushl  -0x58(%ebp)
  802ee6:	e8 e3 f9 ff ff       	call   8028ce <set_block_data>
  802eeb:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802eee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef2:	75 17                	jne    802f0b <alloc_block_BF+0x152>
  802ef4:	83 ec 04             	sub    $0x4,%esp
  802ef7:	68 87 4b 80 00       	push   $0x804b87
  802efc:	68 2c 01 00 00       	push   $0x12c
  802f01:	68 a5 4b 80 00       	push   $0x804ba5
  802f06:	e8 a5 d8 ff ff       	call   8007b0 <_panic>
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 00                	mov    (%eax),%eax
  802f10:	85 c0                	test   %eax,%eax
  802f12:	74 10                	je     802f24 <alloc_block_BF+0x16b>
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 00                	mov    (%eax),%eax
  802f19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1c:	8b 52 04             	mov    0x4(%edx),%edx
  802f1f:	89 50 04             	mov    %edx,0x4(%eax)
  802f22:	eb 0b                	jmp    802f2f <alloc_block_BF+0x176>
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	8b 40 04             	mov    0x4(%eax),%eax
  802f2a:	a3 34 50 80 00       	mov    %eax,0x805034
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	8b 40 04             	mov    0x4(%eax),%eax
  802f35:	85 c0                	test   %eax,%eax
  802f37:	74 0f                	je     802f48 <alloc_block_BF+0x18f>
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 40 04             	mov    0x4(%eax),%eax
  802f3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f42:	8b 12                	mov    (%edx),%edx
  802f44:	89 10                	mov    %edx,(%eax)
  802f46:	eb 0a                	jmp    802f52 <alloc_block_BF+0x199>
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	8b 00                	mov    (%eax),%eax
  802f4d:	a3 30 50 80 00       	mov    %eax,0x805030
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f65:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f6a:	48                   	dec    %eax
  802f6b:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802f70:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f73:	e9 24 04 00 00       	jmp    80339c <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802f78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f7e:	76 13                	jbe    802f93 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802f80:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802f87:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802f8d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f90:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802f93:	a1 38 50 80 00       	mov    0x805038,%eax
  802f98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9f:	74 07                	je     802fa8 <alloc_block_BF+0x1ef>
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	8b 00                	mov    (%eax),%eax
  802fa6:	eb 05                	jmp    802fad <alloc_block_BF+0x1f4>
  802fa8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fad:	a3 38 50 80 00       	mov    %eax,0x805038
  802fb2:	a1 38 50 80 00       	mov    0x805038,%eax
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	0f 85 bf fe ff ff    	jne    802e7e <alloc_block_BF+0xc5>
  802fbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc3:	0f 85 b5 fe ff ff    	jne    802e7e <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802fc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fcd:	0f 84 26 02 00 00    	je     8031f9 <alloc_block_BF+0x440>
  802fd3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fd7:	0f 85 1c 02 00 00    	jne    8031f9 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe0:	2b 45 08             	sub    0x8(%ebp),%eax
  802fe3:	83 e8 08             	sub    $0x8,%eax
  802fe6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	8d 50 08             	lea    0x8(%eax),%edx
  802fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff2:	01 d0                	add    %edx,%eax
  802ff4:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	83 c0 08             	add    $0x8,%eax
  802ffd:	83 ec 04             	sub    $0x4,%esp
  803000:	6a 01                	push   $0x1
  803002:	50                   	push   %eax
  803003:	ff 75 f0             	pushl  -0x10(%ebp)
  803006:	e8 c3 f8 ff ff       	call   8028ce <set_block_data>
  80300b:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80300e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803011:	8b 40 04             	mov    0x4(%eax),%eax
  803014:	85 c0                	test   %eax,%eax
  803016:	75 68                	jne    803080 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803018:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80301c:	75 17                	jne    803035 <alloc_block_BF+0x27c>
  80301e:	83 ec 04             	sub    $0x4,%esp
  803021:	68 c0 4b 80 00       	push   $0x804bc0
  803026:	68 45 01 00 00       	push   $0x145
  80302b:	68 a5 4b 80 00       	push   $0x804ba5
  803030:	e8 7b d7 ff ff       	call   8007b0 <_panic>
  803035:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80303b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80303e:	89 10                	mov    %edx,(%eax)
  803040:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	74 0d                	je     803056 <alloc_block_BF+0x29d>
  803049:	a1 30 50 80 00       	mov    0x805030,%eax
  80304e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803051:	89 50 04             	mov    %edx,0x4(%eax)
  803054:	eb 08                	jmp    80305e <alloc_block_BF+0x2a5>
  803056:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803059:	a3 34 50 80 00       	mov    %eax,0x805034
  80305e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803061:	a3 30 50 80 00       	mov    %eax,0x805030
  803066:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803069:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803070:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803075:	40                   	inc    %eax
  803076:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80307b:	e9 dc 00 00 00       	jmp    80315c <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803083:	8b 00                	mov    (%eax),%eax
  803085:	85 c0                	test   %eax,%eax
  803087:	75 65                	jne    8030ee <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803089:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80308d:	75 17                	jne    8030a6 <alloc_block_BF+0x2ed>
  80308f:	83 ec 04             	sub    $0x4,%esp
  803092:	68 f4 4b 80 00       	push   $0x804bf4
  803097:	68 4a 01 00 00       	push   $0x14a
  80309c:	68 a5 4b 80 00       	push   $0x804ba5
  8030a1:	e8 0a d7 ff ff       	call   8007b0 <_panic>
  8030a6:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8030ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030af:	89 50 04             	mov    %edx,0x4(%eax)
  8030b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b5:	8b 40 04             	mov    0x4(%eax),%eax
  8030b8:	85 c0                	test   %eax,%eax
  8030ba:	74 0c                	je     8030c8 <alloc_block_BF+0x30f>
  8030bc:	a1 34 50 80 00       	mov    0x805034,%eax
  8030c1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030c4:	89 10                	mov    %edx,(%eax)
  8030c6:	eb 08                	jmp    8030d0 <alloc_block_BF+0x317>
  8030c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8030d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030d3:	a3 34 50 80 00       	mov    %eax,0x805034
  8030d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030e6:	40                   	inc    %eax
  8030e7:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8030ec:	eb 6e                	jmp    80315c <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8030ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030f2:	74 06                	je     8030fa <alloc_block_BF+0x341>
  8030f4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030f8:	75 17                	jne    803111 <alloc_block_BF+0x358>
  8030fa:	83 ec 04             	sub    $0x4,%esp
  8030fd:	68 18 4c 80 00       	push   $0x804c18
  803102:	68 4f 01 00 00       	push   $0x14f
  803107:	68 a5 4b 80 00       	push   $0x804ba5
  80310c:	e8 9f d6 ff ff       	call   8007b0 <_panic>
  803111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803114:	8b 10                	mov    (%eax),%edx
  803116:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803119:	89 10                	mov    %edx,(%eax)
  80311b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 0b                	je     80312f <alloc_block_BF+0x376>
  803124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803127:	8b 00                	mov    (%eax),%eax
  803129:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80312c:	89 50 04             	mov    %edx,0x4(%eax)
  80312f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803132:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803135:	89 10                	mov    %edx,(%eax)
  803137:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80313a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80313d:	89 50 04             	mov    %edx,0x4(%eax)
  803140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803143:	8b 00                	mov    (%eax),%eax
  803145:	85 c0                	test   %eax,%eax
  803147:	75 08                	jne    803151 <alloc_block_BF+0x398>
  803149:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80314c:	a3 34 50 80 00       	mov    %eax,0x805034
  803151:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803156:	40                   	inc    %eax
  803157:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80315c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803160:	75 17                	jne    803179 <alloc_block_BF+0x3c0>
  803162:	83 ec 04             	sub    $0x4,%esp
  803165:	68 87 4b 80 00       	push   $0x804b87
  80316a:	68 51 01 00 00       	push   $0x151
  80316f:	68 a5 4b 80 00       	push   $0x804ba5
  803174:	e8 37 d6 ff ff       	call   8007b0 <_panic>
  803179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317c:	8b 00                	mov    (%eax),%eax
  80317e:	85 c0                	test   %eax,%eax
  803180:	74 10                	je     803192 <alloc_block_BF+0x3d9>
  803182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803185:	8b 00                	mov    (%eax),%eax
  803187:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80318a:	8b 52 04             	mov    0x4(%edx),%edx
  80318d:	89 50 04             	mov    %edx,0x4(%eax)
  803190:	eb 0b                	jmp    80319d <alloc_block_BF+0x3e4>
  803192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803195:	8b 40 04             	mov    0x4(%eax),%eax
  803198:	a3 34 50 80 00       	mov    %eax,0x805034
  80319d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a0:	8b 40 04             	mov    0x4(%eax),%eax
  8031a3:	85 c0                	test   %eax,%eax
  8031a5:	74 0f                	je     8031b6 <alloc_block_BF+0x3fd>
  8031a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031aa:	8b 40 04             	mov    0x4(%eax),%eax
  8031ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031b0:	8b 12                	mov    (%edx),%edx
  8031b2:	89 10                	mov    %edx,(%eax)
  8031b4:	eb 0a                	jmp    8031c0 <alloc_block_BF+0x407>
  8031b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b9:	8b 00                	mov    (%eax),%eax
  8031bb:	a3 30 50 80 00       	mov    %eax,0x805030
  8031c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031d8:	48                   	dec    %eax
  8031d9:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  8031de:	83 ec 04             	sub    $0x4,%esp
  8031e1:	6a 00                	push   $0x0
  8031e3:	ff 75 d0             	pushl  -0x30(%ebp)
  8031e6:	ff 75 cc             	pushl  -0x34(%ebp)
  8031e9:	e8 e0 f6 ff ff       	call   8028ce <set_block_data>
  8031ee:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8031f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f4:	e9 a3 01 00 00       	jmp    80339c <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8031f9:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8031fd:	0f 85 9d 00 00 00    	jne    8032a0 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803203:	83 ec 04             	sub    $0x4,%esp
  803206:	6a 01                	push   $0x1
  803208:	ff 75 ec             	pushl  -0x14(%ebp)
  80320b:	ff 75 f0             	pushl  -0x10(%ebp)
  80320e:	e8 bb f6 ff ff       	call   8028ce <set_block_data>
  803213:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803216:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80321a:	75 17                	jne    803233 <alloc_block_BF+0x47a>
  80321c:	83 ec 04             	sub    $0x4,%esp
  80321f:	68 87 4b 80 00       	push   $0x804b87
  803224:	68 58 01 00 00       	push   $0x158
  803229:	68 a5 4b 80 00       	push   $0x804ba5
  80322e:	e8 7d d5 ff ff       	call   8007b0 <_panic>
  803233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803236:	8b 00                	mov    (%eax),%eax
  803238:	85 c0                	test   %eax,%eax
  80323a:	74 10                	je     80324c <alloc_block_BF+0x493>
  80323c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323f:	8b 00                	mov    (%eax),%eax
  803241:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803244:	8b 52 04             	mov    0x4(%edx),%edx
  803247:	89 50 04             	mov    %edx,0x4(%eax)
  80324a:	eb 0b                	jmp    803257 <alloc_block_BF+0x49e>
  80324c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324f:	8b 40 04             	mov    0x4(%eax),%eax
  803252:	a3 34 50 80 00       	mov    %eax,0x805034
  803257:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325a:	8b 40 04             	mov    0x4(%eax),%eax
  80325d:	85 c0                	test   %eax,%eax
  80325f:	74 0f                	je     803270 <alloc_block_BF+0x4b7>
  803261:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803264:	8b 40 04             	mov    0x4(%eax),%eax
  803267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80326a:	8b 12                	mov    (%edx),%edx
  80326c:	89 10                	mov    %edx,(%eax)
  80326e:	eb 0a                	jmp    80327a <alloc_block_BF+0x4c1>
  803270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	a3 30 50 80 00       	mov    %eax,0x805030
  80327a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803286:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803292:	48                   	dec    %eax
  803293:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  803298:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329b:	e9 fc 00 00 00       	jmp    80339c <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a3:	83 c0 08             	add    $0x8,%eax
  8032a6:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8032a9:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8032b0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8032b6:	01 d0                	add    %edx,%eax
  8032b8:	48                   	dec    %eax
  8032b9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8032bc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8032c4:	f7 75 c4             	divl   -0x3c(%ebp)
  8032c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032ca:	29 d0                	sub    %edx,%eax
  8032cc:	c1 e8 0c             	shr    $0xc,%eax
  8032cf:	83 ec 0c             	sub    $0xc,%esp
  8032d2:	50                   	push   %eax
  8032d3:	e8 37 e7 ff ff       	call   801a0f <sbrk>
  8032d8:	83 c4 10             	add    $0x10,%esp
  8032db:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8032de:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8032e2:	75 0a                	jne    8032ee <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8032e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e9:	e9 ae 00 00 00       	jmp    80339c <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8032ee:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8032f5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8032fb:	01 d0                	add    %edx,%eax
  8032fd:	48                   	dec    %eax
  8032fe:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803301:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803304:	ba 00 00 00 00       	mov    $0x0,%edx
  803309:	f7 75 b8             	divl   -0x48(%ebp)
  80330c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80330f:	29 d0                	sub    %edx,%eax
  803311:	8d 50 fc             	lea    -0x4(%eax),%edx
  803314:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803317:	01 d0                	add    %edx,%eax
  803319:	a3 48 50 80 00       	mov    %eax,0x805048
				end_block->info = 1;
  80331e:	a1 48 50 80 00       	mov    0x805048,%eax
  803323:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803329:	83 ec 0c             	sub    $0xc,%esp
  80332c:	68 4c 4c 80 00       	push   $0x804c4c
  803331:	e8 37 d7 ff ff       	call   800a6d <cprintf>
  803336:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803339:	83 ec 08             	sub    $0x8,%esp
  80333c:	ff 75 bc             	pushl  -0x44(%ebp)
  80333f:	68 51 4c 80 00       	push   $0x804c51
  803344:	e8 24 d7 ff ff       	call   800a6d <cprintf>
  803349:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80334c:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803353:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803356:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803359:	01 d0                	add    %edx,%eax
  80335b:	48                   	dec    %eax
  80335c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80335f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803362:	ba 00 00 00 00       	mov    $0x0,%edx
  803367:	f7 75 b0             	divl   -0x50(%ebp)
  80336a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80336d:	29 d0                	sub    %edx,%eax
  80336f:	83 ec 04             	sub    $0x4,%esp
  803372:	6a 01                	push   $0x1
  803374:	50                   	push   %eax
  803375:	ff 75 bc             	pushl  -0x44(%ebp)
  803378:	e8 51 f5 ff ff       	call   8028ce <set_block_data>
  80337d:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803380:	83 ec 0c             	sub    $0xc,%esp
  803383:	ff 75 bc             	pushl  -0x44(%ebp)
  803386:	e8 36 04 00 00       	call   8037c1 <free_block>
  80338b:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80338e:	83 ec 0c             	sub    $0xc,%esp
  803391:	ff 75 08             	pushl  0x8(%ebp)
  803394:	e8 20 fa ff ff       	call   802db9 <alloc_block_BF>
  803399:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80339c:	c9                   	leave  
  80339d:	c3                   	ret    

0080339e <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80339e:	55                   	push   %ebp
  80339f:	89 e5                	mov    %esp,%ebp
  8033a1:	53                   	push   %ebx
  8033a2:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8033a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8033b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b7:	74 1e                	je     8033d7 <merging+0x39>
  8033b9:	ff 75 08             	pushl  0x8(%ebp)
  8033bc:	e8 bc f1 ff ff       	call   80257d <get_block_size>
  8033c1:	83 c4 04             	add    $0x4,%esp
  8033c4:	89 c2                	mov    %eax,%edx
  8033c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c9:	01 d0                	add    %edx,%eax
  8033cb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8033ce:	75 07                	jne    8033d7 <merging+0x39>
		prev_is_free = 1;
  8033d0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8033d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033db:	74 1e                	je     8033fb <merging+0x5d>
  8033dd:	ff 75 10             	pushl  0x10(%ebp)
  8033e0:	e8 98 f1 ff ff       	call   80257d <get_block_size>
  8033e5:	83 c4 04             	add    $0x4,%esp
  8033e8:	89 c2                	mov    %eax,%edx
  8033ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8033ed:	01 d0                	add    %edx,%eax
  8033ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033f2:	75 07                	jne    8033fb <merging+0x5d>
		next_is_free = 1;
  8033f4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8033fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ff:	0f 84 cc 00 00 00    	je     8034d1 <merging+0x133>
  803405:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803409:	0f 84 c2 00 00 00    	je     8034d1 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80340f:	ff 75 08             	pushl  0x8(%ebp)
  803412:	e8 66 f1 ff ff       	call   80257d <get_block_size>
  803417:	83 c4 04             	add    $0x4,%esp
  80341a:	89 c3                	mov    %eax,%ebx
  80341c:	ff 75 10             	pushl  0x10(%ebp)
  80341f:	e8 59 f1 ff ff       	call   80257d <get_block_size>
  803424:	83 c4 04             	add    $0x4,%esp
  803427:	01 c3                	add    %eax,%ebx
  803429:	ff 75 0c             	pushl  0xc(%ebp)
  80342c:	e8 4c f1 ff ff       	call   80257d <get_block_size>
  803431:	83 c4 04             	add    $0x4,%esp
  803434:	01 d8                	add    %ebx,%eax
  803436:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803439:	6a 00                	push   $0x0
  80343b:	ff 75 ec             	pushl  -0x14(%ebp)
  80343e:	ff 75 08             	pushl  0x8(%ebp)
  803441:	e8 88 f4 ff ff       	call   8028ce <set_block_data>
  803446:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803449:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80344d:	75 17                	jne    803466 <merging+0xc8>
  80344f:	83 ec 04             	sub    $0x4,%esp
  803452:	68 87 4b 80 00       	push   $0x804b87
  803457:	68 7d 01 00 00       	push   $0x17d
  80345c:	68 a5 4b 80 00       	push   $0x804ba5
  803461:	e8 4a d3 ff ff       	call   8007b0 <_panic>
  803466:	8b 45 0c             	mov    0xc(%ebp),%eax
  803469:	8b 00                	mov    (%eax),%eax
  80346b:	85 c0                	test   %eax,%eax
  80346d:	74 10                	je     80347f <merging+0xe1>
  80346f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803472:	8b 00                	mov    (%eax),%eax
  803474:	8b 55 0c             	mov    0xc(%ebp),%edx
  803477:	8b 52 04             	mov    0x4(%edx),%edx
  80347a:	89 50 04             	mov    %edx,0x4(%eax)
  80347d:	eb 0b                	jmp    80348a <merging+0xec>
  80347f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803482:	8b 40 04             	mov    0x4(%eax),%eax
  803485:	a3 34 50 80 00       	mov    %eax,0x805034
  80348a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348d:	8b 40 04             	mov    0x4(%eax),%eax
  803490:	85 c0                	test   %eax,%eax
  803492:	74 0f                	je     8034a3 <merging+0x105>
  803494:	8b 45 0c             	mov    0xc(%ebp),%eax
  803497:	8b 40 04             	mov    0x4(%eax),%eax
  80349a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80349d:	8b 12                	mov    (%edx),%edx
  80349f:	89 10                	mov    %edx,(%eax)
  8034a1:	eb 0a                	jmp    8034ad <merging+0x10f>
  8034a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a6:	8b 00                	mov    (%eax),%eax
  8034a8:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034c5:	48                   	dec    %eax
  8034c6:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8034cb:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034cc:	e9 ea 02 00 00       	jmp    8037bb <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8034d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d5:	74 3b                	je     803512 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8034d7:	83 ec 0c             	sub    $0xc,%esp
  8034da:	ff 75 08             	pushl  0x8(%ebp)
  8034dd:	e8 9b f0 ff ff       	call   80257d <get_block_size>
  8034e2:	83 c4 10             	add    $0x10,%esp
  8034e5:	89 c3                	mov    %eax,%ebx
  8034e7:	83 ec 0c             	sub    $0xc,%esp
  8034ea:	ff 75 10             	pushl  0x10(%ebp)
  8034ed:	e8 8b f0 ff ff       	call   80257d <get_block_size>
  8034f2:	83 c4 10             	add    $0x10,%esp
  8034f5:	01 d8                	add    %ebx,%eax
  8034f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8034fa:	83 ec 04             	sub    $0x4,%esp
  8034fd:	6a 00                	push   $0x0
  8034ff:	ff 75 e8             	pushl  -0x18(%ebp)
  803502:	ff 75 08             	pushl  0x8(%ebp)
  803505:	e8 c4 f3 ff ff       	call   8028ce <set_block_data>
  80350a:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80350d:	e9 a9 02 00 00       	jmp    8037bb <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803512:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803516:	0f 84 2d 01 00 00    	je     803649 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80351c:	83 ec 0c             	sub    $0xc,%esp
  80351f:	ff 75 10             	pushl  0x10(%ebp)
  803522:	e8 56 f0 ff ff       	call   80257d <get_block_size>
  803527:	83 c4 10             	add    $0x10,%esp
  80352a:	89 c3                	mov    %eax,%ebx
  80352c:	83 ec 0c             	sub    $0xc,%esp
  80352f:	ff 75 0c             	pushl  0xc(%ebp)
  803532:	e8 46 f0 ff ff       	call   80257d <get_block_size>
  803537:	83 c4 10             	add    $0x10,%esp
  80353a:	01 d8                	add    %ebx,%eax
  80353c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80353f:	83 ec 04             	sub    $0x4,%esp
  803542:	6a 00                	push   $0x0
  803544:	ff 75 e4             	pushl  -0x1c(%ebp)
  803547:	ff 75 10             	pushl  0x10(%ebp)
  80354a:	e8 7f f3 ff ff       	call   8028ce <set_block_data>
  80354f:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803552:	8b 45 10             	mov    0x10(%ebp),%eax
  803555:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803558:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80355c:	74 06                	je     803564 <merging+0x1c6>
  80355e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803562:	75 17                	jne    80357b <merging+0x1dd>
  803564:	83 ec 04             	sub    $0x4,%esp
  803567:	68 60 4c 80 00       	push   $0x804c60
  80356c:	68 8d 01 00 00       	push   $0x18d
  803571:	68 a5 4b 80 00       	push   $0x804ba5
  803576:	e8 35 d2 ff ff       	call   8007b0 <_panic>
  80357b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80357e:	8b 50 04             	mov    0x4(%eax),%edx
  803581:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803584:	89 50 04             	mov    %edx,0x4(%eax)
  803587:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80358a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80358d:	89 10                	mov    %edx,(%eax)
  80358f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803592:	8b 40 04             	mov    0x4(%eax),%eax
  803595:	85 c0                	test   %eax,%eax
  803597:	74 0d                	je     8035a6 <merging+0x208>
  803599:	8b 45 0c             	mov    0xc(%ebp),%eax
  80359c:	8b 40 04             	mov    0x4(%eax),%eax
  80359f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035a2:	89 10                	mov    %edx,(%eax)
  8035a4:	eb 08                	jmp    8035ae <merging+0x210>
  8035a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8035ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035b4:	89 50 04             	mov    %edx,0x4(%eax)
  8035b7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035bc:	40                   	inc    %eax
  8035bd:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  8035c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035c6:	75 17                	jne    8035df <merging+0x241>
  8035c8:	83 ec 04             	sub    $0x4,%esp
  8035cb:	68 87 4b 80 00       	push   $0x804b87
  8035d0:	68 8e 01 00 00       	push   $0x18e
  8035d5:	68 a5 4b 80 00       	push   $0x804ba5
  8035da:	e8 d1 d1 ff ff       	call   8007b0 <_panic>
  8035df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e2:	8b 00                	mov    (%eax),%eax
  8035e4:	85 c0                	test   %eax,%eax
  8035e6:	74 10                	je     8035f8 <merging+0x25a>
  8035e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035eb:	8b 00                	mov    (%eax),%eax
  8035ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f0:	8b 52 04             	mov    0x4(%edx),%edx
  8035f3:	89 50 04             	mov    %edx,0x4(%eax)
  8035f6:	eb 0b                	jmp    803603 <merging+0x265>
  8035f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fb:	8b 40 04             	mov    0x4(%eax),%eax
  8035fe:	a3 34 50 80 00       	mov    %eax,0x805034
  803603:	8b 45 0c             	mov    0xc(%ebp),%eax
  803606:	8b 40 04             	mov    0x4(%eax),%eax
  803609:	85 c0                	test   %eax,%eax
  80360b:	74 0f                	je     80361c <merging+0x27e>
  80360d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803610:	8b 40 04             	mov    0x4(%eax),%eax
  803613:	8b 55 0c             	mov    0xc(%ebp),%edx
  803616:	8b 12                	mov    (%edx),%edx
  803618:	89 10                	mov    %edx,(%eax)
  80361a:	eb 0a                	jmp    803626 <merging+0x288>
  80361c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80361f:	8b 00                	mov    (%eax),%eax
  803621:	a3 30 50 80 00       	mov    %eax,0x805030
  803626:	8b 45 0c             	mov    0xc(%ebp),%eax
  803629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80362f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803639:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80363e:	48                   	dec    %eax
  80363f:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803644:	e9 72 01 00 00       	jmp    8037bb <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803649:	8b 45 10             	mov    0x10(%ebp),%eax
  80364c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80364f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803653:	74 79                	je     8036ce <merging+0x330>
  803655:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803659:	74 73                	je     8036ce <merging+0x330>
  80365b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80365f:	74 06                	je     803667 <merging+0x2c9>
  803661:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803665:	75 17                	jne    80367e <merging+0x2e0>
  803667:	83 ec 04             	sub    $0x4,%esp
  80366a:	68 18 4c 80 00       	push   $0x804c18
  80366f:	68 94 01 00 00       	push   $0x194
  803674:	68 a5 4b 80 00       	push   $0x804ba5
  803679:	e8 32 d1 ff ff       	call   8007b0 <_panic>
  80367e:	8b 45 08             	mov    0x8(%ebp),%eax
  803681:	8b 10                	mov    (%eax),%edx
  803683:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803686:	89 10                	mov    %edx,(%eax)
  803688:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80368b:	8b 00                	mov    (%eax),%eax
  80368d:	85 c0                	test   %eax,%eax
  80368f:	74 0b                	je     80369c <merging+0x2fe>
  803691:	8b 45 08             	mov    0x8(%ebp),%eax
  803694:	8b 00                	mov    (%eax),%eax
  803696:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803699:	89 50 04             	mov    %edx,0x4(%eax)
  80369c:	8b 45 08             	mov    0x8(%ebp),%eax
  80369f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036a2:	89 10                	mov    %edx,(%eax)
  8036a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8036aa:	89 50 04             	mov    %edx,0x4(%eax)
  8036ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036b0:	8b 00                	mov    (%eax),%eax
  8036b2:	85 c0                	test   %eax,%eax
  8036b4:	75 08                	jne    8036be <merging+0x320>
  8036b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036b9:	a3 34 50 80 00       	mov    %eax,0x805034
  8036be:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036c3:	40                   	inc    %eax
  8036c4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036c9:	e9 ce 00 00 00       	jmp    80379c <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8036ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036d2:	74 65                	je     803739 <merging+0x39b>
  8036d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036d8:	75 17                	jne    8036f1 <merging+0x353>
  8036da:	83 ec 04             	sub    $0x4,%esp
  8036dd:	68 f4 4b 80 00       	push   $0x804bf4
  8036e2:	68 95 01 00 00       	push   $0x195
  8036e7:	68 a5 4b 80 00       	push   $0x804ba5
  8036ec:	e8 bf d0 ff ff       	call   8007b0 <_panic>
  8036f1:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8036f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036fa:	89 50 04             	mov    %edx,0x4(%eax)
  8036fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803700:	8b 40 04             	mov    0x4(%eax),%eax
  803703:	85 c0                	test   %eax,%eax
  803705:	74 0c                	je     803713 <merging+0x375>
  803707:	a1 34 50 80 00       	mov    0x805034,%eax
  80370c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80370f:	89 10                	mov    %edx,(%eax)
  803711:	eb 08                	jmp    80371b <merging+0x37d>
  803713:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803716:	a3 30 50 80 00       	mov    %eax,0x805030
  80371b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80371e:	a3 34 50 80 00       	mov    %eax,0x805034
  803723:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803726:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80372c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803731:	40                   	inc    %eax
  803732:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803737:	eb 63                	jmp    80379c <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803739:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80373d:	75 17                	jne    803756 <merging+0x3b8>
  80373f:	83 ec 04             	sub    $0x4,%esp
  803742:	68 c0 4b 80 00       	push   $0x804bc0
  803747:	68 98 01 00 00       	push   $0x198
  80374c:	68 a5 4b 80 00       	push   $0x804ba5
  803751:	e8 5a d0 ff ff       	call   8007b0 <_panic>
  803756:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80375c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80375f:	89 10                	mov    %edx,(%eax)
  803761:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803764:	8b 00                	mov    (%eax),%eax
  803766:	85 c0                	test   %eax,%eax
  803768:	74 0d                	je     803777 <merging+0x3d9>
  80376a:	a1 30 50 80 00       	mov    0x805030,%eax
  80376f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803772:	89 50 04             	mov    %edx,0x4(%eax)
  803775:	eb 08                	jmp    80377f <merging+0x3e1>
  803777:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80377a:	a3 34 50 80 00       	mov    %eax,0x805034
  80377f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803782:	a3 30 50 80 00       	mov    %eax,0x805030
  803787:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80378a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803791:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803796:	40                   	inc    %eax
  803797:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  80379c:	83 ec 0c             	sub    $0xc,%esp
  80379f:	ff 75 10             	pushl  0x10(%ebp)
  8037a2:	e8 d6 ed ff ff       	call   80257d <get_block_size>
  8037a7:	83 c4 10             	add    $0x10,%esp
  8037aa:	83 ec 04             	sub    $0x4,%esp
  8037ad:	6a 00                	push   $0x0
  8037af:	50                   	push   %eax
  8037b0:	ff 75 10             	pushl  0x10(%ebp)
  8037b3:	e8 16 f1 ff ff       	call   8028ce <set_block_data>
  8037b8:	83 c4 10             	add    $0x10,%esp
	}
}
  8037bb:	90                   	nop
  8037bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8037bf:	c9                   	leave  
  8037c0:	c3                   	ret    

008037c1 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8037c1:	55                   	push   %ebp
  8037c2:	89 e5                	mov    %esp,%ebp
  8037c4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8037c7:	a1 30 50 80 00       	mov    0x805030,%eax
  8037cc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8037cf:	a1 34 50 80 00       	mov    0x805034,%eax
  8037d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037d7:	73 1b                	jae    8037f4 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8037d9:	a1 34 50 80 00       	mov    0x805034,%eax
  8037de:	83 ec 04             	sub    $0x4,%esp
  8037e1:	ff 75 08             	pushl  0x8(%ebp)
  8037e4:	6a 00                	push   $0x0
  8037e6:	50                   	push   %eax
  8037e7:	e8 b2 fb ff ff       	call   80339e <merging>
  8037ec:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037ef:	e9 8b 00 00 00       	jmp    80387f <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8037f4:	a1 30 50 80 00       	mov    0x805030,%eax
  8037f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037fc:	76 18                	jbe    803816 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8037fe:	a1 30 50 80 00       	mov    0x805030,%eax
  803803:	83 ec 04             	sub    $0x4,%esp
  803806:	ff 75 08             	pushl  0x8(%ebp)
  803809:	50                   	push   %eax
  80380a:	6a 00                	push   $0x0
  80380c:	e8 8d fb ff ff       	call   80339e <merging>
  803811:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803814:	eb 69                	jmp    80387f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803816:	a1 30 50 80 00       	mov    0x805030,%eax
  80381b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80381e:	eb 39                	jmp    803859 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803823:	3b 45 08             	cmp    0x8(%ebp),%eax
  803826:	73 29                	jae    803851 <free_block+0x90>
  803828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382b:	8b 00                	mov    (%eax),%eax
  80382d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803830:	76 1f                	jbe    803851 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803835:	8b 00                	mov    (%eax),%eax
  803837:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80383a:	83 ec 04             	sub    $0x4,%esp
  80383d:	ff 75 08             	pushl  0x8(%ebp)
  803840:	ff 75 f0             	pushl  -0x10(%ebp)
  803843:	ff 75 f4             	pushl  -0xc(%ebp)
  803846:	e8 53 fb ff ff       	call   80339e <merging>
  80384b:	83 c4 10             	add    $0x10,%esp
			break;
  80384e:	90                   	nop
		}
	}
}
  80384f:	eb 2e                	jmp    80387f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803851:	a1 38 50 80 00       	mov    0x805038,%eax
  803856:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803859:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80385d:	74 07                	je     803866 <free_block+0xa5>
  80385f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803862:	8b 00                	mov    (%eax),%eax
  803864:	eb 05                	jmp    80386b <free_block+0xaa>
  803866:	b8 00 00 00 00       	mov    $0x0,%eax
  80386b:	a3 38 50 80 00       	mov    %eax,0x805038
  803870:	a1 38 50 80 00       	mov    0x805038,%eax
  803875:	85 c0                	test   %eax,%eax
  803877:	75 a7                	jne    803820 <free_block+0x5f>
  803879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80387d:	75 a1                	jne    803820 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80387f:	90                   	nop
  803880:	c9                   	leave  
  803881:	c3                   	ret    

00803882 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803882:	55                   	push   %ebp
  803883:	89 e5                	mov    %esp,%ebp
  803885:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803888:	ff 75 08             	pushl  0x8(%ebp)
  80388b:	e8 ed ec ff ff       	call   80257d <get_block_size>
  803890:	83 c4 04             	add    $0x4,%esp
  803893:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803896:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80389d:	eb 17                	jmp    8038b6 <copy_data+0x34>
  80389f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8038a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038a5:	01 c2                	add    %eax,%edx
  8038a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8038aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ad:	01 c8                	add    %ecx,%eax
  8038af:	8a 00                	mov    (%eax),%al
  8038b1:	88 02                	mov    %al,(%edx)
  8038b3:	ff 45 fc             	incl   -0x4(%ebp)
  8038b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8038b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8038bc:	72 e1                	jb     80389f <copy_data+0x1d>
}
  8038be:	90                   	nop
  8038bf:	c9                   	leave  
  8038c0:	c3                   	ret    

008038c1 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8038c1:	55                   	push   %ebp
  8038c2:	89 e5                	mov    %esp,%ebp
  8038c4:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8038c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038cb:	75 23                	jne    8038f0 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8038cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038d1:	74 13                	je     8038e6 <realloc_block_FF+0x25>
  8038d3:	83 ec 0c             	sub    $0xc,%esp
  8038d6:	ff 75 0c             	pushl  0xc(%ebp)
  8038d9:	e8 1f f0 ff ff       	call   8028fd <alloc_block_FF>
  8038de:	83 c4 10             	add    $0x10,%esp
  8038e1:	e9 f4 06 00 00       	jmp    803fda <realloc_block_FF+0x719>
		return NULL;
  8038e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8038eb:	e9 ea 06 00 00       	jmp    803fda <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8038f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038f4:	75 18                	jne    80390e <realloc_block_FF+0x4d>
	{
		free_block(va);
  8038f6:	83 ec 0c             	sub    $0xc,%esp
  8038f9:	ff 75 08             	pushl  0x8(%ebp)
  8038fc:	e8 c0 fe ff ff       	call   8037c1 <free_block>
  803901:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803904:	b8 00 00 00 00       	mov    $0x0,%eax
  803909:	e9 cc 06 00 00       	jmp    803fda <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80390e:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803912:	77 07                	ja     80391b <realloc_block_FF+0x5a>
  803914:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80391b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80391e:	83 e0 01             	and    $0x1,%eax
  803921:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803924:	8b 45 0c             	mov    0xc(%ebp),%eax
  803927:	83 c0 08             	add    $0x8,%eax
  80392a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80392d:	83 ec 0c             	sub    $0xc,%esp
  803930:	ff 75 08             	pushl  0x8(%ebp)
  803933:	e8 45 ec ff ff       	call   80257d <get_block_size>
  803938:	83 c4 10             	add    $0x10,%esp
  80393b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80393e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803941:	83 e8 08             	sub    $0x8,%eax
  803944:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803947:	8b 45 08             	mov    0x8(%ebp),%eax
  80394a:	83 e8 04             	sub    $0x4,%eax
  80394d:	8b 00                	mov    (%eax),%eax
  80394f:	83 e0 fe             	and    $0xfffffffe,%eax
  803952:	89 c2                	mov    %eax,%edx
  803954:	8b 45 08             	mov    0x8(%ebp),%eax
  803957:	01 d0                	add    %edx,%eax
  803959:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80395c:	83 ec 0c             	sub    $0xc,%esp
  80395f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803962:	e8 16 ec ff ff       	call   80257d <get_block_size>
  803967:	83 c4 10             	add    $0x10,%esp
  80396a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80396d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803970:	83 e8 08             	sub    $0x8,%eax
  803973:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803976:	8b 45 0c             	mov    0xc(%ebp),%eax
  803979:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80397c:	75 08                	jne    803986 <realloc_block_FF+0xc5>
	{
		 return va;
  80397e:	8b 45 08             	mov    0x8(%ebp),%eax
  803981:	e9 54 06 00 00       	jmp    803fda <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803986:	8b 45 0c             	mov    0xc(%ebp),%eax
  803989:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80398c:	0f 83 e5 03 00 00    	jae    803d77 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803992:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803995:	2b 45 0c             	sub    0xc(%ebp),%eax
  803998:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80399b:	83 ec 0c             	sub    $0xc,%esp
  80399e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039a1:	e8 f0 eb ff ff       	call   802596 <is_free_block>
  8039a6:	83 c4 10             	add    $0x10,%esp
  8039a9:	84 c0                	test   %al,%al
  8039ab:	0f 84 3b 01 00 00    	je     803aec <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8039b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039b7:	01 d0                	add    %edx,%eax
  8039b9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8039bc:	83 ec 04             	sub    $0x4,%esp
  8039bf:	6a 01                	push   $0x1
  8039c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8039c4:	ff 75 08             	pushl  0x8(%ebp)
  8039c7:	e8 02 ef ff ff       	call   8028ce <set_block_data>
  8039cc:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8039cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d2:	83 e8 04             	sub    $0x4,%eax
  8039d5:	8b 00                	mov    (%eax),%eax
  8039d7:	83 e0 fe             	and    $0xfffffffe,%eax
  8039da:	89 c2                	mov    %eax,%edx
  8039dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039df:	01 d0                	add    %edx,%eax
  8039e1:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8039e4:	83 ec 04             	sub    $0x4,%esp
  8039e7:	6a 00                	push   $0x0
  8039e9:	ff 75 cc             	pushl  -0x34(%ebp)
  8039ec:	ff 75 c8             	pushl  -0x38(%ebp)
  8039ef:	e8 da ee ff ff       	call   8028ce <set_block_data>
  8039f4:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039fb:	74 06                	je     803a03 <realloc_block_FF+0x142>
  8039fd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803a01:	75 17                	jne    803a1a <realloc_block_FF+0x159>
  803a03:	83 ec 04             	sub    $0x4,%esp
  803a06:	68 18 4c 80 00       	push   $0x804c18
  803a0b:	68 f6 01 00 00       	push   $0x1f6
  803a10:	68 a5 4b 80 00       	push   $0x804ba5
  803a15:	e8 96 cd ff ff       	call   8007b0 <_panic>
  803a1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1d:	8b 10                	mov    (%eax),%edx
  803a1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a22:	89 10                	mov    %edx,(%eax)
  803a24:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a27:	8b 00                	mov    (%eax),%eax
  803a29:	85 c0                	test   %eax,%eax
  803a2b:	74 0b                	je     803a38 <realloc_block_FF+0x177>
  803a2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a30:	8b 00                	mov    (%eax),%eax
  803a32:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a35:	89 50 04             	mov    %edx,0x4(%eax)
  803a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a3e:	89 10                	mov    %edx,(%eax)
  803a40:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a46:	89 50 04             	mov    %edx,0x4(%eax)
  803a49:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a4c:	8b 00                	mov    (%eax),%eax
  803a4e:	85 c0                	test   %eax,%eax
  803a50:	75 08                	jne    803a5a <realloc_block_FF+0x199>
  803a52:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a55:	a3 34 50 80 00       	mov    %eax,0x805034
  803a5a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a5f:	40                   	inc    %eax
  803a60:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a69:	75 17                	jne    803a82 <realloc_block_FF+0x1c1>
  803a6b:	83 ec 04             	sub    $0x4,%esp
  803a6e:	68 87 4b 80 00       	push   $0x804b87
  803a73:	68 f7 01 00 00       	push   $0x1f7
  803a78:	68 a5 4b 80 00       	push   $0x804ba5
  803a7d:	e8 2e cd ff ff       	call   8007b0 <_panic>
  803a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a85:	8b 00                	mov    (%eax),%eax
  803a87:	85 c0                	test   %eax,%eax
  803a89:	74 10                	je     803a9b <realloc_block_FF+0x1da>
  803a8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a8e:	8b 00                	mov    (%eax),%eax
  803a90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a93:	8b 52 04             	mov    0x4(%edx),%edx
  803a96:	89 50 04             	mov    %edx,0x4(%eax)
  803a99:	eb 0b                	jmp    803aa6 <realloc_block_FF+0x1e5>
  803a9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9e:	8b 40 04             	mov    0x4(%eax),%eax
  803aa1:	a3 34 50 80 00       	mov    %eax,0x805034
  803aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa9:	8b 40 04             	mov    0x4(%eax),%eax
  803aac:	85 c0                	test   %eax,%eax
  803aae:	74 0f                	je     803abf <realloc_block_FF+0x1fe>
  803ab0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab3:	8b 40 04             	mov    0x4(%eax),%eax
  803ab6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ab9:	8b 12                	mov    (%edx),%edx
  803abb:	89 10                	mov    %edx,(%eax)
  803abd:	eb 0a                	jmp    803ac9 <realloc_block_FF+0x208>
  803abf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac2:	8b 00                	mov    (%eax),%eax
  803ac4:	a3 30 50 80 00       	mov    %eax,0x805030
  803ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803acc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803adc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ae1:	48                   	dec    %eax
  803ae2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803ae7:	e9 83 02 00 00       	jmp    803d6f <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803aec:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803af0:	0f 86 69 02 00 00    	jbe    803d5f <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803af6:	83 ec 04             	sub    $0x4,%esp
  803af9:	6a 01                	push   $0x1
  803afb:	ff 75 f0             	pushl  -0x10(%ebp)
  803afe:	ff 75 08             	pushl  0x8(%ebp)
  803b01:	e8 c8 ed ff ff       	call   8028ce <set_block_data>
  803b06:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b09:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0c:	83 e8 04             	sub    $0x4,%eax
  803b0f:	8b 00                	mov    (%eax),%eax
  803b11:	83 e0 fe             	and    $0xfffffffe,%eax
  803b14:	89 c2                	mov    %eax,%edx
  803b16:	8b 45 08             	mov    0x8(%ebp),%eax
  803b19:	01 d0                	add    %edx,%eax
  803b1b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803b1e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b23:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803b26:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b2a:	75 68                	jne    803b94 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b2c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b30:	75 17                	jne    803b49 <realloc_block_FF+0x288>
  803b32:	83 ec 04             	sub    $0x4,%esp
  803b35:	68 c0 4b 80 00       	push   $0x804bc0
  803b3a:	68 06 02 00 00       	push   $0x206
  803b3f:	68 a5 4b 80 00       	push   $0x804ba5
  803b44:	e8 67 cc ff ff       	call   8007b0 <_panic>
  803b49:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b52:	89 10                	mov    %edx,(%eax)
  803b54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b57:	8b 00                	mov    (%eax),%eax
  803b59:	85 c0                	test   %eax,%eax
  803b5b:	74 0d                	je     803b6a <realloc_block_FF+0x2a9>
  803b5d:	a1 30 50 80 00       	mov    0x805030,%eax
  803b62:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b65:	89 50 04             	mov    %edx,0x4(%eax)
  803b68:	eb 08                	jmp    803b72 <realloc_block_FF+0x2b1>
  803b6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b6d:	a3 34 50 80 00       	mov    %eax,0x805034
  803b72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b75:	a3 30 50 80 00       	mov    %eax,0x805030
  803b7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b84:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b89:	40                   	inc    %eax
  803b8a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b8f:	e9 b0 01 00 00       	jmp    803d44 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803b94:	a1 30 50 80 00       	mov    0x805030,%eax
  803b99:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b9c:	76 68                	jbe    803c06 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b9e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ba2:	75 17                	jne    803bbb <realloc_block_FF+0x2fa>
  803ba4:	83 ec 04             	sub    $0x4,%esp
  803ba7:	68 c0 4b 80 00       	push   $0x804bc0
  803bac:	68 0b 02 00 00       	push   $0x20b
  803bb1:	68 a5 4b 80 00       	push   $0x804ba5
  803bb6:	e8 f5 cb ff ff       	call   8007b0 <_panic>
  803bbb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803bc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc4:	89 10                	mov    %edx,(%eax)
  803bc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc9:	8b 00                	mov    (%eax),%eax
  803bcb:	85 c0                	test   %eax,%eax
  803bcd:	74 0d                	je     803bdc <realloc_block_FF+0x31b>
  803bcf:	a1 30 50 80 00       	mov    0x805030,%eax
  803bd4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bd7:	89 50 04             	mov    %edx,0x4(%eax)
  803bda:	eb 08                	jmp    803be4 <realloc_block_FF+0x323>
  803bdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bdf:	a3 34 50 80 00       	mov    %eax,0x805034
  803be4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be7:	a3 30 50 80 00       	mov    %eax,0x805030
  803bec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bf6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bfb:	40                   	inc    %eax
  803bfc:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c01:	e9 3e 01 00 00       	jmp    803d44 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803c06:	a1 30 50 80 00       	mov    0x805030,%eax
  803c0b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c0e:	73 68                	jae    803c78 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c10:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c14:	75 17                	jne    803c2d <realloc_block_FF+0x36c>
  803c16:	83 ec 04             	sub    $0x4,%esp
  803c19:	68 f4 4b 80 00       	push   $0x804bf4
  803c1e:	68 10 02 00 00       	push   $0x210
  803c23:	68 a5 4b 80 00       	push   $0x804ba5
  803c28:	e8 83 cb ff ff       	call   8007b0 <_panic>
  803c2d:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803c33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c36:	89 50 04             	mov    %edx,0x4(%eax)
  803c39:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c3c:	8b 40 04             	mov    0x4(%eax),%eax
  803c3f:	85 c0                	test   %eax,%eax
  803c41:	74 0c                	je     803c4f <realloc_block_FF+0x38e>
  803c43:	a1 34 50 80 00       	mov    0x805034,%eax
  803c48:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c4b:	89 10                	mov    %edx,(%eax)
  803c4d:	eb 08                	jmp    803c57 <realloc_block_FF+0x396>
  803c4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c52:	a3 30 50 80 00       	mov    %eax,0x805030
  803c57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c5a:	a3 34 50 80 00       	mov    %eax,0x805034
  803c5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c68:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c6d:	40                   	inc    %eax
  803c6e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c73:	e9 cc 00 00 00       	jmp    803d44 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803c78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803c7f:	a1 30 50 80 00       	mov    0x805030,%eax
  803c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c87:	e9 8a 00 00 00       	jmp    803d16 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c92:	73 7a                	jae    803d0e <realloc_block_FF+0x44d>
  803c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c97:	8b 00                	mov    (%eax),%eax
  803c99:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c9c:	73 70                	jae    803d0e <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803c9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ca2:	74 06                	je     803caa <realloc_block_FF+0x3e9>
  803ca4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ca8:	75 17                	jne    803cc1 <realloc_block_FF+0x400>
  803caa:	83 ec 04             	sub    $0x4,%esp
  803cad:	68 18 4c 80 00       	push   $0x804c18
  803cb2:	68 1a 02 00 00       	push   $0x21a
  803cb7:	68 a5 4b 80 00       	push   $0x804ba5
  803cbc:	e8 ef ca ff ff       	call   8007b0 <_panic>
  803cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc4:	8b 10                	mov    (%eax),%edx
  803cc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc9:	89 10                	mov    %edx,(%eax)
  803ccb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cce:	8b 00                	mov    (%eax),%eax
  803cd0:	85 c0                	test   %eax,%eax
  803cd2:	74 0b                	je     803cdf <realloc_block_FF+0x41e>
  803cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd7:	8b 00                	mov    (%eax),%eax
  803cd9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cdc:	89 50 04             	mov    %edx,0x4(%eax)
  803cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ce5:	89 10                	mov    %edx,(%eax)
  803ce7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ced:	89 50 04             	mov    %edx,0x4(%eax)
  803cf0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cf3:	8b 00                	mov    (%eax),%eax
  803cf5:	85 c0                	test   %eax,%eax
  803cf7:	75 08                	jne    803d01 <realloc_block_FF+0x440>
  803cf9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cfc:	a3 34 50 80 00       	mov    %eax,0x805034
  803d01:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d06:	40                   	inc    %eax
  803d07:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803d0c:	eb 36                	jmp    803d44 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803d0e:	a1 38 50 80 00       	mov    0x805038,%eax
  803d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d1a:	74 07                	je     803d23 <realloc_block_FF+0x462>
  803d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1f:	8b 00                	mov    (%eax),%eax
  803d21:	eb 05                	jmp    803d28 <realloc_block_FF+0x467>
  803d23:	b8 00 00 00 00       	mov    $0x0,%eax
  803d28:	a3 38 50 80 00       	mov    %eax,0x805038
  803d2d:	a1 38 50 80 00       	mov    0x805038,%eax
  803d32:	85 c0                	test   %eax,%eax
  803d34:	0f 85 52 ff ff ff    	jne    803c8c <realloc_block_FF+0x3cb>
  803d3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d3e:	0f 85 48 ff ff ff    	jne    803c8c <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803d44:	83 ec 04             	sub    $0x4,%esp
  803d47:	6a 00                	push   $0x0
  803d49:	ff 75 d8             	pushl  -0x28(%ebp)
  803d4c:	ff 75 d4             	pushl  -0x2c(%ebp)
  803d4f:	e8 7a eb ff ff       	call   8028ce <set_block_data>
  803d54:	83 c4 10             	add    $0x10,%esp
				return va;
  803d57:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5a:	e9 7b 02 00 00       	jmp    803fda <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803d5f:	83 ec 0c             	sub    $0xc,%esp
  803d62:	68 95 4c 80 00       	push   $0x804c95
  803d67:	e8 01 cd ff ff       	call   800a6d <cprintf>
  803d6c:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d72:	e9 63 02 00 00       	jmp    803fda <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d7a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d7d:	0f 86 4d 02 00 00    	jbe    803fd0 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803d83:	83 ec 0c             	sub    $0xc,%esp
  803d86:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d89:	e8 08 e8 ff ff       	call   802596 <is_free_block>
  803d8e:	83 c4 10             	add    $0x10,%esp
  803d91:	84 c0                	test   %al,%al
  803d93:	0f 84 37 02 00 00    	je     803fd0 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d9c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d9f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803da2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803da5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803da8:	76 38                	jbe    803de2 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803daa:	83 ec 0c             	sub    $0xc,%esp
  803dad:	ff 75 08             	pushl  0x8(%ebp)
  803db0:	e8 0c fa ff ff       	call   8037c1 <free_block>
  803db5:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803db8:	83 ec 0c             	sub    $0xc,%esp
  803dbb:	ff 75 0c             	pushl  0xc(%ebp)
  803dbe:	e8 3a eb ff ff       	call   8028fd <alloc_block_FF>
  803dc3:	83 c4 10             	add    $0x10,%esp
  803dc6:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803dc9:	83 ec 08             	sub    $0x8,%esp
  803dcc:	ff 75 c0             	pushl  -0x40(%ebp)
  803dcf:	ff 75 08             	pushl  0x8(%ebp)
  803dd2:	e8 ab fa ff ff       	call   803882 <copy_data>
  803dd7:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803dda:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803ddd:	e9 f8 01 00 00       	jmp    803fda <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803de2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803de5:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803de8:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803deb:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803def:	0f 87 a0 00 00 00    	ja     803e95 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803df5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803df9:	75 17                	jne    803e12 <realloc_block_FF+0x551>
  803dfb:	83 ec 04             	sub    $0x4,%esp
  803dfe:	68 87 4b 80 00       	push   $0x804b87
  803e03:	68 38 02 00 00       	push   $0x238
  803e08:	68 a5 4b 80 00       	push   $0x804ba5
  803e0d:	e8 9e c9 ff ff       	call   8007b0 <_panic>
  803e12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e15:	8b 00                	mov    (%eax),%eax
  803e17:	85 c0                	test   %eax,%eax
  803e19:	74 10                	je     803e2b <realloc_block_FF+0x56a>
  803e1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e1e:	8b 00                	mov    (%eax),%eax
  803e20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e23:	8b 52 04             	mov    0x4(%edx),%edx
  803e26:	89 50 04             	mov    %edx,0x4(%eax)
  803e29:	eb 0b                	jmp    803e36 <realloc_block_FF+0x575>
  803e2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e2e:	8b 40 04             	mov    0x4(%eax),%eax
  803e31:	a3 34 50 80 00       	mov    %eax,0x805034
  803e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e39:	8b 40 04             	mov    0x4(%eax),%eax
  803e3c:	85 c0                	test   %eax,%eax
  803e3e:	74 0f                	je     803e4f <realloc_block_FF+0x58e>
  803e40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e43:	8b 40 04             	mov    0x4(%eax),%eax
  803e46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e49:	8b 12                	mov    (%edx),%edx
  803e4b:	89 10                	mov    %edx,(%eax)
  803e4d:	eb 0a                	jmp    803e59 <realloc_block_FF+0x598>
  803e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e52:	8b 00                	mov    (%eax),%eax
  803e54:	a3 30 50 80 00       	mov    %eax,0x805030
  803e59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e6c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e71:	48                   	dec    %eax
  803e72:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803e77:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e7d:	01 d0                	add    %edx,%eax
  803e7f:	83 ec 04             	sub    $0x4,%esp
  803e82:	6a 01                	push   $0x1
  803e84:	50                   	push   %eax
  803e85:	ff 75 08             	pushl  0x8(%ebp)
  803e88:	e8 41 ea ff ff       	call   8028ce <set_block_data>
  803e8d:	83 c4 10             	add    $0x10,%esp
  803e90:	e9 36 01 00 00       	jmp    803fcb <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803e95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e98:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e9b:	01 d0                	add    %edx,%eax
  803e9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803ea0:	83 ec 04             	sub    $0x4,%esp
  803ea3:	6a 01                	push   $0x1
  803ea5:	ff 75 f0             	pushl  -0x10(%ebp)
  803ea8:	ff 75 08             	pushl  0x8(%ebp)
  803eab:	e8 1e ea ff ff       	call   8028ce <set_block_data>
  803eb0:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb6:	83 e8 04             	sub    $0x4,%eax
  803eb9:	8b 00                	mov    (%eax),%eax
  803ebb:	83 e0 fe             	and    $0xfffffffe,%eax
  803ebe:	89 c2                	mov    %eax,%edx
  803ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec3:	01 d0                	add    %edx,%eax
  803ec5:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803ec8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ecc:	74 06                	je     803ed4 <realloc_block_FF+0x613>
  803ece:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803ed2:	75 17                	jne    803eeb <realloc_block_FF+0x62a>
  803ed4:	83 ec 04             	sub    $0x4,%esp
  803ed7:	68 18 4c 80 00       	push   $0x804c18
  803edc:	68 44 02 00 00       	push   $0x244
  803ee1:	68 a5 4b 80 00       	push   $0x804ba5
  803ee6:	e8 c5 c8 ff ff       	call   8007b0 <_panic>
  803eeb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eee:	8b 10                	mov    (%eax),%edx
  803ef0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ef3:	89 10                	mov    %edx,(%eax)
  803ef5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ef8:	8b 00                	mov    (%eax),%eax
  803efa:	85 c0                	test   %eax,%eax
  803efc:	74 0b                	je     803f09 <realloc_block_FF+0x648>
  803efe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f01:	8b 00                	mov    (%eax),%eax
  803f03:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f06:	89 50 04             	mov    %edx,0x4(%eax)
  803f09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f0c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f0f:	89 10                	mov    %edx,(%eax)
  803f11:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f17:	89 50 04             	mov    %edx,0x4(%eax)
  803f1a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f1d:	8b 00                	mov    (%eax),%eax
  803f1f:	85 c0                	test   %eax,%eax
  803f21:	75 08                	jne    803f2b <realloc_block_FF+0x66a>
  803f23:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f26:	a3 34 50 80 00       	mov    %eax,0x805034
  803f2b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f30:	40                   	inc    %eax
  803f31:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803f36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f3a:	75 17                	jne    803f53 <realloc_block_FF+0x692>
  803f3c:	83 ec 04             	sub    $0x4,%esp
  803f3f:	68 87 4b 80 00       	push   $0x804b87
  803f44:	68 45 02 00 00       	push   $0x245
  803f49:	68 a5 4b 80 00       	push   $0x804ba5
  803f4e:	e8 5d c8 ff ff       	call   8007b0 <_panic>
  803f53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f56:	8b 00                	mov    (%eax),%eax
  803f58:	85 c0                	test   %eax,%eax
  803f5a:	74 10                	je     803f6c <realloc_block_FF+0x6ab>
  803f5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f5f:	8b 00                	mov    (%eax),%eax
  803f61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f64:	8b 52 04             	mov    0x4(%edx),%edx
  803f67:	89 50 04             	mov    %edx,0x4(%eax)
  803f6a:	eb 0b                	jmp    803f77 <realloc_block_FF+0x6b6>
  803f6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f6f:	8b 40 04             	mov    0x4(%eax),%eax
  803f72:	a3 34 50 80 00       	mov    %eax,0x805034
  803f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f7a:	8b 40 04             	mov    0x4(%eax),%eax
  803f7d:	85 c0                	test   %eax,%eax
  803f7f:	74 0f                	je     803f90 <realloc_block_FF+0x6cf>
  803f81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f84:	8b 40 04             	mov    0x4(%eax),%eax
  803f87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f8a:	8b 12                	mov    (%edx),%edx
  803f8c:	89 10                	mov    %edx,(%eax)
  803f8e:	eb 0a                	jmp    803f9a <realloc_block_FF+0x6d9>
  803f90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f93:	8b 00                	mov    (%eax),%eax
  803f95:	a3 30 50 80 00       	mov    %eax,0x805030
  803f9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fad:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803fb2:	48                   	dec    %eax
  803fb3:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803fb8:	83 ec 04             	sub    $0x4,%esp
  803fbb:	6a 00                	push   $0x0
  803fbd:	ff 75 bc             	pushl  -0x44(%ebp)
  803fc0:	ff 75 b8             	pushl  -0x48(%ebp)
  803fc3:	e8 06 e9 ff ff       	call   8028ce <set_block_data>
  803fc8:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  803fce:	eb 0a                	jmp    803fda <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803fd0:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803fd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803fda:	c9                   	leave  
  803fdb:	c3                   	ret    

00803fdc <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803fdc:	55                   	push   %ebp
  803fdd:	89 e5                	mov    %esp,%ebp
  803fdf:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803fe2:	83 ec 04             	sub    $0x4,%esp
  803fe5:	68 9c 4c 80 00       	push   $0x804c9c
  803fea:	68 58 02 00 00       	push   $0x258
  803fef:	68 a5 4b 80 00       	push   $0x804ba5
  803ff4:	e8 b7 c7 ff ff       	call   8007b0 <_panic>

00803ff9 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803ff9:	55                   	push   %ebp
  803ffa:	89 e5                	mov    %esp,%ebp
  803ffc:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803fff:	83 ec 04             	sub    $0x4,%esp
  804002:	68 c4 4c 80 00       	push   $0x804cc4
  804007:	68 61 02 00 00       	push   $0x261
  80400c:	68 a5 4b 80 00       	push   $0x804ba5
  804011:	e8 9a c7 ff ff       	call   8007b0 <_panic>

00804016 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  804016:	55                   	push   %ebp
  804017:	89 e5                	mov    %esp,%ebp
  804019:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  80401c:	83 ec 04             	sub    $0x4,%esp
  80401f:	68 ec 4c 80 00       	push   $0x804cec
  804024:	6a 09                	push   $0x9
  804026:	68 14 4d 80 00       	push   $0x804d14
  80402b:	e8 80 c7 ff ff       	call   8007b0 <_panic>

00804030 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  804030:	55                   	push   %ebp
  804031:	89 e5                	mov    %esp,%ebp
  804033:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  804036:	83 ec 04             	sub    $0x4,%esp
  804039:	68 24 4d 80 00       	push   $0x804d24
  80403e:	6a 10                	push   $0x10
  804040:	68 14 4d 80 00       	push   $0x804d14
  804045:	e8 66 c7 ff ff       	call   8007b0 <_panic>

0080404a <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  80404a:	55                   	push   %ebp
  80404b:	89 e5                	mov    %esp,%ebp
  80404d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  804050:	83 ec 04             	sub    $0x4,%esp
  804053:	68 4c 4d 80 00       	push   $0x804d4c
  804058:	6a 18                	push   $0x18
  80405a:	68 14 4d 80 00       	push   $0x804d14
  80405f:	e8 4c c7 ff ff       	call   8007b0 <_panic>

00804064 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  804064:	55                   	push   %ebp
  804065:	89 e5                	mov    %esp,%ebp
  804067:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  80406a:	83 ec 04             	sub    $0x4,%esp
  80406d:	68 74 4d 80 00       	push   $0x804d74
  804072:	6a 20                	push   $0x20
  804074:	68 14 4d 80 00       	push   $0x804d14
  804079:	e8 32 c7 ff ff       	call   8007b0 <_panic>

0080407e <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80407e:	55                   	push   %ebp
  80407f:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  804081:	8b 45 08             	mov    0x8(%ebp),%eax
  804084:	8b 40 10             	mov    0x10(%eax),%eax
}
  804087:	5d                   	pop    %ebp
  804088:	c3                   	ret    
  804089:	66 90                	xchg   %ax,%ax
  80408b:	90                   	nop

0080408c <__udivdi3>:
  80408c:	55                   	push   %ebp
  80408d:	57                   	push   %edi
  80408e:	56                   	push   %esi
  80408f:	53                   	push   %ebx
  804090:	83 ec 1c             	sub    $0x1c,%esp
  804093:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804097:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80409b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80409f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040a3:	89 ca                	mov    %ecx,%edx
  8040a5:	89 f8                	mov    %edi,%eax
  8040a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040ab:	85 f6                	test   %esi,%esi
  8040ad:	75 2d                	jne    8040dc <__udivdi3+0x50>
  8040af:	39 cf                	cmp    %ecx,%edi
  8040b1:	77 65                	ja     804118 <__udivdi3+0x8c>
  8040b3:	89 fd                	mov    %edi,%ebp
  8040b5:	85 ff                	test   %edi,%edi
  8040b7:	75 0b                	jne    8040c4 <__udivdi3+0x38>
  8040b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8040be:	31 d2                	xor    %edx,%edx
  8040c0:	f7 f7                	div    %edi
  8040c2:	89 c5                	mov    %eax,%ebp
  8040c4:	31 d2                	xor    %edx,%edx
  8040c6:	89 c8                	mov    %ecx,%eax
  8040c8:	f7 f5                	div    %ebp
  8040ca:	89 c1                	mov    %eax,%ecx
  8040cc:	89 d8                	mov    %ebx,%eax
  8040ce:	f7 f5                	div    %ebp
  8040d0:	89 cf                	mov    %ecx,%edi
  8040d2:	89 fa                	mov    %edi,%edx
  8040d4:	83 c4 1c             	add    $0x1c,%esp
  8040d7:	5b                   	pop    %ebx
  8040d8:	5e                   	pop    %esi
  8040d9:	5f                   	pop    %edi
  8040da:	5d                   	pop    %ebp
  8040db:	c3                   	ret    
  8040dc:	39 ce                	cmp    %ecx,%esi
  8040de:	77 28                	ja     804108 <__udivdi3+0x7c>
  8040e0:	0f bd fe             	bsr    %esi,%edi
  8040e3:	83 f7 1f             	xor    $0x1f,%edi
  8040e6:	75 40                	jne    804128 <__udivdi3+0x9c>
  8040e8:	39 ce                	cmp    %ecx,%esi
  8040ea:	72 0a                	jb     8040f6 <__udivdi3+0x6a>
  8040ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040f0:	0f 87 9e 00 00 00    	ja     804194 <__udivdi3+0x108>
  8040f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8040fb:	89 fa                	mov    %edi,%edx
  8040fd:	83 c4 1c             	add    $0x1c,%esp
  804100:	5b                   	pop    %ebx
  804101:	5e                   	pop    %esi
  804102:	5f                   	pop    %edi
  804103:	5d                   	pop    %ebp
  804104:	c3                   	ret    
  804105:	8d 76 00             	lea    0x0(%esi),%esi
  804108:	31 ff                	xor    %edi,%edi
  80410a:	31 c0                	xor    %eax,%eax
  80410c:	89 fa                	mov    %edi,%edx
  80410e:	83 c4 1c             	add    $0x1c,%esp
  804111:	5b                   	pop    %ebx
  804112:	5e                   	pop    %esi
  804113:	5f                   	pop    %edi
  804114:	5d                   	pop    %ebp
  804115:	c3                   	ret    
  804116:	66 90                	xchg   %ax,%ax
  804118:	89 d8                	mov    %ebx,%eax
  80411a:	f7 f7                	div    %edi
  80411c:	31 ff                	xor    %edi,%edi
  80411e:	89 fa                	mov    %edi,%edx
  804120:	83 c4 1c             	add    $0x1c,%esp
  804123:	5b                   	pop    %ebx
  804124:	5e                   	pop    %esi
  804125:	5f                   	pop    %edi
  804126:	5d                   	pop    %ebp
  804127:	c3                   	ret    
  804128:	bd 20 00 00 00       	mov    $0x20,%ebp
  80412d:	89 eb                	mov    %ebp,%ebx
  80412f:	29 fb                	sub    %edi,%ebx
  804131:	89 f9                	mov    %edi,%ecx
  804133:	d3 e6                	shl    %cl,%esi
  804135:	89 c5                	mov    %eax,%ebp
  804137:	88 d9                	mov    %bl,%cl
  804139:	d3 ed                	shr    %cl,%ebp
  80413b:	89 e9                	mov    %ebp,%ecx
  80413d:	09 f1                	or     %esi,%ecx
  80413f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804143:	89 f9                	mov    %edi,%ecx
  804145:	d3 e0                	shl    %cl,%eax
  804147:	89 c5                	mov    %eax,%ebp
  804149:	89 d6                	mov    %edx,%esi
  80414b:	88 d9                	mov    %bl,%cl
  80414d:	d3 ee                	shr    %cl,%esi
  80414f:	89 f9                	mov    %edi,%ecx
  804151:	d3 e2                	shl    %cl,%edx
  804153:	8b 44 24 08          	mov    0x8(%esp),%eax
  804157:	88 d9                	mov    %bl,%cl
  804159:	d3 e8                	shr    %cl,%eax
  80415b:	09 c2                	or     %eax,%edx
  80415d:	89 d0                	mov    %edx,%eax
  80415f:	89 f2                	mov    %esi,%edx
  804161:	f7 74 24 0c          	divl   0xc(%esp)
  804165:	89 d6                	mov    %edx,%esi
  804167:	89 c3                	mov    %eax,%ebx
  804169:	f7 e5                	mul    %ebp
  80416b:	39 d6                	cmp    %edx,%esi
  80416d:	72 19                	jb     804188 <__udivdi3+0xfc>
  80416f:	74 0b                	je     80417c <__udivdi3+0xf0>
  804171:	89 d8                	mov    %ebx,%eax
  804173:	31 ff                	xor    %edi,%edi
  804175:	e9 58 ff ff ff       	jmp    8040d2 <__udivdi3+0x46>
  80417a:	66 90                	xchg   %ax,%ax
  80417c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804180:	89 f9                	mov    %edi,%ecx
  804182:	d3 e2                	shl    %cl,%edx
  804184:	39 c2                	cmp    %eax,%edx
  804186:	73 e9                	jae    804171 <__udivdi3+0xe5>
  804188:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80418b:	31 ff                	xor    %edi,%edi
  80418d:	e9 40 ff ff ff       	jmp    8040d2 <__udivdi3+0x46>
  804192:	66 90                	xchg   %ax,%ax
  804194:	31 c0                	xor    %eax,%eax
  804196:	e9 37 ff ff ff       	jmp    8040d2 <__udivdi3+0x46>
  80419b:	90                   	nop

0080419c <__umoddi3>:
  80419c:	55                   	push   %ebp
  80419d:	57                   	push   %edi
  80419e:	56                   	push   %esi
  80419f:	53                   	push   %ebx
  8041a0:	83 ec 1c             	sub    $0x1c,%esp
  8041a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8041b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8041b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8041bb:	89 f3                	mov    %esi,%ebx
  8041bd:	89 fa                	mov    %edi,%edx
  8041bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041c3:	89 34 24             	mov    %esi,(%esp)
  8041c6:	85 c0                	test   %eax,%eax
  8041c8:	75 1a                	jne    8041e4 <__umoddi3+0x48>
  8041ca:	39 f7                	cmp    %esi,%edi
  8041cc:	0f 86 a2 00 00 00    	jbe    804274 <__umoddi3+0xd8>
  8041d2:	89 c8                	mov    %ecx,%eax
  8041d4:	89 f2                	mov    %esi,%edx
  8041d6:	f7 f7                	div    %edi
  8041d8:	89 d0                	mov    %edx,%eax
  8041da:	31 d2                	xor    %edx,%edx
  8041dc:	83 c4 1c             	add    $0x1c,%esp
  8041df:	5b                   	pop    %ebx
  8041e0:	5e                   	pop    %esi
  8041e1:	5f                   	pop    %edi
  8041e2:	5d                   	pop    %ebp
  8041e3:	c3                   	ret    
  8041e4:	39 f0                	cmp    %esi,%eax
  8041e6:	0f 87 ac 00 00 00    	ja     804298 <__umoddi3+0xfc>
  8041ec:	0f bd e8             	bsr    %eax,%ebp
  8041ef:	83 f5 1f             	xor    $0x1f,%ebp
  8041f2:	0f 84 ac 00 00 00    	je     8042a4 <__umoddi3+0x108>
  8041f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8041fd:	29 ef                	sub    %ebp,%edi
  8041ff:	89 fe                	mov    %edi,%esi
  804201:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804205:	89 e9                	mov    %ebp,%ecx
  804207:	d3 e0                	shl    %cl,%eax
  804209:	89 d7                	mov    %edx,%edi
  80420b:	89 f1                	mov    %esi,%ecx
  80420d:	d3 ef                	shr    %cl,%edi
  80420f:	09 c7                	or     %eax,%edi
  804211:	89 e9                	mov    %ebp,%ecx
  804213:	d3 e2                	shl    %cl,%edx
  804215:	89 14 24             	mov    %edx,(%esp)
  804218:	89 d8                	mov    %ebx,%eax
  80421a:	d3 e0                	shl    %cl,%eax
  80421c:	89 c2                	mov    %eax,%edx
  80421e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804222:	d3 e0                	shl    %cl,%eax
  804224:	89 44 24 04          	mov    %eax,0x4(%esp)
  804228:	8b 44 24 08          	mov    0x8(%esp),%eax
  80422c:	89 f1                	mov    %esi,%ecx
  80422e:	d3 e8                	shr    %cl,%eax
  804230:	09 d0                	or     %edx,%eax
  804232:	d3 eb                	shr    %cl,%ebx
  804234:	89 da                	mov    %ebx,%edx
  804236:	f7 f7                	div    %edi
  804238:	89 d3                	mov    %edx,%ebx
  80423a:	f7 24 24             	mull   (%esp)
  80423d:	89 c6                	mov    %eax,%esi
  80423f:	89 d1                	mov    %edx,%ecx
  804241:	39 d3                	cmp    %edx,%ebx
  804243:	0f 82 87 00 00 00    	jb     8042d0 <__umoddi3+0x134>
  804249:	0f 84 91 00 00 00    	je     8042e0 <__umoddi3+0x144>
  80424f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804253:	29 f2                	sub    %esi,%edx
  804255:	19 cb                	sbb    %ecx,%ebx
  804257:	89 d8                	mov    %ebx,%eax
  804259:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80425d:	d3 e0                	shl    %cl,%eax
  80425f:	89 e9                	mov    %ebp,%ecx
  804261:	d3 ea                	shr    %cl,%edx
  804263:	09 d0                	or     %edx,%eax
  804265:	89 e9                	mov    %ebp,%ecx
  804267:	d3 eb                	shr    %cl,%ebx
  804269:	89 da                	mov    %ebx,%edx
  80426b:	83 c4 1c             	add    $0x1c,%esp
  80426e:	5b                   	pop    %ebx
  80426f:	5e                   	pop    %esi
  804270:	5f                   	pop    %edi
  804271:	5d                   	pop    %ebp
  804272:	c3                   	ret    
  804273:	90                   	nop
  804274:	89 fd                	mov    %edi,%ebp
  804276:	85 ff                	test   %edi,%edi
  804278:	75 0b                	jne    804285 <__umoddi3+0xe9>
  80427a:	b8 01 00 00 00       	mov    $0x1,%eax
  80427f:	31 d2                	xor    %edx,%edx
  804281:	f7 f7                	div    %edi
  804283:	89 c5                	mov    %eax,%ebp
  804285:	89 f0                	mov    %esi,%eax
  804287:	31 d2                	xor    %edx,%edx
  804289:	f7 f5                	div    %ebp
  80428b:	89 c8                	mov    %ecx,%eax
  80428d:	f7 f5                	div    %ebp
  80428f:	89 d0                	mov    %edx,%eax
  804291:	e9 44 ff ff ff       	jmp    8041da <__umoddi3+0x3e>
  804296:	66 90                	xchg   %ax,%ax
  804298:	89 c8                	mov    %ecx,%eax
  80429a:	89 f2                	mov    %esi,%edx
  80429c:	83 c4 1c             	add    $0x1c,%esp
  80429f:	5b                   	pop    %ebx
  8042a0:	5e                   	pop    %esi
  8042a1:	5f                   	pop    %edi
  8042a2:	5d                   	pop    %ebp
  8042a3:	c3                   	ret    
  8042a4:	3b 04 24             	cmp    (%esp),%eax
  8042a7:	72 06                	jb     8042af <__umoddi3+0x113>
  8042a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042ad:	77 0f                	ja     8042be <__umoddi3+0x122>
  8042af:	89 f2                	mov    %esi,%edx
  8042b1:	29 f9                	sub    %edi,%ecx
  8042b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8042b7:	89 14 24             	mov    %edx,(%esp)
  8042ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8042c2:	8b 14 24             	mov    (%esp),%edx
  8042c5:	83 c4 1c             	add    $0x1c,%esp
  8042c8:	5b                   	pop    %ebx
  8042c9:	5e                   	pop    %esi
  8042ca:	5f                   	pop    %edi
  8042cb:	5d                   	pop    %ebp
  8042cc:	c3                   	ret    
  8042cd:	8d 76 00             	lea    0x0(%esi),%esi
  8042d0:	2b 04 24             	sub    (%esp),%eax
  8042d3:	19 fa                	sbb    %edi,%edx
  8042d5:	89 d1                	mov    %edx,%ecx
  8042d7:	89 c6                	mov    %eax,%esi
  8042d9:	e9 71 ff ff ff       	jmp    80424f <__umoddi3+0xb3>
  8042de:	66 90                	xchg   %ax,%ax
  8042e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042e4:	72 ea                	jb     8042d0 <__umoddi3+0x134>
  8042e6:	89 d9                	mov    %ebx,%ecx
  8042e8:	e9 62 ff ff ff       	jmp    80424f <__umoddi3+0xb3>
