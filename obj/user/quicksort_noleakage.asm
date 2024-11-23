
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
  800041:	e8 99 1e 00 00       	call   801edf <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 41 80 00       	push   $0x8041a0
  80004e:	e8 b5 09 00 00       	call   800a08 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 41 80 00       	push   $0x8041a2
  80005e:	e8 a5 09 00 00       	call   800a08 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 bb 41 80 00       	push   $0x8041bb
  80006e:	e8 95 09 00 00       	call   800a08 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 41 80 00       	push   $0x8041a2
  80007e:	e8 85 09 00 00       	call   800a08 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 41 80 00       	push   $0x8041a0
  80008e:	e8 75 09 00 00       	call   800a08 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d4 41 80 00       	push   $0x8041d4
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
  8000c9:	68 f4 41 80 00       	push   $0x8041f4
  8000ce:	e8 35 09 00 00       	call   800a08 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 16 42 80 00       	push   $0x804216
  8000de:	e8 25 09 00 00       	call   800a08 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 24 42 80 00       	push   $0x804224
  8000ee:	e8 15 09 00 00       	call   800a08 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 33 42 80 00       	push   $0x804233
  8000fe:	e8 05 09 00 00       	call   800a08 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 43 42 80 00       	push   $0x804243
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
  80014d:	e8 a7 1d 00 00       	call   801ef9 <sys_unlock_cons>
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
  8001d5:	e8 05 1d 00 00       	call   801edf <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 4c 42 80 00       	push   $0x80424c
  8001e2:	e8 21 08 00 00       	call   800a08 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 0a 1d 00 00       	call   801ef9 <sys_unlock_cons>
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
  80020c:	68 80 42 80 00       	push   $0x804280
  800211:	6a 54                	push   $0x54
  800213:	68 a2 42 80 00       	push   $0x8042a2
  800218:	e8 2e 05 00 00       	call   80074b <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 bd 1c 00 00       	call   801edf <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 c0 42 80 00       	push   $0x8042c0
  80022a:	e8 d9 07 00 00       	call   800a08 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 f4 42 80 00       	push   $0x8042f4
  80023a:	e8 c9 07 00 00       	call   800a08 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 28 43 80 00       	push   $0x804328
  80024a:	e8 b9 07 00 00       	call   800a08 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 a2 1c 00 00       	call   801ef9 <sys_unlock_cons>
			//			sys_unlock_cons();


		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 ec             	pushl  -0x14(%ebp)
  80025d:	e8 7d 19 00 00       	call   801bdf <free>
  800262:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
  800265:	e8 75 1c 00 00       	call   801edf <sys_lock_cons>
		{
			Chose = 0 ;
  80026a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  80026e:	eb 42                	jmp    8002b2 <_main+0x27a>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 5a 43 80 00       	push   $0x80435a
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
  8002be:	e8 36 1c 00 00       	call   801ef9 <sys_unlock_cons>
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
  800570:	68 a0 41 80 00       	push   $0x8041a0
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
  800592:	68 78 43 80 00       	push   $0x804378
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
  8005c0:	68 7d 43 80 00       	push   $0x80437d
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
  8005e4:	e8 41 1a 00 00       	call   80202a <sys_cputc>
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
  8005f5:	e8 cc 18 00 00       	call   801ec6 <sys_cgetc>
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
  800612:	e8 44 1b 00 00       	call   80215b <sys_getenvindex>
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
  800680:	e8 5a 18 00 00       	call   801edf <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800685:	83 ec 0c             	sub    $0xc,%esp
  800688:	68 9c 43 80 00       	push   $0x80439c
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
  8006b0:	68 c4 43 80 00       	push   $0x8043c4
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
  8006e1:	68 ec 43 80 00       	push   $0x8043ec
  8006e6:	e8 1d 03 00 00       	call   800a08 <cprintf>
  8006eb:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f3:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	50                   	push   %eax
  8006fd:	68 44 44 80 00       	push   $0x804444
  800702:	e8 01 03 00 00       	call   800a08 <cprintf>
  800707:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 9c 43 80 00       	push   $0x80439c
  800712:	e8 f1 02 00 00       	call   800a08 <cprintf>
  800717:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80071a:	e8 da 17 00 00       	call   801ef9 <sys_unlock_cons>
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
  800732:	e8 f0 19 00 00       	call   802127 <sys_destroy_env>
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
  800743:	e8 45 1a 00 00       	call   80218d <sys_exit_env>
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
  80076c:	68 58 44 80 00       	push   $0x804458
  800771:	e8 92 02 00 00       	call   800a08 <cprintf>
  800776:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800779:	a1 00 50 80 00       	mov    0x805000,%eax
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	ff 75 08             	pushl  0x8(%ebp)
  800784:	50                   	push   %eax
  800785:	68 5d 44 80 00       	push   $0x80445d
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
  8007a9:	68 79 44 80 00       	push   $0x804479
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
  8007d8:	68 7c 44 80 00       	push   $0x80447c
  8007dd:	6a 26                	push   $0x26
  8007df:	68 c8 44 80 00       	push   $0x8044c8
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
  8008ad:	68 d4 44 80 00       	push   $0x8044d4
  8008b2:	6a 3a                	push   $0x3a
  8008b4:	68 c8 44 80 00       	push   $0x8044c8
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
  800920:	68 28 45 80 00       	push   $0x804528
  800925:	6a 44                	push   $0x44
  800927:	68 c8 44 80 00       	push   $0x8044c8
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
  80097a:	e8 1e 15 00 00       	call   801e9d <sys_cputs>
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
  8009f1:	e8 a7 14 00 00       	call   801e9d <sys_cputs>
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
  800a3b:	e8 9f 14 00 00       	call   801edf <sys_lock_cons>
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
  800a5b:	e8 99 14 00 00       	call   801ef9 <sys_unlock_cons>
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
  800aa5:	e8 8a 34 00 00       	call   803f34 <__udivdi3>
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
  800af5:	e8 4a 35 00 00       	call   804044 <__umoddi3>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	05 94 47 80 00       	add    $0x804794,%eax
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
  800c50:	8b 04 85 b8 47 80 00 	mov    0x8047b8(,%eax,4),%eax
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
  800d31:	8b 34 9d 00 46 80 00 	mov    0x804600(,%ebx,4),%esi
  800d38:	85 f6                	test   %esi,%esi
  800d3a:	75 19                	jne    800d55 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d3c:	53                   	push   %ebx
  800d3d:	68 a5 47 80 00       	push   $0x8047a5
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
  800d56:	68 ae 47 80 00       	push   $0x8047ae
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
  800d83:	be b1 47 80 00       	mov    $0x8047b1,%esi
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
  8010ae:	68 28 49 80 00       	push   $0x804928
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
  8010f0:	68 2b 49 80 00       	push   $0x80492b
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
  8011a1:	e8 39 0d 00 00       	call   801edf <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8011a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011aa:	74 13                	je     8011bf <atomic_readline+0x24>
			cprintf("%s", prompt);
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	ff 75 08             	pushl  0x8(%ebp)
  8011b2:	68 28 49 80 00       	push   $0x804928
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
  8011f4:	68 2b 49 80 00       	push   $0x80492b
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
  80129c:	e8 58 0c 00 00       	call   801ef9 <sys_unlock_cons>
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
  801996:	68 3c 49 80 00       	push   $0x80493c
  80199b:	68 3f 01 00 00       	push   $0x13f
  8019a0:	68 5e 49 80 00       	push   $0x80495e
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
  8019b6:	e8 8d 0a 00 00       	call   802448 <sys_sbrk>
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
  801a31:	e8 96 08 00 00       	call   8022cc <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a36:	85 c0                	test   %eax,%eax
  801a38:	74 16                	je     801a50 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a3a:	83 ec 0c             	sub    $0xc,%esp
  801a3d:	ff 75 08             	pushl  0x8(%ebp)
  801a40:	e8 d6 0d 00 00       	call   80281b <alloc_block_FF>
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a4b:	e9 8a 01 00 00       	jmp    801bda <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801a50:	e8 a8 08 00 00       	call   8022fd <sys_isUHeapPlacementStrategyBESTFIT>
  801a55:	85 c0                	test   %eax,%eax
  801a57:	0f 84 7d 01 00 00    	je     801bda <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801a5d:	83 ec 0c             	sub    $0xc,%esp
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	e8 6f 12 00 00       	call   802cd7 <alloc_block_BF>
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
  801bc9:	e8 b1 08 00 00       	call   80247f <sys_allocate_user_mem>
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
  801c11:	e8 85 08 00 00       	call   80249b <get_block_size>
  801c16:	83 c4 10             	add    $0x10,%esp
  801c19:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c1c:	83 ec 0c             	sub    $0xc,%esp
  801c1f:	ff 75 08             	pushl  0x8(%ebp)
  801c22:	e8 b8 1a 00 00       	call   8036df <free_block>
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
  801cb9:	e8 a5 07 00 00       	call   802463 <sys_free_user_mem>
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
  801cc7:	68 6c 49 80 00       	push   $0x80496c
  801ccc:	68 84 00 00 00       	push   $0x84
  801cd1:	68 96 49 80 00       	push   $0x804996
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
  801cf4:	eb 64                	jmp    801d5a <smalloc+0x7d>
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
  801d29:	eb 2f                	jmp    801d5a <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d2b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d2f:	ff 75 ec             	pushl  -0x14(%ebp)
  801d32:	50                   	push   %eax
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	ff 75 08             	pushl  0x8(%ebp)
  801d39:	e8 2c 03 00 00       	call   80206a <sys_createSharedObject>
  801d3e:	83 c4 10             	add    $0x10,%esp
  801d41:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801d44:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801d48:	74 06                	je     801d50 <smalloc+0x73>
  801d4a:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801d4e:	75 07                	jne    801d57 <smalloc+0x7a>
  801d50:	b8 00 00 00 00       	mov    $0x0,%eax
  801d55:	eb 03                	jmp    801d5a <smalloc+0x7d>
	 return ptr;
  801d57:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d62:	83 ec 08             	sub    $0x8,%esp
  801d65:	ff 75 0c             	pushl  0xc(%ebp)
  801d68:	ff 75 08             	pushl  0x8(%ebp)
  801d6b:	e8 24 03 00 00       	call   802094 <sys_getSizeOfSharedObject>
  801d70:	83 c4 10             	add    $0x10,%esp
  801d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801d76:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801d7a:	75 07                	jne    801d83 <sget+0x27>
  801d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d81:	eb 5c                	jmp    801ddf <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d89:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d90:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d96:	39 d0                	cmp    %edx,%eax
  801d98:	7d 02                	jge    801d9c <sget+0x40>
  801d9a:	89 d0                	mov    %edx,%eax
  801d9c:	83 ec 0c             	sub    $0xc,%esp
  801d9f:	50                   	push   %eax
  801da0:	e8 1b fc ff ff       	call   8019c0 <malloc>
  801da5:	83 c4 10             	add    $0x10,%esp
  801da8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801dab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801daf:	75 07                	jne    801db8 <sget+0x5c>
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax
  801db6:	eb 27                	jmp    801ddf <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801db8:	83 ec 04             	sub    $0x4,%esp
  801dbb:	ff 75 e8             	pushl  -0x18(%ebp)
  801dbe:	ff 75 0c             	pushl  0xc(%ebp)
  801dc1:	ff 75 08             	pushl  0x8(%ebp)
  801dc4:	e8 e8 02 00 00       	call   8020b1 <sys_getSharedObject>
  801dc9:	83 c4 10             	add    $0x10,%esp
  801dcc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801dcf:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801dd3:	75 07                	jne    801ddc <sget+0x80>
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dda:	eb 03                	jmp    801ddf <sget+0x83>
	return ptr;
  801ddc:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801de7:	83 ec 04             	sub    $0x4,%esp
  801dea:	68 a4 49 80 00       	push   $0x8049a4
  801def:	68 c1 00 00 00       	push   $0xc1
  801df4:	68 96 49 80 00       	push   $0x804996
  801df9:	e8 4d e9 ff ff       	call   80074b <_panic>

00801dfe <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e04:	83 ec 04             	sub    $0x4,%esp
  801e07:	68 c8 49 80 00       	push   $0x8049c8
  801e0c:	68 d8 00 00 00       	push   $0xd8
  801e11:	68 96 49 80 00       	push   $0x804996
  801e16:	e8 30 e9 ff ff       	call   80074b <_panic>

00801e1b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e21:	83 ec 04             	sub    $0x4,%esp
  801e24:	68 ee 49 80 00       	push   $0x8049ee
  801e29:	68 e4 00 00 00       	push   $0xe4
  801e2e:	68 96 49 80 00       	push   $0x804996
  801e33:	e8 13 e9 ff ff       	call   80074b <_panic>

00801e38 <shrink>:

}
void shrink(uint32 newSize)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e3e:	83 ec 04             	sub    $0x4,%esp
  801e41:	68 ee 49 80 00       	push   $0x8049ee
  801e46:	68 e9 00 00 00       	push   $0xe9
  801e4b:	68 96 49 80 00       	push   $0x804996
  801e50:	e8 f6 e8 ff ff       	call   80074b <_panic>

00801e55 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e5b:	83 ec 04             	sub    $0x4,%esp
  801e5e:	68 ee 49 80 00       	push   $0x8049ee
  801e63:	68 ee 00 00 00       	push   $0xee
  801e68:	68 96 49 80 00       	push   $0x804996
  801e6d:	e8 d9 e8 ff ff       	call   80074b <_panic>

00801e72 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	57                   	push   %edi
  801e76:	56                   	push   %esi
  801e77:	53                   	push   %ebx
  801e78:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e81:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e84:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e87:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e8a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e8d:	cd 30                	int    $0x30
  801e8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e95:	83 c4 10             	add    $0x10,%esp
  801e98:	5b                   	pop    %ebx
  801e99:	5e                   	pop    %esi
  801e9a:	5f                   	pop    %edi
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    

00801e9d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 04             	sub    $0x4,%esp
  801ea3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ea9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	52                   	push   %edx
  801eb5:	ff 75 0c             	pushl  0xc(%ebp)
  801eb8:	50                   	push   %eax
  801eb9:	6a 00                	push   $0x0
  801ebb:	e8 b2 ff ff ff       	call   801e72 <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
}
  801ec3:	90                   	nop
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 02                	push   $0x2
  801ed5:	e8 98 ff ff ff       	call   801e72 <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <sys_lock_cons>:

void sys_lock_cons(void)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 03                	push   $0x3
  801eee:	e8 7f ff ff ff       	call   801e72 <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
}
  801ef6:	90                   	nop
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 04                	push   $0x4
  801f08:	e8 65 ff ff ff       	call   801e72 <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	90                   	nop
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	52                   	push   %edx
  801f23:	50                   	push   %eax
  801f24:	6a 08                	push   $0x8
  801f26:	e8 47 ff ff ff       	call   801e72 <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	56                   	push   %esi
  801f34:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f35:	8b 75 18             	mov    0x18(%ebp),%esi
  801f38:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f41:	8b 45 08             	mov    0x8(%ebp),%eax
  801f44:	56                   	push   %esi
  801f45:	53                   	push   %ebx
  801f46:	51                   	push   %ecx
  801f47:	52                   	push   %edx
  801f48:	50                   	push   %eax
  801f49:	6a 09                	push   $0x9
  801f4b:	e8 22 ff ff ff       	call   801e72 <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
}
  801f53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f56:	5b                   	pop    %ebx
  801f57:	5e                   	pop    %esi
  801f58:	5d                   	pop    %ebp
  801f59:	c3                   	ret    

00801f5a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	52                   	push   %edx
  801f6a:	50                   	push   %eax
  801f6b:	6a 0a                	push   $0xa
  801f6d:	e8 00 ff ff ff       	call   801e72 <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	ff 75 0c             	pushl  0xc(%ebp)
  801f83:	ff 75 08             	pushl  0x8(%ebp)
  801f86:	6a 0b                	push   $0xb
  801f88:	e8 e5 fe ff ff       	call   801e72 <syscall>
  801f8d:	83 c4 18             	add    $0x18,%esp
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 0c                	push   $0xc
  801fa1:	e8 cc fe ff ff       	call   801e72 <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 0d                	push   $0xd
  801fba:	e8 b3 fe ff ff       	call   801e72 <syscall>
  801fbf:	83 c4 18             	add    $0x18,%esp
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 0e                	push   $0xe
  801fd3:	e8 9a fe ff ff       	call   801e72 <syscall>
  801fd8:	83 c4 18             	add    $0x18,%esp
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 0f                	push   $0xf
  801fec:	e8 81 fe ff ff       	call   801e72 <syscall>
  801ff1:	83 c4 18             	add    $0x18,%esp
}
  801ff4:	c9                   	leave  
  801ff5:	c3                   	ret    

