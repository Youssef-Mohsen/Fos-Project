
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
  800041:	e8 f3 1a 00 00       	call   801b39 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 23 80 00       	push   $0x802360
  80004e:	e8 ad 09 00 00       	call   800a00 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 23 80 00       	push   $0x802362
  80005e:	e8 9d 09 00 00       	call   800a00 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 7b 23 80 00       	push   $0x80237b
  80006e:	e8 8d 09 00 00       	call   800a00 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 23 80 00       	push   $0x802362
  80007e:	e8 7d 09 00 00       	call   800a00 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 23 80 00       	push   $0x802360
  80008e:	e8 6d 09 00 00       	call   800a00 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 94 23 80 00       	push   $0x802394
  8000a5:	e8 ea 0f 00 00       	call   801094 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 3c 15 00 00       	call   8015fc <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 b4 23 80 00       	push   $0x8023b4
  8000ce:	e8 2d 09 00 00       	call   800a00 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 d6 23 80 00       	push   $0x8023d6
  8000de:	e8 1d 09 00 00       	call   800a00 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 e4 23 80 00       	push   $0x8023e4
  8000ee:	e8 0d 09 00 00       	call   800a00 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 f3 23 80 00       	push   $0x8023f3
  8000fe:	e8 fd 08 00 00       	call   800a00 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 03 24 80 00       	push   $0x802403
  80010e:	e8 ed 08 00 00       	call   800a00 <cprintf>
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
  80014d:	e8 01 1a 00 00       	call   801b53 <sys_unlock_cons>
		//sys_unlock_cons();

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 57 18 00 00       	call   8019b8 <malloc>
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
  8001d5:	e8 5f 19 00 00       	call   801b39 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 0c 24 80 00       	push   $0x80240c
  8001e2:	e8 19 08 00 00       	call   800a00 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 64 19 00 00       	call   801b53 <sys_unlock_cons>
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
  80020c:	68 40 24 80 00       	push   $0x802440
  800211:	6a 54                	push   $0x54
  800213:	68 62 24 80 00       	push   $0x802462
  800218:	e8 26 05 00 00       	call   800743 <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 17 19 00 00       	call   801b39 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 80 24 80 00       	push   $0x802480
  80022a:	e8 d1 07 00 00       	call   800a00 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 b4 24 80 00       	push   $0x8024b4
  80023a:	e8 c1 07 00 00       	call   800a00 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 e8 24 80 00       	push   $0x8024e8
  80024a:	e8 b1 07 00 00       	call   800a00 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 fc 18 00 00       	call   801b53 <sys_unlock_cons>
			//			sys_unlock_cons();


		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 ec             	pushl  -0x14(%ebp)
  80025d:	e8 7f 17 00 00       	call   8019e1 <free>
  800262:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
  800265:	e8 cf 18 00 00       	call   801b39 <sys_lock_cons>
		{
			Chose = 0 ;
  80026a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  80026e:	eb 42                	jmp    8002b2 <_main+0x27a>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 1a 25 80 00       	push   $0x80251a
  800278:	e8 83 07 00 00       	call   800a00 <cprintf>
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
  8002be:	e8 90 18 00 00       	call   801b53 <sys_unlock_cons>
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
  800570:	68 60 23 80 00       	push   $0x802360
  800575:	e8 86 04 00 00       	call   800a00 <cprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80057d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800580:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	01 d0                	add    %edx,%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	50                   	push   %eax
  800592:	68 38 25 80 00       	push   $0x802538
  800597:	e8 64 04 00 00       	call   800a00 <cprintf>
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
  8005c0:	68 3d 25 80 00       	push   $0x80253d
  8005c5:	e8 36 04 00 00       	call   800a00 <cprintf>
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
  8005e4:	e8 9b 16 00 00       	call   801c84 <sys_cputc>
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
  8005f5:	e8 26 15 00 00       	call   801b20 <sys_cgetc>
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
  800612:	e8 9e 17 00 00       	call   801db5 <sys_getenvindex>
  800617:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80061a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061d:	89 d0                	mov    %edx,%eax
  80061f:	c1 e0 02             	shl    $0x2,%eax
  800622:	01 d0                	add    %edx,%eax
  800624:	01 c0                	add    %eax,%eax
  800626:	01 d0                	add    %edx,%eax
  800628:	c1 e0 02             	shl    $0x2,%eax
  80062b:	01 d0                	add    %edx,%eax
  80062d:	01 c0                	add    %eax,%eax
  80062f:	01 d0                	add    %edx,%eax
  800631:	c1 e0 04             	shl    $0x4,%eax
  800634:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800639:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80063e:	a1 08 30 80 00       	mov    0x803008,%eax
  800643:	8a 40 20             	mov    0x20(%eax),%al
  800646:	84 c0                	test   %al,%al
  800648:	74 0d                	je     800657 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80064a:	a1 08 30 80 00       	mov    0x803008,%eax
  80064f:	83 c0 20             	add    $0x20,%eax
  800652:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800657:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80065b:	7e 0a                	jle    800667 <libmain+0x5b>
		binaryname = argv[0];
  80065d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 0c             	pushl  0xc(%ebp)
  80066d:	ff 75 08             	pushl  0x8(%ebp)
  800670:	e8 c3 f9 ff ff       	call   800038 <_main>
  800675:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800678:	e8 bc 14 00 00       	call   801b39 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80067d:	83 ec 0c             	sub    $0xc,%esp
  800680:	68 5c 25 80 00       	push   $0x80255c
  800685:	e8 76 03 00 00       	call   800a00 <cprintf>
  80068a:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80068d:	a1 08 30 80 00       	mov    0x803008,%eax
  800692:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800698:	a1 08 30 80 00       	mov    0x803008,%eax
  80069d:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8006a3:	83 ec 04             	sub    $0x4,%esp
  8006a6:	52                   	push   %edx
  8006a7:	50                   	push   %eax
  8006a8:	68 84 25 80 00       	push   $0x802584
  8006ad:	e8 4e 03 00 00       	call   800a00 <cprintf>
  8006b2:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006b5:	a1 08 30 80 00       	mov    0x803008,%eax
  8006ba:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8006c0:	a1 08 30 80 00       	mov    0x803008,%eax
  8006c5:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8006cb:	a1 08 30 80 00       	mov    0x803008,%eax
  8006d0:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8006d6:	51                   	push   %ecx
  8006d7:	52                   	push   %edx
  8006d8:	50                   	push   %eax
  8006d9:	68 ac 25 80 00       	push   $0x8025ac
  8006de:	e8 1d 03 00 00       	call   800a00 <cprintf>
  8006e3:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006e6:	a1 08 30 80 00       	mov    0x803008,%eax
  8006eb:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	50                   	push   %eax
  8006f5:	68 04 26 80 00       	push   $0x802604
  8006fa:	e8 01 03 00 00       	call   800a00 <cprintf>
  8006ff:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800702:	83 ec 0c             	sub    $0xc,%esp
  800705:	68 5c 25 80 00       	push   $0x80255c
  80070a:	e8 f1 02 00 00       	call   800a00 <cprintf>
  80070f:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800712:	e8 3c 14 00 00       	call   801b53 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800717:	e8 19 00 00 00       	call   800735 <exit>
}
  80071c:	90                   	nop
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	6a 00                	push   $0x0
  80072a:	e8 52 16 00 00       	call   801d81 <sys_destroy_env>
  80072f:	83 c4 10             	add    $0x10,%esp
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <exit>:

void
exit(void)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80073b:	e8 a7 16 00 00       	call   801de7 <sys_exit_env>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800749:	8d 45 10             	lea    0x10(%ebp),%eax
  80074c:	83 c0 04             	add    $0x4,%eax
  80074f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800752:	a1 30 30 80 00       	mov    0x803030,%eax
  800757:	85 c0                	test   %eax,%eax
  800759:	74 16                	je     800771 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80075b:	a1 30 30 80 00       	mov    0x803030,%eax
  800760:	83 ec 08             	sub    $0x8,%esp
  800763:	50                   	push   %eax
  800764:	68 18 26 80 00       	push   $0x802618
  800769:	e8 92 02 00 00       	call   800a00 <cprintf>
  80076e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800771:	a1 00 30 80 00       	mov    0x803000,%eax
  800776:	ff 75 0c             	pushl  0xc(%ebp)
  800779:	ff 75 08             	pushl  0x8(%ebp)
  80077c:	50                   	push   %eax
  80077d:	68 1d 26 80 00       	push   $0x80261d
  800782:	e8 79 02 00 00       	call   800a00 <cprintf>
  800787:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80078a:	8b 45 10             	mov    0x10(%ebp),%eax
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 f4             	pushl  -0xc(%ebp)
  800793:	50                   	push   %eax
  800794:	e8 fc 01 00 00       	call   800995 <vcprintf>
  800799:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	6a 00                	push   $0x0
  8007a1:	68 39 26 80 00       	push   $0x802639
  8007a6:	e8 ea 01 00 00       	call   800995 <vcprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007ae:	e8 82 ff ff ff       	call   800735 <exit>

	// should not return here
	while (1) ;
  8007b3:	eb fe                	jmp    8007b3 <_panic+0x70>

008007b5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007bb:	a1 08 30 80 00       	mov    0x803008,%eax
  8007c0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8007c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c9:	39 c2                	cmp    %eax,%edx
  8007cb:	74 14                	je     8007e1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007cd:	83 ec 04             	sub    $0x4,%esp
  8007d0:	68 3c 26 80 00       	push   $0x80263c
  8007d5:	6a 26                	push   $0x26
  8007d7:	68 88 26 80 00       	push   $0x802688
  8007dc:	e8 62 ff ff ff       	call   800743 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007ef:	e9 c5 00 00 00       	jmp    8008b9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8007f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	01 d0                	add    %edx,%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	85 c0                	test   %eax,%eax
  800807:	75 08                	jne    800811 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800809:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80080c:	e9 a5 00 00 00       	jmp    8008b6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800811:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800818:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80081f:	eb 69                	jmp    80088a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800821:	a1 08 30 80 00       	mov    0x803008,%eax
  800826:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80082c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082f:	89 d0                	mov    %edx,%eax
  800831:	01 c0                	add    %eax,%eax
  800833:	01 d0                	add    %edx,%eax
  800835:	c1 e0 03             	shl    $0x3,%eax
  800838:	01 c8                	add    %ecx,%eax
  80083a:	8a 40 04             	mov    0x4(%eax),%al
  80083d:	84 c0                	test   %al,%al
  80083f:	75 46                	jne    800887 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800841:	a1 08 30 80 00       	mov    0x803008,%eax
  800846:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80084c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80084f:	89 d0                	mov    %edx,%eax
  800851:	01 c0                	add    %eax,%eax
  800853:	01 d0                	add    %edx,%eax
  800855:	c1 e0 03             	shl    $0x3,%eax
  800858:	01 c8                	add    %ecx,%eax
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80085f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800862:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800867:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	01 c8                	add    %ecx,%eax
  800878:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80087a:	39 c2                	cmp    %eax,%edx
  80087c:	75 09                	jne    800887 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80087e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800885:	eb 15                	jmp    80089c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800887:	ff 45 e8             	incl   -0x18(%ebp)
  80088a:	a1 08 30 80 00       	mov    0x803008,%eax
  80088f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800895:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800898:	39 c2                	cmp    %eax,%edx
  80089a:	77 85                	ja     800821 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80089c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008a0:	75 14                	jne    8008b6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8008a2:	83 ec 04             	sub    $0x4,%esp
  8008a5:	68 94 26 80 00       	push   $0x802694
  8008aa:	6a 3a                	push   $0x3a
  8008ac:	68 88 26 80 00       	push   $0x802688
  8008b1:	e8 8d fe ff ff       	call   800743 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008b6:	ff 45 f0             	incl   -0x10(%ebp)
  8008b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008bf:	0f 8c 2f ff ff ff    	jl     8007f4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008d3:	eb 26                	jmp    8008fb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008d5:	a1 08 30 80 00       	mov    0x803008,%eax
  8008da:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8008e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008e3:	89 d0                	mov    %edx,%eax
  8008e5:	01 c0                	add    %eax,%eax
  8008e7:	01 d0                	add    %edx,%eax
  8008e9:	c1 e0 03             	shl    $0x3,%eax
  8008ec:	01 c8                	add    %ecx,%eax
  8008ee:	8a 40 04             	mov    0x4(%eax),%al
  8008f1:	3c 01                	cmp    $0x1,%al
  8008f3:	75 03                	jne    8008f8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8008f5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008f8:	ff 45 e0             	incl   -0x20(%ebp)
  8008fb:	a1 08 30 80 00       	mov    0x803008,%eax
  800900:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800906:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800909:	39 c2                	cmp    %eax,%edx
  80090b:	77 c8                	ja     8008d5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80090d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800910:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800913:	74 14                	je     800929 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	68 e8 26 80 00       	push   $0x8026e8
  80091d:	6a 44                	push   $0x44
  80091f:	68 88 26 80 00       	push   $0x802688
  800924:	e8 1a fe ff ff       	call   800743 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800929:	90                   	nop
  80092a:	c9                   	leave  
  80092b:	c3                   	ret    

