
obj/user/quicksort_leakage:     file format elf32-i386


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
  800031:	e8 c8 05 00 00       	call   8005fe <libmain>
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
  800041:	e8 f6 1e 00 00       	call   801f3c <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 42 80 00       	push   $0x804260
  80004e:	e8 a7 09 00 00       	call   8009fa <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 42 80 00       	push   $0x804262
  80005e:	e8 97 09 00 00       	call   8009fa <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 7b 42 80 00       	push   $0x80427b
  80006e:	e8 87 09 00 00       	call   8009fa <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 42 80 00       	push   $0x804262
  80007e:	e8 77 09 00 00       	call   8009fa <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 42 80 00       	push   $0x804260
  80008e:	e8 67 09 00 00       	call   8009fa <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 94 42 80 00       	push   $0x804294
  8000a5:	e8 e4 0f 00 00       	call   80108e <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 36 15 00 00       	call   8015f6 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 b4 42 80 00       	push   $0x8042b4
  8000ce:	e8 27 09 00 00       	call   8009fa <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 d6 42 80 00       	push   $0x8042d6
  8000de:	e8 17 09 00 00       	call   8009fa <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 e4 42 80 00       	push   $0x8042e4
  8000ee:	e8 07 09 00 00       	call   8009fa <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 f3 42 80 00       	push   $0x8042f3
  8000fe:	e8 f7 08 00 00       	call   8009fa <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 03 43 80 00       	push   $0x804303
  80010e:	e8 e7 08 00 00       	call   8009fa <cprintf>
  800113:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800116:	e8 c6 04 00 00       	call   8005e1 <getchar>
  80011b:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80011e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 97 04 00 00       	call   8005c2 <cputchar>
  80012b:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	6a 0a                	push   $0xa
  800133:	e8 8a 04 00 00       	call   8005c2 <cputchar>
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
  80014d:	e8 04 1e 00 00       	call   801f56 <sys_unlock_cons>
		//sys_unlock_cons();

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 51 18 00 00       	call   8019b2 <malloc>
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
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  8001d5:	e8 62 1d 00 00       	call   801f3c <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 0c 43 80 00       	push   $0x80430c
  8001e2:	e8 13 08 00 00       	call   8009fa <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 67 1d 00 00       	call   801f56 <sys_unlock_cons>
		//sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 40 43 80 00       	push   $0x804340
  800211:	6a 54                	push   $0x54
  800213:	68 62 43 80 00       	push   $0x804362
  800218:	e8 20 05 00 00       	call   80073d <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 1a 1d 00 00       	call   801f3c <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 7c 43 80 00       	push   $0x80437c
  80022a:	e8 cb 07 00 00       	call   8009fa <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 b0 43 80 00       	push   $0x8043b0
  80023a:	e8 bb 07 00 00       	call   8009fa <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 e4 43 80 00       	push   $0x8043e4
  80024a:	e8 ab 07 00 00       	call   8009fa <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 ff 1c 00 00       	call   801f56 <sys_unlock_cons>


		}

		//		sys_lock_cons();
		sys_lock_cons();
  800257:	e8 e0 1c 00 00       	call   801f3c <sys_lock_cons>
		{
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 16 44 80 00       	push   $0x804416
  80026a:	e8 8b 07 00 00       	call   8009fa <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 6a 03 00 00       	call   8005e1 <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 3b 03 00 00       	call   8005c2 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 2e 03 00 00       	call   8005c2 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 21 03 00 00       	call   8005c2 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp

		//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b0:	e8 a1 1c 00 00       	call   801f56 <sys_unlock_cons>
		//		sys_unlock_cons();

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8004fd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800501:	75 07                	jne    80050a <InitializeSemiRandom+0x27>
		Repetition = 3;
  800503:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80050a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800511:	eb 1e                	jmp    800531 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800523:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800526:	99                   	cltd   
  800527:	f7 7d f8             	idivl  -0x8(%ebp)
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
		Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  80052e:	ff 45 fc             	incl   -0x4(%ebp)
  800531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800534:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800537:	7c da                	jl     800513 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800539:	90                   	nop
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800542:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800549:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800550:	eb 42                	jmp    800594 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800555:	99                   	cltd   
  800556:	f7 7d f0             	idivl  -0x10(%ebp)
  800559:	89 d0                	mov    %edx,%eax
  80055b:	85 c0                	test   %eax,%eax
  80055d:	75 10                	jne    80056f <PrintElements+0x33>
			cprintf("\n");
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 60 42 80 00       	push   $0x804260
  800567:	e8 8e 04 00 00       	call   8009fa <cprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80056f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	01 d0                	add    %edx,%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	50                   	push   %eax
  800584:	68 34 44 80 00       	push   $0x804434
  800589:	e8 6c 04 00 00       	call   8009fa <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800591:	ff 45 f4             	incl   -0xc(%ebp)
  800594:	8b 45 0c             	mov    0xc(%ebp),%eax
  800597:	48                   	dec    %eax
  800598:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80059b:	7f b5                	jg     800552 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005aa:	01 d0                	add    %edx,%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	50                   	push   %eax
  8005b2:	68 39 44 80 00       	push   $0x804439
  8005b7:	e8 3e 04 00 00       	call   8009fa <cprintf>
  8005bc:	83 c4 10             	add    $0x10,%esp

}
  8005bf:	90                   	nop
  8005c0:	c9                   	leave  
  8005c1:	c3                   	ret    

008005c2 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005c2:	55                   	push   %ebp
  8005c3:	89 e5                	mov    %esp,%ebp
  8005c5:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005ce:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d2:	83 ec 0c             	sub    $0xc,%esp
  8005d5:	50                   	push   %eax
  8005d6:	e8 ac 1a 00 00       	call   802087 <sys_cputc>
  8005db:	83 c4 10             	add    $0x10,%esp
}
  8005de:	90                   	nop
  8005df:	c9                   	leave  
  8005e0:	c3                   	ret    

008005e1 <getchar>:


int
getchar(void)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8005e7:	e8 37 19 00 00       	call   801f23 <sys_cgetc>
  8005ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8005ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005f2:	c9                   	leave  
  8005f3:	c3                   	ret    

008005f4 <iscons>:

int iscons(int fdnum)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005fc:	5d                   	pop    %ebp
  8005fd:	c3                   	ret    

008005fe <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800604:	e8 af 1b 00 00       	call   8021b8 <sys_getenvindex>
  800609:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80060c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	c1 e0 03             	shl    $0x3,%eax
  800614:	01 d0                	add    %edx,%eax
  800616:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80061d:	01 c8                	add    %ecx,%eax
  80061f:	01 c0                	add    %eax,%eax
  800621:	01 d0                	add    %edx,%eax
  800623:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80062a:	01 c8                	add    %ecx,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800633:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800638:	a1 24 50 80 00       	mov    0x805024,%eax
  80063d:	8a 40 20             	mov    0x20(%eax),%al
  800640:	84 c0                	test   %al,%al
  800642:	74 0d                	je     800651 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800644:	a1 24 50 80 00       	mov    0x805024,%eax
  800649:	83 c0 20             	add    $0x20,%eax
  80064c:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800651:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800655:	7e 0a                	jle    800661 <libmain+0x63>
		binaryname = argv[0];
  800657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	ff 75 0c             	pushl  0xc(%ebp)
  800667:	ff 75 08             	pushl  0x8(%ebp)
  80066a:	e8 c9 f9 ff ff       	call   800038 <_main>
  80066f:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800672:	e8 c5 18 00 00       	call   801f3c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800677:	83 ec 0c             	sub    $0xc,%esp
  80067a:	68 58 44 80 00       	push   $0x804458
  80067f:	e8 76 03 00 00       	call   8009fa <cprintf>
  800684:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800687:	a1 24 50 80 00       	mov    0x805024,%eax
  80068c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800692:	a1 24 50 80 00       	mov    0x805024,%eax
  800697:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80069d:	83 ec 04             	sub    $0x4,%esp
  8006a0:	52                   	push   %edx
  8006a1:	50                   	push   %eax
  8006a2:	68 80 44 80 00       	push   $0x804480
  8006a7:	e8 4e 03 00 00       	call   8009fa <cprintf>
  8006ac:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006af:	a1 24 50 80 00       	mov    0x805024,%eax
  8006b4:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8006ba:	a1 24 50 80 00       	mov    0x805024,%eax
  8006bf:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8006c5:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ca:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8006d0:	51                   	push   %ecx
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	68 a8 44 80 00       	push   $0x8044a8
  8006d8:	e8 1d 03 00 00       	call   8009fa <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006e0:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	50                   	push   %eax
  8006ef:	68 00 45 80 00       	push   $0x804500
  8006f4:	e8 01 03 00 00       	call   8009fa <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	68 58 44 80 00       	push   $0x804458
  800704:	e8 f1 02 00 00       	call   8009fa <cprintf>
  800709:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80070c:	e8 45 18 00 00       	call   801f56 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800711:	e8 19 00 00 00       	call   80072f <exit>
}
  800716:	90                   	nop
  800717:	c9                   	leave  
  800718:	c3                   	ret    

00800719 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
  80071c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80071f:	83 ec 0c             	sub    $0xc,%esp
  800722:	6a 00                	push   $0x0
  800724:	e8 5b 1a 00 00       	call   802184 <sys_destroy_env>
  800729:	83 c4 10             	add    $0x10,%esp
}
  80072c:	90                   	nop
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    

0080072f <exit>:

void
exit(void)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800735:	e8 b0 1a 00 00       	call   8021ea <sys_exit_env>
}
  80073a:	90                   	nop
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    

0080073d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800743:	8d 45 10             	lea    0x10(%ebp),%eax
  800746:	83 c0 04             	add    $0x4,%eax
  800749:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80074c:	a1 50 50 80 00       	mov    0x805050,%eax
  800751:	85 c0                	test   %eax,%eax
  800753:	74 16                	je     80076b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800755:	a1 50 50 80 00       	mov    0x805050,%eax
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	50                   	push   %eax
  80075e:	68 14 45 80 00       	push   $0x804514
  800763:	e8 92 02 00 00       	call   8009fa <cprintf>
  800768:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80076b:	a1 00 50 80 00       	mov    0x805000,%eax
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	ff 75 08             	pushl  0x8(%ebp)
  800776:	50                   	push   %eax
  800777:	68 19 45 80 00       	push   $0x804519
  80077c:	e8 79 02 00 00       	call   8009fa <cprintf>
  800781:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800784:	8b 45 10             	mov    0x10(%ebp),%eax
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 f4             	pushl  -0xc(%ebp)
  80078d:	50                   	push   %eax
  80078e:	e8 fc 01 00 00       	call   80098f <vcprintf>
  800793:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	6a 00                	push   $0x0
  80079b:	68 35 45 80 00       	push   $0x804535
  8007a0:	e8 ea 01 00 00       	call   80098f <vcprintf>
  8007a5:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007a8:	e8 82 ff ff ff       	call   80072f <exit>

	// should not return here
	while (1) ;
  8007ad:	eb fe                	jmp    8007ad <_panic+0x70>

008007af <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007b5:	a1 24 50 80 00       	mov    0x805024,%eax
  8007ba:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8007c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c3:	39 c2                	cmp    %eax,%edx
  8007c5:	74 14                	je     8007db <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007c7:	83 ec 04             	sub    $0x4,%esp
  8007ca:	68 38 45 80 00       	push   $0x804538
  8007cf:	6a 26                	push   $0x26
  8007d1:	68 84 45 80 00       	push   $0x804584
  8007d6:	e8 62 ff ff ff       	call   80073d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007e9:	e9 c5 00 00 00       	jmp    8008b3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8007ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	01 d0                	add    %edx,%eax
  8007fd:	8b 00                	mov    (%eax),%eax
  8007ff:	85 c0                	test   %eax,%eax
  800801:	75 08                	jne    80080b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800803:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800806:	e9 a5 00 00 00       	jmp    8008b0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80080b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800812:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800819:	eb 69                	jmp    800884 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80081b:	a1 24 50 80 00       	mov    0x805024,%eax
  800820:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800826:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800829:	89 d0                	mov    %edx,%eax
  80082b:	01 c0                	add    %eax,%eax
  80082d:	01 d0                	add    %edx,%eax
  80082f:	c1 e0 03             	shl    $0x3,%eax
  800832:	01 c8                	add    %ecx,%eax
  800834:	8a 40 04             	mov    0x4(%eax),%al
  800837:	84 c0                	test   %al,%al
  800839:	75 46                	jne    800881 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80083b:	a1 24 50 80 00       	mov    0x805024,%eax
  800840:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800846:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800849:	89 d0                	mov    %edx,%eax
  80084b:	01 c0                	add    %eax,%eax
  80084d:	01 d0                	add    %edx,%eax
  80084f:	c1 e0 03             	shl    $0x3,%eax
  800852:	01 c8                	add    %ecx,%eax
  800854:	8b 00                	mov    (%eax),%eax
  800856:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800859:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80085c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800861:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800863:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800866:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	01 c8                	add    %ecx,%eax
  800872:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800874:	39 c2                	cmp    %eax,%edx
  800876:	75 09                	jne    800881 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800878:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80087f:	eb 15                	jmp    800896 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800881:	ff 45 e8             	incl   -0x18(%ebp)
  800884:	a1 24 50 80 00       	mov    0x805024,%eax
  800889:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80088f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800892:	39 c2                	cmp    %eax,%edx
  800894:	77 85                	ja     80081b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800896:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80089a:	75 14                	jne    8008b0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80089c:	83 ec 04             	sub    $0x4,%esp
  80089f:	68 90 45 80 00       	push   $0x804590
  8008a4:	6a 3a                	push   $0x3a
  8008a6:	68 84 45 80 00       	push   $0x804584
  8008ab:	e8 8d fe ff ff       	call   80073d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008b0:	ff 45 f0             	incl   -0x10(%ebp)
  8008b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008b9:	0f 8c 2f ff ff ff    	jl     8007ee <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008bf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008c6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008cd:	eb 26                	jmp    8008f5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008cf:	a1 24 50 80 00       	mov    0x805024,%eax
  8008d4:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8008da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008dd:	89 d0                	mov    %edx,%eax
  8008df:	01 c0                	add    %eax,%eax
  8008e1:	01 d0                	add    %edx,%eax
  8008e3:	c1 e0 03             	shl    $0x3,%eax
  8008e6:	01 c8                	add    %ecx,%eax
  8008e8:	8a 40 04             	mov    0x4(%eax),%al
  8008eb:	3c 01                	cmp    $0x1,%al
  8008ed:	75 03                	jne    8008f2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8008ef:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008f2:	ff 45 e0             	incl   -0x20(%ebp)
  8008f5:	a1 24 50 80 00       	mov    0x805024,%eax
  8008fa:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800903:	39 c2                	cmp    %eax,%edx
  800905:	77 c8                	ja     8008cf <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80090a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80090d:	74 14                	je     800923 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80090f:	83 ec 04             	sub    $0x4,%esp
  800912:	68 e4 45 80 00       	push   $0x8045e4
  800917:	6a 44                	push   $0x44
  800919:	68 84 45 80 00       	push   $0x804584
  80091e:	e8 1a fe ff ff       	call   80073d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800923:	90                   	nop
  800924:	c9                   	leave  
  800925:	c3                   	ret    

00800926 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80092c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	8d 48 01             	lea    0x1(%eax),%ecx
  800934:	8b 55 0c             	mov    0xc(%ebp),%edx
  800937:	89 0a                	mov    %ecx,(%edx)
  800939:	8b 55 08             	mov    0x8(%ebp),%edx
  80093c:	88 d1                	mov    %dl,%cl
  80093e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800941:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800945:	8b 45 0c             	mov    0xc(%ebp),%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80094f:	75 2c                	jne    80097d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800951:	a0 2c 50 80 00       	mov    0x80502c,%al
  800956:	0f b6 c0             	movzbl %al,%eax
  800959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095c:	8b 12                	mov    (%edx),%edx
  80095e:	89 d1                	mov    %edx,%ecx
  800960:	8b 55 0c             	mov    0xc(%ebp),%edx
  800963:	83 c2 08             	add    $0x8,%edx
  800966:	83 ec 04             	sub    $0x4,%esp
  800969:	50                   	push   %eax
  80096a:	51                   	push   %ecx
  80096b:	52                   	push   %edx
  80096c:	e8 89 15 00 00       	call   801efa <sys_cputs>
  800971:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800974:	8b 45 0c             	mov    0xc(%ebp),%eax
  800977:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80097d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800980:	8b 40 04             	mov    0x4(%eax),%eax
  800983:	8d 50 01             	lea    0x1(%eax),%edx
  800986:	8b 45 0c             	mov    0xc(%ebp),%eax
  800989:	89 50 04             	mov    %edx,0x4(%eax)
}
  80098c:	90                   	nop
  80098d:	c9                   	leave  
  80098e:	c3                   	ret    

0080098f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800998:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80099f:	00 00 00 
	b.cnt = 0;
  8009a2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009a9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	ff 75 08             	pushl  0x8(%ebp)
  8009b2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009b8:	50                   	push   %eax
  8009b9:	68 26 09 80 00       	push   $0x800926
  8009be:	e8 11 02 00 00       	call   800bd4 <vprintfmt>
  8009c3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009c6:	a0 2c 50 80 00       	mov    0x80502c,%al
  8009cb:	0f b6 c0             	movzbl %al,%eax
  8009ce:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009d4:	83 ec 04             	sub    $0x4,%esp
  8009d7:	50                   	push   %eax
  8009d8:	52                   	push   %edx
  8009d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009df:	83 c0 08             	add    $0x8,%eax
  8009e2:	50                   	push   %eax
  8009e3:	e8 12 15 00 00       	call   801efa <sys_cputs>
  8009e8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009eb:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
	return b.cnt;
  8009f2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009f8:	c9                   	leave  
  8009f9:	c3                   	ret    

008009fa <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a00:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
	va_start(ap, fmt);
  800a07:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 f4             	pushl  -0xc(%ebp)
  800a16:	50                   	push   %eax
  800a17:	e8 73 ff ff ff       	call   80098f <vcprintf>
  800a1c:	83 c4 10             	add    $0x10,%esp
  800a1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a2d:	e8 0a 15 00 00       	call   801f3c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a32:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a41:	50                   	push   %eax
  800a42:	e8 48 ff ff ff       	call   80098f <vcprintf>
  800a47:	83 c4 10             	add    $0x10,%esp
  800a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a4d:	e8 04 15 00 00       	call   801f56 <sys_unlock_cons>
	return cnt;
  800a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a55:	c9                   	leave  
  800a56:	c3                   	ret    