00801ff6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	ff 75 08             	pushl  0x8(%ebp)
  802004:	6a 10                	push   $0x10
  802006:	e8 67 fe ff ff       	call   801e72 <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 11                	push   $0x11
  80201f:	e8 4e fe ff ff       	call   801e72 <syscall>
  802024:	83 c4 18             	add    $0x18,%esp
}
  802027:	90                   	nop
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <sys_cputc>:

void
sys_cputc(const char c)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 04             	sub    $0x4,%esp
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802036:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	50                   	push   %eax
  802043:	6a 01                	push   $0x1
  802045:	e8 28 fe ff ff       	call   801e72 <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
}
  80204d:	90                   	nop
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 14                	push   $0x14
  80205f:	e8 0e fe ff ff       	call   801e72 <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
}
  802067:	90                   	nop
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 04             	sub    $0x4,%esp
  802070:	8b 45 10             	mov    0x10(%ebp),%eax
  802073:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802076:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802079:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	6a 00                	push   $0x0
  802082:	51                   	push   %ecx
  802083:	52                   	push   %edx
  802084:	ff 75 0c             	pushl  0xc(%ebp)
  802087:	50                   	push   %eax
  802088:	6a 15                	push   $0x15
  80208a:	e8 e3 fd ff ff       	call   801e72 <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802097:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	52                   	push   %edx
  8020a4:	50                   	push   %eax
  8020a5:	6a 16                	push   $0x16
  8020a7:	e8 c6 fd ff ff       	call   801e72 <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	51                   	push   %ecx
  8020c2:	52                   	push   %edx
  8020c3:	50                   	push   %eax
  8020c4:	6a 17                	push   $0x17
  8020c6:	e8 a7 fd ff ff       	call   801e72 <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	52                   	push   %edx
  8020e0:	50                   	push   %eax
  8020e1:	6a 18                	push   $0x18
  8020e3:	e8 8a fd ff ff       	call   801e72 <syscall>
  8020e8:	83 c4 18             	add    $0x18,%esp
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	6a 00                	push   $0x0
  8020f5:	ff 75 14             	pushl  0x14(%ebp)
  8020f8:	ff 75 10             	pushl  0x10(%ebp)
  8020fb:	ff 75 0c             	pushl  0xc(%ebp)
  8020fe:	50                   	push   %eax
  8020ff:	6a 19                	push   $0x19
  802101:	e8 6c fd ff ff       	call   801e72 <syscall>
  802106:	83 c4 18             	add    $0x18,%esp
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	50                   	push   %eax
  80211a:	6a 1a                	push   $0x1a
  80211c:	e8 51 fd ff ff       	call   801e72 <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
}
  802124:	90                   	nop
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	50                   	push   %eax
  802136:	6a 1b                	push   $0x1b
  802138:	e8 35 fd ff ff       	call   801e72 <syscall>
  80213d:	83 c4 18             	add    $0x18,%esp
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 05                	push   $0x5
  802151:	e8 1c fd ff ff       	call   801e72 <syscall>
  802156:	83 c4 18             	add    $0x18,%esp
}
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 06                	push   $0x6
  80216a:	e8 03 fd ff ff       	call   801e72 <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 07                	push   $0x7
  802183:	e8 ea fc ff ff       	call   801e72 <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <sys_exit_env>:


void sys_exit_env(void)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 1c                	push   $0x1c
  80219c:	e8 d1 fc ff ff       	call   801e72 <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
}
  8021a4:	90                   	nop
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021ad:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021b0:	8d 50 04             	lea    0x4(%eax),%edx
  8021b3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	52                   	push   %edx
  8021bd:	50                   	push   %eax
  8021be:	6a 1d                	push   $0x1d
  8021c0:	e8 ad fc ff ff       	call   801e72 <syscall>
  8021c5:	83 c4 18             	add    $0x18,%esp
	return result;
  8021c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021d1:	89 01                	mov    %eax,(%ecx)
  8021d3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	c9                   	leave  
  8021da:	c2 04 00             	ret    $0x4

008021dd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	ff 75 10             	pushl  0x10(%ebp)
  8021e7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ea:	ff 75 08             	pushl  0x8(%ebp)
  8021ed:	6a 13                	push   $0x13
  8021ef:	e8 7e fc ff ff       	call   801e72 <syscall>
  8021f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f7:	90                   	nop
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_rcr2>:
uint32 sys_rcr2()
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 1e                	push   $0x1e
  802209:	e8 64 fc ff ff       	call   801e72 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
  802216:	83 ec 04             	sub    $0x4,%esp
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80221f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	50                   	push   %eax
  80222c:	6a 1f                	push   $0x1f
  80222e:	e8 3f fc ff ff       	call   801e72 <syscall>
  802233:	83 c4 18             	add    $0x18,%esp
	return ;
  802236:	90                   	nop
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <rsttst>:
void rsttst()
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 21                	push   $0x21
  802248:	e8 25 fc ff ff       	call   801e72 <syscall>
  80224d:	83 c4 18             	add    $0x18,%esp
	return ;
  802250:	90                   	nop
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	83 ec 04             	sub    $0x4,%esp
  802259:	8b 45 14             	mov    0x14(%ebp),%eax
  80225c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80225f:	8b 55 18             	mov    0x18(%ebp),%edx
  802262:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802266:	52                   	push   %edx
  802267:	50                   	push   %eax
  802268:	ff 75 10             	pushl  0x10(%ebp)
  80226b:	ff 75 0c             	pushl  0xc(%ebp)
  80226e:	ff 75 08             	pushl  0x8(%ebp)
  802271:	6a 20                	push   $0x20
  802273:	e8 fa fb ff ff       	call   801e72 <syscall>
  802278:	83 c4 18             	add    $0x18,%esp
	return ;
  80227b:	90                   	nop
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <chktst>:
void chktst(uint32 n)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	ff 75 08             	pushl  0x8(%ebp)
  80228c:	6a 22                	push   $0x22
  80228e:	e8 df fb ff ff       	call   801e72 <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
	return ;
  802296:	90                   	nop
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <inctst>:

void inctst()
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 23                	push   $0x23
  8022a8:	e8 c5 fb ff ff       	call   801e72 <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b0:	90                   	nop
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <gettst>:
uint32 gettst()
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 24                	push   $0x24
  8022c2:	e8 ab fb ff ff       	call   801e72 <syscall>
  8022c7:	83 c4 18             	add    $0x18,%esp
}
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
  8022cf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 25                	push   $0x25
  8022de:	e8 8f fb ff ff       	call   801e72 <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
  8022e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8022e9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8022ed:	75 07                	jne    8022f6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8022ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f4:	eb 05                	jmp    8022fb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 25                	push   $0x25
  80230f:	e8 5e fb ff ff       	call   801e72 <syscall>
  802314:	83 c4 18             	add    $0x18,%esp
  802317:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80231a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80231e:	75 07                	jne    802327 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802320:	b8 01 00 00 00       	mov    $0x1,%eax
  802325:	eb 05                	jmp    80232c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 25                	push   $0x25
  802340:	e8 2d fb ff ff       	call   801e72 <syscall>
  802345:	83 c4 18             	add    $0x18,%esp
  802348:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80234b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80234f:	75 07                	jne    802358 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802351:	b8 01 00 00 00       	mov    $0x1,%eax
  802356:	eb 05                	jmp    80235d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802358:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 25                	push   $0x25
  802371:	e8 fc fa ff ff       	call   801e72 <syscall>
  802376:	83 c4 18             	add    $0x18,%esp
  802379:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80237c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802380:	75 07                	jne    802389 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802382:	b8 01 00 00 00       	mov    $0x1,%eax
  802387:	eb 05                	jmp    80238e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802389:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	ff 75 08             	pushl  0x8(%ebp)
  80239e:	6a 26                	push   $0x26
  8023a0:	e8 cd fa ff ff       	call   801e72 <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a8:	90                   	nop
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023af:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	6a 00                	push   $0x0
  8023bd:	53                   	push   %ebx
  8023be:	51                   	push   %ecx
  8023bf:	52                   	push   %edx
  8023c0:	50                   	push   %eax
  8023c1:	6a 27                	push   $0x27
  8023c3:	e8 aa fa ff ff       	call   801e72 <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
}
  8023cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	52                   	push   %edx
  8023e0:	50                   	push   %eax
  8023e1:	6a 28                	push   $0x28
  8023e3:	e8 8a fa ff ff       	call   801e72 <syscall>
  8023e8:	83 c4 18             	add    $0x18,%esp
}
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    

008023ed <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8023f0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	6a 00                	push   $0x0
  8023fb:	51                   	push   %ecx
  8023fc:	ff 75 10             	pushl  0x10(%ebp)
  8023ff:	52                   	push   %edx
  802400:	50                   	push   %eax
  802401:	6a 29                	push   $0x29
  802403:	e8 6a fa ff ff       	call   801e72 <syscall>
  802408:	83 c4 18             	add    $0x18,%esp
}
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	ff 75 10             	pushl  0x10(%ebp)
  802417:	ff 75 0c             	pushl  0xc(%ebp)
  80241a:	ff 75 08             	pushl  0x8(%ebp)
  80241d:	6a 12                	push   $0x12
  80241f:	e8 4e fa ff ff       	call   801e72 <syscall>
  802424:	83 c4 18             	add    $0x18,%esp
	return ;
  802427:	90                   	nop
}
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80242d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	52                   	push   %edx
  80243a:	50                   	push   %eax
  80243b:	6a 2a                	push   $0x2a
  80243d:	e8 30 fa ff ff       	call   801e72 <syscall>
  802442:	83 c4 18             	add    $0x18,%esp
	return;
  802445:	90                   	nop
}
  802446:	c9                   	leave  
  802447:	c3                   	ret    

00802448 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802448:	55                   	push   %ebp
  802449:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80244b:	8b 45 08             	mov    0x8(%ebp),%eax
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	50                   	push   %eax
  802457:	6a 2b                	push   $0x2b
  802459:	e8 14 fa ff ff       	call   801e72 <syscall>
  80245e:	83 c4 18             	add    $0x18,%esp
}
  802461:	c9                   	leave  
  802462:	c3                   	ret    

00802463 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	ff 75 0c             	pushl  0xc(%ebp)
  80246f:	ff 75 08             	pushl  0x8(%ebp)
  802472:	6a 2c                	push   $0x2c
  802474:	e8 f9 f9 ff ff       	call   801e72 <syscall>
  802479:	83 c4 18             	add    $0x18,%esp
	return;
  80247c:	90                   	nop
}
  80247d:	c9                   	leave  
  80247e:	c3                   	ret    

0080247f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80247f:	55                   	push   %ebp
  802480:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	ff 75 0c             	pushl  0xc(%ebp)
  80248b:	ff 75 08             	pushl  0x8(%ebp)
  80248e:	6a 2d                	push   $0x2d
  802490:	e8 dd f9 ff ff       	call   801e72 <syscall>
  802495:	83 c4 18             	add    $0x18,%esp
	return;
  802498:	90                   	nop
}
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	83 e8 04             	sub    $0x4,%eax
  8024a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8024aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024ad:	8b 00                	mov    (%eax),%eax
  8024af:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8024b2:	c9                   	leave  
  8024b3:	c3                   	ret    

008024b4 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
  8024b7:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	83 e8 04             	sub    $0x4,%eax
  8024c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8024c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c6:	8b 00                	mov    (%eax),%eax
  8024c8:	83 e0 01             	and    $0x1,%eax
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	0f 94 c0             	sete   %al
}
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8024d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8024df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e2:	83 f8 02             	cmp    $0x2,%eax
  8024e5:	74 2b                	je     802512 <alloc_block+0x40>
  8024e7:	83 f8 02             	cmp    $0x2,%eax
  8024ea:	7f 07                	jg     8024f3 <alloc_block+0x21>
  8024ec:	83 f8 01             	cmp    $0x1,%eax
  8024ef:	74 0e                	je     8024ff <alloc_block+0x2d>
  8024f1:	eb 58                	jmp    80254b <alloc_block+0x79>
  8024f3:	83 f8 03             	cmp    $0x3,%eax
  8024f6:	74 2d                	je     802525 <alloc_block+0x53>
  8024f8:	83 f8 04             	cmp    $0x4,%eax
  8024fb:	74 3b                	je     802538 <alloc_block+0x66>
  8024fd:	eb 4c                	jmp    80254b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8024ff:	83 ec 0c             	sub    $0xc,%esp
  802502:	ff 75 08             	pushl  0x8(%ebp)
  802505:	e8 11 03 00 00       	call   80281b <alloc_block_FF>
  80250a:	83 c4 10             	add    $0x10,%esp
  80250d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802510:	eb 4a                	jmp    80255c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802512:	83 ec 0c             	sub    $0xc,%esp
  802515:	ff 75 08             	pushl  0x8(%ebp)
  802518:	e8 fa 19 00 00       	call   803f17 <alloc_block_NF>
  80251d:	83 c4 10             	add    $0x10,%esp
  802520:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802523:	eb 37                	jmp    80255c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802525:	83 ec 0c             	sub    $0xc,%esp
  802528:	ff 75 08             	pushl  0x8(%ebp)
  80252b:	e8 a7 07 00 00       	call   802cd7 <alloc_block_BF>
  802530:	83 c4 10             	add    $0x10,%esp
  802533:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802536:	eb 24                	jmp    80255c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802538:	83 ec 0c             	sub    $0xc,%esp
  80253b:	ff 75 08             	pushl  0x8(%ebp)
  80253e:	e8 b7 19 00 00       	call   803efa <alloc_block_WF>
  802543:	83 c4 10             	add    $0x10,%esp
  802546:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802549:	eb 11                	jmp    80255c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80254b:	83 ec 0c             	sub    $0xc,%esp
  80254e:	68 00 4a 80 00       	push   $0x804a00
  802553:	e8 b0 e4 ff ff       	call   800a08 <cprintf>
  802558:	83 c4 10             	add    $0x10,%esp
		break;
  80255b:	90                   	nop
	}
	return va;
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80255f:	c9                   	leave  
  802560:	c3                   	ret    

00802561 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
  802564:	53                   	push   %ebx
  802565:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802568:	83 ec 0c             	sub    $0xc,%esp
  80256b:	68 20 4a 80 00       	push   $0x804a20
  802570:	e8 93 e4 ff ff       	call   800a08 <cprintf>
  802575:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802578:	83 ec 0c             	sub    $0xc,%esp
  80257b:	68 4b 4a 80 00       	push   $0x804a4b
  802580:	e8 83 e4 ff ff       	call   800a08 <cprintf>
  802585:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258e:	eb 37                	jmp    8025c7 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802590:	83 ec 0c             	sub    $0xc,%esp
  802593:	ff 75 f4             	pushl  -0xc(%ebp)
  802596:	e8 19 ff ff ff       	call   8024b4 <is_free_block>
  80259b:	83 c4 10             	add    $0x10,%esp
  80259e:	0f be d8             	movsbl %al,%ebx
  8025a1:	83 ec 0c             	sub    $0xc,%esp
  8025a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8025a7:	e8 ef fe ff ff       	call   80249b <get_block_size>
  8025ac:	83 c4 10             	add    $0x10,%esp
  8025af:	83 ec 04             	sub    $0x4,%esp
  8025b2:	53                   	push   %ebx
  8025b3:	50                   	push   %eax
  8025b4:	68 63 4a 80 00       	push   $0x804a63
  8025b9:	e8 4a e4 ff ff       	call   800a08 <cprintf>
  8025be:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8025c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8025c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cb:	74 07                	je     8025d4 <print_blocks_list+0x73>
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 00                	mov    (%eax),%eax
  8025d2:	eb 05                	jmp    8025d9 <print_blocks_list+0x78>
  8025d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d9:	89 45 10             	mov    %eax,0x10(%ebp)
  8025dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	75 ad                	jne    802590 <print_blocks_list+0x2f>
  8025e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e7:	75 a7                	jne    802590 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8025e9:	83 ec 0c             	sub    $0xc,%esp
  8025ec:	68 20 4a 80 00       	push   $0x804a20
  8025f1:	e8 12 e4 ff ff       	call   800a08 <cprintf>
  8025f6:	83 c4 10             	add    $0x10,%esp

}
  8025f9:	90                   	nop
  8025fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025fd:	c9                   	leave  
  8025fe:	c3                   	ret    

