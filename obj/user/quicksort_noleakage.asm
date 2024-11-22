
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
  800041:	e8 41 1e 00 00       	call   801e87 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 41 80 00       	push   $0x804140
  80004e:	e8 b5 09 00 00       	call   800a08 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 41 80 00       	push   $0x804142
  80005e:	e8 a5 09 00 00       	call   800a08 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 5b 41 80 00       	push   $0x80415b
  80006e:	e8 95 09 00 00       	call   800a08 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 41 80 00       	push   $0x804142
  80007e:	e8 85 09 00 00       	call   800a08 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 41 80 00       	push   $0x804140
  80008e:	e8 75 09 00 00       	call   800a08 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 74 41 80 00       	push   $0x804174
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
  8000c9:	68 94 41 80 00       	push   $0x804194
  8000ce:	e8 35 09 00 00       	call   800a08 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 b6 41 80 00       	push   $0x8041b6
  8000de:	e8 25 09 00 00       	call   800a08 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 c4 41 80 00       	push   $0x8041c4
  8000ee:	e8 15 09 00 00       	call   800a08 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 d3 41 80 00       	push   $0x8041d3
  8000fe:	e8 05 09 00 00       	call   800a08 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 e3 41 80 00       	push   $0x8041e3
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
  80014d:	e8 4f 1d 00 00       	call   801ea1 <sys_unlock_cons>
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
  8001d5:	e8 ad 1c 00 00       	call   801e87 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 ec 41 80 00       	push   $0x8041ec
  8001e2:	e8 21 08 00 00       	call   800a08 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 b2 1c 00 00       	call   801ea1 <sys_unlock_cons>
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
  80020c:	68 20 42 80 00       	push   $0x804220
  800211:	6a 54                	push   $0x54
  800213:	68 42 42 80 00       	push   $0x804242
  800218:	e8 2e 05 00 00       	call   80074b <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 65 1c 00 00       	call   801e87 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 60 42 80 00       	push   $0x804260
  80022a:	e8 d9 07 00 00       	call   800a08 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 94 42 80 00       	push   $0x804294
  80023a:	e8 c9 07 00 00       	call   800a08 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 c8 42 80 00       	push   $0x8042c8
  80024a:	e8 b9 07 00 00       	call   800a08 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 4a 1c 00 00       	call   801ea1 <sys_unlock_cons>
			//			sys_unlock_cons();


		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 ec             	pushl  -0x14(%ebp)
  80025d:	e8 7d 19 00 00       	call   801bdf <free>
  800262:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
  800265:	e8 1d 1c 00 00       	call   801e87 <sys_lock_cons>
		{
			Chose = 0 ;
  80026a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  80026e:	eb 42                	jmp    8002b2 <_main+0x27a>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 fa 42 80 00       	push   $0x8042fa
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
  8002be:	e8 de 1b 00 00       	call   801ea1 <sys_unlock_cons>
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
  800570:	68 40 41 80 00       	push   $0x804140
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
  800592:	68 18 43 80 00       	push   $0x804318
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
  8005c0:	68 1d 43 80 00       	push   $0x80431d
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
  8005e4:	e8 e9 19 00 00       	call   801fd2 <sys_cputc>
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
  8005f5:	e8 74 18 00 00       	call   801e6e <sys_cgetc>
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
  800612:	e8 ec 1a 00 00       	call   802103 <sys_getenvindex>
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
  800680:	e8 02 18 00 00       	call   801e87 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800685:	83 ec 0c             	sub    $0xc,%esp
  800688:	68 3c 43 80 00       	push   $0x80433c
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
  8006b0:	68 64 43 80 00       	push   $0x804364
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
  8006e1:	68 8c 43 80 00       	push   $0x80438c
  8006e6:	e8 1d 03 00 00       	call   800a08 <cprintf>
  8006eb:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f3:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	50                   	push   %eax
  8006fd:	68 e4 43 80 00       	push   $0x8043e4
  800702:	e8 01 03 00 00       	call   800a08 <cprintf>
  800707:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 3c 43 80 00       	push   $0x80433c
  800712:	e8 f1 02 00 00       	call   800a08 <cprintf>
  800717:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80071a:	e8 82 17 00 00       	call   801ea1 <sys_unlock_cons>
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
  800732:	e8 98 19 00 00       	call   8020cf <sys_destroy_env>
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
  800743:	e8 ed 19 00 00       	call   802135 <sys_exit_env>
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
  80076c:	68 f8 43 80 00       	push   $0x8043f8
  800771:	e8 92 02 00 00       	call   800a08 <cprintf>
  800776:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800779:	a1 00 50 80 00       	mov    0x805000,%eax
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	ff 75 08             	pushl  0x8(%ebp)
  800784:	50                   	push   %eax
  800785:	68 fd 43 80 00       	push   $0x8043fd
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
  8007a9:	68 19 44 80 00       	push   $0x804419
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
  8007d8:	68 1c 44 80 00       	push   $0x80441c
  8007dd:	6a 26                	push   $0x26
  8007df:	68 68 44 80 00       	push   $0x804468
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
  8008ad:	68 74 44 80 00       	push   $0x804474
  8008b2:	6a 3a                	push   $0x3a
  8008b4:	68 68 44 80 00       	push   $0x804468
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
  800920:	68 c8 44 80 00       	push   $0x8044c8
  800925:	6a 44                	push   $0x44
  800927:	68 68 44 80 00       	push   $0x804468
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
  80097a:	e8 c6 14 00 00       	call   801e45 <sys_cputs>
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
  8009f1:	e8 4f 14 00 00       	call   801e45 <sys_cputs>
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
  800a3b:	e8 47 14 00 00       	call   801e87 <sys_lock_cons>
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
  800a5b:	e8 41 14 00 00       	call   801ea1 <sys_unlock_cons>
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
  800aa5:	e8 32 34 00 00       	call   803edc <__udivdi3>
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
  800af5:	e8 f2 34 00 00       	call   803fec <__umoddi3>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	05 34 47 80 00       	add    $0x804734,%eax
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
  800c50:	8b 04 85 58 47 80 00 	mov    0x804758(,%eax,4),%eax
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
  800d31:	8b 34 9d a0 45 80 00 	mov    0x8045a0(,%ebx,4),%esi
  800d38:	85 f6                	test   %esi,%esi
  800d3a:	75 19                	jne    800d55 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d3c:	53                   	push   %ebx
  800d3d:	68 45 47 80 00       	push   $0x804745
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
  800d56:	68 4e 47 80 00       	push   $0x80474e
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
  800d83:	be 51 47 80 00       	mov    $0x804751,%esi
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
  8010ae:	68 c8 48 80 00       	push   $0x8048c8
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
  8010f0:	68 cb 48 80 00       	push   $0x8048cb
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
  8011a1:	e8 e1 0c 00 00       	call   801e87 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8011a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011aa:	74 13                	je     8011bf <atomic_readline+0x24>
			cprintf("%s", prompt);
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	ff 75 08             	pushl  0x8(%ebp)
  8011b2:	68 c8 48 80 00       	push   $0x8048c8
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
  8011f4:	68 cb 48 80 00       	push   $0x8048cb
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
  80129c:	e8 00 0c 00 00       	call   801ea1 <sys_unlock_cons>
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
  801996:	68 dc 48 80 00       	push   $0x8048dc
  80199b:	68 3f 01 00 00       	push   $0x13f
  8019a0:	68 fe 48 80 00       	push   $0x8048fe
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
  8019b6:	e8 35 0a 00 00       	call   8023f0 <sys_sbrk>
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
  801a31:	e8 3e 08 00 00       	call   802274 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a36:	85 c0                	test   %eax,%eax
  801a38:	74 16                	je     801a50 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a3a:	83 ec 0c             	sub    $0xc,%esp
  801a3d:	ff 75 08             	pushl  0x8(%ebp)
  801a40:	e8 7e 0d 00 00       	call   8027c3 <alloc_block_FF>
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a4b:	e9 8a 01 00 00       	jmp    801bda <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801a50:	e8 50 08 00 00       	call   8022a5 <sys_isUHeapPlacementStrategyBESTFIT>
  801a55:	85 c0                	test   %eax,%eax
  801a57:	0f 84 7d 01 00 00    	je     801bda <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801a5d:	83 ec 0c             	sub    $0xc,%esp
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	e8 17 12 00 00       	call   802c7f <alloc_block_BF>
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
  801ab3:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801b00:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801b57:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  801bb9:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801bc0:	83 ec 08             	sub    $0x8,%esp
  801bc3:	ff 75 08             	pushl  0x8(%ebp)
  801bc6:	ff 75 f0             	pushl  -0x10(%ebp)
  801bc9:	e8 59 08 00 00       	call   802427 <sys_allocate_user_mem>
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
  801c11:	e8 2d 08 00 00       	call   802443 <get_block_size>
  801c16:	83 c4 10             	add    $0x10,%esp
  801c19:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c1c:	83 ec 0c             	sub    $0xc,%esp
  801c1f:	ff 75 08             	pushl  0x8(%ebp)
  801c22:	e8 60 1a 00 00       	call   803687 <free_block>
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
  801c5c:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801c99:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
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
  801cb9:	e8 4d 07 00 00       	call   80240b <sys_free_user_mem>
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
  801cc7:	68 0c 49 80 00       	push   $0x80490c
  801ccc:	68 84 00 00 00       	push   $0x84
  801cd1:	68 36 49 80 00       	push   $0x804936
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
  801ced:	75 07                	jne    801cf6 <smalloc+0x19>
  801cef:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf4:	eb 74                	jmp    801d6a <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cfc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d09:	39 d0                	cmp    %edx,%eax
  801d0b:	73 02                	jae    801d0f <smalloc+0x32>
  801d0d:	89 d0                	mov    %edx,%eax
  801d0f:	83 ec 0c             	sub    $0xc,%esp
  801d12:	50                   	push   %eax
  801d13:	e8 a8 fc ff ff       	call   8019c0 <malloc>
  801d18:	83 c4 10             	add    $0x10,%esp
  801d1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801d1e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d22:	75 07                	jne    801d2b <smalloc+0x4e>
  801d24:	b8 00 00 00 00       	mov    $0x0,%eax
  801d29:	eb 3f                	jmp    801d6a <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d2b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d2f:	ff 75 ec             	pushl  -0x14(%ebp)
  801d32:	50                   	push   %eax
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	ff 75 08             	pushl  0x8(%ebp)
  801d39:	e8 d4 02 00 00       	call   802012 <sys_createSharedObject>
  801d3e:	83 c4 10             	add    $0x10,%esp
  801d41:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801d44:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801d48:	74 06                	je     801d50 <smalloc+0x73>
  801d4a:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801d4e:	75 07                	jne    801d57 <smalloc+0x7a>
  801d50:	b8 00 00 00 00       	mov    $0x0,%eax
  801d55:	eb 13                	jmp    801d6a <smalloc+0x8d>
	 cprintf("153\n");
  801d57:	83 ec 0c             	sub    $0xc,%esp
  801d5a:	68 42 49 80 00       	push   $0x804942
  801d5f:	e8 a4 ec ff ff       	call   800a08 <cprintf>
  801d64:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801d72:	83 ec 04             	sub    $0x4,%esp
  801d75:	68 48 49 80 00       	push   $0x804948
  801d7a:	68 a4 00 00 00       	push   $0xa4
  801d7f:	68 36 49 80 00       	push   $0x804936
  801d84:	e8 c2 e9 ff ff       	call   80074b <_panic>

00801d89 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d8f:	83 ec 04             	sub    $0x4,%esp
  801d92:	68 6c 49 80 00       	push   $0x80496c
  801d97:	68 bc 00 00 00       	push   $0xbc
  801d9c:	68 36 49 80 00       	push   $0x804936
  801da1:	e8 a5 e9 ff ff       	call   80074b <_panic>

00801da6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801dac:	83 ec 04             	sub    $0x4,%esp
  801daf:	68 90 49 80 00       	push   $0x804990
  801db4:	68 d3 00 00 00       	push   $0xd3
  801db9:	68 36 49 80 00       	push   $0x804936
  801dbe:	e8 88 e9 ff ff       	call   80074b <_panic>

00801dc3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dc9:	83 ec 04             	sub    $0x4,%esp
  801dcc:	68 b6 49 80 00       	push   $0x8049b6
  801dd1:	68 df 00 00 00       	push   $0xdf
  801dd6:	68 36 49 80 00       	push   $0x804936
  801ddb:	e8 6b e9 ff ff       	call   80074b <_panic>

00801de0 <shrink>:

}
void shrink(uint32 newSize)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801de6:	83 ec 04             	sub    $0x4,%esp
  801de9:	68 b6 49 80 00       	push   $0x8049b6
  801dee:	68 e4 00 00 00       	push   $0xe4
  801df3:	68 36 49 80 00       	push   $0x804936
  801df8:	e8 4e e9 ff ff       	call   80074b <_panic>

00801dfd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e03:	83 ec 04             	sub    $0x4,%esp
  801e06:	68 b6 49 80 00       	push   $0x8049b6
  801e0b:	68 e9 00 00 00       	push   $0xe9
  801e10:	68 36 49 80 00       	push   $0x804936
  801e15:	e8 31 e9 ff ff       	call   80074b <_panic>

00801e1a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	57                   	push   %edi
  801e1e:	56                   	push   %esi
  801e1f:	53                   	push   %ebx
  801e20:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e2c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e2f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e32:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e35:	cd 30                	int    $0x30
  801e37:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e3d:	83 c4 10             	add    $0x10,%esp
  801e40:	5b                   	pop    %ebx
  801e41:	5e                   	pop    %esi
  801e42:	5f                   	pop    %edi
  801e43:	5d                   	pop    %ebp
  801e44:	c3                   	ret    

00801e45 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 04             	sub    $0x4,%esp
  801e4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e51:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	52                   	push   %edx
  801e5d:	ff 75 0c             	pushl  0xc(%ebp)
  801e60:	50                   	push   %eax
  801e61:	6a 00                	push   $0x0
  801e63:	e8 b2 ff ff ff       	call   801e1a <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
}
  801e6b:	90                   	nop
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_cgetc>:

int
sys_cgetc(void)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 02                	push   $0x2
  801e7d:	e8 98 ff ff ff       	call   801e1a <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 03                	push   $0x3
  801e96:	e8 7f ff ff ff       	call   801e1a <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
}
  801e9e:	90                   	nop
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 04                	push   $0x4
  801eb0:	e8 65 ff ff ff       	call   801e1a <syscall>
  801eb5:	83 c4 18             	add    $0x18,%esp
}
  801eb8:	90                   	nop
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ebe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	52                   	push   %edx
  801ecb:	50                   	push   %eax
  801ecc:	6a 08                	push   $0x8
  801ece:	e8 47 ff ff ff       	call   801e1a <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	56                   	push   %esi
  801edc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801edd:	8b 75 18             	mov    0x18(%ebp),%esi
  801ee0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eec:	56                   	push   %esi
  801eed:	53                   	push   %ebx
  801eee:	51                   	push   %ecx
  801eef:	52                   	push   %edx
  801ef0:	50                   	push   %eax
  801ef1:	6a 09                	push   $0x9
  801ef3:	e8 22 ff ff ff       	call   801e1a <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efe:	5b                   	pop    %ebx
  801eff:	5e                   	pop    %esi
  801f00:	5d                   	pop    %ebp
  801f01:	c3                   	ret    

00801f02 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	52                   	push   %edx
  801f12:	50                   	push   %eax
  801f13:	6a 0a                	push   $0xa
  801f15:	e8 00 ff ff ff       	call   801e1a <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	ff 75 0c             	pushl  0xc(%ebp)
  801f2b:	ff 75 08             	pushl  0x8(%ebp)
  801f2e:	6a 0b                	push   $0xb
  801f30:	e8 e5 fe ff ff       	call   801e1a <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 0c                	push   $0xc
  801f49:	e8 cc fe ff ff       	call   801e1a <syscall>
  801f4e:	83 c4 18             	add    $0x18,%esp
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 0d                	push   $0xd
  801f62:	e8 b3 fe ff ff       	call   801e1a <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 0e                	push   $0xe
  801f7b:	e8 9a fe ff ff       	call   801e1a <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 0f                	push   $0xf
  801f94:	e8 81 fe ff ff       	call   801e1a <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	ff 75 08             	pushl  0x8(%ebp)
  801fac:	6a 10                	push   $0x10
  801fae:	e8 67 fe ff ff       	call   801e1a <syscall>
  801fb3:	83 c4 18             	add    $0x18,%esp
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 11                	push   $0x11
  801fc7:	e8 4e fe ff ff       	call   801e1a <syscall>
  801fcc:	83 c4 18             	add    $0x18,%esp
}
  801fcf:	90                   	nop
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <sys_cputc>:

