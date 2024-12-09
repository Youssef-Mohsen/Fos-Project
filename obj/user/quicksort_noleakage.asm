
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 d6 05 00 00       	call   80060c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
		//2012: lock the interrupt
		//sys_lock_cons();
		//2024: lock the console only using a sleepLock
		int NumOfElements;
		int *Elements;
		sys_lock_cons();
  800041:	e8 04 1f 00 00       	call   801f4a <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 42 80 00       	push   $0x804280
  80004e:	e8 b5 09 00 00       	call   800a08 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 82 42 80 00       	push   $0x804282
  80005e:	e8 a5 09 00 00       	call   800a08 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 9b 42 80 00       	push   $0x80429b
  80006e:	e8 95 09 00 00       	call   800a08 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 82 42 80 00       	push   $0x804282
  80007e:	e8 85 09 00 00       	call   800a08 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 42 80 00       	push   $0x804280
  80008e:	e8 75 09 00 00       	call   800a08 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 b4 42 80 00       	push   $0x8042b4
  8000a5:	e8 f2 0f 00 00       	call   80109c <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 44 15 00 00       	call   801604 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 d4 42 80 00       	push   $0x8042d4
  8000ce:	e8 35 09 00 00       	call   800a08 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 f6 42 80 00       	push   $0x8042f6
  8000de:	e8 25 09 00 00       	call   800a08 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 04 43 80 00       	push   $0x804304
  8000ee:	e8 15 09 00 00       	call   800a08 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 13 43 80 00       	push   $0x804313
  8000fe:	e8 05 09 00 00       	call   800a08 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 23 43 80 00       	push   $0x804323
  80010e:	e8 f5 08 00 00       	call   800a08 <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800116:	e8 d4 04 00 00       	call   8005ef <getchar>
  80011b:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80011e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 a5 04 00 00       	call   8005d0 <cputchar>
  80012b:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	6a 0a                	push   $0xa
  800133:	e8 98 04 00 00       	call   8005d0 <cputchar>
  800138:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80013b:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80013f:	74 0c                	je     80014d <_main+0x115>
  800141:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800145:	74 06                	je     80014d <_main+0x115>
  800147:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  80014b:	75 b9                	jne    800106 <_main+0xce>
		}
		//2012: unlock
		sys_unlock_cons();
  80014d:	e8 12 1e 00 00       	call   801f64 <sys_unlock_cons>
		//sys_unlock_cons();

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 5f 18 00 00       	call   8019c0 <malloc>
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 03 03 00 00       	call   80048b <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 21 03 00 00       	call   8004bc <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 43 03 00 00       	call   8004f1 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 30 03 00 00       	call   8004f1 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 fe 00 00 00       	call   8002d0 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  8001d5:	e8 70 1d 00 00       	call   801f4a <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 2c 43 80 00       	push   $0x80432c
  8001e2:	e8 21 08 00 00       	call   800a08 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 75 1d 00 00       	call   801f64 <sys_unlock_cons>
		//sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 e4 01 00 00       	call   8003e1 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 60 43 80 00       	push   $0x804360
  800211:	6a 54                	push   $0x54
  800213:	68 82 43 80 00       	push   $0x804382
  800218:	e8 2e 05 00 00       	call   80074b <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 28 1d 00 00       	call   801f4a <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 a0 43 80 00       	push   $0x8043a0
  80022a:	e8 d9 07 00 00       	call   800a08 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 d4 43 80 00       	push   $0x8043d4
  80023a:	e8 c9 07 00 00       	call   800a08 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 08 44 80 00       	push   $0x804408
  80024a:	e8 b9 07 00 00       	call   800a08 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 0d 1d 00 00       	call   801f64 <sys_unlock_cons>
			//			sys_unlock_cons();


		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 ec             	pushl  -0x14(%ebp)
  80025d:	e8 7d 19 00 00       	call   801bdf <free>
  800262:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
  800265:	e8 e0 1c 00 00       	call   801f4a <sys_lock_cons>
		{
			Chose = 0 ;
  80026a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  80026e:	eb 42                	jmp    8002b2 <_main+0x27a>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 3a 44 80 00       	push   $0x80443a
  800278:	e8 8b 07 00 00       	call   800a08 <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800280:	e8 6a 03 00 00       	call   8005ef <getchar>
  800285:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800288:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 3b 03 00 00       	call   8005d0 <cputchar>
  800295:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	6a 0a                	push   $0xa
  80029d:	e8 2e 03 00 00       	call   8005d0 <cputchar>
  8002a2:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	6a 0a                	push   $0xa
  8002aa:	e8 21 03 00 00       	call   8005d0 <cputchar>
  8002af:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b2:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b6:	74 06                	je     8002be <_main+0x286>
  8002b8:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002bc:	75 b2                	jne    800270 <_main+0x238>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002be:	e8 a1 1c 00 00       	call   801f64 <sys_unlock_cons>
		//		sys_unlock_cons();

	} while (Chose == 'y');
  8002c3:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c7:	0f 84 74 fd ff ff    	je     800041 <_main+0x9>

}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d9:	48                   	dec    %eax
  8002da:	50                   	push   %eax
  8002db:	6a 00                	push   $0x0
  8002dd:	ff 75 0c             	pushl  0xc(%ebp)
  8002e0:	ff 75 08             	pushl  0x8(%ebp)
  8002e3:	e8 06 00 00 00       	call   8002ee <QSort>
  8002e8:	83 c4 10             	add    $0x10,%esp
}
  8002eb:	90                   	nop
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f7:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fa:	0f 8d de 00 00 00    	jge    8003de <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800300:	8b 45 10             	mov    0x10(%ebp),%eax
  800303:	40                   	inc    %eax
  800304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800307:	8b 45 14             	mov    0x14(%ebp),%eax
  80030a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  80030d:	e9 80 00 00 00       	jmp    800392 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800312:	ff 45 f4             	incl   -0xc(%ebp)
  800315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800318:	3b 45 14             	cmp    0x14(%ebp),%eax
  80031b:	7f 2b                	jg     800348 <QSort+0x5a>
  80031d:	8b 45 10             	mov    0x10(%ebp),%eax
  800320:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800327:	8b 45 08             	mov    0x8(%ebp),%eax
  80032a:	01 d0                	add    %edx,%eax
  80032c:	8b 10                	mov    (%eax),%edx
  80032e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800331:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800338:	8b 45 08             	mov    0x8(%ebp),%eax
  80033b:	01 c8                	add    %ecx,%eax
  80033d:	8b 00                	mov    (%eax),%eax
  80033f:	39 c2                	cmp    %eax,%edx
  800341:	7d cf                	jge    800312 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800343:	eb 03                	jmp    800348 <QSort+0x5a>
  800345:	ff 4d f0             	decl   -0x10(%ebp)
  800348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80034e:	7e 26                	jle    800376 <QSort+0x88>
  800350:	8b 45 10             	mov    0x10(%ebp),%eax
  800353:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80035a:	8b 45 08             	mov    0x8(%ebp),%eax
  80035d:	01 d0                	add    %edx,%eax
  80035f:	8b 10                	mov    (%eax),%edx
  800361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800364:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	01 c8                	add    %ecx,%eax
  800370:	8b 00                	mov    (%eax),%eax
  800372:	39 c2                	cmp    %eax,%edx
  800374:	7e cf                	jle    800345 <QSort+0x57>

		if (i <= j)
  800376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800379:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80037c:	7f 14                	jg     800392 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80037e:	83 ec 04             	sub    $0x4,%esp
  800381:	ff 75 f0             	pushl  -0x10(%ebp)
  800384:	ff 75 f4             	pushl  -0xc(%ebp)
  800387:	ff 75 08             	pushl  0x8(%ebp)
  80038a:	e8 a9 00 00 00       	call   800438 <Swap>
  80038f:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800395:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800398:	0f 8e 77 ff ff ff    	jle    800315 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80039e:	83 ec 04             	sub    $0x4,%esp
  8003a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a4:	ff 75 10             	pushl  0x10(%ebp)
  8003a7:	ff 75 08             	pushl  0x8(%ebp)
  8003aa:	e8 89 00 00 00       	call   800438 <Swap>
  8003af:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b5:	48                   	dec    %eax
  8003b6:	50                   	push   %eax
  8003b7:	ff 75 10             	pushl  0x10(%ebp)
  8003ba:	ff 75 0c             	pushl  0xc(%ebp)
  8003bd:	ff 75 08             	pushl  0x8(%ebp)
  8003c0:	e8 29 ff ff ff       	call   8002ee <QSort>
  8003c5:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003c8:	ff 75 14             	pushl  0x14(%ebp)
  8003cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ce:	ff 75 0c             	pushl  0xc(%ebp)
  8003d1:	ff 75 08             	pushl  0x8(%ebp)
  8003d4:	e8 15 ff ff ff       	call   8002ee <QSort>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	eb 01                	jmp    8003df <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003de:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003f5:	eb 33                	jmp    80042a <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	01 d0                	add    %edx,%eax
  800406:	8b 10                	mov    (%eax),%edx
  800408:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80040b:	40                   	inc    %eax
  80040c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	01 c8                	add    %ecx,%eax
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	39 c2                	cmp    %eax,%edx
  80041c:	7e 09                	jle    800427 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80041e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800425:	eb 0c                	jmp    800433 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800427:	ff 45 f8             	incl   -0x8(%ebp)
  80042a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042d:	48                   	dec    %eax
  80042e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800431:	7f c4                	jg     8003f7 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800433:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800436:	c9                   	leave  
  800437:	c3                   	ret    

00800438 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800438:	55                   	push   %ebp
  800439:	89 e5                	mov    %esp,%ebp
  80043b:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80043e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800452:	8b 45 0c             	mov    0xc(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 10             	mov    0x10(%ebp),%eax
  800464:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 c8                	add    %ecx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800474:	8b 45 10             	mov    0x10(%ebp),%eax
  800477:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	01 c2                	add    %eax,%edx
  800483:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800486:	89 02                	mov    %eax,(%edx)
}
  800488:	90                   	nop
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800498:	eb 17                	jmp    8004b1 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80049a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	01 c2                	add    %eax,%edx
  8004a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ac:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004ae:	ff 45 fc             	incl   -0x4(%ebp)
  8004b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004b7:	7c e1                	jl     80049a <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004b9:	90                   	nop
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004c9:	eb 1b                	jmp    8004e6 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	01 c2                	add    %eax,%edx
  8004da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dd:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004e0:	48                   	dec    %eax
  8004e1:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004e3:	ff 45 fc             	incl   -0x4(%ebp)
  8004e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ec:	7c dd                	jl     8004cb <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004ee:	90                   	nop
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004fa:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004ff:	f7 e9                	imul   %ecx
  800501:	c1 f9 1f             	sar    $0x1f,%ecx
  800504:	89 d0                	mov    %edx,%eax
  800506:	29 c8                	sub    %ecx,%eax
  800508:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  80050b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80050f:	75 07                	jne    800518 <InitializeSemiRandom+0x27>
		Repetition = 3;
  800511:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800518:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80051f:	eb 1e                	jmp    80053f <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800524:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800534:	99                   	cltd   
  800535:	f7 7d f8             	idivl  -0x8(%ebp)
  800538:	89 d0                	mov    %edx,%eax
  80053a:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
		Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  80053c:	ff 45 fc             	incl   -0x4(%ebp)
  80053f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800542:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800545:	7c da                	jl     800521 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800550:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800557:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80055e:	eb 42                	jmp    8005a2 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800563:	99                   	cltd   
  800564:	f7 7d f0             	idivl  -0x10(%ebp)
  800567:	89 d0                	mov    %edx,%eax
  800569:	85 c0                	test   %eax,%eax
  80056b:	75 10                	jne    80057d <PrintElements+0x33>
			cprintf("\n");
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	68 80 42 80 00       	push   $0x804280
  800575:	e8 8e 04 00 00       	call   800a08 <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80057d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800580:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	01 d0                	add    %edx,%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	50                   	push   %eax
  800592:	68 58 44 80 00       	push   $0x804458
  800597:	e8 6c 04 00 00       	call   800a08 <cprintf>
  80059c:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80059f:	ff 45 f4             	incl   -0xc(%ebp)
  8005a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a5:	48                   	dec    %eax
  8005a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005a9:	7f b5                	jg     800560 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8005ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	01 d0                	add    %edx,%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	50                   	push   %eax
  8005c0:	68 5d 44 80 00       	push   $0x80445d
  8005c5:	e8 3e 04 00 00       	call   800a08 <cprintf>
  8005ca:	83 c4 10             	add    $0x10,%esp

}
  8005cd:	90                   	nop
  8005ce:	c9                   	leave  
  8005cf:	c3                   	ret    

008005d0 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005dc:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 ac 1a 00 00       	call   802095 <sys_cputc>
  8005e9:	83 c4 10             	add    $0x10,%esp
}
  8005ec:	90                   	nop
  8005ed:	c9                   	leave  
  8005ee:	c3                   	ret    

008005ef <getchar>:


int
getchar(void)
{
  8005ef:	55                   	push   %ebp
  8005f0:	89 e5                	mov    %esp,%ebp
  8005f2:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005f5:	e8 37 19 00 00       	call   801f31 <sys_cgetc>
  8005fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800600:	c9                   	leave  
  800601:	c3                   	ret    

00800602 <iscons>:

int iscons(int fdnum)
{
  800602:	55                   	push   %ebp
  800603:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800605:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80060a:	5d                   	pop    %ebp
  80060b:	c3                   	ret    

0080060c <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800612:	e8 af 1b 00 00       	call   8021c6 <sys_getenvindex>
  800617:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80061a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061d:	89 d0                	mov    %edx,%eax
  80061f:	c1 e0 03             	shl    $0x3,%eax
  800622:	01 d0                	add    %edx,%eax
  800624:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80062b:	01 c8                	add    %ecx,%eax
  80062d:	01 c0                	add    %eax,%eax
  80062f:	01 d0                	add    %edx,%eax
  800631:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800638:	01 c8                	add    %ecx,%eax
  80063a:	01 d0                	add    %edx,%eax
  80063c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800641:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800646:	a1 24 50 80 00       	mov    0x805024,%eax
  80064b:	8a 40 20             	mov    0x20(%eax),%al
  80064e:	84 c0                	test   %al,%al
  800650:	74 0d                	je     80065f <libmain+0x53>
		binaryname = myEnv->prog_name;
  800652:	a1 24 50 80 00       	mov    0x805024,%eax
  800657:	83 c0 20             	add    $0x20,%eax
  80065a:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80065f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800663:	7e 0a                	jle    80066f <libmain+0x63>
		binaryname = argv[0];
  800665:	8b 45 0c             	mov    0xc(%ebp),%eax
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80066f:	83 ec 08             	sub    $0x8,%esp
  800672:	ff 75 0c             	pushl  0xc(%ebp)
  800675:	ff 75 08             	pushl  0x8(%ebp)
  800678:	e8 bb f9 ff ff       	call   800038 <_main>
  80067d:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800680:	e8 c5 18 00 00       	call   801f4a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800685:	83 ec 0c             	sub    $0xc,%esp
  800688:	68 7c 44 80 00       	push   $0x80447c
  80068d:	e8 76 03 00 00       	call   800a08 <cprintf>
  800692:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800695:	a1 24 50 80 00       	mov    0x805024,%eax
  80069a:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8006a0:	a1 24 50 80 00       	mov    0x805024,%eax
  8006a5:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8006ab:	83 ec 04             	sub    $0x4,%esp
  8006ae:	52                   	push   %edx
  8006af:	50                   	push   %eax
  8006b0:	68 a4 44 80 00       	push   $0x8044a4
  8006b5:	e8 4e 03 00 00       	call   800a08 <cprintf>
  8006ba:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006bd:	a1 24 50 80 00       	mov    0x805024,%eax
  8006c2:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8006c8:	a1 24 50 80 00       	mov    0x805024,%eax
  8006cd:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8006d3:	a1 24 50 80 00       	mov    0x805024,%eax
  8006d8:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8006de:	51                   	push   %ecx
  8006df:	52                   	push   %edx
  8006e0:	50                   	push   %eax
  8006e1:	68 cc 44 80 00       	push   $0x8044cc
  8006e6:	e8 1d 03 00 00       	call   800a08 <cprintf>
  8006eb:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f3:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	50                   	push   %eax
  8006fd:	68 24 45 80 00       	push   $0x804524
  800702:	e8 01 03 00 00       	call   800a08 <cprintf>
  800707:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 7c 44 80 00       	push   $0x80447c
  800712:	e8 f1 02 00 00       	call   800a08 <cprintf>
  800717:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80071a:	e8 45 18 00 00       	call   801f64 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80071f:	e8 19 00 00 00       	call   80073d <exit>
}
  800724:	90                   	nop
  800725:	c9                   	leave  
  800726:	c3                   	ret    

00800727 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800727:	55                   	push   %ebp
  800728:	89 e5                	mov    %esp,%ebp
  80072a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80072d:	83 ec 0c             	sub    $0xc,%esp
  800730:	6a 00                	push   $0x0
  800732:	e8 5b 1a 00 00       	call   802192 <sys_destroy_env>
  800737:	83 c4 10             	add    $0x10,%esp
}
  80073a:	90                   	nop
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    

0080073d <exit>:

void
exit(void)
{
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800743:	e8 b0 1a 00 00       	call   8021f8 <sys_exit_env>
}
  800748:	90                   	nop
  800749:	c9                   	leave  
  80074a:	c3                   	ret    

0080074b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800751:	8d 45 10             	lea    0x10(%ebp),%eax
  800754:	83 c0 04             	add    $0x4,%eax
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80075a:	a1 50 50 80 00       	mov    0x805050,%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	74 16                	je     800779 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800763:	a1 50 50 80 00       	mov    0x805050,%eax
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	50                   	push   %eax
  80076c:	68 38 45 80 00       	push   $0x804538
  800771:	e8 92 02 00 00       	call   800a08 <cprintf>
  800776:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800779:	a1 00 50 80 00       	mov    0x805000,%eax
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	ff 75 08             	pushl  0x8(%ebp)
  800784:	50                   	push   %eax
  800785:	68 3d 45 80 00       	push   $0x80453d
  80078a:	e8 79 02 00 00       	call   800a08 <cprintf>
  80078f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800792:	8b 45 10             	mov    0x10(%ebp),%eax
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	ff 75 f4             	pushl  -0xc(%ebp)
  80079b:	50                   	push   %eax
  80079c:	e8 fc 01 00 00       	call   80099d <vcprintf>
  8007a1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	6a 00                	push   $0x0
  8007a9:	68 59 45 80 00       	push   $0x804559
  8007ae:	e8 ea 01 00 00       	call   80099d <vcprintf>
  8007b3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007b6:	e8 82 ff ff ff       	call   80073d <exit>

	// should not return here
	while (1) ;
  8007bb:	eb fe                	jmp    8007bb <_panic+0x70>

008007bd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007c3:	a1 24 50 80 00       	mov    0x805024,%eax
  8007c8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8007ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d1:	39 c2                	cmp    %eax,%edx
  8007d3:	74 14                	je     8007e9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007d5:	83 ec 04             	sub    $0x4,%esp
  8007d8:	68 5c 45 80 00       	push   $0x80455c
  8007dd:	6a 26                	push   $0x26
  8007df:	68 a8 45 80 00       	push   $0x8045a8
  8007e4:	e8 62 ff ff ff       	call   80074b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007f7:	e9 c5 00 00 00       	jmp    8008c1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8007fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	01 d0                	add    %edx,%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	85 c0                	test   %eax,%eax
  80080f:	75 08                	jne    800819 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800811:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800814:	e9 a5 00 00 00       	jmp    8008be <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800819:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800820:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800827:	eb 69                	jmp    800892 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800829:	a1 24 50 80 00       	mov    0x805024,%eax
  80082e:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800834:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800837:	89 d0                	mov    %edx,%eax
  800839:	01 c0                	add    %eax,%eax
  80083b:	01 d0                	add    %edx,%eax
  80083d:	c1 e0 03             	shl    $0x3,%eax
  800840:	01 c8                	add    %ecx,%eax
  800842:	8a 40 04             	mov    0x4(%eax),%al
  800845:	84 c0                	test   %al,%al
  800847:	75 46                	jne    80088f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800849:	a1 24 50 80 00       	mov    0x805024,%eax
  80084e:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800854:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800857:	89 d0                	mov    %edx,%eax
  800859:	01 c0                	add    %eax,%eax
  80085b:	01 d0                	add    %edx,%eax
  80085d:	c1 e0 03             	shl    $0x3,%eax
  800860:	01 c8                	add    %ecx,%eax
  800862:	8b 00                	mov    (%eax),%eax
  800864:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800867:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80086a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80086f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800874:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	01 c8                	add    %ecx,%eax
  800880:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800882:	39 c2                	cmp    %eax,%edx
  800884:	75 09                	jne    80088f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800886:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80088d:	eb 15                	jmp    8008a4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088f:	ff 45 e8             	incl   -0x18(%ebp)
  800892:	a1 24 50 80 00       	mov    0x805024,%eax
  800897:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80089d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a0:	39 c2                	cmp    %eax,%edx
  8008a2:	77 85                	ja     800829 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008a8:	75 14                	jne    8008be <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008aa:	83 ec 04             	sub    $0x4,%esp
  8008ad:	68 b4 45 80 00       	push   $0x8045b4
  8008b2:	6a 3a                	push   $0x3a
  8008b4:	68 a8 45 80 00       	push   $0x8045a8
  8008b9:	e8 8d fe ff ff       	call   80074b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008be:	ff 45 f0             	incl   -0x10(%ebp)
  8008c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008c7:	0f 8c 2f ff ff ff    	jl     8007fc <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008db:	eb 26                	jmp    800903 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008dd:	a1 24 50 80 00       	mov    0x805024,%eax
  8008e2:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8008e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008eb:	89 d0                	mov    %edx,%eax
  8008ed:	01 c0                	add    %eax,%eax
  8008ef:	01 d0                	add    %edx,%eax
  8008f1:	c1 e0 03             	shl    $0x3,%eax
  8008f4:	01 c8                	add    %ecx,%eax
  8008f6:	8a 40 04             	mov    0x4(%eax),%al
  8008f9:	3c 01                	cmp    $0x1,%al
  8008fb:	75 03                	jne    800900 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8008fd:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800900:	ff 45 e0             	incl   -0x20(%ebp)
  800903:	a1 24 50 80 00       	mov    0x805024,%eax
  800908:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80090e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800911:	39 c2                	cmp    %eax,%edx
  800913:	77 c8                	ja     8008dd <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800918:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80091b:	74 14                	je     800931 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80091d:	83 ec 04             	sub    $0x4,%esp
  800920:	68 08 46 80 00       	push   $0x804608
  800925:	6a 44                	push   $0x44
  800927:	68 a8 45 80 00       	push   $0x8045a8
  80092c:	e8 1a fe ff ff       	call   80074b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800931:	90                   	nop
  800932:	c9                   	leave  
  800933:	c3                   	ret    

00800934 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80093a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093d:	8b 00                	mov    (%eax),%eax
  80093f:	8d 48 01             	lea    0x1(%eax),%ecx
  800942:	8b 55 0c             	mov    0xc(%ebp),%edx
  800945:	89 0a                	mov    %ecx,(%edx)
  800947:	8b 55 08             	mov    0x8(%ebp),%edx
  80094a:	88 d1                	mov    %dl,%cl
  80094c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800953:	8b 45 0c             	mov    0xc(%ebp),%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	3d ff 00 00 00       	cmp    $0xff,%eax
  80095d:	75 2c                	jne    80098b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80095f:	a0 2c 50 80 00       	mov    0x80502c,%al
  800964:	0f b6 c0             	movzbl %al,%eax
  800967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096a:	8b 12                	mov    (%edx),%edx
  80096c:	89 d1                	mov    %edx,%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	83 c2 08             	add    $0x8,%edx
  800974:	83 ec 04             	sub    $0x4,%esp
  800977:	50                   	push   %eax
  800978:	51                   	push   %ecx
  800979:	52                   	push   %edx
  80097a:	e8 89 15 00 00       	call   801f08 <sys_cputs>
  80097f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800982:	8b 45 0c             	mov    0xc(%ebp),%eax
  800985:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80098b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098e:	8b 40 04             	mov    0x4(%eax),%eax
  800991:	8d 50 01             	lea    0x1(%eax),%edx
  800994:	8b 45 0c             	mov    0xc(%ebp),%eax
  800997:	89 50 04             	mov    %edx,0x4(%eax)
}
  80099a:	90                   	nop
  80099b:	c9                   	leave  
  80099c:	c3                   	ret    

0080099d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009a6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009ad:	00 00 00 
	b.cnt = 0;
  8009b0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009b7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009ba:	ff 75 0c             	pushl  0xc(%ebp)
  8009bd:	ff 75 08             	pushl  0x8(%ebp)
  8009c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009c6:	50                   	push   %eax
  8009c7:	68 34 09 80 00       	push   $0x800934
  8009cc:	e8 11 02 00 00       	call   800be2 <vprintfmt>
  8009d1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009d4:	a0 2c 50 80 00       	mov    0x80502c,%al
  8009d9:	0f b6 c0             	movzbl %al,%eax
  8009dc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009e2:	83 ec 04             	sub    $0x4,%esp
  8009e5:	50                   	push   %eax
  8009e6:	52                   	push   %edx
  8009e7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009ed:	83 c0 08             	add    $0x8,%eax
  8009f0:	50                   	push   %eax
  8009f1:	e8 12 15 00 00       	call   801f08 <sys_cputs>
  8009f6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009f9:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
	return b.cnt;
  800a00:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a06:	c9                   	leave  
  800a07:	c3                   	ret    

00800a08 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a0e:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
	va_start(ap, fmt);
  800a15:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a18:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 f4             	pushl  -0xc(%ebp)
  800a24:	50                   	push   %eax
  800a25:	e8 73 ff ff ff       	call   80099d <vcprintf>
  800a2a:	83 c4 10             	add    $0x10,%esp
  800a2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a3b:	e8 0a 15 00 00       	call   801f4a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a40:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a4f:	50                   	push   %eax
  800a50:	e8 48 ff ff ff       	call   80099d <vcprintf>
  800a55:	83 c4 10             	add    $0x10,%esp
  800a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a5b:	e8 04 15 00 00       	call   801f64 <sys_unlock_cons>
	return cnt;
  800a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a63:	c9                   	leave  
  800a64:	c3                   	ret    

