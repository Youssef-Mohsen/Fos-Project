
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
  800041:	e8 e3 1f 00 00       	call   802029 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 43 80 00       	push   $0x804300
  80004e:	e8 a7 09 00 00       	call   8009fa <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 43 80 00       	push   $0x804302
  80005e:	e8 97 09 00 00       	call   8009fa <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 1b 43 80 00       	push   $0x80431b
  80006e:	e8 87 09 00 00       	call   8009fa <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 43 80 00       	push   $0x804302
  80007e:	e8 77 09 00 00       	call   8009fa <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 43 80 00       	push   $0x804300
  80008e:	e8 67 09 00 00       	call   8009fa <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 34 43 80 00       	push   $0x804334
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
  8000c9:	68 54 43 80 00       	push   $0x804354
  8000ce:	e8 27 09 00 00       	call   8009fa <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 76 43 80 00       	push   $0x804376
  8000de:	e8 17 09 00 00       	call   8009fa <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 84 43 80 00       	push   $0x804384
  8000ee:	e8 07 09 00 00       	call   8009fa <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 93 43 80 00       	push   $0x804393
  8000fe:	e8 f7 08 00 00       	call   8009fa <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 a3 43 80 00       	push   $0x8043a3
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
  80014d:	e8 f1 1e 00 00       	call   802043 <sys_unlock_cons>
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
  8001d5:	e8 4f 1e 00 00       	call   802029 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 ac 43 80 00       	push   $0x8043ac
  8001e2:	e8 13 08 00 00       	call   8009fa <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 54 1e 00 00       	call   802043 <sys_unlock_cons>
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
  80020c:	68 e0 43 80 00       	push   $0x8043e0
  800211:	6a 54                	push   $0x54
  800213:	68 02 44 80 00       	push   $0x804402
  800218:	e8 20 05 00 00       	call   80073d <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 07 1e 00 00       	call   802029 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 1c 44 80 00       	push   $0x80441c
  80022a:	e8 cb 07 00 00       	call   8009fa <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 50 44 80 00       	push   $0x804450
  80023a:	e8 bb 07 00 00       	call   8009fa <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 84 44 80 00       	push   $0x804484
  80024a:	e8 ab 07 00 00       	call   8009fa <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 ec 1d 00 00       	call   802043 <sys_unlock_cons>


		}

		//		sys_lock_cons();
		sys_lock_cons();
  800257:	e8 cd 1d 00 00       	call   802029 <sys_lock_cons>
		{
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 b6 44 80 00       	push   $0x8044b6
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
  8002b0:	e8 8e 1d 00 00       	call   802043 <sys_unlock_cons>
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
  800562:	68 00 43 80 00       	push   $0x804300
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
  800584:	68 d4 44 80 00       	push   $0x8044d4
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
  8005b2:	68 d9 44 80 00       	push   $0x8044d9
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
  8005d6:	e8 99 1b 00 00       	call   802174 <sys_cputc>
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
  8005e7:	e8 24 1a 00 00       	call   802010 <sys_cgetc>
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
  800604:	e8 9c 1c 00 00       	call   8022a5 <sys_getenvindex>
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
  800672:	e8 b2 19 00 00       	call   802029 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800677:	83 ec 0c             	sub    $0xc,%esp
  80067a:	68 f8 44 80 00       	push   $0x8044f8
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
  8006a2:	68 20 45 80 00       	push   $0x804520
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
  8006d3:	68 48 45 80 00       	push   $0x804548
  8006d8:	e8 1d 03 00 00       	call   8009fa <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006e0:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	50                   	push   %eax
  8006ef:	68 a0 45 80 00       	push   $0x8045a0
  8006f4:	e8 01 03 00 00       	call   8009fa <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	68 f8 44 80 00       	push   $0x8044f8
  800704:	e8 f1 02 00 00       	call   8009fa <cprintf>
  800709:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80070c:	e8 32 19 00 00       	call   802043 <sys_unlock_cons>
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
  800724:	e8 48 1b 00 00       	call   802271 <sys_destroy_env>
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
  800735:	e8 9d 1b 00 00       	call   8022d7 <sys_exit_env>
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
  80074c:	a1 54 50 80 00       	mov    0x805054,%eax
  800751:	85 c0                	test   %eax,%eax
  800753:	74 16                	je     80076b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800755:	a1 54 50 80 00       	mov    0x805054,%eax
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	50                   	push   %eax
  80075e:	68 b4 45 80 00       	push   $0x8045b4
  800763:	e8 92 02 00 00       	call   8009fa <cprintf>
  800768:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80076b:	a1 00 50 80 00       	mov    0x805000,%eax
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	ff 75 08             	pushl  0x8(%ebp)
  800776:	50                   	push   %eax
  800777:	68 b9 45 80 00       	push   $0x8045b9
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
  80079b:	68 d5 45 80 00       	push   $0x8045d5
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
  8007ca:	68 d8 45 80 00       	push   $0x8045d8
  8007cf:	6a 26                	push   $0x26
  8007d1:	68 24 46 80 00       	push   $0x804624
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
  80089f:	68 30 46 80 00       	push   $0x804630
  8008a4:	6a 3a                	push   $0x3a
  8008a6:	68 24 46 80 00       	push   $0x804624
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
  800912:	68 84 46 80 00       	push   $0x804684
  800917:	6a 44                	push   $0x44
  800919:	68 24 46 80 00       	push   $0x804624
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
  800951:	a0 30 50 80 00       	mov    0x805030,%al
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
  80096c:	e8 76 16 00 00       	call   801fe7 <sys_cputs>
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
  8009c6:	a0 30 50 80 00       	mov    0x805030,%al
  8009cb:	0f b6 c0             	movzbl %al,%eax
  8009ce:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009d4:	83 ec 04             	sub    $0x4,%esp
  8009d7:	50                   	push   %eax
  8009d8:	52                   	push   %edx
  8009d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009df:	83 c0 08             	add    $0x8,%eax
  8009e2:	50                   	push   %eax
  8009e3:	e8 ff 15 00 00       	call   801fe7 <sys_cputs>
  8009e8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009eb:	c6 05 30 50 80 00 00 	movb   $0x0,0x805030
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
  800a00:	c6 05 30 50 80 00 01 	movb   $0x1,0x805030
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
  800a2d:	e8 f7 15 00 00       	call   802029 <sys_lock_cons>
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
  800a4d:	e8 f1 15 00 00       	call   802043 <sys_unlock_cons>
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
  800a97:	e8 e4 35 00 00       	call   804080 <__udivdi3>
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
  800ae7:	e8 a4 36 00 00       	call   804190 <__umoddi3>
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	05 f4 48 80 00       	add    $0x8048f4,%eax
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
  800c42:	8b 04 85 18 49 80 00 	mov    0x804918(,%eax,4),%eax
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
  800d23:	8b 34 9d 60 47 80 00 	mov    0x804760(,%ebx,4),%esi
  800d2a:	85 f6                	test   %esi,%esi
  800d2c:	75 19                	jne    800d47 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d2e:	53                   	push   %ebx
  800d2f:	68 05 49 80 00       	push   $0x804905
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
  800d48:	68 0e 49 80 00       	push   $0x80490e
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
  800d75:	be 11 49 80 00       	mov    $0x804911,%esi
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
  800f6d:	c6 05 30 50 80 00 00 	movb   $0x0,0x805030
			break;
  800f74:	eb 2c                	jmp    800fa2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f76:	c6 05 30 50 80 00 01 	movb   $0x1,0x805030
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
  8010a0:	68 88 4a 80 00       	push   $0x804a88
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
  8010e2:	68 8b 4a 80 00       	push   $0x804a8b
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
  801193:	e8 91 0e 00 00       	call   802029 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801198:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80119c:	74 13                	je     8011b1 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	ff 75 08             	pushl  0x8(%ebp)
  8011a4:	68 88 4a 80 00       	push   $0x804a88
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
  8011e6:	68 8b 4a 80 00       	push   $0x804a8b
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
  80128e:	e8 b0 0d 00 00       	call   802043 <sys_unlock_cons>
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
  801988:	68 9c 4a 80 00       	push   $0x804a9c
  80198d:	68 3f 01 00 00       	push   $0x13f
  801992:	68 be 4a 80 00       	push   $0x804abe
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
  8019a8:	e8 e5 0b 00 00       	call   802592 <sys_sbrk>
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
  801a23:	e8 ee 09 00 00       	call   802416 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	74 16                	je     801a42 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a2c:	83 ec 0c             	sub    $0xc,%esp
  801a2f:	ff 75 08             	pushl  0x8(%ebp)
  801a32:	e8 2e 0f 00 00       	call   802965 <alloc_block_FF>
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a3d:	e9 8a 01 00 00       	jmp    801bcc <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801a42:	e8 00 0a 00 00       	call   802447 <sys_isUHeapPlacementStrategyBESTFIT>
  801a47:	85 c0                	test   %eax,%eax
  801a49:	0f 84 7d 01 00 00    	je     801bcc <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	e8 c7 13 00 00       	call   802e21 <alloc_block_BF>
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
		//cprintf("52\n");
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
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801a8e:	a1 24 50 80 00       	mov    0x805024,%eax
  801a93:	8b 40 78             	mov    0x78(%eax),%eax
  801a96:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a99:	29 c2                	sub    %eax,%edx
  801a9b:	89 d0                	mov    %edx,%eax
  801a9d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801aa2:	c1 e8 0c             	shr    $0xc,%eax
  801aa5:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  801aac:	85 c0                	test   %eax,%eax
  801aae:	0f 85 ab 00 00 00    	jne    801b5f <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab7:	05 00 10 00 00       	add    $0x1000,%eax
  801abc:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801abf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
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
  801af2:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
  801af9:	85 c0                	test   %eax,%eax
  801afb:	74 08                	je     801b05 <malloc+0x153>
					{
						//cprintf("71\n");
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
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
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
  801b49:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801b5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b63:	75 16                	jne    801b7b <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801b65:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801b6c:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801b73:	0f 86 15 ff ff ff    	jbe    801a8e <malloc+0xdc>
  801b79:	eb 01                	jmp    801b7c <malloc+0x1ca>
				}
				//cprintf("79\n");

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
  801bab:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801bb2:	83 ec 08             	sub    $0x8,%esp
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	ff 75 f0             	pushl  -0x10(%ebp)
  801bbb:	e8 09 0a 00 00       	call   8025c9 <sys_allocate_user_mem>
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	eb 07                	jmp    801bcc <malloc+0x21a>
		//cprintf("91\n");
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
  801c03:	e8 dd 09 00 00       	call   8025e5 <get_block_size>
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c0e:	83 ec 0c             	sub    $0xc,%esp
  801c11:	ff 75 08             	pushl  0x8(%ebp)
  801c14:	e8 10 1c 00 00       	call   803829 <free_block>
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
  801c4e:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
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
  801c8b:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801c92:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801c96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	83 ec 08             	sub    $0x8,%esp
  801c9f:	52                   	push   %edx
  801ca0:	50                   	push   %eax
  801ca1:	e8 07 09 00 00       	call   8025ad <sys_free_user_mem>
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
  801cb9:	68 cc 4a 80 00       	push   $0x804acc
  801cbe:	68 88 00 00 00       	push   $0x88
  801cc3:	68 f6 4a 80 00       	push   $0x804af6
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
  801ce7:	e9 ec 00 00 00       	jmp    801dd8 <smalloc+0x108>
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
  801d18:	75 0a                	jne    801d24 <smalloc+0x54>
  801d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1f:	e9 b4 00 00 00       	jmp    801dd8 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d24:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d28:	ff 75 ec             	pushl  -0x14(%ebp)
  801d2b:	50                   	push   %eax
  801d2c:	ff 75 0c             	pushl  0xc(%ebp)
  801d2f:	ff 75 08             	pushl  0x8(%ebp)
  801d32:	e8 7d 04 00 00       	call   8021b4 <sys_createSharedObject>
  801d37:	83 c4 10             	add    $0x10,%esp
  801d3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801d3d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801d41:	74 06                	je     801d49 <smalloc+0x79>
  801d43:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801d47:	75 0a                	jne    801d53 <smalloc+0x83>
  801d49:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4e:	e9 85 00 00 00       	jmp    801dd8 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801d53:	83 ec 08             	sub    $0x8,%esp
  801d56:	ff 75 ec             	pushl  -0x14(%ebp)
  801d59:	68 02 4b 80 00       	push   $0x804b02
  801d5e:	e8 97 ec ff ff       	call   8009fa <cprintf>
  801d63:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801d66:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d69:	a1 24 50 80 00       	mov    0x805024,%eax
  801d6e:	8b 40 78             	mov    0x78(%eax),%eax
  801d71:	29 c2                	sub    %eax,%edx
  801d73:	89 d0                	mov    %edx,%eax
  801d75:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d7a:	c1 e8 0c             	shr    $0xc,%eax
  801d7d:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801d83:	42                   	inc    %edx
  801d84:	89 15 28 50 80 00    	mov    %edx,0x805028
  801d8a:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801d90:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801d97:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d9a:	a1 24 50 80 00       	mov    0x805024,%eax
  801d9f:	8b 40 78             	mov    0x78(%eax),%eax
  801da2:	29 c2                	sub    %eax,%edx
  801da4:	89 d0                	mov    %edx,%eax
  801da6:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dab:	c1 e8 0c             	shr    $0xc,%eax
  801dae:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801db5:	a1 24 50 80 00       	mov    0x805024,%eax
  801dba:	8b 50 10             	mov    0x10(%eax),%edx
  801dbd:	89 c8                	mov    %ecx,%eax
  801dbf:	c1 e0 02             	shl    $0x2,%eax
  801dc2:	89 c1                	mov    %eax,%ecx
  801dc4:	c1 e1 09             	shl    $0x9,%ecx
  801dc7:	01 c8                	add    %ecx,%eax
  801dc9:	01 c2                	add    %eax,%edx
  801dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dce:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801de0:	83 ec 08             	sub    $0x8,%esp
  801de3:	ff 75 0c             	pushl  0xc(%ebp)
  801de6:	ff 75 08             	pushl  0x8(%ebp)
  801de9:	e8 f0 03 00 00       	call   8021de <sys_getSizeOfSharedObject>
  801dee:	83 c4 10             	add    $0x10,%esp
  801df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801df4:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801df8:	75 0a                	jne    801e04 <sget+0x2a>
  801dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801dff:	e9 e7 00 00 00       	jmp    801eeb <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e0a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e11:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e17:	39 d0                	cmp    %edx,%eax
  801e19:	73 02                	jae    801e1d <sget+0x43>
  801e1b:	89 d0                	mov    %edx,%eax
  801e1d:	83 ec 0c             	sub    $0xc,%esp
  801e20:	50                   	push   %eax
  801e21:	e8 8c fb ff ff       	call   8019b2 <malloc>
  801e26:	83 c4 10             	add    $0x10,%esp
  801e29:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801e2c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e30:	75 0a                	jne    801e3c <sget+0x62>
  801e32:	b8 00 00 00 00       	mov    $0x0,%eax
  801e37:	e9 af 00 00 00       	jmp    801eeb <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801e3c:	83 ec 04             	sub    $0x4,%esp
  801e3f:	ff 75 e8             	pushl  -0x18(%ebp)
  801e42:	ff 75 0c             	pushl  0xc(%ebp)
  801e45:	ff 75 08             	pushl  0x8(%ebp)
  801e48:	e8 ae 03 00 00       	call   8021fb <sys_getSharedObject>
  801e4d:	83 c4 10             	add    $0x10,%esp
  801e50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801e53:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e56:	a1 24 50 80 00       	mov    0x805024,%eax
  801e5b:	8b 40 78             	mov    0x78(%eax),%eax
  801e5e:	29 c2                	sub    %eax,%edx
  801e60:	89 d0                	mov    %edx,%eax
  801e62:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e67:	c1 e8 0c             	shr    $0xc,%eax
  801e6a:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801e70:	42                   	inc    %edx
  801e71:	89 15 28 50 80 00    	mov    %edx,0x805028
  801e77:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801e7d:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801e84:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e87:	a1 24 50 80 00       	mov    0x805024,%eax
  801e8c:	8b 40 78             	mov    0x78(%eax),%eax
  801e8f:	29 c2                	sub    %eax,%edx
  801e91:	89 d0                	mov    %edx,%eax
  801e93:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e98:	c1 e8 0c             	shr    $0xc,%eax
  801e9b:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801ea2:	a1 24 50 80 00       	mov    0x805024,%eax
  801ea7:	8b 50 10             	mov    0x10(%eax),%edx
  801eaa:	89 c8                	mov    %ecx,%eax
  801eac:	c1 e0 02             	shl    $0x2,%eax
  801eaf:	89 c1                	mov    %eax,%ecx
  801eb1:	c1 e1 09             	shl    $0x9,%ecx
  801eb4:	01 c8                	add    %ecx,%eax
  801eb6:	01 c2                	add    %eax,%edx
  801eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ebb:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801ec2:	a1 24 50 80 00       	mov    0x805024,%eax
  801ec7:	8b 40 10             	mov    0x10(%eax),%eax
  801eca:	83 ec 08             	sub    $0x8,%esp
  801ecd:	50                   	push   %eax
  801ece:	68 11 4b 80 00       	push   $0x804b11
  801ed3:	e8 22 eb ff ff       	call   8009fa <cprintf>
  801ed8:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801edb:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801edf:	75 07                	jne    801ee8 <sget+0x10e>
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee6:	eb 03                	jmp    801eeb <sget+0x111>
	return ptr;
  801ee8:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
  801ef0:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  801ef6:	a1 24 50 80 00       	mov    0x805024,%eax
  801efb:	8b 40 78             	mov    0x78(%eax),%eax
  801efe:	29 c2                	sub    %eax,%edx
  801f00:	89 d0                	mov    %edx,%eax
  801f02:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f07:	c1 e8 0c             	shr    $0xc,%eax
  801f0a:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801f11:	a1 24 50 80 00       	mov    0x805024,%eax
  801f16:	8b 50 10             	mov    0x10(%eax),%edx
  801f19:	89 c8                	mov    %ecx,%eax
  801f1b:	c1 e0 02             	shl    $0x2,%eax
  801f1e:	89 c1                	mov    %eax,%ecx
  801f20:	c1 e1 09             	shl    $0x9,%ecx
  801f23:	01 c8                	add    %ecx,%eax
  801f25:	01 d0                	add    %edx,%eax
  801f27:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801f31:	83 ec 08             	sub    $0x8,%esp
  801f34:	ff 75 08             	pushl  0x8(%ebp)
  801f37:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3a:	e8 db 02 00 00       	call   80221a <sys_freeSharedObject>
  801f3f:	83 c4 10             	add    $0x10,%esp
  801f42:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801f45:	90                   	nop
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f4e:	83 ec 04             	sub    $0x4,%esp
  801f51:	68 20 4b 80 00       	push   $0x804b20
  801f56:	68 e5 00 00 00       	push   $0xe5
  801f5b:	68 f6 4a 80 00       	push   $0x804af6
  801f60:	e8 d8 e7 ff ff       	call   80073d <_panic>

00801f65 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f6b:	83 ec 04             	sub    $0x4,%esp
  801f6e:	68 46 4b 80 00       	push   $0x804b46
  801f73:	68 f1 00 00 00       	push   $0xf1
  801f78:	68 f6 4a 80 00       	push   $0x804af6
  801f7d:	e8 bb e7 ff ff       	call   80073d <_panic>

00801f82 <shrink>:

}
void shrink(uint32 newSize)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f88:	83 ec 04             	sub    $0x4,%esp
  801f8b:	68 46 4b 80 00       	push   $0x804b46
  801f90:	68 f6 00 00 00       	push   $0xf6
  801f95:	68 f6 4a 80 00       	push   $0x804af6
  801f9a:	e8 9e e7 ff ff       	call   80073d <_panic>

