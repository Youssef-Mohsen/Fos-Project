
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
  800041:	e8 f1 1f 00 00       	call   802037 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 43 80 00       	push   $0x804300
  80004e:	e8 b5 09 00 00       	call   800a08 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 43 80 00       	push   $0x804302
  80005e:	e8 a5 09 00 00       	call   800a08 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 1b 43 80 00       	push   $0x80431b
  80006e:	e8 95 09 00 00       	call   800a08 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 43 80 00       	push   $0x804302
  80007e:	e8 85 09 00 00       	call   800a08 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 43 80 00       	push   $0x804300
  80008e:	e8 75 09 00 00       	call   800a08 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 34 43 80 00       	push   $0x804334
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
  8000c9:	68 54 43 80 00       	push   $0x804354
  8000ce:	e8 35 09 00 00       	call   800a08 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 76 43 80 00       	push   $0x804376
  8000de:	e8 25 09 00 00       	call   800a08 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 84 43 80 00       	push   $0x804384
  8000ee:	e8 15 09 00 00       	call   800a08 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 93 43 80 00       	push   $0x804393
  8000fe:	e8 05 09 00 00       	call   800a08 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 a3 43 80 00       	push   $0x8043a3
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
  80014d:	e8 ff 1e 00 00       	call   802051 <sys_unlock_cons>
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
  8001d5:	e8 5d 1e 00 00       	call   802037 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 ac 43 80 00       	push   $0x8043ac
  8001e2:	e8 21 08 00 00       	call   800a08 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 62 1e 00 00       	call   802051 <sys_unlock_cons>
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
  80020c:	68 e0 43 80 00       	push   $0x8043e0
  800211:	6a 54                	push   $0x54
  800213:	68 02 44 80 00       	push   $0x804402
  800218:	e8 2e 05 00 00       	call   80074b <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 15 1e 00 00       	call   802037 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 20 44 80 00       	push   $0x804420
  80022a:	e8 d9 07 00 00       	call   800a08 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 54 44 80 00       	push   $0x804454
  80023a:	e8 c9 07 00 00       	call   800a08 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 88 44 80 00       	push   $0x804488
  80024a:	e8 b9 07 00 00       	call   800a08 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 fa 1d 00 00       	call   802051 <sys_unlock_cons>
			//			sys_unlock_cons();


		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 ec             	pushl  -0x14(%ebp)
  80025d:	e8 7d 19 00 00       	call   801bdf <free>
  800262:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
  800265:	e8 cd 1d 00 00       	call   802037 <sys_lock_cons>
		{
			Chose = 0 ;
  80026a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  80026e:	eb 42                	jmp    8002b2 <_main+0x27a>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 ba 44 80 00       	push   $0x8044ba
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
  8002be:	e8 8e 1d 00 00       	call   802051 <sys_unlock_cons>
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
  800570:	68 00 43 80 00       	push   $0x804300
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
  800592:	68 d8 44 80 00       	push   $0x8044d8
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
  8005c0:	68 dd 44 80 00       	push   $0x8044dd
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
  8005e4:	e8 99 1b 00 00       	call   802182 <sys_cputc>
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
  8005f5:	e8 24 1a 00 00       	call   80201e <sys_cgetc>
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
  800612:	e8 9c 1c 00 00       	call   8022b3 <sys_getenvindex>
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
  800680:	e8 b2 19 00 00       	call   802037 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800685:	83 ec 0c             	sub    $0xc,%esp
  800688:	68 fc 44 80 00       	push   $0x8044fc
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
  8006b0:	68 24 45 80 00       	push   $0x804524
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
  8006e1:	68 4c 45 80 00       	push   $0x80454c
  8006e6:	e8 1d 03 00 00       	call   800a08 <cprintf>
  8006eb:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f3:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	50                   	push   %eax
  8006fd:	68 a4 45 80 00       	push   $0x8045a4
  800702:	e8 01 03 00 00       	call   800a08 <cprintf>
  800707:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 fc 44 80 00       	push   $0x8044fc
  800712:	e8 f1 02 00 00       	call   800a08 <cprintf>
  800717:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80071a:	e8 32 19 00 00       	call   802051 <sys_unlock_cons>
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
  800732:	e8 48 1b 00 00       	call   80227f <sys_destroy_env>
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
  800743:	e8 9d 1b 00 00       	call   8022e5 <sys_exit_env>
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
  80075a:	a1 54 50 80 00       	mov    0x805054,%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	74 16                	je     800779 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800763:	a1 54 50 80 00       	mov    0x805054,%eax
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	50                   	push   %eax
  80076c:	68 b8 45 80 00       	push   $0x8045b8
  800771:	e8 92 02 00 00       	call   800a08 <cprintf>
  800776:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800779:	a1 00 50 80 00       	mov    0x805000,%eax
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	ff 75 08             	pushl  0x8(%ebp)
  800784:	50                   	push   %eax
  800785:	68 bd 45 80 00       	push   $0x8045bd
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
  8007a9:	68 d9 45 80 00       	push   $0x8045d9
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
  8007d8:	68 dc 45 80 00       	push   $0x8045dc
  8007dd:	6a 26                	push   $0x26
  8007df:	68 28 46 80 00       	push   $0x804628
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
  8008ad:	68 34 46 80 00       	push   $0x804634
  8008b2:	6a 3a                	push   $0x3a
  8008b4:	68 28 46 80 00       	push   $0x804628
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
  800920:	68 88 46 80 00       	push   $0x804688
  800925:	6a 44                	push   $0x44
  800927:	68 28 46 80 00       	push   $0x804628
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
  80095f:	a0 30 50 80 00       	mov    0x805030,%al
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
  80097a:	e8 76 16 00 00       	call   801ff5 <sys_cputs>
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
  8009d4:	a0 30 50 80 00       	mov    0x805030,%al
  8009d9:	0f b6 c0             	movzbl %al,%eax
  8009dc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009e2:	83 ec 04             	sub    $0x4,%esp
  8009e5:	50                   	push   %eax
  8009e6:	52                   	push   %edx
  8009e7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009ed:	83 c0 08             	add    $0x8,%eax
  8009f0:	50                   	push   %eax
  8009f1:	e8 ff 15 00 00       	call   801ff5 <sys_cputs>
  8009f6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009f9:	c6 05 30 50 80 00 00 	movb   $0x0,0x805030
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
  800a0e:	c6 05 30 50 80 00 01 	movb   $0x1,0x805030
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
  800a3b:	e8 f7 15 00 00       	call   802037 <sys_lock_cons>
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
  800a5b:	e8 f1 15 00 00       	call   802051 <sys_unlock_cons>
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
  800aa5:	e8 e2 35 00 00       	call   80408c <__udivdi3>
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
  800af5:	e8 a2 36 00 00       	call   80419c <__umoddi3>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	05 f4 48 80 00       	add    $0x8048f4,%eax
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
  800c50:	8b 04 85 18 49 80 00 	mov    0x804918(,%eax,4),%eax
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
  800d31:	8b 34 9d 60 47 80 00 	mov    0x804760(,%ebx,4),%esi
  800d38:	85 f6                	test   %esi,%esi
  800d3a:	75 19                	jne    800d55 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d3c:	53                   	push   %ebx
  800d3d:	68 05 49 80 00       	push   $0x804905
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
  800d56:	68 0e 49 80 00       	push   $0x80490e
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
  800d83:	be 11 49 80 00       	mov    $0x804911,%esi
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
  800f7b:	c6 05 30 50 80 00 00 	movb   $0x0,0x805030
			break;
  800f82:	eb 2c                	jmp    800fb0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f84:	c6 05 30 50 80 00 01 	movb   $0x1,0x805030
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
  8010ae:	68 88 4a 80 00       	push   $0x804a88
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
  8010f0:	68 8b 4a 80 00       	push   $0x804a8b
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
  8011a1:	e8 91 0e 00 00       	call   802037 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8011a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011aa:	74 13                	je     8011bf <atomic_readline+0x24>
			cprintf("%s", prompt);
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	ff 75 08             	pushl  0x8(%ebp)
  8011b2:	68 88 4a 80 00       	push   $0x804a88
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
  8011f4:	68 8b 4a 80 00       	push   $0x804a8b
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
  80129c:	e8 b0 0d 00 00       	call   802051 <sys_unlock_cons>
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
  801996:	68 9c 4a 80 00       	push   $0x804a9c
  80199b:	68 3f 01 00 00       	push   $0x13f
  8019a0:	68 be 4a 80 00       	push   $0x804abe
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
  8019b6:	e8 e5 0b 00 00       	call   8025a0 <sys_sbrk>
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
  801a31:	e8 ee 09 00 00       	call   802424 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a36:	85 c0                	test   %eax,%eax
  801a38:	74 16                	je     801a50 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a3a:	83 ec 0c             	sub    $0xc,%esp
  801a3d:	ff 75 08             	pushl  0x8(%ebp)
  801a40:	e8 2e 0f 00 00       	call   802973 <alloc_block_FF>
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a4b:	e9 8a 01 00 00       	jmp    801bda <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801a50:	e8 00 0a 00 00       	call   802455 <sys_isUHeapPlacementStrategyBESTFIT>
  801a55:	85 c0                	test   %eax,%eax
  801a57:	0f 84 7d 01 00 00    	je     801bda <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801a5d:	83 ec 0c             	sub    $0xc,%esp
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	e8 c7 13 00 00       	call   802e2f <alloc_block_BF>
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
		//cprintf("52\n");
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
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801a9c:	a1 24 50 80 00       	mov    0x805024,%eax
  801aa1:	8b 40 78             	mov    0x78(%eax),%eax
  801aa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aa7:	29 c2                	sub    %eax,%edx
  801aa9:	89 d0                	mov    %edx,%eax
  801aab:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ab0:	c1 e8 0c             	shr    $0xc,%eax
  801ab3:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  801aba:	85 c0                	test   %eax,%eax
  801abc:	0f 85 ab 00 00 00    	jne    801b6d <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac5:	05 00 10 00 00       	add    $0x1000,%eax
  801aca:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801acd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
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
  801b00:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  801b07:	85 c0                	test   %eax,%eax
  801b09:	74 08                	je     801b13 <malloc+0x153>
					{
						//cprintf("71\n");
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
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
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
  801b57:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801b6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b71:	75 16                	jne    801b89 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801b73:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801b7a:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801b81:	0f 86 15 ff ff ff    	jbe    801a9c <malloc+0xdc>
  801b87:	eb 01                	jmp    801b8a <malloc+0x1ca>
				}
				//cprintf("79\n");

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
  801bb9:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801bc0:	83 ec 08             	sub    $0x8,%esp
  801bc3:	ff 75 08             	pushl  0x8(%ebp)
  801bc6:	ff 75 f0             	pushl  -0x10(%ebp)
  801bc9:	e8 09 0a 00 00       	call   8025d7 <sys_allocate_user_mem>
  801bce:	83 c4 10             	add    $0x10,%esp
  801bd1:	eb 07                	jmp    801bda <malloc+0x21a>
		//cprintf("91\n");
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
  801c11:	e8 dd 09 00 00       	call   8025f3 <get_block_size>
  801c16:	83 c4 10             	add    $0x10,%esp
  801c19:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c1c:	83 ec 0c             	sub    $0xc,%esp
  801c1f:	ff 75 08             	pushl  0x8(%ebp)
  801c22:	e8 10 1c 00 00       	call   803837 <free_block>
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
  801c5c:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
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
  801c99:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801ca0:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801ca4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	83 ec 08             	sub    $0x8,%esp
  801cad:	52                   	push   %edx
  801cae:	50                   	push   %eax
  801caf:	e8 07 09 00 00       	call   8025bb <sys_free_user_mem>
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
  801cc7:	68 cc 4a 80 00       	push   $0x804acc
  801ccc:	68 88 00 00 00       	push   $0x88
  801cd1:	68 f6 4a 80 00       	push   $0x804af6
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
  801cf5:	e9 ec 00 00 00       	jmp    801de6 <smalloc+0x108>
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
  801d26:	75 0a                	jne    801d32 <smalloc+0x54>
  801d28:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2d:	e9 b4 00 00 00       	jmp    801de6 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d32:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d36:	ff 75 ec             	pushl  -0x14(%ebp)
  801d39:	50                   	push   %eax
  801d3a:	ff 75 0c             	pushl  0xc(%ebp)
  801d3d:	ff 75 08             	pushl  0x8(%ebp)
  801d40:	e8 7d 04 00 00       	call   8021c2 <sys_createSharedObject>
  801d45:	83 c4 10             	add    $0x10,%esp
  801d48:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801d4b:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801d4f:	74 06                	je     801d57 <smalloc+0x79>
  801d51:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801d55:	75 0a                	jne    801d61 <smalloc+0x83>
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5c:	e9 85 00 00 00       	jmp    801de6 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801d61:	83 ec 08             	sub    $0x8,%esp
  801d64:	ff 75 ec             	pushl  -0x14(%ebp)
  801d67:	68 02 4b 80 00       	push   $0x804b02
  801d6c:	e8 97 ec ff ff       	call   800a08 <cprintf>
  801d71:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801d74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d77:	a1 24 50 80 00       	mov    0x805024,%eax
  801d7c:	8b 40 78             	mov    0x78(%eax),%eax
  801d7f:	29 c2                	sub    %eax,%edx
  801d81:	89 d0                	mov    %edx,%eax
  801d83:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d88:	c1 e8 0c             	shr    $0xc,%eax
  801d8b:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801d91:	42                   	inc    %edx
  801d92:	89 15 28 50 80 00    	mov    %edx,0x805028
  801d98:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801d9e:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801da5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801da8:	a1 24 50 80 00       	mov    0x805024,%eax
  801dad:	8b 40 78             	mov    0x78(%eax),%eax
  801db0:	29 c2                	sub    %eax,%edx
  801db2:	89 d0                	mov    %edx,%eax
  801db4:	2d 00 10 00 00       	sub    $0x1000,%eax
  801db9:	c1 e8 0c             	shr    $0xc,%eax
  801dbc:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801dc3:	a1 24 50 80 00       	mov    0x805024,%eax
  801dc8:	8b 50 10             	mov    0x10(%eax),%edx
  801dcb:	89 c8                	mov    %ecx,%eax
  801dcd:	c1 e0 02             	shl    $0x2,%eax
  801dd0:	89 c1                	mov    %eax,%ecx
  801dd2:	c1 e1 09             	shl    $0x9,%ecx
  801dd5:	01 c8                	add    %ecx,%eax
  801dd7:	01 c2                	add    %eax,%edx
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
  801df7:	e8 f0 03 00 00       	call   8021ec <sys_getSizeOfSharedObject>
  801dfc:	83 c4 10             	add    $0x10,%esp
  801dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801e02:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801e06:	75 0a                	jne    801e12 <sget+0x2a>
  801e08:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0d:	e9 e7 00 00 00       	jmp    801ef9 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e18:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e25:	39 d0                	cmp    %edx,%eax
  801e27:	73 02                	jae    801e2b <sget+0x43>
  801e29:	89 d0                	mov    %edx,%eax
  801e2b:	83 ec 0c             	sub    $0xc,%esp
  801e2e:	50                   	push   %eax
  801e2f:	e8 8c fb ff ff       	call   8019c0 <malloc>
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801e3a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e3e:	75 0a                	jne    801e4a <sget+0x62>
  801e40:	b8 00 00 00 00       	mov    $0x0,%eax
  801e45:	e9 af 00 00 00       	jmp    801ef9 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801e4a:	83 ec 04             	sub    $0x4,%esp
  801e4d:	ff 75 e8             	pushl  -0x18(%ebp)
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	ff 75 08             	pushl  0x8(%ebp)
  801e56:	e8 ae 03 00 00       	call   802209 <sys_getSharedObject>
  801e5b:	83 c4 10             	add    $0x10,%esp
  801e5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801e61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e64:	a1 24 50 80 00       	mov    0x805024,%eax
  801e69:	8b 40 78             	mov    0x78(%eax),%eax
  801e6c:	29 c2                	sub    %eax,%edx
  801e6e:	89 d0                	mov    %edx,%eax
  801e70:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e75:	c1 e8 0c             	shr    $0xc,%eax
  801e78:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801e7e:	42                   	inc    %edx
  801e7f:	89 15 28 50 80 00    	mov    %edx,0x805028
  801e85:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801e8b:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801e92:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e95:	a1 24 50 80 00       	mov    0x805024,%eax
  801e9a:	8b 40 78             	mov    0x78(%eax),%eax
  801e9d:	29 c2                	sub    %eax,%edx
  801e9f:	89 d0                	mov    %edx,%eax
  801ea1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ea6:	c1 e8 0c             	shr    $0xc,%eax
  801ea9:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801eb0:	a1 24 50 80 00       	mov    0x805024,%eax
  801eb5:	8b 50 10             	mov    0x10(%eax),%edx
  801eb8:	89 c8                	mov    %ecx,%eax
  801eba:	c1 e0 02             	shl    $0x2,%eax
  801ebd:	89 c1                	mov    %eax,%ecx
  801ebf:	c1 e1 09             	shl    $0x9,%ecx
  801ec2:	01 c8                	add    %ecx,%eax
  801ec4:	01 c2                	add    %eax,%edx
  801ec6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ec9:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801ed0:	a1 24 50 80 00       	mov    0x805024,%eax
  801ed5:	8b 40 10             	mov    0x10(%eax),%eax
  801ed8:	83 ec 08             	sub    $0x8,%esp
  801edb:	50                   	push   %eax
  801edc:	68 11 4b 80 00       	push   $0x804b11
  801ee1:	e8 22 eb ff ff       	call   800a08 <cprintf>
  801ee6:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801ee9:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801eed:	75 07                	jne    801ef6 <sget+0x10e>
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef4:	eb 03                	jmp    801ef9 <sget+0x111>
	return ptr;
  801ef6:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801f01:	8b 55 08             	mov    0x8(%ebp),%edx
  801f04:	a1 24 50 80 00       	mov    0x805024,%eax
  801f09:	8b 40 78             	mov    0x78(%eax),%eax
  801f0c:	29 c2                	sub    %eax,%edx
  801f0e:	89 d0                	mov    %edx,%eax
  801f10:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f15:	c1 e8 0c             	shr    $0xc,%eax
  801f18:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801f1f:	a1 24 50 80 00       	mov    0x805024,%eax
  801f24:	8b 50 10             	mov    0x10(%eax),%edx
  801f27:	89 c8                	mov    %ecx,%eax
  801f29:	c1 e0 02             	shl    $0x2,%eax
  801f2c:	89 c1                	mov    %eax,%ecx
  801f2e:	c1 e1 09             	shl    $0x9,%ecx
  801f31:	01 c8                	add    %ecx,%eax
  801f33:	01 d0                	add    %edx,%eax
  801f35:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801f3f:	83 ec 08             	sub    $0x8,%esp
  801f42:	ff 75 08             	pushl  0x8(%ebp)
  801f45:	ff 75 f4             	pushl  -0xc(%ebp)
  801f48:	e8 db 02 00 00       	call   802228 <sys_freeSharedObject>
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801f53:	90                   	nop
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f5c:	83 ec 04             	sub    $0x4,%esp
  801f5f:	68 20 4b 80 00       	push   $0x804b20
  801f64:	68 e5 00 00 00       	push   $0xe5
  801f69:	68 f6 4a 80 00       	push   $0x804af6
  801f6e:	e8 d8 e7 ff ff       	call   80074b <_panic>

00801f73 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f79:	83 ec 04             	sub    $0x4,%esp
  801f7c:	68 46 4b 80 00       	push   $0x804b46
  801f81:	68 f1 00 00 00       	push   $0xf1
  801f86:	68 f6 4a 80 00       	push   $0x804af6
  801f8b:	e8 bb e7 ff ff       	call   80074b <_panic>

00801f90 <shrink>:

}
void shrink(uint32 newSize)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f96:	83 ec 04             	sub    $0x4,%esp
  801f99:	68 46 4b 80 00       	push   $0x804b46
  801f9e:	68 f6 00 00 00       	push   $0xf6
  801fa3:	68 f6 4a 80 00       	push   $0x804af6
  801fa8:	e8 9e e7 ff ff       	call   80074b <_panic>