void
sys_cputc(const char c)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 04             	sub    $0x4,%esp
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fde:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	50                   	push   %eax
  801feb:	6a 01                	push   $0x1
  801fed:	e8 28 fe ff ff       	call   801e1a <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
}
  801ff5:	90                   	nop
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 14                	push   $0x14
  802007:	e8 0e fe ff ff       	call   801e1a <syscall>
  80200c:	83 c4 18             	add    $0x18,%esp
}
  80200f:	90                   	nop
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 04             	sub    $0x4,%esp
  802018:	8b 45 10             	mov    0x10(%ebp),%eax
  80201b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80201e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802021:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	6a 00                	push   $0x0
  80202a:	51                   	push   %ecx
  80202b:	52                   	push   %edx
  80202c:	ff 75 0c             	pushl  0xc(%ebp)
  80202f:	50                   	push   %eax
  802030:	6a 15                	push   $0x15
  802032:	e8 e3 fd ff ff       	call   801e1a <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80203f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	52                   	push   %edx
  80204c:	50                   	push   %eax
  80204d:	6a 16                	push   $0x16
  80204f:	e8 c6 fd ff ff       	call   801e1a <syscall>
  802054:	83 c4 18             	add    $0x18,%esp
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80205c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80205f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	51                   	push   %ecx
  80206a:	52                   	push   %edx
  80206b:	50                   	push   %eax
  80206c:	6a 17                	push   $0x17
  80206e:	e8 a7 fd ff ff       	call   801e1a <syscall>
  802073:	83 c4 18             	add    $0x18,%esp
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80207b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	52                   	push   %edx
  802088:	50                   	push   %eax
  802089:	6a 18                	push   $0x18
  80208b:	e8 8a fd ff ff       	call   801e1a <syscall>
  802090:	83 c4 18             	add    $0x18,%esp
}
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	6a 00                	push   $0x0
  80209d:	ff 75 14             	pushl  0x14(%ebp)
  8020a0:	ff 75 10             	pushl  0x10(%ebp)
  8020a3:	ff 75 0c             	pushl  0xc(%ebp)
  8020a6:	50                   	push   %eax
  8020a7:	6a 19                	push   $0x19
  8020a9:	e8 6c fd ff ff       	call   801e1a <syscall>
  8020ae:	83 c4 18             	add    $0x18,%esp
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	50                   	push   %eax
  8020c2:	6a 1a                	push   $0x1a
  8020c4:	e8 51 fd ff ff       	call   801e1a <syscall>
  8020c9:	83 c4 18             	add    $0x18,%esp
}
  8020cc:	90                   	nop
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	50                   	push   %eax
  8020de:	6a 1b                	push   $0x1b
  8020e0:	e8 35 fd ff ff       	call   801e1a <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 05                	push   $0x5
  8020f9:	e8 1c fd ff ff       	call   801e1a <syscall>
  8020fe:	83 c4 18             	add    $0x18,%esp
}
  802101:	c9                   	leave  
  802102:	c3                   	ret    

00802103 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 06                	push   $0x6
  802112:	e8 03 fd ff ff       	call   801e1a <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 07                	push   $0x7
  80212b:	e8 ea fc ff ff       	call   801e1a <syscall>
  802130:	83 c4 18             	add    $0x18,%esp
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <sys_exit_env>:


void sys_exit_env(void)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 1c                	push   $0x1c
  802144:	e8 d1 fc ff ff       	call   801e1a <syscall>
  802149:	83 c4 18             	add    $0x18,%esp
}
  80214c:	90                   	nop
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802155:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802158:	8d 50 04             	lea    0x4(%eax),%edx
  80215b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	52                   	push   %edx
  802165:	50                   	push   %eax
  802166:	6a 1d                	push   $0x1d
  802168:	e8 ad fc ff ff       	call   801e1a <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
	return result;
  802170:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802173:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802176:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802179:	89 01                	mov    %eax,(%ecx)
  80217b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	c9                   	leave  
  802182:	c2 04 00             	ret    $0x4

00802185 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	ff 75 10             	pushl  0x10(%ebp)
  80218f:	ff 75 0c             	pushl  0xc(%ebp)
  802192:	ff 75 08             	pushl  0x8(%ebp)
  802195:	6a 13                	push   $0x13
  802197:	e8 7e fc ff ff       	call   801e1a <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
	return ;
  80219f:	90                   	nop
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 1e                	push   $0x1e
  8021b1:	e8 64 fc ff ff       	call   801e1a <syscall>
  8021b6:	83 c4 18             	add    $0x18,%esp
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	83 ec 04             	sub    $0x4,%esp
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021c7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	50                   	push   %eax
  8021d4:	6a 1f                	push   $0x1f
  8021d6:	e8 3f fc ff ff       	call   801e1a <syscall>
  8021db:	83 c4 18             	add    $0x18,%esp
	return ;
  8021de:	90                   	nop
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <rsttst>:
void rsttst()
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 21                	push   $0x21
  8021f0:	e8 25 fc ff ff       	call   801e1a <syscall>
  8021f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f8:	90                   	nop
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	83 ec 04             	sub    $0x4,%esp
  802201:	8b 45 14             	mov    0x14(%ebp),%eax
  802204:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802207:	8b 55 18             	mov    0x18(%ebp),%edx
  80220a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80220e:	52                   	push   %edx
  80220f:	50                   	push   %eax
  802210:	ff 75 10             	pushl  0x10(%ebp)
  802213:	ff 75 0c             	pushl  0xc(%ebp)
  802216:	ff 75 08             	pushl  0x8(%ebp)
  802219:	6a 20                	push   $0x20
  80221b:	e8 fa fb ff ff       	call   801e1a <syscall>
  802220:	83 c4 18             	add    $0x18,%esp
	return ;
  802223:	90                   	nop
}
  802224:	c9                   	leave  
  802225:	c3                   	ret    

00802226 <chktst>:
void chktst(uint32 n)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	ff 75 08             	pushl  0x8(%ebp)
  802234:	6a 22                	push   $0x22
  802236:	e8 df fb ff ff       	call   801e1a <syscall>
  80223b:	83 c4 18             	add    $0x18,%esp
	return ;
  80223e:	90                   	nop
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <inctst>:

void inctst()
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 23                	push   $0x23
  802250:	e8 c5 fb ff ff       	call   801e1a <syscall>
  802255:	83 c4 18             	add    $0x18,%esp
	return ;
  802258:	90                   	nop
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <gettst>:
uint32 gettst()
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 24                	push   $0x24
  80226a:	e8 ab fb ff ff       	call   801e1a <syscall>
  80226f:	83 c4 18             	add    $0x18,%esp
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 25                	push   $0x25
  802286:	e8 8f fb ff ff       	call   801e1a <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
  80228e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802291:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802295:	75 07                	jne    80229e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802297:	b8 01 00 00 00       	mov    $0x1,%eax
  80229c:	eb 05                	jmp    8022a3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 25                	push   $0x25
  8022b7:	e8 5e fb ff ff       	call   801e1a <syscall>
  8022bc:	83 c4 18             	add    $0x18,%esp
  8022bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022c2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022c6:	75 07                	jne    8022cf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cd:	eb 05                	jmp    8022d4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 25                	push   $0x25
  8022e8:	e8 2d fb ff ff       	call   801e1a <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
  8022f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022f3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022f7:	75 07                	jne    802300 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022fe:	eb 05                	jmp    802305 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802300:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 25                	push   $0x25
  802319:	e8 fc fa ff ff       	call   801e1a <syscall>
  80231e:	83 c4 18             	add    $0x18,%esp
  802321:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802324:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802328:	75 07                	jne    802331 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80232a:	b8 01 00 00 00       	mov    $0x1,%eax
  80232f:	eb 05                	jmp    802336 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802331:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	ff 75 08             	pushl  0x8(%ebp)
  802346:	6a 26                	push   $0x26
  802348:	e8 cd fa ff ff       	call   801e1a <syscall>
  80234d:	83 c4 18             	add    $0x18,%esp
	return ;
  802350:	90                   	nop
}
  802351:	c9                   	leave  
  802352:	c3                   	ret    

00802353 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802353:	55                   	push   %ebp
  802354:	89 e5                	mov    %esp,%ebp
  802356:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802357:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80235a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80235d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	6a 00                	push   $0x0
  802365:	53                   	push   %ebx
  802366:	51                   	push   %ecx
  802367:	52                   	push   %edx
  802368:	50                   	push   %eax
  802369:	6a 27                	push   $0x27
  80236b:	e8 aa fa ff ff       	call   801e1a <syscall>
  802370:	83 c4 18             	add    $0x18,%esp
}
  802373:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80237b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	52                   	push   %edx
  802388:	50                   	push   %eax
  802389:	6a 28                	push   $0x28
  80238b:	e8 8a fa ff ff       	call   801e1a <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802398:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80239b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	6a 00                	push   $0x0
  8023a3:	51                   	push   %ecx
  8023a4:	ff 75 10             	pushl  0x10(%ebp)
  8023a7:	52                   	push   %edx
  8023a8:	50                   	push   %eax
  8023a9:	6a 29                	push   $0x29
  8023ab:	e8 6a fa ff ff       	call   801e1a <syscall>
  8023b0:	83 c4 18             	add    $0x18,%esp
}
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	ff 75 10             	pushl  0x10(%ebp)
  8023bf:	ff 75 0c             	pushl  0xc(%ebp)
  8023c2:	ff 75 08             	pushl  0x8(%ebp)
  8023c5:	6a 12                	push   $0x12
  8023c7:	e8 4e fa ff ff       	call   801e1a <syscall>
  8023cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8023cf:	90                   	nop
}
  8023d0:	c9                   	leave  
  8023d1:	c3                   	ret    

008023d2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8023d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	52                   	push   %edx
  8023e2:	50                   	push   %eax
  8023e3:	6a 2a                	push   $0x2a
  8023e5:	e8 30 fa ff ff       	call   801e1a <syscall>
  8023ea:	83 c4 18             	add    $0x18,%esp
	return;
  8023ed:	90                   	nop
}
  8023ee:	c9                   	leave  
  8023ef:	c3                   	ret    

008023f0 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8023f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	50                   	push   %eax
  8023ff:	6a 2b                	push   $0x2b
  802401:	e8 14 fa ff ff       	call   801e1a <syscall>
  802406:	83 c4 18             	add    $0x18,%esp
}
  802409:	c9                   	leave  
  80240a:	c3                   	ret    

0080240b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	ff 75 0c             	pushl  0xc(%ebp)
  802417:	ff 75 08             	pushl  0x8(%ebp)
  80241a:	6a 2c                	push   $0x2c
  80241c:	e8 f9 f9 ff ff       	call   801e1a <syscall>
  802421:	83 c4 18             	add    $0x18,%esp
	return;
  802424:	90                   	nop
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	ff 75 0c             	pushl  0xc(%ebp)
  802433:	ff 75 08             	pushl  0x8(%ebp)
  802436:	6a 2d                	push   $0x2d
  802438:	e8 dd f9 ff ff       	call   801e1a <syscall>
  80243d:	83 c4 18             	add    $0x18,%esp
	return;
  802440:	90                   	nop
}
  802441:	c9                   	leave  
  802442:	c3                   	ret    

00802443 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802443:	55                   	push   %ebp
  802444:	89 e5                	mov    %esp,%ebp
  802446:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	83 e8 04             	sub    $0x4,%eax
  80244f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802455:	8b 00                	mov    (%eax),%eax
  802457:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80245a:	c9                   	leave  
  80245b:	c3                   	ret    