0080092c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	8d 48 01             	lea    0x1(%eax),%ecx
  80093a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093d:	89 0a                	mov    %ecx,(%edx)
  80093f:	8b 55 08             	mov    0x8(%ebp),%edx
  800942:	88 d1                	mov    %dl,%cl
  800944:	8b 55 0c             	mov    0xc(%ebp),%edx
  800947:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80094b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	3d ff 00 00 00       	cmp    $0xff,%eax
  800955:	75 2c                	jne    800983 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800957:	a0 0c 30 80 00       	mov    0x80300c,%al
  80095c:	0f b6 c0             	movzbl %al,%eax
  80095f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800962:	8b 12                	mov    (%edx),%edx
  800964:	89 d1                	mov    %edx,%ecx
  800966:	8b 55 0c             	mov    0xc(%ebp),%edx
  800969:	83 c2 08             	add    $0x8,%edx
  80096c:	83 ec 04             	sub    $0x4,%esp
  80096f:	50                   	push   %eax
  800970:	51                   	push   %ecx
  800971:	52                   	push   %edx
  800972:	e8 80 11 00 00       	call   801af7 <sys_cputs>
  800977:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80097a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800983:	8b 45 0c             	mov    0xc(%ebp),%eax
  800986:	8b 40 04             	mov    0x4(%eax),%eax
  800989:	8d 50 01             	lea    0x1(%eax),%edx
  80098c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800992:	90                   	nop
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80099e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009a5:	00 00 00 
	b.cnt = 0;
  8009a8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009af:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	ff 75 08             	pushl  0x8(%ebp)
  8009b8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009be:	50                   	push   %eax
  8009bf:	68 2c 09 80 00       	push   $0x80092c
  8009c4:	e8 11 02 00 00       	call   800bda <vprintfmt>
  8009c9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009cc:	a0 0c 30 80 00       	mov    0x80300c,%al
  8009d1:	0f b6 c0             	movzbl %al,%eax
  8009d4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009da:	83 ec 04             	sub    $0x4,%esp
  8009dd:	50                   	push   %eax
  8009de:	52                   	push   %edx
  8009df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009e5:	83 c0 08             	add    $0x8,%eax
  8009e8:	50                   	push   %eax
  8009e9:	e8 09 11 00 00       	call   801af7 <sys_cputs>
  8009ee:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009f1:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  8009f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    

00800a00 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a06:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800a0d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1c:	50                   	push   %eax
  800a1d:	e8 73 ff ff ff       	call   800995 <vcprintf>
  800a22:	83 c4 10             	add    $0x10,%esp
  800a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2b:	c9                   	leave  
  800a2c:	c3                   	ret    

00800a2d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a33:	e8 01 11 00 00       	call   801b39 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a38:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	83 ec 08             	sub    $0x8,%esp
  800a44:	ff 75 f4             	pushl  -0xc(%ebp)
  800a47:	50                   	push   %eax
  800a48:	e8 48 ff ff ff       	call   800995 <vcprintf>
  800a4d:	83 c4 10             	add    $0x10,%esp
  800a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a53:	e8 fb 10 00 00       	call   801b53 <sys_unlock_cons>
	return cnt;
  800a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5b:	c9                   	leave  
  800a5c:	c3                   	ret    

00800a5d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	53                   	push   %ebx
  800a61:	83 ec 14             	sub    $0x14,%esp
  800a64:	8b 45 10             	mov    0x10(%ebp),%eax
  800a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a70:	8b 45 18             	mov    0x18(%ebp),%eax
  800a73:	ba 00 00 00 00       	mov    $0x0,%edx
  800a78:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a7b:	77 55                	ja     800ad2 <printnum+0x75>
  800a7d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a80:	72 05                	jb     800a87 <printnum+0x2a>
  800a82:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a85:	77 4b                	ja     800ad2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a87:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a8a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a8d:	8b 45 18             	mov    0x18(%ebp),%eax
  800a90:	ba 00 00 00 00       	mov    $0x0,%edx
  800a95:	52                   	push   %edx
  800a96:	50                   	push   %eax
  800a97:	ff 75 f4             	pushl  -0xc(%ebp)
  800a9a:	ff 75 f0             	pushl  -0x10(%ebp)
  800a9d:	e8 56 16 00 00       	call   8020f8 <__udivdi3>
  800aa2:	83 c4 10             	add    $0x10,%esp
  800aa5:	83 ec 04             	sub    $0x4,%esp
  800aa8:	ff 75 20             	pushl  0x20(%ebp)
  800aab:	53                   	push   %ebx
  800aac:	ff 75 18             	pushl  0x18(%ebp)
  800aaf:	52                   	push   %edx
  800ab0:	50                   	push   %eax
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	ff 75 08             	pushl  0x8(%ebp)
  800ab7:	e8 a1 ff ff ff       	call   800a5d <printnum>
  800abc:	83 c4 20             	add    $0x20,%esp
  800abf:	eb 1a                	jmp    800adb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 20             	pushl  0x20(%ebp)
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	ff d0                	call   *%eax
  800acf:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ad2:	ff 4d 1c             	decl   0x1c(%ebp)
  800ad5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ad9:	7f e6                	jg     800ac1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800adb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ade:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae9:	53                   	push   %ebx
  800aea:	51                   	push   %ecx
  800aeb:	52                   	push   %edx
  800aec:	50                   	push   %eax
  800aed:	e8 16 17 00 00       	call   802208 <__umoddi3>
  800af2:	83 c4 10             	add    $0x10,%esp
  800af5:	05 54 29 80 00       	add    $0x802954,%eax
  800afa:	8a 00                	mov    (%eax),%al
  800afc:	0f be c0             	movsbl %al,%eax
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	50                   	push   %eax
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	ff d0                	call   *%eax
  800b0b:	83 c4 10             	add    $0x10,%esp
}
  800b0e:	90                   	nop
  800b0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b12:	c9                   	leave  
  800b13:	c3                   	ret    