00801fad <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fb3:	83 ec 04             	sub    $0x4,%esp
  801fb6:	68 46 4b 80 00       	push   $0x804b46
  801fbb:	68 fb 00 00 00       	push   $0xfb
  801fc0:	68 f6 4a 80 00       	push   $0x804af6
  801fc5:	e8 81 e7 ff ff       	call   80074b <_panic>

00801fca <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	57                   	push   %edi
  801fce:	56                   	push   %esi
  801fcf:	53                   	push   %ebx
  801fd0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fdc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fdf:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fe2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fe5:	cd 30                	int    $0x30
  801fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fed:	83 c4 10             	add    $0x10,%esp
  801ff0:	5b                   	pop    %ebx
  801ff1:	5e                   	pop    %esi
  801ff2:	5f                   	pop    %edi
  801ff3:	5d                   	pop    %ebp
  801ff4:	c3                   	ret    

00801ff5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 04             	sub    $0x4,%esp
  801ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802001:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	52                   	push   %edx
  80200d:	ff 75 0c             	pushl  0xc(%ebp)
  802010:	50                   	push   %eax
  802011:	6a 00                	push   $0x0
  802013:	e8 b2 ff ff ff       	call   801fca <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
}
  80201b:	90                   	nop
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_cgetc>:

int
sys_cgetc(void)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 02                	push   $0x2
  80202d:	e8 98 ff ff ff       	call   801fca <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 03                	push   $0x3
  802046:	e8 7f ff ff ff       	call   801fca <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
}
  80204e:	90                   	nop
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 04                	push   $0x4
  802060:	e8 65 ff ff ff       	call   801fca <syscall>
  802065:	83 c4 18             	add    $0x18,%esp
}
  802068:	90                   	nop
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80206e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802071:	8b 45 08             	mov    0x8(%ebp),%eax
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	52                   	push   %edx
  80207b:	50                   	push   %eax
  80207c:	6a 08                	push   $0x8
  80207e:	e8 47 ff ff ff       	call   801fca <syscall>
  802083:	83 c4 18             	add    $0x18,%esp
}
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	56                   	push   %esi
  80208c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80208d:	8b 75 18             	mov    0x18(%ebp),%esi
  802090:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802093:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802096:	8b 55 0c             	mov    0xc(%ebp),%edx
  802099:	8b 45 08             	mov    0x8(%ebp),%eax
  80209c:	56                   	push   %esi
  80209d:	53                   	push   %ebx
  80209e:	51                   	push   %ecx
  80209f:	52                   	push   %edx
  8020a0:	50                   	push   %eax
  8020a1:	6a 09                	push   $0x9
  8020a3:	e8 22 ff ff ff       	call   801fca <syscall>
  8020a8:	83 c4 18             	add    $0x18,%esp
}
  8020ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ae:	5b                   	pop    %ebx
  8020af:	5e                   	pop    %esi
  8020b0:	5d                   	pop    %ebp
  8020b1:	c3                   	ret    

008020b2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	52                   	push   %edx
  8020c2:	50                   	push   %eax
  8020c3:	6a 0a                	push   $0xa
  8020c5:	e8 00 ff ff ff       	call   801fca <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
}
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	ff 75 0c             	pushl  0xc(%ebp)
  8020db:	ff 75 08             	pushl  0x8(%ebp)
  8020de:	6a 0b                	push   $0xb
  8020e0:	e8 e5 fe ff ff       	call   801fca <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 0c                	push   $0xc
  8020f9:	e8 cc fe ff ff       	call   801fca <syscall>
  8020fe:	83 c4 18             	add    $0x18,%esp
}
  802101:	c9                   	leave  
  802102:	c3                   	ret    

00802103 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 0d                	push   $0xd
  802112:	e8 b3 fe ff ff       	call   801fca <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 0e                	push   $0xe
  80212b:	e8 9a fe ff ff       	call   801fca <syscall>
  802130:	83 c4 18             	add    $0x18,%esp
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 0f                	push   $0xf
  802144:	e8 81 fe ff ff       	call   801fca <syscall>
  802149:	83 c4 18             	add    $0x18,%esp
}
  80214c:	c9                   	leave  
  80214d:	c3                   	ret    

0080214e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	ff 75 08             	pushl  0x8(%ebp)
  80215c:	6a 10                	push   $0x10
  80215e:	e8 67 fe ff ff       	call   801fca <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 11                	push   $0x11
  802177:	e8 4e fe ff ff       	call   801fca <syscall>
  80217c:	83 c4 18             	add    $0x18,%esp
}
  80217f:	90                   	nop
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <sys_cputc>:

void
sys_cputc(const char c)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 04             	sub    $0x4,%esp
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80218e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	50                   	push   %eax
  80219b:	6a 01                	push   $0x1
  80219d:	e8 28 fe ff ff       	call   801fca <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
}
  8021a5:	90                   	nop
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 14                	push   $0x14
  8021b7:	e8 0e fe ff ff       	call   801fca <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
}
  8021bf:	90                   	nop
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	83 ec 04             	sub    $0x4,%esp
  8021c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8021cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021d1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	6a 00                	push   $0x0
  8021da:	51                   	push   %ecx
  8021db:	52                   	push   %edx
  8021dc:	ff 75 0c             	pushl  0xc(%ebp)
  8021df:	50                   	push   %eax
  8021e0:	6a 15                	push   $0x15
  8021e2:	e8 e3 fd ff ff       	call   801fca <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	52                   	push   %edx
  8021fc:	50                   	push   %eax
  8021fd:	6a 16                	push   $0x16
  8021ff:	e8 c6 fd ff ff       	call   801fca <syscall>
  802204:	83 c4 18             	add    $0x18,%esp
}
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80220c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80220f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	51                   	push   %ecx
  80221a:	52                   	push   %edx
  80221b:	50                   	push   %eax
  80221c:	6a 17                	push   $0x17
  80221e:	e8 a7 fd ff ff       	call   801fca <syscall>
  802223:	83 c4 18             	add    $0x18,%esp
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80222b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	52                   	push   %edx
  802238:	50                   	push   %eax
  802239:	6a 18                	push   $0x18
  80223b:	e8 8a fd ff ff       	call   801fca <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	6a 00                	push   $0x0
  80224d:	ff 75 14             	pushl  0x14(%ebp)
  802250:	ff 75 10             	pushl  0x10(%ebp)
  802253:	ff 75 0c             	pushl  0xc(%ebp)
  802256:	50                   	push   %eax
  802257:	6a 19                	push   $0x19
  802259:	e8 6c fd ff ff       	call   801fca <syscall>
  80225e:	83 c4 18             	add    $0x18,%esp
}
  802261:	c9                   	leave  
  802262:	c3                   	ret    

00802263 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	50                   	push   %eax
  802272:	6a 1a                	push   $0x1a
  802274:	e8 51 fd ff ff       	call   801fca <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
}
  80227c:	90                   	nop
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	50                   	push   %eax
  80228e:	6a 1b                	push   $0x1b
  802290:	e8 35 fd ff ff       	call   801fca <syscall>
  802295:	83 c4 18             	add    $0x18,%esp
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 05                	push   $0x5
  8022a9:	e8 1c fd ff ff       	call   801fca <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 06                	push   $0x6
  8022c2:	e8 03 fd ff ff       	call   801fca <syscall>
  8022c7:	83 c4 18             	add    $0x18,%esp
}
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 07                	push   $0x7
  8022db:	e8 ea fc ff ff       	call   801fca <syscall>
  8022e0:	83 c4 18             	add    $0x18,%esp
}
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <sys_exit_env>:


void sys_exit_env(void)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 1c                	push   $0x1c
  8022f4:	e8 d1 fc ff ff       	call   801fca <syscall>
  8022f9:	83 c4 18             	add    $0x18,%esp
}
  8022fc:	90                   	nop
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802305:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802308:	8d 50 04             	lea    0x4(%eax),%edx
  80230b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	52                   	push   %edx
  802315:	50                   	push   %eax
  802316:	6a 1d                	push   $0x1d
  802318:	e8 ad fc ff ff       	call   801fca <syscall>
  80231d:	83 c4 18             	add    $0x18,%esp
	return result;
  802320:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802323:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802326:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802329:	89 01                	mov    %eax,(%ecx)
  80232b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	c9                   	leave  
  802332:	c2 04 00             	ret    $0x4

00802335 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	ff 75 10             	pushl  0x10(%ebp)
  80233f:	ff 75 0c             	pushl  0xc(%ebp)
  802342:	ff 75 08             	pushl  0x8(%ebp)
  802345:	6a 13                	push   $0x13
  802347:	e8 7e fc ff ff       	call   801fca <syscall>
  80234c:	83 c4 18             	add    $0x18,%esp
	return ;
  80234f:	90                   	nop
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <sys_rcr2>:
uint32 sys_rcr2()
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 1e                	push   $0x1e
  802361:	e8 64 fc ff ff       	call   801fca <syscall>
  802366:	83 c4 18             	add    $0x18,%esp
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	83 ec 04             	sub    $0x4,%esp
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802377:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	50                   	push   %eax
  802384:	6a 1f                	push   $0x1f
  802386:	e8 3f fc ff ff       	call   801fca <syscall>
  80238b:	83 c4 18             	add    $0x18,%esp
	return ;
  80238e:	90                   	nop
}
  80238f:	c9                   	leave  
  802390:	c3                   	ret    

00802391 <rsttst>:
void rsttst()
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 21                	push   $0x21
  8023a0:	e8 25 fc ff ff       	call   801fca <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a8:	90                   	nop
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	83 ec 04             	sub    $0x4,%esp
  8023b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8023b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023b7:	8b 55 18             	mov    0x18(%ebp),%edx
  8023ba:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023be:	52                   	push   %edx
  8023bf:	50                   	push   %eax
  8023c0:	ff 75 10             	pushl  0x10(%ebp)
  8023c3:	ff 75 0c             	pushl  0xc(%ebp)
  8023c6:	ff 75 08             	pushl  0x8(%ebp)
  8023c9:	6a 20                	push   $0x20
  8023cb:	e8 fa fb ff ff       	call   801fca <syscall>
  8023d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d3:	90                   	nop
}
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <chktst>:
void chktst(uint32 n)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	ff 75 08             	pushl  0x8(%ebp)
  8023e4:	6a 22                	push   $0x22
  8023e6:	e8 df fb ff ff       	call   801fca <syscall>
  8023eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ee:	90                   	nop
}
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <inctst>:

void inctst()
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 23                	push   $0x23
  802400:	e8 c5 fb ff ff       	call   801fca <syscall>
  802405:	83 c4 18             	add    $0x18,%esp
	return ;
  802408:	90                   	nop
}
  802409:	c9                   	leave  
  80240a:	c3                   	ret    

0080240b <gettst>:
uint32 gettst()
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 24                	push   $0x24
  80241a:	e8 ab fb ff ff       	call   801fca <syscall>
  80241f:	83 c4 18             	add    $0x18,%esp
}
  802422:	c9                   	leave  
  802423:	c3                   	ret    

00802424 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
  802427:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 25                	push   $0x25
  802436:	e8 8f fb ff ff       	call   801fca <syscall>
  80243b:	83 c4 18             	add    $0x18,%esp
  80243e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802441:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802445:	75 07                	jne    80244e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802447:	b8 01 00 00 00       	mov    $0x1,%eax
  80244c:	eb 05                	jmp    802453 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80244e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802453:	c9                   	leave  
  802454:	c3                   	ret    

00802455 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
  802458:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 25                	push   $0x25
  802467:	e8 5e fb ff ff       	call   801fca <syscall>
  80246c:	83 c4 18             	add    $0x18,%esp
  80246f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802472:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802476:	75 07                	jne    80247f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802478:	b8 01 00 00 00       	mov    $0x1,%eax
  80247d:	eb 05                	jmp    802484 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80247f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 25                	push   $0x25
  802498:	e8 2d fb ff ff       	call   801fca <syscall>
  80249d:	83 c4 18             	add    $0x18,%esp
  8024a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024a3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024a7:	75 07                	jne    8024b0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ae:	eb 05                	jmp    8024b5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b5:	c9                   	leave  
  8024b6:	c3                   	ret    

008024b7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024b7:	55                   	push   %ebp
  8024b8:	89 e5                	mov    %esp,%ebp
  8024ba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 25                	push   $0x25
  8024c9:	e8 fc fa ff ff       	call   801fca <syscall>
  8024ce:	83 c4 18             	add    $0x18,%esp
  8024d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024d4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024d8:	75 07                	jne    8024e1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024da:	b8 01 00 00 00       	mov    $0x1,%eax
  8024df:	eb 05                	jmp    8024e6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	ff 75 08             	pushl  0x8(%ebp)
  8024f6:	6a 26                	push   $0x26
  8024f8:	e8 cd fa ff ff       	call   801fca <syscall>
  8024fd:	83 c4 18             	add    $0x18,%esp
	return ;
  802500:	90                   	nop
}
  802501:	c9                   	leave  
  802502:	c3                   	ret    

