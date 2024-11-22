
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
  800042:	e8 70 21 00 00       	call   8021b7 <sys_getenvid>
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
  800062:	e8 42 3f 00 00       	call   803fa9 <create_semaphore>
  800067:	83 c4 0c             	add    $0xc,%esp
  80006a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800070:	a3 44 50 80 00       	mov    %eax,0x805044
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800075:	e8 8d 1f 00 00       	call   802007 <sys_calculate_free_frames>
  80007a:	89 c3                	mov    %eax,%ebx
  80007c:	e8 9f 1f 00 00       	call   802020 <sys_calculate_modified_frames>
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
  800092:	e8 46 3f 00 00       	call   803fdd <wait_semaphore>
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
  80016f:	e8 83 3e 00 00       	call   803ff7 <signal_semaphore>
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
  80021c:	e8 bc 3d 00 00       	call   803fdd <wait_semaphore>
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
  80025d:	e8 95 3d 00 00       	call   803ff7 <signal_semaphore>
  800262:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		wait_semaphore(IO_CS);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 35 44 50 80 00    	pushl  0x805044
  80026e:	e8 6a 3d 00 00       	call   803fdd <wait_semaphore>
  800273:	83 c4 10             	add    $0x10,%esp
			cprintf("Freeing the Heap...\n\n") ;
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 de 43 80 00       	push   $0x8043de
  80027e:	e8 ea 07 00 00       	call   800a6d <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
		signal_semaphore(IO_CS);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 35 44 50 80 00    	pushl  0x805044
  80028f:	e8 63 3d 00 00       	call   803ff7 <signal_semaphore>
  800294:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		wait_semaphore(IO_CS);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 35 44 50 80 00    	pushl  0x805044
  8002a0:	e8 38 3d 00 00       	call   803fdd <wait_semaphore>
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
  8002f3:	e8 ff 3c 00 00       	call   803ff7 <signal_semaphore>
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
  80058b:	e8 27 1c 00 00       	call   8021b7 <sys_getenvid>
  800590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	wait_semaphore(IO_CS);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 35 44 50 80 00    	pushl  0x805044
  80059c:	e8 3c 3a 00 00       	call   803fdd <wait_semaphore>
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
  80062a:	e8 c8 39 00 00       	call   803ff7 <signal_semaphore>
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
  800649:	e8 51 1a 00 00       	call   80209f <sys_cputc>
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
  80065a:	e8 dc 18 00 00       	call   801f3b <sys_cgetc>
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
  800677:	e8 54 1b 00 00       	call   8021d0 <sys_getenvindex>
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
  8006e5:	e8 6a 18 00 00       	call   801f54 <sys_lock_cons>
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
  80077f:	e8 ea 17 00 00       	call   801f6e <sys_unlock_cons>
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
  800797:	e8 00 1a 00 00       	call   80219c <sys_destroy_env>
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
  8007a8:	e8 55 1a 00 00       	call   802202 <sys_exit_env>
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
  8009df:	e8 2e 15 00 00       	call   801f12 <sys_cputs>
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
  800a56:	e8 b7 14 00 00       	call   801f12 <sys_cputs>
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
  800aa0:	e8 af 14 00 00       	call   801f54 <sys_lock_cons>
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
  800ac0:	e8 a9 14 00 00       	call   801f6e <sys_unlock_cons>
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
  800b0a:	e8 0d 35 00 00       	call   80401c <__udivdi3>
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
  800b5a:	e8 cd 35 00 00       	call   80412c <__umoddi3>
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
  801206:	e8 49 0d 00 00       	call   801f54 <sys_lock_cons>
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
  801301:	e8 68 0c 00 00       	call   801f6e <sys_unlock_cons>
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
  801a1b:	e8 9d 0a 00 00       	call   8024bd <sys_sbrk>
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
  801a96:	e8 a6 08 00 00       	call   802341 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	74 16                	je     801ab5 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a9f:	83 ec 0c             	sub    $0xc,%esp
  801aa2:	ff 75 08             	pushl  0x8(%ebp)
  801aa5:	e8 e6 0d 00 00       	call   802890 <alloc_block_FF>
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ab0:	e9 8a 01 00 00       	jmp    801c3f <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801ab5:	e8 b8 08 00 00       	call   802372 <sys_isUHeapPlacementStrategyBESTFIT>
  801aba:	85 c0                	test   %eax,%eax
  801abc:	0f 84 7d 01 00 00    	je     801c3f <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801ac2:	83 ec 0c             	sub    $0xc,%esp
  801ac5:	ff 75 08             	pushl  0x8(%ebp)
  801ac8:	e8 7f 12 00 00       	call   802d4c <alloc_block_BF>
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
  801c2e:	e8 c1 08 00 00       	call   8024f4 <sys_allocate_user_mem>
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
  801c76:	e8 95 08 00 00       	call   802510 <get_block_size>
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c81:	83 ec 0c             	sub    $0xc,%esp
  801c84:	ff 75 08             	pushl  0x8(%ebp)
  801c87:	e8 c8 1a 00 00       	call   803754 <free_block>
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
  801d1e:	e8 b5 07 00 00       	call   8024d8 <sys_free_user_mem>
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
  801d59:	eb 74                	jmp    801dcf <smalloc+0x8d>
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
  801d8e:	eb 3f                	jmp    801dcf <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d90:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d94:	ff 75 ec             	pushl  -0x14(%ebp)
  801d97:	50                   	push   %eax
  801d98:	ff 75 0c             	pushl  0xc(%ebp)
  801d9b:	ff 75 08             	pushl  0x8(%ebp)
  801d9e:	e8 3c 03 00 00       	call   8020df <sys_createSharedObject>
  801da3:	83 c4 10             	add    $0x10,%esp
  801da6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801da9:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801dad:	74 06                	je     801db5 <smalloc+0x73>
  801daf:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801db3:	75 07                	jne    801dbc <smalloc+0x7a>
  801db5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dba:	eb 13                	jmp    801dcf <smalloc+0x8d>
	 cprintf("153\n");
  801dbc:	83 ec 0c             	sub    $0xc,%esp
  801dbf:	68 42 4a 80 00       	push   $0x804a42
  801dc4:	e8 a4 ec ff ff       	call   800a6d <cprintf>
  801dc9:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801dd7:	83 ec 08             	sub    $0x8,%esp
  801dda:	ff 75 0c             	pushl  0xc(%ebp)
  801ddd:	ff 75 08             	pushl  0x8(%ebp)
  801de0:	e8 24 03 00 00       	call   802109 <sys_getSizeOfSharedObject>
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801deb:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801def:	75 07                	jne    801df8 <sget+0x27>
  801df1:	b8 00 00 00 00       	mov    $0x0,%eax
  801df6:	eb 5c                	jmp    801e54 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801dfe:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0b:	39 d0                	cmp    %edx,%eax
  801e0d:	7d 02                	jge    801e11 <sget+0x40>
  801e0f:	89 d0                	mov    %edx,%eax
  801e11:	83 ec 0c             	sub    $0xc,%esp
  801e14:	50                   	push   %eax
  801e15:	e8 0b fc ff ff       	call   801a25 <malloc>
  801e1a:	83 c4 10             	add    $0x10,%esp
  801e1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801e20:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e24:	75 07                	jne    801e2d <sget+0x5c>
  801e26:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2b:	eb 27                	jmp    801e54 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801e2d:	83 ec 04             	sub    $0x4,%esp
  801e30:	ff 75 e8             	pushl  -0x18(%ebp)
  801e33:	ff 75 0c             	pushl  0xc(%ebp)
  801e36:	ff 75 08             	pushl  0x8(%ebp)
  801e39:	e8 e8 02 00 00       	call   802126 <sys_getSharedObject>
  801e3e:	83 c4 10             	add    $0x10,%esp
  801e41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801e44:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801e48:	75 07                	jne    801e51 <sget+0x80>
  801e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4f:	eb 03                	jmp    801e54 <sget+0x83>
	return ptr;
  801e51:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e5c:	83 ec 04             	sub    $0x4,%esp
  801e5f:	68 48 4a 80 00       	push   $0x804a48
  801e64:	68 c2 00 00 00       	push   $0xc2
  801e69:	68 36 4a 80 00       	push   $0x804a36
  801e6e:	e8 3d e9 ff ff       	call   8007b0 <_panic>

00801e73 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e79:	83 ec 04             	sub    $0x4,%esp
  801e7c:	68 6c 4a 80 00       	push   $0x804a6c
  801e81:	68 d9 00 00 00       	push   $0xd9
  801e86:	68 36 4a 80 00       	push   $0x804a36
  801e8b:	e8 20 e9 ff ff       	call   8007b0 <_panic>

00801e90 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e96:	83 ec 04             	sub    $0x4,%esp
  801e99:	68 92 4a 80 00       	push   $0x804a92
  801e9e:	68 e5 00 00 00       	push   $0xe5
  801ea3:	68 36 4a 80 00       	push   $0x804a36
  801ea8:	e8 03 e9 ff ff       	call   8007b0 <_panic>

00801ead <shrink>:

}
void shrink(uint32 newSize)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eb3:	83 ec 04             	sub    $0x4,%esp
  801eb6:	68 92 4a 80 00       	push   $0x804a92
  801ebb:	68 ea 00 00 00       	push   $0xea
  801ec0:	68 36 4a 80 00       	push   $0x804a36
  801ec5:	e8 e6 e8 ff ff       	call   8007b0 <_panic>

00801eca <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ed0:	83 ec 04             	sub    $0x4,%esp
  801ed3:	68 92 4a 80 00       	push   $0x804a92
  801ed8:	68 ef 00 00 00       	push   $0xef
  801edd:	68 36 4a 80 00       	push   $0x804a36
  801ee2:	e8 c9 e8 ff ff       	call   8007b0 <_panic>

00801ee7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	57                   	push   %edi
  801eeb:	56                   	push   %esi
  801eec:	53                   	push   %ebx
  801eed:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801efc:	8b 7d 18             	mov    0x18(%ebp),%edi
  801eff:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f02:	cd 30                	int    $0x30
  801f04:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f0a:	83 c4 10             	add    $0x10,%esp
  801f0d:	5b                   	pop    %ebx
  801f0e:	5e                   	pop    %esi
  801f0f:	5f                   	pop    %edi
  801f10:	5d                   	pop    %ebp
  801f11:	c3                   	ret    

00801f12 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 04             	sub    $0x4,%esp
  801f18:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f1e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	52                   	push   %edx
  801f2a:	ff 75 0c             	pushl  0xc(%ebp)
  801f2d:	50                   	push   %eax
  801f2e:	6a 00                	push   $0x0
  801f30:	e8 b2 ff ff ff       	call   801ee7 <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
}
  801f38:	90                   	nop
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <sys_cgetc>:

int
sys_cgetc(void)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 02                	push   $0x2
  801f4a:	e8 98 ff ff ff       	call   801ee7 <syscall>
  801f4f:	83 c4 18             	add    $0x18,%esp
}
  801f52:	c9                   	leave  
  801f53:	c3                   	ret    

00801f54 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 03                	push   $0x3
  801f63:	e8 7f ff ff ff       	call   801ee7 <syscall>
  801f68:	83 c4 18             	add    $0x18,%esp
}
  801f6b:	90                   	nop
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 04                	push   $0x4
  801f7d:	e8 65 ff ff ff       	call   801ee7 <syscall>
  801f82:	83 c4 18             	add    $0x18,%esp
}
  801f85:	90                   	nop
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	52                   	push   %edx
  801f98:	50                   	push   %eax
  801f99:	6a 08                	push   $0x8
  801f9b:	e8 47 ff ff ff       	call   801ee7 <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	56                   	push   %esi
  801fa9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801faa:	8b 75 18             	mov    0x18(%ebp),%esi
  801fad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	56                   	push   %esi
  801fba:	53                   	push   %ebx
  801fbb:	51                   	push   %ecx
  801fbc:	52                   	push   %edx
  801fbd:	50                   	push   %eax
  801fbe:	6a 09                	push   $0x9
  801fc0:	e8 22 ff ff ff       	call   801ee7 <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
}
  801fc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fcb:	5b                   	pop    %ebx
  801fcc:	5e                   	pop    %esi
  801fcd:	5d                   	pop    %ebp
  801fce:	c3                   	ret    

00801fcf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	52                   	push   %edx
  801fdf:	50                   	push   %eax
  801fe0:	6a 0a                	push   $0xa
  801fe2:	e8 00 ff ff ff       	call   801ee7 <syscall>
  801fe7:	83 c4 18             	add    $0x18,%esp
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	ff 75 0c             	pushl  0xc(%ebp)
  801ff8:	ff 75 08             	pushl  0x8(%ebp)
  801ffb:	6a 0b                	push   $0xb
  801ffd:	e8 e5 fe ff ff       	call   801ee7 <syscall>
  802002:	83 c4 18             	add    $0x18,%esp
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 0c                	push   $0xc
  802016:	e8 cc fe ff ff       	call   801ee7 <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 0d                	push   $0xd
  80202f:	e8 b3 fe ff ff       	call   801ee7 <syscall>
  802034:	83 c4 18             	add    $0x18,%esp
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 0e                	push   $0xe
  802048:	e8 9a fe ff ff       	call   801ee7 <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
}
  802050:	c9                   	leave  
  802051:	c3                   	ret    

00802052 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 0f                	push   $0xf
  802061:	e8 81 fe ff ff       	call   801ee7 <syscall>
  802066:	83 c4 18             	add    $0x18,%esp
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	ff 75 08             	pushl  0x8(%ebp)
  802079:	6a 10                	push   $0x10
  80207b:	e8 67 fe ff ff       	call   801ee7 <syscall>
  802080:	83 c4 18             	add    $0x18,%esp
}
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 11                	push   $0x11
  802094:	e8 4e fe ff ff       	call   801ee7 <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
}
  80209c:	90                   	nop
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <sys_cputc>:

void
sys_cputc(const char c)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	83 ec 04             	sub    $0x4,%esp
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020ab:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	50                   	push   %eax
  8020b8:	6a 01                	push   $0x1
  8020ba:	e8 28 fe ff ff       	call   801ee7 <syscall>
  8020bf:	83 c4 18             	add    $0x18,%esp
}
  8020c2:	90                   	nop
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 14                	push   $0x14
  8020d4:	e8 0e fe ff ff       	call   801ee7 <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
}
  8020dc:	90                   	nop
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	83 ec 04             	sub    $0x4,%esp
  8020e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020eb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020ee:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	6a 00                	push   $0x0
  8020f7:	51                   	push   %ecx
  8020f8:	52                   	push   %edx
  8020f9:	ff 75 0c             	pushl  0xc(%ebp)
  8020fc:	50                   	push   %eax
  8020fd:	6a 15                	push   $0x15
  8020ff:	e8 e3 fd ff ff       	call   801ee7 <syscall>
  802104:	83 c4 18             	add    $0x18,%esp
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80210c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	52                   	push   %edx
  802119:	50                   	push   %eax
  80211a:	6a 16                	push   $0x16
  80211c:	e8 c6 fd ff ff       	call   801ee7 <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802129:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80212c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	51                   	push   %ecx
  802137:	52                   	push   %edx
  802138:	50                   	push   %eax
  802139:	6a 17                	push   $0x17
  80213b:	e8 a7 fd ff ff       	call   801ee7 <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802148:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	52                   	push   %edx
  802155:	50                   	push   %eax
  802156:	6a 18                	push   $0x18
  802158:	e8 8a fd ff ff       	call   801ee7 <syscall>
  80215d:	83 c4 18             	add    $0x18,%esp
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	6a 00                	push   $0x0
  80216a:	ff 75 14             	pushl  0x14(%ebp)
  80216d:	ff 75 10             	pushl  0x10(%ebp)
  802170:	ff 75 0c             	pushl  0xc(%ebp)
  802173:	50                   	push   %eax
  802174:	6a 19                	push   $0x19
  802176:	e8 6c fd ff ff       	call   801ee7 <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	50                   	push   %eax
  80218f:	6a 1a                	push   $0x1a
  802191:	e8 51 fd ff ff       	call   801ee7 <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
}
  802199:	90                   	nop
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	50                   	push   %eax
  8021ab:	6a 1b                	push   $0x1b
  8021ad:	e8 35 fd ff ff       	call   801ee7 <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 05                	push   $0x5
  8021c6:	e8 1c fd ff ff       	call   801ee7 <syscall>
  8021cb:	83 c4 18             	add    $0x18,%esp
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 06                	push   $0x6
  8021df:	e8 03 fd ff ff       	call   801ee7 <syscall>
  8021e4:	83 c4 18             	add    $0x18,%esp
}
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 07                	push   $0x7
  8021f8:	e8 ea fc ff ff       	call   801ee7 <syscall>
  8021fd:	83 c4 18             	add    $0x18,%esp
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <sys_exit_env>:


void sys_exit_env(void)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 1c                	push   $0x1c
  802211:	e8 d1 fc ff ff       	call   801ee7 <syscall>
  802216:	83 c4 18             	add    $0x18,%esp
}
  802219:	90                   	nop
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802222:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802225:	8d 50 04             	lea    0x4(%eax),%edx
  802228:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	52                   	push   %edx
  802232:	50                   	push   %eax
  802233:	6a 1d                	push   $0x1d
  802235:	e8 ad fc ff ff       	call   801ee7 <syscall>
  80223a:	83 c4 18             	add    $0x18,%esp
	return result;
  80223d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802240:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802243:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802246:	89 01                	mov    %eax,(%ecx)
  802248:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	c9                   	leave  
  80224f:	c2 04 00             	ret    $0x4

00802252 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	ff 75 10             	pushl  0x10(%ebp)
  80225c:	ff 75 0c             	pushl  0xc(%ebp)
  80225f:	ff 75 08             	pushl  0x8(%ebp)
  802262:	6a 13                	push   $0x13
  802264:	e8 7e fc ff ff       	call   801ee7 <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
	return ;
  80226c:	90                   	nop
}
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <sys_rcr2>:
uint32 sys_rcr2()
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 1e                	push   $0x1e
  80227e:	e8 64 fc ff ff       	call   801ee7 <syscall>
  802283:	83 c4 18             	add    $0x18,%esp
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 04             	sub    $0x4,%esp
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802294:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	50                   	push   %eax
  8022a1:	6a 1f                	push   $0x1f
  8022a3:	e8 3f fc ff ff       	call   801ee7 <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ab:	90                   	nop
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <rsttst>:
void rsttst()
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 21                	push   $0x21
  8022bd:	e8 25 fc ff ff       	call   801ee7 <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c5:	90                   	nop
}
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	83 ec 04             	sub    $0x4,%esp
  8022ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022d4:	8b 55 18             	mov    0x18(%ebp),%edx
  8022d7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022db:	52                   	push   %edx
  8022dc:	50                   	push   %eax
  8022dd:	ff 75 10             	pushl  0x10(%ebp)
  8022e0:	ff 75 0c             	pushl  0xc(%ebp)
  8022e3:	ff 75 08             	pushl  0x8(%ebp)
  8022e6:	6a 20                	push   $0x20
  8022e8:	e8 fa fb ff ff       	call   801ee7 <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f0:	90                   	nop
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <chktst>:
void chktst(uint32 n)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	ff 75 08             	pushl  0x8(%ebp)
  802301:	6a 22                	push   $0x22
  802303:	e8 df fb ff ff       	call   801ee7 <syscall>
  802308:	83 c4 18             	add    $0x18,%esp
	return ;
  80230b:	90                   	nop
}
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <inctst>:

void inctst()
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 23                	push   $0x23
  80231d:	e8 c5 fb ff ff       	call   801ee7 <syscall>
  802322:	83 c4 18             	add    $0x18,%esp
	return ;
  802325:	90                   	nop
}
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <gettst>:
uint32 gettst()
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 24                	push   $0x24
  802337:	e8 ab fb ff ff       	call   801ee7 <syscall>
  80233c:	83 c4 18             	add    $0x18,%esp
}
  80233f:	c9                   	leave  
  802340:	c3                   	ret    

00802341 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
  802344:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 25                	push   $0x25
  802353:	e8 8f fb ff ff       	call   801ee7 <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
  80235b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80235e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802362:	75 07                	jne    80236b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802364:	b8 01 00 00 00       	mov    $0x1,%eax
  802369:	eb 05                	jmp    802370 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80236b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
  802375:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 25                	push   $0x25
  802384:	e8 5e fb ff ff       	call   801ee7 <syscall>
  802389:	83 c4 18             	add    $0x18,%esp
  80238c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80238f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802393:	75 07                	jne    80239c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802395:	b8 01 00 00 00       	mov    $0x1,%eax
  80239a:	eb 05                	jmp    8023a1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80239c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a1:	c9                   	leave  
  8023a2:	c3                   	ret    

008023a3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 25                	push   $0x25
  8023b5:	e8 2d fb ff ff       	call   801ee7 <syscall>
  8023ba:	83 c4 18             	add    $0x18,%esp
  8023bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023c0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023c4:	75 07                	jne    8023cd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023cb:	eb 05                	jmp    8023d2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d2:	c9                   	leave  
  8023d3:	c3                   	ret    

008023d4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8023d4:	55                   	push   %ebp
  8023d5:	89 e5                	mov    %esp,%ebp
  8023d7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 25                	push   $0x25
  8023e6:	e8 fc fa ff ff       	call   801ee7 <syscall>
  8023eb:	83 c4 18             	add    $0x18,%esp
  8023ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023f1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023f5:	75 07                	jne    8023fe <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8023fc:	eb 05                	jmp    802403 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	ff 75 08             	pushl  0x8(%ebp)
  802413:	6a 26                	push   $0x26
  802415:	e8 cd fa ff ff       	call   801ee7 <syscall>
  80241a:	83 c4 18             	add    $0x18,%esp
	return ;
  80241d:	90                   	nop
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802424:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802427:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80242a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	6a 00                	push   $0x0
  802432:	53                   	push   %ebx
  802433:	51                   	push   %ecx
  802434:	52                   	push   %edx
  802435:	50                   	push   %eax
  802436:	6a 27                	push   $0x27
  802438:	e8 aa fa ff ff       	call   801ee7 <syscall>
  80243d:	83 c4 18             	add    $0x18,%esp
}
  802440:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802448:	8b 55 0c             	mov    0xc(%ebp),%edx
  80244b:	8b 45 08             	mov    0x8(%ebp),%eax
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	52                   	push   %edx
  802455:	50                   	push   %eax
  802456:	6a 28                	push   $0x28
  802458:	e8 8a fa ff ff       	call   801ee7 <syscall>
  80245d:	83 c4 18             	add    $0x18,%esp
}
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802465:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802468:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	6a 00                	push   $0x0
  802470:	51                   	push   %ecx
  802471:	ff 75 10             	pushl  0x10(%ebp)
  802474:	52                   	push   %edx
  802475:	50                   	push   %eax
  802476:	6a 29                	push   $0x29
  802478:	e8 6a fa ff ff       	call   801ee7 <syscall>
  80247d:	83 c4 18             	add    $0x18,%esp
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	ff 75 10             	pushl  0x10(%ebp)
  80248c:	ff 75 0c             	pushl  0xc(%ebp)
  80248f:	ff 75 08             	pushl  0x8(%ebp)
  802492:	6a 12                	push   $0x12
  802494:	e8 4e fa ff ff       	call   801ee7 <syscall>
  802499:	83 c4 18             	add    $0x18,%esp
	return ;
  80249c:	90                   	nop
}
  80249d:	c9                   	leave  
  80249e:	c3                   	ret    

0080249f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8024a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	52                   	push   %edx
  8024af:	50                   	push   %eax
  8024b0:	6a 2a                	push   $0x2a
  8024b2:	e8 30 fa ff ff       	call   801ee7 <syscall>
  8024b7:	83 c4 18             	add    $0x18,%esp
	return;
  8024ba:	90                   	nop
}
  8024bb:	c9                   	leave  
  8024bc:	c3                   	ret    

008024bd <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8024bd:	55                   	push   %ebp
  8024be:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	50                   	push   %eax
  8024cc:	6a 2b                	push   $0x2b
  8024ce:	e8 14 fa ff ff       	call   801ee7 <syscall>
  8024d3:	83 c4 18             	add    $0x18,%esp
}
  8024d6:	c9                   	leave  
  8024d7:	c3                   	ret    

008024d8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	ff 75 0c             	pushl  0xc(%ebp)
  8024e4:	ff 75 08             	pushl  0x8(%ebp)
  8024e7:	6a 2c                	push   $0x2c
  8024e9:	e8 f9 f9 ff ff       	call   801ee7 <syscall>
  8024ee:	83 c4 18             	add    $0x18,%esp
	return;
  8024f1:	90                   	nop
}
  8024f2:	c9                   	leave  
  8024f3:	c3                   	ret    

008024f4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	ff 75 0c             	pushl  0xc(%ebp)
  802500:	ff 75 08             	pushl  0x8(%ebp)
  802503:	6a 2d                	push   $0x2d
  802505:	e8 dd f9 ff ff       	call   801ee7 <syscall>
  80250a:	83 c4 18             	add    $0x18,%esp
	return;
  80250d:	90                   	nop
}
  80250e:	c9                   	leave  
  80250f:	c3                   	ret    

00802510 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802516:	8b 45 08             	mov    0x8(%ebp),%eax
  802519:	83 e8 04             	sub    $0x4,%eax
  80251c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80251f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802522:	8b 00                	mov    (%eax),%eax
  802524:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80252f:	8b 45 08             	mov    0x8(%ebp),%eax
  802532:	83 e8 04             	sub    $0x4,%eax
  802535:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802538:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80253b:	8b 00                	mov    (%eax),%eax
  80253d:	83 e0 01             	and    $0x1,%eax
  802540:	85 c0                	test   %eax,%eax
  802542:	0f 94 c0             	sete   %al
}
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
  80254a:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80254d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802554:	8b 45 0c             	mov    0xc(%ebp),%eax
  802557:	83 f8 02             	cmp    $0x2,%eax
  80255a:	74 2b                	je     802587 <alloc_block+0x40>
  80255c:	83 f8 02             	cmp    $0x2,%eax
  80255f:	7f 07                	jg     802568 <alloc_block+0x21>
  802561:	83 f8 01             	cmp    $0x1,%eax
  802564:	74 0e                	je     802574 <alloc_block+0x2d>
  802566:	eb 58                	jmp    8025c0 <alloc_block+0x79>
  802568:	83 f8 03             	cmp    $0x3,%eax
  80256b:	74 2d                	je     80259a <alloc_block+0x53>
  80256d:	83 f8 04             	cmp    $0x4,%eax
  802570:	74 3b                	je     8025ad <alloc_block+0x66>
  802572:	eb 4c                	jmp    8025c0 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802574:	83 ec 0c             	sub    $0xc,%esp
  802577:	ff 75 08             	pushl  0x8(%ebp)
  80257a:	e8 11 03 00 00       	call   802890 <alloc_block_FF>
  80257f:	83 c4 10             	add    $0x10,%esp
  802582:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802585:	eb 4a                	jmp    8025d1 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802587:	83 ec 0c             	sub    $0xc,%esp
  80258a:	ff 75 08             	pushl  0x8(%ebp)
  80258d:	e8 fa 19 00 00       	call   803f8c <alloc_block_NF>
  802592:	83 c4 10             	add    $0x10,%esp
  802595:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802598:	eb 37                	jmp    8025d1 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80259a:	83 ec 0c             	sub    $0xc,%esp
  80259d:	ff 75 08             	pushl  0x8(%ebp)
  8025a0:	e8 a7 07 00 00       	call   802d4c <alloc_block_BF>
  8025a5:	83 c4 10             	add    $0x10,%esp
  8025a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025ab:	eb 24                	jmp    8025d1 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8025ad:	83 ec 0c             	sub    $0xc,%esp
  8025b0:	ff 75 08             	pushl  0x8(%ebp)
  8025b3:	e8 b7 19 00 00       	call   803f6f <alloc_block_WF>
  8025b8:	83 c4 10             	add    $0x10,%esp
  8025bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025be:	eb 11                	jmp    8025d1 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8025c0:	83 ec 0c             	sub    $0xc,%esp
  8025c3:	68 a4 4a 80 00       	push   $0x804aa4
  8025c8:	e8 a0 e4 ff ff       	call   800a6d <cprintf>
  8025cd:	83 c4 10             	add    $0x10,%esp
		break;
  8025d0:	90                   	nop
	}
	return va;
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8025d4:	c9                   	leave  
  8025d5:	c3                   	ret    

008025d6 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
  8025d9:	53                   	push   %ebx
  8025da:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8025dd:	83 ec 0c             	sub    $0xc,%esp
  8025e0:	68 c4 4a 80 00       	push   $0x804ac4
  8025e5:	e8 83 e4 ff ff       	call   800a6d <cprintf>
  8025ea:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8025ed:	83 ec 0c             	sub    $0xc,%esp
  8025f0:	68 ef 4a 80 00       	push   $0x804aef
  8025f5:	e8 73 e4 ff ff       	call   800a6d <cprintf>
  8025fa:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8025fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802600:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802603:	eb 37                	jmp    80263c <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802605:	83 ec 0c             	sub    $0xc,%esp
  802608:	ff 75 f4             	pushl  -0xc(%ebp)
  80260b:	e8 19 ff ff ff       	call   802529 <is_free_block>
  802610:	83 c4 10             	add    $0x10,%esp
  802613:	0f be d8             	movsbl %al,%ebx
  802616:	83 ec 0c             	sub    $0xc,%esp
  802619:	ff 75 f4             	pushl  -0xc(%ebp)
  80261c:	e8 ef fe ff ff       	call   802510 <get_block_size>
  802621:	83 c4 10             	add    $0x10,%esp
  802624:	83 ec 04             	sub    $0x4,%esp
  802627:	53                   	push   %ebx
  802628:	50                   	push   %eax
  802629:	68 07 4b 80 00       	push   $0x804b07
  80262e:	e8 3a e4 ff ff       	call   800a6d <cprintf>
  802633:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802636:	8b 45 10             	mov    0x10(%ebp),%eax
  802639:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802640:	74 07                	je     802649 <print_blocks_list+0x73>
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 00                	mov    (%eax),%eax
  802647:	eb 05                	jmp    80264e <print_blocks_list+0x78>
  802649:	b8 00 00 00 00       	mov    $0x0,%eax
  80264e:	89 45 10             	mov    %eax,0x10(%ebp)
  802651:	8b 45 10             	mov    0x10(%ebp),%eax
  802654:	85 c0                	test   %eax,%eax
  802656:	75 ad                	jne    802605 <print_blocks_list+0x2f>
  802658:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265c:	75 a7                	jne    802605 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80265e:	83 ec 0c             	sub    $0xc,%esp
  802661:	68 c4 4a 80 00       	push   $0x804ac4
  802666:	e8 02 e4 ff ff       	call   800a6d <cprintf>
  80266b:	83 c4 10             	add    $0x10,%esp

}
  80266e:	90                   	nop
  80266f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802672:	c9                   	leave  
  802673:	c3                   	ret    