00800b14 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b17:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b1b:	7e 1c                	jle    800b39 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8b 00                	mov    (%eax),%eax
  800b22:	8d 50 08             	lea    0x8(%eax),%edx
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	89 10                	mov    %edx,(%eax)
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	83 e8 08             	sub    $0x8,%eax
  800b32:	8b 50 04             	mov    0x4(%eax),%edx
  800b35:	8b 00                	mov    (%eax),%eax
  800b37:	eb 40                	jmp    800b79 <getuint+0x65>
	else if (lflag)
  800b39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3d:	74 1e                	je     800b5d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	8d 50 04             	lea    0x4(%eax),%edx
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	89 10                	mov    %edx,(%eax)
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 00                	mov    (%eax),%eax
  800b51:	83 e8 04             	sub    $0x4,%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5b:	eb 1c                	jmp    800b79 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	8b 00                	mov    (%eax),%eax
  800b62:	8d 50 04             	lea    0x4(%eax),%edx
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	89 10                	mov    %edx,(%eax)
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	83 e8 04             	sub    $0x4,%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b7e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b82:	7e 1c                	jle    800ba0 <getint+0x25>
		return va_arg(*ap, long long);
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 00                	mov    (%eax),%eax
  800b89:	8d 50 08             	lea    0x8(%eax),%edx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	89 10                	mov    %edx,(%eax)
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	83 e8 08             	sub    $0x8,%eax
  800b99:	8b 50 04             	mov    0x4(%eax),%edx
  800b9c:	8b 00                	mov    (%eax),%eax
  800b9e:	eb 38                	jmp    800bd8 <getint+0x5d>
	else if (lflag)
  800ba0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba4:	74 1a                	je     800bc0 <getint+0x45>
		return va_arg(*ap, long);
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	8d 50 04             	lea    0x4(%eax),%edx
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	89 10                	mov    %edx,(%eax)
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	83 e8 04             	sub    $0x4,%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	99                   	cltd   
  800bbe:	eb 18                	jmp    800bd8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	8d 50 04             	lea    0x4(%eax),%edx
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	89 10                	mov    %edx,(%eax)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	83 e8 04             	sub    $0x4,%eax
  800bd5:	8b 00                	mov    (%eax),%eax
  800bd7:	99                   	cltd   
}
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	56                   	push   %esi
  800bde:	53                   	push   %ebx
  800bdf:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800be2:	eb 17                	jmp    800bfb <vprintfmt+0x21>
			if (ch == '\0')
  800be4:	85 db                	test   %ebx,%ebx
  800be6:	0f 84 c1 03 00 00    	je     800fad <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800bec:	83 ec 08             	sub    $0x8,%esp
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	53                   	push   %ebx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	ff d0                	call   *%eax
  800bf8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfe:	8d 50 01             	lea    0x1(%eax),%edx
  800c01:	89 55 10             	mov    %edx,0x10(%ebp)
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	0f b6 d8             	movzbl %al,%ebx
  800c09:	83 fb 25             	cmp    $0x25,%ebx
  800c0c:	75 d6                	jne    800be4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c0e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c12:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c19:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c20:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c27:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	8d 50 01             	lea    0x1(%eax),%edx
  800c34:	89 55 10             	mov    %edx,0x10(%ebp)
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	0f b6 d8             	movzbl %al,%ebx
  800c3c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c3f:	83 f8 5b             	cmp    $0x5b,%eax
  800c42:	0f 87 3d 03 00 00    	ja     800f85 <vprintfmt+0x3ab>
  800c48:	8b 04 85 78 29 80 00 	mov    0x802978(,%eax,4),%eax
  800c4f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c51:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c55:	eb d7                	jmp    800c2e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c57:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c5b:	eb d1                	jmp    800c2e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c5d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c67:	89 d0                	mov    %edx,%eax
  800c69:	c1 e0 02             	shl    $0x2,%eax
  800c6c:	01 d0                	add    %edx,%eax
  800c6e:	01 c0                	add    %eax,%eax
  800c70:	01 d8                	add    %ebx,%eax
  800c72:	83 e8 30             	sub    $0x30,%eax
  800c75:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c78:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7b:	8a 00                	mov    (%eax),%al
  800c7d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c80:	83 fb 2f             	cmp    $0x2f,%ebx
  800c83:	7e 3e                	jle    800cc3 <vprintfmt+0xe9>
  800c85:	83 fb 39             	cmp    $0x39,%ebx
  800c88:	7f 39                	jg     800cc3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c8a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c8d:	eb d5                	jmp    800c64 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c92:	83 c0 04             	add    $0x4,%eax
  800c95:	89 45 14             	mov    %eax,0x14(%ebp)
  800c98:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9b:	83 e8 04             	sub    $0x4,%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ca3:	eb 1f                	jmp    800cc4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ca5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca9:	79 83                	jns    800c2e <vprintfmt+0x54>
				width = 0;
  800cab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cb2:	e9 77 ff ff ff       	jmp    800c2e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cb7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cbe:	e9 6b ff ff ff       	jmp    800c2e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cc3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cc8:	0f 89 60 ff ff ff    	jns    800c2e <vprintfmt+0x54>
				width = precision, precision = -1;
  800cce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cd4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cdb:	e9 4e ff ff ff       	jmp    800c2e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ce0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ce3:	e9 46 ff ff ff       	jmp    800c2e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ceb:	83 c0 04             	add    $0x4,%eax
  800cee:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf1:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf4:	83 e8 04             	sub    $0x4,%eax
  800cf7:	8b 00                	mov    (%eax),%eax
  800cf9:	83 ec 08             	sub    $0x8,%esp
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	50                   	push   %eax
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	ff d0                	call   *%eax
  800d05:	83 c4 10             	add    $0x10,%esp
			break;
  800d08:	e9 9b 02 00 00       	jmp    800fa8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d10:	83 c0 04             	add    $0x4,%eax
  800d13:	89 45 14             	mov    %eax,0x14(%ebp)
  800d16:	8b 45 14             	mov    0x14(%ebp),%eax
  800d19:	83 e8 04             	sub    $0x4,%eax
  800d1c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d1e:	85 db                	test   %ebx,%ebx
  800d20:	79 02                	jns    800d24 <vprintfmt+0x14a>
				err = -err;
  800d22:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d24:	83 fb 64             	cmp    $0x64,%ebx
  800d27:	7f 0b                	jg     800d34 <vprintfmt+0x15a>
  800d29:	8b 34 9d c0 27 80 00 	mov    0x8027c0(,%ebx,4),%esi
  800d30:	85 f6                	test   %esi,%esi
  800d32:	75 19                	jne    800d4d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d34:	53                   	push   %ebx
  800d35:	68 65 29 80 00       	push   $0x802965
  800d3a:	ff 75 0c             	pushl  0xc(%ebp)
  800d3d:	ff 75 08             	pushl  0x8(%ebp)
  800d40:	e8 70 02 00 00       	call   800fb5 <printfmt>
  800d45:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d48:	e9 5b 02 00 00       	jmp    800fa8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d4d:	56                   	push   %esi
  800d4e:	68 6e 29 80 00       	push   $0x80296e
  800d53:	ff 75 0c             	pushl  0xc(%ebp)
  800d56:	ff 75 08             	pushl  0x8(%ebp)
  800d59:	e8 57 02 00 00       	call   800fb5 <printfmt>
  800d5e:	83 c4 10             	add    $0x10,%esp
			break;
  800d61:	e9 42 02 00 00       	jmp    800fa8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	83 c0 04             	add    $0x4,%eax
  800d6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800d6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d72:	83 e8 04             	sub    $0x4,%eax
  800d75:	8b 30                	mov    (%eax),%esi
  800d77:	85 f6                	test   %esi,%esi
  800d79:	75 05                	jne    800d80 <vprintfmt+0x1a6>
				p = "(null)";
  800d7b:	be 71 29 80 00       	mov    $0x802971,%esi
			if (width > 0 && padc != '-')
  800d80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d84:	7e 6d                	jle    800df3 <vprintfmt+0x219>
  800d86:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d8a:	74 67                	je     800df3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d8f:	83 ec 08             	sub    $0x8,%esp
  800d92:	50                   	push   %eax
  800d93:	56                   	push   %esi
  800d94:	e8 26 05 00 00       	call   8012bf <strnlen>
  800d99:	83 c4 10             	add    $0x10,%esp
  800d9c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d9f:	eb 16                	jmp    800db7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800da1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800da5:	83 ec 08             	sub    $0x8,%esp
  800da8:	ff 75 0c             	pushl  0xc(%ebp)
  800dab:	50                   	push   %eax
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	ff d0                	call   *%eax
  800db1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800db4:	ff 4d e4             	decl   -0x1c(%ebp)
  800db7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbb:	7f e4                	jg     800da1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dbd:	eb 34                	jmp    800df3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dbf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dc3:	74 1c                	je     800de1 <vprintfmt+0x207>
  800dc5:	83 fb 1f             	cmp    $0x1f,%ebx
  800dc8:	7e 05                	jle    800dcf <vprintfmt+0x1f5>
  800dca:	83 fb 7e             	cmp    $0x7e,%ebx
  800dcd:	7e 12                	jle    800de1 <vprintfmt+0x207>
					putch('?', putdat);
  800dcf:	83 ec 08             	sub    $0x8,%esp
  800dd2:	ff 75 0c             	pushl  0xc(%ebp)
  800dd5:	6a 3f                	push   $0x3f
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	ff d0                	call   *%eax
  800ddc:	83 c4 10             	add    $0x10,%esp
  800ddf:	eb 0f                	jmp    800df0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800de1:	83 ec 08             	sub    $0x8,%esp
  800de4:	ff 75 0c             	pushl  0xc(%ebp)
  800de7:	53                   	push   %ebx
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	ff d0                	call   *%eax
  800ded:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df0:	ff 4d e4             	decl   -0x1c(%ebp)
  800df3:	89 f0                	mov    %esi,%eax
  800df5:	8d 70 01             	lea    0x1(%eax),%esi
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	0f be d8             	movsbl %al,%ebx
  800dfd:	85 db                	test   %ebx,%ebx
  800dff:	74 24                	je     800e25 <vprintfmt+0x24b>
  800e01:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e05:	78 b8                	js     800dbf <vprintfmt+0x1e5>
  800e07:	ff 4d e0             	decl   -0x20(%ebp)
  800e0a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e0e:	79 af                	jns    800dbf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e10:	eb 13                	jmp    800e25 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e12:	83 ec 08             	sub    $0x8,%esp
  800e15:	ff 75 0c             	pushl  0xc(%ebp)
  800e18:	6a 20                	push   $0x20
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	ff d0                	call   *%eax
  800e1f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e22:	ff 4d e4             	decl   -0x1c(%ebp)
  800e25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e29:	7f e7                	jg     800e12 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e2b:	e9 78 01 00 00       	jmp    800fa8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 e8             	pushl  -0x18(%ebp)
  800e36:	8d 45 14             	lea    0x14(%ebp),%eax
  800e39:	50                   	push   %eax
  800e3a:	e8 3c fd ff ff       	call   800b7b <getint>
  800e3f:	83 c4 10             	add    $0x10,%esp
  800e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e45:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4e:	85 d2                	test   %edx,%edx
  800e50:	79 23                	jns    800e75 <vprintfmt+0x29b>
				putch('-', putdat);
  800e52:	83 ec 08             	sub    $0x8,%esp
  800e55:	ff 75 0c             	pushl  0xc(%ebp)
  800e58:	6a 2d                	push   $0x2d
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	ff d0                	call   *%eax
  800e5f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e68:	f7 d8                	neg    %eax
  800e6a:	83 d2 00             	adc    $0x0,%edx
  800e6d:	f7 da                	neg    %edx
  800e6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e72:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e75:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e7c:	e9 bc 00 00 00       	jmp    800f3d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e81:	83 ec 08             	sub    $0x8,%esp
  800e84:	ff 75 e8             	pushl  -0x18(%ebp)
  800e87:	8d 45 14             	lea    0x14(%ebp),%eax
  800e8a:	50                   	push   %eax
  800e8b:	e8 84 fc ff ff       	call   800b14 <getuint>
  800e90:	83 c4 10             	add    $0x10,%esp
  800e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e99:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ea0:	e9 98 00 00 00       	jmp    800f3d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ea5:	83 ec 08             	sub    $0x8,%esp
  800ea8:	ff 75 0c             	pushl  0xc(%ebp)
  800eab:	6a 58                	push   $0x58
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	ff d0                	call   *%eax
  800eb2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	ff 75 0c             	pushl  0xc(%ebp)
  800ebb:	6a 58                	push   $0x58
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	ff d0                	call   *%eax
  800ec2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ec5:	83 ec 08             	sub    $0x8,%esp
  800ec8:	ff 75 0c             	pushl  0xc(%ebp)
  800ecb:	6a 58                	push   $0x58
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	ff d0                	call   *%eax
  800ed2:	83 c4 10             	add    $0x10,%esp
			break;
  800ed5:	e9 ce 00 00 00       	jmp    800fa8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	ff 75 0c             	pushl  0xc(%ebp)
  800ee0:	6a 30                	push   $0x30
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	ff d0                	call   *%eax
  800ee7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800eea:	83 ec 08             	sub    $0x8,%esp
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	6a 78                	push   $0x78
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	ff d0                	call   *%eax
  800ef7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800efa:	8b 45 14             	mov    0x14(%ebp),%eax
  800efd:	83 c0 04             	add    $0x4,%eax
  800f00:	89 45 14             	mov    %eax,0x14(%ebp)
  800f03:	8b 45 14             	mov    0x14(%ebp),%eax
  800f06:	83 e8 04             	sub    $0x4,%eax
  800f09:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f15:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f1c:	eb 1f                	jmp    800f3d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	ff 75 e8             	pushl  -0x18(%ebp)
  800f24:	8d 45 14             	lea    0x14(%ebp),%eax
  800f27:	50                   	push   %eax
  800f28:	e8 e7 fb ff ff       	call   800b14 <getuint>
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f36:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f3d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f44:	83 ec 04             	sub    $0x4,%esp
  800f47:	52                   	push   %edx
  800f48:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f4b:	50                   	push   %eax
  800f4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4f:	ff 75 f0             	pushl  -0x10(%ebp)
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	ff 75 08             	pushl  0x8(%ebp)
  800f58:	e8 00 fb ff ff       	call   800a5d <printnum>
  800f5d:	83 c4 20             	add    $0x20,%esp
			break;
  800f60:	eb 46                	jmp    800fa8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f62:	83 ec 08             	sub    $0x8,%esp
  800f65:	ff 75 0c             	pushl  0xc(%ebp)
  800f68:	53                   	push   %ebx
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	ff d0                	call   *%eax
  800f6e:	83 c4 10             	add    $0x10,%esp
			break;
  800f71:	eb 35                	jmp    800fa8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f73:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800f7a:	eb 2c                	jmp    800fa8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f7c:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800f83:	eb 23                	jmp    800fa8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f85:	83 ec 08             	sub    $0x8,%esp
  800f88:	ff 75 0c             	pushl  0xc(%ebp)
  800f8b:	6a 25                	push   $0x25
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	ff d0                	call   *%eax
  800f92:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f95:	ff 4d 10             	decl   0x10(%ebp)
  800f98:	eb 03                	jmp    800f9d <vprintfmt+0x3c3>
  800f9a:	ff 4d 10             	decl   0x10(%ebp)
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	48                   	dec    %eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	3c 25                	cmp    $0x25,%al
  800fa5:	75 f3                	jne    800f9a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800fa7:	90                   	nop
		}
	}
  800fa8:	e9 35 fc ff ff       	jmp    800be2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fad:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fbb:	8d 45 10             	lea    0x10(%ebp),%eax
  800fbe:	83 c0 04             	add    $0x4,%eax
  800fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc7:	ff 75 f4             	pushl  -0xc(%ebp)
  800fca:	50                   	push   %eax
  800fcb:	ff 75 0c             	pushl  0xc(%ebp)
  800fce:	ff 75 08             	pushl  0x8(%ebp)
  800fd1:	e8 04 fc ff ff       	call   800bda <vprintfmt>
  800fd6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fd9:	90                   	nop
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe2:	8b 40 08             	mov    0x8(%eax),%eax
  800fe5:	8d 50 01             	lea    0x1(%eax),%edx
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	8b 10                	mov    (%eax),%edx
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	8b 40 04             	mov    0x4(%eax),%eax
  800ff9:	39 c2                	cmp    %eax,%edx
  800ffb:	73 12                	jae    80100f <sprintputch+0x33>
		*b->buf++ = ch;
  800ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801000:	8b 00                	mov    (%eax),%eax
  801002:	8d 48 01             	lea    0x1(%eax),%ecx
  801005:	8b 55 0c             	mov    0xc(%ebp),%edx
  801008:	89 0a                	mov    %ecx,(%edx)
  80100a:	8b 55 08             	mov    0x8(%ebp),%edx
  80100d:	88 10                	mov    %dl,(%eax)
}
  80100f:	90                   	nop
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    