00802503 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
  802506:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802507:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80250a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80250d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	6a 00                	push   $0x0
  802515:	53                   	push   %ebx
  802516:	51                   	push   %ecx
  802517:	52                   	push   %edx
  802518:	50                   	push   %eax
  802519:	6a 27                	push   $0x27
  80251b:	e8 aa fa ff ff       	call   801fca <syscall>
  802520:	83 c4 18             	add    $0x18,%esp
}
  802523:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802526:	c9                   	leave  
  802527:	c3                   	ret    

00802528 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802528:	55                   	push   %ebp
  802529:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80252b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80252e:	8b 45 08             	mov    0x8(%ebp),%eax
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	52                   	push   %edx
  802538:	50                   	push   %eax
  802539:	6a 28                	push   $0x28
  80253b:	e8 8a fa ff ff       	call   801fca <syscall>
  802540:	83 c4 18             	add    $0x18,%esp
}
  802543:	c9                   	leave  
  802544:	c3                   	ret    

00802545 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802545:	55                   	push   %ebp
  802546:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802548:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80254b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	6a 00                	push   $0x0
  802553:	51                   	push   %ecx
  802554:	ff 75 10             	pushl  0x10(%ebp)
  802557:	52                   	push   %edx
  802558:	50                   	push   %eax
  802559:	6a 29                	push   $0x29
  80255b:	e8 6a fa ff ff       	call   801fca <syscall>
  802560:	83 c4 18             	add    $0x18,%esp
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	ff 75 10             	pushl  0x10(%ebp)
  80256f:	ff 75 0c             	pushl  0xc(%ebp)
  802572:	ff 75 08             	pushl  0x8(%ebp)
  802575:	6a 12                	push   $0x12
  802577:	e8 4e fa ff ff       	call   801fca <syscall>
  80257c:	83 c4 18             	add    $0x18,%esp
	return ;
  80257f:	90                   	nop
}
  802580:	c9                   	leave  
  802581:	c3                   	ret    

00802582 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802582:	55                   	push   %ebp
  802583:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802585:	8b 55 0c             	mov    0xc(%ebp),%edx
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	52                   	push   %edx
  802592:	50                   	push   %eax
  802593:	6a 2a                	push   $0x2a
  802595:	e8 30 fa ff ff       	call   801fca <syscall>
  80259a:	83 c4 18             	add    $0x18,%esp
	return;
  80259d:	90                   	nop
}
  80259e:	c9                   	leave  
  80259f:	c3                   	ret    

008025a0 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8025a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	50                   	push   %eax
  8025af:	6a 2b                	push   $0x2b
  8025b1:	e8 14 fa ff ff       	call   801fca <syscall>
  8025b6:	83 c4 18             	add    $0x18,%esp
}
  8025b9:	c9                   	leave  
  8025ba:	c3                   	ret    

008025bb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8025bb:	55                   	push   %ebp
  8025bc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	ff 75 0c             	pushl  0xc(%ebp)
  8025c7:	ff 75 08             	pushl  0x8(%ebp)
  8025ca:	6a 2c                	push   $0x2c
  8025cc:	e8 f9 f9 ff ff       	call   801fca <syscall>
  8025d1:	83 c4 18             	add    $0x18,%esp
	return;
  8025d4:	90                   	nop
}
  8025d5:	c9                   	leave  
  8025d6:	c3                   	ret    

008025d7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	ff 75 0c             	pushl  0xc(%ebp)
  8025e3:	ff 75 08             	pushl  0x8(%ebp)
  8025e6:	6a 2d                	push   $0x2d
  8025e8:	e8 dd f9 ff ff       	call   801fca <syscall>
  8025ed:	83 c4 18             	add    $0x18,%esp
	return;
  8025f0:	90                   	nop
}
  8025f1:	c9                   	leave  
  8025f2:	c3                   	ret    

008025f3 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8025f3:	55                   	push   %ebp
  8025f4:	89 e5                	mov    %esp,%ebp
  8025f6:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	83 e8 04             	sub    $0x4,%eax
  8025ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802602:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802605:	8b 00                	mov    (%eax),%eax
  802607:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80260a:	c9                   	leave  
  80260b:	c3                   	ret    

0080260c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80260c:	55                   	push   %ebp
  80260d:	89 e5                	mov    %esp,%ebp
  80260f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802612:	8b 45 08             	mov    0x8(%ebp),%eax
  802615:	83 e8 04             	sub    $0x4,%eax
  802618:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80261b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80261e:	8b 00                	mov    (%eax),%eax
  802620:	83 e0 01             	and    $0x1,%eax
  802623:	85 c0                	test   %eax,%eax
  802625:	0f 94 c0             	sete   %al
}
  802628:	c9                   	leave  
  802629:	c3                   	ret    

0080262a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80262a:	55                   	push   %ebp
  80262b:	89 e5                	mov    %esp,%ebp
  80262d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802630:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80263a:	83 f8 02             	cmp    $0x2,%eax
  80263d:	74 2b                	je     80266a <alloc_block+0x40>
  80263f:	83 f8 02             	cmp    $0x2,%eax
  802642:	7f 07                	jg     80264b <alloc_block+0x21>
  802644:	83 f8 01             	cmp    $0x1,%eax
  802647:	74 0e                	je     802657 <alloc_block+0x2d>
  802649:	eb 58                	jmp    8026a3 <alloc_block+0x79>
  80264b:	83 f8 03             	cmp    $0x3,%eax
  80264e:	74 2d                	je     80267d <alloc_block+0x53>
  802650:	83 f8 04             	cmp    $0x4,%eax
  802653:	74 3b                	je     802690 <alloc_block+0x66>
  802655:	eb 4c                	jmp    8026a3 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802657:	83 ec 0c             	sub    $0xc,%esp
  80265a:	ff 75 08             	pushl  0x8(%ebp)
  80265d:	e8 11 03 00 00       	call   802973 <alloc_block_FF>
  802662:	83 c4 10             	add    $0x10,%esp
  802665:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802668:	eb 4a                	jmp    8026b4 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80266a:	83 ec 0c             	sub    $0xc,%esp
  80266d:	ff 75 08             	pushl  0x8(%ebp)
  802670:	e8 fa 19 00 00       	call   80406f <alloc_block_NF>
  802675:	83 c4 10             	add    $0x10,%esp
  802678:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80267b:	eb 37                	jmp    8026b4 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80267d:	83 ec 0c             	sub    $0xc,%esp
  802680:	ff 75 08             	pushl  0x8(%ebp)
  802683:	e8 a7 07 00 00       	call   802e2f <alloc_block_BF>
  802688:	83 c4 10             	add    $0x10,%esp
  80268b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80268e:	eb 24                	jmp    8026b4 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802690:	83 ec 0c             	sub    $0xc,%esp
  802693:	ff 75 08             	pushl  0x8(%ebp)
  802696:	e8 b7 19 00 00       	call   804052 <alloc_block_WF>
  80269b:	83 c4 10             	add    $0x10,%esp
  80269e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026a1:	eb 11                	jmp    8026b4 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8026a3:	83 ec 0c             	sub    $0xc,%esp
  8026a6:	68 58 4b 80 00       	push   $0x804b58
  8026ab:	e8 58 e3 ff ff       	call   800a08 <cprintf>
  8026b0:	83 c4 10             	add    $0x10,%esp
		break;
  8026b3:	90                   	nop
	}
	return va;
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8026b7:	c9                   	leave  
  8026b8:	c3                   	ret    

008026b9 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8026b9:	55                   	push   %ebp
  8026ba:	89 e5                	mov    %esp,%ebp
  8026bc:	53                   	push   %ebx
  8026bd:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8026c0:	83 ec 0c             	sub    $0xc,%esp
  8026c3:	68 78 4b 80 00       	push   $0x804b78
  8026c8:	e8 3b e3 ff ff       	call   800a08 <cprintf>
  8026cd:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8026d0:	83 ec 0c             	sub    $0xc,%esp
  8026d3:	68 a3 4b 80 00       	push   $0x804ba3
  8026d8:	e8 2b e3 ff ff       	call   800a08 <cprintf>
  8026dd:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8026e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e6:	eb 37                	jmp    80271f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8026e8:	83 ec 0c             	sub    $0xc,%esp
  8026eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ee:	e8 19 ff ff ff       	call   80260c <is_free_block>
  8026f3:	83 c4 10             	add    $0x10,%esp
  8026f6:	0f be d8             	movsbl %al,%ebx
  8026f9:	83 ec 0c             	sub    $0xc,%esp
  8026fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ff:	e8 ef fe ff ff       	call   8025f3 <get_block_size>
  802704:	83 c4 10             	add    $0x10,%esp
  802707:	83 ec 04             	sub    $0x4,%esp
  80270a:	53                   	push   %ebx
  80270b:	50                   	push   %eax
  80270c:	68 bb 4b 80 00       	push   $0x804bbb
  802711:	e8 f2 e2 ff ff       	call   800a08 <cprintf>
  802716:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802719:	8b 45 10             	mov    0x10(%ebp),%eax
  80271c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802723:	74 07                	je     80272c <print_blocks_list+0x73>
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	8b 00                	mov    (%eax),%eax
  80272a:	eb 05                	jmp    802731 <print_blocks_list+0x78>
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
  802731:	89 45 10             	mov    %eax,0x10(%ebp)
  802734:	8b 45 10             	mov    0x10(%ebp),%eax
  802737:	85 c0                	test   %eax,%eax
  802739:	75 ad                	jne    8026e8 <print_blocks_list+0x2f>
  80273b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273f:	75 a7                	jne    8026e8 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802741:	83 ec 0c             	sub    $0xc,%esp
  802744:	68 78 4b 80 00       	push   $0x804b78
  802749:	e8 ba e2 ff ff       	call   800a08 <cprintf>
  80274e:	83 c4 10             	add    $0x10,%esp

}
  802751:	90                   	nop
  802752:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802755:	c9                   	leave  
  802756:	c3                   	ret    

00802757 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
  80275a:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80275d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802760:	83 e0 01             	and    $0x1,%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	74 03                	je     80276a <initialize_dynamic_allocator+0x13>
  802767:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80276a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80276e:	0f 84 c7 01 00 00    	je     80293b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802774:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  80277b:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80277e:	8b 55 08             	mov    0x8(%ebp),%edx
  802781:	8b 45 0c             	mov    0xc(%ebp),%eax
  802784:	01 d0                	add    %edx,%eax
  802786:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80278b:	0f 87 ad 01 00 00    	ja     80293e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802791:	8b 45 08             	mov    0x8(%ebp),%eax
  802794:	85 c0                	test   %eax,%eax
  802796:	0f 89 a5 01 00 00    	jns    802941 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80279c:	8b 55 08             	mov    0x8(%ebp),%edx
  80279f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027a2:	01 d0                	add    %edx,%eax
  8027a4:	83 e8 04             	sub    $0x4,%eax
  8027a7:	a3 4c 50 80 00       	mov    %eax,0x80504c
     struct BlockElement * element = NULL;
  8027ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8027b3:	a1 34 50 80 00       	mov    0x805034,%eax
  8027b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027bb:	e9 87 00 00 00       	jmp    802847 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8027c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c4:	75 14                	jne    8027da <initialize_dynamic_allocator+0x83>
  8027c6:	83 ec 04             	sub    $0x4,%esp
  8027c9:	68 d3 4b 80 00       	push   $0x804bd3
  8027ce:	6a 79                	push   $0x79
  8027d0:	68 f1 4b 80 00       	push   $0x804bf1
  8027d5:	e8 71 df ff ff       	call   80074b <_panic>
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	85 c0                	test   %eax,%eax
  8027e1:	74 10                	je     8027f3 <initialize_dynamic_allocator+0x9c>
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 00                	mov    (%eax),%eax
  8027e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027eb:	8b 52 04             	mov    0x4(%edx),%edx
  8027ee:	89 50 04             	mov    %edx,0x4(%eax)
  8027f1:	eb 0b                	jmp    8027fe <initialize_dynamic_allocator+0xa7>
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 40 04             	mov    0x4(%eax),%eax
  8027f9:	a3 38 50 80 00       	mov    %eax,0x805038
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 40 04             	mov    0x4(%eax),%eax
  802804:	85 c0                	test   %eax,%eax
  802806:	74 0f                	je     802817 <initialize_dynamic_allocator+0xc0>
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	8b 40 04             	mov    0x4(%eax),%eax
  80280e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802811:	8b 12                	mov    (%edx),%edx
  802813:	89 10                	mov    %edx,(%eax)
  802815:	eb 0a                	jmp    802821 <initialize_dynamic_allocator+0xca>
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 00                	mov    (%eax),%eax
  80281c:	a3 34 50 80 00       	mov    %eax,0x805034
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802834:	a1 40 50 80 00       	mov    0x805040,%eax
  802839:	48                   	dec    %eax
  80283a:	a3 40 50 80 00       	mov    %eax,0x805040
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80283f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802844:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802847:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284b:	74 07                	je     802854 <initialize_dynamic_allocator+0xfd>
  80284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802850:	8b 00                	mov    (%eax),%eax
  802852:	eb 05                	jmp    802859 <initialize_dynamic_allocator+0x102>
  802854:	b8 00 00 00 00       	mov    $0x0,%eax
  802859:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80285e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	0f 85 55 ff ff ff    	jne    8027c0 <initialize_dynamic_allocator+0x69>
  80286b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286f:	0f 85 4b ff ff ff    	jne    8027c0 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80287b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802884:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802889:	a3 48 50 80 00       	mov    %eax,0x805048
    end_block->info = 1;
  80288e:	a1 48 50 80 00       	mov    0x805048,%eax
  802893:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	83 c0 08             	add    $0x8,%eax
  80289f:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8028a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a5:	83 c0 04             	add    $0x4,%eax
  8028a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ab:	83 ea 08             	sub    $0x8,%edx
  8028ae:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8028b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	01 d0                	add    %edx,%eax
  8028b8:	83 e8 08             	sub    $0x8,%eax
  8028bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028be:	83 ea 08             	sub    $0x8,%edx
  8028c1:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8028c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8028cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8028d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028da:	75 17                	jne    8028f3 <initialize_dynamic_allocator+0x19c>
  8028dc:	83 ec 04             	sub    $0x4,%esp
  8028df:	68 0c 4c 80 00       	push   $0x804c0c
  8028e4:	68 90 00 00 00       	push   $0x90
  8028e9:	68 f1 4b 80 00       	push   $0x804bf1
  8028ee:	e8 58 de ff ff       	call   80074b <_panic>
  8028f3:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8028f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fc:	89 10                	mov    %edx,(%eax)
  8028fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	85 c0                	test   %eax,%eax
  802905:	74 0d                	je     802914 <initialize_dynamic_allocator+0x1bd>
  802907:	a1 34 50 80 00       	mov    0x805034,%eax
  80290c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80290f:	89 50 04             	mov    %edx,0x4(%eax)
  802912:	eb 08                	jmp    80291c <initialize_dynamic_allocator+0x1c5>
  802914:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802917:	a3 38 50 80 00       	mov    %eax,0x805038
  80291c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291f:	a3 34 50 80 00       	mov    %eax,0x805034
  802924:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802927:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292e:	a1 40 50 80 00       	mov    0x805040,%eax
  802933:	40                   	inc    %eax
  802934:	a3 40 50 80 00       	mov    %eax,0x805040
  802939:	eb 07                	jmp    802942 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80293b:	90                   	nop
  80293c:	eb 04                	jmp    802942 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80293e:	90                   	nop
  80293f:	eb 01                	jmp    802942 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802941:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802942:	c9                   	leave  
  802943:	c3                   	ret    

00802944 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802944:	55                   	push   %ebp
  802945:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802947:	8b 45 10             	mov    0x10(%ebp),%eax
  80294a:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80294d:	8b 45 08             	mov    0x8(%ebp),%eax
  802950:	8d 50 fc             	lea    -0x4(%eax),%edx
  802953:	8b 45 0c             	mov    0xc(%ebp),%eax
  802956:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	83 e8 04             	sub    $0x4,%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	83 e0 fe             	and    $0xfffffffe,%eax
  802963:	8d 50 f8             	lea    -0x8(%eax),%edx
  802966:	8b 45 08             	mov    0x8(%ebp),%eax
  802969:	01 c2                	add    %eax,%edx
  80296b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80296e:	89 02                	mov    %eax,(%edx)
}
  802970:	90                   	nop
  802971:	5d                   	pop    %ebp
  802972:	c3                   	ret    

