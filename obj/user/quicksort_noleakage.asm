
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
  800041:	e8 f3 1e 00 00       	call   801f39 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 42 80 00       	push   $0x804200
  80004e:	e8 b5 09 00 00       	call   800a08 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 42 80 00       	push   $0x804202
  80005e:	e8 a5 09 00 00       	call   800a08 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 1b 42 80 00       	push   $0x80421b
  80006e:	e8 95 09 00 00       	call   800a08 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 42 80 00       	push   $0x804202
  80007e:	e8 85 09 00 00       	call   800a08 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 42 80 00       	push   $0x804200
  80008e:	e8 75 09 00 00       	call   800a08 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 34 42 80 00       	push   $0x804234
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
  8000c9:	68 54 42 80 00       	push   $0x804254
  8000ce:	e8 35 09 00 00       	call   800a08 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 76 42 80 00       	push   $0x804276
  8000de:	e8 25 09 00 00       	call   800a08 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 84 42 80 00       	push   $0x804284
  8000ee:	e8 15 09 00 00       	call   800a08 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 93 42 80 00       	push   $0x804293
  8000fe:	e8 05 09 00 00       	call   800a08 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 a3 42 80 00       	push   $0x8042a3
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
  80014d:	e8 01 1e 00 00       	call   801f53 <sys_unlock_cons>
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
  8001d5:	e8 5f 1d 00 00       	call   801f39 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 ac 42 80 00       	push   $0x8042ac
  8001e2:	e8 21 08 00 00       	call   800a08 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 64 1d 00 00       	call   801f53 <sys_unlock_cons>
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
  80020c:	68 e0 42 80 00       	push   $0x8042e0
  800211:	6a 54                	push   $0x54
  800213:	68 02 43 80 00       	push   $0x804302
  800218:	e8 2e 05 00 00       	call   80074b <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 17 1d 00 00       	call   801f39 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 20 43 80 00       	push   $0x804320
  80022a:	e8 d9 07 00 00       	call   800a08 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 54 43 80 00       	push   $0x804354
  80023a:	e8 c9 07 00 00       	call   800a08 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 88 43 80 00       	push   $0x804388
  80024a:	e8 b9 07 00 00       	call   800a08 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 fc 1c 00 00       	call   801f53 <sys_unlock_cons>
			//			sys_unlock_cons();


		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 ec             	pushl  -0x14(%ebp)
  80025d:	e8 7d 19 00 00       	call   801bdf <free>
  800262:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
  800265:	e8 cf 1c 00 00       	call   801f39 <sys_lock_cons>
		{
			Chose = 0 ;
  80026a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  80026e:	eb 42                	jmp    8002b2 <_main+0x27a>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 ba 43 80 00       	push   $0x8043ba
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
  8002be:	e8 90 1c 00 00       	call   801f53 <sys_unlock_cons>
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
  800570:	68 00 42 80 00       	push   $0x804200
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
  800592:	68 d8 43 80 00       	push   $0x8043d8
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
  8005c0:	68 dd 43 80 00       	push   $0x8043dd
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
  8005e4:	e8 9b 1a 00 00       	call   802084 <sys_cputc>
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
  8005f5:	e8 26 19 00 00       	call   801f20 <sys_cgetc>
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
  800612:	e8 9e 1b 00 00       	call   8021b5 <sys_getenvindex>
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
  800680:	e8 b4 18 00 00       	call   801f39 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800685:	83 ec 0c             	sub    $0xc,%esp
  800688:	68 fc 43 80 00       	push   $0x8043fc
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
  8006b0:	68 24 44 80 00       	push   $0x804424
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
  8006e1:	68 4c 44 80 00       	push   $0x80444c
  8006e6:	e8 1d 03 00 00       	call   800a08 <cprintf>
  8006eb:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f3:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	50                   	push   %eax
  8006fd:	68 a4 44 80 00       	push   $0x8044a4
  800702:	e8 01 03 00 00       	call   800a08 <cprintf>
  800707:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 fc 43 80 00       	push   $0x8043fc
  800712:	e8 f1 02 00 00       	call   800a08 <cprintf>
  800717:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80071a:	e8 34 18 00 00       	call   801f53 <sys_unlock_cons>
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
  800732:	e8 4a 1a 00 00       	call   802181 <sys_destroy_env>
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
  800743:	e8 9f 1a 00 00       	call   8021e7 <sys_exit_env>
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
  80076c:	68 b8 44 80 00       	push   $0x8044b8
  800771:	e8 92 02 00 00       	call   800a08 <cprintf>
  800776:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800779:	a1 00 50 80 00       	mov    0x805000,%eax
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	ff 75 08             	pushl  0x8(%ebp)
  800784:	50                   	push   %eax
  800785:	68 bd 44 80 00       	push   $0x8044bd
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
  8007a9:	68 d9 44 80 00       	push   $0x8044d9
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
  8007d8:	68 dc 44 80 00       	push   $0x8044dc
  8007dd:	6a 26                	push   $0x26
  8007df:	68 28 45 80 00       	push   $0x804528
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
  8008ad:	68 34 45 80 00       	push   $0x804534
  8008b2:	6a 3a                	push   $0x3a
  8008b4:	68 28 45 80 00       	push   $0x804528
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
  800920:	68 88 45 80 00       	push   $0x804588
  800925:	6a 44                	push   $0x44
  800927:	68 28 45 80 00       	push   $0x804528
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
  80097a:	e8 78 15 00 00       	call   801ef7 <sys_cputs>
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
  8009f1:	e8 01 15 00 00       	call   801ef7 <sys_cputs>
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
  800a3b:	e8 f9 14 00 00       	call   801f39 <sys_lock_cons>
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
  800a5b:	e8 f3 14 00 00       	call   801f53 <sys_unlock_cons>
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
  800aa5:	e8 e6 34 00 00       	call   803f90 <__udivdi3>
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
  800af5:	e8 a6 35 00 00       	call   8040a0 <__umoddi3>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	05 f4 47 80 00       	add    $0x8047f4,%eax
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
  800c50:	8b 04 85 18 48 80 00 	mov    0x804818(,%eax,4),%eax
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
  800d31:	8b 34 9d 60 46 80 00 	mov    0x804660(,%ebx,4),%esi
  800d38:	85 f6                	test   %esi,%esi
  800d3a:	75 19                	jne    800d55 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d3c:	53                   	push   %ebx
  800d3d:	68 05 48 80 00       	push   $0x804805
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
  800d56:	68 0e 48 80 00       	push   $0x80480e
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
  800d83:	be 11 48 80 00       	mov    $0x804811,%esi
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
  8010ae:	68 88 49 80 00       	push   $0x804988
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
  8010f0:	68 8b 49 80 00       	push   $0x80498b
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
  8011a1:	e8 93 0d 00 00       	call   801f39 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8011a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011aa:	74 13                	je     8011bf <atomic_readline+0x24>
			cprintf("%s", prompt);
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	ff 75 08             	pushl  0x8(%ebp)
  8011b2:	68 88 49 80 00       	push   $0x804988
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
  8011f4:	68 8b 49 80 00       	push   $0x80498b
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
  80129c:	e8 b2 0c 00 00       	call   801f53 <sys_unlock_cons>
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
  801996:	68 9c 49 80 00       	push   $0x80499c
  80199b:	68 3f 01 00 00       	push   $0x13f
  8019a0:	68 be 49 80 00       	push   $0x8049be
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
  8019b6:	e8 e7 0a 00 00       	call   8024a2 <sys_sbrk>
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
  801a31:	e8 f0 08 00 00       	call   802326 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a36:	85 c0                	test   %eax,%eax
  801a38:	74 16                	je     801a50 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a3a:	83 ec 0c             	sub    $0xc,%esp
  801a3d:	ff 75 08             	pushl  0x8(%ebp)
  801a40:	e8 30 0e 00 00       	call   802875 <alloc_block_FF>
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a4b:	e9 8a 01 00 00       	jmp    801bda <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801a50:	e8 02 09 00 00       	call   802357 <sys_isUHeapPlacementStrategyBESTFIT>
  801a55:	85 c0                	test   %eax,%eax
  801a57:	0f 84 7d 01 00 00    	je     801bda <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801a5d:	83 ec 0c             	sub    $0xc,%esp
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	e8 c9 12 00 00       	call   802d31 <alloc_block_BF>
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
  801ab3:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801b00:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801bb9:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801bc0:	83 ec 08             	sub    $0x8,%esp
  801bc3:	ff 75 08             	pushl  0x8(%ebp)
  801bc6:	ff 75 f0             	pushl  -0x10(%ebp)
  801bc9:	e8 0b 09 00 00       	call   8024d9 <sys_allocate_user_mem>
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
  801c11:	e8 df 08 00 00       	call   8024f5 <get_block_size>
  801c16:	83 c4 10             	add    $0x10,%esp
  801c19:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c1c:	83 ec 0c             	sub    $0xc,%esp
  801c1f:	ff 75 08             	pushl  0x8(%ebp)
  801c22:	e8 12 1b 00 00       	call   803739 <free_block>
  801c27:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
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
  801c76:	eb 2f                	jmp    801ca7 <free+0xc8>
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
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801ca4:	ff 45 f4             	incl   -0xc(%ebp)
  801ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801caa:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801cad:	72 c9                	jb     801c78 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	83 ec 08             	sub    $0x8,%esp
  801cb5:	ff 75 ec             	pushl  -0x14(%ebp)
  801cb8:	50                   	push   %eax
  801cb9:	e8 ff 07 00 00       	call   8024bd <sys_free_user_mem>
  801cbe:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801cc1:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801cc2:	eb 17                	jmp    801cdb <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801cc4:	83 ec 04             	sub    $0x4,%esp
  801cc7:	68 cc 49 80 00       	push   $0x8049cc
  801ccc:	68 85 00 00 00       	push   $0x85
  801cd1:	68 f6 49 80 00       	push   $0x8049f6
  801cd6:	e8 70 ea ff ff       	call   80074b <_panic>
	}
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 28             	sub    $0x28,%esp
  801ce3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce6:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801ce9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ced:	75 0a                	jne    801cf9 <smalloc+0x1c>
  801cef:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf4:	e9 9a 00 00 00       	jmp    801d93 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cff:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d06:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0c:	39 d0                	cmp    %edx,%eax
  801d0e:	73 02                	jae    801d12 <smalloc+0x35>
  801d10:	89 d0                	mov    %edx,%eax
  801d12:	83 ec 0c             	sub    $0xc,%esp
  801d15:	50                   	push   %eax
  801d16:	e8 a5 fc ff ff       	call   8019c0 <malloc>
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801d21:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d25:	75 07                	jne    801d2e <smalloc+0x51>
  801d27:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2c:	eb 65                	jmp    801d93 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d2e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d32:	ff 75 ec             	pushl  -0x14(%ebp)
  801d35:	50                   	push   %eax
  801d36:	ff 75 0c             	pushl  0xc(%ebp)
  801d39:	ff 75 08             	pushl  0x8(%ebp)
  801d3c:	e8 83 03 00 00       	call   8020c4 <sys_createSharedObject>
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801d47:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801d4b:	74 06                	je     801d53 <smalloc+0x76>
  801d4d:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801d51:	75 07                	jne    801d5a <smalloc+0x7d>
  801d53:	b8 00 00 00 00       	mov    $0x0,%eax
  801d58:	eb 39                	jmp    801d93 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801d5a:	83 ec 08             	sub    $0x8,%esp
  801d5d:	ff 75 ec             	pushl  -0x14(%ebp)
  801d60:	68 02 4a 80 00       	push   $0x804a02
  801d65:	e8 9e ec ff ff       	call   800a08 <cprintf>
  801d6a:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801d6d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d70:	a1 24 50 80 00       	mov    0x805024,%eax
  801d75:	8b 40 78             	mov    0x78(%eax),%eax
  801d78:	29 c2                	sub    %eax,%edx
  801d7a:	89 d0                	mov    %edx,%eax
  801d7c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d81:	c1 e8 0c             	shr    $0xc,%eax
  801d84:	89 c2                	mov    %eax,%edx
  801d86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d89:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d9b:	83 ec 08             	sub    $0x8,%esp
  801d9e:	ff 75 0c             	pushl  0xc(%ebp)
  801da1:	ff 75 08             	pushl  0x8(%ebp)
  801da4:	e8 45 03 00 00       	call   8020ee <sys_getSizeOfSharedObject>
  801da9:	83 c4 10             	add    $0x10,%esp
  801dac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801daf:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801db3:	75 07                	jne    801dbc <sget+0x27>
  801db5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dba:	eb 5c                	jmp    801e18 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801dc2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801dc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dcf:	39 d0                	cmp    %edx,%eax
  801dd1:	7d 02                	jge    801dd5 <sget+0x40>
  801dd3:	89 d0                	mov    %edx,%eax
  801dd5:	83 ec 0c             	sub    $0xc,%esp
  801dd8:	50                   	push   %eax
  801dd9:	e8 e2 fb ff ff       	call   8019c0 <malloc>
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801de4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801de8:	75 07                	jne    801df1 <sget+0x5c>
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
  801def:	eb 27                	jmp    801e18 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	ff 75 e8             	pushl  -0x18(%ebp)
  801df7:	ff 75 0c             	pushl  0xc(%ebp)
  801dfa:	ff 75 08             	pushl  0x8(%ebp)
  801dfd:	e8 09 03 00 00       	call   80210b <sys_getSharedObject>
  801e02:	83 c4 10             	add    $0x10,%esp
  801e05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801e08:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801e0c:	75 07                	jne    801e15 <sget+0x80>
  801e0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e13:	eb 03                	jmp    801e18 <sget+0x83>
	return ptr;
  801e15:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801e20:	8b 55 08             	mov    0x8(%ebp),%edx
  801e23:	a1 24 50 80 00       	mov    0x805024,%eax
  801e28:	8b 40 78             	mov    0x78(%eax),%eax
  801e2b:	29 c2                	sub    %eax,%edx
  801e2d:	89 d0                	mov    %edx,%eax
  801e2f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e34:	c1 e8 0c             	shr    $0xc,%eax
  801e37:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801e41:	83 ec 08             	sub    $0x8,%esp
  801e44:	ff 75 08             	pushl  0x8(%ebp)
  801e47:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4a:	e8 db 02 00 00       	call   80212a <sys_freeSharedObject>
  801e4f:	83 c4 10             	add    $0x10,%esp
  801e52:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801e55:	90                   	nop
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e5e:	83 ec 04             	sub    $0x4,%esp
  801e61:	68 14 4a 80 00       	push   $0x804a14
  801e66:	68 dd 00 00 00       	push   $0xdd
  801e6b:	68 f6 49 80 00       	push   $0x8049f6
  801e70:	e8 d6 e8 ff ff       	call   80074b <_panic>

00801e75 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e7b:	83 ec 04             	sub    $0x4,%esp
  801e7e:	68 3a 4a 80 00       	push   $0x804a3a
  801e83:	68 e9 00 00 00       	push   $0xe9
  801e88:	68 f6 49 80 00       	push   $0x8049f6
  801e8d:	e8 b9 e8 ff ff       	call   80074b <_panic>

00801e92 <shrink>:

}
void shrink(uint32 newSize)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e98:	83 ec 04             	sub    $0x4,%esp
  801e9b:	68 3a 4a 80 00       	push   $0x804a3a
  801ea0:	68 ee 00 00 00       	push   $0xee
  801ea5:	68 f6 49 80 00       	push   $0x8049f6
  801eaa:	e8 9c e8 ff ff       	call   80074b <_panic>

00801eaf <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eb5:	83 ec 04             	sub    $0x4,%esp
  801eb8:	68 3a 4a 80 00       	push   $0x804a3a
  801ebd:	68 f3 00 00 00       	push   $0xf3
  801ec2:	68 f6 49 80 00       	push   $0x8049f6
  801ec7:	e8 7f e8 ff ff       	call   80074b <_panic>

00801ecc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	57                   	push   %edi
  801ed0:	56                   	push   %esi
  801ed1:	53                   	push   %ebx
  801ed2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ede:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ee4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ee7:	cd 30                	int    $0x30
  801ee9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801eef:	83 c4 10             	add    $0x10,%esp
  801ef2:	5b                   	pop    %ebx
  801ef3:	5e                   	pop    %esi
  801ef4:	5f                   	pop    %edi
  801ef5:	5d                   	pop    %ebp
  801ef6:	c3                   	ret    