00801f9f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fa5:	83 ec 04             	sub    $0x4,%esp
  801fa8:	68 46 4b 80 00       	push   $0x804b46
  801fad:	68 fb 00 00 00       	push   $0xfb
  801fb2:	68 f6 4a 80 00       	push   $0x804af6
  801fb7:	e8 81 e7 ff ff       	call   80073d <_panic>

00801fbc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	57                   	push   %edi
  801fc0:	56                   	push   %esi
  801fc1:	53                   	push   %ebx
  801fc2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fd1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fd4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fd7:	cd 30                	int    $0x30
  801fd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fdf:	83 c4 10             	add    $0x10,%esp
  801fe2:	5b                   	pop    %ebx
  801fe3:	5e                   	pop    %esi
  801fe4:	5f                   	pop    %edi
  801fe5:	5d                   	pop    %ebp
  801fe6:	c3                   	ret    

00801fe7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	83 ec 04             	sub    $0x4,%esp
  801fed:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ff3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	52                   	push   %edx
  801fff:	ff 75 0c             	pushl  0xc(%ebp)
  802002:	50                   	push   %eax
  802003:	6a 00                	push   $0x0
  802005:	e8 b2 ff ff ff       	call   801fbc <syscall>
  80200a:	83 c4 18             	add    $0x18,%esp
}
  80200d:	90                   	nop
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_cgetc>:

int
sys_cgetc(void)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 02                	push   $0x2
  80201f:	e8 98 ff ff ff       	call   801fbc <syscall>
  802024:	83 c4 18             	add    $0x18,%esp
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 03                	push   $0x3
  802038:	e8 7f ff ff ff       	call   801fbc <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
}
  802040:	90                   	nop
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 04                	push   $0x4
  802052:	e8 65 ff ff ff       	call   801fbc <syscall>
  802057:	83 c4 18             	add    $0x18,%esp
}
  80205a:	90                   	nop
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802060:	8b 55 0c             	mov    0xc(%ebp),%edx
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	52                   	push   %edx
  80206d:	50                   	push   %eax
  80206e:	6a 08                	push   $0x8
  802070:	e8 47 ff ff ff       	call   801fbc <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
}
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	56                   	push   %esi
  80207e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80207f:	8b 75 18             	mov    0x18(%ebp),%esi
  802082:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802085:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802088:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	56                   	push   %esi
  80208f:	53                   	push   %ebx
  802090:	51                   	push   %ecx
  802091:	52                   	push   %edx
  802092:	50                   	push   %eax
  802093:	6a 09                	push   $0x9
  802095:	e8 22 ff ff ff       	call   801fbc <syscall>
  80209a:	83 c4 18             	add    $0x18,%esp
}
  80209d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a0:	5b                   	pop    %ebx
  8020a1:	5e                   	pop    %esi
  8020a2:	5d                   	pop    %ebp
  8020a3:	c3                   	ret    

008020a4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	52                   	push   %edx
  8020b4:	50                   	push   %eax
  8020b5:	6a 0a                	push   $0xa
  8020b7:	e8 00 ff ff ff       	call   801fbc <syscall>
  8020bc:	83 c4 18             	add    $0x18,%esp
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	ff 75 0c             	pushl  0xc(%ebp)
  8020cd:	ff 75 08             	pushl  0x8(%ebp)
  8020d0:	6a 0b                	push   $0xb
  8020d2:	e8 e5 fe ff ff       	call   801fbc <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 0c                	push   $0xc
  8020eb:	e8 cc fe ff ff       	call   801fbc <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 0d                	push   $0xd
  802104:	e8 b3 fe ff ff       	call   801fbc <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 0e                	push   $0xe
  80211d:	e8 9a fe ff ff       	call   801fbc <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 0f                	push   $0xf
  802136:	e8 81 fe ff ff       	call   801fbc <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	ff 75 08             	pushl  0x8(%ebp)
  80214e:	6a 10                	push   $0x10
  802150:	e8 67 fe ff ff       	call   801fbc <syscall>
  802155:	83 c4 18             	add    $0x18,%esp
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 11                	push   $0x11
  802169:	e8 4e fe ff ff       	call   801fbc <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
}
  802171:	90                   	nop
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_cputc>:

void
sys_cputc(const char c)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	83 ec 04             	sub    $0x4,%esp
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802180:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	50                   	push   %eax
  80218d:	6a 01                	push   $0x1
  80218f:	e8 28 fe ff ff       	call   801fbc <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
}
  802197:	90                   	nop
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 14                	push   $0x14
  8021a9:	e8 0e fe ff ff       	call   801fbc <syscall>
  8021ae:	83 c4 18             	add    $0x18,%esp
}
  8021b1:	90                   	nop
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	83 ec 04             	sub    $0x4,%esp
  8021ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8021bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021c0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021c3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	6a 00                	push   $0x0
  8021cc:	51                   	push   %ecx
  8021cd:	52                   	push   %edx
  8021ce:	ff 75 0c             	pushl  0xc(%ebp)
  8021d1:	50                   	push   %eax
  8021d2:	6a 15                	push   $0x15
  8021d4:	e8 e3 fd ff ff       	call   801fbc <syscall>
  8021d9:	83 c4 18             	add    $0x18,%esp
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	52                   	push   %edx
  8021ee:	50                   	push   %eax
  8021ef:	6a 16                	push   $0x16
  8021f1:	e8 c6 fd ff ff       	call   801fbc <syscall>
  8021f6:	83 c4 18             	add    $0x18,%esp
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802201:	8b 55 0c             	mov    0xc(%ebp),%edx
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	51                   	push   %ecx
  80220c:	52                   	push   %edx
  80220d:	50                   	push   %eax
  80220e:	6a 17                	push   $0x17
  802210:	e8 a7 fd ff ff       	call   801fbc <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80221d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	52                   	push   %edx
  80222a:	50                   	push   %eax
  80222b:	6a 18                	push   $0x18
  80222d:	e8 8a fd ff ff       	call   801fbc <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	6a 00                	push   $0x0
  80223f:	ff 75 14             	pushl  0x14(%ebp)
  802242:	ff 75 10             	pushl  0x10(%ebp)
  802245:	ff 75 0c             	pushl  0xc(%ebp)
  802248:	50                   	push   %eax
  802249:	6a 19                	push   $0x19
  80224b:	e8 6c fd ff ff       	call   801fbc <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	50                   	push   %eax
  802264:	6a 1a                	push   $0x1a
  802266:	e8 51 fd ff ff       	call   801fbc <syscall>
  80226b:	83 c4 18             	add    $0x18,%esp
}
  80226e:	90                   	nop
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	50                   	push   %eax
  802280:	6a 1b                	push   $0x1b
  802282:	e8 35 fd ff ff       	call   801fbc <syscall>
  802287:	83 c4 18             	add    $0x18,%esp
}
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 05                	push   $0x5
  80229b:	e8 1c fd ff ff       	call   801fbc <syscall>
  8022a0:	83 c4 18             	add    $0x18,%esp
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 06                	push   $0x6
  8022b4:	e8 03 fd ff ff       	call   801fbc <syscall>
  8022b9:	83 c4 18             	add    $0x18,%esp
}
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 07                	push   $0x7
  8022cd:	e8 ea fc ff ff       	call   801fbc <syscall>
  8022d2:	83 c4 18             	add    $0x18,%esp
}
  8022d5:	c9                   	leave  
  8022d6:	c3                   	ret    

008022d7 <sys_exit_env>:


void sys_exit_env(void)
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 1c                	push   $0x1c
  8022e6:	e8 d1 fc ff ff       	call   801fbc <syscall>
  8022eb:	83 c4 18             	add    $0x18,%esp
}
  8022ee:	90                   	nop
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    

008022f1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022f7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022fa:	8d 50 04             	lea    0x4(%eax),%edx
  8022fd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	52                   	push   %edx
  802307:	50                   	push   %eax
  802308:	6a 1d                	push   $0x1d
  80230a:	e8 ad fc ff ff       	call   801fbc <syscall>
  80230f:	83 c4 18             	add    $0x18,%esp
	return result;
  802312:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802315:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802318:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80231b:	89 01                	mov    %eax,(%ecx)
  80231d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	c9                   	leave  
  802324:	c2 04 00             	ret    $0x4

00802327 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	ff 75 10             	pushl  0x10(%ebp)
  802331:	ff 75 0c             	pushl  0xc(%ebp)
  802334:	ff 75 08             	pushl  0x8(%ebp)
  802337:	6a 13                	push   $0x13
  802339:	e8 7e fc ff ff       	call   801fbc <syscall>
  80233e:	83 c4 18             	add    $0x18,%esp
	return ;
  802341:	90                   	nop
}
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <sys_rcr2>:
uint32 sys_rcr2()
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 1e                	push   $0x1e
  802353:	e8 64 fc ff ff       	call   801fbc <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	83 ec 04             	sub    $0x4,%esp
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802369:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	50                   	push   %eax
  802376:	6a 1f                	push   $0x1f
  802378:	e8 3f fc ff ff       	call   801fbc <syscall>
  80237d:	83 c4 18             	add    $0x18,%esp
	return ;
  802380:	90                   	nop
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <rsttst>:
void rsttst()
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	6a 21                	push   $0x21
  802392:	e8 25 fc ff ff       	call   801fbc <syscall>
  802397:	83 c4 18             	add    $0x18,%esp
	return ;
  80239a:	90                   	nop
}
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

0080239d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
  8023a0:	83 ec 04             	sub    $0x4,%esp
  8023a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023a9:	8b 55 18             	mov    0x18(%ebp),%edx
  8023ac:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023b0:	52                   	push   %edx
  8023b1:	50                   	push   %eax
  8023b2:	ff 75 10             	pushl  0x10(%ebp)
  8023b5:	ff 75 0c             	pushl  0xc(%ebp)
  8023b8:	ff 75 08             	pushl  0x8(%ebp)
  8023bb:	6a 20                	push   $0x20
  8023bd:	e8 fa fb ff ff       	call   801fbc <syscall>
  8023c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c5:	90                   	nop
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <chktst>:
void chktst(uint32 n)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	ff 75 08             	pushl  0x8(%ebp)
  8023d6:	6a 22                	push   $0x22
  8023d8:	e8 df fb ff ff       	call   801fbc <syscall>
  8023dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e0:	90                   	nop
}
  8023e1:	c9                   	leave  
  8023e2:	c3                   	ret    

008023e3 <inctst>:

void inctst()
{
  8023e3:	55                   	push   %ebp
  8023e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 23                	push   $0x23
  8023f2:	e8 c5 fb ff ff       	call   801fbc <syscall>
  8023f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8023fa:	90                   	nop
}
  8023fb:	c9                   	leave  
  8023fc:	c3                   	ret    

008023fd <gettst>:
uint32 gettst()
{
  8023fd:	55                   	push   %ebp
  8023fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 24                	push   $0x24
  80240c:	e8 ab fb ff ff       	call   801fbc <syscall>
  802411:	83 c4 18             	add    $0x18,%esp
}
  802414:	c9                   	leave  
  802415:	c3                   	ret    

00802416 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
  802419:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 25                	push   $0x25
  802428:	e8 8f fb ff ff       	call   801fbc <syscall>
  80242d:	83 c4 18             	add    $0x18,%esp
  802430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802433:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802437:	75 07                	jne    802440 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802439:	b8 01 00 00 00       	mov    $0x1,%eax
  80243e:	eb 05                	jmp    802445 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802440:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 25                	push   $0x25
  802459:	e8 5e fb ff ff       	call   801fbc <syscall>
  80245e:	83 c4 18             	add    $0x18,%esp
  802461:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802464:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802468:	75 07                	jne    802471 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80246a:	b8 01 00 00 00       	mov    $0x1,%eax
  80246f:	eb 05                	jmp    802476 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
  80247b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 25                	push   $0x25
  80248a:	e8 2d fb ff ff       	call   801fbc <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
  802492:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802495:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802499:	75 07                	jne    8024a2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80249b:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a0:	eb 05                	jmp    8024a7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a7:	c9                   	leave  
  8024a8:	c3                   	ret    

008024a9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024a9:	55                   	push   %ebp
  8024aa:	89 e5                	mov    %esp,%ebp
  8024ac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 25                	push   $0x25
  8024bb:	e8 fc fa ff ff       	call   801fbc <syscall>
  8024c0:	83 c4 18             	add    $0x18,%esp
  8024c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024c6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024ca:	75 07                	jne    8024d3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d1:	eb 05                	jmp    8024d8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	ff 75 08             	pushl  0x8(%ebp)
  8024e8:	6a 26                	push   $0x26
  8024ea:	e8 cd fa ff ff       	call   801fbc <syscall>
  8024ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f2:	90                   	nop
}
  8024f3:	c9                   	leave  
  8024f4:	c3                   	ret    

008024f5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
  8024f8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	6a 00                	push   $0x0
  802507:	53                   	push   %ebx
  802508:	51                   	push   %ecx
  802509:	52                   	push   %edx
  80250a:	50                   	push   %eax
  80250b:	6a 27                	push   $0x27
  80250d:	e8 aa fa ff ff       	call   801fbc <syscall>
  802512:	83 c4 18             	add    $0x18,%esp
}
  802515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802518:	c9                   	leave  
  802519:	c3                   	ret    

0080251a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80251d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802520:	8b 45 08             	mov    0x8(%ebp),%eax
  802523:	6a 00                	push   $0x0
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	52                   	push   %edx
  80252a:	50                   	push   %eax
  80252b:	6a 28                	push   $0x28
  80252d:	e8 8a fa ff ff       	call   801fbc <syscall>
  802532:	83 c4 18             	add    $0x18,%esp
}
  802535:	c9                   	leave  
  802536:	c3                   	ret    

00802537 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802537:	55                   	push   %ebp
  802538:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80253a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80253d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	6a 00                	push   $0x0
  802545:	51                   	push   %ecx
  802546:	ff 75 10             	pushl  0x10(%ebp)
  802549:	52                   	push   %edx
  80254a:	50                   	push   %eax
  80254b:	6a 29                	push   $0x29
  80254d:	e8 6a fa ff ff       	call   801fbc <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
}
  802555:	c9                   	leave  
  802556:	c3                   	ret    

00802557 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	ff 75 10             	pushl  0x10(%ebp)
  802561:	ff 75 0c             	pushl  0xc(%ebp)
  802564:	ff 75 08             	pushl  0x8(%ebp)
  802567:	6a 12                	push   $0x12
  802569:	e8 4e fa ff ff       	call   801fbc <syscall>
  80256e:	83 c4 18             	add    $0x18,%esp
	return ;
  802571:	90                   	nop
}
  802572:	c9                   	leave  
  802573:	c3                   	ret    

00802574 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802577:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	52                   	push   %edx
  802584:	50                   	push   %eax
  802585:	6a 2a                	push   $0x2a
  802587:	e8 30 fa ff ff       	call   801fbc <syscall>
  80258c:	83 c4 18             	add    $0x18,%esp
	return;
  80258f:	90                   	nop
}
  802590:	c9                   	leave  
  802591:	c3                   	ret    

00802592 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	50                   	push   %eax
  8025a1:	6a 2b                	push   $0x2b
  8025a3:	e8 14 fa ff ff       	call   801fbc <syscall>
  8025a8:	83 c4 18             	add    $0x18,%esp
}
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	ff 75 0c             	pushl  0xc(%ebp)
  8025b9:	ff 75 08             	pushl  0x8(%ebp)
  8025bc:	6a 2c                	push   $0x2c
  8025be:	e8 f9 f9 ff ff       	call   801fbc <syscall>
  8025c3:	83 c4 18             	add    $0x18,%esp
	return;
  8025c6:	90                   	nop
}
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	ff 75 0c             	pushl  0xc(%ebp)
  8025d5:	ff 75 08             	pushl  0x8(%ebp)
  8025d8:	6a 2d                	push   $0x2d
  8025da:	e8 dd f9 ff ff       	call   801fbc <syscall>
  8025df:	83 c4 18             	add    $0x18,%esp
	return;
  8025e2:	90                   	nop
}
  8025e3:	c9                   	leave  
  8025e4:	c3                   	ret    

008025e5 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8025e5:	55                   	push   %ebp
  8025e6:	89 e5                	mov    %esp,%ebp
  8025e8:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	83 e8 04             	sub    $0x4,%eax
  8025f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8025f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025f7:	8b 00                	mov    (%eax),%eax
  8025f9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802604:	8b 45 08             	mov    0x8(%ebp),%eax
  802607:	83 e8 04             	sub    $0x4,%eax
  80260a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80260d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	83 e0 01             	and    $0x1,%eax
  802615:	85 c0                	test   %eax,%eax
  802617:	0f 94 c0             	sete   %al
}
  80261a:	c9                   	leave  
  80261b:	c3                   	ret    