00802973 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802973:	55                   	push   %ebp
  802974:	89 e5                	mov    %esp,%ebp
  802976:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	83 e0 01             	and    $0x1,%eax
  80297f:	85 c0                	test   %eax,%eax
  802981:	74 03                	je     802986 <alloc_block_FF+0x13>
  802983:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802986:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80298a:	77 07                	ja     802993 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80298c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802993:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802998:	85 c0                	test   %eax,%eax
  80299a:	75 73                	jne    802a0f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80299c:	8b 45 08             	mov    0x8(%ebp),%eax
  80299f:	83 c0 10             	add    $0x10,%eax
  8029a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8029a5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8029ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b2:	01 d0                	add    %edx,%eax
  8029b4:	48                   	dec    %eax
  8029b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8029b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8029c0:	f7 75 ec             	divl   -0x14(%ebp)
  8029c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c6:	29 d0                	sub    %edx,%eax
  8029c8:	c1 e8 0c             	shr    $0xc,%eax
  8029cb:	83 ec 0c             	sub    $0xc,%esp
  8029ce:	50                   	push   %eax
  8029cf:	e8 d6 ef ff ff       	call   8019aa <sbrk>
  8029d4:	83 c4 10             	add    $0x10,%esp
  8029d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029da:	83 ec 0c             	sub    $0xc,%esp
  8029dd:	6a 00                	push   $0x0
  8029df:	e8 c6 ef ff ff       	call   8019aa <sbrk>
  8029e4:	83 c4 10             	add    $0x10,%esp
  8029e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ed:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8029f0:	83 ec 08             	sub    $0x8,%esp
  8029f3:	50                   	push   %eax
  8029f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029f7:	e8 5b fd ff ff       	call   802757 <initialize_dynamic_allocator>
  8029fc:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029ff:	83 ec 0c             	sub    $0xc,%esp
  802a02:	68 2f 4c 80 00       	push   $0x804c2f
  802a07:	e8 fc df ff ff       	call   800a08 <cprintf>
  802a0c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802a0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a13:	75 0a                	jne    802a1f <alloc_block_FF+0xac>
	        return NULL;
  802a15:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1a:	e9 0e 04 00 00       	jmp    802e2d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802a1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a26:	a1 34 50 80 00       	mov    0x805034,%eax
  802a2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2e:	e9 f3 02 00 00       	jmp    802d26 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802a39:	83 ec 0c             	sub    $0xc,%esp
  802a3c:	ff 75 bc             	pushl  -0x44(%ebp)
  802a3f:	e8 af fb ff ff       	call   8025f3 <get_block_size>
  802a44:	83 c4 10             	add    $0x10,%esp
  802a47:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4d:	83 c0 08             	add    $0x8,%eax
  802a50:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a53:	0f 87 c5 02 00 00    	ja     802d1e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	83 c0 18             	add    $0x18,%eax
  802a5f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a62:	0f 87 19 02 00 00    	ja     802c81 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802a68:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a6b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a6e:	83 e8 08             	sub    $0x8,%eax
  802a71:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	8d 50 08             	lea    0x8(%eax),%edx
  802a7a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a7d:	01 d0                	add    %edx,%eax
  802a7f:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	83 c0 08             	add    $0x8,%eax
  802a88:	83 ec 04             	sub    $0x4,%esp
  802a8b:	6a 01                	push   $0x1
  802a8d:	50                   	push   %eax
  802a8e:	ff 75 bc             	pushl  -0x44(%ebp)
  802a91:	e8 ae fe ff ff       	call   802944 <set_block_data>
  802a96:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	75 68                	jne    802b0b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802aa3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802aa7:	75 17                	jne    802ac0 <alloc_block_FF+0x14d>
  802aa9:	83 ec 04             	sub    $0x4,%esp
  802aac:	68 0c 4c 80 00       	push   $0x804c0c
  802ab1:	68 d7 00 00 00       	push   $0xd7
  802ab6:	68 f1 4b 80 00       	push   $0x804bf1
  802abb:	e8 8b dc ff ff       	call   80074b <_panic>
  802ac0:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802ac6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac9:	89 10                	mov    %edx,(%eax)
  802acb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	85 c0                	test   %eax,%eax
  802ad2:	74 0d                	je     802ae1 <alloc_block_FF+0x16e>
  802ad4:	a1 34 50 80 00       	mov    0x805034,%eax
  802ad9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802adc:	89 50 04             	mov    %edx,0x4(%eax)
  802adf:	eb 08                	jmp    802ae9 <alloc_block_FF+0x176>
  802ae1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae4:	a3 38 50 80 00       	mov    %eax,0x805038
  802ae9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aec:	a3 34 50 80 00       	mov    %eax,0x805034
  802af1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802af4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802afb:	a1 40 50 80 00       	mov    0x805040,%eax
  802b00:	40                   	inc    %eax
  802b01:	a3 40 50 80 00       	mov    %eax,0x805040
  802b06:	e9 dc 00 00 00       	jmp    802be7 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	75 65                	jne    802b79 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b14:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b18:	75 17                	jne    802b31 <alloc_block_FF+0x1be>
  802b1a:	83 ec 04             	sub    $0x4,%esp
  802b1d:	68 40 4c 80 00       	push   $0x804c40
  802b22:	68 db 00 00 00       	push   $0xdb
  802b27:	68 f1 4b 80 00       	push   $0x804bf1
  802b2c:	e8 1a dc ff ff       	call   80074b <_panic>
  802b31:	8b 15 38 50 80 00    	mov    0x805038,%edx
  802b37:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b3a:	89 50 04             	mov    %edx,0x4(%eax)
  802b3d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b40:	8b 40 04             	mov    0x4(%eax),%eax
  802b43:	85 c0                	test   %eax,%eax
  802b45:	74 0c                	je     802b53 <alloc_block_FF+0x1e0>
  802b47:	a1 38 50 80 00       	mov    0x805038,%eax
  802b4c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b4f:	89 10                	mov    %edx,(%eax)
  802b51:	eb 08                	jmp    802b5b <alloc_block_FF+0x1e8>
  802b53:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b56:	a3 34 50 80 00       	mov    %eax,0x805034
  802b5b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b5e:	a3 38 50 80 00       	mov    %eax,0x805038
  802b63:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6c:	a1 40 50 80 00       	mov    0x805040,%eax
  802b71:	40                   	inc    %eax
  802b72:	a3 40 50 80 00       	mov    %eax,0x805040
  802b77:	eb 6e                	jmp    802be7 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802b79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7d:	74 06                	je     802b85 <alloc_block_FF+0x212>
  802b7f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b83:	75 17                	jne    802b9c <alloc_block_FF+0x229>
  802b85:	83 ec 04             	sub    $0x4,%esp
  802b88:	68 64 4c 80 00       	push   $0x804c64
  802b8d:	68 df 00 00 00       	push   $0xdf
  802b92:	68 f1 4b 80 00       	push   $0x804bf1
  802b97:	e8 af db ff ff       	call   80074b <_panic>
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 10                	mov    (%eax),%edx
  802ba1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba4:	89 10                	mov    %edx,(%eax)
  802ba6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	74 0b                	je     802bba <alloc_block_FF+0x247>
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 00                	mov    (%eax),%eax
  802bb4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bb7:	89 50 04             	mov    %edx,0x4(%eax)
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bc0:	89 10                	mov    %edx,(%eax)
  802bc2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc8:	89 50 04             	mov    %edx,0x4(%eax)
  802bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bce:	8b 00                	mov    (%eax),%eax
  802bd0:	85 c0                	test   %eax,%eax
  802bd2:	75 08                	jne    802bdc <alloc_block_FF+0x269>
  802bd4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bd7:	a3 38 50 80 00       	mov    %eax,0x805038
  802bdc:	a1 40 50 80 00       	mov    0x805040,%eax
  802be1:	40                   	inc    %eax
  802be2:	a3 40 50 80 00       	mov    %eax,0x805040
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802be7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802beb:	75 17                	jne    802c04 <alloc_block_FF+0x291>
  802bed:	83 ec 04             	sub    $0x4,%esp
  802bf0:	68 d3 4b 80 00       	push   $0x804bd3
  802bf5:	68 e1 00 00 00       	push   $0xe1
  802bfa:	68 f1 4b 80 00       	push   $0x804bf1
  802bff:	e8 47 db ff ff       	call   80074b <_panic>
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 00                	mov    (%eax),%eax
  802c09:	85 c0                	test   %eax,%eax
  802c0b:	74 10                	je     802c1d <alloc_block_FF+0x2aa>
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 00                	mov    (%eax),%eax
  802c12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c15:	8b 52 04             	mov    0x4(%edx),%edx
  802c18:	89 50 04             	mov    %edx,0x4(%eax)
  802c1b:	eb 0b                	jmp    802c28 <alloc_block_FF+0x2b5>
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 40 04             	mov    0x4(%eax),%eax
  802c23:	a3 38 50 80 00       	mov    %eax,0x805038
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 40 04             	mov    0x4(%eax),%eax
  802c2e:	85 c0                	test   %eax,%eax
  802c30:	74 0f                	je     802c41 <alloc_block_FF+0x2ce>
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	8b 40 04             	mov    0x4(%eax),%eax
  802c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c3b:	8b 12                	mov    (%edx),%edx
  802c3d:	89 10                	mov    %edx,(%eax)
  802c3f:	eb 0a                	jmp    802c4b <alloc_block_FF+0x2d8>
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	a3 34 50 80 00       	mov    %eax,0x805034
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5e:	a1 40 50 80 00       	mov    0x805040,%eax
  802c63:	48                   	dec    %eax
  802c64:	a3 40 50 80 00       	mov    %eax,0x805040
				set_block_data(new_block_va, remaining_size, 0);
  802c69:	83 ec 04             	sub    $0x4,%esp
  802c6c:	6a 00                	push   $0x0
  802c6e:	ff 75 b4             	pushl  -0x4c(%ebp)
  802c71:	ff 75 b0             	pushl  -0x50(%ebp)
  802c74:	e8 cb fc ff ff       	call   802944 <set_block_data>
  802c79:	83 c4 10             	add    $0x10,%esp
  802c7c:	e9 95 00 00 00       	jmp    802d16 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802c81:	83 ec 04             	sub    $0x4,%esp
  802c84:	6a 01                	push   $0x1
  802c86:	ff 75 b8             	pushl  -0x48(%ebp)
  802c89:	ff 75 bc             	pushl  -0x44(%ebp)
  802c8c:	e8 b3 fc ff ff       	call   802944 <set_block_data>
  802c91:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802c94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c98:	75 17                	jne    802cb1 <alloc_block_FF+0x33e>
  802c9a:	83 ec 04             	sub    $0x4,%esp
  802c9d:	68 d3 4b 80 00       	push   $0x804bd3
  802ca2:	68 e8 00 00 00       	push   $0xe8
  802ca7:	68 f1 4b 80 00       	push   $0x804bf1
  802cac:	e8 9a da ff ff       	call   80074b <_panic>
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	74 10                	je     802cca <alloc_block_FF+0x357>
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	8b 00                	mov    (%eax),%eax
  802cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc2:	8b 52 04             	mov    0x4(%edx),%edx
  802cc5:	89 50 04             	mov    %edx,0x4(%eax)
  802cc8:	eb 0b                	jmp    802cd5 <alloc_block_FF+0x362>
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 40 04             	mov    0x4(%eax),%eax
  802cd0:	a3 38 50 80 00       	mov    %eax,0x805038
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	8b 40 04             	mov    0x4(%eax),%eax
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	74 0f                	je     802cee <alloc_block_FF+0x37b>
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 40 04             	mov    0x4(%eax),%eax
  802ce5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce8:	8b 12                	mov    (%edx),%edx
  802cea:	89 10                	mov    %edx,(%eax)
  802cec:	eb 0a                	jmp    802cf8 <alloc_block_FF+0x385>
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	a3 34 50 80 00       	mov    %eax,0x805034
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0b:	a1 40 50 80 00       	mov    0x805040,%eax
  802d10:	48                   	dec    %eax
  802d11:	a3 40 50 80 00       	mov    %eax,0x805040
	            }
	            return va;
  802d16:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d19:	e9 0f 01 00 00       	jmp    802e2d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802d1e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2a:	74 07                	je     802d33 <alloc_block_FF+0x3c0>
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	eb 05                	jmp    802d38 <alloc_block_FF+0x3c5>
  802d33:	b8 00 00 00 00       	mov    $0x0,%eax
  802d38:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802d3d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d42:	85 c0                	test   %eax,%eax
  802d44:	0f 85 e9 fc ff ff    	jne    802a33 <alloc_block_FF+0xc0>
  802d4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4e:	0f 85 df fc ff ff    	jne    802a33 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	83 c0 08             	add    $0x8,%eax
  802d5a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d5d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802d64:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d67:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d6a:	01 d0                	add    %edx,%eax
  802d6c:	48                   	dec    %eax
  802d6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802d70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d73:	ba 00 00 00 00       	mov    $0x0,%edx
  802d78:	f7 75 d8             	divl   -0x28(%ebp)
  802d7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d7e:	29 d0                	sub    %edx,%eax
  802d80:	c1 e8 0c             	shr    $0xc,%eax
  802d83:	83 ec 0c             	sub    $0xc,%esp
  802d86:	50                   	push   %eax
  802d87:	e8 1e ec ff ff       	call   8019aa <sbrk>
  802d8c:	83 c4 10             	add    $0x10,%esp
  802d8f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802d92:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d96:	75 0a                	jne    802da2 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802d98:	b8 00 00 00 00       	mov    $0x0,%eax
  802d9d:	e9 8b 00 00 00       	jmp    802e2d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802da2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802da9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802daf:	01 d0                	add    %edx,%eax
  802db1:	48                   	dec    %eax
  802db2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802db5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802db8:	ba 00 00 00 00       	mov    $0x0,%edx
  802dbd:	f7 75 cc             	divl   -0x34(%ebp)
  802dc0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802dc3:	29 d0                	sub    %edx,%eax
  802dc5:	8d 50 fc             	lea    -0x4(%eax),%edx
  802dc8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dcb:	01 d0                	add    %edx,%eax
  802dcd:	a3 48 50 80 00       	mov    %eax,0x805048
			end_block->info = 1;
  802dd2:	a1 48 50 80 00       	mov    0x805048,%eax
  802dd7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ddd:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802de4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802de7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802dea:	01 d0                	add    %edx,%eax
  802dec:	48                   	dec    %eax
  802ded:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802df0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802df3:	ba 00 00 00 00       	mov    $0x0,%edx
  802df8:	f7 75 c4             	divl   -0x3c(%ebp)
  802dfb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dfe:	29 d0                	sub    %edx,%eax
  802e00:	83 ec 04             	sub    $0x4,%esp
  802e03:	6a 01                	push   $0x1
  802e05:	50                   	push   %eax
  802e06:	ff 75 d0             	pushl  -0x30(%ebp)
  802e09:	e8 36 fb ff ff       	call   802944 <set_block_data>
  802e0e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802e11:	83 ec 0c             	sub    $0xc,%esp
  802e14:	ff 75 d0             	pushl  -0x30(%ebp)
  802e17:	e8 1b 0a 00 00       	call   803837 <free_block>
  802e1c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802e1f:	83 ec 0c             	sub    $0xc,%esp
  802e22:	ff 75 08             	pushl  0x8(%ebp)
  802e25:	e8 49 fb ff ff       	call   802973 <alloc_block_FF>
  802e2a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802e2d:	c9                   	leave  
  802e2e:	c3                   	ret    