00800a57 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	53                   	push   %ebx
  800a5b:	83 ec 14             	sub    $0x14,%esp
  800a5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a6a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a72:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a75:	77 55                	ja     800acc <printnum+0x75>
  800a77:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a7a:	72 05                	jb     800a81 <printnum+0x2a>
  800a7c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a7f:	77 4b                	ja     800acc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a81:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a84:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a87:	8b 45 18             	mov    0x18(%ebp),%eax
  800a8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8f:	52                   	push   %edx
  800a90:	50                   	push   %eax
  800a91:	ff 75 f4             	pushl  -0xc(%ebp)
  800a94:	ff 75 f0             	pushl  -0x10(%ebp)
  800a97:	e8 60 35 00 00       	call   803ffc <__udivdi3>
  800a9c:	83 c4 10             	add    $0x10,%esp
  800a9f:	83 ec 04             	sub    $0x4,%esp
  800aa2:	ff 75 20             	pushl  0x20(%ebp)
  800aa5:	53                   	push   %ebx
  800aa6:	ff 75 18             	pushl  0x18(%ebp)
  800aa9:	52                   	push   %edx
  800aaa:	50                   	push   %eax
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	ff 75 08             	pushl  0x8(%ebp)
  800ab1:	e8 a1 ff ff ff       	call   800a57 <printnum>
  800ab6:	83 c4 20             	add    $0x20,%esp
  800ab9:	eb 1a                	jmp    800ad5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	ff 75 20             	pushl  0x20(%ebp)
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	ff d0                	call   *%eax
  800ac9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800acc:	ff 4d 1c             	decl   0x1c(%ebp)
  800acf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ad3:	7f e6                	jg     800abb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ad5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ad8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ae3:	53                   	push   %ebx
  800ae4:	51                   	push   %ecx
  800ae5:	52                   	push   %edx
  800ae6:	50                   	push   %eax
  800ae7:	e8 20 36 00 00       	call   80410c <__umoddi3>
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	05 54 48 80 00       	add    $0x804854,%eax
  800af4:	8a 00                	mov    (%eax),%al
  800af6:	0f be c0             	movsbl %al,%eax
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	50                   	push   %eax
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
}
  800b08:	90                   	nop
  800b09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b11:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b15:	7e 1c                	jle    800b33 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	8b 00                	mov    (%eax),%eax
  800b1c:	8d 50 08             	lea    0x8(%eax),%edx
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	89 10                	mov    %edx,(%eax)
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	8b 00                	mov    (%eax),%eax
  800b29:	83 e8 08             	sub    $0x8,%eax
  800b2c:	8b 50 04             	mov    0x4(%eax),%edx
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	eb 40                	jmp    800b73 <getuint+0x65>
	else if (lflag)
  800b33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b37:	74 1e                	je     800b57 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	8d 50 04             	lea    0x4(%eax),%edx
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	89 10                	mov    %edx,(%eax)
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8b 00                	mov    (%eax),%eax
  800b4b:	83 e8 04             	sub    $0x4,%eax
  800b4e:	8b 00                	mov    (%eax),%eax
  800b50:	ba 00 00 00 00       	mov    $0x0,%edx
  800b55:	eb 1c                	jmp    800b73 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	8b 00                	mov    (%eax),%eax
  800b5c:	8d 50 04             	lea    0x4(%eax),%edx
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	89 10                	mov    %edx,(%eax)
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	8b 00                	mov    (%eax),%eax
  800b69:	83 e8 04             	sub    $0x4,%eax
  800b6c:	8b 00                	mov    (%eax),%eax
  800b6e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b78:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b7c:	7e 1c                	jle    800b9a <getint+0x25>
		return va_arg(*ap, long long);
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	8b 00                	mov    (%eax),%eax
  800b83:	8d 50 08             	lea    0x8(%eax),%edx
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	89 10                	mov    %edx,(%eax)
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	8b 00                	mov    (%eax),%eax
  800b90:	83 e8 08             	sub    $0x8,%eax
  800b93:	8b 50 04             	mov    0x4(%eax),%edx
  800b96:	8b 00                	mov    (%eax),%eax
  800b98:	eb 38                	jmp    800bd2 <getint+0x5d>
	else if (lflag)
  800b9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9e:	74 1a                	je     800bba <getint+0x45>
		return va_arg(*ap, long);
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	8b 00                	mov    (%eax),%eax
  800ba5:	8d 50 04             	lea    0x4(%eax),%edx
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	89 10                	mov    %edx,(%eax)
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8b 00                	mov    (%eax),%eax
  800bb2:	83 e8 04             	sub    $0x4,%eax
  800bb5:	8b 00                	mov    (%eax),%eax
  800bb7:	99                   	cltd   
  800bb8:	eb 18                	jmp    800bd2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8b 00                	mov    (%eax),%eax
  800bbf:	8d 50 04             	lea    0x4(%eax),%edx
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	89 10                	mov    %edx,(%eax)
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8b 00                	mov    (%eax),%eax
  800bcc:	83 e8 04             	sub    $0x4,%eax
  800bcf:	8b 00                	mov    (%eax),%eax
  800bd1:	99                   	cltd   
}
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
  800bd9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bdc:	eb 17                	jmp    800bf5 <vprintfmt+0x21>
			if (ch == '\0')
  800bde:	85 db                	test   %ebx,%ebx
  800be0:	0f 84 c1 03 00 00    	je     800fa7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800be6:	83 ec 08             	sub    $0x8,%esp
  800be9:	ff 75 0c             	pushl  0xc(%ebp)
  800bec:	53                   	push   %ebx
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	ff d0                	call   *%eax
  800bf2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bf5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf8:	8d 50 01             	lea    0x1(%eax),%edx
  800bfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	0f b6 d8             	movzbl %al,%ebx
  800c03:	83 fb 25             	cmp    $0x25,%ebx
  800c06:	75 d6                	jne    800bde <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c08:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c0c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c13:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c1a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c21:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c28:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2b:	8d 50 01             	lea    0x1(%eax),%edx
  800c2e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c31:	8a 00                	mov    (%eax),%al
  800c33:	0f b6 d8             	movzbl %al,%ebx
  800c36:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c39:	83 f8 5b             	cmp    $0x5b,%eax
  800c3c:	0f 87 3d 03 00 00    	ja     800f7f <vprintfmt+0x3ab>
  800c42:	8b 04 85 78 48 80 00 	mov    0x804878(,%eax,4),%eax
  800c49:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c4b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c4f:	eb d7                	jmp    800c28 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c51:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c55:	eb d1                	jmp    800c28 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c61:	89 d0                	mov    %edx,%eax
  800c63:	c1 e0 02             	shl    $0x2,%eax
  800c66:	01 d0                	add    %edx,%eax
  800c68:	01 c0                	add    %eax,%eax
  800c6a:	01 d8                	add    %ebx,%eax
  800c6c:	83 e8 30             	sub    $0x30,%eax
  800c6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c72:	8b 45 10             	mov    0x10(%ebp),%eax
  800c75:	8a 00                	mov    (%eax),%al
  800c77:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c7a:	83 fb 2f             	cmp    $0x2f,%ebx
  800c7d:	7e 3e                	jle    800cbd <vprintfmt+0xe9>
  800c7f:	83 fb 39             	cmp    $0x39,%ebx
  800c82:	7f 39                	jg     800cbd <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c84:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c87:	eb d5                	jmp    800c5e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c89:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8c:	83 c0 04             	add    $0x4,%eax
  800c8f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c92:	8b 45 14             	mov    0x14(%ebp),%eax
  800c95:	83 e8 04             	sub    $0x4,%eax
  800c98:	8b 00                	mov    (%eax),%eax
  800c9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c9d:	eb 1f                	jmp    800cbe <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca3:	79 83                	jns    800c28 <vprintfmt+0x54>
				width = 0;
  800ca5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cac:	e9 77 ff ff ff       	jmp    800c28 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cb1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cb8:	e9 6b ff ff ff       	jmp    800c28 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cbd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cbe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cc2:	0f 89 60 ff ff ff    	jns    800c28 <vprintfmt+0x54>
				width = precision, precision = -1;
  800cc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ccb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cd5:	e9 4e ff ff ff       	jmp    800c28 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cda:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cdd:	e9 46 ff ff ff       	jmp    800c28 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ce2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce5:	83 c0 04             	add    $0x4,%eax
  800ce8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ceb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cee:	83 e8 04             	sub    $0x4,%eax
  800cf1:	8b 00                	mov    (%eax),%eax
  800cf3:	83 ec 08             	sub    $0x8,%esp
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	50                   	push   %eax
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	ff d0                	call   *%eax
  800cff:	83 c4 10             	add    $0x10,%esp
			break;
  800d02:	e9 9b 02 00 00       	jmp    800fa2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d07:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0a:	83 c0 04             	add    $0x4,%eax
  800d0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d10:	8b 45 14             	mov    0x14(%ebp),%eax
  800d13:	83 e8 04             	sub    $0x4,%eax
  800d16:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d18:	85 db                	test   %ebx,%ebx
  800d1a:	79 02                	jns    800d1e <vprintfmt+0x14a>
				err = -err;
  800d1c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d1e:	83 fb 64             	cmp    $0x64,%ebx
  800d21:	7f 0b                	jg     800d2e <vprintfmt+0x15a>
  800d23:	8b 34 9d c0 46 80 00 	mov    0x8046c0(,%ebx,4),%esi
  800d2a:	85 f6                	test   %esi,%esi
  800d2c:	75 19                	jne    800d47 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d2e:	53                   	push   %ebx
  800d2f:	68 65 48 80 00       	push   $0x804865
  800d34:	ff 75 0c             	pushl  0xc(%ebp)
  800d37:	ff 75 08             	pushl  0x8(%ebp)
  800d3a:	e8 70 02 00 00       	call   800faf <printfmt>
  800d3f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d42:	e9 5b 02 00 00       	jmp    800fa2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d47:	56                   	push   %esi
  800d48:	68 6e 48 80 00       	push   $0x80486e
  800d4d:	ff 75 0c             	pushl  0xc(%ebp)
  800d50:	ff 75 08             	pushl  0x8(%ebp)
  800d53:	e8 57 02 00 00       	call   800faf <printfmt>
  800d58:	83 c4 10             	add    $0x10,%esp
			break;
  800d5b:	e9 42 02 00 00       	jmp    800fa2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d60:	8b 45 14             	mov    0x14(%ebp),%eax
  800d63:	83 c0 04             	add    $0x4,%eax
  800d66:	89 45 14             	mov    %eax,0x14(%ebp)
  800d69:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6c:	83 e8 04             	sub    $0x4,%eax
  800d6f:	8b 30                	mov    (%eax),%esi
  800d71:	85 f6                	test   %esi,%esi
  800d73:	75 05                	jne    800d7a <vprintfmt+0x1a6>
				p = "(null)";
  800d75:	be 71 48 80 00       	mov    $0x804871,%esi
			if (width > 0 && padc != '-')
  800d7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d7e:	7e 6d                	jle    800ded <vprintfmt+0x219>
  800d80:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d84:	74 67                	je     800ded <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d89:	83 ec 08             	sub    $0x8,%esp
  800d8c:	50                   	push   %eax
  800d8d:	56                   	push   %esi
  800d8e:	e8 26 05 00 00       	call   8012b9 <strnlen>
  800d93:	83 c4 10             	add    $0x10,%esp
  800d96:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d99:	eb 16                	jmp    800db1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d9b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d9f:	83 ec 08             	sub    $0x8,%esp
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	50                   	push   %eax
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	ff d0                	call   *%eax
  800dab:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dae:	ff 4d e4             	decl   -0x1c(%ebp)
  800db1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db5:	7f e4                	jg     800d9b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800db7:	eb 34                	jmp    800ded <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800db9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dbd:	74 1c                	je     800ddb <vprintfmt+0x207>
  800dbf:	83 fb 1f             	cmp    $0x1f,%ebx
  800dc2:	7e 05                	jle    800dc9 <vprintfmt+0x1f5>
  800dc4:	83 fb 7e             	cmp    $0x7e,%ebx
  800dc7:	7e 12                	jle    800ddb <vprintfmt+0x207>
					putch('?', putdat);
  800dc9:	83 ec 08             	sub    $0x8,%esp
  800dcc:	ff 75 0c             	pushl  0xc(%ebp)
  800dcf:	6a 3f                	push   $0x3f
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	ff d0                	call   *%eax
  800dd6:	83 c4 10             	add    $0x10,%esp
  800dd9:	eb 0f                	jmp    800dea <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ddb:	83 ec 08             	sub    $0x8,%esp
  800dde:	ff 75 0c             	pushl  0xc(%ebp)
  800de1:	53                   	push   %ebx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	ff d0                	call   *%eax
  800de7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dea:	ff 4d e4             	decl   -0x1c(%ebp)
  800ded:	89 f0                	mov    %esi,%eax
  800def:	8d 70 01             	lea    0x1(%eax),%esi
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f be d8             	movsbl %al,%ebx
  800df7:	85 db                	test   %ebx,%ebx
  800df9:	74 24                	je     800e1f <vprintfmt+0x24b>
  800dfb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dff:	78 b8                	js     800db9 <vprintfmt+0x1e5>
  800e01:	ff 4d e0             	decl   -0x20(%ebp)
  800e04:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e08:	79 af                	jns    800db9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e0a:	eb 13                	jmp    800e1f <vprintfmt+0x24b>
				putch(' ', putdat);
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	ff 75 0c             	pushl  0xc(%ebp)
  800e12:	6a 20                	push   $0x20
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	ff d0                	call   *%eax
  800e19:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e1c:	ff 4d e4             	decl   -0x1c(%ebp)
  800e1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e23:	7f e7                	jg     800e0c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e25:	e9 78 01 00 00       	jmp    800fa2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e2a:	83 ec 08             	sub    $0x8,%esp
  800e2d:	ff 75 e8             	pushl  -0x18(%ebp)
  800e30:	8d 45 14             	lea    0x14(%ebp),%eax
  800e33:	50                   	push   %eax
  800e34:	e8 3c fd ff ff       	call   800b75 <getint>
  800e39:	83 c4 10             	add    $0x10,%esp
  800e3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e3f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e48:	85 d2                	test   %edx,%edx
  800e4a:	79 23                	jns    800e6f <vprintfmt+0x29b>
				putch('-', putdat);
  800e4c:	83 ec 08             	sub    $0x8,%esp
  800e4f:	ff 75 0c             	pushl  0xc(%ebp)
  800e52:	6a 2d                	push   $0x2d
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	ff d0                	call   *%eax
  800e59:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e62:	f7 d8                	neg    %eax
  800e64:	83 d2 00             	adc    $0x0,%edx
  800e67:	f7 da                	neg    %edx
  800e69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e6f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e76:	e9 bc 00 00 00       	jmp    800f37 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e7b:	83 ec 08             	sub    $0x8,%esp
  800e7e:	ff 75 e8             	pushl  -0x18(%ebp)
  800e81:	8d 45 14             	lea    0x14(%ebp),%eax
  800e84:	50                   	push   %eax
  800e85:	e8 84 fc ff ff       	call   800b0e <getuint>
  800e8a:	83 c4 10             	add    $0x10,%esp
  800e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e90:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e93:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e9a:	e9 98 00 00 00       	jmp    800f37 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	6a 58                	push   $0x58
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800eaf:	83 ec 08             	sub    $0x8,%esp
  800eb2:	ff 75 0c             	pushl  0xc(%ebp)
  800eb5:	6a 58                	push   $0x58
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	ff d0                	call   *%eax
  800ebc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ebf:	83 ec 08             	sub    $0x8,%esp
  800ec2:	ff 75 0c             	pushl  0xc(%ebp)
  800ec5:	6a 58                	push   $0x58
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	ff d0                	call   *%eax
  800ecc:	83 c4 10             	add    $0x10,%esp
			break;
  800ecf:	e9 ce 00 00 00       	jmp    800fa2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ed4:	83 ec 08             	sub    $0x8,%esp
  800ed7:	ff 75 0c             	pushl  0xc(%ebp)
  800eda:	6a 30                	push   $0x30
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	ff d0                	call   *%eax
  800ee1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ee4:	83 ec 08             	sub    $0x8,%esp
  800ee7:	ff 75 0c             	pushl  0xc(%ebp)
  800eea:	6a 78                	push   $0x78
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	ff d0                	call   *%eax
  800ef1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ef4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef7:	83 c0 04             	add    $0x4,%eax
  800efa:	89 45 14             	mov    %eax,0x14(%ebp)
  800efd:	8b 45 14             	mov    0x14(%ebp),%eax
  800f00:	83 e8 04             	sub    $0x4,%eax
  800f03:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f0f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f16:	eb 1f                	jmp    800f37 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f18:	83 ec 08             	sub    $0x8,%esp
  800f1b:	ff 75 e8             	pushl  -0x18(%ebp)
  800f1e:	8d 45 14             	lea    0x14(%ebp),%eax
  800f21:	50                   	push   %eax
  800f22:	e8 e7 fb ff ff       	call   800b0e <getuint>
  800f27:	83 c4 10             	add    $0x10,%esp
  800f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f30:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f37:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f3e:	83 ec 04             	sub    $0x4,%esp
  800f41:	52                   	push   %edx
  800f42:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f45:	50                   	push   %eax
  800f46:	ff 75 f4             	pushl  -0xc(%ebp)
  800f49:	ff 75 f0             	pushl  -0x10(%ebp)
  800f4c:	ff 75 0c             	pushl  0xc(%ebp)
  800f4f:	ff 75 08             	pushl  0x8(%ebp)
  800f52:	e8 00 fb ff ff       	call   800a57 <printnum>
  800f57:	83 c4 20             	add    $0x20,%esp
			break;
  800f5a:	eb 46                	jmp    800fa2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f5c:	83 ec 08             	sub    $0x8,%esp
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	53                   	push   %ebx
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	ff d0                	call   *%eax
  800f68:	83 c4 10             	add    $0x10,%esp
			break;
  800f6b:	eb 35                	jmp    800fa2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f6d:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800f74:	eb 2c                	jmp    800fa2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f76:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
			break;
  800f7d:	eb 23                	jmp    800fa2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f7f:	83 ec 08             	sub    $0x8,%esp
  800f82:	ff 75 0c             	pushl  0xc(%ebp)
  800f85:	6a 25                	push   $0x25
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	ff d0                	call   *%eax
  800f8c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f8f:	ff 4d 10             	decl   0x10(%ebp)
  800f92:	eb 03                	jmp    800f97 <vprintfmt+0x3c3>
  800f94:	ff 4d 10             	decl   0x10(%ebp)
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	48                   	dec    %eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3c 25                	cmp    $0x25,%al
  800f9f:	75 f3                	jne    800f94 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800fa1:	90                   	nop
		}
	}
  800fa2:	e9 35 fc ff ff       	jmp    800bdc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fa7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5d                   	pop    %ebp
  800fae:	c3                   	ret    

00800faf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fb5:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb8:	83 c0 04             	add    $0x4,%eax
  800fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc1:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc4:	50                   	push   %eax
  800fc5:	ff 75 0c             	pushl  0xc(%ebp)
  800fc8:	ff 75 08             	pushl  0x8(%ebp)
  800fcb:	e8 04 fc ff ff       	call   800bd4 <vprintfmt>
  800fd0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fd3:	90                   	nop
  800fd4:	c9                   	leave  
  800fd5:	c3                   	ret    

00800fd6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	8b 40 08             	mov    0x8(%eax),%eax
  800fdf:	8d 50 01             	lea    0x1(%eax),%edx
  800fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	8b 10                	mov    (%eax),%edx
  800fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff0:	8b 40 04             	mov    0x4(%eax),%eax
  800ff3:	39 c2                	cmp    %eax,%edx
  800ff5:	73 12                	jae    801009 <sprintputch+0x33>
		*b->buf++ = ch;
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	8b 00                	mov    (%eax),%eax
  800ffc:	8d 48 01             	lea    0x1(%eax),%ecx
  800fff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801002:	89 0a                	mov    %ecx,(%edx)
  801004:	8b 55 08             	mov    0x8(%ebp),%edx
  801007:	88 10                	mov    %dl,(%eax)
}
  801009:	90                   	nop
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    

0080100c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	01 d0                	add    %edx,%eax
  801023:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801026:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80102d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801031:	74 06                	je     801039 <vsnprintf+0x2d>
  801033:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801037:	7f 07                	jg     801040 <vsnprintf+0x34>
		return -E_INVAL;
  801039:	b8 03 00 00 00       	mov    $0x3,%eax
  80103e:	eb 20                	jmp    801060 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801040:	ff 75 14             	pushl  0x14(%ebp)
  801043:	ff 75 10             	pushl  0x10(%ebp)
  801046:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801049:	50                   	push   %eax
  80104a:	68 d6 0f 80 00       	push   $0x800fd6
  80104f:	e8 80 fb ff ff       	call   800bd4 <vprintfmt>
  801054:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801057:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80105a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80105d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801060:	c9                   	leave  
  801061:	c3                   	ret    

00801062 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801068:	8d 45 10             	lea    0x10(%ebp),%eax
  80106b:	83 c0 04             	add    $0x4,%eax
  80106e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801071:	8b 45 10             	mov    0x10(%ebp),%eax
  801074:	ff 75 f4             	pushl  -0xc(%ebp)
  801077:	50                   	push   %eax
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	ff 75 08             	pushl  0x8(%ebp)
  80107e:	e8 89 ff ff ff       	call   80100c <vsnprintf>
  801083:	83 c4 10             	add    $0x10,%esp
  801086:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801089:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801094:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801098:	74 13                	je     8010ad <readline+0x1f>
		cprintf("%s", prompt);
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	ff 75 08             	pushl  0x8(%ebp)
  8010a0:	68 e8 49 80 00       	push   $0x8049e8
  8010a5:	e8 50 f9 ff ff       	call   8009fa <cprintf>
  8010aa:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010b4:	83 ec 0c             	sub    $0xc,%esp
  8010b7:	6a 00                	push   $0x0
  8010b9:	e8 36 f5 ff ff       	call   8005f4 <iscons>
  8010be:	83 c4 10             	add    $0x10,%esp
  8010c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010c4:	e8 18 f5 ff ff       	call   8005e1 <getchar>
  8010c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010d0:	79 22                	jns    8010f4 <readline+0x66>
			if (c != -E_EOF)
  8010d2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010d6:	0f 84 ad 00 00 00    	je     801189 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010dc:	83 ec 08             	sub    $0x8,%esp
  8010df:	ff 75 ec             	pushl  -0x14(%ebp)
  8010e2:	68 eb 49 80 00       	push   $0x8049eb
  8010e7:	e8 0e f9 ff ff       	call   8009fa <cprintf>
  8010ec:	83 c4 10             	add    $0x10,%esp
			break;
  8010ef:	e9 95 00 00 00       	jmp    801189 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010f4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010f8:	7e 34                	jle    80112e <readline+0xa0>
  8010fa:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801101:	7f 2b                	jg     80112e <readline+0xa0>
			if (echoing)
  801103:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801107:	74 0e                	je     801117 <readline+0x89>
				cputchar(c);
  801109:	83 ec 0c             	sub    $0xc,%esp
  80110c:	ff 75 ec             	pushl  -0x14(%ebp)
  80110f:	e8 ae f4 ff ff       	call   8005c2 <cputchar>
  801114:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111a:	8d 50 01             	lea    0x1(%eax),%edx
  80111d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801120:	89 c2                	mov    %eax,%edx
  801122:	8b 45 0c             	mov    0xc(%ebp),%eax
  801125:	01 d0                	add    %edx,%eax
  801127:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80112a:	88 10                	mov    %dl,(%eax)
  80112c:	eb 56                	jmp    801184 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80112e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801132:	75 1f                	jne    801153 <readline+0xc5>
  801134:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801138:	7e 19                	jle    801153 <readline+0xc5>
			if (echoing)
  80113a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80113e:	74 0e                	je     80114e <readline+0xc0>
				cputchar(c);
  801140:	83 ec 0c             	sub    $0xc,%esp
  801143:	ff 75 ec             	pushl  -0x14(%ebp)
  801146:	e8 77 f4 ff ff       	call   8005c2 <cputchar>
  80114b:	83 c4 10             	add    $0x10,%esp

			i--;
  80114e:	ff 4d f4             	decl   -0xc(%ebp)
  801151:	eb 31                	jmp    801184 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801153:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801157:	74 0a                	je     801163 <readline+0xd5>
  801159:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80115d:	0f 85 61 ff ff ff    	jne    8010c4 <readline+0x36>
			if (echoing)
  801163:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801167:	74 0e                	je     801177 <readline+0xe9>
				cputchar(c);
  801169:	83 ec 0c             	sub    $0xc,%esp
  80116c:	ff 75 ec             	pushl  -0x14(%ebp)
  80116f:	e8 4e f4 ff ff       	call   8005c2 <cputchar>
  801174:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801177:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117d:	01 d0                	add    %edx,%eax
  80117f:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801182:	eb 06                	jmp    80118a <readline+0xfc>
		}
	}
  801184:	e9 3b ff ff ff       	jmp    8010c4 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801189:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80118a:	90                   	nop
  80118b:	c9                   	leave  
  80118c:	c3                   	ret    

0080118d <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801193:	e8 a4 0d 00 00       	call   801f3c <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801198:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80119c:	74 13                	je     8011b1 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	ff 75 08             	pushl  0x8(%ebp)
  8011a4:	68 e8 49 80 00       	push   $0x8049e8
  8011a9:	e8 4c f8 ff ff       	call   8009fa <cprintf>
  8011ae:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8011b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8011b8:	83 ec 0c             	sub    $0xc,%esp
  8011bb:	6a 00                	push   $0x0
  8011bd:	e8 32 f4 ff ff       	call   8005f4 <iscons>
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8011c8:	e8 14 f4 ff ff       	call   8005e1 <getchar>
  8011cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8011d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011d4:	79 22                	jns    8011f8 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8011d6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011da:	0f 84 ad 00 00 00    	je     80128d <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8011e0:	83 ec 08             	sub    $0x8,%esp
  8011e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e6:	68 eb 49 80 00       	push   $0x8049eb
  8011eb:	e8 0a f8 ff ff       	call   8009fa <cprintf>
  8011f0:	83 c4 10             	add    $0x10,%esp
				break;
  8011f3:	e9 95 00 00 00       	jmp    80128d <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8011f8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011fc:	7e 34                	jle    801232 <atomic_readline+0xa5>
  8011fe:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801205:	7f 2b                	jg     801232 <atomic_readline+0xa5>
				if (echoing)
  801207:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80120b:	74 0e                	je     80121b <atomic_readline+0x8e>
					cputchar(c);
  80120d:	83 ec 0c             	sub    $0xc,%esp
  801210:	ff 75 ec             	pushl  -0x14(%ebp)
  801213:	e8 aa f3 ff ff       	call   8005c2 <cputchar>
  801218:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80121b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80121e:	8d 50 01             	lea    0x1(%eax),%edx
  801221:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801224:	89 c2                	mov    %eax,%edx
  801226:	8b 45 0c             	mov    0xc(%ebp),%eax
  801229:	01 d0                	add    %edx,%eax
  80122b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80122e:	88 10                	mov    %dl,(%eax)
  801230:	eb 56                	jmp    801288 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801232:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801236:	75 1f                	jne    801257 <atomic_readline+0xca>
  801238:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80123c:	7e 19                	jle    801257 <atomic_readline+0xca>
				if (echoing)
  80123e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801242:	74 0e                	je     801252 <atomic_readline+0xc5>
					cputchar(c);
  801244:	83 ec 0c             	sub    $0xc,%esp
  801247:	ff 75 ec             	pushl  -0x14(%ebp)
  80124a:	e8 73 f3 ff ff       	call   8005c2 <cputchar>
  80124f:	83 c4 10             	add    $0x10,%esp
				i--;
  801252:	ff 4d f4             	decl   -0xc(%ebp)
  801255:	eb 31                	jmp    801288 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801257:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80125b:	74 0a                	je     801267 <atomic_readline+0xda>
  80125d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801261:	0f 85 61 ff ff ff    	jne    8011c8 <atomic_readline+0x3b>
				if (echoing)
  801267:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126b:	74 0e                	je     80127b <atomic_readline+0xee>
					cputchar(c);
  80126d:	83 ec 0c             	sub    $0xc,%esp
  801270:	ff 75 ec             	pushl  -0x14(%ebp)
  801273:	e8 4a f3 ff ff       	call   8005c2 <cputchar>
  801278:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80127b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801281:	01 d0                	add    %edx,%eax
  801283:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801286:	eb 06                	jmp    80128e <atomic_readline+0x101>
			}
		}
  801288:	e9 3b ff ff ff       	jmp    8011c8 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80128d:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80128e:	e8 c3 0c 00 00       	call   801f56 <sys_unlock_cons>
}
  801293:	90                   	nop
  801294:	c9                   	leave  
  801295:	c3                   	ret    

00801296 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80129c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a3:	eb 06                	jmp    8012ab <strlen+0x15>
		n++;
  8012a5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a8:	ff 45 08             	incl   0x8(%ebp)
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	84 c0                	test   %al,%al
  8012b2:	75 f1                	jne    8012a5 <strlen+0xf>
		n++;
	return n;
  8012b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c6:	eb 09                	jmp    8012d1 <strnlen+0x18>
		n++;
  8012c8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012cb:	ff 45 08             	incl   0x8(%ebp)
  8012ce:	ff 4d 0c             	decl   0xc(%ebp)
  8012d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012d5:	74 09                	je     8012e0 <strnlen+0x27>
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	8a 00                	mov    (%eax),%al
  8012dc:	84 c0                	test   %al,%al
  8012de:	75 e8                	jne    8012c8 <strnlen+0xf>
		n++;
	return n;
  8012e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    

008012e5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012f1:	90                   	nop
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8d 50 01             	lea    0x1(%eax),%edx
  8012f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8012fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801301:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801304:	8a 12                	mov    (%edx),%dl
  801306:	88 10                	mov    %dl,(%eax)
  801308:	8a 00                	mov    (%eax),%al
  80130a:	84 c0                	test   %al,%al
  80130c:	75 e4                	jne    8012f2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80130e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801311:	c9                   	leave  
  801312:	c3                   	ret    

00801313 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
  801316:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80131f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801326:	eb 1f                	jmp    801347 <strncpy+0x34>
		*dst++ = *src;
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8d 50 01             	lea    0x1(%eax),%edx
  80132e:	89 55 08             	mov    %edx,0x8(%ebp)
  801331:	8b 55 0c             	mov    0xc(%ebp),%edx
  801334:	8a 12                	mov    (%edx),%dl
  801336:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801338:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	84 c0                	test   %al,%al
  80133f:	74 03                	je     801344 <strncpy+0x31>
			src++;
  801341:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801344:	ff 45 fc             	incl   -0x4(%ebp)
  801347:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80134d:	72 d9                	jb     801328 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80134f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801360:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801364:	74 30                	je     801396 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801366:	eb 16                	jmp    80137e <strlcpy+0x2a>
			*dst++ = *src++;
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8d 50 01             	lea    0x1(%eax),%edx
  80136e:	89 55 08             	mov    %edx,0x8(%ebp)
  801371:	8b 55 0c             	mov    0xc(%ebp),%edx
  801374:	8d 4a 01             	lea    0x1(%edx),%ecx
  801377:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80137a:	8a 12                	mov    (%edx),%dl
  80137c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80137e:	ff 4d 10             	decl   0x10(%ebp)
  801381:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801385:	74 09                	je     801390 <strlcpy+0x3c>
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	84 c0                	test   %al,%al
  80138e:	75 d8                	jne    801368 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801396:	8b 55 08             	mov    0x8(%ebp),%edx
  801399:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80139c:	29 c2                	sub    %eax,%edx
  80139e:	89 d0                	mov    %edx,%eax
}
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013a5:	eb 06                	jmp    8013ad <strcmp+0xb>
		p++, q++;
  8013a7:	ff 45 08             	incl   0x8(%ebp)
  8013aa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	84 c0                	test   %al,%al
  8013b4:	74 0e                	je     8013c4 <strcmp+0x22>
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	8a 10                	mov    (%eax),%dl
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	38 c2                	cmp    %al,%dl
  8013c2:	74 e3                	je     8013a7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	8a 00                	mov    (%eax),%al
  8013c9:	0f b6 d0             	movzbl %al,%edx
  8013cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	0f b6 c0             	movzbl %al,%eax
  8013d4:	29 c2                	sub    %eax,%edx
  8013d6:	89 d0                	mov    %edx,%eax
}
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    