0080261c <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
  80261f:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802622:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262c:	83 f8 02             	cmp    $0x2,%eax
  80262f:	74 2b                	je     80265c <alloc_block+0x40>
  802631:	83 f8 02             	cmp    $0x2,%eax
  802634:	7f 07                	jg     80263d <alloc_block+0x21>
  802636:	83 f8 01             	cmp    $0x1,%eax
  802639:	74 0e                	je     802649 <alloc_block+0x2d>
  80263b:	eb 58                	jmp    802695 <alloc_block+0x79>
  80263d:	83 f8 03             	cmp    $0x3,%eax
  802640:	74 2d                	je     80266f <alloc_block+0x53>
  802642:	83 f8 04             	cmp    $0x4,%eax
  802645:	74 3b                	je     802682 <alloc_block+0x66>
  802647:	eb 4c                	jmp    802695 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802649:	83 ec 0c             	sub    $0xc,%esp
  80264c:	ff 75 08             	pushl  0x8(%ebp)
  80264f:	e8 11 03 00 00       	call   802965 <alloc_block_FF>
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80265a:	eb 4a                	jmp    8026a6 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80265c:	83 ec 0c             	sub    $0xc,%esp
  80265f:	ff 75 08             	pushl  0x8(%ebp)
  802662:	e8 fa 19 00 00       	call   804061 <alloc_block_NF>
  802667:	83 c4 10             	add    $0x10,%esp
  80266a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80266d:	eb 37                	jmp    8026a6 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80266f:	83 ec 0c             	sub    $0xc,%esp
  802672:	ff 75 08             	pushl  0x8(%ebp)
  802675:	e8 a7 07 00 00       	call   802e21 <alloc_block_BF>
  80267a:	83 c4 10             	add    $0x10,%esp
  80267d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802680:	eb 24                	jmp    8026a6 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802682:	83 ec 0c             	sub    $0xc,%esp
  802685:	ff 75 08             	pushl  0x8(%ebp)
  802688:	e8 b7 19 00 00       	call   804044 <alloc_block_WF>
  80268d:	83 c4 10             	add    $0x10,%esp
  802690:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802693:	eb 11                	jmp    8026a6 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802695:	83 ec 0c             	sub    $0xc,%esp
  802698:	68 58 4b 80 00       	push   $0x804b58
  80269d:	e8 58 e3 ff ff       	call   8009fa <cprintf>
  8026a2:	83 c4 10             	add    $0x10,%esp
		break;
  8026a5:	90                   	nop
	}
	return va;
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8026a9:	c9                   	leave  
  8026aa:	c3                   	ret    

008026ab <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8026ab:	55                   	push   %ebp
  8026ac:	89 e5                	mov    %esp,%ebp
  8026ae:	53                   	push   %ebx
  8026af:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8026b2:	83 ec 0c             	sub    $0xc,%esp
  8026b5:	68 78 4b 80 00       	push   $0x804b78
  8026ba:	e8 3b e3 ff ff       	call   8009fa <cprintf>
  8026bf:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8026c2:	83 ec 0c             	sub    $0xc,%esp
  8026c5:	68 a3 4b 80 00       	push   $0x804ba3
  8026ca:	e8 2b e3 ff ff       	call   8009fa <cprintf>
  8026cf:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8026d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d8:	eb 37                	jmp    802711 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8026da:	83 ec 0c             	sub    $0xc,%esp
  8026dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8026e0:	e8 19 ff ff ff       	call   8025fe <is_free_block>
  8026e5:	83 c4 10             	add    $0x10,%esp
  8026e8:	0f be d8             	movsbl %al,%ebx
  8026eb:	83 ec 0c             	sub    $0xc,%esp
  8026ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8026f1:	e8 ef fe ff ff       	call   8025e5 <get_block_size>
  8026f6:	83 c4 10             	add    $0x10,%esp
  8026f9:	83 ec 04             	sub    $0x4,%esp
  8026fc:	53                   	push   %ebx
  8026fd:	50                   	push   %eax
  8026fe:	68 bb 4b 80 00       	push   $0x804bbb
  802703:	e8 f2 e2 ff ff       	call   8009fa <cprintf>
  802708:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80270b:	8b 45 10             	mov    0x10(%ebp),%eax
  80270e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802711:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802715:	74 07                	je     80271e <print_blocks_list+0x73>
  802717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271a:	8b 00                	mov    (%eax),%eax
  80271c:	eb 05                	jmp    802723 <print_blocks_list+0x78>
  80271e:	b8 00 00 00 00       	mov    $0x0,%eax
  802723:	89 45 10             	mov    %eax,0x10(%ebp)
  802726:	8b 45 10             	mov    0x10(%ebp),%eax
  802729:	85 c0                	test   %eax,%eax
  80272b:	75 ad                	jne    8026da <print_blocks_list+0x2f>
  80272d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802731:	75 a7                	jne    8026da <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802733:	83 ec 0c             	sub    $0xc,%esp
  802736:	68 78 4b 80 00       	push   $0x804b78
  80273b:	e8 ba e2 ff ff       	call   8009fa <cprintf>
  802740:	83 c4 10             	add    $0x10,%esp

}
  802743:	90                   	nop
  802744:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
  80274c:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80274f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802752:	83 e0 01             	and    $0x1,%eax
  802755:	85 c0                	test   %eax,%eax
  802757:	74 03                	je     80275c <initialize_dynamic_allocator+0x13>
  802759:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80275c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802760:	0f 84 c7 01 00 00    	je     80292d <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802766:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  80276d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802770:	8b 55 08             	mov    0x8(%ebp),%edx
  802773:	8b 45 0c             	mov    0xc(%ebp),%eax
  802776:	01 d0                	add    %edx,%eax
  802778:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80277d:	0f 87 ad 01 00 00    	ja     802930 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	85 c0                	test   %eax,%eax
  802788:	0f 89 a5 01 00 00    	jns    802933 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80278e:	8b 55 08             	mov    0x8(%ebp),%edx
  802791:	8b 45 0c             	mov    0xc(%ebp),%eax
  802794:	01 d0                	add    %edx,%eax
  802796:	83 e8 04             	sub    $0x4,%eax
  802799:	a3 4c 50 80 00       	mov    %eax,0x80504c
     struct BlockElement * element = NULL;
  80279e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8027a5:	a1 34 50 80 00       	mov    0x805034,%eax
  8027aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ad:	e9 87 00 00 00       	jmp    802839 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8027b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b6:	75 14                	jne    8027cc <initialize_dynamic_allocator+0x83>
  8027b8:	83 ec 04             	sub    $0x4,%esp
  8027bb:	68 d3 4b 80 00       	push   $0x804bd3
  8027c0:	6a 79                	push   $0x79
  8027c2:	68 f1 4b 80 00       	push   $0x804bf1
  8027c7:	e8 71 df ff ff       	call   80073d <_panic>
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	8b 00                	mov    (%eax),%eax
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	74 10                	je     8027e5 <initialize_dynamic_allocator+0x9c>
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 00                	mov    (%eax),%eax
  8027da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027dd:	8b 52 04             	mov    0x4(%edx),%edx
  8027e0:	89 50 04             	mov    %edx,0x4(%eax)
  8027e3:	eb 0b                	jmp    8027f0 <initialize_dynamic_allocator+0xa7>
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 40 04             	mov    0x4(%eax),%eax
  8027eb:	a3 38 50 80 00       	mov    %eax,0x805038
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 40 04             	mov    0x4(%eax),%eax
  8027f6:	85 c0                	test   %eax,%eax
  8027f8:	74 0f                	je     802809 <initialize_dynamic_allocator+0xc0>
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	8b 40 04             	mov    0x4(%eax),%eax
  802800:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802803:	8b 12                	mov    (%edx),%edx
  802805:	89 10                	mov    %edx,(%eax)
  802807:	eb 0a                	jmp    802813 <initialize_dynamic_allocator+0xca>
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	8b 00                	mov    (%eax),%eax
  80280e:	a3 34 50 80 00       	mov    %eax,0x805034
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802826:	a1 40 50 80 00       	mov    0x805040,%eax
  80282b:	48                   	dec    %eax
  80282c:	a3 40 50 80 00       	mov    %eax,0x805040
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802831:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802836:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802839:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283d:	74 07                	je     802846 <initialize_dynamic_allocator+0xfd>
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	eb 05                	jmp    80284b <initialize_dynamic_allocator+0x102>
  802846:	b8 00 00 00 00       	mov    $0x0,%eax
  80284b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802850:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802855:	85 c0                	test   %eax,%eax
  802857:	0f 85 55 ff ff ff    	jne    8027b2 <initialize_dynamic_allocator+0x69>
  80285d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802861:	0f 85 4b ff ff ff    	jne    8027b2 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80286d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802870:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802876:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80287b:	a3 48 50 80 00       	mov    %eax,0x805048
    end_block->info = 1;
  802880:	a1 48 50 80 00       	mov    0x805048,%eax
  802885:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	83 c0 08             	add    $0x8,%eax
  802891:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802894:	8b 45 08             	mov    0x8(%ebp),%eax
  802897:	83 c0 04             	add    $0x4,%eax
  80289a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80289d:	83 ea 08             	sub    $0x8,%edx
  8028a0:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8028a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a8:	01 d0                	add    %edx,%eax
  8028aa:	83 e8 08             	sub    $0x8,%eax
  8028ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b0:	83 ea 08             	sub    $0x8,%edx
  8028b3:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8028b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8028be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8028c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028cc:	75 17                	jne    8028e5 <initialize_dynamic_allocator+0x19c>
  8028ce:	83 ec 04             	sub    $0x4,%esp
  8028d1:	68 0c 4c 80 00       	push   $0x804c0c
  8028d6:	68 90 00 00 00       	push   $0x90
  8028db:	68 f1 4b 80 00       	push   $0x804bf1
  8028e0:	e8 58 de ff ff       	call   80073d <_panic>
  8028e5:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8028eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ee:	89 10                	mov    %edx,(%eax)
  8028f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 0d                	je     802906 <initialize_dynamic_allocator+0x1bd>
  8028f9:	a1 34 50 80 00       	mov    0x805034,%eax
  8028fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802901:	89 50 04             	mov    %edx,0x4(%eax)
  802904:	eb 08                	jmp    80290e <initialize_dynamic_allocator+0x1c5>
  802906:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802909:	a3 38 50 80 00       	mov    %eax,0x805038
  80290e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802911:	a3 34 50 80 00       	mov    %eax,0x805034
  802916:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802919:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802920:	a1 40 50 80 00       	mov    0x805040,%eax
  802925:	40                   	inc    %eax
  802926:	a3 40 50 80 00       	mov    %eax,0x805040
  80292b:	eb 07                	jmp    802934 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80292d:	90                   	nop
  80292e:	eb 04                	jmp    802934 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802930:	90                   	nop
  802931:	eb 01                	jmp    802934 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802933:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802934:	c9                   	leave  
  802935:	c3                   	ret    

00802936 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802936:	55                   	push   %ebp
  802937:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802939:	8b 45 10             	mov    0x10(%ebp),%eax
  80293c:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80293f:	8b 45 08             	mov    0x8(%ebp),%eax
  802942:	8d 50 fc             	lea    -0x4(%eax),%edx
  802945:	8b 45 0c             	mov    0xc(%ebp),%eax
  802948:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80294a:	8b 45 08             	mov    0x8(%ebp),%eax
  80294d:	83 e8 04             	sub    $0x4,%eax
  802950:	8b 00                	mov    (%eax),%eax
  802952:	83 e0 fe             	and    $0xfffffffe,%eax
  802955:	8d 50 f8             	lea    -0x8(%eax),%edx
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	01 c2                	add    %eax,%edx
  80295d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802960:	89 02                	mov    %eax,(%edx)
}
  802962:	90                   	nop
  802963:	5d                   	pop    %ebp
  802964:	c3                   	ret    