00802e2f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e2f:	55                   	push   %ebp
  802e30:	89 e5                	mov    %esp,%ebp
  802e32:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	83 e0 01             	and    $0x1,%eax
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	74 03                	je     802e42 <alloc_block_BF+0x13>
  802e3f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802e42:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802e46:	77 07                	ja     802e4f <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802e48:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802e4f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e54:	85 c0                	test   %eax,%eax
  802e56:	75 73                	jne    802ecb <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	83 c0 10             	add    $0x10,%eax
  802e5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e61:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802e68:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6e:	01 d0                	add    %edx,%eax
  802e70:	48                   	dec    %eax
  802e71:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e74:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e77:	ba 00 00 00 00       	mov    $0x0,%edx
  802e7c:	f7 75 e0             	divl   -0x20(%ebp)
  802e7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e82:	29 d0                	sub    %edx,%eax
  802e84:	c1 e8 0c             	shr    $0xc,%eax
  802e87:	83 ec 0c             	sub    $0xc,%esp
  802e8a:	50                   	push   %eax
  802e8b:	e8 1a eb ff ff       	call   8019aa <sbrk>
  802e90:	83 c4 10             	add    $0x10,%esp
  802e93:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802e96:	83 ec 0c             	sub    $0xc,%esp
  802e99:	6a 00                	push   $0x0
  802e9b:	e8 0a eb ff ff       	call   8019aa <sbrk>
  802ea0:	83 c4 10             	add    $0x10,%esp
  802ea3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802ea6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ea9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802eac:	83 ec 08             	sub    $0x8,%esp
  802eaf:	50                   	push   %eax
  802eb0:	ff 75 d8             	pushl  -0x28(%ebp)
  802eb3:	e8 9f f8 ff ff       	call   802757 <initialize_dynamic_allocator>
  802eb8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ebb:	83 ec 0c             	sub    $0xc,%esp
  802ebe:	68 2f 4c 80 00       	push   $0x804c2f
  802ec3:	e8 40 db ff ff       	call   800a08 <cprintf>
  802ec8:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802ecb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802ed2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802ed9:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802ee0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802ee7:	a1 34 50 80 00       	mov    0x805034,%eax
  802eec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eef:	e9 1d 01 00 00       	jmp    803011 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef7:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802efa:	83 ec 0c             	sub    $0xc,%esp
  802efd:	ff 75 a8             	pushl  -0x58(%ebp)
  802f00:	e8 ee f6 ff ff       	call   8025f3 <get_block_size>
  802f05:	83 c4 10             	add    $0x10,%esp
  802f08:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	83 c0 08             	add    $0x8,%eax
  802f11:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f14:	0f 87 ef 00 00 00    	ja     803009 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1d:	83 c0 18             	add    $0x18,%eax
  802f20:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f23:	77 1d                	ja     802f42 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802f25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f28:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f2b:	0f 86 d8 00 00 00    	jbe    803009 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802f31:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f34:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802f37:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802f3d:	e9 c7 00 00 00       	jmp    803009 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	83 c0 08             	add    $0x8,%eax
  802f48:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f4b:	0f 85 9d 00 00 00    	jne    802fee <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802f51:	83 ec 04             	sub    $0x4,%esp
  802f54:	6a 01                	push   $0x1
  802f56:	ff 75 a4             	pushl  -0x5c(%ebp)
  802f59:	ff 75 a8             	pushl  -0x58(%ebp)
  802f5c:	e8 e3 f9 ff ff       	call   802944 <set_block_data>
  802f61:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802f64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f68:	75 17                	jne    802f81 <alloc_block_BF+0x152>
  802f6a:	83 ec 04             	sub    $0x4,%esp
  802f6d:	68 d3 4b 80 00       	push   $0x804bd3
  802f72:	68 2c 01 00 00       	push   $0x12c
  802f77:	68 f1 4b 80 00       	push   $0x804bf1
  802f7c:	e8 ca d7 ff ff       	call   80074b <_panic>
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	8b 00                	mov    (%eax),%eax
  802f86:	85 c0                	test   %eax,%eax
  802f88:	74 10                	je     802f9a <alloc_block_BF+0x16b>
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	8b 00                	mov    (%eax),%eax
  802f8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f92:	8b 52 04             	mov    0x4(%edx),%edx
  802f95:	89 50 04             	mov    %edx,0x4(%eax)
  802f98:	eb 0b                	jmp    802fa5 <alloc_block_BF+0x176>
  802f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9d:	8b 40 04             	mov    0x4(%eax),%eax
  802fa0:	a3 38 50 80 00       	mov    %eax,0x805038
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 40 04             	mov    0x4(%eax),%eax
  802fab:	85 c0                	test   %eax,%eax
  802fad:	74 0f                	je     802fbe <alloc_block_BF+0x18f>
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	8b 40 04             	mov    0x4(%eax),%eax
  802fb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb8:	8b 12                	mov    (%edx),%edx
  802fba:	89 10                	mov    %edx,(%eax)
  802fbc:	eb 0a                	jmp    802fc8 <alloc_block_BF+0x199>
  802fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	a3 34 50 80 00       	mov    %eax,0x805034
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fdb:	a1 40 50 80 00       	mov    0x805040,%eax
  802fe0:	48                   	dec    %eax
  802fe1:	a3 40 50 80 00       	mov    %eax,0x805040
					return va;
  802fe6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fe9:	e9 24 04 00 00       	jmp    803412 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802fee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ff4:	76 13                	jbe    803009 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802ff6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802ffd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803000:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803003:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803006:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803009:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80300e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803011:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803015:	74 07                	je     80301e <alloc_block_BF+0x1ef>
  803017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301a:	8b 00                	mov    (%eax),%eax
  80301c:	eb 05                	jmp    803023 <alloc_block_BF+0x1f4>
  80301e:	b8 00 00 00 00       	mov    $0x0,%eax
  803023:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803028:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80302d:	85 c0                	test   %eax,%eax
  80302f:	0f 85 bf fe ff ff    	jne    802ef4 <alloc_block_BF+0xc5>
  803035:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803039:	0f 85 b5 fe ff ff    	jne    802ef4 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80303f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803043:	0f 84 26 02 00 00    	je     80326f <alloc_block_BF+0x440>
  803049:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80304d:	0f 85 1c 02 00 00    	jne    80326f <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803053:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803056:	2b 45 08             	sub    0x8(%ebp),%eax
  803059:	83 e8 08             	sub    $0x8,%eax
  80305c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	8d 50 08             	lea    0x8(%eax),%edx
  803065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803068:	01 d0                	add    %edx,%eax
  80306a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	83 c0 08             	add    $0x8,%eax
  803073:	83 ec 04             	sub    $0x4,%esp
  803076:	6a 01                	push   $0x1
  803078:	50                   	push   %eax
  803079:	ff 75 f0             	pushl  -0x10(%ebp)
  80307c:	e8 c3 f8 ff ff       	call   802944 <set_block_data>
  803081:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803087:	8b 40 04             	mov    0x4(%eax),%eax
  80308a:	85 c0                	test   %eax,%eax
  80308c:	75 68                	jne    8030f6 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80308e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803092:	75 17                	jne    8030ab <alloc_block_BF+0x27c>
  803094:	83 ec 04             	sub    $0x4,%esp
  803097:	68 0c 4c 80 00       	push   $0x804c0c
  80309c:	68 45 01 00 00       	push   $0x145
  8030a1:	68 f1 4b 80 00       	push   $0x804bf1
  8030a6:	e8 a0 d6 ff ff       	call   80074b <_panic>
  8030ab:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8030b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b4:	89 10                	mov    %edx,(%eax)
  8030b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b9:	8b 00                	mov    (%eax),%eax
  8030bb:	85 c0                	test   %eax,%eax
  8030bd:	74 0d                	je     8030cc <alloc_block_BF+0x29d>
  8030bf:	a1 34 50 80 00       	mov    0x805034,%eax
  8030c4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030c7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ca:	eb 08                	jmp    8030d4 <alloc_block_BF+0x2a5>
  8030cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030cf:	a3 38 50 80 00       	mov    %eax,0x805038
  8030d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8030dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e6:	a1 40 50 80 00       	mov    0x805040,%eax
  8030eb:	40                   	inc    %eax
  8030ec:	a3 40 50 80 00       	mov    %eax,0x805040
  8030f1:	e9 dc 00 00 00       	jmp    8031d2 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8030f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	75 65                	jne    803164 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030ff:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803103:	75 17                	jne    80311c <alloc_block_BF+0x2ed>
  803105:	83 ec 04             	sub    $0x4,%esp
  803108:	68 40 4c 80 00       	push   $0x804c40
  80310d:	68 4a 01 00 00       	push   $0x14a
  803112:	68 f1 4b 80 00       	push   $0x804bf1
  803117:	e8 2f d6 ff ff       	call   80074b <_panic>
  80311c:	8b 15 38 50 80 00    	mov    0x805038,%edx
  803122:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803125:	89 50 04             	mov    %edx,0x4(%eax)
  803128:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80312b:	8b 40 04             	mov    0x4(%eax),%eax
  80312e:	85 c0                	test   %eax,%eax
  803130:	74 0c                	je     80313e <alloc_block_BF+0x30f>
  803132:	a1 38 50 80 00       	mov    0x805038,%eax
  803137:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80313a:	89 10                	mov    %edx,(%eax)
  80313c:	eb 08                	jmp    803146 <alloc_block_BF+0x317>
  80313e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803141:	a3 34 50 80 00       	mov    %eax,0x805034
  803146:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803149:	a3 38 50 80 00       	mov    %eax,0x805038
  80314e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803151:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803157:	a1 40 50 80 00       	mov    0x805040,%eax
  80315c:	40                   	inc    %eax
  80315d:	a3 40 50 80 00       	mov    %eax,0x805040
  803162:	eb 6e                	jmp    8031d2 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803164:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803168:	74 06                	je     803170 <alloc_block_BF+0x341>
  80316a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80316e:	75 17                	jne    803187 <alloc_block_BF+0x358>
  803170:	83 ec 04             	sub    $0x4,%esp
  803173:	68 64 4c 80 00       	push   $0x804c64
  803178:	68 4f 01 00 00       	push   $0x14f
  80317d:	68 f1 4b 80 00       	push   $0x804bf1
  803182:	e8 c4 d5 ff ff       	call   80074b <_panic>
  803187:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318a:	8b 10                	mov    (%eax),%edx
  80318c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80318f:	89 10                	mov    %edx,(%eax)
  803191:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803194:	8b 00                	mov    (%eax),%eax
  803196:	85 c0                	test   %eax,%eax
  803198:	74 0b                	je     8031a5 <alloc_block_BF+0x376>
  80319a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319d:	8b 00                	mov    (%eax),%eax
  80319f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031a2:	89 50 04             	mov    %edx,0x4(%eax)
  8031a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031ab:	89 10                	mov    %edx,(%eax)
  8031ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031b3:	89 50 04             	mov    %edx,0x4(%eax)
  8031b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031b9:	8b 00                	mov    (%eax),%eax
  8031bb:	85 c0                	test   %eax,%eax
  8031bd:	75 08                	jne    8031c7 <alloc_block_BF+0x398>
  8031bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031c2:	a3 38 50 80 00       	mov    %eax,0x805038
  8031c7:	a1 40 50 80 00       	mov    0x805040,%eax
  8031cc:	40                   	inc    %eax
  8031cd:	a3 40 50 80 00       	mov    %eax,0x805040
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8031d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031d6:	75 17                	jne    8031ef <alloc_block_BF+0x3c0>
  8031d8:	83 ec 04             	sub    $0x4,%esp
  8031db:	68 d3 4b 80 00       	push   $0x804bd3
  8031e0:	68 51 01 00 00       	push   $0x151
  8031e5:	68 f1 4b 80 00       	push   $0x804bf1
  8031ea:	e8 5c d5 ff ff       	call   80074b <_panic>
  8031ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f2:	8b 00                	mov    (%eax),%eax
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	74 10                	je     803208 <alloc_block_BF+0x3d9>
  8031f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fb:	8b 00                	mov    (%eax),%eax
  8031fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803200:	8b 52 04             	mov    0x4(%edx),%edx
  803203:	89 50 04             	mov    %edx,0x4(%eax)
  803206:	eb 0b                	jmp    803213 <alloc_block_BF+0x3e4>
  803208:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320b:	8b 40 04             	mov    0x4(%eax),%eax
  80320e:	a3 38 50 80 00       	mov    %eax,0x805038
  803213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803216:	8b 40 04             	mov    0x4(%eax),%eax
  803219:	85 c0                	test   %eax,%eax
  80321b:	74 0f                	je     80322c <alloc_block_BF+0x3fd>
  80321d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803220:	8b 40 04             	mov    0x4(%eax),%eax
  803223:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803226:	8b 12                	mov    (%edx),%edx
  803228:	89 10                	mov    %edx,(%eax)
  80322a:	eb 0a                	jmp    803236 <alloc_block_BF+0x407>
  80322c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322f:	8b 00                	mov    (%eax),%eax
  803231:	a3 34 50 80 00       	mov    %eax,0x805034
  803236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803242:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803249:	a1 40 50 80 00       	mov    0x805040,%eax
  80324e:	48                   	dec    %eax
  80324f:	a3 40 50 80 00       	mov    %eax,0x805040
			set_block_data(new_block_va, remaining_size, 0);
  803254:	83 ec 04             	sub    $0x4,%esp
  803257:	6a 00                	push   $0x0
  803259:	ff 75 d0             	pushl  -0x30(%ebp)
  80325c:	ff 75 cc             	pushl  -0x34(%ebp)
  80325f:	e8 e0 f6 ff ff       	call   802944 <set_block_data>
  803264:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326a:	e9 a3 01 00 00       	jmp    803412 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80326f:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803273:	0f 85 9d 00 00 00    	jne    803316 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803279:	83 ec 04             	sub    $0x4,%esp
  80327c:	6a 01                	push   $0x1
  80327e:	ff 75 ec             	pushl  -0x14(%ebp)
  803281:	ff 75 f0             	pushl  -0x10(%ebp)
  803284:	e8 bb f6 ff ff       	call   802944 <set_block_data>
  803289:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80328c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803290:	75 17                	jne    8032a9 <alloc_block_BF+0x47a>
  803292:	83 ec 04             	sub    $0x4,%esp
  803295:	68 d3 4b 80 00       	push   $0x804bd3
  80329a:	68 58 01 00 00       	push   $0x158
  80329f:	68 f1 4b 80 00       	push   $0x804bf1
  8032a4:	e8 a2 d4 ff ff       	call   80074b <_panic>
  8032a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ac:	8b 00                	mov    (%eax),%eax
  8032ae:	85 c0                	test   %eax,%eax
  8032b0:	74 10                	je     8032c2 <alloc_block_BF+0x493>
  8032b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b5:	8b 00                	mov    (%eax),%eax
  8032b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ba:	8b 52 04             	mov    0x4(%edx),%edx
  8032bd:	89 50 04             	mov    %edx,0x4(%eax)
  8032c0:	eb 0b                	jmp    8032cd <alloc_block_BF+0x49e>
  8032c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c5:	8b 40 04             	mov    0x4(%eax),%eax
  8032c8:	a3 38 50 80 00       	mov    %eax,0x805038
  8032cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d0:	8b 40 04             	mov    0x4(%eax),%eax
  8032d3:	85 c0                	test   %eax,%eax
  8032d5:	74 0f                	je     8032e6 <alloc_block_BF+0x4b7>
  8032d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032da:	8b 40 04             	mov    0x4(%eax),%eax
  8032dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032e0:	8b 12                	mov    (%edx),%edx
  8032e2:	89 10                	mov    %edx,(%eax)
  8032e4:	eb 0a                	jmp    8032f0 <alloc_block_BF+0x4c1>
  8032e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e9:	8b 00                	mov    (%eax),%eax
  8032eb:	a3 34 50 80 00       	mov    %eax,0x805034
  8032f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803303:	a1 40 50 80 00       	mov    0x805040,%eax
  803308:	48                   	dec    %eax
  803309:	a3 40 50 80 00       	mov    %eax,0x805040
		return best_va;
  80330e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803311:	e9 fc 00 00 00       	jmp    803412 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	83 c0 08             	add    $0x8,%eax
  80331c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80331f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803326:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803329:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80332c:	01 d0                	add    %edx,%eax
  80332e:	48                   	dec    %eax
  80332f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803332:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803335:	ba 00 00 00 00       	mov    $0x0,%edx
  80333a:	f7 75 c4             	divl   -0x3c(%ebp)
  80333d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803340:	29 d0                	sub    %edx,%eax
  803342:	c1 e8 0c             	shr    $0xc,%eax
  803345:	83 ec 0c             	sub    $0xc,%esp
  803348:	50                   	push   %eax
  803349:	e8 5c e6 ff ff       	call   8019aa <sbrk>
  80334e:	83 c4 10             	add    $0x10,%esp
  803351:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803354:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803358:	75 0a                	jne    803364 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80335a:	b8 00 00 00 00       	mov    $0x0,%eax
  80335f:	e9 ae 00 00 00       	jmp    803412 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803364:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80336b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80336e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803371:	01 d0                	add    %edx,%eax
  803373:	48                   	dec    %eax
  803374:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803377:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80337a:	ba 00 00 00 00       	mov    $0x0,%edx
  80337f:	f7 75 b8             	divl   -0x48(%ebp)
  803382:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803385:	29 d0                	sub    %edx,%eax
  803387:	8d 50 fc             	lea    -0x4(%eax),%edx
  80338a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80338d:	01 d0                	add    %edx,%eax
  80338f:	a3 48 50 80 00       	mov    %eax,0x805048
				end_block->info = 1;
  803394:	a1 48 50 80 00       	mov    0x805048,%eax
  803399:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80339f:	83 ec 0c             	sub    $0xc,%esp
  8033a2:	68 98 4c 80 00       	push   $0x804c98
  8033a7:	e8 5c d6 ff ff       	call   800a08 <cprintf>
  8033ac:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8033af:	83 ec 08             	sub    $0x8,%esp
  8033b2:	ff 75 bc             	pushl  -0x44(%ebp)
  8033b5:	68 9d 4c 80 00       	push   $0x804c9d
  8033ba:	e8 49 d6 ff ff       	call   800a08 <cprintf>
  8033bf:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8033c2:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8033c9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033cc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033cf:	01 d0                	add    %edx,%eax
  8033d1:	48                   	dec    %eax
  8033d2:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8033d5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8033dd:	f7 75 b0             	divl   -0x50(%ebp)
  8033e0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033e3:	29 d0                	sub    %edx,%eax
  8033e5:	83 ec 04             	sub    $0x4,%esp
  8033e8:	6a 01                	push   $0x1
  8033ea:	50                   	push   %eax
  8033eb:	ff 75 bc             	pushl  -0x44(%ebp)
  8033ee:	e8 51 f5 ff ff       	call   802944 <set_block_data>
  8033f3:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8033f6:	83 ec 0c             	sub    $0xc,%esp
  8033f9:	ff 75 bc             	pushl  -0x44(%ebp)
  8033fc:	e8 36 04 00 00       	call   803837 <free_block>
  803401:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803404:	83 ec 0c             	sub    $0xc,%esp
  803407:	ff 75 08             	pushl  0x8(%ebp)
  80340a:	e8 20 fa ff ff       	call   802e2f <alloc_block_BF>
  80340f:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803412:	c9                   	leave  
  803413:	c3                   	ret    