00802674 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
  802677:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80267a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80267d:	83 e0 01             	and    $0x1,%eax
  802680:	85 c0                	test   %eax,%eax
  802682:	74 03                	je     802687 <initialize_dynamic_allocator+0x13>
  802684:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802687:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80268b:	0f 84 c7 01 00 00    	je     802858 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802691:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802698:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80269b:	8b 55 08             	mov    0x8(%ebp),%edx
  80269e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a1:	01 d0                	add    %edx,%eax
  8026a3:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8026a8:	0f 87 ad 01 00 00    	ja     80285b <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8026ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	0f 89 a5 01 00 00    	jns    80285e <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8026b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026bf:	01 d0                	add    %edx,%eax
  8026c1:	83 e8 04             	sub    $0x4,%eax
  8026c4:	a3 4c 50 80 00       	mov    %eax,0x80504c
     struct BlockElement * element = NULL;
  8026c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8026d0:	a1 30 50 80 00       	mov    0x805030,%eax
  8026d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d8:	e9 87 00 00 00       	jmp    802764 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8026dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e1:	75 14                	jne    8026f7 <initialize_dynamic_allocator+0x83>
  8026e3:	83 ec 04             	sub    $0x4,%esp
  8026e6:	68 1f 4b 80 00       	push   $0x804b1f
  8026eb:	6a 79                	push   $0x79
  8026ed:	68 3d 4b 80 00       	push   $0x804b3d
  8026f2:	e8 b9 e0 ff ff       	call   8007b0 <_panic>
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 00                	mov    (%eax),%eax
  8026fc:	85 c0                	test   %eax,%eax
  8026fe:	74 10                	je     802710 <initialize_dynamic_allocator+0x9c>
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 00                	mov    (%eax),%eax
  802705:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802708:	8b 52 04             	mov    0x4(%edx),%edx
  80270b:	89 50 04             	mov    %edx,0x4(%eax)
  80270e:	eb 0b                	jmp    80271b <initialize_dynamic_allocator+0xa7>
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 40 04             	mov    0x4(%eax),%eax
  802716:	a3 34 50 80 00       	mov    %eax,0x805034
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 40 04             	mov    0x4(%eax),%eax
  802721:	85 c0                	test   %eax,%eax
  802723:	74 0f                	je     802734 <initialize_dynamic_allocator+0xc0>
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	8b 40 04             	mov    0x4(%eax),%eax
  80272b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272e:	8b 12                	mov    (%edx),%edx
  802730:	89 10                	mov    %edx,(%eax)
  802732:	eb 0a                	jmp    80273e <initialize_dynamic_allocator+0xca>
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 00                	mov    (%eax),%eax
  802739:	a3 30 50 80 00       	mov    %eax,0x805030
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802751:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802756:	48                   	dec    %eax
  802757:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80275c:	a1 38 50 80 00       	mov    0x805038,%eax
  802761:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802764:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802768:	74 07                	je     802771 <initialize_dynamic_allocator+0xfd>
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	8b 00                	mov    (%eax),%eax
  80276f:	eb 05                	jmp    802776 <initialize_dynamic_allocator+0x102>
  802771:	b8 00 00 00 00       	mov    $0x0,%eax
  802776:	a3 38 50 80 00       	mov    %eax,0x805038
  80277b:	a1 38 50 80 00       	mov    0x805038,%eax
  802780:	85 c0                	test   %eax,%eax
  802782:	0f 85 55 ff ff ff    	jne    8026dd <initialize_dynamic_allocator+0x69>
  802788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278c:	0f 85 4b ff ff ff    	jne    8026dd <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802792:	8b 45 08             	mov    0x8(%ebp),%eax
  802795:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8027a1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027a6:	a3 48 50 80 00       	mov    %eax,0x805048
    end_block->info = 1;
  8027ab:	a1 48 50 80 00       	mov    0x805048,%eax
  8027b0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8027b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b9:	83 c0 08             	add    $0x8,%eax
  8027bc:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c2:	83 c0 04             	add    $0x4,%eax
  8027c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c8:	83 ea 08             	sub    $0x8,%edx
  8027cb:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	01 d0                	add    %edx,%eax
  8027d5:	83 e8 08             	sub    $0x8,%eax
  8027d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027db:	83 ea 08             	sub    $0x8,%edx
  8027de:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8027e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8027e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8027f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027f7:	75 17                	jne    802810 <initialize_dynamic_allocator+0x19c>
  8027f9:	83 ec 04             	sub    $0x4,%esp
  8027fc:	68 58 4b 80 00       	push   $0x804b58
  802801:	68 90 00 00 00       	push   $0x90
  802806:	68 3d 4b 80 00       	push   $0x804b3d
  80280b:	e8 a0 df ff ff       	call   8007b0 <_panic>
  802810:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802819:	89 10                	mov    %edx,(%eax)
  80281b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281e:	8b 00                	mov    (%eax),%eax
  802820:	85 c0                	test   %eax,%eax
  802822:	74 0d                	je     802831 <initialize_dynamic_allocator+0x1bd>
  802824:	a1 30 50 80 00       	mov    0x805030,%eax
  802829:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80282c:	89 50 04             	mov    %edx,0x4(%eax)
  80282f:	eb 08                	jmp    802839 <initialize_dynamic_allocator+0x1c5>
  802831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802834:	a3 34 50 80 00       	mov    %eax,0x805034
  802839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283c:	a3 30 50 80 00       	mov    %eax,0x805030
  802841:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802844:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80284b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802850:	40                   	inc    %eax
  802851:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802856:	eb 07                	jmp    80285f <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802858:	90                   	nop
  802859:	eb 04                	jmp    80285f <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80285b:	90                   	nop
  80285c:	eb 01                	jmp    80285f <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80285e:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80285f:	c9                   	leave  
  802860:	c3                   	ret    

00802861 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802861:	55                   	push   %ebp
  802862:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802864:	8b 45 10             	mov    0x10(%ebp),%eax
  802867:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80286a:	8b 45 08             	mov    0x8(%ebp),%eax
  80286d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802870:	8b 45 0c             	mov    0xc(%ebp),%eax
  802873:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	83 e8 04             	sub    $0x4,%eax
  80287b:	8b 00                	mov    (%eax),%eax
  80287d:	83 e0 fe             	and    $0xfffffffe,%eax
  802880:	8d 50 f8             	lea    -0x8(%eax),%edx
  802883:	8b 45 08             	mov    0x8(%ebp),%eax
  802886:	01 c2                	add    %eax,%edx
  802888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80288b:	89 02                	mov    %eax,(%edx)
}
  80288d:	90                   	nop
  80288e:	5d                   	pop    %ebp
  80288f:	c3                   	ret    

00802890 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
  802893:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802896:	8b 45 08             	mov    0x8(%ebp),%eax
  802899:	83 e0 01             	and    $0x1,%eax
  80289c:	85 c0                	test   %eax,%eax
  80289e:	74 03                	je     8028a3 <alloc_block_FF+0x13>
  8028a0:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028a3:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028a7:	77 07                	ja     8028b0 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028a9:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028b0:	a1 28 50 80 00       	mov    0x805028,%eax
  8028b5:	85 c0                	test   %eax,%eax
  8028b7:	75 73                	jne    80292c <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	83 c0 10             	add    $0x10,%eax
  8028bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028c2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8028c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cf:	01 d0                	add    %edx,%eax
  8028d1:	48                   	dec    %eax
  8028d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8028d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8028dd:	f7 75 ec             	divl   -0x14(%ebp)
  8028e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e3:	29 d0                	sub    %edx,%eax
  8028e5:	c1 e8 0c             	shr    $0xc,%eax
  8028e8:	83 ec 0c             	sub    $0xc,%esp
  8028eb:	50                   	push   %eax
  8028ec:	e8 1e f1 ff ff       	call   801a0f <sbrk>
  8028f1:	83 c4 10             	add    $0x10,%esp
  8028f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028f7:	83 ec 0c             	sub    $0xc,%esp
  8028fa:	6a 00                	push   $0x0
  8028fc:	e8 0e f1 ff ff       	call   801a0f <sbrk>
  802901:	83 c4 10             	add    $0x10,%esp
  802904:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802907:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80290d:	83 ec 08             	sub    $0x8,%esp
  802910:	50                   	push   %eax
  802911:	ff 75 e4             	pushl  -0x1c(%ebp)
  802914:	e8 5b fd ff ff       	call   802674 <initialize_dynamic_allocator>
  802919:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80291c:	83 ec 0c             	sub    $0xc,%esp
  80291f:	68 7b 4b 80 00       	push   $0x804b7b
  802924:	e8 44 e1 ff ff       	call   800a6d <cprintf>
  802929:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80292c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802930:	75 0a                	jne    80293c <alloc_block_FF+0xac>
	        return NULL;
  802932:	b8 00 00 00 00       	mov    $0x0,%eax
  802937:	e9 0e 04 00 00       	jmp    802d4a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80293c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802943:	a1 30 50 80 00       	mov    0x805030,%eax
  802948:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80294b:	e9 f3 02 00 00       	jmp    802c43 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802956:	83 ec 0c             	sub    $0xc,%esp
  802959:	ff 75 bc             	pushl  -0x44(%ebp)
  80295c:	e8 af fb ff ff       	call   802510 <get_block_size>
  802961:	83 c4 10             	add    $0x10,%esp
  802964:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	83 c0 08             	add    $0x8,%eax
  80296d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802970:	0f 87 c5 02 00 00    	ja     802c3b <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	83 c0 18             	add    $0x18,%eax
  80297c:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80297f:	0f 87 19 02 00 00    	ja     802b9e <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802985:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802988:	2b 45 08             	sub    0x8(%ebp),%eax
  80298b:	83 e8 08             	sub    $0x8,%eax
  80298e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	8d 50 08             	lea    0x8(%eax),%edx
  802997:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80299a:	01 d0                	add    %edx,%eax
  80299c:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80299f:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a2:	83 c0 08             	add    $0x8,%eax
  8029a5:	83 ec 04             	sub    $0x4,%esp
  8029a8:	6a 01                	push   $0x1
  8029aa:	50                   	push   %eax
  8029ab:	ff 75 bc             	pushl  -0x44(%ebp)
  8029ae:	e8 ae fe ff ff       	call   802861 <set_block_data>
  8029b3:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	8b 40 04             	mov    0x4(%eax),%eax
  8029bc:	85 c0                	test   %eax,%eax
  8029be:	75 68                	jne    802a28 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029c0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029c4:	75 17                	jne    8029dd <alloc_block_FF+0x14d>
  8029c6:	83 ec 04             	sub    $0x4,%esp
  8029c9:	68 58 4b 80 00       	push   $0x804b58
  8029ce:	68 d7 00 00 00       	push   $0xd7
  8029d3:	68 3d 4b 80 00       	push   $0x804b3d
  8029d8:	e8 d3 dd ff ff       	call   8007b0 <_panic>
  8029dd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029e6:	89 10                	mov    %edx,(%eax)
  8029e8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029eb:	8b 00                	mov    (%eax),%eax
  8029ed:	85 c0                	test   %eax,%eax
  8029ef:	74 0d                	je     8029fe <alloc_block_FF+0x16e>
  8029f1:	a1 30 50 80 00       	mov    0x805030,%eax
  8029f6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029f9:	89 50 04             	mov    %edx,0x4(%eax)
  8029fc:	eb 08                	jmp    802a06 <alloc_block_FF+0x176>
  8029fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a01:	a3 34 50 80 00       	mov    %eax,0x805034
  802a06:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a09:	a3 30 50 80 00       	mov    %eax,0x805030
  802a0e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a18:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a1d:	40                   	inc    %eax
  802a1e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a23:	e9 dc 00 00 00       	jmp    802b04 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 00                	mov    (%eax),%eax
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	75 65                	jne    802a96 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a31:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a35:	75 17                	jne    802a4e <alloc_block_FF+0x1be>
  802a37:	83 ec 04             	sub    $0x4,%esp
  802a3a:	68 8c 4b 80 00       	push   $0x804b8c
  802a3f:	68 db 00 00 00       	push   $0xdb
  802a44:	68 3d 4b 80 00       	push   $0x804b3d
  802a49:	e8 62 dd ff ff       	call   8007b0 <_panic>
  802a4e:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802a54:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a57:	89 50 04             	mov    %edx,0x4(%eax)
  802a5a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a5d:	8b 40 04             	mov    0x4(%eax),%eax
  802a60:	85 c0                	test   %eax,%eax
  802a62:	74 0c                	je     802a70 <alloc_block_FF+0x1e0>
  802a64:	a1 34 50 80 00       	mov    0x805034,%eax
  802a69:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a6c:	89 10                	mov    %edx,(%eax)
  802a6e:	eb 08                	jmp    802a78 <alloc_block_FF+0x1e8>
  802a70:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a73:	a3 30 50 80 00       	mov    %eax,0x805030
  802a78:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a7b:	a3 34 50 80 00       	mov    %eax,0x805034
  802a80:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a89:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a8e:	40                   	inc    %eax
  802a8f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a94:	eb 6e                	jmp    802b04 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802a96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9a:	74 06                	je     802aa2 <alloc_block_FF+0x212>
  802a9c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802aa0:	75 17                	jne    802ab9 <alloc_block_FF+0x229>
  802aa2:	83 ec 04             	sub    $0x4,%esp
  802aa5:	68 b0 4b 80 00       	push   $0x804bb0
  802aaa:	68 df 00 00 00       	push   $0xdf
  802aaf:	68 3d 4b 80 00       	push   $0x804b3d
  802ab4:	e8 f7 dc ff ff       	call   8007b0 <_panic>
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 10                	mov    (%eax),%edx
  802abe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac1:	89 10                	mov    %edx,(%eax)
  802ac3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 0b                	je     802ad7 <alloc_block_FF+0x247>
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ad4:	89 50 04             	mov    %edx,0x4(%eax)
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802add:	89 10                	mov    %edx,(%eax)
  802adf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae5:	89 50 04             	mov    %edx,0x4(%eax)
  802ae8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	75 08                	jne    802af9 <alloc_block_FF+0x269>
  802af1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802af4:	a3 34 50 80 00       	mov    %eax,0x805034
  802af9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802afe:	40                   	inc    %eax
  802aff:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802b04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b08:	75 17                	jne    802b21 <alloc_block_FF+0x291>
  802b0a:	83 ec 04             	sub    $0x4,%esp
  802b0d:	68 1f 4b 80 00       	push   $0x804b1f
  802b12:	68 e1 00 00 00       	push   $0xe1
  802b17:	68 3d 4b 80 00       	push   $0x804b3d
  802b1c:	e8 8f dc ff ff       	call   8007b0 <_panic>
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	74 10                	je     802b3a <alloc_block_FF+0x2aa>
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	8b 00                	mov    (%eax),%eax
  802b2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b32:	8b 52 04             	mov    0x4(%edx),%edx
  802b35:	89 50 04             	mov    %edx,0x4(%eax)
  802b38:	eb 0b                	jmp    802b45 <alloc_block_FF+0x2b5>
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 40 04             	mov    0x4(%eax),%eax
  802b40:	a3 34 50 80 00       	mov    %eax,0x805034
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 40 04             	mov    0x4(%eax),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	74 0f                	je     802b5e <alloc_block_FF+0x2ce>
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	8b 40 04             	mov    0x4(%eax),%eax
  802b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b58:	8b 12                	mov    (%edx),%edx
  802b5a:	89 10                	mov    %edx,(%eax)
  802b5c:	eb 0a                	jmp    802b68 <alloc_block_FF+0x2d8>
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 00                	mov    (%eax),%eax
  802b63:	a3 30 50 80 00       	mov    %eax,0x805030
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b80:	48                   	dec    %eax
  802b81:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802b86:	83 ec 04             	sub    $0x4,%esp
  802b89:	6a 00                	push   $0x0
  802b8b:	ff 75 b4             	pushl  -0x4c(%ebp)
  802b8e:	ff 75 b0             	pushl  -0x50(%ebp)
  802b91:	e8 cb fc ff ff       	call   802861 <set_block_data>
  802b96:	83 c4 10             	add    $0x10,%esp
  802b99:	e9 95 00 00 00       	jmp    802c33 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802b9e:	83 ec 04             	sub    $0x4,%esp
  802ba1:	6a 01                	push   $0x1
  802ba3:	ff 75 b8             	pushl  -0x48(%ebp)
  802ba6:	ff 75 bc             	pushl  -0x44(%ebp)
  802ba9:	e8 b3 fc ff ff       	call   802861 <set_block_data>
  802bae:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802bb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb5:	75 17                	jne    802bce <alloc_block_FF+0x33e>
  802bb7:	83 ec 04             	sub    $0x4,%esp
  802bba:	68 1f 4b 80 00       	push   $0x804b1f
  802bbf:	68 e8 00 00 00       	push   $0xe8
  802bc4:	68 3d 4b 80 00       	push   $0x804b3d
  802bc9:	e8 e2 db ff ff       	call   8007b0 <_panic>
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	74 10                	je     802be7 <alloc_block_FF+0x357>
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 00                	mov    (%eax),%eax
  802bdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bdf:	8b 52 04             	mov    0x4(%edx),%edx
  802be2:	89 50 04             	mov    %edx,0x4(%eax)
  802be5:	eb 0b                	jmp    802bf2 <alloc_block_FF+0x362>
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 40 04             	mov    0x4(%eax),%eax
  802bed:	a3 34 50 80 00       	mov    %eax,0x805034
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	8b 40 04             	mov    0x4(%eax),%eax
  802bf8:	85 c0                	test   %eax,%eax
  802bfa:	74 0f                	je     802c0b <alloc_block_FF+0x37b>
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 40 04             	mov    0x4(%eax),%eax
  802c02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c05:	8b 12                	mov    (%edx),%edx
  802c07:	89 10                	mov    %edx,(%eax)
  802c09:	eb 0a                	jmp    802c15 <alloc_block_FF+0x385>
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	a3 30 50 80 00       	mov    %eax,0x805030
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c28:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c2d:	48                   	dec    %eax
  802c2e:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802c33:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c36:	e9 0f 01 00 00       	jmp    802d4a <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c3b:	a1 38 50 80 00       	mov    0x805038,%eax
  802c40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c47:	74 07                	je     802c50 <alloc_block_FF+0x3c0>
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 00                	mov    (%eax),%eax
  802c4e:	eb 05                	jmp    802c55 <alloc_block_FF+0x3c5>
  802c50:	b8 00 00 00 00       	mov    $0x0,%eax
  802c55:	a3 38 50 80 00       	mov    %eax,0x805038
  802c5a:	a1 38 50 80 00       	mov    0x805038,%eax
  802c5f:	85 c0                	test   %eax,%eax
  802c61:	0f 85 e9 fc ff ff    	jne    802950 <alloc_block_FF+0xc0>
  802c67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6b:	0f 85 df fc ff ff    	jne    802950 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	83 c0 08             	add    $0x8,%eax
  802c77:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c7a:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802c81:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c84:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c87:	01 d0                	add    %edx,%eax
  802c89:	48                   	dec    %eax
  802c8a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802c8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c90:	ba 00 00 00 00       	mov    $0x0,%edx
  802c95:	f7 75 d8             	divl   -0x28(%ebp)
  802c98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c9b:	29 d0                	sub    %edx,%eax
  802c9d:	c1 e8 0c             	shr    $0xc,%eax
  802ca0:	83 ec 0c             	sub    $0xc,%esp
  802ca3:	50                   	push   %eax
  802ca4:	e8 66 ed ff ff       	call   801a0f <sbrk>
  802ca9:	83 c4 10             	add    $0x10,%esp
  802cac:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802caf:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802cb3:	75 0a                	jne    802cbf <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cba:	e9 8b 00 00 00       	jmp    802d4a <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cbf:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802cc6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cc9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ccc:	01 d0                	add    %edx,%eax
  802cce:	48                   	dec    %eax
  802ccf:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802cd2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802cd5:	ba 00 00 00 00       	mov    $0x0,%edx
  802cda:	f7 75 cc             	divl   -0x34(%ebp)
  802cdd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ce0:	29 d0                	sub    %edx,%eax
  802ce2:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ce5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ce8:	01 d0                	add    %edx,%eax
  802cea:	a3 48 50 80 00       	mov    %eax,0x805048
			end_block->info = 1;
  802cef:	a1 48 50 80 00       	mov    0x805048,%eax
  802cf4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802cfa:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d01:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d04:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d07:	01 d0                	add    %edx,%eax
  802d09:	48                   	dec    %eax
  802d0a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d10:	ba 00 00 00 00       	mov    $0x0,%edx
  802d15:	f7 75 c4             	divl   -0x3c(%ebp)
  802d18:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d1b:	29 d0                	sub    %edx,%eax
  802d1d:	83 ec 04             	sub    $0x4,%esp
  802d20:	6a 01                	push   $0x1
  802d22:	50                   	push   %eax
  802d23:	ff 75 d0             	pushl  -0x30(%ebp)
  802d26:	e8 36 fb ff ff       	call   802861 <set_block_data>
  802d2b:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802d2e:	83 ec 0c             	sub    $0xc,%esp
  802d31:	ff 75 d0             	pushl  -0x30(%ebp)
  802d34:	e8 1b 0a 00 00       	call   803754 <free_block>
  802d39:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802d3c:	83 ec 0c             	sub    $0xc,%esp
  802d3f:	ff 75 08             	pushl  0x8(%ebp)
  802d42:	e8 49 fb ff ff       	call   802890 <alloc_block_FF>
  802d47:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802d4a:	c9                   	leave  
  802d4b:	c3                   	ret    