00801ef7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	8b 45 10             	mov    0x10(%ebp),%eax
  801f00:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f03:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	52                   	push   %edx
  801f0f:	ff 75 0c             	pushl  0xc(%ebp)
  801f12:	50                   	push   %eax
  801f13:	6a 00                	push   $0x0
  801f15:	e8 b2 ff ff ff       	call   801ecc <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
}
  801f1d:	90                   	nop
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 02                	push   $0x2
  801f2f:	e8 98 ff ff ff       	call   801ecc <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 03                	push   $0x3
  801f48:	e8 7f ff ff ff       	call   801ecc <syscall>
  801f4d:	83 c4 18             	add    $0x18,%esp
}
  801f50:	90                   	nop
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 04                	push   $0x4
  801f62:	e8 65 ff ff ff       	call   801ecc <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
}
  801f6a:	90                   	nop
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	52                   	push   %edx
  801f7d:	50                   	push   %eax
  801f7e:	6a 08                	push   $0x8
  801f80:	e8 47 ff ff ff       	call   801ecc <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	56                   	push   %esi
  801f8e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f8f:	8b 75 18             	mov    0x18(%ebp),%esi
  801f92:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f95:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	56                   	push   %esi
  801f9f:	53                   	push   %ebx
  801fa0:	51                   	push   %ecx
  801fa1:	52                   	push   %edx
  801fa2:	50                   	push   %eax
  801fa3:	6a 09                	push   $0x9
  801fa5:	e8 22 ff ff ff       	call   801ecc <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb0:	5b                   	pop    %ebx
  801fb1:	5e                   	pop    %esi
  801fb2:	5d                   	pop    %ebp
  801fb3:	c3                   	ret    

00801fb4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fba:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	52                   	push   %edx
  801fc4:	50                   	push   %eax
  801fc5:	6a 0a                	push   $0xa
  801fc7:	e8 00 ff ff ff       	call   801ecc <syscall>
  801fcc:	83 c4 18             	add    $0x18,%esp
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	ff 75 0c             	pushl  0xc(%ebp)
  801fdd:	ff 75 08             	pushl  0x8(%ebp)
  801fe0:	6a 0b                	push   $0xb
  801fe2:	e8 e5 fe ff ff       	call   801ecc <syscall>
  801fe7:	83 c4 18             	add    $0x18,%esp
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 0c                	push   $0xc
  801ffb:	e8 cc fe ff ff       	call   801ecc <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 0d                	push   $0xd
  802014:	e8 b3 fe ff ff       	call   801ecc <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 0e                	push   $0xe
  80202d:	e8 9a fe ff ff       	call   801ecc <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 0f                	push   $0xf
  802046:	e8 81 fe ff ff       	call   801ecc <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	ff 75 08             	pushl  0x8(%ebp)
  80205e:	6a 10                	push   $0x10
  802060:	e8 67 fe ff ff       	call   801ecc <syscall>
  802065:	83 c4 18             	add    $0x18,%esp
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 11                	push   $0x11
  802079:	e8 4e fe ff ff       	call   801ecc <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
}
  802081:	90                   	nop
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_cputc>:

void
sys_cputc(const char c)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 04             	sub    $0x4,%esp
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802090:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	50                   	push   %eax
  80209d:	6a 01                	push   $0x1
  80209f:	e8 28 fe ff ff       	call   801ecc <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
}
  8020a7:	90                   	nop
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 14                	push   $0x14
  8020b9:	e8 0e fe ff ff       	call   801ecc <syscall>
  8020be:	83 c4 18             	add    $0x18,%esp
}
  8020c1:	90                   	nop
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 04             	sub    $0x4,%esp
  8020ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8020cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020d0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020d3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	6a 00                	push   $0x0
  8020dc:	51                   	push   %ecx
  8020dd:	52                   	push   %edx
  8020de:	ff 75 0c             	pushl  0xc(%ebp)
  8020e1:	50                   	push   %eax
  8020e2:	6a 15                	push   $0x15
  8020e4:	e8 e3 fd ff ff       	call   801ecc <syscall>
  8020e9:	83 c4 18             	add    $0x18,%esp
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8020f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	52                   	push   %edx
  8020fe:	50                   	push   %eax
  8020ff:	6a 16                	push   $0x16
  802101:	e8 c6 fd ff ff       	call   801ecc <syscall>
  802106:	83 c4 18             	add    $0x18,%esp
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80210e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802111:	8b 55 0c             	mov    0xc(%ebp),%edx
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	51                   	push   %ecx
  80211c:	52                   	push   %edx
  80211d:	50                   	push   %eax
  80211e:	6a 17                	push   $0x17
  802120:	e8 a7 fd ff ff       	call   801ecc <syscall>
  802125:	83 c4 18             	add    $0x18,%esp
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80212d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	52                   	push   %edx
  80213a:	50                   	push   %eax
  80213b:	6a 18                	push   $0x18
  80213d:	e8 8a fd ff ff       	call   801ecc <syscall>
  802142:	83 c4 18             	add    $0x18,%esp
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	6a 00                	push   $0x0
  80214f:	ff 75 14             	pushl  0x14(%ebp)
  802152:	ff 75 10             	pushl  0x10(%ebp)
  802155:	ff 75 0c             	pushl  0xc(%ebp)
  802158:	50                   	push   %eax
  802159:	6a 19                	push   $0x19
  80215b:	e8 6c fd ff ff       	call   801ecc <syscall>
  802160:	83 c4 18             	add    $0x18,%esp
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	50                   	push   %eax
  802174:	6a 1a                	push   $0x1a
  802176:	e8 51 fd ff ff       	call   801ecc <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
}
  80217e:	90                   	nop
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	50                   	push   %eax
  802190:	6a 1b                	push   $0x1b
  802192:	e8 35 fd ff ff       	call   801ecc <syscall>
  802197:	83 c4 18             	add    $0x18,%esp
}
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 05                	push   $0x5
  8021ab:	e8 1c fd ff ff       	call   801ecc <syscall>
  8021b0:	83 c4 18             	add    $0x18,%esp
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 06                	push   $0x6
  8021c4:	e8 03 fd ff ff       	call   801ecc <syscall>
  8021c9:	83 c4 18             	add    $0x18,%esp
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 07                	push   $0x7
  8021dd:	e8 ea fc ff ff       	call   801ecc <syscall>
  8021e2:	83 c4 18             	add    $0x18,%esp
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <sys_exit_env>:


void sys_exit_env(void)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 1c                	push   $0x1c
  8021f6:	e8 d1 fc ff ff       	call   801ecc <syscall>
  8021fb:	83 c4 18             	add    $0x18,%esp
}
  8021fe:	90                   	nop
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
  802204:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802207:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80220a:	8d 50 04             	lea    0x4(%eax),%edx
  80220d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	52                   	push   %edx
  802217:	50                   	push   %eax
  802218:	6a 1d                	push   $0x1d
  80221a:	e8 ad fc ff ff       	call   801ecc <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
	return result;
  802222:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802225:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802228:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80222b:	89 01                	mov    %eax,(%ecx)
  80222d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	c9                   	leave  
  802234:	c2 04 00             	ret    $0x4

00802237 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	ff 75 10             	pushl  0x10(%ebp)
  802241:	ff 75 0c             	pushl  0xc(%ebp)
  802244:	ff 75 08             	pushl  0x8(%ebp)
  802247:	6a 13                	push   $0x13
  802249:	e8 7e fc ff ff       	call   801ecc <syscall>
  80224e:	83 c4 18             	add    $0x18,%esp
	return ;
  802251:	90                   	nop
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <sys_rcr2>:
uint32 sys_rcr2()
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 1e                	push   $0x1e
  802263:	e8 64 fc ff ff       	call   801ecc <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    

0080226d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80226d:	55                   	push   %ebp
  80226e:	89 e5                	mov    %esp,%ebp
  802270:	83 ec 04             	sub    $0x4,%esp
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802279:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	50                   	push   %eax
  802286:	6a 1f                	push   $0x1f
  802288:	e8 3f fc ff ff       	call   801ecc <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
	return ;
  802290:	90                   	nop
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <rsttst>:
void rsttst()
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 21                	push   $0x21
  8022a2:	e8 25 fc ff ff       	call   801ecc <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8022aa:	90                   	nop
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	83 ec 04             	sub    $0x4,%esp
  8022b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8022b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022b9:	8b 55 18             	mov    0x18(%ebp),%edx
  8022bc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022c0:	52                   	push   %edx
  8022c1:	50                   	push   %eax
  8022c2:	ff 75 10             	pushl  0x10(%ebp)
  8022c5:	ff 75 0c             	pushl  0xc(%ebp)
  8022c8:	ff 75 08             	pushl  0x8(%ebp)
  8022cb:	6a 20                	push   $0x20
  8022cd:	e8 fa fb ff ff       	call   801ecc <syscall>
  8022d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d5:	90                   	nop
}
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <chktst>:
void chktst(uint32 n)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	ff 75 08             	pushl  0x8(%ebp)
  8022e6:	6a 22                	push   $0x22
  8022e8:	e8 df fb ff ff       	call   801ecc <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f0:	90                   	nop
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <inctst>:

void inctst()
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 23                	push   $0x23
  802302:	e8 c5 fb ff ff       	call   801ecc <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
	return ;
  80230a:	90                   	nop
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <gettst>:
uint32 gettst()
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 24                	push   $0x24
  80231c:	e8 ab fb ff ff       	call   801ecc <syscall>
  802321:	83 c4 18             	add    $0x18,%esp
}
  802324:	c9                   	leave  
  802325:	c3                   	ret    

00802326 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
  802329:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 25                	push   $0x25
  802338:	e8 8f fb ff ff       	call   801ecc <syscall>
  80233d:	83 c4 18             	add    $0x18,%esp
  802340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802343:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802347:	75 07                	jne    802350 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802349:	b8 01 00 00 00       	mov    $0x1,%eax
  80234e:	eb 05                	jmp    802355 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802350:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
  80235a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 25                	push   $0x25
  802369:	e8 5e fb ff ff       	call   801ecc <syscall>
  80236e:	83 c4 18             	add    $0x18,%esp
  802371:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802374:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802378:	75 07                	jne    802381 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80237a:	b8 01 00 00 00       	mov    $0x1,%eax
  80237f:	eb 05                	jmp    802386 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802381:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
  80238b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 25                	push   $0x25
  80239a:	e8 2d fb ff ff       	call   801ecc <syscall>
  80239f:	83 c4 18             	add    $0x18,%esp
  8023a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023a5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023a9:	75 07                	jne    8023b2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b0:	eb 05                	jmp    8023b7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    

008023b9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 25                	push   $0x25
  8023cb:	e8 fc fa ff ff       	call   801ecc <syscall>
  8023d0:	83 c4 18             	add    $0x18,%esp
  8023d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023d6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023da:	75 07                	jne    8023e3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e1:	eb 05                	jmp    8023e8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023e8:	c9                   	leave  
  8023e9:	c3                   	ret    

008023ea <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	ff 75 08             	pushl  0x8(%ebp)
  8023f8:	6a 26                	push   $0x26
  8023fa:	e8 cd fa ff ff       	call   801ecc <syscall>
  8023ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802402:	90                   	nop
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
  802408:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802409:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80240c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80240f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	6a 00                	push   $0x0
  802417:	53                   	push   %ebx
  802418:	51                   	push   %ecx
  802419:	52                   	push   %edx
  80241a:	50                   	push   %eax
  80241b:	6a 27                	push   $0x27
  80241d:	e8 aa fa ff ff       	call   801ecc <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
}
  802425:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80242d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	52                   	push   %edx
  80243a:	50                   	push   %eax
  80243b:	6a 28                	push   $0x28
  80243d:	e8 8a fa ff ff       	call   801ecc <syscall>
  802442:	83 c4 18             	add    $0x18,%esp
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80244a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80244d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802450:	8b 45 08             	mov    0x8(%ebp),%eax
  802453:	6a 00                	push   $0x0
  802455:	51                   	push   %ecx
  802456:	ff 75 10             	pushl  0x10(%ebp)
  802459:	52                   	push   %edx
  80245a:	50                   	push   %eax
  80245b:	6a 29                	push   $0x29
  80245d:	e8 6a fa ff ff       	call   801ecc <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	ff 75 10             	pushl  0x10(%ebp)
  802471:	ff 75 0c             	pushl  0xc(%ebp)
  802474:	ff 75 08             	pushl  0x8(%ebp)
  802477:	6a 12                	push   $0x12
  802479:	e8 4e fa ff ff       	call   801ecc <syscall>
  80247e:	83 c4 18             	add    $0x18,%esp
	return ;
  802481:	90                   	nop
}
  802482:	c9                   	leave  
  802483:	c3                   	ret    

00802484 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	52                   	push   %edx
  802494:	50                   	push   %eax
  802495:	6a 2a                	push   $0x2a
  802497:	e8 30 fa ff ff       	call   801ecc <syscall>
  80249c:	83 c4 18             	add    $0x18,%esp
	return;
  80249f:	90                   	nop
}
  8024a0:	c9                   	leave  
  8024a1:	c3                   	ret    

008024a2 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	50                   	push   %eax
  8024b1:	6a 2b                	push   $0x2b
  8024b3:	e8 14 fa ff ff       	call   801ecc <syscall>
  8024b8:	83 c4 18             	add    $0x18,%esp
}
  8024bb:	c9                   	leave  
  8024bc:	c3                   	ret    

008024bd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8024bd:	55                   	push   %ebp
  8024be:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	ff 75 0c             	pushl  0xc(%ebp)
  8024c9:	ff 75 08             	pushl  0x8(%ebp)
  8024cc:	6a 2c                	push   $0x2c
  8024ce:	e8 f9 f9 ff ff       	call   801ecc <syscall>
  8024d3:	83 c4 18             	add    $0x18,%esp
	return;
  8024d6:	90                   	nop
}
  8024d7:	c9                   	leave  
  8024d8:	c3                   	ret    

008024d9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	ff 75 0c             	pushl  0xc(%ebp)
  8024e5:	ff 75 08             	pushl  0x8(%ebp)
  8024e8:	6a 2d                	push   $0x2d
  8024ea:	e8 dd f9 ff ff       	call   801ecc <syscall>
  8024ef:	83 c4 18             	add    $0x18,%esp
	return;
  8024f2:	90                   	nop
}
  8024f3:	c9                   	leave  
  8024f4:	c3                   	ret    

008024f5 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
  8024f8:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8024fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fe:	83 e8 04             	sub    $0x4,%eax
  802501:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802504:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802507:	8b 00                	mov    (%eax),%eax
  802509:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80250c:	c9                   	leave  
  80250d:	c3                   	ret    

0080250e <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
  802511:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	83 e8 04             	sub    $0x4,%eax
  80251a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80251d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802520:	8b 00                	mov    (%eax),%eax
  802522:	83 e0 01             	and    $0x1,%eax
  802525:	85 c0                	test   %eax,%eax
  802527:	0f 94 c0             	sete   %al
}
  80252a:	c9                   	leave  
  80252b:	c3                   	ret    

0080252c <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
  80252f:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802532:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253c:	83 f8 02             	cmp    $0x2,%eax
  80253f:	74 2b                	je     80256c <alloc_block+0x40>
  802541:	83 f8 02             	cmp    $0x2,%eax
  802544:	7f 07                	jg     80254d <alloc_block+0x21>
  802546:	83 f8 01             	cmp    $0x1,%eax
  802549:	74 0e                	je     802559 <alloc_block+0x2d>
  80254b:	eb 58                	jmp    8025a5 <alloc_block+0x79>
  80254d:	83 f8 03             	cmp    $0x3,%eax
  802550:	74 2d                	je     80257f <alloc_block+0x53>
  802552:	83 f8 04             	cmp    $0x4,%eax
  802555:	74 3b                	je     802592 <alloc_block+0x66>
  802557:	eb 4c                	jmp    8025a5 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802559:	83 ec 0c             	sub    $0xc,%esp
  80255c:	ff 75 08             	pushl  0x8(%ebp)
  80255f:	e8 11 03 00 00       	call   802875 <alloc_block_FF>
  802564:	83 c4 10             	add    $0x10,%esp
  802567:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80256a:	eb 4a                	jmp    8025b6 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80256c:	83 ec 0c             	sub    $0xc,%esp
  80256f:	ff 75 08             	pushl  0x8(%ebp)
  802572:	e8 fa 19 00 00       	call   803f71 <alloc_block_NF>
  802577:	83 c4 10             	add    $0x10,%esp
  80257a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80257d:	eb 37                	jmp    8025b6 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80257f:	83 ec 0c             	sub    $0xc,%esp
  802582:	ff 75 08             	pushl  0x8(%ebp)
  802585:	e8 a7 07 00 00       	call   802d31 <alloc_block_BF>
  80258a:	83 c4 10             	add    $0x10,%esp
  80258d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802590:	eb 24                	jmp    8025b6 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802592:	83 ec 0c             	sub    $0xc,%esp
  802595:	ff 75 08             	pushl  0x8(%ebp)
  802598:	e8 b7 19 00 00       	call   803f54 <alloc_block_WF>
  80259d:	83 c4 10             	add    $0x10,%esp
  8025a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025a3:	eb 11                	jmp    8025b6 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8025a5:	83 ec 0c             	sub    $0xc,%esp
  8025a8:	68 4c 4a 80 00       	push   $0x804a4c
  8025ad:	e8 56 e4 ff ff       	call   800a08 <cprintf>
  8025b2:	83 c4 10             	add    $0x10,%esp
		break;
  8025b5:	90                   	nop
	}
	return va;
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8025b9:	c9                   	leave  
  8025ba:	c3                   	ret    