00801012 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80101e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801021:	8d 50 ff             	lea    -0x1(%eax),%edx
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	01 d0                	add    %edx,%eax
  801029:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80102c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801033:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801037:	74 06                	je     80103f <vsnprintf+0x2d>
  801039:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80103d:	7f 07                	jg     801046 <vsnprintf+0x34>
		return -E_INVAL;
  80103f:	b8 03 00 00 00       	mov    $0x3,%eax
  801044:	eb 20                	jmp    801066 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801046:	ff 75 14             	pushl  0x14(%ebp)
  801049:	ff 75 10             	pushl  0x10(%ebp)
  80104c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80104f:	50                   	push   %eax
  801050:	68 dc 0f 80 00       	push   $0x800fdc
  801055:	e8 80 fb ff ff       	call   800bda <vprintfmt>
  80105a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80105d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801060:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801063:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80106e:	8d 45 10             	lea    0x10(%ebp),%eax
  801071:	83 c0 04             	add    $0x4,%eax
  801074:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801077:	8b 45 10             	mov    0x10(%ebp),%eax
  80107a:	ff 75 f4             	pushl  -0xc(%ebp)
  80107d:	50                   	push   %eax
  80107e:	ff 75 0c             	pushl  0xc(%ebp)
  801081:	ff 75 08             	pushl  0x8(%ebp)
  801084:	e8 89 ff ff ff       	call   801012 <vsnprintf>
  801089:	83 c4 10             	add    $0x10,%esp
  80108c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80108f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80109a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80109e:	74 13                	je     8010b3 <readline+0x1f>
		cprintf("%s", prompt);
  8010a0:	83 ec 08             	sub    $0x8,%esp
  8010a3:	ff 75 08             	pushl  0x8(%ebp)
  8010a6:	68 e8 2a 80 00       	push   $0x802ae8
  8010ab:	e8 50 f9 ff ff       	call   800a00 <cprintf>
  8010b0:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010ba:	83 ec 0c             	sub    $0xc,%esp
  8010bd:	6a 00                	push   $0x0
  8010bf:	e8 3e f5 ff ff       	call   800602 <iscons>
  8010c4:	83 c4 10             	add    $0x10,%esp
  8010c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010ca:	e8 20 f5 ff ff       	call   8005ef <getchar>
  8010cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010d6:	79 22                	jns    8010fa <readline+0x66>
			if (c != -E_EOF)
  8010d8:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010dc:	0f 84 ad 00 00 00    	je     80118f <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010e2:	83 ec 08             	sub    $0x8,%esp
  8010e5:	ff 75 ec             	pushl  -0x14(%ebp)
  8010e8:	68 eb 2a 80 00       	push   $0x802aeb
  8010ed:	e8 0e f9 ff ff       	call   800a00 <cprintf>
  8010f2:	83 c4 10             	add    $0x10,%esp
			break;
  8010f5:	e9 95 00 00 00       	jmp    80118f <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010fa:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010fe:	7e 34                	jle    801134 <readline+0xa0>
  801100:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801107:	7f 2b                	jg     801134 <readline+0xa0>
			if (echoing)
  801109:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80110d:	74 0e                	je     80111d <readline+0x89>
				cputchar(c);
  80110f:	83 ec 0c             	sub    $0xc,%esp
  801112:	ff 75 ec             	pushl  -0x14(%ebp)
  801115:	e8 b6 f4 ff ff       	call   8005d0 <cputchar>
  80111a:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80111d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801120:	8d 50 01             	lea    0x1(%eax),%edx
  801123:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801126:	89 c2                	mov    %eax,%edx
  801128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112b:	01 d0                	add    %edx,%eax
  80112d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801130:	88 10                	mov    %dl,(%eax)
  801132:	eb 56                	jmp    80118a <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801134:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801138:	75 1f                	jne    801159 <readline+0xc5>
  80113a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80113e:	7e 19                	jle    801159 <readline+0xc5>
			if (echoing)
  801140:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801144:	74 0e                	je     801154 <readline+0xc0>
				cputchar(c);
  801146:	83 ec 0c             	sub    $0xc,%esp
  801149:	ff 75 ec             	pushl  -0x14(%ebp)
  80114c:	e8 7f f4 ff ff       	call   8005d0 <cputchar>
  801151:	83 c4 10             	add    $0x10,%esp

			i--;
  801154:	ff 4d f4             	decl   -0xc(%ebp)
  801157:	eb 31                	jmp    80118a <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801159:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80115d:	74 0a                	je     801169 <readline+0xd5>
  80115f:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801163:	0f 85 61 ff ff ff    	jne    8010ca <readline+0x36>
			if (echoing)
  801169:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80116d:	74 0e                	je     80117d <readline+0xe9>
				cputchar(c);
  80116f:	83 ec 0c             	sub    $0xc,%esp
  801172:	ff 75 ec             	pushl  -0x14(%ebp)
  801175:	e8 56 f4 ff ff       	call   8005d0 <cputchar>
  80117a:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80117d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801180:	8b 45 0c             	mov    0xc(%ebp),%eax
  801183:	01 d0                	add    %edx,%eax
  801185:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801188:	eb 06                	jmp    801190 <readline+0xfc>
		}
	}
  80118a:	e9 3b ff ff ff       	jmp    8010ca <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80118f:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801190:	90                   	nop
  801191:	c9                   	leave  
  801192:	c3                   	ret    

00801193 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801199:	e8 9b 09 00 00       	call   801b39 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80119e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011a2:	74 13                	je     8011b7 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8011a4:	83 ec 08             	sub    $0x8,%esp
  8011a7:	ff 75 08             	pushl  0x8(%ebp)
  8011aa:	68 e8 2a 80 00       	push   $0x802ae8
  8011af:	e8 4c f8 ff ff       	call   800a00 <cprintf>
  8011b4:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8011b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8011be:	83 ec 0c             	sub    $0xc,%esp
  8011c1:	6a 00                	push   $0x0
  8011c3:	e8 3a f4 ff ff       	call   800602 <iscons>
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8011ce:	e8 1c f4 ff ff       	call   8005ef <getchar>
  8011d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8011d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011da:	79 22                	jns    8011fe <atomic_readline+0x6b>
				if (c != -E_EOF)
  8011dc:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011e0:	0f 84 ad 00 00 00    	je     801293 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8011e6:	83 ec 08             	sub    $0x8,%esp
  8011e9:	ff 75 ec             	pushl  -0x14(%ebp)
  8011ec:	68 eb 2a 80 00       	push   $0x802aeb
  8011f1:	e8 0a f8 ff ff       	call   800a00 <cprintf>
  8011f6:	83 c4 10             	add    $0x10,%esp
				break;
  8011f9:	e9 95 00 00 00       	jmp    801293 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8011fe:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801202:	7e 34                	jle    801238 <atomic_readline+0xa5>
  801204:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80120b:	7f 2b                	jg     801238 <atomic_readline+0xa5>
				if (echoing)
  80120d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801211:	74 0e                	je     801221 <atomic_readline+0x8e>
					cputchar(c);
  801213:	83 ec 0c             	sub    $0xc,%esp
  801216:	ff 75 ec             	pushl  -0x14(%ebp)
  801219:	e8 b2 f3 ff ff       	call   8005d0 <cputchar>
  80121e:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801224:	8d 50 01             	lea    0x1(%eax),%edx
  801227:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80122a:	89 c2                	mov    %eax,%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	01 d0                	add    %edx,%eax
  801231:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801234:	88 10                	mov    %dl,(%eax)
  801236:	eb 56                	jmp    80128e <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801238:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80123c:	75 1f                	jne    80125d <atomic_readline+0xca>
  80123e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801242:	7e 19                	jle    80125d <atomic_readline+0xca>
				if (echoing)
  801244:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801248:	74 0e                	je     801258 <atomic_readline+0xc5>
					cputchar(c);
  80124a:	83 ec 0c             	sub    $0xc,%esp
  80124d:	ff 75 ec             	pushl  -0x14(%ebp)
  801250:	e8 7b f3 ff ff       	call   8005d0 <cputchar>
  801255:	83 c4 10             	add    $0x10,%esp
				i--;
  801258:	ff 4d f4             	decl   -0xc(%ebp)
  80125b:	eb 31                	jmp    80128e <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80125d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801261:	74 0a                	je     80126d <atomic_readline+0xda>
  801263:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801267:	0f 85 61 ff ff ff    	jne    8011ce <atomic_readline+0x3b>
				if (echoing)
  80126d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801271:	74 0e                	je     801281 <atomic_readline+0xee>
					cputchar(c);
  801273:	83 ec 0c             	sub    $0xc,%esp
  801276:	ff 75 ec             	pushl  -0x14(%ebp)
  801279:	e8 52 f3 ff ff       	call   8005d0 <cputchar>
  80127e:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801281:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801284:	8b 45 0c             	mov    0xc(%ebp),%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80128c:	eb 06                	jmp    801294 <atomic_readline+0x101>
			}
		}
  80128e:	e9 3b ff ff ff       	jmp    8011ce <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801293:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801294:	e8 ba 08 00 00       	call   801b53 <sys_unlock_cons>
}
  801299:	90                   	nop
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a9:	eb 06                	jmp    8012b1 <strlen+0x15>
		n++;
  8012ab:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ae:	ff 45 08             	incl   0x8(%ebp)
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	84 c0                	test   %al,%al
  8012b8:	75 f1                	jne    8012ab <strlen+0xf>
		n++;
	return n;
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012cc:	eb 09                	jmp    8012d7 <strnlen+0x18>
		n++;
  8012ce:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012d1:	ff 45 08             	incl   0x8(%ebp)
  8012d4:	ff 4d 0c             	decl   0xc(%ebp)
  8012d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012db:	74 09                	je     8012e6 <strnlen+0x27>
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	8a 00                	mov    (%eax),%al
  8012e2:	84 c0                	test   %al,%al
  8012e4:	75 e8                	jne    8012ce <strnlen+0xf>
		n++;
	return n;
  8012e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012f7:	90                   	nop
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8d 50 01             	lea    0x1(%eax),%edx
  8012fe:	89 55 08             	mov    %edx,0x8(%ebp)
  801301:	8b 55 0c             	mov    0xc(%ebp),%edx
  801304:	8d 4a 01             	lea    0x1(%edx),%ecx
  801307:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80130a:	8a 12                	mov    (%edx),%dl
  80130c:	88 10                	mov    %dl,(%eax)
  80130e:	8a 00                	mov    (%eax),%al
  801310:	84 c0                	test   %al,%al
  801312:	75 e4                	jne    8012f8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801314:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801325:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80132c:	eb 1f                	jmp    80134d <strncpy+0x34>
		*dst++ = *src;
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8d 50 01             	lea    0x1(%eax),%edx
  801334:	89 55 08             	mov    %edx,0x8(%ebp)
  801337:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133a:	8a 12                	mov    (%edx),%dl
  80133c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80133e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	84 c0                	test   %al,%al
  801345:	74 03                	je     80134a <strncpy+0x31>
			src++;
  801347:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80134a:	ff 45 fc             	incl   -0x4(%ebp)
  80134d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801350:	3b 45 10             	cmp    0x10(%ebp),%eax
  801353:	72 d9                	jb     80132e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801355:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801366:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80136a:	74 30                	je     80139c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80136c:	eb 16                	jmp    801384 <strlcpy+0x2a>
			*dst++ = *src++;
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	8d 50 01             	lea    0x1(%eax),%edx
  801374:	89 55 08             	mov    %edx,0x8(%ebp)
  801377:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80137d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801380:	8a 12                	mov    (%edx),%dl
  801382:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801384:	ff 4d 10             	decl   0x10(%ebp)
  801387:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138b:	74 09                	je     801396 <strlcpy+0x3c>
  80138d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	84 c0                	test   %al,%al
  801394:	75 d8                	jne    80136e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80139c:	8b 55 08             	mov    0x8(%ebp),%edx
  80139f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a2:	29 c2                	sub    %eax,%edx
  8013a4:	89 d0                	mov    %edx,%eax
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013ab:	eb 06                	jmp    8013b3 <strcmp+0xb>
		p++, q++;
  8013ad:	ff 45 08             	incl   0x8(%ebp)
  8013b0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	84 c0                	test   %al,%al
  8013ba:	74 0e                	je     8013ca <strcmp+0x22>
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	8a 10                	mov    (%eax),%dl
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	38 c2                	cmp    %al,%dl
  8013c8:	74 e3                	je     8013ad <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	0f b6 d0             	movzbl %al,%edx
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	0f b6 c0             	movzbl %al,%eax
  8013da:	29 c2                	sub    %eax,%edx
  8013dc:	89 d0                	mov    %edx,%eax
}
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    