00802965 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802965:	55                   	push   %ebp
  802966:	89 e5                	mov    %esp,%ebp
  802968:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80296b:	8b 45 08             	mov    0x8(%ebp),%eax
  80296e:	83 e0 01             	and    $0x1,%eax
  802971:	85 c0                	test   %eax,%eax
  802973:	74 03                	je     802978 <alloc_block_FF+0x13>
  802975:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802978:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80297c:	77 07                	ja     802985 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80297e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802985:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80298a:	85 c0                	test   %eax,%eax
  80298c:	75 73                	jne    802a01 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80298e:	8b 45 08             	mov    0x8(%ebp),%eax
  802991:	83 c0 10             	add    $0x10,%eax
  802994:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802997:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80299e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a4:	01 d0                	add    %edx,%eax
  8029a6:	48                   	dec    %eax
  8029a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8029aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b2:	f7 75 ec             	divl   -0x14(%ebp)
  8029b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b8:	29 d0                	sub    %edx,%eax
  8029ba:	c1 e8 0c             	shr    $0xc,%eax
  8029bd:	83 ec 0c             	sub    $0xc,%esp
  8029c0:	50                   	push   %eax
  8029c1:	e8 d6 ef ff ff       	call   80199c <sbrk>
  8029c6:	83 c4 10             	add    $0x10,%esp
  8029c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8029cc:	83 ec 0c             	sub    $0xc,%esp
  8029cf:	6a 00                	push   $0x0
  8029d1:	e8 c6 ef ff ff       	call   80199c <sbrk>
  8029d6:	83 c4 10             	add    $0x10,%esp
  8029d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029df:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8029e2:	83 ec 08             	sub    $0x8,%esp
  8029e5:	50                   	push   %eax
  8029e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029e9:	e8 5b fd ff ff       	call   802749 <initialize_dynamic_allocator>
  8029ee:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8029f1:	83 ec 0c             	sub    $0xc,%esp
  8029f4:	68 2f 4c 80 00       	push   $0x804c2f
  8029f9:	e8 fc df ff ff       	call   8009fa <cprintf>
  8029fe:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802a01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a05:	75 0a                	jne    802a11 <alloc_block_FF+0xac>
	        return NULL;
  802a07:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0c:	e9 0e 04 00 00       	jmp    802e1f <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802a11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a18:	a1 34 50 80 00       	mov    0x805034,%eax
  802a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a20:	e9 f3 02 00 00       	jmp    802d18 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802a2b:	83 ec 0c             	sub    $0xc,%esp
  802a2e:	ff 75 bc             	pushl  -0x44(%ebp)
  802a31:	e8 af fb ff ff       	call   8025e5 <get_block_size>
  802a36:	83 c4 10             	add    $0x10,%esp
  802a39:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3f:	83 c0 08             	add    $0x8,%eax
  802a42:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a45:	0f 87 c5 02 00 00    	ja     802d10 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4e:	83 c0 18             	add    $0x18,%eax
  802a51:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a54:	0f 87 19 02 00 00    	ja     802c73 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802a5a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a5d:	2b 45 08             	sub    0x8(%ebp),%eax
  802a60:	83 e8 08             	sub    $0x8,%eax
  802a63:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802a66:	8b 45 08             	mov    0x8(%ebp),%eax
  802a69:	8d 50 08             	lea    0x8(%eax),%edx
  802a6c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a6f:	01 d0                	add    %edx,%eax
  802a71:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	83 c0 08             	add    $0x8,%eax
  802a7a:	83 ec 04             	sub    $0x4,%esp
  802a7d:	6a 01                	push   $0x1
  802a7f:	50                   	push   %eax
  802a80:	ff 75 bc             	pushl  -0x44(%ebp)
  802a83:	e8 ae fe ff ff       	call   802936 <set_block_data>
  802a88:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 40 04             	mov    0x4(%eax),%eax
  802a91:	85 c0                	test   %eax,%eax
  802a93:	75 68                	jne    802afd <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a95:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a99:	75 17                	jne    802ab2 <alloc_block_FF+0x14d>
  802a9b:	83 ec 04             	sub    $0x4,%esp
  802a9e:	68 0c 4c 80 00       	push   $0x804c0c
  802aa3:	68 d7 00 00 00       	push   $0xd7
  802aa8:	68 f1 4b 80 00       	push   $0x804bf1
  802aad:	e8 8b dc ff ff       	call   80073d <_panic>
  802ab2:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802ab8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802abb:	89 10                	mov    %edx,(%eax)
  802abd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	74 0d                	je     802ad3 <alloc_block_FF+0x16e>
  802ac6:	a1 34 50 80 00       	mov    0x805034,%eax
  802acb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ace:	89 50 04             	mov    %edx,0x4(%eax)
  802ad1:	eb 08                	jmp    802adb <alloc_block_FF+0x176>
  802ad3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ad6:	a3 38 50 80 00       	mov    %eax,0x805038
  802adb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ade:	a3 34 50 80 00       	mov    %eax,0x805034
  802ae3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aed:	a1 40 50 80 00       	mov    0x805040,%eax
  802af2:	40                   	inc    %eax
  802af3:	a3 40 50 80 00       	mov    %eax,0x805040
  802af8:	e9 dc 00 00 00       	jmp    802bd9 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	85 c0                	test   %eax,%eax
  802b04:	75 65                	jne    802b6b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b06:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b0a:	75 17                	jne    802b23 <alloc_block_FF+0x1be>
  802b0c:	83 ec 04             	sub    $0x4,%esp
  802b0f:	68 40 4c 80 00       	push   $0x804c40
  802b14:	68 db 00 00 00       	push   $0xdb
  802b19:	68 f1 4b 80 00       	push   $0x804bf1
  802b1e:	e8 1a dc ff ff       	call   80073d <_panic>
  802b23:	8b 15 38 50 80 00    	mov    0x805038,%edx
  802b29:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b2c:	89 50 04             	mov    %edx,0x4(%eax)
  802b2f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b32:	8b 40 04             	mov    0x4(%eax),%eax
  802b35:	85 c0                	test   %eax,%eax
  802b37:	74 0c                	je     802b45 <alloc_block_FF+0x1e0>
  802b39:	a1 38 50 80 00       	mov    0x805038,%eax
  802b3e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b41:	89 10                	mov    %edx,(%eax)
  802b43:	eb 08                	jmp    802b4d <alloc_block_FF+0x1e8>
  802b45:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b48:	a3 34 50 80 00       	mov    %eax,0x805034
  802b4d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b50:	a3 38 50 80 00       	mov    %eax,0x805038
  802b55:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5e:	a1 40 50 80 00       	mov    0x805040,%eax
  802b63:	40                   	inc    %eax
  802b64:	a3 40 50 80 00       	mov    %eax,0x805040
  802b69:	eb 6e                	jmp    802bd9 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802b6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6f:	74 06                	je     802b77 <alloc_block_FF+0x212>
  802b71:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b75:	75 17                	jne    802b8e <alloc_block_FF+0x229>
  802b77:	83 ec 04             	sub    $0x4,%esp
  802b7a:	68 64 4c 80 00       	push   $0x804c64
  802b7f:	68 df 00 00 00       	push   $0xdf
  802b84:	68 f1 4b 80 00       	push   $0x804bf1
  802b89:	e8 af db ff ff       	call   80073d <_panic>
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	8b 10                	mov    (%eax),%edx
  802b93:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b96:	89 10                	mov    %edx,(%eax)
  802b98:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b9b:	8b 00                	mov    (%eax),%eax
  802b9d:	85 c0                	test   %eax,%eax
  802b9f:	74 0b                	je     802bac <alloc_block_FF+0x247>
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	8b 00                	mov    (%eax),%eax
  802ba6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ba9:	89 50 04             	mov    %edx,0x4(%eax)
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bb2:	89 10                	mov    %edx,(%eax)
  802bb4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bba:	89 50 04             	mov    %edx,0x4(%eax)
  802bbd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc0:	8b 00                	mov    (%eax),%eax
  802bc2:	85 c0                	test   %eax,%eax
  802bc4:	75 08                	jne    802bce <alloc_block_FF+0x269>
  802bc6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc9:	a3 38 50 80 00       	mov    %eax,0x805038
  802bce:	a1 40 50 80 00       	mov    0x805040,%eax
  802bd3:	40                   	inc    %eax
  802bd4:	a3 40 50 80 00       	mov    %eax,0x805040
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802bd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdd:	75 17                	jne    802bf6 <alloc_block_FF+0x291>
  802bdf:	83 ec 04             	sub    $0x4,%esp
  802be2:	68 d3 4b 80 00       	push   $0x804bd3
  802be7:	68 e1 00 00 00       	push   $0xe1
  802bec:	68 f1 4b 80 00       	push   $0x804bf1
  802bf1:	e8 47 db ff ff       	call   80073d <_panic>
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 00                	mov    (%eax),%eax
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	74 10                	je     802c0f <alloc_block_FF+0x2aa>
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	8b 00                	mov    (%eax),%eax
  802c04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c07:	8b 52 04             	mov    0x4(%edx),%edx
  802c0a:	89 50 04             	mov    %edx,0x4(%eax)
  802c0d:	eb 0b                	jmp    802c1a <alloc_block_FF+0x2b5>
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 40 04             	mov    0x4(%eax),%eax
  802c15:	a3 38 50 80 00       	mov    %eax,0x805038
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 40 04             	mov    0x4(%eax),%eax
  802c20:	85 c0                	test   %eax,%eax
  802c22:	74 0f                	je     802c33 <alloc_block_FF+0x2ce>
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 40 04             	mov    0x4(%eax),%eax
  802c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c2d:	8b 12                	mov    (%edx),%edx
  802c2f:	89 10                	mov    %edx,(%eax)
  802c31:	eb 0a                	jmp    802c3d <alloc_block_FF+0x2d8>
  802c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c36:	8b 00                	mov    (%eax),%eax
  802c38:	a3 34 50 80 00       	mov    %eax,0x805034
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c50:	a1 40 50 80 00       	mov    0x805040,%eax
  802c55:	48                   	dec    %eax
  802c56:	a3 40 50 80 00       	mov    %eax,0x805040
				set_block_data(new_block_va, remaining_size, 0);
  802c5b:	83 ec 04             	sub    $0x4,%esp
  802c5e:	6a 00                	push   $0x0
  802c60:	ff 75 b4             	pushl  -0x4c(%ebp)
  802c63:	ff 75 b0             	pushl  -0x50(%ebp)
  802c66:	e8 cb fc ff ff       	call   802936 <set_block_data>
  802c6b:	83 c4 10             	add    $0x10,%esp
  802c6e:	e9 95 00 00 00       	jmp    802d08 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802c73:	83 ec 04             	sub    $0x4,%esp
  802c76:	6a 01                	push   $0x1
  802c78:	ff 75 b8             	pushl  -0x48(%ebp)
  802c7b:	ff 75 bc             	pushl  -0x44(%ebp)
  802c7e:	e8 b3 fc ff ff       	call   802936 <set_block_data>
  802c83:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802c86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8a:	75 17                	jne    802ca3 <alloc_block_FF+0x33e>
  802c8c:	83 ec 04             	sub    $0x4,%esp
  802c8f:	68 d3 4b 80 00       	push   $0x804bd3
  802c94:	68 e8 00 00 00       	push   $0xe8
  802c99:	68 f1 4b 80 00       	push   $0x804bf1
  802c9e:	e8 9a da ff ff       	call   80073d <_panic>
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 00                	mov    (%eax),%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	74 10                	je     802cbc <alloc_block_FF+0x357>
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 00                	mov    (%eax),%eax
  802cb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb4:	8b 52 04             	mov    0x4(%edx),%edx
  802cb7:	89 50 04             	mov    %edx,0x4(%eax)
  802cba:	eb 0b                	jmp    802cc7 <alloc_block_FF+0x362>
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 40 04             	mov    0x4(%eax),%eax
  802cc2:	a3 38 50 80 00       	mov    %eax,0x805038
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	8b 40 04             	mov    0x4(%eax),%eax
  802ccd:	85 c0                	test   %eax,%eax
  802ccf:	74 0f                	je     802ce0 <alloc_block_FF+0x37b>
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 40 04             	mov    0x4(%eax),%eax
  802cd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cda:	8b 12                	mov    (%edx),%edx
  802cdc:	89 10                	mov    %edx,(%eax)
  802cde:	eb 0a                	jmp    802cea <alloc_block_FF+0x385>
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 00                	mov    (%eax),%eax
  802ce5:	a3 34 50 80 00       	mov    %eax,0x805034
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfd:	a1 40 50 80 00       	mov    0x805040,%eax
  802d02:	48                   	dec    %eax
  802d03:	a3 40 50 80 00       	mov    %eax,0x805040
	            }
	            return va;
  802d08:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d0b:	e9 0f 01 00 00       	jmp    802e1f <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802d10:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1c:	74 07                	je     802d25 <alloc_block_FF+0x3c0>
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 00                	mov    (%eax),%eax
  802d23:	eb 05                	jmp    802d2a <alloc_block_FF+0x3c5>
  802d25:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802d2f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d34:	85 c0                	test   %eax,%eax
  802d36:	0f 85 e9 fc ff ff    	jne    802a25 <alloc_block_FF+0xc0>
  802d3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d40:	0f 85 df fc ff ff    	jne    802a25 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	83 c0 08             	add    $0x8,%eax
  802d4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d4f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802d56:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d5c:	01 d0                	add    %edx,%eax
  802d5e:	48                   	dec    %eax
  802d5f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802d62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d65:	ba 00 00 00 00       	mov    $0x0,%edx
  802d6a:	f7 75 d8             	divl   -0x28(%ebp)
  802d6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d70:	29 d0                	sub    %edx,%eax
  802d72:	c1 e8 0c             	shr    $0xc,%eax
  802d75:	83 ec 0c             	sub    $0xc,%esp
  802d78:	50                   	push   %eax
  802d79:	e8 1e ec ff ff       	call   80199c <sbrk>
  802d7e:	83 c4 10             	add    $0x10,%esp
  802d81:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802d84:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d88:	75 0a                	jne    802d94 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802d8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d8f:	e9 8b 00 00 00       	jmp    802e1f <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d94:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802d9b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802da1:	01 d0                	add    %edx,%eax
  802da3:	48                   	dec    %eax
  802da4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802da7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802daa:	ba 00 00 00 00       	mov    $0x0,%edx
  802daf:	f7 75 cc             	divl   -0x34(%ebp)
  802db2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802db5:	29 d0                	sub    %edx,%eax
  802db7:	8d 50 fc             	lea    -0x4(%eax),%edx
  802dba:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dbd:	01 d0                	add    %edx,%eax
  802dbf:	a3 48 50 80 00       	mov    %eax,0x805048
			end_block->info = 1;
  802dc4:	a1 48 50 80 00       	mov    0x805048,%eax
  802dc9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802dcf:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802dd6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dd9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ddc:	01 d0                	add    %edx,%eax
  802dde:	48                   	dec    %eax
  802ddf:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802de2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802de5:	ba 00 00 00 00       	mov    $0x0,%edx
  802dea:	f7 75 c4             	divl   -0x3c(%ebp)
  802ded:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802df0:	29 d0                	sub    %edx,%eax
  802df2:	83 ec 04             	sub    $0x4,%esp
  802df5:	6a 01                	push   $0x1
  802df7:	50                   	push   %eax
  802df8:	ff 75 d0             	pushl  -0x30(%ebp)
  802dfb:	e8 36 fb ff ff       	call   802936 <set_block_data>
  802e00:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802e03:	83 ec 0c             	sub    $0xc,%esp
  802e06:	ff 75 d0             	pushl  -0x30(%ebp)
  802e09:	e8 1b 0a 00 00       	call   803829 <free_block>
  802e0e:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802e11:	83 ec 0c             	sub    $0xc,%esp
  802e14:	ff 75 08             	pushl  0x8(%ebp)
  802e17:	e8 49 fb ff ff       	call   802965 <alloc_block_FF>
  802e1c:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802e1f:	c9                   	leave  
  802e20:	c3                   	ret    