008013da <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013dd:	eb 09                	jmp    8013e8 <strncmp+0xe>
		n--, p++, q++;
  8013df:	ff 4d 10             	decl   0x10(%ebp)
  8013e2:	ff 45 08             	incl   0x8(%ebp)
  8013e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ec:	74 17                	je     801405 <strncmp+0x2b>
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	84 c0                	test   %al,%al
  8013f5:	74 0e                	je     801405 <strncmp+0x2b>
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	8a 10                	mov    (%eax),%dl
  8013fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ff:	8a 00                	mov    (%eax),%al
  801401:	38 c2                	cmp    %al,%dl
  801403:	74 da                	je     8013df <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801405:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801409:	75 07                	jne    801412 <strncmp+0x38>
		return 0;
  80140b:	b8 00 00 00 00       	mov    $0x0,%eax
  801410:	eb 14                	jmp    801426 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	0f b6 d0             	movzbl %al,%edx
  80141a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	0f b6 c0             	movzbl %al,%eax
  801422:	29 c2                	sub    %eax,%edx
  801424:	89 d0                	mov    %edx,%eax
}
  801426:	5d                   	pop    %ebp
  801427:	c3                   	ret    

00801428 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 04             	sub    $0x4,%esp
  80142e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801431:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801434:	eb 12                	jmp    801448 <strchr+0x20>
		if (*s == c)
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80143e:	75 05                	jne    801445 <strchr+0x1d>
			return (char *) s;
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	eb 11                	jmp    801456 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801445:	ff 45 08             	incl   0x8(%ebp)
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	84 c0                	test   %al,%al
  80144f:	75 e5                	jne    801436 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801451:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	83 ec 04             	sub    $0x4,%esp
  80145e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801461:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801464:	eb 0d                	jmp    801473 <strfind+0x1b>
		if (*s == c)
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80146e:	74 0e                	je     80147e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801470:	ff 45 08             	incl   0x8(%ebp)
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	8a 00                	mov    (%eax),%al
  801478:	84 c0                	test   %al,%al
  80147a:	75 ea                	jne    801466 <strfind+0xe>
  80147c:	eb 01                	jmp    80147f <strfind+0x27>
		if (*s == c)
			break;
  80147e:	90                   	nop
	return (char *) s;
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801490:	8b 45 10             	mov    0x10(%ebp),%eax
  801493:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801496:	eb 0e                	jmp    8014a6 <memset+0x22>
		*p++ = c;
  801498:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149b:	8d 50 01             	lea    0x1(%eax),%edx
  80149e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014a6:	ff 4d f8             	decl   -0x8(%ebp)
  8014a9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014ad:	79 e9                	jns    801498 <memset+0x14>
		*p++ = c;

	return v;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014c6:	eb 16                	jmp    8014de <memcpy+0x2a>
		*d++ = *s++;
  8014c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cb:	8d 50 01             	lea    0x1(%eax),%edx
  8014ce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014d7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014da:	8a 12                	mov    (%edx),%dl
  8014dc:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014de:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	75 dd                	jne    8014c8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801502:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801505:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801508:	73 50                	jae    80155a <memmove+0x6a>
  80150a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150d:	8b 45 10             	mov    0x10(%ebp),%eax
  801510:	01 d0                	add    %edx,%eax
  801512:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801515:	76 43                	jbe    80155a <memmove+0x6a>
		s += n;
  801517:	8b 45 10             	mov    0x10(%ebp),%eax
  80151a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80151d:	8b 45 10             	mov    0x10(%ebp),%eax
  801520:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801523:	eb 10                	jmp    801535 <memmove+0x45>
			*--d = *--s;
  801525:	ff 4d f8             	decl   -0x8(%ebp)
  801528:	ff 4d fc             	decl   -0x4(%ebp)
  80152b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152e:	8a 10                	mov    (%eax),%dl
  801530:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801533:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801535:	8b 45 10             	mov    0x10(%ebp),%eax
  801538:	8d 50 ff             	lea    -0x1(%eax),%edx
  80153b:	89 55 10             	mov    %edx,0x10(%ebp)
  80153e:	85 c0                	test   %eax,%eax
  801540:	75 e3                	jne    801525 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801542:	eb 23                	jmp    801567 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801544:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801547:	8d 50 01             	lea    0x1(%eax),%edx
  80154a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80154d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801550:	8d 4a 01             	lea    0x1(%edx),%ecx
  801553:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801556:	8a 12                	mov    (%edx),%dl
  801558:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80155a:	8b 45 10             	mov    0x10(%ebp),%eax
  80155d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801560:	89 55 10             	mov    %edx,0x10(%ebp)
  801563:	85 c0                	test   %eax,%eax
  801565:	75 dd                	jne    801544 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801578:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80157e:	eb 2a                	jmp    8015aa <memcmp+0x3e>
		if (*s1 != *s2)
  801580:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801583:	8a 10                	mov    (%eax),%dl
  801585:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	38 c2                	cmp    %al,%dl
  80158c:	74 16                	je     8015a4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80158e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801591:	8a 00                	mov    (%eax),%al
  801593:	0f b6 d0             	movzbl %al,%edx
  801596:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801599:	8a 00                	mov    (%eax),%al
  80159b:	0f b6 c0             	movzbl %al,%eax
  80159e:	29 c2                	sub    %eax,%edx
  8015a0:	89 d0                	mov    %edx,%eax
  8015a2:	eb 18                	jmp    8015bc <memcmp+0x50>
		s1++, s2++;
  8015a4:	ff 45 fc             	incl   -0x4(%ebp)
  8015a7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	75 c9                	jne    801580 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ca:	01 d0                	add    %edx,%eax
  8015cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015cf:	eb 15                	jmp    8015e6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	8a 00                	mov    (%eax),%al
  8015d6:	0f b6 d0             	movzbl %al,%edx
  8015d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dc:	0f b6 c0             	movzbl %al,%eax
  8015df:	39 c2                	cmp    %eax,%edx
  8015e1:	74 0d                	je     8015f0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015e3:	ff 45 08             	incl   0x8(%ebp)
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015ec:	72 e3                	jb     8015d1 <memfind+0x13>
  8015ee:	eb 01                	jmp    8015f1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015f0:	90                   	nop
	return (void *) s;
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801603:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80160a:	eb 03                	jmp    80160f <strtol+0x19>
		s++;
  80160c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	8a 00                	mov    (%eax),%al
  801614:	3c 20                	cmp    $0x20,%al
  801616:	74 f4                	je     80160c <strtol+0x16>
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	8a 00                	mov    (%eax),%al
  80161d:	3c 09                	cmp    $0x9,%al
  80161f:	74 eb                	je     80160c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	8a 00                	mov    (%eax),%al
  801626:	3c 2b                	cmp    $0x2b,%al
  801628:	75 05                	jne    80162f <strtol+0x39>
		s++;
  80162a:	ff 45 08             	incl   0x8(%ebp)
  80162d:	eb 13                	jmp    801642 <strtol+0x4c>
	else if (*s == '-')
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	8a 00                	mov    (%eax),%al
  801634:	3c 2d                	cmp    $0x2d,%al
  801636:	75 0a                	jne    801642 <strtol+0x4c>
		s++, neg = 1;
  801638:	ff 45 08             	incl   0x8(%ebp)
  80163b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801642:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801646:	74 06                	je     80164e <strtol+0x58>
  801648:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80164c:	75 20                	jne    80166e <strtol+0x78>
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	3c 30                	cmp    $0x30,%al
  801655:	75 17                	jne    80166e <strtol+0x78>
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	40                   	inc    %eax
  80165b:	8a 00                	mov    (%eax),%al
  80165d:	3c 78                	cmp    $0x78,%al
  80165f:	75 0d                	jne    80166e <strtol+0x78>
		s += 2, base = 16;
  801661:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801665:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80166c:	eb 28                	jmp    801696 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80166e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801672:	75 15                	jne    801689 <strtol+0x93>
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	3c 30                	cmp    $0x30,%al
  80167b:	75 0c                	jne    801689 <strtol+0x93>
		s++, base = 8;
  80167d:	ff 45 08             	incl   0x8(%ebp)
  801680:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801687:	eb 0d                	jmp    801696 <strtol+0xa0>
	else if (base == 0)
  801689:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168d:	75 07                	jne    801696 <strtol+0xa0>
		base = 10;
  80168f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	8a 00                	mov    (%eax),%al
  80169b:	3c 2f                	cmp    $0x2f,%al
  80169d:	7e 19                	jle    8016b8 <strtol+0xc2>
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	3c 39                	cmp    $0x39,%al
  8016a6:	7f 10                	jg     8016b8 <strtol+0xc2>
			dig = *s - '0';
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	0f be c0             	movsbl %al,%eax
  8016b0:	83 e8 30             	sub    $0x30,%eax
  8016b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016b6:	eb 42                	jmp    8016fa <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8a 00                	mov    (%eax),%al
  8016bd:	3c 60                	cmp    $0x60,%al
  8016bf:	7e 19                	jle    8016da <strtol+0xe4>
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	8a 00                	mov    (%eax),%al
  8016c6:	3c 7a                	cmp    $0x7a,%al
  8016c8:	7f 10                	jg     8016da <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	8a 00                	mov    (%eax),%al
  8016cf:	0f be c0             	movsbl %al,%eax
  8016d2:	83 e8 57             	sub    $0x57,%eax
  8016d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d8:	eb 20                	jmp    8016fa <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	3c 40                	cmp    $0x40,%al
  8016e1:	7e 39                	jle    80171c <strtol+0x126>
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	3c 5a                	cmp    $0x5a,%al
  8016ea:	7f 30                	jg     80171c <strtol+0x126>
			dig = *s - 'A' + 10;
  8016ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ef:	8a 00                	mov    (%eax),%al
  8016f1:	0f be c0             	movsbl %al,%eax
  8016f4:	83 e8 37             	sub    $0x37,%eax
  8016f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fd:	3b 45 10             	cmp    0x10(%ebp),%eax
  801700:	7d 19                	jge    80171b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801702:	ff 45 08             	incl   0x8(%ebp)
  801705:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801708:	0f af 45 10          	imul   0x10(%ebp),%eax
  80170c:	89 c2                	mov    %eax,%edx
  80170e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801711:	01 d0                	add    %edx,%eax
  801713:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801716:	e9 7b ff ff ff       	jmp    801696 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80171b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80171c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801720:	74 08                	je     80172a <strtol+0x134>
		*endptr = (char *) s;
  801722:	8b 45 0c             	mov    0xc(%ebp),%eax
  801725:	8b 55 08             	mov    0x8(%ebp),%edx
  801728:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80172a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80172e:	74 07                	je     801737 <strtol+0x141>
  801730:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801733:	f7 d8                	neg    %eax
  801735:	eb 03                	jmp    80173a <strtol+0x144>
  801737:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <ltostr>:

void
ltostr(long value, char *str)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801742:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801749:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801750:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801754:	79 13                	jns    801769 <ltostr+0x2d>
	{
		neg = 1;
  801756:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80175d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801760:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801763:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801766:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801771:	99                   	cltd   
  801772:	f7 f9                	idiv   %ecx
  801774:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801777:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177a:	8d 50 01             	lea    0x1(%eax),%edx
  80177d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801780:	89 c2                	mov    %eax,%edx
  801782:	8b 45 0c             	mov    0xc(%ebp),%eax
  801785:	01 d0                	add    %edx,%eax
  801787:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80178a:	83 c2 30             	add    $0x30,%edx
  80178d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80178f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801792:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801797:	f7 e9                	imul   %ecx
  801799:	c1 fa 02             	sar    $0x2,%edx
  80179c:	89 c8                	mov    %ecx,%eax
  80179e:	c1 f8 1f             	sar    $0x1f,%eax
  8017a1:	29 c2                	sub    %eax,%edx
  8017a3:	89 d0                	mov    %edx,%eax
  8017a5:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8017a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017ac:	75 bb                	jne    801769 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b8:	48                   	dec    %eax
  8017b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017c0:	74 3d                	je     8017ff <ltostr+0xc3>
		start = 1 ;
  8017c2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017c9:	eb 34                	jmp    8017ff <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8017cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d1:	01 d0                	add    %edx,%eax
  8017d3:	8a 00                	mov    (%eax),%al
  8017d5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017de:	01 c2                	add    %eax,%edx
  8017e0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e6:	01 c8                	add    %ecx,%eax
  8017e8:	8a 00                	mov    (%eax),%al
  8017ea:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f2:	01 c2                	add    %eax,%edx
  8017f4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017f7:	88 02                	mov    %al,(%edx)
		start++ ;
  8017f9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017fc:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801802:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801805:	7c c4                	jl     8017cb <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801807:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80180a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180d:	01 d0                	add    %edx,%eax
  80180f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801812:	90                   	nop
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80181b:	ff 75 08             	pushl  0x8(%ebp)
  80181e:	e8 73 fa ff ff       	call   801296 <strlen>
  801823:	83 c4 04             	add    $0x4,%esp
  801826:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801829:	ff 75 0c             	pushl  0xc(%ebp)
  80182c:	e8 65 fa ff ff       	call   801296 <strlen>
  801831:	83 c4 04             	add    $0x4,%esp
  801834:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801837:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80183e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801845:	eb 17                	jmp    80185e <strcconcat+0x49>
		final[s] = str1[s] ;
  801847:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80184a:	8b 45 10             	mov    0x10(%ebp),%eax
  80184d:	01 c2                	add    %eax,%edx
  80184f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	01 c8                	add    %ecx,%eax
  801857:	8a 00                	mov    (%eax),%al
  801859:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80185b:	ff 45 fc             	incl   -0x4(%ebp)
  80185e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801861:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801864:	7c e1                	jl     801847 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801866:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80186d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801874:	eb 1f                	jmp    801895 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801876:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801879:	8d 50 01             	lea    0x1(%eax),%edx
  80187c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80187f:	89 c2                	mov    %eax,%edx
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	01 c2                	add    %eax,%edx
  801886:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801889:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188c:	01 c8                	add    %ecx,%eax
  80188e:	8a 00                	mov    (%eax),%al
  801890:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801892:	ff 45 f8             	incl   -0x8(%ebp)
  801895:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801898:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80189b:	7c d9                	jl     801876 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80189d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a3:	01 d0                	add    %edx,%eax
  8018a5:	c6 00 00             	movb   $0x0,(%eax)
}
  8018a8:	90                   	nop
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ba:	8b 00                	mov    (%eax),%eax
  8018bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c6:	01 d0                	add    %edx,%eax
  8018c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018ce:	eb 0c                	jmp    8018dc <strsplit+0x31>
			*string++ = 0;
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	8d 50 01             	lea    0x1(%eax),%edx
  8018d6:	89 55 08             	mov    %edx,0x8(%ebp)
  8018d9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	8a 00                	mov    (%eax),%al
  8018e1:	84 c0                	test   %al,%al
  8018e3:	74 18                	je     8018fd <strsplit+0x52>
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	8a 00                	mov    (%eax),%al
  8018ea:	0f be c0             	movsbl %al,%eax
  8018ed:	50                   	push   %eax
  8018ee:	ff 75 0c             	pushl  0xc(%ebp)
  8018f1:	e8 32 fb ff ff       	call   801428 <strchr>
  8018f6:	83 c4 08             	add    $0x8,%esp
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	75 d3                	jne    8018d0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	8a 00                	mov    (%eax),%al
  801902:	84 c0                	test   %al,%al
  801904:	74 5a                	je     801960 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801906:	8b 45 14             	mov    0x14(%ebp),%eax
  801909:	8b 00                	mov    (%eax),%eax
  80190b:	83 f8 0f             	cmp    $0xf,%eax
  80190e:	75 07                	jne    801917 <strsplit+0x6c>
		{
			return 0;
  801910:	b8 00 00 00 00       	mov    $0x0,%eax
  801915:	eb 66                	jmp    80197d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801917:	8b 45 14             	mov    0x14(%ebp),%eax
  80191a:	8b 00                	mov    (%eax),%eax
  80191c:	8d 48 01             	lea    0x1(%eax),%ecx
  80191f:	8b 55 14             	mov    0x14(%ebp),%edx
  801922:	89 0a                	mov    %ecx,(%edx)
  801924:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80192b:	8b 45 10             	mov    0x10(%ebp),%eax
  80192e:	01 c2                	add    %eax,%edx
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801935:	eb 03                	jmp    80193a <strsplit+0x8f>
			string++;
  801937:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	84 c0                	test   %al,%al
  801941:	74 8b                	je     8018ce <strsplit+0x23>
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	8a 00                	mov    (%eax),%al
  801948:	0f be c0             	movsbl %al,%eax
  80194b:	50                   	push   %eax
  80194c:	ff 75 0c             	pushl  0xc(%ebp)
  80194f:	e8 d4 fa ff ff       	call   801428 <strchr>
  801954:	83 c4 08             	add    $0x8,%esp
  801957:	85 c0                	test   %eax,%eax
  801959:	74 dc                	je     801937 <strsplit+0x8c>
			string++;
	}
  80195b:	e9 6e ff ff ff       	jmp    8018ce <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801960:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801961:	8b 45 14             	mov    0x14(%ebp),%eax
  801964:	8b 00                	mov    (%eax),%eax
  801966:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80196d:	8b 45 10             	mov    0x10(%ebp),%eax
  801970:	01 d0                	add    %edx,%eax
  801972:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801978:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801985:	83 ec 04             	sub    $0x4,%esp
  801988:	68 fc 49 80 00       	push   $0x8049fc
  80198d:	68 3f 01 00 00       	push   $0x13f
  801992:	68 1e 4a 80 00       	push   $0x804a1e
  801997:	e8 a1 ed ff ff       	call   80073d <_panic>

0080199c <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8019a2:	83 ec 0c             	sub    $0xc,%esp
  8019a5:	ff 75 08             	pushl  0x8(%ebp)
  8019a8:	e8 f8 0a 00 00       	call   8024a5 <sys_sbrk>
  8019ad:	83 c4 10             	add    $0x10,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8019b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019bc:	75 0a                	jne    8019c8 <malloc+0x16>
  8019be:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c3:	e9 07 02 00 00       	jmp    801bcf <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  8019c8:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8019cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019d5:	01 d0                	add    %edx,%eax
  8019d7:	48                   	dec    %eax
  8019d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8019db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019de:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e3:	f7 75 dc             	divl   -0x24(%ebp)
  8019e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019e9:	29 d0                	sub    %edx,%eax
  8019eb:	c1 e8 0c             	shr    $0xc,%eax
  8019ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  8019f1:	a1 24 50 80 00       	mov    0x805024,%eax
  8019f6:	8b 40 78             	mov    0x78(%eax),%eax
  8019f9:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8019fe:	29 c2                	sub    %eax,%edx
  801a00:	89 d0                	mov    %edx,%eax
  801a02:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801a05:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a0d:	c1 e8 0c             	shr    $0xc,%eax
  801a10:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801a13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801a1a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801a21:	77 42                	ja     801a65 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a23:	e8 01 09 00 00       	call   802329 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	74 16                	je     801a42 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801a2c:	83 ec 0c             	sub    $0xc,%esp
  801a2f:	ff 75 08             	pushl  0x8(%ebp)
  801a32:	e8 dd 0e 00 00       	call   802914 <alloc_block_FF>
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a3d:	e9 8a 01 00 00       	jmp    801bcc <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801a42:	e8 13 09 00 00       	call   80235a <sys_isUHeapPlacementStrategyBESTFIT>
  801a47:	85 c0                	test   %eax,%eax
  801a49:	0f 84 7d 01 00 00    	je     801bcc <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	e8 76 13 00 00       	call   802dd0 <alloc_block_BF>
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a60:	e9 67 01 00 00       	jmp    801bcc <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801a65:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801a68:	48                   	dec    %eax
  801a69:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801a6c:	0f 86 53 01 00 00    	jbe    801bc5 <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801a72:	a1 24 50 80 00       	mov    0x805024,%eax
  801a77:	8b 40 78             	mov    0x78(%eax),%eax
  801a7a:	05 00 10 00 00       	add    $0x1000,%eax
  801a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801a82:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801a89:	e9 de 00 00 00       	jmp    801b6c <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801a8e:	a1 24 50 80 00       	mov    0x805024,%eax
  801a93:	8b 40 78             	mov    0x78(%eax),%eax
  801a96:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a99:	29 c2                	sub    %eax,%edx
  801a9b:	89 d0                	mov    %edx,%eax
  801a9d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801aa2:	c1 e8 0c             	shr    $0xc,%eax
  801aa5:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801aac:	85 c0                	test   %eax,%eax
  801aae:	0f 85 ab 00 00 00    	jne    801b5f <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab7:	05 00 10 00 00       	add    $0x1000,%eax
  801abc:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801abf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  801ac6:	eb 47                	jmp    801b0f <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801ac8:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801acf:	76 0a                	jbe    801adb <malloc+0x129>
  801ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad6:	e9 f4 00 00 00       	jmp    801bcf <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801adb:	a1 24 50 80 00       	mov    0x805024,%eax
  801ae0:	8b 40 78             	mov    0x78(%eax),%eax
  801ae3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ae6:	29 c2                	sub    %eax,%edx
  801ae8:	89 d0                	mov    %edx,%eax
  801aea:	2d 00 10 00 00       	sub    $0x1000,%eax
  801aef:	c1 e8 0c             	shr    $0xc,%eax
  801af2:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801af9:	85 c0                	test   %eax,%eax
  801afb:	74 08                	je     801b05 <malloc+0x153>
					{
						
						i = j;
  801afd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801b03:	eb 5a                	jmp    801b5f <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801b05:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801b0c:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  801b0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b12:	48                   	dec    %eax
  801b13:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b16:	77 b0                	ja     801ac8 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801b18:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801b1f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b26:	eb 2f                	jmp    801b57 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b2b:	c1 e0 0c             	shl    $0xc,%eax
  801b2e:	89 c2                	mov    %eax,%edx
  801b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b33:	01 c2                	add    %eax,%edx
  801b35:	a1 24 50 80 00       	mov    0x805024,%eax
  801b3a:	8b 40 78             	mov    0x78(%eax),%eax
  801b3d:	29 c2                	sub    %eax,%edx
  801b3f:	89 d0                	mov    %edx,%eax
  801b41:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b46:	c1 e8 0c             	shr    $0xc,%eax
  801b49:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  801b50:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801b54:	ff 45 e0             	incl   -0x20(%ebp)
  801b57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b5a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801b5d:	72 c9                	jb     801b28 <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  801b5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b63:	75 16                	jne    801b7b <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801b65:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801b6c:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801b73:	0f 86 15 ff ff ff    	jbe    801a8e <malloc+0xdc>
  801b79:	eb 01                	jmp    801b7c <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  801b7b:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801b7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b80:	75 07                	jne    801b89 <malloc+0x1d7>
  801b82:	b8 00 00 00 00       	mov    $0x0,%eax
  801b87:	eb 46                	jmp    801bcf <malloc+0x21d>
		ptr = (void*)i;
  801b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801b8f:	a1 24 50 80 00       	mov    0x805024,%eax
  801b94:	8b 40 78             	mov    0x78(%eax),%eax
  801b97:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b9a:	29 c2                	sub    %eax,%edx
  801b9c:	89 d0                	mov    %edx,%eax
  801b9e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ba3:	c1 e8 0c             	shr    $0xc,%eax
  801ba6:	89 c2                	mov    %eax,%edx
  801ba8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bab:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801bb2:	83 ec 08             	sub    $0x8,%esp
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	ff 75 f0             	pushl  -0x10(%ebp)
  801bbb:	e8 1c 09 00 00       	call   8024dc <sys_allocate_user_mem>
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	eb 07                	jmp    801bcc <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  801bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bca:	eb 03                	jmp    801bcf <malloc+0x21d>
	}
	return ptr;
  801bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801bd7:	a1 24 50 80 00       	mov    0x805024,%eax
  801bdc:	8b 40 78             	mov    0x78(%eax),%eax
  801bdf:	05 00 10 00 00       	add    $0x1000,%eax
  801be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801be7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801bee:	a1 24 50 80 00       	mov    0x805024,%eax
  801bf3:	8b 50 78             	mov    0x78(%eax),%edx
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	39 c2                	cmp    %eax,%edx
  801bfb:	76 24                	jbe    801c21 <free+0x50>
		size = get_block_size(va);
  801bfd:	83 ec 0c             	sub    $0xc,%esp
  801c00:	ff 75 08             	pushl  0x8(%ebp)
  801c03:	e8 8c 09 00 00       	call   802594 <get_block_size>
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c0e:	83 ec 0c             	sub    $0xc,%esp
  801c11:	ff 75 08             	pushl  0x8(%ebp)
  801c14:	e8 9c 1b 00 00       	call   8037b5 <free_block>
  801c19:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801c1c:	e9 ac 00 00 00       	jmp    801ccd <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c27:	0f 82 89 00 00 00    	jb     801cb6 <free+0xe5>
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801c35:	77 7f                	ja     801cb6 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801c37:	8b 55 08             	mov    0x8(%ebp),%edx
  801c3a:	a1 24 50 80 00       	mov    0x805024,%eax
  801c3f:	8b 40 78             	mov    0x78(%eax),%eax
  801c42:	29 c2                	sub    %eax,%edx
  801c44:	89 d0                	mov    %edx,%eax
  801c46:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c4b:	c1 e8 0c             	shr    $0xc,%eax
  801c4e:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801c55:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801c58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c5b:	c1 e0 0c             	shl    $0xc,%eax
  801c5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801c61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801c68:	eb 42                	jmp    801cac <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6d:	c1 e0 0c             	shl    $0xc,%eax
  801c70:	89 c2                	mov    %eax,%edx
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	01 c2                	add    %eax,%edx
  801c77:	a1 24 50 80 00       	mov    0x805024,%eax
  801c7c:	8b 40 78             	mov    0x78(%eax),%eax
  801c7f:	29 c2                	sub    %eax,%edx
  801c81:	89 d0                	mov    %edx,%eax
  801c83:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c88:	c1 e8 0c             	shr    $0xc,%eax
  801c8b:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801c92:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801c96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	83 ec 08             	sub    $0x8,%esp
  801c9f:	52                   	push   %edx
  801ca0:	50                   	push   %eax
  801ca1:	e8 1a 08 00 00       	call   8024c0 <sys_free_user_mem>
  801ca6:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801ca9:	ff 45 f4             	incl   -0xc(%ebp)
  801cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801caf:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801cb2:	72 b6                	jb     801c6a <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801cb4:	eb 17                	jmp    801ccd <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801cb6:	83 ec 04             	sub    $0x4,%esp
  801cb9:	68 2c 4a 80 00       	push   $0x804a2c
  801cbe:	68 87 00 00 00       	push   $0x87
  801cc3:	68 56 4a 80 00       	push   $0x804a56
  801cc8:	e8 70 ea ff ff       	call   80073d <_panic>
	}
}
  801ccd:	90                   	nop
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 28             	sub    $0x28,%esp
  801cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd9:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801cdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ce0:	75 0a                	jne    801cec <smalloc+0x1c>
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce7:	e9 87 00 00 00       	jmp    801d73 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cf2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801cf9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cff:	39 d0                	cmp    %edx,%eax
  801d01:	73 02                	jae    801d05 <smalloc+0x35>
  801d03:	89 d0                	mov    %edx,%eax
  801d05:	83 ec 0c             	sub    $0xc,%esp
  801d08:	50                   	push   %eax
  801d09:	e8 a4 fc ff ff       	call   8019b2 <malloc>
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801d14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d18:	75 07                	jne    801d21 <smalloc+0x51>
  801d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1f:	eb 52                	jmp    801d73 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d21:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d25:	ff 75 ec             	pushl  -0x14(%ebp)
  801d28:	50                   	push   %eax
  801d29:	ff 75 0c             	pushl  0xc(%ebp)
  801d2c:	ff 75 08             	pushl  0x8(%ebp)
  801d2f:	e8 93 03 00 00       	call   8020c7 <sys_createSharedObject>
  801d34:	83 c4 10             	add    $0x10,%esp
  801d37:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801d3a:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801d3e:	74 06                	je     801d46 <smalloc+0x76>
  801d40:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801d44:	75 07                	jne    801d4d <smalloc+0x7d>
  801d46:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4b:	eb 26                	jmp    801d73 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801d4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d50:	a1 24 50 80 00       	mov    0x805024,%eax
  801d55:	8b 40 78             	mov    0x78(%eax),%eax
  801d58:	29 c2                	sub    %eax,%edx
  801d5a:	89 d0                	mov    %edx,%eax
  801d5c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d61:	c1 e8 0c             	shr    $0xc,%eax
  801d64:	89 c2                	mov    %eax,%edx
  801d66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d69:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801d70:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d7b:	83 ec 08             	sub    $0x8,%esp
  801d7e:	ff 75 0c             	pushl  0xc(%ebp)
  801d81:	ff 75 08             	pushl  0x8(%ebp)
  801d84:	e8 68 03 00 00       	call   8020f1 <sys_getSizeOfSharedObject>
  801d89:	83 c4 10             	add    $0x10,%esp
  801d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801d8f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801d93:	75 07                	jne    801d9c <sget+0x27>
  801d95:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9a:	eb 7f                	jmp    801e1b <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801da2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801da9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801daf:	39 d0                	cmp    %edx,%eax
  801db1:	73 02                	jae    801db5 <sget+0x40>
  801db3:	89 d0                	mov    %edx,%eax
  801db5:	83 ec 0c             	sub    $0xc,%esp
  801db8:	50                   	push   %eax
  801db9:	e8 f4 fb ff ff       	call   8019b2 <malloc>
  801dbe:	83 c4 10             	add    $0x10,%esp
  801dc1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801dc4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801dc8:	75 07                	jne    801dd1 <sget+0x5c>
  801dca:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcf:	eb 4a                	jmp    801e1b <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801dd1:	83 ec 04             	sub    $0x4,%esp
  801dd4:	ff 75 e8             	pushl  -0x18(%ebp)
  801dd7:	ff 75 0c             	pushl  0xc(%ebp)
  801dda:	ff 75 08             	pushl  0x8(%ebp)
  801ddd:	e8 2c 03 00 00       	call   80210e <sys_getSharedObject>
  801de2:	83 c4 10             	add    $0x10,%esp
  801de5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801de8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801deb:	a1 24 50 80 00       	mov    0x805024,%eax
  801df0:	8b 40 78             	mov    0x78(%eax),%eax
  801df3:	29 c2                	sub    %eax,%edx
  801df5:	89 d0                	mov    %edx,%eax
  801df7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dfc:	c1 e8 0c             	shr    $0xc,%eax
  801dff:	89 c2                	mov    %eax,%edx
  801e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e04:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801e0b:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801e0f:	75 07                	jne    801e18 <sget+0xa3>
  801e11:	b8 00 00 00 00       	mov    $0x0,%eax
  801e16:	eb 03                	jmp    801e1b <sget+0xa6>
	return ptr;
  801e18:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801e23:	8b 55 08             	mov    0x8(%ebp),%edx
  801e26:	a1 24 50 80 00       	mov    0x805024,%eax
  801e2b:	8b 40 78             	mov    0x78(%eax),%eax
  801e2e:	29 c2                	sub    %eax,%edx
  801e30:	89 d0                	mov    %edx,%eax
  801e32:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e37:	c1 e8 0c             	shr    $0xc,%eax
  801e3a:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801e41:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801e44:	83 ec 08             	sub    $0x8,%esp
  801e47:	ff 75 08             	pushl  0x8(%ebp)
  801e4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4d:	e8 db 02 00 00       	call   80212d <sys_freeSharedObject>
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801e58:	90                   	nop
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e61:	83 ec 04             	sub    $0x4,%esp
  801e64:	68 64 4a 80 00       	push   $0x804a64
  801e69:	68 e4 00 00 00       	push   $0xe4
  801e6e:	68 56 4a 80 00       	push   $0x804a56
  801e73:	e8 c5 e8 ff ff       	call   80073d <_panic>