008025ff <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8025ff:	55                   	push   %ebp
  802600:	89 e5                	mov    %esp,%ebp
  802602:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802605:	8b 45 0c             	mov    0xc(%ebp),%eax
  802608:	83 e0 01             	and    $0x1,%eax
  80260b:	85 c0                	test   %eax,%eax
  80260d:	74 03                	je     802612 <initialize_dynamic_allocator+0x13>
  80260f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802612:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802616:	0f 84 c7 01 00 00    	je     8027e3 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80261c:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802623:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802626:	8b 55 08             	mov    0x8(%ebp),%edx
  802629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262c:	01 d0                	add    %edx,%eax
  80262e:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802633:	0f 87 ad 01 00 00    	ja     8027e6 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	85 c0                	test   %eax,%eax
  80263e:	0f 89 a5 01 00 00    	jns    8027e9 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802644:	8b 55 08             	mov    0x8(%ebp),%edx
  802647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80264a:	01 d0                	add    %edx,%eax
  80264c:	83 e8 04             	sub    $0x4,%eax
  80264f:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  802654:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80265b:	a1 30 50 80 00       	mov    0x805030,%eax
  802660:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802663:	e9 87 00 00 00       	jmp    8026ef <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802668:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266c:	75 14                	jne    802682 <initialize_dynamic_allocator+0x83>
  80266e:	83 ec 04             	sub    $0x4,%esp
  802671:	68 7b 4a 80 00       	push   $0x804a7b
  802676:	6a 79                	push   $0x79
  802678:	68 99 4a 80 00       	push   $0x804a99
  80267d:	e8 c9 e0 ff ff       	call   80074b <_panic>
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 00                	mov    (%eax),%eax
  802687:	85 c0                	test   %eax,%eax
  802689:	74 10                	je     80269b <initialize_dynamic_allocator+0x9c>
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 00                	mov    (%eax),%eax
  802690:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802693:	8b 52 04             	mov    0x4(%edx),%edx
  802696:	89 50 04             	mov    %edx,0x4(%eax)
  802699:	eb 0b                	jmp    8026a6 <initialize_dynamic_allocator+0xa7>
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 40 04             	mov    0x4(%eax),%eax
  8026a1:	a3 34 50 80 00       	mov    %eax,0x805034
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 40 04             	mov    0x4(%eax),%eax
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	74 0f                	je     8026bf <initialize_dynamic_allocator+0xc0>
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b9:	8b 12                	mov    (%edx),%edx
  8026bb:	89 10                	mov    %edx,(%eax)
  8026bd:	eb 0a                	jmp    8026c9 <initialize_dynamic_allocator+0xca>
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	a3 30 50 80 00       	mov    %eax,0x805030
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026dc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026e1:	48                   	dec    %eax
  8026e2:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8026e7:	a1 38 50 80 00       	mov    0x805038,%eax
  8026ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f3:	74 07                	je     8026fc <initialize_dynamic_allocator+0xfd>
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	eb 05                	jmp    802701 <initialize_dynamic_allocator+0x102>
  8026fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802701:	a3 38 50 80 00       	mov    %eax,0x805038
  802706:	a1 38 50 80 00       	mov    0x805038,%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	0f 85 55 ff ff ff    	jne    802668 <initialize_dynamic_allocator+0x69>
  802713:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802717:	0f 85 4b ff ff ff    	jne    802668 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80271d:	8b 45 08             	mov    0x8(%ebp),%eax
  802720:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802726:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80272c:	a1 48 50 80 00       	mov    0x805048,%eax
  802731:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802736:	a1 44 50 80 00       	mov    0x805044,%eax
  80273b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802741:	8b 45 08             	mov    0x8(%ebp),%eax
  802744:	83 c0 08             	add    $0x8,%eax
  802747:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80274a:	8b 45 08             	mov    0x8(%ebp),%eax
  80274d:	83 c0 04             	add    $0x4,%eax
  802750:	8b 55 0c             	mov    0xc(%ebp),%edx
  802753:	83 ea 08             	sub    $0x8,%edx
  802756:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802758:	8b 55 0c             	mov    0xc(%ebp),%edx
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	01 d0                	add    %edx,%eax
  802760:	83 e8 08             	sub    $0x8,%eax
  802763:	8b 55 0c             	mov    0xc(%ebp),%edx
  802766:	83 ea 08             	sub    $0x8,%edx
  802769:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80276b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802774:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802777:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80277e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802782:	75 17                	jne    80279b <initialize_dynamic_allocator+0x19c>
  802784:	83 ec 04             	sub    $0x4,%esp
  802787:	68 b4 4a 80 00       	push   $0x804ab4
  80278c:	68 90 00 00 00       	push   $0x90
  802791:	68 99 4a 80 00       	push   $0x804a99
  802796:	e8 b0 df ff ff       	call   80074b <_panic>
  80279b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8027a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a4:	89 10                	mov    %edx,(%eax)
  8027a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a9:	8b 00                	mov    (%eax),%eax
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	74 0d                	je     8027bc <initialize_dynamic_allocator+0x1bd>
  8027af:	a1 30 50 80 00       	mov    0x805030,%eax
  8027b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b7:	89 50 04             	mov    %edx,0x4(%eax)
  8027ba:	eb 08                	jmp    8027c4 <initialize_dynamic_allocator+0x1c5>
  8027bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bf:	a3 34 50 80 00       	mov    %eax,0x805034
  8027c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8027cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027db:	40                   	inc    %eax
  8027dc:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8027e1:	eb 07                	jmp    8027ea <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8027e3:	90                   	nop
  8027e4:	eb 04                	jmp    8027ea <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8027e6:	90                   	nop
  8027e7:	eb 01                	jmp    8027ea <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8027e9:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8027ea:	c9                   	leave  
  8027eb:	c3                   	ret    

008027ec <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8027ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8027f2:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8027f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8027fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027fe:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802800:	8b 45 08             	mov    0x8(%ebp),%eax
  802803:	83 e8 04             	sub    $0x4,%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	83 e0 fe             	and    $0xfffffffe,%eax
  80280b:	8d 50 f8             	lea    -0x8(%eax),%edx
  80280e:	8b 45 08             	mov    0x8(%ebp),%eax
  802811:	01 c2                	add    %eax,%edx
  802813:	8b 45 0c             	mov    0xc(%ebp),%eax
  802816:	89 02                	mov    %eax,(%edx)
}
  802818:	90                   	nop
  802819:	5d                   	pop    %ebp
  80281a:	c3                   	ret    

0080281b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80281b:	55                   	push   %ebp
  80281c:	89 e5                	mov    %esp,%ebp
  80281e:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802821:	8b 45 08             	mov    0x8(%ebp),%eax
  802824:	83 e0 01             	and    $0x1,%eax
  802827:	85 c0                	test   %eax,%eax
  802829:	74 03                	je     80282e <alloc_block_FF+0x13>
  80282b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80282e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802832:	77 07                	ja     80283b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802834:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80283b:	a1 28 50 80 00       	mov    0x805028,%eax
  802840:	85 c0                	test   %eax,%eax
  802842:	75 73                	jne    8028b7 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802844:	8b 45 08             	mov    0x8(%ebp),%eax
  802847:	83 c0 10             	add    $0x10,%eax
  80284a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80284d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802854:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802857:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285a:	01 d0                	add    %edx,%eax
  80285c:	48                   	dec    %eax
  80285d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802860:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802863:	ba 00 00 00 00       	mov    $0x0,%edx
  802868:	f7 75 ec             	divl   -0x14(%ebp)
  80286b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80286e:	29 d0                	sub    %edx,%eax
  802870:	c1 e8 0c             	shr    $0xc,%eax
  802873:	83 ec 0c             	sub    $0xc,%esp
  802876:	50                   	push   %eax
  802877:	e8 2e f1 ff ff       	call   8019aa <sbrk>
  80287c:	83 c4 10             	add    $0x10,%esp
  80287f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802882:	83 ec 0c             	sub    $0xc,%esp
  802885:	6a 00                	push   $0x0
  802887:	e8 1e f1 ff ff       	call   8019aa <sbrk>
  80288c:	83 c4 10             	add    $0x10,%esp
  80288f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802892:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802895:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802898:	83 ec 08             	sub    $0x8,%esp
  80289b:	50                   	push   %eax
  80289c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80289f:	e8 5b fd ff ff       	call   8025ff <initialize_dynamic_allocator>
  8028a4:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8028a7:	83 ec 0c             	sub    $0xc,%esp
  8028aa:	68 d7 4a 80 00       	push   $0x804ad7
  8028af:	e8 54 e1 ff ff       	call   800a08 <cprintf>
  8028b4:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8028b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028bb:	75 0a                	jne    8028c7 <alloc_block_FF+0xac>
	        return NULL;
  8028bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c2:	e9 0e 04 00 00       	jmp    802cd5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8028c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8028ce:	a1 30 50 80 00       	mov    0x805030,%eax
  8028d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d6:	e9 f3 02 00 00       	jmp    802bce <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8028e1:	83 ec 0c             	sub    $0xc,%esp
  8028e4:	ff 75 bc             	pushl  -0x44(%ebp)
  8028e7:	e8 af fb ff ff       	call   80249b <get_block_size>
  8028ec:	83 c4 10             	add    $0x10,%esp
  8028ef:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8028f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f5:	83 c0 08             	add    $0x8,%eax
  8028f8:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8028fb:	0f 87 c5 02 00 00    	ja     802bc6 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802901:	8b 45 08             	mov    0x8(%ebp),%eax
  802904:	83 c0 18             	add    $0x18,%eax
  802907:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80290a:	0f 87 19 02 00 00    	ja     802b29 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802910:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802913:	2b 45 08             	sub    0x8(%ebp),%eax
  802916:	83 e8 08             	sub    $0x8,%eax
  802919:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	8d 50 08             	lea    0x8(%eax),%edx
  802922:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802925:	01 d0                	add    %edx,%eax
  802927:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80292a:	8b 45 08             	mov    0x8(%ebp),%eax
  80292d:	83 c0 08             	add    $0x8,%eax
  802930:	83 ec 04             	sub    $0x4,%esp
  802933:	6a 01                	push   $0x1
  802935:	50                   	push   %eax
  802936:	ff 75 bc             	pushl  -0x44(%ebp)
  802939:	e8 ae fe ff ff       	call   8027ec <set_block_data>
  80293e:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	8b 40 04             	mov    0x4(%eax),%eax
  802947:	85 c0                	test   %eax,%eax
  802949:	75 68                	jne    8029b3 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80294b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80294f:	75 17                	jne    802968 <alloc_block_FF+0x14d>
  802951:	83 ec 04             	sub    $0x4,%esp
  802954:	68 b4 4a 80 00       	push   $0x804ab4
  802959:	68 d7 00 00 00       	push   $0xd7
  80295e:	68 99 4a 80 00       	push   $0x804a99
  802963:	e8 e3 dd ff ff       	call   80074b <_panic>
  802968:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80296e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802971:	89 10                	mov    %edx,(%eax)
  802973:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802976:	8b 00                	mov    (%eax),%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	74 0d                	je     802989 <alloc_block_FF+0x16e>
  80297c:	a1 30 50 80 00       	mov    0x805030,%eax
  802981:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802984:	89 50 04             	mov    %edx,0x4(%eax)
  802987:	eb 08                	jmp    802991 <alloc_block_FF+0x176>
  802989:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80298c:	a3 34 50 80 00       	mov    %eax,0x805034
  802991:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802994:	a3 30 50 80 00       	mov    %eax,0x805030
  802999:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80299c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8029a8:	40                   	inc    %eax
  8029a9:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8029ae:	e9 dc 00 00 00       	jmp    802a8f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	8b 00                	mov    (%eax),%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	75 65                	jne    802a21 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029bc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029c0:	75 17                	jne    8029d9 <alloc_block_FF+0x1be>
  8029c2:	83 ec 04             	sub    $0x4,%esp
  8029c5:	68 e8 4a 80 00       	push   $0x804ae8
  8029ca:	68 db 00 00 00       	push   $0xdb
  8029cf:	68 99 4a 80 00       	push   $0x804a99
  8029d4:	e8 72 dd ff ff       	call   80074b <_panic>
  8029d9:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8029df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029e2:	89 50 04             	mov    %edx,0x4(%eax)
  8029e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029e8:	8b 40 04             	mov    0x4(%eax),%eax
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	74 0c                	je     8029fb <alloc_block_FF+0x1e0>
  8029ef:	a1 34 50 80 00       	mov    0x805034,%eax
  8029f4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029f7:	89 10                	mov    %edx,(%eax)
  8029f9:	eb 08                	jmp    802a03 <alloc_block_FF+0x1e8>
  8029fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029fe:	a3 30 50 80 00       	mov    %eax,0x805030
  802a03:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a06:	a3 34 50 80 00       	mov    %eax,0x805034
  802a0b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a14:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a19:	40                   	inc    %eax
  802a1a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a1f:	eb 6e                	jmp    802a8f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802a21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a25:	74 06                	je     802a2d <alloc_block_FF+0x212>
  802a27:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a2b:	75 17                	jne    802a44 <alloc_block_FF+0x229>
  802a2d:	83 ec 04             	sub    $0x4,%esp
  802a30:	68 0c 4b 80 00       	push   $0x804b0c
  802a35:	68 df 00 00 00       	push   $0xdf
  802a3a:	68 99 4a 80 00       	push   $0x804a99
  802a3f:	e8 07 dd ff ff       	call   80074b <_panic>
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	8b 10                	mov    (%eax),%edx
  802a49:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a4c:	89 10                	mov    %edx,(%eax)
  802a4e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a51:	8b 00                	mov    (%eax),%eax
  802a53:	85 c0                	test   %eax,%eax
  802a55:	74 0b                	je     802a62 <alloc_block_FF+0x247>
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	8b 00                	mov    (%eax),%eax
  802a5c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a5f:	89 50 04             	mov    %edx,0x4(%eax)
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a68:	89 10                	mov    %edx,(%eax)
  802a6a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a70:	89 50 04             	mov    %edx,0x4(%eax)
  802a73:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a76:	8b 00                	mov    (%eax),%eax
  802a78:	85 c0                	test   %eax,%eax
  802a7a:	75 08                	jne    802a84 <alloc_block_FF+0x269>
  802a7c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a7f:	a3 34 50 80 00       	mov    %eax,0x805034
  802a84:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a89:	40                   	inc    %eax
  802a8a:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802a8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a93:	75 17                	jne    802aac <alloc_block_FF+0x291>
  802a95:	83 ec 04             	sub    $0x4,%esp
  802a98:	68 7b 4a 80 00       	push   $0x804a7b
  802a9d:	68 e1 00 00 00       	push   $0xe1
  802aa2:	68 99 4a 80 00       	push   $0x804a99
  802aa7:	e8 9f dc ff ff       	call   80074b <_panic>
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	8b 00                	mov    (%eax),%eax
  802ab1:	85 c0                	test   %eax,%eax
  802ab3:	74 10                	je     802ac5 <alloc_block_FF+0x2aa>
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802abd:	8b 52 04             	mov    0x4(%edx),%edx
  802ac0:	89 50 04             	mov    %edx,0x4(%eax)
  802ac3:	eb 0b                	jmp    802ad0 <alloc_block_FF+0x2b5>
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 40 04             	mov    0x4(%eax),%eax
  802acb:	a3 34 50 80 00       	mov    %eax,0x805034
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	8b 40 04             	mov    0x4(%eax),%eax
  802ad6:	85 c0                	test   %eax,%eax
  802ad8:	74 0f                	je     802ae9 <alloc_block_FF+0x2ce>
  802ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802add:	8b 40 04             	mov    0x4(%eax),%eax
  802ae0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae3:	8b 12                	mov    (%edx),%edx
  802ae5:	89 10                	mov    %edx,(%eax)
  802ae7:	eb 0a                	jmp    802af3 <alloc_block_FF+0x2d8>
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 00                	mov    (%eax),%eax
  802aee:	a3 30 50 80 00       	mov    %eax,0x805030
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b06:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b0b:	48                   	dec    %eax
  802b0c:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802b11:	83 ec 04             	sub    $0x4,%esp
  802b14:	6a 00                	push   $0x0
  802b16:	ff 75 b4             	pushl  -0x4c(%ebp)
  802b19:	ff 75 b0             	pushl  -0x50(%ebp)
  802b1c:	e8 cb fc ff ff       	call   8027ec <set_block_data>
  802b21:	83 c4 10             	add    $0x10,%esp
  802b24:	e9 95 00 00 00       	jmp    802bbe <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802b29:	83 ec 04             	sub    $0x4,%esp
  802b2c:	6a 01                	push   $0x1
  802b2e:	ff 75 b8             	pushl  -0x48(%ebp)
  802b31:	ff 75 bc             	pushl  -0x44(%ebp)
  802b34:	e8 b3 fc ff ff       	call   8027ec <set_block_data>
  802b39:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802b3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b40:	75 17                	jne    802b59 <alloc_block_FF+0x33e>
  802b42:	83 ec 04             	sub    $0x4,%esp
  802b45:	68 7b 4a 80 00       	push   $0x804a7b
  802b4a:	68 e8 00 00 00       	push   $0xe8
  802b4f:	68 99 4a 80 00       	push   $0x804a99
  802b54:	e8 f2 db ff ff       	call   80074b <_panic>
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	74 10                	je     802b72 <alloc_block_FF+0x357>
  802b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b65:	8b 00                	mov    (%eax),%eax
  802b67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b6a:	8b 52 04             	mov    0x4(%edx),%edx
  802b6d:	89 50 04             	mov    %edx,0x4(%eax)
  802b70:	eb 0b                	jmp    802b7d <alloc_block_FF+0x362>
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	8b 40 04             	mov    0x4(%eax),%eax
  802b78:	a3 34 50 80 00       	mov    %eax,0x805034
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	8b 40 04             	mov    0x4(%eax),%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	74 0f                	je     802b96 <alloc_block_FF+0x37b>
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 40 04             	mov    0x4(%eax),%eax
  802b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b90:	8b 12                	mov    (%edx),%edx
  802b92:	89 10                	mov    %edx,(%eax)
  802b94:	eb 0a                	jmp    802ba0 <alloc_block_FF+0x385>
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	8b 00                	mov    (%eax),%eax
  802b9b:	a3 30 50 80 00       	mov    %eax,0x805030
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bb8:	48                   	dec    %eax
  802bb9:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802bbe:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bc1:	e9 0f 01 00 00       	jmp    802cd5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802bc6:	a1 38 50 80 00       	mov    0x805038,%eax
  802bcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd2:	74 07                	je     802bdb <alloc_block_FF+0x3c0>
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 00                	mov    (%eax),%eax
  802bd9:	eb 05                	jmp    802be0 <alloc_block_FF+0x3c5>
  802bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  802be0:	a3 38 50 80 00       	mov    %eax,0x805038
  802be5:	a1 38 50 80 00       	mov    0x805038,%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	0f 85 e9 fc ff ff    	jne    8028db <alloc_block_FF+0xc0>
  802bf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf6:	0f 85 df fc ff ff    	jne    8028db <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bff:	83 c0 08             	add    $0x8,%eax
  802c02:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c05:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802c0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c12:	01 d0                	add    %edx,%eax
  802c14:	48                   	dec    %eax
  802c15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802c18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c1b:	ba 00 00 00 00       	mov    $0x0,%edx
  802c20:	f7 75 d8             	divl   -0x28(%ebp)
  802c23:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c26:	29 d0                	sub    %edx,%eax
  802c28:	c1 e8 0c             	shr    $0xc,%eax
  802c2b:	83 ec 0c             	sub    $0xc,%esp
  802c2e:	50                   	push   %eax
  802c2f:	e8 76 ed ff ff       	call   8019aa <sbrk>
  802c34:	83 c4 10             	add    $0x10,%esp
  802c37:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802c3a:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802c3e:	75 0a                	jne    802c4a <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802c40:	b8 00 00 00 00       	mov    $0x0,%eax
  802c45:	e9 8b 00 00 00       	jmp    802cd5 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c4a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802c51:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c57:	01 d0                	add    %edx,%eax
  802c59:	48                   	dec    %eax
  802c5a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802c5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c60:	ba 00 00 00 00       	mov    $0x0,%edx
  802c65:	f7 75 cc             	divl   -0x34(%ebp)
  802c68:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c6b:	29 d0                	sub    %edx,%eax
  802c6d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c70:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c73:	01 d0                	add    %edx,%eax
  802c75:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802c7a:	a1 44 50 80 00       	mov    0x805044,%eax
  802c7f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c85:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c8f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c92:	01 d0                	add    %edx,%eax
  802c94:	48                   	dec    %eax
  802c95:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c98:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  802ca0:	f7 75 c4             	divl   -0x3c(%ebp)
  802ca3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ca6:	29 d0                	sub    %edx,%eax
  802ca8:	83 ec 04             	sub    $0x4,%esp
  802cab:	6a 01                	push   $0x1
  802cad:	50                   	push   %eax
  802cae:	ff 75 d0             	pushl  -0x30(%ebp)
  802cb1:	e8 36 fb ff ff       	call   8027ec <set_block_data>
  802cb6:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802cb9:	83 ec 0c             	sub    $0xc,%esp
  802cbc:	ff 75 d0             	pushl  -0x30(%ebp)
  802cbf:	e8 1b 0a 00 00       	call   8036df <free_block>
  802cc4:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802cc7:	83 ec 0c             	sub    $0xc,%esp
  802cca:	ff 75 08             	pushl  0x8(%ebp)
  802ccd:	e8 49 fb ff ff       	call   80281b <alloc_block_FF>
  802cd2:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802cd5:	c9                   	leave  
  802cd6:	c3                   	ret    

