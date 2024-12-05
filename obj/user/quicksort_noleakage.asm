
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
  800049:	68 e0 41 80 00       	push   $0x8041e0
  80004e:	e8 b5 09 00 00       	call   800a08 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 41 80 00       	push   $0x8041e2
  80005e:	e8 a5 09 00 00       	call   800a08 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 fb 41 80 00       	push   $0x8041fb
  80006e:	e8 95 09 00 00       	call   800a08 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 41 80 00       	push   $0x8041e2
  80007e:	e8 85 09 00 00       	call   800a08 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 41 80 00       	push   $0x8041e0
  80008e:	e8 75 09 00 00       	call   800a08 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 14 42 80 00       	push   $0x804214
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
  8000c9:	68 34 42 80 00       	push   $0x804234
  8000ce:	e8 35 09 00 00       	call   800a08 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 56 42 80 00       	push   $0x804256
  8000de:	e8 25 09 00 00       	call   800a08 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 64 42 80 00       	push   $0x804264
  8000ee:	e8 15 09 00 00       	call   800a08 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 73 42 80 00       	push   $0x804273
  8000fe:	e8 05 09 00 00       	call   800a08 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 83 42 80 00       	push   $0x804283
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
  8001dd:	68 8c 42 80 00       	push   $0x80428c
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
  80020c:	68 c0 42 80 00       	push   $0x8042c0
  800211:	6a 54                	push   $0x54
  800213:	68 e2 42 80 00       	push   $0x8042e2
  800218:	e8 2e 05 00 00       	call   80074b <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 28 1d 00 00       	call   801f4a <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 00 43 80 00       	push   $0x804300
  80022a:	e8 d9 07 00 00       	call   800a08 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 34 43 80 00       	push   $0x804334
  80023a:	e8 c9 07 00 00       	call   800a08 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 68 43 80 00       	push   $0x804368
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
  800273:	68 9a 43 80 00       	push   $0x80439a
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
  800570:	68 e0 41 80 00       	push   $0x8041e0
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
  800592:	68 b8 43 80 00       	push   $0x8043b8
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
  8005c0:	68 bd 43 80 00       	push   $0x8043bd
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
  800688:	68 dc 43 80 00       	push   $0x8043dc
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
  8006b0:	68 04 44 80 00       	push   $0x804404
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
  8006e1:	68 2c 44 80 00       	push   $0x80442c
  8006e6:	e8 1d 03 00 00       	call   800a08 <cprintf>
  8006eb:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f3:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	50                   	push   %eax
  8006fd:	68 84 44 80 00       	push   $0x804484
  800702:	e8 01 03 00 00       	call   800a08 <cprintf>
  800707:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 dc 43 80 00       	push   $0x8043dc
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
  80076c:	68 98 44 80 00       	push   $0x804498
  800771:	e8 92 02 00 00       	call   800a08 <cprintf>
  800776:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800779:	a1 00 50 80 00       	mov    0x805000,%eax
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	ff 75 08             	pushl  0x8(%ebp)
  800784:	50                   	push   %eax
  800785:	68 9d 44 80 00       	push   $0x80449d
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
  8007a9:	68 b9 44 80 00       	push   $0x8044b9
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
  8007d8:	68 bc 44 80 00       	push   $0x8044bc
  8007dd:	6a 26                	push   $0x26
  8007df:	68 08 45 80 00       	push   $0x804508
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
  8008ad:	68 14 45 80 00       	push   $0x804514
  8008b2:	6a 3a                	push   $0x3a
  8008b4:	68 08 45 80 00       	push   $0x804508
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
  800920:	68 68 45 80 00       	push   $0x804568
  800925:	6a 44                	push   $0x44
  800927:	68 08 45 80 00       	push   $0x804508
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
  800aa5:	e8 c2 34 00 00       	call   803f6c <__udivdi3>
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
  800af5:	e8 82 35 00 00       	call   80407c <__umoddi3>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	05 d4 47 80 00       	add    $0x8047d4,%eax
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
  800c50:	8b 04 85 f8 47 80 00 	mov    0x8047f8(,%eax,4),%eax
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
  800d31:	8b 34 9d 40 46 80 00 	mov    0x804640(,%ebx,4),%esi
  800d38:	85 f6                	test   %esi,%esi
  800d3a:	75 19                	jne    800d55 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d3c:	53                   	push   %ebx
  800d3d:	68 e5 47 80 00       	push   $0x8047e5
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
  800d56:	68 ee 47 80 00       	push   $0x8047ee
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
  800d83:	be f1 47 80 00       	mov    $0x8047f1,%esi
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
  8010ae:	68 68 49 80 00       	push   $0x804968
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
  8010f0:	68 6b 49 80 00       	push   $0x80496b
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
  8011b2:	68 68 49 80 00       	push   $0x804968
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
  8011f4:	68 6b 49 80 00       	push   $0x80496b
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
  801996:	68 7c 49 80 00       	push   $0x80497c
  80199b:	68 3f 01 00 00       	push   $0x13f
  8019a0:	68 9e 49 80 00       	push   $0x80499e
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
  801a40:	e8 41 0e 00 00       	call   802886 <alloc_block_FF>
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
  801a63:	e8 da 12 00 00       	call   802d42 <alloc_block_BF>
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
  801c11:	e8 f0 08 00 00       	call   802506 <get_block_size>
  801c16:	83 c4 10             	add    $0x10,%esp
  801c19:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c1c:	83 ec 0c             	sub    $0xc,%esp
  801c1f:	ff 75 08             	pushl  0x8(%ebp)
  801c22:	e8 00 1b 00 00       	call   803727 <free_block>
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
  801cc7:	68 ac 49 80 00       	push   $0x8049ac
  801ccc:	68 87 00 00 00       	push   $0x87
  801cd1:	68 d6 49 80 00       	push   $0x8049d6
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
  801e72:	68 e4 49 80 00       	push   $0x8049e4
  801e77:	68 e4 00 00 00       	push   $0xe4
  801e7c:	68 d6 49 80 00       	push   $0x8049d6
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
  801e8f:	68 0a 4a 80 00       	push   $0x804a0a
  801e94:	68 f0 00 00 00       	push   $0xf0
  801e99:	68 d6 49 80 00       	push   $0x8049d6
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
  801eac:	68 0a 4a 80 00       	push   $0x804a0a
  801eb1:	68 f5 00 00 00       	push   $0xf5
  801eb6:	68 d6 49 80 00       	push   $0x8049d6
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
  801ec9:	68 0a 4a 80 00       	push   $0x804a0a
  801ece:	68 fa 00 00 00       	push   $0xfa
  801ed3:	68 d6 49 80 00       	push   $0x8049d6
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

00802506 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80250c:	8b 45 08             	mov    0x8(%ebp),%eax
  80250f:	83 e8 04             	sub    $0x4,%eax
  802512:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802515:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802518:	8b 00                	mov    (%eax),%eax
  80251a:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80251d:	c9                   	leave  
  80251e:	c3                   	ret    

0080251f <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80251f:	55                   	push   %ebp
  802520:	89 e5                	mov    %esp,%ebp
  802522:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802525:	8b 45 08             	mov    0x8(%ebp),%eax
  802528:	83 e8 04             	sub    $0x4,%eax
  80252b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80252e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802531:	8b 00                	mov    (%eax),%eax
  802533:	83 e0 01             	and    $0x1,%eax
  802536:	85 c0                	test   %eax,%eax
  802538:	0f 94 c0             	sete   %al
}
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
  802540:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802543:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80254a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254d:	83 f8 02             	cmp    $0x2,%eax
  802550:	74 2b                	je     80257d <alloc_block+0x40>
  802552:	83 f8 02             	cmp    $0x2,%eax
  802555:	7f 07                	jg     80255e <alloc_block+0x21>
  802557:	83 f8 01             	cmp    $0x1,%eax
  80255a:	74 0e                	je     80256a <alloc_block+0x2d>
  80255c:	eb 58                	jmp    8025b6 <alloc_block+0x79>
  80255e:	83 f8 03             	cmp    $0x3,%eax
  802561:	74 2d                	je     802590 <alloc_block+0x53>
  802563:	83 f8 04             	cmp    $0x4,%eax
  802566:	74 3b                	je     8025a3 <alloc_block+0x66>
  802568:	eb 4c                	jmp    8025b6 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80256a:	83 ec 0c             	sub    $0xc,%esp
  80256d:	ff 75 08             	pushl  0x8(%ebp)
  802570:	e8 11 03 00 00       	call   802886 <alloc_block_FF>
  802575:	83 c4 10             	add    $0x10,%esp
  802578:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80257b:	eb 4a                	jmp    8025c7 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80257d:	83 ec 0c             	sub    $0xc,%esp
  802580:	ff 75 08             	pushl  0x8(%ebp)
  802583:	e8 c7 19 00 00       	call   803f4f <alloc_block_NF>
  802588:	83 c4 10             	add    $0x10,%esp
  80258b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80258e:	eb 37                	jmp    8025c7 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802590:	83 ec 0c             	sub    $0xc,%esp
  802593:	ff 75 08             	pushl  0x8(%ebp)
  802596:	e8 a7 07 00 00       	call   802d42 <alloc_block_BF>
  80259b:	83 c4 10             	add    $0x10,%esp
  80259e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025a1:	eb 24                	jmp    8025c7 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8025a3:	83 ec 0c             	sub    $0xc,%esp
  8025a6:	ff 75 08             	pushl  0x8(%ebp)
  8025a9:	e8 84 19 00 00       	call   803f32 <alloc_block_WF>
  8025ae:	83 c4 10             	add    $0x10,%esp
  8025b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025b4:	eb 11                	jmp    8025c7 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8025b6:	83 ec 0c             	sub    $0xc,%esp
  8025b9:	68 1c 4a 80 00       	push   $0x804a1c
  8025be:	e8 45 e4 ff ff       	call   800a08 <cprintf>
  8025c3:	83 c4 10             	add    $0x10,%esp
		break;
  8025c6:	90                   	nop
	}
	return va;
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
  8025cf:	53                   	push   %ebx
  8025d0:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8025d3:	83 ec 0c             	sub    $0xc,%esp
  8025d6:	68 3c 4a 80 00       	push   $0x804a3c
  8025db:	e8 28 e4 ff ff       	call   800a08 <cprintf>
  8025e0:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8025e3:	83 ec 0c             	sub    $0xc,%esp
  8025e6:	68 67 4a 80 00       	push   $0x804a67
  8025eb:	e8 18 e4 ff ff       	call   800a08 <cprintf>
  8025f0:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8025f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f9:	eb 37                	jmp    802632 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8025fb:	83 ec 0c             	sub    $0xc,%esp
  8025fe:	ff 75 f4             	pushl  -0xc(%ebp)
  802601:	e8 19 ff ff ff       	call   80251f <is_free_block>
  802606:	83 c4 10             	add    $0x10,%esp
  802609:	0f be d8             	movsbl %al,%ebx
  80260c:	83 ec 0c             	sub    $0xc,%esp
  80260f:	ff 75 f4             	pushl  -0xc(%ebp)
  802612:	e8 ef fe ff ff       	call   802506 <get_block_size>
  802617:	83 c4 10             	add    $0x10,%esp
  80261a:	83 ec 04             	sub    $0x4,%esp
  80261d:	53                   	push   %ebx
  80261e:	50                   	push   %eax
  80261f:	68 7f 4a 80 00       	push   $0x804a7f
  802624:	e8 df e3 ff ff       	call   800a08 <cprintf>
  802629:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80262c:	8b 45 10             	mov    0x10(%ebp),%eax
  80262f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802632:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802636:	74 07                	je     80263f <print_blocks_list+0x73>
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	eb 05                	jmp    802644 <print_blocks_list+0x78>
  80263f:	b8 00 00 00 00       	mov    $0x0,%eax
  802644:	89 45 10             	mov    %eax,0x10(%ebp)
  802647:	8b 45 10             	mov    0x10(%ebp),%eax
  80264a:	85 c0                	test   %eax,%eax
  80264c:	75 ad                	jne    8025fb <print_blocks_list+0x2f>
  80264e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802652:	75 a7                	jne    8025fb <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802654:	83 ec 0c             	sub    $0xc,%esp
  802657:	68 3c 4a 80 00       	push   $0x804a3c
  80265c:	e8 a7 e3 ff ff       	call   800a08 <cprintf>
  802661:	83 c4 10             	add    $0x10,%esp

}
  802664:	90                   	nop
  802665:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802668:	c9                   	leave  
  802669:	c3                   	ret    