0080245c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
  80245f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802462:	8b 45 08             	mov    0x8(%ebp),%eax
  802465:	83 e8 04             	sub    $0x4,%eax
  802468:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80246b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	83 e0 01             	and    $0x1,%eax
  802473:	85 c0                	test   %eax,%eax
  802475:	0f 94 c0             	sete   %al
}
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802480:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248a:	83 f8 02             	cmp    $0x2,%eax
  80248d:	74 2b                	je     8024ba <alloc_block+0x40>
  80248f:	83 f8 02             	cmp    $0x2,%eax
  802492:	7f 07                	jg     80249b <alloc_block+0x21>
  802494:	83 f8 01             	cmp    $0x1,%eax
  802497:	74 0e                	je     8024a7 <alloc_block+0x2d>
  802499:	eb 58                	jmp    8024f3 <alloc_block+0x79>
  80249b:	83 f8 03             	cmp    $0x3,%eax
  80249e:	74 2d                	je     8024cd <alloc_block+0x53>
  8024a0:	83 f8 04             	cmp    $0x4,%eax
  8024a3:	74 3b                	je     8024e0 <alloc_block+0x66>
  8024a5:	eb 4c                	jmp    8024f3 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8024a7:	83 ec 0c             	sub    $0xc,%esp
  8024aa:	ff 75 08             	pushl  0x8(%ebp)
  8024ad:	e8 11 03 00 00       	call   8027c3 <alloc_block_FF>
  8024b2:	83 c4 10             	add    $0x10,%esp
  8024b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024b8:	eb 4a                	jmp    802504 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8024ba:	83 ec 0c             	sub    $0xc,%esp
  8024bd:	ff 75 08             	pushl  0x8(%ebp)
  8024c0:	e8 fa 19 00 00       	call   803ebf <alloc_block_NF>
  8024c5:	83 c4 10             	add    $0x10,%esp
  8024c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024cb:	eb 37                	jmp    802504 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8024cd:	83 ec 0c             	sub    $0xc,%esp
  8024d0:	ff 75 08             	pushl  0x8(%ebp)
  8024d3:	e8 a7 07 00 00       	call   802c7f <alloc_block_BF>
  8024d8:	83 c4 10             	add    $0x10,%esp
  8024db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024de:	eb 24                	jmp    802504 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8024e0:	83 ec 0c             	sub    $0xc,%esp
  8024e3:	ff 75 08             	pushl  0x8(%ebp)
  8024e6:	e8 b7 19 00 00       	call   803ea2 <alloc_block_WF>
  8024eb:	83 c4 10             	add    $0x10,%esp
  8024ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024f1:	eb 11                	jmp    802504 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8024f3:	83 ec 0c             	sub    $0xc,%esp
  8024f6:	68 c8 49 80 00       	push   $0x8049c8
  8024fb:	e8 08 e5 ff ff       	call   800a08 <cprintf>
  802500:	83 c4 10             	add    $0x10,%esp
		break;
  802503:	90                   	nop
	}
	return va;
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
  80250c:	53                   	push   %ebx
  80250d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802510:	83 ec 0c             	sub    $0xc,%esp
  802513:	68 e8 49 80 00       	push   $0x8049e8
  802518:	e8 eb e4 ff ff       	call   800a08 <cprintf>
  80251d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802520:	83 ec 0c             	sub    $0xc,%esp
  802523:	68 13 4a 80 00       	push   $0x804a13
  802528:	e8 db e4 ff ff       	call   800a08 <cprintf>
  80252d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802536:	eb 37                	jmp    80256f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802538:	83 ec 0c             	sub    $0xc,%esp
  80253b:	ff 75 f4             	pushl  -0xc(%ebp)
  80253e:	e8 19 ff ff ff       	call   80245c <is_free_block>
  802543:	83 c4 10             	add    $0x10,%esp
  802546:	0f be d8             	movsbl %al,%ebx
  802549:	83 ec 0c             	sub    $0xc,%esp
  80254c:	ff 75 f4             	pushl  -0xc(%ebp)
  80254f:	e8 ef fe ff ff       	call   802443 <get_block_size>
  802554:	83 c4 10             	add    $0x10,%esp
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	53                   	push   %ebx
  80255b:	50                   	push   %eax
  80255c:	68 2b 4a 80 00       	push   $0x804a2b
  802561:	e8 a2 e4 ff ff       	call   800a08 <cprintf>
  802566:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802569:	8b 45 10             	mov    0x10(%ebp),%eax
  80256c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802573:	74 07                	je     80257c <print_blocks_list+0x73>
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	8b 00                	mov    (%eax),%eax
  80257a:	eb 05                	jmp    802581 <print_blocks_list+0x78>
  80257c:	b8 00 00 00 00       	mov    $0x0,%eax
  802581:	89 45 10             	mov    %eax,0x10(%ebp)
  802584:	8b 45 10             	mov    0x10(%ebp),%eax
  802587:	85 c0                	test   %eax,%eax
  802589:	75 ad                	jne    802538 <print_blocks_list+0x2f>
  80258b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258f:	75 a7                	jne    802538 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802591:	83 ec 0c             	sub    $0xc,%esp
  802594:	68 e8 49 80 00       	push   $0x8049e8
  802599:	e8 6a e4 ff ff       	call   800a08 <cprintf>
  80259e:	83 c4 10             	add    $0x10,%esp

}
  8025a1:	90                   	nop
  8025a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
  8025aa:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8025ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b0:	83 e0 01             	and    $0x1,%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	74 03                	je     8025ba <initialize_dynamic_allocator+0x13>
  8025b7:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8025ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025be:	0f 84 c7 01 00 00    	je     80278b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8025c4:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8025cb:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8025ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d4:	01 d0                	add    %edx,%eax
  8025d6:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8025db:	0f 87 ad 01 00 00    	ja     80278e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8025e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	0f 89 a5 01 00 00    	jns    802791 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8025ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f2:	01 d0                	add    %edx,%eax
  8025f4:	83 e8 04             	sub    $0x4,%eax
  8025f7:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8025fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802603:	a1 30 50 80 00       	mov    0x805030,%eax
  802608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260b:	e9 87 00 00 00       	jmp    802697 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802610:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802614:	75 14                	jne    80262a <initialize_dynamic_allocator+0x83>
  802616:	83 ec 04             	sub    $0x4,%esp
  802619:	68 43 4a 80 00       	push   $0x804a43
  80261e:	6a 79                	push   $0x79
  802620:	68 61 4a 80 00       	push   $0x804a61
  802625:	e8 21 e1 ff ff       	call   80074b <_panic>
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 00                	mov    (%eax),%eax
  80262f:	85 c0                	test   %eax,%eax
  802631:	74 10                	je     802643 <initialize_dynamic_allocator+0x9c>
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	8b 00                	mov    (%eax),%eax
  802638:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263b:	8b 52 04             	mov    0x4(%edx),%edx
  80263e:	89 50 04             	mov    %edx,0x4(%eax)
  802641:	eb 0b                	jmp    80264e <initialize_dynamic_allocator+0xa7>
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	8b 40 04             	mov    0x4(%eax),%eax
  802649:	a3 34 50 80 00       	mov    %eax,0x805034
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	8b 40 04             	mov    0x4(%eax),%eax
  802654:	85 c0                	test   %eax,%eax
  802656:	74 0f                	je     802667 <initialize_dynamic_allocator+0xc0>
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 40 04             	mov    0x4(%eax),%eax
  80265e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802661:	8b 12                	mov    (%edx),%edx
  802663:	89 10                	mov    %edx,(%eax)
  802665:	eb 0a                	jmp    802671 <initialize_dynamic_allocator+0xca>
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	a3 30 50 80 00       	mov    %eax,0x805030
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802684:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802689:	48                   	dec    %eax
  80268a:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80268f:	a1 38 50 80 00       	mov    0x805038,%eax
  802694:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802697:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269b:	74 07                	je     8026a4 <initialize_dynamic_allocator+0xfd>
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	8b 00                	mov    (%eax),%eax
  8026a2:	eb 05                	jmp    8026a9 <initialize_dynamic_allocator+0x102>
  8026a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a9:	a3 38 50 80 00       	mov    %eax,0x805038
  8026ae:	a1 38 50 80 00       	mov    0x805038,%eax
  8026b3:	85 c0                	test   %eax,%eax
  8026b5:	0f 85 55 ff ff ff    	jne    802610 <initialize_dynamic_allocator+0x69>
  8026bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bf:	0f 85 4b ff ff ff    	jne    802610 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8026cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ce:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8026d4:	a1 48 50 80 00       	mov    0x805048,%eax
  8026d9:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8026de:	a1 44 50 80 00       	mov    0x805044,%eax
  8026e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8026e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ec:	83 c0 08             	add    $0x8,%eax
  8026ef:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	83 c0 04             	add    $0x4,%eax
  8026f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026fb:	83 ea 08             	sub    $0x8,%edx
  8026fe:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802700:	8b 55 0c             	mov    0xc(%ebp),%edx
  802703:	8b 45 08             	mov    0x8(%ebp),%eax
  802706:	01 d0                	add    %edx,%eax
  802708:	83 e8 08             	sub    $0x8,%eax
  80270b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270e:	83 ea 08             	sub    $0x8,%edx
  802711:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802713:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802716:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80271c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802726:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80272a:	75 17                	jne    802743 <initialize_dynamic_allocator+0x19c>
  80272c:	83 ec 04             	sub    $0x4,%esp
  80272f:	68 7c 4a 80 00       	push   $0x804a7c
  802734:	68 90 00 00 00       	push   $0x90
  802739:	68 61 4a 80 00       	push   $0x804a61
  80273e:	e8 08 e0 ff ff       	call   80074b <_panic>
  802743:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802749:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274c:	89 10                	mov    %edx,(%eax)
  80274e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802751:	8b 00                	mov    (%eax),%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	74 0d                	je     802764 <initialize_dynamic_allocator+0x1bd>
  802757:	a1 30 50 80 00       	mov    0x805030,%eax
  80275c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80275f:	89 50 04             	mov    %edx,0x4(%eax)
  802762:	eb 08                	jmp    80276c <initialize_dynamic_allocator+0x1c5>
  802764:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802767:	a3 34 50 80 00       	mov    %eax,0x805034
  80276c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276f:	a3 30 50 80 00       	mov    %eax,0x805030
  802774:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802777:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802783:	40                   	inc    %eax
  802784:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802789:	eb 07                	jmp    802792 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80278b:	90                   	nop
  80278c:	eb 04                	jmp    802792 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80278e:	90                   	nop
  80278f:	eb 01                	jmp    802792 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802791:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802792:	c9                   	leave  
  802793:	c3                   	ret    

00802794 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802794:	55                   	push   %ebp
  802795:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802797:	8b 45 10             	mov    0x10(%ebp),%eax
  80279a:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80279d:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a0:	8d 50 fc             	lea    -0x4(%eax),%edx
  8027a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027a6:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8027a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ab:	83 e8 04             	sub    $0x4,%eax
  8027ae:	8b 00                	mov    (%eax),%eax
  8027b0:	83 e0 fe             	and    $0xfffffffe,%eax
  8027b3:	8d 50 f8             	lea    -0x8(%eax),%edx
  8027b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b9:	01 c2                	add    %eax,%edx
  8027bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027be:	89 02                	mov    %eax,(%edx)
}
  8027c0:	90                   	nop
  8027c1:	5d                   	pop    %ebp
  8027c2:	c3                   	ret    

008027c3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8027c3:	55                   	push   %ebp
  8027c4:	89 e5                	mov    %esp,%ebp
  8027c6:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cc:	83 e0 01             	and    $0x1,%eax
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	74 03                	je     8027d6 <alloc_block_FF+0x13>
  8027d3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027d6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027da:	77 07                	ja     8027e3 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027dc:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027e3:	a1 28 50 80 00       	mov    0x805028,%eax
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	75 73                	jne    80285f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ef:	83 c0 10             	add    $0x10,%eax
  8027f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027f5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8027fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802802:	01 d0                	add    %edx,%eax
  802804:	48                   	dec    %eax
  802805:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802808:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280b:	ba 00 00 00 00       	mov    $0x0,%edx
  802810:	f7 75 ec             	divl   -0x14(%ebp)
  802813:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802816:	29 d0                	sub    %edx,%eax
  802818:	c1 e8 0c             	shr    $0xc,%eax
  80281b:	83 ec 0c             	sub    $0xc,%esp
  80281e:	50                   	push   %eax
  80281f:	e8 86 f1 ff ff       	call   8019aa <sbrk>
  802824:	83 c4 10             	add    $0x10,%esp
  802827:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80282a:	83 ec 0c             	sub    $0xc,%esp
  80282d:	6a 00                	push   $0x0
  80282f:	e8 76 f1 ff ff       	call   8019aa <sbrk>
  802834:	83 c4 10             	add    $0x10,%esp
  802837:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80283a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80283d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802840:	83 ec 08             	sub    $0x8,%esp
  802843:	50                   	push   %eax
  802844:	ff 75 e4             	pushl  -0x1c(%ebp)
  802847:	e8 5b fd ff ff       	call   8025a7 <initialize_dynamic_allocator>
  80284c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80284f:	83 ec 0c             	sub    $0xc,%esp
  802852:	68 9f 4a 80 00       	push   $0x804a9f
  802857:	e8 ac e1 ff ff       	call   800a08 <cprintf>
  80285c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80285f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802863:	75 0a                	jne    80286f <alloc_block_FF+0xac>
	        return NULL;
  802865:	b8 00 00 00 00       	mov    $0x0,%eax
  80286a:	e9 0e 04 00 00       	jmp    802c7d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80286f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802876:	a1 30 50 80 00       	mov    0x805030,%eax
  80287b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80287e:	e9 f3 02 00 00       	jmp    802b76 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802886:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802889:	83 ec 0c             	sub    $0xc,%esp
  80288c:	ff 75 bc             	pushl  -0x44(%ebp)
  80288f:	e8 af fb ff ff       	call   802443 <get_block_size>
  802894:	83 c4 10             	add    $0x10,%esp
  802897:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80289a:	8b 45 08             	mov    0x8(%ebp),%eax
  80289d:	83 c0 08             	add    $0x8,%eax
  8028a0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8028a3:	0f 87 c5 02 00 00    	ja     802b6e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ac:	83 c0 18             	add    $0x18,%eax
  8028af:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8028b2:	0f 87 19 02 00 00    	ja     802ad1 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8028b8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8028bb:	2b 45 08             	sub    0x8(%ebp),%eax
  8028be:	83 e8 08             	sub    $0x8,%eax
  8028c1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	8d 50 08             	lea    0x8(%eax),%edx
  8028ca:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028cd:	01 d0                	add    %edx,%eax
  8028cf:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	83 c0 08             	add    $0x8,%eax
  8028d8:	83 ec 04             	sub    $0x4,%esp
  8028db:	6a 01                	push   $0x1
  8028dd:	50                   	push   %eax
  8028de:	ff 75 bc             	pushl  -0x44(%ebp)
  8028e1:	e8 ae fe ff ff       	call   802794 <set_block_data>
  8028e6:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	8b 40 04             	mov    0x4(%eax),%eax
  8028ef:	85 c0                	test   %eax,%eax
  8028f1:	75 68                	jne    80295b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028f3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8028f7:	75 17                	jne    802910 <alloc_block_FF+0x14d>
  8028f9:	83 ec 04             	sub    $0x4,%esp
  8028fc:	68 7c 4a 80 00       	push   $0x804a7c
  802901:	68 d7 00 00 00       	push   $0xd7
  802906:	68 61 4a 80 00       	push   $0x804a61
  80290b:	e8 3b de ff ff       	call   80074b <_panic>
  802910:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802916:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802919:	89 10                	mov    %edx,(%eax)
  80291b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80291e:	8b 00                	mov    (%eax),%eax
  802920:	85 c0                	test   %eax,%eax
  802922:	74 0d                	je     802931 <alloc_block_FF+0x16e>
  802924:	a1 30 50 80 00       	mov    0x805030,%eax
  802929:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80292c:	89 50 04             	mov    %edx,0x4(%eax)
  80292f:	eb 08                	jmp    802939 <alloc_block_FF+0x176>
  802931:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802934:	a3 34 50 80 00       	mov    %eax,0x805034
  802939:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80293c:	a3 30 50 80 00       	mov    %eax,0x805030
  802941:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802944:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802950:	40                   	inc    %eax
  802951:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802956:	e9 dc 00 00 00       	jmp    802a37 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	85 c0                	test   %eax,%eax
  802962:	75 65                	jne    8029c9 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802964:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802968:	75 17                	jne    802981 <alloc_block_FF+0x1be>
  80296a:	83 ec 04             	sub    $0x4,%esp
  80296d:	68 b0 4a 80 00       	push   $0x804ab0
  802972:	68 db 00 00 00       	push   $0xdb
  802977:	68 61 4a 80 00       	push   $0x804a61
  80297c:	e8 ca dd ff ff       	call   80074b <_panic>
  802981:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802987:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80298a:	89 50 04             	mov    %edx,0x4(%eax)
  80298d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802990:	8b 40 04             	mov    0x4(%eax),%eax
  802993:	85 c0                	test   %eax,%eax
  802995:	74 0c                	je     8029a3 <alloc_block_FF+0x1e0>
  802997:	a1 34 50 80 00       	mov    0x805034,%eax
  80299c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80299f:	89 10                	mov    %edx,(%eax)
  8029a1:	eb 08                	jmp    8029ab <alloc_block_FF+0x1e8>
  8029a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029a6:	a3 30 50 80 00       	mov    %eax,0x805030
  8029ab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029ae:	a3 34 50 80 00       	mov    %eax,0x805034
  8029b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029bc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8029c1:	40                   	inc    %eax
  8029c2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8029c7:	eb 6e                	jmp    802a37 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8029c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cd:	74 06                	je     8029d5 <alloc_block_FF+0x212>
  8029cf:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029d3:	75 17                	jne    8029ec <alloc_block_FF+0x229>
  8029d5:	83 ec 04             	sub    $0x4,%esp
  8029d8:	68 d4 4a 80 00       	push   $0x804ad4
  8029dd:	68 df 00 00 00       	push   $0xdf
  8029e2:	68 61 4a 80 00       	push   $0x804a61
  8029e7:	e8 5f dd ff ff       	call   80074b <_panic>
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 10                	mov    (%eax),%edx
  8029f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f4:	89 10                	mov    %edx,(%eax)
  8029f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	85 c0                	test   %eax,%eax
  8029fd:	74 0b                	je     802a0a <alloc_block_FF+0x247>
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 00                	mov    (%eax),%eax
  802a04:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a07:	89 50 04             	mov    %edx,0x4(%eax)
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a10:	89 10                	mov    %edx,(%eax)
  802a12:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a18:	89 50 04             	mov    %edx,0x4(%eax)
  802a1b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a1e:	8b 00                	mov    (%eax),%eax
  802a20:	85 c0                	test   %eax,%eax
  802a22:	75 08                	jne    802a2c <alloc_block_FF+0x269>
  802a24:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a27:	a3 34 50 80 00       	mov    %eax,0x805034
  802a2c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a31:	40                   	inc    %eax
  802a32:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802a37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3b:	75 17                	jne    802a54 <alloc_block_FF+0x291>
  802a3d:	83 ec 04             	sub    $0x4,%esp
  802a40:	68 43 4a 80 00       	push   $0x804a43
  802a45:	68 e1 00 00 00       	push   $0xe1
  802a4a:	68 61 4a 80 00       	push   $0x804a61
  802a4f:	e8 f7 dc ff ff       	call   80074b <_panic>
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 00                	mov    (%eax),%eax
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	74 10                	je     802a6d <alloc_block_FF+0x2aa>
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	8b 00                	mov    (%eax),%eax
  802a62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a65:	8b 52 04             	mov    0x4(%edx),%edx
  802a68:	89 50 04             	mov    %edx,0x4(%eax)
  802a6b:	eb 0b                	jmp    802a78 <alloc_block_FF+0x2b5>
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 40 04             	mov    0x4(%eax),%eax
  802a73:	a3 34 50 80 00       	mov    %eax,0x805034
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 40 04             	mov    0x4(%eax),%eax
  802a7e:	85 c0                	test   %eax,%eax
  802a80:	74 0f                	je     802a91 <alloc_block_FF+0x2ce>
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 40 04             	mov    0x4(%eax),%eax
  802a88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8b:	8b 12                	mov    (%edx),%edx
  802a8d:	89 10                	mov    %edx,(%eax)
  802a8f:	eb 0a                	jmp    802a9b <alloc_block_FF+0x2d8>
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 00                	mov    (%eax),%eax
  802a96:	a3 30 50 80 00       	mov    %eax,0x805030
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aae:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ab3:	48                   	dec    %eax
  802ab4:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802ab9:	83 ec 04             	sub    $0x4,%esp
  802abc:	6a 00                	push   $0x0
  802abe:	ff 75 b4             	pushl  -0x4c(%ebp)
  802ac1:	ff 75 b0             	pushl  -0x50(%ebp)
  802ac4:	e8 cb fc ff ff       	call   802794 <set_block_data>
  802ac9:	83 c4 10             	add    $0x10,%esp
  802acc:	e9 95 00 00 00       	jmp    802b66 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802ad1:	83 ec 04             	sub    $0x4,%esp
  802ad4:	6a 01                	push   $0x1
  802ad6:	ff 75 b8             	pushl  -0x48(%ebp)
  802ad9:	ff 75 bc             	pushl  -0x44(%ebp)
  802adc:	e8 b3 fc ff ff       	call   802794 <set_block_data>
  802ae1:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802ae4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae8:	75 17                	jne    802b01 <alloc_block_FF+0x33e>
  802aea:	83 ec 04             	sub    $0x4,%esp
  802aed:	68 43 4a 80 00       	push   $0x804a43
  802af2:	68 e8 00 00 00       	push   $0xe8
  802af7:	68 61 4a 80 00       	push   $0x804a61
  802afc:	e8 4a dc ff ff       	call   80074b <_panic>
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 00                	mov    (%eax),%eax
  802b06:	85 c0                	test   %eax,%eax
  802b08:	74 10                	je     802b1a <alloc_block_FF+0x357>
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	8b 00                	mov    (%eax),%eax
  802b0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b12:	8b 52 04             	mov    0x4(%edx),%edx
  802b15:	89 50 04             	mov    %edx,0x4(%eax)
  802b18:	eb 0b                	jmp    802b25 <alloc_block_FF+0x362>
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 40 04             	mov    0x4(%eax),%eax
  802b20:	a3 34 50 80 00       	mov    %eax,0x805034
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 40 04             	mov    0x4(%eax),%eax
  802b2b:	85 c0                	test   %eax,%eax
  802b2d:	74 0f                	je     802b3e <alloc_block_FF+0x37b>
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	8b 40 04             	mov    0x4(%eax),%eax
  802b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b38:	8b 12                	mov    (%edx),%edx
  802b3a:	89 10                	mov    %edx,(%eax)
  802b3c:	eb 0a                	jmp    802b48 <alloc_block_FF+0x385>
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	a3 30 50 80 00       	mov    %eax,0x805030
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b60:	48                   	dec    %eax
  802b61:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802b66:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b69:	e9 0f 01 00 00       	jmp    802c7d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b6e:	a1 38 50 80 00       	mov    0x805038,%eax
  802b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7a:	74 07                	je     802b83 <alloc_block_FF+0x3c0>
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	eb 05                	jmp    802b88 <alloc_block_FF+0x3c5>
  802b83:	b8 00 00 00 00       	mov    $0x0,%eax
  802b88:	a3 38 50 80 00       	mov    %eax,0x805038
  802b8d:	a1 38 50 80 00       	mov    0x805038,%eax
  802b92:	85 c0                	test   %eax,%eax
  802b94:	0f 85 e9 fc ff ff    	jne    802883 <alloc_block_FF+0xc0>
  802b9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9e:	0f 85 df fc ff ff    	jne    802883 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba7:	83 c0 08             	add    $0x8,%eax
  802baa:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802bad:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802bb4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bb7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bba:	01 d0                	add    %edx,%eax
  802bbc:	48                   	dec    %eax
  802bbd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802bc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bc3:	ba 00 00 00 00       	mov    $0x0,%edx
  802bc8:	f7 75 d8             	divl   -0x28(%ebp)
  802bcb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bce:	29 d0                	sub    %edx,%eax
  802bd0:	c1 e8 0c             	shr    $0xc,%eax
  802bd3:	83 ec 0c             	sub    $0xc,%esp
  802bd6:	50                   	push   %eax
  802bd7:	e8 ce ed ff ff       	call   8019aa <sbrk>
  802bdc:	83 c4 10             	add    $0x10,%esp
  802bdf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802be2:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802be6:	75 0a                	jne    802bf2 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802be8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bed:	e9 8b 00 00 00       	jmp    802c7d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802bf2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802bf9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bfc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bff:	01 d0                	add    %edx,%eax
  802c01:	48                   	dec    %eax
  802c02:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802c05:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c08:	ba 00 00 00 00       	mov    $0x0,%edx
  802c0d:	f7 75 cc             	divl   -0x34(%ebp)
  802c10:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c13:	29 d0                	sub    %edx,%eax
  802c15:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c18:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c1b:	01 d0                	add    %edx,%eax
  802c1d:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802c22:	a1 44 50 80 00       	mov    0x805044,%eax
  802c27:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c2d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c34:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c37:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c3a:	01 d0                	add    %edx,%eax
  802c3c:	48                   	dec    %eax
  802c3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c40:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c43:	ba 00 00 00 00       	mov    $0x0,%edx
  802c48:	f7 75 c4             	divl   -0x3c(%ebp)
  802c4b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c4e:	29 d0                	sub    %edx,%eax
  802c50:	83 ec 04             	sub    $0x4,%esp
  802c53:	6a 01                	push   $0x1
  802c55:	50                   	push   %eax
  802c56:	ff 75 d0             	pushl  -0x30(%ebp)
  802c59:	e8 36 fb ff ff       	call   802794 <set_block_data>
  802c5e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802c61:	83 ec 0c             	sub    $0xc,%esp
  802c64:	ff 75 d0             	pushl  -0x30(%ebp)
  802c67:	e8 1b 0a 00 00       	call   803687 <free_block>
  802c6c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802c6f:	83 ec 0c             	sub    $0xc,%esp
  802c72:	ff 75 08             	pushl  0x8(%ebp)
  802c75:	e8 49 fb ff ff       	call   8027c3 <alloc_block_FF>
  802c7a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802c7d:	c9                   	leave  
  802c7e:	c3                   	ret    