008025bb <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8025bb:	55                   	push   %ebp
  8025bc:	89 e5                	mov    %esp,%ebp
  8025be:	53                   	push   %ebx
  8025bf:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8025c2:	83 ec 0c             	sub    $0xc,%esp
  8025c5:	68 6c 4a 80 00       	push   $0x804a6c
  8025ca:	e8 39 e4 ff ff       	call   800a08 <cprintf>
  8025cf:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8025d2:	83 ec 0c             	sub    $0xc,%esp
  8025d5:	68 97 4a 80 00       	push   $0x804a97
  8025da:	e8 29 e4 ff ff       	call   800a08 <cprintf>
  8025df:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e8:	eb 37                	jmp    802621 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8025ea:	83 ec 0c             	sub    $0xc,%esp
  8025ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8025f0:	e8 19 ff ff ff       	call   80250e <is_free_block>
  8025f5:	83 c4 10             	add    $0x10,%esp
  8025f8:	0f be d8             	movsbl %al,%ebx
  8025fb:	83 ec 0c             	sub    $0xc,%esp
  8025fe:	ff 75 f4             	pushl  -0xc(%ebp)
  802601:	e8 ef fe ff ff       	call   8024f5 <get_block_size>
  802606:	83 c4 10             	add    $0x10,%esp
  802609:	83 ec 04             	sub    $0x4,%esp
  80260c:	53                   	push   %ebx
  80260d:	50                   	push   %eax
  80260e:	68 af 4a 80 00       	push   $0x804aaf
  802613:	e8 f0 e3 ff ff       	call   800a08 <cprintf>
  802618:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80261b:	8b 45 10             	mov    0x10(%ebp),%eax
  80261e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802625:	74 07                	je     80262e <print_blocks_list+0x73>
  802627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262a:	8b 00                	mov    (%eax),%eax
  80262c:	eb 05                	jmp    802633 <print_blocks_list+0x78>
  80262e:	b8 00 00 00 00       	mov    $0x0,%eax
  802633:	89 45 10             	mov    %eax,0x10(%ebp)
  802636:	8b 45 10             	mov    0x10(%ebp),%eax
  802639:	85 c0                	test   %eax,%eax
  80263b:	75 ad                	jne    8025ea <print_blocks_list+0x2f>
  80263d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802641:	75 a7                	jne    8025ea <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802643:	83 ec 0c             	sub    $0xc,%esp
  802646:	68 6c 4a 80 00       	push   $0x804a6c
  80264b:	e8 b8 e3 ff ff       	call   800a08 <cprintf>
  802650:	83 c4 10             	add    $0x10,%esp

}
  802653:	90                   	nop
  802654:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802657:	c9                   	leave  
  802658:	c3                   	ret    

00802659 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
  80265c:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80265f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802662:	83 e0 01             	and    $0x1,%eax
  802665:	85 c0                	test   %eax,%eax
  802667:	74 03                	je     80266c <initialize_dynamic_allocator+0x13>
  802669:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80266c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802670:	0f 84 c7 01 00 00    	je     80283d <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802676:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  80267d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802680:	8b 55 08             	mov    0x8(%ebp),%edx
  802683:	8b 45 0c             	mov    0xc(%ebp),%eax
  802686:	01 d0                	add    %edx,%eax
  802688:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80268d:	0f 87 ad 01 00 00    	ja     802840 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802693:	8b 45 08             	mov    0x8(%ebp),%eax
  802696:	85 c0                	test   %eax,%eax
  802698:	0f 89 a5 01 00 00    	jns    802843 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80269e:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a4:	01 d0                	add    %edx,%eax
  8026a6:	83 e8 04             	sub    $0x4,%eax
  8026a9:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8026ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8026b5:	a1 30 50 80 00       	mov    0x805030,%eax
  8026ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026bd:	e9 87 00 00 00       	jmp    802749 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8026c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c6:	75 14                	jne    8026dc <initialize_dynamic_allocator+0x83>
  8026c8:	83 ec 04             	sub    $0x4,%esp
  8026cb:	68 c7 4a 80 00       	push   $0x804ac7
  8026d0:	6a 79                	push   $0x79
  8026d2:	68 e5 4a 80 00       	push   $0x804ae5
  8026d7:	e8 6f e0 ff ff       	call   80074b <_panic>
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	8b 00                	mov    (%eax),%eax
  8026e1:	85 c0                	test   %eax,%eax
  8026e3:	74 10                	je     8026f5 <initialize_dynamic_allocator+0x9c>
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	8b 00                	mov    (%eax),%eax
  8026ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ed:	8b 52 04             	mov    0x4(%edx),%edx
  8026f0:	89 50 04             	mov    %edx,0x4(%eax)
  8026f3:	eb 0b                	jmp    802700 <initialize_dynamic_allocator+0xa7>
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 40 04             	mov    0x4(%eax),%eax
  8026fb:	a3 34 50 80 00       	mov    %eax,0x805034
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 40 04             	mov    0x4(%eax),%eax
  802706:	85 c0                	test   %eax,%eax
  802708:	74 0f                	je     802719 <initialize_dynamic_allocator+0xc0>
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 40 04             	mov    0x4(%eax),%eax
  802710:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802713:	8b 12                	mov    (%edx),%edx
  802715:	89 10                	mov    %edx,(%eax)
  802717:	eb 0a                	jmp    802723 <initialize_dynamic_allocator+0xca>
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 00                	mov    (%eax),%eax
  80271e:	a3 30 50 80 00       	mov    %eax,0x805030
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802736:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80273b:	48                   	dec    %eax
  80273c:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802741:	a1 38 50 80 00       	mov    0x805038,%eax
  802746:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802749:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274d:	74 07                	je     802756 <initialize_dynamic_allocator+0xfd>
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	eb 05                	jmp    80275b <initialize_dynamic_allocator+0x102>
  802756:	b8 00 00 00 00       	mov    $0x0,%eax
  80275b:	a3 38 50 80 00       	mov    %eax,0x805038
  802760:	a1 38 50 80 00       	mov    0x805038,%eax
  802765:	85 c0                	test   %eax,%eax
  802767:	0f 85 55 ff ff ff    	jne    8026c2 <initialize_dynamic_allocator+0x69>
  80276d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802771:	0f 85 4b ff ff ff    	jne    8026c2 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80277d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802780:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802786:	a1 48 50 80 00       	mov    0x805048,%eax
  80278b:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802790:	a1 44 50 80 00       	mov    0x805044,%eax
  802795:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80279b:	8b 45 08             	mov    0x8(%ebp),%eax
  80279e:	83 c0 08             	add    $0x8,%eax
  8027a1:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a7:	83 c0 04             	add    $0x4,%eax
  8027aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027ad:	83 ea 08             	sub    $0x8,%edx
  8027b0:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b8:	01 d0                	add    %edx,%eax
  8027ba:	83 e8 08             	sub    $0x8,%eax
  8027bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c0:	83 ea 08             	sub    $0x8,%edx
  8027c3:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8027c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8027ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8027d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027dc:	75 17                	jne    8027f5 <initialize_dynamic_allocator+0x19c>
  8027de:	83 ec 04             	sub    $0x4,%esp
  8027e1:	68 00 4b 80 00       	push   $0x804b00
  8027e6:	68 90 00 00 00       	push   $0x90
  8027eb:	68 e5 4a 80 00       	push   $0x804ae5
  8027f0:	e8 56 df ff ff       	call   80074b <_panic>
  8027f5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8027fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fe:	89 10                	mov    %edx,(%eax)
  802800:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802803:	8b 00                	mov    (%eax),%eax
  802805:	85 c0                	test   %eax,%eax
  802807:	74 0d                	je     802816 <initialize_dynamic_allocator+0x1bd>
  802809:	a1 30 50 80 00       	mov    0x805030,%eax
  80280e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802811:	89 50 04             	mov    %edx,0x4(%eax)
  802814:	eb 08                	jmp    80281e <initialize_dynamic_allocator+0x1c5>
  802816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802819:	a3 34 50 80 00       	mov    %eax,0x805034
  80281e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802821:	a3 30 50 80 00       	mov    %eax,0x805030
  802826:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802829:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802830:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802835:	40                   	inc    %eax
  802836:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80283b:	eb 07                	jmp    802844 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80283d:	90                   	nop
  80283e:	eb 04                	jmp    802844 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802840:	90                   	nop
  802841:	eb 01                	jmp    802844 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802843:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802849:	8b 45 10             	mov    0x10(%ebp),%eax
  80284c:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80284f:	8b 45 08             	mov    0x8(%ebp),%eax
  802852:	8d 50 fc             	lea    -0x4(%eax),%edx
  802855:	8b 45 0c             	mov    0xc(%ebp),%eax
  802858:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80285a:	8b 45 08             	mov    0x8(%ebp),%eax
  80285d:	83 e8 04             	sub    $0x4,%eax
  802860:	8b 00                	mov    (%eax),%eax
  802862:	83 e0 fe             	and    $0xfffffffe,%eax
  802865:	8d 50 f8             	lea    -0x8(%eax),%edx
  802868:	8b 45 08             	mov    0x8(%ebp),%eax
  80286b:	01 c2                	add    %eax,%edx
  80286d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802870:	89 02                	mov    %eax,(%edx)
}
  802872:	90                   	nop
  802873:	5d                   	pop    %ebp
  802874:	c3                   	ret    

00802875 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
  802878:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80287b:	8b 45 08             	mov    0x8(%ebp),%eax
  80287e:	83 e0 01             	and    $0x1,%eax
  802881:	85 c0                	test   %eax,%eax
  802883:	74 03                	je     802888 <alloc_block_FF+0x13>
  802885:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802888:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80288c:	77 07                	ja     802895 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80288e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802895:	a1 28 50 80 00       	mov    0x805028,%eax
  80289a:	85 c0                	test   %eax,%eax
  80289c:	75 73                	jne    802911 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80289e:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a1:	83 c0 10             	add    $0x10,%eax
  8028a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028a7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8028ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b4:	01 d0                	add    %edx,%eax
  8028b6:	48                   	dec    %eax
  8028b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8028ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c2:	f7 75 ec             	divl   -0x14(%ebp)
  8028c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c8:	29 d0                	sub    %edx,%eax
  8028ca:	c1 e8 0c             	shr    $0xc,%eax
  8028cd:	83 ec 0c             	sub    $0xc,%esp
  8028d0:	50                   	push   %eax
  8028d1:	e8 d4 f0 ff ff       	call   8019aa <sbrk>
  8028d6:	83 c4 10             	add    $0x10,%esp
  8028d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028dc:	83 ec 0c             	sub    $0xc,%esp
  8028df:	6a 00                	push   $0x0
  8028e1:	e8 c4 f0 ff ff       	call   8019aa <sbrk>
  8028e6:	83 c4 10             	add    $0x10,%esp
  8028e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8028ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ef:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8028f2:	83 ec 08             	sub    $0x8,%esp
  8028f5:	50                   	push   %eax
  8028f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8028f9:	e8 5b fd ff ff       	call   802659 <initialize_dynamic_allocator>
  8028fe:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802901:	83 ec 0c             	sub    $0xc,%esp
  802904:	68 23 4b 80 00       	push   $0x804b23
  802909:	e8 fa e0 ff ff       	call   800a08 <cprintf>
  80290e:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802911:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802915:	75 0a                	jne    802921 <alloc_block_FF+0xac>
	        return NULL;
  802917:	b8 00 00 00 00       	mov    $0x0,%eax
  80291c:	e9 0e 04 00 00       	jmp    802d2f <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802921:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802928:	a1 30 50 80 00       	mov    0x805030,%eax
  80292d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802930:	e9 f3 02 00 00       	jmp    802c28 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80293b:	83 ec 0c             	sub    $0xc,%esp
  80293e:	ff 75 bc             	pushl  -0x44(%ebp)
  802941:	e8 af fb ff ff       	call   8024f5 <get_block_size>
  802946:	83 c4 10             	add    $0x10,%esp
  802949:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	83 c0 08             	add    $0x8,%eax
  802952:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802955:	0f 87 c5 02 00 00    	ja     802c20 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80295b:	8b 45 08             	mov    0x8(%ebp),%eax
  80295e:	83 c0 18             	add    $0x18,%eax
  802961:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802964:	0f 87 19 02 00 00    	ja     802b83 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80296a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80296d:	2b 45 08             	sub    0x8(%ebp),%eax
  802970:	83 e8 08             	sub    $0x8,%eax
  802973:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	8d 50 08             	lea    0x8(%eax),%edx
  80297c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80297f:	01 d0                	add    %edx,%eax
  802981:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802984:	8b 45 08             	mov    0x8(%ebp),%eax
  802987:	83 c0 08             	add    $0x8,%eax
  80298a:	83 ec 04             	sub    $0x4,%esp
  80298d:	6a 01                	push   $0x1
  80298f:	50                   	push   %eax
  802990:	ff 75 bc             	pushl  -0x44(%ebp)
  802993:	e8 ae fe ff ff       	call   802846 <set_block_data>
  802998:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	8b 40 04             	mov    0x4(%eax),%eax
  8029a1:	85 c0                	test   %eax,%eax
  8029a3:	75 68                	jne    802a0d <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029a5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029a9:	75 17                	jne    8029c2 <alloc_block_FF+0x14d>
  8029ab:	83 ec 04             	sub    $0x4,%esp
  8029ae:	68 00 4b 80 00       	push   $0x804b00
  8029b3:	68 d7 00 00 00       	push   $0xd7
  8029b8:	68 e5 4a 80 00       	push   $0x804ae5
  8029bd:	e8 89 dd ff ff       	call   80074b <_panic>
  8029c2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029cb:	89 10                	mov    %edx,(%eax)
  8029cd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	85 c0                	test   %eax,%eax
  8029d4:	74 0d                	je     8029e3 <alloc_block_FF+0x16e>
  8029d6:	a1 30 50 80 00       	mov    0x805030,%eax
  8029db:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029de:	89 50 04             	mov    %edx,0x4(%eax)
  8029e1:	eb 08                	jmp    8029eb <alloc_block_FF+0x176>
  8029e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029e6:	a3 34 50 80 00       	mov    %eax,0x805034
  8029eb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8029f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a02:	40                   	inc    %eax
  802a03:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a08:	e9 dc 00 00 00       	jmp    802ae9 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	85 c0                	test   %eax,%eax
  802a14:	75 65                	jne    802a7b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a16:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a1a:	75 17                	jne    802a33 <alloc_block_FF+0x1be>
  802a1c:	83 ec 04             	sub    $0x4,%esp
  802a1f:	68 34 4b 80 00       	push   $0x804b34
  802a24:	68 db 00 00 00       	push   $0xdb
  802a29:	68 e5 4a 80 00       	push   $0x804ae5
  802a2e:	e8 18 dd ff ff       	call   80074b <_panic>
  802a33:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802a39:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a3c:	89 50 04             	mov    %edx,0x4(%eax)
  802a3f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a42:	8b 40 04             	mov    0x4(%eax),%eax
  802a45:	85 c0                	test   %eax,%eax
  802a47:	74 0c                	je     802a55 <alloc_block_FF+0x1e0>
  802a49:	a1 34 50 80 00       	mov    0x805034,%eax
  802a4e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a51:	89 10                	mov    %edx,(%eax)
  802a53:	eb 08                	jmp    802a5d <alloc_block_FF+0x1e8>
  802a55:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a58:	a3 30 50 80 00       	mov    %eax,0x805030
  802a5d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a60:	a3 34 50 80 00       	mov    %eax,0x805034
  802a65:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a73:	40                   	inc    %eax
  802a74:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a79:	eb 6e                	jmp    802ae9 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802a7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7f:	74 06                	je     802a87 <alloc_block_FF+0x212>
  802a81:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a85:	75 17                	jne    802a9e <alloc_block_FF+0x229>
  802a87:	83 ec 04             	sub    $0x4,%esp
  802a8a:	68 58 4b 80 00       	push   $0x804b58
  802a8f:	68 df 00 00 00       	push   $0xdf
  802a94:	68 e5 4a 80 00       	push   $0x804ae5
  802a99:	e8 ad dc ff ff       	call   80074b <_panic>
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 10                	mov    (%eax),%edx
  802aa3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aa6:	89 10                	mov    %edx,(%eax)
  802aa8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aab:	8b 00                	mov    (%eax),%eax
  802aad:	85 c0                	test   %eax,%eax
  802aaf:	74 0b                	je     802abc <alloc_block_FF+0x247>
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 00                	mov    (%eax),%eax
  802ab6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ab9:	89 50 04             	mov    %edx,0x4(%eax)
  802abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abf:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ac2:	89 10                	mov    %edx,(%eax)
  802ac4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aca:	89 50 04             	mov    %edx,0x4(%eax)
  802acd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	75 08                	jne    802ade <alloc_block_FF+0x269>
  802ad6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ad9:	a3 34 50 80 00       	mov    %eax,0x805034
  802ade:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ae3:	40                   	inc    %eax
  802ae4:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802ae9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aed:	75 17                	jne    802b06 <alloc_block_FF+0x291>
  802aef:	83 ec 04             	sub    $0x4,%esp
  802af2:	68 c7 4a 80 00       	push   $0x804ac7
  802af7:	68 e1 00 00 00       	push   $0xe1
  802afc:	68 e5 4a 80 00       	push   $0x804ae5
  802b01:	e8 45 dc ff ff       	call   80074b <_panic>
  802b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b09:	8b 00                	mov    (%eax),%eax
  802b0b:	85 c0                	test   %eax,%eax
  802b0d:	74 10                	je     802b1f <alloc_block_FF+0x2aa>
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 00                	mov    (%eax),%eax
  802b14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b17:	8b 52 04             	mov    0x4(%edx),%edx
  802b1a:	89 50 04             	mov    %edx,0x4(%eax)
  802b1d:	eb 0b                	jmp    802b2a <alloc_block_FF+0x2b5>
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 40 04             	mov    0x4(%eax),%eax
  802b25:	a3 34 50 80 00       	mov    %eax,0x805034
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	8b 40 04             	mov    0x4(%eax),%eax
  802b30:	85 c0                	test   %eax,%eax
  802b32:	74 0f                	je     802b43 <alloc_block_FF+0x2ce>
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	8b 40 04             	mov    0x4(%eax),%eax
  802b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3d:	8b 12                	mov    (%edx),%edx
  802b3f:	89 10                	mov    %edx,(%eax)
  802b41:	eb 0a                	jmp    802b4d <alloc_block_FF+0x2d8>
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	8b 00                	mov    (%eax),%eax
  802b48:	a3 30 50 80 00       	mov    %eax,0x805030
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b60:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b65:	48                   	dec    %eax
  802b66:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802b6b:	83 ec 04             	sub    $0x4,%esp
  802b6e:	6a 00                	push   $0x0
  802b70:	ff 75 b4             	pushl  -0x4c(%ebp)
  802b73:	ff 75 b0             	pushl  -0x50(%ebp)
  802b76:	e8 cb fc ff ff       	call   802846 <set_block_data>
  802b7b:	83 c4 10             	add    $0x10,%esp
  802b7e:	e9 95 00 00 00       	jmp    802c18 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802b83:	83 ec 04             	sub    $0x4,%esp
  802b86:	6a 01                	push   $0x1
  802b88:	ff 75 b8             	pushl  -0x48(%ebp)
  802b8b:	ff 75 bc             	pushl  -0x44(%ebp)
  802b8e:	e8 b3 fc ff ff       	call   802846 <set_block_data>
  802b93:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802b96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9a:	75 17                	jne    802bb3 <alloc_block_FF+0x33e>
  802b9c:	83 ec 04             	sub    $0x4,%esp
  802b9f:	68 c7 4a 80 00       	push   $0x804ac7
  802ba4:	68 e8 00 00 00       	push   $0xe8
  802ba9:	68 e5 4a 80 00       	push   $0x804ae5
  802bae:	e8 98 db ff ff       	call   80074b <_panic>
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	74 10                	je     802bcc <alloc_block_FF+0x357>
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc4:	8b 52 04             	mov    0x4(%edx),%edx
  802bc7:	89 50 04             	mov    %edx,0x4(%eax)
  802bca:	eb 0b                	jmp    802bd7 <alloc_block_FF+0x362>
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 40 04             	mov    0x4(%eax),%eax
  802bd2:	a3 34 50 80 00       	mov    %eax,0x805034
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 40 04             	mov    0x4(%eax),%eax
  802bdd:	85 c0                	test   %eax,%eax
  802bdf:	74 0f                	je     802bf0 <alloc_block_FF+0x37b>
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	8b 40 04             	mov    0x4(%eax),%eax
  802be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bea:	8b 12                	mov    (%edx),%edx
  802bec:	89 10                	mov    %edx,(%eax)
  802bee:	eb 0a                	jmp    802bfa <alloc_block_FF+0x385>
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
	            }
	            return va;
  802c18:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c1b:	e9 0f 01 00 00       	jmp    802d2f <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c20:	a1 38 50 80 00       	mov    0x805038,%eax
  802c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2c:	74 07                	je     802c35 <alloc_block_FF+0x3c0>
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	8b 00                	mov    (%eax),%eax
  802c33:	eb 05                	jmp    802c3a <alloc_block_FF+0x3c5>
  802c35:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3a:	a3 38 50 80 00       	mov    %eax,0x805038
  802c3f:	a1 38 50 80 00       	mov    0x805038,%eax
  802c44:	85 c0                	test   %eax,%eax
  802c46:	0f 85 e9 fc ff ff    	jne    802935 <alloc_block_FF+0xc0>
  802c4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c50:	0f 85 df fc ff ff    	jne    802935 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	83 c0 08             	add    $0x8,%eax
  802c5c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c5f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802c66:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c6c:	01 d0                	add    %edx,%eax
  802c6e:	48                   	dec    %eax
  802c6f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802c72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c75:	ba 00 00 00 00       	mov    $0x0,%edx
  802c7a:	f7 75 d8             	divl   -0x28(%ebp)
  802c7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c80:	29 d0                	sub    %edx,%eax
  802c82:	c1 e8 0c             	shr    $0xc,%eax
  802c85:	83 ec 0c             	sub    $0xc,%esp
  802c88:	50                   	push   %eax
  802c89:	e8 1c ed ff ff       	call   8019aa <sbrk>
  802c8e:	83 c4 10             	add    $0x10,%esp
  802c91:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802c94:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802c98:	75 0a                	jne    802ca4 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9f:	e9 8b 00 00 00       	jmp    802d2f <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ca4:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802cab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cb1:	01 d0                	add    %edx,%eax
  802cb3:	48                   	dec    %eax
  802cb4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802cb7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802cba:	ba 00 00 00 00       	mov    $0x0,%edx
  802cbf:	f7 75 cc             	divl   -0x34(%ebp)
  802cc2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802cc5:	29 d0                	sub    %edx,%eax
  802cc7:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ccd:	01 d0                	add    %edx,%eax
  802ccf:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802cd4:	a1 44 50 80 00       	mov    0x805044,%eax
  802cd9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802cdf:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ce6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ce9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cec:	01 d0                	add    %edx,%eax
  802cee:	48                   	dec    %eax
  802cef:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cf2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cf5:	ba 00 00 00 00       	mov    $0x0,%edx
  802cfa:	f7 75 c4             	divl   -0x3c(%ebp)
  802cfd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d00:	29 d0                	sub    %edx,%eax
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	6a 01                	push   $0x1
  802d07:	50                   	push   %eax
  802d08:	ff 75 d0             	pushl  -0x30(%ebp)
  802d0b:	e8 36 fb ff ff       	call   802846 <set_block_data>
  802d10:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802d13:	83 ec 0c             	sub    $0xc,%esp
  802d16:	ff 75 d0             	pushl  -0x30(%ebp)
  802d19:	e8 1b 0a 00 00       	call   803739 <free_block>
  802d1e:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802d21:	83 ec 0c             	sub    $0xc,%esp
  802d24:	ff 75 08             	pushl  0x8(%ebp)
  802d27:	e8 49 fb ff ff       	call   802875 <alloc_block_FF>
  802d2c:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802d2f:	c9                   	leave  
  802d30:	c3                   	ret    

