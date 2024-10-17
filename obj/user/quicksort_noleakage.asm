
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
  800041:	e8 09 1b 00 00       	call   801b4f <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 23 80 00       	push   $0x802380
  80004e:	e8 c3 09 00 00       	call   800a16 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 82 23 80 00       	push   $0x802382
  80005e:	e8 b3 09 00 00       	call   800a16 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 9b 23 80 00       	push   $0x80239b
  80006e:	e8 a3 09 00 00       	call   800a16 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 82 23 80 00       	push   $0x802382
  80007e:	e8 93 09 00 00       	call   800a16 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 23 80 00       	push   $0x802380
  80008e:	e8 83 09 00 00       	call   800a16 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 b4 23 80 00       	push   $0x8023b4
  8000a5:	e8 00 10 00 00       	call   8010aa <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 52 15 00 00       	call   801612 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 d4 23 80 00       	push   $0x8023d4
  8000ce:	e8 43 09 00 00       	call   800a16 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 f6 23 80 00       	push   $0x8023f6
  8000de:	e8 33 09 00 00       	call   800a16 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 04 24 80 00       	push   $0x802404
  8000ee:	e8 23 09 00 00       	call   800a16 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 13 24 80 00       	push   $0x802413
  8000fe:	e8 13 09 00 00       	call   800a16 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 23 24 80 00       	push   $0x802423
  80010e:	e8 03 09 00 00       	call   800a16 <cprintf>
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
  80014d:	e8 17 1a 00 00       	call   801b69 <sys_unlock_cons>
		//sys_unlock_cons();

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 6d 18 00 00       	call   8019ce <malloc>
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
  8001d5:	e8 75 19 00 00       	call   801b4f <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 2c 24 80 00       	push   $0x80242c
  8001e2:	e8 2f 08 00 00       	call   800a16 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 7a 19 00 00       	call   801b69 <sys_unlock_cons>
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
  80020c:	68 60 24 80 00       	push   $0x802460
  800211:	6a 54                	push   $0x54
  800213:	68 82 24 80 00       	push   $0x802482
  800218:	e8 3c 05 00 00       	call   800759 <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 2d 19 00 00       	call   801b4f <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 a0 24 80 00       	push   $0x8024a0
  80022a:	e8 e7 07 00 00       	call   800a16 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 d4 24 80 00       	push   $0x8024d4
  80023a:	e8 d7 07 00 00       	call   800a16 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 08 25 80 00       	push   $0x802508
  80024a:	e8 c7 07 00 00       	call   800a16 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 12 19 00 00       	call   801b69 <sys_unlock_cons>
			//			sys_unlock_cons();


		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 ec             	pushl  -0x14(%ebp)
  80025d:	e8 95 17 00 00       	call   8019f7 <free>
  800262:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
  800265:	e8 e5 18 00 00       	call   801b4f <sys_lock_cons>
		{
			Chose = 0 ;
  80026a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  80026e:	eb 42                	jmp    8002b2 <_main+0x27a>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 3a 25 80 00       	push   $0x80253a
  800278:	e8 99 07 00 00       	call   800a16 <cprintf>
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
  8002be:	e8 a6 18 00 00       	call   801b69 <sys_unlock_cons>
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
  800570:	68 80 23 80 00       	push   $0x802380
  800575:	e8 9c 04 00 00       	call   800a16 <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80057d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800580:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	01 d0                	add    %edx,%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	50                   	push   %eax
  800592:	68 58 25 80 00       	push   $0x802558
  800597:	e8 7a 04 00 00       	call   800a16 <cprintf>
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
  8005c0:	68 5d 25 80 00       	push   $0x80255d
  8005c5:	e8 4c 04 00 00       	call   800a16 <cprintf>
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
  8005e4:	e8 b1 16 00 00       	call   801c9a <sys_cputc>
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
  8005f5:	e8 3c 15 00 00       	call   801b36 <sys_cgetc>
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
  800612:	e8 b4 17 00 00       	call   801dcb <sys_getenvindex>
  800617:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80061a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061d:	89 d0                	mov    %edx,%eax
  80061f:	c1 e0 06             	shl    $0x6,%eax
  800622:	29 d0                	sub    %edx,%eax
  800624:	c1 e0 02             	shl    $0x2,%eax
  800627:	01 d0                	add    %edx,%eax
  800629:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800630:	01 c8                	add    %ecx,%eax
  800632:	c1 e0 03             	shl    $0x3,%eax
  800635:	01 d0                	add    %edx,%eax
  800637:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063e:	29 c2                	sub    %eax,%edx
  800640:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800647:	89 c2                	mov    %eax,%edx
  800649:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80064f:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800654:	a1 08 30 80 00       	mov    0x803008,%eax
  800659:	8a 40 20             	mov    0x20(%eax),%al
  80065c:	84 c0                	test   %al,%al
  80065e:	74 0d                	je     80066d <libmain+0x61>
		binaryname = myEnv->prog_name;
  800660:	a1 08 30 80 00       	mov    0x803008,%eax
  800665:	83 c0 20             	add    $0x20,%eax
  800668:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80066d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800671:	7e 0a                	jle    80067d <libmain+0x71>
		binaryname = argv[0];
  800673:	8b 45 0c             	mov    0xc(%ebp),%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	ff 75 08             	pushl  0x8(%ebp)
  800686:	e8 ad f9 ff ff       	call   800038 <_main>
  80068b:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80068e:	e8 bc 14 00 00       	call   801b4f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	68 7c 25 80 00       	push   $0x80257c
  80069b:	e8 76 03 00 00       	call   800a16 <cprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006a3:	a1 08 30 80 00       	mov    0x803008,%eax
  8006a8:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8006ae:	a1 08 30 80 00       	mov    0x803008,%eax
  8006b3:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	52                   	push   %edx
  8006bd:	50                   	push   %eax
  8006be:	68 a4 25 80 00       	push   $0x8025a4
  8006c3:	e8 4e 03 00 00       	call   800a16 <cprintf>
  8006c8:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006cb:	a1 08 30 80 00       	mov    0x803008,%eax
  8006d0:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8006d6:	a1 08 30 80 00       	mov    0x803008,%eax
  8006db:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8006e1:	a1 08 30 80 00       	mov    0x803008,%eax
  8006e6:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8006ec:	51                   	push   %ecx
  8006ed:	52                   	push   %edx
  8006ee:	50                   	push   %eax
  8006ef:	68 cc 25 80 00       	push   $0x8025cc
  8006f4:	e8 1d 03 00 00       	call   800a16 <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006fc:	a1 08 30 80 00       	mov    0x803008,%eax
  800701:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	50                   	push   %eax
  80070b:	68 24 26 80 00       	push   $0x802624
  800710:	e8 01 03 00 00       	call   800a16 <cprintf>
  800715:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	68 7c 25 80 00       	push   $0x80257c
  800720:	e8 f1 02 00 00       	call   800a16 <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800728:	e8 3c 14 00 00       	call   801b69 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80072d:	e8 19 00 00 00       	call   80074b <exit>
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80073b:	83 ec 0c             	sub    $0xc,%esp
  80073e:	6a 00                	push   $0x0
  800740:	e8 52 16 00 00       	call   801d97 <sys_destroy_env>
  800745:	83 c4 10             	add    $0x10,%esp
}
  800748:	90                   	nop
  800749:	c9                   	leave  
  80074a:	c3                   	ret    

0080074b <exit>:

void
exit(void)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800751:	e8 a7 16 00 00       	call   801dfd <sys_exit_env>
}
  800756:	90                   	nop
  800757:	c9                   	leave  
  800758:	c3                   	ret    

00800759 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80075f:	8d 45 10             	lea    0x10(%ebp),%eax
  800762:	83 c0 04             	add    $0x4,%eax
  800765:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800768:	a1 28 30 80 00       	mov    0x803028,%eax
  80076d:	85 c0                	test   %eax,%eax
  80076f:	74 16                	je     800787 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800771:	a1 28 30 80 00       	mov    0x803028,%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	50                   	push   %eax
  80077a:	68 38 26 80 00       	push   $0x802638
  80077f:	e8 92 02 00 00       	call   800a16 <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800787:	a1 00 30 80 00       	mov    0x803000,%eax
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	50                   	push   %eax
  800793:	68 3d 26 80 00       	push   $0x80263d
  800798:	e8 79 02 00 00       	call   800a16 <cprintf>
  80079d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a9:	50                   	push   %eax
  8007aa:	e8 fc 01 00 00       	call   8009ab <vcprintf>
  8007af:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	6a 00                	push   $0x0
  8007b7:	68 59 26 80 00       	push   $0x802659
  8007bc:	e8 ea 01 00 00       	call   8009ab <vcprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007c4:	e8 82 ff ff ff       	call   80074b <exit>

	// should not return here
	while (1) ;
  8007c9:	eb fe                	jmp    8007c9 <_panic+0x70>

008007cb <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007d1:	a1 08 30 80 00       	mov    0x803008,%eax
  8007d6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8007dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007df:	39 c2                	cmp    %eax,%edx
  8007e1:	74 14                	je     8007f7 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007e3:	83 ec 04             	sub    $0x4,%esp
  8007e6:	68 5c 26 80 00       	push   $0x80265c
  8007eb:	6a 26                	push   $0x26
  8007ed:	68 a8 26 80 00       	push   $0x8026a8
  8007f2:	e8 62 ff ff ff       	call   800759 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800805:	e9 c5 00 00 00       	jmp    8008cf <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80080a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	01 d0                	add    %edx,%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	85 c0                	test   %eax,%eax
  80081d:	75 08                	jne    800827 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80081f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800822:	e9 a5 00 00 00       	jmp    8008cc <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800827:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80082e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800835:	eb 69                	jmp    8008a0 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800837:	a1 08 30 80 00       	mov    0x803008,%eax
  80083c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800842:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800845:	89 d0                	mov    %edx,%eax
  800847:	01 c0                	add    %eax,%eax
  800849:	01 d0                	add    %edx,%eax
  80084b:	c1 e0 03             	shl    $0x3,%eax
  80084e:	01 c8                	add    %ecx,%eax
  800850:	8a 40 04             	mov    0x4(%eax),%al
  800853:	84 c0                	test   %al,%al
  800855:	75 46                	jne    80089d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800857:	a1 08 30 80 00       	mov    0x803008,%eax
  80085c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800862:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800865:	89 d0                	mov    %edx,%eax
  800867:	01 c0                	add    %eax,%eax
  800869:	01 d0                	add    %edx,%eax
  80086b:	c1 e0 03             	shl    $0x3,%eax
  80086e:	01 c8                	add    %ecx,%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800875:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800878:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80087f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800882:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	01 c8                	add    %ecx,%eax
  80088e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800890:	39 c2                	cmp    %eax,%edx
  800892:	75 09                	jne    80089d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800894:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80089b:	eb 15                	jmp    8008b2 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089d:	ff 45 e8             	incl   -0x18(%ebp)
  8008a0:	a1 08 30 80 00       	mov    0x803008,%eax
  8008a5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008ae:	39 c2                	cmp    %eax,%edx
  8008b0:	77 85                	ja     800837 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008b6:	75 14                	jne    8008cc <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008b8:	83 ec 04             	sub    $0x4,%esp
  8008bb:	68 b4 26 80 00       	push   $0x8026b4
  8008c0:	6a 3a                	push   $0x3a
  8008c2:	68 a8 26 80 00       	push   $0x8026a8
  8008c7:	e8 8d fe ff ff       	call   800759 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008cc:	ff 45 f0             	incl   -0x10(%ebp)
  8008cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008d5:	0f 8c 2f ff ff ff    	jl     80080a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008e9:	eb 26                	jmp    800911 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008eb:	a1 08 30 80 00       	mov    0x803008,%eax
  8008f0:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8008f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	01 c0                	add    %eax,%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	c1 e0 03             	shl    $0x3,%eax
  800902:	01 c8                	add    %ecx,%eax
  800904:	8a 40 04             	mov    0x4(%eax),%al
  800907:	3c 01                	cmp    $0x1,%al
  800909:	75 03                	jne    80090e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80090b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80090e:	ff 45 e0             	incl   -0x20(%ebp)
  800911:	a1 08 30 80 00       	mov    0x803008,%eax
  800916:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80091c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091f:	39 c2                	cmp    %eax,%edx
  800921:	77 c8                	ja     8008eb <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800926:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800929:	74 14                	je     80093f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80092b:	83 ec 04             	sub    $0x4,%esp
  80092e:	68 08 27 80 00       	push   $0x802708
  800933:	6a 44                	push   $0x44
  800935:	68 a8 26 80 00       	push   $0x8026a8
  80093a:	e8 1a fe ff ff       	call   800759 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80093f:	90                   	nop
  800940:	c9                   	leave  
  800941:	c3                   	ret    