00802d4c <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802d4c:	55                   	push   %ebp
  802d4d:	89 e5                	mov    %esp,%ebp
  802d4f:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	83 e0 01             	and    $0x1,%eax
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	74 03                	je     802d5f <alloc_block_BF+0x13>
  802d5c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802d5f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802d63:	77 07                	ja     802d6c <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802d65:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802d6c:	a1 28 50 80 00       	mov    0x805028,%eax
  802d71:	85 c0                	test   %eax,%eax
  802d73:	75 73                	jne    802de8 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	83 c0 10             	add    $0x10,%eax
  802d7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802d7e:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802d85:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d8b:	01 d0                	add    %edx,%eax
  802d8d:	48                   	dec    %eax
  802d8e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d91:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d94:	ba 00 00 00 00       	mov    $0x0,%edx
  802d99:	f7 75 e0             	divl   -0x20(%ebp)
  802d9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d9f:	29 d0                	sub    %edx,%eax
  802da1:	c1 e8 0c             	shr    $0xc,%eax
  802da4:	83 ec 0c             	sub    $0xc,%esp
  802da7:	50                   	push   %eax
  802da8:	e8 62 ec ff ff       	call   801a0f <sbrk>
  802dad:	83 c4 10             	add    $0x10,%esp
  802db0:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802db3:	83 ec 0c             	sub    $0xc,%esp
  802db6:	6a 00                	push   $0x0
  802db8:	e8 52 ec ff ff       	call   801a0f <sbrk>
  802dbd:	83 c4 10             	add    $0x10,%esp
  802dc0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802dc3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dc6:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802dc9:	83 ec 08             	sub    $0x8,%esp
  802dcc:	50                   	push   %eax
  802dcd:	ff 75 d8             	pushl  -0x28(%ebp)
  802dd0:	e8 9f f8 ff ff       	call   802674 <initialize_dynamic_allocator>
  802dd5:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802dd8:	83 ec 0c             	sub    $0xc,%esp
  802ddb:	68 7b 4b 80 00       	push   $0x804b7b
  802de0:	e8 88 dc ff ff       	call   800a6d <cprintf>
  802de5:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802de8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802def:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802df6:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802dfd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802e04:	a1 30 50 80 00       	mov    0x805030,%eax
  802e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e0c:	e9 1d 01 00 00       	jmp    802f2e <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e14:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802e17:	83 ec 0c             	sub    $0xc,%esp
  802e1a:	ff 75 a8             	pushl  -0x58(%ebp)
  802e1d:	e8 ee f6 ff ff       	call   802510 <get_block_size>
  802e22:	83 c4 10             	add    $0x10,%esp
  802e25:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	83 c0 08             	add    $0x8,%eax
  802e2e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e31:	0f 87 ef 00 00 00    	ja     802f26 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	83 c0 18             	add    $0x18,%eax
  802e3d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e40:	77 1d                	ja     802e5f <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e45:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e48:	0f 86 d8 00 00 00    	jbe    802f26 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802e4e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e51:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802e54:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e5a:	e9 c7 00 00 00       	jmp    802f26 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e62:	83 c0 08             	add    $0x8,%eax
  802e65:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e68:	0f 85 9d 00 00 00    	jne    802f0b <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802e6e:	83 ec 04             	sub    $0x4,%esp
  802e71:	6a 01                	push   $0x1
  802e73:	ff 75 a4             	pushl  -0x5c(%ebp)
  802e76:	ff 75 a8             	pushl  -0x58(%ebp)
  802e79:	e8 e3 f9 ff ff       	call   802861 <set_block_data>
  802e7e:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802e81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e85:	75 17                	jne    802e9e <alloc_block_BF+0x152>
  802e87:	83 ec 04             	sub    $0x4,%esp
  802e8a:	68 1f 4b 80 00       	push   $0x804b1f
  802e8f:	68 2c 01 00 00       	push   $0x12c
  802e94:	68 3d 4b 80 00       	push   $0x804b3d
  802e99:	e8 12 d9 ff ff       	call   8007b0 <_panic>
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 00                	mov    (%eax),%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	74 10                	je     802eb7 <alloc_block_BF+0x16b>
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 00                	mov    (%eax),%eax
  802eac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eaf:	8b 52 04             	mov    0x4(%edx),%edx
  802eb2:	89 50 04             	mov    %edx,0x4(%eax)
  802eb5:	eb 0b                	jmp    802ec2 <alloc_block_BF+0x176>
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	8b 40 04             	mov    0x4(%eax),%eax
  802ebd:	a3 34 50 80 00       	mov    %eax,0x805034
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 40 04             	mov    0x4(%eax),%eax
  802ec8:	85 c0                	test   %eax,%eax
  802eca:	74 0f                	je     802edb <alloc_block_BF+0x18f>
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	8b 40 04             	mov    0x4(%eax),%eax
  802ed2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed5:	8b 12                	mov    (%edx),%edx
  802ed7:	89 10                	mov    %edx,(%eax)
  802ed9:	eb 0a                	jmp    802ee5 <alloc_block_BF+0x199>
  802edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ede:	8b 00                	mov    (%eax),%eax
  802ee0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802efd:	48                   	dec    %eax
  802efe:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802f03:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f06:	e9 24 04 00 00       	jmp    80332f <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f11:	76 13                	jbe    802f26 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802f13:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802f1a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802f20:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f23:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802f26:	a1 38 50 80 00       	mov    0x805038,%eax
  802f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f32:	74 07                	je     802f3b <alloc_block_BF+0x1ef>
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	8b 00                	mov    (%eax),%eax
  802f39:	eb 05                	jmp    802f40 <alloc_block_BF+0x1f4>
  802f3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f40:	a3 38 50 80 00       	mov    %eax,0x805038
  802f45:	a1 38 50 80 00       	mov    0x805038,%eax
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	0f 85 bf fe ff ff    	jne    802e11 <alloc_block_BF+0xc5>
  802f52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f56:	0f 85 b5 fe ff ff    	jne    802e11 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802f5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f60:	0f 84 26 02 00 00    	je     80318c <alloc_block_BF+0x440>
  802f66:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f6a:	0f 85 1c 02 00 00    	jne    80318c <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f73:	2b 45 08             	sub    0x8(%ebp),%eax
  802f76:	83 e8 08             	sub    $0x8,%eax
  802f79:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	8d 50 08             	lea    0x8(%eax),%edx
  802f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f85:	01 d0                	add    %edx,%eax
  802f87:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8d:	83 c0 08             	add    $0x8,%eax
  802f90:	83 ec 04             	sub    $0x4,%esp
  802f93:	6a 01                	push   $0x1
  802f95:	50                   	push   %eax
  802f96:	ff 75 f0             	pushl  -0x10(%ebp)
  802f99:	e8 c3 f8 ff ff       	call   802861 <set_block_data>
  802f9e:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa4:	8b 40 04             	mov    0x4(%eax),%eax
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	75 68                	jne    803013 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802fab:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802faf:	75 17                	jne    802fc8 <alloc_block_BF+0x27c>
  802fb1:	83 ec 04             	sub    $0x4,%esp
  802fb4:	68 58 4b 80 00       	push   $0x804b58
  802fb9:	68 45 01 00 00       	push   $0x145
  802fbe:	68 3d 4b 80 00       	push   $0x804b3d
  802fc3:	e8 e8 d7 ff ff       	call   8007b0 <_panic>
  802fc8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fd1:	89 10                	mov    %edx,(%eax)
  802fd3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fd6:	8b 00                	mov    (%eax),%eax
  802fd8:	85 c0                	test   %eax,%eax
  802fda:	74 0d                	je     802fe9 <alloc_block_BF+0x29d>
  802fdc:	a1 30 50 80 00       	mov    0x805030,%eax
  802fe1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fe4:	89 50 04             	mov    %edx,0x4(%eax)
  802fe7:	eb 08                	jmp    802ff1 <alloc_block_BF+0x2a5>
  802fe9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fec:	a3 34 50 80 00       	mov    %eax,0x805034
  802ff1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ff4:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ffc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803003:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803008:	40                   	inc    %eax
  803009:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80300e:	e9 dc 00 00 00       	jmp    8030ef <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803013:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	85 c0                	test   %eax,%eax
  80301a:	75 65                	jne    803081 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80301c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803020:	75 17                	jne    803039 <alloc_block_BF+0x2ed>
  803022:	83 ec 04             	sub    $0x4,%esp
  803025:	68 8c 4b 80 00       	push   $0x804b8c
  80302a:	68 4a 01 00 00       	push   $0x14a
  80302f:	68 3d 4b 80 00       	push   $0x804b3d
  803034:	e8 77 d7 ff ff       	call   8007b0 <_panic>
  803039:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80303f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803042:	89 50 04             	mov    %edx,0x4(%eax)
  803045:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803048:	8b 40 04             	mov    0x4(%eax),%eax
  80304b:	85 c0                	test   %eax,%eax
  80304d:	74 0c                	je     80305b <alloc_block_BF+0x30f>
  80304f:	a1 34 50 80 00       	mov    0x805034,%eax
  803054:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803057:	89 10                	mov    %edx,(%eax)
  803059:	eb 08                	jmp    803063 <alloc_block_BF+0x317>
  80305b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80305e:	a3 30 50 80 00       	mov    %eax,0x805030
  803063:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803066:	a3 34 50 80 00       	mov    %eax,0x805034
  80306b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80306e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803074:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803079:	40                   	inc    %eax
  80307a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80307f:	eb 6e                	jmp    8030ef <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803081:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803085:	74 06                	je     80308d <alloc_block_BF+0x341>
  803087:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80308b:	75 17                	jne    8030a4 <alloc_block_BF+0x358>
  80308d:	83 ec 04             	sub    $0x4,%esp
  803090:	68 b0 4b 80 00       	push   $0x804bb0
  803095:	68 4f 01 00 00       	push   $0x14f
  80309a:	68 3d 4b 80 00       	push   $0x804b3d
  80309f:	e8 0c d7 ff ff       	call   8007b0 <_panic>
  8030a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a7:	8b 10                	mov    (%eax),%edx
  8030a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030ac:	89 10                	mov    %edx,(%eax)
  8030ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b1:	8b 00                	mov    (%eax),%eax
  8030b3:	85 c0                	test   %eax,%eax
  8030b5:	74 0b                	je     8030c2 <alloc_block_BF+0x376>
  8030b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ba:	8b 00                	mov    (%eax),%eax
  8030bc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030bf:	89 50 04             	mov    %edx,0x4(%eax)
  8030c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030c8:	89 10                	mov    %edx,(%eax)
  8030ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030d0:	89 50 04             	mov    %edx,0x4(%eax)
  8030d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030d6:	8b 00                	mov    (%eax),%eax
  8030d8:	85 c0                	test   %eax,%eax
  8030da:	75 08                	jne    8030e4 <alloc_block_BF+0x398>
  8030dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030df:	a3 34 50 80 00       	mov    %eax,0x805034
  8030e4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030e9:	40                   	inc    %eax
  8030ea:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8030ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030f3:	75 17                	jne    80310c <alloc_block_BF+0x3c0>
  8030f5:	83 ec 04             	sub    $0x4,%esp
  8030f8:	68 1f 4b 80 00       	push   $0x804b1f
  8030fd:	68 51 01 00 00       	push   $0x151
  803102:	68 3d 4b 80 00       	push   $0x804b3d
  803107:	e8 a4 d6 ff ff       	call   8007b0 <_panic>
  80310c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310f:	8b 00                	mov    (%eax),%eax
  803111:	85 c0                	test   %eax,%eax
  803113:	74 10                	je     803125 <alloc_block_BF+0x3d9>
  803115:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803118:	8b 00                	mov    (%eax),%eax
  80311a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80311d:	8b 52 04             	mov    0x4(%edx),%edx
  803120:	89 50 04             	mov    %edx,0x4(%eax)
  803123:	eb 0b                	jmp    803130 <alloc_block_BF+0x3e4>
  803125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803128:	8b 40 04             	mov    0x4(%eax),%eax
  80312b:	a3 34 50 80 00       	mov    %eax,0x805034
  803130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803133:	8b 40 04             	mov    0x4(%eax),%eax
  803136:	85 c0                	test   %eax,%eax
  803138:	74 0f                	je     803149 <alloc_block_BF+0x3fd>
  80313a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313d:	8b 40 04             	mov    0x4(%eax),%eax
  803140:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803143:	8b 12                	mov    (%edx),%edx
  803145:	89 10                	mov    %edx,(%eax)
  803147:	eb 0a                	jmp    803153 <alloc_block_BF+0x407>
  803149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314c:	8b 00                	mov    (%eax),%eax
  80314e:	a3 30 50 80 00       	mov    %eax,0x805030
  803153:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803156:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80315c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803166:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80316b:	48                   	dec    %eax
  80316c:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  803171:	83 ec 04             	sub    $0x4,%esp
  803174:	6a 00                	push   $0x0
  803176:	ff 75 d0             	pushl  -0x30(%ebp)
  803179:	ff 75 cc             	pushl  -0x34(%ebp)
  80317c:	e8 e0 f6 ff ff       	call   802861 <set_block_data>
  803181:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803187:	e9 a3 01 00 00       	jmp    80332f <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80318c:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803190:	0f 85 9d 00 00 00    	jne    803233 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803196:	83 ec 04             	sub    $0x4,%esp
  803199:	6a 01                	push   $0x1
  80319b:	ff 75 ec             	pushl  -0x14(%ebp)
  80319e:	ff 75 f0             	pushl  -0x10(%ebp)
  8031a1:	e8 bb f6 ff ff       	call   802861 <set_block_data>
  8031a6:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8031a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031ad:	75 17                	jne    8031c6 <alloc_block_BF+0x47a>
  8031af:	83 ec 04             	sub    $0x4,%esp
  8031b2:	68 1f 4b 80 00       	push   $0x804b1f
  8031b7:	68 58 01 00 00       	push   $0x158
  8031bc:	68 3d 4b 80 00       	push   $0x804b3d
  8031c1:	e8 ea d5 ff ff       	call   8007b0 <_panic>
  8031c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c9:	8b 00                	mov    (%eax),%eax
  8031cb:	85 c0                	test   %eax,%eax
  8031cd:	74 10                	je     8031df <alloc_block_BF+0x493>
  8031cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d2:	8b 00                	mov    (%eax),%eax
  8031d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d7:	8b 52 04             	mov    0x4(%edx),%edx
  8031da:	89 50 04             	mov    %edx,0x4(%eax)
  8031dd:	eb 0b                	jmp    8031ea <alloc_block_BF+0x49e>
  8031df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e2:	8b 40 04             	mov    0x4(%eax),%eax
  8031e5:	a3 34 50 80 00       	mov    %eax,0x805034
  8031ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ed:	8b 40 04             	mov    0x4(%eax),%eax
  8031f0:	85 c0                	test   %eax,%eax
  8031f2:	74 0f                	je     803203 <alloc_block_BF+0x4b7>
  8031f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f7:	8b 40 04             	mov    0x4(%eax),%eax
  8031fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031fd:	8b 12                	mov    (%edx),%edx
  8031ff:	89 10                	mov    %edx,(%eax)
  803201:	eb 0a                	jmp    80320d <alloc_block_BF+0x4c1>
  803203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	a3 30 50 80 00       	mov    %eax,0x805030
  80320d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803210:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803219:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803220:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803225:	48                   	dec    %eax
  803226:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  80322b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322e:	e9 fc 00 00 00       	jmp    80332f <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803233:	8b 45 08             	mov    0x8(%ebp),%eax
  803236:	83 c0 08             	add    $0x8,%eax
  803239:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80323c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803243:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803246:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803249:	01 d0                	add    %edx,%eax
  80324b:	48                   	dec    %eax
  80324c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80324f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803252:	ba 00 00 00 00       	mov    $0x0,%edx
  803257:	f7 75 c4             	divl   -0x3c(%ebp)
  80325a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80325d:	29 d0                	sub    %edx,%eax
  80325f:	c1 e8 0c             	shr    $0xc,%eax
  803262:	83 ec 0c             	sub    $0xc,%esp
  803265:	50                   	push   %eax
  803266:	e8 a4 e7 ff ff       	call   801a0f <sbrk>
  80326b:	83 c4 10             	add    $0x10,%esp
  80326e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803271:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803275:	75 0a                	jne    803281 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803277:	b8 00 00 00 00       	mov    $0x0,%eax
  80327c:	e9 ae 00 00 00       	jmp    80332f <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803281:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803288:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80328b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80328e:	01 d0                	add    %edx,%eax
  803290:	48                   	dec    %eax
  803291:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803294:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803297:	ba 00 00 00 00       	mov    $0x0,%edx
  80329c:	f7 75 b8             	divl   -0x48(%ebp)
  80329f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8032a2:	29 d0                	sub    %edx,%eax
  8032a4:	8d 50 fc             	lea    -0x4(%eax),%edx
  8032a7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8032aa:	01 d0                	add    %edx,%eax
  8032ac:	a3 48 50 80 00       	mov    %eax,0x805048
				end_block->info = 1;
  8032b1:	a1 48 50 80 00       	mov    0x805048,%eax
  8032b6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8032bc:	83 ec 0c             	sub    $0xc,%esp
  8032bf:	68 e4 4b 80 00       	push   $0x804be4
  8032c4:	e8 a4 d7 ff ff       	call   800a6d <cprintf>
  8032c9:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8032cc:	83 ec 08             	sub    $0x8,%esp
  8032cf:	ff 75 bc             	pushl  -0x44(%ebp)
  8032d2:	68 e9 4b 80 00       	push   $0x804be9
  8032d7:	e8 91 d7 ff ff       	call   800a6d <cprintf>
  8032dc:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8032df:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8032e6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032ec:	01 d0                	add    %edx,%eax
  8032ee:	48                   	dec    %eax
  8032ef:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8032f2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8032f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8032fa:	f7 75 b0             	divl   -0x50(%ebp)
  8032fd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803300:	29 d0                	sub    %edx,%eax
  803302:	83 ec 04             	sub    $0x4,%esp
  803305:	6a 01                	push   $0x1
  803307:	50                   	push   %eax
  803308:	ff 75 bc             	pushl  -0x44(%ebp)
  80330b:	e8 51 f5 ff ff       	call   802861 <set_block_data>
  803310:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803313:	83 ec 0c             	sub    $0xc,%esp
  803316:	ff 75 bc             	pushl  -0x44(%ebp)
  803319:	e8 36 04 00 00       	call   803754 <free_block>
  80331e:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803321:	83 ec 0c             	sub    $0xc,%esp
  803324:	ff 75 08             	pushl  0x8(%ebp)
  803327:	e8 20 fa ff ff       	call   802d4c <alloc_block_BF>
  80332c:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80332f:	c9                   	leave  
  803330:	c3                   	ret    