00800a65 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	53                   	push   %ebx
  800a69:	83 ec 14             	sub    $0x14,%esp
  800a6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a78:	8b 45 18             	mov    0x18(%ebp),%eax
  800a7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a80:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a83:	77 55                	ja     800ada <printnum+0x75>
  800a85:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a88:	72 05                	jb     800a8f <printnum+0x2a>
  800a8a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a8d:	77 4b                	ja     800ada <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a8f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a92:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a95:	8b 45 18             	mov    0x18(%ebp),%eax
  800a98:	ba 00 00 00 00       	mov    $0x0,%edx
  800a9d:	52                   	push   %edx
  800a9e:	50                   	push   %eax
  800a9f:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa2:	ff 75 f0             	pushl  -0x10(%ebp)
  800aa5:	e8 5e 35 00 00       	call   804008 <__udivdi3>
  800aaa:	83 c4 10             	add    $0x10,%esp
  800aad:	83 ec 04             	sub    $0x4,%esp
  800ab0:	ff 75 20             	pushl  0x20(%ebp)
  800ab3:	53                   	push   %ebx
  800ab4:	ff 75 18             	pushl  0x18(%ebp)
  800ab7:	52                   	push   %edx
  800ab8:	50                   	push   %eax
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	ff 75 08             	pushl  0x8(%ebp)
  800abf:	e8 a1 ff ff ff       	call   800a65 <printnum>
  800ac4:	83 c4 20             	add    $0x20,%esp
  800ac7:	eb 1a                	jmp    800ae3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ac9:	83 ec 08             	sub    $0x8,%esp
  800acc:	ff 75 0c             	pushl  0xc(%ebp)
  800acf:	ff 75 20             	pushl  0x20(%ebp)
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ada:	ff 4d 1c             	decl   0x1c(%ebp)
  800add:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ae1:	7f e6                	jg     800ac9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ae3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ae6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af1:	53                   	push   %ebx
  800af2:	51                   	push   %ecx
  800af3:	52                   	push   %edx
  800af4:	50                   	push   %eax
  800af5:	e8 1e 36 00 00       	call   804118 <__umoddi3>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	05 74 48 80 00       	add    $0x804874,%eax
  800b02:	8a 00                	mov    (%eax),%al
  800b04:	0f be c0             	movsbl %al,%eax
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 0c             	pushl  0xc(%ebp)
  800b0d:	50                   	push   %eax
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	ff d0                	call   *%eax
  800b13:	83 c4 10             	add    $0x10,%esp
}
  800b16:	90                   	nop
  800b17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b1f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b23:	7e 1c                	jle    800b41 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	8b 00                	mov    (%eax),%eax
  800b2a:	8d 50 08             	lea    0x8(%eax),%edx
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	89 10                	mov    %edx,(%eax)
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8b 00                	mov    (%eax),%eax
  800b37:	83 e8 08             	sub    $0x8,%eax
  800b3a:	8b 50 04             	mov    0x4(%eax),%edx
  800b3d:	8b 00                	mov    (%eax),%eax
  800b3f:	eb 40                	jmp    800b81 <getuint+0x65>
	else if (lflag)
  800b41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b45:	74 1e                	je     800b65 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	8b 00                	mov    (%eax),%eax
  800b4c:	8d 50 04             	lea    0x4(%eax),%edx
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	89 10                	mov    %edx,(%eax)
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	8b 00                	mov    (%eax),%eax
  800b59:	83 e8 04             	sub    $0x4,%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b63:	eb 1c                	jmp    800b81 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	8b 00                	mov    (%eax),%eax
  800b6a:	8d 50 04             	lea    0x4(%eax),%edx
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	89 10                	mov    %edx,(%eax)
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	8b 00                	mov    (%eax),%eax
  800b77:	83 e8 04             	sub    $0x4,%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b86:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8a:	7e 1c                	jle    800ba8 <getint+0x25>
		return va_arg(*ap, long long);
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8b 00                	mov    (%eax),%eax
  800b91:	8d 50 08             	lea    0x8(%eax),%edx
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	89 10                	mov    %edx,(%eax)
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 00                	mov    (%eax),%eax
  800b9e:	83 e8 08             	sub    $0x8,%eax
  800ba1:	8b 50 04             	mov    0x4(%eax),%edx
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	eb 38                	jmp    800be0 <getint+0x5d>
	else if (lflag)
  800ba8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bac:	74 1a                	je     800bc8 <getint+0x45>
		return va_arg(*ap, long);
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8b 00                	mov    (%eax),%eax
  800bb3:	8d 50 04             	lea    0x4(%eax),%edx
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	89 10                	mov    %edx,(%eax)
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	8b 00                	mov    (%eax),%eax
  800bc0:	83 e8 04             	sub    $0x4,%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	99                   	cltd   
  800bc6:	eb 18                	jmp    800be0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	8b 00                	mov    (%eax),%eax
  800bcd:	8d 50 04             	lea    0x4(%eax),%edx
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	89 10                	mov    %edx,(%eax)
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	8b 00                	mov    (%eax),%eax
  800bda:	83 e8 04             	sub    $0x4,%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	99                   	cltd   
}
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    

00800be2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	56                   	push   %esi
  800be6:	53                   	push   %ebx
  800be7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bea:	eb 17                	jmp    800c03 <vprintfmt+0x21>
			if (ch == '\0')
  800bec:	85 db                	test   %ebx,%ebx
  800bee:	0f 84 c1 03 00 00    	je     800fb5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800bf4:	83 ec 08             	sub    $0x8,%esp
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	53                   	push   %ebx
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	ff d0                	call   *%eax
  800c00:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c03:	8b 45 10             	mov    0x10(%ebp),%eax
  800c06:	8d 50 01             	lea    0x1(%eax),%edx
  800c09:	89 55 10             	mov    %edx,0x10(%ebp)
  800c0c:	8a 00                	mov    (%eax),%al
  800c0e:	0f b6 d8             	movzbl %al,%ebx
  800c11:	83 fb 25             	cmp    $0x25,%ebx
  800c14:	75 d6                	jne    800bec <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c16:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c1a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c21:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c2f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c36:	8b 45 10             	mov    0x10(%ebp),%eax
  800c39:	8d 50 01             	lea    0x1(%eax),%edx
  800c3c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	0f b6 d8             	movzbl %al,%ebx
  800c44:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c47:	83 f8 5b             	cmp    $0x5b,%eax
  800c4a:	0f 87 3d 03 00 00    	ja     800f8d <vprintfmt+0x3ab>
  800c50:	8b 04 85 98 48 80 00 	mov    0x804898(,%eax,4),%eax
  800c57:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c59:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c5d:	eb d7                	jmp    800c36 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c5f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c63:	eb d1                	jmp    800c36 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c6c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c6f:	89 d0                	mov    %edx,%eax
  800c71:	c1 e0 02             	shl    $0x2,%eax
  800c74:	01 d0                	add    %edx,%eax
  800c76:	01 c0                	add    %eax,%eax
  800c78:	01 d8                	add    %ebx,%eax
  800c7a:	83 e8 30             	sub    $0x30,%eax
  800c7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c80:	8b 45 10             	mov    0x10(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c88:	83 fb 2f             	cmp    $0x2f,%ebx
  800c8b:	7e 3e                	jle    800ccb <vprintfmt+0xe9>
  800c8d:	83 fb 39             	cmp    $0x39,%ebx
  800c90:	7f 39                	jg     800ccb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c92:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c95:	eb d5                	jmp    800c6c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c97:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9a:	83 c0 04             	add    $0x4,%eax
  800c9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 e8 04             	sub    $0x4,%eax
  800ca6:	8b 00                	mov    (%eax),%eax
  800ca8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cab:	eb 1f                	jmp    800ccc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cb1:	79 83                	jns    800c36 <vprintfmt+0x54>
				width = 0;
  800cb3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cba:	e9 77 ff ff ff       	jmp    800c36 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cbf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cc6:	e9 6b ff ff ff       	jmp    800c36 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ccb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ccc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd0:	0f 89 60 ff ff ff    	jns    800c36 <vprintfmt+0x54>
				width = precision, precision = -1;
  800cd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cdc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ce3:	e9 4e ff ff ff       	jmp    800c36 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ce8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ceb:	e9 46 ff ff ff       	jmp    800c36 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf3:	83 c0 04             	add    $0x4,%eax
  800cf6:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfc:	83 e8 04             	sub    $0x4,%eax
  800cff:	8b 00                	mov    (%eax),%eax
  800d01:	83 ec 08             	sub    $0x8,%esp
  800d04:	ff 75 0c             	pushl  0xc(%ebp)
  800d07:	50                   	push   %eax
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	ff d0                	call   *%eax
  800d0d:	83 c4 10             	add    $0x10,%esp
			break;
  800d10:	e9 9b 02 00 00       	jmp    800fb0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d15:	8b 45 14             	mov    0x14(%ebp),%eax
  800d18:	83 c0 04             	add    $0x4,%eax
  800d1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d21:	83 e8 04             	sub    $0x4,%eax
  800d24:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d26:	85 db                	test   %ebx,%ebx
  800d28:	79 02                	jns    800d2c <vprintfmt+0x14a>
				err = -err;
  800d2a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d2c:	83 fb 64             	cmp    $0x64,%ebx
  800d2f:	7f 0b                	jg     800d3c <vprintfmt+0x15a>
  800d31:	8b 34 9d e0 46 80 00 	mov    0x8046e0(,%ebx,4),%esi
  800d38:	85 f6                	test   %esi,%esi
  800d3a:	75 19                	jne    800d55 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d3c:	53                   	push   %ebx
  800d3d:	68 85 48 80 00       	push   $0x804885
  800d42:	ff 75 0c             	pushl  0xc(%ebp)
  800d45:	ff 75 08             	pushl  0x8(%ebp)
  800d48:	e8 70 02 00 00       	call   800fbd <printfmt>
  800d4d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d50:	e9 5b 02 00 00       	jmp    800fb0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d55:	56                   	push   %esi
  800d56:	68 8e 48 80 00       	push   $0x80488e
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	e8 57 02 00 00       	call   800fbd <printfmt>
  800d66:	83 c4 10             	add    $0x10,%esp
			break;
  800d69:	e9 42 02 00 00       	jmp    800fb0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d71:	83 c0 04             	add    $0x4,%eax
  800d74:	89 45 14             	mov    %eax,0x14(%ebp)
  800d77:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7a:	83 e8 04             	sub    $0x4,%eax
  800d7d:	8b 30                	mov    (%eax),%esi
  800d7f:	85 f6                	test   %esi,%esi
  800d81:	75 05                	jne    800d88 <vprintfmt+0x1a6>
				p = "(null)";
  800d83:	be 91 48 80 00       	mov    $0x804891,%esi
			if (width > 0 && padc != '-')
  800d88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8c:	7e 6d                	jle    800dfb <vprintfmt+0x219>
  800d8e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d92:	74 67                	je     800dfb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	50                   	push   %eax
  800d9b:	56                   	push   %esi
  800d9c:	e8 26 05 00 00       	call   8012c7 <strnlen>
  800da1:	83 c4 10             	add    $0x10,%esp
  800da4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800da7:	eb 16                	jmp    800dbf <vprintfmt+0x1dd>
					putch(padc, putdat);
  800da9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dad:	83 ec 08             	sub    $0x8,%esp
  800db0:	ff 75 0c             	pushl  0xc(%ebp)
  800db3:	50                   	push   %eax
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	ff d0                	call   *%eax
  800db9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dbc:	ff 4d e4             	decl   -0x1c(%ebp)
  800dbf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc3:	7f e4                	jg     800da9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc5:	eb 34                	jmp    800dfb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dc7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dcb:	74 1c                	je     800de9 <vprintfmt+0x207>
  800dcd:	83 fb 1f             	cmp    $0x1f,%ebx
  800dd0:	7e 05                	jle    800dd7 <vprintfmt+0x1f5>
  800dd2:	83 fb 7e             	cmp    $0x7e,%ebx
  800dd5:	7e 12                	jle    800de9 <vprintfmt+0x207>
					putch('?', putdat);
  800dd7:	83 ec 08             	sub    $0x8,%esp
  800dda:	ff 75 0c             	pushl  0xc(%ebp)
  800ddd:	6a 3f                	push   $0x3f
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	ff d0                	call   *%eax
  800de4:	83 c4 10             	add    $0x10,%esp
  800de7:	eb 0f                	jmp    800df8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800de9:	83 ec 08             	sub    $0x8,%esp
  800dec:	ff 75 0c             	pushl  0xc(%ebp)
  800def:	53                   	push   %ebx
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	ff d0                	call   *%eax
  800df5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df8:	ff 4d e4             	decl   -0x1c(%ebp)
  800dfb:	89 f0                	mov    %esi,%eax
  800dfd:	8d 70 01             	lea    0x1(%eax),%esi
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	0f be d8             	movsbl %al,%ebx
  800e05:	85 db                	test   %ebx,%ebx
  800e07:	74 24                	je     800e2d <vprintfmt+0x24b>
  800e09:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e0d:	78 b8                	js     800dc7 <vprintfmt+0x1e5>
  800e0f:	ff 4d e0             	decl   -0x20(%ebp)
  800e12:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e16:	79 af                	jns    800dc7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e18:	eb 13                	jmp    800e2d <vprintfmt+0x24b>
				putch(' ', putdat);
  800e1a:	83 ec 08             	sub    $0x8,%esp
  800e1d:	ff 75 0c             	pushl  0xc(%ebp)
  800e20:	6a 20                	push   $0x20
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	ff d0                	call   *%eax
  800e27:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e2a:	ff 4d e4             	decl   -0x1c(%ebp)
  800e2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e31:	7f e7                	jg     800e1a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e33:	e9 78 01 00 00       	jmp    800fb0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 e8             	pushl  -0x18(%ebp)
  800e3e:	8d 45 14             	lea    0x14(%ebp),%eax
  800e41:	50                   	push   %eax
  800e42:	e8 3c fd ff ff       	call   800b83 <getint>
  800e47:	83 c4 10             	add    $0x10,%esp
  800e4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e56:	85 d2                	test   %edx,%edx
  800e58:	79 23                	jns    800e7d <vprintfmt+0x29b>
				putch('-', putdat);
  800e5a:	83 ec 08             	sub    $0x8,%esp
  800e5d:	ff 75 0c             	pushl  0xc(%ebp)
  800e60:	6a 2d                	push   $0x2d
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	ff d0                	call   *%eax
  800e67:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e70:	f7 d8                	neg    %eax
  800e72:	83 d2 00             	adc    $0x0,%edx
  800e75:	f7 da                	neg    %edx
  800e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e7d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e84:	e9 bc 00 00 00       	jmp    800f45 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8f:	8d 45 14             	lea    0x14(%ebp),%eax
  800e92:	50                   	push   %eax
  800e93:	e8 84 fc ff ff       	call   800b1c <getuint>
  800e98:	83 c4 10             	add    $0x10,%esp
  800e9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ea1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ea8:	e9 98 00 00 00       	jmp    800f45 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ead:	83 ec 08             	sub    $0x8,%esp
  800eb0:	ff 75 0c             	pushl  0xc(%ebp)
  800eb3:	6a 58                	push   $0x58
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	ff d0                	call   *%eax
  800eba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ebd:	83 ec 08             	sub    $0x8,%esp
  800ec0:	ff 75 0c             	pushl  0xc(%ebp)
  800ec3:	6a 58                	push   $0x58
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	ff d0                	call   *%eax
  800eca:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ecd:	83 ec 08             	sub    $0x8,%esp
  800ed0:	ff 75 0c             	pushl  0xc(%ebp)
  800ed3:	6a 58                	push   $0x58
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	ff d0                	call   *%eax
  800eda:	83 c4 10             	add    $0x10,%esp
			break;
  800edd:	e9 ce 00 00 00       	jmp    800fb0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ee2:	83 ec 08             	sub    $0x8,%esp
  800ee5:	ff 75 0c             	pushl  0xc(%ebp)
  800ee8:	6a 30                	push   $0x30
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	ff d0                	call   *%eax
  800eef:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ef2:	83 ec 08             	sub    $0x8,%esp
  800ef5:	ff 75 0c             	pushl  0xc(%ebp)
  800ef8:	6a 78                	push   $0x78
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	ff d0                	call   *%eax
  800eff:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f02:	8b 45 14             	mov    0x14(%ebp),%eax
  800f05:	83 c0 04             	add    $0x4,%eax
  800f08:	89 45 14             	mov    %eax,0x14(%ebp)
  800f0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0e:	83 e8 04             	sub    $0x4,%eax
  800f11:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f1d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f24:	eb 1f                	jmp    800f45 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f26:	83 ec 08             	sub    $0x8,%esp
  800f29:	ff 75 e8             	pushl  -0x18(%ebp)
  800f2c:	8d 45 14             	lea    0x14(%ebp),%eax
  800f2f:	50                   	push   %eax
  800f30:	e8 e7 fb ff ff       	call   800b1c <getuint>
  800f35:	83 c4 10             	add    $0x10,%esp
  800f38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f3e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f45:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	52                   	push   %edx
  800f50:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f53:	50                   	push   %eax
  800f54:	ff 75 f4             	pushl  -0xc(%ebp)
  800f57:	ff 75 f0             	pushl  -0x10(%ebp)
  800f5a:	ff 75 0c             	pushl  0xc(%ebp)
  800f5d:	ff 75 08             	pushl  0x8(%ebp)
  800f60:	e8 00 fb ff ff       	call   800a65 <printnum>
  800f65:	83 c4 20             	add    $0x20,%esp
			break;
  800f68:	eb 46                	jmp    800fb0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f6a:	83 ec 08             	sub    $0x8,%esp
  800f6d:	ff 75 0c             	pushl  0xc(%ebp)
  800f70:	53                   	push   %ebx
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	ff d0                	call   *%eax
  800f76:	83 c4 10             	add    $0x10,%esp
			break;
  800f79:	eb 35                	jmp    800fb0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f7b:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800f82:	eb 2c                	jmp    800fb0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f84:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
			break;
  800f8b:	eb 23                	jmp    800fb0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f8d:	83 ec 08             	sub    $0x8,%esp
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	6a 25                	push   $0x25
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	ff d0                	call   *%eax
  800f9a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f9d:	ff 4d 10             	decl   0x10(%ebp)
  800fa0:	eb 03                	jmp    800fa5 <vprintfmt+0x3c3>
  800fa2:	ff 4d 10             	decl   0x10(%ebp)
  800fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa8:	48                   	dec    %eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	3c 25                	cmp    $0x25,%al
  800fad:	75 f3                	jne    800fa2 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800faf:	90                   	nop
		}
	}
  800fb0:	e9 35 fc ff ff       	jmp    800bea <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fb5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fc3:	8d 45 10             	lea    0x10(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd2:	50                   	push   %eax
  800fd3:	ff 75 0c             	pushl  0xc(%ebp)
  800fd6:	ff 75 08             	pushl  0x8(%ebp)
  800fd9:	e8 04 fc ff ff       	call   800be2 <vprintfmt>
  800fde:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fe1:	90                   	nop
  800fe2:	c9                   	leave  
  800fe3:	c3                   	ret    

00800fe4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	8b 40 08             	mov    0x8(%eax),%eax
  800fed:	8d 50 01             	lea    0x1(%eax),%edx
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff9:	8b 10                	mov    (%eax),%edx
  800ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffe:	8b 40 04             	mov    0x4(%eax),%eax
  801001:	39 c2                	cmp    %eax,%edx
  801003:	73 12                	jae    801017 <sprintputch+0x33>
		*b->buf++ = ch;
  801005:	8b 45 0c             	mov    0xc(%ebp),%eax
  801008:	8b 00                	mov    (%eax),%eax
  80100a:	8d 48 01             	lea    0x1(%eax),%ecx
  80100d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801010:	89 0a                	mov    %ecx,(%edx)
  801012:	8b 55 08             	mov    0x8(%ebp),%edx
  801015:	88 10                	mov    %dl,(%eax)
}
  801017:	90                   	nop
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	01 d0                	add    %edx,%eax
  801031:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801034:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80103b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80103f:	74 06                	je     801047 <vsnprintf+0x2d>
  801041:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801045:	7f 07                	jg     80104e <vsnprintf+0x34>
		return -E_INVAL;
  801047:	b8 03 00 00 00       	mov    $0x3,%eax
  80104c:	eb 20                	jmp    80106e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80104e:	ff 75 14             	pushl  0x14(%ebp)
  801051:	ff 75 10             	pushl  0x10(%ebp)
  801054:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801057:	50                   	push   %eax
  801058:	68 e4 0f 80 00       	push   $0x800fe4
  80105d:	e8 80 fb ff ff       	call   800be2 <vprintfmt>
  801062:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801065:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801068:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80106e:	c9                   	leave  
  80106f:	c3                   	ret    

00801070 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801076:	8d 45 10             	lea    0x10(%ebp),%eax
  801079:	83 c0 04             	add    $0x4,%eax
  80107c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80107f:	8b 45 10             	mov    0x10(%ebp),%eax
  801082:	ff 75 f4             	pushl  -0xc(%ebp)
  801085:	50                   	push   %eax
  801086:	ff 75 0c             	pushl  0xc(%ebp)
  801089:	ff 75 08             	pushl  0x8(%ebp)
  80108c:	e8 89 ff ff ff       	call   80101a <vsnprintf>
  801091:	83 c4 10             	add    $0x10,%esp
  801094:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801097:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80109a:	c9                   	leave  
  80109b:	c3                   	ret    

0080109c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8010a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a6:	74 13                	je     8010bb <readline+0x1f>
		cprintf("%s", prompt);
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	ff 75 08             	pushl  0x8(%ebp)
  8010ae:	68 08 4a 80 00       	push   $0x804a08
  8010b3:	e8 50 f9 ff ff       	call   800a08 <cprintf>
  8010b8:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010c2:	83 ec 0c             	sub    $0xc,%esp
  8010c5:	6a 00                	push   $0x0
  8010c7:	e8 36 f5 ff ff       	call   800602 <iscons>
  8010cc:	83 c4 10             	add    $0x10,%esp
  8010cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010d2:	e8 18 f5 ff ff       	call   8005ef <getchar>
  8010d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010de:	79 22                	jns    801102 <readline+0x66>
			if (c != -E_EOF)
  8010e0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010e4:	0f 84 ad 00 00 00    	je     801197 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010ea:	83 ec 08             	sub    $0x8,%esp
  8010ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8010f0:	68 0b 4a 80 00       	push   $0x804a0b
  8010f5:	e8 0e f9 ff ff       	call   800a08 <cprintf>
  8010fa:	83 c4 10             	add    $0x10,%esp
			break;
  8010fd:	e9 95 00 00 00       	jmp    801197 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801102:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801106:	7e 34                	jle    80113c <readline+0xa0>
  801108:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80110f:	7f 2b                	jg     80113c <readline+0xa0>
			if (echoing)
  801111:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801115:	74 0e                	je     801125 <readline+0x89>
				cputchar(c);
  801117:	83 ec 0c             	sub    $0xc,%esp
  80111a:	ff 75 ec             	pushl  -0x14(%ebp)
  80111d:	e8 ae f4 ff ff       	call   8005d0 <cputchar>
  801122:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801128:	8d 50 01             	lea    0x1(%eax),%edx
  80112b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80112e:	89 c2                	mov    %eax,%edx
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	01 d0                	add    %edx,%eax
  801135:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801138:	88 10                	mov    %dl,(%eax)
  80113a:	eb 56                	jmp    801192 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80113c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801140:	75 1f                	jne    801161 <readline+0xc5>
  801142:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801146:	7e 19                	jle    801161 <readline+0xc5>
			if (echoing)
  801148:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80114c:	74 0e                	je     80115c <readline+0xc0>
				cputchar(c);
  80114e:	83 ec 0c             	sub    $0xc,%esp
  801151:	ff 75 ec             	pushl  -0x14(%ebp)
  801154:	e8 77 f4 ff ff       	call   8005d0 <cputchar>
  801159:	83 c4 10             	add    $0x10,%esp

			i--;
  80115c:	ff 4d f4             	decl   -0xc(%ebp)
  80115f:	eb 31                	jmp    801192 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801161:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801165:	74 0a                	je     801171 <readline+0xd5>
  801167:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80116b:	0f 85 61 ff ff ff    	jne    8010d2 <readline+0x36>
			if (echoing)
  801171:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801175:	74 0e                	je     801185 <readline+0xe9>
				cputchar(c);
  801177:	83 ec 0c             	sub    $0xc,%esp
  80117a:	ff 75 ec             	pushl  -0x14(%ebp)
  80117d:	e8 4e f4 ff ff       	call   8005d0 <cputchar>
  801182:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	01 d0                	add    %edx,%eax
  80118d:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801190:	eb 06                	jmp    801198 <readline+0xfc>
		}
	}
  801192:	e9 3b ff ff ff       	jmp    8010d2 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801197:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801198:	90                   	nop
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8011a1:	e8 a4 0d 00 00       	call   801f4a <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8011a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011aa:	74 13                	je     8011bf <atomic_readline+0x24>
			cprintf("%s", prompt);
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	ff 75 08             	pushl  0x8(%ebp)
  8011b2:	68 08 4a 80 00       	push   $0x804a08
  8011b7:	e8 4c f8 ff ff       	call   800a08 <cprintf>
  8011bc:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8011bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	6a 00                	push   $0x0
  8011cb:	e8 32 f4 ff ff       	call   800602 <iscons>
  8011d0:	83 c4 10             	add    $0x10,%esp
  8011d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8011d6:	e8 14 f4 ff ff       	call   8005ef <getchar>
  8011db:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8011de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011e2:	79 22                	jns    801206 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8011e4:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011e8:	0f 84 ad 00 00 00    	je     80129b <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8011ee:	83 ec 08             	sub    $0x8,%esp
  8011f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8011f4:	68 0b 4a 80 00       	push   $0x804a0b
  8011f9:	e8 0a f8 ff ff       	call   800a08 <cprintf>
  8011fe:	83 c4 10             	add    $0x10,%esp
				break;
  801201:	e9 95 00 00 00       	jmp    80129b <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801206:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80120a:	7e 34                	jle    801240 <atomic_readline+0xa5>
  80120c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801213:	7f 2b                	jg     801240 <atomic_readline+0xa5>
				if (echoing)
  801215:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801219:	74 0e                	je     801229 <atomic_readline+0x8e>
					cputchar(c);
  80121b:	83 ec 0c             	sub    $0xc,%esp
  80121e:	ff 75 ec             	pushl  -0x14(%ebp)
  801221:	e8 aa f3 ff ff       	call   8005d0 <cputchar>
  801226:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122c:	8d 50 01             	lea    0x1(%eax),%edx
  80122f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801232:	89 c2                	mov    %eax,%edx
  801234:	8b 45 0c             	mov    0xc(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80123c:	88 10                	mov    %dl,(%eax)
  80123e:	eb 56                	jmp    801296 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801240:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801244:	75 1f                	jne    801265 <atomic_readline+0xca>
  801246:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80124a:	7e 19                	jle    801265 <atomic_readline+0xca>
				if (echoing)
  80124c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801250:	74 0e                	je     801260 <atomic_readline+0xc5>
					cputchar(c);
  801252:	83 ec 0c             	sub    $0xc,%esp
  801255:	ff 75 ec             	pushl  -0x14(%ebp)
  801258:	e8 73 f3 ff ff       	call   8005d0 <cputchar>
  80125d:	83 c4 10             	add    $0x10,%esp
				i--;
  801260:	ff 4d f4             	decl   -0xc(%ebp)
  801263:	eb 31                	jmp    801296 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801265:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801269:	74 0a                	je     801275 <atomic_readline+0xda>
  80126b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80126f:	0f 85 61 ff ff ff    	jne    8011d6 <atomic_readline+0x3b>
				if (echoing)
  801275:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801279:	74 0e                	je     801289 <atomic_readline+0xee>
					cputchar(c);
  80127b:	83 ec 0c             	sub    $0xc,%esp
  80127e:	ff 75 ec             	pushl  -0x14(%ebp)
  801281:	e8 4a f3 ff ff       	call   8005d0 <cputchar>
  801286:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128f:	01 d0                	add    %edx,%eax
  801291:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801294:	eb 06                	jmp    80129c <atomic_readline+0x101>
			}
		}
  801296:	e9 3b ff ff ff       	jmp    8011d6 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80129b:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80129c:	e8 c3 0c 00 00       	call   801f64 <sys_unlock_cons>
}
  8012a1:	90                   	nop
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b1:	eb 06                	jmp    8012b9 <strlen+0x15>
		n++;
  8012b3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b6:	ff 45 08             	incl   0x8(%ebp)
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	84 c0                	test   %al,%al
  8012c0:	75 f1                	jne    8012b3 <strlen+0xf>
		n++;
	return n;
  8012c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    

