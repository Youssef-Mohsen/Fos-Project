
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
  800041:	e8 a9 1e 00 00       	call   801eef <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 41 80 00       	push   $0x8041c0
  80004e:	e8 b5 09 00 00       	call   800a08 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 41 80 00       	push   $0x8041c2
  80005e:	e8 a5 09 00 00       	call   800a08 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 db 41 80 00       	push   $0x8041db
  80006e:	e8 95 09 00 00       	call   800a08 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 41 80 00       	push   $0x8041c2
  80007e:	e8 85 09 00 00       	call   800a08 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 41 80 00       	push   $0x8041c0
  80008e:	e8 75 09 00 00       	call   800a08 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 f4 41 80 00       	push   $0x8041f4
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
  8000c9:	68 14 42 80 00       	push   $0x804214
  8000ce:	e8 35 09 00 00       	call   800a08 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 36 42 80 00       	push   $0x804236
  8000de:	e8 25 09 00 00       	call   800a08 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 44 42 80 00       	push   $0x804244
  8000ee:	e8 15 09 00 00       	call   800a08 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 53 42 80 00       	push   $0x804253
  8000fe:	e8 05 09 00 00       	call   800a08 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 63 42 80 00       	push   $0x804263
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
  80014d:	e8 b7 1d 00 00       	call   801f09 <sys_unlock_cons>
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
  8001d5:	e8 15 1d 00 00       	call   801eef <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 6c 42 80 00       	push   $0x80426c
  8001e2:	e8 21 08 00 00       	call   800a08 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 1a 1d 00 00       	call   801f09 <sys_unlock_cons>
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
  80020c:	68 a0 42 80 00       	push   $0x8042a0
  800211:	6a 54                	push   $0x54
  800213:	68 c2 42 80 00       	push   $0x8042c2
  800218:	e8 2e 05 00 00       	call   80074b <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 cd 1c 00 00       	call   801eef <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 e0 42 80 00       	push   $0x8042e0
  80022a:	e8 d9 07 00 00       	call   800a08 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 14 43 80 00       	push   $0x804314
  80023a:	e8 c9 07 00 00       	call   800a08 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 48 43 80 00       	push   $0x804348
  80024a:	e8 b9 07 00 00       	call   800a08 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 b2 1c 00 00       	call   801f09 <sys_unlock_cons>
			//			sys_unlock_cons();


		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 ec             	pushl  -0x14(%ebp)
  80025d:	e8 7d 19 00 00       	call   801bdf <free>
  800262:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
  800265:	e8 85 1c 00 00       	call   801eef <sys_lock_cons>
		{
			Chose = 0 ;
  80026a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  80026e:	eb 42                	jmp    8002b2 <_main+0x27a>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	68 7a 43 80 00       	push   $0x80437a
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
  8002be:	e8 46 1c 00 00       	call   801f09 <sys_unlock_cons>
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
  800570:	68 c0 41 80 00       	push   $0x8041c0
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
  800592:	68 98 43 80 00       	push   $0x804398
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
  8005c0:	68 9d 43 80 00       	push   $0x80439d
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
  8005e4:	e8 51 1a 00 00       	call   80203a <sys_cputc>
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
  8005f5:	e8 dc 18 00 00       	call   801ed6 <sys_cgetc>
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
  800612:	e8 54 1b 00 00       	call   80216b <sys_getenvindex>
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
  800680:	e8 6a 18 00 00       	call   801eef <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800685:	83 ec 0c             	sub    $0xc,%esp
  800688:	68 bc 43 80 00       	push   $0x8043bc
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
  8006b0:	68 e4 43 80 00       	push   $0x8043e4
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
  8006e1:	68 0c 44 80 00       	push   $0x80440c
  8006e6:	e8 1d 03 00 00       	call   800a08 <cprintf>
  8006eb:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f3:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	50                   	push   %eax
  8006fd:	68 64 44 80 00       	push   $0x804464
  800702:	e8 01 03 00 00       	call   800a08 <cprintf>
  800707:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	68 bc 43 80 00       	push   $0x8043bc
  800712:	e8 f1 02 00 00       	call   800a08 <cprintf>
  800717:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80071a:	e8 ea 17 00 00       	call   801f09 <sys_unlock_cons>
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
  800732:	e8 00 1a 00 00       	call   802137 <sys_destroy_env>
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
  800743:	e8 55 1a 00 00       	call   80219d <sys_exit_env>
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
  80076c:	68 78 44 80 00       	push   $0x804478
  800771:	e8 92 02 00 00       	call   800a08 <cprintf>
  800776:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800779:	a1 00 50 80 00       	mov    0x805000,%eax
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	ff 75 08             	pushl  0x8(%ebp)
  800784:	50                   	push   %eax
  800785:	68 7d 44 80 00       	push   $0x80447d
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
  8007a9:	68 99 44 80 00       	push   $0x804499
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
  8007d8:	68 9c 44 80 00       	push   $0x80449c
  8007dd:	6a 26                	push   $0x26
  8007df:	68 e8 44 80 00       	push   $0x8044e8
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
  8008ad:	68 f4 44 80 00       	push   $0x8044f4
  8008b2:	6a 3a                	push   $0x3a
  8008b4:	68 e8 44 80 00       	push   $0x8044e8
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
  800920:	68 48 45 80 00       	push   $0x804548
  800925:	6a 44                	push   $0x44
  800927:	68 e8 44 80 00       	push   $0x8044e8
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
  80097a:	e8 2e 15 00 00       	call   801ead <sys_cputs>
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
  8009f1:	e8 b7 14 00 00       	call   801ead <sys_cputs>
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
  800a3b:	e8 af 14 00 00       	call   801eef <sys_lock_cons>
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
  800a5b:	e8 a9 14 00 00       	call   801f09 <sys_unlock_cons>
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
  800aa5:	e8 9a 34 00 00       	call   803f44 <__udivdi3>
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
  800af5:	e8 5a 35 00 00       	call   804054 <__umoddi3>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	05 b4 47 80 00       	add    $0x8047b4,%eax
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
  800c50:	8b 04 85 d8 47 80 00 	mov    0x8047d8(,%eax,4),%eax
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
  800d31:	8b 34 9d 20 46 80 00 	mov    0x804620(,%ebx,4),%esi
  800d38:	85 f6                	test   %esi,%esi
  800d3a:	75 19                	jne    800d55 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d3c:	53                   	push   %ebx
  800d3d:	68 c5 47 80 00       	push   $0x8047c5
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
  800d56:	68 ce 47 80 00       	push   $0x8047ce
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
  800d83:	be d1 47 80 00       	mov    $0x8047d1,%esi
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
  8010ae:	68 48 49 80 00       	push   $0x804948
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
  8010f0:	68 4b 49 80 00       	push   $0x80494b
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
  8011a1:	e8 49 0d 00 00       	call   801eef <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8011a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011aa:	74 13                	je     8011bf <atomic_readline+0x24>
			cprintf("%s", prompt);
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	ff 75 08             	pushl  0x8(%ebp)
  8011b2:	68 48 49 80 00       	push   $0x804948
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
  8011f4:	68 4b 49 80 00       	push   $0x80494b
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
  80129c:	e8 68 0c 00 00       	call   801f09 <sys_unlock_cons>
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
  801996:	68 5c 49 80 00       	push   $0x80495c
  80199b:	68 3f 01 00 00       	push   $0x13f
  8019a0:	68 7e 49 80 00       	push   $0x80497e
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
  8019b6:	e8 9d 0a 00 00       	call   802458 <sys_sbrk>
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
  801a31:	e8 a6 08 00 00       	call   8022dc <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a36:	85 c0                	test   %eax,%eax
  801a38:	74 16                	je     801a50 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a3a:	83 ec 0c             	sub    $0xc,%esp
  801a3d:	ff 75 08             	pushl  0x8(%ebp)
  801a40:	e8 e6 0d 00 00       	call   80282b <alloc_block_FF>
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a4b:	e9 8a 01 00 00       	jmp    801bda <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801a50:	e8 b8 08 00 00       	call   80230d <sys_isUHeapPlacementStrategyBESTFIT>
  801a55:	85 c0                	test   %eax,%eax
  801a57:	0f 84 7d 01 00 00    	je     801bda <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801a5d:	83 ec 0c             	sub    $0xc,%esp
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	e8 7f 12 00 00       	call   802ce7 <alloc_block_BF>
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
  801bc9:	e8 c1 08 00 00       	call   80248f <sys_allocate_user_mem>
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
  801c11:	e8 95 08 00 00       	call   8024ab <get_block_size>
  801c16:	83 c4 10             	add    $0x10,%esp
  801c19:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c1c:	83 ec 0c             	sub    $0xc,%esp
  801c1f:	ff 75 08             	pushl  0x8(%ebp)
  801c22:	e8 c8 1a 00 00       	call   8036ef <free_block>
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
  801cb9:	e8 b5 07 00 00       	call   802473 <sys_free_user_mem>
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
  801cc7:	68 8c 49 80 00       	push   $0x80498c
  801ccc:	68 84 00 00 00       	push   $0x84
  801cd1:	68 b6 49 80 00       	push   $0x8049b6
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
  801d39:	e8 3c 03 00 00       	call   80207a <sys_createSharedObject>
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
  801d5a:	68 c2 49 80 00       	push   $0x8049c2
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
  801d6f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d72:	83 ec 08             	sub    $0x8,%esp
  801d75:	ff 75 0c             	pushl  0xc(%ebp)
  801d78:	ff 75 08             	pushl  0x8(%ebp)
  801d7b:	e8 24 03 00 00       	call   8020a4 <sys_getSizeOfSharedObject>
  801d80:	83 c4 10             	add    $0x10,%esp
  801d83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801d86:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801d8a:	75 07                	jne    801d93 <sget+0x27>
  801d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d91:	eb 5c                	jmp    801def <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d99:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801da0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da6:	39 d0                	cmp    %edx,%eax
  801da8:	7d 02                	jge    801dac <sget+0x40>
  801daa:	89 d0                	mov    %edx,%eax
  801dac:	83 ec 0c             	sub    $0xc,%esp
  801daf:	50                   	push   %eax
  801db0:	e8 0b fc ff ff       	call   8019c0 <malloc>
  801db5:	83 c4 10             	add    $0x10,%esp
  801db8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801dbb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801dbf:	75 07                	jne    801dc8 <sget+0x5c>
  801dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc6:	eb 27                	jmp    801def <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801dc8:	83 ec 04             	sub    $0x4,%esp
  801dcb:	ff 75 e8             	pushl  -0x18(%ebp)
  801dce:	ff 75 0c             	pushl  0xc(%ebp)
  801dd1:	ff 75 08             	pushl  0x8(%ebp)
  801dd4:	e8 e8 02 00 00       	call   8020c1 <sys_getSharedObject>
  801dd9:	83 c4 10             	add    $0x10,%esp
  801ddc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801ddf:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801de3:	75 07                	jne    801dec <sget+0x80>
  801de5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dea:	eb 03                	jmp    801def <sget+0x83>
	return ptr;
  801dec:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801df7:	83 ec 04             	sub    $0x4,%esp
  801dfa:	68 c8 49 80 00       	push   $0x8049c8
  801dff:	68 c2 00 00 00       	push   $0xc2
  801e04:	68 b6 49 80 00       	push   $0x8049b6
  801e09:	e8 3d e9 ff ff       	call   80074b <_panic>

00801e0e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e14:	83 ec 04             	sub    $0x4,%esp
  801e17:	68 ec 49 80 00       	push   $0x8049ec
  801e1c:	68 d9 00 00 00       	push   $0xd9
  801e21:	68 b6 49 80 00       	push   $0x8049b6
  801e26:	e8 20 e9 ff ff       	call   80074b <_panic>

00801e2b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e31:	83 ec 04             	sub    $0x4,%esp
  801e34:	68 12 4a 80 00       	push   $0x804a12
  801e39:	68 e5 00 00 00       	push   $0xe5
  801e3e:	68 b6 49 80 00       	push   $0x8049b6
  801e43:	e8 03 e9 ff ff       	call   80074b <_panic>

00801e48 <shrink>:

}
void shrink(uint32 newSize)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e4e:	83 ec 04             	sub    $0x4,%esp
  801e51:	68 12 4a 80 00       	push   $0x804a12
  801e56:	68 ea 00 00 00       	push   $0xea
  801e5b:	68 b6 49 80 00       	push   $0x8049b6
  801e60:	e8 e6 e8 ff ff       	call   80074b <_panic>

00801e65 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e6b:	83 ec 04             	sub    $0x4,%esp
  801e6e:	68 12 4a 80 00       	push   $0x804a12
  801e73:	68 ef 00 00 00       	push   $0xef
  801e78:	68 b6 49 80 00       	push   $0x8049b6
  801e7d:	e8 c9 e8 ff ff       	call   80074b <_panic>

00801e82 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	57                   	push   %edi
  801e86:	56                   	push   %esi
  801e87:	53                   	push   %ebx
  801e88:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e91:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e94:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e97:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e9a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e9d:	cd 30                	int    $0x30
  801e9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ea5:	83 c4 10             	add    $0x10,%esp
  801ea8:	5b                   	pop    %ebx
  801ea9:	5e                   	pop    %esi
  801eaa:	5f                   	pop    %edi
  801eab:	5d                   	pop    %ebp
  801eac:	c3                   	ret    

00801ead <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
  801eb0:	83 ec 04             	sub    $0x4,%esp
  801eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801eb9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	52                   	push   %edx
  801ec5:	ff 75 0c             	pushl  0xc(%ebp)
  801ec8:	50                   	push   %eax
  801ec9:	6a 00                	push   $0x0
  801ecb:	e8 b2 ff ff ff       	call   801e82 <syscall>
  801ed0:	83 c4 18             	add    $0x18,%esp
}
  801ed3:	90                   	nop
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 02                	push   $0x2
  801ee5:	e8 98 ff ff ff       	call   801e82 <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_lock_cons>:

void sys_lock_cons(void)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 03                	push   $0x3
  801efe:	e8 7f ff ff ff       	call   801e82 <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
}
  801f06:	90                   	nop
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 04                	push   $0x4
  801f18:	e8 65 ff ff ff       	call   801e82 <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
}
  801f20:	90                   	nop
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	52                   	push   %edx
  801f33:	50                   	push   %eax
  801f34:	6a 08                	push   $0x8
  801f36:	e8 47 ff ff ff       	call   801e82 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	56                   	push   %esi
  801f44:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f45:	8b 75 18             	mov    0x18(%ebp),%esi
  801f48:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	56                   	push   %esi
  801f55:	53                   	push   %ebx
  801f56:	51                   	push   %ecx
  801f57:	52                   	push   %edx
  801f58:	50                   	push   %eax
  801f59:	6a 09                	push   $0x9
  801f5b:	e8 22 ff ff ff       	call   801e82 <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
}
  801f63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f66:	5b                   	pop    %ebx
  801f67:	5e                   	pop    %esi
  801f68:	5d                   	pop    %ebp
  801f69:	c3                   	ret    

00801f6a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	52                   	push   %edx
  801f7a:	50                   	push   %eax
  801f7b:	6a 0a                	push   $0xa
  801f7d:	e8 00 ff ff ff       	call   801e82 <syscall>
  801f82:	83 c4 18             	add    $0x18,%esp
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	ff 75 0c             	pushl  0xc(%ebp)
  801f93:	ff 75 08             	pushl  0x8(%ebp)
  801f96:	6a 0b                	push   $0xb
  801f98:	e8 e5 fe ff ff       	call   801e82 <syscall>
  801f9d:	83 c4 18             	add    $0x18,%esp
}
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 0c                	push   $0xc
  801fb1:	e8 cc fe ff ff       	call   801e82 <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 0d                	push   $0xd
  801fca:	e8 b3 fe ff ff       	call   801e82 <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 0e                	push   $0xe
  801fe3:	e8 9a fe ff ff       	call   801e82 <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 0f                	push   $0xf
  801ffc:	e8 81 fe ff ff       	call   801e82 <syscall>
  802001:	83 c4 18             	add    $0x18,%esp
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	ff 75 08             	pushl  0x8(%ebp)
  802014:	6a 10                	push   $0x10
  802016:	e8 67 fe ff ff       	call   801e82 <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 11                	push   $0x11
  80202f:	e8 4e fe ff ff       	call   801e82 <syscall>
  802034:	83 c4 18             	add    $0x18,%esp
}
  802037:	90                   	nop
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <sys_cputc>:

void
sys_cputc(const char c)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 04             	sub    $0x4,%esp
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802046:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	50                   	push   %eax
  802053:	6a 01                	push   $0x1
  802055:	e8 28 fe ff ff       	call   801e82 <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
}
  80205d:	90                   	nop
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 14                	push   $0x14
  80206f:	e8 0e fe ff ff       	call   801e82 <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	90                   	nop
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	83 ec 04             	sub    $0x4,%esp
  802080:	8b 45 10             	mov    0x10(%ebp),%eax
  802083:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802086:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802089:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	6a 00                	push   $0x0
  802092:	51                   	push   %ecx
  802093:	52                   	push   %edx
  802094:	ff 75 0c             	pushl  0xc(%ebp)
  802097:	50                   	push   %eax
  802098:	6a 15                	push   $0x15
  80209a:	e8 e3 fd ff ff       	call   801e82 <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
}
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8020a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	52                   	push   %edx
  8020b4:	50                   	push   %eax
  8020b5:	6a 16                	push   $0x16
  8020b7:	e8 c6 fd ff ff       	call   801e82 <syscall>
  8020bc:	83 c4 18             	add    $0x18,%esp
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	51                   	push   %ecx
  8020d2:	52                   	push   %edx
  8020d3:	50                   	push   %eax
  8020d4:	6a 17                	push   $0x17
  8020d6:	e8 a7 fd ff ff       	call   801e82 <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	52                   	push   %edx
  8020f0:	50                   	push   %eax
  8020f1:	6a 18                	push   $0x18
  8020f3:	e8 8a fd ff ff       	call   801e82 <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	6a 00                	push   $0x0
  802105:	ff 75 14             	pushl  0x14(%ebp)
  802108:	ff 75 10             	pushl  0x10(%ebp)
  80210b:	ff 75 0c             	pushl  0xc(%ebp)
  80210e:	50                   	push   %eax
  80210f:	6a 19                	push   $0x19
  802111:	e8 6c fd ff ff       	call   801e82 <syscall>
  802116:	83 c4 18             	add    $0x18,%esp
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80211e:	8b 45 08             	mov    0x8(%ebp),%eax
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	50                   	push   %eax
  80212a:	6a 1a                	push   $0x1a
  80212c:	e8 51 fd ff ff       	call   801e82 <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	90                   	nop
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	50                   	push   %eax
  802146:	6a 1b                	push   $0x1b
  802148:	e8 35 fd ff ff       	call   801e82 <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 05                	push   $0x5
  802161:	e8 1c fd ff ff       	call   801e82 <syscall>
  802166:	83 c4 18             	add    $0x18,%esp
}
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 06                	push   $0x6
  80217a:	e8 03 fd ff ff       	call   801e82 <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 07                	push   $0x7
  802193:	e8 ea fc ff ff       	call   801e82 <syscall>
  802198:	83 c4 18             	add    $0x18,%esp
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <sys_exit_env>:


void sys_exit_env(void)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 1c                	push   $0x1c
  8021ac:	e8 d1 fc ff ff       	call   801e82 <syscall>
  8021b1:	83 c4 18             	add    $0x18,%esp
}
  8021b4:	90                   	nop
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021bd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021c0:	8d 50 04             	lea    0x4(%eax),%edx
  8021c3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	52                   	push   %edx
  8021cd:	50                   	push   %eax
  8021ce:	6a 1d                	push   $0x1d
  8021d0:	e8 ad fc ff ff       	call   801e82 <syscall>
  8021d5:	83 c4 18             	add    $0x18,%esp
	return result;
  8021d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021e1:	89 01                	mov    %eax,(%ecx)
  8021e3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	c9                   	leave  
  8021ea:	c2 04 00             	ret    $0x4

008021ed <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	ff 75 10             	pushl  0x10(%ebp)
  8021f7:	ff 75 0c             	pushl  0xc(%ebp)
  8021fa:	ff 75 08             	pushl  0x8(%ebp)
  8021fd:	6a 13                	push   $0x13
  8021ff:	e8 7e fc ff ff       	call   801e82 <syscall>
  802204:	83 c4 18             	add    $0x18,%esp
	return ;
  802207:	90                   	nop
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <sys_rcr2>:
uint32 sys_rcr2()
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 1e                	push   $0x1e
  802219:	e8 64 fc ff ff       	call   801e82 <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	83 ec 04             	sub    $0x4,%esp
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80222f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	50                   	push   %eax
  80223c:	6a 1f                	push   $0x1f
  80223e:	e8 3f fc ff ff       	call   801e82 <syscall>
  802243:	83 c4 18             	add    $0x18,%esp
	return ;
  802246:	90                   	nop
}
  802247:	c9                   	leave  
  802248:	c3                   	ret    

00802249 <rsttst>:
void rsttst()
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 21                	push   $0x21
  802258:	e8 25 fc ff ff       	call   801e82 <syscall>
  80225d:	83 c4 18             	add    $0x18,%esp
	return ;
  802260:	90                   	nop
}
  802261:	c9                   	leave  
  802262:	c3                   	ret    

00802263 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
  802266:	83 ec 04             	sub    $0x4,%esp
  802269:	8b 45 14             	mov    0x14(%ebp),%eax
  80226c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80226f:	8b 55 18             	mov    0x18(%ebp),%edx
  802272:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802276:	52                   	push   %edx
  802277:	50                   	push   %eax
  802278:	ff 75 10             	pushl  0x10(%ebp)
  80227b:	ff 75 0c             	pushl  0xc(%ebp)
  80227e:	ff 75 08             	pushl  0x8(%ebp)
  802281:	6a 20                	push   $0x20
  802283:	e8 fa fb ff ff       	call   801e82 <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
	return ;
  80228b:	90                   	nop
}
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <chktst>:
void chktst(uint32 n)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	ff 75 08             	pushl  0x8(%ebp)
  80229c:	6a 22                	push   $0x22
  80229e:	e8 df fb ff ff       	call   801e82 <syscall>
  8022a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8022a6:	90                   	nop
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <inctst>:

void inctst()
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 23                	push   $0x23
  8022b8:	e8 c5 fb ff ff       	call   801e82 <syscall>
  8022bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c0:	90                   	nop
}
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <gettst>:
uint32 gettst()
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 24                	push   $0x24
  8022d2:	e8 ab fb ff ff       	call   801e82 <syscall>
  8022d7:	83 c4 18             	add    $0x18,%esp
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 25                	push   $0x25
  8022ee:	e8 8f fb ff ff       	call   801e82 <syscall>
  8022f3:	83 c4 18             	add    $0x18,%esp
  8022f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8022f9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8022fd:	75 07                	jne    802306 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8022ff:	b8 01 00 00 00       	mov    $0x1,%eax
  802304:	eb 05                	jmp    80230b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802306:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 25                	push   $0x25
  80231f:	e8 5e fb ff ff       	call   801e82 <syscall>
  802324:	83 c4 18             	add    $0x18,%esp
  802327:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80232a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80232e:	75 07                	jne    802337 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802330:	b8 01 00 00 00       	mov    $0x1,%eax
  802335:	eb 05                	jmp    80233c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802337:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 25                	push   $0x25
  802350:	e8 2d fb ff ff       	call   801e82 <syscall>
  802355:	83 c4 18             	add    $0x18,%esp
  802358:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80235b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80235f:	75 07                	jne    802368 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802361:	b8 01 00 00 00       	mov    $0x1,%eax
  802366:	eb 05                	jmp    80236d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802368:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
  802372:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 25                	push   $0x25
  802381:	e8 fc fa ff ff       	call   801e82 <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
  802389:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80238c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802390:	75 07                	jne    802399 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802392:	b8 01 00 00 00       	mov    $0x1,%eax
  802397:	eb 05                	jmp    80239e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802399:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239e:	c9                   	leave  
  80239f:	c3                   	ret    

008023a0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	ff 75 08             	pushl  0x8(%ebp)
  8023ae:	6a 26                	push   $0x26
  8023b0:	e8 cd fa ff ff       	call   801e82 <syscall>
  8023b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b8:	90                   	nop
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	6a 00                	push   $0x0
  8023cd:	53                   	push   %ebx
  8023ce:	51                   	push   %ecx
  8023cf:	52                   	push   %edx
  8023d0:	50                   	push   %eax
  8023d1:	6a 27                	push   $0x27
  8023d3:	e8 aa fa ff ff       	call   801e82 <syscall>
  8023d8:	83 c4 18             	add    $0x18,%esp
}
  8023db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	52                   	push   %edx
  8023f0:	50                   	push   %eax
  8023f1:	6a 28                	push   $0x28
  8023f3:	e8 8a fa ff ff       	call   801e82 <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
}
  8023fb:	c9                   	leave  
  8023fc:	c3                   	ret    

008023fd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8023fd:	55                   	push   %ebp
  8023fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802400:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802403:	8b 55 0c             	mov    0xc(%ebp),%edx
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	6a 00                	push   $0x0
  80240b:	51                   	push   %ecx
  80240c:	ff 75 10             	pushl  0x10(%ebp)
  80240f:	52                   	push   %edx
  802410:	50                   	push   %eax
  802411:	6a 29                	push   $0x29
  802413:	e8 6a fa ff ff       	call   801e82 <syscall>
  802418:	83 c4 18             	add    $0x18,%esp
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	ff 75 10             	pushl  0x10(%ebp)
  802427:	ff 75 0c             	pushl  0xc(%ebp)
  80242a:	ff 75 08             	pushl  0x8(%ebp)
  80242d:	6a 12                	push   $0x12
  80242f:	e8 4e fa ff ff       	call   801e82 <syscall>
  802434:	83 c4 18             	add    $0x18,%esp
	return ;
  802437:	90                   	nop
}
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80243d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802440:	8b 45 08             	mov    0x8(%ebp),%eax
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	52                   	push   %edx
  80244a:	50                   	push   %eax
  80244b:	6a 2a                	push   $0x2a
  80244d:	e8 30 fa ff ff       	call   801e82 <syscall>
  802452:	83 c4 18             	add    $0x18,%esp
	return;
  802455:	90                   	nop
}
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80245b:	8b 45 08             	mov    0x8(%ebp),%eax
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	50                   	push   %eax
  802467:	6a 2b                	push   $0x2b
  802469:	e8 14 fa ff ff       	call   801e82 <syscall>
  80246e:	83 c4 18             	add    $0x18,%esp
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	ff 75 0c             	pushl  0xc(%ebp)
  80247f:	ff 75 08             	pushl  0x8(%ebp)
  802482:	6a 2c                	push   $0x2c
  802484:	e8 f9 f9 ff ff       	call   801e82 <syscall>
  802489:	83 c4 18             	add    $0x18,%esp
	return;
  80248c:	90                   	nop
}
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    

0080248f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	ff 75 0c             	pushl  0xc(%ebp)
  80249b:	ff 75 08             	pushl  0x8(%ebp)
  80249e:	6a 2d                	push   $0x2d
  8024a0:	e8 dd f9 ff ff       	call   801e82 <syscall>
  8024a5:	83 c4 18             	add    $0x18,%esp
	return;
  8024a8:	90                   	nop
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
  8024ae:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8024b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b4:	83 e8 04             	sub    $0x4,%eax
  8024b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8024ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024bd:	8b 00                	mov    (%eax),%eax
  8024bf:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	83 e8 04             	sub    $0x4,%eax
  8024d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8024d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024d6:	8b 00                	mov    (%eax),%eax
  8024d8:	83 e0 01             	and    $0x1,%eax
  8024db:	85 c0                	test   %eax,%eax
  8024dd:	0f 94 c0             	sete   %al
}
  8024e0:	c9                   	leave  
  8024e1:	c3                   	ret    

008024e2 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
  8024e5:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8024e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8024ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f2:	83 f8 02             	cmp    $0x2,%eax
  8024f5:	74 2b                	je     802522 <alloc_block+0x40>
  8024f7:	83 f8 02             	cmp    $0x2,%eax
  8024fa:	7f 07                	jg     802503 <alloc_block+0x21>
  8024fc:	83 f8 01             	cmp    $0x1,%eax
  8024ff:	74 0e                	je     80250f <alloc_block+0x2d>
  802501:	eb 58                	jmp    80255b <alloc_block+0x79>
  802503:	83 f8 03             	cmp    $0x3,%eax
  802506:	74 2d                	je     802535 <alloc_block+0x53>
  802508:	83 f8 04             	cmp    $0x4,%eax
  80250b:	74 3b                	je     802548 <alloc_block+0x66>
  80250d:	eb 4c                	jmp    80255b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80250f:	83 ec 0c             	sub    $0xc,%esp
  802512:	ff 75 08             	pushl  0x8(%ebp)
  802515:	e8 11 03 00 00       	call   80282b <alloc_block_FF>
  80251a:	83 c4 10             	add    $0x10,%esp
  80251d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802520:	eb 4a                	jmp    80256c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802522:	83 ec 0c             	sub    $0xc,%esp
  802525:	ff 75 08             	pushl  0x8(%ebp)
  802528:	e8 fa 19 00 00       	call   803f27 <alloc_block_NF>
  80252d:	83 c4 10             	add    $0x10,%esp
  802530:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802533:	eb 37                	jmp    80256c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802535:	83 ec 0c             	sub    $0xc,%esp
  802538:	ff 75 08             	pushl  0x8(%ebp)
  80253b:	e8 a7 07 00 00       	call   802ce7 <alloc_block_BF>
  802540:	83 c4 10             	add    $0x10,%esp
  802543:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802546:	eb 24                	jmp    80256c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802548:	83 ec 0c             	sub    $0xc,%esp
  80254b:	ff 75 08             	pushl  0x8(%ebp)
  80254e:	e8 b7 19 00 00       	call   803f0a <alloc_block_WF>
  802553:	83 c4 10             	add    $0x10,%esp
  802556:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802559:	eb 11                	jmp    80256c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80255b:	83 ec 0c             	sub    $0xc,%esp
  80255e:	68 24 4a 80 00       	push   $0x804a24
  802563:	e8 a0 e4 ff ff       	call   800a08 <cprintf>
  802568:	83 c4 10             	add    $0x10,%esp
		break;
  80256b:	90                   	nop
	}
	return va;
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80256f:	c9                   	leave  
  802570:	c3                   	ret    

00802571 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
  802574:	53                   	push   %ebx
  802575:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802578:	83 ec 0c             	sub    $0xc,%esp
  80257b:	68 44 4a 80 00       	push   $0x804a44
  802580:	e8 83 e4 ff ff       	call   800a08 <cprintf>
  802585:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802588:	83 ec 0c             	sub    $0xc,%esp
  80258b:	68 6f 4a 80 00       	push   $0x804a6f
  802590:	e8 73 e4 ff ff       	call   800a08 <cprintf>
  802595:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802598:	8b 45 08             	mov    0x8(%ebp),%eax
  80259b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259e:	eb 37                	jmp    8025d7 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8025a0:	83 ec 0c             	sub    $0xc,%esp
  8025a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8025a6:	e8 19 ff ff ff       	call   8024c4 <is_free_block>
  8025ab:	83 c4 10             	add    $0x10,%esp
  8025ae:	0f be d8             	movsbl %al,%ebx
  8025b1:	83 ec 0c             	sub    $0xc,%esp
  8025b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b7:	e8 ef fe ff ff       	call   8024ab <get_block_size>
  8025bc:	83 c4 10             	add    $0x10,%esp
  8025bf:	83 ec 04             	sub    $0x4,%esp
  8025c2:	53                   	push   %ebx
  8025c3:	50                   	push   %eax
  8025c4:	68 87 4a 80 00       	push   $0x804a87
  8025c9:	e8 3a e4 ff ff       	call   800a08 <cprintf>
  8025ce:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8025d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025db:	74 07                	je     8025e4 <print_blocks_list+0x73>
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	8b 00                	mov    (%eax),%eax
  8025e2:	eb 05                	jmp    8025e9 <print_blocks_list+0x78>
  8025e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e9:	89 45 10             	mov    %eax,0x10(%ebp)
  8025ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8025ef:	85 c0                	test   %eax,%eax
  8025f1:	75 ad                	jne    8025a0 <print_blocks_list+0x2f>
  8025f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f7:	75 a7                	jne    8025a0 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8025f9:	83 ec 0c             	sub    $0xc,%esp
  8025fc:	68 44 4a 80 00       	push   $0x804a44
  802601:	e8 02 e4 ff ff       	call   800a08 <cprintf>
  802606:	83 c4 10             	add    $0x10,%esp

}
  802609:	90                   	nop
  80260a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80260d:	c9                   	leave  
  80260e:	c3                   	ret    