00802d31 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802d31:	55                   	push   %ebp
  802d32:	89 e5                	mov    %esp,%ebp
  802d34:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	83 e0 01             	and    $0x1,%eax
  802d3d:	85 c0                	test   %eax,%eax
  802d3f:	74 03                	je     802d44 <alloc_block_BF+0x13>
  802d41:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802d44:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802d48:	77 07                	ja     802d51 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802d4a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802d51:	a1 28 50 80 00       	mov    0x805028,%eax
  802d56:	85 c0                	test   %eax,%eax
  802d58:	75 73                	jne    802dcd <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	83 c0 10             	add    $0x10,%eax
  802d60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802d63:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802d6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d70:	01 d0                	add    %edx,%eax
  802d72:	48                   	dec    %eax
  802d73:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d79:	ba 00 00 00 00       	mov    $0x0,%edx
  802d7e:	f7 75 e0             	divl   -0x20(%ebp)
  802d81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d84:	29 d0                	sub    %edx,%eax
  802d86:	c1 e8 0c             	shr    $0xc,%eax
  802d89:	83 ec 0c             	sub    $0xc,%esp
  802d8c:	50                   	push   %eax
  802d8d:	e8 18 ec ff ff       	call   8019aa <sbrk>
  802d92:	83 c4 10             	add    $0x10,%esp
  802d95:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802d98:	83 ec 0c             	sub    $0xc,%esp
  802d9b:	6a 00                	push   $0x0
  802d9d:	e8 08 ec ff ff       	call   8019aa <sbrk>
  802da2:	83 c4 10             	add    $0x10,%esp
  802da5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802da8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dab:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802dae:	83 ec 08             	sub    $0x8,%esp
  802db1:	50                   	push   %eax
  802db2:	ff 75 d8             	pushl  -0x28(%ebp)
  802db5:	e8 9f f8 ff ff       	call   802659 <initialize_dynamic_allocator>
  802dba:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802dbd:	83 ec 0c             	sub    $0xc,%esp
  802dc0:	68 23 4b 80 00       	push   $0x804b23
  802dc5:	e8 3e dc ff ff       	call   800a08 <cprintf>
  802dca:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802dcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802dd4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802ddb:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802de2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802de9:	a1 30 50 80 00       	mov    0x805030,%eax
  802dee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df1:	e9 1d 01 00 00       	jmp    802f13 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802dfc:	83 ec 0c             	sub    $0xc,%esp
  802dff:	ff 75 a8             	pushl  -0x58(%ebp)
  802e02:	e8 ee f6 ff ff       	call   8024f5 <get_block_size>
  802e07:	83 c4 10             	add    $0x10,%esp
  802e0a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	83 c0 08             	add    $0x8,%eax
  802e13:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e16:	0f 87 ef 00 00 00    	ja     802f0b <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1f:	83 c0 18             	add    $0x18,%eax
  802e22:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e25:	77 1d                	ja     802e44 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802e27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e2d:	0f 86 d8 00 00 00    	jbe    802f0b <alloc_block_BF+0x1da>
				{
					best_va = va;
  802e33:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e36:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802e39:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e3f:	e9 c7 00 00 00       	jmp    802f0b <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802e44:	8b 45 08             	mov    0x8(%ebp),%eax
  802e47:	83 c0 08             	add    $0x8,%eax
  802e4a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e4d:	0f 85 9d 00 00 00    	jne    802ef0 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802e53:	83 ec 04             	sub    $0x4,%esp
  802e56:	6a 01                	push   $0x1
  802e58:	ff 75 a4             	pushl  -0x5c(%ebp)
  802e5b:	ff 75 a8             	pushl  -0x58(%ebp)
  802e5e:	e8 e3 f9 ff ff       	call   802846 <set_block_data>
  802e63:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802e66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6a:	75 17                	jne    802e83 <alloc_block_BF+0x152>
  802e6c:	83 ec 04             	sub    $0x4,%esp
  802e6f:	68 c7 4a 80 00       	push   $0x804ac7
  802e74:	68 2c 01 00 00       	push   $0x12c
  802e79:	68 e5 4a 80 00       	push   $0x804ae5
  802e7e:	e8 c8 d8 ff ff       	call   80074b <_panic>
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	85 c0                	test   %eax,%eax
  802e8a:	74 10                	je     802e9c <alloc_block_BF+0x16b>
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	8b 00                	mov    (%eax),%eax
  802e91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e94:	8b 52 04             	mov    0x4(%edx),%edx
  802e97:	89 50 04             	mov    %edx,0x4(%eax)
  802e9a:	eb 0b                	jmp    802ea7 <alloc_block_BF+0x176>
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ea2:	a3 34 50 80 00       	mov    %eax,0x805034
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 40 04             	mov    0x4(%eax),%eax
  802ead:	85 c0                	test   %eax,%eax
  802eaf:	74 0f                	je     802ec0 <alloc_block_BF+0x18f>
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	8b 40 04             	mov    0x4(%eax),%eax
  802eb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eba:	8b 12                	mov    (%edx),%edx
  802ebc:	89 10                	mov    %edx,(%eax)
  802ebe:	eb 0a                	jmp    802eca <alloc_block_BF+0x199>
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	8b 00                	mov    (%eax),%eax
  802ec5:	a3 30 50 80 00       	mov    %eax,0x805030
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802edd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ee2:	48                   	dec    %eax
  802ee3:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802ee8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802eeb:	e9 24 04 00 00       	jmp    803314 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802ef0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ef6:	76 13                	jbe    802f0b <alloc_block_BF+0x1da>
					{
						internal = 1;
  802ef8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802eff:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802f05:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f08:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802f0b:	a1 38 50 80 00       	mov    0x805038,%eax
  802f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f17:	74 07                	je     802f20 <alloc_block_BF+0x1ef>
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	8b 00                	mov    (%eax),%eax
  802f1e:	eb 05                	jmp    802f25 <alloc_block_BF+0x1f4>
  802f20:	b8 00 00 00 00       	mov    $0x0,%eax
  802f25:	a3 38 50 80 00       	mov    %eax,0x805038
  802f2a:	a1 38 50 80 00       	mov    0x805038,%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	0f 85 bf fe ff ff    	jne    802df6 <alloc_block_BF+0xc5>
  802f37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3b:	0f 85 b5 fe ff ff    	jne    802df6 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802f41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f45:	0f 84 26 02 00 00    	je     803171 <alloc_block_BF+0x440>
  802f4b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f4f:	0f 85 1c 02 00 00    	jne    803171 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802f55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f58:	2b 45 08             	sub    0x8(%ebp),%eax
  802f5b:	83 e8 08             	sub    $0x8,%eax
  802f5e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802f61:	8b 45 08             	mov    0x8(%ebp),%eax
  802f64:	8d 50 08             	lea    0x8(%eax),%edx
  802f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6a:	01 d0                	add    %edx,%eax
  802f6c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	83 c0 08             	add    $0x8,%eax
  802f75:	83 ec 04             	sub    $0x4,%esp
  802f78:	6a 01                	push   $0x1
  802f7a:	50                   	push   %eax
  802f7b:	ff 75 f0             	pushl  -0x10(%ebp)
  802f7e:	e8 c3 f8 ff ff       	call   802846 <set_block_data>
  802f83:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f89:	8b 40 04             	mov    0x4(%eax),%eax
  802f8c:	85 c0                	test   %eax,%eax
  802f8e:	75 68                	jne    802ff8 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f90:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f94:	75 17                	jne    802fad <alloc_block_BF+0x27c>
  802f96:	83 ec 04             	sub    $0x4,%esp
  802f99:	68 00 4b 80 00       	push   $0x804b00
  802f9e:	68 45 01 00 00       	push   $0x145
  802fa3:	68 e5 4a 80 00       	push   $0x804ae5
  802fa8:	e8 9e d7 ff ff       	call   80074b <_panic>
  802fad:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fb3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fb6:	89 10                	mov    %edx,(%eax)
  802fb8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fbb:	8b 00                	mov    (%eax),%eax
  802fbd:	85 c0                	test   %eax,%eax
  802fbf:	74 0d                	je     802fce <alloc_block_BF+0x29d>
  802fc1:	a1 30 50 80 00       	mov    0x805030,%eax
  802fc6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fc9:	89 50 04             	mov    %edx,0x4(%eax)
  802fcc:	eb 08                	jmp    802fd6 <alloc_block_BF+0x2a5>
  802fce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fd1:	a3 34 50 80 00       	mov    %eax,0x805034
  802fd6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fd9:	a3 30 50 80 00       	mov    %eax,0x805030
  802fde:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fe1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fed:	40                   	inc    %eax
  802fee:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ff3:	e9 dc 00 00 00       	jmp    8030d4 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffb:	8b 00                	mov    (%eax),%eax
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	75 65                	jne    803066 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803001:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803005:	75 17                	jne    80301e <alloc_block_BF+0x2ed>
  803007:	83 ec 04             	sub    $0x4,%esp
  80300a:	68 34 4b 80 00       	push   $0x804b34
  80300f:	68 4a 01 00 00       	push   $0x14a
  803014:	68 e5 4a 80 00       	push   $0x804ae5
  803019:	e8 2d d7 ff ff       	call   80074b <_panic>
  80301e:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803024:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803027:	89 50 04             	mov    %edx,0x4(%eax)
  80302a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80302d:	8b 40 04             	mov    0x4(%eax),%eax
  803030:	85 c0                	test   %eax,%eax
  803032:	74 0c                	je     803040 <alloc_block_BF+0x30f>
  803034:	a1 34 50 80 00       	mov    0x805034,%eax
  803039:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80303c:	89 10                	mov    %edx,(%eax)
  80303e:	eb 08                	jmp    803048 <alloc_block_BF+0x317>
  803040:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803043:	a3 30 50 80 00       	mov    %eax,0x805030
  803048:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80304b:	a3 34 50 80 00       	mov    %eax,0x805034
  803050:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803053:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803059:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80305e:	40                   	inc    %eax
  80305f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803064:	eb 6e                	jmp    8030d4 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803066:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80306a:	74 06                	je     803072 <alloc_block_BF+0x341>
  80306c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803070:	75 17                	jne    803089 <alloc_block_BF+0x358>
  803072:	83 ec 04             	sub    $0x4,%esp
  803075:	68 58 4b 80 00       	push   $0x804b58
  80307a:	68 4f 01 00 00       	push   $0x14f
  80307f:	68 e5 4a 80 00       	push   $0x804ae5
  803084:	e8 c2 d6 ff ff       	call   80074b <_panic>
  803089:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308c:	8b 10                	mov    (%eax),%edx
  80308e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803091:	89 10                	mov    %edx,(%eax)
  803093:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803096:	8b 00                	mov    (%eax),%eax
  803098:	85 c0                	test   %eax,%eax
  80309a:	74 0b                	je     8030a7 <alloc_block_BF+0x376>
  80309c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309f:	8b 00                	mov    (%eax),%eax
  8030a1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030a4:	89 50 04             	mov    %edx,0x4(%eax)
  8030a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030aa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030ad:	89 10                	mov    %edx,(%eax)
  8030af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030b5:	89 50 04             	mov    %edx,0x4(%eax)
  8030b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030bb:	8b 00                	mov    (%eax),%eax
  8030bd:	85 c0                	test   %eax,%eax
  8030bf:	75 08                	jne    8030c9 <alloc_block_BF+0x398>
  8030c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c4:	a3 34 50 80 00       	mov    %eax,0x805034
  8030c9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030ce:	40                   	inc    %eax
  8030cf:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8030d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030d8:	75 17                	jne    8030f1 <alloc_block_BF+0x3c0>
  8030da:	83 ec 04             	sub    $0x4,%esp
  8030dd:	68 c7 4a 80 00       	push   $0x804ac7
  8030e2:	68 51 01 00 00       	push   $0x151
  8030e7:	68 e5 4a 80 00       	push   $0x804ae5
  8030ec:	e8 5a d6 ff ff       	call   80074b <_panic>
  8030f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f4:	8b 00                	mov    (%eax),%eax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	74 10                	je     80310a <alloc_block_BF+0x3d9>
  8030fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fd:	8b 00                	mov    (%eax),%eax
  8030ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803102:	8b 52 04             	mov    0x4(%edx),%edx
  803105:	89 50 04             	mov    %edx,0x4(%eax)
  803108:	eb 0b                	jmp    803115 <alloc_block_BF+0x3e4>
  80310a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310d:	8b 40 04             	mov    0x4(%eax),%eax
  803110:	a3 34 50 80 00       	mov    %eax,0x805034
  803115:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803118:	8b 40 04             	mov    0x4(%eax),%eax
  80311b:	85 c0                	test   %eax,%eax
  80311d:	74 0f                	je     80312e <alloc_block_BF+0x3fd>
  80311f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803122:	8b 40 04             	mov    0x4(%eax),%eax
  803125:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803128:	8b 12                	mov    (%edx),%edx
  80312a:	89 10                	mov    %edx,(%eax)
  80312c:	eb 0a                	jmp    803138 <alloc_block_BF+0x407>
  80312e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803131:	8b 00                	mov    (%eax),%eax
  803133:	a3 30 50 80 00       	mov    %eax,0x805030
  803138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803141:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803144:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803150:	48                   	dec    %eax
  803151:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  803156:	83 ec 04             	sub    $0x4,%esp
  803159:	6a 00                	push   $0x0
  80315b:	ff 75 d0             	pushl  -0x30(%ebp)
  80315e:	ff 75 cc             	pushl  -0x34(%ebp)
  803161:	e8 e0 f6 ff ff       	call   802846 <set_block_data>
  803166:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803169:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316c:	e9 a3 01 00 00       	jmp    803314 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803171:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803175:	0f 85 9d 00 00 00    	jne    803218 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80317b:	83 ec 04             	sub    $0x4,%esp
  80317e:	6a 01                	push   $0x1
  803180:	ff 75 ec             	pushl  -0x14(%ebp)
  803183:	ff 75 f0             	pushl  -0x10(%ebp)
  803186:	e8 bb f6 ff ff       	call   802846 <set_block_data>
  80318b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80318e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803192:	75 17                	jne    8031ab <alloc_block_BF+0x47a>
  803194:	83 ec 04             	sub    $0x4,%esp
  803197:	68 c7 4a 80 00       	push   $0x804ac7
  80319c:	68 58 01 00 00       	push   $0x158
  8031a1:	68 e5 4a 80 00       	push   $0x804ae5
  8031a6:	e8 a0 d5 ff ff       	call   80074b <_panic>
  8031ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ae:	8b 00                	mov    (%eax),%eax
  8031b0:	85 c0                	test   %eax,%eax
  8031b2:	74 10                	je     8031c4 <alloc_block_BF+0x493>
  8031b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b7:	8b 00                	mov    (%eax),%eax
  8031b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031bc:	8b 52 04             	mov    0x4(%edx),%edx
  8031bf:	89 50 04             	mov    %edx,0x4(%eax)
  8031c2:	eb 0b                	jmp    8031cf <alloc_block_BF+0x49e>
  8031c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ca:	a3 34 50 80 00       	mov    %eax,0x805034
  8031cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d2:	8b 40 04             	mov    0x4(%eax),%eax
  8031d5:	85 c0                	test   %eax,%eax
  8031d7:	74 0f                	je     8031e8 <alloc_block_BF+0x4b7>
  8031d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031dc:	8b 40 04             	mov    0x4(%eax),%eax
  8031df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031e2:	8b 12                	mov    (%edx),%edx
  8031e4:	89 10                	mov    %edx,(%eax)
  8031e6:	eb 0a                	jmp    8031f2 <alloc_block_BF+0x4c1>
  8031e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031eb:	8b 00                	mov    (%eax),%eax
  8031ed:	a3 30 50 80 00       	mov    %eax,0x805030
  8031f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803205:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80320a:	48                   	dec    %eax
  80320b:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  803210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803213:	e9 fc 00 00 00       	jmp    803314 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803218:	8b 45 08             	mov    0x8(%ebp),%eax
  80321b:	83 c0 08             	add    $0x8,%eax
  80321e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803221:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803228:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80322b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80322e:	01 d0                	add    %edx,%eax
  803230:	48                   	dec    %eax
  803231:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803234:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803237:	ba 00 00 00 00       	mov    $0x0,%edx
  80323c:	f7 75 c4             	divl   -0x3c(%ebp)
  80323f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803242:	29 d0                	sub    %edx,%eax
  803244:	c1 e8 0c             	shr    $0xc,%eax
  803247:	83 ec 0c             	sub    $0xc,%esp
  80324a:	50                   	push   %eax
  80324b:	e8 5a e7 ff ff       	call   8019aa <sbrk>
  803250:	83 c4 10             	add    $0x10,%esp
  803253:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803256:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80325a:	75 0a                	jne    803266 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80325c:	b8 00 00 00 00       	mov    $0x0,%eax
  803261:	e9 ae 00 00 00       	jmp    803314 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803266:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80326d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803270:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803273:	01 d0                	add    %edx,%eax
  803275:	48                   	dec    %eax
  803276:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803279:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80327c:	ba 00 00 00 00       	mov    $0x0,%edx
  803281:	f7 75 b8             	divl   -0x48(%ebp)
  803284:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803287:	29 d0                	sub    %edx,%eax
  803289:	8d 50 fc             	lea    -0x4(%eax),%edx
  80328c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80328f:	01 d0                	add    %edx,%eax
  803291:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  803296:	a1 44 50 80 00       	mov    0x805044,%eax
  80329b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8032a1:	83 ec 0c             	sub    $0xc,%esp
  8032a4:	68 8c 4b 80 00       	push   $0x804b8c
  8032a9:	e8 5a d7 ff ff       	call   800a08 <cprintf>
  8032ae:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8032b1:	83 ec 08             	sub    $0x8,%esp
  8032b4:	ff 75 bc             	pushl  -0x44(%ebp)
  8032b7:	68 91 4b 80 00       	push   $0x804b91
  8032bc:	e8 47 d7 ff ff       	call   800a08 <cprintf>
  8032c1:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8032c4:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8032cb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032d1:	01 d0                	add    %edx,%eax
  8032d3:	48                   	dec    %eax
  8032d4:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8032d7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8032da:	ba 00 00 00 00       	mov    $0x0,%edx
  8032df:	f7 75 b0             	divl   -0x50(%ebp)
  8032e2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8032e5:	29 d0                	sub    %edx,%eax
  8032e7:	83 ec 04             	sub    $0x4,%esp
  8032ea:	6a 01                	push   $0x1
  8032ec:	50                   	push   %eax
  8032ed:	ff 75 bc             	pushl  -0x44(%ebp)
  8032f0:	e8 51 f5 ff ff       	call   802846 <set_block_data>
  8032f5:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8032f8:	83 ec 0c             	sub    $0xc,%esp
  8032fb:	ff 75 bc             	pushl  -0x44(%ebp)
  8032fe:	e8 36 04 00 00       	call   803739 <free_block>
  803303:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803306:	83 ec 0c             	sub    $0xc,%esp
  803309:	ff 75 08             	pushl  0x8(%ebp)
  80330c:	e8 20 fa ff ff       	call   802d31 <alloc_block_BF>
  803311:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803314:	c9                   	leave  
  803315:	c3                   	ret    

00803316 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803316:	55                   	push   %ebp
  803317:	89 e5                	mov    %esp,%ebp
  803319:	53                   	push   %ebx
  80331a:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80331d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803324:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80332b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80332f:	74 1e                	je     80334f <merging+0x39>
  803331:	ff 75 08             	pushl  0x8(%ebp)
  803334:	e8 bc f1 ff ff       	call   8024f5 <get_block_size>
  803339:	83 c4 04             	add    $0x4,%esp
  80333c:	89 c2                	mov    %eax,%edx
  80333e:	8b 45 08             	mov    0x8(%ebp),%eax
  803341:	01 d0                	add    %edx,%eax
  803343:	3b 45 10             	cmp    0x10(%ebp),%eax
  803346:	75 07                	jne    80334f <merging+0x39>
		prev_is_free = 1;
  803348:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80334f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803353:	74 1e                	je     803373 <merging+0x5d>
  803355:	ff 75 10             	pushl  0x10(%ebp)
  803358:	e8 98 f1 ff ff       	call   8024f5 <get_block_size>
  80335d:	83 c4 04             	add    $0x4,%esp
  803360:	89 c2                	mov    %eax,%edx
  803362:	8b 45 10             	mov    0x10(%ebp),%eax
  803365:	01 d0                	add    %edx,%eax
  803367:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80336a:	75 07                	jne    803373 <merging+0x5d>
		next_is_free = 1;
  80336c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803373:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803377:	0f 84 cc 00 00 00    	je     803449 <merging+0x133>
  80337d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803381:	0f 84 c2 00 00 00    	je     803449 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803387:	ff 75 08             	pushl  0x8(%ebp)
  80338a:	e8 66 f1 ff ff       	call   8024f5 <get_block_size>
  80338f:	83 c4 04             	add    $0x4,%esp
  803392:	89 c3                	mov    %eax,%ebx
  803394:	ff 75 10             	pushl  0x10(%ebp)
  803397:	e8 59 f1 ff ff       	call   8024f5 <get_block_size>
  80339c:	83 c4 04             	add    $0x4,%esp
  80339f:	01 c3                	add    %eax,%ebx
  8033a1:	ff 75 0c             	pushl  0xc(%ebp)
  8033a4:	e8 4c f1 ff ff       	call   8024f5 <get_block_size>
  8033a9:	83 c4 04             	add    $0x4,%esp
  8033ac:	01 d8                	add    %ebx,%eax
  8033ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8033b1:	6a 00                	push   $0x0
  8033b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8033b6:	ff 75 08             	pushl  0x8(%ebp)
  8033b9:	e8 88 f4 ff ff       	call   802846 <set_block_data>
  8033be:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8033c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033c5:	75 17                	jne    8033de <merging+0xc8>
  8033c7:	83 ec 04             	sub    $0x4,%esp
  8033ca:	68 c7 4a 80 00       	push   $0x804ac7
  8033cf:	68 7d 01 00 00       	push   $0x17d
  8033d4:	68 e5 4a 80 00       	push   $0x804ae5
  8033d9:	e8 6d d3 ff ff       	call   80074b <_panic>
  8033de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e1:	8b 00                	mov    (%eax),%eax
  8033e3:	85 c0                	test   %eax,%eax
  8033e5:	74 10                	je     8033f7 <merging+0xe1>
  8033e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ea:	8b 00                	mov    (%eax),%eax
  8033ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033ef:	8b 52 04             	mov    0x4(%edx),%edx
  8033f2:	89 50 04             	mov    %edx,0x4(%eax)
  8033f5:	eb 0b                	jmp    803402 <merging+0xec>
  8033f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033fa:	8b 40 04             	mov    0x4(%eax),%eax
  8033fd:	a3 34 50 80 00       	mov    %eax,0x805034
  803402:	8b 45 0c             	mov    0xc(%ebp),%eax
  803405:	8b 40 04             	mov    0x4(%eax),%eax
  803408:	85 c0                	test   %eax,%eax
  80340a:	74 0f                	je     80341b <merging+0x105>
  80340c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80340f:	8b 40 04             	mov    0x4(%eax),%eax
  803412:	8b 55 0c             	mov    0xc(%ebp),%edx
  803415:	8b 12                	mov    (%edx),%edx
  803417:	89 10                	mov    %edx,(%eax)
  803419:	eb 0a                	jmp    803425 <merging+0x10f>
  80341b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80341e:	8b 00                	mov    (%eax),%eax
  803420:	a3 30 50 80 00       	mov    %eax,0x805030
  803425:	8b 45 0c             	mov    0xc(%ebp),%eax
  803428:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80342e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803431:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803438:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80343d:	48                   	dec    %eax
  80343e:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803443:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803444:	e9 ea 02 00 00       	jmp    803733 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80344d:	74 3b                	je     80348a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80344f:	83 ec 0c             	sub    $0xc,%esp
  803452:	ff 75 08             	pushl  0x8(%ebp)
  803455:	e8 9b f0 ff ff       	call   8024f5 <get_block_size>
  80345a:	83 c4 10             	add    $0x10,%esp
  80345d:	89 c3                	mov    %eax,%ebx
  80345f:	83 ec 0c             	sub    $0xc,%esp
  803462:	ff 75 10             	pushl  0x10(%ebp)
  803465:	e8 8b f0 ff ff       	call   8024f5 <get_block_size>
  80346a:	83 c4 10             	add    $0x10,%esp
  80346d:	01 d8                	add    %ebx,%eax
  80346f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803472:	83 ec 04             	sub    $0x4,%esp
  803475:	6a 00                	push   $0x0
  803477:	ff 75 e8             	pushl  -0x18(%ebp)
  80347a:	ff 75 08             	pushl  0x8(%ebp)
  80347d:	e8 c4 f3 ff ff       	call   802846 <set_block_data>
  803482:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803485:	e9 a9 02 00 00       	jmp    803733 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80348a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80348e:	0f 84 2d 01 00 00    	je     8035c1 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803494:	83 ec 0c             	sub    $0xc,%esp
  803497:	ff 75 10             	pushl  0x10(%ebp)
  80349a:	e8 56 f0 ff ff       	call   8024f5 <get_block_size>
  80349f:	83 c4 10             	add    $0x10,%esp
  8034a2:	89 c3                	mov    %eax,%ebx
  8034a4:	83 ec 0c             	sub    $0xc,%esp
  8034a7:	ff 75 0c             	pushl  0xc(%ebp)
  8034aa:	e8 46 f0 ff ff       	call   8024f5 <get_block_size>
  8034af:	83 c4 10             	add    $0x10,%esp
  8034b2:	01 d8                	add    %ebx,%eax
  8034b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8034b7:	83 ec 04             	sub    $0x4,%esp
  8034ba:	6a 00                	push   $0x0
  8034bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034bf:	ff 75 10             	pushl  0x10(%ebp)
  8034c2:	e8 7f f3 ff ff       	call   802846 <set_block_data>
  8034c7:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8034ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8034cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8034d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034d4:	74 06                	je     8034dc <merging+0x1c6>
  8034d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034da:	75 17                	jne    8034f3 <merging+0x1dd>
  8034dc:	83 ec 04             	sub    $0x4,%esp
  8034df:	68 a0 4b 80 00       	push   $0x804ba0
  8034e4:	68 8d 01 00 00       	push   $0x18d
  8034e9:	68 e5 4a 80 00       	push   $0x804ae5
  8034ee:	e8 58 d2 ff ff       	call   80074b <_panic>
  8034f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f6:	8b 50 04             	mov    0x4(%eax),%edx
  8034f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034fc:	89 50 04             	mov    %edx,0x4(%eax)
  8034ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803502:	8b 55 0c             	mov    0xc(%ebp),%edx
  803505:	89 10                	mov    %edx,(%eax)
  803507:	8b 45 0c             	mov    0xc(%ebp),%eax
  80350a:	8b 40 04             	mov    0x4(%eax),%eax
  80350d:	85 c0                	test   %eax,%eax
  80350f:	74 0d                	je     80351e <merging+0x208>
  803511:	8b 45 0c             	mov    0xc(%ebp),%eax
  803514:	8b 40 04             	mov    0x4(%eax),%eax
  803517:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80351a:	89 10                	mov    %edx,(%eax)
  80351c:	eb 08                	jmp    803526 <merging+0x210>
  80351e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803521:	a3 30 50 80 00       	mov    %eax,0x805030
  803526:	8b 45 0c             	mov    0xc(%ebp),%eax
  803529:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80352c:	89 50 04             	mov    %edx,0x4(%eax)
  80352f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803534:	40                   	inc    %eax
  803535:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  80353a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80353e:	75 17                	jne    803557 <merging+0x241>
  803540:	83 ec 04             	sub    $0x4,%esp
  803543:	68 c7 4a 80 00       	push   $0x804ac7
  803548:	68 8e 01 00 00       	push   $0x18e
  80354d:	68 e5 4a 80 00       	push   $0x804ae5
  803552:	e8 f4 d1 ff ff       	call   80074b <_panic>
  803557:	8b 45 0c             	mov    0xc(%ebp),%eax
  80355a:	8b 00                	mov    (%eax),%eax
  80355c:	85 c0                	test   %eax,%eax
  80355e:	74 10                	je     803570 <merging+0x25a>
  803560:	8b 45 0c             	mov    0xc(%ebp),%eax
  803563:	8b 00                	mov    (%eax),%eax
  803565:	8b 55 0c             	mov    0xc(%ebp),%edx
  803568:	8b 52 04             	mov    0x4(%edx),%edx
  80356b:	89 50 04             	mov    %edx,0x4(%eax)
  80356e:	eb 0b                	jmp    80357b <merging+0x265>
  803570:	8b 45 0c             	mov    0xc(%ebp),%eax
  803573:	8b 40 04             	mov    0x4(%eax),%eax
  803576:	a3 34 50 80 00       	mov    %eax,0x805034
  80357b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80357e:	8b 40 04             	mov    0x4(%eax),%eax
  803581:	85 c0                	test   %eax,%eax
  803583:	74 0f                	je     803594 <merging+0x27e>
  803585:	8b 45 0c             	mov    0xc(%ebp),%eax
  803588:	8b 40 04             	mov    0x4(%eax),%eax
  80358b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80358e:	8b 12                	mov    (%edx),%edx
  803590:	89 10                	mov    %edx,(%eax)
  803592:	eb 0a                	jmp    80359e <merging+0x288>
  803594:	8b 45 0c             	mov    0xc(%ebp),%eax
  803597:	8b 00                	mov    (%eax),%eax
  803599:	a3 30 50 80 00       	mov    %eax,0x805030
  80359e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035b6:	48                   	dec    %eax
  8035b7:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035bc:	e9 72 01 00 00       	jmp    803733 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8035c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8035c4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8035c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035cb:	74 79                	je     803646 <merging+0x330>
  8035cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035d1:	74 73                	je     803646 <merging+0x330>
  8035d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035d7:	74 06                	je     8035df <merging+0x2c9>
  8035d9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035dd:	75 17                	jne    8035f6 <merging+0x2e0>
  8035df:	83 ec 04             	sub    $0x4,%esp
  8035e2:	68 58 4b 80 00       	push   $0x804b58
  8035e7:	68 94 01 00 00       	push   $0x194
  8035ec:	68 e5 4a 80 00       	push   $0x804ae5
  8035f1:	e8 55 d1 ff ff       	call   80074b <_panic>
  8035f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f9:	8b 10                	mov    (%eax),%edx
  8035fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035fe:	89 10                	mov    %edx,(%eax)
  803600:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803603:	8b 00                	mov    (%eax),%eax
  803605:	85 c0                	test   %eax,%eax
  803607:	74 0b                	je     803614 <merging+0x2fe>
  803609:	8b 45 08             	mov    0x8(%ebp),%eax
  80360c:	8b 00                	mov    (%eax),%eax
  80360e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803611:	89 50 04             	mov    %edx,0x4(%eax)
  803614:	8b 45 08             	mov    0x8(%ebp),%eax
  803617:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80361a:	89 10                	mov    %edx,(%eax)
  80361c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80361f:	8b 55 08             	mov    0x8(%ebp),%edx
  803622:	89 50 04             	mov    %edx,0x4(%eax)
  803625:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803628:	8b 00                	mov    (%eax),%eax
  80362a:	85 c0                	test   %eax,%eax
  80362c:	75 08                	jne    803636 <merging+0x320>
  80362e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803631:	a3 34 50 80 00       	mov    %eax,0x805034
  803636:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80363b:	40                   	inc    %eax
  80363c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803641:	e9 ce 00 00 00       	jmp    803714 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803646:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80364a:	74 65                	je     8036b1 <merging+0x39b>
  80364c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803650:	75 17                	jne    803669 <merging+0x353>
  803652:	83 ec 04             	sub    $0x4,%esp
  803655:	68 34 4b 80 00       	push   $0x804b34
  80365a:	68 95 01 00 00       	push   $0x195
  80365f:	68 e5 4a 80 00       	push   $0x804ae5
  803664:	e8 e2 d0 ff ff       	call   80074b <_panic>
  803669:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80366f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803672:	89 50 04             	mov    %edx,0x4(%eax)
  803675:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803678:	8b 40 04             	mov    0x4(%eax),%eax
  80367b:	85 c0                	test   %eax,%eax
  80367d:	74 0c                	je     80368b <merging+0x375>
  80367f:	a1 34 50 80 00       	mov    0x805034,%eax
  803684:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803687:	89 10                	mov    %edx,(%eax)
  803689:	eb 08                	jmp    803693 <merging+0x37d>
  80368b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80368e:	a3 30 50 80 00       	mov    %eax,0x805030
  803693:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803696:	a3 34 50 80 00       	mov    %eax,0x805034
  80369b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80369e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036a9:	40                   	inc    %eax
  8036aa:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036af:	eb 63                	jmp    803714 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8036b1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036b5:	75 17                	jne    8036ce <merging+0x3b8>
  8036b7:	83 ec 04             	sub    $0x4,%esp
  8036ba:	68 00 4b 80 00       	push   $0x804b00
  8036bf:	68 98 01 00 00       	push   $0x198
  8036c4:	68 e5 4a 80 00       	push   $0x804ae5
  8036c9:	e8 7d d0 ff ff       	call   80074b <_panic>
  8036ce:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036d7:	89 10                	mov    %edx,(%eax)
  8036d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036dc:	8b 00                	mov    (%eax),%eax
  8036de:	85 c0                	test   %eax,%eax
  8036e0:	74 0d                	je     8036ef <merging+0x3d9>
  8036e2:	a1 30 50 80 00       	mov    0x805030,%eax
  8036e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036ea:	89 50 04             	mov    %edx,0x4(%eax)
  8036ed:	eb 08                	jmp    8036f7 <merging+0x3e1>
  8036ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f2:	a3 34 50 80 00       	mov    %eax,0x805034
  8036f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8036ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803702:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803709:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80370e:	40                   	inc    %eax
  80370f:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803714:	83 ec 0c             	sub    $0xc,%esp
  803717:	ff 75 10             	pushl  0x10(%ebp)
  80371a:	e8 d6 ed ff ff       	call   8024f5 <get_block_size>
  80371f:	83 c4 10             	add    $0x10,%esp
  803722:	83 ec 04             	sub    $0x4,%esp
  803725:	6a 00                	push   $0x0
  803727:	50                   	push   %eax
  803728:	ff 75 10             	pushl  0x10(%ebp)
  80372b:	e8 16 f1 ff ff       	call   802846 <set_block_data>
  803730:	83 c4 10             	add    $0x10,%esp
	}
}
  803733:	90                   	nop
  803734:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803737:	c9                   	leave  
  803738:	c3                   	ret    