0080266a <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
  80266d:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802670:	8b 45 0c             	mov    0xc(%ebp),%eax
  802673:	83 e0 01             	and    $0x1,%eax
  802676:	85 c0                	test   %eax,%eax
  802678:	74 03                	je     80267d <initialize_dynamic_allocator+0x13>
  80267a:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80267d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802681:	0f 84 c7 01 00 00    	je     80284e <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802687:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  80268e:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802691:	8b 55 08             	mov    0x8(%ebp),%edx
  802694:	8b 45 0c             	mov    0xc(%ebp),%eax
  802697:	01 d0                	add    %edx,%eax
  802699:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80269e:	0f 87 ad 01 00 00    	ja     802851 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	85 c0                	test   %eax,%eax
  8026a9:	0f 89 a5 01 00 00    	jns    802854 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8026af:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026b5:	01 d0                	add    %edx,%eax
  8026b7:	83 e8 04             	sub    $0x4,%eax
  8026ba:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8026bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8026c6:	a1 30 50 80 00       	mov    0x805030,%eax
  8026cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ce:	e9 87 00 00 00       	jmp    80275a <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8026d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d7:	75 14                	jne    8026ed <initialize_dynamic_allocator+0x83>
  8026d9:	83 ec 04             	sub    $0x4,%esp
  8026dc:	68 97 4a 80 00       	push   $0x804a97
  8026e1:	6a 79                	push   $0x79
  8026e3:	68 b5 4a 80 00       	push   $0x804ab5
  8026e8:	e8 5e e0 ff ff       	call   80074b <_panic>
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	8b 00                	mov    (%eax),%eax
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	74 10                	je     802706 <initialize_dynamic_allocator+0x9c>
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 00                	mov    (%eax),%eax
  8026fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fe:	8b 52 04             	mov    0x4(%edx),%edx
  802701:	89 50 04             	mov    %edx,0x4(%eax)
  802704:	eb 0b                	jmp    802711 <initialize_dynamic_allocator+0xa7>
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 40 04             	mov    0x4(%eax),%eax
  80270c:	a3 34 50 80 00       	mov    %eax,0x805034
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 40 04             	mov    0x4(%eax),%eax
  802717:	85 c0                	test   %eax,%eax
  802719:	74 0f                	je     80272a <initialize_dynamic_allocator+0xc0>
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 40 04             	mov    0x4(%eax),%eax
  802721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802724:	8b 12                	mov    (%edx),%edx
  802726:	89 10                	mov    %edx,(%eax)
  802728:	eb 0a                	jmp    802734 <initialize_dynamic_allocator+0xca>
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	a3 30 50 80 00       	mov    %eax,0x805030
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802747:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80274c:	48                   	dec    %eax
  80274d:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802752:	a1 38 50 80 00       	mov    0x805038,%eax
  802757:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275e:	74 07                	je     802767 <initialize_dynamic_allocator+0xfd>
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 00                	mov    (%eax),%eax
  802765:	eb 05                	jmp    80276c <initialize_dynamic_allocator+0x102>
  802767:	b8 00 00 00 00       	mov    $0x0,%eax
  80276c:	a3 38 50 80 00       	mov    %eax,0x805038
  802771:	a1 38 50 80 00       	mov    0x805038,%eax
  802776:	85 c0                	test   %eax,%eax
  802778:	0f 85 55 ff ff ff    	jne    8026d3 <initialize_dynamic_allocator+0x69>
  80277e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802782:	0f 85 4b ff ff ff    	jne    8026d3 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802788:	8b 45 08             	mov    0x8(%ebp),%eax
  80278b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80278e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802791:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802797:	a1 48 50 80 00       	mov    0x805048,%eax
  80279c:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8027a1:	a1 44 50 80 00       	mov    0x805044,%eax
  8027a6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8027ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8027af:	83 c0 08             	add    $0x8,%eax
  8027b2:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b8:	83 c0 04             	add    $0x4,%eax
  8027bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027be:	83 ea 08             	sub    $0x8,%edx
  8027c1:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c9:	01 d0                	add    %edx,%eax
  8027cb:	83 e8 08             	sub    $0x8,%eax
  8027ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d1:	83 ea 08             	sub    $0x8,%edx
  8027d4:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8027d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8027df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8027e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027ed:	75 17                	jne    802806 <initialize_dynamic_allocator+0x19c>
  8027ef:	83 ec 04             	sub    $0x4,%esp
  8027f2:	68 d0 4a 80 00       	push   $0x804ad0
  8027f7:	68 90 00 00 00       	push   $0x90
  8027fc:	68 b5 4a 80 00       	push   $0x804ab5
  802801:	e8 45 df ff ff       	call   80074b <_panic>
  802806:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80280c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280f:	89 10                	mov    %edx,(%eax)
  802811:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802814:	8b 00                	mov    (%eax),%eax
  802816:	85 c0                	test   %eax,%eax
  802818:	74 0d                	je     802827 <initialize_dynamic_allocator+0x1bd>
  80281a:	a1 30 50 80 00       	mov    0x805030,%eax
  80281f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802822:	89 50 04             	mov    %edx,0x4(%eax)
  802825:	eb 08                	jmp    80282f <initialize_dynamic_allocator+0x1c5>
  802827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282a:	a3 34 50 80 00       	mov    %eax,0x805034
  80282f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802832:	a3 30 50 80 00       	mov    %eax,0x805030
  802837:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802841:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802846:	40                   	inc    %eax
  802847:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80284c:	eb 07                	jmp    802855 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80284e:	90                   	nop
  80284f:	eb 04                	jmp    802855 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802851:	90                   	nop
  802852:	eb 01                	jmp    802855 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802854:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802855:	c9                   	leave  
  802856:	c3                   	ret    

00802857 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802857:	55                   	push   %ebp
  802858:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80285a:	8b 45 10             	mov    0x10(%ebp),%eax
  80285d:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	8d 50 fc             	lea    -0x4(%eax),%edx
  802866:	8b 45 0c             	mov    0xc(%ebp),%eax
  802869:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80286b:	8b 45 08             	mov    0x8(%ebp),%eax
  80286e:	83 e8 04             	sub    $0x4,%eax
  802871:	8b 00                	mov    (%eax),%eax
  802873:	83 e0 fe             	and    $0xfffffffe,%eax
  802876:	8d 50 f8             	lea    -0x8(%eax),%edx
  802879:	8b 45 08             	mov    0x8(%ebp),%eax
  80287c:	01 c2                	add    %eax,%edx
  80287e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802881:	89 02                	mov    %eax,(%edx)
}
  802883:	90                   	nop
  802884:	5d                   	pop    %ebp
  802885:	c3                   	ret    

00802886 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802886:	55                   	push   %ebp
  802887:	89 e5                	mov    %esp,%ebp
  802889:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	83 e0 01             	and    $0x1,%eax
  802892:	85 c0                	test   %eax,%eax
  802894:	74 03                	je     802899 <alloc_block_FF+0x13>
  802896:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802899:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80289d:	77 07                	ja     8028a6 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80289f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028a6:	a1 28 50 80 00       	mov    0x805028,%eax
  8028ab:	85 c0                	test   %eax,%eax
  8028ad:	75 73                	jne    802922 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028af:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b2:	83 c0 10             	add    $0x10,%eax
  8028b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028b8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8028bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c5:	01 d0                	add    %edx,%eax
  8028c7:	48                   	dec    %eax
  8028c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8028cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8028d3:	f7 75 ec             	divl   -0x14(%ebp)
  8028d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d9:	29 d0                	sub    %edx,%eax
  8028db:	c1 e8 0c             	shr    $0xc,%eax
  8028de:	83 ec 0c             	sub    $0xc,%esp
  8028e1:	50                   	push   %eax
  8028e2:	e8 c3 f0 ff ff       	call   8019aa <sbrk>
  8028e7:	83 c4 10             	add    $0x10,%esp
  8028ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028ed:	83 ec 0c             	sub    $0xc,%esp
  8028f0:	6a 00                	push   $0x0
  8028f2:	e8 b3 f0 ff ff       	call   8019aa <sbrk>
  8028f7:	83 c4 10             	add    $0x10,%esp
  8028fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8028fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802900:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802903:	83 ec 08             	sub    $0x8,%esp
  802906:	50                   	push   %eax
  802907:	ff 75 e4             	pushl  -0x1c(%ebp)
  80290a:	e8 5b fd ff ff       	call   80266a <initialize_dynamic_allocator>
  80290f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802912:	83 ec 0c             	sub    $0xc,%esp
  802915:	68 f3 4a 80 00       	push   $0x804af3
  80291a:	e8 e9 e0 ff ff       	call   800a08 <cprintf>
  80291f:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802922:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802926:	75 0a                	jne    802932 <alloc_block_FF+0xac>
	        return NULL;
  802928:	b8 00 00 00 00       	mov    $0x0,%eax
  80292d:	e9 0e 04 00 00       	jmp    802d40 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802932:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802939:	a1 30 50 80 00       	mov    0x805030,%eax
  80293e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802941:	e9 f3 02 00 00       	jmp    802c39 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80294c:	83 ec 0c             	sub    $0xc,%esp
  80294f:	ff 75 bc             	pushl  -0x44(%ebp)
  802952:	e8 af fb ff ff       	call   802506 <get_block_size>
  802957:	83 c4 10             	add    $0x10,%esp
  80295a:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	83 c0 08             	add    $0x8,%eax
  802963:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802966:	0f 87 c5 02 00 00    	ja     802c31 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80296c:	8b 45 08             	mov    0x8(%ebp),%eax
  80296f:	83 c0 18             	add    $0x18,%eax
  802972:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802975:	0f 87 19 02 00 00    	ja     802b94 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80297b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80297e:	2b 45 08             	sub    0x8(%ebp),%eax
  802981:	83 e8 08             	sub    $0x8,%eax
  802984:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	8d 50 08             	lea    0x8(%eax),%edx
  80298d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802990:	01 d0                	add    %edx,%eax
  802992:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	83 c0 08             	add    $0x8,%eax
  80299b:	83 ec 04             	sub    $0x4,%esp
  80299e:	6a 01                	push   $0x1
  8029a0:	50                   	push   %eax
  8029a1:	ff 75 bc             	pushl  -0x44(%ebp)
  8029a4:	e8 ae fe ff ff       	call   802857 <set_block_data>
  8029a9:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 40 04             	mov    0x4(%eax),%eax
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	75 68                	jne    802a1e <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029b6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029ba:	75 17                	jne    8029d3 <alloc_block_FF+0x14d>
  8029bc:	83 ec 04             	sub    $0x4,%esp
  8029bf:	68 d0 4a 80 00       	push   $0x804ad0
  8029c4:	68 d7 00 00 00       	push   $0xd7
  8029c9:	68 b5 4a 80 00       	push   $0x804ab5
  8029ce:	e8 78 dd ff ff       	call   80074b <_panic>
  8029d3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029dc:	89 10                	mov    %edx,(%eax)
  8029de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029e1:	8b 00                	mov    (%eax),%eax
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	74 0d                	je     8029f4 <alloc_block_FF+0x16e>
  8029e7:	a1 30 50 80 00       	mov    0x805030,%eax
  8029ec:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029ef:	89 50 04             	mov    %edx,0x4(%eax)
  8029f2:	eb 08                	jmp    8029fc <alloc_block_FF+0x176>
  8029f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f7:	a3 34 50 80 00       	mov    %eax,0x805034
  8029fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029ff:	a3 30 50 80 00       	mov    %eax,0x805030
  802a04:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a13:	40                   	inc    %eax
  802a14:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a19:	e9 dc 00 00 00       	jmp    802afa <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	8b 00                	mov    (%eax),%eax
  802a23:	85 c0                	test   %eax,%eax
  802a25:	75 65                	jne    802a8c <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a27:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a2b:	75 17                	jne    802a44 <alloc_block_FF+0x1be>
  802a2d:	83 ec 04             	sub    $0x4,%esp
  802a30:	68 04 4b 80 00       	push   $0x804b04
  802a35:	68 db 00 00 00       	push   $0xdb
  802a3a:	68 b5 4a 80 00       	push   $0x804ab5
  802a3f:	e8 07 dd ff ff       	call   80074b <_panic>
  802a44:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802a4a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a4d:	89 50 04             	mov    %edx,0x4(%eax)
  802a50:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a53:	8b 40 04             	mov    0x4(%eax),%eax
  802a56:	85 c0                	test   %eax,%eax
  802a58:	74 0c                	je     802a66 <alloc_block_FF+0x1e0>
  802a5a:	a1 34 50 80 00       	mov    0x805034,%eax
  802a5f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a62:	89 10                	mov    %edx,(%eax)
  802a64:	eb 08                	jmp    802a6e <alloc_block_FF+0x1e8>
  802a66:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a69:	a3 30 50 80 00       	mov    %eax,0x805030
  802a6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a71:	a3 34 50 80 00       	mov    %eax,0x805034
  802a76:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a7f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a84:	40                   	inc    %eax
  802a85:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a8a:	eb 6e                	jmp    802afa <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802a8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a90:	74 06                	je     802a98 <alloc_block_FF+0x212>
  802a92:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a96:	75 17                	jne    802aaf <alloc_block_FF+0x229>
  802a98:	83 ec 04             	sub    $0x4,%esp
  802a9b:	68 28 4b 80 00       	push   $0x804b28
  802aa0:	68 df 00 00 00       	push   $0xdf
  802aa5:	68 b5 4a 80 00       	push   $0x804ab5
  802aaa:	e8 9c dc ff ff       	call   80074b <_panic>
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 10                	mov    (%eax),%edx
  802ab4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ab7:	89 10                	mov    %edx,(%eax)
  802ab9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	74 0b                	je     802acd <alloc_block_FF+0x247>
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802aca:	89 50 04             	mov    %edx,0x4(%eax)
  802acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ad3:	89 10                	mov    %edx,(%eax)
  802ad5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ad8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802adb:	89 50 04             	mov    %edx,0x4(%eax)
  802ade:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae1:	8b 00                	mov    (%eax),%eax
  802ae3:	85 c0                	test   %eax,%eax
  802ae5:	75 08                	jne    802aef <alloc_block_FF+0x269>
  802ae7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aea:	a3 34 50 80 00       	mov    %eax,0x805034
  802aef:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802af4:	40                   	inc    %eax
  802af5:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802afa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afe:	75 17                	jne    802b17 <alloc_block_FF+0x291>
  802b00:	83 ec 04             	sub    $0x4,%esp
  802b03:	68 97 4a 80 00       	push   $0x804a97
  802b08:	68 e1 00 00 00       	push   $0xe1
  802b0d:	68 b5 4a 80 00       	push   $0x804ab5
  802b12:	e8 34 dc ff ff       	call   80074b <_panic>
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	8b 00                	mov    (%eax),%eax
  802b1c:	85 c0                	test   %eax,%eax
  802b1e:	74 10                	je     802b30 <alloc_block_FF+0x2aa>
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 00                	mov    (%eax),%eax
  802b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b28:	8b 52 04             	mov    0x4(%edx),%edx
  802b2b:	89 50 04             	mov    %edx,0x4(%eax)
  802b2e:	eb 0b                	jmp    802b3b <alloc_block_FF+0x2b5>
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	a3 34 50 80 00       	mov    %eax,0x805034
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 40 04             	mov    0x4(%eax),%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	74 0f                	je     802b54 <alloc_block_FF+0x2ce>
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 40 04             	mov    0x4(%eax),%eax
  802b4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4e:	8b 12                	mov    (%edx),%edx
  802b50:	89 10                	mov    %edx,(%eax)
  802b52:	eb 0a                	jmp    802b5e <alloc_block_FF+0x2d8>
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	8b 00                	mov    (%eax),%eax
  802b59:	a3 30 50 80 00       	mov    %eax,0x805030
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b71:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b76:	48                   	dec    %eax
  802b77:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802b7c:	83 ec 04             	sub    $0x4,%esp
  802b7f:	6a 00                	push   $0x0
  802b81:	ff 75 b4             	pushl  -0x4c(%ebp)
  802b84:	ff 75 b0             	pushl  -0x50(%ebp)
  802b87:	e8 cb fc ff ff       	call   802857 <set_block_data>
  802b8c:	83 c4 10             	add    $0x10,%esp
  802b8f:	e9 95 00 00 00       	jmp    802c29 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802b94:	83 ec 04             	sub    $0x4,%esp
  802b97:	6a 01                	push   $0x1
  802b99:	ff 75 b8             	pushl  -0x48(%ebp)
  802b9c:	ff 75 bc             	pushl  -0x44(%ebp)
  802b9f:	e8 b3 fc ff ff       	call   802857 <set_block_data>
  802ba4:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802ba7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bab:	75 17                	jne    802bc4 <alloc_block_FF+0x33e>
  802bad:	83 ec 04             	sub    $0x4,%esp
  802bb0:	68 97 4a 80 00       	push   $0x804a97
  802bb5:	68 e8 00 00 00       	push   $0xe8
  802bba:	68 b5 4a 80 00       	push   $0x804ab5
  802bbf:	e8 87 db ff ff       	call   80074b <_panic>
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 00                	mov    (%eax),%eax
  802bc9:	85 c0                	test   %eax,%eax
  802bcb:	74 10                	je     802bdd <alloc_block_FF+0x357>
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	8b 00                	mov    (%eax),%eax
  802bd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd5:	8b 52 04             	mov    0x4(%edx),%edx
  802bd8:	89 50 04             	mov    %edx,0x4(%eax)
  802bdb:	eb 0b                	jmp    802be8 <alloc_block_FF+0x362>
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 40 04             	mov    0x4(%eax),%eax
  802be3:	a3 34 50 80 00       	mov    %eax,0x805034
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 40 04             	mov    0x4(%eax),%eax
  802bee:	85 c0                	test   %eax,%eax
  802bf0:	74 0f                	je     802c01 <alloc_block_FF+0x37b>
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	8b 40 04             	mov    0x4(%eax),%eax
  802bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfb:	8b 12                	mov    (%edx),%edx
  802bfd:	89 10                	mov    %edx,(%eax)
  802bff:	eb 0a                	jmp    802c0b <alloc_block_FF+0x385>
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	8b 00                	mov    (%eax),%eax
  802c06:	a3 30 50 80 00       	mov    %eax,0x805030
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c23:	48                   	dec    %eax
  802c24:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802c29:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c2c:	e9 0f 01 00 00       	jmp    802d40 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c31:	a1 38 50 80 00       	mov    0x805038,%eax
  802c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3d:	74 07                	je     802c46 <alloc_block_FF+0x3c0>
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	8b 00                	mov    (%eax),%eax
  802c44:	eb 05                	jmp    802c4b <alloc_block_FF+0x3c5>
  802c46:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4b:	a3 38 50 80 00       	mov    %eax,0x805038
  802c50:	a1 38 50 80 00       	mov    0x805038,%eax
  802c55:	85 c0                	test   %eax,%eax
  802c57:	0f 85 e9 fc ff ff    	jne    802946 <alloc_block_FF+0xc0>
  802c5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c61:	0f 85 df fc ff ff    	jne    802946 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	83 c0 08             	add    $0x8,%eax
  802c6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c70:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802c77:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c7a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c7d:	01 d0                	add    %edx,%eax
  802c7f:	48                   	dec    %eax
  802c80:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802c83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c86:	ba 00 00 00 00       	mov    $0x0,%edx
  802c8b:	f7 75 d8             	divl   -0x28(%ebp)
  802c8e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c91:	29 d0                	sub    %edx,%eax
  802c93:	c1 e8 0c             	shr    $0xc,%eax
  802c96:	83 ec 0c             	sub    $0xc,%esp
  802c99:	50                   	push   %eax
  802c9a:	e8 0b ed ff ff       	call   8019aa <sbrk>
  802c9f:	83 c4 10             	add    $0x10,%esp
  802ca2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802ca5:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802ca9:	75 0a                	jne    802cb5 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802cab:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb0:	e9 8b 00 00 00       	jmp    802d40 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cb5:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802cbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cbf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cc2:	01 d0                	add    %edx,%eax
  802cc4:	48                   	dec    %eax
  802cc5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802cc8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  802cd0:	f7 75 cc             	divl   -0x34(%ebp)
  802cd3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802cd6:	29 d0                	sub    %edx,%eax
  802cd8:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cdb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cde:	01 d0                	add    %edx,%eax
  802ce0:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802ce5:	a1 44 50 80 00       	mov    0x805044,%eax
  802cea:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802cf0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802cf7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cfa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cfd:	01 d0                	add    %edx,%eax
  802cff:	48                   	dec    %eax
  802d00:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d03:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d06:	ba 00 00 00 00       	mov    $0x0,%edx
  802d0b:	f7 75 c4             	divl   -0x3c(%ebp)
  802d0e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d11:	29 d0                	sub    %edx,%eax
  802d13:	83 ec 04             	sub    $0x4,%esp
  802d16:	6a 01                	push   $0x1
  802d18:	50                   	push   %eax
  802d19:	ff 75 d0             	pushl  -0x30(%ebp)
  802d1c:	e8 36 fb ff ff       	call   802857 <set_block_data>
  802d21:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802d24:	83 ec 0c             	sub    $0xc,%esp
  802d27:	ff 75 d0             	pushl  -0x30(%ebp)
  802d2a:	e8 f8 09 00 00       	call   803727 <free_block>
  802d2f:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802d32:	83 ec 0c             	sub    $0xc,%esp
  802d35:	ff 75 08             	pushl  0x8(%ebp)
  802d38:	e8 49 fb ff ff       	call   802886 <alloc_block_FF>
  802d3d:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802d40:	c9                   	leave  
  802d41:	c3                   	ret    