00801e78 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e7e:	83 ec 04             	sub    $0x4,%esp
  801e81:	68 8a 4a 80 00       	push   $0x804a8a
  801e86:	68 f0 00 00 00       	push   $0xf0
  801e8b:	68 56 4a 80 00       	push   $0x804a56
  801e90:	e8 a8 e8 ff ff       	call   80073d <_panic>

00801e95 <shrink>:

}
void shrink(uint32 newSize)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	68 8a 4a 80 00       	push   $0x804a8a
  801ea3:	68 f5 00 00 00       	push   $0xf5
  801ea8:	68 56 4a 80 00       	push   $0x804a56
  801ead:	e8 8b e8 ff ff       	call   80073d <_panic>

00801eb2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eb8:	83 ec 04             	sub    $0x4,%esp
  801ebb:	68 8a 4a 80 00       	push   $0x804a8a
  801ec0:	68 fa 00 00 00       	push   $0xfa
  801ec5:	68 56 4a 80 00       	push   $0x804a56
  801eca:	e8 6e e8 ff ff       	call   80073d <_panic>

00801ecf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	57                   	push   %edi
  801ed3:	56                   	push   %esi
  801ed4:	53                   	push   %ebx
  801ed5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ede:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee4:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ee7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801eea:	cd 30                	int    $0x30
  801eec:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ef2:	83 c4 10             	add    $0x10,%esp
  801ef5:	5b                   	pop    %ebx
  801ef6:	5e                   	pop    %esi
  801ef7:	5f                   	pop    %edi
  801ef8:	5d                   	pop    %ebp
  801ef9:	c3                   	ret    

00801efa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 04             	sub    $0x4,%esp
  801f00:	8b 45 10             	mov    0x10(%ebp),%eax
  801f03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f06:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	52                   	push   %edx
  801f12:	ff 75 0c             	pushl  0xc(%ebp)
  801f15:	50                   	push   %eax
  801f16:	6a 00                	push   $0x0
  801f18:	e8 b2 ff ff ff       	call   801ecf <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
}
  801f20:	90                   	nop
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 02                	push   $0x2
  801f32:	e8 98 ff ff ff       	call   801ecf <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_lock_cons>:

void sys_lock_cons(void)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 03                	push   $0x3
  801f4b:	e8 7f ff ff ff       	call   801ecf <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
}
  801f53:	90                   	nop
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 04                	push   $0x4
  801f65:	e8 65 ff ff ff       	call   801ecf <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
}
  801f6d:	90                   	nop
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	52                   	push   %edx
  801f80:	50                   	push   %eax
  801f81:	6a 08                	push   $0x8
  801f83:	e8 47 ff ff ff       	call   801ecf <syscall>
  801f88:	83 c4 18             	add    $0x18,%esp
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	56                   	push   %esi
  801f91:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f92:	8b 75 18             	mov    0x18(%ebp),%esi
  801f95:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	56                   	push   %esi
  801fa2:	53                   	push   %ebx
  801fa3:	51                   	push   %ecx
  801fa4:	52                   	push   %edx
  801fa5:	50                   	push   %eax
  801fa6:	6a 09                	push   $0x9
  801fa8:	e8 22 ff ff ff       	call   801ecf <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
}
  801fb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb3:	5b                   	pop    %ebx
  801fb4:	5e                   	pop    %esi
  801fb5:	5d                   	pop    %ebp
  801fb6:	c3                   	ret    

00801fb7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	52                   	push   %edx
  801fc7:	50                   	push   %eax
  801fc8:	6a 0a                	push   $0xa
  801fca:	e8 00 ff ff ff       	call   801ecf <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	ff 75 0c             	pushl  0xc(%ebp)
  801fe0:	ff 75 08             	pushl  0x8(%ebp)
  801fe3:	6a 0b                	push   $0xb
  801fe5:	e8 e5 fe ff ff       	call   801ecf <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 0c                	push   $0xc
  801ffe:	e8 cc fe ff ff       	call   801ecf <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 0d                	push   $0xd
  802017:	e8 b3 fe ff ff       	call   801ecf <syscall>
  80201c:	83 c4 18             	add    $0x18,%esp
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 0e                	push   $0xe
  802030:	e8 9a fe ff ff       	call   801ecf <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 0f                	push   $0xf
  802049:	e8 81 fe ff ff       	call   801ecf <syscall>
  80204e:	83 c4 18             	add    $0x18,%esp
}
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	ff 75 08             	pushl  0x8(%ebp)
  802061:	6a 10                	push   $0x10
  802063:	e8 67 fe ff ff       	call   801ecf <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 11                	push   $0x11
  80207c:	e8 4e fe ff ff       	call   801ecf <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
}
  802084:	90                   	nop
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_cputc>:

void
sys_cputc(const char c)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802093:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	50                   	push   %eax
  8020a0:	6a 01                	push   $0x1
  8020a2:	e8 28 fe ff ff       	call   801ecf <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
}
  8020aa:	90                   	nop
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 14                	push   $0x14
  8020bc:	e8 0e fe ff ff       	call   801ecf <syscall>
  8020c1:	83 c4 18             	add    $0x18,%esp
}
  8020c4:	90                   	nop
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	83 ec 04             	sub    $0x4,%esp
  8020cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020d3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020d6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	6a 00                	push   $0x0
  8020df:	51                   	push   %ecx
  8020e0:	52                   	push   %edx
  8020e1:	ff 75 0c             	pushl  0xc(%ebp)
  8020e4:	50                   	push   %eax
  8020e5:	6a 15                	push   $0x15
  8020e7:	e8 e3 fd ff ff       	call   801ecf <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8020f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	52                   	push   %edx
  802101:	50                   	push   %eax
  802102:	6a 16                	push   $0x16
  802104:	e8 c6 fd ff ff       	call   801ecf <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802111:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802114:	8b 55 0c             	mov    0xc(%ebp),%edx
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	51                   	push   %ecx
  80211f:	52                   	push   %edx
  802120:	50                   	push   %eax
  802121:	6a 17                	push   $0x17
  802123:	e8 a7 fd ff ff       	call   801ecf <syscall>
  802128:	83 c4 18             	add    $0x18,%esp
}
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802130:	8b 55 0c             	mov    0xc(%ebp),%edx
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	52                   	push   %edx
  80213d:	50                   	push   %eax
  80213e:	6a 18                	push   $0x18
  802140:	e8 8a fd ff ff       	call   801ecf <syscall>
  802145:	83 c4 18             	add    $0x18,%esp
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	6a 00                	push   $0x0
  802152:	ff 75 14             	pushl  0x14(%ebp)
  802155:	ff 75 10             	pushl  0x10(%ebp)
  802158:	ff 75 0c             	pushl  0xc(%ebp)
  80215b:	50                   	push   %eax
  80215c:	6a 19                	push   $0x19
  80215e:	e8 6c fd ff ff       	call   801ecf <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	50                   	push   %eax
  802177:	6a 1a                	push   $0x1a
  802179:	e8 51 fd ff ff       	call   801ecf <syscall>
  80217e:	83 c4 18             	add    $0x18,%esp
}
  802181:	90                   	nop
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	50                   	push   %eax
  802193:	6a 1b                	push   $0x1b
  802195:	e8 35 fd ff ff       	call   801ecf <syscall>
  80219a:	83 c4 18             	add    $0x18,%esp
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 05                	push   $0x5
  8021ae:	e8 1c fd ff ff       	call   801ecf <syscall>
  8021b3:	83 c4 18             	add    $0x18,%esp
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 06                	push   $0x6
  8021c7:	e8 03 fd ff ff       	call   801ecf <syscall>
  8021cc:	83 c4 18             	add    $0x18,%esp
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 07                	push   $0x7
  8021e0:	e8 ea fc ff ff       	call   801ecf <syscall>
  8021e5:	83 c4 18             	add    $0x18,%esp
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <sys_exit_env>:


void sys_exit_env(void)
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 1c                	push   $0x1c
  8021f9:	e8 d1 fc ff ff       	call   801ecf <syscall>
  8021fe:	83 c4 18             	add    $0x18,%esp
}
  802201:	90                   	nop
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80220a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80220d:	8d 50 04             	lea    0x4(%eax),%edx
  802210:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	52                   	push   %edx
  80221a:	50                   	push   %eax
  80221b:	6a 1d                	push   $0x1d
  80221d:	e8 ad fc ff ff       	call   801ecf <syscall>
  802222:	83 c4 18             	add    $0x18,%esp
	return result;
  802225:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802228:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80222b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80222e:	89 01                	mov    %eax,(%ecx)
  802230:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	c9                   	leave  
  802237:	c2 04 00             	ret    $0x4

0080223a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	ff 75 10             	pushl  0x10(%ebp)
  802244:	ff 75 0c             	pushl  0xc(%ebp)
  802247:	ff 75 08             	pushl  0x8(%ebp)
  80224a:	6a 13                	push   $0x13
  80224c:	e8 7e fc ff ff       	call   801ecf <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
	return ;
  802254:	90                   	nop
}
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sys_rcr2>:
uint32 sys_rcr2()
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 1e                	push   $0x1e
  802266:	e8 64 fc ff ff       	call   801ecf <syscall>
  80226b:	83 c4 18             	add    $0x18,%esp
}
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	83 ec 04             	sub    $0x4,%esp
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80227c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	50                   	push   %eax
  802289:	6a 1f                	push   $0x1f
  80228b:	e8 3f fc ff ff       	call   801ecf <syscall>
  802290:	83 c4 18             	add    $0x18,%esp
	return ;
  802293:	90                   	nop
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <rsttst>:
void rsttst()
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 21                	push   $0x21
  8022a5:	e8 25 fc ff ff       	call   801ecf <syscall>
  8022aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ad:	90                   	nop
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	83 ec 04             	sub    $0x4,%esp
  8022b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022bc:	8b 55 18             	mov    0x18(%ebp),%edx
  8022bf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022c3:	52                   	push   %edx
  8022c4:	50                   	push   %eax
  8022c5:	ff 75 10             	pushl  0x10(%ebp)
  8022c8:	ff 75 0c             	pushl  0xc(%ebp)
  8022cb:	ff 75 08             	pushl  0x8(%ebp)
  8022ce:	6a 20                	push   $0x20
  8022d0:	e8 fa fb ff ff       	call   801ecf <syscall>
  8022d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d8:	90                   	nop
}
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <chktst>:
void chktst(uint32 n)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	ff 75 08             	pushl  0x8(%ebp)
  8022e9:	6a 22                	push   $0x22
  8022eb:	e8 df fb ff ff       	call   801ecf <syscall>
  8022f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f3:	90                   	nop
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <inctst>:

void inctst()
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 23                	push   $0x23
  802305:	e8 c5 fb ff ff       	call   801ecf <syscall>
  80230a:	83 c4 18             	add    $0x18,%esp
	return ;
  80230d:	90                   	nop
}
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <gettst>:
uint32 gettst()
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 24                	push   $0x24
  80231f:	e8 ab fb ff ff       	call   801ecf <syscall>
  802324:	83 c4 18             	add    $0x18,%esp
}
  802327:	c9                   	leave  
  802328:	c3                   	ret    

00802329 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 25                	push   $0x25
  80233b:	e8 8f fb ff ff       	call   801ecf <syscall>
  802340:	83 c4 18             	add    $0x18,%esp
  802343:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802346:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80234a:	75 07                	jne    802353 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80234c:	b8 01 00 00 00       	mov    $0x1,%eax
  802351:	eb 05                	jmp    802358 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802353:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
  80235d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 25                	push   $0x25
  80236c:	e8 5e fb ff ff       	call   801ecf <syscall>
  802371:	83 c4 18             	add    $0x18,%esp
  802374:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802377:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80237b:	75 07                	jne    802384 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80237d:	b8 01 00 00 00       	mov    $0x1,%eax
  802382:	eb 05                	jmp    802389 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802384:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 25                	push   $0x25
  80239d:	e8 2d fb ff ff       	call   801ecf <syscall>
  8023a2:	83 c4 18             	add    $0x18,%esp
  8023a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023a8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023ac:	75 07                	jne    8023b5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b3:	eb 05                	jmp    8023ba <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 25                	push   $0x25
  8023ce:	e8 fc fa ff ff       	call   801ecf <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
  8023d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023d9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023dd:	75 07                	jne    8023e6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023df:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e4:	eb 05                	jmp    8023eb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    

008023ed <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	ff 75 08             	pushl  0x8(%ebp)
  8023fb:	6a 26                	push   $0x26
  8023fd:	e8 cd fa ff ff       	call   801ecf <syscall>
  802402:	83 c4 18             	add    $0x18,%esp
	return ;
  802405:	90                   	nop
}
  802406:	c9                   	leave  
  802407:	c3                   	ret    

00802408 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802408:	55                   	push   %ebp
  802409:	89 e5                	mov    %esp,%ebp
  80240b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80240c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80240f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802412:	8b 55 0c             	mov    0xc(%ebp),%edx
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	6a 00                	push   $0x0
  80241a:	53                   	push   %ebx
  80241b:	51                   	push   %ecx
  80241c:	52                   	push   %edx
  80241d:	50                   	push   %eax
  80241e:	6a 27                	push   $0x27
  802420:	e8 aa fa ff ff       	call   801ecf <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
}
  802428:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    

0080242d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802430:	8b 55 0c             	mov    0xc(%ebp),%edx
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	52                   	push   %edx
  80243d:	50                   	push   %eax
  80243e:	6a 28                	push   $0x28
  802440:	e8 8a fa ff ff       	call   801ecf <syscall>
  802445:	83 c4 18             	add    $0x18,%esp
}
  802448:	c9                   	leave  
  802449:	c3                   	ret    

0080244a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80244d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802450:	8b 55 0c             	mov    0xc(%ebp),%edx
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	6a 00                	push   $0x0
  802458:	51                   	push   %ecx
  802459:	ff 75 10             	pushl  0x10(%ebp)
  80245c:	52                   	push   %edx
  80245d:	50                   	push   %eax
  80245e:	6a 29                	push   $0x29
  802460:	e8 6a fa ff ff       	call   801ecf <syscall>
  802465:	83 c4 18             	add    $0x18,%esp
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	ff 75 10             	pushl  0x10(%ebp)
  802474:	ff 75 0c             	pushl  0xc(%ebp)
  802477:	ff 75 08             	pushl  0x8(%ebp)
  80247a:	6a 12                	push   $0x12
  80247c:	e8 4e fa ff ff       	call   801ecf <syscall>
  802481:	83 c4 18             	add    $0x18,%esp
	return ;
  802484:	90                   	nop
}
  802485:	c9                   	leave  
  802486:	c3                   	ret    

00802487 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802487:	55                   	push   %ebp
  802488:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80248a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80248d:	8b 45 08             	mov    0x8(%ebp),%eax
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	52                   	push   %edx
  802497:	50                   	push   %eax
  802498:	6a 2a                	push   $0x2a
  80249a:	e8 30 fa ff ff       	call   801ecf <syscall>
  80249f:	83 c4 18             	add    $0x18,%esp
	return;
  8024a2:	90                   	nop
}
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8024a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	50                   	push   %eax
  8024b4:	6a 2b                	push   $0x2b
  8024b6:	e8 14 fa ff ff       	call   801ecf <syscall>
  8024bb:	83 c4 18             	add    $0x18,%esp
}
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	ff 75 0c             	pushl  0xc(%ebp)
  8024cc:	ff 75 08             	pushl  0x8(%ebp)
  8024cf:	6a 2c                	push   $0x2c
  8024d1:	e8 f9 f9 ff ff       	call   801ecf <syscall>
  8024d6:	83 c4 18             	add    $0x18,%esp
	return;
  8024d9:	90                   	nop
}
  8024da:	c9                   	leave  
  8024db:	c3                   	ret    

008024dc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	ff 75 0c             	pushl  0xc(%ebp)
  8024e8:	ff 75 08             	pushl  0x8(%ebp)
  8024eb:	6a 2d                	push   $0x2d
  8024ed:	e8 dd f9 ff ff       	call   801ecf <syscall>
  8024f2:	83 c4 18             	add    $0x18,%esp
	return;
  8024f5:	90                   	nop
}
  8024f6:	c9                   	leave  
  8024f7:	c3                   	ret    

008024f8 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
  8024fb:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 2e                	push   $0x2e
  80250a:	e8 c0 f9 ff ff       	call   801ecf <syscall>
  80250f:	83 c4 18             	add    $0x18,%esp
  802512:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  802515:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802518:	c9                   	leave  
  802519:	c3                   	ret    

0080251a <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  80251d:	8b 45 08             	mov    0x8(%ebp),%eax
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	50                   	push   %eax
  802529:	6a 2f                	push   $0x2f
  80252b:	e8 9f f9 ff ff       	call   801ecf <syscall>
  802530:	83 c4 18             	add    $0x18,%esp
	return;
  802533:	90                   	nop
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  802539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	52                   	push   %edx
  802546:	50                   	push   %eax
  802547:	6a 30                	push   $0x30
  802549:	e8 81 f9 ff ff       	call   801ecf <syscall>
  80254e:	83 c4 18             	add    $0x18,%esp
	return;
  802551:	90                   	nop
}
  802552:	c9                   	leave  
  802553:	c3                   	ret    

00802554 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
  802557:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  80255a:	8b 45 08             	mov    0x8(%ebp),%eax
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	50                   	push   %eax
  802566:	6a 31                	push   $0x31
  802568:	e8 62 f9 ff ff       	call   801ecf <syscall>
  80256d:	83 c4 18             	add    $0x18,%esp
  802570:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  802573:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  80257b:	8b 45 08             	mov    0x8(%ebp),%eax
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	50                   	push   %eax
  802587:	6a 32                	push   $0x32
  802589:	e8 41 f9 ff ff       	call   801ecf <syscall>
  80258e:	83 c4 18             	add    $0x18,%esp
	return;
  802591:	90                   	nop
}
  802592:	c9                   	leave  
  802593:	c3                   	ret    

00802594 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802594:	55                   	push   %ebp
  802595:	89 e5                	mov    %esp,%ebp
  802597:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	83 e8 04             	sub    $0x4,%eax
  8025a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8025a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a6:	8b 00                	mov    (%eax),%eax
  8025a8:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
  8025b0:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	83 e8 04             	sub    $0x4,%eax
  8025b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8025bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025bf:	8b 00                	mov    (%eax),%eax
  8025c1:	83 e0 01             	and    $0x1,%eax
  8025c4:	85 c0                	test   %eax,%eax
  8025c6:	0f 94 c0             	sete   %al
}
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    

