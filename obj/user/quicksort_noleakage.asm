
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
  800041:	e8 16 1f 00 00       	call   801f5c <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 42 80 00       	push   $0x804220
  80004e:	e8 b5 09 00 00       	call   800a08 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 42 80 00       	push   $0x804222
  80005e:	e8 a5 09 00 00       	call   800a08 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 3b 42 80 00       	push   $0x80423b
  80006e:	e8 95 09 00 00       	call   800a08 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 42 80 00       	push   $0x804222
  80007e:	e8 85 09 00 00       	call   800a08 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 42 80 00       	push   $0x804220
  80008e:	e8 75 09 00 00       	call   800a08 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 54 42 80 00       	push   $0x804254
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
  8000c9:	68 74 42 80 00       	push   $0x804274
  8000ce:	e8 35 09 00 00       	call   800a08 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 96 42 80 00       	push   $0x804296
  8000de:	e8 25 09 00 00       	call   800a08 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 a4 42 80 00       	push   $0x8042a4
  8000ee:	e8 15 09 00 00       	call   800a08 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 b3 42 80 00       	push   $0x8042b3
  8000fe:	e8 05 09 00 00       	call   800a08 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 c3 42 80 00       	push   $0x8042c3
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
  80014d:	e8 24 1e 00 00       	call   801f76 <sys_unlock_cons>
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
  8001d5:	e8 82 1d 00 00       	call   801f5c <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 cc 42 80 00       	push   $0x8042cc
  8001e2:	e8 21 08 00 00       	call   800a08 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 87 1d 00 00       	call   801f76 <sys_unlock_cons>
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
  80020c:	68 00 43 80 00       	push   $0x804300
  800211:	6a 54                	push   $0x54
  800213:	68 22 43 80 00       	push   $0x804322
  800218:	e8 2e 05 00 00       	call   80074b <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 3a 1d 00 00       	call   801f5c <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 40 43 80 00       	push   $0x804340
  80022a:	e8 d9 07 00 00       	call   800a08 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 74 43 80 00       	push   $0x804374
  80023a:	e8 c9 07 00 00       	call   800a08 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 a8 43 80 00       	push   $0x8043a8
  80024a:	e8 b9 07 00 00       	call   800a08 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 1f 1d 00 00       	call   801f76 <sys_unlock_cons>
			//			sys_unlock_cons();


		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 ec             	pushl  -0x14(%ebp)
  80025d:	e8 7d 19 00 00       	call   801bdf <free>
  800262:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
  800265:	e8 f2 1c 00 00       	call   801f5c <sys_lock_cons>
		{
			Chose = 0 ;
  80026a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  80026e:	eb 42                	jmp    8002b2 <_main+0x27a>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 da 43 80 00       	push   $0x8043da
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
  8002be:	e8 b3 1c 00 00       	call   801f76 <sys_unlock_cons>
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
  800570:	68 20 42 80 00       	push   $0x804220
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
  800592:	68 f8 43 80 00       	push   $0x8043f8
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
  8005c0:	68 fd 43 80 00       	push   $0x8043fd
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
  8005e4:	e8 be 1a 00 00       	call   8020a7 <sys_cputc>
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
  8005f5:	e8 49 19 00 00       	call   801f43 <sys_cgetc>
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
  800612:	e8 c1 1b 00 00       	call   8021d8 <sys_getenvindex>
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
  800680:	e8 d7 18 00 00       	call   801f5c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800685:	83 ec 0c             	sub    $0xc,%esp
  800688:	68 1c 44 80 00       	push   $0x80441c
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
  8006b0:	68 44 44 80 00       	push   $0x804444
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
  8006e1:	68 6c 44 80 00       	push   $0x80446c
  8006e6:	e8 1d 03 00 00       	call   800a08 <cprintf>
  8006eb:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f3:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	50                   	push   %eax
  8006fd:	68 c4 44 80 00       	push   $0x8044c4
  800702:	e8 01 03 00 00       	call   800a08 <cprintf>
  800707:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 1c 44 80 00       	push   $0x80441c
  800712:	e8 f1 02 00 00       	call   800a08 <cprintf>
  800717:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80071a:	e8 57 18 00 00       	call   801f76 <sys_unlock_cons>
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
  800732:	e8 6d 1a 00 00       	call   8021a4 <sys_destroy_env>
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
  800743:	e8 c2 1a 00 00       	call   80220a <sys_exit_env>
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
  80076c:	68 d8 44 80 00       	push   $0x8044d8
  800771:	e8 92 02 00 00       	call   800a08 <cprintf>
  800776:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800779:	a1 00 50 80 00       	mov    0x805000,%eax
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	ff 75 08             	pushl  0x8(%ebp)
  800784:	50                   	push   %eax
  800785:	68 dd 44 80 00       	push   $0x8044dd
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
  8007a9:	68 f9 44 80 00       	push   $0x8044f9
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
  8007d8:	68 fc 44 80 00       	push   $0x8044fc
  8007dd:	6a 26                	push   $0x26
  8007df:	68 48 45 80 00       	push   $0x804548
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
  8008ad:	68 54 45 80 00       	push   $0x804554
  8008b2:	6a 3a                	push   $0x3a
  8008b4:	68 48 45 80 00       	push   $0x804548
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
  800920:	68 a8 45 80 00       	push   $0x8045a8
  800925:	6a 44                	push   $0x44
  800927:	68 48 45 80 00       	push   $0x804548
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
  80097a:	e8 9b 15 00 00       	call   801f1a <sys_cputs>
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
  8009f1:	e8 24 15 00 00       	call   801f1a <sys_cputs>
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
  800a3b:	e8 1c 15 00 00       	call   801f5c <sys_lock_cons>
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
  800a5b:	e8 16 15 00 00       	call   801f76 <sys_unlock_cons>
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
  800aa5:	e8 0a 35 00 00       	call   803fb4 <__udivdi3>
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
  800af5:	e8 ca 35 00 00       	call   8040c4 <__umoddi3>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	05 14 48 80 00       	add    $0x804814,%eax
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
  800c50:	8b 04 85 38 48 80 00 	mov    0x804838(,%eax,4),%eax
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
  800d31:	8b 34 9d 80 46 80 00 	mov    0x804680(,%ebx,4),%esi
  800d38:	85 f6                	test   %esi,%esi
  800d3a:	75 19                	jne    800d55 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d3c:	53                   	push   %ebx
  800d3d:	68 25 48 80 00       	push   $0x804825
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
  800d56:	68 2e 48 80 00       	push   $0x80482e
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
  800d83:	be 31 48 80 00       	mov    $0x804831,%esi
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
  8010ae:	68 a8 49 80 00       	push   $0x8049a8
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
  8010f0:	68 ab 49 80 00       	push   $0x8049ab
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
  8011a1:	e8 b6 0d 00 00       	call   801f5c <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8011a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011aa:	74 13                	je     8011bf <atomic_readline+0x24>
			cprintf("%s", prompt);
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	ff 75 08             	pushl  0x8(%ebp)
  8011b2:	68 a8 49 80 00       	push   $0x8049a8
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
  8011f4:	68 ab 49 80 00       	push   $0x8049ab
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
  80129c:	e8 d5 0c 00 00       	call   801f76 <sys_unlock_cons>
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
  801996:	68 bc 49 80 00       	push   $0x8049bc
  80199b:	68 3f 01 00 00       	push   $0x13f
  8019a0:	68 de 49 80 00       	push   $0x8049de
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
  8019b6:	e8 0a 0b 00 00       	call   8024c5 <sys_sbrk>
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
  801a31:	e8 13 09 00 00       	call   802349 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a36:	85 c0                	test   %eax,%eax
  801a38:	74 16                	je     801a50 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a3a:	83 ec 0c             	sub    $0xc,%esp
  801a3d:	ff 75 08             	pushl  0x8(%ebp)
  801a40:	e8 53 0e 00 00       	call   802898 <alloc_block_FF>
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a4b:	e9 8a 01 00 00       	jmp    801bda <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801a50:	e8 25 09 00 00       	call   80237a <sys_isUHeapPlacementStrategyBESTFIT>
  801a55:	85 c0                	test   %eax,%eax
  801a57:	0f 84 7d 01 00 00    	je     801bda <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801a5d:	83 ec 0c             	sub    $0xc,%esp
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	e8 ec 12 00 00       	call   802d54 <alloc_block_BF>
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
  801bc9:	e8 2e 09 00 00       	call   8024fc <sys_allocate_user_mem>
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
  801c11:	e8 02 09 00 00       	call   802518 <get_block_size>
  801c16:	83 c4 10             	add    $0x10,%esp
  801c19:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c1c:	83 ec 0c             	sub    $0xc,%esp
  801c1f:	ff 75 08             	pushl  0x8(%ebp)
  801c22:	e8 35 1b 00 00       	call   80375c <free_block>
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
  801cb9:	e8 22 08 00 00       	call   8024e0 <sys_free_user_mem>
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
  801cc7:	68 ec 49 80 00       	push   $0x8049ec
  801ccc:	68 85 00 00 00       	push   $0x85
  801cd1:	68 16 4a 80 00       	push   $0x804a16
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
  801d3c:	e8 a6 03 00 00       	call   8020e7 <sys_createSharedObject>
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
  801d60:	68 22 4a 80 00       	push   $0x804a22
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
  801da4:	e8 68 03 00 00       	call   802111 <sys_getSizeOfSharedObject>
  801da9:	83 c4 10             	add    $0x10,%esp
  801dac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801daf:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801db3:	75 07                	jne    801dbc <sget+0x27>
  801db5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dba:	eb 7f                	jmp    801e3b <sget+0xa6>
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
  801def:	eb 4a                	jmp    801e3b <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	ff 75 e8             	pushl  -0x18(%ebp)
  801df7:	ff 75 0c             	pushl  0xc(%ebp)
  801dfa:	ff 75 08             	pushl  0x8(%ebp)
  801dfd:	e8 2c 03 00 00       	call   80212e <sys_getSharedObject>
  801e02:	83 c4 10             	add    $0x10,%esp
  801e05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801e08:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e0b:	a1 24 50 80 00       	mov    0x805024,%eax
  801e10:	8b 40 78             	mov    0x78(%eax),%eax
  801e13:	29 c2                	sub    %eax,%edx
  801e15:	89 d0                	mov    %edx,%eax
  801e17:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e1c:	c1 e8 0c             	shr    $0xc,%eax
  801e1f:	89 c2                	mov    %eax,%edx
  801e21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e24:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801e2b:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801e2f:	75 07                	jne    801e38 <sget+0xa3>
  801e31:	b8 00 00 00 00       	mov    $0x0,%eax
  801e36:	eb 03                	jmp    801e3b <sget+0xa6>
	return ptr;
  801e38:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801e43:	8b 55 08             	mov    0x8(%ebp),%edx
  801e46:	a1 24 50 80 00       	mov    0x805024,%eax
  801e4b:	8b 40 78             	mov    0x78(%eax),%eax
  801e4e:	29 c2                	sub    %eax,%edx
  801e50:	89 d0                	mov    %edx,%eax
  801e52:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e57:	c1 e8 0c             	shr    $0xc,%eax
  801e5a:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801e64:	83 ec 08             	sub    $0x8,%esp
  801e67:	ff 75 08             	pushl  0x8(%ebp)
  801e6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6d:	e8 db 02 00 00       	call   80214d <sys_freeSharedObject>
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801e78:	90                   	nop
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e81:	83 ec 04             	sub    $0x4,%esp
  801e84:	68 34 4a 80 00       	push   $0x804a34
  801e89:	68 de 00 00 00       	push   $0xde
  801e8e:	68 16 4a 80 00       	push   $0x804a16
  801e93:	e8 b3 e8 ff ff       	call   80074b <_panic>

00801e98 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e9e:	83 ec 04             	sub    $0x4,%esp
  801ea1:	68 5a 4a 80 00       	push   $0x804a5a
  801ea6:	68 ea 00 00 00       	push   $0xea
  801eab:	68 16 4a 80 00       	push   $0x804a16
  801eb0:	e8 96 e8 ff ff       	call   80074b <_panic>

00801eb5 <shrink>:

}
void shrink(uint32 newSize)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ebb:	83 ec 04             	sub    $0x4,%esp
  801ebe:	68 5a 4a 80 00       	push   $0x804a5a
  801ec3:	68 ef 00 00 00       	push   $0xef
  801ec8:	68 16 4a 80 00       	push   $0x804a16
  801ecd:	e8 79 e8 ff ff       	call   80074b <_panic>

00801ed2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ed8:	83 ec 04             	sub    $0x4,%esp
  801edb:	68 5a 4a 80 00       	push   $0x804a5a
  801ee0:	68 f4 00 00 00       	push   $0xf4
  801ee5:	68 16 4a 80 00       	push   $0x804a16
  801eea:	e8 5c e8 ff ff       	call   80074b <_panic>

00801eef <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	57                   	push   %edi
  801ef3:	56                   	push   %esi
  801ef4:	53                   	push   %ebx
  801ef5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f01:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f04:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f07:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f0a:	cd 30                	int    $0x30
  801f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f12:	83 c4 10             	add    $0x10,%esp
  801f15:	5b                   	pop    %ebx
  801f16:	5e                   	pop    %esi
  801f17:	5f                   	pop    %edi
  801f18:	5d                   	pop    %ebp
  801f19:	c3                   	ret    

00801f1a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 04             	sub    $0x4,%esp
  801f20:	8b 45 10             	mov    0x10(%ebp),%eax
  801f23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f26:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	52                   	push   %edx
  801f32:	ff 75 0c             	pushl  0xc(%ebp)
  801f35:	50                   	push   %eax
  801f36:	6a 00                	push   $0x0
  801f38:	e8 b2 ff ff ff       	call   801eef <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
}
  801f40:	90                   	nop
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 02                	push   $0x2
  801f52:	e8 98 ff ff ff       	call   801eef <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_lock_cons>:

void sys_lock_cons(void)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 03                	push   $0x3
  801f6b:	e8 7f ff ff ff       	call   801eef <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
}
  801f73:	90                   	nop
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 04                	push   $0x4
  801f85:	e8 65 ff ff ff       	call   801eef <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
}
  801f8d:	90                   	nop
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	52                   	push   %edx
  801fa0:	50                   	push   %eax
  801fa1:	6a 08                	push   $0x8
  801fa3:	e8 47 ff ff ff       	call   801eef <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	56                   	push   %esi
  801fb1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fb2:	8b 75 18             	mov    0x18(%ebp),%esi
  801fb5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fb8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	56                   	push   %esi
  801fc2:	53                   	push   %ebx
  801fc3:	51                   	push   %ecx
  801fc4:	52                   	push   %edx
  801fc5:	50                   	push   %eax
  801fc6:	6a 09                	push   $0x9
  801fc8:	e8 22 ff ff ff       	call   801eef <syscall>
  801fcd:	83 c4 18             	add    $0x18,%esp
}
  801fd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd3:	5b                   	pop    %ebx
  801fd4:	5e                   	pop    %esi
  801fd5:	5d                   	pop    %ebp
  801fd6:	c3                   	ret    

00801fd7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	52                   	push   %edx
  801fe7:	50                   	push   %eax
  801fe8:	6a 0a                	push   $0xa
  801fea:	e8 00 ff ff ff       	call   801eef <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	ff 75 0c             	pushl  0xc(%ebp)
  802000:	ff 75 08             	pushl  0x8(%ebp)
  802003:	6a 0b                	push   $0xb
  802005:	e8 e5 fe ff ff       	call   801eef <syscall>
  80200a:	83 c4 18             	add    $0x18,%esp
}
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 0c                	push   $0xc
  80201e:	e8 cc fe ff ff       	call   801eef <syscall>
  802023:	83 c4 18             	add    $0x18,%esp
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 0d                	push   $0xd
  802037:	e8 b3 fe ff ff       	call   801eef <syscall>
  80203c:	83 c4 18             	add    $0x18,%esp
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 0e                	push   $0xe
  802050:	e8 9a fe ff ff       	call   801eef <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 0f                	push   $0xf
  802069:	e8 81 fe ff ff       	call   801eef <syscall>
  80206e:	83 c4 18             	add    $0x18,%esp
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	ff 75 08             	pushl  0x8(%ebp)
  802081:	6a 10                	push   $0x10
  802083:	e8 67 fe ff ff       	call   801eef <syscall>
  802088:	83 c4 18             	add    $0x18,%esp
}
  80208b:	c9                   	leave  
  80208c:	c3                   	ret    

0080208d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 11                	push   $0x11
  80209c:	e8 4e fe ff ff       	call   801eef <syscall>
  8020a1:	83 c4 18             	add    $0x18,%esp
}
  8020a4:	90                   	nop
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <sys_cputc>:

void
sys_cputc(const char c)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 04             	sub    $0x4,%esp
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020b3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	50                   	push   %eax
  8020c0:	6a 01                	push   $0x1
  8020c2:	e8 28 fe ff ff       	call   801eef <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
}
  8020ca:	90                   	nop
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 14                	push   $0x14
  8020dc:	e8 0e fe ff ff       	call   801eef <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
}
  8020e4:	90                   	nop
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 04             	sub    $0x4,%esp
  8020ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020f3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	6a 00                	push   $0x0
  8020ff:	51                   	push   %ecx
  802100:	52                   	push   %edx
  802101:	ff 75 0c             	pushl  0xc(%ebp)
  802104:	50                   	push   %eax
  802105:	6a 15                	push   $0x15
  802107:	e8 e3 fd ff ff       	call   801eef <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802114:	8b 55 0c             	mov    0xc(%ebp),%edx
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	52                   	push   %edx
  802121:	50                   	push   %eax
  802122:	6a 16                	push   $0x16
  802124:	e8 c6 fd ff ff       	call   801eef <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802131:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802134:	8b 55 0c             	mov    0xc(%ebp),%edx
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	51                   	push   %ecx
  80213f:	52                   	push   %edx
  802140:	50                   	push   %eax
  802141:	6a 17                	push   $0x17
  802143:	e8 a7 fd ff ff       	call   801eef <syscall>
  802148:	83 c4 18             	add    $0x18,%esp
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802150:	8b 55 0c             	mov    0xc(%ebp),%edx
  802153:	8b 45 08             	mov    0x8(%ebp),%eax
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	52                   	push   %edx
  80215d:	50                   	push   %eax
  80215e:	6a 18                	push   $0x18
  802160:	e8 8a fd ff ff       	call   801eef <syscall>
  802165:	83 c4 18             	add    $0x18,%esp
}
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	6a 00                	push   $0x0
  802172:	ff 75 14             	pushl  0x14(%ebp)
  802175:	ff 75 10             	pushl  0x10(%ebp)
  802178:	ff 75 0c             	pushl  0xc(%ebp)
  80217b:	50                   	push   %eax
  80217c:	6a 19                	push   $0x19
  80217e:	e8 6c fd ff ff       	call   801eef <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	50                   	push   %eax
  802197:	6a 1a                	push   $0x1a
  802199:	e8 51 fd ff ff       	call   801eef <syscall>
  80219e:	83 c4 18             	add    $0x18,%esp
}
  8021a1:	90                   	nop
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	50                   	push   %eax
  8021b3:	6a 1b                	push   $0x1b
  8021b5:	e8 35 fd ff ff       	call   801eef <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_getenvid>:

int32 sys_getenvid(void)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 05                	push   $0x5
  8021ce:	e8 1c fd ff ff       	call   801eef <syscall>
  8021d3:	83 c4 18             	add    $0x18,%esp
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 06                	push   $0x6
  8021e7:	e8 03 fd ff ff       	call   801eef <syscall>
  8021ec:	83 c4 18             	add    $0x18,%esp
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 07                	push   $0x7
  802200:	e8 ea fc ff ff       	call   801eef <syscall>
  802205:	83 c4 18             	add    $0x18,%esp
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <sys_exit_env>:


void sys_exit_env(void)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 1c                	push   $0x1c
  802219:	e8 d1 fc ff ff       	call   801eef <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
}
  802221:	90                   	nop
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80222a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80222d:	8d 50 04             	lea    0x4(%eax),%edx
  802230:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	52                   	push   %edx
  80223a:	50                   	push   %eax
  80223b:	6a 1d                	push   $0x1d
  80223d:	e8 ad fc ff ff       	call   801eef <syscall>
  802242:	83 c4 18             	add    $0x18,%esp
	return result;
  802245:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802248:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80224b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80224e:	89 01                	mov    %eax,(%ecx)
  802250:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	c9                   	leave  
  802257:	c2 04 00             	ret    $0x4

0080225a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	ff 75 10             	pushl  0x10(%ebp)
  802264:	ff 75 0c             	pushl  0xc(%ebp)
  802267:	ff 75 08             	pushl  0x8(%ebp)
  80226a:	6a 13                	push   $0x13
  80226c:	e8 7e fc ff ff       	call   801eef <syscall>
  802271:	83 c4 18             	add    $0x18,%esp
	return ;
  802274:	90                   	nop
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_rcr2>:
uint32 sys_rcr2()
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 1e                	push   $0x1e
  802286:	e8 64 fc ff ff       	call   801eef <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
}
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80229c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	50                   	push   %eax
  8022a9:	6a 1f                	push   $0x1f
  8022ab:	e8 3f fc ff ff       	call   801eef <syscall>
  8022b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b3:	90                   	nop
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <rsttst>:
void rsttst()
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 21                	push   $0x21
  8022c5:	e8 25 fc ff ff       	call   801eef <syscall>
  8022ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8022cd:	90                   	nop
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	83 ec 04             	sub    $0x4,%esp
  8022d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022dc:	8b 55 18             	mov    0x18(%ebp),%edx
  8022df:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022e3:	52                   	push   %edx
  8022e4:	50                   	push   %eax
  8022e5:	ff 75 10             	pushl  0x10(%ebp)
  8022e8:	ff 75 0c             	pushl  0xc(%ebp)
  8022eb:	ff 75 08             	pushl  0x8(%ebp)
  8022ee:	6a 20                	push   $0x20
  8022f0:	e8 fa fb ff ff       	call   801eef <syscall>
  8022f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f8:	90                   	nop
}
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <chktst>:
void chktst(uint32 n)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	ff 75 08             	pushl  0x8(%ebp)
  802309:	6a 22                	push   $0x22
  80230b:	e8 df fb ff ff       	call   801eef <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
	return ;
  802313:	90                   	nop
}
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <inctst>:

void inctst()
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 23                	push   $0x23
  802325:	e8 c5 fb ff ff       	call   801eef <syscall>
  80232a:	83 c4 18             	add    $0x18,%esp
	return ;
  80232d:	90                   	nop
}
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <gettst>:
uint32 gettst()
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 24                	push   $0x24
  80233f:	e8 ab fb ff ff       	call   801eef <syscall>
  802344:	83 c4 18             	add    $0x18,%esp
}
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
  80234c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 25                	push   $0x25
  80235b:	e8 8f fb ff ff       	call   801eef <syscall>
  802360:	83 c4 18             	add    $0x18,%esp
  802363:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802366:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80236a:	75 07                	jne    802373 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80236c:	b8 01 00 00 00       	mov    $0x1,%eax
  802371:	eb 05                	jmp    802378 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802373:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 25                	push   $0x25
  80238c:	e8 5e fb ff ff       	call   801eef <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
  802394:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802397:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80239b:	75 07                	jne    8023a4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80239d:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a2:	eb 05                	jmp    8023a9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 25                	push   $0x25
  8023bd:	e8 2d fb ff ff       	call   801eef <syscall>
  8023c2:	83 c4 18             	add    $0x18,%esp
  8023c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023c8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023cc:	75 07                	jne    8023d5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d3:	eb 05                	jmp    8023da <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023da:	c9                   	leave  
  8023db:	c3                   	ret    

008023dc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
  8023df:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 25                	push   $0x25
  8023ee:	e8 fc fa ff ff       	call   801eef <syscall>
  8023f3:	83 c4 18             	add    $0x18,%esp
  8023f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023f9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023fd:	75 07                	jne    802406 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023ff:	b8 01 00 00 00       	mov    $0x1,%eax
  802404:	eb 05                	jmp    80240b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802406:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	ff 75 08             	pushl  0x8(%ebp)
  80241b:	6a 26                	push   $0x26
  80241d:	e8 cd fa ff ff       	call   801eef <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
	return ;
  802425:	90                   	nop
}
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80242c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80242f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802432:	8b 55 0c             	mov    0xc(%ebp),%edx
  802435:	8b 45 08             	mov    0x8(%ebp),%eax
  802438:	6a 00                	push   $0x0
  80243a:	53                   	push   %ebx
  80243b:	51                   	push   %ecx
  80243c:	52                   	push   %edx
  80243d:	50                   	push   %eax
  80243e:	6a 27                	push   $0x27
  802440:	e8 aa fa ff ff       	call   801eef <syscall>
  802445:	83 c4 18             	add    $0x18,%esp
}
  802448:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802450:	8b 55 0c             	mov    0xc(%ebp),%edx
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	52                   	push   %edx
  80245d:	50                   	push   %eax
  80245e:	6a 28                	push   $0x28
  802460:	e8 8a fa ff ff       	call   801eef <syscall>
  802465:	83 c4 18             	add    $0x18,%esp
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80246d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802470:	8b 55 0c             	mov    0xc(%ebp),%edx
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	6a 00                	push   $0x0
  802478:	51                   	push   %ecx
  802479:	ff 75 10             	pushl  0x10(%ebp)
  80247c:	52                   	push   %edx
  80247d:	50                   	push   %eax
  80247e:	6a 29                	push   $0x29
  802480:	e8 6a fa ff ff       	call   801eef <syscall>
  802485:	83 c4 18             	add    $0x18,%esp
}
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	ff 75 10             	pushl  0x10(%ebp)
  802494:	ff 75 0c             	pushl  0xc(%ebp)
  802497:	ff 75 08             	pushl  0x8(%ebp)
  80249a:	6a 12                	push   $0x12
  80249c:	e8 4e fa ff ff       	call   801eef <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a4:	90                   	nop
}
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8024aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	52                   	push   %edx
  8024b7:	50                   	push   %eax
  8024b8:	6a 2a                	push   $0x2a
  8024ba:	e8 30 fa ff ff       	call   801eef <syscall>
  8024bf:	83 c4 18             	add    $0x18,%esp
	return;
  8024c2:	90                   	nop
}
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    

008024c5 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8024c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	50                   	push   %eax
  8024d4:	6a 2b                	push   $0x2b
  8024d6:	e8 14 fa ff ff       	call   801eef <syscall>
  8024db:	83 c4 18             	add    $0x18,%esp
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	ff 75 0c             	pushl  0xc(%ebp)
  8024ec:	ff 75 08             	pushl  0x8(%ebp)
  8024ef:	6a 2c                	push   $0x2c
  8024f1:	e8 f9 f9 ff ff       	call   801eef <syscall>
  8024f6:	83 c4 18             	add    $0x18,%esp
	return;
  8024f9:	90                   	nop
}
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	ff 75 0c             	pushl  0xc(%ebp)
  802508:	ff 75 08             	pushl  0x8(%ebp)
  80250b:	6a 2d                	push   $0x2d
  80250d:	e8 dd f9 ff ff       	call   801eef <syscall>
  802512:	83 c4 18             	add    $0x18,%esp
	return;
  802515:	90                   	nop
}
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
  80251b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	83 e8 04             	sub    $0x4,%eax
  802524:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802527:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80252f:	c9                   	leave  
  802530:	c3                   	ret    

00802531 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
  802534:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802537:	8b 45 08             	mov    0x8(%ebp),%eax
  80253a:	83 e8 04             	sub    $0x4,%eax
  80253d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802543:	8b 00                	mov    (%eax),%eax
  802545:	83 e0 01             	and    $0x1,%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	0f 94 c0             	sete   %al
}
  80254d:	c9                   	leave  
  80254e:	c3                   	ret    

0080254f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80254f:	55                   	push   %ebp
  802550:	89 e5                	mov    %esp,%ebp
  802552:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802555:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80255c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255f:	83 f8 02             	cmp    $0x2,%eax
  802562:	74 2b                	je     80258f <alloc_block+0x40>
  802564:	83 f8 02             	cmp    $0x2,%eax
  802567:	7f 07                	jg     802570 <alloc_block+0x21>
  802569:	83 f8 01             	cmp    $0x1,%eax
  80256c:	74 0e                	je     80257c <alloc_block+0x2d>
  80256e:	eb 58                	jmp    8025c8 <alloc_block+0x79>
  802570:	83 f8 03             	cmp    $0x3,%eax
  802573:	74 2d                	je     8025a2 <alloc_block+0x53>
  802575:	83 f8 04             	cmp    $0x4,%eax
  802578:	74 3b                	je     8025b5 <alloc_block+0x66>
  80257a:	eb 4c                	jmp    8025c8 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80257c:	83 ec 0c             	sub    $0xc,%esp
  80257f:	ff 75 08             	pushl  0x8(%ebp)
  802582:	e8 11 03 00 00       	call   802898 <alloc_block_FF>
  802587:	83 c4 10             	add    $0x10,%esp
  80258a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80258d:	eb 4a                	jmp    8025d9 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80258f:	83 ec 0c             	sub    $0xc,%esp
  802592:	ff 75 08             	pushl  0x8(%ebp)
  802595:	e8 fa 19 00 00       	call   803f94 <alloc_block_NF>
  80259a:	83 c4 10             	add    $0x10,%esp
  80259d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025a0:	eb 37                	jmp    8025d9 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8025a2:	83 ec 0c             	sub    $0xc,%esp
  8025a5:	ff 75 08             	pushl  0x8(%ebp)
  8025a8:	e8 a7 07 00 00       	call   802d54 <alloc_block_BF>
  8025ad:	83 c4 10             	add    $0x10,%esp
  8025b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025b3:	eb 24                	jmp    8025d9 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8025b5:	83 ec 0c             	sub    $0xc,%esp
  8025b8:	ff 75 08             	pushl  0x8(%ebp)
  8025bb:	e8 b7 19 00 00       	call   803f77 <alloc_block_WF>
  8025c0:	83 c4 10             	add    $0x10,%esp
  8025c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025c6:	eb 11                	jmp    8025d9 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8025c8:	83 ec 0c             	sub    $0xc,%esp
  8025cb:	68 6c 4a 80 00       	push   $0x804a6c
  8025d0:	e8 33 e4 ff ff       	call   800a08 <cprintf>
  8025d5:	83 c4 10             	add    $0x10,%esp
		break;
  8025d8:	90                   	nop
	}
	return va;
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8025dc:	c9                   	leave  
  8025dd:	c3                   	ret    

008025de <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8025de:	55                   	push   %ebp
  8025df:	89 e5                	mov    %esp,%ebp
  8025e1:	53                   	push   %ebx
  8025e2:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8025e5:	83 ec 0c             	sub    $0xc,%esp
  8025e8:	68 8c 4a 80 00       	push   $0x804a8c
  8025ed:	e8 16 e4 ff ff       	call   800a08 <cprintf>
  8025f2:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8025f5:	83 ec 0c             	sub    $0xc,%esp
  8025f8:	68 b7 4a 80 00       	push   $0x804ab7
  8025fd:	e8 06 e4 ff ff       	call   800a08 <cprintf>
  802602:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802605:	8b 45 08             	mov    0x8(%ebp),%eax
  802608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260b:	eb 37                	jmp    802644 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80260d:	83 ec 0c             	sub    $0xc,%esp
  802610:	ff 75 f4             	pushl  -0xc(%ebp)
  802613:	e8 19 ff ff ff       	call   802531 <is_free_block>
  802618:	83 c4 10             	add    $0x10,%esp
  80261b:	0f be d8             	movsbl %al,%ebx
  80261e:	83 ec 0c             	sub    $0xc,%esp
  802621:	ff 75 f4             	pushl  -0xc(%ebp)
  802624:	e8 ef fe ff ff       	call   802518 <get_block_size>
  802629:	83 c4 10             	add    $0x10,%esp
  80262c:	83 ec 04             	sub    $0x4,%esp
  80262f:	53                   	push   %ebx
  802630:	50                   	push   %eax
  802631:	68 cf 4a 80 00       	push   $0x804acf
  802636:	e8 cd e3 ff ff       	call   800a08 <cprintf>
  80263b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80263e:	8b 45 10             	mov    0x10(%ebp),%eax
  802641:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802644:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802648:	74 07                	je     802651 <print_blocks_list+0x73>
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 00                	mov    (%eax),%eax
  80264f:	eb 05                	jmp    802656 <print_blocks_list+0x78>
  802651:	b8 00 00 00 00       	mov    $0x0,%eax
  802656:	89 45 10             	mov    %eax,0x10(%ebp)
  802659:	8b 45 10             	mov    0x10(%ebp),%eax
  80265c:	85 c0                	test   %eax,%eax
  80265e:	75 ad                	jne    80260d <print_blocks_list+0x2f>
  802660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802664:	75 a7                	jne    80260d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802666:	83 ec 0c             	sub    $0xc,%esp
  802669:	68 8c 4a 80 00       	push   $0x804a8c
  80266e:	e8 95 e3 ff ff       	call   800a08 <cprintf>
  802673:	83 c4 10             	add    $0x10,%esp

}
  802676:	90                   	nop
  802677:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80267a:	c9                   	leave  
  80267b:	c3                   	ret    