00803739 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803739:	55                   	push   %ebp
  80373a:	89 e5                	mov    %esp,%ebp
  80373c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80373f:	a1 30 50 80 00       	mov    0x805030,%eax
  803744:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803747:	a1 34 50 80 00       	mov    0x805034,%eax
  80374c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80374f:	73 1b                	jae    80376c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803751:	a1 34 50 80 00       	mov    0x805034,%eax
  803756:	83 ec 04             	sub    $0x4,%esp
  803759:	ff 75 08             	pushl  0x8(%ebp)
  80375c:	6a 00                	push   $0x0
  80375e:	50                   	push   %eax
  80375f:	e8 b2 fb ff ff       	call   803316 <merging>
  803764:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803767:	e9 8b 00 00 00       	jmp    8037f7 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80376c:	a1 30 50 80 00       	mov    0x805030,%eax
  803771:	3b 45 08             	cmp    0x8(%ebp),%eax
  803774:	76 18                	jbe    80378e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803776:	a1 30 50 80 00       	mov    0x805030,%eax
  80377b:	83 ec 04             	sub    $0x4,%esp
  80377e:	ff 75 08             	pushl  0x8(%ebp)
  803781:	50                   	push   %eax
  803782:	6a 00                	push   $0x0
  803784:	e8 8d fb ff ff       	call   803316 <merging>
  803789:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80378c:	eb 69                	jmp    8037f7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80378e:	a1 30 50 80 00       	mov    0x805030,%eax
  803793:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803796:	eb 39                	jmp    8037d1 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80379e:	73 29                	jae    8037c9 <free_block+0x90>
  8037a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a3:	8b 00                	mov    (%eax),%eax
  8037a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037a8:	76 1f                	jbe    8037c9 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8037aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ad:	8b 00                	mov    (%eax),%eax
  8037af:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8037b2:	83 ec 04             	sub    $0x4,%esp
  8037b5:	ff 75 08             	pushl  0x8(%ebp)
  8037b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8037bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8037be:	e8 53 fb ff ff       	call   803316 <merging>
  8037c3:	83 c4 10             	add    $0x10,%esp
			break;
  8037c6:	90                   	nop
		}
	}
}
  8037c7:	eb 2e                	jmp    8037f7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8037c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d5:	74 07                	je     8037de <free_block+0xa5>
  8037d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037da:	8b 00                	mov    (%eax),%eax
  8037dc:	eb 05                	jmp    8037e3 <free_block+0xaa>
  8037de:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e3:	a3 38 50 80 00       	mov    %eax,0x805038
  8037e8:	a1 38 50 80 00       	mov    0x805038,%eax
  8037ed:	85 c0                	test   %eax,%eax
  8037ef:	75 a7                	jne    803798 <free_block+0x5f>
  8037f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f5:	75 a1                	jne    803798 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037f7:	90                   	nop
  8037f8:	c9                   	leave  
  8037f9:	c3                   	ret    