008025cb <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8025d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8025d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025db:	83 f8 02             	cmp    $0x2,%eax
  8025de:	74 2b                	je     80260b <alloc_block+0x40>
  8025e0:	83 f8 02             	cmp    $0x2,%eax
  8025e3:	7f 07                	jg     8025ec <alloc_block+0x21>
  8025e5:	83 f8 01             	cmp    $0x1,%eax
  8025e8:	74 0e                	je     8025f8 <alloc_block+0x2d>
  8025ea:	eb 58                	jmp    802644 <alloc_block+0x79>
  8025ec:	83 f8 03             	cmp    $0x3,%eax
  8025ef:	74 2d                	je     80261e <alloc_block+0x53>
  8025f1:	83 f8 04             	cmp    $0x4,%eax
  8025f4:	74 3b                	je     802631 <alloc_block+0x66>
  8025f6:	eb 4c                	jmp    802644 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8025f8:	83 ec 0c             	sub    $0xc,%esp
  8025fb:	ff 75 08             	pushl  0x8(%ebp)
  8025fe:	e8 11 03 00 00       	call   802914 <alloc_block_FF>
  802603:	83 c4 10             	add    $0x10,%esp
  802606:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802609:	eb 4a                	jmp    802655 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80260b:	83 ec 0c             	sub    $0xc,%esp
  80260e:	ff 75 08             	pushl  0x8(%ebp)
  802611:	e8 c7 19 00 00       	call   803fdd <alloc_block_NF>
  802616:	83 c4 10             	add    $0x10,%esp
  802619:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80261c:	eb 37                	jmp    802655 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80261e:	83 ec 0c             	sub    $0xc,%esp
  802621:	ff 75 08             	pushl  0x8(%ebp)
  802624:	e8 a7 07 00 00       	call   802dd0 <alloc_block_BF>
  802629:	83 c4 10             	add    $0x10,%esp
  80262c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80262f:	eb 24                	jmp    802655 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802631:	83 ec 0c             	sub    $0xc,%esp
  802634:	ff 75 08             	pushl  0x8(%ebp)
  802637:	e8 84 19 00 00       	call   803fc0 <alloc_block_WF>
  80263c:	83 c4 10             	add    $0x10,%esp
  80263f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802642:	eb 11                	jmp    802655 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802644:	83 ec 0c             	sub    $0xc,%esp
  802647:	68 9c 4a 80 00       	push   $0x804a9c
  80264c:	e8 a9 e3 ff ff       	call   8009fa <cprintf>
  802651:	83 c4 10             	add    $0x10,%esp
		break;
  802654:	90                   	nop
	}
	return va;
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802658:	c9                   	leave  
  802659:	c3                   	ret    

0080265a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
  80265d:	53                   	push   %ebx
  80265e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802661:	83 ec 0c             	sub    $0xc,%esp
  802664:	68 bc 4a 80 00       	push   $0x804abc
  802669:	e8 8c e3 ff ff       	call   8009fa <cprintf>
  80266e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802671:	83 ec 0c             	sub    $0xc,%esp
  802674:	68 e7 4a 80 00       	push   $0x804ae7
  802679:	e8 7c e3 ff ff       	call   8009fa <cprintf>
  80267e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802687:	eb 37                	jmp    8026c0 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802689:	83 ec 0c             	sub    $0xc,%esp
  80268c:	ff 75 f4             	pushl  -0xc(%ebp)
  80268f:	e8 19 ff ff ff       	call   8025ad <is_free_block>
  802694:	83 c4 10             	add    $0x10,%esp
  802697:	0f be d8             	movsbl %al,%ebx
  80269a:	83 ec 0c             	sub    $0xc,%esp
  80269d:	ff 75 f4             	pushl  -0xc(%ebp)
  8026a0:	e8 ef fe ff ff       	call   802594 <get_block_size>
  8026a5:	83 c4 10             	add    $0x10,%esp
  8026a8:	83 ec 04             	sub    $0x4,%esp
  8026ab:	53                   	push   %ebx
  8026ac:	50                   	push   %eax
  8026ad:	68 ff 4a 80 00       	push   $0x804aff
  8026b2:	e8 43 e3 ff ff       	call   8009fa <cprintf>
  8026b7:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8026bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c4:	74 07                	je     8026cd <print_blocks_list+0x73>
  8026c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c9:	8b 00                	mov    (%eax),%eax
  8026cb:	eb 05                	jmp    8026d2 <print_blocks_list+0x78>
  8026cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d2:	89 45 10             	mov    %eax,0x10(%ebp)
  8026d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8026d8:	85 c0                	test   %eax,%eax
  8026da:	75 ad                	jne    802689 <print_blocks_list+0x2f>
  8026dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e0:	75 a7                	jne    802689 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8026e2:	83 ec 0c             	sub    $0xc,%esp
  8026e5:	68 bc 4a 80 00       	push   $0x804abc
  8026ea:	e8 0b e3 ff ff       	call   8009fa <cprintf>
  8026ef:	83 c4 10             	add    $0x10,%esp

}
  8026f2:	90                   	nop
  8026f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026f6:	c9                   	leave  
  8026f7:	c3                   	ret    

008026f8 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8026f8:	55                   	push   %ebp
  8026f9:	89 e5                	mov    %esp,%ebp
  8026fb:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8026fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802701:	83 e0 01             	and    $0x1,%eax
  802704:	85 c0                	test   %eax,%eax
  802706:	74 03                	je     80270b <initialize_dynamic_allocator+0x13>
  802708:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80270b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80270f:	0f 84 c7 01 00 00    	je     8028dc <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802715:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  80271c:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80271f:	8b 55 08             	mov    0x8(%ebp),%edx
  802722:	8b 45 0c             	mov    0xc(%ebp),%eax
  802725:	01 d0                	add    %edx,%eax
  802727:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80272c:	0f 87 ad 01 00 00    	ja     8028df <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802732:	8b 45 08             	mov    0x8(%ebp),%eax
  802735:	85 c0                	test   %eax,%eax
  802737:	0f 89 a5 01 00 00    	jns    8028e2 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80273d:	8b 55 08             	mov    0x8(%ebp),%edx
  802740:	8b 45 0c             	mov    0xc(%ebp),%eax
  802743:	01 d0                	add    %edx,%eax
  802745:	83 e8 04             	sub    $0x4,%eax
  802748:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  80274d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802754:	a1 30 50 80 00       	mov    0x805030,%eax
  802759:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275c:	e9 87 00 00 00       	jmp    8027e8 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802761:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802765:	75 14                	jne    80277b <initialize_dynamic_allocator+0x83>
  802767:	83 ec 04             	sub    $0x4,%esp
  80276a:	68 17 4b 80 00       	push   $0x804b17
  80276f:	6a 79                	push   $0x79
  802771:	68 35 4b 80 00       	push   $0x804b35
  802776:	e8 c2 df ff ff       	call   80073d <_panic>
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	85 c0                	test   %eax,%eax
  802782:	74 10                	je     802794 <initialize_dynamic_allocator+0x9c>
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	8b 00                	mov    (%eax),%eax
  802789:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278c:	8b 52 04             	mov    0x4(%edx),%edx
  80278f:	89 50 04             	mov    %edx,0x4(%eax)
  802792:	eb 0b                	jmp    80279f <initialize_dynamic_allocator+0xa7>
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 40 04             	mov    0x4(%eax),%eax
  80279a:	a3 34 50 80 00       	mov    %eax,0x805034
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	8b 40 04             	mov    0x4(%eax),%eax
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	74 0f                	je     8027b8 <initialize_dynamic_allocator+0xc0>
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	8b 40 04             	mov    0x4(%eax),%eax
  8027af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b2:	8b 12                	mov    (%edx),%edx
  8027b4:	89 10                	mov    %edx,(%eax)
  8027b6:	eb 0a                	jmp    8027c2 <initialize_dynamic_allocator+0xca>
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 00                	mov    (%eax),%eax
  8027bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027da:	48                   	dec    %eax
  8027db:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8027e0:	a1 38 50 80 00       	mov    0x805038,%eax
  8027e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ec:	74 07                	je     8027f5 <initialize_dynamic_allocator+0xfd>
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 00                	mov    (%eax),%eax
  8027f3:	eb 05                	jmp    8027fa <initialize_dynamic_allocator+0x102>
  8027f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fa:	a3 38 50 80 00       	mov    %eax,0x805038
  8027ff:	a1 38 50 80 00       	mov    0x805038,%eax
  802804:	85 c0                	test   %eax,%eax
  802806:	0f 85 55 ff ff ff    	jne    802761 <initialize_dynamic_allocator+0x69>
  80280c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802810:	0f 85 4b ff ff ff    	jne    802761 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802816:	8b 45 08             	mov    0x8(%ebp),%eax
  802819:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80281c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802825:	a1 48 50 80 00       	mov    0x805048,%eax
  80282a:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  80282f:	a1 44 50 80 00       	mov    0x805044,%eax
  802834:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80283a:	8b 45 08             	mov    0x8(%ebp),%eax
  80283d:	83 c0 08             	add    $0x8,%eax
  802840:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	83 c0 04             	add    $0x4,%eax
  802849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80284c:	83 ea 08             	sub    $0x8,%edx
  80284f:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802851:	8b 55 0c             	mov    0xc(%ebp),%edx
  802854:	8b 45 08             	mov    0x8(%ebp),%eax
  802857:	01 d0                	add    %edx,%eax
  802859:	83 e8 08             	sub    $0x8,%eax
  80285c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80285f:	83 ea 08             	sub    $0x8,%edx
  802862:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802864:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802867:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80286d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802870:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802877:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80287b:	75 17                	jne    802894 <initialize_dynamic_allocator+0x19c>
  80287d:	83 ec 04             	sub    $0x4,%esp
  802880:	68 50 4b 80 00       	push   $0x804b50
  802885:	68 90 00 00 00       	push   $0x90
  80288a:	68 35 4b 80 00       	push   $0x804b35
  80288f:	e8 a9 de ff ff       	call   80073d <_panic>
  802894:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80289a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289d:	89 10                	mov    %edx,(%eax)
  80289f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	74 0d                	je     8028b5 <initialize_dynamic_allocator+0x1bd>
  8028a8:	a1 30 50 80 00       	mov    0x805030,%eax
  8028ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028b0:	89 50 04             	mov    %edx,0x4(%eax)
  8028b3:	eb 08                	jmp    8028bd <initialize_dynamic_allocator+0x1c5>
  8028b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b8:	a3 34 50 80 00       	mov    %eax,0x805034
  8028bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c0:	a3 30 50 80 00       	mov    %eax,0x805030
  8028c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8028d4:	40                   	inc    %eax
  8028d5:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8028da:	eb 07                	jmp    8028e3 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8028dc:	90                   	nop
  8028dd:	eb 04                	jmp    8028e3 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8028df:	90                   	nop
  8028e0:	eb 01                	jmp    8028e3 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8028e2:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8028e3:	c9                   	leave  
  8028e4:	c3                   	ret    

008028e5 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8028e5:	55                   	push   %ebp
  8028e6:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8028e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8028eb:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8028ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f1:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028f7:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	83 e8 04             	sub    $0x4,%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	83 e0 fe             	and    $0xfffffffe,%eax
  802904:	8d 50 f8             	lea    -0x8(%eax),%edx
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	01 c2                	add    %eax,%edx
  80290c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80290f:	89 02                	mov    %eax,(%edx)
}
  802911:	90                   	nop
  802912:	5d                   	pop    %ebp
  802913:	c3                   	ret    