00803331 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803331:	55                   	push   %ebp
  803332:	89 e5                	mov    %esp,%ebp
  803334:	53                   	push   %ebx
  803335:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803338:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80333f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803346:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334a:	74 1e                	je     80336a <merging+0x39>
  80334c:	ff 75 08             	pushl  0x8(%ebp)
  80334f:	e8 bc f1 ff ff       	call   802510 <get_block_size>
  803354:	83 c4 04             	add    $0x4,%esp
  803357:	89 c2                	mov    %eax,%edx
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	01 d0                	add    %edx,%eax
  80335e:	3b 45 10             	cmp    0x10(%ebp),%eax
  803361:	75 07                	jne    80336a <merging+0x39>
		prev_is_free = 1;
  803363:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80336a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80336e:	74 1e                	je     80338e <merging+0x5d>
  803370:	ff 75 10             	pushl  0x10(%ebp)
  803373:	e8 98 f1 ff ff       	call   802510 <get_block_size>
  803378:	83 c4 04             	add    $0x4,%esp
  80337b:	89 c2                	mov    %eax,%edx
  80337d:	8b 45 10             	mov    0x10(%ebp),%eax
  803380:	01 d0                	add    %edx,%eax
  803382:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803385:	75 07                	jne    80338e <merging+0x5d>
		next_is_free = 1;
  803387:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80338e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803392:	0f 84 cc 00 00 00    	je     803464 <merging+0x133>
  803398:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80339c:	0f 84 c2 00 00 00    	je     803464 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8033a2:	ff 75 08             	pushl  0x8(%ebp)
  8033a5:	e8 66 f1 ff ff       	call   802510 <get_block_size>
  8033aa:	83 c4 04             	add    $0x4,%esp
  8033ad:	89 c3                	mov    %eax,%ebx
  8033af:	ff 75 10             	pushl  0x10(%ebp)
  8033b2:	e8 59 f1 ff ff       	call   802510 <get_block_size>
  8033b7:	83 c4 04             	add    $0x4,%esp
  8033ba:	01 c3                	add    %eax,%ebx
  8033bc:	ff 75 0c             	pushl  0xc(%ebp)
  8033bf:	e8 4c f1 ff ff       	call   802510 <get_block_size>
  8033c4:	83 c4 04             	add    $0x4,%esp
  8033c7:	01 d8                	add    %ebx,%eax
  8033c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8033cc:	6a 00                	push   $0x0
  8033ce:	ff 75 ec             	pushl  -0x14(%ebp)
  8033d1:	ff 75 08             	pushl  0x8(%ebp)
  8033d4:	e8 88 f4 ff ff       	call   802861 <set_block_data>
  8033d9:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8033dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033e0:	75 17                	jne    8033f9 <merging+0xc8>
  8033e2:	83 ec 04             	sub    $0x4,%esp
  8033e5:	68 1f 4b 80 00       	push   $0x804b1f
  8033ea:	68 7d 01 00 00       	push   $0x17d
  8033ef:	68 3d 4b 80 00       	push   $0x804b3d
  8033f4:	e8 b7 d3 ff ff       	call   8007b0 <_panic>
  8033f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033fc:	8b 00                	mov    (%eax),%eax
  8033fe:	85 c0                	test   %eax,%eax
  803400:	74 10                	je     803412 <merging+0xe1>
  803402:	8b 45 0c             	mov    0xc(%ebp),%eax
  803405:	8b 00                	mov    (%eax),%eax
  803407:	8b 55 0c             	mov    0xc(%ebp),%edx
  80340a:	8b 52 04             	mov    0x4(%edx),%edx
  80340d:	89 50 04             	mov    %edx,0x4(%eax)
  803410:	eb 0b                	jmp    80341d <merging+0xec>
  803412:	8b 45 0c             	mov    0xc(%ebp),%eax
  803415:	8b 40 04             	mov    0x4(%eax),%eax
  803418:	a3 34 50 80 00       	mov    %eax,0x805034
  80341d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803420:	8b 40 04             	mov    0x4(%eax),%eax
  803423:	85 c0                	test   %eax,%eax
  803425:	74 0f                	je     803436 <merging+0x105>
  803427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80342a:	8b 40 04             	mov    0x4(%eax),%eax
  80342d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803430:	8b 12                	mov    (%edx),%edx
  803432:	89 10                	mov    %edx,(%eax)
  803434:	eb 0a                	jmp    803440 <merging+0x10f>
  803436:	8b 45 0c             	mov    0xc(%ebp),%eax
  803439:	8b 00                	mov    (%eax),%eax
  80343b:	a3 30 50 80 00       	mov    %eax,0x805030
  803440:	8b 45 0c             	mov    0xc(%ebp),%eax
  803443:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803453:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803458:	48                   	dec    %eax
  803459:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80345e:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80345f:	e9 ea 02 00 00       	jmp    80374e <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803468:	74 3b                	je     8034a5 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80346a:	83 ec 0c             	sub    $0xc,%esp
  80346d:	ff 75 08             	pushl  0x8(%ebp)
  803470:	e8 9b f0 ff ff       	call   802510 <get_block_size>
  803475:	83 c4 10             	add    $0x10,%esp
  803478:	89 c3                	mov    %eax,%ebx
  80347a:	83 ec 0c             	sub    $0xc,%esp
  80347d:	ff 75 10             	pushl  0x10(%ebp)
  803480:	e8 8b f0 ff ff       	call   802510 <get_block_size>
  803485:	83 c4 10             	add    $0x10,%esp
  803488:	01 d8                	add    %ebx,%eax
  80348a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80348d:	83 ec 04             	sub    $0x4,%esp
  803490:	6a 00                	push   $0x0
  803492:	ff 75 e8             	pushl  -0x18(%ebp)
  803495:	ff 75 08             	pushl  0x8(%ebp)
  803498:	e8 c4 f3 ff ff       	call   802861 <set_block_data>
  80349d:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034a0:	e9 a9 02 00 00       	jmp    80374e <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8034a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034a9:	0f 84 2d 01 00 00    	je     8035dc <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8034af:	83 ec 0c             	sub    $0xc,%esp
  8034b2:	ff 75 10             	pushl  0x10(%ebp)
  8034b5:	e8 56 f0 ff ff       	call   802510 <get_block_size>
  8034ba:	83 c4 10             	add    $0x10,%esp
  8034bd:	89 c3                	mov    %eax,%ebx
  8034bf:	83 ec 0c             	sub    $0xc,%esp
  8034c2:	ff 75 0c             	pushl  0xc(%ebp)
  8034c5:	e8 46 f0 ff ff       	call   802510 <get_block_size>
  8034ca:	83 c4 10             	add    $0x10,%esp
  8034cd:	01 d8                	add    %ebx,%eax
  8034cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8034d2:	83 ec 04             	sub    $0x4,%esp
  8034d5:	6a 00                	push   $0x0
  8034d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034da:	ff 75 10             	pushl  0x10(%ebp)
  8034dd:	e8 7f f3 ff ff       	call   802861 <set_block_data>
  8034e2:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8034e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8034e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8034eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034ef:	74 06                	je     8034f7 <merging+0x1c6>
  8034f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034f5:	75 17                	jne    80350e <merging+0x1dd>
  8034f7:	83 ec 04             	sub    $0x4,%esp
  8034fa:	68 f8 4b 80 00       	push   $0x804bf8
  8034ff:	68 8d 01 00 00       	push   $0x18d
  803504:	68 3d 4b 80 00       	push   $0x804b3d
  803509:	e8 a2 d2 ff ff       	call   8007b0 <_panic>
  80350e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803511:	8b 50 04             	mov    0x4(%eax),%edx
  803514:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803517:	89 50 04             	mov    %edx,0x4(%eax)
  80351a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80351d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803520:	89 10                	mov    %edx,(%eax)
  803522:	8b 45 0c             	mov    0xc(%ebp),%eax
  803525:	8b 40 04             	mov    0x4(%eax),%eax
  803528:	85 c0                	test   %eax,%eax
  80352a:	74 0d                	je     803539 <merging+0x208>
  80352c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352f:	8b 40 04             	mov    0x4(%eax),%eax
  803532:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803535:	89 10                	mov    %edx,(%eax)
  803537:	eb 08                	jmp    803541 <merging+0x210>
  803539:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80353c:	a3 30 50 80 00       	mov    %eax,0x805030
  803541:	8b 45 0c             	mov    0xc(%ebp),%eax
  803544:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803547:	89 50 04             	mov    %edx,0x4(%eax)
  80354a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80354f:	40                   	inc    %eax
  803550:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  803555:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803559:	75 17                	jne    803572 <merging+0x241>
  80355b:	83 ec 04             	sub    $0x4,%esp
  80355e:	68 1f 4b 80 00       	push   $0x804b1f
  803563:	68 8e 01 00 00       	push   $0x18e
  803568:	68 3d 4b 80 00       	push   $0x804b3d
  80356d:	e8 3e d2 ff ff       	call   8007b0 <_panic>
  803572:	8b 45 0c             	mov    0xc(%ebp),%eax
  803575:	8b 00                	mov    (%eax),%eax
  803577:	85 c0                	test   %eax,%eax
  803579:	74 10                	je     80358b <merging+0x25a>
  80357b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80357e:	8b 00                	mov    (%eax),%eax
  803580:	8b 55 0c             	mov    0xc(%ebp),%edx
  803583:	8b 52 04             	mov    0x4(%edx),%edx
  803586:	89 50 04             	mov    %edx,0x4(%eax)
  803589:	eb 0b                	jmp    803596 <merging+0x265>
  80358b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80358e:	8b 40 04             	mov    0x4(%eax),%eax
  803591:	a3 34 50 80 00       	mov    %eax,0x805034
  803596:	8b 45 0c             	mov    0xc(%ebp),%eax
  803599:	8b 40 04             	mov    0x4(%eax),%eax
  80359c:	85 c0                	test   %eax,%eax
  80359e:	74 0f                	je     8035af <merging+0x27e>
  8035a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035a3:	8b 40 04             	mov    0x4(%eax),%eax
  8035a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035a9:	8b 12                	mov    (%edx),%edx
  8035ab:	89 10                	mov    %edx,(%eax)
  8035ad:	eb 0a                	jmp    8035b9 <merging+0x288>
  8035af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b2:	8b 00                	mov    (%eax),%eax
  8035b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035cc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035d1:	48                   	dec    %eax
  8035d2:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035d7:	e9 72 01 00 00       	jmp    80374e <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8035dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8035df:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8035e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e6:	74 79                	je     803661 <merging+0x330>
  8035e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035ec:	74 73                	je     803661 <merging+0x330>
  8035ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f2:	74 06                	je     8035fa <merging+0x2c9>
  8035f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035f8:	75 17                	jne    803611 <merging+0x2e0>
  8035fa:	83 ec 04             	sub    $0x4,%esp
  8035fd:	68 b0 4b 80 00       	push   $0x804bb0
  803602:	68 94 01 00 00       	push   $0x194
  803607:	68 3d 4b 80 00       	push   $0x804b3d
  80360c:	e8 9f d1 ff ff       	call   8007b0 <_panic>
  803611:	8b 45 08             	mov    0x8(%ebp),%eax
  803614:	8b 10                	mov    (%eax),%edx
  803616:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803619:	89 10                	mov    %edx,(%eax)
  80361b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80361e:	8b 00                	mov    (%eax),%eax
  803620:	85 c0                	test   %eax,%eax
  803622:	74 0b                	je     80362f <merging+0x2fe>
  803624:	8b 45 08             	mov    0x8(%ebp),%eax
  803627:	8b 00                	mov    (%eax),%eax
  803629:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80362c:	89 50 04             	mov    %edx,0x4(%eax)
  80362f:	8b 45 08             	mov    0x8(%ebp),%eax
  803632:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803635:	89 10                	mov    %edx,(%eax)
  803637:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80363a:	8b 55 08             	mov    0x8(%ebp),%edx
  80363d:	89 50 04             	mov    %edx,0x4(%eax)
  803640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803643:	8b 00                	mov    (%eax),%eax
  803645:	85 c0                	test   %eax,%eax
  803647:	75 08                	jne    803651 <merging+0x320>
  803649:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80364c:	a3 34 50 80 00       	mov    %eax,0x805034
  803651:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803656:	40                   	inc    %eax
  803657:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80365c:	e9 ce 00 00 00       	jmp    80372f <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803661:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803665:	74 65                	je     8036cc <merging+0x39b>
  803667:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80366b:	75 17                	jne    803684 <merging+0x353>
  80366d:	83 ec 04             	sub    $0x4,%esp
  803670:	68 8c 4b 80 00       	push   $0x804b8c
  803675:	68 95 01 00 00       	push   $0x195
  80367a:	68 3d 4b 80 00       	push   $0x804b3d
  80367f:	e8 2c d1 ff ff       	call   8007b0 <_panic>
  803684:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80368a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80368d:	89 50 04             	mov    %edx,0x4(%eax)
  803690:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803693:	8b 40 04             	mov    0x4(%eax),%eax
  803696:	85 c0                	test   %eax,%eax
  803698:	74 0c                	je     8036a6 <merging+0x375>
  80369a:	a1 34 50 80 00       	mov    0x805034,%eax
  80369f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036a2:	89 10                	mov    %edx,(%eax)
  8036a4:	eb 08                	jmp    8036ae <merging+0x37d>
  8036a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8036ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036b1:	a3 34 50 80 00       	mov    %eax,0x805034
  8036b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036bf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036c4:	40                   	inc    %eax
  8036c5:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036ca:	eb 63                	jmp    80372f <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8036cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036d0:	75 17                	jne    8036e9 <merging+0x3b8>
  8036d2:	83 ec 04             	sub    $0x4,%esp
  8036d5:	68 58 4b 80 00       	push   $0x804b58
  8036da:	68 98 01 00 00       	push   $0x198
  8036df:	68 3d 4b 80 00       	push   $0x804b3d
  8036e4:	e8 c7 d0 ff ff       	call   8007b0 <_panic>
  8036e9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f2:	89 10                	mov    %edx,(%eax)
  8036f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f7:	8b 00                	mov    (%eax),%eax
  8036f9:	85 c0                	test   %eax,%eax
  8036fb:	74 0d                	je     80370a <merging+0x3d9>
  8036fd:	a1 30 50 80 00       	mov    0x805030,%eax
  803702:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803705:	89 50 04             	mov    %edx,0x4(%eax)
  803708:	eb 08                	jmp    803712 <merging+0x3e1>
  80370a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80370d:	a3 34 50 80 00       	mov    %eax,0x805034
  803712:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803715:	a3 30 50 80 00       	mov    %eax,0x805030
  80371a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80371d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803724:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803729:	40                   	inc    %eax
  80372a:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  80372f:	83 ec 0c             	sub    $0xc,%esp
  803732:	ff 75 10             	pushl  0x10(%ebp)
  803735:	e8 d6 ed ff ff       	call   802510 <get_block_size>
  80373a:	83 c4 10             	add    $0x10,%esp
  80373d:	83 ec 04             	sub    $0x4,%esp
  803740:	6a 00                	push   $0x0
  803742:	50                   	push   %eax
  803743:	ff 75 10             	pushl  0x10(%ebp)
  803746:	e8 16 f1 ff ff       	call   802861 <set_block_data>
  80374b:	83 c4 10             	add    $0x10,%esp
	}
}
  80374e:	90                   	nop
  80374f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803752:	c9                   	leave  
  803753:	c3                   	ret    