00800942 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	8d 48 01             	lea    0x1(%eax),%ecx
  800950:	8b 55 0c             	mov    0xc(%ebp),%edx
  800953:	89 0a                	mov    %ecx,(%edx)
  800955:	8b 55 08             	mov    0x8(%ebp),%edx
  800958:	88 d1                	mov    %dl,%cl
  80095a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800961:	8b 45 0c             	mov    0xc(%ebp),%eax
  800964:	8b 00                	mov    (%eax),%eax
  800966:	3d ff 00 00 00       	cmp    $0xff,%eax
  80096b:	75 2c                	jne    800999 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80096d:	a0 0c 30 80 00       	mov    0x80300c,%al
  800972:	0f b6 c0             	movzbl %al,%eax
  800975:	8b 55 0c             	mov    0xc(%ebp),%edx
  800978:	8b 12                	mov    (%edx),%edx
  80097a:	89 d1                	mov    %edx,%ecx
  80097c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097f:	83 c2 08             	add    $0x8,%edx
  800982:	83 ec 04             	sub    $0x4,%esp
  800985:	50                   	push   %eax
  800986:	51                   	push   %ecx
  800987:	52                   	push   %edx
  800988:	e8 80 11 00 00       	call   801b0d <sys_cputs>
  80098d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	8b 40 04             	mov    0x4(%eax),%eax
  80099f:	8d 50 01             	lea    0x1(%eax),%edx
  8009a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009a8:	90                   	nop
  8009a9:	c9                   	leave  
  8009aa:	c3                   	ret    

008009ab <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009b4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009bb:	00 00 00 
	b.cnt = 0;
  8009be:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009c5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	ff 75 08             	pushl  0x8(%ebp)
  8009ce:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009d4:	50                   	push   %eax
  8009d5:	68 42 09 80 00       	push   $0x800942
  8009da:	e8 11 02 00 00       	call   800bf0 <vprintfmt>
  8009df:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009e2:	a0 0c 30 80 00       	mov    0x80300c,%al
  8009e7:	0f b6 c0             	movzbl %al,%eax
  8009ea:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009f0:	83 ec 04             	sub    $0x4,%esp
  8009f3:	50                   	push   %eax
  8009f4:	52                   	push   %edx
  8009f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009fb:	83 c0 08             	add    $0x8,%eax
  8009fe:	50                   	push   %eax
  8009ff:	e8 09 11 00 00       	call   801b0d <sys_cputs>
  800a04:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a07:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800a0e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a14:	c9                   	leave  
  800a15:	c3                   	ret    

00800a16 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a1c:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800a23:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a32:	50                   	push   %eax
  800a33:	e8 73 ff ff ff       	call   8009ab <vcprintf>
  800a38:	83 c4 10             	add    $0x10,%esp
  800a3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a41:	c9                   	leave  
  800a42:	c3                   	ret    

00800a43 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a49:	e8 01 11 00 00       	call   801b4f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a4e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	83 ec 08             	sub    $0x8,%esp
  800a5a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5d:	50                   	push   %eax
  800a5e:	e8 48 ff ff ff       	call   8009ab <vcprintf>
  800a63:	83 c4 10             	add    $0x10,%esp
  800a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a69:	e8 fb 10 00 00       	call   801b69 <sys_unlock_cons>
	return cnt;
  800a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a71:	c9                   	leave  
  800a72:	c3                   	ret    

00800a73 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	53                   	push   %ebx
  800a77:	83 ec 14             	sub    $0x14,%esp
  800a7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a80:	8b 45 14             	mov    0x14(%ebp),%eax
  800a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a86:	8b 45 18             	mov    0x18(%ebp),%eax
  800a89:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a91:	77 55                	ja     800ae8 <printnum+0x75>
  800a93:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a96:	72 05                	jb     800a9d <printnum+0x2a>
  800a98:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a9b:	77 4b                	ja     800ae8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a9d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800aa0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800aa3:	8b 45 18             	mov    0x18(%ebp),%eax
  800aa6:	ba 00 00 00 00       	mov    $0x0,%edx
  800aab:	52                   	push   %edx
  800aac:	50                   	push   %eax
  800aad:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab3:	e8 58 16 00 00       	call   802110 <__udivdi3>
  800ab8:	83 c4 10             	add    $0x10,%esp
  800abb:	83 ec 04             	sub    $0x4,%esp
  800abe:	ff 75 20             	pushl  0x20(%ebp)
  800ac1:	53                   	push   %ebx
  800ac2:	ff 75 18             	pushl  0x18(%ebp)
  800ac5:	52                   	push   %edx
  800ac6:	50                   	push   %eax
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	ff 75 08             	pushl  0x8(%ebp)
  800acd:	e8 a1 ff ff ff       	call   800a73 <printnum>
  800ad2:	83 c4 20             	add    $0x20,%esp
  800ad5:	eb 1a                	jmp    800af1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	ff 75 20             	pushl  0x20(%ebp)
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	ff d0                	call   *%eax
  800ae5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ae8:	ff 4d 1c             	decl   0x1c(%ebp)
  800aeb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800aef:	7f e6                	jg     800ad7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800af1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800af4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800afc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aff:	53                   	push   %ebx
  800b00:	51                   	push   %ecx
  800b01:	52                   	push   %edx
  800b02:	50                   	push   %eax
  800b03:	e8 18 17 00 00       	call   802220 <__umoddi3>
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	05 74 29 80 00       	add    $0x802974,%eax
  800b10:	8a 00                	mov    (%eax),%al
  800b12:	0f be c0             	movsbl %al,%eax
  800b15:	83 ec 08             	sub    $0x8,%esp
  800b18:	ff 75 0c             	pushl  0xc(%ebp)
  800b1b:	50                   	push   %eax
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	ff d0                	call   *%eax
  800b21:	83 c4 10             	add    $0x10,%esp
}
  800b24:	90                   	nop
  800b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b28:	c9                   	leave  
  800b29:	c3                   	ret    

00800b2a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b2d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b31:	7e 1c                	jle    800b4f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	8b 00                	mov    (%eax),%eax
  800b38:	8d 50 08             	lea    0x8(%eax),%edx
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	89 10                	mov    %edx,(%eax)
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	8b 00                	mov    (%eax),%eax
  800b45:	83 e8 08             	sub    $0x8,%eax
  800b48:	8b 50 04             	mov    0x4(%eax),%edx
  800b4b:	8b 00                	mov    (%eax),%eax
  800b4d:	eb 40                	jmp    800b8f <getuint+0x65>
	else if (lflag)
  800b4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b53:	74 1e                	je     800b73 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 50 04             	lea    0x4(%eax),%edx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 10                	mov    %edx,(%eax)
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	83 e8 04             	sub    $0x4,%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b71:	eb 1c                	jmp    800b8f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	8d 50 04             	lea    0x4(%eax),%edx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	89 10                	mov    %edx,(%eax)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	83 e8 04             	sub    $0x4,%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    