00803414 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803414:	55                   	push   %ebp
  803415:	89 e5                	mov    %esp,%ebp
  803417:	53                   	push   %ebx
  803418:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80341b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803422:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803429:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80342d:	74 1e                	je     80344d <merging+0x39>
  80342f:	ff 75 08             	pushl  0x8(%ebp)
  803432:	e8 bc f1 ff ff       	call   8025f3 <get_block_size>
  803437:	83 c4 04             	add    $0x4,%esp
  80343a:	89 c2                	mov    %eax,%edx
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	01 d0                	add    %edx,%eax
  803441:	3b 45 10             	cmp    0x10(%ebp),%eax
  803444:	75 07                	jne    80344d <merging+0x39>
		prev_is_free = 1;
  803446:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80344d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803451:	74 1e                	je     803471 <merging+0x5d>
  803453:	ff 75 10             	pushl  0x10(%ebp)
  803456:	e8 98 f1 ff ff       	call   8025f3 <get_block_size>
  80345b:	83 c4 04             	add    $0x4,%esp
  80345e:	89 c2                	mov    %eax,%edx
  803460:	8b 45 10             	mov    0x10(%ebp),%eax
  803463:	01 d0                	add    %edx,%eax
  803465:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803468:	75 07                	jne    803471 <merging+0x5d>
		next_is_free = 1;
  80346a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803471:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803475:	0f 84 cc 00 00 00    	je     803547 <merging+0x133>
  80347b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80347f:	0f 84 c2 00 00 00    	je     803547 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803485:	ff 75 08             	pushl  0x8(%ebp)
  803488:	e8 66 f1 ff ff       	call   8025f3 <get_block_size>
  80348d:	83 c4 04             	add    $0x4,%esp
  803490:	89 c3                	mov    %eax,%ebx
  803492:	ff 75 10             	pushl  0x10(%ebp)
  803495:	e8 59 f1 ff ff       	call   8025f3 <get_block_size>
  80349a:	83 c4 04             	add    $0x4,%esp
  80349d:	01 c3                	add    %eax,%ebx
  80349f:	ff 75 0c             	pushl  0xc(%ebp)
  8034a2:	e8 4c f1 ff ff       	call   8025f3 <get_block_size>
  8034a7:	83 c4 04             	add    $0x4,%esp
  8034aa:	01 d8                	add    %ebx,%eax
  8034ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8034af:	6a 00                	push   $0x0
  8034b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8034b4:	ff 75 08             	pushl  0x8(%ebp)
  8034b7:	e8 88 f4 ff ff       	call   802944 <set_block_data>
  8034bc:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8034bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034c3:	75 17                	jne    8034dc <merging+0xc8>
  8034c5:	83 ec 04             	sub    $0x4,%esp
  8034c8:	68 d3 4b 80 00       	push   $0x804bd3
  8034cd:	68 7d 01 00 00       	push   $0x17d
  8034d2:	68 f1 4b 80 00       	push   $0x804bf1
  8034d7:	e8 6f d2 ff ff       	call   80074b <_panic>
  8034dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034df:	8b 00                	mov    (%eax),%eax
  8034e1:	85 c0                	test   %eax,%eax
  8034e3:	74 10                	je     8034f5 <merging+0xe1>
  8034e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e8:	8b 00                	mov    (%eax),%eax
  8034ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034ed:	8b 52 04             	mov    0x4(%edx),%edx
  8034f0:	89 50 04             	mov    %edx,0x4(%eax)
  8034f3:	eb 0b                	jmp    803500 <merging+0xec>
  8034f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f8:	8b 40 04             	mov    0x4(%eax),%eax
  8034fb:	a3 38 50 80 00       	mov    %eax,0x805038
  803500:	8b 45 0c             	mov    0xc(%ebp),%eax
  803503:	8b 40 04             	mov    0x4(%eax),%eax
  803506:	85 c0                	test   %eax,%eax
  803508:	74 0f                	je     803519 <merging+0x105>
  80350a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80350d:	8b 40 04             	mov    0x4(%eax),%eax
  803510:	8b 55 0c             	mov    0xc(%ebp),%edx
  803513:	8b 12                	mov    (%edx),%edx
  803515:	89 10                	mov    %edx,(%eax)
  803517:	eb 0a                	jmp    803523 <merging+0x10f>
  803519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351c:	8b 00                	mov    (%eax),%eax
  80351e:	a3 34 50 80 00       	mov    %eax,0x805034
  803523:	8b 45 0c             	mov    0xc(%ebp),%eax
  803526:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80352c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803536:	a1 40 50 80 00       	mov    0x805040,%eax
  80353b:	48                   	dec    %eax
  80353c:	a3 40 50 80 00       	mov    %eax,0x805040
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803541:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803542:	e9 ea 02 00 00       	jmp    803831 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803547:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80354b:	74 3b                	je     803588 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80354d:	83 ec 0c             	sub    $0xc,%esp
  803550:	ff 75 08             	pushl  0x8(%ebp)
  803553:	e8 9b f0 ff ff       	call   8025f3 <get_block_size>
  803558:	83 c4 10             	add    $0x10,%esp
  80355b:	89 c3                	mov    %eax,%ebx
  80355d:	83 ec 0c             	sub    $0xc,%esp
  803560:	ff 75 10             	pushl  0x10(%ebp)
  803563:	e8 8b f0 ff ff       	call   8025f3 <get_block_size>
  803568:	83 c4 10             	add    $0x10,%esp
  80356b:	01 d8                	add    %ebx,%eax
  80356d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803570:	83 ec 04             	sub    $0x4,%esp
  803573:	6a 00                	push   $0x0
  803575:	ff 75 e8             	pushl  -0x18(%ebp)
  803578:	ff 75 08             	pushl  0x8(%ebp)
  80357b:	e8 c4 f3 ff ff       	call   802944 <set_block_data>
  803580:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803583:	e9 a9 02 00 00       	jmp    803831 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803588:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80358c:	0f 84 2d 01 00 00    	je     8036bf <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803592:	83 ec 0c             	sub    $0xc,%esp
  803595:	ff 75 10             	pushl  0x10(%ebp)
  803598:	e8 56 f0 ff ff       	call   8025f3 <get_block_size>
  80359d:	83 c4 10             	add    $0x10,%esp
  8035a0:	89 c3                	mov    %eax,%ebx
  8035a2:	83 ec 0c             	sub    $0xc,%esp
  8035a5:	ff 75 0c             	pushl  0xc(%ebp)
  8035a8:	e8 46 f0 ff ff       	call   8025f3 <get_block_size>
  8035ad:	83 c4 10             	add    $0x10,%esp
  8035b0:	01 d8                	add    %ebx,%eax
  8035b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8035b5:	83 ec 04             	sub    $0x4,%esp
  8035b8:	6a 00                	push   $0x0
  8035ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035bd:	ff 75 10             	pushl  0x10(%ebp)
  8035c0:	e8 7f f3 ff ff       	call   802944 <set_block_data>
  8035c5:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8035c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8035cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8035ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035d2:	74 06                	je     8035da <merging+0x1c6>
  8035d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8035d8:	75 17                	jne    8035f1 <merging+0x1dd>
  8035da:	83 ec 04             	sub    $0x4,%esp
  8035dd:	68 ac 4c 80 00       	push   $0x804cac
  8035e2:	68 8d 01 00 00       	push   $0x18d
  8035e7:	68 f1 4b 80 00       	push   $0x804bf1
  8035ec:	e8 5a d1 ff ff       	call   80074b <_panic>
  8035f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f4:	8b 50 04             	mov    0x4(%eax),%edx
  8035f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035fa:	89 50 04             	mov    %edx,0x4(%eax)
  8035fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803600:	8b 55 0c             	mov    0xc(%ebp),%edx
  803603:	89 10                	mov    %edx,(%eax)
  803605:	8b 45 0c             	mov    0xc(%ebp),%eax
  803608:	8b 40 04             	mov    0x4(%eax),%eax
  80360b:	85 c0                	test   %eax,%eax
  80360d:	74 0d                	je     80361c <merging+0x208>
  80360f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803612:	8b 40 04             	mov    0x4(%eax),%eax
  803615:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803618:	89 10                	mov    %edx,(%eax)
  80361a:	eb 08                	jmp    803624 <merging+0x210>
  80361c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80361f:	a3 34 50 80 00       	mov    %eax,0x805034
  803624:	8b 45 0c             	mov    0xc(%ebp),%eax
  803627:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80362a:	89 50 04             	mov    %edx,0x4(%eax)
  80362d:	a1 40 50 80 00       	mov    0x805040,%eax
  803632:	40                   	inc    %eax
  803633:	a3 40 50 80 00       	mov    %eax,0x805040
		LIST_REMOVE(&freeBlocksList, next_block);
  803638:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80363c:	75 17                	jne    803655 <merging+0x241>
  80363e:	83 ec 04             	sub    $0x4,%esp
  803641:	68 d3 4b 80 00       	push   $0x804bd3
  803646:	68 8e 01 00 00       	push   $0x18e
  80364b:	68 f1 4b 80 00       	push   $0x804bf1
  803650:	e8 f6 d0 ff ff       	call   80074b <_panic>
  803655:	8b 45 0c             	mov    0xc(%ebp),%eax
  803658:	8b 00                	mov    (%eax),%eax
  80365a:	85 c0                	test   %eax,%eax
  80365c:	74 10                	je     80366e <merging+0x25a>
  80365e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803661:	8b 00                	mov    (%eax),%eax
  803663:	8b 55 0c             	mov    0xc(%ebp),%edx
  803666:	8b 52 04             	mov    0x4(%edx),%edx
  803669:	89 50 04             	mov    %edx,0x4(%eax)
  80366c:	eb 0b                	jmp    803679 <merging+0x265>
  80366e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803671:	8b 40 04             	mov    0x4(%eax),%eax
  803674:	a3 38 50 80 00       	mov    %eax,0x805038
  803679:	8b 45 0c             	mov    0xc(%ebp),%eax
  80367c:	8b 40 04             	mov    0x4(%eax),%eax
  80367f:	85 c0                	test   %eax,%eax
  803681:	74 0f                	je     803692 <merging+0x27e>
  803683:	8b 45 0c             	mov    0xc(%ebp),%eax
  803686:	8b 40 04             	mov    0x4(%eax),%eax
  803689:	8b 55 0c             	mov    0xc(%ebp),%edx
  80368c:	8b 12                	mov    (%edx),%edx
  80368e:	89 10                	mov    %edx,(%eax)
  803690:	eb 0a                	jmp    80369c <merging+0x288>
  803692:	8b 45 0c             	mov    0xc(%ebp),%eax
  803695:	8b 00                	mov    (%eax),%eax
  803697:	a3 34 50 80 00       	mov    %eax,0x805034
  80369c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80369f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036af:	a1 40 50 80 00       	mov    0x805040,%eax
  8036b4:	48                   	dec    %eax
  8036b5:	a3 40 50 80 00       	mov    %eax,0x805040
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8036ba:	e9 72 01 00 00       	jmp    803831 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8036bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8036c2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8036c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036c9:	74 79                	je     803744 <merging+0x330>
  8036cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036cf:	74 73                	je     803744 <merging+0x330>
  8036d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036d5:	74 06                	je     8036dd <merging+0x2c9>
  8036d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036db:	75 17                	jne    8036f4 <merging+0x2e0>
  8036dd:	83 ec 04             	sub    $0x4,%esp
  8036e0:	68 64 4c 80 00       	push   $0x804c64
  8036e5:	68 94 01 00 00       	push   $0x194
  8036ea:	68 f1 4b 80 00       	push   $0x804bf1
  8036ef:	e8 57 d0 ff ff       	call   80074b <_panic>
  8036f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f7:	8b 10                	mov    (%eax),%edx
  8036f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036fc:	89 10                	mov    %edx,(%eax)
  8036fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803701:	8b 00                	mov    (%eax),%eax
  803703:	85 c0                	test   %eax,%eax
  803705:	74 0b                	je     803712 <merging+0x2fe>
  803707:	8b 45 08             	mov    0x8(%ebp),%eax
  80370a:	8b 00                	mov    (%eax),%eax
  80370c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80370f:	89 50 04             	mov    %edx,0x4(%eax)
  803712:	8b 45 08             	mov    0x8(%ebp),%eax
  803715:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803718:	89 10                	mov    %edx,(%eax)
  80371a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80371d:	8b 55 08             	mov    0x8(%ebp),%edx
  803720:	89 50 04             	mov    %edx,0x4(%eax)
  803723:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803726:	8b 00                	mov    (%eax),%eax
  803728:	85 c0                	test   %eax,%eax
  80372a:	75 08                	jne    803734 <merging+0x320>
  80372c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80372f:	a3 38 50 80 00       	mov    %eax,0x805038
  803734:	a1 40 50 80 00       	mov    0x805040,%eax
  803739:	40                   	inc    %eax
  80373a:	a3 40 50 80 00       	mov    %eax,0x805040
  80373f:	e9 ce 00 00 00       	jmp    803812 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803744:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803748:	74 65                	je     8037af <merging+0x39b>
  80374a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80374e:	75 17                	jne    803767 <merging+0x353>
  803750:	83 ec 04             	sub    $0x4,%esp
  803753:	68 40 4c 80 00       	push   $0x804c40
  803758:	68 95 01 00 00       	push   $0x195
  80375d:	68 f1 4b 80 00       	push   $0x804bf1
  803762:	e8 e4 cf ff ff       	call   80074b <_panic>
  803767:	8b 15 38 50 80 00    	mov    0x805038,%edx
  80376d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803770:	89 50 04             	mov    %edx,0x4(%eax)
  803773:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803776:	8b 40 04             	mov    0x4(%eax),%eax
  803779:	85 c0                	test   %eax,%eax
  80377b:	74 0c                	je     803789 <merging+0x375>
  80377d:	a1 38 50 80 00       	mov    0x805038,%eax
  803782:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803785:	89 10                	mov    %edx,(%eax)
  803787:	eb 08                	jmp    803791 <merging+0x37d>
  803789:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80378c:	a3 34 50 80 00       	mov    %eax,0x805034
  803791:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803794:	a3 38 50 80 00       	mov    %eax,0x805038
  803799:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80379c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037a2:	a1 40 50 80 00       	mov    0x805040,%eax
  8037a7:	40                   	inc    %eax
  8037a8:	a3 40 50 80 00       	mov    %eax,0x805040
  8037ad:	eb 63                	jmp    803812 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8037af:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037b3:	75 17                	jne    8037cc <merging+0x3b8>
  8037b5:	83 ec 04             	sub    $0x4,%esp
  8037b8:	68 0c 4c 80 00       	push   $0x804c0c
  8037bd:	68 98 01 00 00       	push   $0x198
  8037c2:	68 f1 4b 80 00       	push   $0x804bf1
  8037c7:	e8 7f cf ff ff       	call   80074b <_panic>
  8037cc:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8037d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d5:	89 10                	mov    %edx,(%eax)
  8037d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037da:	8b 00                	mov    (%eax),%eax
  8037dc:	85 c0                	test   %eax,%eax
  8037de:	74 0d                	je     8037ed <merging+0x3d9>
  8037e0:	a1 34 50 80 00       	mov    0x805034,%eax
  8037e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037e8:	89 50 04             	mov    %edx,0x4(%eax)
  8037eb:	eb 08                	jmp    8037f5 <merging+0x3e1>
  8037ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f0:	a3 38 50 80 00       	mov    %eax,0x805038
  8037f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f8:	a3 34 50 80 00       	mov    %eax,0x805034
  8037fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803800:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803807:	a1 40 50 80 00       	mov    0x805040,%eax
  80380c:	40                   	inc    %eax
  80380d:	a3 40 50 80 00       	mov    %eax,0x805040
		}
		set_block_data(va, get_block_size(va), 0);
  803812:	83 ec 0c             	sub    $0xc,%esp
  803815:	ff 75 10             	pushl  0x10(%ebp)
  803818:	e8 d6 ed ff ff       	call   8025f3 <get_block_size>
  80381d:	83 c4 10             	add    $0x10,%esp
  803820:	83 ec 04             	sub    $0x4,%esp
  803823:	6a 00                	push   $0x0
  803825:	50                   	push   %eax
  803826:	ff 75 10             	pushl  0x10(%ebp)
  803829:	e8 16 f1 ff ff       	call   802944 <set_block_data>
  80382e:	83 c4 10             	add    $0x10,%esp
	}
}
  803831:	90                   	nop
  803832:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803835:	c9                   	leave  
  803836:	c3                   	ret    