00802d42 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802d42:	55                   	push   %ebp
  802d43:	89 e5                	mov    %esp,%ebp
  802d45:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	83 e0 01             	and    $0x1,%eax
  802d4e:	85 c0                	test   %eax,%eax
  802d50:	74 03                	je     802d55 <alloc_block_BF+0x13>
  802d52:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802d55:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802d59:	77 07                	ja     802d62 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802d5b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802d62:	a1 28 50 80 00       	mov    0x805028,%eax
  802d67:	85 c0                	test   %eax,%eax
  802d69:	75 73                	jne    802dde <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	83 c0 10             	add    $0x10,%eax
  802d71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802d74:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802d7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d81:	01 d0                	add    %edx,%eax
  802d83:	48                   	dec    %eax
  802d84:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d8a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d8f:	f7 75 e0             	divl   -0x20(%ebp)
  802d92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d95:	29 d0                	sub    %edx,%eax
  802d97:	c1 e8 0c             	shr    $0xc,%eax
  802d9a:	83 ec 0c             	sub    $0xc,%esp
  802d9d:	50                   	push   %eax
  802d9e:	e8 07 ec ff ff       	call   8019aa <sbrk>
  802da3:	83 c4 10             	add    $0x10,%esp
  802da6:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802da9:	83 ec 0c             	sub    $0xc,%esp
  802dac:	6a 00                	push   $0x0
  802dae:	e8 f7 eb ff ff       	call   8019aa <sbrk>
  802db3:	83 c4 10             	add    $0x10,%esp
  802db6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802db9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dbc:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802dbf:	83 ec 08             	sub    $0x8,%esp
  802dc2:	50                   	push   %eax
  802dc3:	ff 75 d8             	pushl  -0x28(%ebp)
  802dc6:	e8 9f f8 ff ff       	call   80266a <initialize_dynamic_allocator>
  802dcb:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802dce:	83 ec 0c             	sub    $0xc,%esp
  802dd1:	68 f3 4a 80 00       	push   $0x804af3
  802dd6:	e8 2d dc ff ff       	call   800a08 <cprintf>
  802ddb:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802dde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802de5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802dec:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802df3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802dfa:	a1 30 50 80 00       	mov    0x805030,%eax
  802dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e02:	e9 1d 01 00 00       	jmp    802f24 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802e0d:	83 ec 0c             	sub    $0xc,%esp
  802e10:	ff 75 a8             	pushl  -0x58(%ebp)
  802e13:	e8 ee f6 ff ff       	call   802506 <get_block_size>
  802e18:	83 c4 10             	add    $0x10,%esp
  802e1b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	83 c0 08             	add    $0x8,%eax
  802e24:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e27:	0f 87 ef 00 00 00    	ja     802f1c <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	83 c0 18             	add    $0x18,%eax
  802e33:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e36:	77 1d                	ja     802e55 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802e38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e3e:	0f 86 d8 00 00 00    	jbe    802f1c <alloc_block_BF+0x1da>
				{
					best_va = va;
  802e44:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e47:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802e4a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e50:	e9 c7 00 00 00       	jmp    802f1c <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	83 c0 08             	add    $0x8,%eax
  802e5b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e5e:	0f 85 9d 00 00 00    	jne    802f01 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802e64:	83 ec 04             	sub    $0x4,%esp
  802e67:	6a 01                	push   $0x1
  802e69:	ff 75 a4             	pushl  -0x5c(%ebp)
  802e6c:	ff 75 a8             	pushl  -0x58(%ebp)
  802e6f:	e8 e3 f9 ff ff       	call   802857 <set_block_data>
  802e74:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802e77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7b:	75 17                	jne    802e94 <alloc_block_BF+0x152>
  802e7d:	83 ec 04             	sub    $0x4,%esp
  802e80:	68 97 4a 80 00       	push   $0x804a97
  802e85:	68 2c 01 00 00       	push   $0x12c
  802e8a:	68 b5 4a 80 00       	push   $0x804ab5
  802e8f:	e8 b7 d8 ff ff       	call   80074b <_panic>
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	8b 00                	mov    (%eax),%eax
  802e99:	85 c0                	test   %eax,%eax
  802e9b:	74 10                	je     802ead <alloc_block_BF+0x16b>
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea5:	8b 52 04             	mov    0x4(%edx),%edx
  802ea8:	89 50 04             	mov    %edx,0x4(%eax)
  802eab:	eb 0b                	jmp    802eb8 <alloc_block_BF+0x176>
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	8b 40 04             	mov    0x4(%eax),%eax
  802eb3:	a3 34 50 80 00       	mov    %eax,0x805034
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	8b 40 04             	mov    0x4(%eax),%eax
  802ebe:	85 c0                	test   %eax,%eax
  802ec0:	74 0f                	je     802ed1 <alloc_block_BF+0x18f>
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 40 04             	mov    0x4(%eax),%eax
  802ec8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ecb:	8b 12                	mov    (%edx),%edx
  802ecd:	89 10                	mov    %edx,(%eax)
  802ecf:	eb 0a                	jmp    802edb <alloc_block_BF+0x199>
  802ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed4:	8b 00                	mov    (%eax),%eax
  802ed6:	a3 30 50 80 00       	mov    %eax,0x805030
  802edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ede:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eee:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ef3:	48                   	dec    %eax
  802ef4:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802ef9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802efc:	e9 01 04 00 00       	jmp    803302 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802f01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f04:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f07:	76 13                	jbe    802f1c <alloc_block_BF+0x1da>
					{
						internal = 1;
  802f09:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802f10:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802f16:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f19:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802f1c:	a1 38 50 80 00       	mov    0x805038,%eax
  802f21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f28:	74 07                	je     802f31 <alloc_block_BF+0x1ef>
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	eb 05                	jmp    802f36 <alloc_block_BF+0x1f4>
  802f31:	b8 00 00 00 00       	mov    $0x0,%eax
  802f36:	a3 38 50 80 00       	mov    %eax,0x805038
  802f3b:	a1 38 50 80 00       	mov    0x805038,%eax
  802f40:	85 c0                	test   %eax,%eax
  802f42:	0f 85 bf fe ff ff    	jne    802e07 <alloc_block_BF+0xc5>
  802f48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4c:	0f 85 b5 fe ff ff    	jne    802e07 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802f52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f56:	0f 84 26 02 00 00    	je     803182 <alloc_block_BF+0x440>
  802f5c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f60:	0f 85 1c 02 00 00    	jne    803182 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f69:	2b 45 08             	sub    0x8(%ebp),%eax
  802f6c:	83 e8 08             	sub    $0x8,%eax
  802f6f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802f72:	8b 45 08             	mov    0x8(%ebp),%eax
  802f75:	8d 50 08             	lea    0x8(%eax),%edx
  802f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7b:	01 d0                	add    %edx,%eax
  802f7d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	83 c0 08             	add    $0x8,%eax
  802f86:	83 ec 04             	sub    $0x4,%esp
  802f89:	6a 01                	push   $0x1
  802f8b:	50                   	push   %eax
  802f8c:	ff 75 f0             	pushl  -0x10(%ebp)
  802f8f:	e8 c3 f8 ff ff       	call   802857 <set_block_data>
  802f94:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9a:	8b 40 04             	mov    0x4(%eax),%eax
  802f9d:	85 c0                	test   %eax,%eax
  802f9f:	75 68                	jne    803009 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802fa1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fa5:	75 17                	jne    802fbe <alloc_block_BF+0x27c>
  802fa7:	83 ec 04             	sub    $0x4,%esp
  802faa:	68 d0 4a 80 00       	push   $0x804ad0
  802faf:	68 45 01 00 00       	push   $0x145
  802fb4:	68 b5 4a 80 00       	push   $0x804ab5
  802fb9:	e8 8d d7 ff ff       	call   80074b <_panic>
  802fbe:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fc4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fc7:	89 10                	mov    %edx,(%eax)
  802fc9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fcc:	8b 00                	mov    (%eax),%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	74 0d                	je     802fdf <alloc_block_BF+0x29d>
  802fd2:	a1 30 50 80 00       	mov    0x805030,%eax
  802fd7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fda:	89 50 04             	mov    %edx,0x4(%eax)
  802fdd:	eb 08                	jmp    802fe7 <alloc_block_BF+0x2a5>
  802fdf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fe2:	a3 34 50 80 00       	mov    %eax,0x805034
  802fe7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fea:	a3 30 50 80 00       	mov    %eax,0x805030
  802fef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ff2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ffe:	40                   	inc    %eax
  802fff:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803004:	e9 dc 00 00 00       	jmp    8030e5 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300c:	8b 00                	mov    (%eax),%eax
  80300e:	85 c0                	test   %eax,%eax
  803010:	75 65                	jne    803077 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803012:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803016:	75 17                	jne    80302f <alloc_block_BF+0x2ed>
  803018:	83 ec 04             	sub    $0x4,%esp
  80301b:	68 04 4b 80 00       	push   $0x804b04
  803020:	68 4a 01 00 00       	push   $0x14a
  803025:	68 b5 4a 80 00       	push   $0x804ab5
  80302a:	e8 1c d7 ff ff       	call   80074b <_panic>
  80302f:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803035:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803038:	89 50 04             	mov    %edx,0x4(%eax)
  80303b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80303e:	8b 40 04             	mov    0x4(%eax),%eax
  803041:	85 c0                	test   %eax,%eax
  803043:	74 0c                	je     803051 <alloc_block_BF+0x30f>
  803045:	a1 34 50 80 00       	mov    0x805034,%eax
  80304a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80304d:	89 10                	mov    %edx,(%eax)
  80304f:	eb 08                	jmp    803059 <alloc_block_BF+0x317>
  803051:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803054:	a3 30 50 80 00       	mov    %eax,0x805030
  803059:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80305c:	a3 34 50 80 00       	mov    %eax,0x805034
  803061:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803064:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80306f:	40                   	inc    %eax
  803070:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803075:	eb 6e                	jmp    8030e5 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803077:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80307b:	74 06                	je     803083 <alloc_block_BF+0x341>
  80307d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803081:	75 17                	jne    80309a <alloc_block_BF+0x358>
  803083:	83 ec 04             	sub    $0x4,%esp
  803086:	68 28 4b 80 00       	push   $0x804b28
  80308b:	68 4f 01 00 00       	push   $0x14f
  803090:	68 b5 4a 80 00       	push   $0x804ab5
  803095:	e8 b1 d6 ff ff       	call   80074b <_panic>
  80309a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309d:	8b 10                	mov    (%eax),%edx
  80309f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a2:	89 10                	mov    %edx,(%eax)
  8030a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a7:	8b 00                	mov    (%eax),%eax
  8030a9:	85 c0                	test   %eax,%eax
  8030ab:	74 0b                	je     8030b8 <alloc_block_BF+0x376>
  8030ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b0:	8b 00                	mov    (%eax),%eax
  8030b2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030b5:	89 50 04             	mov    %edx,0x4(%eax)
  8030b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030be:	89 10                	mov    %edx,(%eax)
  8030c0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c6:	89 50 04             	mov    %edx,0x4(%eax)
  8030c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030cc:	8b 00                	mov    (%eax),%eax
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	75 08                	jne    8030da <alloc_block_BF+0x398>
  8030d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030d5:	a3 34 50 80 00       	mov    %eax,0x805034
  8030da:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030df:	40                   	inc    %eax
  8030e0:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8030e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030e9:	75 17                	jne    803102 <alloc_block_BF+0x3c0>
  8030eb:	83 ec 04             	sub    $0x4,%esp
  8030ee:	68 97 4a 80 00       	push   $0x804a97
  8030f3:	68 51 01 00 00       	push   $0x151
  8030f8:	68 b5 4a 80 00       	push   $0x804ab5
  8030fd:	e8 49 d6 ff ff       	call   80074b <_panic>
  803102:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803105:	8b 00                	mov    (%eax),%eax
  803107:	85 c0                	test   %eax,%eax
  803109:	74 10                	je     80311b <alloc_block_BF+0x3d9>
  80310b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310e:	8b 00                	mov    (%eax),%eax
  803110:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803113:	8b 52 04             	mov    0x4(%edx),%edx
  803116:	89 50 04             	mov    %edx,0x4(%eax)
  803119:	eb 0b                	jmp    803126 <alloc_block_BF+0x3e4>
  80311b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311e:	8b 40 04             	mov    0x4(%eax),%eax
  803121:	a3 34 50 80 00       	mov    %eax,0x805034
  803126:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803129:	8b 40 04             	mov    0x4(%eax),%eax
  80312c:	85 c0                	test   %eax,%eax
  80312e:	74 0f                	je     80313f <alloc_block_BF+0x3fd>
  803130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803133:	8b 40 04             	mov    0x4(%eax),%eax
  803136:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803139:	8b 12                	mov    (%edx),%edx
  80313b:	89 10                	mov    %edx,(%eax)
  80313d:	eb 0a                	jmp    803149 <alloc_block_BF+0x407>
  80313f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803142:	8b 00                	mov    (%eax),%eax
  803144:	a3 30 50 80 00       	mov    %eax,0x805030
  803149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803155:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803161:	48                   	dec    %eax
  803162:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  803167:	83 ec 04             	sub    $0x4,%esp
  80316a:	6a 00                	push   $0x0
  80316c:	ff 75 d0             	pushl  -0x30(%ebp)
  80316f:	ff 75 cc             	pushl  -0x34(%ebp)
  803172:	e8 e0 f6 ff ff       	call   802857 <set_block_data>
  803177:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80317a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317d:	e9 80 01 00 00       	jmp    803302 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  803182:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803186:	0f 85 9d 00 00 00    	jne    803229 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80318c:	83 ec 04             	sub    $0x4,%esp
  80318f:	6a 01                	push   $0x1
  803191:	ff 75 ec             	pushl  -0x14(%ebp)
  803194:	ff 75 f0             	pushl  -0x10(%ebp)
  803197:	e8 bb f6 ff ff       	call   802857 <set_block_data>
  80319c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80319f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031a3:	75 17                	jne    8031bc <alloc_block_BF+0x47a>
  8031a5:	83 ec 04             	sub    $0x4,%esp
  8031a8:	68 97 4a 80 00       	push   $0x804a97
  8031ad:	68 58 01 00 00       	push   $0x158
  8031b2:	68 b5 4a 80 00       	push   $0x804ab5
  8031b7:	e8 8f d5 ff ff       	call   80074b <_panic>
  8031bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bf:	8b 00                	mov    (%eax),%eax
  8031c1:	85 c0                	test   %eax,%eax
  8031c3:	74 10                	je     8031d5 <alloc_block_BF+0x493>
  8031c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c8:	8b 00                	mov    (%eax),%eax
  8031ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031cd:	8b 52 04             	mov    0x4(%edx),%edx
  8031d0:	89 50 04             	mov    %edx,0x4(%eax)
  8031d3:	eb 0b                	jmp    8031e0 <alloc_block_BF+0x49e>
  8031d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d8:	8b 40 04             	mov    0x4(%eax),%eax
  8031db:	a3 34 50 80 00       	mov    %eax,0x805034
  8031e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e3:	8b 40 04             	mov    0x4(%eax),%eax
  8031e6:	85 c0                	test   %eax,%eax
  8031e8:	74 0f                	je     8031f9 <alloc_block_BF+0x4b7>
  8031ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ed:	8b 40 04             	mov    0x4(%eax),%eax
  8031f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031f3:	8b 12                	mov    (%edx),%edx
  8031f5:	89 10                	mov    %edx,(%eax)
  8031f7:	eb 0a                	jmp    803203 <alloc_block_BF+0x4c1>
  8031f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fc:	8b 00                	mov    (%eax),%eax
  8031fe:	a3 30 50 80 00       	mov    %eax,0x805030
  803203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803206:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80320c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803216:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80321b:	48                   	dec    %eax
  80321c:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  803221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803224:	e9 d9 00 00 00       	jmp    803302 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	83 c0 08             	add    $0x8,%eax
  80322f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803232:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803239:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80323c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80323f:	01 d0                	add    %edx,%eax
  803241:	48                   	dec    %eax
  803242:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803245:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803248:	ba 00 00 00 00       	mov    $0x0,%edx
  80324d:	f7 75 c4             	divl   -0x3c(%ebp)
  803250:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803253:	29 d0                	sub    %edx,%eax
  803255:	c1 e8 0c             	shr    $0xc,%eax
  803258:	83 ec 0c             	sub    $0xc,%esp
  80325b:	50                   	push   %eax
  80325c:	e8 49 e7 ff ff       	call   8019aa <sbrk>
  803261:	83 c4 10             	add    $0x10,%esp
  803264:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803267:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80326b:	75 0a                	jne    803277 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80326d:	b8 00 00 00 00       	mov    $0x0,%eax
  803272:	e9 8b 00 00 00       	jmp    803302 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803277:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80327e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803281:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803284:	01 d0                	add    %edx,%eax
  803286:	48                   	dec    %eax
  803287:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80328a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80328d:	ba 00 00 00 00       	mov    $0x0,%edx
  803292:	f7 75 b8             	divl   -0x48(%ebp)
  803295:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803298:	29 d0                	sub    %edx,%eax
  80329a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80329d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8032a0:	01 d0                	add    %edx,%eax
  8032a2:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  8032a7:	a1 44 50 80 00       	mov    0x805044,%eax
  8032ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8032b2:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8032b9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032bf:	01 d0                	add    %edx,%eax
  8032c1:	48                   	dec    %eax
  8032c2:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8032c5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8032c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8032cd:	f7 75 b0             	divl   -0x50(%ebp)
  8032d0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8032d3:	29 d0                	sub    %edx,%eax
  8032d5:	83 ec 04             	sub    $0x4,%esp
  8032d8:	6a 01                	push   $0x1
  8032da:	50                   	push   %eax
  8032db:	ff 75 bc             	pushl  -0x44(%ebp)
  8032de:	e8 74 f5 ff ff       	call   802857 <set_block_data>
  8032e3:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8032e6:	83 ec 0c             	sub    $0xc,%esp
  8032e9:	ff 75 bc             	pushl  -0x44(%ebp)
  8032ec:	e8 36 04 00 00       	call   803727 <free_block>
  8032f1:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8032f4:	83 ec 0c             	sub    $0xc,%esp
  8032f7:	ff 75 08             	pushl  0x8(%ebp)
  8032fa:	e8 43 fa ff ff       	call   802d42 <alloc_block_BF>
  8032ff:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803302:	c9                   	leave  
  803303:	c3                   	ret    

00803304 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803304:	55                   	push   %ebp
  803305:	89 e5                	mov    %esp,%ebp
  803307:	53                   	push   %ebx
  803308:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80330b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803312:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803319:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80331d:	74 1e                	je     80333d <merging+0x39>
  80331f:	ff 75 08             	pushl  0x8(%ebp)
  803322:	e8 df f1 ff ff       	call   802506 <get_block_size>
  803327:	83 c4 04             	add    $0x4,%esp
  80332a:	89 c2                	mov    %eax,%edx
  80332c:	8b 45 08             	mov    0x8(%ebp),%eax
  80332f:	01 d0                	add    %edx,%eax
  803331:	3b 45 10             	cmp    0x10(%ebp),%eax
  803334:	75 07                	jne    80333d <merging+0x39>
		prev_is_free = 1;
  803336:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80333d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803341:	74 1e                	je     803361 <merging+0x5d>
  803343:	ff 75 10             	pushl  0x10(%ebp)
  803346:	e8 bb f1 ff ff       	call   802506 <get_block_size>
  80334b:	83 c4 04             	add    $0x4,%esp
  80334e:	89 c2                	mov    %eax,%edx
  803350:	8b 45 10             	mov    0x10(%ebp),%eax
  803353:	01 d0                	add    %edx,%eax
  803355:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803358:	75 07                	jne    803361 <merging+0x5d>
		next_is_free = 1;
  80335a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803361:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803365:	0f 84 cc 00 00 00    	je     803437 <merging+0x133>
  80336b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80336f:	0f 84 c2 00 00 00    	je     803437 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803375:	ff 75 08             	pushl  0x8(%ebp)
  803378:	e8 89 f1 ff ff       	call   802506 <get_block_size>
  80337d:	83 c4 04             	add    $0x4,%esp
  803380:	89 c3                	mov    %eax,%ebx
  803382:	ff 75 10             	pushl  0x10(%ebp)
  803385:	e8 7c f1 ff ff       	call   802506 <get_block_size>
  80338a:	83 c4 04             	add    $0x4,%esp
  80338d:	01 c3                	add    %eax,%ebx
  80338f:	ff 75 0c             	pushl  0xc(%ebp)
  803392:	e8 6f f1 ff ff       	call   802506 <get_block_size>
  803397:	83 c4 04             	add    $0x4,%esp
  80339a:	01 d8                	add    %ebx,%eax
  80339c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80339f:	6a 00                	push   $0x0
  8033a1:	ff 75 ec             	pushl  -0x14(%ebp)
  8033a4:	ff 75 08             	pushl  0x8(%ebp)
  8033a7:	e8 ab f4 ff ff       	call   802857 <set_block_data>
  8033ac:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8033af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033b3:	75 17                	jne    8033cc <merging+0xc8>
  8033b5:	83 ec 04             	sub    $0x4,%esp
  8033b8:	68 97 4a 80 00       	push   $0x804a97
  8033bd:	68 7d 01 00 00       	push   $0x17d
  8033c2:	68 b5 4a 80 00       	push   $0x804ab5
  8033c7:	e8 7f d3 ff ff       	call   80074b <_panic>
  8033cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033cf:	8b 00                	mov    (%eax),%eax
  8033d1:	85 c0                	test   %eax,%eax
  8033d3:	74 10                	je     8033e5 <merging+0xe1>
  8033d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d8:	8b 00                	mov    (%eax),%eax
  8033da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033dd:	8b 52 04             	mov    0x4(%edx),%edx
  8033e0:	89 50 04             	mov    %edx,0x4(%eax)
  8033e3:	eb 0b                	jmp    8033f0 <merging+0xec>
  8033e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e8:	8b 40 04             	mov    0x4(%eax),%eax
  8033eb:	a3 34 50 80 00       	mov    %eax,0x805034
  8033f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f3:	8b 40 04             	mov    0x4(%eax),%eax
  8033f6:	85 c0                	test   %eax,%eax
  8033f8:	74 0f                	je     803409 <merging+0x105>
  8033fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033fd:	8b 40 04             	mov    0x4(%eax),%eax
  803400:	8b 55 0c             	mov    0xc(%ebp),%edx
  803403:	8b 12                	mov    (%edx),%edx
  803405:	89 10                	mov    %edx,(%eax)
  803407:	eb 0a                	jmp    803413 <merging+0x10f>
  803409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80340c:	8b 00                	mov    (%eax),%eax
  80340e:	a3 30 50 80 00       	mov    %eax,0x805030
  803413:	8b 45 0c             	mov    0xc(%ebp),%eax
  803416:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80341c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80341f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803426:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80342b:	48                   	dec    %eax
  80342c:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803431:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803432:	e9 ea 02 00 00       	jmp    803721 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803437:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80343b:	74 3b                	je     803478 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80343d:	83 ec 0c             	sub    $0xc,%esp
  803440:	ff 75 08             	pushl  0x8(%ebp)
  803443:	e8 be f0 ff ff       	call   802506 <get_block_size>
  803448:	83 c4 10             	add    $0x10,%esp
  80344b:	89 c3                	mov    %eax,%ebx
  80344d:	83 ec 0c             	sub    $0xc,%esp
  803450:	ff 75 10             	pushl  0x10(%ebp)
  803453:	e8 ae f0 ff ff       	call   802506 <get_block_size>
  803458:	83 c4 10             	add    $0x10,%esp
  80345b:	01 d8                	add    %ebx,%eax
  80345d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803460:	83 ec 04             	sub    $0x4,%esp
  803463:	6a 00                	push   $0x0
  803465:	ff 75 e8             	pushl  -0x18(%ebp)
  803468:	ff 75 08             	pushl  0x8(%ebp)
  80346b:	e8 e7 f3 ff ff       	call   802857 <set_block_data>
  803470:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803473:	e9 a9 02 00 00       	jmp    803721 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803478:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80347c:	0f 84 2d 01 00 00    	je     8035af <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803482:	83 ec 0c             	sub    $0xc,%esp
  803485:	ff 75 10             	pushl  0x10(%ebp)
  803488:	e8 79 f0 ff ff       	call   802506 <get_block_size>
  80348d:	83 c4 10             	add    $0x10,%esp
  803490:	89 c3                	mov    %eax,%ebx
  803492:	83 ec 0c             	sub    $0xc,%esp
  803495:	ff 75 0c             	pushl  0xc(%ebp)
  803498:	e8 69 f0 ff ff       	call   802506 <get_block_size>
  80349d:	83 c4 10             	add    $0x10,%esp
  8034a0:	01 d8                	add    %ebx,%eax
  8034a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8034a5:	83 ec 04             	sub    $0x4,%esp
  8034a8:	6a 00                	push   $0x0
  8034aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034ad:	ff 75 10             	pushl  0x10(%ebp)
  8034b0:	e8 a2 f3 ff ff       	call   802857 <set_block_data>
  8034b5:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8034b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8034bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8034be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034c2:	74 06                	je     8034ca <merging+0x1c6>
  8034c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034c8:	75 17                	jne    8034e1 <merging+0x1dd>
  8034ca:	83 ec 04             	sub    $0x4,%esp
  8034cd:	68 5c 4b 80 00       	push   $0x804b5c
  8034d2:	68 8d 01 00 00       	push   $0x18d
  8034d7:	68 b5 4a 80 00       	push   $0x804ab5
  8034dc:	e8 6a d2 ff ff       	call   80074b <_panic>
  8034e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e4:	8b 50 04             	mov    0x4(%eax),%edx
  8034e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034ea:	89 50 04             	mov    %edx,0x4(%eax)
  8034ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034f3:	89 10                	mov    %edx,(%eax)
  8034f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f8:	8b 40 04             	mov    0x4(%eax),%eax
  8034fb:	85 c0                	test   %eax,%eax
  8034fd:	74 0d                	je     80350c <merging+0x208>
  8034ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803502:	8b 40 04             	mov    0x4(%eax),%eax
  803505:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803508:	89 10                	mov    %edx,(%eax)
  80350a:	eb 08                	jmp    803514 <merging+0x210>
  80350c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80350f:	a3 30 50 80 00       	mov    %eax,0x805030
  803514:	8b 45 0c             	mov    0xc(%ebp),%eax
  803517:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80351a:	89 50 04             	mov    %edx,0x4(%eax)
  80351d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803522:	40                   	inc    %eax
  803523:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  803528:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80352c:	75 17                	jne    803545 <merging+0x241>
  80352e:	83 ec 04             	sub    $0x4,%esp
  803531:	68 97 4a 80 00       	push   $0x804a97
  803536:	68 8e 01 00 00       	push   $0x18e
  80353b:	68 b5 4a 80 00       	push   $0x804ab5
  803540:	e8 06 d2 ff ff       	call   80074b <_panic>
  803545:	8b 45 0c             	mov    0xc(%ebp),%eax
  803548:	8b 00                	mov    (%eax),%eax
  80354a:	85 c0                	test   %eax,%eax
  80354c:	74 10                	je     80355e <merging+0x25a>
  80354e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803551:	8b 00                	mov    (%eax),%eax
  803553:	8b 55 0c             	mov    0xc(%ebp),%edx
  803556:	8b 52 04             	mov    0x4(%edx),%edx
  803559:	89 50 04             	mov    %edx,0x4(%eax)
  80355c:	eb 0b                	jmp    803569 <merging+0x265>
  80355e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803561:	8b 40 04             	mov    0x4(%eax),%eax
  803564:	a3 34 50 80 00       	mov    %eax,0x805034
  803569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80356c:	8b 40 04             	mov    0x4(%eax),%eax
  80356f:	85 c0                	test   %eax,%eax
  803571:	74 0f                	je     803582 <merging+0x27e>
  803573:	8b 45 0c             	mov    0xc(%ebp),%eax
  803576:	8b 40 04             	mov    0x4(%eax),%eax
  803579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80357c:	8b 12                	mov    (%edx),%edx
  80357e:	89 10                	mov    %edx,(%eax)
  803580:	eb 0a                	jmp    80358c <merging+0x288>
  803582:	8b 45 0c             	mov    0xc(%ebp),%eax
  803585:	8b 00                	mov    (%eax),%eax
  803587:	a3 30 50 80 00       	mov    %eax,0x805030
  80358c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80358f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803595:	8b 45 0c             	mov    0xc(%ebp),%eax
  803598:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035a4:	48                   	dec    %eax
  8035a5:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035aa:	e9 72 01 00 00       	jmp    803721 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8035af:	8b 45 10             	mov    0x10(%ebp),%eax
  8035b2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8035b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035b9:	74 79                	je     803634 <merging+0x330>
  8035bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035bf:	74 73                	je     803634 <merging+0x330>
  8035c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035c5:	74 06                	je     8035cd <merging+0x2c9>
  8035c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035cb:	75 17                	jne    8035e4 <merging+0x2e0>
  8035cd:	83 ec 04             	sub    $0x4,%esp
  8035d0:	68 28 4b 80 00       	push   $0x804b28
  8035d5:	68 94 01 00 00       	push   $0x194
  8035da:	68 b5 4a 80 00       	push   $0x804ab5
  8035df:	e8 67 d1 ff ff       	call   80074b <_panic>
  8035e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e7:	8b 10                	mov    (%eax),%edx
  8035e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035ec:	89 10                	mov    %edx,(%eax)
  8035ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035f1:	8b 00                	mov    (%eax),%eax
  8035f3:	85 c0                	test   %eax,%eax
  8035f5:	74 0b                	je     803602 <merging+0x2fe>
  8035f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fa:	8b 00                	mov    (%eax),%eax
  8035fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035ff:	89 50 04             	mov    %edx,0x4(%eax)
  803602:	8b 45 08             	mov    0x8(%ebp),%eax
  803605:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803608:	89 10                	mov    %edx,(%eax)
  80360a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80360d:	8b 55 08             	mov    0x8(%ebp),%edx
  803610:	89 50 04             	mov    %edx,0x4(%eax)
  803613:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803616:	8b 00                	mov    (%eax),%eax
  803618:	85 c0                	test   %eax,%eax
  80361a:	75 08                	jne    803624 <merging+0x320>
  80361c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80361f:	a3 34 50 80 00       	mov    %eax,0x805034
  803624:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803629:	40                   	inc    %eax
  80362a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80362f:	e9 ce 00 00 00       	jmp    803702 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803634:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803638:	74 65                	je     80369f <merging+0x39b>
  80363a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80363e:	75 17                	jne    803657 <merging+0x353>
  803640:	83 ec 04             	sub    $0x4,%esp
  803643:	68 04 4b 80 00       	push   $0x804b04
  803648:	68 95 01 00 00       	push   $0x195
  80364d:	68 b5 4a 80 00       	push   $0x804ab5
  803652:	e8 f4 d0 ff ff       	call   80074b <_panic>
  803657:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80365d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803660:	89 50 04             	mov    %edx,0x4(%eax)
  803663:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803666:	8b 40 04             	mov    0x4(%eax),%eax
  803669:	85 c0                	test   %eax,%eax
  80366b:	74 0c                	je     803679 <merging+0x375>
  80366d:	a1 34 50 80 00       	mov    0x805034,%eax
  803672:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803675:	89 10                	mov    %edx,(%eax)
  803677:	eb 08                	jmp    803681 <merging+0x37d>
  803679:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80367c:	a3 30 50 80 00       	mov    %eax,0x805030
  803681:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803684:	a3 34 50 80 00       	mov    %eax,0x805034
  803689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80368c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803692:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803697:	40                   	inc    %eax
  803698:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80369d:	eb 63                	jmp    803702 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80369f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036a3:	75 17                	jne    8036bc <merging+0x3b8>
  8036a5:	83 ec 04             	sub    $0x4,%esp
  8036a8:	68 d0 4a 80 00       	push   $0x804ad0
  8036ad:	68 98 01 00 00       	push   $0x198
  8036b2:	68 b5 4a 80 00       	push   $0x804ab5
  8036b7:	e8 8f d0 ff ff       	call   80074b <_panic>
  8036bc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036c5:	89 10                	mov    %edx,(%eax)
  8036c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ca:	8b 00                	mov    (%eax),%eax
  8036cc:	85 c0                	test   %eax,%eax
  8036ce:	74 0d                	je     8036dd <merging+0x3d9>
  8036d0:	a1 30 50 80 00       	mov    0x805030,%eax
  8036d5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036d8:	89 50 04             	mov    %edx,0x4(%eax)
  8036db:	eb 08                	jmp    8036e5 <merging+0x3e1>
  8036dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036e0:	a3 34 50 80 00       	mov    %eax,0x805034
  8036e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036e8:	a3 30 50 80 00       	mov    %eax,0x805030
  8036ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036fc:	40                   	inc    %eax
  8036fd:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803702:	83 ec 0c             	sub    $0xc,%esp
  803705:	ff 75 10             	pushl  0x10(%ebp)
  803708:	e8 f9 ed ff ff       	call   802506 <get_block_size>
  80370d:	83 c4 10             	add    $0x10,%esp
  803710:	83 ec 04             	sub    $0x4,%esp
  803713:	6a 00                	push   $0x0
  803715:	50                   	push   %eax
  803716:	ff 75 10             	pushl  0x10(%ebp)
  803719:	e8 39 f1 ff ff       	call   802857 <set_block_data>
  80371e:	83 c4 10             	add    $0x10,%esp
	}
}
  803721:	90                   	nop
  803722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803725:	c9                   	leave  
  803726:	c3                   	ret    