0080267c <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802682:	8b 45 0c             	mov    0xc(%ebp),%eax
  802685:	83 e0 01             	and    $0x1,%eax
  802688:	85 c0                	test   %eax,%eax
  80268a:	74 03                	je     80268f <initialize_dynamic_allocator+0x13>
  80268c:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80268f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802693:	0f 84 c7 01 00 00    	je     802860 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802699:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8026a0:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8026a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a9:	01 d0                	add    %edx,%eax
  8026ab:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8026b0:	0f 87 ad 01 00 00    	ja     802863 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	0f 89 a5 01 00 00    	jns    802866 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8026c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c7:	01 d0                	add    %edx,%eax
  8026c9:	83 e8 04             	sub    $0x4,%eax
  8026cc:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8026d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8026d8:	a1 30 50 80 00       	mov    0x805030,%eax
  8026dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e0:	e9 87 00 00 00       	jmp    80276c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8026e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e9:	75 14                	jne    8026ff <initialize_dynamic_allocator+0x83>
  8026eb:	83 ec 04             	sub    $0x4,%esp
  8026ee:	68 e7 4a 80 00       	push   $0x804ae7
  8026f3:	6a 79                	push   $0x79
  8026f5:	68 05 4b 80 00       	push   $0x804b05
  8026fa:	e8 4c e0 ff ff       	call   80074b <_panic>
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 00                	mov    (%eax),%eax
  802704:	85 c0                	test   %eax,%eax
  802706:	74 10                	je     802718 <initialize_dynamic_allocator+0x9c>
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	8b 00                	mov    (%eax),%eax
  80270d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802710:	8b 52 04             	mov    0x4(%edx),%edx
  802713:	89 50 04             	mov    %edx,0x4(%eax)
  802716:	eb 0b                	jmp    802723 <initialize_dynamic_allocator+0xa7>
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 40 04             	mov    0x4(%eax),%eax
  80271e:	a3 34 50 80 00       	mov    %eax,0x805034
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	8b 40 04             	mov    0x4(%eax),%eax
  802729:	85 c0                	test   %eax,%eax
  80272b:	74 0f                	je     80273c <initialize_dynamic_allocator+0xc0>
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	8b 40 04             	mov    0x4(%eax),%eax
  802733:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802736:	8b 12                	mov    (%edx),%edx
  802738:	89 10                	mov    %edx,(%eax)
  80273a:	eb 0a                	jmp    802746 <initialize_dynamic_allocator+0xca>
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	8b 00                	mov    (%eax),%eax
  802741:	a3 30 50 80 00       	mov    %eax,0x805030
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802759:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80275e:	48                   	dec    %eax
  80275f:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802764:	a1 38 50 80 00       	mov    0x805038,%eax
  802769:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802770:	74 07                	je     802779 <initialize_dynamic_allocator+0xfd>
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 00                	mov    (%eax),%eax
  802777:	eb 05                	jmp    80277e <initialize_dynamic_allocator+0x102>
  802779:	b8 00 00 00 00       	mov    $0x0,%eax
  80277e:	a3 38 50 80 00       	mov    %eax,0x805038
  802783:	a1 38 50 80 00       	mov    0x805038,%eax
  802788:	85 c0                	test   %eax,%eax
  80278a:	0f 85 55 ff ff ff    	jne    8026e5 <initialize_dynamic_allocator+0x69>
  802790:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802794:	0f 85 4b ff ff ff    	jne    8026e5 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80279a:	8b 45 08             	mov    0x8(%ebp),%eax
  80279d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8027a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8027a9:	a1 48 50 80 00       	mov    0x805048,%eax
  8027ae:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8027b3:	a1 44 50 80 00       	mov    0x805044,%eax
  8027b8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8027be:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c1:	83 c0 08             	add    $0x8,%eax
  8027c4:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ca:	83 c0 04             	add    $0x4,%eax
  8027cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d0:	83 ea 08             	sub    $0x8,%edx
  8027d3:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027db:	01 d0                	add    %edx,%eax
  8027dd:	83 e8 08             	sub    $0x8,%eax
  8027e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e3:	83 ea 08             	sub    $0x8,%edx
  8027e6:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8027e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8027f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8027fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027ff:	75 17                	jne    802818 <initialize_dynamic_allocator+0x19c>
  802801:	83 ec 04             	sub    $0x4,%esp
  802804:	68 20 4b 80 00       	push   $0x804b20
  802809:	68 90 00 00 00       	push   $0x90
  80280e:	68 05 4b 80 00       	push   $0x804b05
  802813:	e8 33 df ff ff       	call   80074b <_panic>
  802818:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80281e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802821:	89 10                	mov    %edx,(%eax)
  802823:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	85 c0                	test   %eax,%eax
  80282a:	74 0d                	je     802839 <initialize_dynamic_allocator+0x1bd>
  80282c:	a1 30 50 80 00       	mov    0x805030,%eax
  802831:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802834:	89 50 04             	mov    %edx,0x4(%eax)
  802837:	eb 08                	jmp    802841 <initialize_dynamic_allocator+0x1c5>
  802839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283c:	a3 34 50 80 00       	mov    %eax,0x805034
  802841:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802844:	a3 30 50 80 00       	mov    %eax,0x805030
  802849:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802853:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802858:	40                   	inc    %eax
  802859:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80285e:	eb 07                	jmp    802867 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802860:	90                   	nop
  802861:	eb 04                	jmp    802867 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802863:	90                   	nop
  802864:	eb 01                	jmp    802867 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802866:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802867:	c9                   	leave  
  802868:	c3                   	ret    

00802869 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802869:	55                   	push   %ebp
  80286a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80286c:	8b 45 10             	mov    0x10(%ebp),%eax
  80286f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	8d 50 fc             	lea    -0x4(%eax),%edx
  802878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80287b:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80287d:	8b 45 08             	mov    0x8(%ebp),%eax
  802880:	83 e8 04             	sub    $0x4,%eax
  802883:	8b 00                	mov    (%eax),%eax
  802885:	83 e0 fe             	and    $0xfffffffe,%eax
  802888:	8d 50 f8             	lea    -0x8(%eax),%edx
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	01 c2                	add    %eax,%edx
  802890:	8b 45 0c             	mov    0xc(%ebp),%eax
  802893:	89 02                	mov    %eax,(%edx)
}
  802895:	90                   	nop
  802896:	5d                   	pop    %ebp
  802897:	c3                   	ret    

00802898 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802898:	55                   	push   %ebp
  802899:	89 e5                	mov    %esp,%ebp
  80289b:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80289e:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a1:	83 e0 01             	and    $0x1,%eax
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	74 03                	je     8028ab <alloc_block_FF+0x13>
  8028a8:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028ab:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028af:	77 07                	ja     8028b8 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028b1:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028b8:	a1 28 50 80 00       	mov    0x805028,%eax
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	75 73                	jne    802934 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	83 c0 10             	add    $0x10,%eax
  8028c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028ca:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8028d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d7:	01 d0                	add    %edx,%eax
  8028d9:	48                   	dec    %eax
  8028da:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8028dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8028e5:	f7 75 ec             	divl   -0x14(%ebp)
  8028e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028eb:	29 d0                	sub    %edx,%eax
  8028ed:	c1 e8 0c             	shr    $0xc,%eax
  8028f0:	83 ec 0c             	sub    $0xc,%esp
  8028f3:	50                   	push   %eax
  8028f4:	e8 b1 f0 ff ff       	call   8019aa <sbrk>
  8028f9:	83 c4 10             	add    $0x10,%esp
  8028fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028ff:	83 ec 0c             	sub    $0xc,%esp
  802902:	6a 00                	push   $0x0
  802904:	e8 a1 f0 ff ff       	call   8019aa <sbrk>
  802909:	83 c4 10             	add    $0x10,%esp
  80290c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80290f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802912:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802915:	83 ec 08             	sub    $0x8,%esp
  802918:	50                   	push   %eax
  802919:	ff 75 e4             	pushl  -0x1c(%ebp)
  80291c:	e8 5b fd ff ff       	call   80267c <initialize_dynamic_allocator>
  802921:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802924:	83 ec 0c             	sub    $0xc,%esp
  802927:	68 43 4b 80 00       	push   $0x804b43
  80292c:	e8 d7 e0 ff ff       	call   800a08 <cprintf>
  802931:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802934:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802938:	75 0a                	jne    802944 <alloc_block_FF+0xac>
	        return NULL;
  80293a:	b8 00 00 00 00       	mov    $0x0,%eax
  80293f:	e9 0e 04 00 00       	jmp    802d52 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802944:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80294b:	a1 30 50 80 00       	mov    0x805030,%eax
  802950:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802953:	e9 f3 02 00 00       	jmp    802c4b <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80295e:	83 ec 0c             	sub    $0xc,%esp
  802961:	ff 75 bc             	pushl  -0x44(%ebp)
  802964:	e8 af fb ff ff       	call   802518 <get_block_size>
  802969:	83 c4 10             	add    $0x10,%esp
  80296c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	83 c0 08             	add    $0x8,%eax
  802975:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802978:	0f 87 c5 02 00 00    	ja     802c43 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80297e:	8b 45 08             	mov    0x8(%ebp),%eax
  802981:	83 c0 18             	add    $0x18,%eax
  802984:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802987:	0f 87 19 02 00 00    	ja     802ba6 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80298d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802990:	2b 45 08             	sub    0x8(%ebp),%eax
  802993:	83 e8 08             	sub    $0x8,%eax
  802996:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	8d 50 08             	lea    0x8(%eax),%edx
  80299f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029a2:	01 d0                	add    %edx,%eax
  8029a4:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	83 c0 08             	add    $0x8,%eax
  8029ad:	83 ec 04             	sub    $0x4,%esp
  8029b0:	6a 01                	push   $0x1
  8029b2:	50                   	push   %eax
  8029b3:	ff 75 bc             	pushl  -0x44(%ebp)
  8029b6:	e8 ae fe ff ff       	call   802869 <set_block_data>
  8029bb:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 40 04             	mov    0x4(%eax),%eax
  8029c4:	85 c0                	test   %eax,%eax
  8029c6:	75 68                	jne    802a30 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029c8:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029cc:	75 17                	jne    8029e5 <alloc_block_FF+0x14d>
  8029ce:	83 ec 04             	sub    $0x4,%esp
  8029d1:	68 20 4b 80 00       	push   $0x804b20
  8029d6:	68 d7 00 00 00       	push   $0xd7
  8029db:	68 05 4b 80 00       	push   $0x804b05
  8029e0:	e8 66 dd ff ff       	call   80074b <_panic>
  8029e5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029eb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029ee:	89 10                	mov    %edx,(%eax)
  8029f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f3:	8b 00                	mov    (%eax),%eax
  8029f5:	85 c0                	test   %eax,%eax
  8029f7:	74 0d                	je     802a06 <alloc_block_FF+0x16e>
  8029f9:	a1 30 50 80 00       	mov    0x805030,%eax
  8029fe:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a01:	89 50 04             	mov    %edx,0x4(%eax)
  802a04:	eb 08                	jmp    802a0e <alloc_block_FF+0x176>
  802a06:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a09:	a3 34 50 80 00       	mov    %eax,0x805034
  802a0e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a11:	a3 30 50 80 00       	mov    %eax,0x805030
  802a16:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a20:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a25:	40                   	inc    %eax
  802a26:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a2b:	e9 dc 00 00 00       	jmp    802b0c <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	85 c0                	test   %eax,%eax
  802a37:	75 65                	jne    802a9e <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a39:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a3d:	75 17                	jne    802a56 <alloc_block_FF+0x1be>
  802a3f:	83 ec 04             	sub    $0x4,%esp
  802a42:	68 54 4b 80 00       	push   $0x804b54
  802a47:	68 db 00 00 00       	push   $0xdb
  802a4c:	68 05 4b 80 00       	push   $0x804b05
  802a51:	e8 f5 dc ff ff       	call   80074b <_panic>
  802a56:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802a5c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a5f:	89 50 04             	mov    %edx,0x4(%eax)
  802a62:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a65:	8b 40 04             	mov    0x4(%eax),%eax
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	74 0c                	je     802a78 <alloc_block_FF+0x1e0>
  802a6c:	a1 34 50 80 00       	mov    0x805034,%eax
  802a71:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a74:	89 10                	mov    %edx,(%eax)
  802a76:	eb 08                	jmp    802a80 <alloc_block_FF+0x1e8>
  802a78:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a7b:	a3 30 50 80 00       	mov    %eax,0x805030
  802a80:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a83:	a3 34 50 80 00       	mov    %eax,0x805034
  802a88:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a91:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a96:	40                   	inc    %eax
  802a97:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a9c:	eb 6e                	jmp    802b0c <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa2:	74 06                	je     802aaa <alloc_block_FF+0x212>
  802aa4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802aa8:	75 17                	jne    802ac1 <alloc_block_FF+0x229>
  802aaa:	83 ec 04             	sub    $0x4,%esp
  802aad:	68 78 4b 80 00       	push   $0x804b78
  802ab2:	68 df 00 00 00       	push   $0xdf
  802ab7:	68 05 4b 80 00       	push   $0x804b05
  802abc:	e8 8a dc ff ff       	call   80074b <_panic>
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 10                	mov    (%eax),%edx
  802ac6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac9:	89 10                	mov    %edx,(%eax)
  802acb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	85 c0                	test   %eax,%eax
  802ad2:	74 0b                	je     802adf <alloc_block_FF+0x247>
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	8b 00                	mov    (%eax),%eax
  802ad9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802adc:	89 50 04             	mov    %edx,0x4(%eax)
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ae5:	89 10                	mov    %edx,(%eax)
  802ae7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aed:	89 50 04             	mov    %edx,0x4(%eax)
  802af0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802af3:	8b 00                	mov    (%eax),%eax
  802af5:	85 c0                	test   %eax,%eax
  802af7:	75 08                	jne    802b01 <alloc_block_FF+0x269>
  802af9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802afc:	a3 34 50 80 00       	mov    %eax,0x805034
  802b01:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b06:	40                   	inc    %eax
  802b07:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802b0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b10:	75 17                	jne    802b29 <alloc_block_FF+0x291>
  802b12:	83 ec 04             	sub    $0x4,%esp
  802b15:	68 e7 4a 80 00       	push   $0x804ae7
  802b1a:	68 e1 00 00 00       	push   $0xe1
  802b1f:	68 05 4b 80 00       	push   $0x804b05
  802b24:	e8 22 dc ff ff       	call   80074b <_panic>
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	8b 00                	mov    (%eax),%eax
  802b2e:	85 c0                	test   %eax,%eax
  802b30:	74 10                	je     802b42 <alloc_block_FF+0x2aa>
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	8b 00                	mov    (%eax),%eax
  802b37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3a:	8b 52 04             	mov    0x4(%edx),%edx
  802b3d:	89 50 04             	mov    %edx,0x4(%eax)
  802b40:	eb 0b                	jmp    802b4d <alloc_block_FF+0x2b5>
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 40 04             	mov    0x4(%eax),%eax
  802b48:	a3 34 50 80 00       	mov    %eax,0x805034
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	8b 40 04             	mov    0x4(%eax),%eax
  802b53:	85 c0                	test   %eax,%eax
  802b55:	74 0f                	je     802b66 <alloc_block_FF+0x2ce>
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	8b 40 04             	mov    0x4(%eax),%eax
  802b5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b60:	8b 12                	mov    (%edx),%edx
  802b62:	89 10                	mov    %edx,(%eax)
  802b64:	eb 0a                	jmp    802b70 <alloc_block_FF+0x2d8>
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 00                	mov    (%eax),%eax
  802b6b:	a3 30 50 80 00       	mov    %eax,0x805030
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b83:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b88:	48                   	dec    %eax
  802b89:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802b8e:	83 ec 04             	sub    $0x4,%esp
  802b91:	6a 00                	push   $0x0
  802b93:	ff 75 b4             	pushl  -0x4c(%ebp)
  802b96:	ff 75 b0             	pushl  -0x50(%ebp)
  802b99:	e8 cb fc ff ff       	call   802869 <set_block_data>
  802b9e:	83 c4 10             	add    $0x10,%esp
  802ba1:	e9 95 00 00 00       	jmp    802c3b <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802ba6:	83 ec 04             	sub    $0x4,%esp
  802ba9:	6a 01                	push   $0x1
  802bab:	ff 75 b8             	pushl  -0x48(%ebp)
  802bae:	ff 75 bc             	pushl  -0x44(%ebp)
  802bb1:	e8 b3 fc ff ff       	call   802869 <set_block_data>
  802bb6:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802bb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbd:	75 17                	jne    802bd6 <alloc_block_FF+0x33e>
  802bbf:	83 ec 04             	sub    $0x4,%esp
  802bc2:	68 e7 4a 80 00       	push   $0x804ae7
  802bc7:	68 e8 00 00 00       	push   $0xe8
  802bcc:	68 05 4b 80 00       	push   $0x804b05
  802bd1:	e8 75 db ff ff       	call   80074b <_panic>
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	74 10                	je     802bef <alloc_block_FF+0x357>
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	8b 00                	mov    (%eax),%eax
  802be4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be7:	8b 52 04             	mov    0x4(%edx),%edx
  802bea:	89 50 04             	mov    %edx,0x4(%eax)
  802bed:	eb 0b                	jmp    802bfa <alloc_block_FF+0x362>
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	8b 40 04             	mov    0x4(%eax),%eax
  802bf5:	a3 34 50 80 00       	mov    %eax,0x805034
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 40 04             	mov    0x4(%eax),%eax
  802c00:	85 c0                	test   %eax,%eax
  802c02:	74 0f                	je     802c13 <alloc_block_FF+0x37b>
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 40 04             	mov    0x4(%eax),%eax
  802c0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0d:	8b 12                	mov    (%edx),%edx
  802c0f:	89 10                	mov    %edx,(%eax)
  802c11:	eb 0a                	jmp    802c1d <alloc_block_FF+0x385>
  802c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c16:	8b 00                	mov    (%eax),%eax
  802c18:	a3 30 50 80 00       	mov    %eax,0x805030
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c30:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c35:	48                   	dec    %eax
  802c36:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802c3b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c3e:	e9 0f 01 00 00       	jmp    802d52 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c43:	a1 38 50 80 00       	mov    0x805038,%eax
  802c48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4f:	74 07                	je     802c58 <alloc_block_FF+0x3c0>
  802c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c54:	8b 00                	mov    (%eax),%eax
  802c56:	eb 05                	jmp    802c5d <alloc_block_FF+0x3c5>
  802c58:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5d:	a3 38 50 80 00       	mov    %eax,0x805038
  802c62:	a1 38 50 80 00       	mov    0x805038,%eax
  802c67:	85 c0                	test   %eax,%eax
  802c69:	0f 85 e9 fc ff ff    	jne    802958 <alloc_block_FF+0xc0>
  802c6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c73:	0f 85 df fc ff ff    	jne    802958 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	83 c0 08             	add    $0x8,%eax
  802c7f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c82:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802c89:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c8c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c8f:	01 d0                	add    %edx,%eax
  802c91:	48                   	dec    %eax
  802c92:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802c95:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c98:	ba 00 00 00 00       	mov    $0x0,%edx
  802c9d:	f7 75 d8             	divl   -0x28(%ebp)
  802ca0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ca3:	29 d0                	sub    %edx,%eax
  802ca5:	c1 e8 0c             	shr    $0xc,%eax
  802ca8:	83 ec 0c             	sub    $0xc,%esp
  802cab:	50                   	push   %eax
  802cac:	e8 f9 ec ff ff       	call   8019aa <sbrk>
  802cb1:	83 c4 10             	add    $0x10,%esp
  802cb4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802cb7:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802cbb:	75 0a                	jne    802cc7 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc2:	e9 8b 00 00 00       	jmp    802d52 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cc7:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802cce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd4:	01 d0                	add    %edx,%eax
  802cd6:	48                   	dec    %eax
  802cd7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802cda:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802cdd:	ba 00 00 00 00       	mov    $0x0,%edx
  802ce2:	f7 75 cc             	divl   -0x34(%ebp)
  802ce5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ce8:	29 d0                	sub    %edx,%eax
  802cea:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ced:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cf0:	01 d0                	add    %edx,%eax
  802cf2:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802cf7:	a1 44 50 80 00       	mov    0x805044,%eax
  802cfc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d02:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d09:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d0c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d0f:	01 d0                	add    %edx,%eax
  802d11:	48                   	dec    %eax
  802d12:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d15:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d18:	ba 00 00 00 00       	mov    $0x0,%edx
  802d1d:	f7 75 c4             	divl   -0x3c(%ebp)
  802d20:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d23:	29 d0                	sub    %edx,%eax
  802d25:	83 ec 04             	sub    $0x4,%esp
  802d28:	6a 01                	push   $0x1
  802d2a:	50                   	push   %eax
  802d2b:	ff 75 d0             	pushl  -0x30(%ebp)
  802d2e:	e8 36 fb ff ff       	call   802869 <set_block_data>
  802d33:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802d36:	83 ec 0c             	sub    $0xc,%esp
  802d39:	ff 75 d0             	pushl  -0x30(%ebp)
  802d3c:	e8 1b 0a 00 00       	call   80375c <free_block>
  802d41:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802d44:	83 ec 0c             	sub    $0xc,%esp
  802d47:	ff 75 08             	pushl  0x8(%ebp)
  802d4a:	e8 49 fb ff ff       	call   802898 <alloc_block_FF>
  802d4f:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802d52:	c9                   	leave  
  802d53:	c3                   	ret    