008012c7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d4:	eb 09                	jmp    8012df <strnlen+0x18>
		n++;
  8012d6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012d9:	ff 45 08             	incl   0x8(%ebp)
  8012dc:	ff 4d 0c             	decl   0xc(%ebp)
  8012df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012e3:	74 09                	je     8012ee <strnlen+0x27>
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8a 00                	mov    (%eax),%al
  8012ea:	84 c0                	test   %al,%al
  8012ec:	75 e8                	jne    8012d6 <strnlen+0xf>
		n++;
	return n;
  8012ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012f1:	c9                   	leave  
  8012f2:	c3                   	ret    

008012f3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
  8012f6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012ff:	90                   	nop
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8d 50 01             	lea    0x1(%eax),%edx
  801306:	89 55 08             	mov    %edx,0x8(%ebp)
  801309:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80130f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801312:	8a 12                	mov    (%edx),%dl
  801314:	88 10                	mov    %dl,(%eax)
  801316:	8a 00                	mov    (%eax),%al
  801318:	84 c0                	test   %al,%al
  80131a:	75 e4                	jne    801300 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80131c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80132d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801334:	eb 1f                	jmp    801355 <strncpy+0x34>
		*dst++ = *src;
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8d 50 01             	lea    0x1(%eax),%edx
  80133c:	89 55 08             	mov    %edx,0x8(%ebp)
  80133f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801342:	8a 12                	mov    (%edx),%dl
  801344:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801346:	8b 45 0c             	mov    0xc(%ebp),%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	84 c0                	test   %al,%al
  80134d:	74 03                	je     801352 <strncpy+0x31>
			src++;
  80134f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801352:	ff 45 fc             	incl   -0x4(%ebp)
  801355:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801358:	3b 45 10             	cmp    0x10(%ebp),%eax
  80135b:	72 d9                	jb     801336 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80135d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801360:	c9                   	leave  
  801361:	c3                   	ret    

00801362 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80136e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801372:	74 30                	je     8013a4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801374:	eb 16                	jmp    80138c <strlcpy+0x2a>
			*dst++ = *src++;
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	8d 50 01             	lea    0x1(%eax),%edx
  80137c:	89 55 08             	mov    %edx,0x8(%ebp)
  80137f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801382:	8d 4a 01             	lea    0x1(%edx),%ecx
  801385:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801388:	8a 12                	mov    (%edx),%dl
  80138a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80138c:	ff 4d 10             	decl   0x10(%ebp)
  80138f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801393:	74 09                	je     80139e <strlcpy+0x3c>
  801395:	8b 45 0c             	mov    0xc(%ebp),%eax
  801398:	8a 00                	mov    (%eax),%al
  80139a:	84 c0                	test   %al,%al
  80139c:	75 d8                	jne    801376 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013aa:	29 c2                	sub    %eax,%edx
  8013ac:	89 d0                	mov    %edx,%eax
}
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013b3:	eb 06                	jmp    8013bb <strcmp+0xb>
		p++, q++;
  8013b5:	ff 45 08             	incl   0x8(%ebp)
  8013b8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	84 c0                	test   %al,%al
  8013c2:	74 0e                	je     8013d2 <strcmp+0x22>
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	8a 10                	mov    (%eax),%dl
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	38 c2                	cmp    %al,%dl
  8013d0:	74 e3                	je     8013b5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	0f b6 d0             	movzbl %al,%edx
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	0f b6 c0             	movzbl %al,%eax
  8013e2:	29 c2                	sub    %eax,%edx
  8013e4:	89 d0                	mov    %edx,%eax
}
  8013e6:	5d                   	pop    %ebp
  8013e7:	c3                   	ret    

008013e8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013eb:	eb 09                	jmp    8013f6 <strncmp+0xe>
		n--, p++, q++;
  8013ed:	ff 4d 10             	decl   0x10(%ebp)
  8013f0:	ff 45 08             	incl   0x8(%ebp)
  8013f3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013fa:	74 17                	je     801413 <strncmp+0x2b>
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	8a 00                	mov    (%eax),%al
  801401:	84 c0                	test   %al,%al
  801403:	74 0e                	je     801413 <strncmp+0x2b>
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	8a 10                	mov    (%eax),%dl
  80140a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	38 c2                	cmp    %al,%dl
  801411:	74 da                	je     8013ed <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801413:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801417:	75 07                	jne    801420 <strncmp+0x38>
		return 0;
  801419:	b8 00 00 00 00       	mov    $0x0,%eax
  80141e:	eb 14                	jmp    801434 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	0f b6 d0             	movzbl %al,%edx
  801428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	0f b6 c0             	movzbl %al,%eax
  801430:	29 c2                	sub    %eax,%edx
  801432:	89 d0                	mov    %edx,%eax
}
  801434:	5d                   	pop    %ebp
  801435:	c3                   	ret    

00801436 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 04             	sub    $0x4,%esp
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801442:	eb 12                	jmp    801456 <strchr+0x20>
		if (*s == c)
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80144c:	75 05                	jne    801453 <strchr+0x1d>
			return (char *) s;
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	eb 11                	jmp    801464 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801453:	ff 45 08             	incl   0x8(%ebp)
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	84 c0                	test   %al,%al
  80145d:	75 e5                	jne    801444 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80145f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	83 ec 04             	sub    $0x4,%esp
  80146c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801472:	eb 0d                	jmp    801481 <strfind+0x1b>
		if (*s == c)
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80147c:	74 0e                	je     80148c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80147e:	ff 45 08             	incl   0x8(%ebp)
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8a 00                	mov    (%eax),%al
  801486:	84 c0                	test   %al,%al
  801488:	75 ea                	jne    801474 <strfind+0xe>
  80148a:	eb 01                	jmp    80148d <strfind+0x27>
		if (*s == c)
			break;
  80148c:	90                   	nop
	return (char *) s;
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80149e:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014a4:	eb 0e                	jmp    8014b4 <memset+0x22>
		*p++ = c;
  8014a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a9:	8d 50 01             	lea    0x1(%eax),%edx
  8014ac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014b4:	ff 4d f8             	decl   -0x8(%ebp)
  8014b7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014bb:	79 e9                	jns    8014a6 <memset+0x14>
		*p++ = c;

	return v;
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014d4:	eb 16                	jmp    8014ec <memcpy+0x2a>
		*d++ = *s++;
  8014d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d9:	8d 50 01             	lea    0x1(%eax),%edx
  8014dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014e5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014e8:	8a 12                	mov    (%edx),%dl
  8014ea:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	75 dd                	jne    8014d6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
  801501:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801510:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801513:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801516:	73 50                	jae    801568 <memmove+0x6a>
  801518:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151b:	8b 45 10             	mov    0x10(%ebp),%eax
  80151e:	01 d0                	add    %edx,%eax
  801520:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801523:	76 43                	jbe    801568 <memmove+0x6a>
		s += n;
  801525:	8b 45 10             	mov    0x10(%ebp),%eax
  801528:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80152b:	8b 45 10             	mov    0x10(%ebp),%eax
  80152e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801531:	eb 10                	jmp    801543 <memmove+0x45>
			*--d = *--s;
  801533:	ff 4d f8             	decl   -0x8(%ebp)
  801536:	ff 4d fc             	decl   -0x4(%ebp)
  801539:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153c:	8a 10                	mov    (%eax),%dl
  80153e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801541:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801543:	8b 45 10             	mov    0x10(%ebp),%eax
  801546:	8d 50 ff             	lea    -0x1(%eax),%edx
  801549:	89 55 10             	mov    %edx,0x10(%ebp)
  80154c:	85 c0                	test   %eax,%eax
  80154e:	75 e3                	jne    801533 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801550:	eb 23                	jmp    801575 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801552:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801555:	8d 50 01             	lea    0x1(%eax),%edx
  801558:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80155b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80155e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801561:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801564:	8a 12                	mov    (%edx),%dl
  801566:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801568:	8b 45 10             	mov    0x10(%ebp),%eax
  80156b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80156e:	89 55 10             	mov    %edx,0x10(%ebp)
  801571:	85 c0                	test   %eax,%eax
  801573:	75 dd                	jne    801552 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801586:	8b 45 0c             	mov    0xc(%ebp),%eax
  801589:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80158c:	eb 2a                	jmp    8015b8 <memcmp+0x3e>
		if (*s1 != *s2)
  80158e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801591:	8a 10                	mov    (%eax),%dl
  801593:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801596:	8a 00                	mov    (%eax),%al
  801598:	38 c2                	cmp    %al,%dl
  80159a:	74 16                	je     8015b2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80159c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	0f b6 d0             	movzbl %al,%edx
  8015a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a7:	8a 00                	mov    (%eax),%al
  8015a9:	0f b6 c0             	movzbl %al,%eax
  8015ac:	29 c2                	sub    %eax,%edx
  8015ae:	89 d0                	mov    %edx,%eax
  8015b0:	eb 18                	jmp    8015ca <memcmp+0x50>
		s1++, s2++;
  8015b2:	ff 45 fc             	incl   -0x4(%ebp)
  8015b5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015be:	89 55 10             	mov    %edx,0x10(%ebp)
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	75 c9                	jne    80158e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d8:	01 d0                	add    %edx,%eax
  8015da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015dd:	eb 15                	jmp    8015f4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	8a 00                	mov    (%eax),%al
  8015e4:	0f b6 d0             	movzbl %al,%edx
  8015e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ea:	0f b6 c0             	movzbl %al,%eax
  8015ed:	39 c2                	cmp    %eax,%edx
  8015ef:	74 0d                	je     8015fe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015f1:	ff 45 08             	incl   0x8(%ebp)
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015fa:	72 e3                	jb     8015df <memfind+0x13>
  8015fc:	eb 01                	jmp    8015ff <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015fe:	90                   	nop
	return (void *) s;
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80160a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801611:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801618:	eb 03                	jmp    80161d <strtol+0x19>
		s++;
  80161a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	8a 00                	mov    (%eax),%al
  801622:	3c 20                	cmp    $0x20,%al
  801624:	74 f4                	je     80161a <strtol+0x16>
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	8a 00                	mov    (%eax),%al
  80162b:	3c 09                	cmp    $0x9,%al
  80162d:	74 eb                	je     80161a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	8a 00                	mov    (%eax),%al
  801634:	3c 2b                	cmp    $0x2b,%al
  801636:	75 05                	jne    80163d <strtol+0x39>
		s++;
  801638:	ff 45 08             	incl   0x8(%ebp)
  80163b:	eb 13                	jmp    801650 <strtol+0x4c>
	else if (*s == '-')
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	8a 00                	mov    (%eax),%al
  801642:	3c 2d                	cmp    $0x2d,%al
  801644:	75 0a                	jne    801650 <strtol+0x4c>
		s++, neg = 1;
  801646:	ff 45 08             	incl   0x8(%ebp)
  801649:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801650:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801654:	74 06                	je     80165c <strtol+0x58>
  801656:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80165a:	75 20                	jne    80167c <strtol+0x78>
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	8a 00                	mov    (%eax),%al
  801661:	3c 30                	cmp    $0x30,%al
  801663:	75 17                	jne    80167c <strtol+0x78>
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	40                   	inc    %eax
  801669:	8a 00                	mov    (%eax),%al
  80166b:	3c 78                	cmp    $0x78,%al
  80166d:	75 0d                	jne    80167c <strtol+0x78>
		s += 2, base = 16;
  80166f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801673:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80167a:	eb 28                	jmp    8016a4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80167c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801680:	75 15                	jne    801697 <strtol+0x93>
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	8a 00                	mov    (%eax),%al
  801687:	3c 30                	cmp    $0x30,%al
  801689:	75 0c                	jne    801697 <strtol+0x93>
		s++, base = 8;
  80168b:	ff 45 08             	incl   0x8(%ebp)
  80168e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801695:	eb 0d                	jmp    8016a4 <strtol+0xa0>
	else if (base == 0)
  801697:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80169b:	75 07                	jne    8016a4 <strtol+0xa0>
		base = 10;
  80169d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	8a 00                	mov    (%eax),%al
  8016a9:	3c 2f                	cmp    $0x2f,%al
  8016ab:	7e 19                	jle    8016c6 <strtol+0xc2>
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8a 00                	mov    (%eax),%al
  8016b2:	3c 39                	cmp    $0x39,%al
  8016b4:	7f 10                	jg     8016c6 <strtol+0xc2>
			dig = *s - '0';
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	8a 00                	mov    (%eax),%al
  8016bb:	0f be c0             	movsbl %al,%eax
  8016be:	83 e8 30             	sub    $0x30,%eax
  8016c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016c4:	eb 42                	jmp    801708 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	8a 00                	mov    (%eax),%al
  8016cb:	3c 60                	cmp    $0x60,%al
  8016cd:	7e 19                	jle    8016e8 <strtol+0xe4>
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	3c 7a                	cmp    $0x7a,%al
  8016d6:	7f 10                	jg     8016e8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	8a 00                	mov    (%eax),%al
  8016dd:	0f be c0             	movsbl %al,%eax
  8016e0:	83 e8 57             	sub    $0x57,%eax
  8016e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016e6:	eb 20                	jmp    801708 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	3c 40                	cmp    $0x40,%al
  8016ef:	7e 39                	jle    80172a <strtol+0x126>
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	8a 00                	mov    (%eax),%al
  8016f6:	3c 5a                	cmp    $0x5a,%al
  8016f8:	7f 30                	jg     80172a <strtol+0x126>
			dig = *s - 'A' + 10;
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	8a 00                	mov    (%eax),%al
  8016ff:	0f be c0             	movsbl %al,%eax
  801702:	83 e8 37             	sub    $0x37,%eax
  801705:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80170e:	7d 19                	jge    801729 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801710:	ff 45 08             	incl   0x8(%ebp)
  801713:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801716:	0f af 45 10          	imul   0x10(%ebp),%eax
  80171a:	89 c2                	mov    %eax,%edx
  80171c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171f:	01 d0                	add    %edx,%eax
  801721:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801724:	e9 7b ff ff ff       	jmp    8016a4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801729:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80172a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80172e:	74 08                	je     801738 <strtol+0x134>
		*endptr = (char *) s;
  801730:	8b 45 0c             	mov    0xc(%ebp),%eax
  801733:	8b 55 08             	mov    0x8(%ebp),%edx
  801736:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801738:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80173c:	74 07                	je     801745 <strtol+0x141>
  80173e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801741:	f7 d8                	neg    %eax
  801743:	eb 03                	jmp    801748 <strtol+0x144>
  801745:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <ltostr>:

void
ltostr(long value, char *str)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801750:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801757:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80175e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801762:	79 13                	jns    801777 <ltostr+0x2d>
	{
		neg = 1;
  801764:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80176b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801771:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801774:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80177f:	99                   	cltd   
  801780:	f7 f9                	idiv   %ecx
  801782:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801785:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801788:	8d 50 01             	lea    0x1(%eax),%edx
  80178b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80178e:	89 c2                	mov    %eax,%edx
  801790:	8b 45 0c             	mov    0xc(%ebp),%eax
  801793:	01 d0                	add    %edx,%eax
  801795:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801798:	83 c2 30             	add    $0x30,%edx
  80179b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80179d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017a5:	f7 e9                	imul   %ecx
  8017a7:	c1 fa 02             	sar    $0x2,%edx
  8017aa:	89 c8                	mov    %ecx,%eax
  8017ac:	c1 f8 1f             	sar    $0x1f,%eax
  8017af:	29 c2                	sub    %eax,%edx
  8017b1:	89 d0                	mov    %edx,%eax
  8017b3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8017b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017ba:	75 bb                	jne    801777 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c6:	48                   	dec    %eax
  8017c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017ce:	74 3d                	je     80180d <ltostr+0xc3>
		start = 1 ;
  8017d0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017d7:	eb 34                	jmp    80180d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8017d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017df:	01 d0                	add    %edx,%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	01 c2                	add    %eax,%edx
  8017ee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f4:	01 c8                	add    %ecx,%eax
  8017f6:	8a 00                	mov    (%eax),%al
  8017f8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801800:	01 c2                	add    %eax,%edx
  801802:	8a 45 eb             	mov    -0x15(%ebp),%al
  801805:	88 02                	mov    %al,(%edx)
		start++ ;
  801807:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80180a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80180d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801810:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801813:	7c c4                	jl     8017d9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801815:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801818:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181b:	01 d0                	add    %edx,%eax
  80181d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801820:	90                   	nop
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	e8 73 fa ff ff       	call   8012a4 <strlen>
  801831:	83 c4 04             	add    $0x4,%esp
  801834:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	e8 65 fa ff ff       	call   8012a4 <strlen>
  80183f:	83 c4 04             	add    $0x4,%esp
  801842:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801845:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80184c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801853:	eb 17                	jmp    80186c <strcconcat+0x49>
		final[s] = str1[s] ;
  801855:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801858:	8b 45 10             	mov    0x10(%ebp),%eax
  80185b:	01 c2                	add    %eax,%edx
  80185d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	01 c8                	add    %ecx,%eax
  801865:	8a 00                	mov    (%eax),%al
  801867:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801869:	ff 45 fc             	incl   -0x4(%ebp)
  80186c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80186f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801872:	7c e1                	jl     801855 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801874:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80187b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801882:	eb 1f                	jmp    8018a3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801884:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801887:	8d 50 01             	lea    0x1(%eax),%edx
  80188a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80188d:	89 c2                	mov    %eax,%edx
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	01 c2                	add    %eax,%edx
  801894:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801897:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189a:	01 c8                	add    %ecx,%eax
  80189c:	8a 00                	mov    (%eax),%al
  80189e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018a0:	ff 45 f8             	incl   -0x8(%ebp)
  8018a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018a9:	7c d9                	jl     801884 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b1:	01 d0                	add    %edx,%eax
  8018b3:	c6 00 00             	movb   $0x0,(%eax)
}
  8018b6:	90                   	nop
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c8:	8b 00                	mov    (%eax),%eax
  8018ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d4:	01 d0                	add    %edx,%eax
  8018d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018dc:	eb 0c                	jmp    8018ea <strsplit+0x31>
			*string++ = 0;
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8d 50 01             	lea    0x1(%eax),%edx
  8018e4:	89 55 08             	mov    %edx,0x8(%ebp)
  8018e7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	8a 00                	mov    (%eax),%al
  8018ef:	84 c0                	test   %al,%al
  8018f1:	74 18                	je     80190b <strsplit+0x52>
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	0f be c0             	movsbl %al,%eax
  8018fb:	50                   	push   %eax
  8018fc:	ff 75 0c             	pushl  0xc(%ebp)
  8018ff:	e8 32 fb ff ff       	call   801436 <strchr>
  801904:	83 c4 08             	add    $0x8,%esp
  801907:	85 c0                	test   %eax,%eax
  801909:	75 d3                	jne    8018de <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	8a 00                	mov    (%eax),%al
  801910:	84 c0                	test   %al,%al
  801912:	74 5a                	je     80196e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801914:	8b 45 14             	mov    0x14(%ebp),%eax
  801917:	8b 00                	mov    (%eax),%eax
  801919:	83 f8 0f             	cmp    $0xf,%eax
  80191c:	75 07                	jne    801925 <strsplit+0x6c>
		{
			return 0;
  80191e:	b8 00 00 00 00       	mov    $0x0,%eax
  801923:	eb 66                	jmp    80198b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801925:	8b 45 14             	mov    0x14(%ebp),%eax
  801928:	8b 00                	mov    (%eax),%eax
  80192a:	8d 48 01             	lea    0x1(%eax),%ecx
  80192d:	8b 55 14             	mov    0x14(%ebp),%edx
  801930:	89 0a                	mov    %ecx,(%edx)
  801932:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801939:	8b 45 10             	mov    0x10(%ebp),%eax
  80193c:	01 c2                	add    %eax,%edx
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801943:	eb 03                	jmp    801948 <strsplit+0x8f>
			string++;
  801945:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	8a 00                	mov    (%eax),%al
  80194d:	84 c0                	test   %al,%al
  80194f:	74 8b                	je     8018dc <strsplit+0x23>
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	8a 00                	mov    (%eax),%al
  801956:	0f be c0             	movsbl %al,%eax
  801959:	50                   	push   %eax
  80195a:	ff 75 0c             	pushl  0xc(%ebp)
  80195d:	e8 d4 fa ff ff       	call   801436 <strchr>
  801962:	83 c4 08             	add    $0x8,%esp
  801965:	85 c0                	test   %eax,%eax
  801967:	74 dc                	je     801945 <strsplit+0x8c>
			string++;
	}
  801969:	e9 6e ff ff ff       	jmp    8018dc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80196e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80196f:	8b 45 14             	mov    0x14(%ebp),%eax
  801972:	8b 00                	mov    (%eax),%eax
  801974:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80197b:	8b 45 10             	mov    0x10(%ebp),%eax
  80197e:	01 d0                	add    %edx,%eax
  801980:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801986:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801993:	83 ec 04             	sub    $0x4,%esp
  801996:	68 1c 4a 80 00       	push   $0x804a1c
  80199b:	68 3f 01 00 00       	push   $0x13f
  8019a0:	68 3e 4a 80 00       	push   $0x804a3e
  8019a5:	e8 a1 ed ff ff       	call   80074b <_panic>