00800b91 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b94:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b98:	7e 1c                	jle    800bb6 <getint+0x25>
		return va_arg(*ap, long long);
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	8d 50 08             	lea    0x8(%eax),%edx
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	89 10                	mov    %edx,(%eax)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 00                	mov    (%eax),%eax
  800bac:	83 e8 08             	sub    $0x8,%eax
  800baf:	8b 50 04             	mov    0x4(%eax),%edx
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	eb 38                	jmp    800bee <getint+0x5d>
	else if (lflag)
  800bb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bba:	74 1a                	je     800bd6 <getint+0x45>
		return va_arg(*ap, long);
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	8d 50 04             	lea    0x4(%eax),%edx
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	89 10                	mov    %edx,(%eax)
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 00                	mov    (%eax),%eax
  800bce:	83 e8 04             	sub    $0x4,%eax
  800bd1:	8b 00                	mov    (%eax),%eax
  800bd3:	99                   	cltd   
  800bd4:	eb 18                	jmp    800bee <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 00                	mov    (%eax),%eax
  800bdb:	8d 50 04             	lea    0x4(%eax),%edx
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	89 10                	mov    %edx,(%eax)
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8b 00                	mov    (%eax),%eax
  800be8:	83 e8 04             	sub    $0x4,%eax
  800beb:	8b 00                	mov    (%eax),%eax
  800bed:	99                   	cltd   
}
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	56                   	push   %esi
  800bf4:	53                   	push   %ebx
  800bf5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bf8:	eb 17                	jmp    800c11 <vprintfmt+0x21>
			if (ch == '\0')
  800bfa:	85 db                	test   %ebx,%ebx
  800bfc:	0f 84 c1 03 00 00    	je     800fc3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	53                   	push   %ebx
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	ff d0                	call   *%eax
  800c0e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c11:	8b 45 10             	mov    0x10(%ebp),%eax
  800c14:	8d 50 01             	lea    0x1(%eax),%edx
  800c17:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1a:	8a 00                	mov    (%eax),%al
  800c1c:	0f b6 d8             	movzbl %al,%ebx
  800c1f:	83 fb 25             	cmp    $0x25,%ebx
  800c22:	75 d6                	jne    800bfa <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c24:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c28:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c2f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c36:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c3d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c44:	8b 45 10             	mov    0x10(%ebp),%eax
  800c47:	8d 50 01             	lea    0x1(%eax),%edx
  800c4a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	0f b6 d8             	movzbl %al,%ebx
  800c52:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c55:	83 f8 5b             	cmp    $0x5b,%eax
  800c58:	0f 87 3d 03 00 00    	ja     800f9b <vprintfmt+0x3ab>
  800c5e:	8b 04 85 98 29 80 00 	mov    0x802998(,%eax,4),%eax
  800c65:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c67:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c6b:	eb d7                	jmp    800c44 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c6d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c71:	eb d1                	jmp    800c44 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c73:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c7a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c7d:	89 d0                	mov    %edx,%eax
  800c7f:	c1 e0 02             	shl    $0x2,%eax
  800c82:	01 d0                	add    %edx,%eax
  800c84:	01 c0                	add    %eax,%eax
  800c86:	01 d8                	add    %ebx,%eax
  800c88:	83 e8 30             	sub    $0x30,%eax
  800c8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c96:	83 fb 2f             	cmp    $0x2f,%ebx
  800c99:	7e 3e                	jle    800cd9 <vprintfmt+0xe9>
  800c9b:	83 fb 39             	cmp    $0x39,%ebx
  800c9e:	7f 39                	jg     800cd9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ca3:	eb d5                	jmp    800c7a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca8:	83 c0 04             	add    $0x4,%eax
  800cab:	89 45 14             	mov    %eax,0x14(%ebp)
  800cae:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb1:	83 e8 04             	sub    $0x4,%eax
  800cb4:	8b 00                	mov    (%eax),%eax
  800cb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cb9:	eb 1f                	jmp    800cda <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cbb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cbf:	79 83                	jns    800c44 <vprintfmt+0x54>
				width = 0;
  800cc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cc8:	e9 77 ff ff ff       	jmp    800c44 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ccd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cd4:	e9 6b ff ff ff       	jmp    800c44 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cd9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cde:	0f 89 60 ff ff ff    	jns    800c44 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ce4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ce7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cf1:	e9 4e ff ff ff       	jmp    800c44 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cf6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cf9:	e9 46 ff ff ff       	jmp    800c44 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800d01:	83 c0 04             	add    $0x4,%eax
  800d04:	89 45 14             	mov    %eax,0x14(%ebp)
  800d07:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0a:	83 e8 04             	sub    $0x4,%eax
  800d0d:	8b 00                	mov    (%eax),%eax
  800d0f:	83 ec 08             	sub    $0x8,%esp
  800d12:	ff 75 0c             	pushl  0xc(%ebp)
  800d15:	50                   	push   %eax
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	ff d0                	call   *%eax
  800d1b:	83 c4 10             	add    $0x10,%esp
			break;
  800d1e:	e9 9b 02 00 00       	jmp    800fbe <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d23:	8b 45 14             	mov    0x14(%ebp),%eax
  800d26:	83 c0 04             	add    $0x4,%eax
  800d29:	89 45 14             	mov    %eax,0x14(%ebp)
  800d2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2f:	83 e8 04             	sub    $0x4,%eax
  800d32:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d34:	85 db                	test   %ebx,%ebx
  800d36:	79 02                	jns    800d3a <vprintfmt+0x14a>
				err = -err;
  800d38:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d3a:	83 fb 64             	cmp    $0x64,%ebx
  800d3d:	7f 0b                	jg     800d4a <vprintfmt+0x15a>
  800d3f:	8b 34 9d e0 27 80 00 	mov    0x8027e0(,%ebx,4),%esi
  800d46:	85 f6                	test   %esi,%esi
  800d48:	75 19                	jne    800d63 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d4a:	53                   	push   %ebx
  800d4b:	68 85 29 80 00       	push   $0x802985
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	ff 75 08             	pushl  0x8(%ebp)
  800d56:	e8 70 02 00 00       	call   800fcb <printfmt>
  800d5b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d5e:	e9 5b 02 00 00       	jmp    800fbe <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d63:	56                   	push   %esi
  800d64:	68 8e 29 80 00       	push   $0x80298e
  800d69:	ff 75 0c             	pushl  0xc(%ebp)
  800d6c:	ff 75 08             	pushl  0x8(%ebp)
  800d6f:	e8 57 02 00 00       	call   800fcb <printfmt>
  800d74:	83 c4 10             	add    $0x10,%esp
			break;
  800d77:	e9 42 02 00 00       	jmp    800fbe <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7f:	83 c0 04             	add    $0x4,%eax
  800d82:	89 45 14             	mov    %eax,0x14(%ebp)
  800d85:	8b 45 14             	mov    0x14(%ebp),%eax
  800d88:	83 e8 04             	sub    $0x4,%eax
  800d8b:	8b 30                	mov    (%eax),%esi
  800d8d:	85 f6                	test   %esi,%esi
  800d8f:	75 05                	jne    800d96 <vprintfmt+0x1a6>
				p = "(null)";
  800d91:	be 91 29 80 00       	mov    $0x802991,%esi
			if (width > 0 && padc != '-')
  800d96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d9a:	7e 6d                	jle    800e09 <vprintfmt+0x219>
  800d9c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800da0:	74 67                	je     800e09 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800da2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800da5:	83 ec 08             	sub    $0x8,%esp
  800da8:	50                   	push   %eax
  800da9:	56                   	push   %esi
  800daa:	e8 26 05 00 00       	call   8012d5 <strnlen>
  800daf:	83 c4 10             	add    $0x10,%esp
  800db2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800db5:	eb 16                	jmp    800dcd <vprintfmt+0x1dd>
					putch(padc, putdat);
  800db7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	50                   	push   %eax
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	ff d0                	call   *%eax
  800dc7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dca:	ff 4d e4             	decl   -0x1c(%ebp)
  800dcd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd1:	7f e4                	jg     800db7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dd3:	eb 34                	jmp    800e09 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dd5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dd9:	74 1c                	je     800df7 <vprintfmt+0x207>
  800ddb:	83 fb 1f             	cmp    $0x1f,%ebx
  800dde:	7e 05                	jle    800de5 <vprintfmt+0x1f5>
  800de0:	83 fb 7e             	cmp    $0x7e,%ebx
  800de3:	7e 12                	jle    800df7 <vprintfmt+0x207>
					putch('?', putdat);
  800de5:	83 ec 08             	sub    $0x8,%esp
  800de8:	ff 75 0c             	pushl  0xc(%ebp)
  800deb:	6a 3f                	push   $0x3f
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	ff d0                	call   *%eax
  800df2:	83 c4 10             	add    $0x10,%esp
  800df5:	eb 0f                	jmp    800e06 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800df7:	83 ec 08             	sub    $0x8,%esp
  800dfa:	ff 75 0c             	pushl  0xc(%ebp)
  800dfd:	53                   	push   %ebx
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	ff d0                	call   *%eax
  800e03:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e06:	ff 4d e4             	decl   -0x1c(%ebp)
  800e09:	89 f0                	mov    %esi,%eax
  800e0b:	8d 70 01             	lea    0x1(%eax),%esi
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	0f be d8             	movsbl %al,%ebx
  800e13:	85 db                	test   %ebx,%ebx
  800e15:	74 24                	je     800e3b <vprintfmt+0x24b>
  800e17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e1b:	78 b8                	js     800dd5 <vprintfmt+0x1e5>
  800e1d:	ff 4d e0             	decl   -0x20(%ebp)
  800e20:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e24:	79 af                	jns    800dd5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e26:	eb 13                	jmp    800e3b <vprintfmt+0x24b>
				putch(' ', putdat);
  800e28:	83 ec 08             	sub    $0x8,%esp
  800e2b:	ff 75 0c             	pushl  0xc(%ebp)
  800e2e:	6a 20                	push   $0x20
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	ff d0                	call   *%eax
  800e35:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e38:	ff 4d e4             	decl   -0x1c(%ebp)
  800e3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e3f:	7f e7                	jg     800e28 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e41:	e9 78 01 00 00       	jmp    800fbe <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e46:	83 ec 08             	sub    $0x8,%esp
  800e49:	ff 75 e8             	pushl  -0x18(%ebp)
  800e4c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e4f:	50                   	push   %eax
  800e50:	e8 3c fd ff ff       	call   800b91 <getint>
  800e55:	83 c4 10             	add    $0x10,%esp
  800e58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e64:	85 d2                	test   %edx,%edx
  800e66:	79 23                	jns    800e8b <vprintfmt+0x29b>
				putch('-', putdat);
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	6a 2d                	push   $0x2d
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	ff d0                	call   *%eax
  800e75:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7e:	f7 d8                	neg    %eax
  800e80:	83 d2 00             	adc    $0x0,%edx
  800e83:	f7 da                	neg    %edx
  800e85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e8b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e92:	e9 bc 00 00 00       	jmp    800f53 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800e9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800ea0:	50                   	push   %eax
  800ea1:	e8 84 fc ff ff       	call   800b2a <getuint>
  800ea6:	83 c4 10             	add    $0x10,%esp
  800ea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800eaf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eb6:	e9 98 00 00 00       	jmp    800f53 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ebb:	83 ec 08             	sub    $0x8,%esp
  800ebe:	ff 75 0c             	pushl  0xc(%ebp)
  800ec1:	6a 58                	push   $0x58
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	ff d0                	call   *%eax
  800ec8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ecb:	83 ec 08             	sub    $0x8,%esp
  800ece:	ff 75 0c             	pushl  0xc(%ebp)
  800ed1:	6a 58                	push   $0x58
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	ff d0                	call   *%eax
  800ed8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800edb:	83 ec 08             	sub    $0x8,%esp
  800ede:	ff 75 0c             	pushl  0xc(%ebp)
  800ee1:	6a 58                	push   $0x58
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	ff d0                	call   *%eax
  800ee8:	83 c4 10             	add    $0x10,%esp
			break;
  800eeb:	e9 ce 00 00 00       	jmp    800fbe <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ef0:	83 ec 08             	sub    $0x8,%esp
  800ef3:	ff 75 0c             	pushl  0xc(%ebp)
  800ef6:	6a 30                	push   $0x30
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	ff d0                	call   *%eax
  800efd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f00:	83 ec 08             	sub    $0x8,%esp
  800f03:	ff 75 0c             	pushl  0xc(%ebp)
  800f06:	6a 78                	push   $0x78
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	ff d0                	call   *%eax
  800f0d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	83 c0 04             	add    $0x4,%eax
  800f16:	89 45 14             	mov    %eax,0x14(%ebp)
  800f19:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1c:	83 e8 04             	sub    $0x4,%eax
  800f1f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f2b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f32:	eb 1f                	jmp    800f53 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f34:	83 ec 08             	sub    $0x8,%esp
  800f37:	ff 75 e8             	pushl  -0x18(%ebp)
  800f3a:	8d 45 14             	lea    0x14(%ebp),%eax
  800f3d:	50                   	push   %eax
  800f3e:	e8 e7 fb ff ff       	call   800b2a <getuint>
  800f43:	83 c4 10             	add    $0x10,%esp
  800f46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f4c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f53:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f5a:	83 ec 04             	sub    $0x4,%esp
  800f5d:	52                   	push   %edx
  800f5e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f61:	50                   	push   %eax
  800f62:	ff 75 f4             	pushl  -0xc(%ebp)
  800f65:	ff 75 f0             	pushl  -0x10(%ebp)
  800f68:	ff 75 0c             	pushl  0xc(%ebp)
  800f6b:	ff 75 08             	pushl  0x8(%ebp)
  800f6e:	e8 00 fb ff ff       	call   800a73 <printnum>
  800f73:	83 c4 20             	add    $0x20,%esp
			break;
  800f76:	eb 46                	jmp    800fbe <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f78:	83 ec 08             	sub    $0x8,%esp
  800f7b:	ff 75 0c             	pushl  0xc(%ebp)
  800f7e:	53                   	push   %ebx
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	ff d0                	call   *%eax
  800f84:	83 c4 10             	add    $0x10,%esp
			break;
  800f87:	eb 35                	jmp    800fbe <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f89:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800f90:	eb 2c                	jmp    800fbe <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f92:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800f99:	eb 23                	jmp    800fbe <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f9b:	83 ec 08             	sub    $0x8,%esp
  800f9e:	ff 75 0c             	pushl  0xc(%ebp)
  800fa1:	6a 25                	push   $0x25
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	ff d0                	call   *%eax
  800fa8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fab:	ff 4d 10             	decl   0x10(%ebp)
  800fae:	eb 03                	jmp    800fb3 <vprintfmt+0x3c3>
  800fb0:	ff 4d 10             	decl   0x10(%ebp)
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	48                   	dec    %eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	3c 25                	cmp    $0x25,%al
  800fbb:	75 f3                	jne    800fb0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800fbd:	90                   	nop
		}
	}
  800fbe:	e9 35 fc ff ff       	jmp    800bf8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fc3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fc7:	5b                   	pop    %ebx
  800fc8:	5e                   	pop    %esi
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    

00800fcb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fd1:	8d 45 10             	lea    0x10(%ebp),%eax
  800fd4:	83 c0 04             	add    $0x4,%eax
  800fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe0:	50                   	push   %eax
  800fe1:	ff 75 0c             	pushl  0xc(%ebp)
  800fe4:	ff 75 08             	pushl  0x8(%ebp)
  800fe7:	e8 04 fc ff ff       	call   800bf0 <vprintfmt>
  800fec:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fef:	90                   	nop
  800ff0:	c9                   	leave  
  800ff1:	c3                   	ret    

00800ff2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff8:	8b 40 08             	mov    0x8(%eax),%eax
  800ffb:	8d 50 01             	lea    0x1(%eax),%edx
  800ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801001:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	8b 10                	mov    (%eax),%edx
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	8b 40 04             	mov    0x4(%eax),%eax
  80100f:	39 c2                	cmp    %eax,%edx
  801011:	73 12                	jae    801025 <sprintputch+0x33>
		*b->buf++ = ch;
  801013:	8b 45 0c             	mov    0xc(%ebp),%eax
  801016:	8b 00                	mov    (%eax),%eax
  801018:	8d 48 01             	lea    0x1(%eax),%ecx
  80101b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101e:	89 0a                	mov    %ecx,(%edx)
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	88 10                	mov    %dl,(%eax)
}
  801025:	90                   	nop
  801026:	5d                   	pop    %ebp
  801027:	c3                   	ret    