00802d54 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802d54:	55                   	push   %ebp
  802d55:	89 e5                	mov    %esp,%ebp
  802d57:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	83 e0 01             	and    $0x1,%eax
  802d60:	85 c0                	test   %eax,%eax
  802d62:	74 03                	je     802d67 <alloc_block_BF+0x13>
  802d64:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802d67:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802d6b:	77 07                	ja     802d74 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802d6d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802d74:	a1 28 50 80 00       	mov    0x805028,%eax
  802d79:	85 c0                	test   %eax,%eax
  802d7b:	75 73                	jne    802df0 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d80:	83 c0 10             	add    $0x10,%eax
  802d83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802d86:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802d8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d93:	01 d0                	add    %edx,%eax
  802d95:	48                   	dec    %eax
  802d96:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d9c:	ba 00 00 00 00       	mov    $0x0,%edx
  802da1:	f7 75 e0             	divl   -0x20(%ebp)
  802da4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da7:	29 d0                	sub    %edx,%eax
  802da9:	c1 e8 0c             	shr    $0xc,%eax
  802dac:	83 ec 0c             	sub    $0xc,%esp
  802daf:	50                   	push   %eax
  802db0:	e8 f5 eb ff ff       	call   8019aa <sbrk>
  802db5:	83 c4 10             	add    $0x10,%esp
  802db8:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802dbb:	83 ec 0c             	sub    $0xc,%esp
  802dbe:	6a 00                	push   $0x0
  802dc0:	e8 e5 eb ff ff       	call   8019aa <sbrk>
  802dc5:	83 c4 10             	add    $0x10,%esp
  802dc8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802dcb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dce:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802dd1:	83 ec 08             	sub    $0x8,%esp
  802dd4:	50                   	push   %eax
  802dd5:	ff 75 d8             	pushl  -0x28(%ebp)
  802dd8:	e8 9f f8 ff ff       	call   80267c <initialize_dynamic_allocator>
  802ddd:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802de0:	83 ec 0c             	sub    $0xc,%esp
  802de3:	68 43 4b 80 00       	push   $0x804b43
  802de8:	e8 1b dc ff ff       	call   800a08 <cprintf>
  802ded:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802df0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802df7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802dfe:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802e05:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802e0c:	a1 30 50 80 00       	mov    0x805030,%eax
  802e11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e14:	e9 1d 01 00 00       	jmp    802f36 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802e1f:	83 ec 0c             	sub    $0xc,%esp
  802e22:	ff 75 a8             	pushl  -0x58(%ebp)
  802e25:	e8 ee f6 ff ff       	call   802518 <get_block_size>
  802e2a:	83 c4 10             	add    $0x10,%esp
  802e2d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	83 c0 08             	add    $0x8,%eax
  802e36:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e39:	0f 87 ef 00 00 00    	ja     802f2e <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	83 c0 18             	add    $0x18,%eax
  802e45:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e48:	77 1d                	ja     802e67 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802e4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e50:	0f 86 d8 00 00 00    	jbe    802f2e <alloc_block_BF+0x1da>
				{
					best_va = va;
  802e56:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e59:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802e5c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e62:	e9 c7 00 00 00       	jmp    802f2e <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	83 c0 08             	add    $0x8,%eax
  802e6d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e70:	0f 85 9d 00 00 00    	jne    802f13 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802e76:	83 ec 04             	sub    $0x4,%esp
  802e79:	6a 01                	push   $0x1
  802e7b:	ff 75 a4             	pushl  -0x5c(%ebp)
  802e7e:	ff 75 a8             	pushl  -0x58(%ebp)
  802e81:	e8 e3 f9 ff ff       	call   802869 <set_block_data>
  802e86:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802e89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8d:	75 17                	jne    802ea6 <alloc_block_BF+0x152>
  802e8f:	83 ec 04             	sub    $0x4,%esp
  802e92:	68 e7 4a 80 00       	push   $0x804ae7
  802e97:	68 2c 01 00 00       	push   $0x12c
  802e9c:	68 05 4b 80 00       	push   $0x804b05
  802ea1:	e8 a5 d8 ff ff       	call   80074b <_panic>
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	85 c0                	test   %eax,%eax
  802ead:	74 10                	je     802ebf <alloc_block_BF+0x16b>
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	8b 00                	mov    (%eax),%eax
  802eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb7:	8b 52 04             	mov    0x4(%edx),%edx
  802eba:	89 50 04             	mov    %edx,0x4(%eax)
  802ebd:	eb 0b                	jmp    802eca <alloc_block_BF+0x176>
  802ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec2:	8b 40 04             	mov    0x4(%eax),%eax
  802ec5:	a3 34 50 80 00       	mov    %eax,0x805034
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	8b 40 04             	mov    0x4(%eax),%eax
  802ed0:	85 c0                	test   %eax,%eax
  802ed2:	74 0f                	je     802ee3 <alloc_block_BF+0x18f>
  802ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed7:	8b 40 04             	mov    0x4(%eax),%eax
  802eda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802edd:	8b 12                	mov    (%edx),%edx
  802edf:	89 10                	mov    %edx,(%eax)
  802ee1:	eb 0a                	jmp    802eed <alloc_block_BF+0x199>
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	8b 00                	mov    (%eax),%eax
  802ee8:	a3 30 50 80 00       	mov    %eax,0x805030
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f00:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f05:	48                   	dec    %eax
  802f06:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802f0b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f0e:	e9 24 04 00 00       	jmp    803337 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f16:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f19:	76 13                	jbe    802f2e <alloc_block_BF+0x1da>
					{
						internal = 1;
  802f1b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802f22:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f25:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802f28:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f2b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802f2e:	a1 38 50 80 00       	mov    0x805038,%eax
  802f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3a:	74 07                	je     802f43 <alloc_block_BF+0x1ef>
  802f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3f:	8b 00                	mov    (%eax),%eax
  802f41:	eb 05                	jmp    802f48 <alloc_block_BF+0x1f4>
  802f43:	b8 00 00 00 00       	mov    $0x0,%eax
  802f48:	a3 38 50 80 00       	mov    %eax,0x805038
  802f4d:	a1 38 50 80 00       	mov    0x805038,%eax
  802f52:	85 c0                	test   %eax,%eax
  802f54:	0f 85 bf fe ff ff    	jne    802e19 <alloc_block_BF+0xc5>
  802f5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5e:	0f 85 b5 fe ff ff    	jne    802e19 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802f64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f68:	0f 84 26 02 00 00    	je     803194 <alloc_block_BF+0x440>
  802f6e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f72:	0f 85 1c 02 00 00    	jne    803194 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802f78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7b:	2b 45 08             	sub    0x8(%ebp),%eax
  802f7e:	83 e8 08             	sub    $0x8,%eax
  802f81:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802f84:	8b 45 08             	mov    0x8(%ebp),%eax
  802f87:	8d 50 08             	lea    0x8(%eax),%edx
  802f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8d:	01 d0                	add    %edx,%eax
  802f8f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	83 c0 08             	add    $0x8,%eax
  802f98:	83 ec 04             	sub    $0x4,%esp
  802f9b:	6a 01                	push   $0x1
  802f9d:	50                   	push   %eax
  802f9e:	ff 75 f0             	pushl  -0x10(%ebp)
  802fa1:	e8 c3 f8 ff ff       	call   802869 <set_block_data>
  802fa6:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fac:	8b 40 04             	mov    0x4(%eax),%eax
  802faf:	85 c0                	test   %eax,%eax
  802fb1:	75 68                	jne    80301b <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802fb3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fb7:	75 17                	jne    802fd0 <alloc_block_BF+0x27c>
  802fb9:	83 ec 04             	sub    $0x4,%esp
  802fbc:	68 20 4b 80 00       	push   $0x804b20
  802fc1:	68 45 01 00 00       	push   $0x145
  802fc6:	68 05 4b 80 00       	push   $0x804b05
  802fcb:	e8 7b d7 ff ff       	call   80074b <_panic>
  802fd0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fd6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fd9:	89 10                	mov    %edx,(%eax)
  802fdb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fde:	8b 00                	mov    (%eax),%eax
  802fe0:	85 c0                	test   %eax,%eax
  802fe2:	74 0d                	je     802ff1 <alloc_block_BF+0x29d>
  802fe4:	a1 30 50 80 00       	mov    0x805030,%eax
  802fe9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fec:	89 50 04             	mov    %edx,0x4(%eax)
  802fef:	eb 08                	jmp    802ff9 <alloc_block_BF+0x2a5>
  802ff1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ff4:	a3 34 50 80 00       	mov    %eax,0x805034
  802ff9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ffc:	a3 30 50 80 00       	mov    %eax,0x805030
  803001:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803004:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803010:	40                   	inc    %eax
  803011:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803016:	e9 dc 00 00 00       	jmp    8030f7 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80301b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301e:	8b 00                	mov    (%eax),%eax
  803020:	85 c0                	test   %eax,%eax
  803022:	75 65                	jne    803089 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803024:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803028:	75 17                	jne    803041 <alloc_block_BF+0x2ed>
  80302a:	83 ec 04             	sub    $0x4,%esp
  80302d:	68 54 4b 80 00       	push   $0x804b54
  803032:	68 4a 01 00 00       	push   $0x14a
  803037:	68 05 4b 80 00       	push   $0x804b05
  80303c:	e8 0a d7 ff ff       	call   80074b <_panic>
  803041:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803047:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80304a:	89 50 04             	mov    %edx,0x4(%eax)
  80304d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803050:	8b 40 04             	mov    0x4(%eax),%eax
  803053:	85 c0                	test   %eax,%eax
  803055:	74 0c                	je     803063 <alloc_block_BF+0x30f>
  803057:	a1 34 50 80 00       	mov    0x805034,%eax
  80305c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80305f:	89 10                	mov    %edx,(%eax)
  803061:	eb 08                	jmp    80306b <alloc_block_BF+0x317>
  803063:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803066:	a3 30 50 80 00       	mov    %eax,0x805030
  80306b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80306e:	a3 34 50 80 00       	mov    %eax,0x805034
  803073:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803076:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80307c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803081:	40                   	inc    %eax
  803082:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803087:	eb 6e                	jmp    8030f7 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803089:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80308d:	74 06                	je     803095 <alloc_block_BF+0x341>
  80308f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803093:	75 17                	jne    8030ac <alloc_block_BF+0x358>
  803095:	83 ec 04             	sub    $0x4,%esp
  803098:	68 78 4b 80 00       	push   $0x804b78
  80309d:	68 4f 01 00 00       	push   $0x14f
  8030a2:	68 05 4b 80 00       	push   $0x804b05
  8030a7:	e8 9f d6 ff ff       	call   80074b <_panic>
  8030ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030af:	8b 10                	mov    (%eax),%edx
  8030b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b4:	89 10                	mov    %edx,(%eax)
  8030b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b9:	8b 00                	mov    (%eax),%eax
  8030bb:	85 c0                	test   %eax,%eax
  8030bd:	74 0b                	je     8030ca <alloc_block_BF+0x376>
  8030bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c2:	8b 00                	mov    (%eax),%eax
  8030c4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030c7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030d0:	89 10                	mov    %edx,(%eax)
  8030d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030d8:	89 50 04             	mov    %edx,0x4(%eax)
  8030db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030de:	8b 00                	mov    (%eax),%eax
  8030e0:	85 c0                	test   %eax,%eax
  8030e2:	75 08                	jne    8030ec <alloc_block_BF+0x398>
  8030e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030e7:	a3 34 50 80 00       	mov    %eax,0x805034
  8030ec:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030f1:	40                   	inc    %eax
  8030f2:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8030f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030fb:	75 17                	jne    803114 <alloc_block_BF+0x3c0>
  8030fd:	83 ec 04             	sub    $0x4,%esp
  803100:	68 e7 4a 80 00       	push   $0x804ae7
  803105:	68 51 01 00 00       	push   $0x151
  80310a:	68 05 4b 80 00       	push   $0x804b05
  80310f:	e8 37 d6 ff ff       	call   80074b <_panic>
  803114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803117:	8b 00                	mov    (%eax),%eax
  803119:	85 c0                	test   %eax,%eax
  80311b:	74 10                	je     80312d <alloc_block_BF+0x3d9>
  80311d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803125:	8b 52 04             	mov    0x4(%edx),%edx
  803128:	89 50 04             	mov    %edx,0x4(%eax)
  80312b:	eb 0b                	jmp    803138 <alloc_block_BF+0x3e4>
  80312d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803130:	8b 40 04             	mov    0x4(%eax),%eax
  803133:	a3 34 50 80 00       	mov    %eax,0x805034
  803138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313b:	8b 40 04             	mov    0x4(%eax),%eax
  80313e:	85 c0                	test   %eax,%eax
  803140:	74 0f                	je     803151 <alloc_block_BF+0x3fd>
  803142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803145:	8b 40 04             	mov    0x4(%eax),%eax
  803148:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80314b:	8b 12                	mov    (%edx),%edx
  80314d:	89 10                	mov    %edx,(%eax)
  80314f:	eb 0a                	jmp    80315b <alloc_block_BF+0x407>
  803151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803154:	8b 00                	mov    (%eax),%eax
  803156:	a3 30 50 80 00       	mov    %eax,0x805030
  80315b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803167:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803173:	48                   	dec    %eax
  803174:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  803179:	83 ec 04             	sub    $0x4,%esp
  80317c:	6a 00                	push   $0x0
  80317e:	ff 75 d0             	pushl  -0x30(%ebp)
  803181:	ff 75 cc             	pushl  -0x34(%ebp)
  803184:	e8 e0 f6 ff ff       	call   802869 <set_block_data>
  803189:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80318c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318f:	e9 a3 01 00 00       	jmp    803337 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803194:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803198:	0f 85 9d 00 00 00    	jne    80323b <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80319e:	83 ec 04             	sub    $0x4,%esp
  8031a1:	6a 01                	push   $0x1
  8031a3:	ff 75 ec             	pushl  -0x14(%ebp)
  8031a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8031a9:	e8 bb f6 ff ff       	call   802869 <set_block_data>
  8031ae:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8031b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031b5:	75 17                	jne    8031ce <alloc_block_BF+0x47a>
  8031b7:	83 ec 04             	sub    $0x4,%esp
  8031ba:	68 e7 4a 80 00       	push   $0x804ae7
  8031bf:	68 58 01 00 00       	push   $0x158
  8031c4:	68 05 4b 80 00       	push   $0x804b05
  8031c9:	e8 7d d5 ff ff       	call   80074b <_panic>
  8031ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d1:	8b 00                	mov    (%eax),%eax
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	74 10                	je     8031e7 <alloc_block_BF+0x493>
  8031d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031da:	8b 00                	mov    (%eax),%eax
  8031dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031df:	8b 52 04             	mov    0x4(%edx),%edx
  8031e2:	89 50 04             	mov    %edx,0x4(%eax)
  8031e5:	eb 0b                	jmp    8031f2 <alloc_block_BF+0x49e>
  8031e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ea:	8b 40 04             	mov    0x4(%eax),%eax
  8031ed:	a3 34 50 80 00       	mov    %eax,0x805034
  8031f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f5:	8b 40 04             	mov    0x4(%eax),%eax
  8031f8:	85 c0                	test   %eax,%eax
  8031fa:	74 0f                	je     80320b <alloc_block_BF+0x4b7>
  8031fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ff:	8b 40 04             	mov    0x4(%eax),%eax
  803202:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803205:	8b 12                	mov    (%edx),%edx
  803207:	89 10                	mov    %edx,(%eax)
  803209:	eb 0a                	jmp    803215 <alloc_block_BF+0x4c1>
  80320b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320e:	8b 00                	mov    (%eax),%eax
  803210:	a3 30 50 80 00       	mov    %eax,0x805030
  803215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803218:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80321e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803221:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803228:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80322d:	48                   	dec    %eax
  80322e:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  803233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803236:	e9 fc 00 00 00       	jmp    803337 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	83 c0 08             	add    $0x8,%eax
  803241:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803244:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80324b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80324e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803251:	01 d0                	add    %edx,%eax
  803253:	48                   	dec    %eax
  803254:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803257:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80325a:	ba 00 00 00 00       	mov    $0x0,%edx
  80325f:	f7 75 c4             	divl   -0x3c(%ebp)
  803262:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803265:	29 d0                	sub    %edx,%eax
  803267:	c1 e8 0c             	shr    $0xc,%eax
  80326a:	83 ec 0c             	sub    $0xc,%esp
  80326d:	50                   	push   %eax
  80326e:	e8 37 e7 ff ff       	call   8019aa <sbrk>
  803273:	83 c4 10             	add    $0x10,%esp
  803276:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803279:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80327d:	75 0a                	jne    803289 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80327f:	b8 00 00 00 00       	mov    $0x0,%eax
  803284:	e9 ae 00 00 00       	jmp    803337 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803289:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803290:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803293:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803296:	01 d0                	add    %edx,%eax
  803298:	48                   	dec    %eax
  803299:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80329c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80329f:	ba 00 00 00 00       	mov    $0x0,%edx
  8032a4:	f7 75 b8             	divl   -0x48(%ebp)
  8032a7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8032aa:	29 d0                	sub    %edx,%eax
  8032ac:	8d 50 fc             	lea    -0x4(%eax),%edx
  8032af:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8032b2:	01 d0                	add    %edx,%eax
  8032b4:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  8032b9:	a1 44 50 80 00       	mov    0x805044,%eax
  8032be:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8032c4:	83 ec 0c             	sub    $0xc,%esp
  8032c7:	68 ac 4b 80 00       	push   $0x804bac
  8032cc:	e8 37 d7 ff ff       	call   800a08 <cprintf>
  8032d1:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8032d4:	83 ec 08             	sub    $0x8,%esp
  8032d7:	ff 75 bc             	pushl  -0x44(%ebp)
  8032da:	68 b1 4b 80 00       	push   $0x804bb1
  8032df:	e8 24 d7 ff ff       	call   800a08 <cprintf>
  8032e4:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8032e7:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8032ee:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032f4:	01 d0                	add    %edx,%eax
  8032f6:	48                   	dec    %eax
  8032f7:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8032fa:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8032fd:	ba 00 00 00 00       	mov    $0x0,%edx
  803302:	f7 75 b0             	divl   -0x50(%ebp)
  803305:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803308:	29 d0                	sub    %edx,%eax
  80330a:	83 ec 04             	sub    $0x4,%esp
  80330d:	6a 01                	push   $0x1
  80330f:	50                   	push   %eax
  803310:	ff 75 bc             	pushl  -0x44(%ebp)
  803313:	e8 51 f5 ff ff       	call   802869 <set_block_data>
  803318:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80331b:	83 ec 0c             	sub    $0xc,%esp
  80331e:	ff 75 bc             	pushl  -0x44(%ebp)
  803321:	e8 36 04 00 00       	call   80375c <free_block>
  803326:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803329:	83 ec 0c             	sub    $0xc,%esp
  80332c:	ff 75 08             	pushl  0x8(%ebp)
  80332f:	e8 20 fa ff ff       	call   802d54 <alloc_block_BF>
  803334:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803337:	c9                   	leave  
  803338:	c3                   	ret    

00803339 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803339:	55                   	push   %ebp
  80333a:	89 e5                	mov    %esp,%ebp
  80333c:	53                   	push   %ebx
  80333d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803340:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803347:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80334e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803352:	74 1e                	je     803372 <merging+0x39>
  803354:	ff 75 08             	pushl  0x8(%ebp)
  803357:	e8 bc f1 ff ff       	call   802518 <get_block_size>
  80335c:	83 c4 04             	add    $0x4,%esp
  80335f:	89 c2                	mov    %eax,%edx
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	01 d0                	add    %edx,%eax
  803366:	3b 45 10             	cmp    0x10(%ebp),%eax
  803369:	75 07                	jne    803372 <merging+0x39>
		prev_is_free = 1;
  80336b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803372:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803376:	74 1e                	je     803396 <merging+0x5d>
  803378:	ff 75 10             	pushl  0x10(%ebp)
  80337b:	e8 98 f1 ff ff       	call   802518 <get_block_size>
  803380:	83 c4 04             	add    $0x4,%esp
  803383:	89 c2                	mov    %eax,%edx
  803385:	8b 45 10             	mov    0x10(%ebp),%eax
  803388:	01 d0                	add    %edx,%eax
  80338a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80338d:	75 07                	jne    803396 <merging+0x5d>
		next_is_free = 1;
  80338f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803396:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80339a:	0f 84 cc 00 00 00    	je     80346c <merging+0x133>
  8033a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033a4:	0f 84 c2 00 00 00    	je     80346c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8033aa:	ff 75 08             	pushl  0x8(%ebp)
  8033ad:	e8 66 f1 ff ff       	call   802518 <get_block_size>
  8033b2:	83 c4 04             	add    $0x4,%esp
  8033b5:	89 c3                	mov    %eax,%ebx
  8033b7:	ff 75 10             	pushl  0x10(%ebp)
  8033ba:	e8 59 f1 ff ff       	call   802518 <get_block_size>
  8033bf:	83 c4 04             	add    $0x4,%esp
  8033c2:	01 c3                	add    %eax,%ebx
  8033c4:	ff 75 0c             	pushl  0xc(%ebp)
  8033c7:	e8 4c f1 ff ff       	call   802518 <get_block_size>
  8033cc:	83 c4 04             	add    $0x4,%esp
  8033cf:	01 d8                	add    %ebx,%eax
  8033d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8033d4:	6a 00                	push   $0x0
  8033d6:	ff 75 ec             	pushl  -0x14(%ebp)
  8033d9:	ff 75 08             	pushl  0x8(%ebp)
  8033dc:	e8 88 f4 ff ff       	call   802869 <set_block_data>
  8033e1:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8033e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033e8:	75 17                	jne    803401 <merging+0xc8>
  8033ea:	83 ec 04             	sub    $0x4,%esp
  8033ed:	68 e7 4a 80 00       	push   $0x804ae7
  8033f2:	68 7d 01 00 00       	push   $0x17d
  8033f7:	68 05 4b 80 00       	push   $0x804b05
  8033fc:	e8 4a d3 ff ff       	call   80074b <_panic>
  803401:	8b 45 0c             	mov    0xc(%ebp),%eax
  803404:	8b 00                	mov    (%eax),%eax
  803406:	85 c0                	test   %eax,%eax
  803408:	74 10                	je     80341a <merging+0xe1>
  80340a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80340d:	8b 00                	mov    (%eax),%eax
  80340f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803412:	8b 52 04             	mov    0x4(%edx),%edx
  803415:	89 50 04             	mov    %edx,0x4(%eax)
  803418:	eb 0b                	jmp    803425 <merging+0xec>
  80341a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80341d:	8b 40 04             	mov    0x4(%eax),%eax
  803420:	a3 34 50 80 00       	mov    %eax,0x805034
  803425:	8b 45 0c             	mov    0xc(%ebp),%eax
  803428:	8b 40 04             	mov    0x4(%eax),%eax
  80342b:	85 c0                	test   %eax,%eax
  80342d:	74 0f                	je     80343e <merging+0x105>
  80342f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803432:	8b 40 04             	mov    0x4(%eax),%eax
  803435:	8b 55 0c             	mov    0xc(%ebp),%edx
  803438:	8b 12                	mov    (%edx),%edx
  80343a:	89 10                	mov    %edx,(%eax)
  80343c:	eb 0a                	jmp    803448 <merging+0x10f>
  80343e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803441:	8b 00                	mov    (%eax),%eax
  803443:	a3 30 50 80 00       	mov    %eax,0x805030
  803448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803451:	8b 45 0c             	mov    0xc(%ebp),%eax
  803454:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803460:	48                   	dec    %eax
  803461:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803466:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803467:	e9 ea 02 00 00       	jmp    803756 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80346c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803470:	74 3b                	je     8034ad <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803472:	83 ec 0c             	sub    $0xc,%esp
  803475:	ff 75 08             	pushl  0x8(%ebp)
  803478:	e8 9b f0 ff ff       	call   802518 <get_block_size>
  80347d:	83 c4 10             	add    $0x10,%esp
  803480:	89 c3                	mov    %eax,%ebx
  803482:	83 ec 0c             	sub    $0xc,%esp
  803485:	ff 75 10             	pushl  0x10(%ebp)
  803488:	e8 8b f0 ff ff       	call   802518 <get_block_size>
  80348d:	83 c4 10             	add    $0x10,%esp
  803490:	01 d8                	add    %ebx,%eax
  803492:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803495:	83 ec 04             	sub    $0x4,%esp
  803498:	6a 00                	push   $0x0
  80349a:	ff 75 e8             	pushl  -0x18(%ebp)
  80349d:	ff 75 08             	pushl  0x8(%ebp)
  8034a0:	e8 c4 f3 ff ff       	call   802869 <set_block_data>
  8034a5:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034a8:	e9 a9 02 00 00       	jmp    803756 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8034ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034b1:	0f 84 2d 01 00 00    	je     8035e4 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8034b7:	83 ec 0c             	sub    $0xc,%esp
  8034ba:	ff 75 10             	pushl  0x10(%ebp)
  8034bd:	e8 56 f0 ff ff       	call   802518 <get_block_size>
  8034c2:	83 c4 10             	add    $0x10,%esp
  8034c5:	89 c3                	mov    %eax,%ebx
  8034c7:	83 ec 0c             	sub    $0xc,%esp
  8034ca:	ff 75 0c             	pushl  0xc(%ebp)
  8034cd:	e8 46 f0 ff ff       	call   802518 <get_block_size>
  8034d2:	83 c4 10             	add    $0x10,%esp
  8034d5:	01 d8                	add    %ebx,%eax
  8034d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8034da:	83 ec 04             	sub    $0x4,%esp
  8034dd:	6a 00                	push   $0x0
  8034df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034e2:	ff 75 10             	pushl  0x10(%ebp)
  8034e5:	e8 7f f3 ff ff       	call   802869 <set_block_data>
  8034ea:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8034ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8034f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8034f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034f7:	74 06                	je     8034ff <merging+0x1c6>
  8034f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034fd:	75 17                	jne    803516 <merging+0x1dd>
  8034ff:	83 ec 04             	sub    $0x4,%esp
  803502:	68 c0 4b 80 00       	push   $0x804bc0
  803507:	68 8d 01 00 00       	push   $0x18d
  80350c:	68 05 4b 80 00       	push   $0x804b05
  803511:	e8 35 d2 ff ff       	call   80074b <_panic>
  803516:	8b 45 0c             	mov    0xc(%ebp),%eax
  803519:	8b 50 04             	mov    0x4(%eax),%edx
  80351c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80351f:	89 50 04             	mov    %edx,0x4(%eax)
  803522:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803525:	8b 55 0c             	mov    0xc(%ebp),%edx
  803528:	89 10                	mov    %edx,(%eax)
  80352a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352d:	8b 40 04             	mov    0x4(%eax),%eax
  803530:	85 c0                	test   %eax,%eax
  803532:	74 0d                	je     803541 <merging+0x208>
  803534:	8b 45 0c             	mov    0xc(%ebp),%eax
  803537:	8b 40 04             	mov    0x4(%eax),%eax
  80353a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80353d:	89 10                	mov    %edx,(%eax)
  80353f:	eb 08                	jmp    803549 <merging+0x210>
  803541:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803544:	a3 30 50 80 00       	mov    %eax,0x805030
  803549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80354c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80354f:	89 50 04             	mov    %edx,0x4(%eax)
  803552:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803557:	40                   	inc    %eax
  803558:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  80355d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803561:	75 17                	jne    80357a <merging+0x241>
  803563:	83 ec 04             	sub    $0x4,%esp
  803566:	68 e7 4a 80 00       	push   $0x804ae7
  80356b:	68 8e 01 00 00       	push   $0x18e
  803570:	68 05 4b 80 00       	push   $0x804b05
  803575:	e8 d1 d1 ff ff       	call   80074b <_panic>
  80357a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80357d:	8b 00                	mov    (%eax),%eax
  80357f:	85 c0                	test   %eax,%eax
  803581:	74 10                	je     803593 <merging+0x25a>
  803583:	8b 45 0c             	mov    0xc(%ebp),%eax
  803586:	8b 00                	mov    (%eax),%eax
  803588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80358b:	8b 52 04             	mov    0x4(%edx),%edx
  80358e:	89 50 04             	mov    %edx,0x4(%eax)
  803591:	eb 0b                	jmp    80359e <merging+0x265>
  803593:	8b 45 0c             	mov    0xc(%ebp),%eax
  803596:	8b 40 04             	mov    0x4(%eax),%eax
  803599:	a3 34 50 80 00       	mov    %eax,0x805034
  80359e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035a1:	8b 40 04             	mov    0x4(%eax),%eax
  8035a4:	85 c0                	test   %eax,%eax
  8035a6:	74 0f                	je     8035b7 <merging+0x27e>
  8035a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ab:	8b 40 04             	mov    0x4(%eax),%eax
  8035ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035b1:	8b 12                	mov    (%edx),%edx
  8035b3:	89 10                	mov    %edx,(%eax)
  8035b5:	eb 0a                	jmp    8035c1 <merging+0x288>
  8035b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ba:	8b 00                	mov    (%eax),%eax
  8035bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8035c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035d9:	48                   	dec    %eax
  8035da:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035df:	e9 72 01 00 00       	jmp    803756 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8035e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8035e7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8035ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ee:	74 79                	je     803669 <merging+0x330>
  8035f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035f4:	74 73                	je     803669 <merging+0x330>
  8035f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035fa:	74 06                	je     803602 <merging+0x2c9>
  8035fc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803600:	75 17                	jne    803619 <merging+0x2e0>
  803602:	83 ec 04             	sub    $0x4,%esp
  803605:	68 78 4b 80 00       	push   $0x804b78
  80360a:	68 94 01 00 00       	push   $0x194
  80360f:	68 05 4b 80 00       	push   $0x804b05
  803614:	e8 32 d1 ff ff       	call   80074b <_panic>
  803619:	8b 45 08             	mov    0x8(%ebp),%eax
  80361c:	8b 10                	mov    (%eax),%edx
  80361e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803621:	89 10                	mov    %edx,(%eax)
  803623:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803626:	8b 00                	mov    (%eax),%eax
  803628:	85 c0                	test   %eax,%eax
  80362a:	74 0b                	je     803637 <merging+0x2fe>
  80362c:	8b 45 08             	mov    0x8(%ebp),%eax
  80362f:	8b 00                	mov    (%eax),%eax
  803631:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803634:	89 50 04             	mov    %edx,0x4(%eax)
  803637:	8b 45 08             	mov    0x8(%ebp),%eax
  80363a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80363d:	89 10                	mov    %edx,(%eax)
  80363f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803642:	8b 55 08             	mov    0x8(%ebp),%edx
  803645:	89 50 04             	mov    %edx,0x4(%eax)
  803648:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80364b:	8b 00                	mov    (%eax),%eax
  80364d:	85 c0                	test   %eax,%eax
  80364f:	75 08                	jne    803659 <merging+0x320>
  803651:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803654:	a3 34 50 80 00       	mov    %eax,0x805034
  803659:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80365e:	40                   	inc    %eax
  80365f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803664:	e9 ce 00 00 00       	jmp    803737 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803669:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80366d:	74 65                	je     8036d4 <merging+0x39b>
  80366f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803673:	75 17                	jne    80368c <merging+0x353>
  803675:	83 ec 04             	sub    $0x4,%esp
  803678:	68 54 4b 80 00       	push   $0x804b54
  80367d:	68 95 01 00 00       	push   $0x195
  803682:	68 05 4b 80 00       	push   $0x804b05
  803687:	e8 bf d0 ff ff       	call   80074b <_panic>
  80368c:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803692:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803695:	89 50 04             	mov    %edx,0x4(%eax)
  803698:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80369b:	8b 40 04             	mov    0x4(%eax),%eax
  80369e:	85 c0                	test   %eax,%eax
  8036a0:	74 0c                	je     8036ae <merging+0x375>
  8036a2:	a1 34 50 80 00       	mov    0x805034,%eax
  8036a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036aa:	89 10                	mov    %edx,(%eax)
  8036ac:	eb 08                	jmp    8036b6 <merging+0x37d>
  8036ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036b1:	a3 30 50 80 00       	mov    %eax,0x805030
  8036b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036b9:	a3 34 50 80 00       	mov    %eax,0x805034
  8036be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036cc:	40                   	inc    %eax
  8036cd:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036d2:	eb 63                	jmp    803737 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8036d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036d8:	75 17                	jne    8036f1 <merging+0x3b8>
  8036da:	83 ec 04             	sub    $0x4,%esp
  8036dd:	68 20 4b 80 00       	push   $0x804b20
  8036e2:	68 98 01 00 00       	push   $0x198
  8036e7:	68 05 4b 80 00       	push   $0x804b05
  8036ec:	e8 5a d0 ff ff       	call   80074b <_panic>
  8036f1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036fa:	89 10                	mov    %edx,(%eax)
  8036fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ff:	8b 00                	mov    (%eax),%eax
  803701:	85 c0                	test   %eax,%eax
  803703:	74 0d                	je     803712 <merging+0x3d9>
  803705:	a1 30 50 80 00       	mov    0x805030,%eax
  80370a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80370d:	89 50 04             	mov    %edx,0x4(%eax)
  803710:	eb 08                	jmp    80371a <merging+0x3e1>
  803712:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803715:	a3 34 50 80 00       	mov    %eax,0x805034
  80371a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80371d:	a3 30 50 80 00       	mov    %eax,0x805030
  803722:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803725:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80372c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803731:	40                   	inc    %eax
  803732:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803737:	83 ec 0c             	sub    $0xc,%esp
  80373a:	ff 75 10             	pushl  0x10(%ebp)
  80373d:	e8 d6 ed ff ff       	call   802518 <get_block_size>
  803742:	83 c4 10             	add    $0x10,%esp
  803745:	83 ec 04             	sub    $0x4,%esp
  803748:	6a 00                	push   $0x0
  80374a:	50                   	push   %eax
  80374b:	ff 75 10             	pushl  0x10(%ebp)
  80374e:	e8 16 f1 ff ff       	call   802869 <set_block_data>
  803753:	83 c4 10             	add    $0x10,%esp
	}
}
  803756:	90                   	nop
  803757:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80375a:	c9                   	leave  
  80375b:	c3                   	ret    