0080260f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80260f:	55                   	push   %ebp
  802610:	89 e5                	mov    %esp,%ebp
  802612:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802615:	8b 45 0c             	mov    0xc(%ebp),%eax
  802618:	83 e0 01             	and    $0x1,%eax
  80261b:	85 c0                	test   %eax,%eax
  80261d:	74 03                	je     802622 <initialize_dynamic_allocator+0x13>
  80261f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802622:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802626:	0f 84 c7 01 00 00    	je     8027f3 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80262c:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802633:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802636:	8b 55 08             	mov    0x8(%ebp),%edx
  802639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80263c:	01 d0                	add    %edx,%eax
  80263e:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802643:	0f 87 ad 01 00 00    	ja     8027f6 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	85 c0                	test   %eax,%eax
  80264e:	0f 89 a5 01 00 00    	jns    8027f9 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802654:	8b 55 08             	mov    0x8(%ebp),%edx
  802657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265a:	01 d0                	add    %edx,%eax
  80265c:	83 e8 04             	sub    $0x4,%eax
  80265f:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  802664:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80266b:	a1 30 50 80 00       	mov    0x805030,%eax
  802670:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802673:	e9 87 00 00 00       	jmp    8026ff <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267c:	75 14                	jne    802692 <initialize_dynamic_allocator+0x83>
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	68 9f 4a 80 00       	push   $0x804a9f
  802686:	6a 79                	push   $0x79
  802688:	68 bd 4a 80 00       	push   $0x804abd
  80268d:	e8 b9 e0 ff ff       	call   80074b <_panic>
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 00                	mov    (%eax),%eax
  802697:	85 c0                	test   %eax,%eax
  802699:	74 10                	je     8026ab <initialize_dynamic_allocator+0x9c>
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 00                	mov    (%eax),%eax
  8026a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a3:	8b 52 04             	mov    0x4(%edx),%edx
  8026a6:	89 50 04             	mov    %edx,0x4(%eax)
  8026a9:	eb 0b                	jmp    8026b6 <initialize_dynamic_allocator+0xa7>
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 40 04             	mov    0x4(%eax),%eax
  8026b1:	a3 34 50 80 00       	mov    %eax,0x805034
  8026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b9:	8b 40 04             	mov    0x4(%eax),%eax
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	74 0f                	je     8026cf <initialize_dynamic_allocator+0xc0>
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 40 04             	mov    0x4(%eax),%eax
  8026c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c9:	8b 12                	mov    (%edx),%edx
  8026cb:	89 10                	mov    %edx,(%eax)
  8026cd:	eb 0a                	jmp    8026d9 <initialize_dynamic_allocator+0xca>
  8026cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d2:	8b 00                	mov    (%eax),%eax
  8026d4:	a3 30 50 80 00       	mov    %eax,0x805030
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ec:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026f1:	48                   	dec    %eax
  8026f2:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8026f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8026fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802703:	74 07                	je     80270c <initialize_dynamic_allocator+0xfd>
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 00                	mov    (%eax),%eax
  80270a:	eb 05                	jmp    802711 <initialize_dynamic_allocator+0x102>
  80270c:	b8 00 00 00 00       	mov    $0x0,%eax
  802711:	a3 38 50 80 00       	mov    %eax,0x805038
  802716:	a1 38 50 80 00       	mov    0x805038,%eax
  80271b:	85 c0                	test   %eax,%eax
  80271d:	0f 85 55 ff ff ff    	jne    802678 <initialize_dynamic_allocator+0x69>
  802723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802727:	0f 85 4b ff ff ff    	jne    802678 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80272d:	8b 45 08             	mov    0x8(%ebp),%eax
  802730:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802736:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80273c:	a1 48 50 80 00       	mov    0x805048,%eax
  802741:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802746:	a1 44 50 80 00       	mov    0x805044,%eax
  80274b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	83 c0 08             	add    $0x8,%eax
  802757:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80275a:	8b 45 08             	mov    0x8(%ebp),%eax
  80275d:	83 c0 04             	add    $0x4,%eax
  802760:	8b 55 0c             	mov    0xc(%ebp),%edx
  802763:	83 ea 08             	sub    $0x8,%edx
  802766:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802768:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276b:	8b 45 08             	mov    0x8(%ebp),%eax
  80276e:	01 d0                	add    %edx,%eax
  802770:	83 e8 08             	sub    $0x8,%eax
  802773:	8b 55 0c             	mov    0xc(%ebp),%edx
  802776:	83 ea 08             	sub    $0x8,%edx
  802779:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80277b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802784:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802787:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80278e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802792:	75 17                	jne    8027ab <initialize_dynamic_allocator+0x19c>
  802794:	83 ec 04             	sub    $0x4,%esp
  802797:	68 d8 4a 80 00       	push   $0x804ad8
  80279c:	68 90 00 00 00       	push   $0x90
  8027a1:	68 bd 4a 80 00       	push   $0x804abd
  8027a6:	e8 a0 df ff ff       	call   80074b <_panic>
  8027ab:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8027b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b4:	89 10                	mov    %edx,(%eax)
  8027b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	85 c0                	test   %eax,%eax
  8027bd:	74 0d                	je     8027cc <initialize_dynamic_allocator+0x1bd>
  8027bf:	a1 30 50 80 00       	mov    0x805030,%eax
  8027c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027c7:	89 50 04             	mov    %edx,0x4(%eax)
  8027ca:	eb 08                	jmp    8027d4 <initialize_dynamic_allocator+0x1c5>
  8027cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cf:	a3 34 50 80 00       	mov    %eax,0x805034
  8027d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d7:	a3 30 50 80 00       	mov    %eax,0x805030
  8027dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027eb:	40                   	inc    %eax
  8027ec:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8027f1:	eb 07                	jmp    8027fa <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8027f3:	90                   	nop
  8027f4:	eb 04                	jmp    8027fa <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8027f6:	90                   	nop
  8027f7:	eb 01                	jmp    8027fa <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8027f9:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8027fa:	c9                   	leave  
  8027fb:	c3                   	ret    

008027fc <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8027fc:	55                   	push   %ebp
  8027fd:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8027ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802802:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802805:	8b 45 08             	mov    0x8(%ebp),%eax
  802808:	8d 50 fc             	lea    -0x4(%eax),%edx
  80280b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80280e:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	83 e8 04             	sub    $0x4,%eax
  802816:	8b 00                	mov    (%eax),%eax
  802818:	83 e0 fe             	and    $0xfffffffe,%eax
  80281b:	8d 50 f8             	lea    -0x8(%eax),%edx
  80281e:	8b 45 08             	mov    0x8(%ebp),%eax
  802821:	01 c2                	add    %eax,%edx
  802823:	8b 45 0c             	mov    0xc(%ebp),%eax
  802826:	89 02                	mov    %eax,(%edx)
}
  802828:	90                   	nop
  802829:	5d                   	pop    %ebp
  80282a:	c3                   	ret    

0080282b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80282b:	55                   	push   %ebp
  80282c:	89 e5                	mov    %esp,%ebp
  80282e:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	83 e0 01             	and    $0x1,%eax
  802837:	85 c0                	test   %eax,%eax
  802839:	74 03                	je     80283e <alloc_block_FF+0x13>
  80283b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80283e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802842:	77 07                	ja     80284b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802844:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80284b:	a1 28 50 80 00       	mov    0x805028,%eax
  802850:	85 c0                	test   %eax,%eax
  802852:	75 73                	jne    8028c7 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802854:	8b 45 08             	mov    0x8(%ebp),%eax
  802857:	83 c0 10             	add    $0x10,%eax
  80285a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80285d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802864:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286a:	01 d0                	add    %edx,%eax
  80286c:	48                   	dec    %eax
  80286d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802870:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802873:	ba 00 00 00 00       	mov    $0x0,%edx
  802878:	f7 75 ec             	divl   -0x14(%ebp)
  80287b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80287e:	29 d0                	sub    %edx,%eax
  802880:	c1 e8 0c             	shr    $0xc,%eax
  802883:	83 ec 0c             	sub    $0xc,%esp
  802886:	50                   	push   %eax
  802887:	e8 1e f1 ff ff       	call   8019aa <sbrk>
  80288c:	83 c4 10             	add    $0x10,%esp
  80288f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802892:	83 ec 0c             	sub    $0xc,%esp
  802895:	6a 00                	push   $0x0
  802897:	e8 0e f1 ff ff       	call   8019aa <sbrk>
  80289c:	83 c4 10             	add    $0x10,%esp
  80289f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8028a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8028a8:	83 ec 08             	sub    $0x8,%esp
  8028ab:	50                   	push   %eax
  8028ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8028af:	e8 5b fd ff ff       	call   80260f <initialize_dynamic_allocator>
  8028b4:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8028b7:	83 ec 0c             	sub    $0xc,%esp
  8028ba:	68 fb 4a 80 00       	push   $0x804afb
  8028bf:	e8 44 e1 ff ff       	call   800a08 <cprintf>
  8028c4:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8028c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028cb:	75 0a                	jne    8028d7 <alloc_block_FF+0xac>
	        return NULL;
  8028cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d2:	e9 0e 04 00 00       	jmp    802ce5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8028d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8028de:	a1 30 50 80 00       	mov    0x805030,%eax
  8028e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e6:	e9 f3 02 00 00       	jmp    802bde <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8028f1:	83 ec 0c             	sub    $0xc,%esp
  8028f4:	ff 75 bc             	pushl  -0x44(%ebp)
  8028f7:	e8 af fb ff ff       	call   8024ab <get_block_size>
  8028fc:	83 c4 10             	add    $0x10,%esp
  8028ff:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	83 c0 08             	add    $0x8,%eax
  802908:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80290b:	0f 87 c5 02 00 00    	ja     802bd6 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802911:	8b 45 08             	mov    0x8(%ebp),%eax
  802914:	83 c0 18             	add    $0x18,%eax
  802917:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80291a:	0f 87 19 02 00 00    	ja     802b39 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802920:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802923:	2b 45 08             	sub    0x8(%ebp),%eax
  802926:	83 e8 08             	sub    $0x8,%eax
  802929:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	8d 50 08             	lea    0x8(%eax),%edx
  802932:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802935:	01 d0                	add    %edx,%eax
  802937:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80293a:	8b 45 08             	mov    0x8(%ebp),%eax
  80293d:	83 c0 08             	add    $0x8,%eax
  802940:	83 ec 04             	sub    $0x4,%esp
  802943:	6a 01                	push   $0x1
  802945:	50                   	push   %eax
  802946:	ff 75 bc             	pushl  -0x44(%ebp)
  802949:	e8 ae fe ff ff       	call   8027fc <set_block_data>
  80294e:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 40 04             	mov    0x4(%eax),%eax
  802957:	85 c0                	test   %eax,%eax
  802959:	75 68                	jne    8029c3 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80295b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80295f:	75 17                	jne    802978 <alloc_block_FF+0x14d>
  802961:	83 ec 04             	sub    $0x4,%esp
  802964:	68 d8 4a 80 00       	push   $0x804ad8
  802969:	68 d7 00 00 00       	push   $0xd7
  80296e:	68 bd 4a 80 00       	push   $0x804abd
  802973:	e8 d3 dd ff ff       	call   80074b <_panic>
  802978:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80297e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802981:	89 10                	mov    %edx,(%eax)
  802983:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	85 c0                	test   %eax,%eax
  80298a:	74 0d                	je     802999 <alloc_block_FF+0x16e>
  80298c:	a1 30 50 80 00       	mov    0x805030,%eax
  802991:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802994:	89 50 04             	mov    %edx,0x4(%eax)
  802997:	eb 08                	jmp    8029a1 <alloc_block_FF+0x176>
  802999:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80299c:	a3 34 50 80 00       	mov    %eax,0x805034
  8029a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029a4:	a3 30 50 80 00       	mov    %eax,0x805030
  8029a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8029b8:	40                   	inc    %eax
  8029b9:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8029be:	e9 dc 00 00 00       	jmp    802a9f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	8b 00                	mov    (%eax),%eax
  8029c8:	85 c0                	test   %eax,%eax
  8029ca:	75 65                	jne    802a31 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029cc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029d0:	75 17                	jne    8029e9 <alloc_block_FF+0x1be>
  8029d2:	83 ec 04             	sub    $0x4,%esp
  8029d5:	68 0c 4b 80 00       	push   $0x804b0c
  8029da:	68 db 00 00 00       	push   $0xdb
  8029df:	68 bd 4a 80 00       	push   $0x804abd
  8029e4:	e8 62 dd ff ff       	call   80074b <_panic>
  8029e9:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8029ef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f2:	89 50 04             	mov    %edx,0x4(%eax)
  8029f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f8:	8b 40 04             	mov    0x4(%eax),%eax
  8029fb:	85 c0                	test   %eax,%eax
  8029fd:	74 0c                	je     802a0b <alloc_block_FF+0x1e0>
  8029ff:	a1 34 50 80 00       	mov    0x805034,%eax
  802a04:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a07:	89 10                	mov    %edx,(%eax)
  802a09:	eb 08                	jmp    802a13 <alloc_block_FF+0x1e8>
  802a0b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a0e:	a3 30 50 80 00       	mov    %eax,0x805030
  802a13:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a16:	a3 34 50 80 00       	mov    %eax,0x805034
  802a1b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a24:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a29:	40                   	inc    %eax
  802a2a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a2f:	eb 6e                	jmp    802a9f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802a31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a35:	74 06                	je     802a3d <alloc_block_FF+0x212>
  802a37:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a3b:	75 17                	jne    802a54 <alloc_block_FF+0x229>
  802a3d:	83 ec 04             	sub    $0x4,%esp
  802a40:	68 30 4b 80 00       	push   $0x804b30
  802a45:	68 df 00 00 00       	push   $0xdf
  802a4a:	68 bd 4a 80 00       	push   $0x804abd
  802a4f:	e8 f7 dc ff ff       	call   80074b <_panic>
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 10                	mov    (%eax),%edx
  802a59:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a5c:	89 10                	mov    %edx,(%eax)
  802a5e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a61:	8b 00                	mov    (%eax),%eax
  802a63:	85 c0                	test   %eax,%eax
  802a65:	74 0b                	je     802a72 <alloc_block_FF+0x247>
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a6f:	89 50 04             	mov    %edx,0x4(%eax)
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a78:	89 10                	mov    %edx,(%eax)
  802a7a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a80:	89 50 04             	mov    %edx,0x4(%eax)
  802a83:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a86:	8b 00                	mov    (%eax),%eax
  802a88:	85 c0                	test   %eax,%eax
  802a8a:	75 08                	jne    802a94 <alloc_block_FF+0x269>
  802a8c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a8f:	a3 34 50 80 00       	mov    %eax,0x805034
  802a94:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a99:	40                   	inc    %eax
  802a9a:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802a9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa3:	75 17                	jne    802abc <alloc_block_FF+0x291>
  802aa5:	83 ec 04             	sub    $0x4,%esp
  802aa8:	68 9f 4a 80 00       	push   $0x804a9f
  802aad:	68 e1 00 00 00       	push   $0xe1
  802ab2:	68 bd 4a 80 00       	push   $0x804abd
  802ab7:	e8 8f dc ff ff       	call   80074b <_panic>
  802abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abf:	8b 00                	mov    (%eax),%eax
  802ac1:	85 c0                	test   %eax,%eax
  802ac3:	74 10                	je     802ad5 <alloc_block_FF+0x2aa>
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 00                	mov    (%eax),%eax
  802aca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802acd:	8b 52 04             	mov    0x4(%edx),%edx
  802ad0:	89 50 04             	mov    %edx,0x4(%eax)
  802ad3:	eb 0b                	jmp    802ae0 <alloc_block_FF+0x2b5>
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	8b 40 04             	mov    0x4(%eax),%eax
  802adb:	a3 34 50 80 00       	mov    %eax,0x805034
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 40 04             	mov    0x4(%eax),%eax
  802ae6:	85 c0                	test   %eax,%eax
  802ae8:	74 0f                	je     802af9 <alloc_block_FF+0x2ce>
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 40 04             	mov    0x4(%eax),%eax
  802af0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af3:	8b 12                	mov    (%edx),%edx
  802af5:	89 10                	mov    %edx,(%eax)
  802af7:	eb 0a                	jmp    802b03 <alloc_block_FF+0x2d8>
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 00                	mov    (%eax),%eax
  802afe:	a3 30 50 80 00       	mov    %eax,0x805030
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b16:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b1b:	48                   	dec    %eax
  802b1c:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802b21:	83 ec 04             	sub    $0x4,%esp
  802b24:	6a 00                	push   $0x0
  802b26:	ff 75 b4             	pushl  -0x4c(%ebp)
  802b29:	ff 75 b0             	pushl  -0x50(%ebp)
  802b2c:	e8 cb fc ff ff       	call   8027fc <set_block_data>
  802b31:	83 c4 10             	add    $0x10,%esp
  802b34:	e9 95 00 00 00       	jmp    802bce <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802b39:	83 ec 04             	sub    $0x4,%esp
  802b3c:	6a 01                	push   $0x1
  802b3e:	ff 75 b8             	pushl  -0x48(%ebp)
  802b41:	ff 75 bc             	pushl  -0x44(%ebp)
  802b44:	e8 b3 fc ff ff       	call   8027fc <set_block_data>
  802b49:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802b4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b50:	75 17                	jne    802b69 <alloc_block_FF+0x33e>
  802b52:	83 ec 04             	sub    $0x4,%esp
  802b55:	68 9f 4a 80 00       	push   $0x804a9f
  802b5a:	68 e8 00 00 00       	push   $0xe8
  802b5f:	68 bd 4a 80 00       	push   $0x804abd
  802b64:	e8 e2 db ff ff       	call   80074b <_panic>
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	74 10                	je     802b82 <alloc_block_FF+0x357>
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7a:	8b 52 04             	mov    0x4(%edx),%edx
  802b7d:	89 50 04             	mov    %edx,0x4(%eax)
  802b80:	eb 0b                	jmp    802b8d <alloc_block_FF+0x362>
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	8b 40 04             	mov    0x4(%eax),%eax
  802b88:	a3 34 50 80 00       	mov    %eax,0x805034
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 40 04             	mov    0x4(%eax),%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	74 0f                	je     802ba6 <alloc_block_FF+0x37b>
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 40 04             	mov    0x4(%eax),%eax
  802b9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba0:	8b 12                	mov    (%edx),%edx
  802ba2:	89 10                	mov    %edx,(%eax)
  802ba4:	eb 0a                	jmp    802bb0 <alloc_block_FF+0x385>
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	a3 30 50 80 00       	mov    %eax,0x805030
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bc8:	48                   	dec    %eax
  802bc9:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802bce:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bd1:	e9 0f 01 00 00       	jmp    802ce5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802bd6:	a1 38 50 80 00       	mov    0x805038,%eax
  802bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be2:	74 07                	je     802beb <alloc_block_FF+0x3c0>
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 00                	mov    (%eax),%eax
  802be9:	eb 05                	jmp    802bf0 <alloc_block_FF+0x3c5>
  802beb:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf0:	a3 38 50 80 00       	mov    %eax,0x805038
  802bf5:	a1 38 50 80 00       	mov    0x805038,%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	0f 85 e9 fc ff ff    	jne    8028eb <alloc_block_FF+0xc0>
  802c02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c06:	0f 85 df fc ff ff    	jne    8028eb <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0f:	83 c0 08             	add    $0x8,%eax
  802c12:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c15:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802c1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c22:	01 d0                	add    %edx,%eax
  802c24:	48                   	dec    %eax
  802c25:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802c28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c2b:	ba 00 00 00 00       	mov    $0x0,%edx
  802c30:	f7 75 d8             	divl   -0x28(%ebp)
  802c33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c36:	29 d0                	sub    %edx,%eax
  802c38:	c1 e8 0c             	shr    $0xc,%eax
  802c3b:	83 ec 0c             	sub    $0xc,%esp
  802c3e:	50                   	push   %eax
  802c3f:	e8 66 ed ff ff       	call   8019aa <sbrk>
  802c44:	83 c4 10             	add    $0x10,%esp
  802c47:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802c4a:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802c4e:	75 0a                	jne    802c5a <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802c50:	b8 00 00 00 00       	mov    $0x0,%eax
  802c55:	e9 8b 00 00 00       	jmp    802ce5 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c5a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802c61:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c67:	01 d0                	add    %edx,%eax
  802c69:	48                   	dec    %eax
  802c6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802c6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c70:	ba 00 00 00 00       	mov    $0x0,%edx
  802c75:	f7 75 cc             	divl   -0x34(%ebp)
  802c78:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c7b:	29 d0                	sub    %edx,%eax
  802c7d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c80:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c83:	01 d0                	add    %edx,%eax
  802c85:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802c8a:	a1 44 50 80 00       	mov    0x805044,%eax
  802c8f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c95:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c9f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ca2:	01 d0                	add    %edx,%eax
  802ca4:	48                   	dec    %eax
  802ca5:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ca8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cab:	ba 00 00 00 00       	mov    $0x0,%edx
  802cb0:	f7 75 c4             	divl   -0x3c(%ebp)
  802cb3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cb6:	29 d0                	sub    %edx,%eax
  802cb8:	83 ec 04             	sub    $0x4,%esp
  802cbb:	6a 01                	push   $0x1
  802cbd:	50                   	push   %eax
  802cbe:	ff 75 d0             	pushl  -0x30(%ebp)
  802cc1:	e8 36 fb ff ff       	call   8027fc <set_block_data>
  802cc6:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802cc9:	83 ec 0c             	sub    $0xc,%esp
  802ccc:	ff 75 d0             	pushl  -0x30(%ebp)
  802ccf:	e8 1b 0a 00 00       	call   8036ef <free_block>
  802cd4:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802cd7:	83 ec 0c             	sub    $0xc,%esp
  802cda:	ff 75 08             	pushl  0x8(%ebp)
  802cdd:	e8 49 fb ff ff       	call   80282b <alloc_block_FF>
  802ce2:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802ce5:	c9                   	leave  
  802ce6:	c3                   	ret    