00802c7f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802c7f:	55                   	push   %ebp
  802c80:	89 e5                	mov    %esp,%ebp
  802c82:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802c85:	8b 45 08             	mov    0x8(%ebp),%eax
  802c88:	83 e0 01             	and    $0x1,%eax
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	74 03                	je     802c92 <alloc_block_BF+0x13>
  802c8f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802c92:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802c96:	77 07                	ja     802c9f <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802c98:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802c9f:	a1 28 50 80 00       	mov    0x805028,%eax
  802ca4:	85 c0                	test   %eax,%eax
  802ca6:	75 73                	jne    802d1b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	83 c0 10             	add    $0x10,%eax
  802cae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802cb1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802cb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cbe:	01 d0                	add    %edx,%eax
  802cc0:	48                   	dec    %eax
  802cc1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802cc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cc7:	ba 00 00 00 00       	mov    $0x0,%edx
  802ccc:	f7 75 e0             	divl   -0x20(%ebp)
  802ccf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cd2:	29 d0                	sub    %edx,%eax
  802cd4:	c1 e8 0c             	shr    $0xc,%eax
  802cd7:	83 ec 0c             	sub    $0xc,%esp
  802cda:	50                   	push   %eax
  802cdb:	e8 ca ec ff ff       	call   8019aa <sbrk>
  802ce0:	83 c4 10             	add    $0x10,%esp
  802ce3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802ce6:	83 ec 0c             	sub    $0xc,%esp
  802ce9:	6a 00                	push   $0x0
  802ceb:	e8 ba ec ff ff       	call   8019aa <sbrk>
  802cf0:	83 c4 10             	add    $0x10,%esp
  802cf3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802cf6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cf9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802cfc:	83 ec 08             	sub    $0x8,%esp
  802cff:	50                   	push   %eax
  802d00:	ff 75 d8             	pushl  -0x28(%ebp)
  802d03:	e8 9f f8 ff ff       	call   8025a7 <initialize_dynamic_allocator>
  802d08:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802d0b:	83 ec 0c             	sub    $0xc,%esp
  802d0e:	68 9f 4a 80 00       	push   $0x804a9f
  802d13:	e8 f0 dc ff ff       	call   800a08 <cprintf>
  802d18:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802d1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802d22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802d29:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802d30:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802d37:	a1 30 50 80 00       	mov    0x805030,%eax
  802d3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d3f:	e9 1d 01 00 00       	jmp    802e61 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802d4a:	83 ec 0c             	sub    $0xc,%esp
  802d4d:	ff 75 a8             	pushl  -0x58(%ebp)
  802d50:	e8 ee f6 ff ff       	call   802443 <get_block_size>
  802d55:	83 c4 10             	add    $0x10,%esp
  802d58:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	83 c0 08             	add    $0x8,%eax
  802d61:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d64:	0f 87 ef 00 00 00    	ja     802e59 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	83 c0 18             	add    $0x18,%eax
  802d70:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d73:	77 1d                	ja     802d92 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802d75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d78:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d7b:	0f 86 d8 00 00 00    	jbe    802e59 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802d81:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802d87:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802d8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d8d:	e9 c7 00 00 00       	jmp    802e59 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	83 c0 08             	add    $0x8,%eax
  802d98:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d9b:	0f 85 9d 00 00 00    	jne    802e3e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802da1:	83 ec 04             	sub    $0x4,%esp
  802da4:	6a 01                	push   $0x1
  802da6:	ff 75 a4             	pushl  -0x5c(%ebp)
  802da9:	ff 75 a8             	pushl  -0x58(%ebp)
  802dac:	e8 e3 f9 ff ff       	call   802794 <set_block_data>
  802db1:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802db4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db8:	75 17                	jne    802dd1 <alloc_block_BF+0x152>
  802dba:	83 ec 04             	sub    $0x4,%esp
  802dbd:	68 43 4a 80 00       	push   $0x804a43
  802dc2:	68 2c 01 00 00       	push   $0x12c
  802dc7:	68 61 4a 80 00       	push   $0x804a61
  802dcc:	e8 7a d9 ff ff       	call   80074b <_panic>
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	8b 00                	mov    (%eax),%eax
  802dd6:	85 c0                	test   %eax,%eax
  802dd8:	74 10                	je     802dea <alloc_block_BF+0x16b>
  802dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddd:	8b 00                	mov    (%eax),%eax
  802ddf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de2:	8b 52 04             	mov    0x4(%edx),%edx
  802de5:	89 50 04             	mov    %edx,0x4(%eax)
  802de8:	eb 0b                	jmp    802df5 <alloc_block_BF+0x176>
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 40 04             	mov    0x4(%eax),%eax
  802df0:	a3 34 50 80 00       	mov    %eax,0x805034
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	8b 40 04             	mov    0x4(%eax),%eax
  802dfb:	85 c0                	test   %eax,%eax
  802dfd:	74 0f                	je     802e0e <alloc_block_BF+0x18f>
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 40 04             	mov    0x4(%eax),%eax
  802e05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e08:	8b 12                	mov    (%edx),%edx
  802e0a:	89 10                	mov    %edx,(%eax)
  802e0c:	eb 0a                	jmp    802e18 <alloc_block_BF+0x199>
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	8b 00                	mov    (%eax),%eax
  802e13:	a3 30 50 80 00       	mov    %eax,0x805030
  802e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e30:	48                   	dec    %eax
  802e31:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802e36:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e39:	e9 24 04 00 00       	jmp    803262 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e41:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e44:	76 13                	jbe    802e59 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802e46:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802e4d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802e53:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e56:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802e59:	a1 38 50 80 00       	mov    0x805038,%eax
  802e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e65:	74 07                	je     802e6e <alloc_block_BF+0x1ef>
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	8b 00                	mov    (%eax),%eax
  802e6c:	eb 05                	jmp    802e73 <alloc_block_BF+0x1f4>
  802e6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e73:	a3 38 50 80 00       	mov    %eax,0x805038
  802e78:	a1 38 50 80 00       	mov    0x805038,%eax
  802e7d:	85 c0                	test   %eax,%eax
  802e7f:	0f 85 bf fe ff ff    	jne    802d44 <alloc_block_BF+0xc5>
  802e85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e89:	0f 85 b5 fe ff ff    	jne    802d44 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802e8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e93:	0f 84 26 02 00 00    	je     8030bf <alloc_block_BF+0x440>
  802e99:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e9d:	0f 85 1c 02 00 00    	jne    8030bf <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802ea3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea6:	2b 45 08             	sub    0x8(%ebp),%eax
  802ea9:	83 e8 08             	sub    $0x8,%eax
  802eac:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb2:	8d 50 08             	lea    0x8(%eax),%edx
  802eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb8:	01 d0                	add    %edx,%eax
  802eba:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	83 c0 08             	add    $0x8,%eax
  802ec3:	83 ec 04             	sub    $0x4,%esp
  802ec6:	6a 01                	push   $0x1
  802ec8:	50                   	push   %eax
  802ec9:	ff 75 f0             	pushl  -0x10(%ebp)
  802ecc:	e8 c3 f8 ff ff       	call   802794 <set_block_data>
  802ed1:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed7:	8b 40 04             	mov    0x4(%eax),%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	75 68                	jne    802f46 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ede:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ee2:	75 17                	jne    802efb <alloc_block_BF+0x27c>
  802ee4:	83 ec 04             	sub    $0x4,%esp
  802ee7:	68 7c 4a 80 00       	push   $0x804a7c
  802eec:	68 45 01 00 00       	push   $0x145
  802ef1:	68 61 4a 80 00       	push   $0x804a61
  802ef6:	e8 50 d8 ff ff       	call   80074b <_panic>
  802efb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f01:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f04:	89 10                	mov    %edx,(%eax)
  802f06:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	85 c0                	test   %eax,%eax
  802f0d:	74 0d                	je     802f1c <alloc_block_BF+0x29d>
  802f0f:	a1 30 50 80 00       	mov    0x805030,%eax
  802f14:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f17:	89 50 04             	mov    %edx,0x4(%eax)
  802f1a:	eb 08                	jmp    802f24 <alloc_block_BF+0x2a5>
  802f1c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f1f:	a3 34 50 80 00       	mov    %eax,0x805034
  802f24:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f27:	a3 30 50 80 00       	mov    %eax,0x805030
  802f2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f36:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f3b:	40                   	inc    %eax
  802f3c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802f41:	e9 dc 00 00 00       	jmp    803022 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f49:	8b 00                	mov    (%eax),%eax
  802f4b:	85 c0                	test   %eax,%eax
  802f4d:	75 65                	jne    802fb4 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f4f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f53:	75 17                	jne    802f6c <alloc_block_BF+0x2ed>
  802f55:	83 ec 04             	sub    $0x4,%esp
  802f58:	68 b0 4a 80 00       	push   $0x804ab0
  802f5d:	68 4a 01 00 00       	push   $0x14a
  802f62:	68 61 4a 80 00       	push   $0x804a61
  802f67:	e8 df d7 ff ff       	call   80074b <_panic>
  802f6c:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802f72:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f75:	89 50 04             	mov    %edx,0x4(%eax)
  802f78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f7b:	8b 40 04             	mov    0x4(%eax),%eax
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	74 0c                	je     802f8e <alloc_block_BF+0x30f>
  802f82:	a1 34 50 80 00       	mov    0x805034,%eax
  802f87:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f8a:	89 10                	mov    %edx,(%eax)
  802f8c:	eb 08                	jmp    802f96 <alloc_block_BF+0x317>
  802f8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f91:	a3 30 50 80 00       	mov    %eax,0x805030
  802f96:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f99:	a3 34 50 80 00       	mov    %eax,0x805034
  802f9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fa1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fac:	40                   	inc    %eax
  802fad:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802fb2:	eb 6e                	jmp    803022 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802fb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fb8:	74 06                	je     802fc0 <alloc_block_BF+0x341>
  802fba:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fbe:	75 17                	jne    802fd7 <alloc_block_BF+0x358>
  802fc0:	83 ec 04             	sub    $0x4,%esp
  802fc3:	68 d4 4a 80 00       	push   $0x804ad4
  802fc8:	68 4f 01 00 00       	push   $0x14f
  802fcd:	68 61 4a 80 00       	push   $0x804a61
  802fd2:	e8 74 d7 ff ff       	call   80074b <_panic>
  802fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fda:	8b 10                	mov    (%eax),%edx
  802fdc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fdf:	89 10                	mov    %edx,(%eax)
  802fe1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fe4:	8b 00                	mov    (%eax),%eax
  802fe6:	85 c0                	test   %eax,%eax
  802fe8:	74 0b                	je     802ff5 <alloc_block_BF+0x376>
  802fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ff2:	89 50 04             	mov    %edx,0x4(%eax)
  802ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ffb:	89 10                	mov    %edx,(%eax)
  802ffd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803000:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803003:	89 50 04             	mov    %edx,0x4(%eax)
  803006:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803009:	8b 00                	mov    (%eax),%eax
  80300b:	85 c0                	test   %eax,%eax
  80300d:	75 08                	jne    803017 <alloc_block_BF+0x398>
  80300f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803012:	a3 34 50 80 00       	mov    %eax,0x805034
  803017:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80301c:	40                   	inc    %eax
  80301d:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803022:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803026:	75 17                	jne    80303f <alloc_block_BF+0x3c0>
  803028:	83 ec 04             	sub    $0x4,%esp
  80302b:	68 43 4a 80 00       	push   $0x804a43
  803030:	68 51 01 00 00       	push   $0x151
  803035:	68 61 4a 80 00       	push   $0x804a61
  80303a:	e8 0c d7 ff ff       	call   80074b <_panic>
  80303f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803042:	8b 00                	mov    (%eax),%eax
  803044:	85 c0                	test   %eax,%eax
  803046:	74 10                	je     803058 <alloc_block_BF+0x3d9>
  803048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803050:	8b 52 04             	mov    0x4(%edx),%edx
  803053:	89 50 04             	mov    %edx,0x4(%eax)
  803056:	eb 0b                	jmp    803063 <alloc_block_BF+0x3e4>
  803058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305b:	8b 40 04             	mov    0x4(%eax),%eax
  80305e:	a3 34 50 80 00       	mov    %eax,0x805034
  803063:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803066:	8b 40 04             	mov    0x4(%eax),%eax
  803069:	85 c0                	test   %eax,%eax
  80306b:	74 0f                	je     80307c <alloc_block_BF+0x3fd>
  80306d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803070:	8b 40 04             	mov    0x4(%eax),%eax
  803073:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803076:	8b 12                	mov    (%edx),%edx
  803078:	89 10                	mov    %edx,(%eax)
  80307a:	eb 0a                	jmp    803086 <alloc_block_BF+0x407>
  80307c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307f:	8b 00                	mov    (%eax),%eax
  803081:	a3 30 50 80 00       	mov    %eax,0x805030
  803086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803089:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80308f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803092:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803099:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80309e:	48                   	dec    %eax
  80309f:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  8030a4:	83 ec 04             	sub    $0x4,%esp
  8030a7:	6a 00                	push   $0x0
  8030a9:	ff 75 d0             	pushl  -0x30(%ebp)
  8030ac:	ff 75 cc             	pushl  -0x34(%ebp)
  8030af:	e8 e0 f6 ff ff       	call   802794 <set_block_data>
  8030b4:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8030b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ba:	e9 a3 01 00 00       	jmp    803262 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8030bf:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8030c3:	0f 85 9d 00 00 00    	jne    803166 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8030c9:	83 ec 04             	sub    $0x4,%esp
  8030cc:	6a 01                	push   $0x1
  8030ce:	ff 75 ec             	pushl  -0x14(%ebp)
  8030d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8030d4:	e8 bb f6 ff ff       	call   802794 <set_block_data>
  8030d9:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8030dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030e0:	75 17                	jne    8030f9 <alloc_block_BF+0x47a>
  8030e2:	83 ec 04             	sub    $0x4,%esp
  8030e5:	68 43 4a 80 00       	push   $0x804a43
  8030ea:	68 58 01 00 00       	push   $0x158
  8030ef:	68 61 4a 80 00       	push   $0x804a61
  8030f4:	e8 52 d6 ff ff       	call   80074b <_panic>
  8030f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fc:	8b 00                	mov    (%eax),%eax
  8030fe:	85 c0                	test   %eax,%eax
  803100:	74 10                	je     803112 <alloc_block_BF+0x493>
  803102:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803105:	8b 00                	mov    (%eax),%eax
  803107:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80310a:	8b 52 04             	mov    0x4(%edx),%edx
  80310d:	89 50 04             	mov    %edx,0x4(%eax)
  803110:	eb 0b                	jmp    80311d <alloc_block_BF+0x49e>
  803112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803115:	8b 40 04             	mov    0x4(%eax),%eax
  803118:	a3 34 50 80 00       	mov    %eax,0x805034
  80311d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803120:	8b 40 04             	mov    0x4(%eax),%eax
  803123:	85 c0                	test   %eax,%eax
  803125:	74 0f                	je     803136 <alloc_block_BF+0x4b7>
  803127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312a:	8b 40 04             	mov    0x4(%eax),%eax
  80312d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803130:	8b 12                	mov    (%edx),%edx
  803132:	89 10                	mov    %edx,(%eax)
  803134:	eb 0a                	jmp    803140 <alloc_block_BF+0x4c1>
  803136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803139:	8b 00                	mov    (%eax),%eax
  80313b:	a3 30 50 80 00       	mov    %eax,0x805030
  803140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803143:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803153:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803158:	48                   	dec    %eax
  803159:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  80315e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803161:	e9 fc 00 00 00       	jmp    803262 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803166:	8b 45 08             	mov    0x8(%ebp),%eax
  803169:	83 c0 08             	add    $0x8,%eax
  80316c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80316f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803176:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803179:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80317c:	01 d0                	add    %edx,%eax
  80317e:	48                   	dec    %eax
  80317f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803182:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803185:	ba 00 00 00 00       	mov    $0x0,%edx
  80318a:	f7 75 c4             	divl   -0x3c(%ebp)
  80318d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803190:	29 d0                	sub    %edx,%eax
  803192:	c1 e8 0c             	shr    $0xc,%eax
  803195:	83 ec 0c             	sub    $0xc,%esp
  803198:	50                   	push   %eax
  803199:	e8 0c e8 ff ff       	call   8019aa <sbrk>
  80319e:	83 c4 10             	add    $0x10,%esp
  8031a1:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8031a4:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8031a8:	75 0a                	jne    8031b4 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8031aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8031af:	e9 ae 00 00 00       	jmp    803262 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8031b4:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8031bb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031be:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8031c1:	01 d0                	add    %edx,%eax
  8031c3:	48                   	dec    %eax
  8031c4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8031c7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8031ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8031cf:	f7 75 b8             	divl   -0x48(%ebp)
  8031d2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8031d5:	29 d0                	sub    %edx,%eax
  8031d7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8031da:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8031dd:	01 d0                	add    %edx,%eax
  8031df:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  8031e4:	a1 44 50 80 00       	mov    0x805044,%eax
  8031e9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8031ef:	83 ec 0c             	sub    $0xc,%esp
  8031f2:	68 08 4b 80 00       	push   $0x804b08
  8031f7:	e8 0c d8 ff ff       	call   800a08 <cprintf>
  8031fc:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8031ff:	83 ec 08             	sub    $0x8,%esp
  803202:	ff 75 bc             	pushl  -0x44(%ebp)
  803205:	68 0d 4b 80 00       	push   $0x804b0d
  80320a:	e8 f9 d7 ff ff       	call   800a08 <cprintf>
  80320f:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803212:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803219:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80321c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80321f:	01 d0                	add    %edx,%eax
  803221:	48                   	dec    %eax
  803222:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803225:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803228:	ba 00 00 00 00       	mov    $0x0,%edx
  80322d:	f7 75 b0             	divl   -0x50(%ebp)
  803230:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803233:	29 d0                	sub    %edx,%eax
  803235:	83 ec 04             	sub    $0x4,%esp
  803238:	6a 01                	push   $0x1
  80323a:	50                   	push   %eax
  80323b:	ff 75 bc             	pushl  -0x44(%ebp)
  80323e:	e8 51 f5 ff ff       	call   802794 <set_block_data>
  803243:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803246:	83 ec 0c             	sub    $0xc,%esp
  803249:	ff 75 bc             	pushl  -0x44(%ebp)
  80324c:	e8 36 04 00 00       	call   803687 <free_block>
  803251:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803254:	83 ec 0c             	sub    $0xc,%esp
  803257:	ff 75 08             	pushl  0x8(%ebp)
  80325a:	e8 20 fa ff ff       	call   802c7f <alloc_block_BF>
  80325f:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803262:	c9                   	leave  
  803263:	c3                   	ret    