008013e0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013e3:	eb 09                	jmp    8013ee <strncmp+0xe>
		n--, p++, q++;
  8013e5:	ff 4d 10             	decl   0x10(%ebp)
  8013e8:	ff 45 08             	incl   0x8(%ebp)
  8013eb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f2:	74 17                	je     80140b <strncmp+0x2b>
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	84 c0                	test   %al,%al
  8013fb:	74 0e                	je     80140b <strncmp+0x2b>
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	8a 10                	mov    (%eax),%dl
  801402:	8b 45 0c             	mov    0xc(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	38 c2                	cmp    %al,%dl
  801409:	74 da                	je     8013e5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80140b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140f:	75 07                	jne    801418 <strncmp+0x38>
		return 0;
  801411:	b8 00 00 00 00       	mov    $0x0,%eax
  801416:	eb 14                	jmp    80142c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	0f b6 d0             	movzbl %al,%edx
  801420:	8b 45 0c             	mov    0xc(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	0f b6 c0             	movzbl %al,%eax
  801428:	29 c2                	sub    %eax,%edx
  80142a:	89 d0                	mov    %edx,%eax
}
  80142c:	5d                   	pop    %ebp
  80142d:	c3                   	ret    

0080142e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	83 ec 04             	sub    $0x4,%esp
  801434:	8b 45 0c             	mov    0xc(%ebp),%eax
  801437:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80143a:	eb 12                	jmp    80144e <strchr+0x20>
		if (*s == c)
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801444:	75 05                	jne    80144b <strchr+0x1d>
			return (char *) s;
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	eb 11                	jmp    80145c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80144b:	ff 45 08             	incl   0x8(%ebp)
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	75 e5                	jne    80143c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801457:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	8b 45 0c             	mov    0xc(%ebp),%eax
  801467:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80146a:	eb 0d                	jmp    801479 <strfind+0x1b>
		if (*s == c)
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801474:	74 0e                	je     801484 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801476:	ff 45 08             	incl   0x8(%ebp)
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	84 c0                	test   %al,%al
  801480:	75 ea                	jne    80146c <strfind+0xe>
  801482:	eb 01                	jmp    801485 <strfind+0x27>
		if (*s == c)
			break;
  801484:	90                   	nop
	return (char *) s;
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801496:	8b 45 10             	mov    0x10(%ebp),%eax
  801499:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80149c:	eb 0e                	jmp    8014ac <memset+0x22>
		*p++ = c;
  80149e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a1:	8d 50 01             	lea    0x1(%eax),%edx
  8014a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014aa:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014ac:	ff 4d f8             	decl   -0x8(%ebp)
  8014af:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014b3:	79 e9                	jns    80149e <memset+0x14>
		*p++ = c;

	return v;
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014cc:	eb 16                	jmp    8014e4 <memcpy+0x2a>
		*d++ = *s++;
  8014ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d1:	8d 50 01             	lea    0x1(%eax),%edx
  8014d4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014dd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014e0:	8a 12                	mov    (%edx),%dl
  8014e2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ed:	85 c0                	test   %eax,%eax
  8014ef:	75 dd                	jne    8014ce <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801508:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80150b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80150e:	73 50                	jae    801560 <memmove+0x6a>
  801510:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801513:	8b 45 10             	mov    0x10(%ebp),%eax
  801516:	01 d0                	add    %edx,%eax
  801518:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80151b:	76 43                	jbe    801560 <memmove+0x6a>
		s += n;
  80151d:	8b 45 10             	mov    0x10(%ebp),%eax
  801520:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801523:	8b 45 10             	mov    0x10(%ebp),%eax
  801526:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801529:	eb 10                	jmp    80153b <memmove+0x45>
			*--d = *--s;
  80152b:	ff 4d f8             	decl   -0x8(%ebp)
  80152e:	ff 4d fc             	decl   -0x4(%ebp)
  801531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801534:	8a 10                	mov    (%eax),%dl
  801536:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801539:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80153b:	8b 45 10             	mov    0x10(%ebp),%eax
  80153e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801541:	89 55 10             	mov    %edx,0x10(%ebp)
  801544:	85 c0                	test   %eax,%eax
  801546:	75 e3                	jne    80152b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801548:	eb 23                	jmp    80156d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80154a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80154d:	8d 50 01             	lea    0x1(%eax),%edx
  801550:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801553:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801556:	8d 4a 01             	lea    0x1(%edx),%ecx
  801559:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80155c:	8a 12                	mov    (%edx),%dl
  80155e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801560:	8b 45 10             	mov    0x10(%ebp),%eax
  801563:	8d 50 ff             	lea    -0x1(%eax),%edx
  801566:	89 55 10             	mov    %edx,0x10(%ebp)
  801569:	85 c0                	test   %eax,%eax
  80156b:	75 dd                	jne    80154a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
  801575:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80157e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801581:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801584:	eb 2a                	jmp    8015b0 <memcmp+0x3e>
		if (*s1 != *s2)
  801586:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801589:	8a 10                	mov    (%eax),%dl
  80158b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	38 c2                	cmp    %al,%dl
  801592:	74 16                	je     8015aa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801594:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801597:	8a 00                	mov    (%eax),%al
  801599:	0f b6 d0             	movzbl %al,%edx
  80159c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80159f:	8a 00                	mov    (%eax),%al
  8015a1:	0f b6 c0             	movzbl %al,%eax
  8015a4:	29 c2                	sub    %eax,%edx
  8015a6:	89 d0                	mov    %edx,%eax
  8015a8:	eb 18                	jmp    8015c2 <memcmp+0x50>
		s1++, s2++;
  8015aa:	ff 45 fc             	incl   -0x4(%ebp)
  8015ad:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	75 c9                	jne    801586 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8015cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d0:	01 d0                	add    %edx,%eax
  8015d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015d5:	eb 15                	jmp    8015ec <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	8a 00                	mov    (%eax),%al
  8015dc:	0f b6 d0             	movzbl %al,%edx
  8015df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e2:	0f b6 c0             	movzbl %al,%eax
  8015e5:	39 c2                	cmp    %eax,%edx
  8015e7:	74 0d                	je     8015f6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015e9:	ff 45 08             	incl   0x8(%ebp)
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015f2:	72 e3                	jb     8015d7 <memfind+0x13>
  8015f4:	eb 01                	jmp    8015f7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015f6:	90                   	nop
	return (void *) s;
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801602:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801609:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801610:	eb 03                	jmp    801615 <strtol+0x19>
		s++;
  801612:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	8a 00                	mov    (%eax),%al
  80161a:	3c 20                	cmp    $0x20,%al
  80161c:	74 f4                	je     801612 <strtol+0x16>
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	8a 00                	mov    (%eax),%al
  801623:	3c 09                	cmp    $0x9,%al
  801625:	74 eb                	je     801612 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	8a 00                	mov    (%eax),%al
  80162c:	3c 2b                	cmp    $0x2b,%al
  80162e:	75 05                	jne    801635 <strtol+0x39>
		s++;
  801630:	ff 45 08             	incl   0x8(%ebp)
  801633:	eb 13                	jmp    801648 <strtol+0x4c>
	else if (*s == '-')
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	3c 2d                	cmp    $0x2d,%al
  80163c:	75 0a                	jne    801648 <strtol+0x4c>
		s++, neg = 1;
  80163e:	ff 45 08             	incl   0x8(%ebp)
  801641:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801648:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80164c:	74 06                	je     801654 <strtol+0x58>
  80164e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801652:	75 20                	jne    801674 <strtol+0x78>
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	3c 30                	cmp    $0x30,%al
  80165b:	75 17                	jne    801674 <strtol+0x78>
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	40                   	inc    %eax
  801661:	8a 00                	mov    (%eax),%al
  801663:	3c 78                	cmp    $0x78,%al
  801665:	75 0d                	jne    801674 <strtol+0x78>
		s += 2, base = 16;
  801667:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80166b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801672:	eb 28                	jmp    80169c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801674:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801678:	75 15                	jne    80168f <strtol+0x93>
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	8a 00                	mov    (%eax),%al
  80167f:	3c 30                	cmp    $0x30,%al
  801681:	75 0c                	jne    80168f <strtol+0x93>
		s++, base = 8;
  801683:	ff 45 08             	incl   0x8(%ebp)
  801686:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80168d:	eb 0d                	jmp    80169c <strtol+0xa0>
	else if (base == 0)
  80168f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801693:	75 07                	jne    80169c <strtol+0xa0>
		base = 10;
  801695:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	8a 00                	mov    (%eax),%al
  8016a1:	3c 2f                	cmp    $0x2f,%al
  8016a3:	7e 19                	jle    8016be <strtol+0xc2>
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	8a 00                	mov    (%eax),%al
  8016aa:	3c 39                	cmp    $0x39,%al
  8016ac:	7f 10                	jg     8016be <strtol+0xc2>
			dig = *s - '0';
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	0f be c0             	movsbl %al,%eax
  8016b6:	83 e8 30             	sub    $0x30,%eax
  8016b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016bc:	eb 42                	jmp    801700 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8a 00                	mov    (%eax),%al
  8016c3:	3c 60                	cmp    $0x60,%al
  8016c5:	7e 19                	jle    8016e0 <strtol+0xe4>
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	8a 00                	mov    (%eax),%al
  8016cc:	3c 7a                	cmp    $0x7a,%al
  8016ce:	7f 10                	jg     8016e0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	8a 00                	mov    (%eax),%al
  8016d5:	0f be c0             	movsbl %al,%eax
  8016d8:	83 e8 57             	sub    $0x57,%eax
  8016db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016de:	eb 20                	jmp    801700 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	3c 40                	cmp    $0x40,%al
  8016e7:	7e 39                	jle    801722 <strtol+0x126>
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	8a 00                	mov    (%eax),%al
  8016ee:	3c 5a                	cmp    $0x5a,%al
  8016f0:	7f 30                	jg     801722 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	8a 00                	mov    (%eax),%al
  8016f7:	0f be c0             	movsbl %al,%eax
  8016fa:	83 e8 37             	sub    $0x37,%eax
  8016fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801703:	3b 45 10             	cmp    0x10(%ebp),%eax
  801706:	7d 19                	jge    801721 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801708:	ff 45 08             	incl   0x8(%ebp)
  80170b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801712:	89 c2                	mov    %eax,%edx
  801714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801717:	01 d0                	add    %edx,%eax
  801719:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80171c:	e9 7b ff ff ff       	jmp    80169c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801721:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801726:	74 08                	je     801730 <strtol+0x134>
		*endptr = (char *) s;
  801728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172b:	8b 55 08             	mov    0x8(%ebp),%edx
  80172e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801730:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801734:	74 07                	je     80173d <strtol+0x141>
  801736:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801739:	f7 d8                	neg    %eax
  80173b:	eb 03                	jmp    801740 <strtol+0x144>
  80173d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <ltostr>:

void
ltostr(long value, char *str)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801748:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80174f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801756:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80175a:	79 13                	jns    80176f <ltostr+0x2d>
	{
		neg = 1;
  80175c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801763:	8b 45 0c             	mov    0xc(%ebp),%eax
  801766:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801769:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80176c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801777:	99                   	cltd   
  801778:	f7 f9                	idiv   %ecx
  80177a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80177d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801780:	8d 50 01             	lea    0x1(%eax),%edx
  801783:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801786:	89 c2                	mov    %eax,%edx
  801788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178b:	01 d0                	add    %edx,%eax
  80178d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801790:	83 c2 30             	add    $0x30,%edx
  801793:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801795:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801798:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80179d:	f7 e9                	imul   %ecx
  80179f:	c1 fa 02             	sar    $0x2,%edx
  8017a2:	89 c8                	mov    %ecx,%eax
  8017a4:	c1 f8 1f             	sar    $0x1f,%eax
  8017a7:	29 c2                	sub    %eax,%edx
  8017a9:	89 d0                	mov    %edx,%eax
  8017ab:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8017ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017b2:	75 bb                	jne    80176f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017be:	48                   	dec    %eax
  8017bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017c6:	74 3d                	je     801805 <ltostr+0xc3>
		start = 1 ;
  8017c8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017cf:	eb 34                	jmp    801805 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8017d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d7:	01 d0                	add    %edx,%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	01 c2                	add    %eax,%edx
  8017e6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	01 c8                	add    %ecx,%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	01 c2                	add    %eax,%edx
  8017fa:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017fd:	88 02                	mov    %al,(%edx)
		start++ ;
  8017ff:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801802:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801808:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80180b:	7c c4                	jl     8017d1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80180d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801810:	8b 45 0c             	mov    0xc(%ebp),%eax
  801813:	01 d0                	add    %edx,%eax
  801815:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801818:	90                   	nop
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801821:	ff 75 08             	pushl  0x8(%ebp)
  801824:	e8 73 fa ff ff       	call   80129c <strlen>
  801829:	83 c4 04             	add    $0x4,%esp
  80182c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80182f:	ff 75 0c             	pushl  0xc(%ebp)
  801832:	e8 65 fa ff ff       	call   80129c <strlen>
  801837:	83 c4 04             	add    $0x4,%esp
  80183a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80183d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801844:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80184b:	eb 17                	jmp    801864 <strcconcat+0x49>
		final[s] = str1[s] ;
  80184d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801850:	8b 45 10             	mov    0x10(%ebp),%eax
  801853:	01 c2                	add    %eax,%edx
  801855:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	01 c8                	add    %ecx,%eax
  80185d:	8a 00                	mov    (%eax),%al
  80185f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801861:	ff 45 fc             	incl   -0x4(%ebp)
  801864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801867:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80186a:	7c e1                	jl     80184d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80186c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801873:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80187a:	eb 1f                	jmp    80189b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80187c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80187f:	8d 50 01             	lea    0x1(%eax),%edx
  801882:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801885:	89 c2                	mov    %eax,%edx
  801887:	8b 45 10             	mov    0x10(%ebp),%eax
  80188a:	01 c2                	add    %eax,%edx
  80188c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80188f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801892:	01 c8                	add    %ecx,%eax
  801894:	8a 00                	mov    (%eax),%al
  801896:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801898:	ff 45 f8             	incl   -0x8(%ebp)
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018a1:	7c d9                	jl     80187c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a9:	01 d0                	add    %edx,%eax
  8018ab:	c6 00 00             	movb   $0x0,(%eax)
}
  8018ae:	90                   	nop
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c0:	8b 00                	mov    (%eax),%eax
  8018c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018cc:	01 d0                	add    %edx,%eax
  8018ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018d4:	eb 0c                	jmp    8018e2 <strsplit+0x31>
			*string++ = 0;
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	8d 50 01             	lea    0x1(%eax),%edx
  8018dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8018df:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	8a 00                	mov    (%eax),%al
  8018e7:	84 c0                	test   %al,%al
  8018e9:	74 18                	je     801903 <strsplit+0x52>
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	8a 00                	mov    (%eax),%al
  8018f0:	0f be c0             	movsbl %al,%eax
  8018f3:	50                   	push   %eax
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	e8 32 fb ff ff       	call   80142e <strchr>
  8018fc:	83 c4 08             	add    $0x8,%esp
  8018ff:	85 c0                	test   %eax,%eax
  801901:	75 d3                	jne    8018d6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801903:	8b 45 08             	mov    0x8(%ebp),%eax
  801906:	8a 00                	mov    (%eax),%al
  801908:	84 c0                	test   %al,%al
  80190a:	74 5a                	je     801966 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80190c:	8b 45 14             	mov    0x14(%ebp),%eax
  80190f:	8b 00                	mov    (%eax),%eax
  801911:	83 f8 0f             	cmp    $0xf,%eax
  801914:	75 07                	jne    80191d <strsplit+0x6c>
		{
			return 0;
  801916:	b8 00 00 00 00       	mov    $0x0,%eax
  80191b:	eb 66                	jmp    801983 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80191d:	8b 45 14             	mov    0x14(%ebp),%eax
  801920:	8b 00                	mov    (%eax),%eax
  801922:	8d 48 01             	lea    0x1(%eax),%ecx
  801925:	8b 55 14             	mov    0x14(%ebp),%edx
  801928:	89 0a                	mov    %ecx,(%edx)
  80192a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801931:	8b 45 10             	mov    0x10(%ebp),%eax
  801934:	01 c2                	add    %eax,%edx
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80193b:	eb 03                	jmp    801940 <strsplit+0x8f>
			string++;
  80193d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	8a 00                	mov    (%eax),%al
  801945:	84 c0                	test   %al,%al
  801947:	74 8b                	je     8018d4 <strsplit+0x23>
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	8a 00                	mov    (%eax),%al
  80194e:	0f be c0             	movsbl %al,%eax
  801951:	50                   	push   %eax
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	e8 d4 fa ff ff       	call   80142e <strchr>
  80195a:	83 c4 08             	add    $0x8,%esp
  80195d:	85 c0                	test   %eax,%eax
  80195f:	74 dc                	je     80193d <strsplit+0x8c>
			string++;
	}
  801961:	e9 6e ff ff ff       	jmp    8018d4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801966:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801967:	8b 45 14             	mov    0x14(%ebp),%eax
  80196a:	8b 00                	mov    (%eax),%eax
  80196c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801973:	8b 45 10             	mov    0x10(%ebp),%eax
  801976:	01 d0                	add    %edx,%eax
  801978:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80197e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80198b:	83 ec 04             	sub    $0x4,%esp
  80198e:	68 fc 2a 80 00       	push   $0x802afc
  801993:	68 3f 01 00 00       	push   $0x13f
  801998:	68 1e 2b 80 00       	push   $0x802b1e
  80199d:	e8 a1 ed ff ff       	call   800743 <_panic>

008019a2 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8019a8:	83 ec 0c             	sub    $0xc,%esp
  8019ab:	ff 75 08             	pushl  0x8(%ebp)
  8019ae:	e8 ef 06 00 00       	call   8020a2 <sys_sbrk>
  8019b3:	83 c4 10             	add    $0x10,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8019be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019c2:	75 07                	jne    8019cb <malloc+0x13>
  8019c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c9:	eb 14                	jmp    8019df <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	68 2c 2b 80 00       	push   $0x802b2c
  8019d3:	6a 1b                	push   $0x1b
  8019d5:	68 51 2b 80 00       	push   $0x802b51
  8019da:	e8 64 ed ff ff       	call   800743 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	68 60 2b 80 00       	push   $0x802b60
  8019ef:	6a 29                	push   $0x29
  8019f1:	68 51 2b 80 00       	push   $0x802b51
  8019f6:	e8 48 ed ff ff       	call   800743 <_panic>

008019fb <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	83 ec 18             	sub    $0x18,%esp
  801a01:	8b 45 10             	mov    0x10(%ebp),%eax
  801a04:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801a07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a0b:	75 07                	jne    801a14 <smalloc+0x19>
  801a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a12:	eb 14                	jmp    801a28 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801a14:	83 ec 04             	sub    $0x4,%esp
  801a17:	68 84 2b 80 00       	push   $0x802b84
  801a1c:	6a 38                	push   $0x38
  801a1e:	68 51 2b 80 00       	push   $0x802b51
  801a23:	e8 1b ed ff ff       	call   800743 <_panic>
	return NULL;
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a30:	83 ec 04             	sub    $0x4,%esp
  801a33:	68 ac 2b 80 00       	push   $0x802bac
  801a38:	6a 43                	push   $0x43
  801a3a:	68 51 2b 80 00       	push   $0x802b51
  801a3f:	e8 ff ec ff ff       	call   800743 <_panic>

00801a44 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a4a:	83 ec 04             	sub    $0x4,%esp
  801a4d:	68 d0 2b 80 00       	push   $0x802bd0
  801a52:	6a 5b                	push   $0x5b
  801a54:	68 51 2b 80 00       	push   $0x802b51
  801a59:	e8 e5 ec ff ff       	call   800743 <_panic>

00801a5e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a64:	83 ec 04             	sub    $0x4,%esp
  801a67:	68 f4 2b 80 00       	push   $0x802bf4
  801a6c:	6a 72                	push   $0x72
  801a6e:	68 51 2b 80 00       	push   $0x802b51
  801a73:	e8 cb ec ff ff       	call   800743 <_panic>

00801a78 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a7e:	83 ec 04             	sub    $0x4,%esp
  801a81:	68 1a 2c 80 00       	push   $0x802c1a
  801a86:	6a 7e                	push   $0x7e
  801a88:	68 51 2b 80 00       	push   $0x802b51
  801a8d:	e8 b1 ec ff ff       	call   800743 <_panic>

00801a92 <shrink>:

}
void shrink(uint32 newSize)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a98:	83 ec 04             	sub    $0x4,%esp
  801a9b:	68 1a 2c 80 00       	push   $0x802c1a
  801aa0:	68 83 00 00 00       	push   $0x83
  801aa5:	68 51 2b 80 00       	push   $0x802b51
  801aaa:	e8 94 ec ff ff       	call   800743 <_panic>