0080375c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80375c:	55                   	push   %ebp
  80375d:	89 e5                	mov    %esp,%ebp
  80375f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803762:	a1 30 50 80 00       	mov    0x805030,%eax
  803767:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80376a:	a1 34 50 80 00       	mov    0x805034,%eax
  80376f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803772:	73 1b                	jae    80378f <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803774:	a1 34 50 80 00       	mov    0x805034,%eax
  803779:	83 ec 04             	sub    $0x4,%esp
  80377c:	ff 75 08             	pushl  0x8(%ebp)
  80377f:	6a 00                	push   $0x0
  803781:	50                   	push   %eax
  803782:	e8 b2 fb ff ff       	call   803339 <merging>
  803787:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80378a:	e9 8b 00 00 00       	jmp    80381a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80378f:	a1 30 50 80 00       	mov    0x805030,%eax
  803794:	3b 45 08             	cmp    0x8(%ebp),%eax
  803797:	76 18                	jbe    8037b1 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803799:	a1 30 50 80 00       	mov    0x805030,%eax
  80379e:	83 ec 04             	sub    $0x4,%esp
  8037a1:	ff 75 08             	pushl  0x8(%ebp)
  8037a4:	50                   	push   %eax
  8037a5:	6a 00                	push   $0x0
  8037a7:	e8 8d fb ff ff       	call   803339 <merging>
  8037ac:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037af:	eb 69                	jmp    80381a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8037b1:	a1 30 50 80 00       	mov    0x805030,%eax
  8037b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037b9:	eb 39                	jmp    8037f4 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8037bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037c1:	73 29                	jae    8037ec <free_block+0x90>
  8037c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c6:	8b 00                	mov    (%eax),%eax
  8037c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037cb:	76 1f                	jbe    8037ec <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8037cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d0:	8b 00                	mov    (%eax),%eax
  8037d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8037d5:	83 ec 04             	sub    $0x4,%esp
  8037d8:	ff 75 08             	pushl  0x8(%ebp)
  8037db:	ff 75 f0             	pushl  -0x10(%ebp)
  8037de:	ff 75 f4             	pushl  -0xc(%ebp)
  8037e1:	e8 53 fb ff ff       	call   803339 <merging>
  8037e6:	83 c4 10             	add    $0x10,%esp
			break;
  8037e9:	90                   	nop
		}
	}
}
  8037ea:	eb 2e                	jmp    80381a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8037ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8037f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f8:	74 07                	je     803801 <free_block+0xa5>
  8037fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fd:	8b 00                	mov    (%eax),%eax
  8037ff:	eb 05                	jmp    803806 <free_block+0xaa>
  803801:	b8 00 00 00 00       	mov    $0x0,%eax
  803806:	a3 38 50 80 00       	mov    %eax,0x805038
  80380b:	a1 38 50 80 00       	mov    0x805038,%eax
  803810:	85 c0                	test   %eax,%eax
  803812:	75 a7                	jne    8037bb <free_block+0x5f>
  803814:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803818:	75 a1                	jne    8037bb <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80381a:	90                   	nop
  80381b:	c9                   	leave  
  80381c:	c3                   	ret    