00801028 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	01 d0                	add    %edx,%eax
  80103f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801049:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104d:	74 06                	je     801055 <vsnprintf+0x2d>
  80104f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801053:	7f 07                	jg     80105c <vsnprintf+0x34>
		return -E_INVAL;
  801055:	b8 03 00 00 00       	mov    $0x3,%eax
  80105a:	eb 20                	jmp    80107c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80105c:	ff 75 14             	pushl  0x14(%ebp)
  80105f:	ff 75 10             	pushl  0x10(%ebp)
  801062:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801065:	50                   	push   %eax
  801066:	68 f2 0f 80 00       	push   $0x800ff2
  80106b:	e8 80 fb ff ff       	call   800bf0 <vprintfmt>
  801070:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801073:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801076:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801079:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80107c:	c9                   	leave  
  80107d:	c3                   	ret    

0080107e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801084:	8d 45 10             	lea    0x10(%ebp),%eax
  801087:	83 c0 04             	add    $0x4,%eax
  80108a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	ff 75 f4             	pushl  -0xc(%ebp)
  801093:	50                   	push   %eax
  801094:	ff 75 0c             	pushl  0xc(%ebp)
  801097:	ff 75 08             	pushl  0x8(%ebp)
  80109a:	e8 89 ff ff ff       	call   801028 <vsnprintf>
  80109f:	83 c4 10             	add    $0x10,%esp
  8010a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8010b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b4:	74 13                	je     8010c9 <readline+0x1f>
		cprintf("%s", prompt);
  8010b6:	83 ec 08             	sub    $0x8,%esp
  8010b9:	ff 75 08             	pushl  0x8(%ebp)
  8010bc:	68 08 2b 80 00       	push   $0x802b08
  8010c1:	e8 50 f9 ff ff       	call   800a16 <cprintf>
  8010c6:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010d0:	83 ec 0c             	sub    $0xc,%esp
  8010d3:	6a 00                	push   $0x0
  8010d5:	e8 28 f5 ff ff       	call   800602 <iscons>
  8010da:	83 c4 10             	add    $0x10,%esp
  8010dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010e0:	e8 0a f5 ff ff       	call   8005ef <getchar>
  8010e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010ec:	79 22                	jns    801110 <readline+0x66>
			if (c != -E_EOF)
  8010ee:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010f2:	0f 84 ad 00 00 00    	je     8011a5 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8010fe:	68 0b 2b 80 00       	push   $0x802b0b
  801103:	e8 0e f9 ff ff       	call   800a16 <cprintf>
  801108:	83 c4 10             	add    $0x10,%esp
			break;
  80110b:	e9 95 00 00 00       	jmp    8011a5 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801110:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801114:	7e 34                	jle    80114a <readline+0xa0>
  801116:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80111d:	7f 2b                	jg     80114a <readline+0xa0>
			if (echoing)
  80111f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801123:	74 0e                	je     801133 <readline+0x89>
				cputchar(c);
  801125:	83 ec 0c             	sub    $0xc,%esp
  801128:	ff 75 ec             	pushl  -0x14(%ebp)
  80112b:	e8 a0 f4 ff ff       	call   8005d0 <cputchar>
  801130:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801136:	8d 50 01             	lea    0x1(%eax),%edx
  801139:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80113c:	89 c2                	mov    %eax,%edx
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	01 d0                	add    %edx,%eax
  801143:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801146:	88 10                	mov    %dl,(%eax)
  801148:	eb 56                	jmp    8011a0 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80114a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80114e:	75 1f                	jne    80116f <readline+0xc5>
  801150:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801154:	7e 19                	jle    80116f <readline+0xc5>
			if (echoing)
  801156:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80115a:	74 0e                	je     80116a <readline+0xc0>
				cputchar(c);
  80115c:	83 ec 0c             	sub    $0xc,%esp
  80115f:	ff 75 ec             	pushl  -0x14(%ebp)
  801162:	e8 69 f4 ff ff       	call   8005d0 <cputchar>
  801167:	83 c4 10             	add    $0x10,%esp

			i--;
  80116a:	ff 4d f4             	decl   -0xc(%ebp)
  80116d:	eb 31                	jmp    8011a0 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80116f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801173:	74 0a                	je     80117f <readline+0xd5>
  801175:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801179:	0f 85 61 ff ff ff    	jne    8010e0 <readline+0x36>
			if (echoing)
  80117f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801183:	74 0e                	je     801193 <readline+0xe9>
				cputchar(c);
  801185:	83 ec 0c             	sub    $0xc,%esp
  801188:	ff 75 ec             	pushl  -0x14(%ebp)
  80118b:	e8 40 f4 ff ff       	call   8005d0 <cputchar>
  801190:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801193:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	01 d0                	add    %edx,%eax
  80119b:	c6 00 00             	movb   $0x0,(%eax)
			break;
  80119e:	eb 06                	jmp    8011a6 <readline+0xfc>
		}
	}
  8011a0:	e9 3b ff ff ff       	jmp    8010e0 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8011a5:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8011a6:	90                   	nop
  8011a7:	c9                   	leave  
  8011a8:	c3                   	ret    

008011a9 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8011af:	e8 9b 09 00 00       	call   801b4f <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8011b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b8:	74 13                	je     8011cd <atomic_readline+0x24>
			cprintf("%s", prompt);
  8011ba:	83 ec 08             	sub    $0x8,%esp
  8011bd:	ff 75 08             	pushl  0x8(%ebp)
  8011c0:	68 08 2b 80 00       	push   $0x802b08
  8011c5:	e8 4c f8 ff ff       	call   800a16 <cprintf>
  8011ca:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8011cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8011d4:	83 ec 0c             	sub    $0xc,%esp
  8011d7:	6a 00                	push   $0x0
  8011d9:	e8 24 f4 ff ff       	call   800602 <iscons>
  8011de:	83 c4 10             	add    $0x10,%esp
  8011e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8011e4:	e8 06 f4 ff ff       	call   8005ef <getchar>
  8011e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8011ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011f0:	79 22                	jns    801214 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8011f2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011f6:	0f 84 ad 00 00 00    	je     8012a9 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8011fc:	83 ec 08             	sub    $0x8,%esp
  8011ff:	ff 75 ec             	pushl  -0x14(%ebp)
  801202:	68 0b 2b 80 00       	push   $0x802b0b
  801207:	e8 0a f8 ff ff       	call   800a16 <cprintf>
  80120c:	83 c4 10             	add    $0x10,%esp
				break;
  80120f:	e9 95 00 00 00       	jmp    8012a9 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801214:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801218:	7e 34                	jle    80124e <atomic_readline+0xa5>
  80121a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801221:	7f 2b                	jg     80124e <atomic_readline+0xa5>
				if (echoing)
  801223:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801227:	74 0e                	je     801237 <atomic_readline+0x8e>
					cputchar(c);
  801229:	83 ec 0c             	sub    $0xc,%esp
  80122c:	ff 75 ec             	pushl  -0x14(%ebp)
  80122f:	e8 9c f3 ff ff       	call   8005d0 <cputchar>
  801234:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123a:	8d 50 01             	lea    0x1(%eax),%edx
  80123d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801240:	89 c2                	mov    %eax,%edx
  801242:	8b 45 0c             	mov    0xc(%ebp),%eax
  801245:	01 d0                	add    %edx,%eax
  801247:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80124a:	88 10                	mov    %dl,(%eax)
  80124c:	eb 56                	jmp    8012a4 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80124e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801252:	75 1f                	jne    801273 <atomic_readline+0xca>
  801254:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801258:	7e 19                	jle    801273 <atomic_readline+0xca>
				if (echoing)
  80125a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80125e:	74 0e                	je     80126e <atomic_readline+0xc5>
					cputchar(c);
  801260:	83 ec 0c             	sub    $0xc,%esp
  801263:	ff 75 ec             	pushl  -0x14(%ebp)
  801266:	e8 65 f3 ff ff       	call   8005d0 <cputchar>
  80126b:	83 c4 10             	add    $0x10,%esp
				i--;
  80126e:	ff 4d f4             	decl   -0xc(%ebp)
  801271:	eb 31                	jmp    8012a4 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801273:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801277:	74 0a                	je     801283 <atomic_readline+0xda>
  801279:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80127d:	0f 85 61 ff ff ff    	jne    8011e4 <atomic_readline+0x3b>
				if (echoing)
  801283:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801287:	74 0e                	je     801297 <atomic_readline+0xee>
					cputchar(c);
  801289:	83 ec 0c             	sub    $0xc,%esp
  80128c:	ff 75 ec             	pushl  -0x14(%ebp)
  80128f:	e8 3c f3 ff ff       	call   8005d0 <cputchar>
  801294:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801297:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80129a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129d:	01 d0                	add    %edx,%eax
  80129f:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8012a2:	eb 06                	jmp    8012aa <atomic_readline+0x101>
			}
		}
  8012a4:	e9 3b ff ff ff       	jmp    8011e4 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8012a9:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8012aa:	e8 ba 08 00 00       	call   801b69 <sys_unlock_cons>
}
  8012af:	90                   	nop
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012bf:	eb 06                	jmp    8012c7 <strlen+0x15>
		n++;
  8012c1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c4:	ff 45 08             	incl   0x8(%ebp)
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	84 c0                	test   %al,%al
  8012ce:	75 f1                	jne    8012c1 <strlen+0xf>
		n++;
	return n;
  8012d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012d3:	c9                   	leave  
  8012d4:	c3                   	ret    

008012d5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e2:	eb 09                	jmp    8012ed <strnlen+0x18>
		n++;
  8012e4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e7:	ff 45 08             	incl   0x8(%ebp)
  8012ea:	ff 4d 0c             	decl   0xc(%ebp)
  8012ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012f1:	74 09                	je     8012fc <strnlen+0x27>
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	8a 00                	mov    (%eax),%al
  8012f8:	84 c0                	test   %al,%al
  8012fa:	75 e8                	jne    8012e4 <strnlen+0xf>
		n++;
	return n;
  8012fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80130d:	90                   	nop
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8d 50 01             	lea    0x1(%eax),%edx
  801314:	89 55 08             	mov    %edx,0x8(%ebp)
  801317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80131d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801320:	8a 12                	mov    (%edx),%dl
  801322:	88 10                	mov    %dl,(%eax)
  801324:	8a 00                	mov    (%eax),%al
  801326:	84 c0                	test   %al,%al
  801328:	75 e4                	jne    80130e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80132a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80133b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801342:	eb 1f                	jmp    801363 <strncpy+0x34>
		*dst++ = *src;
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	8d 50 01             	lea    0x1(%eax),%edx
  80134a:	89 55 08             	mov    %edx,0x8(%ebp)
  80134d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801350:	8a 12                	mov    (%edx),%dl
  801352:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	84 c0                	test   %al,%al
  80135b:	74 03                	je     801360 <strncpy+0x31>
			src++;
  80135d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801360:	ff 45 fc             	incl   -0x4(%ebp)
  801363:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801366:	3b 45 10             	cmp    0x10(%ebp),%eax
  801369:	72 d9                	jb     801344 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80136b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80137c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801380:	74 30                	je     8013b2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801382:	eb 16                	jmp    80139a <strlcpy+0x2a>
			*dst++ = *src++;
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8d 50 01             	lea    0x1(%eax),%edx
  80138a:	89 55 08             	mov    %edx,0x8(%ebp)
  80138d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801390:	8d 4a 01             	lea    0x1(%edx),%ecx
  801393:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801396:	8a 12                	mov    (%edx),%dl
  801398:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80139a:	ff 4d 10             	decl   0x10(%ebp)
  80139d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a1:	74 09                	je     8013ac <strlcpy+0x3c>
  8013a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a6:	8a 00                	mov    (%eax),%al
  8013a8:	84 c0                	test   %al,%al
  8013aa:	75 d8                	jne    801384 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b8:	29 c2                	sub    %eax,%edx
  8013ba:	89 d0                	mov    %edx,%eax
}
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013c1:	eb 06                	jmp    8013c9 <strcmp+0xb>
		p++, q++;
  8013c3:	ff 45 08             	incl   0x8(%ebp)
  8013c6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	84 c0                	test   %al,%al
  8013d0:	74 0e                	je     8013e0 <strcmp+0x22>
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	8a 10                	mov    (%eax),%dl
  8013d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013da:	8a 00                	mov    (%eax),%al
  8013dc:	38 c2                	cmp    %al,%dl
  8013de:	74 e3                	je     8013c3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	8a 00                	mov    (%eax),%al
  8013e5:	0f b6 d0             	movzbl %al,%edx
  8013e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013eb:	8a 00                	mov    (%eax),%al
  8013ed:	0f b6 c0             	movzbl %al,%eax
  8013f0:	29 c2                	sub    %eax,%edx
  8013f2:	89 d0                	mov    %edx,%eax
}
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    