00801aaf <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ab5:	83 ec 04             	sub    $0x4,%esp
  801ab8:	68 1a 2c 80 00       	push   $0x802c1a
  801abd:	68 88 00 00 00       	push   $0x88
  801ac2:	68 51 2b 80 00       	push   $0x802b51
  801ac7:	e8 77 ec ff ff       	call   800743 <_panic>

00801acc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	57                   	push   %edi
  801ad0:	56                   	push   %esi
  801ad1:	53                   	push   %ebx
  801ad2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ade:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ae1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ae4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ae7:	cd 30                	int    $0x30
  801ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	5b                   	pop    %ebx
  801af3:	5e                   	pop    %esi
  801af4:	5f                   	pop    %edi
  801af5:	5d                   	pop    %ebp
  801af6:	c3                   	ret    

00801af7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 04             	sub    $0x4,%esp
  801afd:	8b 45 10             	mov    0x10(%ebp),%eax
  801b00:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b03:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	52                   	push   %edx
  801b0f:	ff 75 0c             	pushl  0xc(%ebp)
  801b12:	50                   	push   %eax
  801b13:	6a 00                	push   $0x0
  801b15:	e8 b2 ff ff ff       	call   801acc <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	90                   	nop
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 02                	push   $0x2
  801b2f:	e8 98 ff ff ff       	call   801acc <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 03                	push   $0x3
  801b48:	e8 7f ff ff ff       	call   801acc <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	90                   	nop
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 04                	push   $0x4
  801b62:	e8 65 ff ff ff       	call   801acc <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	90                   	nop
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	52                   	push   %edx
  801b7d:	50                   	push   %eax
  801b7e:	6a 08                	push   $0x8
  801b80:	e8 47 ff ff ff       	call   801acc <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	56                   	push   %esi
  801b8e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b8f:	8b 75 18             	mov    0x18(%ebp),%esi
  801b92:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b95:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	56                   	push   %esi
  801b9f:	53                   	push   %ebx
  801ba0:	51                   	push   %ecx
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	6a 09                	push   $0x9
  801ba5:	e8 22 ff ff ff       	call   801acc <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb0:	5b                   	pop    %ebx
  801bb1:	5e                   	pop    %esi
  801bb2:	5d                   	pop    %ebp
  801bb3:	c3                   	ret    