00802ce7 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802ce7:	55                   	push   %ebp
  802ce8:	89 e5                	mov    %esp,%ebp
  802cea:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	83 e0 01             	and    $0x1,%eax
  802cf3:	85 c0                	test   %eax,%eax
  802cf5:	74 03                	je     802cfa <alloc_block_BF+0x13>
  802cf7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802cfa:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802cfe:	77 07                	ja     802d07 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802d00:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802d07:	a1 28 50 80 00       	mov    0x805028,%eax
  802d0c:	85 c0                	test   %eax,%eax
  802d0e:	75 73                	jne    802d83 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	83 c0 10             	add    $0x10,%eax
  802d16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802d19:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802d20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d26:	01 d0                	add    %edx,%eax
  802d28:	48                   	dec    %eax
  802d29:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d2f:	ba 00 00 00 00       	mov    $0x0,%edx
  802d34:	f7 75 e0             	divl   -0x20(%ebp)
  802d37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d3a:	29 d0                	sub    %edx,%eax
  802d3c:	c1 e8 0c             	shr    $0xc,%eax
  802d3f:	83 ec 0c             	sub    $0xc,%esp
  802d42:	50                   	push   %eax
  802d43:	e8 62 ec ff ff       	call   8019aa <sbrk>
  802d48:	83 c4 10             	add    $0x10,%esp
  802d4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802d4e:	83 ec 0c             	sub    $0xc,%esp
  802d51:	6a 00                	push   $0x0
  802d53:	e8 52 ec ff ff       	call   8019aa <sbrk>
  802d58:	83 c4 10             	add    $0x10,%esp
  802d5b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802d5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d61:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802d64:	83 ec 08             	sub    $0x8,%esp
  802d67:	50                   	push   %eax
  802d68:	ff 75 d8             	pushl  -0x28(%ebp)
  802d6b:	e8 9f f8 ff ff       	call   80260f <initialize_dynamic_allocator>
  802d70:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802d73:	83 ec 0c             	sub    $0xc,%esp
  802d76:	68 fb 4a 80 00       	push   $0x804afb
  802d7b:	e8 88 dc ff ff       	call   800a08 <cprintf>
  802d80:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802d83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802d8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802d91:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802d98:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802d9f:	a1 30 50 80 00       	mov    0x805030,%eax
  802da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802da7:	e9 1d 01 00 00       	jmp    802ec9 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802db2:	83 ec 0c             	sub    $0xc,%esp
  802db5:	ff 75 a8             	pushl  -0x58(%ebp)
  802db8:	e8 ee f6 ff ff       	call   8024ab <get_block_size>
  802dbd:	83 c4 10             	add    $0x10,%esp
  802dc0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	83 c0 08             	add    $0x8,%eax
  802dc9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802dcc:	0f 87 ef 00 00 00    	ja     802ec1 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	83 c0 18             	add    $0x18,%eax
  802dd8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ddb:	77 1d                	ja     802dfa <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802ddd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802de3:	0f 86 d8 00 00 00    	jbe    802ec1 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802de9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802dec:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802def:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802df2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802df5:	e9 c7 00 00 00       	jmp    802ec1 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	83 c0 08             	add    $0x8,%eax
  802e00:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e03:	0f 85 9d 00 00 00    	jne    802ea6 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802e09:	83 ec 04             	sub    $0x4,%esp
  802e0c:	6a 01                	push   $0x1
  802e0e:	ff 75 a4             	pushl  -0x5c(%ebp)
  802e11:	ff 75 a8             	pushl  -0x58(%ebp)
  802e14:	e8 e3 f9 ff ff       	call   8027fc <set_block_data>
  802e19:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802e1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e20:	75 17                	jne    802e39 <alloc_block_BF+0x152>
  802e22:	83 ec 04             	sub    $0x4,%esp
  802e25:	68 9f 4a 80 00       	push   $0x804a9f
  802e2a:	68 2c 01 00 00       	push   $0x12c
  802e2f:	68 bd 4a 80 00       	push   $0x804abd
  802e34:	e8 12 d9 ff ff       	call   80074b <_panic>
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 00                	mov    (%eax),%eax
  802e3e:	85 c0                	test   %eax,%eax
  802e40:	74 10                	je     802e52 <alloc_block_BF+0x16b>
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 00                	mov    (%eax),%eax
  802e47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4a:	8b 52 04             	mov    0x4(%edx),%edx
  802e4d:	89 50 04             	mov    %edx,0x4(%eax)
  802e50:	eb 0b                	jmp    802e5d <alloc_block_BF+0x176>
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	8b 40 04             	mov    0x4(%eax),%eax
  802e58:	a3 34 50 80 00       	mov    %eax,0x805034
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 40 04             	mov    0x4(%eax),%eax
  802e63:	85 c0                	test   %eax,%eax
  802e65:	74 0f                	je     802e76 <alloc_block_BF+0x18f>
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	8b 40 04             	mov    0x4(%eax),%eax
  802e6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e70:	8b 12                	mov    (%edx),%edx
  802e72:	89 10                	mov    %edx,(%eax)
  802e74:	eb 0a                	jmp    802e80 <alloc_block_BF+0x199>
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 00                	mov    (%eax),%eax
  802e7b:	a3 30 50 80 00       	mov    %eax,0x805030
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e93:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e98:	48                   	dec    %eax
  802e99:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802e9e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ea1:	e9 24 04 00 00       	jmp    8032ca <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802ea6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802eac:	76 13                	jbe    802ec1 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802eae:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802eb5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802eb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802ebb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ebe:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802ec1:	a1 38 50 80 00       	mov    0x805038,%eax
  802ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ec9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ecd:	74 07                	je     802ed6 <alloc_block_BF+0x1ef>
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	8b 00                	mov    (%eax),%eax
  802ed4:	eb 05                	jmp    802edb <alloc_block_BF+0x1f4>
  802ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  802edb:	a3 38 50 80 00       	mov    %eax,0x805038
  802ee0:	a1 38 50 80 00       	mov    0x805038,%eax
  802ee5:	85 c0                	test   %eax,%eax
  802ee7:	0f 85 bf fe ff ff    	jne    802dac <alloc_block_BF+0xc5>
  802eed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef1:	0f 85 b5 fe ff ff    	jne    802dac <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802ef7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802efb:	0f 84 26 02 00 00    	je     803127 <alloc_block_BF+0x440>
  802f01:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f05:	0f 85 1c 02 00 00    	jne    803127 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0e:	2b 45 08             	sub    0x8(%ebp),%eax
  802f11:	83 e8 08             	sub    $0x8,%eax
  802f14:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	8d 50 08             	lea    0x8(%eax),%edx
  802f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f20:	01 d0                	add    %edx,%eax
  802f22:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	83 c0 08             	add    $0x8,%eax
  802f2b:	83 ec 04             	sub    $0x4,%esp
  802f2e:	6a 01                	push   $0x1
  802f30:	50                   	push   %eax
  802f31:	ff 75 f0             	pushl  -0x10(%ebp)
  802f34:	e8 c3 f8 ff ff       	call   8027fc <set_block_data>
  802f39:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3f:	8b 40 04             	mov    0x4(%eax),%eax
  802f42:	85 c0                	test   %eax,%eax
  802f44:	75 68                	jne    802fae <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f46:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f4a:	75 17                	jne    802f63 <alloc_block_BF+0x27c>
  802f4c:	83 ec 04             	sub    $0x4,%esp
  802f4f:	68 d8 4a 80 00       	push   $0x804ad8
  802f54:	68 45 01 00 00       	push   $0x145
  802f59:	68 bd 4a 80 00       	push   $0x804abd
  802f5e:	e8 e8 d7 ff ff       	call   80074b <_panic>
  802f63:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f69:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f6c:	89 10                	mov    %edx,(%eax)
  802f6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f71:	8b 00                	mov    (%eax),%eax
  802f73:	85 c0                	test   %eax,%eax
  802f75:	74 0d                	je     802f84 <alloc_block_BF+0x29d>
  802f77:	a1 30 50 80 00       	mov    0x805030,%eax
  802f7c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f7f:	89 50 04             	mov    %edx,0x4(%eax)
  802f82:	eb 08                	jmp    802f8c <alloc_block_BF+0x2a5>
  802f84:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f87:	a3 34 50 80 00       	mov    %eax,0x805034
  802f8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f8f:	a3 30 50 80 00       	mov    %eax,0x805030
  802f94:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fa3:	40                   	inc    %eax
  802fa4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802fa9:	e9 dc 00 00 00       	jmp    80308a <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb1:	8b 00                	mov    (%eax),%eax
  802fb3:	85 c0                	test   %eax,%eax
  802fb5:	75 65                	jne    80301c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802fb7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fbb:	75 17                	jne    802fd4 <alloc_block_BF+0x2ed>
  802fbd:	83 ec 04             	sub    $0x4,%esp
  802fc0:	68 0c 4b 80 00       	push   $0x804b0c
  802fc5:	68 4a 01 00 00       	push   $0x14a
  802fca:	68 bd 4a 80 00       	push   $0x804abd
  802fcf:	e8 77 d7 ff ff       	call   80074b <_panic>
  802fd4:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802fda:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fdd:	89 50 04             	mov    %edx,0x4(%eax)
  802fe0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fe3:	8b 40 04             	mov    0x4(%eax),%eax
  802fe6:	85 c0                	test   %eax,%eax
  802fe8:	74 0c                	je     802ff6 <alloc_block_BF+0x30f>
  802fea:	a1 34 50 80 00       	mov    0x805034,%eax
  802fef:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ff2:	89 10                	mov    %edx,(%eax)
  802ff4:	eb 08                	jmp    802ffe <alloc_block_BF+0x317>
  802ff6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ff9:	a3 30 50 80 00       	mov    %eax,0x805030
  802ffe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803001:	a3 34 50 80 00       	mov    %eax,0x805034
  803006:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803009:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803014:	40                   	inc    %eax
  803015:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80301a:	eb 6e                	jmp    80308a <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80301c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803020:	74 06                	je     803028 <alloc_block_BF+0x341>
  803022:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803026:	75 17                	jne    80303f <alloc_block_BF+0x358>
  803028:	83 ec 04             	sub    $0x4,%esp
  80302b:	68 30 4b 80 00       	push   $0x804b30
  803030:	68 4f 01 00 00       	push   $0x14f
  803035:	68 bd 4a 80 00       	push   $0x804abd
  80303a:	e8 0c d7 ff ff       	call   80074b <_panic>
  80303f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803042:	8b 10                	mov    (%eax),%edx
  803044:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803047:	89 10                	mov    %edx,(%eax)
  803049:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	85 c0                	test   %eax,%eax
  803050:	74 0b                	je     80305d <alloc_block_BF+0x376>
  803052:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803055:	8b 00                	mov    (%eax),%eax
  803057:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80305a:	89 50 04             	mov    %edx,0x4(%eax)
  80305d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803060:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803063:	89 10                	mov    %edx,(%eax)
  803065:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803068:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80306b:	89 50 04             	mov    %edx,0x4(%eax)
  80306e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	85 c0                	test   %eax,%eax
  803075:	75 08                	jne    80307f <alloc_block_BF+0x398>
  803077:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80307a:	a3 34 50 80 00       	mov    %eax,0x805034
  80307f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803084:	40                   	inc    %eax
  803085:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80308a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80308e:	75 17                	jne    8030a7 <alloc_block_BF+0x3c0>
  803090:	83 ec 04             	sub    $0x4,%esp
  803093:	68 9f 4a 80 00       	push   $0x804a9f
  803098:	68 51 01 00 00       	push   $0x151
  80309d:	68 bd 4a 80 00       	push   $0x804abd
  8030a2:	e8 a4 d6 ff ff       	call   80074b <_panic>
  8030a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030aa:	8b 00                	mov    (%eax),%eax
  8030ac:	85 c0                	test   %eax,%eax
  8030ae:	74 10                	je     8030c0 <alloc_block_BF+0x3d9>
  8030b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b3:	8b 00                	mov    (%eax),%eax
  8030b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030b8:	8b 52 04             	mov    0x4(%edx),%edx
  8030bb:	89 50 04             	mov    %edx,0x4(%eax)
  8030be:	eb 0b                	jmp    8030cb <alloc_block_BF+0x3e4>
  8030c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c3:	8b 40 04             	mov    0x4(%eax),%eax
  8030c6:	a3 34 50 80 00       	mov    %eax,0x805034
  8030cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ce:	8b 40 04             	mov    0x4(%eax),%eax
  8030d1:	85 c0                	test   %eax,%eax
  8030d3:	74 0f                	je     8030e4 <alloc_block_BF+0x3fd>
  8030d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d8:	8b 40 04             	mov    0x4(%eax),%eax
  8030db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030de:	8b 12                	mov    (%edx),%edx
  8030e0:	89 10                	mov    %edx,(%eax)
  8030e2:	eb 0a                	jmp    8030ee <alloc_block_BF+0x407>
  8030e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e7:	8b 00                	mov    (%eax),%eax
  8030e9:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803101:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803106:	48                   	dec    %eax
  803107:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  80310c:	83 ec 04             	sub    $0x4,%esp
  80310f:	6a 00                	push   $0x0
  803111:	ff 75 d0             	pushl  -0x30(%ebp)
  803114:	ff 75 cc             	pushl  -0x34(%ebp)
  803117:	e8 e0 f6 ff ff       	call   8027fc <set_block_data>
  80311c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80311f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803122:	e9 a3 01 00 00       	jmp    8032ca <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803127:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80312b:	0f 85 9d 00 00 00    	jne    8031ce <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803131:	83 ec 04             	sub    $0x4,%esp
  803134:	6a 01                	push   $0x1
  803136:	ff 75 ec             	pushl  -0x14(%ebp)
  803139:	ff 75 f0             	pushl  -0x10(%ebp)
  80313c:	e8 bb f6 ff ff       	call   8027fc <set_block_data>
  803141:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803144:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803148:	75 17                	jne    803161 <alloc_block_BF+0x47a>
  80314a:	83 ec 04             	sub    $0x4,%esp
  80314d:	68 9f 4a 80 00       	push   $0x804a9f
  803152:	68 58 01 00 00       	push   $0x158
  803157:	68 bd 4a 80 00       	push   $0x804abd
  80315c:	e8 ea d5 ff ff       	call   80074b <_panic>
  803161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803164:	8b 00                	mov    (%eax),%eax
  803166:	85 c0                	test   %eax,%eax
  803168:	74 10                	je     80317a <alloc_block_BF+0x493>
  80316a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803172:	8b 52 04             	mov    0x4(%edx),%edx
  803175:	89 50 04             	mov    %edx,0x4(%eax)
  803178:	eb 0b                	jmp    803185 <alloc_block_BF+0x49e>
  80317a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317d:	8b 40 04             	mov    0x4(%eax),%eax
  803180:	a3 34 50 80 00       	mov    %eax,0x805034
  803185:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803188:	8b 40 04             	mov    0x4(%eax),%eax
  80318b:	85 c0                	test   %eax,%eax
  80318d:	74 0f                	je     80319e <alloc_block_BF+0x4b7>
  80318f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803192:	8b 40 04             	mov    0x4(%eax),%eax
  803195:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803198:	8b 12                	mov    (%edx),%edx
  80319a:	89 10                	mov    %edx,(%eax)
  80319c:	eb 0a                	jmp    8031a8 <alloc_block_BF+0x4c1>
  80319e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8031a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031bb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031c0:	48                   	dec    %eax
  8031c1:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  8031c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c9:	e9 fc 00 00 00       	jmp    8032ca <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d1:	83 c0 08             	add    $0x8,%eax
  8031d4:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8031d7:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8031de:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031e1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8031e4:	01 d0                	add    %edx,%eax
  8031e6:	48                   	dec    %eax
  8031e7:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8031ea:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8031f2:	f7 75 c4             	divl   -0x3c(%ebp)
  8031f5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031f8:	29 d0                	sub    %edx,%eax
  8031fa:	c1 e8 0c             	shr    $0xc,%eax
  8031fd:	83 ec 0c             	sub    $0xc,%esp
  803200:	50                   	push   %eax
  803201:	e8 a4 e7 ff ff       	call   8019aa <sbrk>
  803206:	83 c4 10             	add    $0x10,%esp
  803209:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80320c:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803210:	75 0a                	jne    80321c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803212:	b8 00 00 00 00       	mov    $0x0,%eax
  803217:	e9 ae 00 00 00       	jmp    8032ca <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80321c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803223:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803226:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803229:	01 d0                	add    %edx,%eax
  80322b:	48                   	dec    %eax
  80322c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80322f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803232:	ba 00 00 00 00       	mov    $0x0,%edx
  803237:	f7 75 b8             	divl   -0x48(%ebp)
  80323a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80323d:	29 d0                	sub    %edx,%eax
  80323f:	8d 50 fc             	lea    -0x4(%eax),%edx
  803242:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803245:	01 d0                	add    %edx,%eax
  803247:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  80324c:	a1 44 50 80 00       	mov    0x805044,%eax
  803251:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803257:	83 ec 0c             	sub    $0xc,%esp
  80325a:	68 64 4b 80 00       	push   $0x804b64
  80325f:	e8 a4 d7 ff ff       	call   800a08 <cprintf>
  803264:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803267:	83 ec 08             	sub    $0x8,%esp
  80326a:	ff 75 bc             	pushl  -0x44(%ebp)
  80326d:	68 69 4b 80 00       	push   $0x804b69
  803272:	e8 91 d7 ff ff       	call   800a08 <cprintf>
  803277:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80327a:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803281:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803284:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803287:	01 d0                	add    %edx,%eax
  803289:	48                   	dec    %eax
  80328a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80328d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803290:	ba 00 00 00 00       	mov    $0x0,%edx
  803295:	f7 75 b0             	divl   -0x50(%ebp)
  803298:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80329b:	29 d0                	sub    %edx,%eax
  80329d:	83 ec 04             	sub    $0x4,%esp
  8032a0:	6a 01                	push   $0x1
  8032a2:	50                   	push   %eax
  8032a3:	ff 75 bc             	pushl  -0x44(%ebp)
  8032a6:	e8 51 f5 ff ff       	call   8027fc <set_block_data>
  8032ab:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8032ae:	83 ec 0c             	sub    $0xc,%esp
  8032b1:	ff 75 bc             	pushl  -0x44(%ebp)
  8032b4:	e8 36 04 00 00       	call   8036ef <free_block>
  8032b9:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8032bc:	83 ec 0c             	sub    $0xc,%esp
  8032bf:	ff 75 08             	pushl  0x8(%ebp)
  8032c2:	e8 20 fa ff ff       	call   802ce7 <alloc_block_BF>
  8032c7:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8032ca:	c9                   	leave  
  8032cb:	c3                   	ret    