008013f6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013f9:	eb 09                	jmp    801404 <strncmp+0xe>
		n--, p++, q++;
  8013fb:	ff 4d 10             	decl   0x10(%ebp)
  8013fe:	ff 45 08             	incl   0x8(%ebp)
  801401:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801404:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801408:	74 17                	je     801421 <strncmp+0x2b>
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	84 c0                	test   %al,%al
  801411:	74 0e                	je     801421 <strncmp+0x2b>
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8a 10                	mov    (%eax),%dl
  801418:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	38 c2                	cmp    %al,%dl
  80141f:	74 da                	je     8013fb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801421:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801425:	75 07                	jne    80142e <strncmp+0x38>
		return 0;
  801427:	b8 00 00 00 00       	mov    $0x0,%eax
  80142c:	eb 14                	jmp    801442 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8a 00                	mov    (%eax),%al
  801433:	0f b6 d0             	movzbl %al,%edx
  801436:	8b 45 0c             	mov    0xc(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	0f b6 c0             	movzbl %al,%eax
  80143e:	29 c2                	sub    %eax,%edx
  801440:	89 d0                	mov    %edx,%eax
}
  801442:	5d                   	pop    %ebp
  801443:	c3                   	ret    

00801444 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	83 ec 04             	sub    $0x4,%esp
  80144a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801450:	eb 12                	jmp    801464 <strchr+0x20>
		if (*s == c)
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80145a:	75 05                	jne    801461 <strchr+0x1d>
			return (char *) s;
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	eb 11                	jmp    801472 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801461:	ff 45 08             	incl   0x8(%ebp)
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	84 c0                	test   %al,%al
  80146b:	75 e5                	jne    801452 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80146d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 04             	sub    $0x4,%esp
  80147a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801480:	eb 0d                	jmp    80148f <strfind+0x1b>
		if (*s == c)
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80148a:	74 0e                	je     80149a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80148c:	ff 45 08             	incl   0x8(%ebp)
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	84 c0                	test   %al,%al
  801496:	75 ea                	jne    801482 <strfind+0xe>
  801498:	eb 01                	jmp    80149b <strfind+0x27>
		if (*s == c)
			break;
  80149a:	90                   	nop
	return (char *) s;
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8014af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014b2:	eb 0e                	jmp    8014c2 <memset+0x22>
		*p++ = c;
  8014b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ba:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014c2:	ff 4d f8             	decl   -0x8(%ebp)
  8014c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014c9:	79 e9                	jns    8014b4 <memset+0x14>
		*p++ = c;

	return v;
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014e2:	eb 16                	jmp    8014fa <memcpy+0x2a>
		*d++ = *s++;
  8014e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014f3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014f6:	8a 12                	mov    (%edx),%dl
  8014f8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  801500:	89 55 10             	mov    %edx,0x10(%ebp)
  801503:	85 c0                	test   %eax,%eax
  801505:	75 dd                	jne    8014e4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801512:	8b 45 0c             	mov    0xc(%ebp),%eax
  801515:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80151e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801521:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801524:	73 50                	jae    801576 <memmove+0x6a>
  801526:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801529:	8b 45 10             	mov    0x10(%ebp),%eax
  80152c:	01 d0                	add    %edx,%eax
  80152e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801531:	76 43                	jbe    801576 <memmove+0x6a>
		s += n;
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801539:	8b 45 10             	mov    0x10(%ebp),%eax
  80153c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80153f:	eb 10                	jmp    801551 <memmove+0x45>
			*--d = *--s;
  801541:	ff 4d f8             	decl   -0x8(%ebp)
  801544:	ff 4d fc             	decl   -0x4(%ebp)
  801547:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154a:	8a 10                	mov    (%eax),%dl
  80154c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80154f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801551:	8b 45 10             	mov    0x10(%ebp),%eax
  801554:	8d 50 ff             	lea    -0x1(%eax),%edx
  801557:	89 55 10             	mov    %edx,0x10(%ebp)
  80155a:	85 c0                	test   %eax,%eax
  80155c:	75 e3                	jne    801541 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80155e:	eb 23                	jmp    801583 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801560:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801563:	8d 50 01             	lea    0x1(%eax),%edx
  801566:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801569:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80156c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80156f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801572:	8a 12                	mov    (%edx),%dl
  801574:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	8d 50 ff             	lea    -0x1(%eax),%edx
  80157c:	89 55 10             	mov    %edx,0x10(%ebp)
  80157f:	85 c0                	test   %eax,%eax
  801581:	75 dd                	jne    801560 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801594:	8b 45 0c             	mov    0xc(%ebp),%eax
  801597:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80159a:	eb 2a                	jmp    8015c6 <memcmp+0x3e>
		if (*s1 != *s2)
  80159c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80159f:	8a 10                	mov    (%eax),%dl
  8015a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a4:	8a 00                	mov    (%eax),%al
  8015a6:	38 c2                	cmp    %al,%dl
  8015a8:	74 16                	je     8015c0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ad:	8a 00                	mov    (%eax),%al
  8015af:	0f b6 d0             	movzbl %al,%edx
  8015b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b5:	8a 00                	mov    (%eax),%al
  8015b7:	0f b6 c0             	movzbl %al,%eax
  8015ba:	29 c2                	sub    %eax,%edx
  8015bc:	89 d0                	mov    %edx,%eax
  8015be:	eb 18                	jmp    8015d8 <memcmp+0x50>
		s1++, s2++;
  8015c0:	ff 45 fc             	incl   -0x4(%ebp)
  8015c3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015cc:	89 55 10             	mov    %edx,0x10(%ebp)
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	75 c9                	jne    80159c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e6:	01 d0                	add    %edx,%eax
  8015e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015eb:	eb 15                	jmp    801602 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8a 00                	mov    (%eax),%al
  8015f2:	0f b6 d0             	movzbl %al,%edx
  8015f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f8:	0f b6 c0             	movzbl %al,%eax
  8015fb:	39 c2                	cmp    %eax,%edx
  8015fd:	74 0d                	je     80160c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015ff:	ff 45 08             	incl   0x8(%ebp)
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801608:	72 e3                	jb     8015ed <memfind+0x13>
  80160a:	eb 01                	jmp    80160d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80160c:	90                   	nop
	return (void *) s;
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801618:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80161f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801626:	eb 03                	jmp    80162b <strtol+0x19>
		s++;
  801628:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	3c 20                	cmp    $0x20,%al
  801632:	74 f4                	je     801628 <strtol+0x16>
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	8a 00                	mov    (%eax),%al
  801639:	3c 09                	cmp    $0x9,%al
  80163b:	74 eb                	je     801628 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	8a 00                	mov    (%eax),%al
  801642:	3c 2b                	cmp    $0x2b,%al
  801644:	75 05                	jne    80164b <strtol+0x39>
		s++;
  801646:	ff 45 08             	incl   0x8(%ebp)
  801649:	eb 13                	jmp    80165e <strtol+0x4c>
	else if (*s == '-')
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 2d                	cmp    $0x2d,%al
  801652:	75 0a                	jne    80165e <strtol+0x4c>
		s++, neg = 1;
  801654:	ff 45 08             	incl   0x8(%ebp)
  801657:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80165e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801662:	74 06                	je     80166a <strtol+0x58>
  801664:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801668:	75 20                	jne    80168a <strtol+0x78>
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	8a 00                	mov    (%eax),%al
  80166f:	3c 30                	cmp    $0x30,%al
  801671:	75 17                	jne    80168a <strtol+0x78>
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	40                   	inc    %eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	3c 78                	cmp    $0x78,%al
  80167b:	75 0d                	jne    80168a <strtol+0x78>
		s += 2, base = 16;
  80167d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801681:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801688:	eb 28                	jmp    8016b2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80168a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168e:	75 15                	jne    8016a5 <strtol+0x93>
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	3c 30                	cmp    $0x30,%al
  801697:	75 0c                	jne    8016a5 <strtol+0x93>
		s++, base = 8;
  801699:	ff 45 08             	incl   0x8(%ebp)
  80169c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016a3:	eb 0d                	jmp    8016b2 <strtol+0xa0>
	else if (base == 0)
  8016a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a9:	75 07                	jne    8016b2 <strtol+0xa0>
		base = 10;
  8016ab:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8a 00                	mov    (%eax),%al
  8016b7:	3c 2f                	cmp    $0x2f,%al
  8016b9:	7e 19                	jle    8016d4 <strtol+0xc2>
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	3c 39                	cmp    $0x39,%al
  8016c2:	7f 10                	jg     8016d4 <strtol+0xc2>
			dig = *s - '0';
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	8a 00                	mov    (%eax),%al
  8016c9:	0f be c0             	movsbl %al,%eax
  8016cc:	83 e8 30             	sub    $0x30,%eax
  8016cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d2:	eb 42                	jmp    801716 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	8a 00                	mov    (%eax),%al
  8016d9:	3c 60                	cmp    $0x60,%al
  8016db:	7e 19                	jle    8016f6 <strtol+0xe4>
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8a 00                	mov    (%eax),%al
  8016e2:	3c 7a                	cmp    $0x7a,%al
  8016e4:	7f 10                	jg     8016f6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	8a 00                	mov    (%eax),%al
  8016eb:	0f be c0             	movsbl %al,%eax
  8016ee:	83 e8 57             	sub    $0x57,%eax
  8016f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016f4:	eb 20                	jmp    801716 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	3c 40                	cmp    $0x40,%al
  8016fd:	7e 39                	jle    801738 <strtol+0x126>
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	8a 00                	mov    (%eax),%al
  801704:	3c 5a                	cmp    $0x5a,%al
  801706:	7f 30                	jg     801738 <strtol+0x126>
			dig = *s - 'A' + 10;
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	8a 00                	mov    (%eax),%al
  80170d:	0f be c0             	movsbl %al,%eax
  801710:	83 e8 37             	sub    $0x37,%eax
  801713:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801719:	3b 45 10             	cmp    0x10(%ebp),%eax
  80171c:	7d 19                	jge    801737 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80171e:	ff 45 08             	incl   0x8(%ebp)
  801721:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801724:	0f af 45 10          	imul   0x10(%ebp),%eax
  801728:	89 c2                	mov    %eax,%edx
  80172a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172d:	01 d0                	add    %edx,%eax
  80172f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801732:	e9 7b ff ff ff       	jmp    8016b2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801737:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801738:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80173c:	74 08                	je     801746 <strtol+0x134>
		*endptr = (char *) s;
  80173e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801741:	8b 55 08             	mov    0x8(%ebp),%edx
  801744:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801746:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80174a:	74 07                	je     801753 <strtol+0x141>
  80174c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80174f:	f7 d8                	neg    %eax
  801751:	eb 03                	jmp    801756 <strtol+0x144>
  801753:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <ltostr>:

void
ltostr(long value, char *str)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80175e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801765:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80176c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801770:	79 13                	jns    801785 <ltostr+0x2d>
	{
		neg = 1;
  801772:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801779:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80177f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801782:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80178d:	99                   	cltd   
  80178e:	f7 f9                	idiv   %ecx
  801790:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801793:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801796:	8d 50 01             	lea    0x1(%eax),%edx
  801799:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80179c:	89 c2                	mov    %eax,%edx
  80179e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a1:	01 d0                	add    %edx,%eax
  8017a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017a6:	83 c2 30             	add    $0x30,%edx
  8017a9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ae:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017b3:	f7 e9                	imul   %ecx
  8017b5:	c1 fa 02             	sar    $0x2,%edx
  8017b8:	89 c8                	mov    %ecx,%eax
  8017ba:	c1 f8 1f             	sar    $0x1f,%eax
  8017bd:	29 c2                	sub    %eax,%edx
  8017bf:	89 d0                	mov    %edx,%eax
  8017c1:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8017c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017c8:	75 bb                	jne    801785 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d4:	48                   	dec    %eax
  8017d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017dc:	74 3d                	je     80181b <ltostr+0xc3>
		start = 1 ;
  8017de:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017e5:	eb 34                	jmp    80181b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8017e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ed:	01 d0                	add    %edx,%eax
  8017ef:	8a 00                	mov    (%eax),%al
  8017f1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fa:	01 c2                	add    %eax,%edx
  8017fc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801802:	01 c8                	add    %ecx,%eax
  801804:	8a 00                	mov    (%eax),%al
  801806:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801808:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80180b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180e:	01 c2                	add    %eax,%edx
  801810:	8a 45 eb             	mov    -0x15(%ebp),%al
  801813:	88 02                	mov    %al,(%edx)
		start++ ;
  801815:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801818:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801821:	7c c4                	jl     8017e7 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801823:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	01 d0                	add    %edx,%eax
  80182b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80182e:	90                   	nop
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801837:	ff 75 08             	pushl  0x8(%ebp)
  80183a:	e8 73 fa ff ff       	call   8012b2 <strlen>
  80183f:	83 c4 04             	add    $0x4,%esp
  801842:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801845:	ff 75 0c             	pushl  0xc(%ebp)
  801848:	e8 65 fa ff ff       	call   8012b2 <strlen>
  80184d:	83 c4 04             	add    $0x4,%esp
  801850:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801853:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80185a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801861:	eb 17                	jmp    80187a <strcconcat+0x49>
		final[s] = str1[s] ;
  801863:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801866:	8b 45 10             	mov    0x10(%ebp),%eax
  801869:	01 c2                	add    %eax,%edx
  80186b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	01 c8                	add    %ecx,%eax
  801873:	8a 00                	mov    (%eax),%al
  801875:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801877:	ff 45 fc             	incl   -0x4(%ebp)
  80187a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80187d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801880:	7c e1                	jl     801863 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801882:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801889:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801890:	eb 1f                	jmp    8018b1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801892:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801895:	8d 50 01             	lea    0x1(%eax),%edx
  801898:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80189b:	89 c2                	mov    %eax,%edx
  80189d:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a0:	01 c2                	add    %eax,%edx
  8018a2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a8:	01 c8                	add    %ecx,%eax
  8018aa:	8a 00                	mov    (%eax),%al
  8018ac:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018ae:	ff 45 f8             	incl   -0x8(%ebp)
  8018b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018b7:	7c d9                	jl     801892 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bf:	01 d0                	add    %edx,%eax
  8018c1:	c6 00 00             	movb   $0x0,(%eax)
}
  8018c4:	90                   	nop
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8018cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d6:	8b 00                	mov    (%eax),%eax
  8018d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018df:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e2:	01 d0                	add    %edx,%eax
  8018e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018ea:	eb 0c                	jmp    8018f8 <strsplit+0x31>
			*string++ = 0;
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	8d 50 01             	lea    0x1(%eax),%edx
  8018f2:	89 55 08             	mov    %edx,0x8(%ebp)
  8018f5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	8a 00                	mov    (%eax),%al
  8018fd:	84 c0                	test   %al,%al
  8018ff:	74 18                	je     801919 <strsplit+0x52>
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	8a 00                	mov    (%eax),%al
  801906:	0f be c0             	movsbl %al,%eax
  801909:	50                   	push   %eax
  80190a:	ff 75 0c             	pushl  0xc(%ebp)
  80190d:	e8 32 fb ff ff       	call   801444 <strchr>
  801912:	83 c4 08             	add    $0x8,%esp
  801915:	85 c0                	test   %eax,%eax
  801917:	75 d3                	jne    8018ec <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	8a 00                	mov    (%eax),%al
  80191e:	84 c0                	test   %al,%al
  801920:	74 5a                	je     80197c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801922:	8b 45 14             	mov    0x14(%ebp),%eax
  801925:	8b 00                	mov    (%eax),%eax
  801927:	83 f8 0f             	cmp    $0xf,%eax
  80192a:	75 07                	jne    801933 <strsplit+0x6c>
		{
			return 0;
  80192c:	b8 00 00 00 00       	mov    $0x0,%eax
  801931:	eb 66                	jmp    801999 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801933:	8b 45 14             	mov    0x14(%ebp),%eax
  801936:	8b 00                	mov    (%eax),%eax
  801938:	8d 48 01             	lea    0x1(%eax),%ecx
  80193b:	8b 55 14             	mov    0x14(%ebp),%edx
  80193e:	89 0a                	mov    %ecx,(%edx)
  801940:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801947:	8b 45 10             	mov    0x10(%ebp),%eax
  80194a:	01 c2                	add    %eax,%edx
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801951:	eb 03                	jmp    801956 <strsplit+0x8f>
			string++;
  801953:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	84 c0                	test   %al,%al
  80195d:	74 8b                	je     8018ea <strsplit+0x23>
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	8a 00                	mov    (%eax),%al
  801964:	0f be c0             	movsbl %al,%eax
  801967:	50                   	push   %eax
  801968:	ff 75 0c             	pushl  0xc(%ebp)
  80196b:	e8 d4 fa ff ff       	call   801444 <strchr>
  801970:	83 c4 08             	add    $0x8,%esp
  801973:	85 c0                	test   %eax,%eax
  801975:	74 dc                	je     801953 <strsplit+0x8c>
			string++;
	}
  801977:	e9 6e ff ff ff       	jmp    8018ea <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80197c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80197d:	8b 45 14             	mov    0x14(%ebp),%eax
  801980:	8b 00                	mov    (%eax),%eax
  801982:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801989:	8b 45 10             	mov    0x10(%ebp),%eax
  80198c:	01 d0                	add    %edx,%eax
  80198e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801994:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8019a1:	83 ec 04             	sub    $0x4,%esp
  8019a4:	68 1c 2b 80 00       	push   $0x802b1c
  8019a9:	68 3f 01 00 00       	push   $0x13f
  8019ae:	68 3e 2b 80 00       	push   $0x802b3e
  8019b3:	e8 a1 ed ff ff       	call   800759 <_panic>

008019b8 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8019be:	83 ec 0c             	sub    $0xc,%esp
  8019c1:	ff 75 08             	pushl  0x8(%ebp)
  8019c4:	e8 ef 06 00 00       	call   8020b8 <sys_sbrk>
  8019c9:	83 c4 10             	add    $0x10,%esp
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8019d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019d8:	75 07                	jne    8019e1 <malloc+0x13>
  8019da:	b8 00 00 00 00       	mov    $0x0,%eax
  8019df:	eb 14                	jmp    8019f5 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8019e1:	83 ec 04             	sub    $0x4,%esp
  8019e4:	68 4c 2b 80 00       	push   $0x802b4c
  8019e9:	6a 1b                	push   $0x1b
  8019eb:	68 71 2b 80 00       	push   $0x802b71
  8019f0:	e8 64 ed ff ff       	call   800759 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	68 80 2b 80 00       	push   $0x802b80
  801a05:	6a 29                	push   $0x29
  801a07:	68 71 2b 80 00       	push   $0x802b71
  801a0c:	e8 48 ed ff ff       	call   800759 <_panic>

00801a11 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 18             	sub    $0x18,%esp
  801a17:	8b 45 10             	mov    0x10(%ebp),%eax
  801a1a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801a1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a21:	75 07                	jne    801a2a <smalloc+0x19>
  801a23:	b8 00 00 00 00       	mov    $0x0,%eax
  801a28:	eb 14                	jmp    801a3e <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801a2a:	83 ec 04             	sub    $0x4,%esp
  801a2d:	68 a4 2b 80 00       	push   $0x802ba4
  801a32:	6a 38                	push   $0x38
  801a34:	68 71 2b 80 00       	push   $0x802b71
  801a39:	e8 1b ed ff ff       	call   800759 <_panic>
	return NULL;
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	68 cc 2b 80 00       	push   $0x802bcc
  801a4e:	6a 43                	push   $0x43
  801a50:	68 71 2b 80 00       	push   $0x802b71
  801a55:	e8 ff ec ff ff       	call   800759 <_panic>

00801a5a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a60:	83 ec 04             	sub    $0x4,%esp
  801a63:	68 f0 2b 80 00       	push   $0x802bf0
  801a68:	6a 5b                	push   $0x5b
  801a6a:	68 71 2b 80 00       	push   $0x802b71
  801a6f:	e8 e5 ec ff ff       	call   800759 <_panic>

00801a74 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a7a:	83 ec 04             	sub    $0x4,%esp
  801a7d:	68 14 2c 80 00       	push   $0x802c14
  801a82:	6a 72                	push   $0x72
  801a84:	68 71 2b 80 00       	push   $0x802b71
  801a89:	e8 cb ec ff ff       	call   800759 <_panic>

00801a8e <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a94:	83 ec 04             	sub    $0x4,%esp
  801a97:	68 3a 2c 80 00       	push   $0x802c3a
  801a9c:	6a 7e                	push   $0x7e
  801a9e:	68 71 2b 80 00       	push   $0x802b71
  801aa3:	e8 b1 ec ff ff       	call   800759 <_panic>

00801aa8 <shrink>:

}
void shrink(uint32 newSize)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	68 3a 2c 80 00       	push   $0x802c3a
  801ab6:	68 83 00 00 00       	push   $0x83
  801abb:	68 71 2b 80 00       	push   $0x802b71
  801ac0:	e8 94 ec ff ff       	call   800759 <_panic>

00801ac5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	68 3a 2c 80 00       	push   $0x802c3a
  801ad3:	68 88 00 00 00       	push   $0x88
  801ad8:	68 71 2b 80 00       	push   $0x802b71
  801add:	e8 77 ec ff ff       	call   800759 <_panic>

00801ae2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	57                   	push   %edi
  801ae6:	56                   	push   %esi
  801ae7:	53                   	push   %ebx
  801ae8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801af7:	8b 7d 18             	mov    0x18(%ebp),%edi
  801afa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801afd:	cd 30                	int    $0x30
  801aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b05:	83 c4 10             	add    $0x10,%esp
  801b08:	5b                   	pop    %ebx
  801b09:	5e                   	pop    %esi
  801b0a:	5f                   	pop    %edi
  801b0b:	5d                   	pop    %ebp
  801b0c:	c3                   	ret    

00801b0d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	83 ec 04             	sub    $0x4,%esp
  801b13:	8b 45 10             	mov    0x10(%ebp),%eax
  801b16:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b19:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	52                   	push   %edx
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	50                   	push   %eax
  801b29:	6a 00                	push   $0x0
  801b2b:	e8 b2 ff ff ff       	call   801ae2 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	90                   	nop
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 02                	push   $0x2
  801b45:	e8 98 ff ff ff       	call   801ae2 <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 03                	push   $0x3
  801b5e:	e8 7f ff ff ff       	call   801ae2 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	90                   	nop
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 04                	push   $0x4
  801b78:	e8 65 ff ff ff       	call   801ae2 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	90                   	nop
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	52                   	push   %edx
  801b93:	50                   	push   %eax
  801b94:	6a 08                	push   $0x8
  801b96:	e8 47 ff ff ff       	call   801ae2 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	56                   	push   %esi
  801ba4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ba5:	8b 75 18             	mov    0x18(%ebp),%esi
  801ba8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	56                   	push   %esi
  801bb5:	53                   	push   %ebx
  801bb6:	51                   	push   %ecx
  801bb7:	52                   	push   %edx
  801bb8:	50                   	push   %eax
  801bb9:	6a 09                	push   $0x9
  801bbb:	e8 22 ff ff ff       	call   801ae2 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc6:	5b                   	pop    %ebx
  801bc7:	5e                   	pop    %esi
  801bc8:	5d                   	pop    %ebp
  801bc9:	c3                   	ret    