00802cd7 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802cd7:	55                   	push   %ebp
  802cd8:	89 e5                	mov    %esp,%ebp
  802cda:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce0:	83 e0 01             	and    $0x1,%eax
  802ce3:	85 c0                	test   %eax,%eax
  802ce5:	74 03                	je     802cea <alloc_block_BF+0x13>
  802ce7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802cea:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802cee:	77 07                	ja     802cf7 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802cf0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802cf7:	a1 28 50 80 00       	mov    0x805028,%eax
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	75 73                	jne    802d73 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	83 c0 10             	add    $0x10,%eax
  802d06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802d09:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802d10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d16:	01 d0                	add    %edx,%eax
  802d18:	48                   	dec    %eax
  802d19:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d1f:	ba 00 00 00 00       	mov    $0x0,%edx
  802d24:	f7 75 e0             	divl   -0x20(%ebp)
  802d27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d2a:	29 d0                	sub    %edx,%eax
  802d2c:	c1 e8 0c             	shr    $0xc,%eax
  802d2f:	83 ec 0c             	sub    $0xc,%esp
  802d32:	50                   	push   %eax
  802d33:	e8 72 ec ff ff       	call   8019aa <sbrk>
  802d38:	83 c4 10             	add    $0x10,%esp
  802d3b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802d3e:	83 ec 0c             	sub    $0xc,%esp
  802d41:	6a 00                	push   $0x0
  802d43:	e8 62 ec ff ff       	call   8019aa <sbrk>
  802d48:	83 c4 10             	add    $0x10,%esp
  802d4b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802d4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d51:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802d54:	83 ec 08             	sub    $0x8,%esp
  802d57:	50                   	push   %eax
  802d58:	ff 75 d8             	pushl  -0x28(%ebp)
  802d5b:	e8 9f f8 ff ff       	call   8025ff <initialize_dynamic_allocator>
  802d60:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802d63:	83 ec 0c             	sub    $0xc,%esp
  802d66:	68 d7 4a 80 00       	push   $0x804ad7
  802d6b:	e8 98 dc ff ff       	call   800a08 <cprintf>
  802d70:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802d73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802d7a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802d81:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802d88:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802d8f:	a1 30 50 80 00       	mov    0x805030,%eax
  802d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d97:	e9 1d 01 00 00       	jmp    802eb9 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802da2:	83 ec 0c             	sub    $0xc,%esp
  802da5:	ff 75 a8             	pushl  -0x58(%ebp)
  802da8:	e8 ee f6 ff ff       	call   80249b <get_block_size>
  802dad:	83 c4 10             	add    $0x10,%esp
  802db0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	83 c0 08             	add    $0x8,%eax
  802db9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802dbc:	0f 87 ef 00 00 00    	ja     802eb1 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	83 c0 18             	add    $0x18,%eax
  802dc8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802dcb:	77 1d                	ja     802dea <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802dcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802dd3:	0f 86 d8 00 00 00    	jbe    802eb1 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802dd9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ddc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802ddf:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802de2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802de5:	e9 c7 00 00 00       	jmp    802eb1 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802dea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ded:	83 c0 08             	add    $0x8,%eax
  802df0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802df3:	0f 85 9d 00 00 00    	jne    802e96 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802df9:	83 ec 04             	sub    $0x4,%esp
  802dfc:	6a 01                	push   $0x1
  802dfe:	ff 75 a4             	pushl  -0x5c(%ebp)
  802e01:	ff 75 a8             	pushl  -0x58(%ebp)
  802e04:	e8 e3 f9 ff ff       	call   8027ec <set_block_data>
  802e09:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802e0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e10:	75 17                	jne    802e29 <alloc_block_BF+0x152>
  802e12:	83 ec 04             	sub    $0x4,%esp
  802e15:	68 7b 4a 80 00       	push   $0x804a7b
  802e1a:	68 2c 01 00 00       	push   $0x12c
  802e1f:	68 99 4a 80 00       	push   $0x804a99
  802e24:	e8 22 d9 ff ff       	call   80074b <_panic>
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	8b 00                	mov    (%eax),%eax
  802e2e:	85 c0                	test   %eax,%eax
  802e30:	74 10                	je     802e42 <alloc_block_BF+0x16b>
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	8b 00                	mov    (%eax),%eax
  802e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e3a:	8b 52 04             	mov    0x4(%edx),%edx
  802e3d:	89 50 04             	mov    %edx,0x4(%eax)
  802e40:	eb 0b                	jmp    802e4d <alloc_block_BF+0x176>
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 40 04             	mov    0x4(%eax),%eax
  802e48:	a3 34 50 80 00       	mov    %eax,0x805034
  802e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e50:	8b 40 04             	mov    0x4(%eax),%eax
  802e53:	85 c0                	test   %eax,%eax
  802e55:	74 0f                	je     802e66 <alloc_block_BF+0x18f>
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 40 04             	mov    0x4(%eax),%eax
  802e5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e60:	8b 12                	mov    (%edx),%edx
  802e62:	89 10                	mov    %edx,(%eax)
  802e64:	eb 0a                	jmp    802e70 <alloc_block_BF+0x199>
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 00                	mov    (%eax),%eax
  802e6b:	a3 30 50 80 00       	mov    %eax,0x805030
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e83:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e88:	48                   	dec    %eax
  802e89:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802e8e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e91:	e9 24 04 00 00       	jmp    8032ba <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802e96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e99:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e9c:	76 13                	jbe    802eb1 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802e9e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802ea5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ea8:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802eab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802eae:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802eb1:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebd:	74 07                	je     802ec6 <alloc_block_BF+0x1ef>
  802ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec2:	8b 00                	mov    (%eax),%eax
  802ec4:	eb 05                	jmp    802ecb <alloc_block_BF+0x1f4>
  802ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ecb:	a3 38 50 80 00       	mov    %eax,0x805038
  802ed0:	a1 38 50 80 00       	mov    0x805038,%eax
  802ed5:	85 c0                	test   %eax,%eax
  802ed7:	0f 85 bf fe ff ff    	jne    802d9c <alloc_block_BF+0xc5>
  802edd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee1:	0f 85 b5 fe ff ff    	jne    802d9c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802ee7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eeb:	0f 84 26 02 00 00    	je     803117 <alloc_block_BF+0x440>
  802ef1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ef5:	0f 85 1c 02 00 00    	jne    803117 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efe:	2b 45 08             	sub    0x8(%ebp),%eax
  802f01:	83 e8 08             	sub    $0x8,%eax
  802f04:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	8d 50 08             	lea    0x8(%eax),%edx
  802f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f10:	01 d0                	add    %edx,%eax
  802f12:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	83 c0 08             	add    $0x8,%eax
  802f1b:	83 ec 04             	sub    $0x4,%esp
  802f1e:	6a 01                	push   $0x1
  802f20:	50                   	push   %eax
  802f21:	ff 75 f0             	pushl  -0x10(%ebp)
  802f24:	e8 c3 f8 ff ff       	call   8027ec <set_block_data>
  802f29:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2f:	8b 40 04             	mov    0x4(%eax),%eax
  802f32:	85 c0                	test   %eax,%eax
  802f34:	75 68                	jne    802f9e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f36:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f3a:	75 17                	jne    802f53 <alloc_block_BF+0x27c>
  802f3c:	83 ec 04             	sub    $0x4,%esp
  802f3f:	68 b4 4a 80 00       	push   $0x804ab4
  802f44:	68 45 01 00 00       	push   $0x145
  802f49:	68 99 4a 80 00       	push   $0x804a99
  802f4e:	e8 f8 d7 ff ff       	call   80074b <_panic>
  802f53:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f59:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f5c:	89 10                	mov    %edx,(%eax)
  802f5e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f61:	8b 00                	mov    (%eax),%eax
  802f63:	85 c0                	test   %eax,%eax
  802f65:	74 0d                	je     802f74 <alloc_block_BF+0x29d>
  802f67:	a1 30 50 80 00       	mov    0x805030,%eax
  802f6c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f6f:	89 50 04             	mov    %edx,0x4(%eax)
  802f72:	eb 08                	jmp    802f7c <alloc_block_BF+0x2a5>
  802f74:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f77:	a3 34 50 80 00       	mov    %eax,0x805034
  802f7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f7f:	a3 30 50 80 00       	mov    %eax,0x805030
  802f84:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f93:	40                   	inc    %eax
  802f94:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802f99:	e9 dc 00 00 00       	jmp    80307a <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa1:	8b 00                	mov    (%eax),%eax
  802fa3:	85 c0                	test   %eax,%eax
  802fa5:	75 65                	jne    80300c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802fa7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fab:	75 17                	jne    802fc4 <alloc_block_BF+0x2ed>
  802fad:	83 ec 04             	sub    $0x4,%esp
  802fb0:	68 e8 4a 80 00       	push   $0x804ae8
  802fb5:	68 4a 01 00 00       	push   $0x14a
  802fba:	68 99 4a 80 00       	push   $0x804a99
  802fbf:	e8 87 d7 ff ff       	call   80074b <_panic>
  802fc4:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802fca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fcd:	89 50 04             	mov    %edx,0x4(%eax)
  802fd0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fd3:	8b 40 04             	mov    0x4(%eax),%eax
  802fd6:	85 c0                	test   %eax,%eax
  802fd8:	74 0c                	je     802fe6 <alloc_block_BF+0x30f>
  802fda:	a1 34 50 80 00       	mov    0x805034,%eax
  802fdf:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fe2:	89 10                	mov    %edx,(%eax)
  802fe4:	eb 08                	jmp    802fee <alloc_block_BF+0x317>
  802fe6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fe9:	a3 30 50 80 00       	mov    %eax,0x805030
  802fee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ff1:	a3 34 50 80 00       	mov    %eax,0x805034
  802ff6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ff9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fff:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803004:	40                   	inc    %eax
  803005:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80300a:	eb 6e                	jmp    80307a <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80300c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803010:	74 06                	je     803018 <alloc_block_BF+0x341>
  803012:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803016:	75 17                	jne    80302f <alloc_block_BF+0x358>
  803018:	83 ec 04             	sub    $0x4,%esp
  80301b:	68 0c 4b 80 00       	push   $0x804b0c
  803020:	68 4f 01 00 00       	push   $0x14f
  803025:	68 99 4a 80 00       	push   $0x804a99
  80302a:	e8 1c d7 ff ff       	call   80074b <_panic>
  80302f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803032:	8b 10                	mov    (%eax),%edx
  803034:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803037:	89 10                	mov    %edx,(%eax)
  803039:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80303c:	8b 00                	mov    (%eax),%eax
  80303e:	85 c0                	test   %eax,%eax
  803040:	74 0b                	je     80304d <alloc_block_BF+0x376>
  803042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803045:	8b 00                	mov    (%eax),%eax
  803047:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80304a:	89 50 04             	mov    %edx,0x4(%eax)
  80304d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803050:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803053:	89 10                	mov    %edx,(%eax)
  803055:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803058:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80305b:	89 50 04             	mov    %edx,0x4(%eax)
  80305e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	85 c0                	test   %eax,%eax
  803065:	75 08                	jne    80306f <alloc_block_BF+0x398>
  803067:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80306a:	a3 34 50 80 00       	mov    %eax,0x805034
  80306f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803074:	40                   	inc    %eax
  803075:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80307a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80307e:	75 17                	jne    803097 <alloc_block_BF+0x3c0>
  803080:	83 ec 04             	sub    $0x4,%esp
  803083:	68 7b 4a 80 00       	push   $0x804a7b
  803088:	68 51 01 00 00       	push   $0x151
  80308d:	68 99 4a 80 00       	push   $0x804a99
  803092:	e8 b4 d6 ff ff       	call   80074b <_panic>
  803097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309a:	8b 00                	mov    (%eax),%eax
  80309c:	85 c0                	test   %eax,%eax
  80309e:	74 10                	je     8030b0 <alloc_block_BF+0x3d9>
  8030a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030a8:	8b 52 04             	mov    0x4(%edx),%edx
  8030ab:	89 50 04             	mov    %edx,0x4(%eax)
  8030ae:	eb 0b                	jmp    8030bb <alloc_block_BF+0x3e4>
  8030b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b3:	8b 40 04             	mov    0x4(%eax),%eax
  8030b6:	a3 34 50 80 00       	mov    %eax,0x805034
  8030bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030be:	8b 40 04             	mov    0x4(%eax),%eax
  8030c1:	85 c0                	test   %eax,%eax
  8030c3:	74 0f                	je     8030d4 <alloc_block_BF+0x3fd>
  8030c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c8:	8b 40 04             	mov    0x4(%eax),%eax
  8030cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030ce:	8b 12                	mov    (%edx),%edx
  8030d0:	89 10                	mov    %edx,(%eax)
  8030d2:	eb 0a                	jmp    8030de <alloc_block_BF+0x407>
  8030d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8030de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030f6:	48                   	dec    %eax
  8030f7:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  8030fc:	83 ec 04             	sub    $0x4,%esp
  8030ff:	6a 00                	push   $0x0
  803101:	ff 75 d0             	pushl  -0x30(%ebp)
  803104:	ff 75 cc             	pushl  -0x34(%ebp)
  803107:	e8 e0 f6 ff ff       	call   8027ec <set_block_data>
  80310c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80310f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803112:	e9 a3 01 00 00       	jmp    8032ba <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803117:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80311b:	0f 85 9d 00 00 00    	jne    8031be <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803121:	83 ec 04             	sub    $0x4,%esp
  803124:	6a 01                	push   $0x1
  803126:	ff 75 ec             	pushl  -0x14(%ebp)
  803129:	ff 75 f0             	pushl  -0x10(%ebp)
  80312c:	e8 bb f6 ff ff       	call   8027ec <set_block_data>
  803131:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803134:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803138:	75 17                	jne    803151 <alloc_block_BF+0x47a>
  80313a:	83 ec 04             	sub    $0x4,%esp
  80313d:	68 7b 4a 80 00       	push   $0x804a7b
  803142:	68 58 01 00 00       	push   $0x158
  803147:	68 99 4a 80 00       	push   $0x804a99
  80314c:	e8 fa d5 ff ff       	call   80074b <_panic>
  803151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803154:	8b 00                	mov    (%eax),%eax
  803156:	85 c0                	test   %eax,%eax
  803158:	74 10                	je     80316a <alloc_block_BF+0x493>
  80315a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315d:	8b 00                	mov    (%eax),%eax
  80315f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803162:	8b 52 04             	mov    0x4(%edx),%edx
  803165:	89 50 04             	mov    %edx,0x4(%eax)
  803168:	eb 0b                	jmp    803175 <alloc_block_BF+0x49e>
  80316a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316d:	8b 40 04             	mov    0x4(%eax),%eax
  803170:	a3 34 50 80 00       	mov    %eax,0x805034
  803175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803178:	8b 40 04             	mov    0x4(%eax),%eax
  80317b:	85 c0                	test   %eax,%eax
  80317d:	74 0f                	je     80318e <alloc_block_BF+0x4b7>
  80317f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803182:	8b 40 04             	mov    0x4(%eax),%eax
  803185:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803188:	8b 12                	mov    (%edx),%edx
  80318a:	89 10                	mov    %edx,(%eax)
  80318c:	eb 0a                	jmp    803198 <alloc_block_BF+0x4c1>
  80318e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803191:	8b 00                	mov    (%eax),%eax
  803193:	a3 30 50 80 00       	mov    %eax,0x805030
  803198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ab:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031b0:	48                   	dec    %eax
  8031b1:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  8031b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b9:	e9 fc 00 00 00       	jmp    8032ba <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	83 c0 08             	add    $0x8,%eax
  8031c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8031c7:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8031ce:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031d1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8031d4:	01 d0                	add    %edx,%eax
  8031d6:	48                   	dec    %eax
  8031d7:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8031da:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8031e2:	f7 75 c4             	divl   -0x3c(%ebp)
  8031e5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031e8:	29 d0                	sub    %edx,%eax
  8031ea:	c1 e8 0c             	shr    $0xc,%eax
  8031ed:	83 ec 0c             	sub    $0xc,%esp
  8031f0:	50                   	push   %eax
  8031f1:	e8 b4 e7 ff ff       	call   8019aa <sbrk>
  8031f6:	83 c4 10             	add    $0x10,%esp
  8031f9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8031fc:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803200:	75 0a                	jne    80320c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803202:	b8 00 00 00 00       	mov    $0x0,%eax
  803207:	e9 ae 00 00 00       	jmp    8032ba <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80320c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803213:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803216:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803219:	01 d0                	add    %edx,%eax
  80321b:	48                   	dec    %eax
  80321c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80321f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803222:	ba 00 00 00 00       	mov    $0x0,%edx
  803227:	f7 75 b8             	divl   -0x48(%ebp)
  80322a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80322d:	29 d0                	sub    %edx,%eax
  80322f:	8d 50 fc             	lea    -0x4(%eax),%edx
  803232:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803235:	01 d0                	add    %edx,%eax
  803237:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  80323c:	a1 44 50 80 00       	mov    0x805044,%eax
  803241:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803247:	83 ec 0c             	sub    $0xc,%esp
  80324a:	68 40 4b 80 00       	push   $0x804b40
  80324f:	e8 b4 d7 ff ff       	call   800a08 <cprintf>
  803254:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803257:	83 ec 08             	sub    $0x8,%esp
  80325a:	ff 75 bc             	pushl  -0x44(%ebp)
  80325d:	68 45 4b 80 00       	push   $0x804b45
  803262:	e8 a1 d7 ff ff       	call   800a08 <cprintf>
  803267:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80326a:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803271:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803274:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803277:	01 d0                	add    %edx,%eax
  803279:	48                   	dec    %eax
  80327a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80327d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803280:	ba 00 00 00 00       	mov    $0x0,%edx
  803285:	f7 75 b0             	divl   -0x50(%ebp)
  803288:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80328b:	29 d0                	sub    %edx,%eax
  80328d:	83 ec 04             	sub    $0x4,%esp
  803290:	6a 01                	push   $0x1
  803292:	50                   	push   %eax
  803293:	ff 75 bc             	pushl  -0x44(%ebp)
  803296:	e8 51 f5 ff ff       	call   8027ec <set_block_data>
  80329b:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80329e:	83 ec 0c             	sub    $0xc,%esp
  8032a1:	ff 75 bc             	pushl  -0x44(%ebp)
  8032a4:	e8 36 04 00 00       	call   8036df <free_block>
  8032a9:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8032ac:	83 ec 0c             	sub    $0xc,%esp
  8032af:	ff 75 08             	pushl  0x8(%ebp)
  8032b2:	e8 20 fa ff ff       	call   802cd7 <alloc_block_BF>
  8032b7:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8032ba:	c9                   	leave  
  8032bb:	c3                   	ret    