008032cc <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8032cc:	55                   	push   %ebp
  8032cd:	89 e5                	mov    %esp,%ebp
  8032cf:	53                   	push   %ebx
  8032d0:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8032d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8032da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8032e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e5:	74 1e                	je     803305 <merging+0x39>
  8032e7:	ff 75 08             	pushl  0x8(%ebp)
  8032ea:	e8 bc f1 ff ff       	call   8024ab <get_block_size>
  8032ef:	83 c4 04             	add    $0x4,%esp
  8032f2:	89 c2                	mov    %eax,%edx
  8032f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f7:	01 d0                	add    %edx,%eax
  8032f9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8032fc:	75 07                	jne    803305 <merging+0x39>
		prev_is_free = 1;
  8032fe:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803305:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803309:	74 1e                	je     803329 <merging+0x5d>
  80330b:	ff 75 10             	pushl  0x10(%ebp)
  80330e:	e8 98 f1 ff ff       	call   8024ab <get_block_size>
  803313:	83 c4 04             	add    $0x4,%esp
  803316:	89 c2                	mov    %eax,%edx
  803318:	8b 45 10             	mov    0x10(%ebp),%eax
  80331b:	01 d0                	add    %edx,%eax
  80331d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803320:	75 07                	jne    803329 <merging+0x5d>
		next_is_free = 1;
  803322:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803329:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80332d:	0f 84 cc 00 00 00    	je     8033ff <merging+0x133>
  803333:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803337:	0f 84 c2 00 00 00    	je     8033ff <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80333d:	ff 75 08             	pushl  0x8(%ebp)
  803340:	e8 66 f1 ff ff       	call   8024ab <get_block_size>
  803345:	83 c4 04             	add    $0x4,%esp
  803348:	89 c3                	mov    %eax,%ebx
  80334a:	ff 75 10             	pushl  0x10(%ebp)
  80334d:	e8 59 f1 ff ff       	call   8024ab <get_block_size>
  803352:	83 c4 04             	add    $0x4,%esp
  803355:	01 c3                	add    %eax,%ebx
  803357:	ff 75 0c             	pushl  0xc(%ebp)
  80335a:	e8 4c f1 ff ff       	call   8024ab <get_block_size>
  80335f:	83 c4 04             	add    $0x4,%esp
  803362:	01 d8                	add    %ebx,%eax
  803364:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803367:	6a 00                	push   $0x0
  803369:	ff 75 ec             	pushl  -0x14(%ebp)
  80336c:	ff 75 08             	pushl  0x8(%ebp)
  80336f:	e8 88 f4 ff ff       	call   8027fc <set_block_data>
  803374:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803377:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80337b:	75 17                	jne    803394 <merging+0xc8>
  80337d:	83 ec 04             	sub    $0x4,%esp
  803380:	68 9f 4a 80 00       	push   $0x804a9f
  803385:	68 7d 01 00 00       	push   $0x17d
  80338a:	68 bd 4a 80 00       	push   $0x804abd
  80338f:	e8 b7 d3 ff ff       	call   80074b <_panic>
  803394:	8b 45 0c             	mov    0xc(%ebp),%eax
  803397:	8b 00                	mov    (%eax),%eax
  803399:	85 c0                	test   %eax,%eax
  80339b:	74 10                	je     8033ad <merging+0xe1>
  80339d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a0:	8b 00                	mov    (%eax),%eax
  8033a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033a5:	8b 52 04             	mov    0x4(%edx),%edx
  8033a8:	89 50 04             	mov    %edx,0x4(%eax)
  8033ab:	eb 0b                	jmp    8033b8 <merging+0xec>
  8033ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b0:	8b 40 04             	mov    0x4(%eax),%eax
  8033b3:	a3 34 50 80 00       	mov    %eax,0x805034
  8033b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033bb:	8b 40 04             	mov    0x4(%eax),%eax
  8033be:	85 c0                	test   %eax,%eax
  8033c0:	74 0f                	je     8033d1 <merging+0x105>
  8033c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c5:	8b 40 04             	mov    0x4(%eax),%eax
  8033c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033cb:	8b 12                	mov    (%edx),%edx
  8033cd:	89 10                	mov    %edx,(%eax)
  8033cf:	eb 0a                	jmp    8033db <merging+0x10f>
  8033d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d4:	8b 00                	mov    (%eax),%eax
  8033d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8033db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ee:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8033f3:	48                   	dec    %eax
  8033f4:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8033f9:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8033fa:	e9 ea 02 00 00       	jmp    8036e9 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8033ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803403:	74 3b                	je     803440 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803405:	83 ec 0c             	sub    $0xc,%esp
  803408:	ff 75 08             	pushl  0x8(%ebp)
  80340b:	e8 9b f0 ff ff       	call   8024ab <get_block_size>
  803410:	83 c4 10             	add    $0x10,%esp
  803413:	89 c3                	mov    %eax,%ebx
  803415:	83 ec 0c             	sub    $0xc,%esp
  803418:	ff 75 10             	pushl  0x10(%ebp)
  80341b:	e8 8b f0 ff ff       	call   8024ab <get_block_size>
  803420:	83 c4 10             	add    $0x10,%esp
  803423:	01 d8                	add    %ebx,%eax
  803425:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803428:	83 ec 04             	sub    $0x4,%esp
  80342b:	6a 00                	push   $0x0
  80342d:	ff 75 e8             	pushl  -0x18(%ebp)
  803430:	ff 75 08             	pushl  0x8(%ebp)
  803433:	e8 c4 f3 ff ff       	call   8027fc <set_block_data>
  803438:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80343b:	e9 a9 02 00 00       	jmp    8036e9 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803440:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803444:	0f 84 2d 01 00 00    	je     803577 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80344a:	83 ec 0c             	sub    $0xc,%esp
  80344d:	ff 75 10             	pushl  0x10(%ebp)
  803450:	e8 56 f0 ff ff       	call   8024ab <get_block_size>
  803455:	83 c4 10             	add    $0x10,%esp
  803458:	89 c3                	mov    %eax,%ebx
  80345a:	83 ec 0c             	sub    $0xc,%esp
  80345d:	ff 75 0c             	pushl  0xc(%ebp)
  803460:	e8 46 f0 ff ff       	call   8024ab <get_block_size>
  803465:	83 c4 10             	add    $0x10,%esp
  803468:	01 d8                	add    %ebx,%eax
  80346a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80346d:	83 ec 04             	sub    $0x4,%esp
  803470:	6a 00                	push   $0x0
  803472:	ff 75 e4             	pushl  -0x1c(%ebp)
  803475:	ff 75 10             	pushl  0x10(%ebp)
  803478:	e8 7f f3 ff ff       	call   8027fc <set_block_data>
  80347d:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803480:	8b 45 10             	mov    0x10(%ebp),%eax
  803483:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803486:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80348a:	74 06                	je     803492 <merging+0x1c6>
  80348c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803490:	75 17                	jne    8034a9 <merging+0x1dd>
  803492:	83 ec 04             	sub    $0x4,%esp
  803495:	68 78 4b 80 00       	push   $0x804b78
  80349a:	68 8d 01 00 00       	push   $0x18d
  80349f:	68 bd 4a 80 00       	push   $0x804abd
  8034a4:	e8 a2 d2 ff ff       	call   80074b <_panic>
  8034a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ac:	8b 50 04             	mov    0x4(%eax),%edx
  8034af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b2:	89 50 04             	mov    %edx,0x4(%eax)
  8034b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034bb:	89 10                	mov    %edx,(%eax)
  8034bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c0:	8b 40 04             	mov    0x4(%eax),%eax
  8034c3:	85 c0                	test   %eax,%eax
  8034c5:	74 0d                	je     8034d4 <merging+0x208>
  8034c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ca:	8b 40 04             	mov    0x4(%eax),%eax
  8034cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034d0:	89 10                	mov    %edx,(%eax)
  8034d2:	eb 08                	jmp    8034dc <merging+0x210>
  8034d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034d7:	a3 30 50 80 00       	mov    %eax,0x805030
  8034dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034e2:	89 50 04             	mov    %edx,0x4(%eax)
  8034e5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034ea:	40                   	inc    %eax
  8034eb:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  8034f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034f4:	75 17                	jne    80350d <merging+0x241>
  8034f6:	83 ec 04             	sub    $0x4,%esp
  8034f9:	68 9f 4a 80 00       	push   $0x804a9f
  8034fe:	68 8e 01 00 00       	push   $0x18e
  803503:	68 bd 4a 80 00       	push   $0x804abd
  803508:	e8 3e d2 ff ff       	call   80074b <_panic>
  80350d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803510:	8b 00                	mov    (%eax),%eax
  803512:	85 c0                	test   %eax,%eax
  803514:	74 10                	je     803526 <merging+0x25a>
  803516:	8b 45 0c             	mov    0xc(%ebp),%eax
  803519:	8b 00                	mov    (%eax),%eax
  80351b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80351e:	8b 52 04             	mov    0x4(%edx),%edx
  803521:	89 50 04             	mov    %edx,0x4(%eax)
  803524:	eb 0b                	jmp    803531 <merging+0x265>
  803526:	8b 45 0c             	mov    0xc(%ebp),%eax
  803529:	8b 40 04             	mov    0x4(%eax),%eax
  80352c:	a3 34 50 80 00       	mov    %eax,0x805034
  803531:	8b 45 0c             	mov    0xc(%ebp),%eax
  803534:	8b 40 04             	mov    0x4(%eax),%eax
  803537:	85 c0                	test   %eax,%eax
  803539:	74 0f                	je     80354a <merging+0x27e>
  80353b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80353e:	8b 40 04             	mov    0x4(%eax),%eax
  803541:	8b 55 0c             	mov    0xc(%ebp),%edx
  803544:	8b 12                	mov    (%edx),%edx
  803546:	89 10                	mov    %edx,(%eax)
  803548:	eb 0a                	jmp    803554 <merging+0x288>
  80354a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80354d:	8b 00                	mov    (%eax),%eax
  80354f:	a3 30 50 80 00       	mov    %eax,0x805030
  803554:	8b 45 0c             	mov    0xc(%ebp),%eax
  803557:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80355d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803560:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803567:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80356c:	48                   	dec    %eax
  80356d:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803572:	e9 72 01 00 00       	jmp    8036e9 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803577:	8b 45 10             	mov    0x10(%ebp),%eax
  80357a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80357d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803581:	74 79                	je     8035fc <merging+0x330>
  803583:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803587:	74 73                	je     8035fc <merging+0x330>
  803589:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80358d:	74 06                	je     803595 <merging+0x2c9>
  80358f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803593:	75 17                	jne    8035ac <merging+0x2e0>
  803595:	83 ec 04             	sub    $0x4,%esp
  803598:	68 30 4b 80 00       	push   $0x804b30
  80359d:	68 94 01 00 00       	push   $0x194
  8035a2:	68 bd 4a 80 00       	push   $0x804abd
  8035a7:	e8 9f d1 ff ff       	call   80074b <_panic>
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	8b 10                	mov    (%eax),%edx
  8035b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035b4:	89 10                	mov    %edx,(%eax)
  8035b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035b9:	8b 00                	mov    (%eax),%eax
  8035bb:	85 c0                	test   %eax,%eax
  8035bd:	74 0b                	je     8035ca <merging+0x2fe>
  8035bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c2:	8b 00                	mov    (%eax),%eax
  8035c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035c7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035d0:	89 10                	mov    %edx,(%eax)
  8035d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d8:	89 50 04             	mov    %edx,0x4(%eax)
  8035db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035de:	8b 00                	mov    (%eax),%eax
  8035e0:	85 c0                	test   %eax,%eax
  8035e2:	75 08                	jne    8035ec <merging+0x320>
  8035e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035e7:	a3 34 50 80 00       	mov    %eax,0x805034
  8035ec:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035f1:	40                   	inc    %eax
  8035f2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035f7:	e9 ce 00 00 00       	jmp    8036ca <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8035fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803600:	74 65                	je     803667 <merging+0x39b>
  803602:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803606:	75 17                	jne    80361f <merging+0x353>
  803608:	83 ec 04             	sub    $0x4,%esp
  80360b:	68 0c 4b 80 00       	push   $0x804b0c
  803610:	68 95 01 00 00       	push   $0x195
  803615:	68 bd 4a 80 00       	push   $0x804abd
  80361a:	e8 2c d1 ff ff       	call   80074b <_panic>
  80361f:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803625:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803628:	89 50 04             	mov    %edx,0x4(%eax)
  80362b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80362e:	8b 40 04             	mov    0x4(%eax),%eax
  803631:	85 c0                	test   %eax,%eax
  803633:	74 0c                	je     803641 <merging+0x375>
  803635:	a1 34 50 80 00       	mov    0x805034,%eax
  80363a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80363d:	89 10                	mov    %edx,(%eax)
  80363f:	eb 08                	jmp    803649 <merging+0x37d>
  803641:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803644:	a3 30 50 80 00       	mov    %eax,0x805030
  803649:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80364c:	a3 34 50 80 00       	mov    %eax,0x805034
  803651:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803654:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80365a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80365f:	40                   	inc    %eax
  803660:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803665:	eb 63                	jmp    8036ca <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803667:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80366b:	75 17                	jne    803684 <merging+0x3b8>
  80366d:	83 ec 04             	sub    $0x4,%esp
  803670:	68 d8 4a 80 00       	push   $0x804ad8
  803675:	68 98 01 00 00       	push   $0x198
  80367a:	68 bd 4a 80 00       	push   $0x804abd
  80367f:	e8 c7 d0 ff ff       	call   80074b <_panic>
  803684:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80368a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80368d:	89 10                	mov    %edx,(%eax)
  80368f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803692:	8b 00                	mov    (%eax),%eax
  803694:	85 c0                	test   %eax,%eax
  803696:	74 0d                	je     8036a5 <merging+0x3d9>
  803698:	a1 30 50 80 00       	mov    0x805030,%eax
  80369d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036a0:	89 50 04             	mov    %edx,0x4(%eax)
  8036a3:	eb 08                	jmp    8036ad <merging+0x3e1>
  8036a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036a8:	a3 34 50 80 00       	mov    %eax,0x805034
  8036ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8036b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036bf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036c4:	40                   	inc    %eax
  8036c5:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  8036ca:	83 ec 0c             	sub    $0xc,%esp
  8036cd:	ff 75 10             	pushl  0x10(%ebp)
  8036d0:	e8 d6 ed ff ff       	call   8024ab <get_block_size>
  8036d5:	83 c4 10             	add    $0x10,%esp
  8036d8:	83 ec 04             	sub    $0x4,%esp
  8036db:	6a 00                	push   $0x0
  8036dd:	50                   	push   %eax
  8036de:	ff 75 10             	pushl  0x10(%ebp)
  8036e1:	e8 16 f1 ff ff       	call   8027fc <set_block_data>
  8036e6:	83 c4 10             	add    $0x10,%esp
	}
}
  8036e9:	90                   	nop
  8036ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8036ed:	c9                   	leave  
  8036ee:	c3                   	ret    