00803837 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803837:	55                   	push   %ebp
  803838:	89 e5                	mov    %esp,%ebp
  80383a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80383d:	a1 34 50 80 00       	mov    0x805034,%eax
  803842:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803845:	a1 38 50 80 00       	mov    0x805038,%eax
  80384a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80384d:	73 1b                	jae    80386a <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80384f:	a1 38 50 80 00       	mov    0x805038,%eax
  803854:	83 ec 04             	sub    $0x4,%esp
  803857:	ff 75 08             	pushl  0x8(%ebp)
  80385a:	6a 00                	push   $0x0
  80385c:	50                   	push   %eax
  80385d:	e8 b2 fb ff ff       	call   803414 <merging>
  803862:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803865:	e9 8b 00 00 00       	jmp    8038f5 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80386a:	a1 34 50 80 00       	mov    0x805034,%eax
  80386f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803872:	76 18                	jbe    80388c <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803874:	a1 34 50 80 00       	mov    0x805034,%eax
  803879:	83 ec 04             	sub    $0x4,%esp
  80387c:	ff 75 08             	pushl  0x8(%ebp)
  80387f:	50                   	push   %eax
  803880:	6a 00                	push   $0x0
  803882:	e8 8d fb ff ff       	call   803414 <merging>
  803887:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80388a:	eb 69                	jmp    8038f5 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80388c:	a1 34 50 80 00       	mov    0x805034,%eax
  803891:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803894:	eb 39                	jmp    8038cf <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803899:	3b 45 08             	cmp    0x8(%ebp),%eax
  80389c:	73 29                	jae    8038c7 <free_block+0x90>
  80389e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a1:	8b 00                	mov    (%eax),%eax
  8038a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038a6:	76 1f                	jbe    8038c7 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8038a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ab:	8b 00                	mov    (%eax),%eax
  8038ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8038b0:	83 ec 04             	sub    $0x4,%esp
  8038b3:	ff 75 08             	pushl  0x8(%ebp)
  8038b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8038b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8038bc:	e8 53 fb ff ff       	call   803414 <merging>
  8038c1:	83 c4 10             	add    $0x10,%esp
			break;
  8038c4:	90                   	nop
		}
	}
}
  8038c5:	eb 2e                	jmp    8038f5 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8038c7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8038cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038d3:	74 07                	je     8038dc <free_block+0xa5>
  8038d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d8:	8b 00                	mov    (%eax),%eax
  8038da:	eb 05                	jmp    8038e1 <free_block+0xaa>
  8038dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e1:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8038e6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8038eb:	85 c0                	test   %eax,%eax
  8038ed:	75 a7                	jne    803896 <free_block+0x5f>
  8038ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f3:	75 a1                	jne    803896 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038f5:	90                   	nop
  8038f6:	c9                   	leave  
  8038f7:	c3                   	ret    

008038f8 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8038f8:	55                   	push   %ebp
  8038f9:	89 e5                	mov    %esp,%ebp
  8038fb:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8038fe:	ff 75 08             	pushl  0x8(%ebp)
  803901:	e8 ed ec ff ff       	call   8025f3 <get_block_size>
  803906:	83 c4 04             	add    $0x4,%esp
  803909:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80390c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803913:	eb 17                	jmp    80392c <copy_data+0x34>
  803915:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80391b:	01 c2                	add    %eax,%edx
  80391d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803920:	8b 45 08             	mov    0x8(%ebp),%eax
  803923:	01 c8                	add    %ecx,%eax
  803925:	8a 00                	mov    (%eax),%al
  803927:	88 02                	mov    %al,(%edx)
  803929:	ff 45 fc             	incl   -0x4(%ebp)
  80392c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80392f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803932:	72 e1                	jb     803915 <copy_data+0x1d>
}
  803934:	90                   	nop
  803935:	c9                   	leave  
  803936:	c3                   	ret    