008019aa <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8019b0:	83 ec 0c             	sub    $0xc,%esp
  8019b3:	ff 75 08             	pushl  0x8(%ebp)
  8019b6:	e8 f8 0a 00 00       	call   8024b3 <sys_sbrk>
  8019bb:	83 c4 10             	add    $0x10,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8019c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019ca:	75 0a                	jne    8019d6 <malloc+0x16>
  8019cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d1:	e9 07 02 00 00       	jmp    801bdd <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  8019d6:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8019dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8019e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019e3:	01 d0                	add    %edx,%eax
  8019e5:	48                   	dec    %eax
  8019e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f1:	f7 75 dc             	divl   -0x24(%ebp)
  8019f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019f7:	29 d0                	sub    %edx,%eax
  8019f9:	c1 e8 0c             	shr    $0xc,%eax
  8019fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  8019ff:	a1 24 50 80 00       	mov    0x805024,%eax
  801a04:	8b 40 78             	mov    0x78(%eax),%eax
  801a07:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801a0c:	29 c2                	sub    %eax,%edx
  801a0e:	89 d0                	mov    %edx,%eax
  801a10:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801a13:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a1b:	c1 e8 0c             	shr    $0xc,%eax
  801a1e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801a21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801a28:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801a2f:	77 42                	ja     801a73 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a31:	e8 01 09 00 00       	call   802337 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a36:	85 c0                	test   %eax,%eax
  801a38:	74 16                	je     801a50 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801a3a:	83 ec 0c             	sub    $0xc,%esp
  801a3d:	ff 75 08             	pushl  0x8(%ebp)
  801a40:	e8 dd 0e 00 00       	call   802922 <alloc_block_FF>
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a4b:	e9 8a 01 00 00       	jmp    801bda <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801a50:	e8 13 09 00 00       	call   802368 <sys_isUHeapPlacementStrategyBESTFIT>
  801a55:	85 c0                	test   %eax,%eax
  801a57:	0f 84 7d 01 00 00    	je     801bda <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801a5d:	83 ec 0c             	sub    $0xc,%esp
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	e8 76 13 00 00       	call   802dde <alloc_block_BF>
  801a68:	83 c4 10             	add    $0x10,%esp
  801a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a6e:	e9 67 01 00 00       	jmp    801bda <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801a73:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a76:	48                   	dec    %eax
  801a77:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801a7a:	0f 86 53 01 00 00    	jbe    801bd3 <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801a80:	a1 24 50 80 00       	mov    0x805024,%eax
  801a85:	8b 40 78             	mov    0x78(%eax),%eax
  801a88:	05 00 10 00 00       	add    $0x1000,%eax
  801a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801a90:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801a97:	e9 de 00 00 00       	jmp    801b7a <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801a9c:	a1 24 50 80 00       	mov    0x805024,%eax
  801aa1:	8b 40 78             	mov    0x78(%eax),%eax
  801aa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aa7:	29 c2                	sub    %eax,%edx
  801aa9:	89 d0                	mov    %edx,%eax
  801aab:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ab0:	c1 e8 0c             	shr    $0xc,%eax
  801ab3:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801aba:	85 c0                	test   %eax,%eax
  801abc:	0f 85 ab 00 00 00    	jne    801b6d <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac5:	05 00 10 00 00       	add    $0x1000,%eax
  801aca:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801acd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  801ad4:	eb 47                	jmp    801b1d <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801ad6:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801add:	76 0a                	jbe    801ae9 <malloc+0x129>
  801adf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae4:	e9 f4 00 00 00       	jmp    801bdd <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801ae9:	a1 24 50 80 00       	mov    0x805024,%eax
  801aee:	8b 40 78             	mov    0x78(%eax),%eax
  801af1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801af4:	29 c2                	sub    %eax,%edx
  801af6:	89 d0                	mov    %edx,%eax
  801af8:	2d 00 10 00 00       	sub    $0x1000,%eax
  801afd:	c1 e8 0c             	shr    $0xc,%eax
  801b00:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801b07:	85 c0                	test   %eax,%eax
  801b09:	74 08                	je     801b13 <malloc+0x153>
					{
						
						i = j;
  801b0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801b11:	eb 5a                	jmp    801b6d <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801b13:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801b1a:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  801b1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b20:	48                   	dec    %eax
  801b21:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b24:	77 b0                	ja     801ad6 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801b26:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801b2d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b34:	eb 2f                	jmp    801b65 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801b36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b39:	c1 e0 0c             	shl    $0xc,%eax
  801b3c:	89 c2                	mov    %eax,%edx
  801b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b41:	01 c2                	add    %eax,%edx
  801b43:	a1 24 50 80 00       	mov    0x805024,%eax
  801b48:	8b 40 78             	mov    0x78(%eax),%eax
  801b4b:	29 c2                	sub    %eax,%edx
  801b4d:	89 d0                	mov    %edx,%eax
  801b4f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b54:	c1 e8 0c             	shr    $0xc,%eax
  801b57:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  801b5e:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801b62:	ff 45 e0             	incl   -0x20(%ebp)
  801b65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b68:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b6b:	72 c9                	jb     801b36 <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  801b6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b71:	75 16                	jne    801b89 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801b73:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801b7a:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801b81:	0f 86 15 ff ff ff    	jbe    801a9c <malloc+0xdc>
  801b87:	eb 01                	jmp    801b8a <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  801b89:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801b8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b8e:	75 07                	jne    801b97 <malloc+0x1d7>
  801b90:	b8 00 00 00 00       	mov    $0x0,%eax
  801b95:	eb 46                	jmp    801bdd <malloc+0x21d>
		ptr = (void*)i;
  801b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801b9d:	a1 24 50 80 00       	mov    0x805024,%eax
  801ba2:	8b 40 78             	mov    0x78(%eax),%eax
  801ba5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ba8:	29 c2                	sub    %eax,%edx
  801baa:	89 d0                	mov    %edx,%eax
  801bac:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bb1:	c1 e8 0c             	shr    $0xc,%eax
  801bb4:	89 c2                	mov    %eax,%edx
  801bb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bb9:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801bc0:	83 ec 08             	sub    $0x8,%esp
  801bc3:	ff 75 08             	pushl  0x8(%ebp)
  801bc6:	ff 75 f0             	pushl  -0x10(%ebp)
  801bc9:	e8 1c 09 00 00       	call   8024ea <sys_allocate_user_mem>
  801bce:	83 c4 10             	add    $0x10,%esp
  801bd1:	eb 07                	jmp    801bda <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  801bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd8:	eb 03                	jmp    801bdd <malloc+0x21d>
	}
	return ptr;
  801bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801be5:	a1 24 50 80 00       	mov    0x805024,%eax
  801bea:	8b 40 78             	mov    0x78(%eax),%eax
  801bed:	05 00 10 00 00       	add    $0x1000,%eax
  801bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801bf5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801bfc:	a1 24 50 80 00       	mov    0x805024,%eax
  801c01:	8b 50 78             	mov    0x78(%eax),%edx
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	39 c2                	cmp    %eax,%edx
  801c09:	76 24                	jbe    801c2f <free+0x50>
		size = get_block_size(va);
  801c0b:	83 ec 0c             	sub    $0xc,%esp
  801c0e:	ff 75 08             	pushl  0x8(%ebp)
  801c11:	e8 8c 09 00 00       	call   8025a2 <get_block_size>
  801c16:	83 c4 10             	add    $0x10,%esp
  801c19:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c1c:	83 ec 0c             	sub    $0xc,%esp
  801c1f:	ff 75 08             	pushl  0x8(%ebp)
  801c22:	e8 9c 1b 00 00       	call   8037c3 <free_block>
  801c27:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801c2a:	e9 ac 00 00 00       	jmp    801cdb <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c35:	0f 82 89 00 00 00    	jb     801cc4 <free+0xe5>
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801c43:	77 7f                	ja     801cc4 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801c45:	8b 55 08             	mov    0x8(%ebp),%edx
  801c48:	a1 24 50 80 00       	mov    0x805024,%eax
  801c4d:	8b 40 78             	mov    0x78(%eax),%eax
  801c50:	29 c2                	sub    %eax,%edx
  801c52:	89 d0                	mov    %edx,%eax
  801c54:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c59:	c1 e8 0c             	shr    $0xc,%eax
  801c5c:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801c63:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801c66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c69:	c1 e0 0c             	shl    $0xc,%eax
  801c6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801c6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801c76:	eb 42                	jmp    801cba <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7b:	c1 e0 0c             	shl    $0xc,%eax
  801c7e:	89 c2                	mov    %eax,%edx
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	01 c2                	add    %eax,%edx
  801c85:	a1 24 50 80 00       	mov    0x805024,%eax
  801c8a:	8b 40 78             	mov    0x78(%eax),%eax
  801c8d:	29 c2                	sub    %eax,%edx
  801c8f:	89 d0                	mov    %edx,%eax
  801c91:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c96:	c1 e8 0c             	shr    $0xc,%eax
  801c99:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801ca0:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801ca4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	83 ec 08             	sub    $0x8,%esp
  801cad:	52                   	push   %edx
  801cae:	50                   	push   %eax
  801caf:	e8 1a 08 00 00       	call   8024ce <sys_free_user_mem>
  801cb4:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801cb7:	ff 45 f4             	incl   -0xc(%ebp)
  801cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801cc0:	72 b6                	jb     801c78 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801cc2:	eb 17                	jmp    801cdb <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801cc4:	83 ec 04             	sub    $0x4,%esp
  801cc7:	68 4c 4a 80 00       	push   $0x804a4c
  801ccc:	68 87 00 00 00       	push   $0x87
  801cd1:	68 76 4a 80 00       	push   $0x804a76
  801cd6:	e8 70 ea ff ff       	call   80074b <_panic>
	}
}
  801cdb:	90                   	nop
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 28             	sub    $0x28,%esp
  801ce4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce7:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801cea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cee:	75 0a                	jne    801cfa <smalloc+0x1c>
  801cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf5:	e9 87 00 00 00       	jmp    801d81 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d00:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0d:	39 d0                	cmp    %edx,%eax
  801d0f:	73 02                	jae    801d13 <smalloc+0x35>
  801d11:	89 d0                	mov    %edx,%eax
  801d13:	83 ec 0c             	sub    $0xc,%esp
  801d16:	50                   	push   %eax
  801d17:	e8 a4 fc ff ff       	call   8019c0 <malloc>
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801d22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d26:	75 07                	jne    801d2f <smalloc+0x51>
  801d28:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2d:	eb 52                	jmp    801d81 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d2f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d33:	ff 75 ec             	pushl  -0x14(%ebp)
  801d36:	50                   	push   %eax
  801d37:	ff 75 0c             	pushl  0xc(%ebp)
  801d3a:	ff 75 08             	pushl  0x8(%ebp)
  801d3d:	e8 93 03 00 00       	call   8020d5 <sys_createSharedObject>
  801d42:	83 c4 10             	add    $0x10,%esp
  801d45:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801d48:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801d4c:	74 06                	je     801d54 <smalloc+0x76>
  801d4e:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801d52:	75 07                	jne    801d5b <smalloc+0x7d>
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
  801d59:	eb 26                	jmp    801d81 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801d5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d5e:	a1 24 50 80 00       	mov    0x805024,%eax
  801d63:	8b 40 78             	mov    0x78(%eax),%eax
  801d66:	29 c2                	sub    %eax,%edx
  801d68:	89 d0                	mov    %edx,%eax
  801d6a:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d6f:	c1 e8 0c             	shr    $0xc,%eax
  801d72:	89 c2                	mov    %eax,%edx
  801d74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d77:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801d7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d89:	83 ec 08             	sub    $0x8,%esp
  801d8c:	ff 75 0c             	pushl  0xc(%ebp)
  801d8f:	ff 75 08             	pushl  0x8(%ebp)
  801d92:	e8 68 03 00 00       	call   8020ff <sys_getSizeOfSharedObject>
  801d97:	83 c4 10             	add    $0x10,%esp
  801d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801d9d:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801da1:	75 07                	jne    801daa <sget+0x27>
  801da3:	b8 00 00 00 00       	mov    $0x0,%eax
  801da8:	eb 7f                	jmp    801e29 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801db0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801db7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbd:	39 d0                	cmp    %edx,%eax
  801dbf:	73 02                	jae    801dc3 <sget+0x40>
  801dc1:	89 d0                	mov    %edx,%eax
  801dc3:	83 ec 0c             	sub    $0xc,%esp
  801dc6:	50                   	push   %eax
  801dc7:	e8 f4 fb ff ff       	call   8019c0 <malloc>
  801dcc:	83 c4 10             	add    $0x10,%esp
  801dcf:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801dd2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801dd6:	75 07                	jne    801ddf <sget+0x5c>
  801dd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddd:	eb 4a                	jmp    801e29 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801ddf:	83 ec 04             	sub    $0x4,%esp
  801de2:	ff 75 e8             	pushl  -0x18(%ebp)
  801de5:	ff 75 0c             	pushl  0xc(%ebp)
  801de8:	ff 75 08             	pushl  0x8(%ebp)
  801deb:	e8 2c 03 00 00       	call   80211c <sys_getSharedObject>
  801df0:	83 c4 10             	add    $0x10,%esp
  801df3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801df6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801df9:	a1 24 50 80 00       	mov    0x805024,%eax
  801dfe:	8b 40 78             	mov    0x78(%eax),%eax
  801e01:	29 c2                	sub    %eax,%edx
  801e03:	89 d0                	mov    %edx,%eax
  801e05:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e0a:	c1 e8 0c             	shr    $0xc,%eax
  801e0d:	89 c2                	mov    %eax,%edx
  801e0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e12:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801e19:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801e1d:	75 07                	jne    801e26 <sget+0xa3>
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e24:	eb 03                	jmp    801e29 <sget+0xa6>
	return ptr;
  801e26:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801e31:	8b 55 08             	mov    0x8(%ebp),%edx
  801e34:	a1 24 50 80 00       	mov    0x805024,%eax
  801e39:	8b 40 78             	mov    0x78(%eax),%eax
  801e3c:	29 c2                	sub    %eax,%edx
  801e3e:	89 d0                	mov    %edx,%eax
  801e40:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e45:	c1 e8 0c             	shr    $0xc,%eax
  801e48:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801e52:	83 ec 08             	sub    $0x8,%esp
  801e55:	ff 75 08             	pushl  0x8(%ebp)
  801e58:	ff 75 f4             	pushl  -0xc(%ebp)
  801e5b:	e8 db 02 00 00       	call   80213b <sys_freeSharedObject>
  801e60:	83 c4 10             	add    $0x10,%esp
  801e63:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801e66:	90                   	nop
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e6f:	83 ec 04             	sub    $0x4,%esp
  801e72:	68 84 4a 80 00       	push   $0x804a84
  801e77:	68 e4 00 00 00       	push   $0xe4
  801e7c:	68 76 4a 80 00       	push   $0x804a76
  801e81:	e8 c5 e8 ff ff       	call   80074b <_panic>

00801e86 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e8c:	83 ec 04             	sub    $0x4,%esp
  801e8f:	68 aa 4a 80 00       	push   $0x804aaa
  801e94:	68 f0 00 00 00       	push   $0xf0
  801e99:	68 76 4a 80 00       	push   $0x804a76
  801e9e:	e8 a8 e8 ff ff       	call   80074b <_panic>

00801ea3 <shrink>:

}
void shrink(uint32 newSize)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	68 aa 4a 80 00       	push   $0x804aaa
  801eb1:	68 f5 00 00 00       	push   $0xf5
  801eb6:	68 76 4a 80 00       	push   $0x804a76
  801ebb:	e8 8b e8 ff ff       	call   80074b <_panic>

00801ec0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec6:	83 ec 04             	sub    $0x4,%esp
  801ec9:	68 aa 4a 80 00       	push   $0x804aaa
  801ece:	68 fa 00 00 00       	push   $0xfa
  801ed3:	68 76 4a 80 00       	push   $0x804a76
  801ed8:	e8 6e e8 ff ff       	call   80074b <_panic>

00801edd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	57                   	push   %edi
  801ee1:	56                   	push   %esi
  801ee2:	53                   	push   %ebx
  801ee3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef2:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ef5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ef8:	cd 30                	int    $0x30
  801efa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	5b                   	pop    %ebx
  801f04:	5e                   	pop    %esi
  801f05:	5f                   	pop    %edi
  801f06:	5d                   	pop    %ebp
  801f07:	c3                   	ret    

00801f08 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 04             	sub    $0x4,%esp
  801f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f11:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f14:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	52                   	push   %edx
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	50                   	push   %eax
  801f24:	6a 00                	push   $0x0
  801f26:	e8 b2 ff ff ff       	call   801edd <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
}
  801f2e:	90                   	nop
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 02                	push   $0x2
  801f40:	e8 98 ff ff ff       	call   801edd <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <sys_lock_cons>:

void sys_lock_cons(void)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 03                	push   $0x3
  801f59:	e8 7f ff ff ff       	call   801edd <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
}
  801f61:	90                   	nop
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 04                	push   $0x4
  801f73:	e8 65 ff ff ff       	call   801edd <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
}
  801f7b:	90                   	nop
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	52                   	push   %edx
  801f8e:	50                   	push   %eax
  801f8f:	6a 08                	push   $0x8
  801f91:	e8 47 ff ff ff       	call   801edd <syscall>
  801f96:	83 c4 18             	add    $0x18,%esp
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	56                   	push   %esi
  801f9f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fa0:	8b 75 18             	mov    0x18(%ebp),%esi
  801fa3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	56                   	push   %esi
  801fb0:	53                   	push   %ebx
  801fb1:	51                   	push   %ecx
  801fb2:	52                   	push   %edx
  801fb3:	50                   	push   %eax
  801fb4:	6a 09                	push   $0x9
  801fb6:	e8 22 ff ff ff       	call   801edd <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
}
  801fbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc1:	5b                   	pop    %ebx
  801fc2:	5e                   	pop    %esi
  801fc3:	5d                   	pop    %ebp
  801fc4:	c3                   	ret    

00801fc5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	52                   	push   %edx
  801fd5:	50                   	push   %eax
  801fd6:	6a 0a                	push   $0xa
  801fd8:	e8 00 ff ff ff       	call   801edd <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	ff 75 0c             	pushl  0xc(%ebp)
  801fee:	ff 75 08             	pushl  0x8(%ebp)
  801ff1:	6a 0b                	push   $0xb
  801ff3:	e8 e5 fe ff ff       	call   801edd <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 0c                	push   $0xc
  80200c:	e8 cc fe ff ff       	call   801edd <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 0d                	push   $0xd
  802025:	e8 b3 fe ff ff       	call   801edd <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 0e                	push   $0xe
  80203e:	e8 9a fe ff ff       	call   801edd <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 0f                	push   $0xf
  802057:	e8 81 fe ff ff       	call   801edd <syscall>
  80205c:	83 c4 18             	add    $0x18,%esp
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	ff 75 08             	pushl  0x8(%ebp)
  80206f:	6a 10                	push   $0x10
  802071:	e8 67 fe ff ff       	call   801edd <syscall>
  802076:	83 c4 18             	add    $0x18,%esp
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 11                	push   $0x11
  80208a:	e8 4e fe ff ff       	call   801edd <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	90                   	nop
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <sys_cputc>:

void
sys_cputc(const char c)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020a1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	50                   	push   %eax
  8020ae:	6a 01                	push   $0x1
  8020b0:	e8 28 fe ff ff       	call   801edd <syscall>
  8020b5:	83 c4 18             	add    $0x18,%esp
}
  8020b8:	90                   	nop
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 14                	push   $0x14
  8020ca:	e8 0e fe ff ff       	call   801edd <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
}
  8020d2:	90                   	nop
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 04             	sub    $0x4,%esp
  8020db:	8b 45 10             	mov    0x10(%ebp),%eax
  8020de:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020e1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020e4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	6a 00                	push   $0x0
  8020ed:	51                   	push   %ecx
  8020ee:	52                   	push   %edx
  8020ef:	ff 75 0c             	pushl  0xc(%ebp)
  8020f2:	50                   	push   %eax
  8020f3:	6a 15                	push   $0x15
  8020f5:	e8 e3 fd ff ff       	call   801edd <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802102:	8b 55 0c             	mov    0xc(%ebp),%edx
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	52                   	push   %edx
  80210f:	50                   	push   %eax
  802110:	6a 16                	push   $0x16
  802112:	e8 c6 fd ff ff       	call   801edd <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80211f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802122:	8b 55 0c             	mov    0xc(%ebp),%edx
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	51                   	push   %ecx
  80212d:	52                   	push   %edx
  80212e:	50                   	push   %eax
  80212f:	6a 17                	push   $0x17
  802131:	e8 a7 fd ff ff       	call   801edd <syscall>
  802136:	83 c4 18             	add    $0x18,%esp
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80213e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	52                   	push   %edx
  80214b:	50                   	push   %eax
  80214c:	6a 18                	push   $0x18
  80214e:	e8 8a fd ff ff       	call   801edd <syscall>
  802153:	83 c4 18             	add    $0x18,%esp
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	6a 00                	push   $0x0
  802160:	ff 75 14             	pushl  0x14(%ebp)
  802163:	ff 75 10             	pushl  0x10(%ebp)
  802166:	ff 75 0c             	pushl  0xc(%ebp)
  802169:	50                   	push   %eax
  80216a:	6a 19                	push   $0x19
  80216c:	e8 6c fd ff ff       	call   801edd <syscall>
  802171:	83 c4 18             	add    $0x18,%esp
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	50                   	push   %eax
  802185:	6a 1a                	push   $0x1a
  802187:	e8 51 fd ff ff       	call   801edd <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
}
  80218f:	90                   	nop
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	50                   	push   %eax
  8021a1:	6a 1b                	push   $0x1b
  8021a3:	e8 35 fd ff ff       	call   801edd <syscall>
  8021a8:	83 c4 18             	add    $0x18,%esp
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <sys_getenvid>:

int32 sys_getenvid(void)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 05                	push   $0x5
  8021bc:	e8 1c fd ff ff       	call   801edd <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 06                	push   $0x6
  8021d5:	e8 03 fd ff ff       	call   801edd <syscall>
  8021da:	83 c4 18             	add    $0x18,%esp
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 07                	push   $0x7
  8021ee:	e8 ea fc ff ff       	call   801edd <syscall>
  8021f3:	83 c4 18             	add    $0x18,%esp
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <sys_exit_env>:


void sys_exit_env(void)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 1c                	push   $0x1c
  802207:	e8 d1 fc ff ff       	call   801edd <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	90                   	nop
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802218:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80221b:	8d 50 04             	lea    0x4(%eax),%edx
  80221e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	52                   	push   %edx
  802228:	50                   	push   %eax
  802229:	6a 1d                	push   $0x1d
  80222b:	e8 ad fc ff ff       	call   801edd <syscall>
  802230:	83 c4 18             	add    $0x18,%esp
	return result;
  802233:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802236:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802239:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80223c:	89 01                	mov    %eax,(%ecx)
  80223e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	c9                   	leave  
  802245:	c2 04 00             	ret    $0x4

00802248 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	ff 75 10             	pushl  0x10(%ebp)
  802252:	ff 75 0c             	pushl  0xc(%ebp)
  802255:	ff 75 08             	pushl  0x8(%ebp)
  802258:	6a 13                	push   $0x13
  80225a:	e8 7e fc ff ff       	call   801edd <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
	return ;
  802262:	90                   	nop
}
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <sys_rcr2>:
uint32 sys_rcr2()
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 1e                	push   $0x1e
  802274:	e8 64 fc ff ff       	call   801edd <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	83 ec 04             	sub    $0x4,%esp
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80228a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	50                   	push   %eax
  802297:	6a 1f                	push   $0x1f
  802299:	e8 3f fc ff ff       	call   801edd <syscall>
  80229e:	83 c4 18             	add    $0x18,%esp
	return ;
  8022a1:	90                   	nop
}
  8022a2:	c9                   	leave  
  8022a3:	c3                   	ret    

008022a4 <rsttst>:
void rsttst()
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 21                	push   $0x21
  8022b3:	e8 25 fc ff ff       	call   801edd <syscall>
  8022b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8022bb:	90                   	nop
}
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	83 ec 04             	sub    $0x4,%esp
  8022c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022ca:	8b 55 18             	mov    0x18(%ebp),%edx
  8022cd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022d1:	52                   	push   %edx
  8022d2:	50                   	push   %eax
  8022d3:	ff 75 10             	pushl  0x10(%ebp)
  8022d6:	ff 75 0c             	pushl  0xc(%ebp)
  8022d9:	ff 75 08             	pushl  0x8(%ebp)
  8022dc:	6a 20                	push   $0x20
  8022de:	e8 fa fb ff ff       	call   801edd <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e6:	90                   	nop
}
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <chktst>:
void chktst(uint32 n)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	ff 75 08             	pushl  0x8(%ebp)
  8022f7:	6a 22                	push   $0x22
  8022f9:	e8 df fb ff ff       	call   801edd <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802301:	90                   	nop
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <inctst>:

void inctst()
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 23                	push   $0x23
  802313:	e8 c5 fb ff ff       	call   801edd <syscall>
  802318:	83 c4 18             	add    $0x18,%esp
	return ;
  80231b:	90                   	nop
}
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <gettst>:
uint32 gettst()
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 24                	push   $0x24
  80232d:	e8 ab fb ff ff       	call   801edd <syscall>
  802332:	83 c4 18             	add    $0x18,%esp
}
  802335:	c9                   	leave  
  802336:	c3                   	ret    

00802337 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 25                	push   $0x25
  802349:	e8 8f fb ff ff       	call   801edd <syscall>
  80234e:	83 c4 18             	add    $0x18,%esp
  802351:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802354:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802358:	75 07                	jne    802361 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80235a:	b8 01 00 00 00       	mov    $0x1,%eax
  80235f:	eb 05                	jmp    802366 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802361:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 25                	push   $0x25
  80237a:	e8 5e fb ff ff       	call   801edd <syscall>
  80237f:	83 c4 18             	add    $0x18,%esp
  802382:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802385:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802389:	75 07                	jne    802392 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80238b:	b8 01 00 00 00       	mov    $0x1,%eax
  802390:	eb 05                	jmp    802397 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802392:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 25                	push   $0x25
  8023ab:	e8 2d fb ff ff       	call   801edd <syscall>
  8023b0:	83 c4 18             	add    $0x18,%esp
  8023b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023b6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023ba:	75 07                	jne    8023c3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c1:	eb 05                	jmp    8023c8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 25                	push   $0x25
  8023dc:	e8 fc fa ff ff       	call   801edd <syscall>
  8023e1:	83 c4 18             	add    $0x18,%esp
  8023e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023e7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023eb:	75 07                	jne    8023f4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f2:	eb 05                	jmp    8023f9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	ff 75 08             	pushl  0x8(%ebp)
  802409:	6a 26                	push   $0x26
  80240b:	e8 cd fa ff ff       	call   801edd <syscall>
  802410:	83 c4 18             	add    $0x18,%esp
	return ;
  802413:	90                   	nop
}
  802414:	c9                   	leave  
  802415:	c3                   	ret    

00802416 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
  802419:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80241a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80241d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802420:	8b 55 0c             	mov    0xc(%ebp),%edx
  802423:	8b 45 08             	mov    0x8(%ebp),%eax
  802426:	6a 00                	push   $0x0
  802428:	53                   	push   %ebx
  802429:	51                   	push   %ecx
  80242a:	52                   	push   %edx
  80242b:	50                   	push   %eax
  80242c:	6a 27                	push   $0x27
  80242e:	e8 aa fa ff ff       	call   801edd <syscall>
  802433:	83 c4 18             	add    $0x18,%esp
}
  802436:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802439:	c9                   	leave  
  80243a:	c3                   	ret    

0080243b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80243e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802441:	8b 45 08             	mov    0x8(%ebp),%eax
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	52                   	push   %edx
  80244b:	50                   	push   %eax
  80244c:	6a 28                	push   $0x28
  80244e:	e8 8a fa ff ff       	call   801edd <syscall>
  802453:	83 c4 18             	add    $0x18,%esp
}
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80245b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80245e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	6a 00                	push   $0x0
  802466:	51                   	push   %ecx
  802467:	ff 75 10             	pushl  0x10(%ebp)
  80246a:	52                   	push   %edx
  80246b:	50                   	push   %eax
  80246c:	6a 29                	push   $0x29
  80246e:	e8 6a fa ff ff       	call   801edd <syscall>
  802473:	83 c4 18             	add    $0x18,%esp
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	ff 75 10             	pushl  0x10(%ebp)
  802482:	ff 75 0c             	pushl  0xc(%ebp)
  802485:	ff 75 08             	pushl  0x8(%ebp)
  802488:	6a 12                	push   $0x12
  80248a:	e8 4e fa ff ff       	call   801edd <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
	return ;
  802492:	90                   	nop
}
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	52                   	push   %edx
  8024a5:	50                   	push   %eax
  8024a6:	6a 2a                	push   $0x2a
  8024a8:	e8 30 fa ff ff       	call   801edd <syscall>
  8024ad:	83 c4 18             	add    $0x18,%esp
	return;
  8024b0:	90                   	nop
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	50                   	push   %eax
  8024c2:	6a 2b                	push   $0x2b
  8024c4:	e8 14 fa ff ff       	call   801edd <syscall>
  8024c9:	83 c4 18             	add    $0x18,%esp
}
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	ff 75 0c             	pushl  0xc(%ebp)
  8024da:	ff 75 08             	pushl  0x8(%ebp)
  8024dd:	6a 2c                	push   $0x2c
  8024df:	e8 f9 f9 ff ff       	call   801edd <syscall>
  8024e4:	83 c4 18             	add    $0x18,%esp
	return;
  8024e7:	90                   	nop
}
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    