008032bc <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8032bc:	55                   	push   %ebp
  8032bd:	89 e5                	mov    %esp,%ebp
  8032bf:	53                   	push   %ebx
  8032c0:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8032c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8032ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8032d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d5:	74 1e                	je     8032f5 <merging+0x39>
  8032d7:	ff 75 08             	pushl  0x8(%ebp)
  8032da:	e8 bc f1 ff ff       	call   80249b <get_block_size>
  8032df:	83 c4 04             	add    $0x4,%esp
  8032e2:	89 c2                	mov    %eax,%edx
  8032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e7:	01 d0                	add    %edx,%eax
  8032e9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8032ec:	75 07                	jne    8032f5 <merging+0x39>
		prev_is_free = 1;
  8032ee:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8032f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032f9:	74 1e                	je     803319 <merging+0x5d>
  8032fb:	ff 75 10             	pushl  0x10(%ebp)
  8032fe:	e8 98 f1 ff ff       	call   80249b <get_block_size>
  803303:	83 c4 04             	add    $0x4,%esp
  803306:	89 c2                	mov    %eax,%edx
  803308:	8b 45 10             	mov    0x10(%ebp),%eax
  80330b:	01 d0                	add    %edx,%eax
  80330d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803310:	75 07                	jne    803319 <merging+0x5d>
		next_is_free = 1;
  803312:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803319:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80331d:	0f 84 cc 00 00 00    	je     8033ef <merging+0x133>
  803323:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803327:	0f 84 c2 00 00 00    	je     8033ef <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80332d:	ff 75 08             	pushl  0x8(%ebp)
  803330:	e8 66 f1 ff ff       	call   80249b <get_block_size>
  803335:	83 c4 04             	add    $0x4,%esp
  803338:	89 c3                	mov    %eax,%ebx
  80333a:	ff 75 10             	pushl  0x10(%ebp)
  80333d:	e8 59 f1 ff ff       	call   80249b <get_block_size>
  803342:	83 c4 04             	add    $0x4,%esp
  803345:	01 c3                	add    %eax,%ebx
  803347:	ff 75 0c             	pushl  0xc(%ebp)
  80334a:	e8 4c f1 ff ff       	call   80249b <get_block_size>
  80334f:	83 c4 04             	add    $0x4,%esp
  803352:	01 d8                	add    %ebx,%eax
  803354:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803357:	6a 00                	push   $0x0
  803359:	ff 75 ec             	pushl  -0x14(%ebp)
  80335c:	ff 75 08             	pushl  0x8(%ebp)
  80335f:	e8 88 f4 ff ff       	call   8027ec <set_block_data>
  803364:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803367:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80336b:	75 17                	jne    803384 <merging+0xc8>
  80336d:	83 ec 04             	sub    $0x4,%esp
  803370:	68 7b 4a 80 00       	push   $0x804a7b
  803375:	68 7d 01 00 00       	push   $0x17d
  80337a:	68 99 4a 80 00       	push   $0x804a99
  80337f:	e8 c7 d3 ff ff       	call   80074b <_panic>
  803384:	8b 45 0c             	mov    0xc(%ebp),%eax
  803387:	8b 00                	mov    (%eax),%eax
  803389:	85 c0                	test   %eax,%eax
  80338b:	74 10                	je     80339d <merging+0xe1>
  80338d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803390:	8b 00                	mov    (%eax),%eax
  803392:	8b 55 0c             	mov    0xc(%ebp),%edx
  803395:	8b 52 04             	mov    0x4(%edx),%edx
  803398:	89 50 04             	mov    %edx,0x4(%eax)
  80339b:	eb 0b                	jmp    8033a8 <merging+0xec>
  80339d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a0:	8b 40 04             	mov    0x4(%eax),%eax
  8033a3:	a3 34 50 80 00       	mov    %eax,0x805034
  8033a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ab:	8b 40 04             	mov    0x4(%eax),%eax
  8033ae:	85 c0                	test   %eax,%eax
  8033b0:	74 0f                	je     8033c1 <merging+0x105>
  8033b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b5:	8b 40 04             	mov    0x4(%eax),%eax
  8033b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033bb:	8b 12                	mov    (%edx),%edx
  8033bd:	89 10                	mov    %edx,(%eax)
  8033bf:	eb 0a                	jmp    8033cb <merging+0x10f>
  8033c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c4:	8b 00                	mov    (%eax),%eax
  8033c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8033cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033de:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8033e3:	48                   	dec    %eax
  8033e4:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8033e9:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8033ea:	e9 ea 02 00 00       	jmp    8036d9 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8033ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f3:	74 3b                	je     803430 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8033f5:	83 ec 0c             	sub    $0xc,%esp
  8033f8:	ff 75 08             	pushl  0x8(%ebp)
  8033fb:	e8 9b f0 ff ff       	call   80249b <get_block_size>
  803400:	83 c4 10             	add    $0x10,%esp
  803403:	89 c3                	mov    %eax,%ebx
  803405:	83 ec 0c             	sub    $0xc,%esp
  803408:	ff 75 10             	pushl  0x10(%ebp)
  80340b:	e8 8b f0 ff ff       	call   80249b <get_block_size>
  803410:	83 c4 10             	add    $0x10,%esp
  803413:	01 d8                	add    %ebx,%eax
  803415:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803418:	83 ec 04             	sub    $0x4,%esp
  80341b:	6a 00                	push   $0x0
  80341d:	ff 75 e8             	pushl  -0x18(%ebp)
  803420:	ff 75 08             	pushl  0x8(%ebp)
  803423:	e8 c4 f3 ff ff       	call   8027ec <set_block_data>
  803428:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80342b:	e9 a9 02 00 00       	jmp    8036d9 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803430:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803434:	0f 84 2d 01 00 00    	je     803567 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80343a:	83 ec 0c             	sub    $0xc,%esp
  80343d:	ff 75 10             	pushl  0x10(%ebp)
  803440:	e8 56 f0 ff ff       	call   80249b <get_block_size>
  803445:	83 c4 10             	add    $0x10,%esp
  803448:	89 c3                	mov    %eax,%ebx
  80344a:	83 ec 0c             	sub    $0xc,%esp
  80344d:	ff 75 0c             	pushl  0xc(%ebp)
  803450:	e8 46 f0 ff ff       	call   80249b <get_block_size>
  803455:	83 c4 10             	add    $0x10,%esp
  803458:	01 d8                	add    %ebx,%eax
  80345a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80345d:	83 ec 04             	sub    $0x4,%esp
  803460:	6a 00                	push   $0x0
  803462:	ff 75 e4             	pushl  -0x1c(%ebp)
  803465:	ff 75 10             	pushl  0x10(%ebp)
  803468:	e8 7f f3 ff ff       	call   8027ec <set_block_data>
  80346d:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803470:	8b 45 10             	mov    0x10(%ebp),%eax
  803473:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803476:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80347a:	74 06                	je     803482 <merging+0x1c6>
  80347c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803480:	75 17                	jne    803499 <merging+0x1dd>
  803482:	83 ec 04             	sub    $0x4,%esp
  803485:	68 54 4b 80 00       	push   $0x804b54
  80348a:	68 8d 01 00 00       	push   $0x18d
  80348f:	68 99 4a 80 00       	push   $0x804a99
  803494:	e8 b2 d2 ff ff       	call   80074b <_panic>
  803499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349c:	8b 50 04             	mov    0x4(%eax),%edx
  80349f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034a2:	89 50 04             	mov    %edx,0x4(%eax)
  8034a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034ab:	89 10                	mov    %edx,(%eax)
  8034ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b0:	8b 40 04             	mov    0x4(%eax),%eax
  8034b3:	85 c0                	test   %eax,%eax
  8034b5:	74 0d                	je     8034c4 <merging+0x208>
  8034b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ba:	8b 40 04             	mov    0x4(%eax),%eax
  8034bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034c0:	89 10                	mov    %edx,(%eax)
  8034c2:	eb 08                	jmp    8034cc <merging+0x210>
  8034c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8034cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034d2:	89 50 04             	mov    %edx,0x4(%eax)
  8034d5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034da:	40                   	inc    %eax
  8034db:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  8034e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034e4:	75 17                	jne    8034fd <merging+0x241>
  8034e6:	83 ec 04             	sub    $0x4,%esp
  8034e9:	68 7b 4a 80 00       	push   $0x804a7b
  8034ee:	68 8e 01 00 00       	push   $0x18e
  8034f3:	68 99 4a 80 00       	push   $0x804a99
  8034f8:	e8 4e d2 ff ff       	call   80074b <_panic>
  8034fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803500:	8b 00                	mov    (%eax),%eax
  803502:	85 c0                	test   %eax,%eax
  803504:	74 10                	je     803516 <merging+0x25a>
  803506:	8b 45 0c             	mov    0xc(%ebp),%eax
  803509:	8b 00                	mov    (%eax),%eax
  80350b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80350e:	8b 52 04             	mov    0x4(%edx),%edx
  803511:	89 50 04             	mov    %edx,0x4(%eax)
  803514:	eb 0b                	jmp    803521 <merging+0x265>
  803516:	8b 45 0c             	mov    0xc(%ebp),%eax
  803519:	8b 40 04             	mov    0x4(%eax),%eax
  80351c:	a3 34 50 80 00       	mov    %eax,0x805034
  803521:	8b 45 0c             	mov    0xc(%ebp),%eax
  803524:	8b 40 04             	mov    0x4(%eax),%eax
  803527:	85 c0                	test   %eax,%eax
  803529:	74 0f                	je     80353a <merging+0x27e>
  80352b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352e:	8b 40 04             	mov    0x4(%eax),%eax
  803531:	8b 55 0c             	mov    0xc(%ebp),%edx
  803534:	8b 12                	mov    (%edx),%edx
  803536:	89 10                	mov    %edx,(%eax)
  803538:	eb 0a                	jmp    803544 <merging+0x288>
  80353a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80353d:	8b 00                	mov    (%eax),%eax
  80353f:	a3 30 50 80 00       	mov    %eax,0x805030
  803544:	8b 45 0c             	mov    0xc(%ebp),%eax
  803547:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80354d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803550:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803557:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80355c:	48                   	dec    %eax
  80355d:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803562:	e9 72 01 00 00       	jmp    8036d9 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803567:	8b 45 10             	mov    0x10(%ebp),%eax
  80356a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80356d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803571:	74 79                	je     8035ec <merging+0x330>
  803573:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803577:	74 73                	je     8035ec <merging+0x330>
  803579:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80357d:	74 06                	je     803585 <merging+0x2c9>
  80357f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803583:	75 17                	jne    80359c <merging+0x2e0>
  803585:	83 ec 04             	sub    $0x4,%esp
  803588:	68 0c 4b 80 00       	push   $0x804b0c
  80358d:	68 94 01 00 00       	push   $0x194
  803592:	68 99 4a 80 00       	push   $0x804a99
  803597:	e8 af d1 ff ff       	call   80074b <_panic>
  80359c:	8b 45 08             	mov    0x8(%ebp),%eax
  80359f:	8b 10                	mov    (%eax),%edx
  8035a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035a4:	89 10                	mov    %edx,(%eax)
  8035a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035a9:	8b 00                	mov    (%eax),%eax
  8035ab:	85 c0                	test   %eax,%eax
  8035ad:	74 0b                	je     8035ba <merging+0x2fe>
  8035af:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b2:	8b 00                	mov    (%eax),%eax
  8035b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035b7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035c0:	89 10                	mov    %edx,(%eax)
  8035c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c8:	89 50 04             	mov    %edx,0x4(%eax)
  8035cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035ce:	8b 00                	mov    (%eax),%eax
  8035d0:	85 c0                	test   %eax,%eax
  8035d2:	75 08                	jne    8035dc <merging+0x320>
  8035d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8035dc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035e1:	40                   	inc    %eax
  8035e2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035e7:	e9 ce 00 00 00       	jmp    8036ba <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8035ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f0:	74 65                	je     803657 <merging+0x39b>
  8035f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035f6:	75 17                	jne    80360f <merging+0x353>
  8035f8:	83 ec 04             	sub    $0x4,%esp
  8035fb:	68 e8 4a 80 00       	push   $0x804ae8
  803600:	68 95 01 00 00       	push   $0x195
  803605:	68 99 4a 80 00       	push   $0x804a99
  80360a:	e8 3c d1 ff ff       	call   80074b <_panic>
  80360f:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803615:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803618:	89 50 04             	mov    %edx,0x4(%eax)
  80361b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80361e:	8b 40 04             	mov    0x4(%eax),%eax
  803621:	85 c0                	test   %eax,%eax
  803623:	74 0c                	je     803631 <merging+0x375>
  803625:	a1 34 50 80 00       	mov    0x805034,%eax
  80362a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80362d:	89 10                	mov    %edx,(%eax)
  80362f:	eb 08                	jmp    803639 <merging+0x37d>
  803631:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803634:	a3 30 50 80 00       	mov    %eax,0x805030
  803639:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80363c:	a3 34 50 80 00       	mov    %eax,0x805034
  803641:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803644:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80364a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80364f:	40                   	inc    %eax
  803650:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803655:	eb 63                	jmp    8036ba <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803657:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80365b:	75 17                	jne    803674 <merging+0x3b8>
  80365d:	83 ec 04             	sub    $0x4,%esp
  803660:	68 b4 4a 80 00       	push   $0x804ab4
  803665:	68 98 01 00 00       	push   $0x198
  80366a:	68 99 4a 80 00       	push   $0x804a99
  80366f:	e8 d7 d0 ff ff       	call   80074b <_panic>
  803674:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80367a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80367d:	89 10                	mov    %edx,(%eax)
  80367f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803682:	8b 00                	mov    (%eax),%eax
  803684:	85 c0                	test   %eax,%eax
  803686:	74 0d                	je     803695 <merging+0x3d9>
  803688:	a1 30 50 80 00       	mov    0x805030,%eax
  80368d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803690:	89 50 04             	mov    %edx,0x4(%eax)
  803693:	eb 08                	jmp    80369d <merging+0x3e1>
  803695:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803698:	a3 34 50 80 00       	mov    %eax,0x805034
  80369d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036a0:	a3 30 50 80 00       	mov    %eax,0x805030
  8036a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036af:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036b4:	40                   	inc    %eax
  8036b5:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  8036ba:	83 ec 0c             	sub    $0xc,%esp
  8036bd:	ff 75 10             	pushl  0x10(%ebp)
  8036c0:	e8 d6 ed ff ff       	call   80249b <get_block_size>
  8036c5:	83 c4 10             	add    $0x10,%esp
  8036c8:	83 ec 04             	sub    $0x4,%esp
  8036cb:	6a 00                	push   $0x0
  8036cd:	50                   	push   %eax
  8036ce:	ff 75 10             	pushl  0x10(%ebp)
  8036d1:	e8 16 f1 ff ff       	call   8027ec <set_block_data>
  8036d6:	83 c4 10             	add    $0x10,%esp
	}
}
  8036d9:	90                   	nop
  8036da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8036dd:	c9                   	leave  
  8036de:	c3                   	ret    