00803264 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803264:	55                   	push   %ebp
  803265:	89 e5                	mov    %esp,%ebp
  803267:	53                   	push   %ebx
  803268:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80326b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803272:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803279:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80327d:	74 1e                	je     80329d <merging+0x39>
  80327f:	ff 75 08             	pushl  0x8(%ebp)
  803282:	e8 bc f1 ff ff       	call   802443 <get_block_size>
  803287:	83 c4 04             	add    $0x4,%esp
  80328a:	89 c2                	mov    %eax,%edx
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	01 d0                	add    %edx,%eax
  803291:	3b 45 10             	cmp    0x10(%ebp),%eax
  803294:	75 07                	jne    80329d <merging+0x39>
		prev_is_free = 1;
  803296:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80329d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032a1:	74 1e                	je     8032c1 <merging+0x5d>
  8032a3:	ff 75 10             	pushl  0x10(%ebp)
  8032a6:	e8 98 f1 ff ff       	call   802443 <get_block_size>
  8032ab:	83 c4 04             	add    $0x4,%esp
  8032ae:	89 c2                	mov    %eax,%edx
  8032b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8032b3:	01 d0                	add    %edx,%eax
  8032b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032b8:	75 07                	jne    8032c1 <merging+0x5d>
		next_is_free = 1;
  8032ba:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8032c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c5:	0f 84 cc 00 00 00    	je     803397 <merging+0x133>
  8032cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032cf:	0f 84 c2 00 00 00    	je     803397 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8032d5:	ff 75 08             	pushl  0x8(%ebp)
  8032d8:	e8 66 f1 ff ff       	call   802443 <get_block_size>
  8032dd:	83 c4 04             	add    $0x4,%esp
  8032e0:	89 c3                	mov    %eax,%ebx
  8032e2:	ff 75 10             	pushl  0x10(%ebp)
  8032e5:	e8 59 f1 ff ff       	call   802443 <get_block_size>
  8032ea:	83 c4 04             	add    $0x4,%esp
  8032ed:	01 c3                	add    %eax,%ebx
  8032ef:	ff 75 0c             	pushl  0xc(%ebp)
  8032f2:	e8 4c f1 ff ff       	call   802443 <get_block_size>
  8032f7:	83 c4 04             	add    $0x4,%esp
  8032fa:	01 d8                	add    %ebx,%eax
  8032fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8032ff:	6a 00                	push   $0x0
  803301:	ff 75 ec             	pushl  -0x14(%ebp)
  803304:	ff 75 08             	pushl  0x8(%ebp)
  803307:	e8 88 f4 ff ff       	call   802794 <set_block_data>
  80330c:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80330f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803313:	75 17                	jne    80332c <merging+0xc8>
  803315:	83 ec 04             	sub    $0x4,%esp
  803318:	68 43 4a 80 00       	push   $0x804a43
  80331d:	68 7d 01 00 00       	push   $0x17d
  803322:	68 61 4a 80 00       	push   $0x804a61
  803327:	e8 1f d4 ff ff       	call   80074b <_panic>
  80332c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80332f:	8b 00                	mov    (%eax),%eax
  803331:	85 c0                	test   %eax,%eax
  803333:	74 10                	je     803345 <merging+0xe1>
  803335:	8b 45 0c             	mov    0xc(%ebp),%eax
  803338:	8b 00                	mov    (%eax),%eax
  80333a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80333d:	8b 52 04             	mov    0x4(%edx),%edx
  803340:	89 50 04             	mov    %edx,0x4(%eax)
  803343:	eb 0b                	jmp    803350 <merging+0xec>
  803345:	8b 45 0c             	mov    0xc(%ebp),%eax
  803348:	8b 40 04             	mov    0x4(%eax),%eax
  80334b:	a3 34 50 80 00       	mov    %eax,0x805034
  803350:	8b 45 0c             	mov    0xc(%ebp),%eax
  803353:	8b 40 04             	mov    0x4(%eax),%eax
  803356:	85 c0                	test   %eax,%eax
  803358:	74 0f                	je     803369 <merging+0x105>
  80335a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80335d:	8b 40 04             	mov    0x4(%eax),%eax
  803360:	8b 55 0c             	mov    0xc(%ebp),%edx
  803363:	8b 12                	mov    (%edx),%edx
  803365:	89 10                	mov    %edx,(%eax)
  803367:	eb 0a                	jmp    803373 <merging+0x10f>
  803369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	a3 30 50 80 00       	mov    %eax,0x805030
  803373:	8b 45 0c             	mov    0xc(%ebp),%eax
  803376:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80337c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80337f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803386:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80338b:	48                   	dec    %eax
  80338c:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803391:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803392:	e9 ea 02 00 00       	jmp    803681 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803397:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80339b:	74 3b                	je     8033d8 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80339d:	83 ec 0c             	sub    $0xc,%esp
  8033a0:	ff 75 08             	pushl  0x8(%ebp)
  8033a3:	e8 9b f0 ff ff       	call   802443 <get_block_size>
  8033a8:	83 c4 10             	add    $0x10,%esp
  8033ab:	89 c3                	mov    %eax,%ebx
  8033ad:	83 ec 0c             	sub    $0xc,%esp
  8033b0:	ff 75 10             	pushl  0x10(%ebp)
  8033b3:	e8 8b f0 ff ff       	call   802443 <get_block_size>
  8033b8:	83 c4 10             	add    $0x10,%esp
  8033bb:	01 d8                	add    %ebx,%eax
  8033bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8033c0:	83 ec 04             	sub    $0x4,%esp
  8033c3:	6a 00                	push   $0x0
  8033c5:	ff 75 e8             	pushl  -0x18(%ebp)
  8033c8:	ff 75 08             	pushl  0x8(%ebp)
  8033cb:	e8 c4 f3 ff ff       	call   802794 <set_block_data>
  8033d0:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8033d3:	e9 a9 02 00 00       	jmp    803681 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8033d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033dc:	0f 84 2d 01 00 00    	je     80350f <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8033e2:	83 ec 0c             	sub    $0xc,%esp
  8033e5:	ff 75 10             	pushl  0x10(%ebp)
  8033e8:	e8 56 f0 ff ff       	call   802443 <get_block_size>
  8033ed:	83 c4 10             	add    $0x10,%esp
  8033f0:	89 c3                	mov    %eax,%ebx
  8033f2:	83 ec 0c             	sub    $0xc,%esp
  8033f5:	ff 75 0c             	pushl  0xc(%ebp)
  8033f8:	e8 46 f0 ff ff       	call   802443 <get_block_size>
  8033fd:	83 c4 10             	add    $0x10,%esp
  803400:	01 d8                	add    %ebx,%eax
  803402:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803405:	83 ec 04             	sub    $0x4,%esp
  803408:	6a 00                	push   $0x0
  80340a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80340d:	ff 75 10             	pushl  0x10(%ebp)
  803410:	e8 7f f3 ff ff       	call   802794 <set_block_data>
  803415:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803418:	8b 45 10             	mov    0x10(%ebp),%eax
  80341b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80341e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803422:	74 06                	je     80342a <merging+0x1c6>
  803424:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803428:	75 17                	jne    803441 <merging+0x1dd>
  80342a:	83 ec 04             	sub    $0x4,%esp
  80342d:	68 1c 4b 80 00       	push   $0x804b1c
  803432:	68 8d 01 00 00       	push   $0x18d
  803437:	68 61 4a 80 00       	push   $0x804a61
  80343c:	e8 0a d3 ff ff       	call   80074b <_panic>
  803441:	8b 45 0c             	mov    0xc(%ebp),%eax
  803444:	8b 50 04             	mov    0x4(%eax),%edx
  803447:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80344a:	89 50 04             	mov    %edx,0x4(%eax)
  80344d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803450:	8b 55 0c             	mov    0xc(%ebp),%edx
  803453:	89 10                	mov    %edx,(%eax)
  803455:	8b 45 0c             	mov    0xc(%ebp),%eax
  803458:	8b 40 04             	mov    0x4(%eax),%eax
  80345b:	85 c0                	test   %eax,%eax
  80345d:	74 0d                	je     80346c <merging+0x208>
  80345f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803462:	8b 40 04             	mov    0x4(%eax),%eax
  803465:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803468:	89 10                	mov    %edx,(%eax)
  80346a:	eb 08                	jmp    803474 <merging+0x210>
  80346c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80346f:	a3 30 50 80 00       	mov    %eax,0x805030
  803474:	8b 45 0c             	mov    0xc(%ebp),%eax
  803477:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80347a:	89 50 04             	mov    %edx,0x4(%eax)
  80347d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803482:	40                   	inc    %eax
  803483:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  803488:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80348c:	75 17                	jne    8034a5 <merging+0x241>
  80348e:	83 ec 04             	sub    $0x4,%esp
  803491:	68 43 4a 80 00       	push   $0x804a43
  803496:	68 8e 01 00 00       	push   $0x18e
  80349b:	68 61 4a 80 00       	push   $0x804a61
  8034a0:	e8 a6 d2 ff ff       	call   80074b <_panic>
  8034a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a8:	8b 00                	mov    (%eax),%eax
  8034aa:	85 c0                	test   %eax,%eax
  8034ac:	74 10                	je     8034be <merging+0x25a>
  8034ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b1:	8b 00                	mov    (%eax),%eax
  8034b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034b6:	8b 52 04             	mov    0x4(%edx),%edx
  8034b9:	89 50 04             	mov    %edx,0x4(%eax)
  8034bc:	eb 0b                	jmp    8034c9 <merging+0x265>
  8034be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c1:	8b 40 04             	mov    0x4(%eax),%eax
  8034c4:	a3 34 50 80 00       	mov    %eax,0x805034
  8034c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034cc:	8b 40 04             	mov    0x4(%eax),%eax
  8034cf:	85 c0                	test   %eax,%eax
  8034d1:	74 0f                	je     8034e2 <merging+0x27e>
  8034d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d6:	8b 40 04             	mov    0x4(%eax),%eax
  8034d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034dc:	8b 12                	mov    (%edx),%edx
  8034de:	89 10                	mov    %edx,(%eax)
  8034e0:	eb 0a                	jmp    8034ec <merging+0x288>
  8034e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e5:	8b 00                	mov    (%eax),%eax
  8034e7:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ff:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803504:	48                   	dec    %eax
  803505:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80350a:	e9 72 01 00 00       	jmp    803681 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80350f:	8b 45 10             	mov    0x10(%ebp),%eax
  803512:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803515:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803519:	74 79                	je     803594 <merging+0x330>
  80351b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80351f:	74 73                	je     803594 <merging+0x330>
  803521:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803525:	74 06                	je     80352d <merging+0x2c9>
  803527:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80352b:	75 17                	jne    803544 <merging+0x2e0>
  80352d:	83 ec 04             	sub    $0x4,%esp
  803530:	68 d4 4a 80 00       	push   $0x804ad4
  803535:	68 94 01 00 00       	push   $0x194
  80353a:	68 61 4a 80 00       	push   $0x804a61
  80353f:	e8 07 d2 ff ff       	call   80074b <_panic>
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	8b 10                	mov    (%eax),%edx
  803549:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80354c:	89 10                	mov    %edx,(%eax)
  80354e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803551:	8b 00                	mov    (%eax),%eax
  803553:	85 c0                	test   %eax,%eax
  803555:	74 0b                	je     803562 <merging+0x2fe>
  803557:	8b 45 08             	mov    0x8(%ebp),%eax
  80355a:	8b 00                	mov    (%eax),%eax
  80355c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80355f:	89 50 04             	mov    %edx,0x4(%eax)
  803562:	8b 45 08             	mov    0x8(%ebp),%eax
  803565:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803568:	89 10                	mov    %edx,(%eax)
  80356a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80356d:	8b 55 08             	mov    0x8(%ebp),%edx
  803570:	89 50 04             	mov    %edx,0x4(%eax)
  803573:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803576:	8b 00                	mov    (%eax),%eax
  803578:	85 c0                	test   %eax,%eax
  80357a:	75 08                	jne    803584 <merging+0x320>
  80357c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80357f:	a3 34 50 80 00       	mov    %eax,0x805034
  803584:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803589:	40                   	inc    %eax
  80358a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80358f:	e9 ce 00 00 00       	jmp    803662 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803594:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803598:	74 65                	je     8035ff <merging+0x39b>
  80359a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80359e:	75 17                	jne    8035b7 <merging+0x353>
  8035a0:	83 ec 04             	sub    $0x4,%esp
  8035a3:	68 b0 4a 80 00       	push   $0x804ab0
  8035a8:	68 95 01 00 00       	push   $0x195
  8035ad:	68 61 4a 80 00       	push   $0x804a61
  8035b2:	e8 94 d1 ff ff       	call   80074b <_panic>
  8035b7:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8035bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035c0:	89 50 04             	mov    %edx,0x4(%eax)
  8035c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035c6:	8b 40 04             	mov    0x4(%eax),%eax
  8035c9:	85 c0                	test   %eax,%eax
  8035cb:	74 0c                	je     8035d9 <merging+0x375>
  8035cd:	a1 34 50 80 00       	mov    0x805034,%eax
  8035d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035d5:	89 10                	mov    %edx,(%eax)
  8035d7:	eb 08                	jmp    8035e1 <merging+0x37d>
  8035d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035dc:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035e4:	a3 34 50 80 00       	mov    %eax,0x805034
  8035e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035f2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035f7:	40                   	inc    %eax
  8035f8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035fd:	eb 63                	jmp    803662 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8035ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803603:	75 17                	jne    80361c <merging+0x3b8>
  803605:	83 ec 04             	sub    $0x4,%esp
  803608:	68 7c 4a 80 00       	push   $0x804a7c
  80360d:	68 98 01 00 00       	push   $0x198
  803612:	68 61 4a 80 00       	push   $0x804a61
  803617:	e8 2f d1 ff ff       	call   80074b <_panic>
  80361c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803622:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803625:	89 10                	mov    %edx,(%eax)
  803627:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80362a:	8b 00                	mov    (%eax),%eax
  80362c:	85 c0                	test   %eax,%eax
  80362e:	74 0d                	je     80363d <merging+0x3d9>
  803630:	a1 30 50 80 00       	mov    0x805030,%eax
  803635:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803638:	89 50 04             	mov    %edx,0x4(%eax)
  80363b:	eb 08                	jmp    803645 <merging+0x3e1>
  80363d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803640:	a3 34 50 80 00       	mov    %eax,0x805034
  803645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803648:	a3 30 50 80 00       	mov    %eax,0x805030
  80364d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803650:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803657:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80365c:	40                   	inc    %eax
  80365d:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803662:	83 ec 0c             	sub    $0xc,%esp
  803665:	ff 75 10             	pushl  0x10(%ebp)
  803668:	e8 d6 ed ff ff       	call   802443 <get_block_size>
  80366d:	83 c4 10             	add    $0x10,%esp
  803670:	83 ec 04             	sub    $0x4,%esp
  803673:	6a 00                	push   $0x0
  803675:	50                   	push   %eax
  803676:	ff 75 10             	pushl  0x10(%ebp)
  803679:	e8 16 f1 ff ff       	call   802794 <set_block_data>
  80367e:	83 c4 10             	add    $0x10,%esp
	}
}
  803681:	90                   	nop
  803682:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803685:	c9                   	leave  
  803686:	c3                   	ret    