008024ea <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	ff 75 0c             	pushl  0xc(%ebp)
  8024f6:	ff 75 08             	pushl  0x8(%ebp)
  8024f9:	6a 2d                	push   $0x2d
  8024fb:	e8 dd f9 ff ff       	call   801edd <syscall>
  802500:	83 c4 18             	add    $0x18,%esp
	return;
  802503:	90                   	nop
}
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 2e                	push   $0x2e
  802518:	e8 c0 f9 ff ff       	call   801edd <syscall>
  80251d:	83 c4 18             	add    $0x18,%esp
  802520:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  802523:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802526:	c9                   	leave  
  802527:	c3                   	ret    

00802528 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  802528:	55                   	push   %ebp
  802529:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	50                   	push   %eax
  802537:	6a 2f                	push   $0x2f
  802539:	e8 9f f9 ff ff       	call   801edd <syscall>
  80253e:	83 c4 18             	add    $0x18,%esp
	return;
  802541:	90                   	nop
}
  802542:	c9                   	leave  
  802543:	c3                   	ret    

00802544 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  802547:	8b 55 0c             	mov    0xc(%ebp),%edx
  80254a:	8b 45 08             	mov    0x8(%ebp),%eax
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	52                   	push   %edx
  802554:	50                   	push   %eax
  802555:	6a 30                	push   $0x30
  802557:	e8 81 f9 ff ff       	call   801edd <syscall>
  80255c:	83 c4 18             	add    $0x18,%esp
	return;
  80255f:	90                   	nop
}
  802560:	c9                   	leave  
  802561:	c3                   	ret    

00802562 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
  802565:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  802568:	8b 45 08             	mov    0x8(%ebp),%eax
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	50                   	push   %eax
  802574:	6a 31                	push   $0x31
  802576:	e8 62 f9 ff ff       	call   801edd <syscall>
  80257b:	83 c4 18             	add    $0x18,%esp
  80257e:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  802581:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802584:	c9                   	leave  
  802585:	c3                   	ret    

00802586 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  802589:	8b 45 08             	mov    0x8(%ebp),%eax
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	50                   	push   %eax
  802595:	6a 32                	push   $0x32
  802597:	e8 41 f9 ff ff       	call   801edd <syscall>
  80259c:	83 c4 18             	add    $0x18,%esp
	return;
  80259f:	90                   	nop
}
  8025a0:	c9                   	leave  
  8025a1:	c3                   	ret    

008025a2 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8025a2:	55                   	push   %ebp
  8025a3:	89 e5                	mov    %esp,%ebp
  8025a5:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ab:	83 e8 04             	sub    $0x4,%eax
  8025ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8025b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025b4:	8b 00                	mov    (%eax),%eax
  8025b6:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8025b9:	c9                   	leave  
  8025ba:	c3                   	ret    

008025bb <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8025bb:	55                   	push   %ebp
  8025bc:	89 e5                	mov    %esp,%ebp
  8025be:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	83 e8 04             	sub    $0x4,%eax
  8025c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8025ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025cd:	8b 00                	mov    (%eax),%eax
  8025cf:	83 e0 01             	and    $0x1,%eax
  8025d2:	85 c0                	test   %eax,%eax
  8025d4:	0f 94 c0             	sete   %al
}
  8025d7:	c9                   	leave  
  8025d8:	c3                   	ret    

008025d9 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
  8025dc:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8025df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8025e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e9:	83 f8 02             	cmp    $0x2,%eax
  8025ec:	74 2b                	je     802619 <alloc_block+0x40>
  8025ee:	83 f8 02             	cmp    $0x2,%eax
  8025f1:	7f 07                	jg     8025fa <alloc_block+0x21>
  8025f3:	83 f8 01             	cmp    $0x1,%eax
  8025f6:	74 0e                	je     802606 <alloc_block+0x2d>
  8025f8:	eb 58                	jmp    802652 <alloc_block+0x79>
  8025fa:	83 f8 03             	cmp    $0x3,%eax
  8025fd:	74 2d                	je     80262c <alloc_block+0x53>
  8025ff:	83 f8 04             	cmp    $0x4,%eax
  802602:	74 3b                	je     80263f <alloc_block+0x66>
  802604:	eb 4c                	jmp    802652 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802606:	83 ec 0c             	sub    $0xc,%esp
  802609:	ff 75 08             	pushl  0x8(%ebp)
  80260c:	e8 11 03 00 00       	call   802922 <alloc_block_FF>
  802611:	83 c4 10             	add    $0x10,%esp
  802614:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802617:	eb 4a                	jmp    802663 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802619:	83 ec 0c             	sub    $0xc,%esp
  80261c:	ff 75 08             	pushl  0x8(%ebp)
  80261f:	e8 c7 19 00 00       	call   803feb <alloc_block_NF>
  802624:	83 c4 10             	add    $0x10,%esp
  802627:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80262a:	eb 37                	jmp    802663 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80262c:	83 ec 0c             	sub    $0xc,%esp
  80262f:	ff 75 08             	pushl  0x8(%ebp)
  802632:	e8 a7 07 00 00       	call   802dde <alloc_block_BF>
  802637:	83 c4 10             	add    $0x10,%esp
  80263a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80263d:	eb 24                	jmp    802663 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80263f:	83 ec 0c             	sub    $0xc,%esp
  802642:	ff 75 08             	pushl  0x8(%ebp)
  802645:	e8 84 19 00 00       	call   803fce <alloc_block_WF>
  80264a:	83 c4 10             	add    $0x10,%esp
  80264d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802650:	eb 11                	jmp    802663 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802652:	83 ec 0c             	sub    $0xc,%esp
  802655:	68 bc 4a 80 00       	push   $0x804abc
  80265a:	e8 a9 e3 ff ff       	call   800a08 <cprintf>
  80265f:	83 c4 10             	add    $0x10,%esp
		break;
  802662:	90                   	nop
	}
	return va;
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802666:	c9                   	leave  
  802667:	c3                   	ret    

00802668 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802668:	55                   	push   %ebp
  802669:	89 e5                	mov    %esp,%ebp
  80266b:	53                   	push   %ebx
  80266c:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80266f:	83 ec 0c             	sub    $0xc,%esp
  802672:	68 dc 4a 80 00       	push   $0x804adc
  802677:	e8 8c e3 ff ff       	call   800a08 <cprintf>
  80267c:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80267f:	83 ec 0c             	sub    $0xc,%esp
  802682:	68 07 4b 80 00       	push   $0x804b07
  802687:	e8 7c e3 ff ff       	call   800a08 <cprintf>
  80268c:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80268f:	8b 45 08             	mov    0x8(%ebp),%eax
  802692:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802695:	eb 37                	jmp    8026ce <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802697:	83 ec 0c             	sub    $0xc,%esp
  80269a:	ff 75 f4             	pushl  -0xc(%ebp)
  80269d:	e8 19 ff ff ff       	call   8025bb <is_free_block>
  8026a2:	83 c4 10             	add    $0x10,%esp
  8026a5:	0f be d8             	movsbl %al,%ebx
  8026a8:	83 ec 0c             	sub    $0xc,%esp
  8026ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ae:	e8 ef fe ff ff       	call   8025a2 <get_block_size>
  8026b3:	83 c4 10             	add    $0x10,%esp
  8026b6:	83 ec 04             	sub    $0x4,%esp
  8026b9:	53                   	push   %ebx
  8026ba:	50                   	push   %eax
  8026bb:	68 1f 4b 80 00       	push   $0x804b1f
  8026c0:	e8 43 e3 ff ff       	call   800a08 <cprintf>
  8026c5:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8026cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d2:	74 07                	je     8026db <print_blocks_list+0x73>
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 00                	mov    (%eax),%eax
  8026d9:	eb 05                	jmp    8026e0 <print_blocks_list+0x78>
  8026db:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e0:	89 45 10             	mov    %eax,0x10(%ebp)
  8026e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	75 ad                	jne    802697 <print_blocks_list+0x2f>
  8026ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ee:	75 a7                	jne    802697 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8026f0:	83 ec 0c             	sub    $0xc,%esp
  8026f3:	68 dc 4a 80 00       	push   $0x804adc
  8026f8:	e8 0b e3 ff ff       	call   800a08 <cprintf>
  8026fd:	83 c4 10             	add    $0x10,%esp

}
  802700:	90                   	nop
  802701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80270c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80270f:	83 e0 01             	and    $0x1,%eax
  802712:	85 c0                	test   %eax,%eax
  802714:	74 03                	je     802719 <initialize_dynamic_allocator+0x13>
  802716:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802719:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80271d:	0f 84 c7 01 00 00    	je     8028ea <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802723:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  80272a:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80272d:	8b 55 08             	mov    0x8(%ebp),%edx
  802730:	8b 45 0c             	mov    0xc(%ebp),%eax
  802733:	01 d0                	add    %edx,%eax
  802735:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80273a:	0f 87 ad 01 00 00    	ja     8028ed <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802740:	8b 45 08             	mov    0x8(%ebp),%eax
  802743:	85 c0                	test   %eax,%eax
  802745:	0f 89 a5 01 00 00    	jns    8028f0 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80274b:	8b 55 08             	mov    0x8(%ebp),%edx
  80274e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802751:	01 d0                	add    %edx,%eax
  802753:	83 e8 04             	sub    $0x4,%eax
  802756:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  80275b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802762:	a1 30 50 80 00       	mov    0x805030,%eax
  802767:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276a:	e9 87 00 00 00       	jmp    8027f6 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80276f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802773:	75 14                	jne    802789 <initialize_dynamic_allocator+0x83>
  802775:	83 ec 04             	sub    $0x4,%esp
  802778:	68 37 4b 80 00       	push   $0x804b37
  80277d:	6a 79                	push   $0x79
  80277f:	68 55 4b 80 00       	push   $0x804b55
  802784:	e8 c2 df ff ff       	call   80074b <_panic>
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	8b 00                	mov    (%eax),%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	74 10                	je     8027a2 <initialize_dynamic_allocator+0x9c>
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 00                	mov    (%eax),%eax
  802797:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279a:	8b 52 04             	mov    0x4(%edx),%edx
  80279d:	89 50 04             	mov    %edx,0x4(%eax)
  8027a0:	eb 0b                	jmp    8027ad <initialize_dynamic_allocator+0xa7>
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 40 04             	mov    0x4(%eax),%eax
  8027a8:	a3 34 50 80 00       	mov    %eax,0x805034
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	8b 40 04             	mov    0x4(%eax),%eax
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	74 0f                	je     8027c6 <initialize_dynamic_allocator+0xc0>
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 40 04             	mov    0x4(%eax),%eax
  8027bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c0:	8b 12                	mov    (%edx),%edx
  8027c2:	89 10                	mov    %edx,(%eax)
  8027c4:	eb 0a                	jmp    8027d0 <initialize_dynamic_allocator+0xca>
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	8b 00                	mov    (%eax),%eax
  8027cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027e8:	48                   	dec    %eax
  8027e9:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8027ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8027f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fa:	74 07                	je     802803 <initialize_dynamic_allocator+0xfd>
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	eb 05                	jmp    802808 <initialize_dynamic_allocator+0x102>
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
  802808:	a3 38 50 80 00       	mov    %eax,0x805038
  80280d:	a1 38 50 80 00       	mov    0x805038,%eax
  802812:	85 c0                	test   %eax,%eax
  802814:	0f 85 55 ff ff ff    	jne    80276f <initialize_dynamic_allocator+0x69>
  80281a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281e:	0f 85 4b ff ff ff    	jne    80276f <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802824:	8b 45 08             	mov    0x8(%ebp),%eax
  802827:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80282a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802833:	a1 48 50 80 00       	mov    0x805048,%eax
  802838:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  80283d:	a1 44 50 80 00       	mov    0x805044,%eax
  802842:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802848:	8b 45 08             	mov    0x8(%ebp),%eax
  80284b:	83 c0 08             	add    $0x8,%eax
  80284e:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802851:	8b 45 08             	mov    0x8(%ebp),%eax
  802854:	83 c0 04             	add    $0x4,%eax
  802857:	8b 55 0c             	mov    0xc(%ebp),%edx
  80285a:	83 ea 08             	sub    $0x8,%edx
  80285d:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80285f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	01 d0                	add    %edx,%eax
  802867:	83 e8 08             	sub    $0x8,%eax
  80286a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80286d:	83 ea 08             	sub    $0x8,%edx
  802870:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802872:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802875:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80287b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802885:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802889:	75 17                	jne    8028a2 <initialize_dynamic_allocator+0x19c>
  80288b:	83 ec 04             	sub    $0x4,%esp
  80288e:	68 70 4b 80 00       	push   $0x804b70
  802893:	68 90 00 00 00       	push   $0x90
  802898:	68 55 4b 80 00       	push   $0x804b55
  80289d:	e8 a9 de ff ff       	call   80074b <_panic>
  8028a2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ab:	89 10                	mov    %edx,(%eax)
  8028ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b0:	8b 00                	mov    (%eax),%eax
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	74 0d                	je     8028c3 <initialize_dynamic_allocator+0x1bd>
  8028b6:	a1 30 50 80 00       	mov    0x805030,%eax
  8028bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028be:	89 50 04             	mov    %edx,0x4(%eax)
  8028c1:	eb 08                	jmp    8028cb <initialize_dynamic_allocator+0x1c5>
  8028c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c6:	a3 34 50 80 00       	mov    %eax,0x805034
  8028cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8028d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028dd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8028e2:	40                   	inc    %eax
  8028e3:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8028e8:	eb 07                	jmp    8028f1 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8028ea:	90                   	nop
  8028eb:	eb 04                	jmp    8028f1 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8028ed:	90                   	nop
  8028ee:	eb 01                	jmp    8028f1 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8028f0:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8028f1:	c9                   	leave  
  8028f2:	c3                   	ret    

008028f3 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8028f3:	55                   	push   %ebp
  8028f4:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8028f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8028f9:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8028fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ff:	8d 50 fc             	lea    -0x4(%eax),%edx
  802902:	8b 45 0c             	mov    0xc(%ebp),%eax
  802905:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	83 e8 04             	sub    $0x4,%eax
  80290d:	8b 00                	mov    (%eax),%eax
  80290f:	83 e0 fe             	and    $0xfffffffe,%eax
  802912:	8d 50 f8             	lea    -0x8(%eax),%edx
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	01 c2                	add    %eax,%edx
  80291a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80291d:	89 02                	mov    %eax,(%edx)
}
  80291f:	90                   	nop
  802920:	5d                   	pop    %ebp
  802921:	c3                   	ret    

00802922 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802922:	55                   	push   %ebp
  802923:	89 e5                	mov    %esp,%ebp
  802925:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802928:	8b 45 08             	mov    0x8(%ebp),%eax
  80292b:	83 e0 01             	and    $0x1,%eax
  80292e:	85 c0                	test   %eax,%eax
  802930:	74 03                	je     802935 <alloc_block_FF+0x13>
  802932:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802935:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802939:	77 07                	ja     802942 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80293b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802942:	a1 28 50 80 00       	mov    0x805028,%eax
  802947:	85 c0                	test   %eax,%eax
  802949:	75 73                	jne    8029be <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80294b:	8b 45 08             	mov    0x8(%ebp),%eax
  80294e:	83 c0 10             	add    $0x10,%eax
  802951:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802954:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80295b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80295e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802961:	01 d0                	add    %edx,%eax
  802963:	48                   	dec    %eax
  802964:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802967:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296a:	ba 00 00 00 00       	mov    $0x0,%edx
  80296f:	f7 75 ec             	divl   -0x14(%ebp)
  802972:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802975:	29 d0                	sub    %edx,%eax
  802977:	c1 e8 0c             	shr    $0xc,%eax
  80297a:	83 ec 0c             	sub    $0xc,%esp
  80297d:	50                   	push   %eax
  80297e:	e8 27 f0 ff ff       	call   8019aa <sbrk>
  802983:	83 c4 10             	add    $0x10,%esp
  802986:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802989:	83 ec 0c             	sub    $0xc,%esp
  80298c:	6a 00                	push   $0x0
  80298e:	e8 17 f0 ff ff       	call   8019aa <sbrk>
  802993:	83 c4 10             	add    $0x10,%esp
  802996:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802999:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80299c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80299f:	83 ec 08             	sub    $0x8,%esp
  8029a2:	50                   	push   %eax
  8029a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029a6:	e8 5b fd ff ff       	call   802706 <initialize_dynamic_allocator>
  8029ab:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029ae:	83 ec 0c             	sub    $0xc,%esp
  8029b1:	68 93 4b 80 00       	push   $0x804b93
  8029b6:	e8 4d e0 ff ff       	call   800a08 <cprintf>
  8029bb:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8029be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c2:	75 0a                	jne    8029ce <alloc_block_FF+0xac>
	        return NULL;
  8029c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c9:	e9 0e 04 00 00       	jmp    802ddc <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8029ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8029d5:	a1 30 50 80 00       	mov    0x805030,%eax
  8029da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029dd:	e9 f3 02 00 00       	jmp    802cd5 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8029e8:	83 ec 0c             	sub    $0xc,%esp
  8029eb:	ff 75 bc             	pushl  -0x44(%ebp)
  8029ee:	e8 af fb ff ff       	call   8025a2 <get_block_size>
  8029f3:	83 c4 10             	add    $0x10,%esp
  8029f6:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8029f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fc:	83 c0 08             	add    $0x8,%eax
  8029ff:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a02:	0f 87 c5 02 00 00    	ja     802ccd <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	83 c0 18             	add    $0x18,%eax
  802a0e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a11:	0f 87 19 02 00 00    	ja     802c30 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802a17:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a1a:	2b 45 08             	sub    0x8(%ebp),%eax
  802a1d:	83 e8 08             	sub    $0x8,%eax
  802a20:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802a23:	8b 45 08             	mov    0x8(%ebp),%eax
  802a26:	8d 50 08             	lea    0x8(%eax),%edx
  802a29:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a2c:	01 d0                	add    %edx,%eax
  802a2e:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802a31:	8b 45 08             	mov    0x8(%ebp),%eax
  802a34:	83 c0 08             	add    $0x8,%eax
  802a37:	83 ec 04             	sub    $0x4,%esp
  802a3a:	6a 01                	push   $0x1
  802a3c:	50                   	push   %eax
  802a3d:	ff 75 bc             	pushl  -0x44(%ebp)
  802a40:	e8 ae fe ff ff       	call   8028f3 <set_block_data>
  802a45:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 40 04             	mov    0x4(%eax),%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	75 68                	jne    802aba <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a52:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a56:	75 17                	jne    802a6f <alloc_block_FF+0x14d>
  802a58:	83 ec 04             	sub    $0x4,%esp
  802a5b:	68 70 4b 80 00       	push   $0x804b70
  802a60:	68 d7 00 00 00       	push   $0xd7
  802a65:	68 55 4b 80 00       	push   $0x804b55
  802a6a:	e8 dc dc ff ff       	call   80074b <_panic>
  802a6f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a75:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a78:	89 10                	mov    %edx,(%eax)
  802a7a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a7d:	8b 00                	mov    (%eax),%eax
  802a7f:	85 c0                	test   %eax,%eax
  802a81:	74 0d                	je     802a90 <alloc_block_FF+0x16e>
  802a83:	a1 30 50 80 00       	mov    0x805030,%eax
  802a88:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a8b:	89 50 04             	mov    %edx,0x4(%eax)
  802a8e:	eb 08                	jmp    802a98 <alloc_block_FF+0x176>
  802a90:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a93:	a3 34 50 80 00       	mov    %eax,0x805034
  802a98:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a9b:	a3 30 50 80 00       	mov    %eax,0x805030
  802aa0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aa3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aaa:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802aaf:	40                   	inc    %eax
  802ab0:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ab5:	e9 dc 00 00 00       	jmp    802b96 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	8b 00                	mov    (%eax),%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	75 65                	jne    802b28 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ac3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ac7:	75 17                	jne    802ae0 <alloc_block_FF+0x1be>
  802ac9:	83 ec 04             	sub    $0x4,%esp
  802acc:	68 a4 4b 80 00       	push   $0x804ba4
  802ad1:	68 db 00 00 00       	push   $0xdb
  802ad6:	68 55 4b 80 00       	push   $0x804b55
  802adb:	e8 6b dc ff ff       	call   80074b <_panic>
  802ae0:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802ae6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae9:	89 50 04             	mov    %edx,0x4(%eax)
  802aec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aef:	8b 40 04             	mov    0x4(%eax),%eax
  802af2:	85 c0                	test   %eax,%eax
  802af4:	74 0c                	je     802b02 <alloc_block_FF+0x1e0>
  802af6:	a1 34 50 80 00       	mov    0x805034,%eax
  802afb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802afe:	89 10                	mov    %edx,(%eax)
  802b00:	eb 08                	jmp    802b0a <alloc_block_FF+0x1e8>
  802b02:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b05:	a3 30 50 80 00       	mov    %eax,0x805030
  802b0a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b0d:	a3 34 50 80 00       	mov    %eax,0x805034
  802b12:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b20:	40                   	inc    %eax
  802b21:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b26:	eb 6e                	jmp    802b96 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802b28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2c:	74 06                	je     802b34 <alloc_block_FF+0x212>
  802b2e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b32:	75 17                	jne    802b4b <alloc_block_FF+0x229>
  802b34:	83 ec 04             	sub    $0x4,%esp
  802b37:	68 c8 4b 80 00       	push   $0x804bc8
  802b3c:	68 df 00 00 00       	push   $0xdf
  802b41:	68 55 4b 80 00       	push   $0x804b55
  802b46:	e8 00 dc ff ff       	call   80074b <_panic>
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	8b 10                	mov    (%eax),%edx
  802b50:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b53:	89 10                	mov    %edx,(%eax)
  802b55:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	85 c0                	test   %eax,%eax
  802b5c:	74 0b                	je     802b69 <alloc_block_FF+0x247>
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 00                	mov    (%eax),%eax
  802b63:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b66:	89 50 04             	mov    %edx,0x4(%eax)
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b6f:	89 10                	mov    %edx,(%eax)
  802b71:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b77:	89 50 04             	mov    %edx,0x4(%eax)
  802b7a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b7d:	8b 00                	mov    (%eax),%eax
  802b7f:	85 c0                	test   %eax,%eax
  802b81:	75 08                	jne    802b8b <alloc_block_FF+0x269>
  802b83:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b86:	a3 34 50 80 00       	mov    %eax,0x805034
  802b8b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b90:	40                   	inc    %eax
  802b91:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802b96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9a:	75 17                	jne    802bb3 <alloc_block_FF+0x291>
  802b9c:	83 ec 04             	sub    $0x4,%esp
  802b9f:	68 37 4b 80 00       	push   $0x804b37
  802ba4:	68 e1 00 00 00       	push   $0xe1
  802ba9:	68 55 4b 80 00       	push   $0x804b55
  802bae:	e8 98 db ff ff       	call   80074b <_panic>
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	74 10                	je     802bcc <alloc_block_FF+0x2aa>
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc4:	8b 52 04             	mov    0x4(%edx),%edx
  802bc7:	89 50 04             	mov    %edx,0x4(%eax)
  802bca:	eb 0b                	jmp    802bd7 <alloc_block_FF+0x2b5>
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 40 04             	mov    0x4(%eax),%eax
  802bd2:	a3 34 50 80 00       	mov    %eax,0x805034
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 40 04             	mov    0x4(%eax),%eax
  802bdd:	85 c0                	test   %eax,%eax
  802bdf:	74 0f                	je     802bf0 <alloc_block_FF+0x2ce>
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	8b 40 04             	mov    0x4(%eax),%eax
  802be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bea:	8b 12                	mov    (%edx),%edx
  802bec:	89 10                	mov    %edx,(%eax)
  802bee:	eb 0a                	jmp    802bfa <alloc_block_FF+0x2d8>
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 00                	mov    (%eax),%eax
  802bf5:	a3 30 50 80 00       	mov    %eax,0x805030
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c12:	48                   	dec    %eax
  802c13:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802c18:	83 ec 04             	sub    $0x4,%esp
  802c1b:	6a 00                	push   $0x0
  802c1d:	ff 75 b4             	pushl  -0x4c(%ebp)
  802c20:	ff 75 b0             	pushl  -0x50(%ebp)
  802c23:	e8 cb fc ff ff       	call   8028f3 <set_block_data>
  802c28:	83 c4 10             	add    $0x10,%esp
  802c2b:	e9 95 00 00 00       	jmp    802cc5 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802c30:	83 ec 04             	sub    $0x4,%esp
  802c33:	6a 01                	push   $0x1
  802c35:	ff 75 b8             	pushl  -0x48(%ebp)
  802c38:	ff 75 bc             	pushl  -0x44(%ebp)
  802c3b:	e8 b3 fc ff ff       	call   8028f3 <set_block_data>
  802c40:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802c43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c47:	75 17                	jne    802c60 <alloc_block_FF+0x33e>
  802c49:	83 ec 04             	sub    $0x4,%esp
  802c4c:	68 37 4b 80 00       	push   $0x804b37
  802c51:	68 e8 00 00 00       	push   $0xe8
  802c56:	68 55 4b 80 00       	push   $0x804b55
  802c5b:	e8 eb da ff ff       	call   80074b <_panic>
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 00                	mov    (%eax),%eax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	74 10                	je     802c79 <alloc_block_FF+0x357>
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c71:	8b 52 04             	mov    0x4(%edx),%edx
  802c74:	89 50 04             	mov    %edx,0x4(%eax)
  802c77:	eb 0b                	jmp    802c84 <alloc_block_FF+0x362>
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	8b 40 04             	mov    0x4(%eax),%eax
  802c7f:	a3 34 50 80 00       	mov    %eax,0x805034
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 40 04             	mov    0x4(%eax),%eax
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	74 0f                	je     802c9d <alloc_block_FF+0x37b>
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 40 04             	mov    0x4(%eax),%eax
  802c94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c97:	8b 12                	mov    (%edx),%edx
  802c99:	89 10                	mov    %edx,(%eax)
  802c9b:	eb 0a                	jmp    802ca7 <alloc_block_FF+0x385>
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 00                	mov    (%eax),%eax
  802ca2:	a3 30 50 80 00       	mov    %eax,0x805030
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cba:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cbf:	48                   	dec    %eax
  802cc0:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802cc5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cc8:	e9 0f 01 00 00       	jmp    802ddc <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802ccd:	a1 38 50 80 00       	mov    0x805038,%eax
  802cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd9:	74 07                	je     802ce2 <alloc_block_FF+0x3c0>
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 00                	mov    (%eax),%eax
  802ce0:	eb 05                	jmp    802ce7 <alloc_block_FF+0x3c5>
  802ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce7:	a3 38 50 80 00       	mov    %eax,0x805038
  802cec:	a1 38 50 80 00       	mov    0x805038,%eax
  802cf1:	85 c0                	test   %eax,%eax
  802cf3:	0f 85 e9 fc ff ff    	jne    8029e2 <alloc_block_FF+0xc0>
  802cf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfd:	0f 85 df fc ff ff    	jne    8029e2 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	83 c0 08             	add    $0x8,%eax
  802d09:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d0c:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802d13:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d16:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d19:	01 d0                	add    %edx,%eax
  802d1b:	48                   	dec    %eax
  802d1c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802d1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d22:	ba 00 00 00 00       	mov    $0x0,%edx
  802d27:	f7 75 d8             	divl   -0x28(%ebp)
  802d2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d2d:	29 d0                	sub    %edx,%eax
  802d2f:	c1 e8 0c             	shr    $0xc,%eax
  802d32:	83 ec 0c             	sub    $0xc,%esp
  802d35:	50                   	push   %eax
  802d36:	e8 6f ec ff ff       	call   8019aa <sbrk>
  802d3b:	83 c4 10             	add    $0x10,%esp
  802d3e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802d41:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d45:	75 0a                	jne    802d51 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802d47:	b8 00 00 00 00       	mov    $0x0,%eax
  802d4c:	e9 8b 00 00 00       	jmp    802ddc <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d51:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802d58:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d5e:	01 d0                	add    %edx,%eax
  802d60:	48                   	dec    %eax
  802d61:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802d64:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d67:	ba 00 00 00 00       	mov    $0x0,%edx
  802d6c:	f7 75 cc             	divl   -0x34(%ebp)
  802d6f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d72:	29 d0                	sub    %edx,%eax
  802d74:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d77:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d7a:	01 d0                	add    %edx,%eax
  802d7c:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802d81:	a1 44 50 80 00       	mov    0x805044,%eax
  802d86:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d8c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d93:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d96:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d99:	01 d0                	add    %edx,%eax
  802d9b:	48                   	dec    %eax
  802d9c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d9f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802da2:	ba 00 00 00 00       	mov    $0x0,%edx
  802da7:	f7 75 c4             	divl   -0x3c(%ebp)
  802daa:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dad:	29 d0                	sub    %edx,%eax
  802daf:	83 ec 04             	sub    $0x4,%esp
  802db2:	6a 01                	push   $0x1
  802db4:	50                   	push   %eax
  802db5:	ff 75 d0             	pushl  -0x30(%ebp)
  802db8:	e8 36 fb ff ff       	call   8028f3 <set_block_data>
  802dbd:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802dc0:	83 ec 0c             	sub    $0xc,%esp
  802dc3:	ff 75 d0             	pushl  -0x30(%ebp)
  802dc6:	e8 f8 09 00 00       	call   8037c3 <free_block>
  802dcb:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802dce:	83 ec 0c             	sub    $0xc,%esp
  802dd1:	ff 75 08             	pushl  0x8(%ebp)
  802dd4:	e8 49 fb ff ff       	call   802922 <alloc_block_FF>
  802dd9:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802ddc:	c9                   	leave  
  802ddd:	c3                   	ret    