008036df <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8036df:	55                   	push   %ebp
  8036e0:	89 e5                	mov    %esp,%ebp
  8036e2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8036e5:	a1 30 50 80 00       	mov    0x805030,%eax
  8036ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8036ed:	a1 34 50 80 00       	mov    0x805034,%eax
  8036f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036f5:	73 1b                	jae    803712 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8036f7:	a1 34 50 80 00       	mov    0x805034,%eax
  8036fc:	83 ec 04             	sub    $0x4,%esp
  8036ff:	ff 75 08             	pushl  0x8(%ebp)
  803702:	6a 00                	push   $0x0
  803704:	50                   	push   %eax
  803705:	e8 b2 fb ff ff       	call   8032bc <merging>
  80370a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80370d:	e9 8b 00 00 00       	jmp    80379d <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803712:	a1 30 50 80 00       	mov    0x805030,%eax
  803717:	3b 45 08             	cmp    0x8(%ebp),%eax
  80371a:	76 18                	jbe    803734 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80371c:	a1 30 50 80 00       	mov    0x805030,%eax
  803721:	83 ec 04             	sub    $0x4,%esp
  803724:	ff 75 08             	pushl  0x8(%ebp)
  803727:	50                   	push   %eax
  803728:	6a 00                	push   $0x0
  80372a:	e8 8d fb ff ff       	call   8032bc <merging>
  80372f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803732:	eb 69                	jmp    80379d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803734:	a1 30 50 80 00       	mov    0x805030,%eax
  803739:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80373c:	eb 39                	jmp    803777 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80373e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803741:	3b 45 08             	cmp    0x8(%ebp),%eax
  803744:	73 29                	jae    80376f <free_block+0x90>
  803746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803749:	8b 00                	mov    (%eax),%eax
  80374b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80374e:	76 1f                	jbe    80376f <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803753:	8b 00                	mov    (%eax),%eax
  803755:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803758:	83 ec 04             	sub    $0x4,%esp
  80375b:	ff 75 08             	pushl  0x8(%ebp)
  80375e:	ff 75 f0             	pushl  -0x10(%ebp)
  803761:	ff 75 f4             	pushl  -0xc(%ebp)
  803764:	e8 53 fb ff ff       	call   8032bc <merging>
  803769:	83 c4 10             	add    $0x10,%esp
			break;
  80376c:	90                   	nop
		}
	}
}
  80376d:	eb 2e                	jmp    80379d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80376f:	a1 38 50 80 00       	mov    0x805038,%eax
  803774:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803777:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80377b:	74 07                	je     803784 <free_block+0xa5>
  80377d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803780:	8b 00                	mov    (%eax),%eax
  803782:	eb 05                	jmp    803789 <free_block+0xaa>
  803784:	b8 00 00 00 00       	mov    $0x0,%eax
  803789:	a3 38 50 80 00       	mov    %eax,0x805038
  80378e:	a1 38 50 80 00       	mov    0x805038,%eax
  803793:	85 c0                	test   %eax,%eax
  803795:	75 a7                	jne    80373e <free_block+0x5f>
  803797:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80379b:	75 a1                	jne    80373e <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80379d:	90                   	nop
  80379e:	c9                   	leave  
  80379f:	c3                   	ret    

008037a0 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8037a0:	55                   	push   %ebp
  8037a1:	89 e5                	mov    %esp,%ebp
  8037a3:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8037a6:	ff 75 08             	pushl  0x8(%ebp)
  8037a9:	e8 ed ec ff ff       	call   80249b <get_block_size>
  8037ae:	83 c4 04             	add    $0x4,%esp
  8037b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8037b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8037bb:	eb 17                	jmp    8037d4 <copy_data+0x34>
  8037bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8037c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037c3:	01 c2                	add    %eax,%edx
  8037c5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8037c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cb:	01 c8                	add    %ecx,%eax
  8037cd:	8a 00                	mov    (%eax),%al
  8037cf:	88 02                	mov    %al,(%edx)
  8037d1:	ff 45 fc             	incl   -0x4(%ebp)
  8037d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8037da:	72 e1                	jb     8037bd <copy_data+0x1d>
}
  8037dc:	90                   	nop
  8037dd:	c9                   	leave  
  8037de:	c3                   	ret    