00802914 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802914:	55                   	push   %ebp
  802915:	89 e5                	mov    %esp,%ebp
  802917:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80291a:	8b 45 08             	mov    0x8(%ebp),%eax
  80291d:	83 e0 01             	and    $0x1,%eax
  802920:	85 c0                	test   %eax,%eax
  802922:	74 03                	je     802927 <alloc_block_FF+0x13>
  802924:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802927:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80292b:	77 07                	ja     802934 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80292d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802934:	a1 28 50 80 00       	mov    0x805028,%eax
  802939:	85 c0                	test   %eax,%eax
  80293b:	75 73                	jne    8029b0 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	83 c0 10             	add    $0x10,%eax
  802943:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802946:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80294d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802953:	01 d0                	add    %edx,%eax
  802955:	48                   	dec    %eax
  802956:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802959:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295c:	ba 00 00 00 00       	mov    $0x0,%edx
  802961:	f7 75 ec             	divl   -0x14(%ebp)
  802964:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802967:	29 d0                	sub    %edx,%eax
  802969:	c1 e8 0c             	shr    $0xc,%eax
  80296c:	83 ec 0c             	sub    $0xc,%esp
  80296f:	50                   	push   %eax
  802970:	e8 27 f0 ff ff       	call   80199c <sbrk>
  802975:	83 c4 10             	add    $0x10,%esp
  802978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80297b:	83 ec 0c             	sub    $0xc,%esp
  80297e:	6a 00                	push   $0x0
  802980:	e8 17 f0 ff ff       	call   80199c <sbrk>
  802985:	83 c4 10             	add    $0x10,%esp
  802988:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80298b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802991:	83 ec 08             	sub    $0x8,%esp
  802994:	50                   	push   %eax
  802995:	ff 75 e4             	pushl  -0x1c(%ebp)
  802998:	e8 5b fd ff ff       	call   8026f8 <initialize_dynamic_allocator>
  80299d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029a0:	83 ec 0c             	sub    $0xc,%esp
  8029a3:	68 73 4b 80 00       	push   $0x804b73
  8029a8:	e8 4d e0 ff ff       	call   8009fa <cprintf>
  8029ad:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8029b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b4:	75 0a                	jne    8029c0 <alloc_block_FF+0xac>
	        return NULL;
  8029b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bb:	e9 0e 04 00 00       	jmp    802dce <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8029c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8029c7:	a1 30 50 80 00       	mov    0x805030,%eax
  8029cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029cf:	e9 f3 02 00 00       	jmp    802cc7 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8029da:	83 ec 0c             	sub    $0xc,%esp
  8029dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8029e0:	e8 af fb ff ff       	call   802594 <get_block_size>
  8029e5:	83 c4 10             	add    $0x10,%esp
  8029e8:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	83 c0 08             	add    $0x8,%eax
  8029f1:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8029f4:	0f 87 c5 02 00 00    	ja     802cbf <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	83 c0 18             	add    $0x18,%eax
  802a00:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a03:	0f 87 19 02 00 00    	ja     802c22 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802a09:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a0c:	2b 45 08             	sub    0x8(%ebp),%eax
  802a0f:	83 e8 08             	sub    $0x8,%eax
  802a12:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802a15:	8b 45 08             	mov    0x8(%ebp),%eax
  802a18:	8d 50 08             	lea    0x8(%eax),%edx
  802a1b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a1e:	01 d0                	add    %edx,%eax
  802a20:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802a23:	8b 45 08             	mov    0x8(%ebp),%eax
  802a26:	83 c0 08             	add    $0x8,%eax
  802a29:	83 ec 04             	sub    $0x4,%esp
  802a2c:	6a 01                	push   $0x1
  802a2e:	50                   	push   %eax
  802a2f:	ff 75 bc             	pushl  -0x44(%ebp)
  802a32:	e8 ae fe ff ff       	call   8028e5 <set_block_data>
  802a37:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 40 04             	mov    0x4(%eax),%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	75 68                	jne    802aac <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a44:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a48:	75 17                	jne    802a61 <alloc_block_FF+0x14d>
  802a4a:	83 ec 04             	sub    $0x4,%esp
  802a4d:	68 50 4b 80 00       	push   $0x804b50
  802a52:	68 d7 00 00 00       	push   $0xd7
  802a57:	68 35 4b 80 00       	push   $0x804b35
  802a5c:	e8 dc dc ff ff       	call   80073d <_panic>
  802a61:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a67:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a6a:	89 10                	mov    %edx,(%eax)
  802a6c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a6f:	8b 00                	mov    (%eax),%eax
  802a71:	85 c0                	test   %eax,%eax
  802a73:	74 0d                	je     802a82 <alloc_block_FF+0x16e>
  802a75:	a1 30 50 80 00       	mov    0x805030,%eax
  802a7a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a7d:	89 50 04             	mov    %edx,0x4(%eax)
  802a80:	eb 08                	jmp    802a8a <alloc_block_FF+0x176>
  802a82:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a85:	a3 34 50 80 00       	mov    %eax,0x805034
  802a8a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a8d:	a3 30 50 80 00       	mov    %eax,0x805030
  802a92:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802aa1:	40                   	inc    %eax
  802aa2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802aa7:	e9 dc 00 00 00       	jmp    802b88 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	8b 00                	mov    (%eax),%eax
  802ab1:	85 c0                	test   %eax,%eax
  802ab3:	75 65                	jne    802b1a <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ab5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ab9:	75 17                	jne    802ad2 <alloc_block_FF+0x1be>
  802abb:	83 ec 04             	sub    $0x4,%esp
  802abe:	68 84 4b 80 00       	push   $0x804b84
  802ac3:	68 db 00 00 00       	push   $0xdb
  802ac8:	68 35 4b 80 00       	push   $0x804b35
  802acd:	e8 6b dc ff ff       	call   80073d <_panic>
  802ad2:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802ad8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802adb:	89 50 04             	mov    %edx,0x4(%eax)
  802ade:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae1:	8b 40 04             	mov    0x4(%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	74 0c                	je     802af4 <alloc_block_FF+0x1e0>
  802ae8:	a1 34 50 80 00       	mov    0x805034,%eax
  802aed:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802af0:	89 10                	mov    %edx,(%eax)
  802af2:	eb 08                	jmp    802afc <alloc_block_FF+0x1e8>
  802af4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802af7:	a3 30 50 80 00       	mov    %eax,0x805030
  802afc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aff:	a3 34 50 80 00       	mov    %eax,0x805034
  802b04:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b12:	40                   	inc    %eax
  802b13:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b18:	eb 6e                	jmp    802b88 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802b1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1e:	74 06                	je     802b26 <alloc_block_FF+0x212>
  802b20:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b24:	75 17                	jne    802b3d <alloc_block_FF+0x229>
  802b26:	83 ec 04             	sub    $0x4,%esp
  802b29:	68 a8 4b 80 00       	push   $0x804ba8
  802b2e:	68 df 00 00 00       	push   $0xdf
  802b33:	68 35 4b 80 00       	push   $0x804b35
  802b38:	e8 00 dc ff ff       	call   80073d <_panic>
  802b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b40:	8b 10                	mov    (%eax),%edx
  802b42:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b45:	89 10                	mov    %edx,(%eax)
  802b47:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	85 c0                	test   %eax,%eax
  802b4e:	74 0b                	je     802b5b <alloc_block_FF+0x247>
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 00                	mov    (%eax),%eax
  802b55:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b58:	89 50 04             	mov    %edx,0x4(%eax)
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b61:	89 10                	mov    %edx,(%eax)
  802b63:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b69:	89 50 04             	mov    %edx,0x4(%eax)
  802b6c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b6f:	8b 00                	mov    (%eax),%eax
  802b71:	85 c0                	test   %eax,%eax
  802b73:	75 08                	jne    802b7d <alloc_block_FF+0x269>
  802b75:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b78:	a3 34 50 80 00       	mov    %eax,0x805034
  802b7d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b82:	40                   	inc    %eax
  802b83:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802b88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8c:	75 17                	jne    802ba5 <alloc_block_FF+0x291>
  802b8e:	83 ec 04             	sub    $0x4,%esp
  802b91:	68 17 4b 80 00       	push   $0x804b17
  802b96:	68 e1 00 00 00       	push   $0xe1
  802b9b:	68 35 4b 80 00       	push   $0x804b35
  802ba0:	e8 98 db ff ff       	call   80073d <_panic>
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	85 c0                	test   %eax,%eax
  802bac:	74 10                	je     802bbe <alloc_block_FF+0x2aa>
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	8b 00                	mov    (%eax),%eax
  802bb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb6:	8b 52 04             	mov    0x4(%edx),%edx
  802bb9:	89 50 04             	mov    %edx,0x4(%eax)
  802bbc:	eb 0b                	jmp    802bc9 <alloc_block_FF+0x2b5>
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	8b 40 04             	mov    0x4(%eax),%eax
  802bc4:	a3 34 50 80 00       	mov    %eax,0x805034
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 40 04             	mov    0x4(%eax),%eax
  802bcf:	85 c0                	test   %eax,%eax
  802bd1:	74 0f                	je     802be2 <alloc_block_FF+0x2ce>
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	8b 40 04             	mov    0x4(%eax),%eax
  802bd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bdc:	8b 12                	mov    (%edx),%edx
  802bde:	89 10                	mov    %edx,(%eax)
  802be0:	eb 0a                	jmp    802bec <alloc_block_FF+0x2d8>
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	a3 30 50 80 00       	mov    %eax,0x805030
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bff:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c04:	48                   	dec    %eax
  802c05:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802c0a:	83 ec 04             	sub    $0x4,%esp
  802c0d:	6a 00                	push   $0x0
  802c0f:	ff 75 b4             	pushl  -0x4c(%ebp)
  802c12:	ff 75 b0             	pushl  -0x50(%ebp)
  802c15:	e8 cb fc ff ff       	call   8028e5 <set_block_data>
  802c1a:	83 c4 10             	add    $0x10,%esp
  802c1d:	e9 95 00 00 00       	jmp    802cb7 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802c22:	83 ec 04             	sub    $0x4,%esp
  802c25:	6a 01                	push   $0x1
  802c27:	ff 75 b8             	pushl  -0x48(%ebp)
  802c2a:	ff 75 bc             	pushl  -0x44(%ebp)
  802c2d:	e8 b3 fc ff ff       	call   8028e5 <set_block_data>
  802c32:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802c35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c39:	75 17                	jne    802c52 <alloc_block_FF+0x33e>
  802c3b:	83 ec 04             	sub    $0x4,%esp
  802c3e:	68 17 4b 80 00       	push   $0x804b17
  802c43:	68 e8 00 00 00       	push   $0xe8
  802c48:	68 35 4b 80 00       	push   $0x804b35
  802c4d:	e8 eb da ff ff       	call   80073d <_panic>
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	74 10                	je     802c6b <alloc_block_FF+0x357>
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c63:	8b 52 04             	mov    0x4(%edx),%edx
  802c66:	89 50 04             	mov    %edx,0x4(%eax)
  802c69:	eb 0b                	jmp    802c76 <alloc_block_FF+0x362>
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 40 04             	mov    0x4(%eax),%eax
  802c71:	a3 34 50 80 00       	mov    %eax,0x805034
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	8b 40 04             	mov    0x4(%eax),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	74 0f                	je     802c8f <alloc_block_FF+0x37b>
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	8b 40 04             	mov    0x4(%eax),%eax
  802c86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c89:	8b 12                	mov    (%edx),%edx
  802c8b:	89 10                	mov    %edx,(%eax)
  802c8d:	eb 0a                	jmp    802c99 <alloc_block_FF+0x385>
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	8b 00                	mov    (%eax),%eax
  802c94:	a3 30 50 80 00       	mov    %eax,0x805030
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cac:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cb1:	48                   	dec    %eax
  802cb2:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802cb7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cba:	e9 0f 01 00 00       	jmp    802dce <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802cbf:	a1 38 50 80 00       	mov    0x805038,%eax
  802cc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccb:	74 07                	je     802cd4 <alloc_block_FF+0x3c0>
  802ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd0:	8b 00                	mov    (%eax),%eax
  802cd2:	eb 05                	jmp    802cd9 <alloc_block_FF+0x3c5>
  802cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd9:	a3 38 50 80 00       	mov    %eax,0x805038
  802cde:	a1 38 50 80 00       	mov    0x805038,%eax
  802ce3:	85 c0                	test   %eax,%eax
  802ce5:	0f 85 e9 fc ff ff    	jne    8029d4 <alloc_block_FF+0xc0>
  802ceb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cef:	0f 85 df fc ff ff    	jne    8029d4 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	83 c0 08             	add    $0x8,%eax
  802cfb:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cfe:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802d05:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d0b:	01 d0                	add    %edx,%eax
  802d0d:	48                   	dec    %eax
  802d0e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802d11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d14:	ba 00 00 00 00       	mov    $0x0,%edx
  802d19:	f7 75 d8             	divl   -0x28(%ebp)
  802d1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d1f:	29 d0                	sub    %edx,%eax
  802d21:	c1 e8 0c             	shr    $0xc,%eax
  802d24:	83 ec 0c             	sub    $0xc,%esp
  802d27:	50                   	push   %eax
  802d28:	e8 6f ec ff ff       	call   80199c <sbrk>
  802d2d:	83 c4 10             	add    $0x10,%esp
  802d30:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802d33:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d37:	75 0a                	jne    802d43 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802d39:	b8 00 00 00 00       	mov    $0x0,%eax
  802d3e:	e9 8b 00 00 00       	jmp    802dce <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d43:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802d4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d50:	01 d0                	add    %edx,%eax
  802d52:	48                   	dec    %eax
  802d53:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802d56:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d59:	ba 00 00 00 00       	mov    $0x0,%edx
  802d5e:	f7 75 cc             	divl   -0x34(%ebp)
  802d61:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d64:	29 d0                	sub    %edx,%eax
  802d66:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d69:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d6c:	01 d0                	add    %edx,%eax
  802d6e:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802d73:	a1 44 50 80 00       	mov    0x805044,%eax
  802d78:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d7e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d85:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d88:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d8b:	01 d0                	add    %edx,%eax
  802d8d:	48                   	dec    %eax
  802d8e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d91:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d94:	ba 00 00 00 00       	mov    $0x0,%edx
  802d99:	f7 75 c4             	divl   -0x3c(%ebp)
  802d9c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d9f:	29 d0                	sub    %edx,%eax
  802da1:	83 ec 04             	sub    $0x4,%esp
  802da4:	6a 01                	push   $0x1
  802da6:	50                   	push   %eax
  802da7:	ff 75 d0             	pushl  -0x30(%ebp)
  802daa:	e8 36 fb ff ff       	call   8028e5 <set_block_data>
  802daf:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802db2:	83 ec 0c             	sub    $0xc,%esp
  802db5:	ff 75 d0             	pushl  -0x30(%ebp)
  802db8:	e8 f8 09 00 00       	call   8037b5 <free_block>
  802dbd:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802dc0:	83 ec 0c             	sub    $0xc,%esp
  802dc3:	ff 75 08             	pushl  0x8(%ebp)
  802dc6:	e8 49 fb ff ff       	call   802914 <alloc_block_FF>
  802dcb:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802dce:	c9                   	leave  
  802dcf:	c3                   	ret    

00802dd0 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802dd0:	55                   	push   %ebp
  802dd1:	89 e5                	mov    %esp,%ebp
  802dd3:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	83 e0 01             	and    $0x1,%eax
  802ddc:	85 c0                	test   %eax,%eax
  802dde:	74 03                	je     802de3 <alloc_block_BF+0x13>
  802de0:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802de3:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802de7:	77 07                	ja     802df0 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802de9:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802df0:	a1 28 50 80 00       	mov    0x805028,%eax
  802df5:	85 c0                	test   %eax,%eax
  802df7:	75 73                	jne    802e6c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802df9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfc:	83 c0 10             	add    $0x10,%eax
  802dff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e02:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802e09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0f:	01 d0                	add    %edx,%eax
  802e11:	48                   	dec    %eax
  802e12:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e18:	ba 00 00 00 00       	mov    $0x0,%edx
  802e1d:	f7 75 e0             	divl   -0x20(%ebp)
  802e20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e23:	29 d0                	sub    %edx,%eax
  802e25:	c1 e8 0c             	shr    $0xc,%eax
  802e28:	83 ec 0c             	sub    $0xc,%esp
  802e2b:	50                   	push   %eax
  802e2c:	e8 6b eb ff ff       	call   80199c <sbrk>
  802e31:	83 c4 10             	add    $0x10,%esp
  802e34:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802e37:	83 ec 0c             	sub    $0xc,%esp
  802e3a:	6a 00                	push   $0x0
  802e3c:	e8 5b eb ff ff       	call   80199c <sbrk>
  802e41:	83 c4 10             	add    $0x10,%esp
  802e44:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802e47:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e4a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802e4d:	83 ec 08             	sub    $0x8,%esp
  802e50:	50                   	push   %eax
  802e51:	ff 75 d8             	pushl  -0x28(%ebp)
  802e54:	e8 9f f8 ff ff       	call   8026f8 <initialize_dynamic_allocator>
  802e59:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802e5c:	83 ec 0c             	sub    $0xc,%esp
  802e5f:	68 73 4b 80 00       	push   $0x804b73
  802e64:	e8 91 db ff ff       	call   8009fa <cprintf>
  802e69:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802e6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802e73:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802e7a:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802e81:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802e88:	a1 30 50 80 00       	mov    0x805030,%eax
  802e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e90:	e9 1d 01 00 00       	jmp    802fb2 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802e9b:	83 ec 0c             	sub    $0xc,%esp
  802e9e:	ff 75 a8             	pushl  -0x58(%ebp)
  802ea1:	e8 ee f6 ff ff       	call   802594 <get_block_size>
  802ea6:	83 c4 10             	add    $0x10,%esp
  802ea9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	83 c0 08             	add    $0x8,%eax
  802eb2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802eb5:	0f 87 ef 00 00 00    	ja     802faa <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	83 c0 18             	add    $0x18,%eax
  802ec1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ec4:	77 1d                	ja     802ee3 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ecc:	0f 86 d8 00 00 00    	jbe    802faa <alloc_block_BF+0x1da>
				{
					best_va = va;
  802ed2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802ed8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802edb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ede:	e9 c7 00 00 00       	jmp    802faa <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee6:	83 c0 08             	add    $0x8,%eax
  802ee9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802eec:	0f 85 9d 00 00 00    	jne    802f8f <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802ef2:	83 ec 04             	sub    $0x4,%esp
  802ef5:	6a 01                	push   $0x1
  802ef7:	ff 75 a4             	pushl  -0x5c(%ebp)
  802efa:	ff 75 a8             	pushl  -0x58(%ebp)
  802efd:	e8 e3 f9 ff ff       	call   8028e5 <set_block_data>
  802f02:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802f05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f09:	75 17                	jne    802f22 <alloc_block_BF+0x152>
  802f0b:	83 ec 04             	sub    $0x4,%esp
  802f0e:	68 17 4b 80 00       	push   $0x804b17
  802f13:	68 2c 01 00 00       	push   $0x12c
  802f18:	68 35 4b 80 00       	push   $0x804b35
  802f1d:	e8 1b d8 ff ff       	call   80073d <_panic>
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 00                	mov    (%eax),%eax
  802f27:	85 c0                	test   %eax,%eax
  802f29:	74 10                	je     802f3b <alloc_block_BF+0x16b>
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f33:	8b 52 04             	mov    0x4(%edx),%edx
  802f36:	89 50 04             	mov    %edx,0x4(%eax)
  802f39:	eb 0b                	jmp    802f46 <alloc_block_BF+0x176>
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	8b 40 04             	mov    0x4(%eax),%eax
  802f41:	a3 34 50 80 00       	mov    %eax,0x805034
  802f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f49:	8b 40 04             	mov    0x4(%eax),%eax
  802f4c:	85 c0                	test   %eax,%eax
  802f4e:	74 0f                	je     802f5f <alloc_block_BF+0x18f>
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	8b 40 04             	mov    0x4(%eax),%eax
  802f56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f59:	8b 12                	mov    (%edx),%edx
  802f5b:	89 10                	mov    %edx,(%eax)
  802f5d:	eb 0a                	jmp    802f69 <alloc_block_BF+0x199>
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	8b 00                	mov    (%eax),%eax
  802f64:	a3 30 50 80 00       	mov    %eax,0x805030
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f81:	48                   	dec    %eax
  802f82:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802f87:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f8a:	e9 01 04 00 00       	jmp    803390 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802f8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f92:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f95:	76 13                	jbe    802faa <alloc_block_BF+0x1da>
					{
						internal = 1;
  802f97:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802f9e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802fa4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802fa7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802faa:	a1 38 50 80 00       	mov    0x805038,%eax
  802faf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb6:	74 07                	je     802fbf <alloc_block_BF+0x1ef>
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	8b 00                	mov    (%eax),%eax
  802fbd:	eb 05                	jmp    802fc4 <alloc_block_BF+0x1f4>
  802fbf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc4:	a3 38 50 80 00       	mov    %eax,0x805038
  802fc9:	a1 38 50 80 00       	mov    0x805038,%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	0f 85 bf fe ff ff    	jne    802e95 <alloc_block_BF+0xc5>
  802fd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fda:	0f 85 b5 fe ff ff    	jne    802e95 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802fe0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fe4:	0f 84 26 02 00 00    	je     803210 <alloc_block_BF+0x440>
  802fea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fee:	0f 85 1c 02 00 00    	jne    803210 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff7:	2b 45 08             	sub    0x8(%ebp),%eax
  802ffa:	83 e8 08             	sub    $0x8,%eax
  802ffd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	8d 50 08             	lea    0x8(%eax),%edx
  803006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803009:	01 d0                	add    %edx,%eax
  80300b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	83 c0 08             	add    $0x8,%eax
  803014:	83 ec 04             	sub    $0x4,%esp
  803017:	6a 01                	push   $0x1
  803019:	50                   	push   %eax
  80301a:	ff 75 f0             	pushl  -0x10(%ebp)
  80301d:	e8 c3 f8 ff ff       	call   8028e5 <set_block_data>
  803022:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803028:	8b 40 04             	mov    0x4(%eax),%eax
  80302b:	85 c0                	test   %eax,%eax
  80302d:	75 68                	jne    803097 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80302f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803033:	75 17                	jne    80304c <alloc_block_BF+0x27c>
  803035:	83 ec 04             	sub    $0x4,%esp
  803038:	68 50 4b 80 00       	push   $0x804b50
  80303d:	68 45 01 00 00       	push   $0x145
  803042:	68 35 4b 80 00       	push   $0x804b35
  803047:	e8 f1 d6 ff ff       	call   80073d <_panic>
  80304c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803052:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803055:	89 10                	mov    %edx,(%eax)
  803057:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80305a:	8b 00                	mov    (%eax),%eax
  80305c:	85 c0                	test   %eax,%eax
  80305e:	74 0d                	je     80306d <alloc_block_BF+0x29d>
  803060:	a1 30 50 80 00       	mov    0x805030,%eax
  803065:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803068:	89 50 04             	mov    %edx,0x4(%eax)
  80306b:	eb 08                	jmp    803075 <alloc_block_BF+0x2a5>
  80306d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803070:	a3 34 50 80 00       	mov    %eax,0x805034
  803075:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803078:	a3 30 50 80 00       	mov    %eax,0x805030
  80307d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803080:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803087:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80308c:	40                   	inc    %eax
  80308d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803092:	e9 dc 00 00 00       	jmp    803173 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309a:	8b 00                	mov    (%eax),%eax
  80309c:	85 c0                	test   %eax,%eax
  80309e:	75 65                	jne    803105 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030a0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030a4:	75 17                	jne    8030bd <alloc_block_BF+0x2ed>
  8030a6:	83 ec 04             	sub    $0x4,%esp
  8030a9:	68 84 4b 80 00       	push   $0x804b84
  8030ae:	68 4a 01 00 00       	push   $0x14a
  8030b3:	68 35 4b 80 00       	push   $0x804b35
  8030b8:	e8 80 d6 ff ff       	call   80073d <_panic>
  8030bd:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8030c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c6:	89 50 04             	mov    %edx,0x4(%eax)
  8030c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030cc:	8b 40 04             	mov    0x4(%eax),%eax
  8030cf:	85 c0                	test   %eax,%eax
  8030d1:	74 0c                	je     8030df <alloc_block_BF+0x30f>
  8030d3:	a1 34 50 80 00       	mov    0x805034,%eax
  8030d8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030db:	89 10                	mov    %edx,(%eax)
  8030dd:	eb 08                	jmp    8030e7 <alloc_block_BF+0x317>
  8030df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030e2:	a3 30 50 80 00       	mov    %eax,0x805030
  8030e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030ea:	a3 34 50 80 00       	mov    %eax,0x805034
  8030ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030fd:	40                   	inc    %eax
  8030fe:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803103:	eb 6e                	jmp    803173 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803105:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803109:	74 06                	je     803111 <alloc_block_BF+0x341>
  80310b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80310f:	75 17                	jne    803128 <alloc_block_BF+0x358>
  803111:	83 ec 04             	sub    $0x4,%esp
  803114:	68 a8 4b 80 00       	push   $0x804ba8
  803119:	68 4f 01 00 00       	push   $0x14f
  80311e:	68 35 4b 80 00       	push   $0x804b35
  803123:	e8 15 d6 ff ff       	call   80073d <_panic>
  803128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312b:	8b 10                	mov    (%eax),%edx
  80312d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803130:	89 10                	mov    %edx,(%eax)
  803132:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803135:	8b 00                	mov    (%eax),%eax
  803137:	85 c0                	test   %eax,%eax
  803139:	74 0b                	je     803146 <alloc_block_BF+0x376>
  80313b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313e:	8b 00                	mov    (%eax),%eax
  803140:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803143:	89 50 04             	mov    %edx,0x4(%eax)
  803146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803149:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80314c:	89 10                	mov    %edx,(%eax)
  80314e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803151:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803154:	89 50 04             	mov    %edx,0x4(%eax)
  803157:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80315a:	8b 00                	mov    (%eax),%eax
  80315c:	85 c0                	test   %eax,%eax
  80315e:	75 08                	jne    803168 <alloc_block_BF+0x398>
  803160:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803163:	a3 34 50 80 00       	mov    %eax,0x805034
  803168:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80316d:	40                   	inc    %eax
  80316e:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803173:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803177:	75 17                	jne    803190 <alloc_block_BF+0x3c0>
  803179:	83 ec 04             	sub    $0x4,%esp
  80317c:	68 17 4b 80 00       	push   $0x804b17
  803181:	68 51 01 00 00       	push   $0x151
  803186:	68 35 4b 80 00       	push   $0x804b35
  80318b:	e8 ad d5 ff ff       	call   80073d <_panic>
  803190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803193:	8b 00                	mov    (%eax),%eax
  803195:	85 c0                	test   %eax,%eax
  803197:	74 10                	je     8031a9 <alloc_block_BF+0x3d9>
  803199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319c:	8b 00                	mov    (%eax),%eax
  80319e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a1:	8b 52 04             	mov    0x4(%edx),%edx
  8031a4:	89 50 04             	mov    %edx,0x4(%eax)
  8031a7:	eb 0b                	jmp    8031b4 <alloc_block_BF+0x3e4>
  8031a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ac:	8b 40 04             	mov    0x4(%eax),%eax
  8031af:	a3 34 50 80 00       	mov    %eax,0x805034
  8031b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ba:	85 c0                	test   %eax,%eax
  8031bc:	74 0f                	je     8031cd <alloc_block_BF+0x3fd>
  8031be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c1:	8b 40 04             	mov    0x4(%eax),%eax
  8031c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031c7:	8b 12                	mov    (%edx),%edx
  8031c9:	89 10                	mov    %edx,(%eax)
  8031cb:	eb 0a                	jmp    8031d7 <alloc_block_BF+0x407>
  8031cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d0:	8b 00                	mov    (%eax),%eax
  8031d2:	a3 30 50 80 00       	mov    %eax,0x805030
  8031d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ea:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031ef:	48                   	dec    %eax
  8031f0:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  8031f5:	83 ec 04             	sub    $0x4,%esp
  8031f8:	6a 00                	push   $0x0
  8031fa:	ff 75 d0             	pushl  -0x30(%ebp)
  8031fd:	ff 75 cc             	pushl  -0x34(%ebp)
  803200:	e8 e0 f6 ff ff       	call   8028e5 <set_block_data>
  803205:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803208:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320b:	e9 80 01 00 00       	jmp    803390 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  803210:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803214:	0f 85 9d 00 00 00    	jne    8032b7 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80321a:	83 ec 04             	sub    $0x4,%esp
  80321d:	6a 01                	push   $0x1
  80321f:	ff 75 ec             	pushl  -0x14(%ebp)
  803222:	ff 75 f0             	pushl  -0x10(%ebp)
  803225:	e8 bb f6 ff ff       	call   8028e5 <set_block_data>
  80322a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80322d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803231:	75 17                	jne    80324a <alloc_block_BF+0x47a>
  803233:	83 ec 04             	sub    $0x4,%esp
  803236:	68 17 4b 80 00       	push   $0x804b17
  80323b:	68 58 01 00 00       	push   $0x158
  803240:	68 35 4b 80 00       	push   $0x804b35
  803245:	e8 f3 d4 ff ff       	call   80073d <_panic>
  80324a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324d:	8b 00                	mov    (%eax),%eax
  80324f:	85 c0                	test   %eax,%eax
  803251:	74 10                	je     803263 <alloc_block_BF+0x493>
  803253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803256:	8b 00                	mov    (%eax),%eax
  803258:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80325b:	8b 52 04             	mov    0x4(%edx),%edx
  80325e:	89 50 04             	mov    %edx,0x4(%eax)
  803261:	eb 0b                	jmp    80326e <alloc_block_BF+0x49e>
  803263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803266:	8b 40 04             	mov    0x4(%eax),%eax
  803269:	a3 34 50 80 00       	mov    %eax,0x805034
  80326e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803271:	8b 40 04             	mov    0x4(%eax),%eax
  803274:	85 c0                	test   %eax,%eax
  803276:	74 0f                	je     803287 <alloc_block_BF+0x4b7>
  803278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327b:	8b 40 04             	mov    0x4(%eax),%eax
  80327e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803281:	8b 12                	mov    (%edx),%edx
  803283:	89 10                	mov    %edx,(%eax)
  803285:	eb 0a                	jmp    803291 <alloc_block_BF+0x4c1>
  803287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	a3 30 50 80 00       	mov    %eax,0x805030
  803291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803294:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032a9:	48                   	dec    %eax
  8032aa:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  8032af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b2:	e9 d9 00 00 00       	jmp    803390 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	83 c0 08             	add    $0x8,%eax
  8032bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8032c0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8032c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032ca:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8032cd:	01 d0                	add    %edx,%eax
  8032cf:	48                   	dec    %eax
  8032d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8032d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8032db:	f7 75 c4             	divl   -0x3c(%ebp)
  8032de:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032e1:	29 d0                	sub    %edx,%eax
  8032e3:	c1 e8 0c             	shr    $0xc,%eax
  8032e6:	83 ec 0c             	sub    $0xc,%esp
  8032e9:	50                   	push   %eax
  8032ea:	e8 ad e6 ff ff       	call   80199c <sbrk>
  8032ef:	83 c4 10             	add    $0x10,%esp
  8032f2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8032f5:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8032f9:	75 0a                	jne    803305 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8032fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803300:	e9 8b 00 00 00       	jmp    803390 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803305:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80330c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80330f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803312:	01 d0                	add    %edx,%eax
  803314:	48                   	dec    %eax
  803315:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803318:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80331b:	ba 00 00 00 00       	mov    $0x0,%edx
  803320:	f7 75 b8             	divl   -0x48(%ebp)
  803323:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803326:	29 d0                	sub    %edx,%eax
  803328:	8d 50 fc             	lea    -0x4(%eax),%edx
  80332b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80332e:	01 d0                	add    %edx,%eax
  803330:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  803335:	a1 44 50 80 00       	mov    0x805044,%eax
  80333a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803340:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803347:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80334a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80334d:	01 d0                	add    %edx,%eax
  80334f:	48                   	dec    %eax
  803350:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803353:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803356:	ba 00 00 00 00       	mov    $0x0,%edx
  80335b:	f7 75 b0             	divl   -0x50(%ebp)
  80335e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803361:	29 d0                	sub    %edx,%eax
  803363:	83 ec 04             	sub    $0x4,%esp
  803366:	6a 01                	push   $0x1
  803368:	50                   	push   %eax
  803369:	ff 75 bc             	pushl  -0x44(%ebp)
  80336c:	e8 74 f5 ff ff       	call   8028e5 <set_block_data>
  803371:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803374:	83 ec 0c             	sub    $0xc,%esp
  803377:	ff 75 bc             	pushl  -0x44(%ebp)
  80337a:	e8 36 04 00 00       	call   8037b5 <free_block>
  80337f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803382:	83 ec 0c             	sub    $0xc,%esp
  803385:	ff 75 08             	pushl  0x8(%ebp)
  803388:	e8 43 fa ff ff       	call   802dd0 <alloc_block_BF>
  80338d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803390:	c9                   	leave  
  803391:	c3                   	ret    

00803392 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803392:	55                   	push   %ebp
  803393:	89 e5                	mov    %esp,%ebp
  803395:	53                   	push   %ebx
  803396:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803399:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8033a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ab:	74 1e                	je     8033cb <merging+0x39>
  8033ad:	ff 75 08             	pushl  0x8(%ebp)
  8033b0:	e8 df f1 ff ff       	call   802594 <get_block_size>
  8033b5:	83 c4 04             	add    $0x4,%esp
  8033b8:	89 c2                	mov    %eax,%edx
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	01 d0                	add    %edx,%eax
  8033bf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8033c2:	75 07                	jne    8033cb <merging+0x39>
		prev_is_free = 1;
  8033c4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8033cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033cf:	74 1e                	je     8033ef <merging+0x5d>
  8033d1:	ff 75 10             	pushl  0x10(%ebp)
  8033d4:	e8 bb f1 ff ff       	call   802594 <get_block_size>
  8033d9:	83 c4 04             	add    $0x4,%esp
  8033dc:	89 c2                	mov    %eax,%edx
  8033de:	8b 45 10             	mov    0x10(%ebp),%eax
  8033e1:	01 d0                	add    %edx,%eax
  8033e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033e6:	75 07                	jne    8033ef <merging+0x5d>
		next_is_free = 1;
  8033e8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8033ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f3:	0f 84 cc 00 00 00    	je     8034c5 <merging+0x133>
  8033f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033fd:	0f 84 c2 00 00 00    	je     8034c5 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803403:	ff 75 08             	pushl  0x8(%ebp)
  803406:	e8 89 f1 ff ff       	call   802594 <get_block_size>
  80340b:	83 c4 04             	add    $0x4,%esp
  80340e:	89 c3                	mov    %eax,%ebx
  803410:	ff 75 10             	pushl  0x10(%ebp)
  803413:	e8 7c f1 ff ff       	call   802594 <get_block_size>
  803418:	83 c4 04             	add    $0x4,%esp
  80341b:	01 c3                	add    %eax,%ebx
  80341d:	ff 75 0c             	pushl  0xc(%ebp)
  803420:	e8 6f f1 ff ff       	call   802594 <get_block_size>
  803425:	83 c4 04             	add    $0x4,%esp
  803428:	01 d8                	add    %ebx,%eax
  80342a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80342d:	6a 00                	push   $0x0
  80342f:	ff 75 ec             	pushl  -0x14(%ebp)
  803432:	ff 75 08             	pushl  0x8(%ebp)
  803435:	e8 ab f4 ff ff       	call   8028e5 <set_block_data>
  80343a:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80343d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803441:	75 17                	jne    80345a <merging+0xc8>
  803443:	83 ec 04             	sub    $0x4,%esp
  803446:	68 17 4b 80 00       	push   $0x804b17
  80344b:	68 7d 01 00 00       	push   $0x17d
  803450:	68 35 4b 80 00       	push   $0x804b35
  803455:	e8 e3 d2 ff ff       	call   80073d <_panic>
  80345a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80345d:	8b 00                	mov    (%eax),%eax
  80345f:	85 c0                	test   %eax,%eax
  803461:	74 10                	je     803473 <merging+0xe1>
  803463:	8b 45 0c             	mov    0xc(%ebp),%eax
  803466:	8b 00                	mov    (%eax),%eax
  803468:	8b 55 0c             	mov    0xc(%ebp),%edx
  80346b:	8b 52 04             	mov    0x4(%edx),%edx
  80346e:	89 50 04             	mov    %edx,0x4(%eax)
  803471:	eb 0b                	jmp    80347e <merging+0xec>
  803473:	8b 45 0c             	mov    0xc(%ebp),%eax
  803476:	8b 40 04             	mov    0x4(%eax),%eax
  803479:	a3 34 50 80 00       	mov    %eax,0x805034
  80347e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803481:	8b 40 04             	mov    0x4(%eax),%eax
  803484:	85 c0                	test   %eax,%eax
  803486:	74 0f                	je     803497 <merging+0x105>
  803488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348b:	8b 40 04             	mov    0x4(%eax),%eax
  80348e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803491:	8b 12                	mov    (%edx),%edx
  803493:	89 10                	mov    %edx,(%eax)
  803495:	eb 0a                	jmp    8034a1 <merging+0x10f>
  803497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349a:	8b 00                	mov    (%eax),%eax
  80349c:	a3 30 50 80 00       	mov    %eax,0x805030
  8034a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034b9:	48                   	dec    %eax
  8034ba:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8034bf:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034c0:	e9 ea 02 00 00       	jmp    8037af <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8034c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c9:	74 3b                	je     803506 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8034cb:	83 ec 0c             	sub    $0xc,%esp
  8034ce:	ff 75 08             	pushl  0x8(%ebp)
  8034d1:	e8 be f0 ff ff       	call   802594 <get_block_size>
  8034d6:	83 c4 10             	add    $0x10,%esp
  8034d9:	89 c3                	mov    %eax,%ebx
  8034db:	83 ec 0c             	sub    $0xc,%esp
  8034de:	ff 75 10             	pushl  0x10(%ebp)
  8034e1:	e8 ae f0 ff ff       	call   802594 <get_block_size>
  8034e6:	83 c4 10             	add    $0x10,%esp
  8034e9:	01 d8                	add    %ebx,%eax
  8034eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8034ee:	83 ec 04             	sub    $0x4,%esp
  8034f1:	6a 00                	push   $0x0
  8034f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8034f6:	ff 75 08             	pushl  0x8(%ebp)
  8034f9:	e8 e7 f3 ff ff       	call   8028e5 <set_block_data>
  8034fe:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803501:	e9 a9 02 00 00       	jmp    8037af <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803506:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80350a:	0f 84 2d 01 00 00    	je     80363d <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803510:	83 ec 0c             	sub    $0xc,%esp
  803513:	ff 75 10             	pushl  0x10(%ebp)
  803516:	e8 79 f0 ff ff       	call   802594 <get_block_size>
  80351b:	83 c4 10             	add    $0x10,%esp
  80351e:	89 c3                	mov    %eax,%ebx
  803520:	83 ec 0c             	sub    $0xc,%esp
  803523:	ff 75 0c             	pushl  0xc(%ebp)
  803526:	e8 69 f0 ff ff       	call   802594 <get_block_size>
  80352b:	83 c4 10             	add    $0x10,%esp
  80352e:	01 d8                	add    %ebx,%eax
  803530:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803533:	83 ec 04             	sub    $0x4,%esp
  803536:	6a 00                	push   $0x0
  803538:	ff 75 e4             	pushl  -0x1c(%ebp)
  80353b:	ff 75 10             	pushl  0x10(%ebp)
  80353e:	e8 a2 f3 ff ff       	call   8028e5 <set_block_data>
  803543:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803546:	8b 45 10             	mov    0x10(%ebp),%eax
  803549:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80354c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803550:	74 06                	je     803558 <merging+0x1c6>
  803552:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803556:	75 17                	jne    80356f <merging+0x1dd>
  803558:	83 ec 04             	sub    $0x4,%esp
  80355b:	68 dc 4b 80 00       	push   $0x804bdc
  803560:	68 8d 01 00 00       	push   $0x18d
  803565:	68 35 4b 80 00       	push   $0x804b35
  80356a:	e8 ce d1 ff ff       	call   80073d <_panic>
  80356f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803572:	8b 50 04             	mov    0x4(%eax),%edx
  803575:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803578:	89 50 04             	mov    %edx,0x4(%eax)
  80357b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80357e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803581:	89 10                	mov    %edx,(%eax)
  803583:	8b 45 0c             	mov    0xc(%ebp),%eax
  803586:	8b 40 04             	mov    0x4(%eax),%eax
  803589:	85 c0                	test   %eax,%eax
  80358b:	74 0d                	je     80359a <merging+0x208>
  80358d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803590:	8b 40 04             	mov    0x4(%eax),%eax
  803593:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803596:	89 10                	mov    %edx,(%eax)
  803598:	eb 08                	jmp    8035a2 <merging+0x210>
  80359a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80359d:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035a8:	89 50 04             	mov    %edx,0x4(%eax)
  8035ab:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035b0:	40                   	inc    %eax
  8035b1:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  8035b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035ba:	75 17                	jne    8035d3 <merging+0x241>
  8035bc:	83 ec 04             	sub    $0x4,%esp
  8035bf:	68 17 4b 80 00       	push   $0x804b17
  8035c4:	68 8e 01 00 00       	push   $0x18e
  8035c9:	68 35 4b 80 00       	push   $0x804b35
  8035ce:	e8 6a d1 ff ff       	call   80073d <_panic>
  8035d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d6:	8b 00                	mov    (%eax),%eax
  8035d8:	85 c0                	test   %eax,%eax
  8035da:	74 10                	je     8035ec <merging+0x25a>
  8035dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035df:	8b 00                	mov    (%eax),%eax
  8035e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035e4:	8b 52 04             	mov    0x4(%edx),%edx
  8035e7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ea:	eb 0b                	jmp    8035f7 <merging+0x265>
  8035ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ef:	8b 40 04             	mov    0x4(%eax),%eax
  8035f2:	a3 34 50 80 00       	mov    %eax,0x805034
  8035f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fa:	8b 40 04             	mov    0x4(%eax),%eax
  8035fd:	85 c0                	test   %eax,%eax
  8035ff:	74 0f                	je     803610 <merging+0x27e>
  803601:	8b 45 0c             	mov    0xc(%ebp),%eax
  803604:	8b 40 04             	mov    0x4(%eax),%eax
  803607:	8b 55 0c             	mov    0xc(%ebp),%edx
  80360a:	8b 12                	mov    (%edx),%edx
  80360c:	89 10                	mov    %edx,(%eax)
  80360e:	eb 0a                	jmp    80361a <merging+0x288>
  803610:	8b 45 0c             	mov    0xc(%ebp),%eax
  803613:	8b 00                	mov    (%eax),%eax
  803615:	a3 30 50 80 00       	mov    %eax,0x805030
  80361a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80361d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803623:	8b 45 0c             	mov    0xc(%ebp),%eax
  803626:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803632:	48                   	dec    %eax
  803633:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803638:	e9 72 01 00 00       	jmp    8037af <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80363d:	8b 45 10             	mov    0x10(%ebp),%eax
  803640:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803643:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803647:	74 79                	je     8036c2 <merging+0x330>
  803649:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80364d:	74 73                	je     8036c2 <merging+0x330>
  80364f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803653:	74 06                	je     80365b <merging+0x2c9>
  803655:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803659:	75 17                	jne    803672 <merging+0x2e0>
  80365b:	83 ec 04             	sub    $0x4,%esp
  80365e:	68 a8 4b 80 00       	push   $0x804ba8
  803663:	68 94 01 00 00       	push   $0x194
  803668:	68 35 4b 80 00       	push   $0x804b35
  80366d:	e8 cb d0 ff ff       	call   80073d <_panic>
  803672:	8b 45 08             	mov    0x8(%ebp),%eax
  803675:	8b 10                	mov    (%eax),%edx
  803677:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80367a:	89 10                	mov    %edx,(%eax)
  80367c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80367f:	8b 00                	mov    (%eax),%eax
  803681:	85 c0                	test   %eax,%eax
  803683:	74 0b                	je     803690 <merging+0x2fe>
  803685:	8b 45 08             	mov    0x8(%ebp),%eax
  803688:	8b 00                	mov    (%eax),%eax
  80368a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80368d:	89 50 04             	mov    %edx,0x4(%eax)
  803690:	8b 45 08             	mov    0x8(%ebp),%eax
  803693:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803696:	89 10                	mov    %edx,(%eax)
  803698:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80369b:	8b 55 08             	mov    0x8(%ebp),%edx
  80369e:	89 50 04             	mov    %edx,0x4(%eax)
  8036a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036a4:	8b 00                	mov    (%eax),%eax
  8036a6:	85 c0                	test   %eax,%eax
  8036a8:	75 08                	jne    8036b2 <merging+0x320>
  8036aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ad:	a3 34 50 80 00       	mov    %eax,0x805034
  8036b2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036b7:	40                   	inc    %eax
  8036b8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036bd:	e9 ce 00 00 00       	jmp    803790 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8036c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036c6:	74 65                	je     80372d <merging+0x39b>
  8036c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036cc:	75 17                	jne    8036e5 <merging+0x353>
  8036ce:	83 ec 04             	sub    $0x4,%esp
  8036d1:	68 84 4b 80 00       	push   $0x804b84
  8036d6:	68 95 01 00 00       	push   $0x195
  8036db:	68 35 4b 80 00       	push   $0x804b35
  8036e0:	e8 58 d0 ff ff       	call   80073d <_panic>
  8036e5:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8036eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ee:	89 50 04             	mov    %edx,0x4(%eax)
  8036f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f4:	8b 40 04             	mov    0x4(%eax),%eax
  8036f7:	85 c0                	test   %eax,%eax
  8036f9:	74 0c                	je     803707 <merging+0x375>
  8036fb:	a1 34 50 80 00       	mov    0x805034,%eax
  803700:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803703:	89 10                	mov    %edx,(%eax)
  803705:	eb 08                	jmp    80370f <merging+0x37d>
  803707:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80370a:	a3 30 50 80 00       	mov    %eax,0x805030
  80370f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803712:	a3 34 50 80 00       	mov    %eax,0x805034
  803717:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80371a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803720:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803725:	40                   	inc    %eax
  803726:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80372b:	eb 63                	jmp    803790 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80372d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803731:	75 17                	jne    80374a <merging+0x3b8>
  803733:	83 ec 04             	sub    $0x4,%esp
  803736:	68 50 4b 80 00       	push   $0x804b50
  80373b:	68 98 01 00 00       	push   $0x198
  803740:	68 35 4b 80 00       	push   $0x804b35
  803745:	e8 f3 cf ff ff       	call   80073d <_panic>
  80374a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803750:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803753:	89 10                	mov    %edx,(%eax)
  803755:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803758:	8b 00                	mov    (%eax),%eax
  80375a:	85 c0                	test   %eax,%eax
  80375c:	74 0d                	je     80376b <merging+0x3d9>
  80375e:	a1 30 50 80 00       	mov    0x805030,%eax
  803763:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803766:	89 50 04             	mov    %edx,0x4(%eax)
  803769:	eb 08                	jmp    803773 <merging+0x3e1>
  80376b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80376e:	a3 34 50 80 00       	mov    %eax,0x805034
  803773:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803776:	a3 30 50 80 00       	mov    %eax,0x805030
  80377b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80377e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803785:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80378a:	40                   	inc    %eax
  80378b:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803790:	83 ec 0c             	sub    $0xc,%esp
  803793:	ff 75 10             	pushl  0x10(%ebp)
  803796:	e8 f9 ed ff ff       	call   802594 <get_block_size>
  80379b:	83 c4 10             	add    $0x10,%esp
  80379e:	83 ec 04             	sub    $0x4,%esp
  8037a1:	6a 00                	push   $0x0
  8037a3:	50                   	push   %eax
  8037a4:	ff 75 10             	pushl  0x10(%ebp)
  8037a7:	e8 39 f1 ff ff       	call   8028e5 <set_block_data>
  8037ac:	83 c4 10             	add    $0x10,%esp
	}
}
  8037af:	90                   	nop
  8037b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8037b3:	c9                   	leave  
  8037b4:	c3                   	ret    

008037b5 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8037b5:	55                   	push   %ebp
  8037b6:	89 e5                	mov    %esp,%ebp
  8037b8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8037bb:	a1 30 50 80 00       	mov    0x805030,%eax
  8037c0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8037c3:	a1 34 50 80 00       	mov    0x805034,%eax
  8037c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037cb:	73 1b                	jae    8037e8 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8037cd:	a1 34 50 80 00       	mov    0x805034,%eax
  8037d2:	83 ec 04             	sub    $0x4,%esp
  8037d5:	ff 75 08             	pushl  0x8(%ebp)
  8037d8:	6a 00                	push   $0x0
  8037da:	50                   	push   %eax
  8037db:	e8 b2 fb ff ff       	call   803392 <merging>
  8037e0:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037e3:	e9 8b 00 00 00       	jmp    803873 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8037e8:	a1 30 50 80 00       	mov    0x805030,%eax
  8037ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037f0:	76 18                	jbe    80380a <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8037f2:	a1 30 50 80 00       	mov    0x805030,%eax
  8037f7:	83 ec 04             	sub    $0x4,%esp
  8037fa:	ff 75 08             	pushl  0x8(%ebp)
  8037fd:	50                   	push   %eax
  8037fe:	6a 00                	push   $0x0
  803800:	e8 8d fb ff ff       	call   803392 <merging>
  803805:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803808:	eb 69                	jmp    803873 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80380a:	a1 30 50 80 00       	mov    0x805030,%eax
  80380f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803812:	eb 39                	jmp    80384d <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803817:	3b 45 08             	cmp    0x8(%ebp),%eax
  80381a:	73 29                	jae    803845 <free_block+0x90>
  80381c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381f:	8b 00                	mov    (%eax),%eax
  803821:	3b 45 08             	cmp    0x8(%ebp),%eax
  803824:	76 1f                	jbe    803845 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803829:	8b 00                	mov    (%eax),%eax
  80382b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80382e:	83 ec 04             	sub    $0x4,%esp
  803831:	ff 75 08             	pushl  0x8(%ebp)
  803834:	ff 75 f0             	pushl  -0x10(%ebp)
  803837:	ff 75 f4             	pushl  -0xc(%ebp)
  80383a:	e8 53 fb ff ff       	call   803392 <merging>
  80383f:	83 c4 10             	add    $0x10,%esp
			break;
  803842:	90                   	nop
		}
	}
}
  803843:	eb 2e                	jmp    803873 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803845:	a1 38 50 80 00       	mov    0x805038,%eax
  80384a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80384d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803851:	74 07                	je     80385a <free_block+0xa5>
  803853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803856:	8b 00                	mov    (%eax),%eax
  803858:	eb 05                	jmp    80385f <free_block+0xaa>
  80385a:	b8 00 00 00 00       	mov    $0x0,%eax
  80385f:	a3 38 50 80 00       	mov    %eax,0x805038
  803864:	a1 38 50 80 00       	mov    0x805038,%eax
  803869:	85 c0                	test   %eax,%eax
  80386b:	75 a7                	jne    803814 <free_block+0x5f>
  80386d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803871:	75 a1                	jne    803814 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803873:	90                   	nop
  803874:	c9                   	leave  
  803875:	c3                   	ret    