00801bb4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	52                   	push   %edx
  801bc4:	50                   	push   %eax
  801bc5:	6a 0a                	push   $0xa
  801bc7:	e8 00 ff ff ff       	call   801acc <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	ff 75 0c             	pushl  0xc(%ebp)
  801bdd:	ff 75 08             	pushl  0x8(%ebp)
  801be0:	6a 0b                	push   $0xb
  801be2:	e8 e5 fe ff ff       	call   801acc <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 0c                	push   $0xc
  801bfb:	e8 cc fe ff ff       	call   801acc <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 0d                	push   $0xd
  801c14:	e8 b3 fe ff ff       	call   801acc <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 0e                	push   $0xe
  801c2d:	e8 9a fe ff ff       	call   801acc <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 0f                	push   $0xf
  801c46:	e8 81 fe ff ff       	call   801acc <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	ff 75 08             	pushl  0x8(%ebp)
  801c5e:	6a 10                	push   $0x10
  801c60:	e8 67 fe ff ff       	call   801acc <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 11                	push   $0x11
  801c79:	e8 4e fe ff ff       	call   801acc <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
}
  801c81:	90                   	nop
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_cputc>:

void
sys_cputc(const char c)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	83 ec 04             	sub    $0x4,%esp
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c90:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	50                   	push   %eax
  801c9d:	6a 01                	push   $0x1
  801c9f:	e8 28 fe ff ff       	call   801acc <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	90                   	nop
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 14                	push   $0x14
  801cb9:	e8 0e fe ff ff       	call   801acc <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
}
  801cc1:	90                   	nop
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	83 ec 04             	sub    $0x4,%esp
  801cca:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cd0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cd3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	6a 00                	push   $0x0
  801cdc:	51                   	push   %ecx
  801cdd:	52                   	push   %edx
  801cde:	ff 75 0c             	pushl  0xc(%ebp)
  801ce1:	50                   	push   %eax
  801ce2:	6a 15                	push   $0x15
  801ce4:	e8 e3 fd ff ff       	call   801acc <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	52                   	push   %edx
  801cfe:	50                   	push   %eax
  801cff:	6a 16                	push   $0x16
  801d01:	e8 c6 fd ff ff       	call   801acc <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	51                   	push   %ecx
  801d1c:	52                   	push   %edx
  801d1d:	50                   	push   %eax
  801d1e:	6a 17                	push   $0x17
  801d20:	e8 a7 fd ff ff       	call   801acc <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	52                   	push   %edx
  801d3a:	50                   	push   %eax
  801d3b:	6a 18                	push   $0x18
  801d3d:	e8 8a fd ff ff       	call   801acc <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	6a 00                	push   $0x0
  801d4f:	ff 75 14             	pushl  0x14(%ebp)
  801d52:	ff 75 10             	pushl  0x10(%ebp)
  801d55:	ff 75 0c             	pushl  0xc(%ebp)
  801d58:	50                   	push   %eax
  801d59:	6a 19                	push   $0x19
  801d5b:	e8 6c fd ff ff       	call   801acc <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	50                   	push   %eax
  801d74:	6a 1a                	push   $0x1a
  801d76:	e8 51 fd ff ff       	call   801acc <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
}
  801d7e:	90                   	nop
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	50                   	push   %eax
  801d90:	6a 1b                	push   $0x1b
  801d92:	e8 35 fd ff ff       	call   801acc <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 05                	push   $0x5
  801dab:	e8 1c fd ff ff       	call   801acc <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 06                	push   $0x6
  801dc4:	e8 03 fd ff ff       	call   801acc <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 07                	push   $0x7
  801ddd:	e8 ea fc ff ff       	call   801acc <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_exit_env>:


void sys_exit_env(void)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 1c                	push   $0x1c
  801df6:	e8 d1 fc ff ff       	call   801acc <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
}
  801dfe:	90                   	nop
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e07:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e0a:	8d 50 04             	lea    0x4(%eax),%edx
  801e0d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	52                   	push   %edx
  801e17:	50                   	push   %eax
  801e18:	6a 1d                	push   $0x1d
  801e1a:	e8 ad fc ff ff       	call   801acc <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
	return result;
  801e22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e2b:	89 01                	mov    %eax,(%ecx)
  801e2d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e30:	8b 45 08             	mov    0x8(%ebp),%eax
  801e33:	c9                   	leave  
  801e34:	c2 04 00             	ret    $0x4

00801e37 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	ff 75 10             	pushl  0x10(%ebp)
  801e41:	ff 75 0c             	pushl  0xc(%ebp)
  801e44:	ff 75 08             	pushl  0x8(%ebp)
  801e47:	6a 13                	push   $0x13
  801e49:	e8 7e fc ff ff       	call   801acc <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e51:	90                   	nop
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 1e                	push   $0x1e
  801e63:	e8 64 fc ff ff       	call   801acc <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 04             	sub    $0x4,%esp
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e79:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	50                   	push   %eax
  801e86:	6a 1f                	push   $0x1f
  801e88:	e8 3f fc ff ff       	call   801acc <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e90:	90                   	nop
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <rsttst>:
void rsttst()
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 21                	push   $0x21
  801ea2:	e8 25 fc ff ff       	call   801acc <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eaa:	90                   	nop
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	83 ec 04             	sub    $0x4,%esp
  801eb3:	8b 45 14             	mov    0x14(%ebp),%eax
  801eb6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801eb9:	8b 55 18             	mov    0x18(%ebp),%edx
  801ebc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ec0:	52                   	push   %edx
  801ec1:	50                   	push   %eax
  801ec2:	ff 75 10             	pushl  0x10(%ebp)
  801ec5:	ff 75 0c             	pushl  0xc(%ebp)
  801ec8:	ff 75 08             	pushl  0x8(%ebp)
  801ecb:	6a 20                	push   $0x20
  801ecd:	e8 fa fb ff ff       	call   801acc <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed5:	90                   	nop
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <chktst>:
void chktst(uint32 n)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	ff 75 08             	pushl  0x8(%ebp)
  801ee6:	6a 22                	push   $0x22
  801ee8:	e8 df fb ff ff       	call   801acc <syscall>
  801eed:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef0:	90                   	nop
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <inctst>:

void inctst()
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 23                	push   $0x23
  801f02:	e8 c5 fb ff ff       	call   801acc <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0a:	90                   	nop
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <gettst>:
uint32 gettst()
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 24                	push   $0x24
  801f1c:	e8 ab fb ff ff       	call   801acc <syscall>
  801f21:	83 c4 18             	add    $0x18,%esp
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 25                	push   $0x25
  801f38:	e8 8f fb ff ff       	call   801acc <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
  801f40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f43:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f47:	75 07                	jne    801f50 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f49:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4e:	eb 05                	jmp    801f55 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 25                	push   $0x25
  801f69:	e8 5e fb ff ff       	call   801acc <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
  801f71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f74:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f78:	75 07                	jne    801f81 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7f:	eb 05                	jmp    801f86 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 25                	push   $0x25
  801f9a:	e8 2d fb ff ff       	call   801acc <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
  801fa2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fa5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fa9:	75 07                	jne    801fb2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fab:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb0:	eb 05                	jmp    801fb7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 25                	push   $0x25
  801fcb:	e8 fc fa ff ff       	call   801acc <syscall>
  801fd0:	83 c4 18             	add    $0x18,%esp
  801fd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fd6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fda:	75 07                	jne    801fe3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fdc:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe1:	eb 05                	jmp    801fe8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	ff 75 08             	pushl  0x8(%ebp)
  801ff8:	6a 26                	push   $0x26
  801ffa:	e8 cd fa ff ff       	call   801acc <syscall>
  801fff:	83 c4 18             	add    $0x18,%esp
	return ;
  802002:	90                   	nop
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802009:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80200c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80200f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	6a 00                	push   $0x0
  802017:	53                   	push   %ebx
  802018:	51                   	push   %ecx
  802019:	52                   	push   %edx
  80201a:	50                   	push   %eax
  80201b:	6a 27                	push   $0x27
  80201d:	e8 aa fa ff ff       	call   801acc <syscall>
  802022:	83 c4 18             	add    $0x18,%esp
}
  802025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80202d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	52                   	push   %edx
  80203a:	50                   	push   %eax
  80203b:	6a 28                	push   $0x28
  80203d:	e8 8a fa ff ff       	call   801acc <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80204a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	6a 00                	push   $0x0
  802055:	51                   	push   %ecx
  802056:	ff 75 10             	pushl  0x10(%ebp)
  802059:	52                   	push   %edx
  80205a:	50                   	push   %eax
  80205b:	6a 29                	push   $0x29
  80205d:	e8 6a fa ff ff       	call   801acc <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	ff 75 10             	pushl  0x10(%ebp)
  802071:	ff 75 0c             	pushl  0xc(%ebp)
  802074:	ff 75 08             	pushl  0x8(%ebp)
  802077:	6a 12                	push   $0x12
  802079:	e8 4e fa ff ff       	call   801acc <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
	return ;
  802081:	90                   	nop
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802087:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	52                   	push   %edx
  802094:	50                   	push   %eax
  802095:	6a 2a                	push   $0x2a
  802097:	e8 30 fa ff ff       	call   801acc <syscall>
  80209c:	83 c4 18             	add    $0x18,%esp
	return;
  80209f:	90                   	nop
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	50                   	push   %eax
  8020b1:	6a 2b                	push   $0x2b
  8020b3:	e8 14 fa ff ff       	call   801acc <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	ff 75 0c             	pushl  0xc(%ebp)
  8020c9:	ff 75 08             	pushl  0x8(%ebp)
  8020cc:	6a 2c                	push   $0x2c
  8020ce:	e8 f9 f9 ff ff       	call   801acc <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
	return;
  8020d6:	90                   	nop
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	ff 75 0c             	pushl  0xc(%ebp)
  8020e5:	ff 75 08             	pushl  0x8(%ebp)
  8020e8:	6a 2d                	push   $0x2d
  8020ea:	e8 dd f9 ff ff       	call   801acc <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
	return;
  8020f2:	90                   	nop
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    
  8020f5:	66 90                	xchg   %ax,%ax
  8020f7:	90                   	nop