00803937 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803937:	55                   	push   %ebp
  803938:	89 e5                	mov    %esp,%ebp
  80393a:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80393d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803941:	75 23                	jne    803966 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803943:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803947:	74 13                	je     80395c <realloc_block_FF+0x25>
  803949:	83 ec 0c             	sub    $0xc,%esp
  80394c:	ff 75 0c             	pushl  0xc(%ebp)
  80394f:	e8 1f f0 ff ff       	call   802973 <alloc_block_FF>
  803954:	83 c4 10             	add    $0x10,%esp
  803957:	e9 f4 06 00 00       	jmp    804050 <realloc_block_FF+0x719>
		return NULL;
  80395c:	b8 00 00 00 00       	mov    $0x0,%eax
  803961:	e9 ea 06 00 00       	jmp    804050 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803966:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80396a:	75 18                	jne    803984 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80396c:	83 ec 0c             	sub    $0xc,%esp
  80396f:	ff 75 08             	pushl  0x8(%ebp)
  803972:	e8 c0 fe ff ff       	call   803837 <free_block>
  803977:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80397a:	b8 00 00 00 00       	mov    $0x0,%eax
  80397f:	e9 cc 06 00 00       	jmp    804050 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803984:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803988:	77 07                	ja     803991 <realloc_block_FF+0x5a>
  80398a:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803991:	8b 45 0c             	mov    0xc(%ebp),%eax
  803994:	83 e0 01             	and    $0x1,%eax
  803997:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80399a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80399d:	83 c0 08             	add    $0x8,%eax
  8039a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8039a3:	83 ec 0c             	sub    $0xc,%esp
  8039a6:	ff 75 08             	pushl  0x8(%ebp)
  8039a9:	e8 45 ec ff ff       	call   8025f3 <get_block_size>
  8039ae:	83 c4 10             	add    $0x10,%esp
  8039b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8039b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039b7:	83 e8 08             	sub    $0x8,%eax
  8039ba:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8039bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c0:	83 e8 04             	sub    $0x4,%eax
  8039c3:	8b 00                	mov    (%eax),%eax
  8039c5:	83 e0 fe             	and    $0xfffffffe,%eax
  8039c8:	89 c2                	mov    %eax,%edx
  8039ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cd:	01 d0                	add    %edx,%eax
  8039cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8039d2:	83 ec 0c             	sub    $0xc,%esp
  8039d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039d8:	e8 16 ec ff ff       	call   8025f3 <get_block_size>
  8039dd:	83 c4 10             	add    $0x10,%esp
  8039e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8039e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039e6:	83 e8 08             	sub    $0x8,%eax
  8039e9:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8039ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039ef:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039f2:	75 08                	jne    8039fc <realloc_block_FF+0xc5>
	{
		 return va;
  8039f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f7:	e9 54 06 00 00       	jmp    804050 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8039fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039ff:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a02:	0f 83 e5 03 00 00    	jae    803ded <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0b:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803a11:	83 ec 0c             	sub    $0xc,%esp
  803a14:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a17:	e8 f0 eb ff ff       	call   80260c <is_free_block>
  803a1c:	83 c4 10             	add    $0x10,%esp
  803a1f:	84 c0                	test   %al,%al
  803a21:	0f 84 3b 01 00 00    	je     803b62 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803a27:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a2a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a2d:	01 d0                	add    %edx,%eax
  803a2f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803a32:	83 ec 04             	sub    $0x4,%esp
  803a35:	6a 01                	push   $0x1
  803a37:	ff 75 f0             	pushl  -0x10(%ebp)
  803a3a:	ff 75 08             	pushl  0x8(%ebp)
  803a3d:	e8 02 ef ff ff       	call   802944 <set_block_data>
  803a42:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803a45:	8b 45 08             	mov    0x8(%ebp),%eax
  803a48:	83 e8 04             	sub    $0x4,%eax
  803a4b:	8b 00                	mov    (%eax),%eax
  803a4d:	83 e0 fe             	and    $0xfffffffe,%eax
  803a50:	89 c2                	mov    %eax,%edx
  803a52:	8b 45 08             	mov    0x8(%ebp),%eax
  803a55:	01 d0                	add    %edx,%eax
  803a57:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803a5a:	83 ec 04             	sub    $0x4,%esp
  803a5d:	6a 00                	push   $0x0
  803a5f:	ff 75 cc             	pushl  -0x34(%ebp)
  803a62:	ff 75 c8             	pushl  -0x38(%ebp)
  803a65:	e8 da ee ff ff       	call   802944 <set_block_data>
  803a6a:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a71:	74 06                	je     803a79 <realloc_block_FF+0x142>
  803a73:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803a77:	75 17                	jne    803a90 <realloc_block_FF+0x159>
  803a79:	83 ec 04             	sub    $0x4,%esp
  803a7c:	68 64 4c 80 00       	push   $0x804c64
  803a81:	68 f6 01 00 00       	push   $0x1f6
  803a86:	68 f1 4b 80 00       	push   $0x804bf1
  803a8b:	e8 bb cc ff ff       	call   80074b <_panic>
  803a90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a93:	8b 10                	mov    (%eax),%edx
  803a95:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a98:	89 10                	mov    %edx,(%eax)
  803a9a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a9d:	8b 00                	mov    (%eax),%eax
  803a9f:	85 c0                	test   %eax,%eax
  803aa1:	74 0b                	je     803aae <realloc_block_FF+0x177>
  803aa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa6:	8b 00                	mov    (%eax),%eax
  803aa8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803aab:	89 50 04             	mov    %edx,0x4(%eax)
  803aae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ab4:	89 10                	mov    %edx,(%eax)
  803ab6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ab9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803abc:	89 50 04             	mov    %edx,0x4(%eax)
  803abf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ac2:	8b 00                	mov    (%eax),%eax
  803ac4:	85 c0                	test   %eax,%eax
  803ac6:	75 08                	jne    803ad0 <realloc_block_FF+0x199>
  803ac8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803acb:	a3 38 50 80 00       	mov    %eax,0x805038
  803ad0:	a1 40 50 80 00       	mov    0x805040,%eax
  803ad5:	40                   	inc    %eax
  803ad6:	a3 40 50 80 00       	mov    %eax,0x805040
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803adb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803adf:	75 17                	jne    803af8 <realloc_block_FF+0x1c1>
  803ae1:	83 ec 04             	sub    $0x4,%esp
  803ae4:	68 d3 4b 80 00       	push   $0x804bd3
  803ae9:	68 f7 01 00 00       	push   $0x1f7
  803aee:	68 f1 4b 80 00       	push   $0x804bf1
  803af3:	e8 53 cc ff ff       	call   80074b <_panic>
  803af8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803afb:	8b 00                	mov    (%eax),%eax
  803afd:	85 c0                	test   %eax,%eax
  803aff:	74 10                	je     803b11 <realloc_block_FF+0x1da>
  803b01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b04:	8b 00                	mov    (%eax),%eax
  803b06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b09:	8b 52 04             	mov    0x4(%edx),%edx
  803b0c:	89 50 04             	mov    %edx,0x4(%eax)
  803b0f:	eb 0b                	jmp    803b1c <realloc_block_FF+0x1e5>
  803b11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b14:	8b 40 04             	mov    0x4(%eax),%eax
  803b17:	a3 38 50 80 00       	mov    %eax,0x805038
  803b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1f:	8b 40 04             	mov    0x4(%eax),%eax
  803b22:	85 c0                	test   %eax,%eax
  803b24:	74 0f                	je     803b35 <realloc_block_FF+0x1fe>
  803b26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b29:	8b 40 04             	mov    0x4(%eax),%eax
  803b2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b2f:	8b 12                	mov    (%edx),%edx
  803b31:	89 10                	mov    %edx,(%eax)
  803b33:	eb 0a                	jmp    803b3f <realloc_block_FF+0x208>
  803b35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b38:	8b 00                	mov    (%eax),%eax
  803b3a:	a3 34 50 80 00       	mov    %eax,0x805034
  803b3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b52:	a1 40 50 80 00       	mov    0x805040,%eax
  803b57:	48                   	dec    %eax
  803b58:	a3 40 50 80 00       	mov    %eax,0x805040
  803b5d:	e9 83 02 00 00       	jmp    803de5 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803b62:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803b66:	0f 86 69 02 00 00    	jbe    803dd5 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803b6c:	83 ec 04             	sub    $0x4,%esp
  803b6f:	6a 01                	push   $0x1
  803b71:	ff 75 f0             	pushl  -0x10(%ebp)
  803b74:	ff 75 08             	pushl  0x8(%ebp)
  803b77:	e8 c8 ed ff ff       	call   802944 <set_block_data>
  803b7c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b82:	83 e8 04             	sub    $0x4,%eax
  803b85:	8b 00                	mov    (%eax),%eax
  803b87:	83 e0 fe             	and    $0xfffffffe,%eax
  803b8a:	89 c2                	mov    %eax,%edx
  803b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8f:	01 d0                	add    %edx,%eax
  803b91:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803b94:	a1 40 50 80 00       	mov    0x805040,%eax
  803b99:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803b9c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ba0:	75 68                	jne    803c0a <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ba2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ba6:	75 17                	jne    803bbf <realloc_block_FF+0x288>
  803ba8:	83 ec 04             	sub    $0x4,%esp
  803bab:	68 0c 4c 80 00       	push   $0x804c0c
  803bb0:	68 06 02 00 00       	push   $0x206
  803bb5:	68 f1 4b 80 00       	push   $0x804bf1
  803bba:	e8 8c cb ff ff       	call   80074b <_panic>
  803bbf:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803bc5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc8:	89 10                	mov    %edx,(%eax)
  803bca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bcd:	8b 00                	mov    (%eax),%eax
  803bcf:	85 c0                	test   %eax,%eax
  803bd1:	74 0d                	je     803be0 <realloc_block_FF+0x2a9>
  803bd3:	a1 34 50 80 00       	mov    0x805034,%eax
  803bd8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bdb:	89 50 04             	mov    %edx,0x4(%eax)
  803bde:	eb 08                	jmp    803be8 <realloc_block_FF+0x2b1>
  803be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be3:	a3 38 50 80 00       	mov    %eax,0x805038
  803be8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803beb:	a3 34 50 80 00       	mov    %eax,0x805034
  803bf0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bf3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bfa:	a1 40 50 80 00       	mov    0x805040,%eax
  803bff:	40                   	inc    %eax
  803c00:	a3 40 50 80 00       	mov    %eax,0x805040
  803c05:	e9 b0 01 00 00       	jmp    803dba <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803c0a:	a1 34 50 80 00       	mov    0x805034,%eax
  803c0f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c12:	76 68                	jbe    803c7c <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c14:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c18:	75 17                	jne    803c31 <realloc_block_FF+0x2fa>
  803c1a:	83 ec 04             	sub    $0x4,%esp
  803c1d:	68 0c 4c 80 00       	push   $0x804c0c
  803c22:	68 0b 02 00 00       	push   $0x20b
  803c27:	68 f1 4b 80 00       	push   $0x804bf1
  803c2c:	e8 1a cb ff ff       	call   80074b <_panic>
  803c31:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803c37:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c3a:	89 10                	mov    %edx,(%eax)
  803c3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c3f:	8b 00                	mov    (%eax),%eax
  803c41:	85 c0                	test   %eax,%eax
  803c43:	74 0d                	je     803c52 <realloc_block_FF+0x31b>
  803c45:	a1 34 50 80 00       	mov    0x805034,%eax
  803c4a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c4d:	89 50 04             	mov    %edx,0x4(%eax)
  803c50:	eb 08                	jmp    803c5a <realloc_block_FF+0x323>
  803c52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c55:	a3 38 50 80 00       	mov    %eax,0x805038
  803c5a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c5d:	a3 34 50 80 00       	mov    %eax,0x805034
  803c62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c6c:	a1 40 50 80 00       	mov    0x805040,%eax
  803c71:	40                   	inc    %eax
  803c72:	a3 40 50 80 00       	mov    %eax,0x805040
  803c77:	e9 3e 01 00 00       	jmp    803dba <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803c7c:	a1 34 50 80 00       	mov    0x805034,%eax
  803c81:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c84:	73 68                	jae    803cee <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c86:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c8a:	75 17                	jne    803ca3 <realloc_block_FF+0x36c>
  803c8c:	83 ec 04             	sub    $0x4,%esp
  803c8f:	68 40 4c 80 00       	push   $0x804c40
  803c94:	68 10 02 00 00       	push   $0x210
  803c99:	68 f1 4b 80 00       	push   $0x804bf1
  803c9e:	e8 a8 ca ff ff       	call   80074b <_panic>
  803ca3:	8b 15 38 50 80 00    	mov    0x805038,%edx
  803ca9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cac:	89 50 04             	mov    %edx,0x4(%eax)
  803caf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cb2:	8b 40 04             	mov    0x4(%eax),%eax
  803cb5:	85 c0                	test   %eax,%eax
  803cb7:	74 0c                	je     803cc5 <realloc_block_FF+0x38e>
  803cb9:	a1 38 50 80 00       	mov    0x805038,%eax
  803cbe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cc1:	89 10                	mov    %edx,(%eax)
  803cc3:	eb 08                	jmp    803ccd <realloc_block_FF+0x396>
  803cc5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc8:	a3 34 50 80 00       	mov    %eax,0x805034
  803ccd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cd0:	a3 38 50 80 00       	mov    %eax,0x805038
  803cd5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cde:	a1 40 50 80 00       	mov    0x805040,%eax
  803ce3:	40                   	inc    %eax
  803ce4:	a3 40 50 80 00       	mov    %eax,0x805040
  803ce9:	e9 cc 00 00 00       	jmp    803dba <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803cee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803cf5:	a1 34 50 80 00       	mov    0x805034,%eax
  803cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cfd:	e9 8a 00 00 00       	jmp    803d8c <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d05:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d08:	73 7a                	jae    803d84 <realloc_block_FF+0x44d>
  803d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0d:	8b 00                	mov    (%eax),%eax
  803d0f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d12:	73 70                	jae    803d84 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803d14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d18:	74 06                	je     803d20 <realloc_block_FF+0x3e9>
  803d1a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d1e:	75 17                	jne    803d37 <realloc_block_FF+0x400>
  803d20:	83 ec 04             	sub    $0x4,%esp
  803d23:	68 64 4c 80 00       	push   $0x804c64
  803d28:	68 1a 02 00 00       	push   $0x21a
  803d2d:	68 f1 4b 80 00       	push   $0x804bf1
  803d32:	e8 14 ca ff ff       	call   80074b <_panic>
  803d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3a:	8b 10                	mov    (%eax),%edx
  803d3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d3f:	89 10                	mov    %edx,(%eax)
  803d41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d44:	8b 00                	mov    (%eax),%eax
  803d46:	85 c0                	test   %eax,%eax
  803d48:	74 0b                	je     803d55 <realloc_block_FF+0x41e>
  803d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4d:	8b 00                	mov    (%eax),%eax
  803d4f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d52:	89 50 04             	mov    %edx,0x4(%eax)
  803d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d58:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d5b:	89 10                	mov    %edx,(%eax)
  803d5d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d63:	89 50 04             	mov    %edx,0x4(%eax)
  803d66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d69:	8b 00                	mov    (%eax),%eax
  803d6b:	85 c0                	test   %eax,%eax
  803d6d:	75 08                	jne    803d77 <realloc_block_FF+0x440>
  803d6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d72:	a3 38 50 80 00       	mov    %eax,0x805038
  803d77:	a1 40 50 80 00       	mov    0x805040,%eax
  803d7c:	40                   	inc    %eax
  803d7d:	a3 40 50 80 00       	mov    %eax,0x805040
							break;
  803d82:	eb 36                	jmp    803dba <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803d84:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d90:	74 07                	je     803d99 <realloc_block_FF+0x462>
  803d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d95:	8b 00                	mov    (%eax),%eax
  803d97:	eb 05                	jmp    803d9e <realloc_block_FF+0x467>
  803d99:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803da3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803da8:	85 c0                	test   %eax,%eax
  803daa:	0f 85 52 ff ff ff    	jne    803d02 <realloc_block_FF+0x3cb>
  803db0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803db4:	0f 85 48 ff ff ff    	jne    803d02 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803dba:	83 ec 04             	sub    $0x4,%esp
  803dbd:	6a 00                	push   $0x0
  803dbf:	ff 75 d8             	pushl  -0x28(%ebp)
  803dc2:	ff 75 d4             	pushl  -0x2c(%ebp)
  803dc5:	e8 7a eb ff ff       	call   802944 <set_block_data>
  803dca:	83 c4 10             	add    $0x10,%esp
				return va;
  803dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd0:	e9 7b 02 00 00       	jmp    804050 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803dd5:	83 ec 0c             	sub    $0xc,%esp
  803dd8:	68 e1 4c 80 00       	push   $0x804ce1
  803ddd:	e8 26 cc ff ff       	call   800a08 <cprintf>
  803de2:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803de5:	8b 45 08             	mov    0x8(%ebp),%eax
  803de8:	e9 63 02 00 00       	jmp    804050 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  803df0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803df3:	0f 86 4d 02 00 00    	jbe    804046 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803df9:	83 ec 0c             	sub    $0xc,%esp
  803dfc:	ff 75 e4             	pushl  -0x1c(%ebp)
  803dff:	e8 08 e8 ff ff       	call   80260c <is_free_block>
  803e04:	83 c4 10             	add    $0x10,%esp
  803e07:	84 c0                	test   %al,%al
  803e09:	0f 84 37 02 00 00    	je     804046 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e12:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803e15:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803e18:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e1b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e1e:	76 38                	jbe    803e58 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803e20:	83 ec 0c             	sub    $0xc,%esp
  803e23:	ff 75 08             	pushl  0x8(%ebp)
  803e26:	e8 0c fa ff ff       	call   803837 <free_block>
  803e2b:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803e2e:	83 ec 0c             	sub    $0xc,%esp
  803e31:	ff 75 0c             	pushl  0xc(%ebp)
  803e34:	e8 3a eb ff ff       	call   802973 <alloc_block_FF>
  803e39:	83 c4 10             	add    $0x10,%esp
  803e3c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803e3f:	83 ec 08             	sub    $0x8,%esp
  803e42:	ff 75 c0             	pushl  -0x40(%ebp)
  803e45:	ff 75 08             	pushl  0x8(%ebp)
  803e48:	e8 ab fa ff ff       	call   8038f8 <copy_data>
  803e4d:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803e50:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803e53:	e9 f8 01 00 00       	jmp    804050 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803e58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e5b:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803e5e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803e61:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803e65:	0f 87 a0 00 00 00    	ja     803f0b <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803e6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e6f:	75 17                	jne    803e88 <realloc_block_FF+0x551>
  803e71:	83 ec 04             	sub    $0x4,%esp
  803e74:	68 d3 4b 80 00       	push   $0x804bd3
  803e79:	68 38 02 00 00       	push   $0x238
  803e7e:	68 f1 4b 80 00       	push   $0x804bf1
  803e83:	e8 c3 c8 ff ff       	call   80074b <_panic>
  803e88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e8b:	8b 00                	mov    (%eax),%eax
  803e8d:	85 c0                	test   %eax,%eax
  803e8f:	74 10                	je     803ea1 <realloc_block_FF+0x56a>
  803e91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e94:	8b 00                	mov    (%eax),%eax
  803e96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e99:	8b 52 04             	mov    0x4(%edx),%edx
  803e9c:	89 50 04             	mov    %edx,0x4(%eax)
  803e9f:	eb 0b                	jmp    803eac <realloc_block_FF+0x575>
  803ea1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea4:	8b 40 04             	mov    0x4(%eax),%eax
  803ea7:	a3 38 50 80 00       	mov    %eax,0x805038
  803eac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eaf:	8b 40 04             	mov    0x4(%eax),%eax
  803eb2:	85 c0                	test   %eax,%eax
  803eb4:	74 0f                	je     803ec5 <realloc_block_FF+0x58e>
  803eb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb9:	8b 40 04             	mov    0x4(%eax),%eax
  803ebc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ebf:	8b 12                	mov    (%edx),%edx
  803ec1:	89 10                	mov    %edx,(%eax)
  803ec3:	eb 0a                	jmp    803ecf <realloc_block_FF+0x598>
  803ec5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec8:	8b 00                	mov    (%eax),%eax
  803eca:	a3 34 50 80 00       	mov    %eax,0x805034
  803ecf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803edb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ee2:	a1 40 50 80 00       	mov    0x805040,%eax
  803ee7:	48                   	dec    %eax
  803ee8:	a3 40 50 80 00       	mov    %eax,0x805040

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803eed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ef0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ef3:	01 d0                	add    %edx,%eax
  803ef5:	83 ec 04             	sub    $0x4,%esp
  803ef8:	6a 01                	push   $0x1
  803efa:	50                   	push   %eax
  803efb:	ff 75 08             	pushl  0x8(%ebp)
  803efe:	e8 41 ea ff ff       	call   802944 <set_block_data>
  803f03:	83 c4 10             	add    $0x10,%esp
  803f06:	e9 36 01 00 00       	jmp    804041 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803f0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f0e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f11:	01 d0                	add    %edx,%eax
  803f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803f16:	83 ec 04             	sub    $0x4,%esp
  803f19:	6a 01                	push   $0x1
  803f1b:	ff 75 f0             	pushl  -0x10(%ebp)
  803f1e:	ff 75 08             	pushl  0x8(%ebp)
  803f21:	e8 1e ea ff ff       	call   802944 <set_block_data>
  803f26:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803f29:	8b 45 08             	mov    0x8(%ebp),%eax
  803f2c:	83 e8 04             	sub    $0x4,%eax
  803f2f:	8b 00                	mov    (%eax),%eax
  803f31:	83 e0 fe             	and    $0xfffffffe,%eax
  803f34:	89 c2                	mov    %eax,%edx
  803f36:	8b 45 08             	mov    0x8(%ebp),%eax
  803f39:	01 d0                	add    %edx,%eax
  803f3b:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803f3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f42:	74 06                	je     803f4a <realloc_block_FF+0x613>
  803f44:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803f48:	75 17                	jne    803f61 <realloc_block_FF+0x62a>
  803f4a:	83 ec 04             	sub    $0x4,%esp
  803f4d:	68 64 4c 80 00       	push   $0x804c64
  803f52:	68 44 02 00 00       	push   $0x244
  803f57:	68 f1 4b 80 00       	push   $0x804bf1
  803f5c:	e8 ea c7 ff ff       	call   80074b <_panic>
  803f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f64:	8b 10                	mov    (%eax),%edx
  803f66:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f69:	89 10                	mov    %edx,(%eax)
  803f6b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f6e:	8b 00                	mov    (%eax),%eax
  803f70:	85 c0                	test   %eax,%eax
  803f72:	74 0b                	je     803f7f <realloc_block_FF+0x648>
  803f74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f77:	8b 00                	mov    (%eax),%eax
  803f79:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f7c:	89 50 04             	mov    %edx,0x4(%eax)
  803f7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f82:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f85:	89 10                	mov    %edx,(%eax)
  803f87:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f8d:	89 50 04             	mov    %edx,0x4(%eax)
  803f90:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f93:	8b 00                	mov    (%eax),%eax
  803f95:	85 c0                	test   %eax,%eax
  803f97:	75 08                	jne    803fa1 <realloc_block_FF+0x66a>
  803f99:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f9c:	a3 38 50 80 00       	mov    %eax,0x805038
  803fa1:	a1 40 50 80 00       	mov    0x805040,%eax
  803fa6:	40                   	inc    %eax
  803fa7:	a3 40 50 80 00       	mov    %eax,0x805040
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803fac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fb0:	75 17                	jne    803fc9 <realloc_block_FF+0x692>
  803fb2:	83 ec 04             	sub    $0x4,%esp
  803fb5:	68 d3 4b 80 00       	push   $0x804bd3
  803fba:	68 45 02 00 00       	push   $0x245
  803fbf:	68 f1 4b 80 00       	push   $0x804bf1
  803fc4:	e8 82 c7 ff ff       	call   80074b <_panic>
  803fc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fcc:	8b 00                	mov    (%eax),%eax
  803fce:	85 c0                	test   %eax,%eax
  803fd0:	74 10                	je     803fe2 <realloc_block_FF+0x6ab>
  803fd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd5:	8b 00                	mov    (%eax),%eax
  803fd7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fda:	8b 52 04             	mov    0x4(%edx),%edx
  803fdd:	89 50 04             	mov    %edx,0x4(%eax)
  803fe0:	eb 0b                	jmp    803fed <realloc_block_FF+0x6b6>
  803fe2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe5:	8b 40 04             	mov    0x4(%eax),%eax
  803fe8:	a3 38 50 80 00       	mov    %eax,0x805038
  803fed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff0:	8b 40 04             	mov    0x4(%eax),%eax
  803ff3:	85 c0                	test   %eax,%eax
  803ff5:	74 0f                	je     804006 <realloc_block_FF+0x6cf>
  803ff7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ffa:	8b 40 04             	mov    0x4(%eax),%eax
  803ffd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804000:	8b 12                	mov    (%edx),%edx
  804002:	89 10                	mov    %edx,(%eax)
  804004:	eb 0a                	jmp    804010 <realloc_block_FF+0x6d9>
  804006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804009:	8b 00                	mov    (%eax),%eax
  80400b:	a3 34 50 80 00       	mov    %eax,0x805034
  804010:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804013:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804019:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80401c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804023:	a1 40 50 80 00       	mov    0x805040,%eax
  804028:	48                   	dec    %eax
  804029:	a3 40 50 80 00       	mov    %eax,0x805040
				set_block_data(next_new_va, remaining_size, 0);
  80402e:	83 ec 04             	sub    $0x4,%esp
  804031:	6a 00                	push   $0x0
  804033:	ff 75 bc             	pushl  -0x44(%ebp)
  804036:	ff 75 b8             	pushl  -0x48(%ebp)
  804039:	e8 06 e9 ff ff       	call   802944 <set_block_data>
  80403e:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804041:	8b 45 08             	mov    0x8(%ebp),%eax
  804044:	eb 0a                	jmp    804050 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804046:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80404d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804050:	c9                   	leave  
  804051:	c3                   	ret    

00804052 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804052:	55                   	push   %ebp
  804053:	89 e5                	mov    %esp,%ebp
  804055:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804058:	83 ec 04             	sub    $0x4,%esp
  80405b:	68 e8 4c 80 00       	push   $0x804ce8
  804060:	68 58 02 00 00       	push   $0x258
  804065:	68 f1 4b 80 00       	push   $0x804bf1
  80406a:	e8 dc c6 ff ff       	call   80074b <_panic>

0080406f <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80406f:	55                   	push   %ebp
  804070:	89 e5                	mov    %esp,%ebp
  804072:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804075:	83 ec 04             	sub    $0x4,%esp
  804078:	68 10 4d 80 00       	push   $0x804d10
  80407d:	68 61 02 00 00       	push   $0x261
  804082:	68 f1 4b 80 00       	push   $0x804bf1
  804087:	e8 bf c6 ff ff       	call   80074b <_panic>

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