008036ef <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8036ef:	55                   	push   %ebp
  8036f0:	89 e5                	mov    %esp,%ebp
  8036f2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8036f5:	a1 30 50 80 00       	mov    0x805030,%eax
  8036fa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8036fd:	a1 34 50 80 00       	mov    0x805034,%eax
  803702:	3b 45 08             	cmp    0x8(%ebp),%eax
  803705:	73 1b                	jae    803722 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803707:	a1 34 50 80 00       	mov    0x805034,%eax
  80370c:	83 ec 04             	sub    $0x4,%esp
  80370f:	ff 75 08             	pushl  0x8(%ebp)
  803712:	6a 00                	push   $0x0
  803714:	50                   	push   %eax
  803715:	e8 b2 fb ff ff       	call   8032cc <merging>
  80371a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80371d:	e9 8b 00 00 00       	jmp    8037ad <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803722:	a1 30 50 80 00       	mov    0x805030,%eax
  803727:	3b 45 08             	cmp    0x8(%ebp),%eax
  80372a:	76 18                	jbe    803744 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80372c:	a1 30 50 80 00       	mov    0x805030,%eax
  803731:	83 ec 04             	sub    $0x4,%esp
  803734:	ff 75 08             	pushl  0x8(%ebp)
  803737:	50                   	push   %eax
  803738:	6a 00                	push   $0x0
  80373a:	e8 8d fb ff ff       	call   8032cc <merging>
  80373f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803742:	eb 69                	jmp    8037ad <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803744:	a1 30 50 80 00       	mov    0x805030,%eax
  803749:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80374c:	eb 39                	jmp    803787 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80374e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803751:	3b 45 08             	cmp    0x8(%ebp),%eax
  803754:	73 29                	jae    80377f <free_block+0x90>
  803756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803759:	8b 00                	mov    (%eax),%eax
  80375b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80375e:	76 1f                	jbe    80377f <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803763:	8b 00                	mov    (%eax),%eax
  803765:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803768:	83 ec 04             	sub    $0x4,%esp
  80376b:	ff 75 08             	pushl  0x8(%ebp)
  80376e:	ff 75 f0             	pushl  -0x10(%ebp)
  803771:	ff 75 f4             	pushl  -0xc(%ebp)
  803774:	e8 53 fb ff ff       	call   8032cc <merging>
  803779:	83 c4 10             	add    $0x10,%esp
			break;
  80377c:	90                   	nop
		}
	}
}
  80377d:	eb 2e                	jmp    8037ad <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80377f:	a1 38 50 80 00       	mov    0x805038,%eax
  803784:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803787:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80378b:	74 07                	je     803794 <free_block+0xa5>
  80378d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803790:	8b 00                	mov    (%eax),%eax
  803792:	eb 05                	jmp    803799 <free_block+0xaa>
  803794:	b8 00 00 00 00       	mov    $0x0,%eax
  803799:	a3 38 50 80 00       	mov    %eax,0x805038
  80379e:	a1 38 50 80 00       	mov    0x805038,%eax
  8037a3:	85 c0                	test   %eax,%eax
  8037a5:	75 a7                	jne    80374e <free_block+0x5f>
  8037a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ab:	75 a1                	jne    80374e <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037ad:	90                   	nop
  8037ae:	c9                   	leave  
  8037af:	c3                   	ret    

008037b0 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8037b0:	55                   	push   %ebp
  8037b1:	89 e5                	mov    %esp,%ebp
  8037b3:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8037b6:	ff 75 08             	pushl  0x8(%ebp)
  8037b9:	e8 ed ec ff ff       	call   8024ab <get_block_size>
  8037be:	83 c4 04             	add    $0x4,%esp
  8037c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8037c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8037cb:	eb 17                	jmp    8037e4 <copy_data+0x34>
  8037cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8037d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d3:	01 c2                	add    %eax,%edx
  8037d5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8037d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037db:	01 c8                	add    %ecx,%eax
  8037dd:	8a 00                	mov    (%eax),%al
  8037df:	88 02                	mov    %al,(%edx)
  8037e1:	ff 45 fc             	incl   -0x4(%ebp)
  8037e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037e7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8037ea:	72 e1                	jb     8037cd <copy_data+0x1d>
}
  8037ec:	90                   	nop
  8037ed:	c9                   	leave  
  8037ee:	c3                   	ret    