00803687 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803687:	55                   	push   %ebp
  803688:	89 e5                	mov    %esp,%ebp
  80368a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80368d:	a1 30 50 80 00       	mov    0x805030,%eax
  803692:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803695:	a1 34 50 80 00       	mov    0x805034,%eax
  80369a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80369d:	73 1b                	jae    8036ba <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80369f:	a1 34 50 80 00       	mov    0x805034,%eax
  8036a4:	83 ec 04             	sub    $0x4,%esp
  8036a7:	ff 75 08             	pushl  0x8(%ebp)
  8036aa:	6a 00                	push   $0x0
  8036ac:	50                   	push   %eax
  8036ad:	e8 b2 fb ff ff       	call   803264 <merging>
  8036b2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8036b5:	e9 8b 00 00 00       	jmp    803745 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8036ba:	a1 30 50 80 00       	mov    0x805030,%eax
  8036bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036c2:	76 18                	jbe    8036dc <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8036c4:	a1 30 50 80 00       	mov    0x805030,%eax
  8036c9:	83 ec 04             	sub    $0x4,%esp
  8036cc:	ff 75 08             	pushl  0x8(%ebp)
  8036cf:	50                   	push   %eax
  8036d0:	6a 00                	push   $0x0
  8036d2:	e8 8d fb ff ff       	call   803264 <merging>
  8036d7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8036da:	eb 69                	jmp    803745 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8036dc:	a1 30 50 80 00       	mov    0x805030,%eax
  8036e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036e4:	eb 39                	jmp    80371f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036ec:	73 29                	jae    803717 <free_block+0x90>
  8036ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f1:	8b 00                	mov    (%eax),%eax
  8036f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036f6:	76 1f                	jbe    803717 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8036f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fb:	8b 00                	mov    (%eax),%eax
  8036fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803700:	83 ec 04             	sub    $0x4,%esp
  803703:	ff 75 08             	pushl  0x8(%ebp)
  803706:	ff 75 f0             	pushl  -0x10(%ebp)
  803709:	ff 75 f4             	pushl  -0xc(%ebp)
  80370c:	e8 53 fb ff ff       	call   803264 <merging>
  803711:	83 c4 10             	add    $0x10,%esp
			break;
  803714:	90                   	nop
		}
	}
}
  803715:	eb 2e                	jmp    803745 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803717:	a1 38 50 80 00       	mov    0x805038,%eax
  80371c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80371f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803723:	74 07                	je     80372c <free_block+0xa5>
  803725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803728:	8b 00                	mov    (%eax),%eax
  80372a:	eb 05                	jmp    803731 <free_block+0xaa>
  80372c:	b8 00 00 00 00       	mov    $0x0,%eax
  803731:	a3 38 50 80 00       	mov    %eax,0x805038
  803736:	a1 38 50 80 00       	mov    0x805038,%eax
  80373b:	85 c0                	test   %eax,%eax
  80373d:	75 a7                	jne    8036e6 <free_block+0x5f>
  80373f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803743:	75 a1                	jne    8036e6 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803745:	90                   	nop
  803746:	c9                   	leave  
  803747:	c3                   	ret    

00803748 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803748:	55                   	push   %ebp
  803749:	89 e5                	mov    %esp,%ebp
  80374b:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80374e:	ff 75 08             	pushl  0x8(%ebp)
  803751:	e8 ed ec ff ff       	call   802443 <get_block_size>
  803756:	83 c4 04             	add    $0x4,%esp
  803759:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80375c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803763:	eb 17                	jmp    80377c <copy_data+0x34>
  803765:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803768:	8b 45 0c             	mov    0xc(%ebp),%eax
  80376b:	01 c2                	add    %eax,%edx
  80376d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803770:	8b 45 08             	mov    0x8(%ebp),%eax
  803773:	01 c8                	add    %ecx,%eax
  803775:	8a 00                	mov    (%eax),%al
  803777:	88 02                	mov    %al,(%edx)
  803779:	ff 45 fc             	incl   -0x4(%ebp)
  80377c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80377f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803782:	72 e1                	jb     803765 <copy_data+0x1d>
}
  803784:	90                   	nop
  803785:	c9                   	leave  
  803786:	c3                   	ret    