00802e21 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e21:	55                   	push   %ebp
  802e22:	89 e5                	mov    %esp,%ebp
  802e24:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	83 e0 01             	and    $0x1,%eax
  802e2d:	85 c0                	test   %eax,%eax
  802e2f:	74 03                	je     802e34 <alloc_block_BF+0x13>
  802e31:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802e34:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802e38:	77 07                	ja     802e41 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802e3a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802e41:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e46:	85 c0                	test   %eax,%eax
  802e48:	75 73                	jne    802ebd <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	83 c0 10             	add    $0x10,%eax
  802e50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e53:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802e5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e60:	01 d0                	add    %edx,%eax
  802e62:	48                   	dec    %eax
  802e63:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e69:	ba 00 00 00 00       	mov    $0x0,%edx
  802e6e:	f7 75 e0             	divl   -0x20(%ebp)
  802e71:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e74:	29 d0                	sub    %edx,%eax
  802e76:	c1 e8 0c             	shr    $0xc,%eax
  802e79:	83 ec 0c             	sub    $0xc,%esp
  802e7c:	50                   	push   %eax
  802e7d:	e8 1a eb ff ff       	call   80199c <sbrk>
  802e82:	83 c4 10             	add    $0x10,%esp
  802e85:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802e88:	83 ec 0c             	sub    $0xc,%esp
  802e8b:	6a 00                	push   $0x0
  802e8d:	e8 0a eb ff ff       	call   80199c <sbrk>
  802e92:	83 c4 10             	add    $0x10,%esp
  802e95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802e98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e9b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802e9e:	83 ec 08             	sub    $0x8,%esp
  802ea1:	50                   	push   %eax
  802ea2:	ff 75 d8             	pushl  -0x28(%ebp)
  802ea5:	e8 9f f8 ff ff       	call   802749 <initialize_dynamic_allocator>
  802eaa:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ead:	83 ec 0c             	sub    $0xc,%esp
  802eb0:	68 2f 4c 80 00       	push   $0x804c2f
  802eb5:	e8 40 db ff ff       	call   8009fa <cprintf>
  802eba:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802ebd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802ec4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802ecb:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802ed2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802ed9:	a1 34 50 80 00       	mov    0x805034,%eax
  802ede:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee1:	e9 1d 01 00 00       	jmp    803003 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802eec:	83 ec 0c             	sub    $0xc,%esp
  802eef:	ff 75 a8             	pushl  -0x58(%ebp)
  802ef2:	e8 ee f6 ff ff       	call   8025e5 <get_block_size>
  802ef7:	83 c4 10             	add    $0x10,%esp
  802efa:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	83 c0 08             	add    $0x8,%eax
  802f03:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f06:	0f 87 ef 00 00 00    	ja     802ffb <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	83 c0 18             	add    $0x18,%eax
  802f12:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f15:	77 1d                	ja     802f34 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f1d:	0f 86 d8 00 00 00    	jbe    802ffb <alloc_block_BF+0x1da>
				{
					best_va = va;
  802f23:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f26:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802f29:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802f2f:	e9 c7 00 00 00       	jmp    802ffb <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802f34:	8b 45 08             	mov    0x8(%ebp),%eax
  802f37:	83 c0 08             	add    $0x8,%eax
  802f3a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f3d:	0f 85 9d 00 00 00    	jne    802fe0 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802f43:	83 ec 04             	sub    $0x4,%esp
  802f46:	6a 01                	push   $0x1
  802f48:	ff 75 a4             	pushl  -0x5c(%ebp)
  802f4b:	ff 75 a8             	pushl  -0x58(%ebp)
  802f4e:	e8 e3 f9 ff ff       	call   802936 <set_block_data>
  802f53:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802f56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5a:	75 17                	jne    802f73 <alloc_block_BF+0x152>
  802f5c:	83 ec 04             	sub    $0x4,%esp
  802f5f:	68 d3 4b 80 00       	push   $0x804bd3
  802f64:	68 2c 01 00 00       	push   $0x12c
  802f69:	68 f1 4b 80 00       	push   $0x804bf1
  802f6e:	e8 ca d7 ff ff       	call   80073d <_panic>
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	8b 00                	mov    (%eax),%eax
  802f78:	85 c0                	test   %eax,%eax
  802f7a:	74 10                	je     802f8c <alloc_block_BF+0x16b>
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	8b 00                	mov    (%eax),%eax
  802f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f84:	8b 52 04             	mov    0x4(%edx),%edx
  802f87:	89 50 04             	mov    %edx,0x4(%eax)
  802f8a:	eb 0b                	jmp    802f97 <alloc_block_BF+0x176>
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	8b 40 04             	mov    0x4(%eax),%eax
  802f92:	a3 38 50 80 00       	mov    %eax,0x805038
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	8b 40 04             	mov    0x4(%eax),%eax
  802f9d:	85 c0                	test   %eax,%eax
  802f9f:	74 0f                	je     802fb0 <alloc_block_BF+0x18f>
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	8b 40 04             	mov    0x4(%eax),%eax
  802fa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802faa:	8b 12                	mov    (%edx),%edx
  802fac:	89 10                	mov    %edx,(%eax)
  802fae:	eb 0a                	jmp    802fba <alloc_block_BF+0x199>
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	8b 00                	mov    (%eax),%eax
  802fb5:	a3 34 50 80 00       	mov    %eax,0x805034
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fcd:	a1 40 50 80 00       	mov    0x805040,%eax
  802fd2:	48                   	dec    %eax
  802fd3:	a3 40 50 80 00       	mov    %eax,0x805040
					return va;
  802fd8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fdb:	e9 24 04 00 00       	jmp    803404 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fe6:	76 13                	jbe    802ffb <alloc_block_BF+0x1da>
					{
						internal = 1;
  802fe8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802fef:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ff2:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802ff5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ff8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802ffb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803000:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803007:	74 07                	je     803010 <alloc_block_BF+0x1ef>
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	8b 00                	mov    (%eax),%eax
  80300e:	eb 05                	jmp    803015 <alloc_block_BF+0x1f4>
  803010:	b8 00 00 00 00       	mov    $0x0,%eax
  803015:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80301a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80301f:	85 c0                	test   %eax,%eax
  803021:	0f 85 bf fe ff ff    	jne    802ee6 <alloc_block_BF+0xc5>
  803027:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302b:	0f 85 b5 fe ff ff    	jne    802ee6 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803031:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803035:	0f 84 26 02 00 00    	je     803261 <alloc_block_BF+0x440>
  80303b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80303f:	0f 85 1c 02 00 00    	jne    803261 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803045:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803048:	2b 45 08             	sub    0x8(%ebp),%eax
  80304b:	83 e8 08             	sub    $0x8,%eax
  80304e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	8d 50 08             	lea    0x8(%eax),%edx
  803057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305a:	01 d0                	add    %edx,%eax
  80305c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	83 c0 08             	add    $0x8,%eax
  803065:	83 ec 04             	sub    $0x4,%esp
  803068:	6a 01                	push   $0x1
  80306a:	50                   	push   %eax
  80306b:	ff 75 f0             	pushl  -0x10(%ebp)
  80306e:	e8 c3 f8 ff ff       	call   802936 <set_block_data>
  803073:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803079:	8b 40 04             	mov    0x4(%eax),%eax
  80307c:	85 c0                	test   %eax,%eax
  80307e:	75 68                	jne    8030e8 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803080:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803084:	75 17                	jne    80309d <alloc_block_BF+0x27c>
  803086:	83 ec 04             	sub    $0x4,%esp
  803089:	68 0c 4c 80 00       	push   $0x804c0c
  80308e:	68 45 01 00 00       	push   $0x145
  803093:	68 f1 4b 80 00       	push   $0x804bf1
  803098:	e8 a0 d6 ff ff       	call   80073d <_panic>
  80309d:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8030a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a6:	89 10                	mov    %edx,(%eax)
  8030a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030ab:	8b 00                	mov    (%eax),%eax
  8030ad:	85 c0                	test   %eax,%eax
  8030af:	74 0d                	je     8030be <alloc_block_BF+0x29d>
  8030b1:	a1 34 50 80 00       	mov    0x805034,%eax
  8030b6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030b9:	89 50 04             	mov    %edx,0x4(%eax)
  8030bc:	eb 08                	jmp    8030c6 <alloc_block_BF+0x2a5>
  8030be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c1:	a3 38 50 80 00       	mov    %eax,0x805038
  8030c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c9:	a3 34 50 80 00       	mov    %eax,0x805034
  8030ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d8:	a1 40 50 80 00       	mov    0x805040,%eax
  8030dd:	40                   	inc    %eax
  8030de:	a3 40 50 80 00       	mov    %eax,0x805040
  8030e3:	e9 dc 00 00 00       	jmp    8031c4 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8030e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030eb:	8b 00                	mov    (%eax),%eax
  8030ed:	85 c0                	test   %eax,%eax
  8030ef:	75 65                	jne    803156 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030f1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030f5:	75 17                	jne    80310e <alloc_block_BF+0x2ed>
  8030f7:	83 ec 04             	sub    $0x4,%esp
  8030fa:	68 40 4c 80 00       	push   $0x804c40
  8030ff:	68 4a 01 00 00       	push   $0x14a
  803104:	68 f1 4b 80 00       	push   $0x804bf1
  803109:	e8 2f d6 ff ff       	call   80073d <_panic>
  80310e:	8b 15 38 50 80 00    	mov    0x805038,%edx
  803114:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803117:	89 50 04             	mov    %edx,0x4(%eax)
  80311a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80311d:	8b 40 04             	mov    0x4(%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 0c                	je     803130 <alloc_block_BF+0x30f>
  803124:	a1 38 50 80 00       	mov    0x805038,%eax
  803129:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80312c:	89 10                	mov    %edx,(%eax)
  80312e:	eb 08                	jmp    803138 <alloc_block_BF+0x317>
  803130:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803133:	a3 34 50 80 00       	mov    %eax,0x805034
  803138:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80313b:	a3 38 50 80 00       	mov    %eax,0x805038
  803140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803143:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803149:	a1 40 50 80 00       	mov    0x805040,%eax
  80314e:	40                   	inc    %eax
  80314f:	a3 40 50 80 00       	mov    %eax,0x805040
  803154:	eb 6e                	jmp    8031c4 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803156:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80315a:	74 06                	je     803162 <alloc_block_BF+0x341>
  80315c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803160:	75 17                	jne    803179 <alloc_block_BF+0x358>
  803162:	83 ec 04             	sub    $0x4,%esp
  803165:	68 64 4c 80 00       	push   $0x804c64
  80316a:	68 4f 01 00 00       	push   $0x14f
  80316f:	68 f1 4b 80 00       	push   $0x804bf1
  803174:	e8 c4 d5 ff ff       	call   80073d <_panic>
  803179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317c:	8b 10                	mov    (%eax),%edx
  80317e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803181:	89 10                	mov    %edx,(%eax)
  803183:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803186:	8b 00                	mov    (%eax),%eax
  803188:	85 c0                	test   %eax,%eax
  80318a:	74 0b                	je     803197 <alloc_block_BF+0x376>
  80318c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318f:	8b 00                	mov    (%eax),%eax
  803191:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803194:	89 50 04             	mov    %edx,0x4(%eax)
  803197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80319d:	89 10                	mov    %edx,(%eax)
  80319f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a5:	89 50 04             	mov    %edx,0x4(%eax)
  8031a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ab:	8b 00                	mov    (%eax),%eax
  8031ad:	85 c0                	test   %eax,%eax
  8031af:	75 08                	jne    8031b9 <alloc_block_BF+0x398>
  8031b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031b4:	a3 38 50 80 00       	mov    %eax,0x805038
  8031b9:	a1 40 50 80 00       	mov    0x805040,%eax
  8031be:	40                   	inc    %eax
  8031bf:	a3 40 50 80 00       	mov    %eax,0x805040
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8031c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031c8:	75 17                	jne    8031e1 <alloc_block_BF+0x3c0>
  8031ca:	83 ec 04             	sub    $0x4,%esp
  8031cd:	68 d3 4b 80 00       	push   $0x804bd3
  8031d2:	68 51 01 00 00       	push   $0x151
  8031d7:	68 f1 4b 80 00       	push   $0x804bf1
  8031dc:	e8 5c d5 ff ff       	call   80073d <_panic>
  8031e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e4:	8b 00                	mov    (%eax),%eax
  8031e6:	85 c0                	test   %eax,%eax
  8031e8:	74 10                	je     8031fa <alloc_block_BF+0x3d9>
  8031ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ed:	8b 00                	mov    (%eax),%eax
  8031ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031f2:	8b 52 04             	mov    0x4(%edx),%edx
  8031f5:	89 50 04             	mov    %edx,0x4(%eax)
  8031f8:	eb 0b                	jmp    803205 <alloc_block_BF+0x3e4>
  8031fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fd:	8b 40 04             	mov    0x4(%eax),%eax
  803200:	a3 38 50 80 00       	mov    %eax,0x805038
  803205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803208:	8b 40 04             	mov    0x4(%eax),%eax
  80320b:	85 c0                	test   %eax,%eax
  80320d:	74 0f                	je     80321e <alloc_block_BF+0x3fd>
  80320f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803212:	8b 40 04             	mov    0x4(%eax),%eax
  803215:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803218:	8b 12                	mov    (%edx),%edx
  80321a:	89 10                	mov    %edx,(%eax)
  80321c:	eb 0a                	jmp    803228 <alloc_block_BF+0x407>
  80321e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803221:	8b 00                	mov    (%eax),%eax
  803223:	a3 34 50 80 00       	mov    %eax,0x805034
  803228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803231:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803234:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323b:	a1 40 50 80 00       	mov    0x805040,%eax
  803240:	48                   	dec    %eax
  803241:	a3 40 50 80 00       	mov    %eax,0x805040
			set_block_data(new_block_va, remaining_size, 0);
  803246:	83 ec 04             	sub    $0x4,%esp
  803249:	6a 00                	push   $0x0
  80324b:	ff 75 d0             	pushl  -0x30(%ebp)
  80324e:	ff 75 cc             	pushl  -0x34(%ebp)
  803251:	e8 e0 f6 ff ff       	call   802936 <set_block_data>
  803256:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325c:	e9 a3 01 00 00       	jmp    803404 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803261:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803265:	0f 85 9d 00 00 00    	jne    803308 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80326b:	83 ec 04             	sub    $0x4,%esp
  80326e:	6a 01                	push   $0x1
  803270:	ff 75 ec             	pushl  -0x14(%ebp)
  803273:	ff 75 f0             	pushl  -0x10(%ebp)
  803276:	e8 bb f6 ff ff       	call   802936 <set_block_data>
  80327b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80327e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803282:	75 17                	jne    80329b <alloc_block_BF+0x47a>
  803284:	83 ec 04             	sub    $0x4,%esp
  803287:	68 d3 4b 80 00       	push   $0x804bd3
  80328c:	68 58 01 00 00       	push   $0x158
  803291:	68 f1 4b 80 00       	push   $0x804bf1
  803296:	e8 a2 d4 ff ff       	call   80073d <_panic>
  80329b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329e:	8b 00                	mov    (%eax),%eax
  8032a0:	85 c0                	test   %eax,%eax
  8032a2:	74 10                	je     8032b4 <alloc_block_BF+0x493>
  8032a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a7:	8b 00                	mov    (%eax),%eax
  8032a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ac:	8b 52 04             	mov    0x4(%edx),%edx
  8032af:	89 50 04             	mov    %edx,0x4(%eax)
  8032b2:	eb 0b                	jmp    8032bf <alloc_block_BF+0x49e>
  8032b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b7:	8b 40 04             	mov    0x4(%eax),%eax
  8032ba:	a3 38 50 80 00       	mov    %eax,0x805038
  8032bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c2:	8b 40 04             	mov    0x4(%eax),%eax
  8032c5:	85 c0                	test   %eax,%eax
  8032c7:	74 0f                	je     8032d8 <alloc_block_BF+0x4b7>
  8032c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cc:	8b 40 04             	mov    0x4(%eax),%eax
  8032cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032d2:	8b 12                	mov    (%edx),%edx
  8032d4:	89 10                	mov    %edx,(%eax)
  8032d6:	eb 0a                	jmp    8032e2 <alloc_block_BF+0x4c1>
  8032d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032db:	8b 00                	mov    (%eax),%eax
  8032dd:	a3 34 50 80 00       	mov    %eax,0x805034
  8032e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f5:	a1 40 50 80 00       	mov    0x805040,%eax
  8032fa:	48                   	dec    %eax
  8032fb:	a3 40 50 80 00       	mov    %eax,0x805040
		return best_va;
  803300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803303:	e9 fc 00 00 00       	jmp    803404 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803308:	8b 45 08             	mov    0x8(%ebp),%eax
  80330b:	83 c0 08             	add    $0x8,%eax
  80330e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803311:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803318:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80331b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80331e:	01 d0                	add    %edx,%eax
  803320:	48                   	dec    %eax
  803321:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803324:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803327:	ba 00 00 00 00       	mov    $0x0,%edx
  80332c:	f7 75 c4             	divl   -0x3c(%ebp)
  80332f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803332:	29 d0                	sub    %edx,%eax
  803334:	c1 e8 0c             	shr    $0xc,%eax
  803337:	83 ec 0c             	sub    $0xc,%esp
  80333a:	50                   	push   %eax
  80333b:	e8 5c e6 ff ff       	call   80199c <sbrk>
  803340:	83 c4 10             	add    $0x10,%esp
  803343:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803346:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80334a:	75 0a                	jne    803356 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80334c:	b8 00 00 00 00       	mov    $0x0,%eax
  803351:	e9 ae 00 00 00       	jmp    803404 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803356:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80335d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803360:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803363:	01 d0                	add    %edx,%eax
  803365:	48                   	dec    %eax
  803366:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803369:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80336c:	ba 00 00 00 00       	mov    $0x0,%edx
  803371:	f7 75 b8             	divl   -0x48(%ebp)
  803374:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803377:	29 d0                	sub    %edx,%eax
  803379:	8d 50 fc             	lea    -0x4(%eax),%edx
  80337c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80337f:	01 d0                	add    %edx,%eax
  803381:	a3 48 50 80 00       	mov    %eax,0x805048
				end_block->info = 1;
  803386:	a1 48 50 80 00       	mov    0x805048,%eax
  80338b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803391:	83 ec 0c             	sub    $0xc,%esp
  803394:	68 98 4c 80 00       	push   $0x804c98
  803399:	e8 5c d6 ff ff       	call   8009fa <cprintf>
  80339e:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8033a1:	83 ec 08             	sub    $0x8,%esp
  8033a4:	ff 75 bc             	pushl  -0x44(%ebp)
  8033a7:	68 9d 4c 80 00       	push   $0x804c9d
  8033ac:	e8 49 d6 ff ff       	call   8009fa <cprintf>
  8033b1:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8033b4:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8033bb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033c1:	01 d0                	add    %edx,%eax
  8033c3:	48                   	dec    %eax
  8033c4:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8033c7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8033cf:	f7 75 b0             	divl   -0x50(%ebp)
  8033d2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033d5:	29 d0                	sub    %edx,%eax
  8033d7:	83 ec 04             	sub    $0x4,%esp
  8033da:	6a 01                	push   $0x1
  8033dc:	50                   	push   %eax
  8033dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8033e0:	e8 51 f5 ff ff       	call   802936 <set_block_data>
  8033e5:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8033e8:	83 ec 0c             	sub    $0xc,%esp
  8033eb:	ff 75 bc             	pushl  -0x44(%ebp)
  8033ee:	e8 36 04 00 00       	call   803829 <free_block>
  8033f3:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8033f6:	83 ec 0c             	sub    $0xc,%esp
  8033f9:	ff 75 08             	pushl  0x8(%ebp)
  8033fc:	e8 20 fa ff ff       	call   802e21 <alloc_block_BF>
  803401:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803404:	c9                   	leave  
  803405:	c3                   	ret    

00803406 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803406:	55                   	push   %ebp
  803407:	89 e5                	mov    %esp,%ebp
  803409:	53                   	push   %ebx
  80340a:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80340d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803414:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80341b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80341f:	74 1e                	je     80343f <merging+0x39>
  803421:	ff 75 08             	pushl  0x8(%ebp)
  803424:	e8 bc f1 ff ff       	call   8025e5 <get_block_size>
  803429:	83 c4 04             	add    $0x4,%esp
  80342c:	89 c2                	mov    %eax,%edx
  80342e:	8b 45 08             	mov    0x8(%ebp),%eax
  803431:	01 d0                	add    %edx,%eax
  803433:	3b 45 10             	cmp    0x10(%ebp),%eax
  803436:	75 07                	jne    80343f <merging+0x39>
		prev_is_free = 1;
  803438:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80343f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803443:	74 1e                	je     803463 <merging+0x5d>
  803445:	ff 75 10             	pushl  0x10(%ebp)
  803448:	e8 98 f1 ff ff       	call   8025e5 <get_block_size>
  80344d:	83 c4 04             	add    $0x4,%esp
  803450:	89 c2                	mov    %eax,%edx
  803452:	8b 45 10             	mov    0x10(%ebp),%eax
  803455:	01 d0                	add    %edx,%eax
  803457:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80345a:	75 07                	jne    803463 <merging+0x5d>
		next_is_free = 1;
  80345c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803463:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803467:	0f 84 cc 00 00 00    	je     803539 <merging+0x133>
  80346d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803471:	0f 84 c2 00 00 00    	je     803539 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803477:	ff 75 08             	pushl  0x8(%ebp)
  80347a:	e8 66 f1 ff ff       	call   8025e5 <get_block_size>
  80347f:	83 c4 04             	add    $0x4,%esp
  803482:	89 c3                	mov    %eax,%ebx
  803484:	ff 75 10             	pushl  0x10(%ebp)
  803487:	e8 59 f1 ff ff       	call   8025e5 <get_block_size>
  80348c:	83 c4 04             	add    $0x4,%esp
  80348f:	01 c3                	add    %eax,%ebx
  803491:	ff 75 0c             	pushl  0xc(%ebp)
  803494:	e8 4c f1 ff ff       	call   8025e5 <get_block_size>
  803499:	83 c4 04             	add    $0x4,%esp
  80349c:	01 d8                	add    %ebx,%eax
  80349e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8034a1:	6a 00                	push   $0x0
  8034a3:	ff 75 ec             	pushl  -0x14(%ebp)
  8034a6:	ff 75 08             	pushl  0x8(%ebp)
  8034a9:	e8 88 f4 ff ff       	call   802936 <set_block_data>
  8034ae:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8034b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034b5:	75 17                	jne    8034ce <merging+0xc8>
  8034b7:	83 ec 04             	sub    $0x4,%esp
  8034ba:	68 d3 4b 80 00       	push   $0x804bd3
  8034bf:	68 7d 01 00 00       	push   $0x17d
  8034c4:	68 f1 4b 80 00       	push   $0x804bf1
  8034c9:	e8 6f d2 ff ff       	call   80073d <_panic>
  8034ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d1:	8b 00                	mov    (%eax),%eax
  8034d3:	85 c0                	test   %eax,%eax
  8034d5:	74 10                	je     8034e7 <merging+0xe1>
  8034d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034da:	8b 00                	mov    (%eax),%eax
  8034dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034df:	8b 52 04             	mov    0x4(%edx),%edx
  8034e2:	89 50 04             	mov    %edx,0x4(%eax)
  8034e5:	eb 0b                	jmp    8034f2 <merging+0xec>
  8034e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ea:	8b 40 04             	mov    0x4(%eax),%eax
  8034ed:	a3 38 50 80 00       	mov    %eax,0x805038
  8034f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f5:	8b 40 04             	mov    0x4(%eax),%eax
  8034f8:	85 c0                	test   %eax,%eax
  8034fa:	74 0f                	je     80350b <merging+0x105>
  8034fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ff:	8b 40 04             	mov    0x4(%eax),%eax
  803502:	8b 55 0c             	mov    0xc(%ebp),%edx
  803505:	8b 12                	mov    (%edx),%edx
  803507:	89 10                	mov    %edx,(%eax)
  803509:	eb 0a                	jmp    803515 <merging+0x10f>
  80350b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80350e:	8b 00                	mov    (%eax),%eax
  803510:	a3 34 50 80 00       	mov    %eax,0x805034
  803515:	8b 45 0c             	mov    0xc(%ebp),%eax
  803518:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80351e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803521:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803528:	a1 40 50 80 00       	mov    0x805040,%eax
  80352d:	48                   	dec    %eax
  80352e:	a3 40 50 80 00       	mov    %eax,0x805040
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803533:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803534:	e9 ea 02 00 00       	jmp    803823 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803539:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80353d:	74 3b                	je     80357a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80353f:	83 ec 0c             	sub    $0xc,%esp
  803542:	ff 75 08             	pushl  0x8(%ebp)
  803545:	e8 9b f0 ff ff       	call   8025e5 <get_block_size>
  80354a:	83 c4 10             	add    $0x10,%esp
  80354d:	89 c3                	mov    %eax,%ebx
  80354f:	83 ec 0c             	sub    $0xc,%esp
  803552:	ff 75 10             	pushl  0x10(%ebp)
  803555:	e8 8b f0 ff ff       	call   8025e5 <get_block_size>
  80355a:	83 c4 10             	add    $0x10,%esp
  80355d:	01 d8                	add    %ebx,%eax
  80355f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803562:	83 ec 04             	sub    $0x4,%esp
  803565:	6a 00                	push   $0x0
  803567:	ff 75 e8             	pushl  -0x18(%ebp)
  80356a:	ff 75 08             	pushl  0x8(%ebp)
  80356d:	e8 c4 f3 ff ff       	call   802936 <set_block_data>
  803572:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803575:	e9 a9 02 00 00       	jmp    803823 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80357a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80357e:	0f 84 2d 01 00 00    	je     8036b1 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803584:	83 ec 0c             	sub    $0xc,%esp
  803587:	ff 75 10             	pushl  0x10(%ebp)
  80358a:	e8 56 f0 ff ff       	call   8025e5 <get_block_size>
  80358f:	83 c4 10             	add    $0x10,%esp
  803592:	89 c3                	mov    %eax,%ebx
  803594:	83 ec 0c             	sub    $0xc,%esp
  803597:	ff 75 0c             	pushl  0xc(%ebp)
  80359a:	e8 46 f0 ff ff       	call   8025e5 <get_block_size>
  80359f:	83 c4 10             	add    $0x10,%esp
  8035a2:	01 d8                	add    %ebx,%eax
  8035a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8035a7:	83 ec 04             	sub    $0x4,%esp
  8035aa:	6a 00                	push   $0x0
  8035ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035af:	ff 75 10             	pushl  0x10(%ebp)
  8035b2:	e8 7f f3 ff ff       	call   802936 <set_block_data>
  8035b7:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8035ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8035bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8035c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035c4:	74 06                	je     8035cc <merging+0x1c6>
  8035c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8035ca:	75 17                	jne    8035e3 <merging+0x1dd>
  8035cc:	83 ec 04             	sub    $0x4,%esp
  8035cf:	68 ac 4c 80 00       	push   $0x804cac
  8035d4:	68 8d 01 00 00       	push   $0x18d
  8035d9:	68 f1 4b 80 00       	push   $0x804bf1
  8035de:	e8 5a d1 ff ff       	call   80073d <_panic>
  8035e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e6:	8b 50 04             	mov    0x4(%eax),%edx
  8035e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ec:	89 50 04             	mov    %edx,0x4(%eax)
  8035ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f5:	89 10                	mov    %edx,(%eax)
  8035f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fa:	8b 40 04             	mov    0x4(%eax),%eax
  8035fd:	85 c0                	test   %eax,%eax
  8035ff:	74 0d                	je     80360e <merging+0x208>
  803601:	8b 45 0c             	mov    0xc(%ebp),%eax
  803604:	8b 40 04             	mov    0x4(%eax),%eax
  803607:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80360a:	89 10                	mov    %edx,(%eax)
  80360c:	eb 08                	jmp    803616 <merging+0x210>
  80360e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803611:	a3 34 50 80 00       	mov    %eax,0x805034
  803616:	8b 45 0c             	mov    0xc(%ebp),%eax
  803619:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80361c:	89 50 04             	mov    %edx,0x4(%eax)
  80361f:	a1 40 50 80 00       	mov    0x805040,%eax
  803624:	40                   	inc    %eax
  803625:	a3 40 50 80 00       	mov    %eax,0x805040
		LIST_REMOVE(&freeBlocksList, next_block);
  80362a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80362e:	75 17                	jne    803647 <merging+0x241>
  803630:	83 ec 04             	sub    $0x4,%esp
  803633:	68 d3 4b 80 00       	push   $0x804bd3
  803638:	68 8e 01 00 00       	push   $0x18e
  80363d:	68 f1 4b 80 00       	push   $0x804bf1
  803642:	e8 f6 d0 ff ff       	call   80073d <_panic>
  803647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80364a:	8b 00                	mov    (%eax),%eax
  80364c:	85 c0                	test   %eax,%eax
  80364e:	74 10                	je     803660 <merging+0x25a>
  803650:	8b 45 0c             	mov    0xc(%ebp),%eax
  803653:	8b 00                	mov    (%eax),%eax
  803655:	8b 55 0c             	mov    0xc(%ebp),%edx
  803658:	8b 52 04             	mov    0x4(%edx),%edx
  80365b:	89 50 04             	mov    %edx,0x4(%eax)
  80365e:	eb 0b                	jmp    80366b <merging+0x265>
  803660:	8b 45 0c             	mov    0xc(%ebp),%eax
  803663:	8b 40 04             	mov    0x4(%eax),%eax
  803666:	a3 38 50 80 00       	mov    %eax,0x805038
  80366b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80366e:	8b 40 04             	mov    0x4(%eax),%eax
  803671:	85 c0                	test   %eax,%eax
  803673:	74 0f                	je     803684 <merging+0x27e>
  803675:	8b 45 0c             	mov    0xc(%ebp),%eax
  803678:	8b 40 04             	mov    0x4(%eax),%eax
  80367b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80367e:	8b 12                	mov    (%edx),%edx
  803680:	89 10                	mov    %edx,(%eax)
  803682:	eb 0a                	jmp    80368e <merging+0x288>
  803684:	8b 45 0c             	mov    0xc(%ebp),%eax
  803687:	8b 00                	mov    (%eax),%eax
  803689:	a3 34 50 80 00       	mov    %eax,0x805034
  80368e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803691:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803697:	8b 45 0c             	mov    0xc(%ebp),%eax
  80369a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a1:	a1 40 50 80 00       	mov    0x805040,%eax
  8036a6:	48                   	dec    %eax
  8036a7:	a3 40 50 80 00       	mov    %eax,0x805040
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8036ac:	e9 72 01 00 00       	jmp    803823 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8036b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8036b4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8036b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036bb:	74 79                	je     803736 <merging+0x330>
  8036bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036c1:	74 73                	je     803736 <merging+0x330>
  8036c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036c7:	74 06                	je     8036cf <merging+0x2c9>
  8036c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036cd:	75 17                	jne    8036e6 <merging+0x2e0>
  8036cf:	83 ec 04             	sub    $0x4,%esp
  8036d2:	68 64 4c 80 00       	push   $0x804c64
  8036d7:	68 94 01 00 00       	push   $0x194
  8036dc:	68 f1 4b 80 00       	push   $0x804bf1
  8036e1:	e8 57 d0 ff ff       	call   80073d <_panic>
  8036e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e9:	8b 10                	mov    (%eax),%edx
  8036eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ee:	89 10                	mov    %edx,(%eax)
  8036f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f3:	8b 00                	mov    (%eax),%eax
  8036f5:	85 c0                	test   %eax,%eax
  8036f7:	74 0b                	je     803704 <merging+0x2fe>
  8036f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fc:	8b 00                	mov    (%eax),%eax
  8036fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803701:	89 50 04             	mov    %edx,0x4(%eax)
  803704:	8b 45 08             	mov    0x8(%ebp),%eax
  803707:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80370a:	89 10                	mov    %edx,(%eax)
  80370c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80370f:	8b 55 08             	mov    0x8(%ebp),%edx
  803712:	89 50 04             	mov    %edx,0x4(%eax)
  803715:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803718:	8b 00                	mov    (%eax),%eax
  80371a:	85 c0                	test   %eax,%eax
  80371c:	75 08                	jne    803726 <merging+0x320>
  80371e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803721:	a3 38 50 80 00       	mov    %eax,0x805038
  803726:	a1 40 50 80 00       	mov    0x805040,%eax
  80372b:	40                   	inc    %eax
  80372c:	a3 40 50 80 00       	mov    %eax,0x805040
  803731:	e9 ce 00 00 00       	jmp    803804 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803736:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80373a:	74 65                	je     8037a1 <merging+0x39b>
  80373c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803740:	75 17                	jne    803759 <merging+0x353>
  803742:	83 ec 04             	sub    $0x4,%esp
  803745:	68 40 4c 80 00       	push   $0x804c40
  80374a:	68 95 01 00 00       	push   $0x195
  80374f:	68 f1 4b 80 00       	push   $0x804bf1
  803754:	e8 e4 cf ff ff       	call   80073d <_panic>
  803759:	8b 15 38 50 80 00    	mov    0x805038,%edx
  80375f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803762:	89 50 04             	mov    %edx,0x4(%eax)
  803765:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803768:	8b 40 04             	mov    0x4(%eax),%eax
  80376b:	85 c0                	test   %eax,%eax
  80376d:	74 0c                	je     80377b <merging+0x375>
  80376f:	a1 38 50 80 00       	mov    0x805038,%eax
  803774:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803777:	89 10                	mov    %edx,(%eax)
  803779:	eb 08                	jmp    803783 <merging+0x37d>
  80377b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80377e:	a3 34 50 80 00       	mov    %eax,0x805034
  803783:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803786:	a3 38 50 80 00       	mov    %eax,0x805038
  80378b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80378e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803794:	a1 40 50 80 00       	mov    0x805040,%eax
  803799:	40                   	inc    %eax
  80379a:	a3 40 50 80 00       	mov    %eax,0x805040
  80379f:	eb 63                	jmp    803804 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8037a1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037a5:	75 17                	jne    8037be <merging+0x3b8>
  8037a7:	83 ec 04             	sub    $0x4,%esp
  8037aa:	68 0c 4c 80 00       	push   $0x804c0c
  8037af:	68 98 01 00 00       	push   $0x198
  8037b4:	68 f1 4b 80 00       	push   $0x804bf1
  8037b9:	e8 7f cf ff ff       	call   80073d <_panic>
  8037be:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8037c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c7:	89 10                	mov    %edx,(%eax)
  8037c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037cc:	8b 00                	mov    (%eax),%eax
  8037ce:	85 c0                	test   %eax,%eax
  8037d0:	74 0d                	je     8037df <merging+0x3d9>
  8037d2:	a1 34 50 80 00       	mov    0x805034,%eax
  8037d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037da:	89 50 04             	mov    %edx,0x4(%eax)
  8037dd:	eb 08                	jmp    8037e7 <merging+0x3e1>
  8037df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037e2:	a3 38 50 80 00       	mov    %eax,0x805038
  8037e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ea:	a3 34 50 80 00       	mov    %eax,0x805034
  8037ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f9:	a1 40 50 80 00       	mov    0x805040,%eax
  8037fe:	40                   	inc    %eax
  8037ff:	a3 40 50 80 00       	mov    %eax,0x805040
		}
		set_block_data(va, get_block_size(va), 0);
  803804:	83 ec 0c             	sub    $0xc,%esp
  803807:	ff 75 10             	pushl  0x10(%ebp)
  80380a:	e8 d6 ed ff ff       	call   8025e5 <get_block_size>
  80380f:	83 c4 10             	add    $0x10,%esp
  803812:	83 ec 04             	sub    $0x4,%esp
  803815:	6a 00                	push   $0x0
  803817:	50                   	push   %eax
  803818:	ff 75 10             	pushl  0x10(%ebp)
  80381b:	e8 16 f1 ff ff       	call   802936 <set_block_data>
  803820:	83 c4 10             	add    $0x10,%esp
	}
}
  803823:	90                   	nop
  803824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803827:	c9                   	leave  
  803828:	c3                   	ret    