00803754 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803754:	55                   	push   %ebp
  803755:	89 e5                	mov    %esp,%ebp
  803757:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80375a:	a1 30 50 80 00       	mov    0x805030,%eax
  80375f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803762:	a1 34 50 80 00       	mov    0x805034,%eax
  803767:	3b 45 08             	cmp    0x8(%ebp),%eax
  80376a:	73 1b                	jae    803787 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80376c:	a1 34 50 80 00       	mov    0x805034,%eax
  803771:	83 ec 04             	sub    $0x4,%esp
  803774:	ff 75 08             	pushl  0x8(%ebp)
  803777:	6a 00                	push   $0x0
  803779:	50                   	push   %eax
  80377a:	e8 b2 fb ff ff       	call   803331 <merging>
  80377f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803782:	e9 8b 00 00 00       	jmp    803812 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803787:	a1 30 50 80 00       	mov    0x805030,%eax
  80378c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80378f:	76 18                	jbe    8037a9 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803791:	a1 30 50 80 00       	mov    0x805030,%eax
  803796:	83 ec 04             	sub    $0x4,%esp
  803799:	ff 75 08             	pushl  0x8(%ebp)
  80379c:	50                   	push   %eax
  80379d:	6a 00                	push   $0x0
  80379f:	e8 8d fb ff ff       	call   803331 <merging>
  8037a4:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037a7:	eb 69                	jmp    803812 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8037a9:	a1 30 50 80 00       	mov    0x805030,%eax
  8037ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037b1:	eb 39                	jmp    8037ec <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8037b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037b9:	73 29                	jae    8037e4 <free_block+0x90>
  8037bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037be:	8b 00                	mov    (%eax),%eax
  8037c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037c3:	76 1f                	jbe    8037e4 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8037c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c8:	8b 00                	mov    (%eax),%eax
  8037ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8037cd:	83 ec 04             	sub    $0x4,%esp
  8037d0:	ff 75 08             	pushl  0x8(%ebp)
  8037d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8037d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8037d9:	e8 53 fb ff ff       	call   803331 <merging>
  8037de:	83 c4 10             	add    $0x10,%esp
			break;
  8037e1:	90                   	nop
		}
	}
}
  8037e2:	eb 2e                	jmp    803812 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8037e4:	a1 38 50 80 00       	mov    0x805038,%eax
  8037e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f0:	74 07                	je     8037f9 <free_block+0xa5>
  8037f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f5:	8b 00                	mov    (%eax),%eax
  8037f7:	eb 05                	jmp    8037fe <free_block+0xaa>
  8037f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037fe:	a3 38 50 80 00       	mov    %eax,0x805038
  803803:	a1 38 50 80 00       	mov    0x805038,%eax
  803808:	85 c0                	test   %eax,%eax
  80380a:	75 a7                	jne    8037b3 <free_block+0x5f>
  80380c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803810:	75 a1                	jne    8037b3 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803812:	90                   	nop
  803813:	c9                   	leave  
  803814:	c3                   	ret    

00803815 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803815:	55                   	push   %ebp
  803816:	89 e5                	mov    %esp,%ebp
  803818:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80381b:	ff 75 08             	pushl  0x8(%ebp)
  80381e:	e8 ed ec ff ff       	call   802510 <get_block_size>
  803823:	83 c4 04             	add    $0x4,%esp
  803826:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803829:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803830:	eb 17                	jmp    803849 <copy_data+0x34>
  803832:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803835:	8b 45 0c             	mov    0xc(%ebp),%eax
  803838:	01 c2                	add    %eax,%edx
  80383a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80383d:	8b 45 08             	mov    0x8(%ebp),%eax
  803840:	01 c8                	add    %ecx,%eax
  803842:	8a 00                	mov    (%eax),%al
  803844:	88 02                	mov    %al,(%edx)
  803846:	ff 45 fc             	incl   -0x4(%ebp)
  803849:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80384c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80384f:	72 e1                	jb     803832 <copy_data+0x1d>
}
  803851:	90                   	nop
  803852:	c9                   	leave  
  803853:	c3                   	ret    