00803787 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803787:	55                   	push   %ebp
  803788:	89 e5                	mov    %esp,%ebp
  80378a:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80378d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803791:	75 23                	jne    8037b6 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803793:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803797:	74 13                	je     8037ac <realloc_block_FF+0x25>
  803799:	83 ec 0c             	sub    $0xc,%esp
  80379c:	ff 75 0c             	pushl  0xc(%ebp)
  80379f:	e8 1f f0 ff ff       	call   8027c3 <alloc_block_FF>
  8037a4:	83 c4 10             	add    $0x10,%esp
  8037a7:	e9 f4 06 00 00       	jmp    803ea0 <realloc_block_FF+0x719>
		return NULL;
  8037ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b1:	e9 ea 06 00 00       	jmp    803ea0 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8037b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037ba:	75 18                	jne    8037d4 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8037bc:	83 ec 0c             	sub    $0xc,%esp
  8037bf:	ff 75 08             	pushl  0x8(%ebp)
  8037c2:	e8 c0 fe ff ff       	call   803687 <free_block>
  8037c7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8037ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8037cf:	e9 cc 06 00 00       	jmp    803ea0 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8037d4:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8037d8:	77 07                	ja     8037e1 <realloc_block_FF+0x5a>
  8037da:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8037e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e4:	83 e0 01             	and    $0x1,%eax
  8037e7:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8037ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ed:	83 c0 08             	add    $0x8,%eax
  8037f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8037f3:	83 ec 0c             	sub    $0xc,%esp
  8037f6:	ff 75 08             	pushl  0x8(%ebp)
  8037f9:	e8 45 ec ff ff       	call   802443 <get_block_size>
  8037fe:	83 c4 10             	add    $0x10,%esp
  803801:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803804:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803807:	83 e8 08             	sub    $0x8,%eax
  80380a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80380d:	8b 45 08             	mov    0x8(%ebp),%eax
  803810:	83 e8 04             	sub    $0x4,%eax
  803813:	8b 00                	mov    (%eax),%eax
  803815:	83 e0 fe             	and    $0xfffffffe,%eax
  803818:	89 c2                	mov    %eax,%edx
  80381a:	8b 45 08             	mov    0x8(%ebp),%eax
  80381d:	01 d0                	add    %edx,%eax
  80381f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803822:	83 ec 0c             	sub    $0xc,%esp
  803825:	ff 75 e4             	pushl  -0x1c(%ebp)
  803828:	e8 16 ec ff ff       	call   802443 <get_block_size>
  80382d:	83 c4 10             	add    $0x10,%esp
  803830:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803833:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803836:	83 e8 08             	sub    $0x8,%eax
  803839:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80383c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80383f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803842:	75 08                	jne    80384c <realloc_block_FF+0xc5>
	{
		 return va;
  803844:	8b 45 08             	mov    0x8(%ebp),%eax
  803847:	e9 54 06 00 00       	jmp    803ea0 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80384c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80384f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803852:	0f 83 e5 03 00 00    	jae    803c3d <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80385e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803861:	83 ec 0c             	sub    $0xc,%esp
  803864:	ff 75 e4             	pushl  -0x1c(%ebp)
  803867:	e8 f0 eb ff ff       	call   80245c <is_free_block>
  80386c:	83 c4 10             	add    $0x10,%esp
  80386f:	84 c0                	test   %al,%al
  803871:	0f 84 3b 01 00 00    	je     8039b2 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803877:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80387a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80387d:	01 d0                	add    %edx,%eax
  80387f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803882:	83 ec 04             	sub    $0x4,%esp
  803885:	6a 01                	push   $0x1
  803887:	ff 75 f0             	pushl  -0x10(%ebp)
  80388a:	ff 75 08             	pushl  0x8(%ebp)
  80388d:	e8 02 ef ff ff       	call   802794 <set_block_data>
  803892:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803895:	8b 45 08             	mov    0x8(%ebp),%eax
  803898:	83 e8 04             	sub    $0x4,%eax
  80389b:	8b 00                	mov    (%eax),%eax
  80389d:	83 e0 fe             	and    $0xfffffffe,%eax
  8038a0:	89 c2                	mov    %eax,%edx
  8038a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a5:	01 d0                	add    %edx,%eax
  8038a7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8038aa:	83 ec 04             	sub    $0x4,%esp
  8038ad:	6a 00                	push   $0x0
  8038af:	ff 75 cc             	pushl  -0x34(%ebp)
  8038b2:	ff 75 c8             	pushl  -0x38(%ebp)
  8038b5:	e8 da ee ff ff       	call   802794 <set_block_data>
  8038ba:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038c1:	74 06                	je     8038c9 <realloc_block_FF+0x142>
  8038c3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8038c7:	75 17                	jne    8038e0 <realloc_block_FF+0x159>
  8038c9:	83 ec 04             	sub    $0x4,%esp
  8038cc:	68 d4 4a 80 00       	push   $0x804ad4
  8038d1:	68 f6 01 00 00       	push   $0x1f6
  8038d6:	68 61 4a 80 00       	push   $0x804a61
  8038db:	e8 6b ce ff ff       	call   80074b <_panic>
  8038e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e3:	8b 10                	mov    (%eax),%edx
  8038e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038e8:	89 10                	mov    %edx,(%eax)
  8038ea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038ed:	8b 00                	mov    (%eax),%eax
  8038ef:	85 c0                	test   %eax,%eax
  8038f1:	74 0b                	je     8038fe <realloc_block_FF+0x177>
  8038f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f6:	8b 00                	mov    (%eax),%eax
  8038f8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8038fb:	89 50 04             	mov    %edx,0x4(%eax)
  8038fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803901:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803904:	89 10                	mov    %edx,(%eax)
  803906:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803909:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80390c:	89 50 04             	mov    %edx,0x4(%eax)
  80390f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803912:	8b 00                	mov    (%eax),%eax
  803914:	85 c0                	test   %eax,%eax
  803916:	75 08                	jne    803920 <realloc_block_FF+0x199>
  803918:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80391b:	a3 34 50 80 00       	mov    %eax,0x805034
  803920:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803925:	40                   	inc    %eax
  803926:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80392b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80392f:	75 17                	jne    803948 <realloc_block_FF+0x1c1>
  803931:	83 ec 04             	sub    $0x4,%esp
  803934:	68 43 4a 80 00       	push   $0x804a43
  803939:	68 f7 01 00 00       	push   $0x1f7
  80393e:	68 61 4a 80 00       	push   $0x804a61
  803943:	e8 03 ce ff ff       	call   80074b <_panic>
  803948:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394b:	8b 00                	mov    (%eax),%eax
  80394d:	85 c0                	test   %eax,%eax
  80394f:	74 10                	je     803961 <realloc_block_FF+0x1da>
  803951:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803954:	8b 00                	mov    (%eax),%eax
  803956:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803959:	8b 52 04             	mov    0x4(%edx),%edx
  80395c:	89 50 04             	mov    %edx,0x4(%eax)
  80395f:	eb 0b                	jmp    80396c <realloc_block_FF+0x1e5>
  803961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803964:	8b 40 04             	mov    0x4(%eax),%eax
  803967:	a3 34 50 80 00       	mov    %eax,0x805034
  80396c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396f:	8b 40 04             	mov    0x4(%eax),%eax
  803972:	85 c0                	test   %eax,%eax
  803974:	74 0f                	je     803985 <realloc_block_FF+0x1fe>
  803976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803979:	8b 40 04             	mov    0x4(%eax),%eax
  80397c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80397f:	8b 12                	mov    (%edx),%edx
  803981:	89 10                	mov    %edx,(%eax)
  803983:	eb 0a                	jmp    80398f <realloc_block_FF+0x208>
  803985:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803988:	8b 00                	mov    (%eax),%eax
  80398a:	a3 30 50 80 00       	mov    %eax,0x805030
  80398f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803992:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803998:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039a7:	48                   	dec    %eax
  8039a8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8039ad:	e9 83 02 00 00       	jmp    803c35 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8039b2:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8039b6:	0f 86 69 02 00 00    	jbe    803c25 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8039bc:	83 ec 04             	sub    $0x4,%esp
  8039bf:	6a 01                	push   $0x1
  8039c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8039c4:	ff 75 08             	pushl  0x8(%ebp)
  8039c7:	e8 c8 ed ff ff       	call   802794 <set_block_data>
  8039cc:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d2:	83 e8 04             	sub    $0x4,%eax
  8039d5:	8b 00                	mov    (%eax),%eax
  8039d7:	83 e0 fe             	and    $0xfffffffe,%eax
  8039da:	89 c2                	mov    %eax,%edx
  8039dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039df:	01 d0                	add    %edx,%eax
  8039e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8039e4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8039ec:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8039f0:	75 68                	jne    803a5a <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8039f2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039f6:	75 17                	jne    803a0f <realloc_block_FF+0x288>
  8039f8:	83 ec 04             	sub    $0x4,%esp
  8039fb:	68 7c 4a 80 00       	push   $0x804a7c
  803a00:	68 06 02 00 00       	push   $0x206
  803a05:	68 61 4a 80 00       	push   $0x804a61
  803a0a:	e8 3c cd ff ff       	call   80074b <_panic>
  803a0f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a18:	89 10                	mov    %edx,(%eax)
  803a1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a1d:	8b 00                	mov    (%eax),%eax
  803a1f:	85 c0                	test   %eax,%eax
  803a21:	74 0d                	je     803a30 <realloc_block_FF+0x2a9>
  803a23:	a1 30 50 80 00       	mov    0x805030,%eax
  803a28:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a2b:	89 50 04             	mov    %edx,0x4(%eax)
  803a2e:	eb 08                	jmp    803a38 <realloc_block_FF+0x2b1>
  803a30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a33:	a3 34 50 80 00       	mov    %eax,0x805034
  803a38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a3b:	a3 30 50 80 00       	mov    %eax,0x805030
  803a40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a4a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a4f:	40                   	inc    %eax
  803a50:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a55:	e9 b0 01 00 00       	jmp    803c0a <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803a5a:	a1 30 50 80 00       	mov    0x805030,%eax
  803a5f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a62:	76 68                	jbe    803acc <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a64:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a68:	75 17                	jne    803a81 <realloc_block_FF+0x2fa>
  803a6a:	83 ec 04             	sub    $0x4,%esp
  803a6d:	68 7c 4a 80 00       	push   $0x804a7c
  803a72:	68 0b 02 00 00       	push   $0x20b
  803a77:	68 61 4a 80 00       	push   $0x804a61
  803a7c:	e8 ca cc ff ff       	call   80074b <_panic>
  803a81:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a8a:	89 10                	mov    %edx,(%eax)
  803a8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a8f:	8b 00                	mov    (%eax),%eax
  803a91:	85 c0                	test   %eax,%eax
  803a93:	74 0d                	je     803aa2 <realloc_block_FF+0x31b>
  803a95:	a1 30 50 80 00       	mov    0x805030,%eax
  803a9a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a9d:	89 50 04             	mov    %edx,0x4(%eax)
  803aa0:	eb 08                	jmp    803aaa <realloc_block_FF+0x323>
  803aa2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aa5:	a3 34 50 80 00       	mov    %eax,0x805034
  803aaa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aad:	a3 30 50 80 00       	mov    %eax,0x805030
  803ab2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803abc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ac1:	40                   	inc    %eax
  803ac2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803ac7:	e9 3e 01 00 00       	jmp    803c0a <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803acc:	a1 30 50 80 00       	mov    0x805030,%eax
  803ad1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ad4:	73 68                	jae    803b3e <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ad6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ada:	75 17                	jne    803af3 <realloc_block_FF+0x36c>
  803adc:	83 ec 04             	sub    $0x4,%esp
  803adf:	68 b0 4a 80 00       	push   $0x804ab0
  803ae4:	68 10 02 00 00       	push   $0x210
  803ae9:	68 61 4a 80 00       	push   $0x804a61
  803aee:	e8 58 cc ff ff       	call   80074b <_panic>
  803af3:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803af9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803afc:	89 50 04             	mov    %edx,0x4(%eax)
  803aff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b02:	8b 40 04             	mov    0x4(%eax),%eax
  803b05:	85 c0                	test   %eax,%eax
  803b07:	74 0c                	je     803b15 <realloc_block_FF+0x38e>
  803b09:	a1 34 50 80 00       	mov    0x805034,%eax
  803b0e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b11:	89 10                	mov    %edx,(%eax)
  803b13:	eb 08                	jmp    803b1d <realloc_block_FF+0x396>
  803b15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b18:	a3 30 50 80 00       	mov    %eax,0x805030
  803b1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b20:	a3 34 50 80 00       	mov    %eax,0x805034
  803b25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b2e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b33:	40                   	inc    %eax
  803b34:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b39:	e9 cc 00 00 00       	jmp    803c0a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803b3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803b45:	a1 30 50 80 00       	mov    0x805030,%eax
  803b4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b4d:	e9 8a 00 00 00       	jmp    803bdc <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b55:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b58:	73 7a                	jae    803bd4 <realloc_block_FF+0x44d>
  803b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5d:	8b 00                	mov    (%eax),%eax
  803b5f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b62:	73 70                	jae    803bd4 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803b64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b68:	74 06                	je     803b70 <realloc_block_FF+0x3e9>
  803b6a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b6e:	75 17                	jne    803b87 <realloc_block_FF+0x400>
  803b70:	83 ec 04             	sub    $0x4,%esp
  803b73:	68 d4 4a 80 00       	push   $0x804ad4
  803b78:	68 1a 02 00 00       	push   $0x21a
  803b7d:	68 61 4a 80 00       	push   $0x804a61
  803b82:	e8 c4 cb ff ff       	call   80074b <_panic>
  803b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b8a:	8b 10                	mov    (%eax),%edx
  803b8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b8f:	89 10                	mov    %edx,(%eax)
  803b91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b94:	8b 00                	mov    (%eax),%eax
  803b96:	85 c0                	test   %eax,%eax
  803b98:	74 0b                	je     803ba5 <realloc_block_FF+0x41e>
  803b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9d:	8b 00                	mov    (%eax),%eax
  803b9f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ba2:	89 50 04             	mov    %edx,0x4(%eax)
  803ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bab:	89 10                	mov    %edx,(%eax)
  803bad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bb3:	89 50 04             	mov    %edx,0x4(%eax)
  803bb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bb9:	8b 00                	mov    (%eax),%eax
  803bbb:	85 c0                	test   %eax,%eax
  803bbd:	75 08                	jne    803bc7 <realloc_block_FF+0x440>
  803bbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc2:	a3 34 50 80 00       	mov    %eax,0x805034
  803bc7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bcc:	40                   	inc    %eax
  803bcd:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803bd2:	eb 36                	jmp    803c0a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803bd4:	a1 38 50 80 00       	mov    0x805038,%eax
  803bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803be0:	74 07                	je     803be9 <realloc_block_FF+0x462>
  803be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be5:	8b 00                	mov    (%eax),%eax
  803be7:	eb 05                	jmp    803bee <realloc_block_FF+0x467>
  803be9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bee:	a3 38 50 80 00       	mov    %eax,0x805038
  803bf3:	a1 38 50 80 00       	mov    0x805038,%eax
  803bf8:	85 c0                	test   %eax,%eax
  803bfa:	0f 85 52 ff ff ff    	jne    803b52 <realloc_block_FF+0x3cb>
  803c00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c04:	0f 85 48 ff ff ff    	jne    803b52 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803c0a:	83 ec 04             	sub    $0x4,%esp
  803c0d:	6a 00                	push   $0x0
  803c0f:	ff 75 d8             	pushl  -0x28(%ebp)
  803c12:	ff 75 d4             	pushl  -0x2c(%ebp)
  803c15:	e8 7a eb ff ff       	call   802794 <set_block_data>
  803c1a:	83 c4 10             	add    $0x10,%esp
				return va;
  803c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c20:	e9 7b 02 00 00       	jmp    803ea0 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803c25:	83 ec 0c             	sub    $0xc,%esp
  803c28:	68 51 4b 80 00       	push   $0x804b51
  803c2d:	e8 d6 cd ff ff       	call   800a08 <cprintf>
  803c32:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803c35:	8b 45 08             	mov    0x8(%ebp),%eax
  803c38:	e9 63 02 00 00       	jmp    803ea0 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c40:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c43:	0f 86 4d 02 00 00    	jbe    803e96 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803c49:	83 ec 0c             	sub    $0xc,%esp
  803c4c:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c4f:	e8 08 e8 ff ff       	call   80245c <is_free_block>
  803c54:	83 c4 10             	add    $0x10,%esp
  803c57:	84 c0                	test   %al,%al
  803c59:	0f 84 37 02 00 00    	je     803e96 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c62:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803c65:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803c68:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c6b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803c6e:	76 38                	jbe    803ca8 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803c70:	83 ec 0c             	sub    $0xc,%esp
  803c73:	ff 75 08             	pushl  0x8(%ebp)
  803c76:	e8 0c fa ff ff       	call   803687 <free_block>
  803c7b:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803c7e:	83 ec 0c             	sub    $0xc,%esp
  803c81:	ff 75 0c             	pushl  0xc(%ebp)
  803c84:	e8 3a eb ff ff       	call   8027c3 <alloc_block_FF>
  803c89:	83 c4 10             	add    $0x10,%esp
  803c8c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803c8f:	83 ec 08             	sub    $0x8,%esp
  803c92:	ff 75 c0             	pushl  -0x40(%ebp)
  803c95:	ff 75 08             	pushl  0x8(%ebp)
  803c98:	e8 ab fa ff ff       	call   803748 <copy_data>
  803c9d:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803ca0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803ca3:	e9 f8 01 00 00       	jmp    803ea0 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cab:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803cae:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803cb1:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803cb5:	0f 87 a0 00 00 00    	ja     803d5b <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803cbb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cbf:	75 17                	jne    803cd8 <realloc_block_FF+0x551>
  803cc1:	83 ec 04             	sub    $0x4,%esp
  803cc4:	68 43 4a 80 00       	push   $0x804a43
  803cc9:	68 38 02 00 00       	push   $0x238
  803cce:	68 61 4a 80 00       	push   $0x804a61
  803cd3:	e8 73 ca ff ff       	call   80074b <_panic>
  803cd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cdb:	8b 00                	mov    (%eax),%eax
  803cdd:	85 c0                	test   %eax,%eax
  803cdf:	74 10                	je     803cf1 <realloc_block_FF+0x56a>
  803ce1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ce4:	8b 00                	mov    (%eax),%eax
  803ce6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ce9:	8b 52 04             	mov    0x4(%edx),%edx
  803cec:	89 50 04             	mov    %edx,0x4(%eax)
  803cef:	eb 0b                	jmp    803cfc <realloc_block_FF+0x575>
  803cf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cf4:	8b 40 04             	mov    0x4(%eax),%eax
  803cf7:	a3 34 50 80 00       	mov    %eax,0x805034
  803cfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cff:	8b 40 04             	mov    0x4(%eax),%eax
  803d02:	85 c0                	test   %eax,%eax
  803d04:	74 0f                	je     803d15 <realloc_block_FF+0x58e>
  803d06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d09:	8b 40 04             	mov    0x4(%eax),%eax
  803d0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d0f:	8b 12                	mov    (%edx),%edx
  803d11:	89 10                	mov    %edx,(%eax)
  803d13:	eb 0a                	jmp    803d1f <realloc_block_FF+0x598>
  803d15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d18:	8b 00                	mov    (%eax),%eax
  803d1a:	a3 30 50 80 00       	mov    %eax,0x805030
  803d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d32:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d37:	48                   	dec    %eax
  803d38:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803d3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d43:	01 d0                	add    %edx,%eax
  803d45:	83 ec 04             	sub    $0x4,%esp
  803d48:	6a 01                	push   $0x1
  803d4a:	50                   	push   %eax
  803d4b:	ff 75 08             	pushl  0x8(%ebp)
  803d4e:	e8 41 ea ff ff       	call   802794 <set_block_data>
  803d53:	83 c4 10             	add    $0x10,%esp
  803d56:	e9 36 01 00 00       	jmp    803e91 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803d5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d5e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d61:	01 d0                	add    %edx,%eax
  803d63:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803d66:	83 ec 04             	sub    $0x4,%esp
  803d69:	6a 01                	push   $0x1
  803d6b:	ff 75 f0             	pushl  -0x10(%ebp)
  803d6e:	ff 75 08             	pushl  0x8(%ebp)
  803d71:	e8 1e ea ff ff       	call   802794 <set_block_data>
  803d76:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803d79:	8b 45 08             	mov    0x8(%ebp),%eax
  803d7c:	83 e8 04             	sub    $0x4,%eax
  803d7f:	8b 00                	mov    (%eax),%eax
  803d81:	83 e0 fe             	and    $0xfffffffe,%eax
  803d84:	89 c2                	mov    %eax,%edx
  803d86:	8b 45 08             	mov    0x8(%ebp),%eax
  803d89:	01 d0                	add    %edx,%eax
  803d8b:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803d8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d92:	74 06                	je     803d9a <realloc_block_FF+0x613>
  803d94:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803d98:	75 17                	jne    803db1 <realloc_block_FF+0x62a>
  803d9a:	83 ec 04             	sub    $0x4,%esp
  803d9d:	68 d4 4a 80 00       	push   $0x804ad4
  803da2:	68 44 02 00 00       	push   $0x244
  803da7:	68 61 4a 80 00       	push   $0x804a61
  803dac:	e8 9a c9 ff ff       	call   80074b <_panic>
  803db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db4:	8b 10                	mov    (%eax),%edx
  803db6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803db9:	89 10                	mov    %edx,(%eax)
  803dbb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803dbe:	8b 00                	mov    (%eax),%eax
  803dc0:	85 c0                	test   %eax,%eax
  803dc2:	74 0b                	je     803dcf <realloc_block_FF+0x648>
  803dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc7:	8b 00                	mov    (%eax),%eax
  803dc9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803dcc:	89 50 04             	mov    %edx,0x4(%eax)
  803dcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803dd5:	89 10                	mov    %edx,(%eax)
  803dd7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803dda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ddd:	89 50 04             	mov    %edx,0x4(%eax)
  803de0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803de3:	8b 00                	mov    (%eax),%eax
  803de5:	85 c0                	test   %eax,%eax
  803de7:	75 08                	jne    803df1 <realloc_block_FF+0x66a>
  803de9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803dec:	a3 34 50 80 00       	mov    %eax,0x805034
  803df1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803df6:	40                   	inc    %eax
  803df7:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803dfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e00:	75 17                	jne    803e19 <realloc_block_FF+0x692>
  803e02:	83 ec 04             	sub    $0x4,%esp
  803e05:	68 43 4a 80 00       	push   $0x804a43
  803e0a:	68 45 02 00 00       	push   $0x245
  803e0f:	68 61 4a 80 00       	push   $0x804a61
  803e14:	e8 32 c9 ff ff       	call   80074b <_panic>
  803e19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e1c:	8b 00                	mov    (%eax),%eax
  803e1e:	85 c0                	test   %eax,%eax
  803e20:	74 10                	je     803e32 <realloc_block_FF+0x6ab>
  803e22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e25:	8b 00                	mov    (%eax),%eax
  803e27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e2a:	8b 52 04             	mov    0x4(%edx),%edx
  803e2d:	89 50 04             	mov    %edx,0x4(%eax)
  803e30:	eb 0b                	jmp    803e3d <realloc_block_FF+0x6b6>
  803e32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e35:	8b 40 04             	mov    0x4(%eax),%eax
  803e38:	a3 34 50 80 00       	mov    %eax,0x805034
  803e3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e40:	8b 40 04             	mov    0x4(%eax),%eax
  803e43:	85 c0                	test   %eax,%eax
  803e45:	74 0f                	je     803e56 <realloc_block_FF+0x6cf>
  803e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e4a:	8b 40 04             	mov    0x4(%eax),%eax
  803e4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e50:	8b 12                	mov    (%edx),%edx
  803e52:	89 10                	mov    %edx,(%eax)
  803e54:	eb 0a                	jmp    803e60 <realloc_block_FF+0x6d9>
  803e56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e59:	8b 00                	mov    (%eax),%eax
  803e5b:	a3 30 50 80 00       	mov    %eax,0x805030
  803e60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e73:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e78:	48                   	dec    %eax
  803e79:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803e7e:	83 ec 04             	sub    $0x4,%esp
  803e81:	6a 00                	push   $0x0
  803e83:	ff 75 bc             	pushl  -0x44(%ebp)
  803e86:	ff 75 b8             	pushl  -0x48(%ebp)
  803e89:	e8 06 e9 ff ff       	call   802794 <set_block_data>
  803e8e:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803e91:	8b 45 08             	mov    0x8(%ebp),%eax
  803e94:	eb 0a                	jmp    803ea0 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803e96:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803e9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803ea0:	c9                   	leave  
  803ea1:	c3                   	ret    

00803ea2 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803ea2:	55                   	push   %ebp
  803ea3:	89 e5                	mov    %esp,%ebp
  803ea5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803ea8:	83 ec 04             	sub    $0x4,%esp
  803eab:	68 58 4b 80 00       	push   $0x804b58
  803eb0:	68 58 02 00 00       	push   $0x258
  803eb5:	68 61 4a 80 00       	push   $0x804a61
  803eba:	e8 8c c8 ff ff       	call   80074b <_panic>

00803ebf <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803ebf:	55                   	push   %ebp
  803ec0:	89 e5                	mov    %esp,%ebp
  803ec2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803ec5:	83 ec 04             	sub    $0x4,%esp
  803ec8:	68 80 4b 80 00       	push   $0x804b80
  803ecd:	68 61 02 00 00       	push   $0x261
  803ed2:	68 61 4a 80 00       	push   $0x804a61
  803ed7:	e8 6f c8 ff ff       	call   80074b <_panic>

00803edc <__udivdi3>:
  803edc:	55                   	push   %ebp
  803edd:	57                   	push   %edi
  803ede:	56                   	push   %esi
  803edf:	53                   	push   %ebx
  803ee0:	83 ec 1c             	sub    $0x1c,%esp
  803ee3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ee7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803eeb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803eef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ef3:	89 ca                	mov    %ecx,%edx
  803ef5:	89 f8                	mov    %edi,%eax
  803ef7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803efb:	85 f6                	test   %esi,%esi
  803efd:	75 2d                	jne    803f2c <__udivdi3+0x50>
  803eff:	39 cf                	cmp    %ecx,%edi
  803f01:	77 65                	ja     803f68 <__udivdi3+0x8c>
  803f03:	89 fd                	mov    %edi,%ebp
  803f05:	85 ff                	test   %edi,%edi
  803f07:	75 0b                	jne    803f14 <__udivdi3+0x38>
  803f09:	b8 01 00 00 00       	mov    $0x1,%eax
  803f0e:	31 d2                	xor    %edx,%edx
  803f10:	f7 f7                	div    %edi
  803f12:	89 c5                	mov    %eax,%ebp
  803f14:	31 d2                	xor    %edx,%edx
  803f16:	89 c8                	mov    %ecx,%eax
  803f18:	f7 f5                	div    %ebp
  803f1a:	89 c1                	mov    %eax,%ecx
  803f1c:	89 d8                	mov    %ebx,%eax
  803f1e:	f7 f5                	div    %ebp
  803f20:	89 cf                	mov    %ecx,%edi
  803f22:	89 fa                	mov    %edi,%edx
  803f24:	83 c4 1c             	add    $0x1c,%esp
  803f27:	5b                   	pop    %ebx
  803f28:	5e                   	pop    %esi
  803f29:	5f                   	pop    %edi
  803f2a:	5d                   	pop    %ebp
  803f2b:	c3                   	ret    
  803f2c:	39 ce                	cmp    %ecx,%esi
  803f2e:	77 28                	ja     803f58 <__udivdi3+0x7c>
  803f30:	0f bd fe             	bsr    %esi,%edi
  803f33:	83 f7 1f             	xor    $0x1f,%edi
  803f36:	75 40                	jne    803f78 <__udivdi3+0x9c>
  803f38:	39 ce                	cmp    %ecx,%esi
  803f3a:	72 0a                	jb     803f46 <__udivdi3+0x6a>
  803f3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f40:	0f 87 9e 00 00 00    	ja     803fe4 <__udivdi3+0x108>
  803f46:	b8 01 00 00 00       	mov    $0x1,%eax
  803f4b:	89 fa                	mov    %edi,%edx
  803f4d:	83 c4 1c             	add    $0x1c,%esp
  803f50:	5b                   	pop    %ebx
  803f51:	5e                   	pop    %esi
  803f52:	5f                   	pop    %edi
  803f53:	5d                   	pop    %ebp
  803f54:	c3                   	ret    
  803f55:	8d 76 00             	lea    0x0(%esi),%esi
  803f58:	31 ff                	xor    %edi,%edi
  803f5a:	31 c0                	xor    %eax,%eax
  803f5c:	89 fa                	mov    %edi,%edx
  803f5e:	83 c4 1c             	add    $0x1c,%esp
  803f61:	5b                   	pop    %ebx
  803f62:	5e                   	pop    %esi
  803f63:	5f                   	pop    %edi
  803f64:	5d                   	pop    %ebp
  803f65:	c3                   	ret    
  803f66:	66 90                	xchg   %ax,%ax
  803f68:	89 d8                	mov    %ebx,%eax
  803f6a:	f7 f7                	div    %edi
  803f6c:	31 ff                	xor    %edi,%edi
  803f6e:	89 fa                	mov    %edi,%edx
  803f70:	83 c4 1c             	add    $0x1c,%esp
  803f73:	5b                   	pop    %ebx
  803f74:	5e                   	pop    %esi
  803f75:	5f                   	pop    %edi
  803f76:	5d                   	pop    %ebp
  803f77:	c3                   	ret    
  803f78:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f7d:	89 eb                	mov    %ebp,%ebx
  803f7f:	29 fb                	sub    %edi,%ebx
  803f81:	89 f9                	mov    %edi,%ecx
  803f83:	d3 e6                	shl    %cl,%esi
  803f85:	89 c5                	mov    %eax,%ebp
  803f87:	88 d9                	mov    %bl,%cl
  803f89:	d3 ed                	shr    %cl,%ebp
  803f8b:	89 e9                	mov    %ebp,%ecx
  803f8d:	09 f1                	or     %esi,%ecx
  803f8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f93:	89 f9                	mov    %edi,%ecx
  803f95:	d3 e0                	shl    %cl,%eax
  803f97:	89 c5                	mov    %eax,%ebp
  803f99:	89 d6                	mov    %edx,%esi
  803f9b:	88 d9                	mov    %bl,%cl
  803f9d:	d3 ee                	shr    %cl,%esi
  803f9f:	89 f9                	mov    %edi,%ecx
  803fa1:	d3 e2                	shl    %cl,%edx
  803fa3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fa7:	88 d9                	mov    %bl,%cl
  803fa9:	d3 e8                	shr    %cl,%eax
  803fab:	09 c2                	or     %eax,%edx
  803fad:	89 d0                	mov    %edx,%eax
  803faf:	89 f2                	mov    %esi,%edx
  803fb1:	f7 74 24 0c          	divl   0xc(%esp)
  803fb5:	89 d6                	mov    %edx,%esi
  803fb7:	89 c3                	mov    %eax,%ebx
  803fb9:	f7 e5                	mul    %ebp
  803fbb:	39 d6                	cmp    %edx,%esi
  803fbd:	72 19                	jb     803fd8 <__udivdi3+0xfc>
  803fbf:	74 0b                	je     803fcc <__udivdi3+0xf0>
  803fc1:	89 d8                	mov    %ebx,%eax
  803fc3:	31 ff                	xor    %edi,%edi
  803fc5:	e9 58 ff ff ff       	jmp    803f22 <__udivdi3+0x46>
  803fca:	66 90                	xchg   %ax,%ax
  803fcc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803fd0:	89 f9                	mov    %edi,%ecx
  803fd2:	d3 e2                	shl    %cl,%edx
  803fd4:	39 c2                	cmp    %eax,%edx
  803fd6:	73 e9                	jae    803fc1 <__udivdi3+0xe5>
  803fd8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803fdb:	31 ff                	xor    %edi,%edi
  803fdd:	e9 40 ff ff ff       	jmp    803f22 <__udivdi3+0x46>
  803fe2:	66 90                	xchg   %ax,%ax
  803fe4:	31 c0                	xor    %eax,%eax
  803fe6:	e9 37 ff ff ff       	jmp    803f22 <__udivdi3+0x46>
  803feb:	90                   	nop

00803fec <__umoddi3>:
  803fec:	55                   	push   %ebp
  803fed:	57                   	push   %edi
  803fee:	56                   	push   %esi
  803fef:	53                   	push   %ebx
  803ff0:	83 ec 1c             	sub    $0x1c,%esp
  803ff3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ff7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ffb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804003:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804007:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80400b:	89 f3                	mov    %esi,%ebx
  80400d:	89 fa                	mov    %edi,%edx
  80400f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804013:	89 34 24             	mov    %esi,(%esp)
  804016:	85 c0                	test   %eax,%eax
  804018:	75 1a                	jne    804034 <__umoddi3+0x48>
  80401a:	39 f7                	cmp    %esi,%edi
  80401c:	0f 86 a2 00 00 00    	jbe    8040c4 <__umoddi3+0xd8>
  804022:	89 c8                	mov    %ecx,%eax
  804024:	89 f2                	mov    %esi,%edx
  804026:	f7 f7                	div    %edi
  804028:	89 d0                	mov    %edx,%eax
  80402a:	31 d2                	xor    %edx,%edx
  80402c:	83 c4 1c             	add    $0x1c,%esp
  80402f:	5b                   	pop    %ebx
  804030:	5e                   	pop    %esi
  804031:	5f                   	pop    %edi
  804032:	5d                   	pop    %ebp
  804033:	c3                   	ret    
  804034:	39 f0                	cmp    %esi,%eax
  804036:	0f 87 ac 00 00 00    	ja     8040e8 <__umoddi3+0xfc>
  80403c:	0f bd e8             	bsr    %eax,%ebp
  80403f:	83 f5 1f             	xor    $0x1f,%ebp
  804042:	0f 84 ac 00 00 00    	je     8040f4 <__umoddi3+0x108>
  804048:	bf 20 00 00 00       	mov    $0x20,%edi
  80404d:	29 ef                	sub    %ebp,%edi
  80404f:	89 fe                	mov    %edi,%esi
  804051:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804055:	89 e9                	mov    %ebp,%ecx
  804057:	d3 e0                	shl    %cl,%eax
  804059:	89 d7                	mov    %edx,%edi
  80405b:	89 f1                	mov    %esi,%ecx
  80405d:	d3 ef                	shr    %cl,%edi
  80405f:	09 c7                	or     %eax,%edi
  804061:	89 e9                	mov    %ebp,%ecx
  804063:	d3 e2                	shl    %cl,%edx
  804065:	89 14 24             	mov    %edx,(%esp)
  804068:	89 d8                	mov    %ebx,%eax
  80406a:	d3 e0                	shl    %cl,%eax
  80406c:	89 c2                	mov    %eax,%edx
  80406e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804072:	d3 e0                	shl    %cl,%eax
  804074:	89 44 24 04          	mov    %eax,0x4(%esp)
  804078:	8b 44 24 08          	mov    0x8(%esp),%eax
  80407c:	89 f1                	mov    %esi,%ecx
  80407e:	d3 e8                	shr    %cl,%eax
  804080:	09 d0                	or     %edx,%eax
  804082:	d3 eb                	shr    %cl,%ebx
  804084:	89 da                	mov    %ebx,%edx
  804086:	f7 f7                	div    %edi
  804088:	89 d3                	mov    %edx,%ebx
  80408a:	f7 24 24             	mull   (%esp)
  80408d:	89 c6                	mov    %eax,%esi
  80408f:	89 d1                	mov    %edx,%ecx
  804091:	39 d3                	cmp    %edx,%ebx
  804093:	0f 82 87 00 00 00    	jb     804120 <__umoddi3+0x134>
  804099:	0f 84 91 00 00 00    	je     804130 <__umoddi3+0x144>
  80409f:	8b 54 24 04          	mov    0x4(%esp),%edx
  8040a3:	29 f2                	sub    %esi,%edx
  8040a5:	19 cb                	sbb    %ecx,%ebx
  8040a7:	89 d8                	mov    %ebx,%eax
  8040a9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8040ad:	d3 e0                	shl    %cl,%eax
  8040af:	89 e9                	mov    %ebp,%ecx
  8040b1:	d3 ea                	shr    %cl,%edx
  8040b3:	09 d0                	or     %edx,%eax
  8040b5:	89 e9                	mov    %ebp,%ecx
  8040b7:	d3 eb                	shr    %cl,%ebx
  8040b9:	89 da                	mov    %ebx,%edx
  8040bb:	83 c4 1c             	add    $0x1c,%esp
  8040be:	5b                   	pop    %ebx
  8040bf:	5e                   	pop    %esi
  8040c0:	5f                   	pop    %edi
  8040c1:	5d                   	pop    %ebp
  8040c2:	c3                   	ret    
  8040c3:	90                   	nop
  8040c4:	89 fd                	mov    %edi,%ebp
  8040c6:	85 ff                	test   %edi,%edi
  8040c8:	75 0b                	jne    8040d5 <__umoddi3+0xe9>
  8040ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8040cf:	31 d2                	xor    %edx,%edx
  8040d1:	f7 f7                	div    %edi
  8040d3:	89 c5                	mov    %eax,%ebp
  8040d5:	89 f0                	mov    %esi,%eax
  8040d7:	31 d2                	xor    %edx,%edx
  8040d9:	f7 f5                	div    %ebp
  8040db:	89 c8                	mov    %ecx,%eax
  8040dd:	f7 f5                	div    %ebp
  8040df:	89 d0                	mov    %edx,%eax
  8040e1:	e9 44 ff ff ff       	jmp    80402a <__umoddi3+0x3e>
  8040e6:	66 90                	xchg   %ax,%ax
  8040e8:	89 c8                	mov    %ecx,%eax
  8040ea:	89 f2                	mov    %esi,%edx
  8040ec:	83 c4 1c             	add    $0x1c,%esp
  8040ef:	5b                   	pop    %ebx
  8040f0:	5e                   	pop    %esi
  8040f1:	5f                   	pop    %edi
  8040f2:	5d                   	pop    %ebp
  8040f3:	c3                   	ret    
  8040f4:	3b 04 24             	cmp    (%esp),%eax
  8040f7:	72 06                	jb     8040ff <__umoddi3+0x113>
  8040f9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8040fd:	77 0f                	ja     80410e <__umoddi3+0x122>
  8040ff:	89 f2                	mov    %esi,%edx
  804101:	29 f9                	sub    %edi,%ecx
  804103:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804107:	89 14 24             	mov    %edx,(%esp)
  80410a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80410e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804112:	8b 14 24             	mov    (%esp),%edx
  804115:	83 c4 1c             	add    $0x1c,%esp
  804118:	5b                   	pop    %ebx
  804119:	5e                   	pop    %esi
  80411a:	5f                   	pop    %edi
  80411b:	5d                   	pop    %ebp
  80411c:	c3                   	ret    
  80411d:	8d 76 00             	lea    0x0(%esi),%esi
  804120:	2b 04 24             	sub    (%esp),%eax
  804123:	19 fa                	sbb    %edi,%edx
  804125:	89 d1                	mov    %edx,%ecx
  804127:	89 c6                	mov    %eax,%esi
  804129:	e9 71 ff ff ff       	jmp    80409f <__umoddi3+0xb3>
  80412e:	66 90                	xchg   %ax,%ax
  804130:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804134:	72 ea                	jb     804120 <__umoddi3+0x134>
  804136:	89 d9                	mov    %ebx,%ecx
  804138:	e9 62 ff ff ff       	jmp    80409f <__umoddi3+0xb3>