00803829 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803829:	55                   	push   %ebp
  80382a:	89 e5                	mov    %esp,%ebp
  80382c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80382f:	a1 34 50 80 00       	mov    0x805034,%eax
  803834:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803837:	a1 38 50 80 00       	mov    0x805038,%eax
  80383c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80383f:	73 1b                	jae    80385c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803841:	a1 38 50 80 00       	mov    0x805038,%eax
  803846:	83 ec 04             	sub    $0x4,%esp
  803849:	ff 75 08             	pushl  0x8(%ebp)
  80384c:	6a 00                	push   $0x0
  80384e:	50                   	push   %eax
  80384f:	e8 b2 fb ff ff       	call   803406 <merging>
  803854:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803857:	e9 8b 00 00 00       	jmp    8038e7 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80385c:	a1 34 50 80 00       	mov    0x805034,%eax
  803861:	3b 45 08             	cmp    0x8(%ebp),%eax
  803864:	76 18                	jbe    80387e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803866:	a1 34 50 80 00       	mov    0x805034,%eax
  80386b:	83 ec 04             	sub    $0x4,%esp
  80386e:	ff 75 08             	pushl  0x8(%ebp)
  803871:	50                   	push   %eax
  803872:	6a 00                	push   $0x0
  803874:	e8 8d fb ff ff       	call   803406 <merging>
  803879:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80387c:	eb 69                	jmp    8038e7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80387e:	a1 34 50 80 00       	mov    0x805034,%eax
  803883:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803886:	eb 39                	jmp    8038c1 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80388e:	73 29                	jae    8038b9 <free_block+0x90>
  803890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803893:	8b 00                	mov    (%eax),%eax
  803895:	3b 45 08             	cmp    0x8(%ebp),%eax
  803898:	76 1f                	jbe    8038b9 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80389a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389d:	8b 00                	mov    (%eax),%eax
  80389f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8038a2:	83 ec 04             	sub    $0x4,%esp
  8038a5:	ff 75 08             	pushl  0x8(%ebp)
  8038a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8038ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8038ae:	e8 53 fb ff ff       	call   803406 <merging>
  8038b3:	83 c4 10             	add    $0x10,%esp
			break;
  8038b6:	90                   	nop
		}
	}
}
  8038b7:	eb 2e                	jmp    8038e7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8038b9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8038be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038c5:	74 07                	je     8038ce <free_block+0xa5>
  8038c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ca:	8b 00                	mov    (%eax),%eax
  8038cc:	eb 05                	jmp    8038d3 <free_block+0xaa>
  8038ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8038d3:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8038d8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8038dd:	85 c0                	test   %eax,%eax
  8038df:	75 a7                	jne    803888 <free_block+0x5f>
  8038e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038e5:	75 a1                	jne    803888 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038e7:	90                   	nop
  8038e8:	c9                   	leave  
  8038e9:	c3                   	ret    

008038ea <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8038ea:	55                   	push   %ebp
  8038eb:	89 e5                	mov    %esp,%ebp
  8038ed:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8038f0:	ff 75 08             	pushl  0x8(%ebp)
  8038f3:	e8 ed ec ff ff       	call   8025e5 <get_block_size>
  8038f8:	83 c4 04             	add    $0x4,%esp
  8038fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8038fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803905:	eb 17                	jmp    80391e <copy_data+0x34>
  803907:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80390a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80390d:	01 c2                	add    %eax,%edx
  80390f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803912:	8b 45 08             	mov    0x8(%ebp),%eax
  803915:	01 c8                	add    %ecx,%eax
  803917:	8a 00                	mov    (%eax),%al
  803919:	88 02                	mov    %al,(%edx)
  80391b:	ff 45 fc             	incl   -0x4(%ebp)
  80391e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803921:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803924:	72 e1                	jb     803907 <copy_data+0x1d>
}
  803926:	90                   	nop
  803927:	c9                   	leave  
  803928:	c3                   	ret    