00803854 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803854:	55                   	push   %ebp
  803855:	89 e5                	mov    %esp,%ebp
  803857:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80385a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80385e:	75 23                	jne    803883 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803860:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803864:	74 13                	je     803879 <realloc_block_FF+0x25>
  803866:	83 ec 0c             	sub    $0xc,%esp
  803869:	ff 75 0c             	pushl  0xc(%ebp)
  80386c:	e8 1f f0 ff ff       	call   802890 <alloc_block_FF>
  803871:	83 c4 10             	add    $0x10,%esp
  803874:	e9 f4 06 00 00       	jmp    803f6d <realloc_block_FF+0x719>
		return NULL;
  803879:	b8 00 00 00 00       	mov    $0x0,%eax
  80387e:	e9 ea 06 00 00       	jmp    803f6d <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803883:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803887:	75 18                	jne    8038a1 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803889:	83 ec 0c             	sub    $0xc,%esp
  80388c:	ff 75 08             	pushl  0x8(%ebp)
  80388f:	e8 c0 fe ff ff       	call   803754 <free_block>
  803894:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803897:	b8 00 00 00 00       	mov    $0x0,%eax
  80389c:	e9 cc 06 00 00       	jmp    803f6d <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8038a1:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8038a5:	77 07                	ja     8038ae <realloc_block_FF+0x5a>
  8038a7:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8038ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b1:	83 e0 01             	and    $0x1,%eax
  8038b4:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8038b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038ba:	83 c0 08             	add    $0x8,%eax
  8038bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8038c0:	83 ec 0c             	sub    $0xc,%esp
  8038c3:	ff 75 08             	pushl  0x8(%ebp)
  8038c6:	e8 45 ec ff ff       	call   802510 <get_block_size>
  8038cb:	83 c4 10             	add    $0x10,%esp
  8038ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8038d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038d4:	83 e8 08             	sub    $0x8,%eax
  8038d7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8038da:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dd:	83 e8 04             	sub    $0x4,%eax
  8038e0:	8b 00                	mov    (%eax),%eax
  8038e2:	83 e0 fe             	and    $0xfffffffe,%eax
  8038e5:	89 c2                	mov    %eax,%edx
  8038e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ea:	01 d0                	add    %edx,%eax
  8038ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8038ef:	83 ec 0c             	sub    $0xc,%esp
  8038f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038f5:	e8 16 ec ff ff       	call   802510 <get_block_size>
  8038fa:	83 c4 10             	add    $0x10,%esp
  8038fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803903:	83 e8 08             	sub    $0x8,%eax
  803906:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803909:	8b 45 0c             	mov    0xc(%ebp),%eax
  80390c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80390f:	75 08                	jne    803919 <realloc_block_FF+0xc5>
	{
		 return va;
  803911:	8b 45 08             	mov    0x8(%ebp),%eax
  803914:	e9 54 06 00 00       	jmp    803f6d <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803919:	8b 45 0c             	mov    0xc(%ebp),%eax
  80391c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80391f:	0f 83 e5 03 00 00    	jae    803d0a <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803925:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803928:	2b 45 0c             	sub    0xc(%ebp),%eax
  80392b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80392e:	83 ec 0c             	sub    $0xc,%esp
  803931:	ff 75 e4             	pushl  -0x1c(%ebp)
  803934:	e8 f0 eb ff ff       	call   802529 <is_free_block>
  803939:	83 c4 10             	add    $0x10,%esp
  80393c:	84 c0                	test   %al,%al
  80393e:	0f 84 3b 01 00 00    	je     803a7f <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803944:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803947:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80394a:	01 d0                	add    %edx,%eax
  80394c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80394f:	83 ec 04             	sub    $0x4,%esp
  803952:	6a 01                	push   $0x1
  803954:	ff 75 f0             	pushl  -0x10(%ebp)
  803957:	ff 75 08             	pushl  0x8(%ebp)
  80395a:	e8 02 ef ff ff       	call   802861 <set_block_data>
  80395f:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803962:	8b 45 08             	mov    0x8(%ebp),%eax
  803965:	83 e8 04             	sub    $0x4,%eax
  803968:	8b 00                	mov    (%eax),%eax
  80396a:	83 e0 fe             	and    $0xfffffffe,%eax
  80396d:	89 c2                	mov    %eax,%edx
  80396f:	8b 45 08             	mov    0x8(%ebp),%eax
  803972:	01 d0                	add    %edx,%eax
  803974:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803977:	83 ec 04             	sub    $0x4,%esp
  80397a:	6a 00                	push   $0x0
  80397c:	ff 75 cc             	pushl  -0x34(%ebp)
  80397f:	ff 75 c8             	pushl  -0x38(%ebp)
  803982:	e8 da ee ff ff       	call   802861 <set_block_data>
  803987:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80398a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80398e:	74 06                	je     803996 <realloc_block_FF+0x142>
  803990:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803994:	75 17                	jne    8039ad <realloc_block_FF+0x159>
  803996:	83 ec 04             	sub    $0x4,%esp
  803999:	68 b0 4b 80 00       	push   $0x804bb0
  80399e:	68 f6 01 00 00       	push   $0x1f6
  8039a3:	68 3d 4b 80 00       	push   $0x804b3d
  8039a8:	e8 03 ce ff ff       	call   8007b0 <_panic>
  8039ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b0:	8b 10                	mov    (%eax),%edx
  8039b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039b5:	89 10                	mov    %edx,(%eax)
  8039b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039ba:	8b 00                	mov    (%eax),%eax
  8039bc:	85 c0                	test   %eax,%eax
  8039be:	74 0b                	je     8039cb <realloc_block_FF+0x177>
  8039c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c3:	8b 00                	mov    (%eax),%eax
  8039c5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039c8:	89 50 04             	mov    %edx,0x4(%eax)
  8039cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ce:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039d1:	89 10                	mov    %edx,(%eax)
  8039d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039d9:	89 50 04             	mov    %edx,0x4(%eax)
  8039dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039df:	8b 00                	mov    (%eax),%eax
  8039e1:	85 c0                	test   %eax,%eax
  8039e3:	75 08                	jne    8039ed <realloc_block_FF+0x199>
  8039e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039e8:	a3 34 50 80 00       	mov    %eax,0x805034
  8039ed:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039f2:	40                   	inc    %eax
  8039f3:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8039f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039fc:	75 17                	jne    803a15 <realloc_block_FF+0x1c1>
  8039fe:	83 ec 04             	sub    $0x4,%esp
  803a01:	68 1f 4b 80 00       	push   $0x804b1f
  803a06:	68 f7 01 00 00       	push   $0x1f7
  803a0b:	68 3d 4b 80 00       	push   $0x804b3d
  803a10:	e8 9b cd ff ff       	call   8007b0 <_panic>
  803a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a18:	8b 00                	mov    (%eax),%eax
  803a1a:	85 c0                	test   %eax,%eax
  803a1c:	74 10                	je     803a2e <realloc_block_FF+0x1da>
  803a1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a21:	8b 00                	mov    (%eax),%eax
  803a23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a26:	8b 52 04             	mov    0x4(%edx),%edx
  803a29:	89 50 04             	mov    %edx,0x4(%eax)
  803a2c:	eb 0b                	jmp    803a39 <realloc_block_FF+0x1e5>
  803a2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a31:	8b 40 04             	mov    0x4(%eax),%eax
  803a34:	a3 34 50 80 00       	mov    %eax,0x805034
  803a39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3c:	8b 40 04             	mov    0x4(%eax),%eax
  803a3f:	85 c0                	test   %eax,%eax
  803a41:	74 0f                	je     803a52 <realloc_block_FF+0x1fe>
  803a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a46:	8b 40 04             	mov    0x4(%eax),%eax
  803a49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a4c:	8b 12                	mov    (%edx),%edx
  803a4e:	89 10                	mov    %edx,(%eax)
  803a50:	eb 0a                	jmp    803a5c <realloc_block_FF+0x208>
  803a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a55:	8b 00                	mov    (%eax),%eax
  803a57:	a3 30 50 80 00       	mov    %eax,0x805030
  803a5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a6f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a74:	48                   	dec    %eax
  803a75:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a7a:	e9 83 02 00 00       	jmp    803d02 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803a7f:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803a83:	0f 86 69 02 00 00    	jbe    803cf2 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803a89:	83 ec 04             	sub    $0x4,%esp
  803a8c:	6a 01                	push   $0x1
  803a8e:	ff 75 f0             	pushl  -0x10(%ebp)
  803a91:	ff 75 08             	pushl  0x8(%ebp)
  803a94:	e8 c8 ed ff ff       	call   802861 <set_block_data>
  803a99:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9f:	83 e8 04             	sub    $0x4,%eax
  803aa2:	8b 00                	mov    (%eax),%eax
  803aa4:	83 e0 fe             	and    $0xfffffffe,%eax
  803aa7:	89 c2                	mov    %eax,%edx
  803aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  803aac:	01 d0                	add    %edx,%eax
  803aae:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803ab1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ab6:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803ab9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803abd:	75 68                	jne    803b27 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803abf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ac3:	75 17                	jne    803adc <realloc_block_FF+0x288>
  803ac5:	83 ec 04             	sub    $0x4,%esp
  803ac8:	68 58 4b 80 00       	push   $0x804b58
  803acd:	68 06 02 00 00       	push   $0x206
  803ad2:	68 3d 4b 80 00       	push   $0x804b3d
  803ad7:	e8 d4 cc ff ff       	call   8007b0 <_panic>
  803adc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803ae2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae5:	89 10                	mov    %edx,(%eax)
  803ae7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aea:	8b 00                	mov    (%eax),%eax
  803aec:	85 c0                	test   %eax,%eax
  803aee:	74 0d                	je     803afd <realloc_block_FF+0x2a9>
  803af0:	a1 30 50 80 00       	mov    0x805030,%eax
  803af5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803af8:	89 50 04             	mov    %edx,0x4(%eax)
  803afb:	eb 08                	jmp    803b05 <realloc_block_FF+0x2b1>
  803afd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b00:	a3 34 50 80 00       	mov    %eax,0x805034
  803b05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b08:	a3 30 50 80 00       	mov    %eax,0x805030
  803b0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b17:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b1c:	40                   	inc    %eax
  803b1d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b22:	e9 b0 01 00 00       	jmp    803cd7 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803b27:	a1 30 50 80 00       	mov    0x805030,%eax
  803b2c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b2f:	76 68                	jbe    803b99 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b31:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b35:	75 17                	jne    803b4e <realloc_block_FF+0x2fa>
  803b37:	83 ec 04             	sub    $0x4,%esp
  803b3a:	68 58 4b 80 00       	push   $0x804b58
  803b3f:	68 0b 02 00 00       	push   $0x20b
  803b44:	68 3d 4b 80 00       	push   $0x804b3d
  803b49:	e8 62 cc ff ff       	call   8007b0 <_panic>
  803b4e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b57:	89 10                	mov    %edx,(%eax)
  803b59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b5c:	8b 00                	mov    (%eax),%eax
  803b5e:	85 c0                	test   %eax,%eax
  803b60:	74 0d                	je     803b6f <realloc_block_FF+0x31b>
  803b62:	a1 30 50 80 00       	mov    0x805030,%eax
  803b67:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b6a:	89 50 04             	mov    %edx,0x4(%eax)
  803b6d:	eb 08                	jmp    803b77 <realloc_block_FF+0x323>
  803b6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b72:	a3 34 50 80 00       	mov    %eax,0x805034
  803b77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b7a:	a3 30 50 80 00       	mov    %eax,0x805030
  803b7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b89:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b8e:	40                   	inc    %eax
  803b8f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b94:	e9 3e 01 00 00       	jmp    803cd7 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803b99:	a1 30 50 80 00       	mov    0x805030,%eax
  803b9e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ba1:	73 68                	jae    803c0b <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ba3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ba7:	75 17                	jne    803bc0 <realloc_block_FF+0x36c>
  803ba9:	83 ec 04             	sub    $0x4,%esp
  803bac:	68 8c 4b 80 00       	push   $0x804b8c
  803bb1:	68 10 02 00 00       	push   $0x210
  803bb6:	68 3d 4b 80 00       	push   $0x804b3d
  803bbb:	e8 f0 cb ff ff       	call   8007b0 <_panic>
  803bc0:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803bc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc9:	89 50 04             	mov    %edx,0x4(%eax)
  803bcc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bcf:	8b 40 04             	mov    0x4(%eax),%eax
  803bd2:	85 c0                	test   %eax,%eax
  803bd4:	74 0c                	je     803be2 <realloc_block_FF+0x38e>
  803bd6:	a1 34 50 80 00       	mov    0x805034,%eax
  803bdb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bde:	89 10                	mov    %edx,(%eax)
  803be0:	eb 08                	jmp    803bea <realloc_block_FF+0x396>
  803be2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be5:	a3 30 50 80 00       	mov    %eax,0x805030
  803bea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bed:	a3 34 50 80 00       	mov    %eax,0x805034
  803bf2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bf5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bfb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c00:	40                   	inc    %eax
  803c01:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c06:	e9 cc 00 00 00       	jmp    803cd7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803c0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803c12:	a1 30 50 80 00       	mov    0x805030,%eax
  803c17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c1a:	e9 8a 00 00 00       	jmp    803ca9 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c22:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c25:	73 7a                	jae    803ca1 <realloc_block_FF+0x44d>
  803c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2a:	8b 00                	mov    (%eax),%eax
  803c2c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c2f:	73 70                	jae    803ca1 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803c31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c35:	74 06                	je     803c3d <realloc_block_FF+0x3e9>
  803c37:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c3b:	75 17                	jne    803c54 <realloc_block_FF+0x400>
  803c3d:	83 ec 04             	sub    $0x4,%esp
  803c40:	68 b0 4b 80 00       	push   $0x804bb0
  803c45:	68 1a 02 00 00       	push   $0x21a
  803c4a:	68 3d 4b 80 00       	push   $0x804b3d
  803c4f:	e8 5c cb ff ff       	call   8007b0 <_panic>
  803c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c57:	8b 10                	mov    (%eax),%edx
  803c59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c5c:	89 10                	mov    %edx,(%eax)
  803c5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c61:	8b 00                	mov    (%eax),%eax
  803c63:	85 c0                	test   %eax,%eax
  803c65:	74 0b                	je     803c72 <realloc_block_FF+0x41e>
  803c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c6a:	8b 00                	mov    (%eax),%eax
  803c6c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c6f:	89 50 04             	mov    %edx,0x4(%eax)
  803c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c75:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c78:	89 10                	mov    %edx,(%eax)
  803c7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c80:	89 50 04             	mov    %edx,0x4(%eax)
  803c83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c86:	8b 00                	mov    (%eax),%eax
  803c88:	85 c0                	test   %eax,%eax
  803c8a:	75 08                	jne    803c94 <realloc_block_FF+0x440>
  803c8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c8f:	a3 34 50 80 00       	mov    %eax,0x805034
  803c94:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c99:	40                   	inc    %eax
  803c9a:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803c9f:	eb 36                	jmp    803cd7 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803ca1:	a1 38 50 80 00       	mov    0x805038,%eax
  803ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ca9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cad:	74 07                	je     803cb6 <realloc_block_FF+0x462>
  803caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb2:	8b 00                	mov    (%eax),%eax
  803cb4:	eb 05                	jmp    803cbb <realloc_block_FF+0x467>
  803cb6:	b8 00 00 00 00       	mov    $0x0,%eax
  803cbb:	a3 38 50 80 00       	mov    %eax,0x805038
  803cc0:	a1 38 50 80 00       	mov    0x805038,%eax
  803cc5:	85 c0                	test   %eax,%eax
  803cc7:	0f 85 52 ff ff ff    	jne    803c1f <realloc_block_FF+0x3cb>
  803ccd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cd1:	0f 85 48 ff ff ff    	jne    803c1f <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803cd7:	83 ec 04             	sub    $0x4,%esp
  803cda:	6a 00                	push   $0x0
  803cdc:	ff 75 d8             	pushl  -0x28(%ebp)
  803cdf:	ff 75 d4             	pushl  -0x2c(%ebp)
  803ce2:	e8 7a eb ff ff       	call   802861 <set_block_data>
  803ce7:	83 c4 10             	add    $0x10,%esp
				return va;
  803cea:	8b 45 08             	mov    0x8(%ebp),%eax
  803ced:	e9 7b 02 00 00       	jmp    803f6d <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803cf2:	83 ec 0c             	sub    $0xc,%esp
  803cf5:	68 2d 4c 80 00       	push   $0x804c2d
  803cfa:	e8 6e cd ff ff       	call   800a6d <cprintf>
  803cff:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803d02:	8b 45 08             	mov    0x8(%ebp),%eax
  803d05:	e9 63 02 00 00       	jmp    803f6d <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d0d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d10:	0f 86 4d 02 00 00    	jbe    803f63 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803d16:	83 ec 0c             	sub    $0xc,%esp
  803d19:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d1c:	e8 08 e8 ff ff       	call   802529 <is_free_block>
  803d21:	83 c4 10             	add    $0x10,%esp
  803d24:	84 c0                	test   %al,%al
  803d26:	0f 84 37 02 00 00    	je     803f63 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d2f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803d35:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d38:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d3b:	76 38                	jbe    803d75 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803d3d:	83 ec 0c             	sub    $0xc,%esp
  803d40:	ff 75 08             	pushl  0x8(%ebp)
  803d43:	e8 0c fa ff ff       	call   803754 <free_block>
  803d48:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803d4b:	83 ec 0c             	sub    $0xc,%esp
  803d4e:	ff 75 0c             	pushl  0xc(%ebp)
  803d51:	e8 3a eb ff ff       	call   802890 <alloc_block_FF>
  803d56:	83 c4 10             	add    $0x10,%esp
  803d59:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803d5c:	83 ec 08             	sub    $0x8,%esp
  803d5f:	ff 75 c0             	pushl  -0x40(%ebp)
  803d62:	ff 75 08             	pushl  0x8(%ebp)
  803d65:	e8 ab fa ff ff       	call   803815 <copy_data>
  803d6a:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803d6d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803d70:	e9 f8 01 00 00       	jmp    803f6d <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803d75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d78:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803d7b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803d7e:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803d82:	0f 87 a0 00 00 00    	ja     803e28 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803d88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d8c:	75 17                	jne    803da5 <realloc_block_FF+0x551>
  803d8e:	83 ec 04             	sub    $0x4,%esp
  803d91:	68 1f 4b 80 00       	push   $0x804b1f
  803d96:	68 38 02 00 00       	push   $0x238
  803d9b:	68 3d 4b 80 00       	push   $0x804b3d
  803da0:	e8 0b ca ff ff       	call   8007b0 <_panic>
  803da5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da8:	8b 00                	mov    (%eax),%eax
  803daa:	85 c0                	test   %eax,%eax
  803dac:	74 10                	je     803dbe <realloc_block_FF+0x56a>
  803dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db1:	8b 00                	mov    (%eax),%eax
  803db3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803db6:	8b 52 04             	mov    0x4(%edx),%edx
  803db9:	89 50 04             	mov    %edx,0x4(%eax)
  803dbc:	eb 0b                	jmp    803dc9 <realloc_block_FF+0x575>
  803dbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc1:	8b 40 04             	mov    0x4(%eax),%eax
  803dc4:	a3 34 50 80 00       	mov    %eax,0x805034
  803dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dcc:	8b 40 04             	mov    0x4(%eax),%eax
  803dcf:	85 c0                	test   %eax,%eax
  803dd1:	74 0f                	je     803de2 <realloc_block_FF+0x58e>
  803dd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd6:	8b 40 04             	mov    0x4(%eax),%eax
  803dd9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ddc:	8b 12                	mov    (%edx),%edx
  803dde:	89 10                	mov    %edx,(%eax)
  803de0:	eb 0a                	jmp    803dec <realloc_block_FF+0x598>
  803de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de5:	8b 00                	mov    (%eax),%eax
  803de7:	a3 30 50 80 00       	mov    %eax,0x805030
  803dec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803def:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803df5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dff:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e04:	48                   	dec    %eax
  803e05:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803e0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e10:	01 d0                	add    %edx,%eax
  803e12:	83 ec 04             	sub    $0x4,%esp
  803e15:	6a 01                	push   $0x1
  803e17:	50                   	push   %eax
  803e18:	ff 75 08             	pushl  0x8(%ebp)
  803e1b:	e8 41 ea ff ff       	call   802861 <set_block_data>
  803e20:	83 c4 10             	add    $0x10,%esp
  803e23:	e9 36 01 00 00       	jmp    803f5e <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803e28:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e2b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e2e:	01 d0                	add    %edx,%eax
  803e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803e33:	83 ec 04             	sub    $0x4,%esp
  803e36:	6a 01                	push   $0x1
  803e38:	ff 75 f0             	pushl  -0x10(%ebp)
  803e3b:	ff 75 08             	pushl  0x8(%ebp)
  803e3e:	e8 1e ea ff ff       	call   802861 <set_block_data>
  803e43:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803e46:	8b 45 08             	mov    0x8(%ebp),%eax
  803e49:	83 e8 04             	sub    $0x4,%eax
  803e4c:	8b 00                	mov    (%eax),%eax
  803e4e:	83 e0 fe             	and    $0xfffffffe,%eax
  803e51:	89 c2                	mov    %eax,%edx
  803e53:	8b 45 08             	mov    0x8(%ebp),%eax
  803e56:	01 d0                	add    %edx,%eax
  803e58:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803e5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e5f:	74 06                	je     803e67 <realloc_block_FF+0x613>
  803e61:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803e65:	75 17                	jne    803e7e <realloc_block_FF+0x62a>
  803e67:	83 ec 04             	sub    $0x4,%esp
  803e6a:	68 b0 4b 80 00       	push   $0x804bb0
  803e6f:	68 44 02 00 00       	push   $0x244
  803e74:	68 3d 4b 80 00       	push   $0x804b3d
  803e79:	e8 32 c9 ff ff       	call   8007b0 <_panic>
  803e7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e81:	8b 10                	mov    (%eax),%edx
  803e83:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e86:	89 10                	mov    %edx,(%eax)
  803e88:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e8b:	8b 00                	mov    (%eax),%eax
  803e8d:	85 c0                	test   %eax,%eax
  803e8f:	74 0b                	je     803e9c <realloc_block_FF+0x648>
  803e91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e94:	8b 00                	mov    (%eax),%eax
  803e96:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e99:	89 50 04             	mov    %edx,0x4(%eax)
  803e9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e9f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ea2:	89 10                	mov    %edx,(%eax)
  803ea4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ea7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803eaa:	89 50 04             	mov    %edx,0x4(%eax)
  803ead:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803eb0:	8b 00                	mov    (%eax),%eax
  803eb2:	85 c0                	test   %eax,%eax
  803eb4:	75 08                	jne    803ebe <realloc_block_FF+0x66a>
  803eb6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803eb9:	a3 34 50 80 00       	mov    %eax,0x805034
  803ebe:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ec3:	40                   	inc    %eax
  803ec4:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ec9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ecd:	75 17                	jne    803ee6 <realloc_block_FF+0x692>
  803ecf:	83 ec 04             	sub    $0x4,%esp
  803ed2:	68 1f 4b 80 00       	push   $0x804b1f
  803ed7:	68 45 02 00 00       	push   $0x245
  803edc:	68 3d 4b 80 00       	push   $0x804b3d
  803ee1:	e8 ca c8 ff ff       	call   8007b0 <_panic>
  803ee6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee9:	8b 00                	mov    (%eax),%eax
  803eeb:	85 c0                	test   %eax,%eax
  803eed:	74 10                	je     803eff <realloc_block_FF+0x6ab>
  803eef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef2:	8b 00                	mov    (%eax),%eax
  803ef4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ef7:	8b 52 04             	mov    0x4(%edx),%edx
  803efa:	89 50 04             	mov    %edx,0x4(%eax)
  803efd:	eb 0b                	jmp    803f0a <realloc_block_FF+0x6b6>
  803eff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f02:	8b 40 04             	mov    0x4(%eax),%eax
  803f05:	a3 34 50 80 00       	mov    %eax,0x805034
  803f0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f0d:	8b 40 04             	mov    0x4(%eax),%eax
  803f10:	85 c0                	test   %eax,%eax
  803f12:	74 0f                	je     803f23 <realloc_block_FF+0x6cf>
  803f14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f17:	8b 40 04             	mov    0x4(%eax),%eax
  803f1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f1d:	8b 12                	mov    (%edx),%edx
  803f1f:	89 10                	mov    %edx,(%eax)
  803f21:	eb 0a                	jmp    803f2d <realloc_block_FF+0x6d9>
  803f23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f26:	8b 00                	mov    (%eax),%eax
  803f28:	a3 30 50 80 00       	mov    %eax,0x805030
  803f2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f40:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f45:	48                   	dec    %eax
  803f46:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803f4b:	83 ec 04             	sub    $0x4,%esp
  803f4e:	6a 00                	push   $0x0
  803f50:	ff 75 bc             	pushl  -0x44(%ebp)
  803f53:	ff 75 b8             	pushl  -0x48(%ebp)
  803f56:	e8 06 e9 ff ff       	call   802861 <set_block_data>
  803f5b:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  803f61:	eb 0a                	jmp    803f6d <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803f63:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803f6a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803f6d:	c9                   	leave  
  803f6e:	c3                   	ret    

00803f6f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803f6f:	55                   	push   %ebp
  803f70:	89 e5                	mov    %esp,%ebp
  803f72:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803f75:	83 ec 04             	sub    $0x4,%esp
  803f78:	68 34 4c 80 00       	push   $0x804c34
  803f7d:	68 58 02 00 00       	push   $0x258
  803f82:	68 3d 4b 80 00       	push   $0x804b3d
  803f87:	e8 24 c8 ff ff       	call   8007b0 <_panic>

00803f8c <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803f8c:	55                   	push   %ebp
  803f8d:	89 e5                	mov    %esp,%ebp
  803f8f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803f92:	83 ec 04             	sub    $0x4,%esp
  803f95:	68 5c 4c 80 00       	push   $0x804c5c
  803f9a:	68 61 02 00 00       	push   $0x261
  803f9f:	68 3d 4b 80 00       	push   $0x804b3d
  803fa4:	e8 07 c8 ff ff       	call   8007b0 <_panic>

00803fa9 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803fa9:	55                   	push   %ebp
  803faa:	89 e5                	mov    %esp,%ebp
  803fac:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803faf:	83 ec 04             	sub    $0x4,%esp
  803fb2:	68 84 4c 80 00       	push   $0x804c84
  803fb7:	6a 09                	push   $0x9
  803fb9:	68 ac 4c 80 00       	push   $0x804cac
  803fbe:	e8 ed c7 ff ff       	call   8007b0 <_panic>

00803fc3 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803fc3:	55                   	push   %ebp
  803fc4:	89 e5                	mov    %esp,%ebp
  803fc6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803fc9:	83 ec 04             	sub    $0x4,%esp
  803fcc:	68 bc 4c 80 00       	push   $0x804cbc
  803fd1:	6a 10                	push   $0x10
  803fd3:	68 ac 4c 80 00       	push   $0x804cac
  803fd8:	e8 d3 c7 ff ff       	call   8007b0 <_panic>

00803fdd <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803fdd:	55                   	push   %ebp
  803fde:	89 e5                	mov    %esp,%ebp
  803fe0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803fe3:	83 ec 04             	sub    $0x4,%esp
  803fe6:	68 e4 4c 80 00       	push   $0x804ce4
  803feb:	6a 18                	push   $0x18
  803fed:	68 ac 4c 80 00       	push   $0x804cac
  803ff2:	e8 b9 c7 ff ff       	call   8007b0 <_panic>

00803ff7 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803ff7:	55                   	push   %ebp
  803ff8:	89 e5                	mov    %esp,%ebp
  803ffa:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803ffd:	83 ec 04             	sub    $0x4,%esp
  804000:	68 0c 4d 80 00       	push   $0x804d0c
  804005:	6a 20                	push   $0x20
  804007:	68 ac 4c 80 00       	push   $0x804cac
  80400c:	e8 9f c7 ff ff       	call   8007b0 <_panic>

00804011 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  804011:	55                   	push   %ebp
  804012:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  804014:	8b 45 08             	mov    0x8(%ebp),%eax
  804017:	8b 40 10             	mov    0x10(%eax),%eax
}
  80401a:	5d                   	pop    %ebp
  80401b:	c3                   	ret    