0080381d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80381d:	55                   	push   %ebp
  80381e:	89 e5                	mov    %esp,%ebp
  803820:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803823:	ff 75 08             	pushl  0x8(%ebp)
  803826:	e8 ed ec ff ff       	call   802518 <get_block_size>
  80382b:	83 c4 04             	add    $0x4,%esp
  80382e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803831:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803838:	eb 17                	jmp    803851 <copy_data+0x34>
  80383a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80383d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803840:	01 c2                	add    %eax,%edx
  803842:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803845:	8b 45 08             	mov    0x8(%ebp),%eax
  803848:	01 c8                	add    %ecx,%eax
  80384a:	8a 00                	mov    (%eax),%al
  80384c:	88 02                	mov    %al,(%edx)
  80384e:	ff 45 fc             	incl   -0x4(%ebp)
  803851:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803854:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803857:	72 e1                	jb     80383a <copy_data+0x1d>
}
  803859:	90                   	nop
  80385a:	c9                   	leave  
  80385b:	c3                   	ret    

0080385c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80385c:	55                   	push   %ebp
  80385d:	89 e5                	mov    %esp,%ebp
  80385f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803862:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803866:	75 23                	jne    80388b <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803868:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80386c:	74 13                	je     803881 <realloc_block_FF+0x25>
  80386e:	83 ec 0c             	sub    $0xc,%esp
  803871:	ff 75 0c             	pushl  0xc(%ebp)
  803874:	e8 1f f0 ff ff       	call   802898 <alloc_block_FF>
  803879:	83 c4 10             	add    $0x10,%esp
  80387c:	e9 f4 06 00 00       	jmp    803f75 <realloc_block_FF+0x719>
		return NULL;
  803881:	b8 00 00 00 00       	mov    $0x0,%eax
  803886:	e9 ea 06 00 00       	jmp    803f75 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80388b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80388f:	75 18                	jne    8038a9 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803891:	83 ec 0c             	sub    $0xc,%esp
  803894:	ff 75 08             	pushl  0x8(%ebp)
  803897:	e8 c0 fe ff ff       	call   80375c <free_block>
  80389c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80389f:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a4:	e9 cc 06 00 00       	jmp    803f75 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8038a9:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8038ad:	77 07                	ja     8038b6 <realloc_block_FF+0x5a>
  8038af:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8038b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b9:	83 e0 01             	and    $0x1,%eax
  8038bc:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8038bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c2:	83 c0 08             	add    $0x8,%eax
  8038c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8038c8:	83 ec 0c             	sub    $0xc,%esp
  8038cb:	ff 75 08             	pushl  0x8(%ebp)
  8038ce:	e8 45 ec ff ff       	call   802518 <get_block_size>
  8038d3:	83 c4 10             	add    $0x10,%esp
  8038d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8038d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038dc:	83 e8 08             	sub    $0x8,%eax
  8038df:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8038e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e5:	83 e8 04             	sub    $0x4,%eax
  8038e8:	8b 00                	mov    (%eax),%eax
  8038ea:	83 e0 fe             	and    $0xfffffffe,%eax
  8038ed:	89 c2                	mov    %eax,%edx
  8038ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f2:	01 d0                	add    %edx,%eax
  8038f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8038f7:	83 ec 0c             	sub    $0xc,%esp
  8038fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038fd:	e8 16 ec ff ff       	call   802518 <get_block_size>
  803902:	83 c4 10             	add    $0x10,%esp
  803905:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803908:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80390b:	83 e8 08             	sub    $0x8,%eax
  80390e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803911:	8b 45 0c             	mov    0xc(%ebp),%eax
  803914:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803917:	75 08                	jne    803921 <realloc_block_FF+0xc5>
	{
		 return va;
  803919:	8b 45 08             	mov    0x8(%ebp),%eax
  80391c:	e9 54 06 00 00       	jmp    803f75 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803921:	8b 45 0c             	mov    0xc(%ebp),%eax
  803924:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803927:	0f 83 e5 03 00 00    	jae    803d12 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80392d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803930:	2b 45 0c             	sub    0xc(%ebp),%eax
  803933:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803936:	83 ec 0c             	sub    $0xc,%esp
  803939:	ff 75 e4             	pushl  -0x1c(%ebp)
  80393c:	e8 f0 eb ff ff       	call   802531 <is_free_block>
  803941:	83 c4 10             	add    $0x10,%esp
  803944:	84 c0                	test   %al,%al
  803946:	0f 84 3b 01 00 00    	je     803a87 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80394c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80394f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803952:	01 d0                	add    %edx,%eax
  803954:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803957:	83 ec 04             	sub    $0x4,%esp
  80395a:	6a 01                	push   $0x1
  80395c:	ff 75 f0             	pushl  -0x10(%ebp)
  80395f:	ff 75 08             	pushl  0x8(%ebp)
  803962:	e8 02 ef ff ff       	call   802869 <set_block_data>
  803967:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80396a:	8b 45 08             	mov    0x8(%ebp),%eax
  80396d:	83 e8 04             	sub    $0x4,%eax
  803970:	8b 00                	mov    (%eax),%eax
  803972:	83 e0 fe             	and    $0xfffffffe,%eax
  803975:	89 c2                	mov    %eax,%edx
  803977:	8b 45 08             	mov    0x8(%ebp),%eax
  80397a:	01 d0                	add    %edx,%eax
  80397c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80397f:	83 ec 04             	sub    $0x4,%esp
  803982:	6a 00                	push   $0x0
  803984:	ff 75 cc             	pushl  -0x34(%ebp)
  803987:	ff 75 c8             	pushl  -0x38(%ebp)
  80398a:	e8 da ee ff ff       	call   802869 <set_block_data>
  80398f:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803992:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803996:	74 06                	je     80399e <realloc_block_FF+0x142>
  803998:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80399c:	75 17                	jne    8039b5 <realloc_block_FF+0x159>
  80399e:	83 ec 04             	sub    $0x4,%esp
  8039a1:	68 78 4b 80 00       	push   $0x804b78
  8039a6:	68 f6 01 00 00       	push   $0x1f6
  8039ab:	68 05 4b 80 00       	push   $0x804b05
  8039b0:	e8 96 cd ff ff       	call   80074b <_panic>
  8039b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b8:	8b 10                	mov    (%eax),%edx
  8039ba:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039bd:	89 10                	mov    %edx,(%eax)
  8039bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039c2:	8b 00                	mov    (%eax),%eax
  8039c4:	85 c0                	test   %eax,%eax
  8039c6:	74 0b                	je     8039d3 <realloc_block_FF+0x177>
  8039c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cb:	8b 00                	mov    (%eax),%eax
  8039cd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039d0:	89 50 04             	mov    %edx,0x4(%eax)
  8039d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039d9:	89 10                	mov    %edx,(%eax)
  8039db:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039e1:	89 50 04             	mov    %edx,0x4(%eax)
  8039e4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039e7:	8b 00                	mov    (%eax),%eax
  8039e9:	85 c0                	test   %eax,%eax
  8039eb:	75 08                	jne    8039f5 <realloc_block_FF+0x199>
  8039ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039f0:	a3 34 50 80 00       	mov    %eax,0x805034
  8039f5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039fa:	40                   	inc    %eax
  8039fb:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a04:	75 17                	jne    803a1d <realloc_block_FF+0x1c1>
  803a06:	83 ec 04             	sub    $0x4,%esp
  803a09:	68 e7 4a 80 00       	push   $0x804ae7
  803a0e:	68 f7 01 00 00       	push   $0x1f7
  803a13:	68 05 4b 80 00       	push   $0x804b05
  803a18:	e8 2e cd ff ff       	call   80074b <_panic>
  803a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a20:	8b 00                	mov    (%eax),%eax
  803a22:	85 c0                	test   %eax,%eax
  803a24:	74 10                	je     803a36 <realloc_block_FF+0x1da>
  803a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a29:	8b 00                	mov    (%eax),%eax
  803a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a2e:	8b 52 04             	mov    0x4(%edx),%edx
  803a31:	89 50 04             	mov    %edx,0x4(%eax)
  803a34:	eb 0b                	jmp    803a41 <realloc_block_FF+0x1e5>
  803a36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a39:	8b 40 04             	mov    0x4(%eax),%eax
  803a3c:	a3 34 50 80 00       	mov    %eax,0x805034
  803a41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a44:	8b 40 04             	mov    0x4(%eax),%eax
  803a47:	85 c0                	test   %eax,%eax
  803a49:	74 0f                	je     803a5a <realloc_block_FF+0x1fe>
  803a4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4e:	8b 40 04             	mov    0x4(%eax),%eax
  803a51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a54:	8b 12                	mov    (%edx),%edx
  803a56:	89 10                	mov    %edx,(%eax)
  803a58:	eb 0a                	jmp    803a64 <realloc_block_FF+0x208>
  803a5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a5d:	8b 00                	mov    (%eax),%eax
  803a5f:	a3 30 50 80 00       	mov    %eax,0x805030
  803a64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a77:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a7c:	48                   	dec    %eax
  803a7d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a82:	e9 83 02 00 00       	jmp    803d0a <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803a87:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803a8b:	0f 86 69 02 00 00    	jbe    803cfa <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803a91:	83 ec 04             	sub    $0x4,%esp
  803a94:	6a 01                	push   $0x1
  803a96:	ff 75 f0             	pushl  -0x10(%ebp)
  803a99:	ff 75 08             	pushl  0x8(%ebp)
  803a9c:	e8 c8 ed ff ff       	call   802869 <set_block_data>
  803aa1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa7:	83 e8 04             	sub    $0x4,%eax
  803aaa:	8b 00                	mov    (%eax),%eax
  803aac:	83 e0 fe             	and    $0xfffffffe,%eax
  803aaf:	89 c2                	mov    %eax,%edx
  803ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab4:	01 d0                	add    %edx,%eax
  803ab6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803ab9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803abe:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803ac1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ac5:	75 68                	jne    803b2f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ac7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803acb:	75 17                	jne    803ae4 <realloc_block_FF+0x288>
  803acd:	83 ec 04             	sub    $0x4,%esp
  803ad0:	68 20 4b 80 00       	push   $0x804b20
  803ad5:	68 06 02 00 00       	push   $0x206
  803ada:	68 05 4b 80 00       	push   $0x804b05
  803adf:	e8 67 cc ff ff       	call   80074b <_panic>
  803ae4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803aea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aed:	89 10                	mov    %edx,(%eax)
  803aef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803af2:	8b 00                	mov    (%eax),%eax
  803af4:	85 c0                	test   %eax,%eax
  803af6:	74 0d                	je     803b05 <realloc_block_FF+0x2a9>
  803af8:	a1 30 50 80 00       	mov    0x805030,%eax
  803afd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b00:	89 50 04             	mov    %edx,0x4(%eax)
  803b03:	eb 08                	jmp    803b0d <realloc_block_FF+0x2b1>
  803b05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b08:	a3 34 50 80 00       	mov    %eax,0x805034
  803b0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b10:	a3 30 50 80 00       	mov    %eax,0x805030
  803b15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b1f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b24:	40                   	inc    %eax
  803b25:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b2a:	e9 b0 01 00 00       	jmp    803cdf <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803b2f:	a1 30 50 80 00       	mov    0x805030,%eax
  803b34:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b37:	76 68                	jbe    803ba1 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b39:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b3d:	75 17                	jne    803b56 <realloc_block_FF+0x2fa>
  803b3f:	83 ec 04             	sub    $0x4,%esp
  803b42:	68 20 4b 80 00       	push   $0x804b20
  803b47:	68 0b 02 00 00       	push   $0x20b
  803b4c:	68 05 4b 80 00       	push   $0x804b05
  803b51:	e8 f5 cb ff ff       	call   80074b <_panic>
  803b56:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b5f:	89 10                	mov    %edx,(%eax)
  803b61:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b64:	8b 00                	mov    (%eax),%eax
  803b66:	85 c0                	test   %eax,%eax
  803b68:	74 0d                	je     803b77 <realloc_block_FF+0x31b>
  803b6a:	a1 30 50 80 00       	mov    0x805030,%eax
  803b6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b72:	89 50 04             	mov    %edx,0x4(%eax)
  803b75:	eb 08                	jmp    803b7f <realloc_block_FF+0x323>
  803b77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b7a:	a3 34 50 80 00       	mov    %eax,0x805034
  803b7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b82:	a3 30 50 80 00       	mov    %eax,0x805030
  803b87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b91:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b96:	40                   	inc    %eax
  803b97:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b9c:	e9 3e 01 00 00       	jmp    803cdf <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803ba1:	a1 30 50 80 00       	mov    0x805030,%eax
  803ba6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ba9:	73 68                	jae    803c13 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803bab:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803baf:	75 17                	jne    803bc8 <realloc_block_FF+0x36c>
  803bb1:	83 ec 04             	sub    $0x4,%esp
  803bb4:	68 54 4b 80 00       	push   $0x804b54
  803bb9:	68 10 02 00 00       	push   $0x210
  803bbe:	68 05 4b 80 00       	push   $0x804b05
  803bc3:	e8 83 cb ff ff       	call   80074b <_panic>
  803bc8:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803bce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bd1:	89 50 04             	mov    %edx,0x4(%eax)
  803bd4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bd7:	8b 40 04             	mov    0x4(%eax),%eax
  803bda:	85 c0                	test   %eax,%eax
  803bdc:	74 0c                	je     803bea <realloc_block_FF+0x38e>
  803bde:	a1 34 50 80 00       	mov    0x805034,%eax
  803be3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803be6:	89 10                	mov    %edx,(%eax)
  803be8:	eb 08                	jmp    803bf2 <realloc_block_FF+0x396>
  803bea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bed:	a3 30 50 80 00       	mov    %eax,0x805030
  803bf2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bf5:	a3 34 50 80 00       	mov    %eax,0x805034
  803bfa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c03:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c08:	40                   	inc    %eax
  803c09:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c0e:	e9 cc 00 00 00       	jmp    803cdf <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803c13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803c1a:	a1 30 50 80 00       	mov    0x805030,%eax
  803c1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c22:	e9 8a 00 00 00       	jmp    803cb1 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c2d:	73 7a                	jae    803ca9 <realloc_block_FF+0x44d>
  803c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c32:	8b 00                	mov    (%eax),%eax
  803c34:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c37:	73 70                	jae    803ca9 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803c39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c3d:	74 06                	je     803c45 <realloc_block_FF+0x3e9>
  803c3f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c43:	75 17                	jne    803c5c <realloc_block_FF+0x400>
  803c45:	83 ec 04             	sub    $0x4,%esp
  803c48:	68 78 4b 80 00       	push   $0x804b78
  803c4d:	68 1a 02 00 00       	push   $0x21a
  803c52:	68 05 4b 80 00       	push   $0x804b05
  803c57:	e8 ef ca ff ff       	call   80074b <_panic>
  803c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5f:	8b 10                	mov    (%eax),%edx
  803c61:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c64:	89 10                	mov    %edx,(%eax)
  803c66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c69:	8b 00                	mov    (%eax),%eax
  803c6b:	85 c0                	test   %eax,%eax
  803c6d:	74 0b                	je     803c7a <realloc_block_FF+0x41e>
  803c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c72:	8b 00                	mov    (%eax),%eax
  803c74:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c77:	89 50 04             	mov    %edx,0x4(%eax)
  803c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c80:	89 10                	mov    %edx,(%eax)
  803c82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c88:	89 50 04             	mov    %edx,0x4(%eax)
  803c8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c8e:	8b 00                	mov    (%eax),%eax
  803c90:	85 c0                	test   %eax,%eax
  803c92:	75 08                	jne    803c9c <realloc_block_FF+0x440>
  803c94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c97:	a3 34 50 80 00       	mov    %eax,0x805034
  803c9c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ca1:	40                   	inc    %eax
  803ca2:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803ca7:	eb 36                	jmp    803cdf <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803ca9:	a1 38 50 80 00       	mov    0x805038,%eax
  803cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cb5:	74 07                	je     803cbe <realloc_block_FF+0x462>
  803cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cba:	8b 00                	mov    (%eax),%eax
  803cbc:	eb 05                	jmp    803cc3 <realloc_block_FF+0x467>
  803cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  803cc3:	a3 38 50 80 00       	mov    %eax,0x805038
  803cc8:	a1 38 50 80 00       	mov    0x805038,%eax
  803ccd:	85 c0                	test   %eax,%eax
  803ccf:	0f 85 52 ff ff ff    	jne    803c27 <realloc_block_FF+0x3cb>
  803cd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cd9:	0f 85 48 ff ff ff    	jne    803c27 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803cdf:	83 ec 04             	sub    $0x4,%esp
  803ce2:	6a 00                	push   $0x0
  803ce4:	ff 75 d8             	pushl  -0x28(%ebp)
  803ce7:	ff 75 d4             	pushl  -0x2c(%ebp)
  803cea:	e8 7a eb ff ff       	call   802869 <set_block_data>
  803cef:	83 c4 10             	add    $0x10,%esp
				return va;
  803cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf5:	e9 7b 02 00 00       	jmp    803f75 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803cfa:	83 ec 0c             	sub    $0xc,%esp
  803cfd:	68 f5 4b 80 00       	push   $0x804bf5
  803d02:	e8 01 cd ff ff       	call   800a08 <cprintf>
  803d07:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0d:	e9 63 02 00 00       	jmp    803f75 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d15:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d18:	0f 86 4d 02 00 00    	jbe    803f6b <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803d1e:	83 ec 0c             	sub    $0xc,%esp
  803d21:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d24:	e8 08 e8 ff ff       	call   802531 <is_free_block>
  803d29:	83 c4 10             	add    $0x10,%esp
  803d2c:	84 c0                	test   %al,%al
  803d2e:	0f 84 37 02 00 00    	je     803f6b <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d37:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803d3d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d40:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d43:	76 38                	jbe    803d7d <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803d45:	83 ec 0c             	sub    $0xc,%esp
  803d48:	ff 75 08             	pushl  0x8(%ebp)
  803d4b:	e8 0c fa ff ff       	call   80375c <free_block>
  803d50:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803d53:	83 ec 0c             	sub    $0xc,%esp
  803d56:	ff 75 0c             	pushl  0xc(%ebp)
  803d59:	e8 3a eb ff ff       	call   802898 <alloc_block_FF>
  803d5e:	83 c4 10             	add    $0x10,%esp
  803d61:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803d64:	83 ec 08             	sub    $0x8,%esp
  803d67:	ff 75 c0             	pushl  -0x40(%ebp)
  803d6a:	ff 75 08             	pushl  0x8(%ebp)
  803d6d:	e8 ab fa ff ff       	call   80381d <copy_data>
  803d72:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803d75:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803d78:	e9 f8 01 00 00       	jmp    803f75 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d80:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803d83:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803d86:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803d8a:	0f 87 a0 00 00 00    	ja     803e30 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803d90:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d94:	75 17                	jne    803dad <realloc_block_FF+0x551>
  803d96:	83 ec 04             	sub    $0x4,%esp
  803d99:	68 e7 4a 80 00       	push   $0x804ae7
  803d9e:	68 38 02 00 00       	push   $0x238
  803da3:	68 05 4b 80 00       	push   $0x804b05
  803da8:	e8 9e c9 ff ff       	call   80074b <_panic>
  803dad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db0:	8b 00                	mov    (%eax),%eax
  803db2:	85 c0                	test   %eax,%eax
  803db4:	74 10                	je     803dc6 <realloc_block_FF+0x56a>
  803db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db9:	8b 00                	mov    (%eax),%eax
  803dbb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dbe:	8b 52 04             	mov    0x4(%edx),%edx
  803dc1:	89 50 04             	mov    %edx,0x4(%eax)
  803dc4:	eb 0b                	jmp    803dd1 <realloc_block_FF+0x575>
  803dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc9:	8b 40 04             	mov    0x4(%eax),%eax
  803dcc:	a3 34 50 80 00       	mov    %eax,0x805034
  803dd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd4:	8b 40 04             	mov    0x4(%eax),%eax
  803dd7:	85 c0                	test   %eax,%eax
  803dd9:	74 0f                	je     803dea <realloc_block_FF+0x58e>
  803ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dde:	8b 40 04             	mov    0x4(%eax),%eax
  803de1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803de4:	8b 12                	mov    (%edx),%edx
  803de6:	89 10                	mov    %edx,(%eax)
  803de8:	eb 0a                	jmp    803df4 <realloc_block_FF+0x598>
  803dea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ded:	8b 00                	mov    (%eax),%eax
  803def:	a3 30 50 80 00       	mov    %eax,0x805030
  803df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e07:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e0c:	48                   	dec    %eax
  803e0d:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803e12:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e18:	01 d0                	add    %edx,%eax
  803e1a:	83 ec 04             	sub    $0x4,%esp
  803e1d:	6a 01                	push   $0x1
  803e1f:	50                   	push   %eax
  803e20:	ff 75 08             	pushl  0x8(%ebp)
  803e23:	e8 41 ea ff ff       	call   802869 <set_block_data>
  803e28:	83 c4 10             	add    $0x10,%esp
  803e2b:	e9 36 01 00 00       	jmp    803f66 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803e30:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e33:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e36:	01 d0                	add    %edx,%eax
  803e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803e3b:	83 ec 04             	sub    $0x4,%esp
  803e3e:	6a 01                	push   $0x1
  803e40:	ff 75 f0             	pushl  -0x10(%ebp)
  803e43:	ff 75 08             	pushl  0x8(%ebp)
  803e46:	e8 1e ea ff ff       	call   802869 <set_block_data>
  803e4b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e51:	83 e8 04             	sub    $0x4,%eax
  803e54:	8b 00                	mov    (%eax),%eax
  803e56:	83 e0 fe             	and    $0xfffffffe,%eax
  803e59:	89 c2                	mov    %eax,%edx
  803e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5e:	01 d0                	add    %edx,%eax
  803e60:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803e63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e67:	74 06                	je     803e6f <realloc_block_FF+0x613>
  803e69:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803e6d:	75 17                	jne    803e86 <realloc_block_FF+0x62a>
  803e6f:	83 ec 04             	sub    $0x4,%esp
  803e72:	68 78 4b 80 00       	push   $0x804b78
  803e77:	68 44 02 00 00       	push   $0x244
  803e7c:	68 05 4b 80 00       	push   $0x804b05
  803e81:	e8 c5 c8 ff ff       	call   80074b <_panic>
  803e86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e89:	8b 10                	mov    (%eax),%edx
  803e8b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e8e:	89 10                	mov    %edx,(%eax)
  803e90:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e93:	8b 00                	mov    (%eax),%eax
  803e95:	85 c0                	test   %eax,%eax
  803e97:	74 0b                	je     803ea4 <realloc_block_FF+0x648>
  803e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e9c:	8b 00                	mov    (%eax),%eax
  803e9e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ea1:	89 50 04             	mov    %edx,0x4(%eax)
  803ea4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803eaa:	89 10                	mov    %edx,(%eax)
  803eac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803eaf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803eb2:	89 50 04             	mov    %edx,0x4(%eax)
  803eb5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803eb8:	8b 00                	mov    (%eax),%eax
  803eba:	85 c0                	test   %eax,%eax
  803ebc:	75 08                	jne    803ec6 <realloc_block_FF+0x66a>
  803ebe:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ec1:	a3 34 50 80 00       	mov    %eax,0x805034
  803ec6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ecb:	40                   	inc    %eax
  803ecc:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ed1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ed5:	75 17                	jne    803eee <realloc_block_FF+0x692>
  803ed7:	83 ec 04             	sub    $0x4,%esp
  803eda:	68 e7 4a 80 00       	push   $0x804ae7
  803edf:	68 45 02 00 00       	push   $0x245
  803ee4:	68 05 4b 80 00       	push   $0x804b05
  803ee9:	e8 5d c8 ff ff       	call   80074b <_panic>
  803eee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef1:	8b 00                	mov    (%eax),%eax
  803ef3:	85 c0                	test   %eax,%eax
  803ef5:	74 10                	je     803f07 <realloc_block_FF+0x6ab>
  803ef7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efa:	8b 00                	mov    (%eax),%eax
  803efc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803eff:	8b 52 04             	mov    0x4(%edx),%edx
  803f02:	89 50 04             	mov    %edx,0x4(%eax)
  803f05:	eb 0b                	jmp    803f12 <realloc_block_FF+0x6b6>
  803f07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f0a:	8b 40 04             	mov    0x4(%eax),%eax
  803f0d:	a3 34 50 80 00       	mov    %eax,0x805034
  803f12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f15:	8b 40 04             	mov    0x4(%eax),%eax
  803f18:	85 c0                	test   %eax,%eax
  803f1a:	74 0f                	je     803f2b <realloc_block_FF+0x6cf>
  803f1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f1f:	8b 40 04             	mov    0x4(%eax),%eax
  803f22:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f25:	8b 12                	mov    (%edx),%edx
  803f27:	89 10                	mov    %edx,(%eax)
  803f29:	eb 0a                	jmp    803f35 <realloc_block_FF+0x6d9>
  803f2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f2e:	8b 00                	mov    (%eax),%eax
  803f30:	a3 30 50 80 00       	mov    %eax,0x805030
  803f35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f48:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f4d:	48                   	dec    %eax
  803f4e:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803f53:	83 ec 04             	sub    $0x4,%esp
  803f56:	6a 00                	push   $0x0
  803f58:	ff 75 bc             	pushl  -0x44(%ebp)
  803f5b:	ff 75 b8             	pushl  -0x48(%ebp)
  803f5e:	e8 06 e9 ff ff       	call   802869 <set_block_data>
  803f63:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803f66:	8b 45 08             	mov    0x8(%ebp),%eax
  803f69:	eb 0a                	jmp    803f75 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803f6b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803f72:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803f75:	c9                   	leave  
  803f76:	c3                   	ret    

00803f77 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803f77:	55                   	push   %ebp
  803f78:	89 e5                	mov    %esp,%ebp
  803f7a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803f7d:	83 ec 04             	sub    $0x4,%esp
  803f80:	68 fc 4b 80 00       	push   $0x804bfc
  803f85:	68 58 02 00 00       	push   $0x258
  803f8a:	68 05 4b 80 00       	push   $0x804b05
  803f8f:	e8 b7 c7 ff ff       	call   80074b <_panic>

00803f94 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803f94:	55                   	push   %ebp
  803f95:	89 e5                	mov    %esp,%ebp
  803f97:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803f9a:	83 ec 04             	sub    $0x4,%esp
  803f9d:	68 24 4c 80 00       	push   $0x804c24
  803fa2:	68 61 02 00 00       	push   $0x261
  803fa7:	68 05 4b 80 00       	push   $0x804b05
  803fac:	e8 9a c7 ff ff       	call   80074b <_panic>
  803fb1:	66 90                	xchg   %ax,%ax
  803fb3:	90                   	nop

00803fb4 <__udivdi3>:
  803fb4:	55                   	push   %ebp
  803fb5:	57                   	push   %edi
  803fb6:	56                   	push   %esi
  803fb7:	53                   	push   %ebx
  803fb8:	83 ec 1c             	sub    $0x1c,%esp
  803fbb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803fbf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803fc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fc7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803fcb:	89 ca                	mov    %ecx,%edx
  803fcd:	89 f8                	mov    %edi,%eax
  803fcf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803fd3:	85 f6                	test   %esi,%esi
  803fd5:	75 2d                	jne    804004 <__udivdi3+0x50>
  803fd7:	39 cf                	cmp    %ecx,%edi
  803fd9:	77 65                	ja     804040 <__udivdi3+0x8c>
  803fdb:	89 fd                	mov    %edi,%ebp
  803fdd:	85 ff                	test   %edi,%edi
  803fdf:	75 0b                	jne    803fec <__udivdi3+0x38>
  803fe1:	b8 01 00 00 00       	mov    $0x1,%eax
  803fe6:	31 d2                	xor    %edx,%edx
  803fe8:	f7 f7                	div    %edi
  803fea:	89 c5                	mov    %eax,%ebp
  803fec:	31 d2                	xor    %edx,%edx
  803fee:	89 c8                	mov    %ecx,%eax
  803ff0:	f7 f5                	div    %ebp
  803ff2:	89 c1                	mov    %eax,%ecx
  803ff4:	89 d8                	mov    %ebx,%eax
  803ff6:	f7 f5                	div    %ebp
  803ff8:	89 cf                	mov    %ecx,%edi
  803ffa:	89 fa                	mov    %edi,%edx
  803ffc:	83 c4 1c             	add    $0x1c,%esp
  803fff:	5b                   	pop    %ebx
  804000:	5e                   	pop    %esi
  804001:	5f                   	pop    %edi
  804002:	5d                   	pop    %ebp
  804003:	c3                   	ret    
  804004:	39 ce                	cmp    %ecx,%esi
  804006:	77 28                	ja     804030 <__udivdi3+0x7c>
  804008:	0f bd fe             	bsr    %esi,%edi
  80400b:	83 f7 1f             	xor    $0x1f,%edi
  80400e:	75 40                	jne    804050 <__udivdi3+0x9c>
  804010:	39 ce                	cmp    %ecx,%esi
  804012:	72 0a                	jb     80401e <__udivdi3+0x6a>
  804014:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804018:	0f 87 9e 00 00 00    	ja     8040bc <__udivdi3+0x108>
  80401e:	b8 01 00 00 00       	mov    $0x1,%eax
  804023:	89 fa                	mov    %edi,%edx
  804025:	83 c4 1c             	add    $0x1c,%esp
  804028:	5b                   	pop    %ebx
  804029:	5e                   	pop    %esi
  80402a:	5f                   	pop    %edi
  80402b:	5d                   	pop    %ebp
  80402c:	c3                   	ret    
  80402d:	8d 76 00             	lea    0x0(%esi),%esi
  804030:	31 ff                	xor    %edi,%edi
  804032:	31 c0                	xor    %eax,%eax
  804034:	89 fa                	mov    %edi,%edx
  804036:	83 c4 1c             	add    $0x1c,%esp
  804039:	5b                   	pop    %ebx
  80403a:	5e                   	pop    %esi
  80403b:	5f                   	pop    %edi
  80403c:	5d                   	pop    %ebp
  80403d:	c3                   	ret    
  80403e:	66 90                	xchg   %ax,%ax
  804040:	89 d8                	mov    %ebx,%eax
  804042:	f7 f7                	div    %edi
  804044:	31 ff                	xor    %edi,%edi
  804046:	89 fa                	mov    %edi,%edx
  804048:	83 c4 1c             	add    $0x1c,%esp
  80404b:	5b                   	pop    %ebx
  80404c:	5e                   	pop    %esi
  80404d:	5f                   	pop    %edi
  80404e:	5d                   	pop    %ebp
  80404f:	c3                   	ret    
  804050:	bd 20 00 00 00       	mov    $0x20,%ebp
  804055:	89 eb                	mov    %ebp,%ebx
  804057:	29 fb                	sub    %edi,%ebx
  804059:	89 f9                	mov    %edi,%ecx
  80405b:	d3 e6                	shl    %cl,%esi
  80405d:	89 c5                	mov    %eax,%ebp
  80405f:	88 d9                	mov    %bl,%cl
  804061:	d3 ed                	shr    %cl,%ebp
  804063:	89 e9                	mov    %ebp,%ecx
  804065:	09 f1                	or     %esi,%ecx
  804067:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80406b:	89 f9                	mov    %edi,%ecx
  80406d:	d3 e0                	shl    %cl,%eax
  80406f:	89 c5                	mov    %eax,%ebp
  804071:	89 d6                	mov    %edx,%esi
  804073:	88 d9                	mov    %bl,%cl
  804075:	d3 ee                	shr    %cl,%esi
  804077:	89 f9                	mov    %edi,%ecx
  804079:	d3 e2                	shl    %cl,%edx
  80407b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80407f:	88 d9                	mov    %bl,%cl
  804081:	d3 e8                	shr    %cl,%eax
  804083:	09 c2                	or     %eax,%edx
  804085:	89 d0                	mov    %edx,%eax
  804087:	89 f2                	mov    %esi,%edx
  804089:	f7 74 24 0c          	divl   0xc(%esp)
  80408d:	89 d6                	mov    %edx,%esi
  80408f:	89 c3                	mov    %eax,%ebx
  804091:	f7 e5                	mul    %ebp
  804093:	39 d6                	cmp    %edx,%esi
  804095:	72 19                	jb     8040b0 <__udivdi3+0xfc>
  804097:	74 0b                	je     8040a4 <__udivdi3+0xf0>
  804099:	89 d8                	mov    %ebx,%eax
  80409b:	31 ff                	xor    %edi,%edi
  80409d:	e9 58 ff ff ff       	jmp    803ffa <__udivdi3+0x46>
  8040a2:	66 90                	xchg   %ax,%ax
  8040a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8040a8:	89 f9                	mov    %edi,%ecx
  8040aa:	d3 e2                	shl    %cl,%edx
  8040ac:	39 c2                	cmp    %eax,%edx
  8040ae:	73 e9                	jae    804099 <__udivdi3+0xe5>
  8040b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8040b3:	31 ff                	xor    %edi,%edi
  8040b5:	e9 40 ff ff ff       	jmp    803ffa <__udivdi3+0x46>
  8040ba:	66 90                	xchg   %ax,%ax
  8040bc:	31 c0                	xor    %eax,%eax
  8040be:	e9 37 ff ff ff       	jmp    803ffa <__udivdi3+0x46>
  8040c3:	90                   	nop

008040c4 <__umoddi3>:
  8040c4:	55                   	push   %ebp
  8040c5:	57                   	push   %edi
  8040c6:	56                   	push   %esi
  8040c7:	53                   	push   %ebx
  8040c8:	83 ec 1c             	sub    $0x1c,%esp
  8040cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8040cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8040d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040e3:	89 f3                	mov    %esi,%ebx
  8040e5:	89 fa                	mov    %edi,%edx
  8040e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040eb:	89 34 24             	mov    %esi,(%esp)
  8040ee:	85 c0                	test   %eax,%eax
  8040f0:	75 1a                	jne    80410c <__umoddi3+0x48>
  8040f2:	39 f7                	cmp    %esi,%edi
  8040f4:	0f 86 a2 00 00 00    	jbe    80419c <__umoddi3+0xd8>
  8040fa:	89 c8                	mov    %ecx,%eax
  8040fc:	89 f2                	mov    %esi,%edx
  8040fe:	f7 f7                	div    %edi
  804100:	89 d0                	mov    %edx,%eax
  804102:	31 d2                	xor    %edx,%edx
  804104:	83 c4 1c             	add    $0x1c,%esp
  804107:	5b                   	pop    %ebx
  804108:	5e                   	pop    %esi
  804109:	5f                   	pop    %edi
  80410a:	5d                   	pop    %ebp
  80410b:	c3                   	ret    
  80410c:	39 f0                	cmp    %esi,%eax
  80410e:	0f 87 ac 00 00 00    	ja     8041c0 <__umoddi3+0xfc>
  804114:	0f bd e8             	bsr    %eax,%ebp
  804117:	83 f5 1f             	xor    $0x1f,%ebp
  80411a:	0f 84 ac 00 00 00    	je     8041cc <__umoddi3+0x108>
  804120:	bf 20 00 00 00       	mov    $0x20,%edi
  804125:	29 ef                	sub    %ebp,%edi
  804127:	89 fe                	mov    %edi,%esi
  804129:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80412d:	89 e9                	mov    %ebp,%ecx
  80412f:	d3 e0                	shl    %cl,%eax
  804131:	89 d7                	mov    %edx,%edi
  804133:	89 f1                	mov    %esi,%ecx
  804135:	d3 ef                	shr    %cl,%edi
  804137:	09 c7                	or     %eax,%edi
  804139:	89 e9                	mov    %ebp,%ecx
  80413b:	d3 e2                	shl    %cl,%edx
  80413d:	89 14 24             	mov    %edx,(%esp)
  804140:	89 d8                	mov    %ebx,%eax
  804142:	d3 e0                	shl    %cl,%eax
  804144:	89 c2                	mov    %eax,%edx
  804146:	8b 44 24 08          	mov    0x8(%esp),%eax
  80414a:	d3 e0                	shl    %cl,%eax
  80414c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804150:	8b 44 24 08          	mov    0x8(%esp),%eax
  804154:	89 f1                	mov    %esi,%ecx
  804156:	d3 e8                	shr    %cl,%eax
  804158:	09 d0                	or     %edx,%eax
  80415a:	d3 eb                	shr    %cl,%ebx
  80415c:	89 da                	mov    %ebx,%edx
  80415e:	f7 f7                	div    %edi
  804160:	89 d3                	mov    %edx,%ebx
  804162:	f7 24 24             	mull   (%esp)
  804165:	89 c6                	mov    %eax,%esi
  804167:	89 d1                	mov    %edx,%ecx
  804169:	39 d3                	cmp    %edx,%ebx
  80416b:	0f 82 87 00 00 00    	jb     8041f8 <__umoddi3+0x134>
  804171:	0f 84 91 00 00 00    	je     804208 <__umoddi3+0x144>
  804177:	8b 54 24 04          	mov    0x4(%esp),%edx
  80417b:	29 f2                	sub    %esi,%edx
  80417d:	19 cb                	sbb    %ecx,%ebx
  80417f:	89 d8                	mov    %ebx,%eax
  804181:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804185:	d3 e0                	shl    %cl,%eax
  804187:	89 e9                	mov    %ebp,%ecx
  804189:	d3 ea                	shr    %cl,%edx
  80418b:	09 d0                	or     %edx,%eax
  80418d:	89 e9                	mov    %ebp,%ecx
  80418f:	d3 eb                	shr    %cl,%ebx
  804191:	89 da                	mov    %ebx,%edx
  804193:	83 c4 1c             	add    $0x1c,%esp
  804196:	5b                   	pop    %ebx
  804197:	5e                   	pop    %esi
  804198:	5f                   	pop    %edi
  804199:	5d                   	pop    %ebp
  80419a:	c3                   	ret    
  80419b:	90                   	nop
  80419c:	89 fd                	mov    %edi,%ebp
  80419e:	85 ff                	test   %edi,%edi
  8041a0:	75 0b                	jne    8041ad <__umoddi3+0xe9>
  8041a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8041a7:	31 d2                	xor    %edx,%edx
  8041a9:	f7 f7                	div    %edi
  8041ab:	89 c5                	mov    %eax,%ebp
  8041ad:	89 f0                	mov    %esi,%eax
  8041af:	31 d2                	xor    %edx,%edx
  8041b1:	f7 f5                	div    %ebp
  8041b3:	89 c8                	mov    %ecx,%eax
  8041b5:	f7 f5                	div    %ebp
  8041b7:	89 d0                	mov    %edx,%eax
  8041b9:	e9 44 ff ff ff       	jmp    804102 <__umoddi3+0x3e>
  8041be:	66 90                	xchg   %ax,%ax
  8041c0:	89 c8                	mov    %ecx,%eax
  8041c2:	89 f2                	mov    %esi,%edx
  8041c4:	83 c4 1c             	add    $0x1c,%esp
  8041c7:	5b                   	pop    %ebx
  8041c8:	5e                   	pop    %esi
  8041c9:	5f                   	pop    %edi
  8041ca:	5d                   	pop    %ebp
  8041cb:	c3                   	ret    
  8041cc:	3b 04 24             	cmp    (%esp),%eax
  8041cf:	72 06                	jb     8041d7 <__umoddi3+0x113>
  8041d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8041d5:	77 0f                	ja     8041e6 <__umoddi3+0x122>
  8041d7:	89 f2                	mov    %esi,%edx
  8041d9:	29 f9                	sub    %edi,%ecx
  8041db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8041df:	89 14 24             	mov    %edx,(%esp)
  8041e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041ea:	8b 14 24             	mov    (%esp),%edx
  8041ed:	83 c4 1c             	add    $0x1c,%esp
  8041f0:	5b                   	pop    %ebx
  8041f1:	5e                   	pop    %esi
  8041f2:	5f                   	pop    %edi
  8041f3:	5d                   	pop    %ebp
  8041f4:	c3                   	ret    
  8041f5:	8d 76 00             	lea    0x0(%esi),%esi
  8041f8:	2b 04 24             	sub    (%esp),%eax
  8041fb:	19 fa                	sbb    %edi,%edx
  8041fd:	89 d1                	mov    %edx,%ecx
  8041ff:	89 c6                	mov    %eax,%esi
  804201:	e9 71 ff ff ff       	jmp    804177 <__umoddi3+0xb3>
  804206:	66 90                	xchg   %ax,%ax
  804208:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80420c:	72 ea                	jb     8041f8 <__umoddi3+0x134>
  80420e:	89 d9                	mov    %ebx,%ecx
  804210:	e9 62 ff ff ff       	jmp    804177 <__umoddi3+0xb3>