00801bca <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	52                   	push   %edx
  801bda:	50                   	push   %eax
  801bdb:	6a 0a                	push   $0xa
  801bdd:	e8 00 ff ff ff       	call   801ae2 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	ff 75 0c             	pushl  0xc(%ebp)
  801bf3:	ff 75 08             	pushl  0x8(%ebp)
  801bf6:	6a 0b                	push   $0xb
  801bf8:	e8 e5 fe ff ff       	call   801ae2 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 0c                	push   $0xc
  801c11:	e8 cc fe ff ff       	call   801ae2 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 0d                	push   $0xd
  801c2a:	e8 b3 fe ff ff       	call   801ae2 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 0e                	push   $0xe
  801c43:	e8 9a fe ff ff       	call   801ae2 <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 0f                	push   $0xf
  801c5c:	e8 81 fe ff ff       	call   801ae2 <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	ff 75 08             	pushl  0x8(%ebp)
  801c74:	6a 10                	push   $0x10
  801c76:	e8 67 fe ff ff       	call   801ae2 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 11                	push   $0x11
  801c8f:	e8 4e fe ff ff       	call   801ae2 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	90                   	nop
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_cputc>:

void
sys_cputc(const char c)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 04             	sub    $0x4,%esp
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ca6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	50                   	push   %eax
  801cb3:	6a 01                	push   $0x1
  801cb5:	e8 28 fe ff ff       	call   801ae2 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	90                   	nop
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 14                	push   $0x14
  801ccf:	e8 0e fe ff ff       	call   801ae2 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	90                   	nop
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 04             	sub    $0x4,%esp
  801ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ce6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ce9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	6a 00                	push   $0x0
  801cf2:	51                   	push   %ecx
  801cf3:	52                   	push   %edx
  801cf4:	ff 75 0c             	pushl  0xc(%ebp)
  801cf7:	50                   	push   %eax
  801cf8:	6a 15                	push   $0x15
  801cfa:	e8 e3 fd ff ff       	call   801ae2 <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	52                   	push   %edx
  801d14:	50                   	push   %eax
  801d15:	6a 16                	push   $0x16
  801d17:	e8 c6 fd ff ff       	call   801ae2 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	51                   	push   %ecx
  801d32:	52                   	push   %edx
  801d33:	50                   	push   %eax
  801d34:	6a 17                	push   $0x17
  801d36:	e8 a7 fd ff ff       	call   801ae2 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	52                   	push   %edx
  801d50:	50                   	push   %eax
  801d51:	6a 18                	push   $0x18
  801d53:	e8 8a fd ff ff       	call   801ae2 <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	6a 00                	push   $0x0
  801d65:	ff 75 14             	pushl  0x14(%ebp)
  801d68:	ff 75 10             	pushl  0x10(%ebp)
  801d6b:	ff 75 0c             	pushl  0xc(%ebp)
  801d6e:	50                   	push   %eax
  801d6f:	6a 19                	push   $0x19
  801d71:	e8 6c fd ff ff       	call   801ae2 <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	50                   	push   %eax
  801d8a:	6a 1a                	push   $0x1a
  801d8c:	e8 51 fd ff ff       	call   801ae2 <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
}
  801d94:	90                   	nop
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	50                   	push   %eax
  801da6:	6a 1b                	push   $0x1b
  801da8:	e8 35 fd ff ff       	call   801ae2 <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 05                	push   $0x5
  801dc1:	e8 1c fd ff ff       	call   801ae2 <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 06                	push   $0x6
  801dda:	e8 03 fd ff ff       	call   801ae2 <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 07                	push   $0x7
  801df3:	e8 ea fc ff ff       	call   801ae2 <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <sys_exit_env>:


void sys_exit_env(void)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 1c                	push   $0x1c
  801e0c:	e8 d1 fc ff ff       	call   801ae2 <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
}
  801e14:	90                   	nop
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e1d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e20:	8d 50 04             	lea    0x4(%eax),%edx
  801e23:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	52                   	push   %edx
  801e2d:	50                   	push   %eax
  801e2e:	6a 1d                	push   $0x1d
  801e30:	e8 ad fc ff ff       	call   801ae2 <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
	return result;
  801e38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e41:	89 01                	mov    %eax,(%ecx)
  801e43:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	c9                   	leave  
  801e4a:	c2 04 00             	ret    $0x4

00801e4d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	ff 75 10             	pushl  0x10(%ebp)
  801e57:	ff 75 0c             	pushl  0xc(%ebp)
  801e5a:	ff 75 08             	pushl  0x8(%ebp)
  801e5d:	6a 13                	push   $0x13
  801e5f:	e8 7e fc ff ff       	call   801ae2 <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
	return ;
  801e67:	90                   	nop
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_rcr2>:
uint32 sys_rcr2()
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 1e                	push   $0x1e
  801e79:	e8 64 fc ff ff       	call   801ae2 <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 04             	sub    $0x4,%esp
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e8f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	50                   	push   %eax
  801e9c:	6a 1f                	push   $0x1f
  801e9e:	e8 3f fc ff ff       	call   801ae2 <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea6:	90                   	nop
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <rsttst>:
void rsttst()
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 21                	push   $0x21
  801eb8:	e8 25 fc ff ff       	call   801ae2 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec0:	90                   	nop
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 04             	sub    $0x4,%esp
  801ec9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ecc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ecf:	8b 55 18             	mov    0x18(%ebp),%edx
  801ed2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ed6:	52                   	push   %edx
  801ed7:	50                   	push   %eax
  801ed8:	ff 75 10             	pushl  0x10(%ebp)
  801edb:	ff 75 0c             	pushl  0xc(%ebp)
  801ede:	ff 75 08             	pushl  0x8(%ebp)
  801ee1:	6a 20                	push   $0x20
  801ee3:	e8 fa fb ff ff       	call   801ae2 <syscall>
  801ee8:	83 c4 18             	add    $0x18,%esp
	return ;
  801eeb:	90                   	nop
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <chktst>:
void chktst(uint32 n)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	ff 75 08             	pushl  0x8(%ebp)
  801efc:	6a 22                	push   $0x22
  801efe:	e8 df fb ff ff       	call   801ae2 <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
	return ;
  801f06:	90                   	nop
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <inctst>:

void inctst()
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 23                	push   $0x23
  801f18:	e8 c5 fb ff ff       	call   801ae2 <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f20:	90                   	nop
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <gettst>:
uint32 gettst()
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 24                	push   $0x24
  801f32:	e8 ab fb ff ff       	call   801ae2 <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 25                	push   $0x25
  801f4e:	e8 8f fb ff ff       	call   801ae2 <syscall>
  801f53:	83 c4 18             	add    $0x18,%esp
  801f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f59:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f5d:	75 07                	jne    801f66 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f64:	eb 05                	jmp    801f6b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 25                	push   $0x25
  801f7f:	e8 5e fb ff ff       	call   801ae2 <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
  801f87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f8a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f8e:	75 07                	jne    801f97 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f90:	b8 01 00 00 00       	mov    $0x1,%eax
  801f95:	eb 05                	jmp    801f9c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 25                	push   $0x25
  801fb0:	e8 2d fb ff ff       	call   801ae2 <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
  801fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fbb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fbf:	75 07                	jne    801fc8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc6:	eb 05                	jmp    801fcd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 25                	push   $0x25
  801fe1:	e8 fc fa ff ff       	call   801ae2 <syscall>
  801fe6:	83 c4 18             	add    $0x18,%esp
  801fe9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ff0:	75 07                	jne    801ff9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ff2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff7:	eb 05                	jmp    801ffe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ff9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	ff 75 08             	pushl  0x8(%ebp)
  80200e:	6a 26                	push   $0x26
  802010:	e8 cd fa ff ff       	call   801ae2 <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
	return ;
  802018:	90                   	nop
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80201f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802022:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802025:	8b 55 0c             	mov    0xc(%ebp),%edx
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	6a 00                	push   $0x0
  80202d:	53                   	push   %ebx
  80202e:	51                   	push   %ecx
  80202f:	52                   	push   %edx
  802030:	50                   	push   %eax
  802031:	6a 27                	push   $0x27
  802033:	e8 aa fa ff ff       	call   801ae2 <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
}
  80203b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802043:	8b 55 0c             	mov    0xc(%ebp),%edx
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	52                   	push   %edx
  802050:	50                   	push   %eax
  802051:	6a 28                	push   $0x28
  802053:	e8 8a fa ff ff       	call   801ae2 <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802060:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802063:	8b 55 0c             	mov    0xc(%ebp),%edx
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	6a 00                	push   $0x0
  80206b:	51                   	push   %ecx
  80206c:	ff 75 10             	pushl  0x10(%ebp)
  80206f:	52                   	push   %edx
  802070:	50                   	push   %eax
  802071:	6a 29                	push   $0x29
  802073:	e8 6a fa ff ff       	call   801ae2 <syscall>
  802078:	83 c4 18             	add    $0x18,%esp
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	ff 75 10             	pushl  0x10(%ebp)
  802087:	ff 75 0c             	pushl  0xc(%ebp)
  80208a:	ff 75 08             	pushl  0x8(%ebp)
  80208d:	6a 12                	push   $0x12
  80208f:	e8 4e fa ff ff       	call   801ae2 <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
	return ;
  802097:	90                   	nop
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80209d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	52                   	push   %edx
  8020aa:	50                   	push   %eax
  8020ab:	6a 2a                	push   $0x2a
  8020ad:	e8 30 fa ff ff       	call   801ae2 <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
	return;
  8020b5:	90                   	nop
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
  8020bb:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8020be:	83 ec 04             	sub    $0x4,%esp
  8020c1:	68 4a 2c 80 00       	push   $0x802c4a
  8020c6:	68 2e 01 00 00       	push   $0x12e
  8020cb:	68 5e 2c 80 00       	push   $0x802c5e
  8020d0:	e8 84 e6 ff ff       	call   800759 <_panic>

008020d5 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8020db:	83 ec 04             	sub    $0x4,%esp
  8020de:	68 4a 2c 80 00       	push   $0x802c4a
  8020e3:	68 35 01 00 00       	push   $0x135
  8020e8:	68 5e 2c 80 00       	push   $0x802c5e
  8020ed:	e8 67 e6 ff ff       	call   800759 <_panic>

008020f2 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	68 4a 2c 80 00       	push   $0x802c4a
  802100:	68 3b 01 00 00       	push   $0x13b
  802105:	68 5e 2c 80 00       	push   $0x802c5e
  80210a:	e8 4a e6 ff ff       	call   800759 <_panic>
  80210f:	90                   	nop