00802dde <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802dde:	55                   	push   %ebp
  802ddf:	89 e5                	mov    %esp,%ebp
  802de1:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	83 e0 01             	and    $0x1,%eax
  802dea:	85 c0                	test   %eax,%eax
  802dec:	74 03                	je     802df1 <alloc_block_BF+0x13>
  802dee:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802df1:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802df5:	77 07                	ja     802dfe <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802df7:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802dfe:	a1 28 50 80 00       	mov    0x805028,%eax
  802e03:	85 c0                	test   %eax,%eax
  802e05:	75 73                	jne    802e7a <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	83 c0 10             	add    $0x10,%eax
  802e0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e10:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802e17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1d:	01 d0                	add    %edx,%eax
  802e1f:	48                   	dec    %eax
  802e20:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e23:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e26:	ba 00 00 00 00       	mov    $0x0,%edx
  802e2b:	f7 75 e0             	divl   -0x20(%ebp)
  802e2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e31:	29 d0                	sub    %edx,%eax
  802e33:	c1 e8 0c             	shr    $0xc,%eax
  802e36:	83 ec 0c             	sub    $0xc,%esp
  802e39:	50                   	push   %eax
  802e3a:	e8 6b eb ff ff       	call   8019aa <sbrk>
  802e3f:	83 c4 10             	add    $0x10,%esp
  802e42:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802e45:	83 ec 0c             	sub    $0xc,%esp
  802e48:	6a 00                	push   $0x0
  802e4a:	e8 5b eb ff ff       	call   8019aa <sbrk>
  802e4f:	83 c4 10             	add    $0x10,%esp
  802e52:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802e55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e58:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802e5b:	83 ec 08             	sub    $0x8,%esp
  802e5e:	50                   	push   %eax
  802e5f:	ff 75 d8             	pushl  -0x28(%ebp)
  802e62:	e8 9f f8 ff ff       	call   802706 <initialize_dynamic_allocator>
  802e67:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802e6a:	83 ec 0c             	sub    $0xc,%esp
  802e6d:	68 93 4b 80 00       	push   $0x804b93
  802e72:	e8 91 db ff ff       	call   800a08 <cprintf>
  802e77:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802e7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802e81:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802e88:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802e8f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802e96:	a1 30 50 80 00       	mov    0x805030,%eax
  802e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e9e:	e9 1d 01 00 00       	jmp    802fc0 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802ea9:	83 ec 0c             	sub    $0xc,%esp
  802eac:	ff 75 a8             	pushl  -0x58(%ebp)
  802eaf:	e8 ee f6 ff ff       	call   8025a2 <get_block_size>
  802eb4:	83 c4 10             	add    $0x10,%esp
  802eb7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	83 c0 08             	add    $0x8,%eax
  802ec0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ec3:	0f 87 ef 00 00 00    	ja     802fb8 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	83 c0 18             	add    $0x18,%eax
  802ecf:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ed2:	77 1d                	ja     802ef1 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802ed4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802eda:	0f 86 d8 00 00 00    	jbe    802fb8 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802ee0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ee3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802ee6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ee9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802eec:	e9 c7 00 00 00       	jmp    802fb8 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	83 c0 08             	add    $0x8,%eax
  802ef7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802efa:	0f 85 9d 00 00 00    	jne    802f9d <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802f00:	83 ec 04             	sub    $0x4,%esp
  802f03:	6a 01                	push   $0x1
  802f05:	ff 75 a4             	pushl  -0x5c(%ebp)
  802f08:	ff 75 a8             	pushl  -0x58(%ebp)
  802f0b:	e8 e3 f9 ff ff       	call   8028f3 <set_block_data>
  802f10:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802f13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f17:	75 17                	jne    802f30 <alloc_block_BF+0x152>
  802f19:	83 ec 04             	sub    $0x4,%esp
  802f1c:	68 37 4b 80 00       	push   $0x804b37
  802f21:	68 2c 01 00 00       	push   $0x12c
  802f26:	68 55 4b 80 00       	push   $0x804b55
  802f2b:	e8 1b d8 ff ff       	call   80074b <_panic>
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 00                	mov    (%eax),%eax
  802f35:	85 c0                	test   %eax,%eax
  802f37:	74 10                	je     802f49 <alloc_block_BF+0x16b>
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f41:	8b 52 04             	mov    0x4(%edx),%edx
  802f44:	89 50 04             	mov    %edx,0x4(%eax)
  802f47:	eb 0b                	jmp    802f54 <alloc_block_BF+0x176>
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 40 04             	mov    0x4(%eax),%eax
  802f4f:	a3 34 50 80 00       	mov    %eax,0x805034
  802f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f57:	8b 40 04             	mov    0x4(%eax),%eax
  802f5a:	85 c0                	test   %eax,%eax
  802f5c:	74 0f                	je     802f6d <alloc_block_BF+0x18f>
  802f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f61:	8b 40 04             	mov    0x4(%eax),%eax
  802f64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f67:	8b 12                	mov    (%edx),%edx
  802f69:	89 10                	mov    %edx,(%eax)
  802f6b:	eb 0a                	jmp    802f77 <alloc_block_BF+0x199>
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	a3 30 50 80 00       	mov    %eax,0x805030
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f8f:	48                   	dec    %eax
  802f90:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802f95:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f98:	e9 01 04 00 00       	jmp    80339e <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fa3:	76 13                	jbe    802fb8 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802fa5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802fac:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802faf:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802fb2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802fb5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802fb8:	a1 38 50 80 00       	mov    0x805038,%eax
  802fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc4:	74 07                	je     802fcd <alloc_block_BF+0x1ef>
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	8b 00                	mov    (%eax),%eax
  802fcb:	eb 05                	jmp    802fd2 <alloc_block_BF+0x1f4>
  802fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd2:	a3 38 50 80 00       	mov    %eax,0x805038
  802fd7:	a1 38 50 80 00       	mov    0x805038,%eax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	0f 85 bf fe ff ff    	jne    802ea3 <alloc_block_BF+0xc5>
  802fe4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe8:	0f 85 b5 fe ff ff    	jne    802ea3 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802fee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ff2:	0f 84 26 02 00 00    	je     80321e <alloc_block_BF+0x440>
  802ff8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ffc:	0f 85 1c 02 00 00    	jne    80321e <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803005:	2b 45 08             	sub    0x8(%ebp),%eax
  803008:	83 e8 08             	sub    $0x8,%eax
  80300b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	8d 50 08             	lea    0x8(%eax),%edx
  803014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803017:	01 d0                	add    %edx,%eax
  803019:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	83 c0 08             	add    $0x8,%eax
  803022:	83 ec 04             	sub    $0x4,%esp
  803025:	6a 01                	push   $0x1
  803027:	50                   	push   %eax
  803028:	ff 75 f0             	pushl  -0x10(%ebp)
  80302b:	e8 c3 f8 ff ff       	call   8028f3 <set_block_data>
  803030:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803036:	8b 40 04             	mov    0x4(%eax),%eax
  803039:	85 c0                	test   %eax,%eax
  80303b:	75 68                	jne    8030a5 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80303d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803041:	75 17                	jne    80305a <alloc_block_BF+0x27c>
  803043:	83 ec 04             	sub    $0x4,%esp
  803046:	68 70 4b 80 00       	push   $0x804b70
  80304b:	68 45 01 00 00       	push   $0x145
  803050:	68 55 4b 80 00       	push   $0x804b55
  803055:	e8 f1 d6 ff ff       	call   80074b <_panic>
  80305a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803060:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803063:	89 10                	mov    %edx,(%eax)
  803065:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803068:	8b 00                	mov    (%eax),%eax
  80306a:	85 c0                	test   %eax,%eax
  80306c:	74 0d                	je     80307b <alloc_block_BF+0x29d>
  80306e:	a1 30 50 80 00       	mov    0x805030,%eax
  803073:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803076:	89 50 04             	mov    %edx,0x4(%eax)
  803079:	eb 08                	jmp    803083 <alloc_block_BF+0x2a5>
  80307b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80307e:	a3 34 50 80 00       	mov    %eax,0x805034
  803083:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803086:	a3 30 50 80 00       	mov    %eax,0x805030
  80308b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80308e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803095:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80309a:	40                   	inc    %eax
  80309b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8030a0:	e9 dc 00 00 00       	jmp    803181 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8030a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a8:	8b 00                	mov    (%eax),%eax
  8030aa:	85 c0                	test   %eax,%eax
  8030ac:	75 65                	jne    803113 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030ae:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030b2:	75 17                	jne    8030cb <alloc_block_BF+0x2ed>
  8030b4:	83 ec 04             	sub    $0x4,%esp
  8030b7:	68 a4 4b 80 00       	push   $0x804ba4
  8030bc:	68 4a 01 00 00       	push   $0x14a
  8030c1:	68 55 4b 80 00       	push   $0x804b55
  8030c6:	e8 80 d6 ff ff       	call   80074b <_panic>
  8030cb:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8030d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030d4:	89 50 04             	mov    %edx,0x4(%eax)
  8030d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030da:	8b 40 04             	mov    0x4(%eax),%eax
  8030dd:	85 c0                	test   %eax,%eax
  8030df:	74 0c                	je     8030ed <alloc_block_BF+0x30f>
  8030e1:	a1 34 50 80 00       	mov    0x805034,%eax
  8030e6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030e9:	89 10                	mov    %edx,(%eax)
  8030eb:	eb 08                	jmp    8030f5 <alloc_block_BF+0x317>
  8030ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8030f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f8:	a3 34 50 80 00       	mov    %eax,0x805034
  8030fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803100:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803106:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80310b:	40                   	inc    %eax
  80310c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803111:	eb 6e                	jmp    803181 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803113:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803117:	74 06                	je     80311f <alloc_block_BF+0x341>
  803119:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80311d:	75 17                	jne    803136 <alloc_block_BF+0x358>
  80311f:	83 ec 04             	sub    $0x4,%esp
  803122:	68 c8 4b 80 00       	push   $0x804bc8
  803127:	68 4f 01 00 00       	push   $0x14f
  80312c:	68 55 4b 80 00       	push   $0x804b55
  803131:	e8 15 d6 ff ff       	call   80074b <_panic>
  803136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803139:	8b 10                	mov    (%eax),%edx
  80313b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80313e:	89 10                	mov    %edx,(%eax)
  803140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803143:	8b 00                	mov    (%eax),%eax
  803145:	85 c0                	test   %eax,%eax
  803147:	74 0b                	je     803154 <alloc_block_BF+0x376>
  803149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314c:	8b 00                	mov    (%eax),%eax
  80314e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803151:	89 50 04             	mov    %edx,0x4(%eax)
  803154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803157:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80315a:	89 10                	mov    %edx,(%eax)
  80315c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80315f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803162:	89 50 04             	mov    %edx,0x4(%eax)
  803165:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803168:	8b 00                	mov    (%eax),%eax
  80316a:	85 c0                	test   %eax,%eax
  80316c:	75 08                	jne    803176 <alloc_block_BF+0x398>
  80316e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803171:	a3 34 50 80 00       	mov    %eax,0x805034
  803176:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80317b:	40                   	inc    %eax
  80317c:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803181:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803185:	75 17                	jne    80319e <alloc_block_BF+0x3c0>
  803187:	83 ec 04             	sub    $0x4,%esp
  80318a:	68 37 4b 80 00       	push   $0x804b37
  80318f:	68 51 01 00 00       	push   $0x151
  803194:	68 55 4b 80 00       	push   $0x804b55
  803199:	e8 ad d5 ff ff       	call   80074b <_panic>
  80319e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	85 c0                	test   %eax,%eax
  8031a5:	74 10                	je     8031b7 <alloc_block_BF+0x3d9>
  8031a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031aa:	8b 00                	mov    (%eax),%eax
  8031ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031af:	8b 52 04             	mov    0x4(%edx),%edx
  8031b2:	89 50 04             	mov    %edx,0x4(%eax)
  8031b5:	eb 0b                	jmp    8031c2 <alloc_block_BF+0x3e4>
  8031b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ba:	8b 40 04             	mov    0x4(%eax),%eax
  8031bd:	a3 34 50 80 00       	mov    %eax,0x805034
  8031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c5:	8b 40 04             	mov    0x4(%eax),%eax
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	74 0f                	je     8031db <alloc_block_BF+0x3fd>
  8031cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cf:	8b 40 04             	mov    0x4(%eax),%eax
  8031d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d5:	8b 12                	mov    (%edx),%edx
  8031d7:	89 10                	mov    %edx,(%eax)
  8031d9:	eb 0a                	jmp    8031e5 <alloc_block_BF+0x407>
  8031db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031de:	8b 00                	mov    (%eax),%eax
  8031e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8031e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031fd:	48                   	dec    %eax
  8031fe:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  803203:	83 ec 04             	sub    $0x4,%esp
  803206:	6a 00                	push   $0x0
  803208:	ff 75 d0             	pushl  -0x30(%ebp)
  80320b:	ff 75 cc             	pushl  -0x34(%ebp)
  80320e:	e8 e0 f6 ff ff       	call   8028f3 <set_block_data>
  803213:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803219:	e9 80 01 00 00       	jmp    80339e <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  80321e:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803222:	0f 85 9d 00 00 00    	jne    8032c5 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803228:	83 ec 04             	sub    $0x4,%esp
  80322b:	6a 01                	push   $0x1
  80322d:	ff 75 ec             	pushl  -0x14(%ebp)
  803230:	ff 75 f0             	pushl  -0x10(%ebp)
  803233:	e8 bb f6 ff ff       	call   8028f3 <set_block_data>
  803238:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80323b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80323f:	75 17                	jne    803258 <alloc_block_BF+0x47a>
  803241:	83 ec 04             	sub    $0x4,%esp
  803244:	68 37 4b 80 00       	push   $0x804b37
  803249:	68 58 01 00 00       	push   $0x158
  80324e:	68 55 4b 80 00       	push   $0x804b55
  803253:	e8 f3 d4 ff ff       	call   80074b <_panic>
  803258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325b:	8b 00                	mov    (%eax),%eax
  80325d:	85 c0                	test   %eax,%eax
  80325f:	74 10                	je     803271 <alloc_block_BF+0x493>
  803261:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803264:	8b 00                	mov    (%eax),%eax
  803266:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803269:	8b 52 04             	mov    0x4(%edx),%edx
  80326c:	89 50 04             	mov    %edx,0x4(%eax)
  80326f:	eb 0b                	jmp    80327c <alloc_block_BF+0x49e>
  803271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803274:	8b 40 04             	mov    0x4(%eax),%eax
  803277:	a3 34 50 80 00       	mov    %eax,0x805034
  80327c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327f:	8b 40 04             	mov    0x4(%eax),%eax
  803282:	85 c0                	test   %eax,%eax
  803284:	74 0f                	je     803295 <alloc_block_BF+0x4b7>
  803286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803289:	8b 40 04             	mov    0x4(%eax),%eax
  80328c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80328f:	8b 12                	mov    (%edx),%edx
  803291:	89 10                	mov    %edx,(%eax)
  803293:	eb 0a                	jmp    80329f <alloc_block_BF+0x4c1>
  803295:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803298:	8b 00                	mov    (%eax),%eax
  80329a:	a3 30 50 80 00       	mov    %eax,0x805030
  80329f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032b7:	48                   	dec    %eax
  8032b8:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  8032bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c0:	e9 d9 00 00 00       	jmp    80339e <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	83 c0 08             	add    $0x8,%eax
  8032cb:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8032ce:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8032d5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032d8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8032db:	01 d0                	add    %edx,%eax
  8032dd:	48                   	dec    %eax
  8032de:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8032e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8032e9:	f7 75 c4             	divl   -0x3c(%ebp)
  8032ec:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032ef:	29 d0                	sub    %edx,%eax
  8032f1:	c1 e8 0c             	shr    $0xc,%eax
  8032f4:	83 ec 0c             	sub    $0xc,%esp
  8032f7:	50                   	push   %eax
  8032f8:	e8 ad e6 ff ff       	call   8019aa <sbrk>
  8032fd:	83 c4 10             	add    $0x10,%esp
  803300:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803303:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803307:	75 0a                	jne    803313 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803309:	b8 00 00 00 00       	mov    $0x0,%eax
  80330e:	e9 8b 00 00 00       	jmp    80339e <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803313:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80331a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80331d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803320:	01 d0                	add    %edx,%eax
  803322:	48                   	dec    %eax
  803323:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803326:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803329:	ba 00 00 00 00       	mov    $0x0,%edx
  80332e:	f7 75 b8             	divl   -0x48(%ebp)
  803331:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803334:	29 d0                	sub    %edx,%eax
  803336:	8d 50 fc             	lea    -0x4(%eax),%edx
  803339:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80333c:	01 d0                	add    %edx,%eax
  80333e:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  803343:	a1 44 50 80 00       	mov    0x805044,%eax
  803348:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80334e:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803355:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803358:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80335b:	01 d0                	add    %edx,%eax
  80335d:	48                   	dec    %eax
  80335e:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803361:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803364:	ba 00 00 00 00       	mov    $0x0,%edx
  803369:	f7 75 b0             	divl   -0x50(%ebp)
  80336c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80336f:	29 d0                	sub    %edx,%eax
  803371:	83 ec 04             	sub    $0x4,%esp
  803374:	6a 01                	push   $0x1
  803376:	50                   	push   %eax
  803377:	ff 75 bc             	pushl  -0x44(%ebp)
  80337a:	e8 74 f5 ff ff       	call   8028f3 <set_block_data>
  80337f:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803382:	83 ec 0c             	sub    $0xc,%esp
  803385:	ff 75 bc             	pushl  -0x44(%ebp)
  803388:	e8 36 04 00 00       	call   8037c3 <free_block>
  80338d:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803390:	83 ec 0c             	sub    $0xc,%esp
  803393:	ff 75 08             	pushl  0x8(%ebp)
  803396:	e8 43 fa ff ff       	call   802dde <alloc_block_BF>
  80339b:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80339e:	c9                   	leave  
  80339f:	c3                   	ret    