00803727 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803727:	55                   	push   %ebp
  803728:	89 e5                	mov    %esp,%ebp
  80372a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80372d:	a1 30 50 80 00       	mov    0x805030,%eax
  803732:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803735:	a1 34 50 80 00       	mov    0x805034,%eax
  80373a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80373d:	73 1b                	jae    80375a <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80373f:	a1 34 50 80 00       	mov    0x805034,%eax
  803744:	83 ec 04             	sub    $0x4,%esp
  803747:	ff 75 08             	pushl  0x8(%ebp)
  80374a:	6a 00                	push   $0x0
  80374c:	50                   	push   %eax
  80374d:	e8 b2 fb ff ff       	call   803304 <merging>
  803752:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803755:	e9 8b 00 00 00       	jmp    8037e5 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80375a:	a1 30 50 80 00       	mov    0x805030,%eax
  80375f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803762:	76 18                	jbe    80377c <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803764:	a1 30 50 80 00       	mov    0x805030,%eax
  803769:	83 ec 04             	sub    $0x4,%esp
  80376c:	ff 75 08             	pushl  0x8(%ebp)
  80376f:	50                   	push   %eax
  803770:	6a 00                	push   $0x0
  803772:	e8 8d fb ff ff       	call   803304 <merging>
  803777:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80377a:	eb 69                	jmp    8037e5 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80377c:	a1 30 50 80 00       	mov    0x805030,%eax
  803781:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803784:	eb 39                	jmp    8037bf <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803789:	3b 45 08             	cmp    0x8(%ebp),%eax
  80378c:	73 29                	jae    8037b7 <free_block+0x90>
  80378e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803791:	8b 00                	mov    (%eax),%eax
  803793:	3b 45 08             	cmp    0x8(%ebp),%eax
  803796:	76 1f                	jbe    8037b7 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379b:	8b 00                	mov    (%eax),%eax
  80379d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8037a0:	83 ec 04             	sub    $0x4,%esp
  8037a3:	ff 75 08             	pushl  0x8(%ebp)
  8037a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8037a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8037ac:	e8 53 fb ff ff       	call   803304 <merging>
  8037b1:	83 c4 10             	add    $0x10,%esp
			break;
  8037b4:	90                   	nop
		}
	}
}
  8037b5:	eb 2e                	jmp    8037e5 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8037b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8037bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037c3:	74 07                	je     8037cc <free_block+0xa5>
  8037c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c8:	8b 00                	mov    (%eax),%eax
  8037ca:	eb 05                	jmp    8037d1 <free_block+0xaa>
  8037cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8037d1:	a3 38 50 80 00       	mov    %eax,0x805038
  8037d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8037db:	85 c0                	test   %eax,%eax
  8037dd:	75 a7                	jne    803786 <free_block+0x5f>
  8037df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e3:	75 a1                	jne    803786 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037e5:	90                   	nop
  8037e6:	c9                   	leave  
  8037e7:	c3                   	ret    