00802110 <__udivdi3>:
  802110:	55                   	push   %ebp
  802111:	57                   	push   %edi
  802112:	56                   	push   %esi
  802113:	53                   	push   %ebx
  802114:	83 ec 1c             	sub    $0x1c,%esp
  802117:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80211b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80211f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802123:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802127:	89 ca                	mov    %ecx,%edx
  802129:	89 f8                	mov    %edi,%eax
  80212b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80212f:	85 f6                	test   %esi,%esi
  802131:	75 2d                	jne    802160 <__udivdi3+0x50>
  802133:	39 cf                	cmp    %ecx,%edi
  802135:	77 65                	ja     80219c <__udivdi3+0x8c>
  802137:	89 fd                	mov    %edi,%ebp
  802139:	85 ff                	test   %edi,%edi
  80213b:	75 0b                	jne    802148 <__udivdi3+0x38>
  80213d:	b8 01 00 00 00       	mov    $0x1,%eax
  802142:	31 d2                	xor    %edx,%edx
  802144:	f7 f7                	div    %edi
  802146:	89 c5                	mov    %eax,%ebp
  802148:	31 d2                	xor    %edx,%edx
  80214a:	89 c8                	mov    %ecx,%eax
  80214c:	f7 f5                	div    %ebp
  80214e:	89 c1                	mov    %eax,%ecx
  802150:	89 d8                	mov    %ebx,%eax
  802152:	f7 f5                	div    %ebp
  802154:	89 cf                	mov    %ecx,%edi
  802156:	89 fa                	mov    %edi,%edx
  802158:	83 c4 1c             	add    $0x1c,%esp
  80215b:	5b                   	pop    %ebx
  80215c:	5e                   	pop    %esi
  80215d:	5f                   	pop    %edi
  80215e:	5d                   	pop    %ebp
  80215f:	c3                   	ret    
  802160:	39 ce                	cmp    %ecx,%esi
  802162:	77 28                	ja     80218c <__udivdi3+0x7c>
  802164:	0f bd fe             	bsr    %esi,%edi
  802167:	83 f7 1f             	xor    $0x1f,%edi
  80216a:	75 40                	jne    8021ac <__udivdi3+0x9c>
  80216c:	39 ce                	cmp    %ecx,%esi
  80216e:	72 0a                	jb     80217a <__udivdi3+0x6a>
  802170:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802174:	0f 87 9e 00 00 00    	ja     802218 <__udivdi3+0x108>
  80217a:	b8 01 00 00 00       	mov    $0x1,%eax
  80217f:	89 fa                	mov    %edi,%edx
  802181:	83 c4 1c             	add    $0x1c,%esp
  802184:	5b                   	pop    %ebx
  802185:	5e                   	pop    %esi
  802186:	5f                   	pop    %edi
  802187:	5d                   	pop    %ebp
  802188:	c3                   	ret    
  802189:	8d 76 00             	lea    0x0(%esi),%esi
  80218c:	31 ff                	xor    %edi,%edi
  80218e:	31 c0                	xor    %eax,%eax
  802190:	89 fa                	mov    %edi,%edx
  802192:	83 c4 1c             	add    $0x1c,%esp
  802195:	5b                   	pop    %ebx
  802196:	5e                   	pop    %esi
  802197:	5f                   	pop    %edi
  802198:	5d                   	pop    %ebp
  802199:	c3                   	ret    
  80219a:	66 90                	xchg   %ax,%ax
  80219c:	89 d8                	mov    %ebx,%eax
  80219e:	f7 f7                	div    %edi
  8021a0:	31 ff                	xor    %edi,%edi
  8021a2:	89 fa                	mov    %edi,%edx
  8021a4:	83 c4 1c             	add    $0x1c,%esp
  8021a7:	5b                   	pop    %ebx
  8021a8:	5e                   	pop    %esi
  8021a9:	5f                   	pop    %edi
  8021aa:	5d                   	pop    %ebp
  8021ab:	c3                   	ret    
  8021ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8021b1:	89 eb                	mov    %ebp,%ebx
  8021b3:	29 fb                	sub    %edi,%ebx
  8021b5:	89 f9                	mov    %edi,%ecx
  8021b7:	d3 e6                	shl    %cl,%esi
  8021b9:	89 c5                	mov    %eax,%ebp
  8021bb:	88 d9                	mov    %bl,%cl
  8021bd:	d3 ed                	shr    %cl,%ebp
  8021bf:	89 e9                	mov    %ebp,%ecx
  8021c1:	09 f1                	or     %esi,%ecx
  8021c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021c7:	89 f9                	mov    %edi,%ecx
  8021c9:	d3 e0                	shl    %cl,%eax
  8021cb:	89 c5                	mov    %eax,%ebp
  8021cd:	89 d6                	mov    %edx,%esi
  8021cf:	88 d9                	mov    %bl,%cl
  8021d1:	d3 ee                	shr    %cl,%esi
  8021d3:	89 f9                	mov    %edi,%ecx
  8021d5:	d3 e2                	shl    %cl,%edx
  8021d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021db:	88 d9                	mov    %bl,%cl
  8021dd:	d3 e8                	shr    %cl,%eax
  8021df:	09 c2                	or     %eax,%edx
  8021e1:	89 d0                	mov    %edx,%eax
  8021e3:	89 f2                	mov    %esi,%edx
  8021e5:	f7 74 24 0c          	divl   0xc(%esp)
  8021e9:	89 d6                	mov    %edx,%esi
  8021eb:	89 c3                	mov    %eax,%ebx
  8021ed:	f7 e5                	mul    %ebp
  8021ef:	39 d6                	cmp    %edx,%esi
  8021f1:	72 19                	jb     80220c <__udivdi3+0xfc>
  8021f3:	74 0b                	je     802200 <__udivdi3+0xf0>
  8021f5:	89 d8                	mov    %ebx,%eax
  8021f7:	31 ff                	xor    %edi,%edi
  8021f9:	e9 58 ff ff ff       	jmp    802156 <__udivdi3+0x46>
  8021fe:	66 90                	xchg   %ax,%ax
  802200:	8b 54 24 08          	mov    0x8(%esp),%edx
  802204:	89 f9                	mov    %edi,%ecx
  802206:	d3 e2                	shl    %cl,%edx
  802208:	39 c2                	cmp    %eax,%edx
  80220a:	73 e9                	jae    8021f5 <__udivdi3+0xe5>
  80220c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80220f:	31 ff                	xor    %edi,%edi
  802211:	e9 40 ff ff ff       	jmp    802156 <__udivdi3+0x46>
  802216:	66 90                	xchg   %ax,%ax
  802218:	31 c0                	xor    %eax,%eax
  80221a:	e9 37 ff ff ff       	jmp    802156 <__udivdi3+0x46>
  80221f:	90                   	nop

00802220 <__umoddi3>:
  802220:	55                   	push   %ebp
  802221:	57                   	push   %edi
  802222:	56                   	push   %esi
  802223:	53                   	push   %ebx
  802224:	83 ec 1c             	sub    $0x1c,%esp
  802227:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80222b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80222f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802233:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802237:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80223b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80223f:	89 f3                	mov    %esi,%ebx
  802241:	89 fa                	mov    %edi,%edx
  802243:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802247:	89 34 24             	mov    %esi,(%esp)
  80224a:	85 c0                	test   %eax,%eax
  80224c:	75 1a                	jne    802268 <__umoddi3+0x48>
  80224e:	39 f7                	cmp    %esi,%edi
  802250:	0f 86 a2 00 00 00    	jbe    8022f8 <__umoddi3+0xd8>
  802256:	89 c8                	mov    %ecx,%eax
  802258:	89 f2                	mov    %esi,%edx
  80225a:	f7 f7                	div    %edi
  80225c:	89 d0                	mov    %edx,%eax
  80225e:	31 d2                	xor    %edx,%edx
  802260:	83 c4 1c             	add    $0x1c,%esp
  802263:	5b                   	pop    %ebx
  802264:	5e                   	pop    %esi
  802265:	5f                   	pop    %edi
  802266:	5d                   	pop    %ebp
  802267:	c3                   	ret    
  802268:	39 f0                	cmp    %esi,%eax
  80226a:	0f 87 ac 00 00 00    	ja     80231c <__umoddi3+0xfc>
  802270:	0f bd e8             	bsr    %eax,%ebp
  802273:	83 f5 1f             	xor    $0x1f,%ebp
  802276:	0f 84 ac 00 00 00    	je     802328 <__umoddi3+0x108>
  80227c:	bf 20 00 00 00       	mov    $0x20,%edi
  802281:	29 ef                	sub    %ebp,%edi
  802283:	89 fe                	mov    %edi,%esi
  802285:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802289:	89 e9                	mov    %ebp,%ecx
  80228b:	d3 e0                	shl    %cl,%eax
  80228d:	89 d7                	mov    %edx,%edi
  80228f:	89 f1                	mov    %esi,%ecx
  802291:	d3 ef                	shr    %cl,%edi
  802293:	09 c7                	or     %eax,%edi
  802295:	89 e9                	mov    %ebp,%ecx
  802297:	d3 e2                	shl    %cl,%edx
  802299:	89 14 24             	mov    %edx,(%esp)
  80229c:	89 d8                	mov    %ebx,%eax
  80229e:	d3 e0                	shl    %cl,%eax
  8022a0:	89 c2                	mov    %eax,%edx
  8022a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022a6:	d3 e0                	shl    %cl,%eax
  8022a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022b0:	89 f1                	mov    %esi,%ecx
  8022b2:	d3 e8                	shr    %cl,%eax
  8022b4:	09 d0                	or     %edx,%eax
  8022b6:	d3 eb                	shr    %cl,%ebx
  8022b8:	89 da                	mov    %ebx,%edx
  8022ba:	f7 f7                	div    %edi
  8022bc:	89 d3                	mov    %edx,%ebx
  8022be:	f7 24 24             	mull   (%esp)
  8022c1:	89 c6                	mov    %eax,%esi
  8022c3:	89 d1                	mov    %edx,%ecx
  8022c5:	39 d3                	cmp    %edx,%ebx
  8022c7:	0f 82 87 00 00 00    	jb     802354 <__umoddi3+0x134>
  8022cd:	0f 84 91 00 00 00    	je     802364 <__umoddi3+0x144>
  8022d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022d7:	29 f2                	sub    %esi,%edx
  8022d9:	19 cb                	sbb    %ecx,%ebx
  8022db:	89 d8                	mov    %ebx,%eax
  8022dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022e1:	d3 e0                	shl    %cl,%eax
  8022e3:	89 e9                	mov    %ebp,%ecx
  8022e5:	d3 ea                	shr    %cl,%edx
  8022e7:	09 d0                	or     %edx,%eax
  8022e9:	89 e9                	mov    %ebp,%ecx
  8022eb:	d3 eb                	shr    %cl,%ebx
  8022ed:	89 da                	mov    %ebx,%edx
  8022ef:	83 c4 1c             	add    $0x1c,%esp
  8022f2:	5b                   	pop    %ebx
  8022f3:	5e                   	pop    %esi
  8022f4:	5f                   	pop    %edi
  8022f5:	5d                   	pop    %ebp
  8022f6:	c3                   	ret    
  8022f7:	90                   	nop
  8022f8:	89 fd                	mov    %edi,%ebp
  8022fa:	85 ff                	test   %edi,%edi
  8022fc:	75 0b                	jne    802309 <__umoddi3+0xe9>
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	31 d2                	xor    %edx,%edx
  802305:	f7 f7                	div    %edi
  802307:	89 c5                	mov    %eax,%ebp
  802309:	89 f0                	mov    %esi,%eax
  80230b:	31 d2                	xor    %edx,%edx
  80230d:	f7 f5                	div    %ebp
  80230f:	89 c8                	mov    %ecx,%eax
  802311:	f7 f5                	div    %ebp
  802313:	89 d0                	mov    %edx,%eax
  802315:	e9 44 ff ff ff       	jmp    80225e <__umoddi3+0x3e>
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	89 c8                	mov    %ecx,%eax
  80231e:	89 f2                	mov    %esi,%edx
  802320:	83 c4 1c             	add    $0x1c,%esp
  802323:	5b                   	pop    %ebx
  802324:	5e                   	pop    %esi
  802325:	5f                   	pop    %edi
  802326:	5d                   	pop    %ebp
  802327:	c3                   	ret    
  802328:	3b 04 24             	cmp    (%esp),%eax
  80232b:	72 06                	jb     802333 <__umoddi3+0x113>
  80232d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802331:	77 0f                	ja     802342 <__umoddi3+0x122>
  802333:	89 f2                	mov    %esi,%edx
  802335:	29 f9                	sub    %edi,%ecx
  802337:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80233b:	89 14 24             	mov    %edx,(%esp)
  80233e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802342:	8b 44 24 04          	mov    0x4(%esp),%eax
  802346:	8b 14 24             	mov    (%esp),%edx
  802349:	83 c4 1c             	add    $0x1c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	8d 76 00             	lea    0x0(%esi),%esi
  802354:	2b 04 24             	sub    (%esp),%eax
  802357:	19 fa                	sbb    %edi,%edx
  802359:	89 d1                	mov    %edx,%ecx
  80235b:	89 c6                	mov    %eax,%esi
  80235d:	e9 71 ff ff ff       	jmp    8022d3 <__umoddi3+0xb3>
  802362:	66 90                	xchg   %ax,%ax
  802364:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802368:	72 ea                	jb     802354 <__umoddi3+0x134>
  80236a:	89 d9                	mov    %ebx,%ecx
  80236c:	e9 62 ff ff ff       	jmp    8022d3 <__umoddi3+0xb3>