008033a0 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8033a0:	55                   	push   %ebp
  8033a1:	89 e5                	mov    %esp,%ebp
  8033a3:	53                   	push   %ebx
  8033a4:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8033a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8033b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b9:	74 1e                	je     8033d9 <merging+0x39>
  8033bb:	ff 75 08             	pushl  0x8(%ebp)
  8033be:	e8 df f1 ff ff       	call   8025a2 <get_block_size>
  8033c3:	83 c4 04             	add    $0x4,%esp
  8033c6:	89 c2                	mov    %eax,%edx
  8033c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cb:	01 d0                	add    %edx,%eax
  8033cd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8033d0:	75 07                	jne    8033d9 <merging+0x39>
		prev_is_free = 1;
  8033d2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8033d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033dd:	74 1e                	je     8033fd <merging+0x5d>
  8033df:	ff 75 10             	pushl  0x10(%ebp)
  8033e2:	e8 bb f1 ff ff       	call   8025a2 <get_block_size>
  8033e7:	83 c4 04             	add    $0x4,%esp
  8033ea:	89 c2                	mov    %eax,%edx
  8033ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8033ef:	01 d0                	add    %edx,%eax
  8033f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033f4:	75 07                	jne    8033fd <merging+0x5d>
		next_is_free = 1;
  8033f6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8033fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803401:	0f 84 cc 00 00 00    	je     8034d3 <merging+0x133>
  803407:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80340b:	0f 84 c2 00 00 00    	je     8034d3 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803411:	ff 75 08             	pushl  0x8(%ebp)
  803414:	e8 89 f1 ff ff       	call   8025a2 <get_block_size>
  803419:	83 c4 04             	add    $0x4,%esp
  80341c:	89 c3                	mov    %eax,%ebx
  80341e:	ff 75 10             	pushl  0x10(%ebp)
  803421:	e8 7c f1 ff ff       	call   8025a2 <get_block_size>
  803426:	83 c4 04             	add    $0x4,%esp
  803429:	01 c3                	add    %eax,%ebx
  80342b:	ff 75 0c             	pushl  0xc(%ebp)
  80342e:	e8 6f f1 ff ff       	call   8025a2 <get_block_size>
  803433:	83 c4 04             	add    $0x4,%esp
  803436:	01 d8                	add    %ebx,%eax
  803438:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80343b:	6a 00                	push   $0x0
  80343d:	ff 75 ec             	pushl  -0x14(%ebp)
  803440:	ff 75 08             	pushl  0x8(%ebp)
  803443:	e8 ab f4 ff ff       	call   8028f3 <set_block_data>
  803448:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80344b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80344f:	75 17                	jne    803468 <merging+0xc8>
  803451:	83 ec 04             	sub    $0x4,%esp
  803454:	68 37 4b 80 00       	push   $0x804b37
  803459:	68 7d 01 00 00       	push   $0x17d
  80345e:	68 55 4b 80 00       	push   $0x804b55
  803463:	e8 e3 d2 ff ff       	call   80074b <_panic>
  803468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80346b:	8b 00                	mov    (%eax),%eax
  80346d:	85 c0                	test   %eax,%eax
  80346f:	74 10                	je     803481 <merging+0xe1>
  803471:	8b 45 0c             	mov    0xc(%ebp),%eax
  803474:	8b 00                	mov    (%eax),%eax
  803476:	8b 55 0c             	mov    0xc(%ebp),%edx
  803479:	8b 52 04             	mov    0x4(%edx),%edx
  80347c:	89 50 04             	mov    %edx,0x4(%eax)
  80347f:	eb 0b                	jmp    80348c <merging+0xec>
  803481:	8b 45 0c             	mov    0xc(%ebp),%eax
  803484:	8b 40 04             	mov    0x4(%eax),%eax
  803487:	a3 34 50 80 00       	mov    %eax,0x805034
  80348c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348f:	8b 40 04             	mov    0x4(%eax),%eax
  803492:	85 c0                	test   %eax,%eax
  803494:	74 0f                	je     8034a5 <merging+0x105>
  803496:	8b 45 0c             	mov    0xc(%ebp),%eax
  803499:	8b 40 04             	mov    0x4(%eax),%eax
  80349c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80349f:	8b 12                	mov    (%edx),%edx
  8034a1:	89 10                	mov    %edx,(%eax)
  8034a3:	eb 0a                	jmp    8034af <merging+0x10f>
  8034a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a8:	8b 00                	mov    (%eax),%eax
  8034aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8034af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034c7:	48                   	dec    %eax
  8034c8:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8034cd:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034ce:	e9 ea 02 00 00       	jmp    8037bd <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8034d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d7:	74 3b                	je     803514 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8034d9:	83 ec 0c             	sub    $0xc,%esp
  8034dc:	ff 75 08             	pushl  0x8(%ebp)
  8034df:	e8 be f0 ff ff       	call   8025a2 <get_block_size>
  8034e4:	83 c4 10             	add    $0x10,%esp
  8034e7:	89 c3                	mov    %eax,%ebx
  8034e9:	83 ec 0c             	sub    $0xc,%esp
  8034ec:	ff 75 10             	pushl  0x10(%ebp)
  8034ef:	e8 ae f0 ff ff       	call   8025a2 <get_block_size>
  8034f4:	83 c4 10             	add    $0x10,%esp
  8034f7:	01 d8                	add    %ebx,%eax
  8034f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8034fc:	83 ec 04             	sub    $0x4,%esp
  8034ff:	6a 00                	push   $0x0
  803501:	ff 75 e8             	pushl  -0x18(%ebp)
  803504:	ff 75 08             	pushl  0x8(%ebp)
  803507:	e8 e7 f3 ff ff       	call   8028f3 <set_block_data>
  80350c:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80350f:	e9 a9 02 00 00       	jmp    8037bd <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803514:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803518:	0f 84 2d 01 00 00    	je     80364b <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80351e:	83 ec 0c             	sub    $0xc,%esp
  803521:	ff 75 10             	pushl  0x10(%ebp)
  803524:	e8 79 f0 ff ff       	call   8025a2 <get_block_size>
  803529:	83 c4 10             	add    $0x10,%esp
  80352c:	89 c3                	mov    %eax,%ebx
  80352e:	83 ec 0c             	sub    $0xc,%esp
  803531:	ff 75 0c             	pushl  0xc(%ebp)
  803534:	e8 69 f0 ff ff       	call   8025a2 <get_block_size>
  803539:	83 c4 10             	add    $0x10,%esp
  80353c:	01 d8                	add    %ebx,%eax
  80353e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803541:	83 ec 04             	sub    $0x4,%esp
  803544:	6a 00                	push   $0x0
  803546:	ff 75 e4             	pushl  -0x1c(%ebp)
  803549:	ff 75 10             	pushl  0x10(%ebp)
  80354c:	e8 a2 f3 ff ff       	call   8028f3 <set_block_data>
  803551:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803554:	8b 45 10             	mov    0x10(%ebp),%eax
  803557:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80355a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80355e:	74 06                	je     803566 <merging+0x1c6>
  803560:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803564:	75 17                	jne    80357d <merging+0x1dd>
  803566:	83 ec 04             	sub    $0x4,%esp
  803569:	68 fc 4b 80 00       	push   $0x804bfc
  80356e:	68 8d 01 00 00       	push   $0x18d
  803573:	68 55 4b 80 00       	push   $0x804b55
  803578:	e8 ce d1 ff ff       	call   80074b <_panic>
  80357d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803580:	8b 50 04             	mov    0x4(%eax),%edx
  803583:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803586:	89 50 04             	mov    %edx,0x4(%eax)
  803589:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80358c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80358f:	89 10                	mov    %edx,(%eax)
  803591:	8b 45 0c             	mov    0xc(%ebp),%eax
  803594:	8b 40 04             	mov    0x4(%eax),%eax
  803597:	85 c0                	test   %eax,%eax
  803599:	74 0d                	je     8035a8 <merging+0x208>
  80359b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80359e:	8b 40 04             	mov    0x4(%eax),%eax
  8035a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035a4:	89 10                	mov    %edx,(%eax)
  8035a6:	eb 08                	jmp    8035b0 <merging+0x210>
  8035a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ab:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035b6:	89 50 04             	mov    %edx,0x4(%eax)
  8035b9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035be:	40                   	inc    %eax
  8035bf:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  8035c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035c8:	75 17                	jne    8035e1 <merging+0x241>
  8035ca:	83 ec 04             	sub    $0x4,%esp
  8035cd:	68 37 4b 80 00       	push   $0x804b37
  8035d2:	68 8e 01 00 00       	push   $0x18e
  8035d7:	68 55 4b 80 00       	push   $0x804b55
  8035dc:	e8 6a d1 ff ff       	call   80074b <_panic>
  8035e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e4:	8b 00                	mov    (%eax),%eax
  8035e6:	85 c0                	test   %eax,%eax
  8035e8:	74 10                	je     8035fa <merging+0x25a>
  8035ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ed:	8b 00                	mov    (%eax),%eax
  8035ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f2:	8b 52 04             	mov    0x4(%edx),%edx
  8035f5:	89 50 04             	mov    %edx,0x4(%eax)
  8035f8:	eb 0b                	jmp    803605 <merging+0x265>
  8035fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fd:	8b 40 04             	mov    0x4(%eax),%eax
  803600:	a3 34 50 80 00       	mov    %eax,0x805034
  803605:	8b 45 0c             	mov    0xc(%ebp),%eax
  803608:	8b 40 04             	mov    0x4(%eax),%eax
  80360b:	85 c0                	test   %eax,%eax
  80360d:	74 0f                	je     80361e <merging+0x27e>
  80360f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803612:	8b 40 04             	mov    0x4(%eax),%eax
  803615:	8b 55 0c             	mov    0xc(%ebp),%edx
  803618:	8b 12                	mov    (%edx),%edx
  80361a:	89 10                	mov    %edx,(%eax)
  80361c:	eb 0a                	jmp    803628 <merging+0x288>
  80361e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803621:	8b 00                	mov    (%eax),%eax
  803623:	a3 30 50 80 00       	mov    %eax,0x805030
  803628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803631:	8b 45 0c             	mov    0xc(%ebp),%eax
  803634:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803640:	48                   	dec    %eax
  803641:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803646:	e9 72 01 00 00       	jmp    8037bd <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80364b:	8b 45 10             	mov    0x10(%ebp),%eax
  80364e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803651:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803655:	74 79                	je     8036d0 <merging+0x330>
  803657:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80365b:	74 73                	je     8036d0 <merging+0x330>
  80365d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803661:	74 06                	je     803669 <merging+0x2c9>
  803663:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803667:	75 17                	jne    803680 <merging+0x2e0>
  803669:	83 ec 04             	sub    $0x4,%esp
  80366c:	68 c8 4b 80 00       	push   $0x804bc8
  803671:	68 94 01 00 00       	push   $0x194
  803676:	68 55 4b 80 00       	push   $0x804b55
  80367b:	e8 cb d0 ff ff       	call   80074b <_panic>
  803680:	8b 45 08             	mov    0x8(%ebp),%eax
  803683:	8b 10                	mov    (%eax),%edx
  803685:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803688:	89 10                	mov    %edx,(%eax)
  80368a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80368d:	8b 00                	mov    (%eax),%eax
  80368f:	85 c0                	test   %eax,%eax
  803691:	74 0b                	je     80369e <merging+0x2fe>
  803693:	8b 45 08             	mov    0x8(%ebp),%eax
  803696:	8b 00                	mov    (%eax),%eax
  803698:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80369b:	89 50 04             	mov    %edx,0x4(%eax)
  80369e:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036a4:	89 10                	mov    %edx,(%eax)
  8036a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ac:	89 50 04             	mov    %edx,0x4(%eax)
  8036af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036b2:	8b 00                	mov    (%eax),%eax
  8036b4:	85 c0                	test   %eax,%eax
  8036b6:	75 08                	jne    8036c0 <merging+0x320>
  8036b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036bb:	a3 34 50 80 00       	mov    %eax,0x805034
  8036c0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036c5:	40                   	inc    %eax
  8036c6:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036cb:	e9 ce 00 00 00       	jmp    80379e <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8036d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036d4:	74 65                	je     80373b <merging+0x39b>
  8036d6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036da:	75 17                	jne    8036f3 <merging+0x353>
  8036dc:	83 ec 04             	sub    $0x4,%esp
  8036df:	68 a4 4b 80 00       	push   $0x804ba4
  8036e4:	68 95 01 00 00       	push   $0x195
  8036e9:	68 55 4b 80 00       	push   $0x804b55
  8036ee:	e8 58 d0 ff ff       	call   80074b <_panic>
  8036f3:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8036f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036fc:	89 50 04             	mov    %edx,0x4(%eax)
  8036ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803702:	8b 40 04             	mov    0x4(%eax),%eax
  803705:	85 c0                	test   %eax,%eax
  803707:	74 0c                	je     803715 <merging+0x375>
  803709:	a1 34 50 80 00       	mov    0x805034,%eax
  80370e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803711:	89 10                	mov    %edx,(%eax)
  803713:	eb 08                	jmp    80371d <merging+0x37d>
  803715:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803718:	a3 30 50 80 00       	mov    %eax,0x805030
  80371d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803720:	a3 34 50 80 00       	mov    %eax,0x805034
  803725:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803728:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80372e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803733:	40                   	inc    %eax
  803734:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803739:	eb 63                	jmp    80379e <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80373b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80373f:	75 17                	jne    803758 <merging+0x3b8>
  803741:	83 ec 04             	sub    $0x4,%esp
  803744:	68 70 4b 80 00       	push   $0x804b70
  803749:	68 98 01 00 00       	push   $0x198
  80374e:	68 55 4b 80 00       	push   $0x804b55
  803753:	e8 f3 cf ff ff       	call   80074b <_panic>
  803758:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80375e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803761:	89 10                	mov    %edx,(%eax)
  803763:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803766:	8b 00                	mov    (%eax),%eax
  803768:	85 c0                	test   %eax,%eax
  80376a:	74 0d                	je     803779 <merging+0x3d9>
  80376c:	a1 30 50 80 00       	mov    0x805030,%eax
  803771:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803774:	89 50 04             	mov    %edx,0x4(%eax)
  803777:	eb 08                	jmp    803781 <merging+0x3e1>
  803779:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80377c:	a3 34 50 80 00       	mov    %eax,0x805034
  803781:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803784:	a3 30 50 80 00       	mov    %eax,0x805030
  803789:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80378c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803793:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803798:	40                   	inc    %eax
  803799:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  80379e:	83 ec 0c             	sub    $0xc,%esp
  8037a1:	ff 75 10             	pushl  0x10(%ebp)
  8037a4:	e8 f9 ed ff ff       	call   8025a2 <get_block_size>
  8037a9:	83 c4 10             	add    $0x10,%esp
  8037ac:	83 ec 04             	sub    $0x4,%esp
  8037af:	6a 00                	push   $0x0
  8037b1:	50                   	push   %eax
  8037b2:	ff 75 10             	pushl  0x10(%ebp)
  8037b5:	e8 39 f1 ff ff       	call   8028f3 <set_block_data>
  8037ba:	83 c4 10             	add    $0x10,%esp
	}
}
  8037bd:	90                   	nop
  8037be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8037c1:	c9                   	leave  
  8037c2:	c3                   	ret    

008037c3 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8037c3:	55                   	push   %ebp
  8037c4:	89 e5                	mov    %esp,%ebp
  8037c6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8037c9:	a1 30 50 80 00       	mov    0x805030,%eax
  8037ce:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8037d1:	a1 34 50 80 00       	mov    0x805034,%eax
  8037d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037d9:	73 1b                	jae    8037f6 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8037db:	a1 34 50 80 00       	mov    0x805034,%eax
  8037e0:	83 ec 04             	sub    $0x4,%esp
  8037e3:	ff 75 08             	pushl  0x8(%ebp)
  8037e6:	6a 00                	push   $0x0
  8037e8:	50                   	push   %eax
  8037e9:	e8 b2 fb ff ff       	call   8033a0 <merging>
  8037ee:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037f1:	e9 8b 00 00 00       	jmp    803881 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8037f6:	a1 30 50 80 00       	mov    0x805030,%eax
  8037fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037fe:	76 18                	jbe    803818 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803800:	a1 30 50 80 00       	mov    0x805030,%eax
  803805:	83 ec 04             	sub    $0x4,%esp
  803808:	ff 75 08             	pushl  0x8(%ebp)
  80380b:	50                   	push   %eax
  80380c:	6a 00                	push   $0x0
  80380e:	e8 8d fb ff ff       	call   8033a0 <merging>
  803813:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803816:	eb 69                	jmp    803881 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803818:	a1 30 50 80 00       	mov    0x805030,%eax
  80381d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803820:	eb 39                	jmp    80385b <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803825:	3b 45 08             	cmp    0x8(%ebp),%eax
  803828:	73 29                	jae    803853 <free_block+0x90>
  80382a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382d:	8b 00                	mov    (%eax),%eax
  80382f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803832:	76 1f                	jbe    803853 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803837:	8b 00                	mov    (%eax),%eax
  803839:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80383c:	83 ec 04             	sub    $0x4,%esp
  80383f:	ff 75 08             	pushl  0x8(%ebp)
  803842:	ff 75 f0             	pushl  -0x10(%ebp)
  803845:	ff 75 f4             	pushl  -0xc(%ebp)
  803848:	e8 53 fb ff ff       	call   8033a0 <merging>
  80384d:	83 c4 10             	add    $0x10,%esp
			break;
  803850:	90                   	nop
		}
	}
}
  803851:	eb 2e                	jmp    803881 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803853:	a1 38 50 80 00       	mov    0x805038,%eax
  803858:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80385b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80385f:	74 07                	je     803868 <free_block+0xa5>
  803861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803864:	8b 00                	mov    (%eax),%eax
  803866:	eb 05                	jmp    80386d <free_block+0xaa>
  803868:	b8 00 00 00 00       	mov    $0x0,%eax
  80386d:	a3 38 50 80 00       	mov    %eax,0x805038
  803872:	a1 38 50 80 00       	mov    0x805038,%eax
  803877:	85 c0                	test   %eax,%eax
  803879:	75 a7                	jne    803822 <free_block+0x5f>
  80387b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80387f:	75 a1                	jne    803822 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803881:	90                   	nop
  803882:	c9                   	leave  
  803883:	c3                   	ret    

00803884 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803884:	55                   	push   %ebp
  803885:	89 e5                	mov    %esp,%ebp
  803887:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80388a:	ff 75 08             	pushl  0x8(%ebp)
  80388d:	e8 10 ed ff ff       	call   8025a2 <get_block_size>
  803892:	83 c4 04             	add    $0x4,%esp
  803895:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803898:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80389f:	eb 17                	jmp    8038b8 <copy_data+0x34>
  8038a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8038a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038a7:	01 c2                	add    %eax,%edx
  8038a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8038ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8038af:	01 c8                	add    %ecx,%eax
  8038b1:	8a 00                	mov    (%eax),%al
  8038b3:	88 02                	mov    %al,(%edx)
  8038b5:	ff 45 fc             	incl   -0x4(%ebp)
  8038b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8038bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8038be:	72 e1                	jb     8038a1 <copy_data+0x1d>
}
  8038c0:	90                   	nop
  8038c1:	c9                   	leave  
  8038c2:	c3                   	ret    