008037fa <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8037fa:	55                   	push   %ebp
  8037fb:	89 e5                	mov    %esp,%ebp
  8037fd:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803800:	ff 75 08             	pushl  0x8(%ebp)
  803803:	e8 ed ec ff ff       	call   8024f5 <get_block_size>
  803808:	83 c4 04             	add    $0x4,%esp
  80380b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80380e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803815:	eb 17                	jmp    80382e <copy_data+0x34>
  803817:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80381a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80381d:	01 c2                	add    %eax,%edx
  80381f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803822:	8b 45 08             	mov    0x8(%ebp),%eax
  803825:	01 c8                	add    %ecx,%eax
  803827:	8a 00                	mov    (%eax),%al
  803829:	88 02                	mov    %al,(%edx)
  80382b:	ff 45 fc             	incl   -0x4(%ebp)
  80382e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803831:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803834:	72 e1                	jb     803817 <copy_data+0x1d>
}
  803836:	90                   	nop
  803837:	c9                   	leave  
  803838:	c3                   	ret    

00803839 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803839:	55                   	push   %ebp
  80383a:	89 e5                	mov    %esp,%ebp
  80383c:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80383f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803843:	75 23                	jne    803868 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803845:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803849:	74 13                	je     80385e <realloc_block_FF+0x25>
  80384b:	83 ec 0c             	sub    $0xc,%esp
  80384e:	ff 75 0c             	pushl  0xc(%ebp)
  803851:	e8 1f f0 ff ff       	call   802875 <alloc_block_FF>
  803856:	83 c4 10             	add    $0x10,%esp
  803859:	e9 f4 06 00 00       	jmp    803f52 <realloc_block_FF+0x719>
		return NULL;
  80385e:	b8 00 00 00 00       	mov    $0x0,%eax
  803863:	e9 ea 06 00 00       	jmp    803f52 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803868:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80386c:	75 18                	jne    803886 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80386e:	83 ec 0c             	sub    $0xc,%esp
  803871:	ff 75 08             	pushl  0x8(%ebp)
  803874:	e8 c0 fe ff ff       	call   803739 <free_block>
  803879:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80387c:	b8 00 00 00 00       	mov    $0x0,%eax
  803881:	e9 cc 06 00 00       	jmp    803f52 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803886:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80388a:	77 07                	ja     803893 <realloc_block_FF+0x5a>
  80388c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803893:	8b 45 0c             	mov    0xc(%ebp),%eax
  803896:	83 e0 01             	and    $0x1,%eax
  803899:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80389c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80389f:	83 c0 08             	add    $0x8,%eax
  8038a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8038a5:	83 ec 0c             	sub    $0xc,%esp
  8038a8:	ff 75 08             	pushl  0x8(%ebp)
  8038ab:	e8 45 ec ff ff       	call   8024f5 <get_block_size>
  8038b0:	83 c4 10             	add    $0x10,%esp
  8038b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8038b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038b9:	83 e8 08             	sub    $0x8,%eax
  8038bc:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8038bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c2:	83 e8 04             	sub    $0x4,%eax
  8038c5:	8b 00                	mov    (%eax),%eax
  8038c7:	83 e0 fe             	and    $0xfffffffe,%eax
  8038ca:	89 c2                	mov    %eax,%edx
  8038cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cf:	01 d0                	add    %edx,%eax
  8038d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8038d4:	83 ec 0c             	sub    $0xc,%esp
  8038d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038da:	e8 16 ec ff ff       	call   8024f5 <get_block_size>
  8038df:	83 c4 10             	add    $0x10,%esp
  8038e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8038e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038e8:	83 e8 08             	sub    $0x8,%eax
  8038eb:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8038ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038f1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038f4:	75 08                	jne    8038fe <realloc_block_FF+0xc5>
	{
		 return va;
  8038f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f9:	e9 54 06 00 00       	jmp    803f52 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8038fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803901:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803904:	0f 83 e5 03 00 00    	jae    803cef <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80390a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803910:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803913:	83 ec 0c             	sub    $0xc,%esp
  803916:	ff 75 e4             	pushl  -0x1c(%ebp)
  803919:	e8 f0 eb ff ff       	call   80250e <is_free_block>
  80391e:	83 c4 10             	add    $0x10,%esp
  803921:	84 c0                	test   %al,%al
  803923:	0f 84 3b 01 00 00    	je     803a64 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803929:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80392c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80392f:	01 d0                	add    %edx,%eax
  803931:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803934:	83 ec 04             	sub    $0x4,%esp
  803937:	6a 01                	push   $0x1
  803939:	ff 75 f0             	pushl  -0x10(%ebp)
  80393c:	ff 75 08             	pushl  0x8(%ebp)
  80393f:	e8 02 ef ff ff       	call   802846 <set_block_data>
  803944:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803947:	8b 45 08             	mov    0x8(%ebp),%eax
  80394a:	83 e8 04             	sub    $0x4,%eax
  80394d:	8b 00                	mov    (%eax),%eax
  80394f:	83 e0 fe             	and    $0xfffffffe,%eax
  803952:	89 c2                	mov    %eax,%edx
  803954:	8b 45 08             	mov    0x8(%ebp),%eax
  803957:	01 d0                	add    %edx,%eax
  803959:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80395c:	83 ec 04             	sub    $0x4,%esp
  80395f:	6a 00                	push   $0x0
  803961:	ff 75 cc             	pushl  -0x34(%ebp)
  803964:	ff 75 c8             	pushl  -0x38(%ebp)
  803967:	e8 da ee ff ff       	call   802846 <set_block_data>
  80396c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80396f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803973:	74 06                	je     80397b <realloc_block_FF+0x142>
  803975:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803979:	75 17                	jne    803992 <realloc_block_FF+0x159>
  80397b:	83 ec 04             	sub    $0x4,%esp
  80397e:	68 58 4b 80 00       	push   $0x804b58
  803983:	68 f6 01 00 00       	push   $0x1f6
  803988:	68 e5 4a 80 00       	push   $0x804ae5
  80398d:	e8 b9 cd ff ff       	call   80074b <_panic>
  803992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803995:	8b 10                	mov    (%eax),%edx
  803997:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80399a:	89 10                	mov    %edx,(%eax)
  80399c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80399f:	8b 00                	mov    (%eax),%eax
  8039a1:	85 c0                	test   %eax,%eax
  8039a3:	74 0b                	je     8039b0 <realloc_block_FF+0x177>
  8039a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a8:	8b 00                	mov    (%eax),%eax
  8039aa:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039ad:	89 50 04             	mov    %edx,0x4(%eax)
  8039b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039b6:	89 10                	mov    %edx,(%eax)
  8039b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039be:	89 50 04             	mov    %edx,0x4(%eax)
  8039c1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039c4:	8b 00                	mov    (%eax),%eax
  8039c6:	85 c0                	test   %eax,%eax
  8039c8:	75 08                	jne    8039d2 <realloc_block_FF+0x199>
  8039ca:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039cd:	a3 34 50 80 00       	mov    %eax,0x805034
  8039d2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039d7:	40                   	inc    %eax
  8039d8:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8039dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039e1:	75 17                	jne    8039fa <realloc_block_FF+0x1c1>
  8039e3:	83 ec 04             	sub    $0x4,%esp
  8039e6:	68 c7 4a 80 00       	push   $0x804ac7
  8039eb:	68 f7 01 00 00       	push   $0x1f7
  8039f0:	68 e5 4a 80 00       	push   $0x804ae5
  8039f5:	e8 51 cd ff ff       	call   80074b <_panic>
  8039fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fd:	8b 00                	mov    (%eax),%eax
  8039ff:	85 c0                	test   %eax,%eax
  803a01:	74 10                	je     803a13 <realloc_block_FF+0x1da>
  803a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a06:	8b 00                	mov    (%eax),%eax
  803a08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a0b:	8b 52 04             	mov    0x4(%edx),%edx
  803a0e:	89 50 04             	mov    %edx,0x4(%eax)
  803a11:	eb 0b                	jmp    803a1e <realloc_block_FF+0x1e5>
  803a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a16:	8b 40 04             	mov    0x4(%eax),%eax
  803a19:	a3 34 50 80 00       	mov    %eax,0x805034
  803a1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a21:	8b 40 04             	mov    0x4(%eax),%eax
  803a24:	85 c0                	test   %eax,%eax
  803a26:	74 0f                	je     803a37 <realloc_block_FF+0x1fe>
  803a28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2b:	8b 40 04             	mov    0x4(%eax),%eax
  803a2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a31:	8b 12                	mov    (%edx),%edx
  803a33:	89 10                	mov    %edx,(%eax)
  803a35:	eb 0a                	jmp    803a41 <realloc_block_FF+0x208>
  803a37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3a:	8b 00                	mov    (%eax),%eax
  803a3c:	a3 30 50 80 00       	mov    %eax,0x805030
  803a41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a54:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a59:	48                   	dec    %eax
  803a5a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a5f:	e9 83 02 00 00       	jmp    803ce7 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803a64:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803a68:	0f 86 69 02 00 00    	jbe    803cd7 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803a6e:	83 ec 04             	sub    $0x4,%esp
  803a71:	6a 01                	push   $0x1
  803a73:	ff 75 f0             	pushl  -0x10(%ebp)
  803a76:	ff 75 08             	pushl  0x8(%ebp)
  803a79:	e8 c8 ed ff ff       	call   802846 <set_block_data>
  803a7e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a81:	8b 45 08             	mov    0x8(%ebp),%eax
  803a84:	83 e8 04             	sub    $0x4,%eax
  803a87:	8b 00                	mov    (%eax),%eax
  803a89:	83 e0 fe             	and    $0xfffffffe,%eax
  803a8c:	89 c2                	mov    %eax,%edx
  803a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a91:	01 d0                	add    %edx,%eax
  803a93:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803a96:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a9b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803a9e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803aa2:	75 68                	jne    803b0c <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803aa4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803aa8:	75 17                	jne    803ac1 <realloc_block_FF+0x288>
  803aaa:	83 ec 04             	sub    $0x4,%esp
  803aad:	68 00 4b 80 00       	push   $0x804b00
  803ab2:	68 06 02 00 00       	push   $0x206
  803ab7:	68 e5 4a 80 00       	push   $0x804ae5
  803abc:	e8 8a cc ff ff       	call   80074b <_panic>
  803ac1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803ac7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aca:	89 10                	mov    %edx,(%eax)
  803acc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803acf:	8b 00                	mov    (%eax),%eax
  803ad1:	85 c0                	test   %eax,%eax
  803ad3:	74 0d                	je     803ae2 <realloc_block_FF+0x2a9>
  803ad5:	a1 30 50 80 00       	mov    0x805030,%eax
  803ada:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803add:	89 50 04             	mov    %edx,0x4(%eax)
  803ae0:	eb 08                	jmp    803aea <realloc_block_FF+0x2b1>
  803ae2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae5:	a3 34 50 80 00       	mov    %eax,0x805034
  803aea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aed:	a3 30 50 80 00       	mov    %eax,0x805030
  803af2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803af5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803afc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b01:	40                   	inc    %eax
  803b02:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b07:	e9 b0 01 00 00       	jmp    803cbc <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803b0c:	a1 30 50 80 00       	mov    0x805030,%eax
  803b11:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b14:	76 68                	jbe    803b7e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b16:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b1a:	75 17                	jne    803b33 <realloc_block_FF+0x2fa>
  803b1c:	83 ec 04             	sub    $0x4,%esp
  803b1f:	68 00 4b 80 00       	push   $0x804b00
  803b24:	68 0b 02 00 00       	push   $0x20b
  803b29:	68 e5 4a 80 00       	push   $0x804ae5
  803b2e:	e8 18 cc ff ff       	call   80074b <_panic>
  803b33:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b39:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b3c:	89 10                	mov    %edx,(%eax)
  803b3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b41:	8b 00                	mov    (%eax),%eax
  803b43:	85 c0                	test   %eax,%eax
  803b45:	74 0d                	je     803b54 <realloc_block_FF+0x31b>
  803b47:	a1 30 50 80 00       	mov    0x805030,%eax
  803b4c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b4f:	89 50 04             	mov    %edx,0x4(%eax)
  803b52:	eb 08                	jmp    803b5c <realloc_block_FF+0x323>
  803b54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b57:	a3 34 50 80 00       	mov    %eax,0x805034
  803b5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b5f:	a3 30 50 80 00       	mov    %eax,0x805030
  803b64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b6e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b73:	40                   	inc    %eax
  803b74:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b79:	e9 3e 01 00 00       	jmp    803cbc <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803b7e:	a1 30 50 80 00       	mov    0x805030,%eax
  803b83:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b86:	73 68                	jae    803bf0 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b88:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b8c:	75 17                	jne    803ba5 <realloc_block_FF+0x36c>
  803b8e:	83 ec 04             	sub    $0x4,%esp
  803b91:	68 34 4b 80 00       	push   $0x804b34
  803b96:	68 10 02 00 00       	push   $0x210
  803b9b:	68 e5 4a 80 00       	push   $0x804ae5
  803ba0:	e8 a6 cb ff ff       	call   80074b <_panic>
  803ba5:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803bab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bae:	89 50 04             	mov    %edx,0x4(%eax)
  803bb1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bb4:	8b 40 04             	mov    0x4(%eax),%eax
  803bb7:	85 c0                	test   %eax,%eax
  803bb9:	74 0c                	je     803bc7 <realloc_block_FF+0x38e>
  803bbb:	a1 34 50 80 00       	mov    0x805034,%eax
  803bc0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bc3:	89 10                	mov    %edx,(%eax)
  803bc5:	eb 08                	jmp    803bcf <realloc_block_FF+0x396>
  803bc7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bca:	a3 30 50 80 00       	mov    %eax,0x805030
  803bcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bd2:	a3 34 50 80 00       	mov    %eax,0x805034
  803bd7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803be0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803be5:	40                   	inc    %eax
  803be6:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803beb:	e9 cc 00 00 00       	jmp    803cbc <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803bf0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803bf7:	a1 30 50 80 00       	mov    0x805030,%eax
  803bfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bff:	e9 8a 00 00 00       	jmp    803c8e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c07:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c0a:	73 7a                	jae    803c86 <realloc_block_FF+0x44d>
  803c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0f:	8b 00                	mov    (%eax),%eax
  803c11:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c14:	73 70                	jae    803c86 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803c16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c1a:	74 06                	je     803c22 <realloc_block_FF+0x3e9>
  803c1c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c20:	75 17                	jne    803c39 <realloc_block_FF+0x400>
  803c22:	83 ec 04             	sub    $0x4,%esp
  803c25:	68 58 4b 80 00       	push   $0x804b58
  803c2a:	68 1a 02 00 00       	push   $0x21a
  803c2f:	68 e5 4a 80 00       	push   $0x804ae5
  803c34:	e8 12 cb ff ff       	call   80074b <_panic>
  803c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c3c:	8b 10                	mov    (%eax),%edx
  803c3e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c41:	89 10                	mov    %edx,(%eax)
  803c43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c46:	8b 00                	mov    (%eax),%eax
  803c48:	85 c0                	test   %eax,%eax
  803c4a:	74 0b                	je     803c57 <realloc_block_FF+0x41e>
  803c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4f:	8b 00                	mov    (%eax),%eax
  803c51:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c54:	89 50 04             	mov    %edx,0x4(%eax)
  803c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c5d:	89 10                	mov    %edx,(%eax)
  803c5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c65:	89 50 04             	mov    %edx,0x4(%eax)
  803c68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c6b:	8b 00                	mov    (%eax),%eax
  803c6d:	85 c0                	test   %eax,%eax
  803c6f:	75 08                	jne    803c79 <realloc_block_FF+0x440>
  803c71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c74:	a3 34 50 80 00       	mov    %eax,0x805034
  803c79:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c7e:	40                   	inc    %eax
  803c7f:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803c84:	eb 36                	jmp    803cbc <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803c86:	a1 38 50 80 00       	mov    0x805038,%eax
  803c8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c92:	74 07                	je     803c9b <realloc_block_FF+0x462>
  803c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c97:	8b 00                	mov    (%eax),%eax
  803c99:	eb 05                	jmp    803ca0 <realloc_block_FF+0x467>
  803c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca0:	a3 38 50 80 00       	mov    %eax,0x805038
  803ca5:	a1 38 50 80 00       	mov    0x805038,%eax
  803caa:	85 c0                	test   %eax,%eax
  803cac:	0f 85 52 ff ff ff    	jne    803c04 <realloc_block_FF+0x3cb>
  803cb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cb6:	0f 85 48 ff ff ff    	jne    803c04 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803cbc:	83 ec 04             	sub    $0x4,%esp
  803cbf:	6a 00                	push   $0x0
  803cc1:	ff 75 d8             	pushl  -0x28(%ebp)
  803cc4:	ff 75 d4             	pushl  -0x2c(%ebp)
  803cc7:	e8 7a eb ff ff       	call   802846 <set_block_data>
  803ccc:	83 c4 10             	add    $0x10,%esp
				return va;
  803ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd2:	e9 7b 02 00 00       	jmp    803f52 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803cd7:	83 ec 0c             	sub    $0xc,%esp
  803cda:	68 d5 4b 80 00       	push   $0x804bd5
  803cdf:	e8 24 cd ff ff       	call   800a08 <cprintf>
  803ce4:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cea:	e9 63 02 00 00       	jmp    803f52 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cf2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803cf5:	0f 86 4d 02 00 00    	jbe    803f48 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803cfb:	83 ec 0c             	sub    $0xc,%esp
  803cfe:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d01:	e8 08 e8 ff ff       	call   80250e <is_free_block>
  803d06:	83 c4 10             	add    $0x10,%esp
  803d09:	84 c0                	test   %al,%al
  803d0b:	0f 84 37 02 00 00    	je     803f48 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d14:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d17:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803d1a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d1d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d20:	76 38                	jbe    803d5a <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803d22:	83 ec 0c             	sub    $0xc,%esp
  803d25:	ff 75 08             	pushl  0x8(%ebp)
  803d28:	e8 0c fa ff ff       	call   803739 <free_block>
  803d2d:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803d30:	83 ec 0c             	sub    $0xc,%esp
  803d33:	ff 75 0c             	pushl  0xc(%ebp)
  803d36:	e8 3a eb ff ff       	call   802875 <alloc_block_FF>
  803d3b:	83 c4 10             	add    $0x10,%esp
  803d3e:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803d41:	83 ec 08             	sub    $0x8,%esp
  803d44:	ff 75 c0             	pushl  -0x40(%ebp)
  803d47:	ff 75 08             	pushl  0x8(%ebp)
  803d4a:	e8 ab fa ff ff       	call   8037fa <copy_data>
  803d4f:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803d52:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803d55:	e9 f8 01 00 00       	jmp    803f52 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803d5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d5d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803d60:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803d63:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803d67:	0f 87 a0 00 00 00    	ja     803e0d <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803d6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d71:	75 17                	jne    803d8a <realloc_block_FF+0x551>
  803d73:	83 ec 04             	sub    $0x4,%esp
  803d76:	68 c7 4a 80 00       	push   $0x804ac7
  803d7b:	68 38 02 00 00       	push   $0x238
  803d80:	68 e5 4a 80 00       	push   $0x804ae5
  803d85:	e8 c1 c9 ff ff       	call   80074b <_panic>
  803d8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d8d:	8b 00                	mov    (%eax),%eax
  803d8f:	85 c0                	test   %eax,%eax
  803d91:	74 10                	je     803da3 <realloc_block_FF+0x56a>
  803d93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d96:	8b 00                	mov    (%eax),%eax
  803d98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d9b:	8b 52 04             	mov    0x4(%edx),%edx
  803d9e:	89 50 04             	mov    %edx,0x4(%eax)
  803da1:	eb 0b                	jmp    803dae <realloc_block_FF+0x575>
  803da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da6:	8b 40 04             	mov    0x4(%eax),%eax
  803da9:	a3 34 50 80 00       	mov    %eax,0x805034
  803dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db1:	8b 40 04             	mov    0x4(%eax),%eax
  803db4:	85 c0                	test   %eax,%eax
  803db6:	74 0f                	je     803dc7 <realloc_block_FF+0x58e>
  803db8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbb:	8b 40 04             	mov    0x4(%eax),%eax
  803dbe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dc1:	8b 12                	mov    (%edx),%edx
  803dc3:	89 10                	mov    %edx,(%eax)
  803dc5:	eb 0a                	jmp    803dd1 <realloc_block_FF+0x598>
  803dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dca:	8b 00                	mov    (%eax),%eax
  803dcc:	a3 30 50 80 00       	mov    %eax,0x805030
  803dd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ddd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803de4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803de9:	48                   	dec    %eax
  803dea:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803def:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803df2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803df5:	01 d0                	add    %edx,%eax
  803df7:	83 ec 04             	sub    $0x4,%esp
  803dfa:	6a 01                	push   $0x1
  803dfc:	50                   	push   %eax
  803dfd:	ff 75 08             	pushl  0x8(%ebp)
  803e00:	e8 41 ea ff ff       	call   802846 <set_block_data>
  803e05:	83 c4 10             	add    $0x10,%esp
  803e08:	e9 36 01 00 00       	jmp    803f43 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803e0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e10:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e13:	01 d0                	add    %edx,%eax
  803e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803e18:	83 ec 04             	sub    $0x4,%esp
  803e1b:	6a 01                	push   $0x1
  803e1d:	ff 75 f0             	pushl  -0x10(%ebp)
  803e20:	ff 75 08             	pushl  0x8(%ebp)
  803e23:	e8 1e ea ff ff       	call   802846 <set_block_data>
  803e28:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2e:	83 e8 04             	sub    $0x4,%eax
  803e31:	8b 00                	mov    (%eax),%eax
  803e33:	83 e0 fe             	and    $0xfffffffe,%eax
  803e36:	89 c2                	mov    %eax,%edx
  803e38:	8b 45 08             	mov    0x8(%ebp),%eax
  803e3b:	01 d0                	add    %edx,%eax
  803e3d:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803e40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e44:	74 06                	je     803e4c <realloc_block_FF+0x613>
  803e46:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803e4a:	75 17                	jne    803e63 <realloc_block_FF+0x62a>
  803e4c:	83 ec 04             	sub    $0x4,%esp
  803e4f:	68 58 4b 80 00       	push   $0x804b58
  803e54:	68 44 02 00 00       	push   $0x244
  803e59:	68 e5 4a 80 00       	push   $0x804ae5
  803e5e:	e8 e8 c8 ff ff       	call   80074b <_panic>
  803e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e66:	8b 10                	mov    (%eax),%edx
  803e68:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e6b:	89 10                	mov    %edx,(%eax)
  803e6d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e70:	8b 00                	mov    (%eax),%eax
  803e72:	85 c0                	test   %eax,%eax
  803e74:	74 0b                	je     803e81 <realloc_block_FF+0x648>
  803e76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e79:	8b 00                	mov    (%eax),%eax
  803e7b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e7e:	89 50 04             	mov    %edx,0x4(%eax)
  803e81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e84:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e87:	89 10                	mov    %edx,(%eax)
  803e89:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e8f:	89 50 04             	mov    %edx,0x4(%eax)
  803e92:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e95:	8b 00                	mov    (%eax),%eax
  803e97:	85 c0                	test   %eax,%eax
  803e99:	75 08                	jne    803ea3 <realloc_block_FF+0x66a>
  803e9b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e9e:	a3 34 50 80 00       	mov    %eax,0x805034
  803ea3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ea8:	40                   	inc    %eax
  803ea9:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803eae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803eb2:	75 17                	jne    803ecb <realloc_block_FF+0x692>
  803eb4:	83 ec 04             	sub    $0x4,%esp
  803eb7:	68 c7 4a 80 00       	push   $0x804ac7
  803ebc:	68 45 02 00 00       	push   $0x245
  803ec1:	68 e5 4a 80 00       	push   $0x804ae5
  803ec6:	e8 80 c8 ff ff       	call   80074b <_panic>
  803ecb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ece:	8b 00                	mov    (%eax),%eax
  803ed0:	85 c0                	test   %eax,%eax
  803ed2:	74 10                	je     803ee4 <realloc_block_FF+0x6ab>
  803ed4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed7:	8b 00                	mov    (%eax),%eax
  803ed9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803edc:	8b 52 04             	mov    0x4(%edx),%edx
  803edf:	89 50 04             	mov    %edx,0x4(%eax)
  803ee2:	eb 0b                	jmp    803eef <realloc_block_FF+0x6b6>
  803ee4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee7:	8b 40 04             	mov    0x4(%eax),%eax
  803eea:	a3 34 50 80 00       	mov    %eax,0x805034
  803eef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef2:	8b 40 04             	mov    0x4(%eax),%eax
  803ef5:	85 c0                	test   %eax,%eax
  803ef7:	74 0f                	je     803f08 <realloc_block_FF+0x6cf>
  803ef9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efc:	8b 40 04             	mov    0x4(%eax),%eax
  803eff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f02:	8b 12                	mov    (%edx),%edx
  803f04:	89 10                	mov    %edx,(%eax)
  803f06:	eb 0a                	jmp    803f12 <realloc_block_FF+0x6d9>
  803f08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f0b:	8b 00                	mov    (%eax),%eax
  803f0d:	a3 30 50 80 00       	mov    %eax,0x805030
  803f12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f25:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f2a:	48                   	dec    %eax
  803f2b:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803f30:	83 ec 04             	sub    $0x4,%esp
  803f33:	6a 00                	push   $0x0
  803f35:	ff 75 bc             	pushl  -0x44(%ebp)
  803f38:	ff 75 b8             	pushl  -0x48(%ebp)
  803f3b:	e8 06 e9 ff ff       	call   802846 <set_block_data>
  803f40:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803f43:	8b 45 08             	mov    0x8(%ebp),%eax
  803f46:	eb 0a                	jmp    803f52 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803f48:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803f4f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803f52:	c9                   	leave  
  803f53:	c3                   	ret    

00803f54 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803f54:	55                   	push   %ebp
  803f55:	89 e5                	mov    %esp,%ebp
  803f57:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803f5a:	83 ec 04             	sub    $0x4,%esp
  803f5d:	68 dc 4b 80 00       	push   $0x804bdc
  803f62:	68 58 02 00 00       	push   $0x258
  803f67:	68 e5 4a 80 00       	push   $0x804ae5
  803f6c:	e8 da c7 ff ff       	call   80074b <_panic>

00803f71 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803f71:	55                   	push   %ebp
  803f72:	89 e5                	mov    %esp,%ebp
  803f74:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803f77:	83 ec 04             	sub    $0x4,%esp
  803f7a:	68 04 4c 80 00       	push   $0x804c04
  803f7f:	68 61 02 00 00       	push   $0x261
  803f84:	68 e5 4a 80 00       	push   $0x804ae5
  803f89:	e8 bd c7 ff ff       	call   80074b <_panic>
  803f8e:	66 90                	xchg   %ax,%ax

00803f90 <__udivdi3>:
  803f90:	55                   	push   %ebp
  803f91:	57                   	push   %edi
  803f92:	56                   	push   %esi
  803f93:	53                   	push   %ebx
  803f94:	83 ec 1c             	sub    $0x1c,%esp
  803f97:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f9b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fa3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803fa7:	89 ca                	mov    %ecx,%edx
  803fa9:	89 f8                	mov    %edi,%eax
  803fab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803faf:	85 f6                	test   %esi,%esi
  803fb1:	75 2d                	jne    803fe0 <__udivdi3+0x50>
  803fb3:	39 cf                	cmp    %ecx,%edi
  803fb5:	77 65                	ja     80401c <__udivdi3+0x8c>
  803fb7:	89 fd                	mov    %edi,%ebp
  803fb9:	85 ff                	test   %edi,%edi
  803fbb:	75 0b                	jne    803fc8 <__udivdi3+0x38>
  803fbd:	b8 01 00 00 00       	mov    $0x1,%eax
  803fc2:	31 d2                	xor    %edx,%edx
  803fc4:	f7 f7                	div    %edi
  803fc6:	89 c5                	mov    %eax,%ebp
  803fc8:	31 d2                	xor    %edx,%edx
  803fca:	89 c8                	mov    %ecx,%eax
  803fcc:	f7 f5                	div    %ebp
  803fce:	89 c1                	mov    %eax,%ecx
  803fd0:	89 d8                	mov    %ebx,%eax
  803fd2:	f7 f5                	div    %ebp
  803fd4:	89 cf                	mov    %ecx,%edi
  803fd6:	89 fa                	mov    %edi,%edx
  803fd8:	83 c4 1c             	add    $0x1c,%esp
  803fdb:	5b                   	pop    %ebx
  803fdc:	5e                   	pop    %esi
  803fdd:	5f                   	pop    %edi
  803fde:	5d                   	pop    %ebp
  803fdf:	c3                   	ret    
  803fe0:	39 ce                	cmp    %ecx,%esi
  803fe2:	77 28                	ja     80400c <__udivdi3+0x7c>
  803fe4:	0f bd fe             	bsr    %esi,%edi
  803fe7:	83 f7 1f             	xor    $0x1f,%edi
  803fea:	75 40                	jne    80402c <__udivdi3+0x9c>
  803fec:	39 ce                	cmp    %ecx,%esi
  803fee:	72 0a                	jb     803ffa <__udivdi3+0x6a>
  803ff0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ff4:	0f 87 9e 00 00 00    	ja     804098 <__udivdi3+0x108>
  803ffa:	b8 01 00 00 00       	mov    $0x1,%eax
  803fff:	89 fa                	mov    %edi,%edx
  804001:	83 c4 1c             	add    $0x1c,%esp
  804004:	5b                   	pop    %ebx
  804005:	5e                   	pop    %esi
  804006:	5f                   	pop    %edi
  804007:	5d                   	pop    %ebp
  804008:	c3                   	ret    
  804009:	8d 76 00             	lea    0x0(%esi),%esi
  80400c:	31 ff                	xor    %edi,%edi
  80400e:	31 c0                	xor    %eax,%eax
  804010:	89 fa                	mov    %edi,%edx
  804012:	83 c4 1c             	add    $0x1c,%esp
  804015:	5b                   	pop    %ebx
  804016:	5e                   	pop    %esi
  804017:	5f                   	pop    %edi
  804018:	5d                   	pop    %ebp
  804019:	c3                   	ret    
  80401a:	66 90                	xchg   %ax,%ax
  80401c:	89 d8                	mov    %ebx,%eax
  80401e:	f7 f7                	div    %edi
  804020:	31 ff                	xor    %edi,%edi
  804022:	89 fa                	mov    %edi,%edx
  804024:	83 c4 1c             	add    $0x1c,%esp
  804027:	5b                   	pop    %ebx
  804028:	5e                   	pop    %esi
  804029:	5f                   	pop    %edi
  80402a:	5d                   	pop    %ebp
  80402b:	c3                   	ret    
  80402c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804031:	89 eb                	mov    %ebp,%ebx
  804033:	29 fb                	sub    %edi,%ebx
  804035:	89 f9                	mov    %edi,%ecx
  804037:	d3 e6                	shl    %cl,%esi
  804039:	89 c5                	mov    %eax,%ebp
  80403b:	88 d9                	mov    %bl,%cl
  80403d:	d3 ed                	shr    %cl,%ebp
  80403f:	89 e9                	mov    %ebp,%ecx
  804041:	09 f1                	or     %esi,%ecx
  804043:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804047:	89 f9                	mov    %edi,%ecx
  804049:	d3 e0                	shl    %cl,%eax
  80404b:	89 c5                	mov    %eax,%ebp
  80404d:	89 d6                	mov    %edx,%esi
  80404f:	88 d9                	mov    %bl,%cl
  804051:	d3 ee                	shr    %cl,%esi
  804053:	89 f9                	mov    %edi,%ecx
  804055:	d3 e2                	shl    %cl,%edx
  804057:	8b 44 24 08          	mov    0x8(%esp),%eax
  80405b:	88 d9                	mov    %bl,%cl
  80405d:	d3 e8                	shr    %cl,%eax
  80405f:	09 c2                	or     %eax,%edx
  804061:	89 d0                	mov    %edx,%eax
  804063:	89 f2                	mov    %esi,%edx
  804065:	f7 74 24 0c          	divl   0xc(%esp)
  804069:	89 d6                	mov    %edx,%esi
  80406b:	89 c3                	mov    %eax,%ebx
  80406d:	f7 e5                	mul    %ebp
  80406f:	39 d6                	cmp    %edx,%esi
  804071:	72 19                	jb     80408c <__udivdi3+0xfc>
  804073:	74 0b                	je     804080 <__udivdi3+0xf0>
  804075:	89 d8                	mov    %ebx,%eax
  804077:	31 ff                	xor    %edi,%edi
  804079:	e9 58 ff ff ff       	jmp    803fd6 <__udivdi3+0x46>
  80407e:	66 90                	xchg   %ax,%ax
  804080:	8b 54 24 08          	mov    0x8(%esp),%edx
  804084:	89 f9                	mov    %edi,%ecx
  804086:	d3 e2                	shl    %cl,%edx
  804088:	39 c2                	cmp    %eax,%edx
  80408a:	73 e9                	jae    804075 <__udivdi3+0xe5>
  80408c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80408f:	31 ff                	xor    %edi,%edi
  804091:	e9 40 ff ff ff       	jmp    803fd6 <__udivdi3+0x46>
  804096:	66 90                	xchg   %ax,%ax
  804098:	31 c0                	xor    %eax,%eax
  80409a:	e9 37 ff ff ff       	jmp    803fd6 <__udivdi3+0x46>
  80409f:	90                   	nop

008040a0 <__umoddi3>:
  8040a0:	55                   	push   %ebp
  8040a1:	57                   	push   %edi
  8040a2:	56                   	push   %esi
  8040a3:	53                   	push   %ebx
  8040a4:	83 ec 1c             	sub    $0x1c,%esp
  8040a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8040ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8040af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040bf:	89 f3                	mov    %esi,%ebx
  8040c1:	89 fa                	mov    %edi,%edx
  8040c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040c7:	89 34 24             	mov    %esi,(%esp)
  8040ca:	85 c0                	test   %eax,%eax
  8040cc:	75 1a                	jne    8040e8 <__umoddi3+0x48>
  8040ce:	39 f7                	cmp    %esi,%edi
  8040d0:	0f 86 a2 00 00 00    	jbe    804178 <__umoddi3+0xd8>
  8040d6:	89 c8                	mov    %ecx,%eax
  8040d8:	89 f2                	mov    %esi,%edx
  8040da:	f7 f7                	div    %edi
  8040dc:	89 d0                	mov    %edx,%eax
  8040de:	31 d2                	xor    %edx,%edx
  8040e0:	83 c4 1c             	add    $0x1c,%esp
  8040e3:	5b                   	pop    %ebx
  8040e4:	5e                   	pop    %esi
  8040e5:	5f                   	pop    %edi
  8040e6:	5d                   	pop    %ebp
  8040e7:	c3                   	ret    
  8040e8:	39 f0                	cmp    %esi,%eax
  8040ea:	0f 87 ac 00 00 00    	ja     80419c <__umoddi3+0xfc>
  8040f0:	0f bd e8             	bsr    %eax,%ebp
  8040f3:	83 f5 1f             	xor    $0x1f,%ebp
  8040f6:	0f 84 ac 00 00 00    	je     8041a8 <__umoddi3+0x108>
  8040fc:	bf 20 00 00 00       	mov    $0x20,%edi
  804101:	29 ef                	sub    %ebp,%edi
  804103:	89 fe                	mov    %edi,%esi
  804105:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804109:	89 e9                	mov    %ebp,%ecx
  80410b:	d3 e0                	shl    %cl,%eax
  80410d:	89 d7                	mov    %edx,%edi
  80410f:	89 f1                	mov    %esi,%ecx
  804111:	d3 ef                	shr    %cl,%edi
  804113:	09 c7                	or     %eax,%edi
  804115:	89 e9                	mov    %ebp,%ecx
  804117:	d3 e2                	shl    %cl,%edx
  804119:	89 14 24             	mov    %edx,(%esp)
  80411c:	89 d8                	mov    %ebx,%eax
  80411e:	d3 e0                	shl    %cl,%eax
  804120:	89 c2                	mov    %eax,%edx
  804122:	8b 44 24 08          	mov    0x8(%esp),%eax
  804126:	d3 e0                	shl    %cl,%eax
  804128:	89 44 24 04          	mov    %eax,0x4(%esp)
  80412c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804130:	89 f1                	mov    %esi,%ecx
  804132:	d3 e8                	shr    %cl,%eax
  804134:	09 d0                	or     %edx,%eax
  804136:	d3 eb                	shr    %cl,%ebx
  804138:	89 da                	mov    %ebx,%edx
  80413a:	f7 f7                	div    %edi
  80413c:	89 d3                	mov    %edx,%ebx
  80413e:	f7 24 24             	mull   (%esp)
  804141:	89 c6                	mov    %eax,%esi
  804143:	89 d1                	mov    %edx,%ecx
  804145:	39 d3                	cmp    %edx,%ebx
  804147:	0f 82 87 00 00 00    	jb     8041d4 <__umoddi3+0x134>
  80414d:	0f 84 91 00 00 00    	je     8041e4 <__umoddi3+0x144>
  804153:	8b 54 24 04          	mov    0x4(%esp),%edx
  804157:	29 f2                	sub    %esi,%edx
  804159:	19 cb                	sbb    %ecx,%ebx
  80415b:	89 d8                	mov    %ebx,%eax
  80415d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804161:	d3 e0                	shl    %cl,%eax
  804163:	89 e9                	mov    %ebp,%ecx
  804165:	d3 ea                	shr    %cl,%edx
  804167:	09 d0                	or     %edx,%eax
  804169:	89 e9                	mov    %ebp,%ecx
  80416b:	d3 eb                	shr    %cl,%ebx
  80416d:	89 da                	mov    %ebx,%edx
  80416f:	83 c4 1c             	add    $0x1c,%esp
  804172:	5b                   	pop    %ebx
  804173:	5e                   	pop    %esi
  804174:	5f                   	pop    %edi
  804175:	5d                   	pop    %ebp
  804176:	c3                   	ret    
  804177:	90                   	nop
  804178:	89 fd                	mov    %edi,%ebp
  80417a:	85 ff                	test   %edi,%edi
  80417c:	75 0b                	jne    804189 <__umoddi3+0xe9>
  80417e:	b8 01 00 00 00       	mov    $0x1,%eax
  804183:	31 d2                	xor    %edx,%edx
  804185:	f7 f7                	div    %edi
  804187:	89 c5                	mov    %eax,%ebp
  804189:	89 f0                	mov    %esi,%eax
  80418b:	31 d2                	xor    %edx,%edx
  80418d:	f7 f5                	div    %ebp
  80418f:	89 c8                	mov    %ecx,%eax
  804191:	f7 f5                	div    %ebp
  804193:	89 d0                	mov    %edx,%eax
  804195:	e9 44 ff ff ff       	jmp    8040de <__umoddi3+0x3e>
  80419a:	66 90                	xchg   %ax,%ax
  80419c:	89 c8                	mov    %ecx,%eax
  80419e:	89 f2                	mov    %esi,%edx
  8041a0:	83 c4 1c             	add    $0x1c,%esp
  8041a3:	5b                   	pop    %ebx
  8041a4:	5e                   	pop    %esi
  8041a5:	5f                   	pop    %edi
  8041a6:	5d                   	pop    %ebp
  8041a7:	c3                   	ret    
  8041a8:	3b 04 24             	cmp    (%esp),%eax
  8041ab:	72 06                	jb     8041b3 <__umoddi3+0x113>
  8041ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8041b1:	77 0f                	ja     8041c2 <__umoddi3+0x122>
  8041b3:	89 f2                	mov    %esi,%edx
  8041b5:	29 f9                	sub    %edi,%ecx
  8041b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8041bb:	89 14 24             	mov    %edx,(%esp)
  8041be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041c6:	8b 14 24             	mov    (%esp),%edx
  8041c9:	83 c4 1c             	add    $0x1c,%esp
  8041cc:	5b                   	pop    %ebx
  8041cd:	5e                   	pop    %esi
  8041ce:	5f                   	pop    %edi
  8041cf:	5d                   	pop    %ebp
  8041d0:	c3                   	ret    
  8041d1:	8d 76 00             	lea    0x0(%esi),%esi
  8041d4:	2b 04 24             	sub    (%esp),%eax
  8041d7:	19 fa                	sbb    %edi,%edx
  8041d9:	89 d1                	mov    %edx,%ecx
  8041db:	89 c6                	mov    %eax,%esi
  8041dd:	e9 71 ff ff ff       	jmp    804153 <__umoddi3+0xb3>
  8041e2:	66 90                	xchg   %ax,%ax
  8041e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041e8:	72 ea                	jb     8041d4 <__umoddi3+0x134>
  8041ea:	89 d9                	mov    %ebx,%ecx
  8041ec:	e9 62 ff ff ff       	jmp    804153 <__umoddi3+0xb3>