00803929 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803929:	55                   	push   %ebp
  80392a:	89 e5                	mov    %esp,%ebp
  80392c:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80392f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803933:	75 23                	jne    803958 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803935:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803939:	74 13                	je     80394e <realloc_block_FF+0x25>
  80393b:	83 ec 0c             	sub    $0xc,%esp
  80393e:	ff 75 0c             	pushl  0xc(%ebp)
  803941:	e8 1f f0 ff ff       	call   802965 <alloc_block_FF>
  803946:	83 c4 10             	add    $0x10,%esp
  803949:	e9 f4 06 00 00       	jmp    804042 <realloc_block_FF+0x719>
		return NULL;
  80394e:	b8 00 00 00 00       	mov    $0x0,%eax
  803953:	e9 ea 06 00 00       	jmp    804042 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803958:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80395c:	75 18                	jne    803976 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80395e:	83 ec 0c             	sub    $0xc,%esp
  803961:	ff 75 08             	pushl  0x8(%ebp)
  803964:	e8 c0 fe ff ff       	call   803829 <free_block>
  803969:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80396c:	b8 00 00 00 00       	mov    $0x0,%eax
  803971:	e9 cc 06 00 00       	jmp    804042 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803976:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80397a:	77 07                	ja     803983 <realloc_block_FF+0x5a>
  80397c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803983:	8b 45 0c             	mov    0xc(%ebp),%eax
  803986:	83 e0 01             	and    $0x1,%eax
  803989:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80398c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80398f:	83 c0 08             	add    $0x8,%eax
  803992:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803995:	83 ec 0c             	sub    $0xc,%esp
  803998:	ff 75 08             	pushl  0x8(%ebp)
  80399b:	e8 45 ec ff ff       	call   8025e5 <get_block_size>
  8039a0:	83 c4 10             	add    $0x10,%esp
  8039a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8039a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039a9:	83 e8 08             	sub    $0x8,%eax
  8039ac:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8039af:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b2:	83 e8 04             	sub    $0x4,%eax
  8039b5:	8b 00                	mov    (%eax),%eax
  8039b7:	83 e0 fe             	and    $0xfffffffe,%eax
  8039ba:	89 c2                	mov    %eax,%edx
  8039bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bf:	01 d0                	add    %edx,%eax
  8039c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8039c4:	83 ec 0c             	sub    $0xc,%esp
  8039c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039ca:	e8 16 ec ff ff       	call   8025e5 <get_block_size>
  8039cf:	83 c4 10             	add    $0x10,%esp
  8039d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8039d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039d8:	83 e8 08             	sub    $0x8,%eax
  8039db:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8039de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039e4:	75 08                	jne    8039ee <realloc_block_FF+0xc5>
	{
		 return va;
  8039e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e9:	e9 54 06 00 00       	jmp    804042 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8039ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039f1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8039f4:	0f 83 e5 03 00 00    	jae    803ddf <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8039fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039fd:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a00:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803a03:	83 ec 0c             	sub    $0xc,%esp
  803a06:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a09:	e8 f0 eb ff ff       	call   8025fe <is_free_block>
  803a0e:	83 c4 10             	add    $0x10,%esp
  803a11:	84 c0                	test   %al,%al
  803a13:	0f 84 3b 01 00 00    	je     803b54 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803a19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a1c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a1f:	01 d0                	add    %edx,%eax
  803a21:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803a24:	83 ec 04             	sub    $0x4,%esp
  803a27:	6a 01                	push   $0x1
  803a29:	ff 75 f0             	pushl  -0x10(%ebp)
  803a2c:	ff 75 08             	pushl  0x8(%ebp)
  803a2f:	e8 02 ef ff ff       	call   802936 <set_block_data>
  803a34:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803a37:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3a:	83 e8 04             	sub    $0x4,%eax
  803a3d:	8b 00                	mov    (%eax),%eax
  803a3f:	83 e0 fe             	and    $0xfffffffe,%eax
  803a42:	89 c2                	mov    %eax,%edx
  803a44:	8b 45 08             	mov    0x8(%ebp),%eax
  803a47:	01 d0                	add    %edx,%eax
  803a49:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803a4c:	83 ec 04             	sub    $0x4,%esp
  803a4f:	6a 00                	push   $0x0
  803a51:	ff 75 cc             	pushl  -0x34(%ebp)
  803a54:	ff 75 c8             	pushl  -0x38(%ebp)
  803a57:	e8 da ee ff ff       	call   802936 <set_block_data>
  803a5c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a63:	74 06                	je     803a6b <realloc_block_FF+0x142>
  803a65:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803a69:	75 17                	jne    803a82 <realloc_block_FF+0x159>
  803a6b:	83 ec 04             	sub    $0x4,%esp
  803a6e:	68 64 4c 80 00       	push   $0x804c64
  803a73:	68 f6 01 00 00       	push   $0x1f6
  803a78:	68 f1 4b 80 00       	push   $0x804bf1
  803a7d:	e8 bb cc ff ff       	call   80073d <_panic>
  803a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a85:	8b 10                	mov    (%eax),%edx
  803a87:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a8a:	89 10                	mov    %edx,(%eax)
  803a8c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a8f:	8b 00                	mov    (%eax),%eax
  803a91:	85 c0                	test   %eax,%eax
  803a93:	74 0b                	je     803aa0 <realloc_block_FF+0x177>
  803a95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a98:	8b 00                	mov    (%eax),%eax
  803a9a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a9d:	89 50 04             	mov    %edx,0x4(%eax)
  803aa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803aa6:	89 10                	mov    %edx,(%eax)
  803aa8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803aab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aae:	89 50 04             	mov    %edx,0x4(%eax)
  803ab1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ab4:	8b 00                	mov    (%eax),%eax
  803ab6:	85 c0                	test   %eax,%eax
  803ab8:	75 08                	jne    803ac2 <realloc_block_FF+0x199>
  803aba:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803abd:	a3 38 50 80 00       	mov    %eax,0x805038
  803ac2:	a1 40 50 80 00       	mov    0x805040,%eax
  803ac7:	40                   	inc    %eax
  803ac8:	a3 40 50 80 00       	mov    %eax,0x805040
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ad1:	75 17                	jne    803aea <realloc_block_FF+0x1c1>
  803ad3:	83 ec 04             	sub    $0x4,%esp
  803ad6:	68 d3 4b 80 00       	push   $0x804bd3
  803adb:	68 f7 01 00 00       	push   $0x1f7
  803ae0:	68 f1 4b 80 00       	push   $0x804bf1
  803ae5:	e8 53 cc ff ff       	call   80073d <_panic>
  803aea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aed:	8b 00                	mov    (%eax),%eax
  803aef:	85 c0                	test   %eax,%eax
  803af1:	74 10                	je     803b03 <realloc_block_FF+0x1da>
  803af3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af6:	8b 00                	mov    (%eax),%eax
  803af8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803afb:	8b 52 04             	mov    0x4(%edx),%edx
  803afe:	89 50 04             	mov    %edx,0x4(%eax)
  803b01:	eb 0b                	jmp    803b0e <realloc_block_FF+0x1e5>
  803b03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b06:	8b 40 04             	mov    0x4(%eax),%eax
  803b09:	a3 38 50 80 00       	mov    %eax,0x805038
  803b0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b11:	8b 40 04             	mov    0x4(%eax),%eax
  803b14:	85 c0                	test   %eax,%eax
  803b16:	74 0f                	je     803b27 <realloc_block_FF+0x1fe>
  803b18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1b:	8b 40 04             	mov    0x4(%eax),%eax
  803b1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b21:	8b 12                	mov    (%edx),%edx
  803b23:	89 10                	mov    %edx,(%eax)
  803b25:	eb 0a                	jmp    803b31 <realloc_block_FF+0x208>
  803b27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b2a:	8b 00                	mov    (%eax),%eax
  803b2c:	a3 34 50 80 00       	mov    %eax,0x805034
  803b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b44:	a1 40 50 80 00       	mov    0x805040,%eax
  803b49:	48                   	dec    %eax
  803b4a:	a3 40 50 80 00       	mov    %eax,0x805040
  803b4f:	e9 83 02 00 00       	jmp    803dd7 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803b54:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803b58:	0f 86 69 02 00 00    	jbe    803dc7 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803b5e:	83 ec 04             	sub    $0x4,%esp
  803b61:	6a 01                	push   $0x1
  803b63:	ff 75 f0             	pushl  -0x10(%ebp)
  803b66:	ff 75 08             	pushl  0x8(%ebp)
  803b69:	e8 c8 ed ff ff       	call   802936 <set_block_data>
  803b6e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b71:	8b 45 08             	mov    0x8(%ebp),%eax
  803b74:	83 e8 04             	sub    $0x4,%eax
  803b77:	8b 00                	mov    (%eax),%eax
  803b79:	83 e0 fe             	and    $0xfffffffe,%eax
  803b7c:	89 c2                	mov    %eax,%edx
  803b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b81:	01 d0                	add    %edx,%eax
  803b83:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803b86:	a1 40 50 80 00       	mov    0x805040,%eax
  803b8b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803b8e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b92:	75 68                	jne    803bfc <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b94:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b98:	75 17                	jne    803bb1 <realloc_block_FF+0x288>
  803b9a:	83 ec 04             	sub    $0x4,%esp
  803b9d:	68 0c 4c 80 00       	push   $0x804c0c
  803ba2:	68 06 02 00 00       	push   $0x206
  803ba7:	68 f1 4b 80 00       	push   $0x804bf1
  803bac:	e8 8c cb ff ff       	call   80073d <_panic>
  803bb1:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803bb7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bba:	89 10                	mov    %edx,(%eax)
  803bbc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bbf:	8b 00                	mov    (%eax),%eax
  803bc1:	85 c0                	test   %eax,%eax
  803bc3:	74 0d                	je     803bd2 <realloc_block_FF+0x2a9>
  803bc5:	a1 34 50 80 00       	mov    0x805034,%eax
  803bca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bcd:	89 50 04             	mov    %edx,0x4(%eax)
  803bd0:	eb 08                	jmp    803bda <realloc_block_FF+0x2b1>
  803bd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bd5:	a3 38 50 80 00       	mov    %eax,0x805038
  803bda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bdd:	a3 34 50 80 00       	mov    %eax,0x805034
  803be2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bec:	a1 40 50 80 00       	mov    0x805040,%eax
  803bf1:	40                   	inc    %eax
  803bf2:	a3 40 50 80 00       	mov    %eax,0x805040
  803bf7:	e9 b0 01 00 00       	jmp    803dac <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803bfc:	a1 34 50 80 00       	mov    0x805034,%eax
  803c01:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c04:	76 68                	jbe    803c6e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c06:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c0a:	75 17                	jne    803c23 <realloc_block_FF+0x2fa>
  803c0c:	83 ec 04             	sub    $0x4,%esp
  803c0f:	68 0c 4c 80 00       	push   $0x804c0c
  803c14:	68 0b 02 00 00       	push   $0x20b
  803c19:	68 f1 4b 80 00       	push   $0x804bf1
  803c1e:	e8 1a cb ff ff       	call   80073d <_panic>
  803c23:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803c29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c2c:	89 10                	mov    %edx,(%eax)
  803c2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c31:	8b 00                	mov    (%eax),%eax
  803c33:	85 c0                	test   %eax,%eax
  803c35:	74 0d                	je     803c44 <realloc_block_FF+0x31b>
  803c37:	a1 34 50 80 00       	mov    0x805034,%eax
  803c3c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c3f:	89 50 04             	mov    %edx,0x4(%eax)
  803c42:	eb 08                	jmp    803c4c <realloc_block_FF+0x323>
  803c44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c47:	a3 38 50 80 00       	mov    %eax,0x805038
  803c4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c4f:	a3 34 50 80 00       	mov    %eax,0x805034
  803c54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c5e:	a1 40 50 80 00       	mov    0x805040,%eax
  803c63:	40                   	inc    %eax
  803c64:	a3 40 50 80 00       	mov    %eax,0x805040
  803c69:	e9 3e 01 00 00       	jmp    803dac <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803c6e:	a1 34 50 80 00       	mov    0x805034,%eax
  803c73:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c76:	73 68                	jae    803ce0 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c78:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c7c:	75 17                	jne    803c95 <realloc_block_FF+0x36c>
  803c7e:	83 ec 04             	sub    $0x4,%esp
  803c81:	68 40 4c 80 00       	push   $0x804c40
  803c86:	68 10 02 00 00       	push   $0x210
  803c8b:	68 f1 4b 80 00       	push   $0x804bf1
  803c90:	e8 a8 ca ff ff       	call   80073d <_panic>
  803c95:	8b 15 38 50 80 00    	mov    0x805038,%edx
  803c9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c9e:	89 50 04             	mov    %edx,0x4(%eax)
  803ca1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca4:	8b 40 04             	mov    0x4(%eax),%eax
  803ca7:	85 c0                	test   %eax,%eax
  803ca9:	74 0c                	je     803cb7 <realloc_block_FF+0x38e>
  803cab:	a1 38 50 80 00       	mov    0x805038,%eax
  803cb0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cb3:	89 10                	mov    %edx,(%eax)
  803cb5:	eb 08                	jmp    803cbf <realloc_block_FF+0x396>
  803cb7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cba:	a3 34 50 80 00       	mov    %eax,0x805034
  803cbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc2:	a3 38 50 80 00       	mov    %eax,0x805038
  803cc7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cd0:	a1 40 50 80 00       	mov    0x805040,%eax
  803cd5:	40                   	inc    %eax
  803cd6:	a3 40 50 80 00       	mov    %eax,0x805040
  803cdb:	e9 cc 00 00 00       	jmp    803dac <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803ce0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803ce7:	a1 34 50 80 00       	mov    0x805034,%eax
  803cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cef:	e9 8a 00 00 00       	jmp    803d7e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803cfa:	73 7a                	jae    803d76 <realloc_block_FF+0x44d>
  803cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cff:	8b 00                	mov    (%eax),%eax
  803d01:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d04:	73 70                	jae    803d76 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803d06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d0a:	74 06                	je     803d12 <realloc_block_FF+0x3e9>
  803d0c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d10:	75 17                	jne    803d29 <realloc_block_FF+0x400>
  803d12:	83 ec 04             	sub    $0x4,%esp
  803d15:	68 64 4c 80 00       	push   $0x804c64
  803d1a:	68 1a 02 00 00       	push   $0x21a
  803d1f:	68 f1 4b 80 00       	push   $0x804bf1
  803d24:	e8 14 ca ff ff       	call   80073d <_panic>
  803d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2c:	8b 10                	mov    (%eax),%edx
  803d2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d31:	89 10                	mov    %edx,(%eax)
  803d33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d36:	8b 00                	mov    (%eax),%eax
  803d38:	85 c0                	test   %eax,%eax
  803d3a:	74 0b                	je     803d47 <realloc_block_FF+0x41e>
  803d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3f:	8b 00                	mov    (%eax),%eax
  803d41:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d44:	89 50 04             	mov    %edx,0x4(%eax)
  803d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d4d:	89 10                	mov    %edx,(%eax)
  803d4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d55:	89 50 04             	mov    %edx,0x4(%eax)
  803d58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d5b:	8b 00                	mov    (%eax),%eax
  803d5d:	85 c0                	test   %eax,%eax
  803d5f:	75 08                	jne    803d69 <realloc_block_FF+0x440>
  803d61:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d64:	a3 38 50 80 00       	mov    %eax,0x805038
  803d69:	a1 40 50 80 00       	mov    0x805040,%eax
  803d6e:	40                   	inc    %eax
  803d6f:	a3 40 50 80 00       	mov    %eax,0x805040
							break;
  803d74:	eb 36                	jmp    803dac <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803d76:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d82:	74 07                	je     803d8b <realloc_block_FF+0x462>
  803d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d87:	8b 00                	mov    (%eax),%eax
  803d89:	eb 05                	jmp    803d90 <realloc_block_FF+0x467>
  803d8b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d90:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803d95:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d9a:	85 c0                	test   %eax,%eax
  803d9c:	0f 85 52 ff ff ff    	jne    803cf4 <realloc_block_FF+0x3cb>
  803da2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803da6:	0f 85 48 ff ff ff    	jne    803cf4 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803dac:	83 ec 04             	sub    $0x4,%esp
  803daf:	6a 00                	push   $0x0
  803db1:	ff 75 d8             	pushl  -0x28(%ebp)
  803db4:	ff 75 d4             	pushl  -0x2c(%ebp)
  803db7:	e8 7a eb ff ff       	call   802936 <set_block_data>
  803dbc:	83 c4 10             	add    $0x10,%esp
				return va;
  803dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc2:	e9 7b 02 00 00       	jmp    804042 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803dc7:	83 ec 0c             	sub    $0xc,%esp
  803dca:	68 e1 4c 80 00       	push   $0x804ce1
  803dcf:	e8 26 cc ff ff       	call   8009fa <cprintf>
  803dd4:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  803dda:	e9 63 02 00 00       	jmp    804042 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  803de2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803de5:	0f 86 4d 02 00 00    	jbe    804038 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803deb:	83 ec 0c             	sub    $0xc,%esp
  803dee:	ff 75 e4             	pushl  -0x1c(%ebp)
  803df1:	e8 08 e8 ff ff       	call   8025fe <is_free_block>
  803df6:	83 c4 10             	add    $0x10,%esp
  803df9:	84 c0                	test   %al,%al
  803dfb:	0f 84 37 02 00 00    	je     804038 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e04:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803e07:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803e0a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e0d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e10:	76 38                	jbe    803e4a <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803e12:	83 ec 0c             	sub    $0xc,%esp
  803e15:	ff 75 08             	pushl  0x8(%ebp)
  803e18:	e8 0c fa ff ff       	call   803829 <free_block>
  803e1d:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803e20:	83 ec 0c             	sub    $0xc,%esp
  803e23:	ff 75 0c             	pushl  0xc(%ebp)
  803e26:	e8 3a eb ff ff       	call   802965 <alloc_block_FF>
  803e2b:	83 c4 10             	add    $0x10,%esp
  803e2e:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803e31:	83 ec 08             	sub    $0x8,%esp
  803e34:	ff 75 c0             	pushl  -0x40(%ebp)
  803e37:	ff 75 08             	pushl  0x8(%ebp)
  803e3a:	e8 ab fa ff ff       	call   8038ea <copy_data>
  803e3f:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803e42:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803e45:	e9 f8 01 00 00       	jmp    804042 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803e4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e4d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803e50:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803e53:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803e57:	0f 87 a0 00 00 00    	ja     803efd <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803e5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e61:	75 17                	jne    803e7a <realloc_block_FF+0x551>
  803e63:	83 ec 04             	sub    $0x4,%esp
  803e66:	68 d3 4b 80 00       	push   $0x804bd3
  803e6b:	68 38 02 00 00       	push   $0x238
  803e70:	68 f1 4b 80 00       	push   $0x804bf1
  803e75:	e8 c3 c8 ff ff       	call   80073d <_panic>
  803e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e7d:	8b 00                	mov    (%eax),%eax
  803e7f:	85 c0                	test   %eax,%eax
  803e81:	74 10                	je     803e93 <realloc_block_FF+0x56a>
  803e83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e86:	8b 00                	mov    (%eax),%eax
  803e88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e8b:	8b 52 04             	mov    0x4(%edx),%edx
  803e8e:	89 50 04             	mov    %edx,0x4(%eax)
  803e91:	eb 0b                	jmp    803e9e <realloc_block_FF+0x575>
  803e93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e96:	8b 40 04             	mov    0x4(%eax),%eax
  803e99:	a3 38 50 80 00       	mov    %eax,0x805038
  803e9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea1:	8b 40 04             	mov    0x4(%eax),%eax
  803ea4:	85 c0                	test   %eax,%eax
  803ea6:	74 0f                	je     803eb7 <realloc_block_FF+0x58e>
  803ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eab:	8b 40 04             	mov    0x4(%eax),%eax
  803eae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803eb1:	8b 12                	mov    (%edx),%edx
  803eb3:	89 10                	mov    %edx,(%eax)
  803eb5:	eb 0a                	jmp    803ec1 <realloc_block_FF+0x598>
  803eb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eba:	8b 00                	mov    (%eax),%eax
  803ebc:	a3 34 50 80 00       	mov    %eax,0x805034
  803ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ecd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ed4:	a1 40 50 80 00       	mov    0x805040,%eax
  803ed9:	48                   	dec    %eax
  803eda:	a3 40 50 80 00       	mov    %eax,0x805040

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803edf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ee2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ee5:	01 d0                	add    %edx,%eax
  803ee7:	83 ec 04             	sub    $0x4,%esp
  803eea:	6a 01                	push   $0x1
  803eec:	50                   	push   %eax
  803eed:	ff 75 08             	pushl  0x8(%ebp)
  803ef0:	e8 41 ea ff ff       	call   802936 <set_block_data>
  803ef5:	83 c4 10             	add    $0x10,%esp
  803ef8:	e9 36 01 00 00       	jmp    804033 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803efd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f00:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f03:	01 d0                	add    %edx,%eax
  803f05:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803f08:	83 ec 04             	sub    $0x4,%esp
  803f0b:	6a 01                	push   $0x1
  803f0d:	ff 75 f0             	pushl  -0x10(%ebp)
  803f10:	ff 75 08             	pushl  0x8(%ebp)
  803f13:	e8 1e ea ff ff       	call   802936 <set_block_data>
  803f18:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f1e:	83 e8 04             	sub    $0x4,%eax
  803f21:	8b 00                	mov    (%eax),%eax
  803f23:	83 e0 fe             	and    $0xfffffffe,%eax
  803f26:	89 c2                	mov    %eax,%edx
  803f28:	8b 45 08             	mov    0x8(%ebp),%eax
  803f2b:	01 d0                	add    %edx,%eax
  803f2d:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803f30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f34:	74 06                	je     803f3c <realloc_block_FF+0x613>
  803f36:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803f3a:	75 17                	jne    803f53 <realloc_block_FF+0x62a>
  803f3c:	83 ec 04             	sub    $0x4,%esp
  803f3f:	68 64 4c 80 00       	push   $0x804c64
  803f44:	68 44 02 00 00       	push   $0x244
  803f49:	68 f1 4b 80 00       	push   $0x804bf1
  803f4e:	e8 ea c7 ff ff       	call   80073d <_panic>
  803f53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f56:	8b 10                	mov    (%eax),%edx
  803f58:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f5b:	89 10                	mov    %edx,(%eax)
  803f5d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f60:	8b 00                	mov    (%eax),%eax
  803f62:	85 c0                	test   %eax,%eax
  803f64:	74 0b                	je     803f71 <realloc_block_FF+0x648>
  803f66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f69:	8b 00                	mov    (%eax),%eax
  803f6b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f6e:	89 50 04             	mov    %edx,0x4(%eax)
  803f71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f74:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f77:	89 10                	mov    %edx,(%eax)
  803f79:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f7f:	89 50 04             	mov    %edx,0x4(%eax)
  803f82:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f85:	8b 00                	mov    (%eax),%eax
  803f87:	85 c0                	test   %eax,%eax
  803f89:	75 08                	jne    803f93 <realloc_block_FF+0x66a>
  803f8b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f8e:	a3 38 50 80 00       	mov    %eax,0x805038
  803f93:	a1 40 50 80 00       	mov    0x805040,%eax
  803f98:	40                   	inc    %eax
  803f99:	a3 40 50 80 00       	mov    %eax,0x805040
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803f9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fa2:	75 17                	jne    803fbb <realloc_block_FF+0x692>
  803fa4:	83 ec 04             	sub    $0x4,%esp
  803fa7:	68 d3 4b 80 00       	push   $0x804bd3
  803fac:	68 45 02 00 00       	push   $0x245
  803fb1:	68 f1 4b 80 00       	push   $0x804bf1
  803fb6:	e8 82 c7 ff ff       	call   80073d <_panic>
  803fbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fbe:	8b 00                	mov    (%eax),%eax
  803fc0:	85 c0                	test   %eax,%eax
  803fc2:	74 10                	je     803fd4 <realloc_block_FF+0x6ab>
  803fc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc7:	8b 00                	mov    (%eax),%eax
  803fc9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fcc:	8b 52 04             	mov    0x4(%edx),%edx
  803fcf:	89 50 04             	mov    %edx,0x4(%eax)
  803fd2:	eb 0b                	jmp    803fdf <realloc_block_FF+0x6b6>
  803fd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd7:	8b 40 04             	mov    0x4(%eax),%eax
  803fda:	a3 38 50 80 00       	mov    %eax,0x805038
  803fdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe2:	8b 40 04             	mov    0x4(%eax),%eax
  803fe5:	85 c0                	test   %eax,%eax
  803fe7:	74 0f                	je     803ff8 <realloc_block_FF+0x6cf>
  803fe9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fec:	8b 40 04             	mov    0x4(%eax),%eax
  803fef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ff2:	8b 12                	mov    (%edx),%edx
  803ff4:	89 10                	mov    %edx,(%eax)
  803ff6:	eb 0a                	jmp    804002 <realloc_block_FF+0x6d9>
  803ff8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ffb:	8b 00                	mov    (%eax),%eax
  803ffd:	a3 34 50 80 00       	mov    %eax,0x805034
  804002:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804005:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80400b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80400e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804015:	a1 40 50 80 00       	mov    0x805040,%eax
  80401a:	48                   	dec    %eax
  80401b:	a3 40 50 80 00       	mov    %eax,0x805040
				set_block_data(next_new_va, remaining_size, 0);
  804020:	83 ec 04             	sub    $0x4,%esp
  804023:	6a 00                	push   $0x0
  804025:	ff 75 bc             	pushl  -0x44(%ebp)
  804028:	ff 75 b8             	pushl  -0x48(%ebp)
  80402b:	e8 06 e9 ff ff       	call   802936 <set_block_data>
  804030:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804033:	8b 45 08             	mov    0x8(%ebp),%eax
  804036:	eb 0a                	jmp    804042 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804038:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80403f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804042:	c9                   	leave  
  804043:	c3                   	ret    

00804044 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804044:	55                   	push   %ebp
  804045:	89 e5                	mov    %esp,%ebp
  804047:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80404a:	83 ec 04             	sub    $0x4,%esp
  80404d:	68 e8 4c 80 00       	push   $0x804ce8
  804052:	68 58 02 00 00       	push   $0x258
  804057:	68 f1 4b 80 00       	push   $0x804bf1
  80405c:	e8 dc c6 ff ff       	call   80073d <_panic>

00804061 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804061:	55                   	push   %ebp
  804062:	89 e5                	mov    %esp,%ebp
  804064:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804067:	83 ec 04             	sub    $0x4,%esp
  80406a:	68 10 4d 80 00       	push   $0x804d10
  80406f:	68 61 02 00 00       	push   $0x261
  804074:	68 f1 4b 80 00       	push   $0x804bf1
  804079:	e8 bf c6 ff ff       	call   80073d <_panic>
  80407e:	66 90                	xchg   %ax,%ax

00804080 <__udivdi3>:
  804080:	55                   	push   %ebp
  804081:	57                   	push   %edi
  804082:	56                   	push   %esi
  804083:	53                   	push   %ebx
  804084:	83 ec 1c             	sub    $0x1c,%esp
  804087:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80408b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80408f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804093:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804097:	89 ca                	mov    %ecx,%edx
  804099:	89 f8                	mov    %edi,%eax
  80409b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80409f:	85 f6                	test   %esi,%esi
  8040a1:	75 2d                	jne    8040d0 <__udivdi3+0x50>
  8040a3:	39 cf                	cmp    %ecx,%edi
  8040a5:	77 65                	ja     80410c <__udivdi3+0x8c>
  8040a7:	89 fd                	mov    %edi,%ebp
  8040a9:	85 ff                	test   %edi,%edi
  8040ab:	75 0b                	jne    8040b8 <__udivdi3+0x38>
  8040ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8040b2:	31 d2                	xor    %edx,%edx
  8040b4:	f7 f7                	div    %edi
  8040b6:	89 c5                	mov    %eax,%ebp
  8040b8:	31 d2                	xor    %edx,%edx
  8040ba:	89 c8                	mov    %ecx,%eax
  8040bc:	f7 f5                	div    %ebp
  8040be:	89 c1                	mov    %eax,%ecx
  8040c0:	89 d8                	mov    %ebx,%eax
  8040c2:	f7 f5                	div    %ebp
  8040c4:	89 cf                	mov    %ecx,%edi
  8040c6:	89 fa                	mov    %edi,%edx
  8040c8:	83 c4 1c             	add    $0x1c,%esp
  8040cb:	5b                   	pop    %ebx
  8040cc:	5e                   	pop    %esi
  8040cd:	5f                   	pop    %edi
  8040ce:	5d                   	pop    %ebp
  8040cf:	c3                   	ret    
  8040d0:	39 ce                	cmp    %ecx,%esi
  8040d2:	77 28                	ja     8040fc <__udivdi3+0x7c>
  8040d4:	0f bd fe             	bsr    %esi,%edi
  8040d7:	83 f7 1f             	xor    $0x1f,%edi
  8040da:	75 40                	jne    80411c <__udivdi3+0x9c>
  8040dc:	39 ce                	cmp    %ecx,%esi
  8040de:	72 0a                	jb     8040ea <__udivdi3+0x6a>
  8040e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040e4:	0f 87 9e 00 00 00    	ja     804188 <__udivdi3+0x108>
  8040ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8040ef:	89 fa                	mov    %edi,%edx
  8040f1:	83 c4 1c             	add    $0x1c,%esp
  8040f4:	5b                   	pop    %ebx
  8040f5:	5e                   	pop    %esi
  8040f6:	5f                   	pop    %edi
  8040f7:	5d                   	pop    %ebp
  8040f8:	c3                   	ret    
  8040f9:	8d 76 00             	lea    0x0(%esi),%esi
  8040fc:	31 ff                	xor    %edi,%edi
  8040fe:	31 c0                	xor    %eax,%eax
  804100:	89 fa                	mov    %edi,%edx
  804102:	83 c4 1c             	add    $0x1c,%esp
  804105:	5b                   	pop    %ebx
  804106:	5e                   	pop    %esi
  804107:	5f                   	pop    %edi
  804108:	5d                   	pop    %ebp
  804109:	c3                   	ret    
  80410a:	66 90                	xchg   %ax,%ax
  80410c:	89 d8                	mov    %ebx,%eax
  80410e:	f7 f7                	div    %edi
  804110:	31 ff                	xor    %edi,%edi
  804112:	89 fa                	mov    %edi,%edx
  804114:	83 c4 1c             	add    $0x1c,%esp
  804117:	5b                   	pop    %ebx
  804118:	5e                   	pop    %esi
  804119:	5f                   	pop    %edi
  80411a:	5d                   	pop    %ebp
  80411b:	c3                   	ret    
  80411c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804121:	89 eb                	mov    %ebp,%ebx
  804123:	29 fb                	sub    %edi,%ebx
  804125:	89 f9                	mov    %edi,%ecx
  804127:	d3 e6                	shl    %cl,%esi
  804129:	89 c5                	mov    %eax,%ebp
  80412b:	88 d9                	mov    %bl,%cl
  80412d:	d3 ed                	shr    %cl,%ebp
  80412f:	89 e9                	mov    %ebp,%ecx
  804131:	09 f1                	or     %esi,%ecx
  804133:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804137:	89 f9                	mov    %edi,%ecx
  804139:	d3 e0                	shl    %cl,%eax
  80413b:	89 c5                	mov    %eax,%ebp
  80413d:	89 d6                	mov    %edx,%esi
  80413f:	88 d9                	mov    %bl,%cl
  804141:	d3 ee                	shr    %cl,%esi
  804143:	89 f9                	mov    %edi,%ecx
  804145:	d3 e2                	shl    %cl,%edx
  804147:	8b 44 24 08          	mov    0x8(%esp),%eax
  80414b:	88 d9                	mov    %bl,%cl
  80414d:	d3 e8                	shr    %cl,%eax
  80414f:	09 c2                	or     %eax,%edx
  804151:	89 d0                	mov    %edx,%eax
  804153:	89 f2                	mov    %esi,%edx
  804155:	f7 74 24 0c          	divl   0xc(%esp)
  804159:	89 d6                	mov    %edx,%esi
  80415b:	89 c3                	mov    %eax,%ebx
  80415d:	f7 e5                	mul    %ebp
  80415f:	39 d6                	cmp    %edx,%esi
  804161:	72 19                	jb     80417c <__udivdi3+0xfc>
  804163:	74 0b                	je     804170 <__udivdi3+0xf0>
  804165:	89 d8                	mov    %ebx,%eax
  804167:	31 ff                	xor    %edi,%edi
  804169:	e9 58 ff ff ff       	jmp    8040c6 <__udivdi3+0x46>
  80416e:	66 90                	xchg   %ax,%ax
  804170:	8b 54 24 08          	mov    0x8(%esp),%edx
  804174:	89 f9                	mov    %edi,%ecx
  804176:	d3 e2                	shl    %cl,%edx
  804178:	39 c2                	cmp    %eax,%edx
  80417a:	73 e9                	jae    804165 <__udivdi3+0xe5>
  80417c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80417f:	31 ff                	xor    %edi,%edi
  804181:	e9 40 ff ff ff       	jmp    8040c6 <__udivdi3+0x46>
  804186:	66 90                	xchg   %ax,%ax
  804188:	31 c0                	xor    %eax,%eax
  80418a:	e9 37 ff ff ff       	jmp    8040c6 <__udivdi3+0x46>
  80418f:	90                   	nop

00804190 <__umoddi3>:
  804190:	55                   	push   %ebp
  804191:	57                   	push   %edi
  804192:	56                   	push   %esi
  804193:	53                   	push   %ebx
  804194:	83 ec 1c             	sub    $0x1c,%esp
  804197:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80419b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80419f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8041a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8041ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8041af:	89 f3                	mov    %esi,%ebx
  8041b1:	89 fa                	mov    %edi,%edx
  8041b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041b7:	89 34 24             	mov    %esi,(%esp)
  8041ba:	85 c0                	test   %eax,%eax
  8041bc:	75 1a                	jne    8041d8 <__umoddi3+0x48>
  8041be:	39 f7                	cmp    %esi,%edi
  8041c0:	0f 86 a2 00 00 00    	jbe    804268 <__umoddi3+0xd8>
  8041c6:	89 c8                	mov    %ecx,%eax
  8041c8:	89 f2                	mov    %esi,%edx
  8041ca:	f7 f7                	div    %edi
  8041cc:	89 d0                	mov    %edx,%eax
  8041ce:	31 d2                	xor    %edx,%edx
  8041d0:	83 c4 1c             	add    $0x1c,%esp
  8041d3:	5b                   	pop    %ebx
  8041d4:	5e                   	pop    %esi
  8041d5:	5f                   	pop    %edi
  8041d6:	5d                   	pop    %ebp
  8041d7:	c3                   	ret    
  8041d8:	39 f0                	cmp    %esi,%eax
  8041da:	0f 87 ac 00 00 00    	ja     80428c <__umoddi3+0xfc>
  8041e0:	0f bd e8             	bsr    %eax,%ebp
  8041e3:	83 f5 1f             	xor    $0x1f,%ebp
  8041e6:	0f 84 ac 00 00 00    	je     804298 <__umoddi3+0x108>
  8041ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8041f1:	29 ef                	sub    %ebp,%edi
  8041f3:	89 fe                	mov    %edi,%esi
  8041f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041f9:	89 e9                	mov    %ebp,%ecx
  8041fb:	d3 e0                	shl    %cl,%eax
  8041fd:	89 d7                	mov    %edx,%edi
  8041ff:	89 f1                	mov    %esi,%ecx
  804201:	d3 ef                	shr    %cl,%edi
  804203:	09 c7                	or     %eax,%edi
  804205:	89 e9                	mov    %ebp,%ecx
  804207:	d3 e2                	shl    %cl,%edx
  804209:	89 14 24             	mov    %edx,(%esp)
  80420c:	89 d8                	mov    %ebx,%eax
  80420e:	d3 e0                	shl    %cl,%eax
  804210:	89 c2                	mov    %eax,%edx
  804212:	8b 44 24 08          	mov    0x8(%esp),%eax
  804216:	d3 e0                	shl    %cl,%eax
  804218:	89 44 24 04          	mov    %eax,0x4(%esp)
  80421c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804220:	89 f1                	mov    %esi,%ecx
  804222:	d3 e8                	shr    %cl,%eax
  804224:	09 d0                	or     %edx,%eax
  804226:	d3 eb                	shr    %cl,%ebx
  804228:	89 da                	mov    %ebx,%edx
  80422a:	f7 f7                	div    %edi
  80422c:	89 d3                	mov    %edx,%ebx
  80422e:	f7 24 24             	mull   (%esp)
  804231:	89 c6                	mov    %eax,%esi
  804233:	89 d1                	mov    %edx,%ecx
  804235:	39 d3                	cmp    %edx,%ebx
  804237:	0f 82 87 00 00 00    	jb     8042c4 <__umoddi3+0x134>
  80423d:	0f 84 91 00 00 00    	je     8042d4 <__umoddi3+0x144>
  804243:	8b 54 24 04          	mov    0x4(%esp),%edx
  804247:	29 f2                	sub    %esi,%edx
  804249:	19 cb                	sbb    %ecx,%ebx
  80424b:	89 d8                	mov    %ebx,%eax
  80424d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804251:	d3 e0                	shl    %cl,%eax
  804253:	89 e9                	mov    %ebp,%ecx
  804255:	d3 ea                	shr    %cl,%edx
  804257:	09 d0                	or     %edx,%eax
  804259:	89 e9                	mov    %ebp,%ecx
  80425b:	d3 eb                	shr    %cl,%ebx
  80425d:	89 da                	mov    %ebx,%edx
  80425f:	83 c4 1c             	add    $0x1c,%esp
  804262:	5b                   	pop    %ebx
  804263:	5e                   	pop    %esi
  804264:	5f                   	pop    %edi
  804265:	5d                   	pop    %ebp
  804266:	c3                   	ret    
  804267:	90                   	nop
  804268:	89 fd                	mov    %edi,%ebp
  80426a:	85 ff                	test   %edi,%edi
  80426c:	75 0b                	jne    804279 <__umoddi3+0xe9>
  80426e:	b8 01 00 00 00       	mov    $0x1,%eax
  804273:	31 d2                	xor    %edx,%edx
  804275:	f7 f7                	div    %edi
  804277:	89 c5                	mov    %eax,%ebp
  804279:	89 f0                	mov    %esi,%eax
  80427b:	31 d2                	xor    %edx,%edx
  80427d:	f7 f5                	div    %ebp
  80427f:	89 c8                	mov    %ecx,%eax
  804281:	f7 f5                	div    %ebp
  804283:	89 d0                	mov    %edx,%eax
  804285:	e9 44 ff ff ff       	jmp    8041ce <__umoddi3+0x3e>
  80428a:	66 90                	xchg   %ax,%ax
  80428c:	89 c8                	mov    %ecx,%eax
  80428e:	89 f2                	mov    %esi,%edx
  804290:	83 c4 1c             	add    $0x1c,%esp
  804293:	5b                   	pop    %ebx
  804294:	5e                   	pop    %esi
  804295:	5f                   	pop    %edi
  804296:	5d                   	pop    %ebp
  804297:	c3                   	ret    
  804298:	3b 04 24             	cmp    (%esp),%eax
  80429b:	72 06                	jb     8042a3 <__umoddi3+0x113>
  80429d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042a1:	77 0f                	ja     8042b2 <__umoddi3+0x122>
  8042a3:	89 f2                	mov    %esi,%edx
  8042a5:	29 f9                	sub    %edi,%ecx
  8042a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8042ab:	89 14 24             	mov    %edx,(%esp)
  8042ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8042b6:	8b 14 24             	mov    (%esp),%edx
  8042b9:	83 c4 1c             	add    $0x1c,%esp
  8042bc:	5b                   	pop    %ebx
  8042bd:	5e                   	pop    %esi
  8042be:	5f                   	pop    %edi
  8042bf:	5d                   	pop    %ebp
  8042c0:	c3                   	ret    
  8042c1:	8d 76 00             	lea    0x0(%esi),%esi
  8042c4:	2b 04 24             	sub    (%esp),%eax
  8042c7:	19 fa                	sbb    %edi,%edx
  8042c9:	89 d1                	mov    %edx,%ecx
  8042cb:	89 c6                	mov    %eax,%esi
  8042cd:	e9 71 ff ff ff       	jmp    804243 <__umoddi3+0xb3>
  8042d2:	66 90                	xchg   %ax,%ax
  8042d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042d8:	72 ea                	jb     8042c4 <__umoddi3+0x134>
  8042da:	89 d9                	mov    %ebx,%ecx
  8042dc:	e9 62 ff ff ff       	jmp    804243 <__umoddi3+0xb3>