008038c3 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8038c3:	55                   	push   %ebp
  8038c4:	89 e5                	mov    %esp,%ebp
  8038c6:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8038c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038cd:	75 23                	jne    8038f2 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8038cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038d3:	74 13                	je     8038e8 <realloc_block_FF+0x25>
  8038d5:	83 ec 0c             	sub    $0xc,%esp
  8038d8:	ff 75 0c             	pushl  0xc(%ebp)
  8038db:	e8 42 f0 ff ff       	call   802922 <alloc_block_FF>
  8038e0:	83 c4 10             	add    $0x10,%esp
  8038e3:	e9 e4 06 00 00       	jmp    803fcc <realloc_block_FF+0x709>
		return NULL;
  8038e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ed:	e9 da 06 00 00       	jmp    803fcc <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8038f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038f6:	75 18                	jne    803910 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8038f8:	83 ec 0c             	sub    $0xc,%esp
  8038fb:	ff 75 08             	pushl  0x8(%ebp)
  8038fe:	e8 c0 fe ff ff       	call   8037c3 <free_block>
  803903:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803906:	b8 00 00 00 00       	mov    $0x0,%eax
  80390b:	e9 bc 06 00 00       	jmp    803fcc <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803910:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803914:	77 07                	ja     80391d <realloc_block_FF+0x5a>
  803916:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80391d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803920:	83 e0 01             	and    $0x1,%eax
  803923:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803926:	8b 45 0c             	mov    0xc(%ebp),%eax
  803929:	83 c0 08             	add    $0x8,%eax
  80392c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80392f:	83 ec 0c             	sub    $0xc,%esp
  803932:	ff 75 08             	pushl  0x8(%ebp)
  803935:	e8 68 ec ff ff       	call   8025a2 <get_block_size>
  80393a:	83 c4 10             	add    $0x10,%esp
  80393d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803940:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803943:	83 e8 08             	sub    $0x8,%eax
  803946:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803949:	8b 45 08             	mov    0x8(%ebp),%eax
  80394c:	83 e8 04             	sub    $0x4,%eax
  80394f:	8b 00                	mov    (%eax),%eax
  803951:	83 e0 fe             	and    $0xfffffffe,%eax
  803954:	89 c2                	mov    %eax,%edx
  803956:	8b 45 08             	mov    0x8(%ebp),%eax
  803959:	01 d0                	add    %edx,%eax
  80395b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80395e:	83 ec 0c             	sub    $0xc,%esp
  803961:	ff 75 e4             	pushl  -0x1c(%ebp)
  803964:	e8 39 ec ff ff       	call   8025a2 <get_block_size>
  803969:	83 c4 10             	add    $0x10,%esp
  80396c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80396f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803972:	83 e8 08             	sub    $0x8,%eax
  803975:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80397b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80397e:	75 08                	jne    803988 <realloc_block_FF+0xc5>
	{
		 return va;
  803980:	8b 45 08             	mov    0x8(%ebp),%eax
  803983:	e9 44 06 00 00       	jmp    803fcc <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80398b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80398e:	0f 83 d5 03 00 00    	jae    803d69 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803994:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803997:	2b 45 0c             	sub    0xc(%ebp),%eax
  80399a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80399d:	83 ec 0c             	sub    $0xc,%esp
  8039a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039a3:	e8 13 ec ff ff       	call   8025bb <is_free_block>
  8039a8:	83 c4 10             	add    $0x10,%esp
  8039ab:	84 c0                	test   %al,%al
  8039ad:	0f 84 3b 01 00 00    	je     803aee <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8039b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039b9:	01 d0                	add    %edx,%eax
  8039bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8039be:	83 ec 04             	sub    $0x4,%esp
  8039c1:	6a 01                	push   $0x1
  8039c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8039c6:	ff 75 08             	pushl  0x8(%ebp)
  8039c9:	e8 25 ef ff ff       	call   8028f3 <set_block_data>
  8039ce:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8039d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d4:	83 e8 04             	sub    $0x4,%eax
  8039d7:	8b 00                	mov    (%eax),%eax
  8039d9:	83 e0 fe             	and    $0xfffffffe,%eax
  8039dc:	89 c2                	mov    %eax,%edx
  8039de:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e1:	01 d0                	add    %edx,%eax
  8039e3:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8039e6:	83 ec 04             	sub    $0x4,%esp
  8039e9:	6a 00                	push   $0x0
  8039eb:	ff 75 cc             	pushl  -0x34(%ebp)
  8039ee:	ff 75 c8             	pushl  -0x38(%ebp)
  8039f1:	e8 fd ee ff ff       	call   8028f3 <set_block_data>
  8039f6:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039fd:	74 06                	je     803a05 <realloc_block_FF+0x142>
  8039ff:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803a03:	75 17                	jne    803a1c <realloc_block_FF+0x159>
  803a05:	83 ec 04             	sub    $0x4,%esp
  803a08:	68 c8 4b 80 00       	push   $0x804bc8
  803a0d:	68 f6 01 00 00       	push   $0x1f6
  803a12:	68 55 4b 80 00       	push   $0x804b55
  803a17:	e8 2f cd ff ff       	call   80074b <_panic>
  803a1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1f:	8b 10                	mov    (%eax),%edx
  803a21:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a24:	89 10                	mov    %edx,(%eax)
  803a26:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a29:	8b 00                	mov    (%eax),%eax
  803a2b:	85 c0                	test   %eax,%eax
  803a2d:	74 0b                	je     803a3a <realloc_block_FF+0x177>
  803a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a32:	8b 00                	mov    (%eax),%eax
  803a34:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a37:	89 50 04             	mov    %edx,0x4(%eax)
  803a3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a40:	89 10                	mov    %edx,(%eax)
  803a42:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a48:	89 50 04             	mov    %edx,0x4(%eax)
  803a4b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a4e:	8b 00                	mov    (%eax),%eax
  803a50:	85 c0                	test   %eax,%eax
  803a52:	75 08                	jne    803a5c <realloc_block_FF+0x199>
  803a54:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a57:	a3 34 50 80 00       	mov    %eax,0x805034
  803a5c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a61:	40                   	inc    %eax
  803a62:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a6b:	75 17                	jne    803a84 <realloc_block_FF+0x1c1>
  803a6d:	83 ec 04             	sub    $0x4,%esp
  803a70:	68 37 4b 80 00       	push   $0x804b37
  803a75:	68 f7 01 00 00       	push   $0x1f7
  803a7a:	68 55 4b 80 00       	push   $0x804b55
  803a7f:	e8 c7 cc ff ff       	call   80074b <_panic>
  803a84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a87:	8b 00                	mov    (%eax),%eax
  803a89:	85 c0                	test   %eax,%eax
  803a8b:	74 10                	je     803a9d <realloc_block_FF+0x1da>
  803a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a90:	8b 00                	mov    (%eax),%eax
  803a92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a95:	8b 52 04             	mov    0x4(%edx),%edx
  803a98:	89 50 04             	mov    %edx,0x4(%eax)
  803a9b:	eb 0b                	jmp    803aa8 <realloc_block_FF+0x1e5>
  803a9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa0:	8b 40 04             	mov    0x4(%eax),%eax
  803aa3:	a3 34 50 80 00       	mov    %eax,0x805034
  803aa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aab:	8b 40 04             	mov    0x4(%eax),%eax
  803aae:	85 c0                	test   %eax,%eax
  803ab0:	74 0f                	je     803ac1 <realloc_block_FF+0x1fe>
  803ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab5:	8b 40 04             	mov    0x4(%eax),%eax
  803ab8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803abb:	8b 12                	mov    (%edx),%edx
  803abd:	89 10                	mov    %edx,(%eax)
  803abf:	eb 0a                	jmp    803acb <realloc_block_FF+0x208>
  803ac1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac4:	8b 00                	mov    (%eax),%eax
  803ac6:	a3 30 50 80 00       	mov    %eax,0x805030
  803acb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ace:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ad4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ade:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ae3:	48                   	dec    %eax
  803ae4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803ae9:	e9 73 02 00 00       	jmp    803d61 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803aee:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803af2:	0f 86 69 02 00 00    	jbe    803d61 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803af8:	83 ec 04             	sub    $0x4,%esp
  803afb:	6a 01                	push   $0x1
  803afd:	ff 75 f0             	pushl  -0x10(%ebp)
  803b00:	ff 75 08             	pushl  0x8(%ebp)
  803b03:	e8 eb ed ff ff       	call   8028f3 <set_block_data>
  803b08:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0e:	83 e8 04             	sub    $0x4,%eax
  803b11:	8b 00                	mov    (%eax),%eax
  803b13:	83 e0 fe             	and    $0xfffffffe,%eax
  803b16:	89 c2                	mov    %eax,%edx
  803b18:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1b:	01 d0                	add    %edx,%eax
  803b1d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803b20:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b25:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803b28:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b2c:	75 68                	jne    803b96 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b2e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b32:	75 17                	jne    803b4b <realloc_block_FF+0x288>
  803b34:	83 ec 04             	sub    $0x4,%esp
  803b37:	68 70 4b 80 00       	push   $0x804b70
  803b3c:	68 06 02 00 00       	push   $0x206
  803b41:	68 55 4b 80 00       	push   $0x804b55
  803b46:	e8 00 cc ff ff       	call   80074b <_panic>
  803b4b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b54:	89 10                	mov    %edx,(%eax)
  803b56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b59:	8b 00                	mov    (%eax),%eax
  803b5b:	85 c0                	test   %eax,%eax
  803b5d:	74 0d                	je     803b6c <realloc_block_FF+0x2a9>
  803b5f:	a1 30 50 80 00       	mov    0x805030,%eax
  803b64:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b67:	89 50 04             	mov    %edx,0x4(%eax)
  803b6a:	eb 08                	jmp    803b74 <realloc_block_FF+0x2b1>
  803b6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b6f:	a3 34 50 80 00       	mov    %eax,0x805034
  803b74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b77:	a3 30 50 80 00       	mov    %eax,0x805030
  803b7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b86:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b8b:	40                   	inc    %eax
  803b8c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b91:	e9 b0 01 00 00       	jmp    803d46 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803b96:	a1 30 50 80 00       	mov    0x805030,%eax
  803b9b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b9e:	76 68                	jbe    803c08 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ba0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ba4:	75 17                	jne    803bbd <realloc_block_FF+0x2fa>
  803ba6:	83 ec 04             	sub    $0x4,%esp
  803ba9:	68 70 4b 80 00       	push   $0x804b70
  803bae:	68 0b 02 00 00       	push   $0x20b
  803bb3:	68 55 4b 80 00       	push   $0x804b55
  803bb8:	e8 8e cb ff ff       	call   80074b <_panic>
  803bbd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803bc3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc6:	89 10                	mov    %edx,(%eax)
  803bc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bcb:	8b 00                	mov    (%eax),%eax
  803bcd:	85 c0                	test   %eax,%eax
  803bcf:	74 0d                	je     803bde <realloc_block_FF+0x31b>
  803bd1:	a1 30 50 80 00       	mov    0x805030,%eax
  803bd6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bd9:	89 50 04             	mov    %edx,0x4(%eax)
  803bdc:	eb 08                	jmp    803be6 <realloc_block_FF+0x323>
  803bde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be1:	a3 34 50 80 00       	mov    %eax,0x805034
  803be6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be9:	a3 30 50 80 00       	mov    %eax,0x805030
  803bee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bf1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bf8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bfd:	40                   	inc    %eax
  803bfe:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c03:	e9 3e 01 00 00       	jmp    803d46 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803c08:	a1 30 50 80 00       	mov    0x805030,%eax
  803c0d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c10:	73 68                	jae    803c7a <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c12:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c16:	75 17                	jne    803c2f <realloc_block_FF+0x36c>
  803c18:	83 ec 04             	sub    $0x4,%esp
  803c1b:	68 a4 4b 80 00       	push   $0x804ba4
  803c20:	68 10 02 00 00       	push   $0x210
  803c25:	68 55 4b 80 00       	push   $0x804b55
  803c2a:	e8 1c cb ff ff       	call   80074b <_panic>
  803c2f:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803c35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c38:	89 50 04             	mov    %edx,0x4(%eax)
  803c3b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c3e:	8b 40 04             	mov    0x4(%eax),%eax
  803c41:	85 c0                	test   %eax,%eax
  803c43:	74 0c                	je     803c51 <realloc_block_FF+0x38e>
  803c45:	a1 34 50 80 00       	mov    0x805034,%eax
  803c4a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c4d:	89 10                	mov    %edx,(%eax)
  803c4f:	eb 08                	jmp    803c59 <realloc_block_FF+0x396>
  803c51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c54:	a3 30 50 80 00       	mov    %eax,0x805030
  803c59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c5c:	a3 34 50 80 00       	mov    %eax,0x805034
  803c61:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c6a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c6f:	40                   	inc    %eax
  803c70:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c75:	e9 cc 00 00 00       	jmp    803d46 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803c81:	a1 30 50 80 00       	mov    0x805030,%eax
  803c86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c89:	e9 8a 00 00 00       	jmp    803d18 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c91:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c94:	73 7a                	jae    803d10 <realloc_block_FF+0x44d>
  803c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c99:	8b 00                	mov    (%eax),%eax
  803c9b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c9e:	73 70                	jae    803d10 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803ca0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ca4:	74 06                	je     803cac <realloc_block_FF+0x3e9>
  803ca6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803caa:	75 17                	jne    803cc3 <realloc_block_FF+0x400>
  803cac:	83 ec 04             	sub    $0x4,%esp
  803caf:	68 c8 4b 80 00       	push   $0x804bc8
  803cb4:	68 1a 02 00 00       	push   $0x21a
  803cb9:	68 55 4b 80 00       	push   $0x804b55
  803cbe:	e8 88 ca ff ff       	call   80074b <_panic>
  803cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc6:	8b 10                	mov    (%eax),%edx
  803cc8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ccb:	89 10                	mov    %edx,(%eax)
  803ccd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cd0:	8b 00                	mov    (%eax),%eax
  803cd2:	85 c0                	test   %eax,%eax
  803cd4:	74 0b                	je     803ce1 <realloc_block_FF+0x41e>
  803cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd9:	8b 00                	mov    (%eax),%eax
  803cdb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cde:	89 50 04             	mov    %edx,0x4(%eax)
  803ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ce7:	89 10                	mov    %edx,(%eax)
  803ce9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cef:	89 50 04             	mov    %edx,0x4(%eax)
  803cf2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cf5:	8b 00                	mov    (%eax),%eax
  803cf7:	85 c0                	test   %eax,%eax
  803cf9:	75 08                	jne    803d03 <realloc_block_FF+0x440>
  803cfb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cfe:	a3 34 50 80 00       	mov    %eax,0x805034
  803d03:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d08:	40                   	inc    %eax
  803d09:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803d0e:	eb 36                	jmp    803d46 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803d10:	a1 38 50 80 00       	mov    0x805038,%eax
  803d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d1c:	74 07                	je     803d25 <realloc_block_FF+0x462>
  803d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d21:	8b 00                	mov    (%eax),%eax
  803d23:	eb 05                	jmp    803d2a <realloc_block_FF+0x467>
  803d25:	b8 00 00 00 00       	mov    $0x0,%eax
  803d2a:	a3 38 50 80 00       	mov    %eax,0x805038
  803d2f:	a1 38 50 80 00       	mov    0x805038,%eax
  803d34:	85 c0                	test   %eax,%eax
  803d36:	0f 85 52 ff ff ff    	jne    803c8e <realloc_block_FF+0x3cb>
  803d3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d40:	0f 85 48 ff ff ff    	jne    803c8e <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803d46:	83 ec 04             	sub    $0x4,%esp
  803d49:	6a 00                	push   $0x0
  803d4b:	ff 75 d8             	pushl  -0x28(%ebp)
  803d4e:	ff 75 d4             	pushl  -0x2c(%ebp)
  803d51:	e8 9d eb ff ff       	call   8028f3 <set_block_data>
  803d56:	83 c4 10             	add    $0x10,%esp
				return va;
  803d59:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5c:	e9 6b 02 00 00       	jmp    803fcc <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803d61:	8b 45 08             	mov    0x8(%ebp),%eax
  803d64:	e9 63 02 00 00       	jmp    803fcc <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d6c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d6f:	0f 86 4d 02 00 00    	jbe    803fc2 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803d75:	83 ec 0c             	sub    $0xc,%esp
  803d78:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d7b:	e8 3b e8 ff ff       	call   8025bb <is_free_block>
  803d80:	83 c4 10             	add    $0x10,%esp
  803d83:	84 c0                	test   %al,%al
  803d85:	0f 84 37 02 00 00    	je     803fc2 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d8e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d91:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803d94:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d97:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d9a:	76 38                	jbe    803dd4 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803d9c:	83 ec 0c             	sub    $0xc,%esp
  803d9f:	ff 75 0c             	pushl  0xc(%ebp)
  803da2:	e8 7b eb ff ff       	call   802922 <alloc_block_FF>
  803da7:	83 c4 10             	add    $0x10,%esp
  803daa:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803dad:	83 ec 08             	sub    $0x8,%esp
  803db0:	ff 75 c0             	pushl  -0x40(%ebp)
  803db3:	ff 75 08             	pushl  0x8(%ebp)
  803db6:	e8 c9 fa ff ff       	call   803884 <copy_data>
  803dbb:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803dbe:	83 ec 0c             	sub    $0xc,%esp
  803dc1:	ff 75 08             	pushl  0x8(%ebp)
  803dc4:	e8 fa f9 ff ff       	call   8037c3 <free_block>
  803dc9:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803dcc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803dcf:	e9 f8 01 00 00       	jmp    803fcc <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803dd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dd7:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803dda:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803ddd:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803de1:	0f 87 a0 00 00 00    	ja     803e87 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803de7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803deb:	75 17                	jne    803e04 <realloc_block_FF+0x541>
  803ded:	83 ec 04             	sub    $0x4,%esp
  803df0:	68 37 4b 80 00       	push   $0x804b37
  803df5:	68 38 02 00 00       	push   $0x238
  803dfa:	68 55 4b 80 00       	push   $0x804b55
  803dff:	e8 47 c9 ff ff       	call   80074b <_panic>
  803e04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e07:	8b 00                	mov    (%eax),%eax
  803e09:	85 c0                	test   %eax,%eax
  803e0b:	74 10                	je     803e1d <realloc_block_FF+0x55a>
  803e0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e10:	8b 00                	mov    (%eax),%eax
  803e12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e15:	8b 52 04             	mov    0x4(%edx),%edx
  803e18:	89 50 04             	mov    %edx,0x4(%eax)
  803e1b:	eb 0b                	jmp    803e28 <realloc_block_FF+0x565>
  803e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e20:	8b 40 04             	mov    0x4(%eax),%eax
  803e23:	a3 34 50 80 00       	mov    %eax,0x805034
  803e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e2b:	8b 40 04             	mov    0x4(%eax),%eax
  803e2e:	85 c0                	test   %eax,%eax
  803e30:	74 0f                	je     803e41 <realloc_block_FF+0x57e>
  803e32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e35:	8b 40 04             	mov    0x4(%eax),%eax
  803e38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e3b:	8b 12                	mov    (%edx),%edx
  803e3d:	89 10                	mov    %edx,(%eax)
  803e3f:	eb 0a                	jmp    803e4b <realloc_block_FF+0x588>
  803e41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e44:	8b 00                	mov    (%eax),%eax
  803e46:	a3 30 50 80 00       	mov    %eax,0x805030
  803e4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e5e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e63:	48                   	dec    %eax
  803e64:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803e69:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e6f:	01 d0                	add    %edx,%eax
  803e71:	83 ec 04             	sub    $0x4,%esp
  803e74:	6a 01                	push   $0x1
  803e76:	50                   	push   %eax
  803e77:	ff 75 08             	pushl  0x8(%ebp)
  803e7a:	e8 74 ea ff ff       	call   8028f3 <set_block_data>
  803e7f:	83 c4 10             	add    $0x10,%esp
  803e82:	e9 36 01 00 00       	jmp    803fbd <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803e87:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e8a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e8d:	01 d0                	add    %edx,%eax
  803e8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803e92:	83 ec 04             	sub    $0x4,%esp
  803e95:	6a 01                	push   $0x1
  803e97:	ff 75 f0             	pushl  -0x10(%ebp)
  803e9a:	ff 75 08             	pushl  0x8(%ebp)
  803e9d:	e8 51 ea ff ff       	call   8028f3 <set_block_data>
  803ea2:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea8:	83 e8 04             	sub    $0x4,%eax
  803eab:	8b 00                	mov    (%eax),%eax
  803ead:	83 e0 fe             	and    $0xfffffffe,%eax
  803eb0:	89 c2                	mov    %eax,%edx
  803eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb5:	01 d0                	add    %edx,%eax
  803eb7:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803eba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ebe:	74 06                	je     803ec6 <realloc_block_FF+0x603>
  803ec0:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803ec4:	75 17                	jne    803edd <realloc_block_FF+0x61a>
  803ec6:	83 ec 04             	sub    $0x4,%esp
  803ec9:	68 c8 4b 80 00       	push   $0x804bc8
  803ece:	68 44 02 00 00       	push   $0x244
  803ed3:	68 55 4b 80 00       	push   $0x804b55
  803ed8:	e8 6e c8 ff ff       	call   80074b <_panic>
  803edd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee0:	8b 10                	mov    (%eax),%edx
  803ee2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ee5:	89 10                	mov    %edx,(%eax)
  803ee7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803eea:	8b 00                	mov    (%eax),%eax
  803eec:	85 c0                	test   %eax,%eax
  803eee:	74 0b                	je     803efb <realloc_block_FF+0x638>
  803ef0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef3:	8b 00                	mov    (%eax),%eax
  803ef5:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ef8:	89 50 04             	mov    %edx,0x4(%eax)
  803efb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efe:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f01:	89 10                	mov    %edx,(%eax)
  803f03:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f09:	89 50 04             	mov    %edx,0x4(%eax)
  803f0c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f0f:	8b 00                	mov    (%eax),%eax
  803f11:	85 c0                	test   %eax,%eax
  803f13:	75 08                	jne    803f1d <realloc_block_FF+0x65a>
  803f15:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f18:	a3 34 50 80 00       	mov    %eax,0x805034
  803f1d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f22:	40                   	inc    %eax
  803f23:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803f28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f2c:	75 17                	jne    803f45 <realloc_block_FF+0x682>
  803f2e:	83 ec 04             	sub    $0x4,%esp
  803f31:	68 37 4b 80 00       	push   $0x804b37
  803f36:	68 45 02 00 00       	push   $0x245
  803f3b:	68 55 4b 80 00       	push   $0x804b55
  803f40:	e8 06 c8 ff ff       	call   80074b <_panic>
  803f45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f48:	8b 00                	mov    (%eax),%eax
  803f4a:	85 c0                	test   %eax,%eax
  803f4c:	74 10                	je     803f5e <realloc_block_FF+0x69b>
  803f4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f51:	8b 00                	mov    (%eax),%eax
  803f53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f56:	8b 52 04             	mov    0x4(%edx),%edx
  803f59:	89 50 04             	mov    %edx,0x4(%eax)
  803f5c:	eb 0b                	jmp    803f69 <realloc_block_FF+0x6a6>
  803f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f61:	8b 40 04             	mov    0x4(%eax),%eax
  803f64:	a3 34 50 80 00       	mov    %eax,0x805034
  803f69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f6c:	8b 40 04             	mov    0x4(%eax),%eax
  803f6f:	85 c0                	test   %eax,%eax
  803f71:	74 0f                	je     803f82 <realloc_block_FF+0x6bf>
  803f73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f76:	8b 40 04             	mov    0x4(%eax),%eax
  803f79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f7c:	8b 12                	mov    (%edx),%edx
  803f7e:	89 10                	mov    %edx,(%eax)
  803f80:	eb 0a                	jmp    803f8c <realloc_block_FF+0x6c9>
  803f82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f85:	8b 00                	mov    (%eax),%eax
  803f87:	a3 30 50 80 00       	mov    %eax,0x805030
  803f8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f9f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803fa4:	48                   	dec    %eax
  803fa5:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803faa:	83 ec 04             	sub    $0x4,%esp
  803fad:	6a 00                	push   $0x0
  803faf:	ff 75 bc             	pushl  -0x44(%ebp)
  803fb2:	ff 75 b8             	pushl  -0x48(%ebp)
  803fb5:	e8 39 e9 ff ff       	call   8028f3 <set_block_data>
  803fba:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc0:	eb 0a                	jmp    803fcc <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803fc2:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803fc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803fcc:	c9                   	leave  
  803fcd:	c3                   	ret    

00803fce <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803fce:	55                   	push   %ebp
  803fcf:	89 e5                	mov    %esp,%ebp
  803fd1:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803fd4:	83 ec 04             	sub    $0x4,%esp
  803fd7:	68 34 4c 80 00       	push   $0x804c34
  803fdc:	68 58 02 00 00       	push   $0x258
  803fe1:	68 55 4b 80 00       	push   $0x804b55
  803fe6:	e8 60 c7 ff ff       	call   80074b <_panic>

00803feb <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803feb:	55                   	push   %ebp
  803fec:	89 e5                	mov    %esp,%ebp
  803fee:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803ff1:	83 ec 04             	sub    $0x4,%esp
  803ff4:	68 5c 4c 80 00       	push   $0x804c5c
  803ff9:	68 61 02 00 00       	push   $0x261
  803ffe:	68 55 4b 80 00       	push   $0x804b55
  804003:	e8 43 c7 ff ff       	call   80074b <_panic>

00804008 <__udivdi3>:
  804008:	55                   	push   %ebp
  804009:	57                   	push   %edi
  80400a:	56                   	push   %esi
  80400b:	53                   	push   %ebx
  80400c:	83 ec 1c             	sub    $0x1c,%esp
  80400f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804013:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804017:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80401b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80401f:	89 ca                	mov    %ecx,%edx
  804021:	89 f8                	mov    %edi,%eax
  804023:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804027:	85 f6                	test   %esi,%esi
  804029:	75 2d                	jne    804058 <__udivdi3+0x50>
  80402b:	39 cf                	cmp    %ecx,%edi
  80402d:	77 65                	ja     804094 <__udivdi3+0x8c>
  80402f:	89 fd                	mov    %edi,%ebp
  804031:	85 ff                	test   %edi,%edi
  804033:	75 0b                	jne    804040 <__udivdi3+0x38>
  804035:	b8 01 00 00 00       	mov    $0x1,%eax
  80403a:	31 d2                	xor    %edx,%edx
  80403c:	f7 f7                	div    %edi
  80403e:	89 c5                	mov    %eax,%ebp
  804040:	31 d2                	xor    %edx,%edx
  804042:	89 c8                	mov    %ecx,%eax
  804044:	f7 f5                	div    %ebp
  804046:	89 c1                	mov    %eax,%ecx
  804048:	89 d8                	mov    %ebx,%eax
  80404a:	f7 f5                	div    %ebp
  80404c:	89 cf                	mov    %ecx,%edi
  80404e:	89 fa                	mov    %edi,%edx
  804050:	83 c4 1c             	add    $0x1c,%esp
  804053:	5b                   	pop    %ebx
  804054:	5e                   	pop    %esi
  804055:	5f                   	pop    %edi
  804056:	5d                   	pop    %ebp
  804057:	c3                   	ret    
  804058:	39 ce                	cmp    %ecx,%esi
  80405a:	77 28                	ja     804084 <__udivdi3+0x7c>
  80405c:	0f bd fe             	bsr    %esi,%edi
  80405f:	83 f7 1f             	xor    $0x1f,%edi
  804062:	75 40                	jne    8040a4 <__udivdi3+0x9c>
  804064:	39 ce                	cmp    %ecx,%esi
  804066:	72 0a                	jb     804072 <__udivdi3+0x6a>
  804068:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80406c:	0f 87 9e 00 00 00    	ja     804110 <__udivdi3+0x108>
  804072:	b8 01 00 00 00       	mov    $0x1,%eax
  804077:	89 fa                	mov    %edi,%edx
  804079:	83 c4 1c             	add    $0x1c,%esp
  80407c:	5b                   	pop    %ebx
  80407d:	5e                   	pop    %esi
  80407e:	5f                   	pop    %edi
  80407f:	5d                   	pop    %ebp
  804080:	c3                   	ret    
  804081:	8d 76 00             	lea    0x0(%esi),%esi
  804084:	31 ff                	xor    %edi,%edi
  804086:	31 c0                	xor    %eax,%eax
  804088:	89 fa                	mov    %edi,%edx
  80408a:	83 c4 1c             	add    $0x1c,%esp
  80408d:	5b                   	pop    %ebx
  80408e:	5e                   	pop    %esi
  80408f:	5f                   	pop    %edi
  804090:	5d                   	pop    %ebp
  804091:	c3                   	ret    
  804092:	66 90                	xchg   %ax,%ax
  804094:	89 d8                	mov    %ebx,%eax
  804096:	f7 f7                	div    %edi
  804098:	31 ff                	xor    %edi,%edi
  80409a:	89 fa                	mov    %edi,%edx
  80409c:	83 c4 1c             	add    $0x1c,%esp
  80409f:	5b                   	pop    %ebx
  8040a0:	5e                   	pop    %esi
  8040a1:	5f                   	pop    %edi
  8040a2:	5d                   	pop    %ebp
  8040a3:	c3                   	ret    
  8040a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040a9:	89 eb                	mov    %ebp,%ebx
  8040ab:	29 fb                	sub    %edi,%ebx
  8040ad:	89 f9                	mov    %edi,%ecx
  8040af:	d3 e6                	shl    %cl,%esi
  8040b1:	89 c5                	mov    %eax,%ebp
  8040b3:	88 d9                	mov    %bl,%cl
  8040b5:	d3 ed                	shr    %cl,%ebp
  8040b7:	89 e9                	mov    %ebp,%ecx
  8040b9:	09 f1                	or     %esi,%ecx
  8040bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040bf:	89 f9                	mov    %edi,%ecx
  8040c1:	d3 e0                	shl    %cl,%eax
  8040c3:	89 c5                	mov    %eax,%ebp
  8040c5:	89 d6                	mov    %edx,%esi
  8040c7:	88 d9                	mov    %bl,%cl
  8040c9:	d3 ee                	shr    %cl,%esi
  8040cb:	89 f9                	mov    %edi,%ecx
  8040cd:	d3 e2                	shl    %cl,%edx
  8040cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040d3:	88 d9                	mov    %bl,%cl
  8040d5:	d3 e8                	shr    %cl,%eax
  8040d7:	09 c2                	or     %eax,%edx
  8040d9:	89 d0                	mov    %edx,%eax
  8040db:	89 f2                	mov    %esi,%edx
  8040dd:	f7 74 24 0c          	divl   0xc(%esp)
  8040e1:	89 d6                	mov    %edx,%esi
  8040e3:	89 c3                	mov    %eax,%ebx
  8040e5:	f7 e5                	mul    %ebp
  8040e7:	39 d6                	cmp    %edx,%esi
  8040e9:	72 19                	jb     804104 <__udivdi3+0xfc>
  8040eb:	74 0b                	je     8040f8 <__udivdi3+0xf0>
  8040ed:	89 d8                	mov    %ebx,%eax
  8040ef:	31 ff                	xor    %edi,%edi
  8040f1:	e9 58 ff ff ff       	jmp    80404e <__udivdi3+0x46>
  8040f6:	66 90                	xchg   %ax,%ax
  8040f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8040fc:	89 f9                	mov    %edi,%ecx
  8040fe:	d3 e2                	shl    %cl,%edx
  804100:	39 c2                	cmp    %eax,%edx
  804102:	73 e9                	jae    8040ed <__udivdi3+0xe5>
  804104:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804107:	31 ff                	xor    %edi,%edi
  804109:	e9 40 ff ff ff       	jmp    80404e <__udivdi3+0x46>
  80410e:	66 90                	xchg   %ax,%ax
  804110:	31 c0                	xor    %eax,%eax
  804112:	e9 37 ff ff ff       	jmp    80404e <__udivdi3+0x46>
  804117:	90                   	nop

00804118 <__umoddi3>:
  804118:	55                   	push   %ebp
  804119:	57                   	push   %edi
  80411a:	56                   	push   %esi
  80411b:	53                   	push   %ebx
  80411c:	83 ec 1c             	sub    $0x1c,%esp
  80411f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804123:	8b 74 24 34          	mov    0x34(%esp),%esi
  804127:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80412b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80412f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804133:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804137:	89 f3                	mov    %esi,%ebx
  804139:	89 fa                	mov    %edi,%edx
  80413b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80413f:	89 34 24             	mov    %esi,(%esp)
  804142:	85 c0                	test   %eax,%eax
  804144:	75 1a                	jne    804160 <__umoddi3+0x48>
  804146:	39 f7                	cmp    %esi,%edi
  804148:	0f 86 a2 00 00 00    	jbe    8041f0 <__umoddi3+0xd8>
  80414e:	89 c8                	mov    %ecx,%eax
  804150:	89 f2                	mov    %esi,%edx
  804152:	f7 f7                	div    %edi
  804154:	89 d0                	mov    %edx,%eax
  804156:	31 d2                	xor    %edx,%edx
  804158:	83 c4 1c             	add    $0x1c,%esp
  80415b:	5b                   	pop    %ebx
  80415c:	5e                   	pop    %esi
  80415d:	5f                   	pop    %edi
  80415e:	5d                   	pop    %ebp
  80415f:	c3                   	ret    
  804160:	39 f0                	cmp    %esi,%eax
  804162:	0f 87 ac 00 00 00    	ja     804214 <__umoddi3+0xfc>
  804168:	0f bd e8             	bsr    %eax,%ebp
  80416b:	83 f5 1f             	xor    $0x1f,%ebp
  80416e:	0f 84 ac 00 00 00    	je     804220 <__umoddi3+0x108>
  804174:	bf 20 00 00 00       	mov    $0x20,%edi
  804179:	29 ef                	sub    %ebp,%edi
  80417b:	89 fe                	mov    %edi,%esi
  80417d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804181:	89 e9                	mov    %ebp,%ecx
  804183:	d3 e0                	shl    %cl,%eax
  804185:	89 d7                	mov    %edx,%edi
  804187:	89 f1                	mov    %esi,%ecx
  804189:	d3 ef                	shr    %cl,%edi
  80418b:	09 c7                	or     %eax,%edi
  80418d:	89 e9                	mov    %ebp,%ecx
  80418f:	d3 e2                	shl    %cl,%edx
  804191:	89 14 24             	mov    %edx,(%esp)
  804194:	89 d8                	mov    %ebx,%eax
  804196:	d3 e0                	shl    %cl,%eax
  804198:	89 c2                	mov    %eax,%edx
  80419a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80419e:	d3 e0                	shl    %cl,%eax
  8041a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041a8:	89 f1                	mov    %esi,%ecx
  8041aa:	d3 e8                	shr    %cl,%eax
  8041ac:	09 d0                	or     %edx,%eax
  8041ae:	d3 eb                	shr    %cl,%ebx
  8041b0:	89 da                	mov    %ebx,%edx
  8041b2:	f7 f7                	div    %edi
  8041b4:	89 d3                	mov    %edx,%ebx
  8041b6:	f7 24 24             	mull   (%esp)
  8041b9:	89 c6                	mov    %eax,%esi
  8041bb:	89 d1                	mov    %edx,%ecx
  8041bd:	39 d3                	cmp    %edx,%ebx
  8041bf:	0f 82 87 00 00 00    	jb     80424c <__umoddi3+0x134>
  8041c5:	0f 84 91 00 00 00    	je     80425c <__umoddi3+0x144>
  8041cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041cf:	29 f2                	sub    %esi,%edx
  8041d1:	19 cb                	sbb    %ecx,%ebx
  8041d3:	89 d8                	mov    %ebx,%eax
  8041d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041d9:	d3 e0                	shl    %cl,%eax
  8041db:	89 e9                	mov    %ebp,%ecx
  8041dd:	d3 ea                	shr    %cl,%edx
  8041df:	09 d0                	or     %edx,%eax
  8041e1:	89 e9                	mov    %ebp,%ecx
  8041e3:	d3 eb                	shr    %cl,%ebx
  8041e5:	89 da                	mov    %ebx,%edx
  8041e7:	83 c4 1c             	add    $0x1c,%esp
  8041ea:	5b                   	pop    %ebx
  8041eb:	5e                   	pop    %esi
  8041ec:	5f                   	pop    %edi
  8041ed:	5d                   	pop    %ebp
  8041ee:	c3                   	ret    
  8041ef:	90                   	nop
  8041f0:	89 fd                	mov    %edi,%ebp
  8041f2:	85 ff                	test   %edi,%edi
  8041f4:	75 0b                	jne    804201 <__umoddi3+0xe9>
  8041f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8041fb:	31 d2                	xor    %edx,%edx
  8041fd:	f7 f7                	div    %edi
  8041ff:	89 c5                	mov    %eax,%ebp
  804201:	89 f0                	mov    %esi,%eax
  804203:	31 d2                	xor    %edx,%edx
  804205:	f7 f5                	div    %ebp
  804207:	89 c8                	mov    %ecx,%eax
  804209:	f7 f5                	div    %ebp
  80420b:	89 d0                	mov    %edx,%eax
  80420d:	e9 44 ff ff ff       	jmp    804156 <__umoddi3+0x3e>
  804212:	66 90                	xchg   %ax,%ax
  804214:	89 c8                	mov    %ecx,%eax
  804216:	89 f2                	mov    %esi,%edx
  804218:	83 c4 1c             	add    $0x1c,%esp
  80421b:	5b                   	pop    %ebx
  80421c:	5e                   	pop    %esi
  80421d:	5f                   	pop    %edi
  80421e:	5d                   	pop    %ebp
  80421f:	c3                   	ret    
  804220:	3b 04 24             	cmp    (%esp),%eax
  804223:	72 06                	jb     80422b <__umoddi3+0x113>
  804225:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804229:	77 0f                	ja     80423a <__umoddi3+0x122>
  80422b:	89 f2                	mov    %esi,%edx
  80422d:	29 f9                	sub    %edi,%ecx
  80422f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804233:	89 14 24             	mov    %edx,(%esp)
  804236:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80423a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80423e:	8b 14 24             	mov    (%esp),%edx
  804241:	83 c4 1c             	add    $0x1c,%esp
  804244:	5b                   	pop    %ebx
  804245:	5e                   	pop    %esi
  804246:	5f                   	pop    %edi
  804247:	5d                   	pop    %ebp
  804248:	c3                   	ret    
  804249:	8d 76 00             	lea    0x0(%esi),%esi
  80424c:	2b 04 24             	sub    (%esp),%eax
  80424f:	19 fa                	sbb    %edi,%edx
  804251:	89 d1                	mov    %edx,%ecx
  804253:	89 c6                	mov    %eax,%esi
  804255:	e9 71 ff ff ff       	jmp    8041cb <__umoddi3+0xb3>
  80425a:	66 90                	xchg   %ax,%ax
  80425c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804260:	72 ea                	jb     80424c <__umoddi3+0x134>
  804262:	89 d9                	mov    %ebx,%ecx
  804264:	e9 62 ff ff ff       	jmp    8041cb <__umoddi3+0xb3>