0080401c <__udivdi3>:
  80401c:	55                   	push   %ebp
  80401d:	57                   	push   %edi
  80401e:	56                   	push   %esi
  80401f:	53                   	push   %ebx
  804020:	83 ec 1c             	sub    $0x1c,%esp
  804023:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804027:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80402b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80402f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804033:	89 ca                	mov    %ecx,%edx
  804035:	89 f8                	mov    %edi,%eax
  804037:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80403b:	85 f6                	test   %esi,%esi
  80403d:	75 2d                	jne    80406c <__udivdi3+0x50>
  80403f:	39 cf                	cmp    %ecx,%edi
  804041:	77 65                	ja     8040a8 <__udivdi3+0x8c>
  804043:	89 fd                	mov    %edi,%ebp
  804045:	85 ff                	test   %edi,%edi
  804047:	75 0b                	jne    804054 <__udivdi3+0x38>
  804049:	b8 01 00 00 00       	mov    $0x1,%eax
  80404e:	31 d2                	xor    %edx,%edx
  804050:	f7 f7                	div    %edi
  804052:	89 c5                	mov    %eax,%ebp
  804054:	31 d2                	xor    %edx,%edx
  804056:	89 c8                	mov    %ecx,%eax
  804058:	f7 f5                	div    %ebp
  80405a:	89 c1                	mov    %eax,%ecx
  80405c:	89 d8                	mov    %ebx,%eax
  80405e:	f7 f5                	div    %ebp
  804060:	89 cf                	mov    %ecx,%edi
  804062:	89 fa                	mov    %edi,%edx
  804064:	83 c4 1c             	add    $0x1c,%esp
  804067:	5b                   	pop    %ebx
  804068:	5e                   	pop    %esi
  804069:	5f                   	pop    %edi
  80406a:	5d                   	pop    %ebp
  80406b:	c3                   	ret    
  80406c:	39 ce                	cmp    %ecx,%esi
  80406e:	77 28                	ja     804098 <__udivdi3+0x7c>
  804070:	0f bd fe             	bsr    %esi,%edi
  804073:	83 f7 1f             	xor    $0x1f,%edi
  804076:	75 40                	jne    8040b8 <__udivdi3+0x9c>
  804078:	39 ce                	cmp    %ecx,%esi
  80407a:	72 0a                	jb     804086 <__udivdi3+0x6a>
  80407c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804080:	0f 87 9e 00 00 00    	ja     804124 <__udivdi3+0x108>
  804086:	b8 01 00 00 00       	mov    $0x1,%eax
  80408b:	89 fa                	mov    %edi,%edx
  80408d:	83 c4 1c             	add    $0x1c,%esp
  804090:	5b                   	pop    %ebx
  804091:	5e                   	pop    %esi
  804092:	5f                   	pop    %edi
  804093:	5d                   	pop    %ebp
  804094:	c3                   	ret    
  804095:	8d 76 00             	lea    0x0(%esi),%esi
  804098:	31 ff                	xor    %edi,%edi
  80409a:	31 c0                	xor    %eax,%eax
  80409c:	89 fa                	mov    %edi,%edx
  80409e:	83 c4 1c             	add    $0x1c,%esp
  8040a1:	5b                   	pop    %ebx
  8040a2:	5e                   	pop    %esi
  8040a3:	5f                   	pop    %edi
  8040a4:	5d                   	pop    %ebp
  8040a5:	c3                   	ret    
  8040a6:	66 90                	xchg   %ax,%ax
  8040a8:	89 d8                	mov    %ebx,%eax
  8040aa:	f7 f7                	div    %edi
  8040ac:	31 ff                	xor    %edi,%edi
  8040ae:	89 fa                	mov    %edi,%edx
  8040b0:	83 c4 1c             	add    $0x1c,%esp
  8040b3:	5b                   	pop    %ebx
  8040b4:	5e                   	pop    %esi
  8040b5:	5f                   	pop    %edi
  8040b6:	5d                   	pop    %ebp
  8040b7:	c3                   	ret    
  8040b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040bd:	89 eb                	mov    %ebp,%ebx
  8040bf:	29 fb                	sub    %edi,%ebx
  8040c1:	89 f9                	mov    %edi,%ecx
  8040c3:	d3 e6                	shl    %cl,%esi
  8040c5:	89 c5                	mov    %eax,%ebp
  8040c7:	88 d9                	mov    %bl,%cl
  8040c9:	d3 ed                	shr    %cl,%ebp
  8040cb:	89 e9                	mov    %ebp,%ecx
  8040cd:	09 f1                	or     %esi,%ecx
  8040cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040d3:	89 f9                	mov    %edi,%ecx
  8040d5:	d3 e0                	shl    %cl,%eax
  8040d7:	89 c5                	mov    %eax,%ebp
  8040d9:	89 d6                	mov    %edx,%esi
  8040db:	88 d9                	mov    %bl,%cl
  8040dd:	d3 ee                	shr    %cl,%esi
  8040df:	89 f9                	mov    %edi,%ecx
  8040e1:	d3 e2                	shl    %cl,%edx
  8040e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040e7:	88 d9                	mov    %bl,%cl
  8040e9:	d3 e8                	shr    %cl,%eax
  8040eb:	09 c2                	or     %eax,%edx
  8040ed:	89 d0                	mov    %edx,%eax
  8040ef:	89 f2                	mov    %esi,%edx
  8040f1:	f7 74 24 0c          	divl   0xc(%esp)
  8040f5:	89 d6                	mov    %edx,%esi
  8040f7:	89 c3                	mov    %eax,%ebx
  8040f9:	f7 e5                	mul    %ebp
  8040fb:	39 d6                	cmp    %edx,%esi
  8040fd:	72 19                	jb     804118 <__udivdi3+0xfc>
  8040ff:	74 0b                	je     80410c <__udivdi3+0xf0>
  804101:	89 d8                	mov    %ebx,%eax
  804103:	31 ff                	xor    %edi,%edi
  804105:	e9 58 ff ff ff       	jmp    804062 <__udivdi3+0x46>
  80410a:	66 90                	xchg   %ax,%ax
  80410c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804110:	89 f9                	mov    %edi,%ecx
  804112:	d3 e2                	shl    %cl,%edx
  804114:	39 c2                	cmp    %eax,%edx
  804116:	73 e9                	jae    804101 <__udivdi3+0xe5>
  804118:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80411b:	31 ff                	xor    %edi,%edi
  80411d:	e9 40 ff ff ff       	jmp    804062 <__udivdi3+0x46>
  804122:	66 90                	xchg   %ax,%ax
  804124:	31 c0                	xor    %eax,%eax
  804126:	e9 37 ff ff ff       	jmp    804062 <__udivdi3+0x46>
  80412b:	90                   	nop

0080412c <__umoddi3>:
  80412c:	55                   	push   %ebp
  80412d:	57                   	push   %edi
  80412e:	56                   	push   %esi
  80412f:	53                   	push   %ebx
  804130:	83 ec 1c             	sub    $0x1c,%esp
  804133:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804137:	8b 74 24 34          	mov    0x34(%esp),%esi
  80413b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80413f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804143:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804147:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80414b:	89 f3                	mov    %esi,%ebx
  80414d:	89 fa                	mov    %edi,%edx
  80414f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804153:	89 34 24             	mov    %esi,(%esp)
  804156:	85 c0                	test   %eax,%eax
  804158:	75 1a                	jne    804174 <__umoddi3+0x48>
  80415a:	39 f7                	cmp    %esi,%edi
  80415c:	0f 86 a2 00 00 00    	jbe    804204 <__umoddi3+0xd8>
  804162:	89 c8                	mov    %ecx,%eax
  804164:	89 f2                	mov    %esi,%edx
  804166:	f7 f7                	div    %edi
  804168:	89 d0                	mov    %edx,%eax
  80416a:	31 d2                	xor    %edx,%edx
  80416c:	83 c4 1c             	add    $0x1c,%esp
  80416f:	5b                   	pop    %ebx
  804170:	5e                   	pop    %esi
  804171:	5f                   	pop    %edi
  804172:	5d                   	pop    %ebp
  804173:	c3                   	ret    
  804174:	39 f0                	cmp    %esi,%eax
  804176:	0f 87 ac 00 00 00    	ja     804228 <__umoddi3+0xfc>
  80417c:	0f bd e8             	bsr    %eax,%ebp
  80417f:	83 f5 1f             	xor    $0x1f,%ebp
  804182:	0f 84 ac 00 00 00    	je     804234 <__umoddi3+0x108>
  804188:	bf 20 00 00 00       	mov    $0x20,%edi
  80418d:	29 ef                	sub    %ebp,%edi
  80418f:	89 fe                	mov    %edi,%esi
  804191:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804195:	89 e9                	mov    %ebp,%ecx
  804197:	d3 e0                	shl    %cl,%eax
  804199:	89 d7                	mov    %edx,%edi
  80419b:	89 f1                	mov    %esi,%ecx
  80419d:	d3 ef                	shr    %cl,%edi
  80419f:	09 c7                	or     %eax,%edi
  8041a1:	89 e9                	mov    %ebp,%ecx
  8041a3:	d3 e2                	shl    %cl,%edx
  8041a5:	89 14 24             	mov    %edx,(%esp)
  8041a8:	89 d8                	mov    %ebx,%eax
  8041aa:	d3 e0                	shl    %cl,%eax
  8041ac:	89 c2                	mov    %eax,%edx
  8041ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041b2:	d3 e0                	shl    %cl,%eax
  8041b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041bc:	89 f1                	mov    %esi,%ecx
  8041be:	d3 e8                	shr    %cl,%eax
  8041c0:	09 d0                	or     %edx,%eax
  8041c2:	d3 eb                	shr    %cl,%ebx
  8041c4:	89 da                	mov    %ebx,%edx
  8041c6:	f7 f7                	div    %edi
  8041c8:	89 d3                	mov    %edx,%ebx
  8041ca:	f7 24 24             	mull   (%esp)
  8041cd:	89 c6                	mov    %eax,%esi
  8041cf:	89 d1                	mov    %edx,%ecx
  8041d1:	39 d3                	cmp    %edx,%ebx
  8041d3:	0f 82 87 00 00 00    	jb     804260 <__umoddi3+0x134>
  8041d9:	0f 84 91 00 00 00    	je     804270 <__umoddi3+0x144>
  8041df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041e3:	29 f2                	sub    %esi,%edx
  8041e5:	19 cb                	sbb    %ecx,%ebx
  8041e7:	89 d8                	mov    %ebx,%eax
  8041e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041ed:	d3 e0                	shl    %cl,%eax
  8041ef:	89 e9                	mov    %ebp,%ecx
  8041f1:	d3 ea                	shr    %cl,%edx
  8041f3:	09 d0                	or     %edx,%eax
  8041f5:	89 e9                	mov    %ebp,%ecx
  8041f7:	d3 eb                	shr    %cl,%ebx
  8041f9:	89 da                	mov    %ebx,%edx
  8041fb:	83 c4 1c             	add    $0x1c,%esp
  8041fe:	5b                   	pop    %ebx
  8041ff:	5e                   	pop    %esi
  804200:	5f                   	pop    %edi
  804201:	5d                   	pop    %ebp
  804202:	c3                   	ret    
  804203:	90                   	nop
  804204:	89 fd                	mov    %edi,%ebp
  804206:	85 ff                	test   %edi,%edi
  804208:	75 0b                	jne    804215 <__umoddi3+0xe9>
  80420a:	b8 01 00 00 00       	mov    $0x1,%eax
  80420f:	31 d2                	xor    %edx,%edx
  804211:	f7 f7                	div    %edi
  804213:	89 c5                	mov    %eax,%ebp
  804215:	89 f0                	mov    %esi,%eax
  804217:	31 d2                	xor    %edx,%edx
  804219:	f7 f5                	div    %ebp
  80421b:	89 c8                	mov    %ecx,%eax
  80421d:	f7 f5                	div    %ebp
  80421f:	89 d0                	mov    %edx,%eax
  804221:	e9 44 ff ff ff       	jmp    80416a <__umoddi3+0x3e>
  804226:	66 90                	xchg   %ax,%ax
  804228:	89 c8                	mov    %ecx,%eax
  80422a:	89 f2                	mov    %esi,%edx
  80422c:	83 c4 1c             	add    $0x1c,%esp
  80422f:	5b                   	pop    %ebx
  804230:	5e                   	pop    %esi
  804231:	5f                   	pop    %edi
  804232:	5d                   	pop    %ebp
  804233:	c3                   	ret    
  804234:	3b 04 24             	cmp    (%esp),%eax
  804237:	72 06                	jb     80423f <__umoddi3+0x113>
  804239:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80423d:	77 0f                	ja     80424e <__umoddi3+0x122>
  80423f:	89 f2                	mov    %esi,%edx
  804241:	29 f9                	sub    %edi,%ecx
  804243:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804247:	89 14 24             	mov    %edx,(%esp)
  80424a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80424e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804252:	8b 14 24             	mov    (%esp),%edx
  804255:	83 c4 1c             	add    $0x1c,%esp
  804258:	5b                   	pop    %ebx
  804259:	5e                   	pop    %esi
  80425a:	5f                   	pop    %edi
  80425b:	5d                   	pop    %ebp
  80425c:	c3                   	ret    
  80425d:	8d 76 00             	lea    0x0(%esi),%esi
  804260:	2b 04 24             	sub    (%esp),%eax
  804263:	19 fa                	sbb    %edi,%edx
  804265:	89 d1                	mov    %edx,%ecx
  804267:	89 c6                	mov    %eax,%esi
  804269:	e9 71 ff ff ff       	jmp    8041df <__umoddi3+0xb3>
  80426e:	66 90                	xchg   %ax,%ax
  804270:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804274:	72 ea                	jb     804260 <__umoddi3+0x134>
  804276:	89 d9                	mov    %ebx,%ecx
  804278:	e9 62 ff ff ff       	jmp    8041df <__umoddi3+0xb3>