00803876 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803876:	55                   	push   %ebp
  803877:	89 e5                	mov    %esp,%ebp
  803879:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80387c:	ff 75 08             	pushl  0x8(%ebp)
  80387f:	e8 10 ed ff ff       	call   802594 <get_block_size>
  803884:	83 c4 04             	add    $0x4,%esp
  803887:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80388a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803891:	eb 17                	jmp    8038aa <copy_data+0x34>
  803893:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803896:	8b 45 0c             	mov    0xc(%ebp),%eax
  803899:	01 c2                	add    %eax,%edx
  80389b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80389e:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a1:	01 c8                	add    %ecx,%eax
  8038a3:	8a 00                	mov    (%eax),%al
  8038a5:	88 02                	mov    %al,(%edx)
  8038a7:	ff 45 fc             	incl   -0x4(%ebp)
  8038aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8038ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8038b0:	72 e1                	jb     803893 <copy_data+0x1d>
}
  8038b2:	90                   	nop
  8038b3:	c9                   	leave  
  8038b4:	c3                   	ret    

008038b5 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8038b5:	55                   	push   %ebp
  8038b6:	89 e5                	mov    %esp,%ebp
  8038b8:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8038bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038bf:	75 23                	jne    8038e4 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8038c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038c5:	74 13                	je     8038da <realloc_block_FF+0x25>
  8038c7:	83 ec 0c             	sub    $0xc,%esp
  8038ca:	ff 75 0c             	pushl  0xc(%ebp)
  8038cd:	e8 42 f0 ff ff       	call   802914 <alloc_block_FF>
  8038d2:	83 c4 10             	add    $0x10,%esp
  8038d5:	e9 e4 06 00 00       	jmp    803fbe <realloc_block_FF+0x709>
		return NULL;
  8038da:	b8 00 00 00 00       	mov    $0x0,%eax
  8038df:	e9 da 06 00 00       	jmp    803fbe <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8038e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038e8:	75 18                	jne    803902 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8038ea:	83 ec 0c             	sub    $0xc,%esp
  8038ed:	ff 75 08             	pushl  0x8(%ebp)
  8038f0:	e8 c0 fe ff ff       	call   8037b5 <free_block>
  8038f5:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8038f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8038fd:	e9 bc 06 00 00       	jmp    803fbe <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803902:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803906:	77 07                	ja     80390f <realloc_block_FF+0x5a>
  803908:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80390f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803912:	83 e0 01             	and    $0x1,%eax
  803915:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80391b:	83 c0 08             	add    $0x8,%eax
  80391e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803921:	83 ec 0c             	sub    $0xc,%esp
  803924:	ff 75 08             	pushl  0x8(%ebp)
  803927:	e8 68 ec ff ff       	call   802594 <get_block_size>
  80392c:	83 c4 10             	add    $0x10,%esp
  80392f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803932:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803935:	83 e8 08             	sub    $0x8,%eax
  803938:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80393b:	8b 45 08             	mov    0x8(%ebp),%eax
  80393e:	83 e8 04             	sub    $0x4,%eax
  803941:	8b 00                	mov    (%eax),%eax
  803943:	83 e0 fe             	and    $0xfffffffe,%eax
  803946:	89 c2                	mov    %eax,%edx
  803948:	8b 45 08             	mov    0x8(%ebp),%eax
  80394b:	01 d0                	add    %edx,%eax
  80394d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803950:	83 ec 0c             	sub    $0xc,%esp
  803953:	ff 75 e4             	pushl  -0x1c(%ebp)
  803956:	e8 39 ec ff ff       	call   802594 <get_block_size>
  80395b:	83 c4 10             	add    $0x10,%esp
  80395e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803961:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803964:	83 e8 08             	sub    $0x8,%eax
  803967:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80396a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80396d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803970:	75 08                	jne    80397a <realloc_block_FF+0xc5>
	{
		 return va;
  803972:	8b 45 08             	mov    0x8(%ebp),%eax
  803975:	e9 44 06 00 00       	jmp    803fbe <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  80397a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80397d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803980:	0f 83 d5 03 00 00    	jae    803d5b <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803986:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803989:	2b 45 0c             	sub    0xc(%ebp),%eax
  80398c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80398f:	83 ec 0c             	sub    $0xc,%esp
  803992:	ff 75 e4             	pushl  -0x1c(%ebp)
  803995:	e8 13 ec ff ff       	call   8025ad <is_free_block>
  80399a:	83 c4 10             	add    $0x10,%esp
  80399d:	84 c0                	test   %al,%al
  80399f:	0f 84 3b 01 00 00    	je     803ae0 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8039a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039ab:	01 d0                	add    %edx,%eax
  8039ad:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8039b0:	83 ec 04             	sub    $0x4,%esp
  8039b3:	6a 01                	push   $0x1
  8039b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8039b8:	ff 75 08             	pushl  0x8(%ebp)
  8039bb:	e8 25 ef ff ff       	call   8028e5 <set_block_data>
  8039c0:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8039c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c6:	83 e8 04             	sub    $0x4,%eax
  8039c9:	8b 00                	mov    (%eax),%eax
  8039cb:	83 e0 fe             	and    $0xfffffffe,%eax
  8039ce:	89 c2                	mov    %eax,%edx
  8039d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d3:	01 d0                	add    %edx,%eax
  8039d5:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8039d8:	83 ec 04             	sub    $0x4,%esp
  8039db:	6a 00                	push   $0x0
  8039dd:	ff 75 cc             	pushl  -0x34(%ebp)
  8039e0:	ff 75 c8             	pushl  -0x38(%ebp)
  8039e3:	e8 fd ee ff ff       	call   8028e5 <set_block_data>
  8039e8:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039ef:	74 06                	je     8039f7 <realloc_block_FF+0x142>
  8039f1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8039f5:	75 17                	jne    803a0e <realloc_block_FF+0x159>
  8039f7:	83 ec 04             	sub    $0x4,%esp
  8039fa:	68 a8 4b 80 00       	push   $0x804ba8
  8039ff:	68 f6 01 00 00       	push   $0x1f6
  803a04:	68 35 4b 80 00       	push   $0x804b35
  803a09:	e8 2f cd ff ff       	call   80073d <_panic>
  803a0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a11:	8b 10                	mov    (%eax),%edx
  803a13:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a16:	89 10                	mov    %edx,(%eax)
  803a18:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a1b:	8b 00                	mov    (%eax),%eax
  803a1d:	85 c0                	test   %eax,%eax
  803a1f:	74 0b                	je     803a2c <realloc_block_FF+0x177>
  803a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a24:	8b 00                	mov    (%eax),%eax
  803a26:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a29:	89 50 04             	mov    %edx,0x4(%eax)
  803a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a32:	89 10                	mov    %edx,(%eax)
  803a34:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a3a:	89 50 04             	mov    %edx,0x4(%eax)
  803a3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a40:	8b 00                	mov    (%eax),%eax
  803a42:	85 c0                	test   %eax,%eax
  803a44:	75 08                	jne    803a4e <realloc_block_FF+0x199>
  803a46:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a49:	a3 34 50 80 00       	mov    %eax,0x805034
  803a4e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a53:	40                   	inc    %eax
  803a54:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a5d:	75 17                	jne    803a76 <realloc_block_FF+0x1c1>
  803a5f:	83 ec 04             	sub    $0x4,%esp
  803a62:	68 17 4b 80 00       	push   $0x804b17
  803a67:	68 f7 01 00 00       	push   $0x1f7
  803a6c:	68 35 4b 80 00       	push   $0x804b35
  803a71:	e8 c7 cc ff ff       	call   80073d <_panic>
  803a76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a79:	8b 00                	mov    (%eax),%eax
  803a7b:	85 c0                	test   %eax,%eax
  803a7d:	74 10                	je     803a8f <realloc_block_FF+0x1da>
  803a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a82:	8b 00                	mov    (%eax),%eax
  803a84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a87:	8b 52 04             	mov    0x4(%edx),%edx
  803a8a:	89 50 04             	mov    %edx,0x4(%eax)
  803a8d:	eb 0b                	jmp    803a9a <realloc_block_FF+0x1e5>
  803a8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a92:	8b 40 04             	mov    0x4(%eax),%eax
  803a95:	a3 34 50 80 00       	mov    %eax,0x805034
  803a9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9d:	8b 40 04             	mov    0x4(%eax),%eax
  803aa0:	85 c0                	test   %eax,%eax
  803aa2:	74 0f                	je     803ab3 <realloc_block_FF+0x1fe>
  803aa4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa7:	8b 40 04             	mov    0x4(%eax),%eax
  803aaa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aad:	8b 12                	mov    (%edx),%edx
  803aaf:	89 10                	mov    %edx,(%eax)
  803ab1:	eb 0a                	jmp    803abd <realloc_block_FF+0x208>
  803ab3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab6:	8b 00                	mov    (%eax),%eax
  803ab8:	a3 30 50 80 00       	mov    %eax,0x805030
  803abd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ac6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ad0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ad5:	48                   	dec    %eax
  803ad6:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803adb:	e9 73 02 00 00       	jmp    803d53 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803ae0:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803ae4:	0f 86 69 02 00 00    	jbe    803d53 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803aea:	83 ec 04             	sub    $0x4,%esp
  803aed:	6a 01                	push   $0x1
  803aef:	ff 75 f0             	pushl  -0x10(%ebp)
  803af2:	ff 75 08             	pushl  0x8(%ebp)
  803af5:	e8 eb ed ff ff       	call   8028e5 <set_block_data>
  803afa:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803afd:	8b 45 08             	mov    0x8(%ebp),%eax
  803b00:	83 e8 04             	sub    $0x4,%eax
  803b03:	8b 00                	mov    (%eax),%eax
  803b05:	83 e0 fe             	and    $0xfffffffe,%eax
  803b08:	89 c2                	mov    %eax,%edx
  803b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0d:	01 d0                	add    %edx,%eax
  803b0f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803b12:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b17:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803b1a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b1e:	75 68                	jne    803b88 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b20:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b24:	75 17                	jne    803b3d <realloc_block_FF+0x288>
  803b26:	83 ec 04             	sub    $0x4,%esp
  803b29:	68 50 4b 80 00       	push   $0x804b50
  803b2e:	68 06 02 00 00       	push   $0x206
  803b33:	68 35 4b 80 00       	push   $0x804b35
  803b38:	e8 00 cc ff ff       	call   80073d <_panic>
  803b3d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b46:	89 10                	mov    %edx,(%eax)
  803b48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b4b:	8b 00                	mov    (%eax),%eax
  803b4d:	85 c0                	test   %eax,%eax
  803b4f:	74 0d                	je     803b5e <realloc_block_FF+0x2a9>
  803b51:	a1 30 50 80 00       	mov    0x805030,%eax
  803b56:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b59:	89 50 04             	mov    %edx,0x4(%eax)
  803b5c:	eb 08                	jmp    803b66 <realloc_block_FF+0x2b1>
  803b5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b61:	a3 34 50 80 00       	mov    %eax,0x805034
  803b66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b69:	a3 30 50 80 00       	mov    %eax,0x805030
  803b6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b78:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b7d:	40                   	inc    %eax
  803b7e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b83:	e9 b0 01 00 00       	jmp    803d38 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803b88:	a1 30 50 80 00       	mov    0x805030,%eax
  803b8d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b90:	76 68                	jbe    803bfa <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b92:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b96:	75 17                	jne    803baf <realloc_block_FF+0x2fa>
  803b98:	83 ec 04             	sub    $0x4,%esp
  803b9b:	68 50 4b 80 00       	push   $0x804b50
  803ba0:	68 0b 02 00 00       	push   $0x20b
  803ba5:	68 35 4b 80 00       	push   $0x804b35
  803baa:	e8 8e cb ff ff       	call   80073d <_panic>
  803baf:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803bb5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bb8:	89 10                	mov    %edx,(%eax)
  803bba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bbd:	8b 00                	mov    (%eax),%eax
  803bbf:	85 c0                	test   %eax,%eax
  803bc1:	74 0d                	je     803bd0 <realloc_block_FF+0x31b>
  803bc3:	a1 30 50 80 00       	mov    0x805030,%eax
  803bc8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bcb:	89 50 04             	mov    %edx,0x4(%eax)
  803bce:	eb 08                	jmp    803bd8 <realloc_block_FF+0x323>
  803bd0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bd3:	a3 34 50 80 00       	mov    %eax,0x805034
  803bd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bdb:	a3 30 50 80 00       	mov    %eax,0x805030
  803be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bea:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bef:	40                   	inc    %eax
  803bf0:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803bf5:	e9 3e 01 00 00       	jmp    803d38 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803bfa:	a1 30 50 80 00       	mov    0x805030,%eax
  803bff:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c02:	73 68                	jae    803c6c <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c04:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c08:	75 17                	jne    803c21 <realloc_block_FF+0x36c>
  803c0a:	83 ec 04             	sub    $0x4,%esp
  803c0d:	68 84 4b 80 00       	push   $0x804b84
  803c12:	68 10 02 00 00       	push   $0x210
  803c17:	68 35 4b 80 00       	push   $0x804b35
  803c1c:	e8 1c cb ff ff       	call   80073d <_panic>
  803c21:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803c27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c2a:	89 50 04             	mov    %edx,0x4(%eax)
  803c2d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c30:	8b 40 04             	mov    0x4(%eax),%eax
  803c33:	85 c0                	test   %eax,%eax
  803c35:	74 0c                	je     803c43 <realloc_block_FF+0x38e>
  803c37:	a1 34 50 80 00       	mov    0x805034,%eax
  803c3c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c3f:	89 10                	mov    %edx,(%eax)
  803c41:	eb 08                	jmp    803c4b <realloc_block_FF+0x396>
  803c43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c46:	a3 30 50 80 00       	mov    %eax,0x805030
  803c4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c4e:	a3 34 50 80 00       	mov    %eax,0x805034
  803c53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c5c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c61:	40                   	inc    %eax
  803c62:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c67:	e9 cc 00 00 00       	jmp    803d38 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803c6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803c73:	a1 30 50 80 00       	mov    0x805030,%eax
  803c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c7b:	e9 8a 00 00 00       	jmp    803d0a <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c83:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c86:	73 7a                	jae    803d02 <realloc_block_FF+0x44d>
  803c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8b:	8b 00                	mov    (%eax),%eax
  803c8d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c90:	73 70                	jae    803d02 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803c92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c96:	74 06                	je     803c9e <realloc_block_FF+0x3e9>
  803c98:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c9c:	75 17                	jne    803cb5 <realloc_block_FF+0x400>
  803c9e:	83 ec 04             	sub    $0x4,%esp
  803ca1:	68 a8 4b 80 00       	push   $0x804ba8
  803ca6:	68 1a 02 00 00       	push   $0x21a
  803cab:	68 35 4b 80 00       	push   $0x804b35
  803cb0:	e8 88 ca ff ff       	call   80073d <_panic>
  803cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb8:	8b 10                	mov    (%eax),%edx
  803cba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cbd:	89 10                	mov    %edx,(%eax)
  803cbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc2:	8b 00                	mov    (%eax),%eax
  803cc4:	85 c0                	test   %eax,%eax
  803cc6:	74 0b                	je     803cd3 <realloc_block_FF+0x41e>
  803cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ccb:	8b 00                	mov    (%eax),%eax
  803ccd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cd0:	89 50 04             	mov    %edx,0x4(%eax)
  803cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cd9:	89 10                	mov    %edx,(%eax)
  803cdb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ce1:	89 50 04             	mov    %edx,0x4(%eax)
  803ce4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce7:	8b 00                	mov    (%eax),%eax
  803ce9:	85 c0                	test   %eax,%eax
  803ceb:	75 08                	jne    803cf5 <realloc_block_FF+0x440>
  803ced:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cf0:	a3 34 50 80 00       	mov    %eax,0x805034
  803cf5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803cfa:	40                   	inc    %eax
  803cfb:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803d00:	eb 36                	jmp    803d38 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803d02:	a1 38 50 80 00       	mov    0x805038,%eax
  803d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d0e:	74 07                	je     803d17 <realloc_block_FF+0x462>
  803d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d13:	8b 00                	mov    (%eax),%eax
  803d15:	eb 05                	jmp    803d1c <realloc_block_FF+0x467>
  803d17:	b8 00 00 00 00       	mov    $0x0,%eax
  803d1c:	a3 38 50 80 00       	mov    %eax,0x805038
  803d21:	a1 38 50 80 00       	mov    0x805038,%eax
  803d26:	85 c0                	test   %eax,%eax
  803d28:	0f 85 52 ff ff ff    	jne    803c80 <realloc_block_FF+0x3cb>
  803d2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d32:	0f 85 48 ff ff ff    	jne    803c80 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803d38:	83 ec 04             	sub    $0x4,%esp
  803d3b:	6a 00                	push   $0x0
  803d3d:	ff 75 d8             	pushl  -0x28(%ebp)
  803d40:	ff 75 d4             	pushl  -0x2c(%ebp)
  803d43:	e8 9d eb ff ff       	call   8028e5 <set_block_data>
  803d48:	83 c4 10             	add    $0x10,%esp
				return va;
  803d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d4e:	e9 6b 02 00 00       	jmp    803fbe <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803d53:	8b 45 08             	mov    0x8(%ebp),%eax
  803d56:	e9 63 02 00 00       	jmp    803fbe <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d5e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d61:	0f 86 4d 02 00 00    	jbe    803fb4 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803d67:	83 ec 0c             	sub    $0xc,%esp
  803d6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d6d:	e8 3b e8 ff ff       	call   8025ad <is_free_block>
  803d72:	83 c4 10             	add    $0x10,%esp
  803d75:	84 c0                	test   %al,%al
  803d77:	0f 84 37 02 00 00    	je     803fb4 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d80:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d83:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803d86:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d89:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d8c:	76 38                	jbe    803dc6 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803d8e:	83 ec 0c             	sub    $0xc,%esp
  803d91:	ff 75 0c             	pushl  0xc(%ebp)
  803d94:	e8 7b eb ff ff       	call   802914 <alloc_block_FF>
  803d99:	83 c4 10             	add    $0x10,%esp
  803d9c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803d9f:	83 ec 08             	sub    $0x8,%esp
  803da2:	ff 75 c0             	pushl  -0x40(%ebp)
  803da5:	ff 75 08             	pushl  0x8(%ebp)
  803da8:	e8 c9 fa ff ff       	call   803876 <copy_data>
  803dad:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803db0:	83 ec 0c             	sub    $0xc,%esp
  803db3:	ff 75 08             	pushl  0x8(%ebp)
  803db6:	e8 fa f9 ff ff       	call   8037b5 <free_block>
  803dbb:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803dbe:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803dc1:	e9 f8 01 00 00       	jmp    803fbe <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803dc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dc9:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803dcc:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803dcf:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803dd3:	0f 87 a0 00 00 00    	ja     803e79 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803dd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ddd:	75 17                	jne    803df6 <realloc_block_FF+0x541>
  803ddf:	83 ec 04             	sub    $0x4,%esp
  803de2:	68 17 4b 80 00       	push   $0x804b17
  803de7:	68 38 02 00 00       	push   $0x238
  803dec:	68 35 4b 80 00       	push   $0x804b35
  803df1:	e8 47 c9 ff ff       	call   80073d <_panic>
  803df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df9:	8b 00                	mov    (%eax),%eax
  803dfb:	85 c0                	test   %eax,%eax
  803dfd:	74 10                	je     803e0f <realloc_block_FF+0x55a>
  803dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e02:	8b 00                	mov    (%eax),%eax
  803e04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e07:	8b 52 04             	mov    0x4(%edx),%edx
  803e0a:	89 50 04             	mov    %edx,0x4(%eax)
  803e0d:	eb 0b                	jmp    803e1a <realloc_block_FF+0x565>
  803e0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e12:	8b 40 04             	mov    0x4(%eax),%eax
  803e15:	a3 34 50 80 00       	mov    %eax,0x805034
  803e1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e1d:	8b 40 04             	mov    0x4(%eax),%eax
  803e20:	85 c0                	test   %eax,%eax
  803e22:	74 0f                	je     803e33 <realloc_block_FF+0x57e>
  803e24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e27:	8b 40 04             	mov    0x4(%eax),%eax
  803e2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e2d:	8b 12                	mov    (%edx),%edx
  803e2f:	89 10                	mov    %edx,(%eax)
  803e31:	eb 0a                	jmp    803e3d <realloc_block_FF+0x588>
  803e33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e36:	8b 00                	mov    (%eax),%eax
  803e38:	a3 30 50 80 00       	mov    %eax,0x805030
  803e3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e50:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e55:	48                   	dec    %eax
  803e56:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803e5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e61:	01 d0                	add    %edx,%eax
  803e63:	83 ec 04             	sub    $0x4,%esp
  803e66:	6a 01                	push   $0x1
  803e68:	50                   	push   %eax
  803e69:	ff 75 08             	pushl  0x8(%ebp)
  803e6c:	e8 74 ea ff ff       	call   8028e5 <set_block_data>
  803e71:	83 c4 10             	add    $0x10,%esp
  803e74:	e9 36 01 00 00       	jmp    803faf <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803e79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e7c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e7f:	01 d0                	add    %edx,%eax
  803e81:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803e84:	83 ec 04             	sub    $0x4,%esp
  803e87:	6a 01                	push   $0x1
  803e89:	ff 75 f0             	pushl  -0x10(%ebp)
  803e8c:	ff 75 08             	pushl  0x8(%ebp)
  803e8f:	e8 51 ea ff ff       	call   8028e5 <set_block_data>
  803e94:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803e97:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9a:	83 e8 04             	sub    $0x4,%eax
  803e9d:	8b 00                	mov    (%eax),%eax
  803e9f:	83 e0 fe             	and    $0xfffffffe,%eax
  803ea2:	89 c2                	mov    %eax,%edx
  803ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea7:	01 d0                	add    %edx,%eax
  803ea9:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803eac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803eb0:	74 06                	je     803eb8 <realloc_block_FF+0x603>
  803eb2:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803eb6:	75 17                	jne    803ecf <realloc_block_FF+0x61a>
  803eb8:	83 ec 04             	sub    $0x4,%esp
  803ebb:	68 a8 4b 80 00       	push   $0x804ba8
  803ec0:	68 44 02 00 00       	push   $0x244
  803ec5:	68 35 4b 80 00       	push   $0x804b35
  803eca:	e8 6e c8 ff ff       	call   80073d <_panic>
  803ecf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed2:	8b 10                	mov    (%eax),%edx
  803ed4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ed7:	89 10                	mov    %edx,(%eax)
  803ed9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803edc:	8b 00                	mov    (%eax),%eax
  803ede:	85 c0                	test   %eax,%eax
  803ee0:	74 0b                	je     803eed <realloc_block_FF+0x638>
  803ee2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee5:	8b 00                	mov    (%eax),%eax
  803ee7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803eea:	89 50 04             	mov    %edx,0x4(%eax)
  803eed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ef3:	89 10                	mov    %edx,(%eax)
  803ef5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ef8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803efb:	89 50 04             	mov    %edx,0x4(%eax)
  803efe:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f01:	8b 00                	mov    (%eax),%eax
  803f03:	85 c0                	test   %eax,%eax
  803f05:	75 08                	jne    803f0f <realloc_block_FF+0x65a>
  803f07:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f0a:	a3 34 50 80 00       	mov    %eax,0x805034
  803f0f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f14:	40                   	inc    %eax
  803f15:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803f1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f1e:	75 17                	jne    803f37 <realloc_block_FF+0x682>
  803f20:	83 ec 04             	sub    $0x4,%esp
  803f23:	68 17 4b 80 00       	push   $0x804b17
  803f28:	68 45 02 00 00       	push   $0x245
  803f2d:	68 35 4b 80 00       	push   $0x804b35
  803f32:	e8 06 c8 ff ff       	call   80073d <_panic>
  803f37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f3a:	8b 00                	mov    (%eax),%eax
  803f3c:	85 c0                	test   %eax,%eax
  803f3e:	74 10                	je     803f50 <realloc_block_FF+0x69b>
  803f40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f43:	8b 00                	mov    (%eax),%eax
  803f45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f48:	8b 52 04             	mov    0x4(%edx),%edx
  803f4b:	89 50 04             	mov    %edx,0x4(%eax)
  803f4e:	eb 0b                	jmp    803f5b <realloc_block_FF+0x6a6>
  803f50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f53:	8b 40 04             	mov    0x4(%eax),%eax
  803f56:	a3 34 50 80 00       	mov    %eax,0x805034
  803f5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f5e:	8b 40 04             	mov    0x4(%eax),%eax
  803f61:	85 c0                	test   %eax,%eax
  803f63:	74 0f                	je     803f74 <realloc_block_FF+0x6bf>
  803f65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f68:	8b 40 04             	mov    0x4(%eax),%eax
  803f6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f6e:	8b 12                	mov    (%edx),%edx
  803f70:	89 10                	mov    %edx,(%eax)
  803f72:	eb 0a                	jmp    803f7e <realloc_block_FF+0x6c9>
  803f74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f77:	8b 00                	mov    (%eax),%eax
  803f79:	a3 30 50 80 00       	mov    %eax,0x805030
  803f7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f91:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f96:	48                   	dec    %eax
  803f97:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803f9c:	83 ec 04             	sub    $0x4,%esp
  803f9f:	6a 00                	push   $0x0
  803fa1:	ff 75 bc             	pushl  -0x44(%ebp)
  803fa4:	ff 75 b8             	pushl  -0x48(%ebp)
  803fa7:	e8 39 e9 ff ff       	call   8028e5 <set_block_data>
  803fac:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803faf:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb2:	eb 0a                	jmp    803fbe <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803fb4:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803fbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803fbe:	c9                   	leave  
  803fbf:	c3                   	ret    

00803fc0 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803fc0:	55                   	push   %ebp
  803fc1:	89 e5                	mov    %esp,%ebp
  803fc3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803fc6:	83 ec 04             	sub    $0x4,%esp
  803fc9:	68 14 4c 80 00       	push   $0x804c14
  803fce:	68 58 02 00 00       	push   $0x258
  803fd3:	68 35 4b 80 00       	push   $0x804b35
  803fd8:	e8 60 c7 ff ff       	call   80073d <_panic>

00803fdd <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803fdd:	55                   	push   %ebp
  803fde:	89 e5                	mov    %esp,%ebp
  803fe0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803fe3:	83 ec 04             	sub    $0x4,%esp
  803fe6:	68 3c 4c 80 00       	push   $0x804c3c
  803feb:	68 61 02 00 00       	push   $0x261
  803ff0:	68 35 4b 80 00       	push   $0x804b35
  803ff5:	e8 43 c7 ff ff       	call   80073d <_panic>
  803ffa:	66 90                	xchg   %ax,%ax

00803ffc <__udivdi3>:
  803ffc:	55                   	push   %ebp
  803ffd:	57                   	push   %edi
  803ffe:	56                   	push   %esi
  803fff:	53                   	push   %ebx
  804000:	83 ec 1c             	sub    $0x1c,%esp
  804003:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804007:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80400b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80400f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804013:	89 ca                	mov    %ecx,%edx
  804015:	89 f8                	mov    %edi,%eax
  804017:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80401b:	85 f6                	test   %esi,%esi
  80401d:	75 2d                	jne    80404c <__udivdi3+0x50>
  80401f:	39 cf                	cmp    %ecx,%edi
  804021:	77 65                	ja     804088 <__udivdi3+0x8c>
  804023:	89 fd                	mov    %edi,%ebp
  804025:	85 ff                	test   %edi,%edi
  804027:	75 0b                	jne    804034 <__udivdi3+0x38>
  804029:	b8 01 00 00 00       	mov    $0x1,%eax
  80402e:	31 d2                	xor    %edx,%edx
  804030:	f7 f7                	div    %edi
  804032:	89 c5                	mov    %eax,%ebp
  804034:	31 d2                	xor    %edx,%edx
  804036:	89 c8                	mov    %ecx,%eax
  804038:	f7 f5                	div    %ebp
  80403a:	89 c1                	mov    %eax,%ecx
  80403c:	89 d8                	mov    %ebx,%eax
  80403e:	f7 f5                	div    %ebp
  804040:	89 cf                	mov    %ecx,%edi
  804042:	89 fa                	mov    %edi,%edx
  804044:	83 c4 1c             	add    $0x1c,%esp
  804047:	5b                   	pop    %ebx
  804048:	5e                   	pop    %esi
  804049:	5f                   	pop    %edi
  80404a:	5d                   	pop    %ebp
  80404b:	c3                   	ret    
  80404c:	39 ce                	cmp    %ecx,%esi
  80404e:	77 28                	ja     804078 <__udivdi3+0x7c>
  804050:	0f bd fe             	bsr    %esi,%edi
  804053:	83 f7 1f             	xor    $0x1f,%edi
  804056:	75 40                	jne    804098 <__udivdi3+0x9c>
  804058:	39 ce                	cmp    %ecx,%esi
  80405a:	72 0a                	jb     804066 <__udivdi3+0x6a>
  80405c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804060:	0f 87 9e 00 00 00    	ja     804104 <__udivdi3+0x108>
  804066:	b8 01 00 00 00       	mov    $0x1,%eax
  80406b:	89 fa                	mov    %edi,%edx
  80406d:	83 c4 1c             	add    $0x1c,%esp
  804070:	5b                   	pop    %ebx
  804071:	5e                   	pop    %esi
  804072:	5f                   	pop    %edi
  804073:	5d                   	pop    %ebp
  804074:	c3                   	ret    
  804075:	8d 76 00             	lea    0x0(%esi),%esi
  804078:	31 ff                	xor    %edi,%edi
  80407a:	31 c0                	xor    %eax,%eax
  80407c:	89 fa                	mov    %edi,%edx
  80407e:	83 c4 1c             	add    $0x1c,%esp
  804081:	5b                   	pop    %ebx
  804082:	5e                   	pop    %esi
  804083:	5f                   	pop    %edi
  804084:	5d                   	pop    %ebp
  804085:	c3                   	ret    
  804086:	66 90                	xchg   %ax,%ax
  804088:	89 d8                	mov    %ebx,%eax
  80408a:	f7 f7                	div    %edi
  80408c:	31 ff                	xor    %edi,%edi
  80408e:	89 fa                	mov    %edi,%edx
  804090:	83 c4 1c             	add    $0x1c,%esp
  804093:	5b                   	pop    %ebx
  804094:	5e                   	pop    %esi
  804095:	5f                   	pop    %edi
  804096:	5d                   	pop    %ebp
  804097:	c3                   	ret    
  804098:	bd 20 00 00 00       	mov    $0x20,%ebp
  80409d:	89 eb                	mov    %ebp,%ebx
  80409f:	29 fb                	sub    %edi,%ebx
  8040a1:	89 f9                	mov    %edi,%ecx
  8040a3:	d3 e6                	shl    %cl,%esi
  8040a5:	89 c5                	mov    %eax,%ebp
  8040a7:	88 d9                	mov    %bl,%cl
  8040a9:	d3 ed                	shr    %cl,%ebp
  8040ab:	89 e9                	mov    %ebp,%ecx
  8040ad:	09 f1                	or     %esi,%ecx
  8040af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040b3:	89 f9                	mov    %edi,%ecx
  8040b5:	d3 e0                	shl    %cl,%eax
  8040b7:	89 c5                	mov    %eax,%ebp
  8040b9:	89 d6                	mov    %edx,%esi
  8040bb:	88 d9                	mov    %bl,%cl
  8040bd:	d3 ee                	shr    %cl,%esi
  8040bf:	89 f9                	mov    %edi,%ecx
  8040c1:	d3 e2                	shl    %cl,%edx
  8040c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040c7:	88 d9                	mov    %bl,%cl
  8040c9:	d3 e8                	shr    %cl,%eax
  8040cb:	09 c2                	or     %eax,%edx
  8040cd:	89 d0                	mov    %edx,%eax
  8040cf:	89 f2                	mov    %esi,%edx
  8040d1:	f7 74 24 0c          	divl   0xc(%esp)
  8040d5:	89 d6                	mov    %edx,%esi
  8040d7:	89 c3                	mov    %eax,%ebx
  8040d9:	f7 e5                	mul    %ebp
  8040db:	39 d6                	cmp    %edx,%esi
  8040dd:	72 19                	jb     8040f8 <__udivdi3+0xfc>
  8040df:	74 0b                	je     8040ec <__udivdi3+0xf0>
  8040e1:	89 d8                	mov    %ebx,%eax
  8040e3:	31 ff                	xor    %edi,%edi
  8040e5:	e9 58 ff ff ff       	jmp    804042 <__udivdi3+0x46>
  8040ea:	66 90                	xchg   %ax,%ax
  8040ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8040f0:	89 f9                	mov    %edi,%ecx
  8040f2:	d3 e2                	shl    %cl,%edx
  8040f4:	39 c2                	cmp    %eax,%edx
  8040f6:	73 e9                	jae    8040e1 <__udivdi3+0xe5>
  8040f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8040fb:	31 ff                	xor    %edi,%edi
  8040fd:	e9 40 ff ff ff       	jmp    804042 <__udivdi3+0x46>
  804102:	66 90                	xchg   %ax,%ax
  804104:	31 c0                	xor    %eax,%eax
  804106:	e9 37 ff ff ff       	jmp    804042 <__udivdi3+0x46>
  80410b:	90                   	nop

0080410c <__umoddi3>:
  80410c:	55                   	push   %ebp
  80410d:	57                   	push   %edi
  80410e:	56                   	push   %esi
  80410f:	53                   	push   %ebx
  804110:	83 ec 1c             	sub    $0x1c,%esp
  804113:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804117:	8b 74 24 34          	mov    0x34(%esp),%esi
  80411b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80411f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804123:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804127:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80412b:	89 f3                	mov    %esi,%ebx
  80412d:	89 fa                	mov    %edi,%edx
  80412f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804133:	89 34 24             	mov    %esi,(%esp)
  804136:	85 c0                	test   %eax,%eax
  804138:	75 1a                	jne    804154 <__umoddi3+0x48>
  80413a:	39 f7                	cmp    %esi,%edi
  80413c:	0f 86 a2 00 00 00    	jbe    8041e4 <__umoddi3+0xd8>
  804142:	89 c8                	mov    %ecx,%eax
  804144:	89 f2                	mov    %esi,%edx
  804146:	f7 f7                	div    %edi
  804148:	89 d0                	mov    %edx,%eax
  80414a:	31 d2                	xor    %edx,%edx
  80414c:	83 c4 1c             	add    $0x1c,%esp
  80414f:	5b                   	pop    %ebx
  804150:	5e                   	pop    %esi
  804151:	5f                   	pop    %edi
  804152:	5d                   	pop    %ebp
  804153:	c3                   	ret    
  804154:	39 f0                	cmp    %esi,%eax
  804156:	0f 87 ac 00 00 00    	ja     804208 <__umoddi3+0xfc>
  80415c:	0f bd e8             	bsr    %eax,%ebp
  80415f:	83 f5 1f             	xor    $0x1f,%ebp
  804162:	0f 84 ac 00 00 00    	je     804214 <__umoddi3+0x108>
  804168:	bf 20 00 00 00       	mov    $0x20,%edi
  80416d:	29 ef                	sub    %ebp,%edi
  80416f:	89 fe                	mov    %edi,%esi
  804171:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804175:	89 e9                	mov    %ebp,%ecx
  804177:	d3 e0                	shl    %cl,%eax
  804179:	89 d7                	mov    %edx,%edi
  80417b:	89 f1                	mov    %esi,%ecx
  80417d:	d3 ef                	shr    %cl,%edi
  80417f:	09 c7                	or     %eax,%edi
  804181:	89 e9                	mov    %ebp,%ecx
  804183:	d3 e2                	shl    %cl,%edx
  804185:	89 14 24             	mov    %edx,(%esp)
  804188:	89 d8                	mov    %ebx,%eax
  80418a:	d3 e0                	shl    %cl,%eax
  80418c:	89 c2                	mov    %eax,%edx
  80418e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804192:	d3 e0                	shl    %cl,%eax
  804194:	89 44 24 04          	mov    %eax,0x4(%esp)
  804198:	8b 44 24 08          	mov    0x8(%esp),%eax
  80419c:	89 f1                	mov    %esi,%ecx
  80419e:	d3 e8                	shr    %cl,%eax
  8041a0:	09 d0                	or     %edx,%eax
  8041a2:	d3 eb                	shr    %cl,%ebx
  8041a4:	89 da                	mov    %ebx,%edx
  8041a6:	f7 f7                	div    %edi
  8041a8:	89 d3                	mov    %edx,%ebx
  8041aa:	f7 24 24             	mull   (%esp)
  8041ad:	89 c6                	mov    %eax,%esi
  8041af:	89 d1                	mov    %edx,%ecx
  8041b1:	39 d3                	cmp    %edx,%ebx
  8041b3:	0f 82 87 00 00 00    	jb     804240 <__umoddi3+0x134>
  8041b9:	0f 84 91 00 00 00    	je     804250 <__umoddi3+0x144>
  8041bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041c3:	29 f2                	sub    %esi,%edx
  8041c5:	19 cb                	sbb    %ecx,%ebx
  8041c7:	89 d8                	mov    %ebx,%eax
  8041c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041cd:	d3 e0                	shl    %cl,%eax
  8041cf:	89 e9                	mov    %ebp,%ecx
  8041d1:	d3 ea                	shr    %cl,%edx
  8041d3:	09 d0                	or     %edx,%eax
  8041d5:	89 e9                	mov    %ebp,%ecx
  8041d7:	d3 eb                	shr    %cl,%ebx
  8041d9:	89 da                	mov    %ebx,%edx
  8041db:	83 c4 1c             	add    $0x1c,%esp
  8041de:	5b                   	pop    %ebx
  8041df:	5e                   	pop    %esi
  8041e0:	5f                   	pop    %edi
  8041e1:	5d                   	pop    %ebp
  8041e2:	c3                   	ret    
  8041e3:	90                   	nop
  8041e4:	89 fd                	mov    %edi,%ebp
  8041e6:	85 ff                	test   %edi,%edi
  8041e8:	75 0b                	jne    8041f5 <__umoddi3+0xe9>
  8041ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8041ef:	31 d2                	xor    %edx,%edx
  8041f1:	f7 f7                	div    %edi
  8041f3:	89 c5                	mov    %eax,%ebp
  8041f5:	89 f0                	mov    %esi,%eax
  8041f7:	31 d2                	xor    %edx,%edx
  8041f9:	f7 f5                	div    %ebp
  8041fb:	89 c8                	mov    %ecx,%eax
  8041fd:	f7 f5                	div    %ebp
  8041ff:	89 d0                	mov    %edx,%eax
  804201:	e9 44 ff ff ff       	jmp    80414a <__umoddi3+0x3e>
  804206:	66 90                	xchg   %ax,%ax
  804208:	89 c8                	mov    %ecx,%eax
  80420a:	89 f2                	mov    %esi,%edx
  80420c:	83 c4 1c             	add    $0x1c,%esp
  80420f:	5b                   	pop    %ebx
  804210:	5e                   	pop    %esi
  804211:	5f                   	pop    %edi
  804212:	5d                   	pop    %ebp
  804213:	c3                   	ret    
  804214:	3b 04 24             	cmp    (%esp),%eax
  804217:	72 06                	jb     80421f <__umoddi3+0x113>
  804219:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80421d:	77 0f                	ja     80422e <__umoddi3+0x122>
  80421f:	89 f2                	mov    %esi,%edx
  804221:	29 f9                	sub    %edi,%ecx
  804223:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804227:	89 14 24             	mov    %edx,(%esp)
  80422a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80422e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804232:	8b 14 24             	mov    (%esp),%edx
  804235:	83 c4 1c             	add    $0x1c,%esp
  804238:	5b                   	pop    %ebx
  804239:	5e                   	pop    %esi
  80423a:	5f                   	pop    %edi
  80423b:	5d                   	pop    %ebp
  80423c:	c3                   	ret    
  80423d:	8d 76 00             	lea    0x0(%esi),%esi
  804240:	2b 04 24             	sub    (%esp),%eax
  804243:	19 fa                	sbb    %edi,%edx
  804245:	89 d1                	mov    %edx,%ecx
  804247:	89 c6                	mov    %eax,%esi
  804249:	e9 71 ff ff ff       	jmp    8041bf <__umoddi3+0xb3>
  80424e:	66 90                	xchg   %ax,%ax
  804250:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804254:	72 ea                	jb     804240 <__umoddi3+0x134>
  804256:	89 d9                	mov    %ebx,%ecx
  804258:	e9 62 ff ff ff       	jmp    8041bf <__umoddi3+0xb3>