008037df <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8037df:	55                   	push   %ebp
  8037e0:	89 e5                	mov    %esp,%ebp
  8037e2:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8037e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037e9:	75 23                	jne    80380e <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8037eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037ef:	74 13                	je     803804 <realloc_block_FF+0x25>
  8037f1:	83 ec 0c             	sub    $0xc,%esp
  8037f4:	ff 75 0c             	pushl  0xc(%ebp)
  8037f7:	e8 1f f0 ff ff       	call   80281b <alloc_block_FF>
  8037fc:	83 c4 10             	add    $0x10,%esp
  8037ff:	e9 f4 06 00 00       	jmp    803ef8 <realloc_block_FF+0x719>
		return NULL;
  803804:	b8 00 00 00 00       	mov    $0x0,%eax
  803809:	e9 ea 06 00 00       	jmp    803ef8 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80380e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803812:	75 18                	jne    80382c <realloc_block_FF+0x4d>
	{
		free_block(va);
  803814:	83 ec 0c             	sub    $0xc,%esp
  803817:	ff 75 08             	pushl  0x8(%ebp)
  80381a:	e8 c0 fe ff ff       	call   8036df <free_block>
  80381f:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803822:	b8 00 00 00 00       	mov    $0x0,%eax
  803827:	e9 cc 06 00 00       	jmp    803ef8 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80382c:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803830:	77 07                	ja     803839 <realloc_block_FF+0x5a>
  803832:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80383c:	83 e0 01             	and    $0x1,%eax
  80383f:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803842:	8b 45 0c             	mov    0xc(%ebp),%eax
  803845:	83 c0 08             	add    $0x8,%eax
  803848:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80384b:	83 ec 0c             	sub    $0xc,%esp
  80384e:	ff 75 08             	pushl  0x8(%ebp)
  803851:	e8 45 ec ff ff       	call   80249b <get_block_size>
  803856:	83 c4 10             	add    $0x10,%esp
  803859:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80385c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385f:	83 e8 08             	sub    $0x8,%eax
  803862:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803865:	8b 45 08             	mov    0x8(%ebp),%eax
  803868:	83 e8 04             	sub    $0x4,%eax
  80386b:	8b 00                	mov    (%eax),%eax
  80386d:	83 e0 fe             	and    $0xfffffffe,%eax
  803870:	89 c2                	mov    %eax,%edx
  803872:	8b 45 08             	mov    0x8(%ebp),%eax
  803875:	01 d0                	add    %edx,%eax
  803877:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80387a:	83 ec 0c             	sub    $0xc,%esp
  80387d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803880:	e8 16 ec ff ff       	call   80249b <get_block_size>
  803885:	83 c4 10             	add    $0x10,%esp
  803888:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80388b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80388e:	83 e8 08             	sub    $0x8,%eax
  803891:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803894:	8b 45 0c             	mov    0xc(%ebp),%eax
  803897:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80389a:	75 08                	jne    8038a4 <realloc_block_FF+0xc5>
	{
		 return va;
  80389c:	8b 45 08             	mov    0x8(%ebp),%eax
  80389f:	e9 54 06 00 00       	jmp    803ef8 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8038a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038a7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038aa:	0f 83 e5 03 00 00    	jae    803c95 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8038b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b3:	2b 45 0c             	sub    0xc(%ebp),%eax
  8038b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8038b9:	83 ec 0c             	sub    $0xc,%esp
  8038bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038bf:	e8 f0 eb ff ff       	call   8024b4 <is_free_block>
  8038c4:	83 c4 10             	add    $0x10,%esp
  8038c7:	84 c0                	test   %al,%al
  8038c9:	0f 84 3b 01 00 00    	je     803a0a <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8038cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038d5:	01 d0                	add    %edx,%eax
  8038d7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8038da:	83 ec 04             	sub    $0x4,%esp
  8038dd:	6a 01                	push   $0x1
  8038df:	ff 75 f0             	pushl  -0x10(%ebp)
  8038e2:	ff 75 08             	pushl  0x8(%ebp)
  8038e5:	e8 02 ef ff ff       	call   8027ec <set_block_data>
  8038ea:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8038ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f0:	83 e8 04             	sub    $0x4,%eax
  8038f3:	8b 00                	mov    (%eax),%eax
  8038f5:	83 e0 fe             	and    $0xfffffffe,%eax
  8038f8:	89 c2                	mov    %eax,%edx
  8038fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fd:	01 d0                	add    %edx,%eax
  8038ff:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803902:	83 ec 04             	sub    $0x4,%esp
  803905:	6a 00                	push   $0x0
  803907:	ff 75 cc             	pushl  -0x34(%ebp)
  80390a:	ff 75 c8             	pushl  -0x38(%ebp)
  80390d:	e8 da ee ff ff       	call   8027ec <set_block_data>
  803912:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803919:	74 06                	je     803921 <realloc_block_FF+0x142>
  80391b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80391f:	75 17                	jne    803938 <realloc_block_FF+0x159>
  803921:	83 ec 04             	sub    $0x4,%esp
  803924:	68 0c 4b 80 00       	push   $0x804b0c
  803929:	68 f6 01 00 00       	push   $0x1f6
  80392e:	68 99 4a 80 00       	push   $0x804a99
  803933:	e8 13 ce ff ff       	call   80074b <_panic>
  803938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393b:	8b 10                	mov    (%eax),%edx
  80393d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803940:	89 10                	mov    %edx,(%eax)
  803942:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803945:	8b 00                	mov    (%eax),%eax
  803947:	85 c0                	test   %eax,%eax
  803949:	74 0b                	je     803956 <realloc_block_FF+0x177>
  80394b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394e:	8b 00                	mov    (%eax),%eax
  803950:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803953:	89 50 04             	mov    %edx,0x4(%eax)
  803956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803959:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80395c:	89 10                	mov    %edx,(%eax)
  80395e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803961:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803964:	89 50 04             	mov    %edx,0x4(%eax)
  803967:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80396a:	8b 00                	mov    (%eax),%eax
  80396c:	85 c0                	test   %eax,%eax
  80396e:	75 08                	jne    803978 <realloc_block_FF+0x199>
  803970:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803973:	a3 34 50 80 00       	mov    %eax,0x805034
  803978:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80397d:	40                   	inc    %eax
  80397e:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803987:	75 17                	jne    8039a0 <realloc_block_FF+0x1c1>
  803989:	83 ec 04             	sub    $0x4,%esp
  80398c:	68 7b 4a 80 00       	push   $0x804a7b
  803991:	68 f7 01 00 00       	push   $0x1f7
  803996:	68 99 4a 80 00       	push   $0x804a99
  80399b:	e8 ab cd ff ff       	call   80074b <_panic>
  8039a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a3:	8b 00                	mov    (%eax),%eax
  8039a5:	85 c0                	test   %eax,%eax
  8039a7:	74 10                	je     8039b9 <realloc_block_FF+0x1da>
  8039a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ac:	8b 00                	mov    (%eax),%eax
  8039ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039b1:	8b 52 04             	mov    0x4(%edx),%edx
  8039b4:	89 50 04             	mov    %edx,0x4(%eax)
  8039b7:	eb 0b                	jmp    8039c4 <realloc_block_FF+0x1e5>
  8039b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bc:	8b 40 04             	mov    0x4(%eax),%eax
  8039bf:	a3 34 50 80 00       	mov    %eax,0x805034
  8039c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c7:	8b 40 04             	mov    0x4(%eax),%eax
  8039ca:	85 c0                	test   %eax,%eax
  8039cc:	74 0f                	je     8039dd <realloc_block_FF+0x1fe>
  8039ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d1:	8b 40 04             	mov    0x4(%eax),%eax
  8039d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039d7:	8b 12                	mov    (%edx),%edx
  8039d9:	89 10                	mov    %edx,(%eax)
  8039db:	eb 0a                	jmp    8039e7 <realloc_block_FF+0x208>
  8039dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e0:	8b 00                	mov    (%eax),%eax
  8039e2:	a3 30 50 80 00       	mov    %eax,0x805030
  8039e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039fa:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039ff:	48                   	dec    %eax
  803a00:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a05:	e9 83 02 00 00       	jmp    803c8d <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803a0a:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803a0e:	0f 86 69 02 00 00    	jbe    803c7d <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803a14:	83 ec 04             	sub    $0x4,%esp
  803a17:	6a 01                	push   $0x1
  803a19:	ff 75 f0             	pushl  -0x10(%ebp)
  803a1c:	ff 75 08             	pushl  0x8(%ebp)
  803a1f:	e8 c8 ed ff ff       	call   8027ec <set_block_data>
  803a24:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a27:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2a:	83 e8 04             	sub    $0x4,%eax
  803a2d:	8b 00                	mov    (%eax),%eax
  803a2f:	83 e0 fe             	and    $0xfffffffe,%eax
  803a32:	89 c2                	mov    %eax,%edx
  803a34:	8b 45 08             	mov    0x8(%ebp),%eax
  803a37:	01 d0                	add    %edx,%eax
  803a39:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803a3c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a41:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803a44:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803a48:	75 68                	jne    803ab2 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a4a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a4e:	75 17                	jne    803a67 <realloc_block_FF+0x288>
  803a50:	83 ec 04             	sub    $0x4,%esp
  803a53:	68 b4 4a 80 00       	push   $0x804ab4
  803a58:	68 06 02 00 00       	push   $0x206
  803a5d:	68 99 4a 80 00       	push   $0x804a99
  803a62:	e8 e4 cc ff ff       	call   80074b <_panic>
  803a67:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a70:	89 10                	mov    %edx,(%eax)
  803a72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a75:	8b 00                	mov    (%eax),%eax
  803a77:	85 c0                	test   %eax,%eax
  803a79:	74 0d                	je     803a88 <realloc_block_FF+0x2a9>
  803a7b:	a1 30 50 80 00       	mov    0x805030,%eax
  803a80:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a83:	89 50 04             	mov    %edx,0x4(%eax)
  803a86:	eb 08                	jmp    803a90 <realloc_block_FF+0x2b1>
  803a88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a8b:	a3 34 50 80 00       	mov    %eax,0x805034
  803a90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a93:	a3 30 50 80 00       	mov    %eax,0x805030
  803a98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aa2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803aa7:	40                   	inc    %eax
  803aa8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803aad:	e9 b0 01 00 00       	jmp    803c62 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803ab2:	a1 30 50 80 00       	mov    0x805030,%eax
  803ab7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803aba:	76 68                	jbe    803b24 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803abc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ac0:	75 17                	jne    803ad9 <realloc_block_FF+0x2fa>
  803ac2:	83 ec 04             	sub    $0x4,%esp
  803ac5:	68 b4 4a 80 00       	push   $0x804ab4
  803aca:	68 0b 02 00 00       	push   $0x20b
  803acf:	68 99 4a 80 00       	push   $0x804a99
  803ad4:	e8 72 cc ff ff       	call   80074b <_panic>
  803ad9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803adf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae2:	89 10                	mov    %edx,(%eax)
  803ae4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae7:	8b 00                	mov    (%eax),%eax
  803ae9:	85 c0                	test   %eax,%eax
  803aeb:	74 0d                	je     803afa <realloc_block_FF+0x31b>
  803aed:	a1 30 50 80 00       	mov    0x805030,%eax
  803af2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803af5:	89 50 04             	mov    %edx,0x4(%eax)
  803af8:	eb 08                	jmp    803b02 <realloc_block_FF+0x323>
  803afa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803afd:	a3 34 50 80 00       	mov    %eax,0x805034
  803b02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b05:	a3 30 50 80 00       	mov    %eax,0x805030
  803b0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b14:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b19:	40                   	inc    %eax
  803b1a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b1f:	e9 3e 01 00 00       	jmp    803c62 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803b24:	a1 30 50 80 00       	mov    0x805030,%eax
  803b29:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b2c:	73 68                	jae    803b96 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b2e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b32:	75 17                	jne    803b4b <realloc_block_FF+0x36c>
  803b34:	83 ec 04             	sub    $0x4,%esp
  803b37:	68 e8 4a 80 00       	push   $0x804ae8
  803b3c:	68 10 02 00 00       	push   $0x210
  803b41:	68 99 4a 80 00       	push   $0x804a99
  803b46:	e8 00 cc ff ff       	call   80074b <_panic>
  803b4b:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803b51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b54:	89 50 04             	mov    %edx,0x4(%eax)
  803b57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b5a:	8b 40 04             	mov    0x4(%eax),%eax
  803b5d:	85 c0                	test   %eax,%eax
  803b5f:	74 0c                	je     803b6d <realloc_block_FF+0x38e>
  803b61:	a1 34 50 80 00       	mov    0x805034,%eax
  803b66:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b69:	89 10                	mov    %edx,(%eax)
  803b6b:	eb 08                	jmp    803b75 <realloc_block_FF+0x396>
  803b6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b70:	a3 30 50 80 00       	mov    %eax,0x805030
  803b75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b78:	a3 34 50 80 00       	mov    %eax,0x805034
  803b7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b86:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b8b:	40                   	inc    %eax
  803b8c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b91:	e9 cc 00 00 00       	jmp    803c62 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803b96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803b9d:	a1 30 50 80 00       	mov    0x805030,%eax
  803ba2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ba5:	e9 8a 00 00 00       	jmp    803c34 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bad:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bb0:	73 7a                	jae    803c2c <realloc_block_FF+0x44d>
  803bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb5:	8b 00                	mov    (%eax),%eax
  803bb7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bba:	73 70                	jae    803c2c <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803bbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bc0:	74 06                	je     803bc8 <realloc_block_FF+0x3e9>
  803bc2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bc6:	75 17                	jne    803bdf <realloc_block_FF+0x400>
  803bc8:	83 ec 04             	sub    $0x4,%esp
  803bcb:	68 0c 4b 80 00       	push   $0x804b0c
  803bd0:	68 1a 02 00 00       	push   $0x21a
  803bd5:	68 99 4a 80 00       	push   $0x804a99
  803bda:	e8 6c cb ff ff       	call   80074b <_panic>
  803bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be2:	8b 10                	mov    (%eax),%edx
  803be4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be7:	89 10                	mov    %edx,(%eax)
  803be9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bec:	8b 00                	mov    (%eax),%eax
  803bee:	85 c0                	test   %eax,%eax
  803bf0:	74 0b                	je     803bfd <realloc_block_FF+0x41e>
  803bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf5:	8b 00                	mov    (%eax),%eax
  803bf7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bfa:	89 50 04             	mov    %edx,0x4(%eax)
  803bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c00:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c03:	89 10                	mov    %edx,(%eax)
  803c05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c0b:	89 50 04             	mov    %edx,0x4(%eax)
  803c0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c11:	8b 00                	mov    (%eax),%eax
  803c13:	85 c0                	test   %eax,%eax
  803c15:	75 08                	jne    803c1f <realloc_block_FF+0x440>
  803c17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c1a:	a3 34 50 80 00       	mov    %eax,0x805034
  803c1f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c24:	40                   	inc    %eax
  803c25:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803c2a:	eb 36                	jmp    803c62 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803c2c:	a1 38 50 80 00       	mov    0x805038,%eax
  803c31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c38:	74 07                	je     803c41 <realloc_block_FF+0x462>
  803c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c3d:	8b 00                	mov    (%eax),%eax
  803c3f:	eb 05                	jmp    803c46 <realloc_block_FF+0x467>
  803c41:	b8 00 00 00 00       	mov    $0x0,%eax
  803c46:	a3 38 50 80 00       	mov    %eax,0x805038
  803c4b:	a1 38 50 80 00       	mov    0x805038,%eax
  803c50:	85 c0                	test   %eax,%eax
  803c52:	0f 85 52 ff ff ff    	jne    803baa <realloc_block_FF+0x3cb>
  803c58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c5c:	0f 85 48 ff ff ff    	jne    803baa <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803c62:	83 ec 04             	sub    $0x4,%esp
  803c65:	6a 00                	push   $0x0
  803c67:	ff 75 d8             	pushl  -0x28(%ebp)
  803c6a:	ff 75 d4             	pushl  -0x2c(%ebp)
  803c6d:	e8 7a eb ff ff       	call   8027ec <set_block_data>
  803c72:	83 c4 10             	add    $0x10,%esp
				return va;
  803c75:	8b 45 08             	mov    0x8(%ebp),%eax
  803c78:	e9 7b 02 00 00       	jmp    803ef8 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803c7d:	83 ec 0c             	sub    $0xc,%esp
  803c80:	68 89 4b 80 00       	push   $0x804b89
  803c85:	e8 7e cd ff ff       	call   800a08 <cprintf>
  803c8a:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c90:	e9 63 02 00 00       	jmp    803ef8 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c98:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c9b:	0f 86 4d 02 00 00    	jbe    803eee <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803ca1:	83 ec 0c             	sub    $0xc,%esp
  803ca4:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ca7:	e8 08 e8 ff ff       	call   8024b4 <is_free_block>
  803cac:	83 c4 10             	add    $0x10,%esp
  803caf:	84 c0                	test   %al,%al
  803cb1:	0f 84 37 02 00 00    	je     803eee <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cba:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803cbd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803cc0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803cc3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803cc6:	76 38                	jbe    803d00 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803cc8:	83 ec 0c             	sub    $0xc,%esp
  803ccb:	ff 75 08             	pushl  0x8(%ebp)
  803cce:	e8 0c fa ff ff       	call   8036df <free_block>
  803cd3:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803cd6:	83 ec 0c             	sub    $0xc,%esp
  803cd9:	ff 75 0c             	pushl  0xc(%ebp)
  803cdc:	e8 3a eb ff ff       	call   80281b <alloc_block_FF>
  803ce1:	83 c4 10             	add    $0x10,%esp
  803ce4:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803ce7:	83 ec 08             	sub    $0x8,%esp
  803cea:	ff 75 c0             	pushl  -0x40(%ebp)
  803ced:	ff 75 08             	pushl  0x8(%ebp)
  803cf0:	e8 ab fa ff ff       	call   8037a0 <copy_data>
  803cf5:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803cf8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803cfb:	e9 f8 01 00 00       	jmp    803ef8 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d03:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803d06:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803d09:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803d0d:	0f 87 a0 00 00 00    	ja     803db3 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803d13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d17:	75 17                	jne    803d30 <realloc_block_FF+0x551>
  803d19:	83 ec 04             	sub    $0x4,%esp
  803d1c:	68 7b 4a 80 00       	push   $0x804a7b
  803d21:	68 38 02 00 00       	push   $0x238
  803d26:	68 99 4a 80 00       	push   $0x804a99
  803d2b:	e8 1b ca ff ff       	call   80074b <_panic>
  803d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d33:	8b 00                	mov    (%eax),%eax
  803d35:	85 c0                	test   %eax,%eax
  803d37:	74 10                	je     803d49 <realloc_block_FF+0x56a>
  803d39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3c:	8b 00                	mov    (%eax),%eax
  803d3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d41:	8b 52 04             	mov    0x4(%edx),%edx
  803d44:	89 50 04             	mov    %edx,0x4(%eax)
  803d47:	eb 0b                	jmp    803d54 <realloc_block_FF+0x575>
  803d49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4c:	8b 40 04             	mov    0x4(%eax),%eax
  803d4f:	a3 34 50 80 00       	mov    %eax,0x805034
  803d54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d57:	8b 40 04             	mov    0x4(%eax),%eax
  803d5a:	85 c0                	test   %eax,%eax
  803d5c:	74 0f                	je     803d6d <realloc_block_FF+0x58e>
  803d5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d61:	8b 40 04             	mov    0x4(%eax),%eax
  803d64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d67:	8b 12                	mov    (%edx),%edx
  803d69:	89 10                	mov    %edx,(%eax)
  803d6b:	eb 0a                	jmp    803d77 <realloc_block_FF+0x598>
  803d6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d70:	8b 00                	mov    (%eax),%eax
  803d72:	a3 30 50 80 00       	mov    %eax,0x805030
  803d77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d8a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d8f:	48                   	dec    %eax
  803d90:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803d95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d9b:	01 d0                	add    %edx,%eax
  803d9d:	83 ec 04             	sub    $0x4,%esp
  803da0:	6a 01                	push   $0x1
  803da2:	50                   	push   %eax
  803da3:	ff 75 08             	pushl  0x8(%ebp)
  803da6:	e8 41 ea ff ff       	call   8027ec <set_block_data>
  803dab:	83 c4 10             	add    $0x10,%esp
  803dae:	e9 36 01 00 00       	jmp    803ee9 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803db3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803db6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803db9:	01 d0                	add    %edx,%eax
  803dbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803dbe:	83 ec 04             	sub    $0x4,%esp
  803dc1:	6a 01                	push   $0x1
  803dc3:	ff 75 f0             	pushl  -0x10(%ebp)
  803dc6:	ff 75 08             	pushl  0x8(%ebp)
  803dc9:	e8 1e ea ff ff       	call   8027ec <set_block_data>
  803dce:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd4:	83 e8 04             	sub    $0x4,%eax
  803dd7:	8b 00                	mov    (%eax),%eax
  803dd9:	83 e0 fe             	and    $0xfffffffe,%eax
  803ddc:	89 c2                	mov    %eax,%edx
  803dde:	8b 45 08             	mov    0x8(%ebp),%eax
  803de1:	01 d0                	add    %edx,%eax
  803de3:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803de6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803dea:	74 06                	je     803df2 <realloc_block_FF+0x613>
  803dec:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803df0:	75 17                	jne    803e09 <realloc_block_FF+0x62a>
  803df2:	83 ec 04             	sub    $0x4,%esp
  803df5:	68 0c 4b 80 00       	push   $0x804b0c
  803dfa:	68 44 02 00 00       	push   $0x244
  803dff:	68 99 4a 80 00       	push   $0x804a99
  803e04:	e8 42 c9 ff ff       	call   80074b <_panic>
  803e09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e0c:	8b 10                	mov    (%eax),%edx
  803e0e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e11:	89 10                	mov    %edx,(%eax)
  803e13:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e16:	8b 00                	mov    (%eax),%eax
  803e18:	85 c0                	test   %eax,%eax
  803e1a:	74 0b                	je     803e27 <realloc_block_FF+0x648>
  803e1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e1f:	8b 00                	mov    (%eax),%eax
  803e21:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e24:	89 50 04             	mov    %edx,0x4(%eax)
  803e27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e2a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e2d:	89 10                	mov    %edx,(%eax)
  803e2f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e35:	89 50 04             	mov    %edx,0x4(%eax)
  803e38:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e3b:	8b 00                	mov    (%eax),%eax
  803e3d:	85 c0                	test   %eax,%eax
  803e3f:	75 08                	jne    803e49 <realloc_block_FF+0x66a>
  803e41:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e44:	a3 34 50 80 00       	mov    %eax,0x805034
  803e49:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e4e:	40                   	inc    %eax
  803e4f:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803e54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e58:	75 17                	jne    803e71 <realloc_block_FF+0x692>
  803e5a:	83 ec 04             	sub    $0x4,%esp
  803e5d:	68 7b 4a 80 00       	push   $0x804a7b
  803e62:	68 45 02 00 00       	push   $0x245
  803e67:	68 99 4a 80 00       	push   $0x804a99
  803e6c:	e8 da c8 ff ff       	call   80074b <_panic>
  803e71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e74:	8b 00                	mov    (%eax),%eax
  803e76:	85 c0                	test   %eax,%eax
  803e78:	74 10                	je     803e8a <realloc_block_FF+0x6ab>
  803e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e7d:	8b 00                	mov    (%eax),%eax
  803e7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e82:	8b 52 04             	mov    0x4(%edx),%edx
  803e85:	89 50 04             	mov    %edx,0x4(%eax)
  803e88:	eb 0b                	jmp    803e95 <realloc_block_FF+0x6b6>
  803e8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e8d:	8b 40 04             	mov    0x4(%eax),%eax
  803e90:	a3 34 50 80 00       	mov    %eax,0x805034
  803e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e98:	8b 40 04             	mov    0x4(%eax),%eax
  803e9b:	85 c0                	test   %eax,%eax
  803e9d:	74 0f                	je     803eae <realloc_block_FF+0x6cf>
  803e9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea2:	8b 40 04             	mov    0x4(%eax),%eax
  803ea5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ea8:	8b 12                	mov    (%edx),%edx
  803eaa:	89 10                	mov    %edx,(%eax)
  803eac:	eb 0a                	jmp    803eb8 <realloc_block_FF+0x6d9>
  803eae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb1:	8b 00                	mov    (%eax),%eax
  803eb3:	a3 30 50 80 00       	mov    %eax,0x805030
  803eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ebb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ecb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ed0:	48                   	dec    %eax
  803ed1:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803ed6:	83 ec 04             	sub    $0x4,%esp
  803ed9:	6a 00                	push   $0x0
  803edb:	ff 75 bc             	pushl  -0x44(%ebp)
  803ede:	ff 75 b8             	pushl  -0x48(%ebp)
  803ee1:	e8 06 e9 ff ff       	call   8027ec <set_block_data>
  803ee6:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  803eec:	eb 0a                	jmp    803ef8 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803eee:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803ef5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803ef8:	c9                   	leave  
  803ef9:	c3                   	ret    

00803efa <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803efa:	55                   	push   %ebp
  803efb:	89 e5                	mov    %esp,%ebp
  803efd:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803f00:	83 ec 04             	sub    $0x4,%esp
  803f03:	68 90 4b 80 00       	push   $0x804b90
  803f08:	68 58 02 00 00       	push   $0x258
  803f0d:	68 99 4a 80 00       	push   $0x804a99
  803f12:	e8 34 c8 ff ff       	call   80074b <_panic>

00803f17 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803f17:	55                   	push   %ebp
  803f18:	89 e5                	mov    %esp,%ebp
  803f1a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803f1d:	83 ec 04             	sub    $0x4,%esp
  803f20:	68 b8 4b 80 00       	push   $0x804bb8
  803f25:	68 61 02 00 00       	push   $0x261
  803f2a:	68 99 4a 80 00       	push   $0x804a99
  803f2f:	e8 17 c8 ff ff       	call   80074b <_panic>

00803f34 <__udivdi3>:
  803f34:	55                   	push   %ebp
  803f35:	57                   	push   %edi
  803f36:	56                   	push   %esi
  803f37:	53                   	push   %ebx
  803f38:	83 ec 1c             	sub    $0x1c,%esp
  803f3b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f3f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f47:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f4b:	89 ca                	mov    %ecx,%edx
  803f4d:	89 f8                	mov    %edi,%eax
  803f4f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f53:	85 f6                	test   %esi,%esi
  803f55:	75 2d                	jne    803f84 <__udivdi3+0x50>
  803f57:	39 cf                	cmp    %ecx,%edi
  803f59:	77 65                	ja     803fc0 <__udivdi3+0x8c>
  803f5b:	89 fd                	mov    %edi,%ebp
  803f5d:	85 ff                	test   %edi,%edi
  803f5f:	75 0b                	jne    803f6c <__udivdi3+0x38>
  803f61:	b8 01 00 00 00       	mov    $0x1,%eax
  803f66:	31 d2                	xor    %edx,%edx
  803f68:	f7 f7                	div    %edi
  803f6a:	89 c5                	mov    %eax,%ebp
  803f6c:	31 d2                	xor    %edx,%edx
  803f6e:	89 c8                	mov    %ecx,%eax
  803f70:	f7 f5                	div    %ebp
  803f72:	89 c1                	mov    %eax,%ecx
  803f74:	89 d8                	mov    %ebx,%eax
  803f76:	f7 f5                	div    %ebp
  803f78:	89 cf                	mov    %ecx,%edi
  803f7a:	89 fa                	mov    %edi,%edx
  803f7c:	83 c4 1c             	add    $0x1c,%esp
  803f7f:	5b                   	pop    %ebx
  803f80:	5e                   	pop    %esi
  803f81:	5f                   	pop    %edi
  803f82:	5d                   	pop    %ebp
  803f83:	c3                   	ret    
  803f84:	39 ce                	cmp    %ecx,%esi
  803f86:	77 28                	ja     803fb0 <__udivdi3+0x7c>
  803f88:	0f bd fe             	bsr    %esi,%edi
  803f8b:	83 f7 1f             	xor    $0x1f,%edi
  803f8e:	75 40                	jne    803fd0 <__udivdi3+0x9c>
  803f90:	39 ce                	cmp    %ecx,%esi
  803f92:	72 0a                	jb     803f9e <__udivdi3+0x6a>
  803f94:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f98:	0f 87 9e 00 00 00    	ja     80403c <__udivdi3+0x108>
  803f9e:	b8 01 00 00 00       	mov    $0x1,%eax
  803fa3:	89 fa                	mov    %edi,%edx
  803fa5:	83 c4 1c             	add    $0x1c,%esp
  803fa8:	5b                   	pop    %ebx
  803fa9:	5e                   	pop    %esi
  803faa:	5f                   	pop    %edi
  803fab:	5d                   	pop    %ebp
  803fac:	c3                   	ret    
  803fad:	8d 76 00             	lea    0x0(%esi),%esi
  803fb0:	31 ff                	xor    %edi,%edi
  803fb2:	31 c0                	xor    %eax,%eax
  803fb4:	89 fa                	mov    %edi,%edx
  803fb6:	83 c4 1c             	add    $0x1c,%esp
  803fb9:	5b                   	pop    %ebx
  803fba:	5e                   	pop    %esi
  803fbb:	5f                   	pop    %edi
  803fbc:	5d                   	pop    %ebp
  803fbd:	c3                   	ret    
  803fbe:	66 90                	xchg   %ax,%ax
  803fc0:	89 d8                	mov    %ebx,%eax
  803fc2:	f7 f7                	div    %edi
  803fc4:	31 ff                	xor    %edi,%edi
  803fc6:	89 fa                	mov    %edi,%edx
  803fc8:	83 c4 1c             	add    $0x1c,%esp
  803fcb:	5b                   	pop    %ebx
  803fcc:	5e                   	pop    %esi
  803fcd:	5f                   	pop    %edi
  803fce:	5d                   	pop    %ebp
  803fcf:	c3                   	ret    
  803fd0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803fd5:	89 eb                	mov    %ebp,%ebx
  803fd7:	29 fb                	sub    %edi,%ebx
  803fd9:	89 f9                	mov    %edi,%ecx
  803fdb:	d3 e6                	shl    %cl,%esi
  803fdd:	89 c5                	mov    %eax,%ebp
  803fdf:	88 d9                	mov    %bl,%cl
  803fe1:	d3 ed                	shr    %cl,%ebp
  803fe3:	89 e9                	mov    %ebp,%ecx
  803fe5:	09 f1                	or     %esi,%ecx
  803fe7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803feb:	89 f9                	mov    %edi,%ecx
  803fed:	d3 e0                	shl    %cl,%eax
  803fef:	89 c5                	mov    %eax,%ebp
  803ff1:	89 d6                	mov    %edx,%esi
  803ff3:	88 d9                	mov    %bl,%cl
  803ff5:	d3 ee                	shr    %cl,%esi
  803ff7:	89 f9                	mov    %edi,%ecx
  803ff9:	d3 e2                	shl    %cl,%edx
  803ffb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fff:	88 d9                	mov    %bl,%cl
  804001:	d3 e8                	shr    %cl,%eax
  804003:	09 c2                	or     %eax,%edx
  804005:	89 d0                	mov    %edx,%eax
  804007:	89 f2                	mov    %esi,%edx
  804009:	f7 74 24 0c          	divl   0xc(%esp)
  80400d:	89 d6                	mov    %edx,%esi
  80400f:	89 c3                	mov    %eax,%ebx
  804011:	f7 e5                	mul    %ebp
  804013:	39 d6                	cmp    %edx,%esi
  804015:	72 19                	jb     804030 <__udivdi3+0xfc>
  804017:	74 0b                	je     804024 <__udivdi3+0xf0>
  804019:	89 d8                	mov    %ebx,%eax
  80401b:	31 ff                	xor    %edi,%edi
  80401d:	e9 58 ff ff ff       	jmp    803f7a <__udivdi3+0x46>
  804022:	66 90                	xchg   %ax,%ax
  804024:	8b 54 24 08          	mov    0x8(%esp),%edx
  804028:	89 f9                	mov    %edi,%ecx
  80402a:	d3 e2                	shl    %cl,%edx
  80402c:	39 c2                	cmp    %eax,%edx
  80402e:	73 e9                	jae    804019 <__udivdi3+0xe5>
  804030:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804033:	31 ff                	xor    %edi,%edi
  804035:	e9 40 ff ff ff       	jmp    803f7a <__udivdi3+0x46>
  80403a:	66 90                	xchg   %ax,%ax
  80403c:	31 c0                	xor    %eax,%eax
  80403e:	e9 37 ff ff ff       	jmp    803f7a <__udivdi3+0x46>
  804043:	90                   	nop

00804044 <__umoddi3>:
  804044:	55                   	push   %ebp
  804045:	57                   	push   %edi
  804046:	56                   	push   %esi
  804047:	53                   	push   %ebx
  804048:	83 ec 1c             	sub    $0x1c,%esp
  80404b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80404f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804053:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804057:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80405b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80405f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804063:	89 f3                	mov    %esi,%ebx
  804065:	89 fa                	mov    %edi,%edx
  804067:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80406b:	89 34 24             	mov    %esi,(%esp)
  80406e:	85 c0                	test   %eax,%eax
  804070:	75 1a                	jne    80408c <__umoddi3+0x48>
  804072:	39 f7                	cmp    %esi,%edi
  804074:	0f 86 a2 00 00 00    	jbe    80411c <__umoddi3+0xd8>
  80407a:	89 c8                	mov    %ecx,%eax
  80407c:	89 f2                	mov    %esi,%edx
  80407e:	f7 f7                	div    %edi
  804080:	89 d0                	mov    %edx,%eax
  804082:	31 d2                	xor    %edx,%edx
  804084:	83 c4 1c             	add    $0x1c,%esp
  804087:	5b                   	pop    %ebx
  804088:	5e                   	pop    %esi
  804089:	5f                   	pop    %edi
  80408a:	5d                   	pop    %ebp
  80408b:	c3                   	ret    
  80408c:	39 f0                	cmp    %esi,%eax
  80408e:	0f 87 ac 00 00 00    	ja     804140 <__umoddi3+0xfc>
  804094:	0f bd e8             	bsr    %eax,%ebp
  804097:	83 f5 1f             	xor    $0x1f,%ebp
  80409a:	0f 84 ac 00 00 00    	je     80414c <__umoddi3+0x108>
  8040a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8040a5:	29 ef                	sub    %ebp,%edi
  8040a7:	89 fe                	mov    %edi,%esi
  8040a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040ad:	89 e9                	mov    %ebp,%ecx
  8040af:	d3 e0                	shl    %cl,%eax
  8040b1:	89 d7                	mov    %edx,%edi
  8040b3:	89 f1                	mov    %esi,%ecx
  8040b5:	d3 ef                	shr    %cl,%edi
  8040b7:	09 c7                	or     %eax,%edi
  8040b9:	89 e9                	mov    %ebp,%ecx
  8040bb:	d3 e2                	shl    %cl,%edx
  8040bd:	89 14 24             	mov    %edx,(%esp)
  8040c0:	89 d8                	mov    %ebx,%eax
  8040c2:	d3 e0                	shl    %cl,%eax
  8040c4:	89 c2                	mov    %eax,%edx
  8040c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040ca:	d3 e0                	shl    %cl,%eax
  8040cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040d4:	89 f1                	mov    %esi,%ecx
  8040d6:	d3 e8                	shr    %cl,%eax
  8040d8:	09 d0                	or     %edx,%eax
  8040da:	d3 eb                	shr    %cl,%ebx
  8040dc:	89 da                	mov    %ebx,%edx
  8040de:	f7 f7                	div    %edi
  8040e0:	89 d3                	mov    %edx,%ebx
  8040e2:	f7 24 24             	mull   (%esp)
  8040e5:	89 c6                	mov    %eax,%esi
  8040e7:	89 d1                	mov    %edx,%ecx
  8040e9:	39 d3                	cmp    %edx,%ebx
  8040eb:	0f 82 87 00 00 00    	jb     804178 <__umoddi3+0x134>
  8040f1:	0f 84 91 00 00 00    	je     804188 <__umoddi3+0x144>
  8040f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8040fb:	29 f2                	sub    %esi,%edx
  8040fd:	19 cb                	sbb    %ecx,%ebx
  8040ff:	89 d8                	mov    %ebx,%eax
  804101:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804105:	d3 e0                	shl    %cl,%eax
  804107:	89 e9                	mov    %ebp,%ecx
  804109:	d3 ea                	shr    %cl,%edx
  80410b:	09 d0                	or     %edx,%eax
  80410d:	89 e9                	mov    %ebp,%ecx
  80410f:	d3 eb                	shr    %cl,%ebx
  804111:	89 da                	mov    %ebx,%edx
  804113:	83 c4 1c             	add    $0x1c,%esp
  804116:	5b                   	pop    %ebx
  804117:	5e                   	pop    %esi
  804118:	5f                   	pop    %edi
  804119:	5d                   	pop    %ebp
  80411a:	c3                   	ret    
  80411b:	90                   	nop
  80411c:	89 fd                	mov    %edi,%ebp
  80411e:	85 ff                	test   %edi,%edi
  804120:	75 0b                	jne    80412d <__umoddi3+0xe9>
  804122:	b8 01 00 00 00       	mov    $0x1,%eax
  804127:	31 d2                	xor    %edx,%edx
  804129:	f7 f7                	div    %edi
  80412b:	89 c5                	mov    %eax,%ebp
  80412d:	89 f0                	mov    %esi,%eax
  80412f:	31 d2                	xor    %edx,%edx
  804131:	f7 f5                	div    %ebp
  804133:	89 c8                	mov    %ecx,%eax
  804135:	f7 f5                	div    %ebp
  804137:	89 d0                	mov    %edx,%eax
  804139:	e9 44 ff ff ff       	jmp    804082 <__umoddi3+0x3e>
  80413e:	66 90                	xchg   %ax,%ax
  804140:	89 c8                	mov    %ecx,%eax
  804142:	89 f2                	mov    %esi,%edx
  804144:	83 c4 1c             	add    $0x1c,%esp
  804147:	5b                   	pop    %ebx
  804148:	5e                   	pop    %esi
  804149:	5f                   	pop    %edi
  80414a:	5d                   	pop    %ebp
  80414b:	c3                   	ret    
  80414c:	3b 04 24             	cmp    (%esp),%eax
  80414f:	72 06                	jb     804157 <__umoddi3+0x113>
  804151:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804155:	77 0f                	ja     804166 <__umoddi3+0x122>
  804157:	89 f2                	mov    %esi,%edx
  804159:	29 f9                	sub    %edi,%ecx
  80415b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80415f:	89 14 24             	mov    %edx,(%esp)
  804162:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804166:	8b 44 24 04          	mov    0x4(%esp),%eax
  80416a:	8b 14 24             	mov    (%esp),%edx
  80416d:	83 c4 1c             	add    $0x1c,%esp
  804170:	5b                   	pop    %ebx
  804171:	5e                   	pop    %esi
  804172:	5f                   	pop    %edi
  804173:	5d                   	pop    %ebp
  804174:	c3                   	ret    
  804175:	8d 76 00             	lea    0x0(%esi),%esi
  804178:	2b 04 24             	sub    (%esp),%eax
  80417b:	19 fa                	sbb    %edi,%edx
  80417d:	89 d1                	mov    %edx,%ecx
  80417f:	89 c6                	mov    %eax,%esi
  804181:	e9 71 ff ff ff       	jmp    8040f7 <__umoddi3+0xb3>
  804186:	66 90                	xchg   %ax,%ax
  804188:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80418c:	72 ea                	jb     804178 <__umoddi3+0x134>
  80418e:	89 d9                	mov    %ebx,%ecx
  804190:	e9 62 ff ff ff       	jmp    8040f7 <__umoddi3+0xb3>