008037e8 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8037e8:	55                   	push   %ebp
  8037e9:	89 e5                	mov    %esp,%ebp
  8037eb:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8037ee:	ff 75 08             	pushl  0x8(%ebp)
  8037f1:	e8 10 ed ff ff       	call   802506 <get_block_size>
  8037f6:	83 c4 04             	add    $0x4,%esp
  8037f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8037fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803803:	eb 17                	jmp    80381c <copy_data+0x34>
  803805:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803808:	8b 45 0c             	mov    0xc(%ebp),%eax
  80380b:	01 c2                	add    %eax,%edx
  80380d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803810:	8b 45 08             	mov    0x8(%ebp),%eax
  803813:	01 c8                	add    %ecx,%eax
  803815:	8a 00                	mov    (%eax),%al
  803817:	88 02                	mov    %al,(%edx)
  803819:	ff 45 fc             	incl   -0x4(%ebp)
  80381c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80381f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803822:	72 e1                	jb     803805 <copy_data+0x1d>
}
  803824:	90                   	nop
  803825:	c9                   	leave  
  803826:	c3                   	ret    

00803827 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803827:	55                   	push   %ebp
  803828:	89 e5                	mov    %esp,%ebp
  80382a:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80382d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803831:	75 23                	jne    803856 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803833:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803837:	74 13                	je     80384c <realloc_block_FF+0x25>
  803839:	83 ec 0c             	sub    $0xc,%esp
  80383c:	ff 75 0c             	pushl  0xc(%ebp)
  80383f:	e8 42 f0 ff ff       	call   802886 <alloc_block_FF>
  803844:	83 c4 10             	add    $0x10,%esp
  803847:	e9 e4 06 00 00       	jmp    803f30 <realloc_block_FF+0x709>
		return NULL;
  80384c:	b8 00 00 00 00       	mov    $0x0,%eax
  803851:	e9 da 06 00 00       	jmp    803f30 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803856:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80385a:	75 18                	jne    803874 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80385c:	83 ec 0c             	sub    $0xc,%esp
  80385f:	ff 75 08             	pushl  0x8(%ebp)
  803862:	e8 c0 fe ff ff       	call   803727 <free_block>
  803867:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80386a:	b8 00 00 00 00       	mov    $0x0,%eax
  80386f:	e9 bc 06 00 00       	jmp    803f30 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803874:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803878:	77 07                	ja     803881 <realloc_block_FF+0x5a>
  80387a:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803881:	8b 45 0c             	mov    0xc(%ebp),%eax
  803884:	83 e0 01             	and    $0x1,%eax
  803887:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80388a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80388d:	83 c0 08             	add    $0x8,%eax
  803890:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803893:	83 ec 0c             	sub    $0xc,%esp
  803896:	ff 75 08             	pushl  0x8(%ebp)
  803899:	e8 68 ec ff ff       	call   802506 <get_block_size>
  80389e:	83 c4 10             	add    $0x10,%esp
  8038a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8038a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038a7:	83 e8 08             	sub    $0x8,%eax
  8038aa:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8038ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b0:	83 e8 04             	sub    $0x4,%eax
  8038b3:	8b 00                	mov    (%eax),%eax
  8038b5:	83 e0 fe             	and    $0xfffffffe,%eax
  8038b8:	89 c2                	mov    %eax,%edx
  8038ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bd:	01 d0                	add    %edx,%eax
  8038bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8038c2:	83 ec 0c             	sub    $0xc,%esp
  8038c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038c8:	e8 39 ec ff ff       	call   802506 <get_block_size>
  8038cd:	83 c4 10             	add    $0x10,%esp
  8038d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8038d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038d6:	83 e8 08             	sub    $0x8,%eax
  8038d9:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8038dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038df:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038e2:	75 08                	jne    8038ec <realloc_block_FF+0xc5>
	{
		 return va;
  8038e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e7:	e9 44 06 00 00       	jmp    803f30 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8038ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038ef:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038f2:	0f 83 d5 03 00 00    	jae    803ccd <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8038f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038fb:	2b 45 0c             	sub    0xc(%ebp),%eax
  8038fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803901:	83 ec 0c             	sub    $0xc,%esp
  803904:	ff 75 e4             	pushl  -0x1c(%ebp)
  803907:	e8 13 ec ff ff       	call   80251f <is_free_block>
  80390c:	83 c4 10             	add    $0x10,%esp
  80390f:	84 c0                	test   %al,%al
  803911:	0f 84 3b 01 00 00    	je     803a52 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803917:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80391a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80391d:	01 d0                	add    %edx,%eax
  80391f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803922:	83 ec 04             	sub    $0x4,%esp
  803925:	6a 01                	push   $0x1
  803927:	ff 75 f0             	pushl  -0x10(%ebp)
  80392a:	ff 75 08             	pushl  0x8(%ebp)
  80392d:	e8 25 ef ff ff       	call   802857 <set_block_data>
  803932:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803935:	8b 45 08             	mov    0x8(%ebp),%eax
  803938:	83 e8 04             	sub    $0x4,%eax
  80393b:	8b 00                	mov    (%eax),%eax
  80393d:	83 e0 fe             	and    $0xfffffffe,%eax
  803940:	89 c2                	mov    %eax,%edx
  803942:	8b 45 08             	mov    0x8(%ebp),%eax
  803945:	01 d0                	add    %edx,%eax
  803947:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80394a:	83 ec 04             	sub    $0x4,%esp
  80394d:	6a 00                	push   $0x0
  80394f:	ff 75 cc             	pushl  -0x34(%ebp)
  803952:	ff 75 c8             	pushl  -0x38(%ebp)
  803955:	e8 fd ee ff ff       	call   802857 <set_block_data>
  80395a:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80395d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803961:	74 06                	je     803969 <realloc_block_FF+0x142>
  803963:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803967:	75 17                	jne    803980 <realloc_block_FF+0x159>
  803969:	83 ec 04             	sub    $0x4,%esp
  80396c:	68 28 4b 80 00       	push   $0x804b28
  803971:	68 f6 01 00 00       	push   $0x1f6
  803976:	68 b5 4a 80 00       	push   $0x804ab5
  80397b:	e8 cb cd ff ff       	call   80074b <_panic>
  803980:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803983:	8b 10                	mov    (%eax),%edx
  803985:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803988:	89 10                	mov    %edx,(%eax)
  80398a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80398d:	8b 00                	mov    (%eax),%eax
  80398f:	85 c0                	test   %eax,%eax
  803991:	74 0b                	je     80399e <realloc_block_FF+0x177>
  803993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803996:	8b 00                	mov    (%eax),%eax
  803998:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80399b:	89 50 04             	mov    %edx,0x4(%eax)
  80399e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039a4:	89 10                	mov    %edx,(%eax)
  8039a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039ac:	89 50 04             	mov    %edx,0x4(%eax)
  8039af:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039b2:	8b 00                	mov    (%eax),%eax
  8039b4:	85 c0                	test   %eax,%eax
  8039b6:	75 08                	jne    8039c0 <realloc_block_FF+0x199>
  8039b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039bb:	a3 34 50 80 00       	mov    %eax,0x805034
  8039c0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039c5:	40                   	inc    %eax
  8039c6:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8039cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039cf:	75 17                	jne    8039e8 <realloc_block_FF+0x1c1>
  8039d1:	83 ec 04             	sub    $0x4,%esp
  8039d4:	68 97 4a 80 00       	push   $0x804a97
  8039d9:	68 f7 01 00 00       	push   $0x1f7
  8039de:	68 b5 4a 80 00       	push   $0x804ab5
  8039e3:	e8 63 cd ff ff       	call   80074b <_panic>
  8039e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039eb:	8b 00                	mov    (%eax),%eax
  8039ed:	85 c0                	test   %eax,%eax
  8039ef:	74 10                	je     803a01 <realloc_block_FF+0x1da>
  8039f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f4:	8b 00                	mov    (%eax),%eax
  8039f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039f9:	8b 52 04             	mov    0x4(%edx),%edx
  8039fc:	89 50 04             	mov    %edx,0x4(%eax)
  8039ff:	eb 0b                	jmp    803a0c <realloc_block_FF+0x1e5>
  803a01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a04:	8b 40 04             	mov    0x4(%eax),%eax
  803a07:	a3 34 50 80 00       	mov    %eax,0x805034
  803a0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a0f:	8b 40 04             	mov    0x4(%eax),%eax
  803a12:	85 c0                	test   %eax,%eax
  803a14:	74 0f                	je     803a25 <realloc_block_FF+0x1fe>
  803a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a19:	8b 40 04             	mov    0x4(%eax),%eax
  803a1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a1f:	8b 12                	mov    (%edx),%edx
  803a21:	89 10                	mov    %edx,(%eax)
  803a23:	eb 0a                	jmp    803a2f <realloc_block_FF+0x208>
  803a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a28:	8b 00                	mov    (%eax),%eax
  803a2a:	a3 30 50 80 00       	mov    %eax,0x805030
  803a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a42:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a47:	48                   	dec    %eax
  803a48:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a4d:	e9 73 02 00 00       	jmp    803cc5 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803a52:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803a56:	0f 86 69 02 00 00    	jbe    803cc5 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803a5c:	83 ec 04             	sub    $0x4,%esp
  803a5f:	6a 01                	push   $0x1
  803a61:	ff 75 f0             	pushl  -0x10(%ebp)
  803a64:	ff 75 08             	pushl  0x8(%ebp)
  803a67:	e8 eb ed ff ff       	call   802857 <set_block_data>
  803a6c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a72:	83 e8 04             	sub    $0x4,%eax
  803a75:	8b 00                	mov    (%eax),%eax
  803a77:	83 e0 fe             	and    $0xfffffffe,%eax
  803a7a:	89 c2                	mov    %eax,%edx
  803a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7f:	01 d0                	add    %edx,%eax
  803a81:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803a84:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a89:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803a8c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803a90:	75 68                	jne    803afa <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a92:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a96:	75 17                	jne    803aaf <realloc_block_FF+0x288>
  803a98:	83 ec 04             	sub    $0x4,%esp
  803a9b:	68 d0 4a 80 00       	push   $0x804ad0
  803aa0:	68 06 02 00 00       	push   $0x206
  803aa5:	68 b5 4a 80 00       	push   $0x804ab5
  803aaa:	e8 9c cc ff ff       	call   80074b <_panic>
  803aaf:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803ab5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab8:	89 10                	mov    %edx,(%eax)
  803aba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803abd:	8b 00                	mov    (%eax),%eax
  803abf:	85 c0                	test   %eax,%eax
  803ac1:	74 0d                	je     803ad0 <realloc_block_FF+0x2a9>
  803ac3:	a1 30 50 80 00       	mov    0x805030,%eax
  803ac8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803acb:	89 50 04             	mov    %edx,0x4(%eax)
  803ace:	eb 08                	jmp    803ad8 <realloc_block_FF+0x2b1>
  803ad0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ad3:	a3 34 50 80 00       	mov    %eax,0x805034
  803ad8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803adb:	a3 30 50 80 00       	mov    %eax,0x805030
  803ae0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aea:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803aef:	40                   	inc    %eax
  803af0:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803af5:	e9 b0 01 00 00       	jmp    803caa <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803afa:	a1 30 50 80 00       	mov    0x805030,%eax
  803aff:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b02:	76 68                	jbe    803b6c <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b04:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b08:	75 17                	jne    803b21 <realloc_block_FF+0x2fa>
  803b0a:	83 ec 04             	sub    $0x4,%esp
  803b0d:	68 d0 4a 80 00       	push   $0x804ad0
  803b12:	68 0b 02 00 00       	push   $0x20b
  803b17:	68 b5 4a 80 00       	push   $0x804ab5
  803b1c:	e8 2a cc ff ff       	call   80074b <_panic>
  803b21:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b2a:	89 10                	mov    %edx,(%eax)
  803b2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b2f:	8b 00                	mov    (%eax),%eax
  803b31:	85 c0                	test   %eax,%eax
  803b33:	74 0d                	je     803b42 <realloc_block_FF+0x31b>
  803b35:	a1 30 50 80 00       	mov    0x805030,%eax
  803b3a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b3d:	89 50 04             	mov    %edx,0x4(%eax)
  803b40:	eb 08                	jmp    803b4a <realloc_block_FF+0x323>
  803b42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b45:	a3 34 50 80 00       	mov    %eax,0x805034
  803b4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b4d:	a3 30 50 80 00       	mov    %eax,0x805030
  803b52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b5c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b61:	40                   	inc    %eax
  803b62:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b67:	e9 3e 01 00 00       	jmp    803caa <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803b6c:	a1 30 50 80 00       	mov    0x805030,%eax
  803b71:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b74:	73 68                	jae    803bde <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b76:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b7a:	75 17                	jne    803b93 <realloc_block_FF+0x36c>
  803b7c:	83 ec 04             	sub    $0x4,%esp
  803b7f:	68 04 4b 80 00       	push   $0x804b04
  803b84:	68 10 02 00 00       	push   $0x210
  803b89:	68 b5 4a 80 00       	push   $0x804ab5
  803b8e:	e8 b8 cb ff ff       	call   80074b <_panic>
  803b93:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803b99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b9c:	89 50 04             	mov    %edx,0x4(%eax)
  803b9f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ba2:	8b 40 04             	mov    0x4(%eax),%eax
  803ba5:	85 c0                	test   %eax,%eax
  803ba7:	74 0c                	je     803bb5 <realloc_block_FF+0x38e>
  803ba9:	a1 34 50 80 00       	mov    0x805034,%eax
  803bae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bb1:	89 10                	mov    %edx,(%eax)
  803bb3:	eb 08                	jmp    803bbd <realloc_block_FF+0x396>
  803bb5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bb8:	a3 30 50 80 00       	mov    %eax,0x805030
  803bbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc0:	a3 34 50 80 00       	mov    %eax,0x805034
  803bc5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bce:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bd3:	40                   	inc    %eax
  803bd4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803bd9:	e9 cc 00 00 00       	jmp    803caa <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803bde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803be5:	a1 30 50 80 00       	mov    0x805030,%eax
  803bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bed:	e9 8a 00 00 00       	jmp    803c7c <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bf8:	73 7a                	jae    803c74 <realloc_block_FF+0x44d>
  803bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfd:	8b 00                	mov    (%eax),%eax
  803bff:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c02:	73 70                	jae    803c74 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c08:	74 06                	je     803c10 <realloc_block_FF+0x3e9>
  803c0a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c0e:	75 17                	jne    803c27 <realloc_block_FF+0x400>
  803c10:	83 ec 04             	sub    $0x4,%esp
  803c13:	68 28 4b 80 00       	push   $0x804b28
  803c18:	68 1a 02 00 00       	push   $0x21a
  803c1d:	68 b5 4a 80 00       	push   $0x804ab5
  803c22:	e8 24 cb ff ff       	call   80074b <_panic>
  803c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2a:	8b 10                	mov    (%eax),%edx
  803c2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c2f:	89 10                	mov    %edx,(%eax)
  803c31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c34:	8b 00                	mov    (%eax),%eax
  803c36:	85 c0                	test   %eax,%eax
  803c38:	74 0b                	je     803c45 <realloc_block_FF+0x41e>
  803c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c3d:	8b 00                	mov    (%eax),%eax
  803c3f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c42:	89 50 04             	mov    %edx,0x4(%eax)
  803c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c48:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c4b:	89 10                	mov    %edx,(%eax)
  803c4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c53:	89 50 04             	mov    %edx,0x4(%eax)
  803c56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c59:	8b 00                	mov    (%eax),%eax
  803c5b:	85 c0                	test   %eax,%eax
  803c5d:	75 08                	jne    803c67 <realloc_block_FF+0x440>
  803c5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c62:	a3 34 50 80 00       	mov    %eax,0x805034
  803c67:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c6c:	40                   	inc    %eax
  803c6d:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803c72:	eb 36                	jmp    803caa <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803c74:	a1 38 50 80 00       	mov    0x805038,%eax
  803c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c80:	74 07                	je     803c89 <realloc_block_FF+0x462>
  803c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c85:	8b 00                	mov    (%eax),%eax
  803c87:	eb 05                	jmp    803c8e <realloc_block_FF+0x467>
  803c89:	b8 00 00 00 00       	mov    $0x0,%eax
  803c8e:	a3 38 50 80 00       	mov    %eax,0x805038
  803c93:	a1 38 50 80 00       	mov    0x805038,%eax
  803c98:	85 c0                	test   %eax,%eax
  803c9a:	0f 85 52 ff ff ff    	jne    803bf2 <realloc_block_FF+0x3cb>
  803ca0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ca4:	0f 85 48 ff ff ff    	jne    803bf2 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803caa:	83 ec 04             	sub    $0x4,%esp
  803cad:	6a 00                	push   $0x0
  803caf:	ff 75 d8             	pushl  -0x28(%ebp)
  803cb2:	ff 75 d4             	pushl  -0x2c(%ebp)
  803cb5:	e8 9d eb ff ff       	call   802857 <set_block_data>
  803cba:	83 c4 10             	add    $0x10,%esp
				return va;
  803cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc0:	e9 6b 02 00 00       	jmp    803f30 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc8:	e9 63 02 00 00       	jmp    803f30 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cd0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803cd3:	0f 86 4d 02 00 00    	jbe    803f26 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803cd9:	83 ec 0c             	sub    $0xc,%esp
  803cdc:	ff 75 e4             	pushl  -0x1c(%ebp)
  803cdf:	e8 3b e8 ff ff       	call   80251f <is_free_block>
  803ce4:	83 c4 10             	add    $0x10,%esp
  803ce7:	84 c0                	test   %al,%al
  803ce9:	0f 84 37 02 00 00    	je     803f26 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cf2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803cf5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803cf8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803cfb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803cfe:	76 38                	jbe    803d38 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803d00:	83 ec 0c             	sub    $0xc,%esp
  803d03:	ff 75 0c             	pushl  0xc(%ebp)
  803d06:	e8 7b eb ff ff       	call   802886 <alloc_block_FF>
  803d0b:	83 c4 10             	add    $0x10,%esp
  803d0e:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803d11:	83 ec 08             	sub    $0x8,%esp
  803d14:	ff 75 c0             	pushl  -0x40(%ebp)
  803d17:	ff 75 08             	pushl  0x8(%ebp)
  803d1a:	e8 c9 fa ff ff       	call   8037e8 <copy_data>
  803d1f:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803d22:	83 ec 0c             	sub    $0xc,%esp
  803d25:	ff 75 08             	pushl  0x8(%ebp)
  803d28:	e8 fa f9 ff ff       	call   803727 <free_block>
  803d2d:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803d30:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803d33:	e9 f8 01 00 00       	jmp    803f30 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803d38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d3b:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803d3e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803d41:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803d45:	0f 87 a0 00 00 00    	ja     803deb <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803d4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d4f:	75 17                	jne    803d68 <realloc_block_FF+0x541>
  803d51:	83 ec 04             	sub    $0x4,%esp
  803d54:	68 97 4a 80 00       	push   $0x804a97
  803d59:	68 38 02 00 00       	push   $0x238
  803d5e:	68 b5 4a 80 00       	push   $0x804ab5
  803d63:	e8 e3 c9 ff ff       	call   80074b <_panic>
  803d68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d6b:	8b 00                	mov    (%eax),%eax
  803d6d:	85 c0                	test   %eax,%eax
  803d6f:	74 10                	je     803d81 <realloc_block_FF+0x55a>
  803d71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d74:	8b 00                	mov    (%eax),%eax
  803d76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d79:	8b 52 04             	mov    0x4(%edx),%edx
  803d7c:	89 50 04             	mov    %edx,0x4(%eax)
  803d7f:	eb 0b                	jmp    803d8c <realloc_block_FF+0x565>
  803d81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d84:	8b 40 04             	mov    0x4(%eax),%eax
  803d87:	a3 34 50 80 00       	mov    %eax,0x805034
  803d8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d8f:	8b 40 04             	mov    0x4(%eax),%eax
  803d92:	85 c0                	test   %eax,%eax
  803d94:	74 0f                	je     803da5 <realloc_block_FF+0x57e>
  803d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d99:	8b 40 04             	mov    0x4(%eax),%eax
  803d9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d9f:	8b 12                	mov    (%edx),%edx
  803da1:	89 10                	mov    %edx,(%eax)
  803da3:	eb 0a                	jmp    803daf <realloc_block_FF+0x588>
  803da5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da8:	8b 00                	mov    (%eax),%eax
  803daa:	a3 30 50 80 00       	mov    %eax,0x805030
  803daf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803db8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dc2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803dc7:	48                   	dec    %eax
  803dc8:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803dcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803dd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dd3:	01 d0                	add    %edx,%eax
  803dd5:	83 ec 04             	sub    $0x4,%esp
  803dd8:	6a 01                	push   $0x1
  803dda:	50                   	push   %eax
  803ddb:	ff 75 08             	pushl  0x8(%ebp)
  803dde:	e8 74 ea ff ff       	call   802857 <set_block_data>
  803de3:	83 c4 10             	add    $0x10,%esp
  803de6:	e9 36 01 00 00       	jmp    803f21 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803deb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803dee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803df1:	01 d0                	add    %edx,%eax
  803df3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803df6:	83 ec 04             	sub    $0x4,%esp
  803df9:	6a 01                	push   $0x1
  803dfb:	ff 75 f0             	pushl  -0x10(%ebp)
  803dfe:	ff 75 08             	pushl  0x8(%ebp)
  803e01:	e8 51 ea ff ff       	call   802857 <set_block_data>
  803e06:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803e09:	8b 45 08             	mov    0x8(%ebp),%eax
  803e0c:	83 e8 04             	sub    $0x4,%eax
  803e0f:	8b 00                	mov    (%eax),%eax
  803e11:	83 e0 fe             	and    $0xfffffffe,%eax
  803e14:	89 c2                	mov    %eax,%edx
  803e16:	8b 45 08             	mov    0x8(%ebp),%eax
  803e19:	01 d0                	add    %edx,%eax
  803e1b:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803e1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e22:	74 06                	je     803e2a <realloc_block_FF+0x603>
  803e24:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803e28:	75 17                	jne    803e41 <realloc_block_FF+0x61a>
  803e2a:	83 ec 04             	sub    $0x4,%esp
  803e2d:	68 28 4b 80 00       	push   $0x804b28
  803e32:	68 44 02 00 00       	push   $0x244
  803e37:	68 b5 4a 80 00       	push   $0x804ab5
  803e3c:	e8 0a c9 ff ff       	call   80074b <_panic>
  803e41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e44:	8b 10                	mov    (%eax),%edx
  803e46:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e49:	89 10                	mov    %edx,(%eax)
  803e4b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e4e:	8b 00                	mov    (%eax),%eax
  803e50:	85 c0                	test   %eax,%eax
  803e52:	74 0b                	je     803e5f <realloc_block_FF+0x638>
  803e54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e57:	8b 00                	mov    (%eax),%eax
  803e59:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e5c:	89 50 04             	mov    %edx,0x4(%eax)
  803e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e62:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e65:	89 10                	mov    %edx,(%eax)
  803e67:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e6d:	89 50 04             	mov    %edx,0x4(%eax)
  803e70:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e73:	8b 00                	mov    (%eax),%eax
  803e75:	85 c0                	test   %eax,%eax
  803e77:	75 08                	jne    803e81 <realloc_block_FF+0x65a>
  803e79:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e7c:	a3 34 50 80 00       	mov    %eax,0x805034
  803e81:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e86:	40                   	inc    %eax
  803e87:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803e8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e90:	75 17                	jne    803ea9 <realloc_block_FF+0x682>
  803e92:	83 ec 04             	sub    $0x4,%esp
  803e95:	68 97 4a 80 00       	push   $0x804a97
  803e9a:	68 45 02 00 00       	push   $0x245
  803e9f:	68 b5 4a 80 00       	push   $0x804ab5
  803ea4:	e8 a2 c8 ff ff       	call   80074b <_panic>
  803ea9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eac:	8b 00                	mov    (%eax),%eax
  803eae:	85 c0                	test   %eax,%eax
  803eb0:	74 10                	je     803ec2 <realloc_block_FF+0x69b>
  803eb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb5:	8b 00                	mov    (%eax),%eax
  803eb7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803eba:	8b 52 04             	mov    0x4(%edx),%edx
  803ebd:	89 50 04             	mov    %edx,0x4(%eax)
  803ec0:	eb 0b                	jmp    803ecd <realloc_block_FF+0x6a6>
  803ec2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec5:	8b 40 04             	mov    0x4(%eax),%eax
  803ec8:	a3 34 50 80 00       	mov    %eax,0x805034
  803ecd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed0:	8b 40 04             	mov    0x4(%eax),%eax
  803ed3:	85 c0                	test   %eax,%eax
  803ed5:	74 0f                	je     803ee6 <realloc_block_FF+0x6bf>
  803ed7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eda:	8b 40 04             	mov    0x4(%eax),%eax
  803edd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ee0:	8b 12                	mov    (%edx),%edx
  803ee2:	89 10                	mov    %edx,(%eax)
  803ee4:	eb 0a                	jmp    803ef0 <realloc_block_FF+0x6c9>
  803ee6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee9:	8b 00                	mov    (%eax),%eax
  803eeb:	a3 30 50 80 00       	mov    %eax,0x805030
  803ef0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ef9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f03:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f08:	48                   	dec    %eax
  803f09:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803f0e:	83 ec 04             	sub    $0x4,%esp
  803f11:	6a 00                	push   $0x0
  803f13:	ff 75 bc             	pushl  -0x44(%ebp)
  803f16:	ff 75 b8             	pushl  -0x48(%ebp)
  803f19:	e8 39 e9 ff ff       	call   802857 <set_block_data>
  803f1e:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803f21:	8b 45 08             	mov    0x8(%ebp),%eax
  803f24:	eb 0a                	jmp    803f30 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803f26:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803f2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803f30:	c9                   	leave  
  803f31:	c3                   	ret    

00803f32 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803f32:	55                   	push   %ebp
  803f33:	89 e5                	mov    %esp,%ebp
  803f35:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803f38:	83 ec 04             	sub    $0x4,%esp
  803f3b:	68 94 4b 80 00       	push   $0x804b94
  803f40:	68 58 02 00 00       	push   $0x258
  803f45:	68 b5 4a 80 00       	push   $0x804ab5
  803f4a:	e8 fc c7 ff ff       	call   80074b <_panic>

00803f4f <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803f4f:	55                   	push   %ebp
  803f50:	89 e5                	mov    %esp,%ebp
  803f52:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803f55:	83 ec 04             	sub    $0x4,%esp
  803f58:	68 bc 4b 80 00       	push   $0x804bbc
  803f5d:	68 61 02 00 00       	push   $0x261
  803f62:	68 b5 4a 80 00       	push   $0x804ab5
  803f67:	e8 df c7 ff ff       	call   80074b <_panic>

00803f6c <__udivdi3>:
  803f6c:	55                   	push   %ebp
  803f6d:	57                   	push   %edi
  803f6e:	56                   	push   %esi
  803f6f:	53                   	push   %ebx
  803f70:	83 ec 1c             	sub    $0x1c,%esp
  803f73:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f77:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f7f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f83:	89 ca                	mov    %ecx,%edx
  803f85:	89 f8                	mov    %edi,%eax
  803f87:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f8b:	85 f6                	test   %esi,%esi
  803f8d:	75 2d                	jne    803fbc <__udivdi3+0x50>
  803f8f:	39 cf                	cmp    %ecx,%edi
  803f91:	77 65                	ja     803ff8 <__udivdi3+0x8c>
  803f93:	89 fd                	mov    %edi,%ebp
  803f95:	85 ff                	test   %edi,%edi
  803f97:	75 0b                	jne    803fa4 <__udivdi3+0x38>
  803f99:	b8 01 00 00 00       	mov    $0x1,%eax
  803f9e:	31 d2                	xor    %edx,%edx
  803fa0:	f7 f7                	div    %edi
  803fa2:	89 c5                	mov    %eax,%ebp
  803fa4:	31 d2                	xor    %edx,%edx
  803fa6:	89 c8                	mov    %ecx,%eax
  803fa8:	f7 f5                	div    %ebp
  803faa:	89 c1                	mov    %eax,%ecx
  803fac:	89 d8                	mov    %ebx,%eax
  803fae:	f7 f5                	div    %ebp
  803fb0:	89 cf                	mov    %ecx,%edi
  803fb2:	89 fa                	mov    %edi,%edx
  803fb4:	83 c4 1c             	add    $0x1c,%esp
  803fb7:	5b                   	pop    %ebx
  803fb8:	5e                   	pop    %esi
  803fb9:	5f                   	pop    %edi
  803fba:	5d                   	pop    %ebp
  803fbb:	c3                   	ret    
  803fbc:	39 ce                	cmp    %ecx,%esi
  803fbe:	77 28                	ja     803fe8 <__udivdi3+0x7c>
  803fc0:	0f bd fe             	bsr    %esi,%edi
  803fc3:	83 f7 1f             	xor    $0x1f,%edi
  803fc6:	75 40                	jne    804008 <__udivdi3+0x9c>
  803fc8:	39 ce                	cmp    %ecx,%esi
  803fca:	72 0a                	jb     803fd6 <__udivdi3+0x6a>
  803fcc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803fd0:	0f 87 9e 00 00 00    	ja     804074 <__udivdi3+0x108>
  803fd6:	b8 01 00 00 00       	mov    $0x1,%eax
  803fdb:	89 fa                	mov    %edi,%edx
  803fdd:	83 c4 1c             	add    $0x1c,%esp
  803fe0:	5b                   	pop    %ebx
  803fe1:	5e                   	pop    %esi
  803fe2:	5f                   	pop    %edi
  803fe3:	5d                   	pop    %ebp
  803fe4:	c3                   	ret    
  803fe5:	8d 76 00             	lea    0x0(%esi),%esi
  803fe8:	31 ff                	xor    %edi,%edi
  803fea:	31 c0                	xor    %eax,%eax
  803fec:	89 fa                	mov    %edi,%edx
  803fee:	83 c4 1c             	add    $0x1c,%esp
  803ff1:	5b                   	pop    %ebx
  803ff2:	5e                   	pop    %esi
  803ff3:	5f                   	pop    %edi
  803ff4:	5d                   	pop    %ebp
  803ff5:	c3                   	ret    
  803ff6:	66 90                	xchg   %ax,%ax
  803ff8:	89 d8                	mov    %ebx,%eax
  803ffa:	f7 f7                	div    %edi
  803ffc:	31 ff                	xor    %edi,%edi
  803ffe:	89 fa                	mov    %edi,%edx
  804000:	83 c4 1c             	add    $0x1c,%esp
  804003:	5b                   	pop    %ebx
  804004:	5e                   	pop    %esi
  804005:	5f                   	pop    %edi
  804006:	5d                   	pop    %ebp
  804007:	c3                   	ret    
  804008:	bd 20 00 00 00       	mov    $0x20,%ebp
  80400d:	89 eb                	mov    %ebp,%ebx
  80400f:	29 fb                	sub    %edi,%ebx
  804011:	89 f9                	mov    %edi,%ecx
  804013:	d3 e6                	shl    %cl,%esi
  804015:	89 c5                	mov    %eax,%ebp
  804017:	88 d9                	mov    %bl,%cl
  804019:	d3 ed                	shr    %cl,%ebp
  80401b:	89 e9                	mov    %ebp,%ecx
  80401d:	09 f1                	or     %esi,%ecx
  80401f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804023:	89 f9                	mov    %edi,%ecx
  804025:	d3 e0                	shl    %cl,%eax
  804027:	89 c5                	mov    %eax,%ebp
  804029:	89 d6                	mov    %edx,%esi
  80402b:	88 d9                	mov    %bl,%cl
  80402d:	d3 ee                	shr    %cl,%esi
  80402f:	89 f9                	mov    %edi,%ecx
  804031:	d3 e2                	shl    %cl,%edx
  804033:	8b 44 24 08          	mov    0x8(%esp),%eax
  804037:	88 d9                	mov    %bl,%cl
  804039:	d3 e8                	shr    %cl,%eax
  80403b:	09 c2                	or     %eax,%edx
  80403d:	89 d0                	mov    %edx,%eax
  80403f:	89 f2                	mov    %esi,%edx
  804041:	f7 74 24 0c          	divl   0xc(%esp)
  804045:	89 d6                	mov    %edx,%esi
  804047:	89 c3                	mov    %eax,%ebx
  804049:	f7 e5                	mul    %ebp
  80404b:	39 d6                	cmp    %edx,%esi
  80404d:	72 19                	jb     804068 <__udivdi3+0xfc>
  80404f:	74 0b                	je     80405c <__udivdi3+0xf0>
  804051:	89 d8                	mov    %ebx,%eax
  804053:	31 ff                	xor    %edi,%edi
  804055:	e9 58 ff ff ff       	jmp    803fb2 <__udivdi3+0x46>
  80405a:	66 90                	xchg   %ax,%ax
  80405c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804060:	89 f9                	mov    %edi,%ecx
  804062:	d3 e2                	shl    %cl,%edx
  804064:	39 c2                	cmp    %eax,%edx
  804066:	73 e9                	jae    804051 <__udivdi3+0xe5>
  804068:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80406b:	31 ff                	xor    %edi,%edi
  80406d:	e9 40 ff ff ff       	jmp    803fb2 <__udivdi3+0x46>
  804072:	66 90                	xchg   %ax,%ax
  804074:	31 c0                	xor    %eax,%eax
  804076:	e9 37 ff ff ff       	jmp    803fb2 <__udivdi3+0x46>
  80407b:	90                   	nop

0080407c <__umoddi3>:
  80407c:	55                   	push   %ebp
  80407d:	57                   	push   %edi
  80407e:	56                   	push   %esi
  80407f:	53                   	push   %ebx
  804080:	83 ec 1c             	sub    $0x1c,%esp
  804083:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804087:	8b 74 24 34          	mov    0x34(%esp),%esi
  80408b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80408f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804093:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804097:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80409b:	89 f3                	mov    %esi,%ebx
  80409d:	89 fa                	mov    %edi,%edx
  80409f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040a3:	89 34 24             	mov    %esi,(%esp)
  8040a6:	85 c0                	test   %eax,%eax
  8040a8:	75 1a                	jne    8040c4 <__umoddi3+0x48>
  8040aa:	39 f7                	cmp    %esi,%edi
  8040ac:	0f 86 a2 00 00 00    	jbe    804154 <__umoddi3+0xd8>
  8040b2:	89 c8                	mov    %ecx,%eax
  8040b4:	89 f2                	mov    %esi,%edx
  8040b6:	f7 f7                	div    %edi
  8040b8:	89 d0                	mov    %edx,%eax
  8040ba:	31 d2                	xor    %edx,%edx
  8040bc:	83 c4 1c             	add    $0x1c,%esp
  8040bf:	5b                   	pop    %ebx
  8040c0:	5e                   	pop    %esi
  8040c1:	5f                   	pop    %edi
  8040c2:	5d                   	pop    %ebp
  8040c3:	c3                   	ret    
  8040c4:	39 f0                	cmp    %esi,%eax
  8040c6:	0f 87 ac 00 00 00    	ja     804178 <__umoddi3+0xfc>
  8040cc:	0f bd e8             	bsr    %eax,%ebp
  8040cf:	83 f5 1f             	xor    $0x1f,%ebp
  8040d2:	0f 84 ac 00 00 00    	je     804184 <__umoddi3+0x108>
  8040d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8040dd:	29 ef                	sub    %ebp,%edi
  8040df:	89 fe                	mov    %edi,%esi
  8040e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040e5:	89 e9                	mov    %ebp,%ecx
  8040e7:	d3 e0                	shl    %cl,%eax
  8040e9:	89 d7                	mov    %edx,%edi
  8040eb:	89 f1                	mov    %esi,%ecx
  8040ed:	d3 ef                	shr    %cl,%edi
  8040ef:	09 c7                	or     %eax,%edi
  8040f1:	89 e9                	mov    %ebp,%ecx
  8040f3:	d3 e2                	shl    %cl,%edx
  8040f5:	89 14 24             	mov    %edx,(%esp)
  8040f8:	89 d8                	mov    %ebx,%eax
  8040fa:	d3 e0                	shl    %cl,%eax
  8040fc:	89 c2                	mov    %eax,%edx
  8040fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  804102:	d3 e0                	shl    %cl,%eax
  804104:	89 44 24 04          	mov    %eax,0x4(%esp)
  804108:	8b 44 24 08          	mov    0x8(%esp),%eax
  80410c:	89 f1                	mov    %esi,%ecx
  80410e:	d3 e8                	shr    %cl,%eax
  804110:	09 d0                	or     %edx,%eax
  804112:	d3 eb                	shr    %cl,%ebx
  804114:	89 da                	mov    %ebx,%edx
  804116:	f7 f7                	div    %edi
  804118:	89 d3                	mov    %edx,%ebx
  80411a:	f7 24 24             	mull   (%esp)
  80411d:	89 c6                	mov    %eax,%esi
  80411f:	89 d1                	mov    %edx,%ecx
  804121:	39 d3                	cmp    %edx,%ebx
  804123:	0f 82 87 00 00 00    	jb     8041b0 <__umoddi3+0x134>
  804129:	0f 84 91 00 00 00    	je     8041c0 <__umoddi3+0x144>
  80412f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804133:	29 f2                	sub    %esi,%edx
  804135:	19 cb                	sbb    %ecx,%ebx
  804137:	89 d8                	mov    %ebx,%eax
  804139:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80413d:	d3 e0                	shl    %cl,%eax
  80413f:	89 e9                	mov    %ebp,%ecx
  804141:	d3 ea                	shr    %cl,%edx
  804143:	09 d0                	or     %edx,%eax
  804145:	89 e9                	mov    %ebp,%ecx
  804147:	d3 eb                	shr    %cl,%ebx
  804149:	89 da                	mov    %ebx,%edx
  80414b:	83 c4 1c             	add    $0x1c,%esp
  80414e:	5b                   	pop    %ebx
  80414f:	5e                   	pop    %esi
  804150:	5f                   	pop    %edi
  804151:	5d                   	pop    %ebp
  804152:	c3                   	ret    
  804153:	90                   	nop
  804154:	89 fd                	mov    %edi,%ebp
  804156:	85 ff                	test   %edi,%edi
  804158:	75 0b                	jne    804165 <__umoddi3+0xe9>
  80415a:	b8 01 00 00 00       	mov    $0x1,%eax
  80415f:	31 d2                	xor    %edx,%edx
  804161:	f7 f7                	div    %edi
  804163:	89 c5                	mov    %eax,%ebp
  804165:	89 f0                	mov    %esi,%eax
  804167:	31 d2                	xor    %edx,%edx
  804169:	f7 f5                	div    %ebp
  80416b:	89 c8                	mov    %ecx,%eax
  80416d:	f7 f5                	div    %ebp
  80416f:	89 d0                	mov    %edx,%eax
  804171:	e9 44 ff ff ff       	jmp    8040ba <__umoddi3+0x3e>
  804176:	66 90                	xchg   %ax,%ax
  804178:	89 c8                	mov    %ecx,%eax
  80417a:	89 f2                	mov    %esi,%edx
  80417c:	83 c4 1c             	add    $0x1c,%esp
  80417f:	5b                   	pop    %ebx
  804180:	5e                   	pop    %esi
  804181:	5f                   	pop    %edi
  804182:	5d                   	pop    %ebp
  804183:	c3                   	ret    
  804184:	3b 04 24             	cmp    (%esp),%eax
  804187:	72 06                	jb     80418f <__umoddi3+0x113>
  804189:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80418d:	77 0f                	ja     80419e <__umoddi3+0x122>
  80418f:	89 f2                	mov    %esi,%edx
  804191:	29 f9                	sub    %edi,%ecx
  804193:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804197:	89 14 24             	mov    %edx,(%esp)
  80419a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80419e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041a2:	8b 14 24             	mov    (%esp),%edx
  8041a5:	83 c4 1c             	add    $0x1c,%esp
  8041a8:	5b                   	pop    %ebx
  8041a9:	5e                   	pop    %esi
  8041aa:	5f                   	pop    %edi
  8041ab:	5d                   	pop    %ebp
  8041ac:	c3                   	ret    
  8041ad:	8d 76 00             	lea    0x0(%esi),%esi
  8041b0:	2b 04 24             	sub    (%esp),%eax
  8041b3:	19 fa                	sbb    %edi,%edx
  8041b5:	89 d1                	mov    %edx,%ecx
  8041b7:	89 c6                	mov    %eax,%esi
  8041b9:	e9 71 ff ff ff       	jmp    80412f <__umoddi3+0xb3>
  8041be:	66 90                	xchg   %ax,%ax
  8041c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041c4:	72 ea                	jb     8041b0 <__umoddi3+0x134>
  8041c6:	89 d9                	mov    %ebx,%ecx
  8041c8:	e9 62 ff ff ff       	jmp    80412f <__umoddi3+0xb3>