008037ef <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8037ef:	55                   	push   %ebp
  8037f0:	89 e5                	mov    %esp,%ebp
  8037f2:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8037f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037f9:	75 23                	jne    80381e <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8037fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037ff:	74 13                	je     803814 <realloc_block_FF+0x25>
  803801:	83 ec 0c             	sub    $0xc,%esp
  803804:	ff 75 0c             	pushl  0xc(%ebp)
  803807:	e8 1f f0 ff ff       	call   80282b <alloc_block_FF>
  80380c:	83 c4 10             	add    $0x10,%esp
  80380f:	e9 f4 06 00 00       	jmp    803f08 <realloc_block_FF+0x719>
		return NULL;
  803814:	b8 00 00 00 00       	mov    $0x0,%eax
  803819:	e9 ea 06 00 00       	jmp    803f08 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80381e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803822:	75 18                	jne    80383c <realloc_block_FF+0x4d>
	{
		free_block(va);
  803824:	83 ec 0c             	sub    $0xc,%esp
  803827:	ff 75 08             	pushl  0x8(%ebp)
  80382a:	e8 c0 fe ff ff       	call   8036ef <free_block>
  80382f:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803832:	b8 00 00 00 00       	mov    $0x0,%eax
  803837:	e9 cc 06 00 00       	jmp    803f08 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80383c:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803840:	77 07                	ja     803849 <realloc_block_FF+0x5a>
  803842:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80384c:	83 e0 01             	and    $0x1,%eax
  80384f:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803852:	8b 45 0c             	mov    0xc(%ebp),%eax
  803855:	83 c0 08             	add    $0x8,%eax
  803858:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80385b:	83 ec 0c             	sub    $0xc,%esp
  80385e:	ff 75 08             	pushl  0x8(%ebp)
  803861:	e8 45 ec ff ff       	call   8024ab <get_block_size>
  803866:	83 c4 10             	add    $0x10,%esp
  803869:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80386c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80386f:	83 e8 08             	sub    $0x8,%eax
  803872:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803875:	8b 45 08             	mov    0x8(%ebp),%eax
  803878:	83 e8 04             	sub    $0x4,%eax
  80387b:	8b 00                	mov    (%eax),%eax
  80387d:	83 e0 fe             	and    $0xfffffffe,%eax
  803880:	89 c2                	mov    %eax,%edx
  803882:	8b 45 08             	mov    0x8(%ebp),%eax
  803885:	01 d0                	add    %edx,%eax
  803887:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80388a:	83 ec 0c             	sub    $0xc,%esp
  80388d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803890:	e8 16 ec ff ff       	call   8024ab <get_block_size>
  803895:	83 c4 10             	add    $0x10,%esp
  803898:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80389b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80389e:	83 e8 08             	sub    $0x8,%eax
  8038a1:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8038a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038a7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038aa:	75 08                	jne    8038b4 <realloc_block_FF+0xc5>
	{
		 return va;
  8038ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8038af:	e9 54 06 00 00       	jmp    803f08 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8038b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038ba:	0f 83 e5 03 00 00    	jae    803ca5 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8038c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c3:	2b 45 0c             	sub    0xc(%ebp),%eax
  8038c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8038c9:	83 ec 0c             	sub    $0xc,%esp
  8038cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038cf:	e8 f0 eb ff ff       	call   8024c4 <is_free_block>
  8038d4:	83 c4 10             	add    $0x10,%esp
  8038d7:	84 c0                	test   %al,%al
  8038d9:	0f 84 3b 01 00 00    	je     803a1a <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8038df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038e5:	01 d0                	add    %edx,%eax
  8038e7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8038ea:	83 ec 04             	sub    $0x4,%esp
  8038ed:	6a 01                	push   $0x1
  8038ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8038f2:	ff 75 08             	pushl  0x8(%ebp)
  8038f5:	e8 02 ef ff ff       	call   8027fc <set_block_data>
  8038fa:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8038fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803900:	83 e8 04             	sub    $0x4,%eax
  803903:	8b 00                	mov    (%eax),%eax
  803905:	83 e0 fe             	and    $0xfffffffe,%eax
  803908:	89 c2                	mov    %eax,%edx
  80390a:	8b 45 08             	mov    0x8(%ebp),%eax
  80390d:	01 d0                	add    %edx,%eax
  80390f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803912:	83 ec 04             	sub    $0x4,%esp
  803915:	6a 00                	push   $0x0
  803917:	ff 75 cc             	pushl  -0x34(%ebp)
  80391a:	ff 75 c8             	pushl  -0x38(%ebp)
  80391d:	e8 da ee ff ff       	call   8027fc <set_block_data>
  803922:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803925:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803929:	74 06                	je     803931 <realloc_block_FF+0x142>
  80392b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80392f:	75 17                	jne    803948 <realloc_block_FF+0x159>
  803931:	83 ec 04             	sub    $0x4,%esp
  803934:	68 30 4b 80 00       	push   $0x804b30
  803939:	68 f6 01 00 00       	push   $0x1f6
  80393e:	68 bd 4a 80 00       	push   $0x804abd
  803943:	e8 03 ce ff ff       	call   80074b <_panic>
  803948:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394b:	8b 10                	mov    (%eax),%edx
  80394d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803950:	89 10                	mov    %edx,(%eax)
  803952:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803955:	8b 00                	mov    (%eax),%eax
  803957:	85 c0                	test   %eax,%eax
  803959:	74 0b                	je     803966 <realloc_block_FF+0x177>
  80395b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395e:	8b 00                	mov    (%eax),%eax
  803960:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803963:	89 50 04             	mov    %edx,0x4(%eax)
  803966:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803969:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80396c:	89 10                	mov    %edx,(%eax)
  80396e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803971:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803974:	89 50 04             	mov    %edx,0x4(%eax)
  803977:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80397a:	8b 00                	mov    (%eax),%eax
  80397c:	85 c0                	test   %eax,%eax
  80397e:	75 08                	jne    803988 <realloc_block_FF+0x199>
  803980:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803983:	a3 34 50 80 00       	mov    %eax,0x805034
  803988:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80398d:	40                   	inc    %eax
  80398e:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803993:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803997:	75 17                	jne    8039b0 <realloc_block_FF+0x1c1>
  803999:	83 ec 04             	sub    $0x4,%esp
  80399c:	68 9f 4a 80 00       	push   $0x804a9f
  8039a1:	68 f7 01 00 00       	push   $0x1f7
  8039a6:	68 bd 4a 80 00       	push   $0x804abd
  8039ab:	e8 9b cd ff ff       	call   80074b <_panic>
  8039b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b3:	8b 00                	mov    (%eax),%eax
  8039b5:	85 c0                	test   %eax,%eax
  8039b7:	74 10                	je     8039c9 <realloc_block_FF+0x1da>
  8039b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bc:	8b 00                	mov    (%eax),%eax
  8039be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039c1:	8b 52 04             	mov    0x4(%edx),%edx
  8039c4:	89 50 04             	mov    %edx,0x4(%eax)
  8039c7:	eb 0b                	jmp    8039d4 <realloc_block_FF+0x1e5>
  8039c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cc:	8b 40 04             	mov    0x4(%eax),%eax
  8039cf:	a3 34 50 80 00       	mov    %eax,0x805034
  8039d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d7:	8b 40 04             	mov    0x4(%eax),%eax
  8039da:	85 c0                	test   %eax,%eax
  8039dc:	74 0f                	je     8039ed <realloc_block_FF+0x1fe>
  8039de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e1:	8b 40 04             	mov    0x4(%eax),%eax
  8039e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039e7:	8b 12                	mov    (%edx),%edx
  8039e9:	89 10                	mov    %edx,(%eax)
  8039eb:	eb 0a                	jmp    8039f7 <realloc_block_FF+0x208>
  8039ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f0:	8b 00                	mov    (%eax),%eax
  8039f2:	a3 30 50 80 00       	mov    %eax,0x805030
  8039f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a0a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a0f:	48                   	dec    %eax
  803a10:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a15:	e9 83 02 00 00       	jmp    803c9d <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803a1a:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803a1e:	0f 86 69 02 00 00    	jbe    803c8d <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803a24:	83 ec 04             	sub    $0x4,%esp
  803a27:	6a 01                	push   $0x1
  803a29:	ff 75 f0             	pushl  -0x10(%ebp)
  803a2c:	ff 75 08             	pushl  0x8(%ebp)
  803a2f:	e8 c8 ed ff ff       	call   8027fc <set_block_data>
  803a34:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a37:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3a:	83 e8 04             	sub    $0x4,%eax
  803a3d:	8b 00                	mov    (%eax),%eax
  803a3f:	83 e0 fe             	and    $0xfffffffe,%eax
  803a42:	89 c2                	mov    %eax,%edx
  803a44:	8b 45 08             	mov    0x8(%ebp),%eax
  803a47:	01 d0                	add    %edx,%eax
  803a49:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803a4c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a51:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803a54:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803a58:	75 68                	jne    803ac2 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a5a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a5e:	75 17                	jne    803a77 <realloc_block_FF+0x288>
  803a60:	83 ec 04             	sub    $0x4,%esp
  803a63:	68 d8 4a 80 00       	push   $0x804ad8
  803a68:	68 06 02 00 00       	push   $0x206
  803a6d:	68 bd 4a 80 00       	push   $0x804abd
  803a72:	e8 d4 cc ff ff       	call   80074b <_panic>
  803a77:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a80:	89 10                	mov    %edx,(%eax)
  803a82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a85:	8b 00                	mov    (%eax),%eax
  803a87:	85 c0                	test   %eax,%eax
  803a89:	74 0d                	je     803a98 <realloc_block_FF+0x2a9>
  803a8b:	a1 30 50 80 00       	mov    0x805030,%eax
  803a90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a93:	89 50 04             	mov    %edx,0x4(%eax)
  803a96:	eb 08                	jmp    803aa0 <realloc_block_FF+0x2b1>
  803a98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a9b:	a3 34 50 80 00       	mov    %eax,0x805034
  803aa0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aa3:	a3 30 50 80 00       	mov    %eax,0x805030
  803aa8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ab2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ab7:	40                   	inc    %eax
  803ab8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803abd:	e9 b0 01 00 00       	jmp    803c72 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803ac2:	a1 30 50 80 00       	mov    0x805030,%eax
  803ac7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803aca:	76 68                	jbe    803b34 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803acc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ad0:	75 17                	jne    803ae9 <realloc_block_FF+0x2fa>
  803ad2:	83 ec 04             	sub    $0x4,%esp
  803ad5:	68 d8 4a 80 00       	push   $0x804ad8
  803ada:	68 0b 02 00 00       	push   $0x20b
  803adf:	68 bd 4a 80 00       	push   $0x804abd
  803ae4:	e8 62 cc ff ff       	call   80074b <_panic>
  803ae9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803aef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803af2:	89 10                	mov    %edx,(%eax)
  803af4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803af7:	8b 00                	mov    (%eax),%eax
  803af9:	85 c0                	test   %eax,%eax
  803afb:	74 0d                	je     803b0a <realloc_block_FF+0x31b>
  803afd:	a1 30 50 80 00       	mov    0x805030,%eax
  803b02:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b05:	89 50 04             	mov    %edx,0x4(%eax)
  803b08:	eb 08                	jmp    803b12 <realloc_block_FF+0x323>
  803b0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b0d:	a3 34 50 80 00       	mov    %eax,0x805034
  803b12:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b15:	a3 30 50 80 00       	mov    %eax,0x805030
  803b1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b24:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b29:	40                   	inc    %eax
  803b2a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b2f:	e9 3e 01 00 00       	jmp    803c72 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803b34:	a1 30 50 80 00       	mov    0x805030,%eax
  803b39:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b3c:	73 68                	jae    803ba6 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b3e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b42:	75 17                	jne    803b5b <realloc_block_FF+0x36c>
  803b44:	83 ec 04             	sub    $0x4,%esp
  803b47:	68 0c 4b 80 00       	push   $0x804b0c
  803b4c:	68 10 02 00 00       	push   $0x210
  803b51:	68 bd 4a 80 00       	push   $0x804abd
  803b56:	e8 f0 cb ff ff       	call   80074b <_panic>
  803b5b:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803b61:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b64:	89 50 04             	mov    %edx,0x4(%eax)
  803b67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b6a:	8b 40 04             	mov    0x4(%eax),%eax
  803b6d:	85 c0                	test   %eax,%eax
  803b6f:	74 0c                	je     803b7d <realloc_block_FF+0x38e>
  803b71:	a1 34 50 80 00       	mov    0x805034,%eax
  803b76:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b79:	89 10                	mov    %edx,(%eax)
  803b7b:	eb 08                	jmp    803b85 <realloc_block_FF+0x396>
  803b7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b80:	a3 30 50 80 00       	mov    %eax,0x805030
  803b85:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b88:	a3 34 50 80 00       	mov    %eax,0x805034
  803b8d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b96:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b9b:	40                   	inc    %eax
  803b9c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803ba1:	e9 cc 00 00 00       	jmp    803c72 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803ba6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803bad:	a1 30 50 80 00       	mov    0x805030,%eax
  803bb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bb5:	e9 8a 00 00 00       	jmp    803c44 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bbd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bc0:	73 7a                	jae    803c3c <realloc_block_FF+0x44d>
  803bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc5:	8b 00                	mov    (%eax),%eax
  803bc7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bca:	73 70                	jae    803c3c <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803bcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bd0:	74 06                	je     803bd8 <realloc_block_FF+0x3e9>
  803bd2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bd6:	75 17                	jne    803bef <realloc_block_FF+0x400>
  803bd8:	83 ec 04             	sub    $0x4,%esp
  803bdb:	68 30 4b 80 00       	push   $0x804b30
  803be0:	68 1a 02 00 00       	push   $0x21a
  803be5:	68 bd 4a 80 00       	push   $0x804abd
  803bea:	e8 5c cb ff ff       	call   80074b <_panic>
  803bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf2:	8b 10                	mov    (%eax),%edx
  803bf4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bf7:	89 10                	mov    %edx,(%eax)
  803bf9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bfc:	8b 00                	mov    (%eax),%eax
  803bfe:	85 c0                	test   %eax,%eax
  803c00:	74 0b                	je     803c0d <realloc_block_FF+0x41e>
  803c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c05:	8b 00                	mov    (%eax),%eax
  803c07:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c0a:	89 50 04             	mov    %edx,0x4(%eax)
  803c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c10:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c13:	89 10                	mov    %edx,(%eax)
  803c15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c1b:	89 50 04             	mov    %edx,0x4(%eax)
  803c1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c21:	8b 00                	mov    (%eax),%eax
  803c23:	85 c0                	test   %eax,%eax
  803c25:	75 08                	jne    803c2f <realloc_block_FF+0x440>
  803c27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c2a:	a3 34 50 80 00       	mov    %eax,0x805034
  803c2f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c34:	40                   	inc    %eax
  803c35:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803c3a:	eb 36                	jmp    803c72 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803c3c:	a1 38 50 80 00       	mov    0x805038,%eax
  803c41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c48:	74 07                	je     803c51 <realloc_block_FF+0x462>
  803c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4d:	8b 00                	mov    (%eax),%eax
  803c4f:	eb 05                	jmp    803c56 <realloc_block_FF+0x467>
  803c51:	b8 00 00 00 00       	mov    $0x0,%eax
  803c56:	a3 38 50 80 00       	mov    %eax,0x805038
  803c5b:	a1 38 50 80 00       	mov    0x805038,%eax
  803c60:	85 c0                	test   %eax,%eax
  803c62:	0f 85 52 ff ff ff    	jne    803bba <realloc_block_FF+0x3cb>
  803c68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c6c:	0f 85 48 ff ff ff    	jne    803bba <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803c72:	83 ec 04             	sub    $0x4,%esp
  803c75:	6a 00                	push   $0x0
  803c77:	ff 75 d8             	pushl  -0x28(%ebp)
  803c7a:	ff 75 d4             	pushl  -0x2c(%ebp)
  803c7d:	e8 7a eb ff ff       	call   8027fc <set_block_data>
  803c82:	83 c4 10             	add    $0x10,%esp
				return va;
  803c85:	8b 45 08             	mov    0x8(%ebp),%eax
  803c88:	e9 7b 02 00 00       	jmp    803f08 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803c8d:	83 ec 0c             	sub    $0xc,%esp
  803c90:	68 ad 4b 80 00       	push   $0x804bad
  803c95:	e8 6e cd ff ff       	call   800a08 <cprintf>
  803c9a:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca0:	e9 63 02 00 00       	jmp    803f08 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803ca5:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ca8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803cab:	0f 86 4d 02 00 00    	jbe    803efe <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803cb1:	83 ec 0c             	sub    $0xc,%esp
  803cb4:	ff 75 e4             	pushl  -0x1c(%ebp)
  803cb7:	e8 08 e8 ff ff       	call   8024c4 <is_free_block>
  803cbc:	83 c4 10             	add    $0x10,%esp
  803cbf:	84 c0                	test   %al,%al
  803cc1:	0f 84 37 02 00 00    	je     803efe <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cca:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803ccd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803cd0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803cd3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803cd6:	76 38                	jbe    803d10 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803cd8:	83 ec 0c             	sub    $0xc,%esp
  803cdb:	ff 75 08             	pushl  0x8(%ebp)
  803cde:	e8 0c fa ff ff       	call   8036ef <free_block>
  803ce3:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803ce6:	83 ec 0c             	sub    $0xc,%esp
  803ce9:	ff 75 0c             	pushl  0xc(%ebp)
  803cec:	e8 3a eb ff ff       	call   80282b <alloc_block_FF>
  803cf1:	83 c4 10             	add    $0x10,%esp
  803cf4:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803cf7:	83 ec 08             	sub    $0x8,%esp
  803cfa:	ff 75 c0             	pushl  -0x40(%ebp)
  803cfd:	ff 75 08             	pushl  0x8(%ebp)
  803d00:	e8 ab fa ff ff       	call   8037b0 <copy_data>
  803d05:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803d08:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803d0b:	e9 f8 01 00 00       	jmp    803f08 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803d10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d13:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803d16:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803d19:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803d1d:	0f 87 a0 00 00 00    	ja     803dc3 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803d23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d27:	75 17                	jne    803d40 <realloc_block_FF+0x551>
  803d29:	83 ec 04             	sub    $0x4,%esp
  803d2c:	68 9f 4a 80 00       	push   $0x804a9f
  803d31:	68 38 02 00 00       	push   $0x238
  803d36:	68 bd 4a 80 00       	push   $0x804abd
  803d3b:	e8 0b ca ff ff       	call   80074b <_panic>
  803d40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d43:	8b 00                	mov    (%eax),%eax
  803d45:	85 c0                	test   %eax,%eax
  803d47:	74 10                	je     803d59 <realloc_block_FF+0x56a>
  803d49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4c:	8b 00                	mov    (%eax),%eax
  803d4e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d51:	8b 52 04             	mov    0x4(%edx),%edx
  803d54:	89 50 04             	mov    %edx,0x4(%eax)
  803d57:	eb 0b                	jmp    803d64 <realloc_block_FF+0x575>
  803d59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d5c:	8b 40 04             	mov    0x4(%eax),%eax
  803d5f:	a3 34 50 80 00       	mov    %eax,0x805034
  803d64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d67:	8b 40 04             	mov    0x4(%eax),%eax
  803d6a:	85 c0                	test   %eax,%eax
  803d6c:	74 0f                	je     803d7d <realloc_block_FF+0x58e>
  803d6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d71:	8b 40 04             	mov    0x4(%eax),%eax
  803d74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d77:	8b 12                	mov    (%edx),%edx
  803d79:	89 10                	mov    %edx,(%eax)
  803d7b:	eb 0a                	jmp    803d87 <realloc_block_FF+0x598>
  803d7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d80:	8b 00                	mov    (%eax),%eax
  803d82:	a3 30 50 80 00       	mov    %eax,0x805030
  803d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d9a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d9f:	48                   	dec    %eax
  803da0:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803da5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dab:	01 d0                	add    %edx,%eax
  803dad:	83 ec 04             	sub    $0x4,%esp
  803db0:	6a 01                	push   $0x1
  803db2:	50                   	push   %eax
  803db3:	ff 75 08             	pushl  0x8(%ebp)
  803db6:	e8 41 ea ff ff       	call   8027fc <set_block_data>
  803dbb:	83 c4 10             	add    $0x10,%esp
  803dbe:	e9 36 01 00 00       	jmp    803ef9 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803dc3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803dc6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803dc9:	01 d0                	add    %edx,%eax
  803dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803dce:	83 ec 04             	sub    $0x4,%esp
  803dd1:	6a 01                	push   $0x1
  803dd3:	ff 75 f0             	pushl  -0x10(%ebp)
  803dd6:	ff 75 08             	pushl  0x8(%ebp)
  803dd9:	e8 1e ea ff ff       	call   8027fc <set_block_data>
  803dde:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803de1:	8b 45 08             	mov    0x8(%ebp),%eax
  803de4:	83 e8 04             	sub    $0x4,%eax
  803de7:	8b 00                	mov    (%eax),%eax
  803de9:	83 e0 fe             	and    $0xfffffffe,%eax
  803dec:	89 c2                	mov    %eax,%edx
  803dee:	8b 45 08             	mov    0x8(%ebp),%eax
  803df1:	01 d0                	add    %edx,%eax
  803df3:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803df6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803dfa:	74 06                	je     803e02 <realloc_block_FF+0x613>
  803dfc:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803e00:	75 17                	jne    803e19 <realloc_block_FF+0x62a>
  803e02:	83 ec 04             	sub    $0x4,%esp
  803e05:	68 30 4b 80 00       	push   $0x804b30
  803e0a:	68 44 02 00 00       	push   $0x244
  803e0f:	68 bd 4a 80 00       	push   $0x804abd
  803e14:	e8 32 c9 ff ff       	call   80074b <_panic>
  803e19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e1c:	8b 10                	mov    (%eax),%edx
  803e1e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e21:	89 10                	mov    %edx,(%eax)
  803e23:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e26:	8b 00                	mov    (%eax),%eax
  803e28:	85 c0                	test   %eax,%eax
  803e2a:	74 0b                	je     803e37 <realloc_block_FF+0x648>
  803e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e2f:	8b 00                	mov    (%eax),%eax
  803e31:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e34:	89 50 04             	mov    %edx,0x4(%eax)
  803e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e3a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e3d:	89 10                	mov    %edx,(%eax)
  803e3f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e45:	89 50 04             	mov    %edx,0x4(%eax)
  803e48:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e4b:	8b 00                	mov    (%eax),%eax
  803e4d:	85 c0                	test   %eax,%eax
  803e4f:	75 08                	jne    803e59 <realloc_block_FF+0x66a>
  803e51:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e54:	a3 34 50 80 00       	mov    %eax,0x805034
  803e59:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e5e:	40                   	inc    %eax
  803e5f:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803e64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e68:	75 17                	jne    803e81 <realloc_block_FF+0x692>
  803e6a:	83 ec 04             	sub    $0x4,%esp
  803e6d:	68 9f 4a 80 00       	push   $0x804a9f
  803e72:	68 45 02 00 00       	push   $0x245
  803e77:	68 bd 4a 80 00       	push   $0x804abd
  803e7c:	e8 ca c8 ff ff       	call   80074b <_panic>
  803e81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e84:	8b 00                	mov    (%eax),%eax
  803e86:	85 c0                	test   %eax,%eax
  803e88:	74 10                	je     803e9a <realloc_block_FF+0x6ab>
  803e8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e8d:	8b 00                	mov    (%eax),%eax
  803e8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e92:	8b 52 04             	mov    0x4(%edx),%edx
  803e95:	89 50 04             	mov    %edx,0x4(%eax)
  803e98:	eb 0b                	jmp    803ea5 <realloc_block_FF+0x6b6>
  803e9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e9d:	8b 40 04             	mov    0x4(%eax),%eax
  803ea0:	a3 34 50 80 00       	mov    %eax,0x805034
  803ea5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea8:	8b 40 04             	mov    0x4(%eax),%eax
  803eab:	85 c0                	test   %eax,%eax
  803ead:	74 0f                	je     803ebe <realloc_block_FF+0x6cf>
  803eaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb2:	8b 40 04             	mov    0x4(%eax),%eax
  803eb5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803eb8:	8b 12                	mov    (%edx),%edx
  803eba:	89 10                	mov    %edx,(%eax)
  803ebc:	eb 0a                	jmp    803ec8 <realloc_block_FF+0x6d9>
  803ebe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec1:	8b 00                	mov    (%eax),%eax
  803ec3:	a3 30 50 80 00       	mov    %eax,0x805030
  803ec8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ecb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ed1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803edb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ee0:	48                   	dec    %eax
  803ee1:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803ee6:	83 ec 04             	sub    $0x4,%esp
  803ee9:	6a 00                	push   $0x0
  803eeb:	ff 75 bc             	pushl  -0x44(%ebp)
  803eee:	ff 75 b8             	pushl  -0x48(%ebp)
  803ef1:	e8 06 e9 ff ff       	call   8027fc <set_block_data>
  803ef6:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  803efc:	eb 0a                	jmp    803f08 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803efe:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803f05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803f08:	c9                   	leave  
  803f09:	c3                   	ret    

00803f0a <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803f0a:	55                   	push   %ebp
  803f0b:	89 e5                	mov    %esp,%ebp
  803f0d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803f10:	83 ec 04             	sub    $0x4,%esp
  803f13:	68 b4 4b 80 00       	push   $0x804bb4
  803f18:	68 58 02 00 00       	push   $0x258
  803f1d:	68 bd 4a 80 00       	push   $0x804abd
  803f22:	e8 24 c8 ff ff       	call   80074b <_panic>

00803f27 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803f27:	55                   	push   %ebp
  803f28:	89 e5                	mov    %esp,%ebp
  803f2a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803f2d:	83 ec 04             	sub    $0x4,%esp
  803f30:	68 dc 4b 80 00       	push   $0x804bdc
  803f35:	68 61 02 00 00       	push   $0x261
  803f3a:	68 bd 4a 80 00       	push   $0x804abd
  803f3f:	e8 07 c8 ff ff       	call   80074b <_panic>

00803f44 <__udivdi3>:
  803f44:	55                   	push   %ebp
  803f45:	57                   	push   %edi
  803f46:	56                   	push   %esi
  803f47:	53                   	push   %ebx
  803f48:	83 ec 1c             	sub    $0x1c,%esp
  803f4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f5b:	89 ca                	mov    %ecx,%edx
  803f5d:	89 f8                	mov    %edi,%eax
  803f5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f63:	85 f6                	test   %esi,%esi
  803f65:	75 2d                	jne    803f94 <__udivdi3+0x50>
  803f67:	39 cf                	cmp    %ecx,%edi
  803f69:	77 65                	ja     803fd0 <__udivdi3+0x8c>
  803f6b:	89 fd                	mov    %edi,%ebp
  803f6d:	85 ff                	test   %edi,%edi
  803f6f:	75 0b                	jne    803f7c <__udivdi3+0x38>
  803f71:	b8 01 00 00 00       	mov    $0x1,%eax
  803f76:	31 d2                	xor    %edx,%edx
  803f78:	f7 f7                	div    %edi
  803f7a:	89 c5                	mov    %eax,%ebp
  803f7c:	31 d2                	xor    %edx,%edx
  803f7e:	89 c8                	mov    %ecx,%eax
  803f80:	f7 f5                	div    %ebp
  803f82:	89 c1                	mov    %eax,%ecx
  803f84:	89 d8                	mov    %ebx,%eax
  803f86:	f7 f5                	div    %ebp
  803f88:	89 cf                	mov    %ecx,%edi
  803f8a:	89 fa                	mov    %edi,%edx
  803f8c:	83 c4 1c             	add    $0x1c,%esp
  803f8f:	5b                   	pop    %ebx
  803f90:	5e                   	pop    %esi
  803f91:	5f                   	pop    %edi
  803f92:	5d                   	pop    %ebp
  803f93:	c3                   	ret    
  803f94:	39 ce                	cmp    %ecx,%esi
  803f96:	77 28                	ja     803fc0 <__udivdi3+0x7c>
  803f98:	0f bd fe             	bsr    %esi,%edi
  803f9b:	83 f7 1f             	xor    $0x1f,%edi
  803f9e:	75 40                	jne    803fe0 <__udivdi3+0x9c>
  803fa0:	39 ce                	cmp    %ecx,%esi
  803fa2:	72 0a                	jb     803fae <__udivdi3+0x6a>
  803fa4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803fa8:	0f 87 9e 00 00 00    	ja     80404c <__udivdi3+0x108>
  803fae:	b8 01 00 00 00       	mov    $0x1,%eax
  803fb3:	89 fa                	mov    %edi,%edx
  803fb5:	83 c4 1c             	add    $0x1c,%esp
  803fb8:	5b                   	pop    %ebx
  803fb9:	5e                   	pop    %esi
  803fba:	5f                   	pop    %edi
  803fbb:	5d                   	pop    %ebp
  803fbc:	c3                   	ret    
  803fbd:	8d 76 00             	lea    0x0(%esi),%esi
  803fc0:	31 ff                	xor    %edi,%edi
  803fc2:	31 c0                	xor    %eax,%eax
  803fc4:	89 fa                	mov    %edi,%edx
  803fc6:	83 c4 1c             	add    $0x1c,%esp
  803fc9:	5b                   	pop    %ebx
  803fca:	5e                   	pop    %esi
  803fcb:	5f                   	pop    %edi
  803fcc:	5d                   	pop    %ebp
  803fcd:	c3                   	ret    
  803fce:	66 90                	xchg   %ax,%ax
  803fd0:	89 d8                	mov    %ebx,%eax
  803fd2:	f7 f7                	div    %edi
  803fd4:	31 ff                	xor    %edi,%edi
  803fd6:	89 fa                	mov    %edi,%edx
  803fd8:	83 c4 1c             	add    $0x1c,%esp
  803fdb:	5b                   	pop    %ebx
  803fdc:	5e                   	pop    %esi
  803fdd:	5f                   	pop    %edi
  803fde:	5d                   	pop    %ebp
  803fdf:	c3                   	ret    
  803fe0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803fe5:	89 eb                	mov    %ebp,%ebx
  803fe7:	29 fb                	sub    %edi,%ebx
  803fe9:	89 f9                	mov    %edi,%ecx
  803feb:	d3 e6                	shl    %cl,%esi
  803fed:	89 c5                	mov    %eax,%ebp
  803fef:	88 d9                	mov    %bl,%cl
  803ff1:	d3 ed                	shr    %cl,%ebp
  803ff3:	89 e9                	mov    %ebp,%ecx
  803ff5:	09 f1                	or     %esi,%ecx
  803ff7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ffb:	89 f9                	mov    %edi,%ecx
  803ffd:	d3 e0                	shl    %cl,%eax
  803fff:	89 c5                	mov    %eax,%ebp
  804001:	89 d6                	mov    %edx,%esi
  804003:	88 d9                	mov    %bl,%cl
  804005:	d3 ee                	shr    %cl,%esi
  804007:	89 f9                	mov    %edi,%ecx
  804009:	d3 e2                	shl    %cl,%edx
  80400b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80400f:	88 d9                	mov    %bl,%cl
  804011:	d3 e8                	shr    %cl,%eax
  804013:	09 c2                	or     %eax,%edx
  804015:	89 d0                	mov    %edx,%eax
  804017:	89 f2                	mov    %esi,%edx
  804019:	f7 74 24 0c          	divl   0xc(%esp)
  80401d:	89 d6                	mov    %edx,%esi
  80401f:	89 c3                	mov    %eax,%ebx
  804021:	f7 e5                	mul    %ebp
  804023:	39 d6                	cmp    %edx,%esi
  804025:	72 19                	jb     804040 <__udivdi3+0xfc>
  804027:	74 0b                	je     804034 <__udivdi3+0xf0>
  804029:	89 d8                	mov    %ebx,%eax
  80402b:	31 ff                	xor    %edi,%edi
  80402d:	e9 58 ff ff ff       	jmp    803f8a <__udivdi3+0x46>
  804032:	66 90                	xchg   %ax,%ax
  804034:	8b 54 24 08          	mov    0x8(%esp),%edx
  804038:	89 f9                	mov    %edi,%ecx
  80403a:	d3 e2                	shl    %cl,%edx
  80403c:	39 c2                	cmp    %eax,%edx
  80403e:	73 e9                	jae    804029 <__udivdi3+0xe5>
  804040:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804043:	31 ff                	xor    %edi,%edi
  804045:	e9 40 ff ff ff       	jmp    803f8a <__udivdi3+0x46>
  80404a:	66 90                	xchg   %ax,%ax
  80404c:	31 c0                	xor    %eax,%eax
  80404e:	e9 37 ff ff ff       	jmp    803f8a <__udivdi3+0x46>
  804053:	90                   	nop

00804054 <__umoddi3>:
  804054:	55                   	push   %ebp
  804055:	57                   	push   %edi
  804056:	56                   	push   %esi
  804057:	53                   	push   %ebx
  804058:	83 ec 1c             	sub    $0x1c,%esp
  80405b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80405f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804063:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804067:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80406b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80406f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804073:	89 f3                	mov    %esi,%ebx
  804075:	89 fa                	mov    %edi,%edx
  804077:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80407b:	89 34 24             	mov    %esi,(%esp)
  80407e:	85 c0                	test   %eax,%eax
  804080:	75 1a                	jne    80409c <__umoddi3+0x48>
  804082:	39 f7                	cmp    %esi,%edi
  804084:	0f 86 a2 00 00 00    	jbe    80412c <__umoddi3+0xd8>
  80408a:	89 c8                	mov    %ecx,%eax
  80408c:	89 f2                	mov    %esi,%edx
  80408e:	f7 f7                	div    %edi
  804090:	89 d0                	mov    %edx,%eax
  804092:	31 d2                	xor    %edx,%edx
  804094:	83 c4 1c             	add    $0x1c,%esp
  804097:	5b                   	pop    %ebx
  804098:	5e                   	pop    %esi
  804099:	5f                   	pop    %edi
  80409a:	5d                   	pop    %ebp
  80409b:	c3                   	ret    
  80409c:	39 f0                	cmp    %esi,%eax
  80409e:	0f 87 ac 00 00 00    	ja     804150 <__umoddi3+0xfc>
  8040a4:	0f bd e8             	bsr    %eax,%ebp
  8040a7:	83 f5 1f             	xor    $0x1f,%ebp
  8040aa:	0f 84 ac 00 00 00    	je     80415c <__umoddi3+0x108>
  8040b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8040b5:	29 ef                	sub    %ebp,%edi
  8040b7:	89 fe                	mov    %edi,%esi
  8040b9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040bd:	89 e9                	mov    %ebp,%ecx
  8040bf:	d3 e0                	shl    %cl,%eax
  8040c1:	89 d7                	mov    %edx,%edi
  8040c3:	89 f1                	mov    %esi,%ecx
  8040c5:	d3 ef                	shr    %cl,%edi
  8040c7:	09 c7                	or     %eax,%edi
  8040c9:	89 e9                	mov    %ebp,%ecx
  8040cb:	d3 e2                	shl    %cl,%edx
  8040cd:	89 14 24             	mov    %edx,(%esp)
  8040d0:	89 d8                	mov    %ebx,%eax
  8040d2:	d3 e0                	shl    %cl,%eax
  8040d4:	89 c2                	mov    %eax,%edx
  8040d6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040da:	d3 e0                	shl    %cl,%eax
  8040dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040e0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040e4:	89 f1                	mov    %esi,%ecx
  8040e6:	d3 e8                	shr    %cl,%eax
  8040e8:	09 d0                	or     %edx,%eax
  8040ea:	d3 eb                	shr    %cl,%ebx
  8040ec:	89 da                	mov    %ebx,%edx
  8040ee:	f7 f7                	div    %edi
  8040f0:	89 d3                	mov    %edx,%ebx
  8040f2:	f7 24 24             	mull   (%esp)
  8040f5:	89 c6                	mov    %eax,%esi
  8040f7:	89 d1                	mov    %edx,%ecx
  8040f9:	39 d3                	cmp    %edx,%ebx
  8040fb:	0f 82 87 00 00 00    	jb     804188 <__umoddi3+0x134>
  804101:	0f 84 91 00 00 00    	je     804198 <__umoddi3+0x144>
  804107:	8b 54 24 04          	mov    0x4(%esp),%edx
  80410b:	29 f2                	sub    %esi,%edx
  80410d:	19 cb                	sbb    %ecx,%ebx
  80410f:	89 d8                	mov    %ebx,%eax
  804111:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804115:	d3 e0                	shl    %cl,%eax
  804117:	89 e9                	mov    %ebp,%ecx
  804119:	d3 ea                	shr    %cl,%edx
  80411b:	09 d0                	or     %edx,%eax
  80411d:	89 e9                	mov    %ebp,%ecx
  80411f:	d3 eb                	shr    %cl,%ebx
  804121:	89 da                	mov    %ebx,%edx
  804123:	83 c4 1c             	add    $0x1c,%esp
  804126:	5b                   	pop    %ebx
  804127:	5e                   	pop    %esi
  804128:	5f                   	pop    %edi
  804129:	5d                   	pop    %ebp
  80412a:	c3                   	ret    
  80412b:	90                   	nop
  80412c:	89 fd                	mov    %edi,%ebp
  80412e:	85 ff                	test   %edi,%edi
  804130:	75 0b                	jne    80413d <__umoddi3+0xe9>
  804132:	b8 01 00 00 00       	mov    $0x1,%eax
  804137:	31 d2                	xor    %edx,%edx
  804139:	f7 f7                	div    %edi
  80413b:	89 c5                	mov    %eax,%ebp
  80413d:	89 f0                	mov    %esi,%eax
  80413f:	31 d2                	xor    %edx,%edx
  804141:	f7 f5                	div    %ebp
  804143:	89 c8                	mov    %ecx,%eax
  804145:	f7 f5                	div    %ebp
  804147:	89 d0                	mov    %edx,%eax
  804149:	e9 44 ff ff ff       	jmp    804092 <__umoddi3+0x3e>
  80414e:	66 90                	xchg   %ax,%ax
  804150:	89 c8                	mov    %ecx,%eax
  804152:	89 f2                	mov    %esi,%edx
  804154:	83 c4 1c             	add    $0x1c,%esp
  804157:	5b                   	pop    %ebx
  804158:	5e                   	pop    %esi
  804159:	5f                   	pop    %edi
  80415a:	5d                   	pop    %ebp
  80415b:	c3                   	ret    
  80415c:	3b 04 24             	cmp    (%esp),%eax
  80415f:	72 06                	jb     804167 <__umoddi3+0x113>
  804161:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804165:	77 0f                	ja     804176 <__umoddi3+0x122>
  804167:	89 f2                	mov    %esi,%edx
  804169:	29 f9                	sub    %edi,%ecx
  80416b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80416f:	89 14 24             	mov    %edx,(%esp)
  804172:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804176:	8b 44 24 04          	mov    0x4(%esp),%eax
  80417a:	8b 14 24             	mov    (%esp),%edx
  80417d:	83 c4 1c             	add    $0x1c,%esp
  804180:	5b                   	pop    %ebx
  804181:	5e                   	pop    %esi
  804182:	5f                   	pop    %edi
  804183:	5d                   	pop    %ebp
  804184:	c3                   	ret    
  804185:	8d 76 00             	lea    0x0(%esi),%esi
  804188:	2b 04 24             	sub    (%esp),%eax
  80418b:	19 fa                	sbb    %edi,%edx
  80418d:	89 d1                	mov    %edx,%ecx
  80418f:	89 c6                	mov    %eax,%esi
  804191:	e9 71 ff ff ff       	jmp    804107 <__umoddi3+0xb3>
  804196:	66 90                	xchg   %ax,%ax
  804198:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80419c:	72 ea                	jb     804188 <__umoddi3+0x134>
  80419e:	89 d9                	mov    %ebx,%ecx
  8041a0:	e9 62 ff ff ff       	jmp    804107 <__umoddi3+0xb3>