008020f8 <__udivdi3>:
  8020f8:	55                   	push   %ebp
  8020f9:	57                   	push   %edi
  8020fa:	56                   	push   %esi
  8020fb:	53                   	push   %ebx
  8020fc:	83 ec 1c             	sub    $0x1c,%esp
  8020ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802103:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802107:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80210b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80210f:	89 ca                	mov    %ecx,%edx
  802111:	89 f8                	mov    %edi,%eax
  802113:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802117:	85 f6                	test   %esi,%esi
  802119:	75 2d                	jne    802148 <__udivdi3+0x50>
  80211b:	39 cf                	cmp    %ecx,%edi
  80211d:	77 65                	ja     802184 <__udivdi3+0x8c>
  80211f:	89 fd                	mov    %edi,%ebp
  802121:	85 ff                	test   %edi,%edi
  802123:	75 0b                	jne    802130 <__udivdi3+0x38>
  802125:	b8 01 00 00 00       	mov    $0x1,%eax
  80212a:	31 d2                	xor    %edx,%edx
  80212c:	f7 f7                	div    %edi
  80212e:	89 c5                	mov    %eax,%ebp
  802130:	31 d2                	xor    %edx,%edx
  802132:	89 c8                	mov    %ecx,%eax
  802134:	f7 f5                	div    %ebp
  802136:	89 c1                	mov    %eax,%ecx
  802138:	89 d8                	mov    %ebx,%eax
  80213a:	f7 f5                	div    %ebp
  80213c:	89 cf                	mov    %ecx,%edi
  80213e:	89 fa                	mov    %edi,%edx
  802140:	83 c4 1c             	add    $0x1c,%esp
  802143:	5b                   	pop    %ebx
  802144:	5e                   	pop    %esi
  802145:	5f                   	pop    %edi
  802146:	5d                   	pop    %ebp
  802147:	c3                   	ret    
  802148:	39 ce                	cmp    %ecx,%esi
  80214a:	77 28                	ja     802174 <__udivdi3+0x7c>
  80214c:	0f bd fe             	bsr    %esi,%edi
  80214f:	83 f7 1f             	xor    $0x1f,%edi
  802152:	75 40                	jne    802194 <__udivdi3+0x9c>
  802154:	39 ce                	cmp    %ecx,%esi
  802156:	72 0a                	jb     802162 <__udivdi3+0x6a>
  802158:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80215c:	0f 87 9e 00 00 00    	ja     802200 <__udivdi3+0x108>
  802162:	b8 01 00 00 00       	mov    $0x1,%eax
  802167:	89 fa                	mov    %edi,%edx
  802169:	83 c4 1c             	add    $0x1c,%esp
  80216c:	5b                   	pop    %ebx
  80216d:	5e                   	pop    %esi
  80216e:	5f                   	pop    %edi
  80216f:	5d                   	pop    %ebp
  802170:	c3                   	ret    
  802171:	8d 76 00             	lea    0x0(%esi),%esi
  802174:	31 ff                	xor    %edi,%edi
  802176:	31 c0                	xor    %eax,%eax
  802178:	89 fa                	mov    %edi,%edx
  80217a:	83 c4 1c             	add    $0x1c,%esp
  80217d:	5b                   	pop    %ebx
  80217e:	5e                   	pop    %esi
  80217f:	5f                   	pop    %edi
  802180:	5d                   	pop    %ebp
  802181:	c3                   	ret    
  802182:	66 90                	xchg   %ax,%ax
  802184:	89 d8                	mov    %ebx,%eax
  802186:	f7 f7                	div    %edi
  802188:	31 ff                	xor    %edi,%edi
  80218a:	89 fa                	mov    %edi,%edx
  80218c:	83 c4 1c             	add    $0x1c,%esp
  80218f:	5b                   	pop    %ebx
  802190:	5e                   	pop    %esi
  802191:	5f                   	pop    %edi
  802192:	5d                   	pop    %ebp
  802193:	c3                   	ret    
  802194:	bd 20 00 00 00       	mov    $0x20,%ebp
  802199:	89 eb                	mov    %ebp,%ebx
  80219b:	29 fb                	sub    %edi,%ebx
  80219d:	89 f9                	mov    %edi,%ecx
  80219f:	d3 e6                	shl    %cl,%esi
  8021a1:	89 c5                	mov    %eax,%ebp
  8021a3:	88 d9                	mov    %bl,%cl
  8021a5:	d3 ed                	shr    %cl,%ebp
  8021a7:	89 e9                	mov    %ebp,%ecx
  8021a9:	09 f1                	or     %esi,%ecx
  8021ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8021af:	89 f9                	mov    %edi,%ecx
  8021b1:	d3 e0                	shl    %cl,%eax
  8021b3:	89 c5                	mov    %eax,%ebp
  8021b5:	89 d6                	mov    %edx,%esi
  8021b7:	88 d9                	mov    %bl,%cl
  8021b9:	d3 ee                	shr    %cl,%esi
  8021bb:	89 f9                	mov    %edi,%ecx
  8021bd:	d3 e2                	shl    %cl,%edx
  8021bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021c3:	88 d9                	mov    %bl,%cl
  8021c5:	d3 e8                	shr    %cl,%eax
  8021c7:	09 c2                	or     %eax,%edx
  8021c9:	89 d0                	mov    %edx,%eax
  8021cb:	89 f2                	mov    %esi,%edx
  8021cd:	f7 74 24 0c          	divl   0xc(%esp)
  8021d1:	89 d6                	mov    %edx,%esi
  8021d3:	89 c3                	mov    %eax,%ebx
  8021d5:	f7 e5                	mul    %ebp
  8021d7:	39 d6                	cmp    %edx,%esi
  8021d9:	72 19                	jb     8021f4 <__udivdi3+0xfc>
  8021db:	74 0b                	je     8021e8 <__udivdi3+0xf0>
  8021dd:	89 d8                	mov    %ebx,%eax
  8021df:	31 ff                	xor    %edi,%edi
  8021e1:	e9 58 ff ff ff       	jmp    80213e <__udivdi3+0x46>
  8021e6:	66 90                	xchg   %ax,%ax
  8021e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021ec:	89 f9                	mov    %edi,%ecx
  8021ee:	d3 e2                	shl    %cl,%edx
  8021f0:	39 c2                	cmp    %eax,%edx
  8021f2:	73 e9                	jae    8021dd <__udivdi3+0xe5>
  8021f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021f7:	31 ff                	xor    %edi,%edi
  8021f9:	e9 40 ff ff ff       	jmp    80213e <__udivdi3+0x46>
  8021fe:	66 90                	xchg   %ax,%ax
  802200:	31 c0                	xor    %eax,%eax
  802202:	e9 37 ff ff ff       	jmp    80213e <__udivdi3+0x46>
  802207:	90                   	nop

00802208 <__umoddi3>:
  802208:	55                   	push   %ebp
  802209:	57                   	push   %edi
  80220a:	56                   	push   %esi
  80220b:	53                   	push   %ebx
  80220c:	83 ec 1c             	sub    $0x1c,%esp
  80220f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802213:	8b 74 24 34          	mov    0x34(%esp),%esi
  802217:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80221b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80221f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802223:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802227:	89 f3                	mov    %esi,%ebx
  802229:	89 fa                	mov    %edi,%edx
  80222b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80222f:	89 34 24             	mov    %esi,(%esp)
  802232:	85 c0                	test   %eax,%eax
  802234:	75 1a                	jne    802250 <__umoddi3+0x48>
  802236:	39 f7                	cmp    %esi,%edi
  802238:	0f 86 a2 00 00 00    	jbe    8022e0 <__umoddi3+0xd8>
  80223e:	89 c8                	mov    %ecx,%eax
  802240:	89 f2                	mov    %esi,%edx
  802242:	f7 f7                	div    %edi
  802244:	89 d0                	mov    %edx,%eax
  802246:	31 d2                	xor    %edx,%edx
  802248:	83 c4 1c             	add    $0x1c,%esp
  80224b:	5b                   	pop    %ebx
  80224c:	5e                   	pop    %esi
  80224d:	5f                   	pop    %edi
  80224e:	5d                   	pop    %ebp
  80224f:	c3                   	ret    
  802250:	39 f0                	cmp    %esi,%eax
  802252:	0f 87 ac 00 00 00    	ja     802304 <__umoddi3+0xfc>
  802258:	0f bd e8             	bsr    %eax,%ebp
  80225b:	83 f5 1f             	xor    $0x1f,%ebp
  80225e:	0f 84 ac 00 00 00    	je     802310 <__umoddi3+0x108>
  802264:	bf 20 00 00 00       	mov    $0x20,%edi
  802269:	29 ef                	sub    %ebp,%edi
  80226b:	89 fe                	mov    %edi,%esi
  80226d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802271:	89 e9                	mov    %ebp,%ecx
  802273:	d3 e0                	shl    %cl,%eax
  802275:	89 d7                	mov    %edx,%edi
  802277:	89 f1                	mov    %esi,%ecx
  802279:	d3 ef                	shr    %cl,%edi
  80227b:	09 c7                	or     %eax,%edi
  80227d:	89 e9                	mov    %ebp,%ecx
  80227f:	d3 e2                	shl    %cl,%edx
  802281:	89 14 24             	mov    %edx,(%esp)
  802284:	89 d8                	mov    %ebx,%eax
  802286:	d3 e0                	shl    %cl,%eax
  802288:	89 c2                	mov    %eax,%edx
  80228a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80228e:	d3 e0                	shl    %cl,%eax
  802290:	89 44 24 04          	mov    %eax,0x4(%esp)
  802294:	8b 44 24 08          	mov    0x8(%esp),%eax
  802298:	89 f1                	mov    %esi,%ecx
  80229a:	d3 e8                	shr    %cl,%eax
  80229c:	09 d0                	or     %edx,%eax
  80229e:	d3 eb                	shr    %cl,%ebx
  8022a0:	89 da                	mov    %ebx,%edx
  8022a2:	f7 f7                	div    %edi
  8022a4:	89 d3                	mov    %edx,%ebx
  8022a6:	f7 24 24             	mull   (%esp)
  8022a9:	89 c6                	mov    %eax,%esi
  8022ab:	89 d1                	mov    %edx,%ecx
  8022ad:	39 d3                	cmp    %edx,%ebx
  8022af:	0f 82 87 00 00 00    	jb     80233c <__umoddi3+0x134>
  8022b5:	0f 84 91 00 00 00    	je     80234c <__umoddi3+0x144>
  8022bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022bf:	29 f2                	sub    %esi,%edx
  8022c1:	19 cb                	sbb    %ecx,%ebx
  8022c3:	89 d8                	mov    %ebx,%eax
  8022c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022c9:	d3 e0                	shl    %cl,%eax
  8022cb:	89 e9                	mov    %ebp,%ecx
  8022cd:	d3 ea                	shr    %cl,%edx
  8022cf:	09 d0                	or     %edx,%eax
  8022d1:	89 e9                	mov    %ebp,%ecx
  8022d3:	d3 eb                	shr    %cl,%ebx
  8022d5:	89 da                	mov    %ebx,%edx
  8022d7:	83 c4 1c             	add    $0x1c,%esp
  8022da:	5b                   	pop    %ebx
  8022db:	5e                   	pop    %esi
  8022dc:	5f                   	pop    %edi
  8022dd:	5d                   	pop    %ebp
  8022de:	c3                   	ret    
  8022df:	90                   	nop
  8022e0:	89 fd                	mov    %edi,%ebp
  8022e2:	85 ff                	test   %edi,%edi
  8022e4:	75 0b                	jne    8022f1 <__umoddi3+0xe9>
  8022e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022eb:	31 d2                	xor    %edx,%edx
  8022ed:	f7 f7                	div    %edi
  8022ef:	89 c5                	mov    %eax,%ebp
  8022f1:	89 f0                	mov    %esi,%eax
  8022f3:	31 d2                	xor    %edx,%edx
  8022f5:	f7 f5                	div    %ebp
  8022f7:	89 c8                	mov    %ecx,%eax
  8022f9:	f7 f5                	div    %ebp
  8022fb:	89 d0                	mov    %edx,%eax
  8022fd:	e9 44 ff ff ff       	jmp    802246 <__umoddi3+0x3e>
  802302:	66 90                	xchg   %ax,%ax
  802304:	89 c8                	mov    %ecx,%eax
  802306:	89 f2                	mov    %esi,%edx
  802308:	83 c4 1c             	add    $0x1c,%esp
  80230b:	5b                   	pop    %ebx
  80230c:	5e                   	pop    %esi
  80230d:	5f                   	pop    %edi
  80230e:	5d                   	pop    %ebp
  80230f:	c3                   	ret    
  802310:	3b 04 24             	cmp    (%esp),%eax
  802313:	72 06                	jb     80231b <__umoddi3+0x113>
  802315:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802319:	77 0f                	ja     80232a <__umoddi3+0x122>
  80231b:	89 f2                	mov    %esi,%edx
  80231d:	29 f9                	sub    %edi,%ecx
  80231f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802323:	89 14 24             	mov    %edx,(%esp)
  802326:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80232a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80232e:	8b 14 24             	mov    (%esp),%edx
  802331:	83 c4 1c             	add    $0x1c,%esp
  802334:	5b                   	pop    %ebx
  802335:	5e                   	pop    %esi
  802336:	5f                   	pop    %edi
  802337:	5d                   	pop    %ebp
  802338:	c3                   	ret    
  802339:	8d 76 00             	lea    0x0(%esi),%esi
  80233c:	2b 04 24             	sub    (%esp),%eax
  80233f:	19 fa                	sbb    %edi,%edx
  802341:	89 d1                	mov    %edx,%ecx
  802343:	89 c6                	mov    %eax,%esi
  802345:	e9 71 ff ff ff       	jmp    8022bb <__umoddi3+0xb3>
  80234a:	66 90                	xchg   %ax,%ax
  80234c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802350:	72 ea                	jb     80233c <__umoddi3+0x134>
  802352:	89 d9                	mov    %ebx,%ecx
  802354:	e9 62 ff ff ff       	jmp    8022bb <__umoddi3+0xb3>
