
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
  800041:	e8 33 1e 00 00       	call   801e79 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 41 80 00       	push   $0x804140
  80004e:	e8 a7 09 00 00       	call   8009fa <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 41 80 00       	push   $0x804142
  80005e:	e8 97 09 00 00       	call   8009fa <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 5b 41 80 00       	push   $0x80415b
  80006e:	e8 87 09 00 00       	call   8009fa <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 41 80 00       	push   $0x804142
  80007e:	e8 77 09 00 00       	call   8009fa <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 41 80 00       	push   $0x804140
  80008e:	e8 67 09 00 00       	call   8009fa <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 74 41 80 00       	push   $0x804174
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
  8000c9:	68 94 41 80 00       	push   $0x804194
  8000ce:	e8 27 09 00 00       	call   8009fa <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 b6 41 80 00       	push   $0x8041b6
  8000de:	e8 17 09 00 00       	call   8009fa <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 c4 41 80 00       	push   $0x8041c4
  8000ee:	e8 07 09 00 00       	call   8009fa <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 d3 41 80 00       	push   $0x8041d3
  8000fe:	e8 f7 08 00 00       	call   8009fa <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 e3 41 80 00       	push   $0x8041e3
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
  80014d:	e8 41 1d 00 00       	call   801e93 <sys_unlock_cons>
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
  8001d5:	e8 9f 1c 00 00       	call   801e79 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 ec 41 80 00       	push   $0x8041ec
  8001e2:	e8 13 08 00 00       	call   8009fa <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 a4 1c 00 00       	call   801e93 <sys_unlock_cons>
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
  80020c:	68 20 42 80 00       	push   $0x804220
  800211:	6a 54                	push   $0x54
  800213:	68 42 42 80 00       	push   $0x804242
  800218:	e8 20 05 00 00       	call   80073d <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 57 1c 00 00       	call   801e79 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 5c 42 80 00       	push   $0x80425c
  80022a:	e8 cb 07 00 00       	call   8009fa <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 90 42 80 00       	push   $0x804290
  80023a:	e8 bb 07 00 00       	call   8009fa <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 c4 42 80 00       	push   $0x8042c4
  80024a:	e8 ab 07 00 00       	call   8009fa <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 3c 1c 00 00       	call   801e93 <sys_unlock_cons>


		}

		//		sys_lock_cons();
		sys_lock_cons();
  800257:	e8 1d 1c 00 00       	call   801e79 <sys_lock_cons>
		{
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 f6 42 80 00       	push   $0x8042f6
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
  8002b0:	e8 de 1b 00 00       	call   801e93 <sys_unlock_cons>
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
  800562:	68 40 41 80 00       	push   $0x804140
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
  800584:	68 14 43 80 00       	push   $0x804314
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
  8005b2:	68 19 43 80 00       	push   $0x804319
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
  8005d6:	e8 e9 19 00 00       	call   801fc4 <sys_cputc>
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
  8005e7:	e8 74 18 00 00       	call   801e60 <sys_cgetc>
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
  800604:	e8 ec 1a 00 00       	call   8020f5 <sys_getenvindex>
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
  800672:	e8 02 18 00 00       	call   801e79 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800677:	83 ec 0c             	sub    $0xc,%esp
  80067a:	68 38 43 80 00       	push   $0x804338
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
  8006a2:	68 60 43 80 00       	push   $0x804360
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
  8006d3:	68 88 43 80 00       	push   $0x804388
  8006d8:	e8 1d 03 00 00       	call   8009fa <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006e0:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	50                   	push   %eax
  8006ef:	68 e0 43 80 00       	push   $0x8043e0
  8006f4:	e8 01 03 00 00       	call   8009fa <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	68 38 43 80 00       	push   $0x804338
  800704:	e8 f1 02 00 00       	call   8009fa <cprintf>
  800709:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80070c:	e8 82 17 00 00       	call   801e93 <sys_unlock_cons>
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
  800724:	e8 98 19 00 00       	call   8020c1 <sys_destroy_env>
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
  800735:	e8 ed 19 00 00       	call   802127 <sys_exit_env>
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
  80075e:	68 f4 43 80 00       	push   $0x8043f4
  800763:	e8 92 02 00 00       	call   8009fa <cprintf>
  800768:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80076b:	a1 00 50 80 00       	mov    0x805000,%eax
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	ff 75 08             	pushl  0x8(%ebp)
  800776:	50                   	push   %eax
  800777:	68 f9 43 80 00       	push   $0x8043f9
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
  80079b:	68 15 44 80 00       	push   $0x804415
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
  8007ca:	68 18 44 80 00       	push   $0x804418
  8007cf:	6a 26                	push   $0x26
  8007d1:	68 64 44 80 00       	push   $0x804464
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
  80089f:	68 70 44 80 00       	push   $0x804470
  8008a4:	6a 3a                	push   $0x3a
  8008a6:	68 64 44 80 00       	push   $0x804464
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
  800912:	68 c4 44 80 00       	push   $0x8044c4
  800917:	6a 44                	push   $0x44
  800919:	68 64 44 80 00       	push   $0x804464
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
  80096c:	e8 c6 14 00 00       	call   801e37 <sys_cputs>
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
  8009e3:	e8 4f 14 00 00       	call   801e37 <sys_cputs>
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
  800a2d:	e8 47 14 00 00       	call   801e79 <sys_lock_cons>
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
  800a4d:	e8 41 14 00 00       	call   801e93 <sys_unlock_cons>
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
  800a97:	e8 34 34 00 00       	call   803ed0 <__udivdi3>
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
  800ae7:	e8 f4 34 00 00       	call   803fe0 <__umoddi3>
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	05 34 47 80 00       	add    $0x804734,%eax
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
  800c42:	8b 04 85 58 47 80 00 	mov    0x804758(,%eax,4),%eax
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
  800d23:	8b 34 9d a0 45 80 00 	mov    0x8045a0(,%ebx,4),%esi
  800d2a:	85 f6                	test   %esi,%esi
  800d2c:	75 19                	jne    800d47 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d2e:	53                   	push   %ebx
  800d2f:	68 45 47 80 00       	push   $0x804745
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
  800d48:	68 4e 47 80 00       	push   $0x80474e
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
  800d75:	be 51 47 80 00       	mov    $0x804751,%esi
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
  8010a0:	68 c8 48 80 00       	push   $0x8048c8
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
  8010e2:	68 cb 48 80 00       	push   $0x8048cb
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
  801193:	e8 e1 0c 00 00       	call   801e79 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801198:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80119c:	74 13                	je     8011b1 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	ff 75 08             	pushl  0x8(%ebp)
  8011a4:	68 c8 48 80 00       	push   $0x8048c8
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
  8011e6:	68 cb 48 80 00       	push   $0x8048cb
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
  80128e:	e8 00 0c 00 00       	call   801e93 <sys_unlock_cons>
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
  801988:	68 dc 48 80 00       	push   $0x8048dc
  80198d:	68 3f 01 00 00       	push   $0x13f
  801992:	68 fe 48 80 00       	push   $0x8048fe
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
  8019a8:	e8 35 0a 00 00       	call   8023e2 <sys_sbrk>
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
  801a23:	e8 3e 08 00 00       	call   802266 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	74 16                	je     801a42 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a2c:	83 ec 0c             	sub    $0xc,%esp
  801a2f:	ff 75 08             	pushl  0x8(%ebp)
  801a32:	e8 7e 0d 00 00       	call   8027b5 <alloc_block_FF>
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a3d:	e9 8a 01 00 00       	jmp    801bcc <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801a42:	e8 50 08 00 00       	call   802297 <sys_isUHeapPlacementStrategyBESTFIT>
  801a47:	85 c0                	test   %eax,%eax
  801a49:	0f 84 7d 01 00 00    	je     801bcc <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	e8 17 12 00 00       	call   802c71 <alloc_block_BF>
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
  801aa5:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801af2:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801b49:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  801bab:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801bb2:	83 ec 08             	sub    $0x8,%esp
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	ff 75 f0             	pushl  -0x10(%ebp)
  801bbb:	e8 59 08 00 00       	call   802419 <sys_allocate_user_mem>
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
  801c03:	e8 2d 08 00 00       	call   802435 <get_block_size>
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c0e:	83 ec 0c             	sub    $0xc,%esp
  801c11:	ff 75 08             	pushl  0x8(%ebp)
  801c14:	e8 60 1a 00 00       	call   803679 <free_block>
  801c19:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
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
  801c4e:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801c55:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801c58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c5b:	c1 e0 0c             	shl    $0xc,%eax
  801c5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801c61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801c68:	eb 2f                	jmp    801c99 <free+0xc8>
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
  801c8b:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  801c92:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801c96:	ff 45 f4             	incl   -0xc(%ebp)
  801c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c9f:	72 c9                	jb     801c6a <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	83 ec 08             	sub    $0x8,%esp
  801ca7:	ff 75 ec             	pushl  -0x14(%ebp)
  801caa:	50                   	push   %eax
  801cab:	e8 4d 07 00 00       	call   8023fd <sys_free_user_mem>
  801cb0:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801cb3:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801cb4:	eb 17                	jmp    801ccd <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801cb6:	83 ec 04             	sub    $0x4,%esp
  801cb9:	68 0c 49 80 00       	push   $0x80490c
  801cbe:	68 84 00 00 00       	push   $0x84
  801cc3:	68 36 49 80 00       	push   $0x804936
  801cc8:	e8 70 ea ff ff       	call   80073d <_panic>
	}
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 28             	sub    $0x28,%esp
  801cd5:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd8:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801cdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cdf:	75 07                	jne    801ce8 <smalloc+0x19>
  801ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce6:	eb 74                	jmp    801d5c <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cee:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801cf5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfb:	39 d0                	cmp    %edx,%eax
  801cfd:	73 02                	jae    801d01 <smalloc+0x32>
  801cff:	89 d0                	mov    %edx,%eax
  801d01:	83 ec 0c             	sub    $0xc,%esp
  801d04:	50                   	push   %eax
  801d05:	e8 a8 fc ff ff       	call   8019b2 <malloc>
  801d0a:	83 c4 10             	add    $0x10,%esp
  801d0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801d10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d14:	75 07                	jne    801d1d <smalloc+0x4e>
  801d16:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1b:	eb 3f                	jmp    801d5c <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d1d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d21:	ff 75 ec             	pushl  -0x14(%ebp)
  801d24:	50                   	push   %eax
  801d25:	ff 75 0c             	pushl  0xc(%ebp)
  801d28:	ff 75 08             	pushl  0x8(%ebp)
  801d2b:	e8 d4 02 00 00       	call   802004 <sys_createSharedObject>
  801d30:	83 c4 10             	add    $0x10,%esp
  801d33:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801d36:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801d3a:	74 06                	je     801d42 <smalloc+0x73>
  801d3c:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801d40:	75 07                	jne    801d49 <smalloc+0x7a>
  801d42:	b8 00 00 00 00       	mov    $0x0,%eax
  801d47:	eb 13                	jmp    801d5c <smalloc+0x8d>
	 cprintf("153\n");
  801d49:	83 ec 0c             	sub    $0xc,%esp
  801d4c:	68 42 49 80 00       	push   $0x804942
  801d51:	e8 a4 ec ff ff       	call   8009fa <cprintf>
  801d56:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801d59:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801d64:	83 ec 04             	sub    $0x4,%esp
  801d67:	68 48 49 80 00       	push   $0x804948
  801d6c:	68 a4 00 00 00       	push   $0xa4
  801d71:	68 36 49 80 00       	push   $0x804936
  801d76:	e8 c2 e9 ff ff       	call   80073d <_panic>

00801d7b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d81:	83 ec 04             	sub    $0x4,%esp
  801d84:	68 6c 49 80 00       	push   $0x80496c
  801d89:	68 bc 00 00 00       	push   $0xbc
  801d8e:	68 36 49 80 00       	push   $0x804936
  801d93:	e8 a5 e9 ff ff       	call   80073d <_panic>

00801d98 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d9e:	83 ec 04             	sub    $0x4,%esp
  801da1:	68 90 49 80 00       	push   $0x804990
  801da6:	68 d3 00 00 00       	push   $0xd3
  801dab:	68 36 49 80 00       	push   $0x804936
  801db0:	e8 88 e9 ff ff       	call   80073d <_panic>

00801db5 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dbb:	83 ec 04             	sub    $0x4,%esp
  801dbe:	68 b6 49 80 00       	push   $0x8049b6
  801dc3:	68 df 00 00 00       	push   $0xdf
  801dc8:	68 36 49 80 00       	push   $0x804936
  801dcd:	e8 6b e9 ff ff       	call   80073d <_panic>

00801dd2 <shrink>:

}
void shrink(uint32 newSize)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dd8:	83 ec 04             	sub    $0x4,%esp
  801ddb:	68 b6 49 80 00       	push   $0x8049b6
  801de0:	68 e4 00 00 00       	push   $0xe4
  801de5:	68 36 49 80 00       	push   $0x804936
  801dea:	e8 4e e9 ff ff       	call   80073d <_panic>

00801def <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801df5:	83 ec 04             	sub    $0x4,%esp
  801df8:	68 b6 49 80 00       	push   $0x8049b6
  801dfd:	68 e9 00 00 00       	push   $0xe9
  801e02:	68 36 49 80 00       	push   $0x804936
  801e07:	e8 31 e9 ff ff       	call   80073d <_panic>

00801e0c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	57                   	push   %edi
  801e10:	56                   	push   %esi
  801e11:	53                   	push   %ebx
  801e12:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e15:	8b 45 08             	mov    0x8(%ebp),%eax
  801e18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e1e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e21:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e24:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e27:	cd 30                	int    $0x30
  801e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	5b                   	pop    %ebx
  801e33:	5e                   	pop    %esi
  801e34:	5f                   	pop    %edi
  801e35:	5d                   	pop    %ebp
  801e36:	c3                   	ret    

00801e37 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e40:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e43:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	52                   	push   %edx
  801e4f:	ff 75 0c             	pushl  0xc(%ebp)
  801e52:	50                   	push   %eax
  801e53:	6a 00                	push   $0x0
  801e55:	e8 b2 ff ff ff       	call   801e0c <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	90                   	nop
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 02                	push   $0x2
  801e6f:	e8 98 ff ff ff       	call   801e0c <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 03                	push   $0x3
  801e88:	e8 7f ff ff ff       	call   801e0c <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
}
  801e90:	90                   	nop
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 04                	push   $0x4
  801ea2:	e8 65 ff ff ff       	call   801e0c <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	90                   	nop
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	52                   	push   %edx
  801ebd:	50                   	push   %eax
  801ebe:	6a 08                	push   $0x8
  801ec0:	e8 47 ff ff ff       	call   801e0c <syscall>
  801ec5:	83 c4 18             	add    $0x18,%esp
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	56                   	push   %esi
  801ece:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ecf:	8b 75 18             	mov    0x18(%ebp),%esi
  801ed2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ed5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	56                   	push   %esi
  801edf:	53                   	push   %ebx
  801ee0:	51                   	push   %ecx
  801ee1:	52                   	push   %edx
  801ee2:	50                   	push   %eax
  801ee3:	6a 09                	push   $0x9
  801ee5:	e8 22 ff ff ff       	call   801e0c <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
}
  801eed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ef0:	5b                   	pop    %ebx
  801ef1:	5e                   	pop    %esi
  801ef2:	5d                   	pop    %ebp
  801ef3:	c3                   	ret    

00801ef4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ef7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efa:	8b 45 08             	mov    0x8(%ebp),%eax
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	52                   	push   %edx
  801f04:	50                   	push   %eax
  801f05:	6a 0a                	push   $0xa
  801f07:	e8 00 ff ff ff       	call   801e0c <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	ff 75 0c             	pushl  0xc(%ebp)
  801f1d:	ff 75 08             	pushl  0x8(%ebp)
  801f20:	6a 0b                	push   $0xb
  801f22:	e8 e5 fe ff ff       	call   801e0c <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 0c                	push   $0xc
  801f3b:	e8 cc fe ff ff       	call   801e0c <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 0d                	push   $0xd
  801f54:	e8 b3 fe ff ff       	call   801e0c <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 0e                	push   $0xe
  801f6d:	e8 9a fe ff ff       	call   801e0c <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 0f                	push   $0xf
  801f86:	e8 81 fe ff ff       	call   801e0c <syscall>
  801f8b:	83 c4 18             	add    $0x18,%esp
}
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	ff 75 08             	pushl  0x8(%ebp)
  801f9e:	6a 10                	push   $0x10
  801fa0:	e8 67 fe ff ff       	call   801e0c <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sys_scarce_memory>:

void sys_scarce_memory()
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 11                	push   $0x11
  801fb9:	e8 4e fe ff ff       	call   801e0c <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
}
  801fc1:	90                   	nop
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <sys_cputc>:

void
sys_cputc(const char c)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 04             	sub    $0x4,%esp
  801fca:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fd0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	50                   	push   %eax
  801fdd:	6a 01                	push   $0x1
  801fdf:	e8 28 fe ff ff       	call   801e0c <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
}
  801fe7:	90                   	nop
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 14                	push   $0x14
  801ff9:	e8 0e fe ff ff       	call   801e0c <syscall>
  801ffe:	83 c4 18             	add    $0x18,%esp
}
  802001:	90                   	nop
  802002:	c9                   	leave  
  802003:	c3                   	ret    

00802004 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 04             	sub    $0x4,%esp
  80200a:	8b 45 10             	mov    0x10(%ebp),%eax
  80200d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802010:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802013:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	6a 00                	push   $0x0
  80201c:	51                   	push   %ecx
  80201d:	52                   	push   %edx
  80201e:	ff 75 0c             	pushl  0xc(%ebp)
  802021:	50                   	push   %eax
  802022:	6a 15                	push   $0x15
  802024:	e8 e3 fd ff ff       	call   801e0c <syscall>
  802029:	83 c4 18             	add    $0x18,%esp
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802031:	8b 55 0c             	mov    0xc(%ebp),%edx
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	52                   	push   %edx
  80203e:	50                   	push   %eax
  80203f:	6a 16                	push   $0x16
  802041:	e8 c6 fd ff ff       	call   801e0c <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80204e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802051:	8b 55 0c             	mov    0xc(%ebp),%edx
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	51                   	push   %ecx
  80205c:	52                   	push   %edx
  80205d:	50                   	push   %eax
  80205e:	6a 17                	push   $0x17
  802060:	e8 a7 fd ff ff       	call   801e0c <syscall>
  802065:	83 c4 18             	add    $0x18,%esp
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80206d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	52                   	push   %edx
  80207a:	50                   	push   %eax
  80207b:	6a 18                	push   $0x18
  80207d:	e8 8a fd ff ff       	call   801e0c <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	6a 00                	push   $0x0
  80208f:	ff 75 14             	pushl  0x14(%ebp)
  802092:	ff 75 10             	pushl  0x10(%ebp)
  802095:	ff 75 0c             	pushl  0xc(%ebp)
  802098:	50                   	push   %eax
  802099:	6a 19                	push   $0x19
  80209b:	e8 6c fd ff ff       	call   801e0c <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	50                   	push   %eax
  8020b4:	6a 1a                	push   $0x1a
  8020b6:	e8 51 fd ff ff       	call   801e0c <syscall>
  8020bb:	83 c4 18             	add    $0x18,%esp
}
  8020be:	90                   	nop
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	50                   	push   %eax
  8020d0:	6a 1b                	push   $0x1b
  8020d2:	e8 35 fd ff ff       	call   801e0c <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 05                	push   $0x5
  8020eb:	e8 1c fd ff ff       	call   801e0c <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 06                	push   $0x6
  802104:	e8 03 fd ff ff       	call   801e0c <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 07                	push   $0x7
  80211d:	e8 ea fc ff ff       	call   801e0c <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_exit_env>:


void sys_exit_env(void)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 1c                	push   $0x1c
  802136:	e8 d1 fc ff ff       	call   801e0c <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
}
  80213e:	90                   	nop
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802147:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80214a:	8d 50 04             	lea    0x4(%eax),%edx
  80214d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	52                   	push   %edx
  802157:	50                   	push   %eax
  802158:	6a 1d                	push   $0x1d
  80215a:	e8 ad fc ff ff       	call   801e0c <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
	return result;
  802162:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802165:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802168:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80216b:	89 01                	mov    %eax,(%ecx)
  80216d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	c9                   	leave  
  802174:	c2 04 00             	ret    $0x4

00802177 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	ff 75 10             	pushl  0x10(%ebp)
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	6a 13                	push   $0x13
  802189:	e8 7e fc ff ff       	call   801e0c <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
	return ;
  802191:	90                   	nop
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <sys_rcr2>:
uint32 sys_rcr2()
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 1e                	push   $0x1e
  8021a3:	e8 64 fc ff ff       	call   801e0c <syscall>
  8021a8:	83 c4 18             	add    $0x18,%esp
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	83 ec 04             	sub    $0x4,%esp
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021b9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	50                   	push   %eax
  8021c6:	6a 1f                	push   $0x1f
  8021c8:	e8 3f fc ff ff       	call   801e0c <syscall>
  8021cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d0:	90                   	nop
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <rsttst>:
void rsttst()
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 21                	push   $0x21
  8021e2:	e8 25 fc ff ff       	call   801e0c <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ea:	90                   	nop
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 04             	sub    $0x4,%esp
  8021f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021f9:	8b 55 18             	mov    0x18(%ebp),%edx
  8021fc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802200:	52                   	push   %edx
  802201:	50                   	push   %eax
  802202:	ff 75 10             	pushl  0x10(%ebp)
  802205:	ff 75 0c             	pushl  0xc(%ebp)
  802208:	ff 75 08             	pushl  0x8(%ebp)
  80220b:	6a 20                	push   $0x20
  80220d:	e8 fa fb ff ff       	call   801e0c <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
	return ;
  802215:	90                   	nop
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <chktst>:
void chktst(uint32 n)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	ff 75 08             	pushl  0x8(%ebp)
  802226:	6a 22                	push   $0x22
  802228:	e8 df fb ff ff       	call   801e0c <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
	return ;
  802230:	90                   	nop
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <inctst>:

void inctst()
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 23                	push   $0x23
  802242:	e8 c5 fb ff ff       	call   801e0c <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
	return ;
  80224a:	90                   	nop
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <gettst>:
uint32 gettst()
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 24                	push   $0x24
  80225c:	e8 ab fb ff ff       	call   801e0c <syscall>
  802261:	83 c4 18             	add    $0x18,%esp
}
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 25                	push   $0x25
  802278:	e8 8f fb ff ff       	call   801e0c <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
  802280:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802283:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802287:	75 07                	jne    802290 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802289:	b8 01 00 00 00       	mov    $0x1,%eax
  80228e:	eb 05                	jmp    802295 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802290:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 25                	push   $0x25
  8022a9:	e8 5e fb ff ff       	call   801e0c <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
  8022b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022b4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022b8:	75 07                	jne    8022c1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8022bf:	eb 05                	jmp    8022c6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 25                	push   $0x25
  8022da:	e8 2d fb ff ff       	call   801e0c <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
  8022e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022e5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022e9:	75 07                	jne    8022f2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f0:	eb 05                	jmp    8022f7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 25                	push   $0x25
  80230b:	e8 fc fa ff ff       	call   801e0c <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
  802313:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802316:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80231a:	75 07                	jne    802323 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80231c:	b8 01 00 00 00       	mov    $0x1,%eax
  802321:	eb 05                	jmp    802328 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802323:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	ff 75 08             	pushl  0x8(%ebp)
  802338:	6a 26                	push   $0x26
  80233a:	e8 cd fa ff ff       	call   801e0c <syscall>
  80233f:	83 c4 18             	add    $0x18,%esp
	return ;
  802342:	90                   	nop
}
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802349:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80234c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80234f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	6a 00                	push   $0x0
  802357:	53                   	push   %ebx
  802358:	51                   	push   %ecx
  802359:	52                   	push   %edx
  80235a:	50                   	push   %eax
  80235b:	6a 27                	push   $0x27
  80235d:	e8 aa fa ff ff       	call   801e0c <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
}
  802365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80236d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	52                   	push   %edx
  80237a:	50                   	push   %eax
  80237b:	6a 28                	push   $0x28
  80237d:	e8 8a fa ff ff       	call   801e0c <syscall>
  802382:	83 c4 18             	add    $0x18,%esp
}
  802385:	c9                   	leave  
  802386:	c3                   	ret    

00802387 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80238a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80238d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	6a 00                	push   $0x0
  802395:	51                   	push   %ecx
  802396:	ff 75 10             	pushl  0x10(%ebp)
  802399:	52                   	push   %edx
  80239a:	50                   	push   %eax
  80239b:	6a 29                	push   $0x29
  80239d:	e8 6a fa ff ff       	call   801e0c <syscall>
  8023a2:	83 c4 18             	add    $0x18,%esp
}
  8023a5:	c9                   	leave  
  8023a6:	c3                   	ret    

008023a7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	ff 75 10             	pushl  0x10(%ebp)
  8023b1:	ff 75 0c             	pushl  0xc(%ebp)
  8023b4:	ff 75 08             	pushl  0x8(%ebp)
  8023b7:	6a 12                	push   $0x12
  8023b9:	e8 4e fa ff ff       	call   801e0c <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c1:	90                   	nop
}
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8023c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	52                   	push   %edx
  8023d4:	50                   	push   %eax
  8023d5:	6a 2a                	push   $0x2a
  8023d7:	e8 30 fa ff ff       	call   801e0c <syscall>
  8023dc:	83 c4 18             	add    $0x18,%esp
	return;
  8023df:	90                   	nop
}
  8023e0:	c9                   	leave  
  8023e1:	c3                   	ret    

008023e2 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	50                   	push   %eax
  8023f1:	6a 2b                	push   $0x2b
  8023f3:	e8 14 fa ff ff       	call   801e0c <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
}
  8023fb:	c9                   	leave  
  8023fc:	c3                   	ret    

008023fd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023fd:	55                   	push   %ebp
  8023fe:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	ff 75 0c             	pushl  0xc(%ebp)
  802409:	ff 75 08             	pushl  0x8(%ebp)
  80240c:	6a 2c                	push   $0x2c
  80240e:	e8 f9 f9 ff ff       	call   801e0c <syscall>
  802413:	83 c4 18             	add    $0x18,%esp
	return;
  802416:	90                   	nop
}
  802417:	c9                   	leave  
  802418:	c3                   	ret    

00802419 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	ff 75 0c             	pushl  0xc(%ebp)
  802425:	ff 75 08             	pushl  0x8(%ebp)
  802428:	6a 2d                	push   $0x2d
  80242a:	e8 dd f9 ff ff       	call   801e0c <syscall>
  80242f:	83 c4 18             	add    $0x18,%esp
	return;
  802432:	90                   	nop
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
  802438:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	83 e8 04             	sub    $0x4,%eax
  802441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802444:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802447:	8b 00                	mov    (%eax),%eax
  802449:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	83 e8 04             	sub    $0x4,%eax
  80245a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80245d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802460:	8b 00                	mov    (%eax),%eax
  802462:	83 e0 01             	and    $0x1,%eax
  802465:	85 c0                	test   %eax,%eax
  802467:	0f 94 c0             	sete   %al
}
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802472:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247c:	83 f8 02             	cmp    $0x2,%eax
  80247f:	74 2b                	je     8024ac <alloc_block+0x40>
  802481:	83 f8 02             	cmp    $0x2,%eax
  802484:	7f 07                	jg     80248d <alloc_block+0x21>
  802486:	83 f8 01             	cmp    $0x1,%eax
  802489:	74 0e                	je     802499 <alloc_block+0x2d>
  80248b:	eb 58                	jmp    8024e5 <alloc_block+0x79>
  80248d:	83 f8 03             	cmp    $0x3,%eax
  802490:	74 2d                	je     8024bf <alloc_block+0x53>
  802492:	83 f8 04             	cmp    $0x4,%eax
  802495:	74 3b                	je     8024d2 <alloc_block+0x66>
  802497:	eb 4c                	jmp    8024e5 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802499:	83 ec 0c             	sub    $0xc,%esp
  80249c:	ff 75 08             	pushl  0x8(%ebp)
  80249f:	e8 11 03 00 00       	call   8027b5 <alloc_block_FF>
  8024a4:	83 c4 10             	add    $0x10,%esp
  8024a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024aa:	eb 4a                	jmp    8024f6 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8024ac:	83 ec 0c             	sub    $0xc,%esp
  8024af:	ff 75 08             	pushl  0x8(%ebp)
  8024b2:	e8 fa 19 00 00       	call   803eb1 <alloc_block_NF>
  8024b7:	83 c4 10             	add    $0x10,%esp
  8024ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024bd:	eb 37                	jmp    8024f6 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8024bf:	83 ec 0c             	sub    $0xc,%esp
  8024c2:	ff 75 08             	pushl  0x8(%ebp)
  8024c5:	e8 a7 07 00 00       	call   802c71 <alloc_block_BF>
  8024ca:	83 c4 10             	add    $0x10,%esp
  8024cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024d0:	eb 24                	jmp    8024f6 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8024d2:	83 ec 0c             	sub    $0xc,%esp
  8024d5:	ff 75 08             	pushl  0x8(%ebp)
  8024d8:	e8 b7 19 00 00       	call   803e94 <alloc_block_WF>
  8024dd:	83 c4 10             	add    $0x10,%esp
  8024e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8024e3:	eb 11                	jmp    8024f6 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8024e5:	83 ec 0c             	sub    $0xc,%esp
  8024e8:	68 c8 49 80 00       	push   $0x8049c8
  8024ed:	e8 08 e5 ff ff       	call   8009fa <cprintf>
  8024f2:	83 c4 10             	add    $0x10,%esp
		break;
  8024f5:	90                   	nop
	}
	return va;
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	53                   	push   %ebx
  8024ff:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802502:	83 ec 0c             	sub    $0xc,%esp
  802505:	68 e8 49 80 00       	push   $0x8049e8
  80250a:	e8 eb e4 ff ff       	call   8009fa <cprintf>
  80250f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802512:	83 ec 0c             	sub    $0xc,%esp
  802515:	68 13 4a 80 00       	push   $0x804a13
  80251a:	e8 db e4 ff ff       	call   8009fa <cprintf>
  80251f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802528:	eb 37                	jmp    802561 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80252a:	83 ec 0c             	sub    $0xc,%esp
  80252d:	ff 75 f4             	pushl  -0xc(%ebp)
  802530:	e8 19 ff ff ff       	call   80244e <is_free_block>
  802535:	83 c4 10             	add    $0x10,%esp
  802538:	0f be d8             	movsbl %al,%ebx
  80253b:	83 ec 0c             	sub    $0xc,%esp
  80253e:	ff 75 f4             	pushl  -0xc(%ebp)
  802541:	e8 ef fe ff ff       	call   802435 <get_block_size>
  802546:	83 c4 10             	add    $0x10,%esp
  802549:	83 ec 04             	sub    $0x4,%esp
  80254c:	53                   	push   %ebx
  80254d:	50                   	push   %eax
  80254e:	68 2b 4a 80 00       	push   $0x804a2b
  802553:	e8 a2 e4 ff ff       	call   8009fa <cprintf>
  802558:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80255b:	8b 45 10             	mov    0x10(%ebp),%eax
  80255e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802561:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802565:	74 07                	je     80256e <print_blocks_list+0x73>
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	8b 00                	mov    (%eax),%eax
  80256c:	eb 05                	jmp    802573 <print_blocks_list+0x78>
  80256e:	b8 00 00 00 00       	mov    $0x0,%eax
  802573:	89 45 10             	mov    %eax,0x10(%ebp)
  802576:	8b 45 10             	mov    0x10(%ebp),%eax
  802579:	85 c0                	test   %eax,%eax
  80257b:	75 ad                	jne    80252a <print_blocks_list+0x2f>
  80257d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802581:	75 a7                	jne    80252a <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802583:	83 ec 0c             	sub    $0xc,%esp
  802586:	68 e8 49 80 00       	push   $0x8049e8
  80258b:	e8 6a e4 ff ff       	call   8009fa <cprintf>
  802590:	83 c4 10             	add    $0x10,%esp

}
  802593:	90                   	nop
  802594:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802597:	c9                   	leave  
  802598:	c3                   	ret    

00802599 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802599:	55                   	push   %ebp
  80259a:	89 e5                	mov    %esp,%ebp
  80259c:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80259f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a2:	83 e0 01             	and    $0x1,%eax
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	74 03                	je     8025ac <initialize_dynamic_allocator+0x13>
  8025a9:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8025ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025b0:	0f 84 c7 01 00 00    	je     80277d <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8025b6:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8025bd:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8025c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8025c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c6:	01 d0                	add    %edx,%eax
  8025c8:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8025cd:	0f 87 ad 01 00 00    	ja     802780 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8025d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	0f 89 a5 01 00 00    	jns    802783 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8025de:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e4:	01 d0                	add    %edx,%eax
  8025e6:	83 e8 04             	sub    $0x4,%eax
  8025e9:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8025ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8025f5:	a1 30 50 80 00       	mov    0x805030,%eax
  8025fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fd:	e9 87 00 00 00       	jmp    802689 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802606:	75 14                	jne    80261c <initialize_dynamic_allocator+0x83>
  802608:	83 ec 04             	sub    $0x4,%esp
  80260b:	68 43 4a 80 00       	push   $0x804a43
  802610:	6a 79                	push   $0x79
  802612:	68 61 4a 80 00       	push   $0x804a61
  802617:	e8 21 e1 ff ff       	call   80073d <_panic>
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 00                	mov    (%eax),%eax
  802621:	85 c0                	test   %eax,%eax
  802623:	74 10                	je     802635 <initialize_dynamic_allocator+0x9c>
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 00                	mov    (%eax),%eax
  80262a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262d:	8b 52 04             	mov    0x4(%edx),%edx
  802630:	89 50 04             	mov    %edx,0x4(%eax)
  802633:	eb 0b                	jmp    802640 <initialize_dynamic_allocator+0xa7>
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 40 04             	mov    0x4(%eax),%eax
  80263b:	a3 34 50 80 00       	mov    %eax,0x805034
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 04             	mov    0x4(%eax),%eax
  802646:	85 c0                	test   %eax,%eax
  802648:	74 0f                	je     802659 <initialize_dynamic_allocator+0xc0>
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 40 04             	mov    0x4(%eax),%eax
  802650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802653:	8b 12                	mov    (%edx),%edx
  802655:	89 10                	mov    %edx,(%eax)
  802657:	eb 0a                	jmp    802663 <initialize_dynamic_allocator+0xca>
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	8b 00                	mov    (%eax),%eax
  80265e:	a3 30 50 80 00       	mov    %eax,0x805030
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802676:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80267b:	48                   	dec    %eax
  80267c:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802681:	a1 38 50 80 00       	mov    0x805038,%eax
  802686:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802689:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268d:	74 07                	je     802696 <initialize_dynamic_allocator+0xfd>
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	eb 05                	jmp    80269b <initialize_dynamic_allocator+0x102>
  802696:	b8 00 00 00 00       	mov    $0x0,%eax
  80269b:	a3 38 50 80 00       	mov    %eax,0x805038
  8026a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	0f 85 55 ff ff ff    	jne    802602 <initialize_dynamic_allocator+0x69>
  8026ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b1:	0f 85 4b ff ff ff    	jne    802602 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8026b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8026bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8026c6:	a1 48 50 80 00       	mov    0x805048,%eax
  8026cb:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8026d0:	a1 44 50 80 00       	mov    0x805044,%eax
  8026d5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	83 c0 08             	add    $0x8,%eax
  8026e1:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8026e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e7:	83 c0 04             	add    $0x4,%eax
  8026ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ed:	83 ea 08             	sub    $0x8,%edx
  8026f0:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8026f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f8:	01 d0                	add    %edx,%eax
  8026fa:	83 e8 08             	sub    $0x8,%eax
  8026fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802700:	83 ea 08             	sub    $0x8,%edx
  802703:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802705:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802708:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80270e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802711:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802718:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80271c:	75 17                	jne    802735 <initialize_dynamic_allocator+0x19c>
  80271e:	83 ec 04             	sub    $0x4,%esp
  802721:	68 7c 4a 80 00       	push   $0x804a7c
  802726:	68 90 00 00 00       	push   $0x90
  80272b:	68 61 4a 80 00       	push   $0x804a61
  802730:	e8 08 e0 ff ff       	call   80073d <_panic>
  802735:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80273b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273e:	89 10                	mov    %edx,(%eax)
  802740:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	85 c0                	test   %eax,%eax
  802747:	74 0d                	je     802756 <initialize_dynamic_allocator+0x1bd>
  802749:	a1 30 50 80 00       	mov    0x805030,%eax
  80274e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802751:	89 50 04             	mov    %edx,0x4(%eax)
  802754:	eb 08                	jmp    80275e <initialize_dynamic_allocator+0x1c5>
  802756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802759:	a3 34 50 80 00       	mov    %eax,0x805034
  80275e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802761:	a3 30 50 80 00       	mov    %eax,0x805030
  802766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802769:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802770:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802775:	40                   	inc    %eax
  802776:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80277b:	eb 07                	jmp    802784 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80277d:	90                   	nop
  80277e:	eb 04                	jmp    802784 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802780:	90                   	nop
  802781:	eb 01                	jmp    802784 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802783:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802789:	8b 45 10             	mov    0x10(%ebp),%eax
  80278c:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	8d 50 fc             	lea    -0x4(%eax),%edx
  802795:	8b 45 0c             	mov    0xc(%ebp),%eax
  802798:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80279a:	8b 45 08             	mov    0x8(%ebp),%eax
  80279d:	83 e8 04             	sub    $0x4,%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	83 e0 fe             	and    $0xfffffffe,%eax
  8027a5:	8d 50 f8             	lea    -0x8(%eax),%edx
  8027a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ab:	01 c2                	add    %eax,%edx
  8027ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b0:	89 02                	mov    %eax,(%edx)
}
  8027b2:	90                   	nop
  8027b3:	5d                   	pop    %ebp
  8027b4:	c3                   	ret    

008027b5 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8027b5:	55                   	push   %ebp
  8027b6:	89 e5                	mov    %esp,%ebp
  8027b8:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	83 e0 01             	and    $0x1,%eax
  8027c1:	85 c0                	test   %eax,%eax
  8027c3:	74 03                	je     8027c8 <alloc_block_FF+0x13>
  8027c5:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027c8:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027cc:	77 07                	ja     8027d5 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027ce:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027d5:	a1 28 50 80 00       	mov    0x805028,%eax
  8027da:	85 c0                	test   %eax,%eax
  8027dc:	75 73                	jne    802851 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	83 c0 10             	add    $0x10,%eax
  8027e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027e7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8027ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f4:	01 d0                	add    %edx,%eax
  8027f6:	48                   	dec    %eax
  8027f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8027fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027fd:	ba 00 00 00 00       	mov    $0x0,%edx
  802802:	f7 75 ec             	divl   -0x14(%ebp)
  802805:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802808:	29 d0                	sub    %edx,%eax
  80280a:	c1 e8 0c             	shr    $0xc,%eax
  80280d:	83 ec 0c             	sub    $0xc,%esp
  802810:	50                   	push   %eax
  802811:	e8 86 f1 ff ff       	call   80199c <sbrk>
  802816:	83 c4 10             	add    $0x10,%esp
  802819:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80281c:	83 ec 0c             	sub    $0xc,%esp
  80281f:	6a 00                	push   $0x0
  802821:	e8 76 f1 ff ff       	call   80199c <sbrk>
  802826:	83 c4 10             	add    $0x10,%esp
  802829:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80282c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80282f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802832:	83 ec 08             	sub    $0x8,%esp
  802835:	50                   	push   %eax
  802836:	ff 75 e4             	pushl  -0x1c(%ebp)
  802839:	e8 5b fd ff ff       	call   802599 <initialize_dynamic_allocator>
  80283e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802841:	83 ec 0c             	sub    $0xc,%esp
  802844:	68 9f 4a 80 00       	push   $0x804a9f
  802849:	e8 ac e1 ff ff       	call   8009fa <cprintf>
  80284e:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802851:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802855:	75 0a                	jne    802861 <alloc_block_FF+0xac>
	        return NULL;
  802857:	b8 00 00 00 00       	mov    $0x0,%eax
  80285c:	e9 0e 04 00 00       	jmp    802c6f <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802861:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802868:	a1 30 50 80 00       	mov    0x805030,%eax
  80286d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802870:	e9 f3 02 00 00       	jmp    802b68 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80287b:	83 ec 0c             	sub    $0xc,%esp
  80287e:	ff 75 bc             	pushl  -0x44(%ebp)
  802881:	e8 af fb ff ff       	call   802435 <get_block_size>
  802886:	83 c4 10             	add    $0x10,%esp
  802889:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	83 c0 08             	add    $0x8,%eax
  802892:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802895:	0f 87 c5 02 00 00    	ja     802b60 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	83 c0 18             	add    $0x18,%eax
  8028a1:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8028a4:	0f 87 19 02 00 00    	ja     802ac3 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8028aa:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8028ad:	2b 45 08             	sub    0x8(%ebp),%eax
  8028b0:	83 e8 08             	sub    $0x8,%eax
  8028b3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8028b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b9:	8d 50 08             	lea    0x8(%eax),%edx
  8028bc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028bf:	01 d0                	add    %edx,%eax
  8028c1:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	83 c0 08             	add    $0x8,%eax
  8028ca:	83 ec 04             	sub    $0x4,%esp
  8028cd:	6a 01                	push   $0x1
  8028cf:	50                   	push   %eax
  8028d0:	ff 75 bc             	pushl  -0x44(%ebp)
  8028d3:	e8 ae fe ff ff       	call   802786 <set_block_data>
  8028d8:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 40 04             	mov    0x4(%eax),%eax
  8028e1:	85 c0                	test   %eax,%eax
  8028e3:	75 68                	jne    80294d <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028e5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8028e9:	75 17                	jne    802902 <alloc_block_FF+0x14d>
  8028eb:	83 ec 04             	sub    $0x4,%esp
  8028ee:	68 7c 4a 80 00       	push   $0x804a7c
  8028f3:	68 d7 00 00 00       	push   $0xd7
  8028f8:	68 61 4a 80 00       	push   $0x804a61
  8028fd:	e8 3b de ff ff       	call   80073d <_panic>
  802902:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802908:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80290b:	89 10                	mov    %edx,(%eax)
  80290d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	85 c0                	test   %eax,%eax
  802914:	74 0d                	je     802923 <alloc_block_FF+0x16e>
  802916:	a1 30 50 80 00       	mov    0x805030,%eax
  80291b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80291e:	89 50 04             	mov    %edx,0x4(%eax)
  802921:	eb 08                	jmp    80292b <alloc_block_FF+0x176>
  802923:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802926:	a3 34 50 80 00       	mov    %eax,0x805034
  80292b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80292e:	a3 30 50 80 00       	mov    %eax,0x805030
  802933:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802936:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802942:	40                   	inc    %eax
  802943:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802948:	e9 dc 00 00 00       	jmp    802a29 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	8b 00                	mov    (%eax),%eax
  802952:	85 c0                	test   %eax,%eax
  802954:	75 65                	jne    8029bb <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802956:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80295a:	75 17                	jne    802973 <alloc_block_FF+0x1be>
  80295c:	83 ec 04             	sub    $0x4,%esp
  80295f:	68 b0 4a 80 00       	push   $0x804ab0
  802964:	68 db 00 00 00       	push   $0xdb
  802969:	68 61 4a 80 00       	push   $0x804a61
  80296e:	e8 ca dd ff ff       	call   80073d <_panic>
  802973:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802979:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80297c:	89 50 04             	mov    %edx,0x4(%eax)
  80297f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802982:	8b 40 04             	mov    0x4(%eax),%eax
  802985:	85 c0                	test   %eax,%eax
  802987:	74 0c                	je     802995 <alloc_block_FF+0x1e0>
  802989:	a1 34 50 80 00       	mov    0x805034,%eax
  80298e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802991:	89 10                	mov    %edx,(%eax)
  802993:	eb 08                	jmp    80299d <alloc_block_FF+0x1e8>
  802995:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802998:	a3 30 50 80 00       	mov    %eax,0x805030
  80299d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029a0:	a3 34 50 80 00       	mov    %eax,0x805034
  8029a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ae:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8029b3:	40                   	inc    %eax
  8029b4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8029b9:	eb 6e                	jmp    802a29 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8029bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029bf:	74 06                	je     8029c7 <alloc_block_FF+0x212>
  8029c1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029c5:	75 17                	jne    8029de <alloc_block_FF+0x229>
  8029c7:	83 ec 04             	sub    $0x4,%esp
  8029ca:	68 d4 4a 80 00       	push   $0x804ad4
  8029cf:	68 df 00 00 00       	push   $0xdf
  8029d4:	68 61 4a 80 00       	push   $0x804a61
  8029d9:	e8 5f dd ff ff       	call   80073d <_panic>
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	8b 10                	mov    (%eax),%edx
  8029e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029e6:	89 10                	mov    %edx,(%eax)
  8029e8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029eb:	8b 00                	mov    (%eax),%eax
  8029ed:	85 c0                	test   %eax,%eax
  8029ef:	74 0b                	je     8029fc <alloc_block_FF+0x247>
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	8b 00                	mov    (%eax),%eax
  8029f6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029f9:	89 50 04             	mov    %edx,0x4(%eax)
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a02:	89 10                	mov    %edx,(%eax)
  802a04:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0a:	89 50 04             	mov    %edx,0x4(%eax)
  802a0d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	85 c0                	test   %eax,%eax
  802a14:	75 08                	jne    802a1e <alloc_block_FF+0x269>
  802a16:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a19:	a3 34 50 80 00       	mov    %eax,0x805034
  802a1e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a23:	40                   	inc    %eax
  802a24:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802a29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2d:	75 17                	jne    802a46 <alloc_block_FF+0x291>
  802a2f:	83 ec 04             	sub    $0x4,%esp
  802a32:	68 43 4a 80 00       	push   $0x804a43
  802a37:	68 e1 00 00 00       	push   $0xe1
  802a3c:	68 61 4a 80 00       	push   $0x804a61
  802a41:	e8 f7 dc ff ff       	call   80073d <_panic>
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 00                	mov    (%eax),%eax
  802a4b:	85 c0                	test   %eax,%eax
  802a4d:	74 10                	je     802a5f <alloc_block_FF+0x2aa>
  802a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a52:	8b 00                	mov    (%eax),%eax
  802a54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a57:	8b 52 04             	mov    0x4(%edx),%edx
  802a5a:	89 50 04             	mov    %edx,0x4(%eax)
  802a5d:	eb 0b                	jmp    802a6a <alloc_block_FF+0x2b5>
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 40 04             	mov    0x4(%eax),%eax
  802a65:	a3 34 50 80 00       	mov    %eax,0x805034
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	8b 40 04             	mov    0x4(%eax),%eax
  802a70:	85 c0                	test   %eax,%eax
  802a72:	74 0f                	je     802a83 <alloc_block_FF+0x2ce>
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	8b 40 04             	mov    0x4(%eax),%eax
  802a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a7d:	8b 12                	mov    (%edx),%edx
  802a7f:	89 10                	mov    %edx,(%eax)
  802a81:	eb 0a                	jmp    802a8d <alloc_block_FF+0x2d8>
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 00                	mov    (%eax),%eax
  802a88:	a3 30 50 80 00       	mov    %eax,0x805030
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802aa5:	48                   	dec    %eax
  802aa6:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802aab:	83 ec 04             	sub    $0x4,%esp
  802aae:	6a 00                	push   $0x0
  802ab0:	ff 75 b4             	pushl  -0x4c(%ebp)
  802ab3:	ff 75 b0             	pushl  -0x50(%ebp)
  802ab6:	e8 cb fc ff ff       	call   802786 <set_block_data>
  802abb:	83 c4 10             	add    $0x10,%esp
  802abe:	e9 95 00 00 00       	jmp    802b58 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802ac3:	83 ec 04             	sub    $0x4,%esp
  802ac6:	6a 01                	push   $0x1
  802ac8:	ff 75 b8             	pushl  -0x48(%ebp)
  802acb:	ff 75 bc             	pushl  -0x44(%ebp)
  802ace:	e8 b3 fc ff ff       	call   802786 <set_block_data>
  802ad3:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802ad6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ada:	75 17                	jne    802af3 <alloc_block_FF+0x33e>
  802adc:	83 ec 04             	sub    $0x4,%esp
  802adf:	68 43 4a 80 00       	push   $0x804a43
  802ae4:	68 e8 00 00 00       	push   $0xe8
  802ae9:	68 61 4a 80 00       	push   $0x804a61
  802aee:	e8 4a dc ff ff       	call   80073d <_panic>
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	8b 00                	mov    (%eax),%eax
  802af8:	85 c0                	test   %eax,%eax
  802afa:	74 10                	je     802b0c <alloc_block_FF+0x357>
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	8b 00                	mov    (%eax),%eax
  802b01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b04:	8b 52 04             	mov    0x4(%edx),%edx
  802b07:	89 50 04             	mov    %edx,0x4(%eax)
  802b0a:	eb 0b                	jmp    802b17 <alloc_block_FF+0x362>
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 40 04             	mov    0x4(%eax),%eax
  802b12:	a3 34 50 80 00       	mov    %eax,0x805034
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	8b 40 04             	mov    0x4(%eax),%eax
  802b1d:	85 c0                	test   %eax,%eax
  802b1f:	74 0f                	je     802b30 <alloc_block_FF+0x37b>
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 40 04             	mov    0x4(%eax),%eax
  802b27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2a:	8b 12                	mov    (%edx),%edx
  802b2c:	89 10                	mov    %edx,(%eax)
  802b2e:	eb 0a                	jmp    802b3a <alloc_block_FF+0x385>
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 00                	mov    (%eax),%eax
  802b35:	a3 30 50 80 00       	mov    %eax,0x805030
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b52:	48                   	dec    %eax
  802b53:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802b58:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b5b:	e9 0f 01 00 00       	jmp    802c6f <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b60:	a1 38 50 80 00       	mov    0x805038,%eax
  802b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6c:	74 07                	je     802b75 <alloc_block_FF+0x3c0>
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 00                	mov    (%eax),%eax
  802b73:	eb 05                	jmp    802b7a <alloc_block_FF+0x3c5>
  802b75:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7a:	a3 38 50 80 00       	mov    %eax,0x805038
  802b7f:	a1 38 50 80 00       	mov    0x805038,%eax
  802b84:	85 c0                	test   %eax,%eax
  802b86:	0f 85 e9 fc ff ff    	jne    802875 <alloc_block_FF+0xc0>
  802b8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b90:	0f 85 df fc ff ff    	jne    802875 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	83 c0 08             	add    $0x8,%eax
  802b9c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b9f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802ba6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ba9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bac:	01 d0                	add    %edx,%eax
  802bae:	48                   	dec    %eax
  802baf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802bb2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bb5:	ba 00 00 00 00       	mov    $0x0,%edx
  802bba:	f7 75 d8             	divl   -0x28(%ebp)
  802bbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802bc0:	29 d0                	sub    %edx,%eax
  802bc2:	c1 e8 0c             	shr    $0xc,%eax
  802bc5:	83 ec 0c             	sub    $0xc,%esp
  802bc8:	50                   	push   %eax
  802bc9:	e8 ce ed ff ff       	call   80199c <sbrk>
  802bce:	83 c4 10             	add    $0x10,%esp
  802bd1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802bd4:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802bd8:	75 0a                	jne    802be4 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802bda:	b8 00 00 00 00       	mov    $0x0,%eax
  802bdf:	e9 8b 00 00 00       	jmp    802c6f <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802be4:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802beb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802bee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf1:	01 d0                	add    %edx,%eax
  802bf3:	48                   	dec    %eax
  802bf4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802bf7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  802bff:	f7 75 cc             	divl   -0x34(%ebp)
  802c02:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c05:	29 d0                	sub    %edx,%eax
  802c07:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c0a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c0d:	01 d0                	add    %edx,%eax
  802c0f:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802c14:	a1 44 50 80 00       	mov    0x805044,%eax
  802c19:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c1f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c26:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c2c:	01 d0                	add    %edx,%eax
  802c2e:	48                   	dec    %eax
  802c2f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c32:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c35:	ba 00 00 00 00       	mov    $0x0,%edx
  802c3a:	f7 75 c4             	divl   -0x3c(%ebp)
  802c3d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c40:	29 d0                	sub    %edx,%eax
  802c42:	83 ec 04             	sub    $0x4,%esp
  802c45:	6a 01                	push   $0x1
  802c47:	50                   	push   %eax
  802c48:	ff 75 d0             	pushl  -0x30(%ebp)
  802c4b:	e8 36 fb ff ff       	call   802786 <set_block_data>
  802c50:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802c53:	83 ec 0c             	sub    $0xc,%esp
  802c56:	ff 75 d0             	pushl  -0x30(%ebp)
  802c59:	e8 1b 0a 00 00       	call   803679 <free_block>
  802c5e:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802c61:	83 ec 0c             	sub    $0xc,%esp
  802c64:	ff 75 08             	pushl  0x8(%ebp)
  802c67:	e8 49 fb ff ff       	call   8027b5 <alloc_block_FF>
  802c6c:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802c6f:	c9                   	leave  
  802c70:	c3                   	ret    

00802c71 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802c71:	55                   	push   %ebp
  802c72:	89 e5                	mov    %esp,%ebp
  802c74:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	83 e0 01             	and    $0x1,%eax
  802c7d:	85 c0                	test   %eax,%eax
  802c7f:	74 03                	je     802c84 <alloc_block_BF+0x13>
  802c81:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802c84:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802c88:	77 07                	ja     802c91 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802c8a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802c91:	a1 28 50 80 00       	mov    0x805028,%eax
  802c96:	85 c0                	test   %eax,%eax
  802c98:	75 73                	jne    802d0d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	83 c0 10             	add    $0x10,%eax
  802ca0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802ca3:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802caa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb0:	01 d0                	add    %edx,%eax
  802cb2:	48                   	dec    %eax
  802cb3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802cb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cb9:	ba 00 00 00 00       	mov    $0x0,%edx
  802cbe:	f7 75 e0             	divl   -0x20(%ebp)
  802cc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cc4:	29 d0                	sub    %edx,%eax
  802cc6:	c1 e8 0c             	shr    $0xc,%eax
  802cc9:	83 ec 0c             	sub    $0xc,%esp
  802ccc:	50                   	push   %eax
  802ccd:	e8 ca ec ff ff       	call   80199c <sbrk>
  802cd2:	83 c4 10             	add    $0x10,%esp
  802cd5:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802cd8:	83 ec 0c             	sub    $0xc,%esp
  802cdb:	6a 00                	push   $0x0
  802cdd:	e8 ba ec ff ff       	call   80199c <sbrk>
  802ce2:	83 c4 10             	add    $0x10,%esp
  802ce5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802ce8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ceb:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802cee:	83 ec 08             	sub    $0x8,%esp
  802cf1:	50                   	push   %eax
  802cf2:	ff 75 d8             	pushl  -0x28(%ebp)
  802cf5:	e8 9f f8 ff ff       	call   802599 <initialize_dynamic_allocator>
  802cfa:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802cfd:	83 ec 0c             	sub    $0xc,%esp
  802d00:	68 9f 4a 80 00       	push   $0x804a9f
  802d05:	e8 f0 dc ff ff       	call   8009fa <cprintf>
  802d0a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802d0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802d14:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802d1b:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802d22:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802d29:	a1 30 50 80 00       	mov    0x805030,%eax
  802d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d31:	e9 1d 01 00 00       	jmp    802e53 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d39:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802d3c:	83 ec 0c             	sub    $0xc,%esp
  802d3f:	ff 75 a8             	pushl  -0x58(%ebp)
  802d42:	e8 ee f6 ff ff       	call   802435 <get_block_size>
  802d47:	83 c4 10             	add    $0x10,%esp
  802d4a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	83 c0 08             	add    $0x8,%eax
  802d53:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d56:	0f 87 ef 00 00 00    	ja     802e4b <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	83 c0 18             	add    $0x18,%eax
  802d62:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d65:	77 1d                	ja     802d84 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d6d:	0f 86 d8 00 00 00    	jbe    802e4b <alloc_block_BF+0x1da>
				{
					best_va = va;
  802d73:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802d76:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802d79:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802d7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d7f:	e9 c7 00 00 00       	jmp    802e4b <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	83 c0 08             	add    $0x8,%eax
  802d8a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802d8d:	0f 85 9d 00 00 00    	jne    802e30 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802d93:	83 ec 04             	sub    $0x4,%esp
  802d96:	6a 01                	push   $0x1
  802d98:	ff 75 a4             	pushl  -0x5c(%ebp)
  802d9b:	ff 75 a8             	pushl  -0x58(%ebp)
  802d9e:	e8 e3 f9 ff ff       	call   802786 <set_block_data>
  802da3:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802da6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802daa:	75 17                	jne    802dc3 <alloc_block_BF+0x152>
  802dac:	83 ec 04             	sub    $0x4,%esp
  802daf:	68 43 4a 80 00       	push   $0x804a43
  802db4:	68 2c 01 00 00       	push   $0x12c
  802db9:	68 61 4a 80 00       	push   $0x804a61
  802dbe:	e8 7a d9 ff ff       	call   80073d <_panic>
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	8b 00                	mov    (%eax),%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	74 10                	je     802ddc <alloc_block_BF+0x16b>
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 00                	mov    (%eax),%eax
  802dd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd4:	8b 52 04             	mov    0x4(%edx),%edx
  802dd7:	89 50 04             	mov    %edx,0x4(%eax)
  802dda:	eb 0b                	jmp    802de7 <alloc_block_BF+0x176>
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	8b 40 04             	mov    0x4(%eax),%eax
  802de2:	a3 34 50 80 00       	mov    %eax,0x805034
  802de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dea:	8b 40 04             	mov    0x4(%eax),%eax
  802ded:	85 c0                	test   %eax,%eax
  802def:	74 0f                	je     802e00 <alloc_block_BF+0x18f>
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 40 04             	mov    0x4(%eax),%eax
  802df7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dfa:	8b 12                	mov    (%edx),%edx
  802dfc:	89 10                	mov    %edx,(%eax)
  802dfe:	eb 0a                	jmp    802e0a <alloc_block_BF+0x199>
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	a3 30 50 80 00       	mov    %eax,0x805030
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e22:	48                   	dec    %eax
  802e23:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802e28:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e2b:	e9 24 04 00 00       	jmp    803254 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802e30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e33:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e36:	76 13                	jbe    802e4b <alloc_block_BF+0x1da>
					{
						internal = 1;
  802e38:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802e3f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802e45:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e48:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802e4b:	a1 38 50 80 00       	mov    0x805038,%eax
  802e50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e57:	74 07                	je     802e60 <alloc_block_BF+0x1ef>
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	8b 00                	mov    (%eax),%eax
  802e5e:	eb 05                	jmp    802e65 <alloc_block_BF+0x1f4>
  802e60:	b8 00 00 00 00       	mov    $0x0,%eax
  802e65:	a3 38 50 80 00       	mov    %eax,0x805038
  802e6a:	a1 38 50 80 00       	mov    0x805038,%eax
  802e6f:	85 c0                	test   %eax,%eax
  802e71:	0f 85 bf fe ff ff    	jne    802d36 <alloc_block_BF+0xc5>
  802e77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7b:	0f 85 b5 fe ff ff    	jne    802d36 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802e81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e85:	0f 84 26 02 00 00    	je     8030b1 <alloc_block_BF+0x440>
  802e8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e8f:	0f 85 1c 02 00 00    	jne    8030b1 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802e95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e98:	2b 45 08             	sub    0x8(%ebp),%eax
  802e9b:	83 e8 08             	sub    $0x8,%eax
  802e9e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	8d 50 08             	lea    0x8(%eax),%edx
  802ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eaa:	01 d0                	add    %edx,%eax
  802eac:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb2:	83 c0 08             	add    $0x8,%eax
  802eb5:	83 ec 04             	sub    $0x4,%esp
  802eb8:	6a 01                	push   $0x1
  802eba:	50                   	push   %eax
  802ebb:	ff 75 f0             	pushl  -0x10(%ebp)
  802ebe:	e8 c3 f8 ff ff       	call   802786 <set_block_data>
  802ec3:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec9:	8b 40 04             	mov    0x4(%eax),%eax
  802ecc:	85 c0                	test   %eax,%eax
  802ece:	75 68                	jne    802f38 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ed0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ed4:	75 17                	jne    802eed <alloc_block_BF+0x27c>
  802ed6:	83 ec 04             	sub    $0x4,%esp
  802ed9:	68 7c 4a 80 00       	push   $0x804a7c
  802ede:	68 45 01 00 00       	push   $0x145
  802ee3:	68 61 4a 80 00       	push   $0x804a61
  802ee8:	e8 50 d8 ff ff       	call   80073d <_panic>
  802eed:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802ef3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ef6:	89 10                	mov    %edx,(%eax)
  802ef8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802efb:	8b 00                	mov    (%eax),%eax
  802efd:	85 c0                	test   %eax,%eax
  802eff:	74 0d                	je     802f0e <alloc_block_BF+0x29d>
  802f01:	a1 30 50 80 00       	mov    0x805030,%eax
  802f06:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f09:	89 50 04             	mov    %edx,0x4(%eax)
  802f0c:	eb 08                	jmp    802f16 <alloc_block_BF+0x2a5>
  802f0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f11:	a3 34 50 80 00       	mov    %eax,0x805034
  802f16:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f19:	a3 30 50 80 00       	mov    %eax,0x805030
  802f1e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f28:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f2d:	40                   	inc    %eax
  802f2e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802f33:	e9 dc 00 00 00       	jmp    803014 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	85 c0                	test   %eax,%eax
  802f3f:	75 65                	jne    802fa6 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f41:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f45:	75 17                	jne    802f5e <alloc_block_BF+0x2ed>
  802f47:	83 ec 04             	sub    $0x4,%esp
  802f4a:	68 b0 4a 80 00       	push   $0x804ab0
  802f4f:	68 4a 01 00 00       	push   $0x14a
  802f54:	68 61 4a 80 00       	push   $0x804a61
  802f59:	e8 df d7 ff ff       	call   80073d <_panic>
  802f5e:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802f64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f67:	89 50 04             	mov    %edx,0x4(%eax)
  802f6a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f6d:	8b 40 04             	mov    0x4(%eax),%eax
  802f70:	85 c0                	test   %eax,%eax
  802f72:	74 0c                	je     802f80 <alloc_block_BF+0x30f>
  802f74:	a1 34 50 80 00       	mov    0x805034,%eax
  802f79:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f7c:	89 10                	mov    %edx,(%eax)
  802f7e:	eb 08                	jmp    802f88 <alloc_block_BF+0x317>
  802f80:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f83:	a3 30 50 80 00       	mov    %eax,0x805030
  802f88:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f8b:	a3 34 50 80 00       	mov    %eax,0x805034
  802f90:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f99:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f9e:	40                   	inc    %eax
  802f9f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802fa4:	eb 6e                	jmp    803014 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802fa6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802faa:	74 06                	je     802fb2 <alloc_block_BF+0x341>
  802fac:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fb0:	75 17                	jne    802fc9 <alloc_block_BF+0x358>
  802fb2:	83 ec 04             	sub    $0x4,%esp
  802fb5:	68 d4 4a 80 00       	push   $0x804ad4
  802fba:	68 4f 01 00 00       	push   $0x14f
  802fbf:	68 61 4a 80 00       	push   $0x804a61
  802fc4:	e8 74 d7 ff ff       	call   80073d <_panic>
  802fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcc:	8b 10                	mov    (%eax),%edx
  802fce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fd1:	89 10                	mov    %edx,(%eax)
  802fd3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fd6:	8b 00                	mov    (%eax),%eax
  802fd8:	85 c0                	test   %eax,%eax
  802fda:	74 0b                	je     802fe7 <alloc_block_BF+0x376>
  802fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdf:	8b 00                	mov    (%eax),%eax
  802fe1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fe4:	89 50 04             	mov    %edx,0x4(%eax)
  802fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fea:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fed:	89 10                	mov    %edx,(%eax)
  802fef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ff2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ff5:	89 50 04             	mov    %edx,0x4(%eax)
  802ff8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ffb:	8b 00                	mov    (%eax),%eax
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	75 08                	jne    803009 <alloc_block_BF+0x398>
  803001:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803004:	a3 34 50 80 00       	mov    %eax,0x805034
  803009:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80300e:	40                   	inc    %eax
  80300f:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803014:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803018:	75 17                	jne    803031 <alloc_block_BF+0x3c0>
  80301a:	83 ec 04             	sub    $0x4,%esp
  80301d:	68 43 4a 80 00       	push   $0x804a43
  803022:	68 51 01 00 00       	push   $0x151
  803027:	68 61 4a 80 00       	push   $0x804a61
  80302c:	e8 0c d7 ff ff       	call   80073d <_panic>
  803031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803034:	8b 00                	mov    (%eax),%eax
  803036:	85 c0                	test   %eax,%eax
  803038:	74 10                	je     80304a <alloc_block_BF+0x3d9>
  80303a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303d:	8b 00                	mov    (%eax),%eax
  80303f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803042:	8b 52 04             	mov    0x4(%edx),%edx
  803045:	89 50 04             	mov    %edx,0x4(%eax)
  803048:	eb 0b                	jmp    803055 <alloc_block_BF+0x3e4>
  80304a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304d:	8b 40 04             	mov    0x4(%eax),%eax
  803050:	a3 34 50 80 00       	mov    %eax,0x805034
  803055:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803058:	8b 40 04             	mov    0x4(%eax),%eax
  80305b:	85 c0                	test   %eax,%eax
  80305d:	74 0f                	je     80306e <alloc_block_BF+0x3fd>
  80305f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803062:	8b 40 04             	mov    0x4(%eax),%eax
  803065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803068:	8b 12                	mov    (%edx),%edx
  80306a:	89 10                	mov    %edx,(%eax)
  80306c:	eb 0a                	jmp    803078 <alloc_block_BF+0x407>
  80306e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	a3 30 50 80 00       	mov    %eax,0x805030
  803078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803084:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803090:	48                   	dec    %eax
  803091:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  803096:	83 ec 04             	sub    $0x4,%esp
  803099:	6a 00                	push   $0x0
  80309b:	ff 75 d0             	pushl  -0x30(%ebp)
  80309e:	ff 75 cc             	pushl  -0x34(%ebp)
  8030a1:	e8 e0 f6 ff ff       	call   802786 <set_block_data>
  8030a6:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8030a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ac:	e9 a3 01 00 00       	jmp    803254 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8030b1:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8030b5:	0f 85 9d 00 00 00    	jne    803158 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8030bb:	83 ec 04             	sub    $0x4,%esp
  8030be:	6a 01                	push   $0x1
  8030c0:	ff 75 ec             	pushl  -0x14(%ebp)
  8030c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8030c6:	e8 bb f6 ff ff       	call   802786 <set_block_data>
  8030cb:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8030ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030d2:	75 17                	jne    8030eb <alloc_block_BF+0x47a>
  8030d4:	83 ec 04             	sub    $0x4,%esp
  8030d7:	68 43 4a 80 00       	push   $0x804a43
  8030dc:	68 58 01 00 00       	push   $0x158
  8030e1:	68 61 4a 80 00       	push   $0x804a61
  8030e6:	e8 52 d6 ff ff       	call   80073d <_panic>
  8030eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ee:	8b 00                	mov    (%eax),%eax
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	74 10                	je     803104 <alloc_block_BF+0x493>
  8030f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030fc:	8b 52 04             	mov    0x4(%edx),%edx
  8030ff:	89 50 04             	mov    %edx,0x4(%eax)
  803102:	eb 0b                	jmp    80310f <alloc_block_BF+0x49e>
  803104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803107:	8b 40 04             	mov    0x4(%eax),%eax
  80310a:	a3 34 50 80 00       	mov    %eax,0x805034
  80310f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803112:	8b 40 04             	mov    0x4(%eax),%eax
  803115:	85 c0                	test   %eax,%eax
  803117:	74 0f                	je     803128 <alloc_block_BF+0x4b7>
  803119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311c:	8b 40 04             	mov    0x4(%eax),%eax
  80311f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803122:	8b 12                	mov    (%edx),%edx
  803124:	89 10                	mov    %edx,(%eax)
  803126:	eb 0a                	jmp    803132 <alloc_block_BF+0x4c1>
  803128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312b:	8b 00                	mov    (%eax),%eax
  80312d:	a3 30 50 80 00       	mov    %eax,0x805030
  803132:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803135:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803145:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80314a:	48                   	dec    %eax
  80314b:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  803150:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803153:	e9 fc 00 00 00       	jmp    803254 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	83 c0 08             	add    $0x8,%eax
  80315e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803161:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803168:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80316b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80316e:	01 d0                	add    %edx,%eax
  803170:	48                   	dec    %eax
  803171:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803174:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803177:	ba 00 00 00 00       	mov    $0x0,%edx
  80317c:	f7 75 c4             	divl   -0x3c(%ebp)
  80317f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803182:	29 d0                	sub    %edx,%eax
  803184:	c1 e8 0c             	shr    $0xc,%eax
  803187:	83 ec 0c             	sub    $0xc,%esp
  80318a:	50                   	push   %eax
  80318b:	e8 0c e8 ff ff       	call   80199c <sbrk>
  803190:	83 c4 10             	add    $0x10,%esp
  803193:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803196:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80319a:	75 0a                	jne    8031a6 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80319c:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a1:	e9 ae 00 00 00       	jmp    803254 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8031a6:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8031ad:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8031b3:	01 d0                	add    %edx,%eax
  8031b5:	48                   	dec    %eax
  8031b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8031b9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8031bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8031c1:	f7 75 b8             	divl   -0x48(%ebp)
  8031c4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8031c7:	29 d0                	sub    %edx,%eax
  8031c9:	8d 50 fc             	lea    -0x4(%eax),%edx
  8031cc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8031cf:	01 d0                	add    %edx,%eax
  8031d1:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  8031d6:	a1 44 50 80 00       	mov    0x805044,%eax
  8031db:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8031e1:	83 ec 0c             	sub    $0xc,%esp
  8031e4:	68 08 4b 80 00       	push   $0x804b08
  8031e9:	e8 0c d8 ff ff       	call   8009fa <cprintf>
  8031ee:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8031f1:	83 ec 08             	sub    $0x8,%esp
  8031f4:	ff 75 bc             	pushl  -0x44(%ebp)
  8031f7:	68 0d 4b 80 00       	push   $0x804b0d
  8031fc:	e8 f9 d7 ff ff       	call   8009fa <cprintf>
  803201:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803204:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80320b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80320e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803211:	01 d0                	add    %edx,%eax
  803213:	48                   	dec    %eax
  803214:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803217:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80321a:	ba 00 00 00 00       	mov    $0x0,%edx
  80321f:	f7 75 b0             	divl   -0x50(%ebp)
  803222:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803225:	29 d0                	sub    %edx,%eax
  803227:	83 ec 04             	sub    $0x4,%esp
  80322a:	6a 01                	push   $0x1
  80322c:	50                   	push   %eax
  80322d:	ff 75 bc             	pushl  -0x44(%ebp)
  803230:	e8 51 f5 ff ff       	call   802786 <set_block_data>
  803235:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803238:	83 ec 0c             	sub    $0xc,%esp
  80323b:	ff 75 bc             	pushl  -0x44(%ebp)
  80323e:	e8 36 04 00 00       	call   803679 <free_block>
  803243:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803246:	83 ec 0c             	sub    $0xc,%esp
  803249:	ff 75 08             	pushl  0x8(%ebp)
  80324c:	e8 20 fa ff ff       	call   802c71 <alloc_block_BF>
  803251:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803254:	c9                   	leave  
  803255:	c3                   	ret    

00803256 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803256:	55                   	push   %ebp
  803257:	89 e5                	mov    %esp,%ebp
  803259:	53                   	push   %ebx
  80325a:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80325d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803264:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80326b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80326f:	74 1e                	je     80328f <merging+0x39>
  803271:	ff 75 08             	pushl  0x8(%ebp)
  803274:	e8 bc f1 ff ff       	call   802435 <get_block_size>
  803279:	83 c4 04             	add    $0x4,%esp
  80327c:	89 c2                	mov    %eax,%edx
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	01 d0                	add    %edx,%eax
  803283:	3b 45 10             	cmp    0x10(%ebp),%eax
  803286:	75 07                	jne    80328f <merging+0x39>
		prev_is_free = 1;
  803288:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80328f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803293:	74 1e                	je     8032b3 <merging+0x5d>
  803295:	ff 75 10             	pushl  0x10(%ebp)
  803298:	e8 98 f1 ff ff       	call   802435 <get_block_size>
  80329d:	83 c4 04             	add    $0x4,%esp
  8032a0:	89 c2                	mov    %eax,%edx
  8032a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8032a5:	01 d0                	add    %edx,%eax
  8032a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032aa:	75 07                	jne    8032b3 <merging+0x5d>
		next_is_free = 1;
  8032ac:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8032b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b7:	0f 84 cc 00 00 00    	je     803389 <merging+0x133>
  8032bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032c1:	0f 84 c2 00 00 00    	je     803389 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8032c7:	ff 75 08             	pushl  0x8(%ebp)
  8032ca:	e8 66 f1 ff ff       	call   802435 <get_block_size>
  8032cf:	83 c4 04             	add    $0x4,%esp
  8032d2:	89 c3                	mov    %eax,%ebx
  8032d4:	ff 75 10             	pushl  0x10(%ebp)
  8032d7:	e8 59 f1 ff ff       	call   802435 <get_block_size>
  8032dc:	83 c4 04             	add    $0x4,%esp
  8032df:	01 c3                	add    %eax,%ebx
  8032e1:	ff 75 0c             	pushl  0xc(%ebp)
  8032e4:	e8 4c f1 ff ff       	call   802435 <get_block_size>
  8032e9:	83 c4 04             	add    $0x4,%esp
  8032ec:	01 d8                	add    %ebx,%eax
  8032ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8032f1:	6a 00                	push   $0x0
  8032f3:	ff 75 ec             	pushl  -0x14(%ebp)
  8032f6:	ff 75 08             	pushl  0x8(%ebp)
  8032f9:	e8 88 f4 ff ff       	call   802786 <set_block_data>
  8032fe:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803301:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803305:	75 17                	jne    80331e <merging+0xc8>
  803307:	83 ec 04             	sub    $0x4,%esp
  80330a:	68 43 4a 80 00       	push   $0x804a43
  80330f:	68 7d 01 00 00       	push   $0x17d
  803314:	68 61 4a 80 00       	push   $0x804a61
  803319:	e8 1f d4 ff ff       	call   80073d <_panic>
  80331e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	85 c0                	test   %eax,%eax
  803325:	74 10                	je     803337 <merging+0xe1>
  803327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80332a:	8b 00                	mov    (%eax),%eax
  80332c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80332f:	8b 52 04             	mov    0x4(%edx),%edx
  803332:	89 50 04             	mov    %edx,0x4(%eax)
  803335:	eb 0b                	jmp    803342 <merging+0xec>
  803337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333a:	8b 40 04             	mov    0x4(%eax),%eax
  80333d:	a3 34 50 80 00       	mov    %eax,0x805034
  803342:	8b 45 0c             	mov    0xc(%ebp),%eax
  803345:	8b 40 04             	mov    0x4(%eax),%eax
  803348:	85 c0                	test   %eax,%eax
  80334a:	74 0f                	je     80335b <merging+0x105>
  80334c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80334f:	8b 40 04             	mov    0x4(%eax),%eax
  803352:	8b 55 0c             	mov    0xc(%ebp),%edx
  803355:	8b 12                	mov    (%edx),%edx
  803357:	89 10                	mov    %edx,(%eax)
  803359:	eb 0a                	jmp    803365 <merging+0x10f>
  80335b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80335e:	8b 00                	mov    (%eax),%eax
  803360:	a3 30 50 80 00       	mov    %eax,0x805030
  803365:	8b 45 0c             	mov    0xc(%ebp),%eax
  803368:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803371:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803378:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80337d:	48                   	dec    %eax
  80337e:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803383:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803384:	e9 ea 02 00 00       	jmp    803673 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338d:	74 3b                	je     8033ca <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80338f:	83 ec 0c             	sub    $0xc,%esp
  803392:	ff 75 08             	pushl  0x8(%ebp)
  803395:	e8 9b f0 ff ff       	call   802435 <get_block_size>
  80339a:	83 c4 10             	add    $0x10,%esp
  80339d:	89 c3                	mov    %eax,%ebx
  80339f:	83 ec 0c             	sub    $0xc,%esp
  8033a2:	ff 75 10             	pushl  0x10(%ebp)
  8033a5:	e8 8b f0 ff ff       	call   802435 <get_block_size>
  8033aa:	83 c4 10             	add    $0x10,%esp
  8033ad:	01 d8                	add    %ebx,%eax
  8033af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8033b2:	83 ec 04             	sub    $0x4,%esp
  8033b5:	6a 00                	push   $0x0
  8033b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8033ba:	ff 75 08             	pushl  0x8(%ebp)
  8033bd:	e8 c4 f3 ff ff       	call   802786 <set_block_data>
  8033c2:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8033c5:	e9 a9 02 00 00       	jmp    803673 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8033ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033ce:	0f 84 2d 01 00 00    	je     803501 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8033d4:	83 ec 0c             	sub    $0xc,%esp
  8033d7:	ff 75 10             	pushl  0x10(%ebp)
  8033da:	e8 56 f0 ff ff       	call   802435 <get_block_size>
  8033df:	83 c4 10             	add    $0x10,%esp
  8033e2:	89 c3                	mov    %eax,%ebx
  8033e4:	83 ec 0c             	sub    $0xc,%esp
  8033e7:	ff 75 0c             	pushl  0xc(%ebp)
  8033ea:	e8 46 f0 ff ff       	call   802435 <get_block_size>
  8033ef:	83 c4 10             	add    $0x10,%esp
  8033f2:	01 d8                	add    %ebx,%eax
  8033f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8033f7:	83 ec 04             	sub    $0x4,%esp
  8033fa:	6a 00                	push   $0x0
  8033fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033ff:	ff 75 10             	pushl  0x10(%ebp)
  803402:	e8 7f f3 ff ff       	call   802786 <set_block_data>
  803407:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80340a:	8b 45 10             	mov    0x10(%ebp),%eax
  80340d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803410:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803414:	74 06                	je     80341c <merging+0x1c6>
  803416:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80341a:	75 17                	jne    803433 <merging+0x1dd>
  80341c:	83 ec 04             	sub    $0x4,%esp
  80341f:	68 1c 4b 80 00       	push   $0x804b1c
  803424:	68 8d 01 00 00       	push   $0x18d
  803429:	68 61 4a 80 00       	push   $0x804a61
  80342e:	e8 0a d3 ff ff       	call   80073d <_panic>
  803433:	8b 45 0c             	mov    0xc(%ebp),%eax
  803436:	8b 50 04             	mov    0x4(%eax),%edx
  803439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80343c:	89 50 04             	mov    %edx,0x4(%eax)
  80343f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803442:	8b 55 0c             	mov    0xc(%ebp),%edx
  803445:	89 10                	mov    %edx,(%eax)
  803447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344a:	8b 40 04             	mov    0x4(%eax),%eax
  80344d:	85 c0                	test   %eax,%eax
  80344f:	74 0d                	je     80345e <merging+0x208>
  803451:	8b 45 0c             	mov    0xc(%ebp),%eax
  803454:	8b 40 04             	mov    0x4(%eax),%eax
  803457:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80345a:	89 10                	mov    %edx,(%eax)
  80345c:	eb 08                	jmp    803466 <merging+0x210>
  80345e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803461:	a3 30 50 80 00       	mov    %eax,0x805030
  803466:	8b 45 0c             	mov    0xc(%ebp),%eax
  803469:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80346c:	89 50 04             	mov    %edx,0x4(%eax)
  80346f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803474:	40                   	inc    %eax
  803475:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  80347a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80347e:	75 17                	jne    803497 <merging+0x241>
  803480:	83 ec 04             	sub    $0x4,%esp
  803483:	68 43 4a 80 00       	push   $0x804a43
  803488:	68 8e 01 00 00       	push   $0x18e
  80348d:	68 61 4a 80 00       	push   $0x804a61
  803492:	e8 a6 d2 ff ff       	call   80073d <_panic>
  803497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349a:	8b 00                	mov    (%eax),%eax
  80349c:	85 c0                	test   %eax,%eax
  80349e:	74 10                	je     8034b0 <merging+0x25a>
  8034a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a3:	8b 00                	mov    (%eax),%eax
  8034a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034a8:	8b 52 04             	mov    0x4(%edx),%edx
  8034ab:	89 50 04             	mov    %edx,0x4(%eax)
  8034ae:	eb 0b                	jmp    8034bb <merging+0x265>
  8034b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b3:	8b 40 04             	mov    0x4(%eax),%eax
  8034b6:	a3 34 50 80 00       	mov    %eax,0x805034
  8034bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034be:	8b 40 04             	mov    0x4(%eax),%eax
  8034c1:	85 c0                	test   %eax,%eax
  8034c3:	74 0f                	je     8034d4 <merging+0x27e>
  8034c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c8:	8b 40 04             	mov    0x4(%eax),%eax
  8034cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034ce:	8b 12                	mov    (%edx),%edx
  8034d0:	89 10                	mov    %edx,(%eax)
  8034d2:	eb 0a                	jmp    8034de <merging+0x288>
  8034d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d7:	8b 00                	mov    (%eax),%eax
  8034d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8034de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034f6:	48                   	dec    %eax
  8034f7:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034fc:	e9 72 01 00 00       	jmp    803673 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803501:	8b 45 10             	mov    0x10(%ebp),%eax
  803504:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803507:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80350b:	74 79                	je     803586 <merging+0x330>
  80350d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803511:	74 73                	je     803586 <merging+0x330>
  803513:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803517:	74 06                	je     80351f <merging+0x2c9>
  803519:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80351d:	75 17                	jne    803536 <merging+0x2e0>
  80351f:	83 ec 04             	sub    $0x4,%esp
  803522:	68 d4 4a 80 00       	push   $0x804ad4
  803527:	68 94 01 00 00       	push   $0x194
  80352c:	68 61 4a 80 00       	push   $0x804a61
  803531:	e8 07 d2 ff ff       	call   80073d <_panic>
  803536:	8b 45 08             	mov    0x8(%ebp),%eax
  803539:	8b 10                	mov    (%eax),%edx
  80353b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80353e:	89 10                	mov    %edx,(%eax)
  803540:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803543:	8b 00                	mov    (%eax),%eax
  803545:	85 c0                	test   %eax,%eax
  803547:	74 0b                	je     803554 <merging+0x2fe>
  803549:	8b 45 08             	mov    0x8(%ebp),%eax
  80354c:	8b 00                	mov    (%eax),%eax
  80354e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803551:	89 50 04             	mov    %edx,0x4(%eax)
  803554:	8b 45 08             	mov    0x8(%ebp),%eax
  803557:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80355a:	89 10                	mov    %edx,(%eax)
  80355c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80355f:	8b 55 08             	mov    0x8(%ebp),%edx
  803562:	89 50 04             	mov    %edx,0x4(%eax)
  803565:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803568:	8b 00                	mov    (%eax),%eax
  80356a:	85 c0                	test   %eax,%eax
  80356c:	75 08                	jne    803576 <merging+0x320>
  80356e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803571:	a3 34 50 80 00       	mov    %eax,0x805034
  803576:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80357b:	40                   	inc    %eax
  80357c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803581:	e9 ce 00 00 00       	jmp    803654 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803586:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80358a:	74 65                	je     8035f1 <merging+0x39b>
  80358c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803590:	75 17                	jne    8035a9 <merging+0x353>
  803592:	83 ec 04             	sub    $0x4,%esp
  803595:	68 b0 4a 80 00       	push   $0x804ab0
  80359a:	68 95 01 00 00       	push   $0x195
  80359f:	68 61 4a 80 00       	push   $0x804a61
  8035a4:	e8 94 d1 ff ff       	call   80073d <_panic>
  8035a9:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8035af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035b2:	89 50 04             	mov    %edx,0x4(%eax)
  8035b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035b8:	8b 40 04             	mov    0x4(%eax),%eax
  8035bb:	85 c0                	test   %eax,%eax
  8035bd:	74 0c                	je     8035cb <merging+0x375>
  8035bf:	a1 34 50 80 00       	mov    0x805034,%eax
  8035c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035c7:	89 10                	mov    %edx,(%eax)
  8035c9:	eb 08                	jmp    8035d3 <merging+0x37d>
  8035cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8035d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035d6:	a3 34 50 80 00       	mov    %eax,0x805034
  8035db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035e9:	40                   	inc    %eax
  8035ea:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035ef:	eb 63                	jmp    803654 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8035f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035f5:	75 17                	jne    80360e <merging+0x3b8>
  8035f7:	83 ec 04             	sub    $0x4,%esp
  8035fa:	68 7c 4a 80 00       	push   $0x804a7c
  8035ff:	68 98 01 00 00       	push   $0x198
  803604:	68 61 4a 80 00       	push   $0x804a61
  803609:	e8 2f d1 ff ff       	call   80073d <_panic>
  80360e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803614:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803617:	89 10                	mov    %edx,(%eax)
  803619:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80361c:	8b 00                	mov    (%eax),%eax
  80361e:	85 c0                	test   %eax,%eax
  803620:	74 0d                	je     80362f <merging+0x3d9>
  803622:	a1 30 50 80 00       	mov    0x805030,%eax
  803627:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80362a:	89 50 04             	mov    %edx,0x4(%eax)
  80362d:	eb 08                	jmp    803637 <merging+0x3e1>
  80362f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803632:	a3 34 50 80 00       	mov    %eax,0x805034
  803637:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80363a:	a3 30 50 80 00       	mov    %eax,0x805030
  80363f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803642:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803649:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80364e:	40                   	inc    %eax
  80364f:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803654:	83 ec 0c             	sub    $0xc,%esp
  803657:	ff 75 10             	pushl  0x10(%ebp)
  80365a:	e8 d6 ed ff ff       	call   802435 <get_block_size>
  80365f:	83 c4 10             	add    $0x10,%esp
  803662:	83 ec 04             	sub    $0x4,%esp
  803665:	6a 00                	push   $0x0
  803667:	50                   	push   %eax
  803668:	ff 75 10             	pushl  0x10(%ebp)
  80366b:	e8 16 f1 ff ff       	call   802786 <set_block_data>
  803670:	83 c4 10             	add    $0x10,%esp
	}
}
  803673:	90                   	nop
  803674:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803677:	c9                   	leave  
  803678:	c3                   	ret    

00803679 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803679:	55                   	push   %ebp
  80367a:	89 e5                	mov    %esp,%ebp
  80367c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80367f:	a1 30 50 80 00       	mov    0x805030,%eax
  803684:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803687:	a1 34 50 80 00       	mov    0x805034,%eax
  80368c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80368f:	73 1b                	jae    8036ac <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803691:	a1 34 50 80 00       	mov    0x805034,%eax
  803696:	83 ec 04             	sub    $0x4,%esp
  803699:	ff 75 08             	pushl  0x8(%ebp)
  80369c:	6a 00                	push   $0x0
  80369e:	50                   	push   %eax
  80369f:	e8 b2 fb ff ff       	call   803256 <merging>
  8036a4:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8036a7:	e9 8b 00 00 00       	jmp    803737 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8036ac:	a1 30 50 80 00       	mov    0x805030,%eax
  8036b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036b4:	76 18                	jbe    8036ce <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8036b6:	a1 30 50 80 00       	mov    0x805030,%eax
  8036bb:	83 ec 04             	sub    $0x4,%esp
  8036be:	ff 75 08             	pushl  0x8(%ebp)
  8036c1:	50                   	push   %eax
  8036c2:	6a 00                	push   $0x0
  8036c4:	e8 8d fb ff ff       	call   803256 <merging>
  8036c9:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8036cc:	eb 69                	jmp    803737 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8036ce:	a1 30 50 80 00       	mov    0x805030,%eax
  8036d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036d6:	eb 39                	jmp    803711 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8036d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036de:	73 29                	jae    803709 <free_block+0x90>
  8036e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e3:	8b 00                	mov    (%eax),%eax
  8036e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036e8:	76 1f                	jbe    803709 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ed:	8b 00                	mov    (%eax),%eax
  8036ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8036f2:	83 ec 04             	sub    $0x4,%esp
  8036f5:	ff 75 08             	pushl  0x8(%ebp)
  8036f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8036fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8036fe:	e8 53 fb ff ff       	call   803256 <merging>
  803703:	83 c4 10             	add    $0x10,%esp
			break;
  803706:	90                   	nop
		}
	}
}
  803707:	eb 2e                	jmp    803737 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803709:	a1 38 50 80 00       	mov    0x805038,%eax
  80370e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803711:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803715:	74 07                	je     80371e <free_block+0xa5>
  803717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371a:	8b 00                	mov    (%eax),%eax
  80371c:	eb 05                	jmp    803723 <free_block+0xaa>
  80371e:	b8 00 00 00 00       	mov    $0x0,%eax
  803723:	a3 38 50 80 00       	mov    %eax,0x805038
  803728:	a1 38 50 80 00       	mov    0x805038,%eax
  80372d:	85 c0                	test   %eax,%eax
  80372f:	75 a7                	jne    8036d8 <free_block+0x5f>
  803731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803735:	75 a1                	jne    8036d8 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803737:	90                   	nop
  803738:	c9                   	leave  
  803739:	c3                   	ret    

0080373a <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80373a:	55                   	push   %ebp
  80373b:	89 e5                	mov    %esp,%ebp
  80373d:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803740:	ff 75 08             	pushl  0x8(%ebp)
  803743:	e8 ed ec ff ff       	call   802435 <get_block_size>
  803748:	83 c4 04             	add    $0x4,%esp
  80374b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80374e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803755:	eb 17                	jmp    80376e <copy_data+0x34>
  803757:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80375a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80375d:	01 c2                	add    %eax,%edx
  80375f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803762:	8b 45 08             	mov    0x8(%ebp),%eax
  803765:	01 c8                	add    %ecx,%eax
  803767:	8a 00                	mov    (%eax),%al
  803769:	88 02                	mov    %al,(%edx)
  80376b:	ff 45 fc             	incl   -0x4(%ebp)
  80376e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803771:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803774:	72 e1                	jb     803757 <copy_data+0x1d>
}
  803776:	90                   	nop
  803777:	c9                   	leave  
  803778:	c3                   	ret    

00803779 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803779:	55                   	push   %ebp
  80377a:	89 e5                	mov    %esp,%ebp
  80377c:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80377f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803783:	75 23                	jne    8037a8 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803785:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803789:	74 13                	je     80379e <realloc_block_FF+0x25>
  80378b:	83 ec 0c             	sub    $0xc,%esp
  80378e:	ff 75 0c             	pushl  0xc(%ebp)
  803791:	e8 1f f0 ff ff       	call   8027b5 <alloc_block_FF>
  803796:	83 c4 10             	add    $0x10,%esp
  803799:	e9 f4 06 00 00       	jmp    803e92 <realloc_block_FF+0x719>
		return NULL;
  80379e:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a3:	e9 ea 06 00 00       	jmp    803e92 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8037a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037ac:	75 18                	jne    8037c6 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8037ae:	83 ec 0c             	sub    $0xc,%esp
  8037b1:	ff 75 08             	pushl  0x8(%ebp)
  8037b4:	e8 c0 fe ff ff       	call   803679 <free_block>
  8037b9:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8037bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c1:	e9 cc 06 00 00       	jmp    803e92 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8037c6:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8037ca:	77 07                	ja     8037d3 <realloc_block_FF+0x5a>
  8037cc:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8037d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d6:	83 e0 01             	and    $0x1,%eax
  8037d9:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8037dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037df:	83 c0 08             	add    $0x8,%eax
  8037e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8037e5:	83 ec 0c             	sub    $0xc,%esp
  8037e8:	ff 75 08             	pushl  0x8(%ebp)
  8037eb:	e8 45 ec ff ff       	call   802435 <get_block_size>
  8037f0:	83 c4 10             	add    $0x10,%esp
  8037f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8037f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f9:	83 e8 08             	sub    $0x8,%eax
  8037fc:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8037ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803802:	83 e8 04             	sub    $0x4,%eax
  803805:	8b 00                	mov    (%eax),%eax
  803807:	83 e0 fe             	and    $0xfffffffe,%eax
  80380a:	89 c2                	mov    %eax,%edx
  80380c:	8b 45 08             	mov    0x8(%ebp),%eax
  80380f:	01 d0                	add    %edx,%eax
  803811:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803814:	83 ec 0c             	sub    $0xc,%esp
  803817:	ff 75 e4             	pushl  -0x1c(%ebp)
  80381a:	e8 16 ec ff ff       	call   802435 <get_block_size>
  80381f:	83 c4 10             	add    $0x10,%esp
  803822:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803825:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803828:	83 e8 08             	sub    $0x8,%eax
  80382b:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80382e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803831:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803834:	75 08                	jne    80383e <realloc_block_FF+0xc5>
	{
		 return va;
  803836:	8b 45 08             	mov    0x8(%ebp),%eax
  803839:	e9 54 06 00 00       	jmp    803e92 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80383e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803841:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803844:	0f 83 e5 03 00 00    	jae    803c2f <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80384a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803850:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803853:	83 ec 0c             	sub    $0xc,%esp
  803856:	ff 75 e4             	pushl  -0x1c(%ebp)
  803859:	e8 f0 eb ff ff       	call   80244e <is_free_block>
  80385e:	83 c4 10             	add    $0x10,%esp
  803861:	84 c0                	test   %al,%al
  803863:	0f 84 3b 01 00 00    	je     8039a4 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803869:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80386c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80386f:	01 d0                	add    %edx,%eax
  803871:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803874:	83 ec 04             	sub    $0x4,%esp
  803877:	6a 01                	push   $0x1
  803879:	ff 75 f0             	pushl  -0x10(%ebp)
  80387c:	ff 75 08             	pushl  0x8(%ebp)
  80387f:	e8 02 ef ff ff       	call   802786 <set_block_data>
  803884:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803887:	8b 45 08             	mov    0x8(%ebp),%eax
  80388a:	83 e8 04             	sub    $0x4,%eax
  80388d:	8b 00                	mov    (%eax),%eax
  80388f:	83 e0 fe             	and    $0xfffffffe,%eax
  803892:	89 c2                	mov    %eax,%edx
  803894:	8b 45 08             	mov    0x8(%ebp),%eax
  803897:	01 d0                	add    %edx,%eax
  803899:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80389c:	83 ec 04             	sub    $0x4,%esp
  80389f:	6a 00                	push   $0x0
  8038a1:	ff 75 cc             	pushl  -0x34(%ebp)
  8038a4:	ff 75 c8             	pushl  -0x38(%ebp)
  8038a7:	e8 da ee ff ff       	call   802786 <set_block_data>
  8038ac:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038b3:	74 06                	je     8038bb <realloc_block_FF+0x142>
  8038b5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8038b9:	75 17                	jne    8038d2 <realloc_block_FF+0x159>
  8038bb:	83 ec 04             	sub    $0x4,%esp
  8038be:	68 d4 4a 80 00       	push   $0x804ad4
  8038c3:	68 f6 01 00 00       	push   $0x1f6
  8038c8:	68 61 4a 80 00       	push   $0x804a61
  8038cd:	e8 6b ce ff ff       	call   80073d <_panic>
  8038d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d5:	8b 10                	mov    (%eax),%edx
  8038d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038da:	89 10                	mov    %edx,(%eax)
  8038dc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038df:	8b 00                	mov    (%eax),%eax
  8038e1:	85 c0                	test   %eax,%eax
  8038e3:	74 0b                	je     8038f0 <realloc_block_FF+0x177>
  8038e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e8:	8b 00                	mov    (%eax),%eax
  8038ea:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8038ed:	89 50 04             	mov    %edx,0x4(%eax)
  8038f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8038f6:	89 10                	mov    %edx,(%eax)
  8038f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038fe:	89 50 04             	mov    %edx,0x4(%eax)
  803901:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803904:	8b 00                	mov    (%eax),%eax
  803906:	85 c0                	test   %eax,%eax
  803908:	75 08                	jne    803912 <realloc_block_FF+0x199>
  80390a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80390d:	a3 34 50 80 00       	mov    %eax,0x805034
  803912:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803917:	40                   	inc    %eax
  803918:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80391d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803921:	75 17                	jne    80393a <realloc_block_FF+0x1c1>
  803923:	83 ec 04             	sub    $0x4,%esp
  803926:	68 43 4a 80 00       	push   $0x804a43
  80392b:	68 f7 01 00 00       	push   $0x1f7
  803930:	68 61 4a 80 00       	push   $0x804a61
  803935:	e8 03 ce ff ff       	call   80073d <_panic>
  80393a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393d:	8b 00                	mov    (%eax),%eax
  80393f:	85 c0                	test   %eax,%eax
  803941:	74 10                	je     803953 <realloc_block_FF+0x1da>
  803943:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803946:	8b 00                	mov    (%eax),%eax
  803948:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80394b:	8b 52 04             	mov    0x4(%edx),%edx
  80394e:	89 50 04             	mov    %edx,0x4(%eax)
  803951:	eb 0b                	jmp    80395e <realloc_block_FF+0x1e5>
  803953:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803956:	8b 40 04             	mov    0x4(%eax),%eax
  803959:	a3 34 50 80 00       	mov    %eax,0x805034
  80395e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803961:	8b 40 04             	mov    0x4(%eax),%eax
  803964:	85 c0                	test   %eax,%eax
  803966:	74 0f                	je     803977 <realloc_block_FF+0x1fe>
  803968:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396b:	8b 40 04             	mov    0x4(%eax),%eax
  80396e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803971:	8b 12                	mov    (%edx),%edx
  803973:	89 10                	mov    %edx,(%eax)
  803975:	eb 0a                	jmp    803981 <realloc_block_FF+0x208>
  803977:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397a:	8b 00                	mov    (%eax),%eax
  80397c:	a3 30 50 80 00       	mov    %eax,0x805030
  803981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803984:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80398a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803994:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803999:	48                   	dec    %eax
  80399a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80399f:	e9 83 02 00 00       	jmp    803c27 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8039a4:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8039a8:	0f 86 69 02 00 00    	jbe    803c17 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8039ae:	83 ec 04             	sub    $0x4,%esp
  8039b1:	6a 01                	push   $0x1
  8039b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8039b6:	ff 75 08             	pushl  0x8(%ebp)
  8039b9:	e8 c8 ed ff ff       	call   802786 <set_block_data>
  8039be:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c4:	83 e8 04             	sub    $0x4,%eax
  8039c7:	8b 00                	mov    (%eax),%eax
  8039c9:	83 e0 fe             	and    $0xfffffffe,%eax
  8039cc:	89 c2                	mov    %eax,%edx
  8039ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d1:	01 d0                	add    %edx,%eax
  8039d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8039d6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039db:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8039de:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8039e2:	75 68                	jne    803a4c <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8039e4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8039e8:	75 17                	jne    803a01 <realloc_block_FF+0x288>
  8039ea:	83 ec 04             	sub    $0x4,%esp
  8039ed:	68 7c 4a 80 00       	push   $0x804a7c
  8039f2:	68 06 02 00 00       	push   $0x206
  8039f7:	68 61 4a 80 00       	push   $0x804a61
  8039fc:	e8 3c cd ff ff       	call   80073d <_panic>
  803a01:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a0a:	89 10                	mov    %edx,(%eax)
  803a0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a0f:	8b 00                	mov    (%eax),%eax
  803a11:	85 c0                	test   %eax,%eax
  803a13:	74 0d                	je     803a22 <realloc_block_FF+0x2a9>
  803a15:	a1 30 50 80 00       	mov    0x805030,%eax
  803a1a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a1d:	89 50 04             	mov    %edx,0x4(%eax)
  803a20:	eb 08                	jmp    803a2a <realloc_block_FF+0x2b1>
  803a22:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a25:	a3 34 50 80 00       	mov    %eax,0x805034
  803a2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a2d:	a3 30 50 80 00       	mov    %eax,0x805030
  803a32:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a3c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a41:	40                   	inc    %eax
  803a42:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a47:	e9 b0 01 00 00       	jmp    803bfc <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803a4c:	a1 30 50 80 00       	mov    0x805030,%eax
  803a51:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803a54:	76 68                	jbe    803abe <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a56:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a5a:	75 17                	jne    803a73 <realloc_block_FF+0x2fa>
  803a5c:	83 ec 04             	sub    $0x4,%esp
  803a5f:	68 7c 4a 80 00       	push   $0x804a7c
  803a64:	68 0b 02 00 00       	push   $0x20b
  803a69:	68 61 4a 80 00       	push   $0x804a61
  803a6e:	e8 ca cc ff ff       	call   80073d <_panic>
  803a73:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a7c:	89 10                	mov    %edx,(%eax)
  803a7e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a81:	8b 00                	mov    (%eax),%eax
  803a83:	85 c0                	test   %eax,%eax
  803a85:	74 0d                	je     803a94 <realloc_block_FF+0x31b>
  803a87:	a1 30 50 80 00       	mov    0x805030,%eax
  803a8c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a8f:	89 50 04             	mov    %edx,0x4(%eax)
  803a92:	eb 08                	jmp    803a9c <realloc_block_FF+0x323>
  803a94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a97:	a3 34 50 80 00       	mov    %eax,0x805034
  803a9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a9f:	a3 30 50 80 00       	mov    %eax,0x805030
  803aa4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aa7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aae:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ab3:	40                   	inc    %eax
  803ab4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803ab9:	e9 3e 01 00 00       	jmp    803bfc <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803abe:	a1 30 50 80 00       	mov    0x805030,%eax
  803ac3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ac6:	73 68                	jae    803b30 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ac8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803acc:	75 17                	jne    803ae5 <realloc_block_FF+0x36c>
  803ace:	83 ec 04             	sub    $0x4,%esp
  803ad1:	68 b0 4a 80 00       	push   $0x804ab0
  803ad6:	68 10 02 00 00       	push   $0x210
  803adb:	68 61 4a 80 00       	push   $0x804a61
  803ae0:	e8 58 cc ff ff       	call   80073d <_panic>
  803ae5:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803aeb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aee:	89 50 04             	mov    %edx,0x4(%eax)
  803af1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803af4:	8b 40 04             	mov    0x4(%eax),%eax
  803af7:	85 c0                	test   %eax,%eax
  803af9:	74 0c                	je     803b07 <realloc_block_FF+0x38e>
  803afb:	a1 34 50 80 00       	mov    0x805034,%eax
  803b00:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b03:	89 10                	mov    %edx,(%eax)
  803b05:	eb 08                	jmp    803b0f <realloc_block_FF+0x396>
  803b07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b0a:	a3 30 50 80 00       	mov    %eax,0x805030
  803b0f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b12:	a3 34 50 80 00       	mov    %eax,0x805034
  803b17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b20:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b25:	40                   	inc    %eax
  803b26:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b2b:	e9 cc 00 00 00       	jmp    803bfc <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803b30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803b37:	a1 30 50 80 00       	mov    0x805030,%eax
  803b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b3f:	e9 8a 00 00 00       	jmp    803bce <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b47:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b4a:	73 7a                	jae    803bc6 <realloc_block_FF+0x44d>
  803b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4f:	8b 00                	mov    (%eax),%eax
  803b51:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b54:	73 70                	jae    803bc6 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803b56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b5a:	74 06                	je     803b62 <realloc_block_FF+0x3e9>
  803b5c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b60:	75 17                	jne    803b79 <realloc_block_FF+0x400>
  803b62:	83 ec 04             	sub    $0x4,%esp
  803b65:	68 d4 4a 80 00       	push   $0x804ad4
  803b6a:	68 1a 02 00 00       	push   $0x21a
  803b6f:	68 61 4a 80 00       	push   $0x804a61
  803b74:	e8 c4 cb ff ff       	call   80073d <_panic>
  803b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b7c:	8b 10                	mov    (%eax),%edx
  803b7e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b81:	89 10                	mov    %edx,(%eax)
  803b83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b86:	8b 00                	mov    (%eax),%eax
  803b88:	85 c0                	test   %eax,%eax
  803b8a:	74 0b                	je     803b97 <realloc_block_FF+0x41e>
  803b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b8f:	8b 00                	mov    (%eax),%eax
  803b91:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b94:	89 50 04             	mov    %edx,0x4(%eax)
  803b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b9d:	89 10                	mov    %edx,(%eax)
  803b9f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ba5:	89 50 04             	mov    %edx,0x4(%eax)
  803ba8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bab:	8b 00                	mov    (%eax),%eax
  803bad:	85 c0                	test   %eax,%eax
  803baf:	75 08                	jne    803bb9 <realloc_block_FF+0x440>
  803bb1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bb4:	a3 34 50 80 00       	mov    %eax,0x805034
  803bb9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bbe:	40                   	inc    %eax
  803bbf:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803bc4:	eb 36                	jmp    803bfc <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803bc6:	a1 38 50 80 00       	mov    0x805038,%eax
  803bcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bd2:	74 07                	je     803bdb <realloc_block_FF+0x462>
  803bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd7:	8b 00                	mov    (%eax),%eax
  803bd9:	eb 05                	jmp    803be0 <realloc_block_FF+0x467>
  803bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  803be0:	a3 38 50 80 00       	mov    %eax,0x805038
  803be5:	a1 38 50 80 00       	mov    0x805038,%eax
  803bea:	85 c0                	test   %eax,%eax
  803bec:	0f 85 52 ff ff ff    	jne    803b44 <realloc_block_FF+0x3cb>
  803bf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bf6:	0f 85 48 ff ff ff    	jne    803b44 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803bfc:	83 ec 04             	sub    $0x4,%esp
  803bff:	6a 00                	push   $0x0
  803c01:	ff 75 d8             	pushl  -0x28(%ebp)
  803c04:	ff 75 d4             	pushl  -0x2c(%ebp)
  803c07:	e8 7a eb ff ff       	call   802786 <set_block_data>
  803c0c:	83 c4 10             	add    $0x10,%esp
				return va;
  803c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c12:	e9 7b 02 00 00       	jmp    803e92 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803c17:	83 ec 0c             	sub    $0xc,%esp
  803c1a:	68 51 4b 80 00       	push   $0x804b51
  803c1f:	e8 d6 cd ff ff       	call   8009fa <cprintf>
  803c24:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803c27:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2a:	e9 63 02 00 00       	jmp    803e92 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c32:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c35:	0f 86 4d 02 00 00    	jbe    803e88 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803c3b:	83 ec 0c             	sub    $0xc,%esp
  803c3e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c41:	e8 08 e8 ff ff       	call   80244e <is_free_block>
  803c46:	83 c4 10             	add    $0x10,%esp
  803c49:	84 c0                	test   %al,%al
  803c4b:	0f 84 37 02 00 00    	je     803e88 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c54:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803c57:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803c5a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803c5d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803c60:	76 38                	jbe    803c9a <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803c62:	83 ec 0c             	sub    $0xc,%esp
  803c65:	ff 75 08             	pushl  0x8(%ebp)
  803c68:	e8 0c fa ff ff       	call   803679 <free_block>
  803c6d:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803c70:	83 ec 0c             	sub    $0xc,%esp
  803c73:	ff 75 0c             	pushl  0xc(%ebp)
  803c76:	e8 3a eb ff ff       	call   8027b5 <alloc_block_FF>
  803c7b:	83 c4 10             	add    $0x10,%esp
  803c7e:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803c81:	83 ec 08             	sub    $0x8,%esp
  803c84:	ff 75 c0             	pushl  -0x40(%ebp)
  803c87:	ff 75 08             	pushl  0x8(%ebp)
  803c8a:	e8 ab fa ff ff       	call   80373a <copy_data>
  803c8f:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803c92:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803c95:	e9 f8 01 00 00       	jmp    803e92 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803c9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c9d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803ca0:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803ca3:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803ca7:	0f 87 a0 00 00 00    	ja     803d4d <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803cad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cb1:	75 17                	jne    803cca <realloc_block_FF+0x551>
  803cb3:	83 ec 04             	sub    $0x4,%esp
  803cb6:	68 43 4a 80 00       	push   $0x804a43
  803cbb:	68 38 02 00 00       	push   $0x238
  803cc0:	68 61 4a 80 00       	push   $0x804a61
  803cc5:	e8 73 ca ff ff       	call   80073d <_panic>
  803cca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ccd:	8b 00                	mov    (%eax),%eax
  803ccf:	85 c0                	test   %eax,%eax
  803cd1:	74 10                	je     803ce3 <realloc_block_FF+0x56a>
  803cd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cd6:	8b 00                	mov    (%eax),%eax
  803cd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803cdb:	8b 52 04             	mov    0x4(%edx),%edx
  803cde:	89 50 04             	mov    %edx,0x4(%eax)
  803ce1:	eb 0b                	jmp    803cee <realloc_block_FF+0x575>
  803ce3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ce6:	8b 40 04             	mov    0x4(%eax),%eax
  803ce9:	a3 34 50 80 00       	mov    %eax,0x805034
  803cee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cf1:	8b 40 04             	mov    0x4(%eax),%eax
  803cf4:	85 c0                	test   %eax,%eax
  803cf6:	74 0f                	je     803d07 <realloc_block_FF+0x58e>
  803cf8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cfb:	8b 40 04             	mov    0x4(%eax),%eax
  803cfe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d01:	8b 12                	mov    (%edx),%edx
  803d03:	89 10                	mov    %edx,(%eax)
  803d05:	eb 0a                	jmp    803d11 <realloc_block_FF+0x598>
  803d07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d0a:	8b 00                	mov    (%eax),%eax
  803d0c:	a3 30 50 80 00       	mov    %eax,0x805030
  803d11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d24:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d29:	48                   	dec    %eax
  803d2a:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803d2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d35:	01 d0                	add    %edx,%eax
  803d37:	83 ec 04             	sub    $0x4,%esp
  803d3a:	6a 01                	push   $0x1
  803d3c:	50                   	push   %eax
  803d3d:	ff 75 08             	pushl  0x8(%ebp)
  803d40:	e8 41 ea ff ff       	call   802786 <set_block_data>
  803d45:	83 c4 10             	add    $0x10,%esp
  803d48:	e9 36 01 00 00       	jmp    803e83 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803d4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d50:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d53:	01 d0                	add    %edx,%eax
  803d55:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803d58:	83 ec 04             	sub    $0x4,%esp
  803d5b:	6a 01                	push   $0x1
  803d5d:	ff 75 f0             	pushl  -0x10(%ebp)
  803d60:	ff 75 08             	pushl  0x8(%ebp)
  803d63:	e8 1e ea ff ff       	call   802786 <set_block_data>
  803d68:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6e:	83 e8 04             	sub    $0x4,%eax
  803d71:	8b 00                	mov    (%eax),%eax
  803d73:	83 e0 fe             	and    $0xfffffffe,%eax
  803d76:	89 c2                	mov    %eax,%edx
  803d78:	8b 45 08             	mov    0x8(%ebp),%eax
  803d7b:	01 d0                	add    %edx,%eax
  803d7d:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803d80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d84:	74 06                	je     803d8c <realloc_block_FF+0x613>
  803d86:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803d8a:	75 17                	jne    803da3 <realloc_block_FF+0x62a>
  803d8c:	83 ec 04             	sub    $0x4,%esp
  803d8f:	68 d4 4a 80 00       	push   $0x804ad4
  803d94:	68 44 02 00 00       	push   $0x244
  803d99:	68 61 4a 80 00       	push   $0x804a61
  803d9e:	e8 9a c9 ff ff       	call   80073d <_panic>
  803da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da6:	8b 10                	mov    (%eax),%edx
  803da8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803dab:	89 10                	mov    %edx,(%eax)
  803dad:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803db0:	8b 00                	mov    (%eax),%eax
  803db2:	85 c0                	test   %eax,%eax
  803db4:	74 0b                	je     803dc1 <realloc_block_FF+0x648>
  803db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db9:	8b 00                	mov    (%eax),%eax
  803dbb:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803dbe:	89 50 04             	mov    %edx,0x4(%eax)
  803dc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803dc7:	89 10                	mov    %edx,(%eax)
  803dc9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803dcc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dcf:	89 50 04             	mov    %edx,0x4(%eax)
  803dd2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803dd5:	8b 00                	mov    (%eax),%eax
  803dd7:	85 c0                	test   %eax,%eax
  803dd9:	75 08                	jne    803de3 <realloc_block_FF+0x66a>
  803ddb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803dde:	a3 34 50 80 00       	mov    %eax,0x805034
  803de3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803de8:	40                   	inc    %eax
  803de9:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803dee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803df2:	75 17                	jne    803e0b <realloc_block_FF+0x692>
  803df4:	83 ec 04             	sub    $0x4,%esp
  803df7:	68 43 4a 80 00       	push   $0x804a43
  803dfc:	68 45 02 00 00       	push   $0x245
  803e01:	68 61 4a 80 00       	push   $0x804a61
  803e06:	e8 32 c9 ff ff       	call   80073d <_panic>
  803e0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e0e:	8b 00                	mov    (%eax),%eax
  803e10:	85 c0                	test   %eax,%eax
  803e12:	74 10                	je     803e24 <realloc_block_FF+0x6ab>
  803e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e17:	8b 00                	mov    (%eax),%eax
  803e19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e1c:	8b 52 04             	mov    0x4(%edx),%edx
  803e1f:	89 50 04             	mov    %edx,0x4(%eax)
  803e22:	eb 0b                	jmp    803e2f <realloc_block_FF+0x6b6>
  803e24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e27:	8b 40 04             	mov    0x4(%eax),%eax
  803e2a:	a3 34 50 80 00       	mov    %eax,0x805034
  803e2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e32:	8b 40 04             	mov    0x4(%eax),%eax
  803e35:	85 c0                	test   %eax,%eax
  803e37:	74 0f                	je     803e48 <realloc_block_FF+0x6cf>
  803e39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e3c:	8b 40 04             	mov    0x4(%eax),%eax
  803e3f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e42:	8b 12                	mov    (%edx),%edx
  803e44:	89 10                	mov    %edx,(%eax)
  803e46:	eb 0a                	jmp    803e52 <realloc_block_FF+0x6d9>
  803e48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e4b:	8b 00                	mov    (%eax),%eax
  803e4d:	a3 30 50 80 00       	mov    %eax,0x805030
  803e52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e65:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e6a:	48                   	dec    %eax
  803e6b:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803e70:	83 ec 04             	sub    $0x4,%esp
  803e73:	6a 00                	push   $0x0
  803e75:	ff 75 bc             	pushl  -0x44(%ebp)
  803e78:	ff 75 b8             	pushl  -0x48(%ebp)
  803e7b:	e8 06 e9 ff ff       	call   802786 <set_block_data>
  803e80:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803e83:	8b 45 08             	mov    0x8(%ebp),%eax
  803e86:	eb 0a                	jmp    803e92 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803e88:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803e8f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803e92:	c9                   	leave  
  803e93:	c3                   	ret    

00803e94 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803e94:	55                   	push   %ebp
  803e95:	89 e5                	mov    %esp,%ebp
  803e97:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803e9a:	83 ec 04             	sub    $0x4,%esp
  803e9d:	68 58 4b 80 00       	push   $0x804b58
  803ea2:	68 58 02 00 00       	push   $0x258
  803ea7:	68 61 4a 80 00       	push   $0x804a61
  803eac:	e8 8c c8 ff ff       	call   80073d <_panic>

00803eb1 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803eb1:	55                   	push   %ebp
  803eb2:	89 e5                	mov    %esp,%ebp
  803eb4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803eb7:	83 ec 04             	sub    $0x4,%esp
  803eba:	68 80 4b 80 00       	push   $0x804b80
  803ebf:	68 61 02 00 00       	push   $0x261
  803ec4:	68 61 4a 80 00       	push   $0x804a61
  803ec9:	e8 6f c8 ff ff       	call   80073d <_panic>
  803ece:	66 90                	xchg   %ax,%ax

00803ed0 <__udivdi3>:
  803ed0:	55                   	push   %ebp
  803ed1:	57                   	push   %edi
  803ed2:	56                   	push   %esi
  803ed3:	53                   	push   %ebx
  803ed4:	83 ec 1c             	sub    $0x1c,%esp
  803ed7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803edb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803edf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ee3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ee7:	89 ca                	mov    %ecx,%edx
  803ee9:	89 f8                	mov    %edi,%eax
  803eeb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803eef:	85 f6                	test   %esi,%esi
  803ef1:	75 2d                	jne    803f20 <__udivdi3+0x50>
  803ef3:	39 cf                	cmp    %ecx,%edi
  803ef5:	77 65                	ja     803f5c <__udivdi3+0x8c>
  803ef7:	89 fd                	mov    %edi,%ebp
  803ef9:	85 ff                	test   %edi,%edi
  803efb:	75 0b                	jne    803f08 <__udivdi3+0x38>
  803efd:	b8 01 00 00 00       	mov    $0x1,%eax
  803f02:	31 d2                	xor    %edx,%edx
  803f04:	f7 f7                	div    %edi
  803f06:	89 c5                	mov    %eax,%ebp
  803f08:	31 d2                	xor    %edx,%edx
  803f0a:	89 c8                	mov    %ecx,%eax
  803f0c:	f7 f5                	div    %ebp
  803f0e:	89 c1                	mov    %eax,%ecx
  803f10:	89 d8                	mov    %ebx,%eax
  803f12:	f7 f5                	div    %ebp
  803f14:	89 cf                	mov    %ecx,%edi
  803f16:	89 fa                	mov    %edi,%edx
  803f18:	83 c4 1c             	add    $0x1c,%esp
  803f1b:	5b                   	pop    %ebx
  803f1c:	5e                   	pop    %esi
  803f1d:	5f                   	pop    %edi
  803f1e:	5d                   	pop    %ebp
  803f1f:	c3                   	ret    
  803f20:	39 ce                	cmp    %ecx,%esi
  803f22:	77 28                	ja     803f4c <__udivdi3+0x7c>
  803f24:	0f bd fe             	bsr    %esi,%edi
  803f27:	83 f7 1f             	xor    $0x1f,%edi
  803f2a:	75 40                	jne    803f6c <__udivdi3+0x9c>
  803f2c:	39 ce                	cmp    %ecx,%esi
  803f2e:	72 0a                	jb     803f3a <__udivdi3+0x6a>
  803f30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f34:	0f 87 9e 00 00 00    	ja     803fd8 <__udivdi3+0x108>
  803f3a:	b8 01 00 00 00       	mov    $0x1,%eax
  803f3f:	89 fa                	mov    %edi,%edx
  803f41:	83 c4 1c             	add    $0x1c,%esp
  803f44:	5b                   	pop    %ebx
  803f45:	5e                   	pop    %esi
  803f46:	5f                   	pop    %edi
  803f47:	5d                   	pop    %ebp
  803f48:	c3                   	ret    
  803f49:	8d 76 00             	lea    0x0(%esi),%esi
  803f4c:	31 ff                	xor    %edi,%edi
  803f4e:	31 c0                	xor    %eax,%eax
  803f50:	89 fa                	mov    %edi,%edx
  803f52:	83 c4 1c             	add    $0x1c,%esp
  803f55:	5b                   	pop    %ebx
  803f56:	5e                   	pop    %esi
  803f57:	5f                   	pop    %edi
  803f58:	5d                   	pop    %ebp
  803f59:	c3                   	ret    
  803f5a:	66 90                	xchg   %ax,%ax
  803f5c:	89 d8                	mov    %ebx,%eax
  803f5e:	f7 f7                	div    %edi
  803f60:	31 ff                	xor    %edi,%edi
  803f62:	89 fa                	mov    %edi,%edx
  803f64:	83 c4 1c             	add    $0x1c,%esp
  803f67:	5b                   	pop    %ebx
  803f68:	5e                   	pop    %esi
  803f69:	5f                   	pop    %edi
  803f6a:	5d                   	pop    %ebp
  803f6b:	c3                   	ret    
  803f6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f71:	89 eb                	mov    %ebp,%ebx
  803f73:	29 fb                	sub    %edi,%ebx
  803f75:	89 f9                	mov    %edi,%ecx
  803f77:	d3 e6                	shl    %cl,%esi
  803f79:	89 c5                	mov    %eax,%ebp
  803f7b:	88 d9                	mov    %bl,%cl
  803f7d:	d3 ed                	shr    %cl,%ebp
  803f7f:	89 e9                	mov    %ebp,%ecx
  803f81:	09 f1                	or     %esi,%ecx
  803f83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f87:	89 f9                	mov    %edi,%ecx
  803f89:	d3 e0                	shl    %cl,%eax
  803f8b:	89 c5                	mov    %eax,%ebp
  803f8d:	89 d6                	mov    %edx,%esi
  803f8f:	88 d9                	mov    %bl,%cl
  803f91:	d3 ee                	shr    %cl,%esi
  803f93:	89 f9                	mov    %edi,%ecx
  803f95:	d3 e2                	shl    %cl,%edx
  803f97:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f9b:	88 d9                	mov    %bl,%cl
  803f9d:	d3 e8                	shr    %cl,%eax
  803f9f:	09 c2                	or     %eax,%edx
  803fa1:	89 d0                	mov    %edx,%eax
  803fa3:	89 f2                	mov    %esi,%edx
  803fa5:	f7 74 24 0c          	divl   0xc(%esp)
  803fa9:	89 d6                	mov    %edx,%esi
  803fab:	89 c3                	mov    %eax,%ebx
  803fad:	f7 e5                	mul    %ebp
  803faf:	39 d6                	cmp    %edx,%esi
  803fb1:	72 19                	jb     803fcc <__udivdi3+0xfc>
  803fb3:	74 0b                	je     803fc0 <__udivdi3+0xf0>
  803fb5:	89 d8                	mov    %ebx,%eax
  803fb7:	31 ff                	xor    %edi,%edi
  803fb9:	e9 58 ff ff ff       	jmp    803f16 <__udivdi3+0x46>
  803fbe:	66 90                	xchg   %ax,%ax
  803fc0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803fc4:	89 f9                	mov    %edi,%ecx
  803fc6:	d3 e2                	shl    %cl,%edx
  803fc8:	39 c2                	cmp    %eax,%edx
  803fca:	73 e9                	jae    803fb5 <__udivdi3+0xe5>
  803fcc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803fcf:	31 ff                	xor    %edi,%edi
  803fd1:	e9 40 ff ff ff       	jmp    803f16 <__udivdi3+0x46>
  803fd6:	66 90                	xchg   %ax,%ax
  803fd8:	31 c0                	xor    %eax,%eax
  803fda:	e9 37 ff ff ff       	jmp    803f16 <__udivdi3+0x46>
  803fdf:	90                   	nop

00803fe0 <__umoddi3>:
  803fe0:	55                   	push   %ebp
  803fe1:	57                   	push   %edi
  803fe2:	56                   	push   %esi
  803fe3:	53                   	push   %ebx
  803fe4:	83 ec 1c             	sub    $0x1c,%esp
  803fe7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803feb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803fef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ff3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ff7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ffb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803fff:	89 f3                	mov    %esi,%ebx
  804001:	89 fa                	mov    %edi,%edx
  804003:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804007:	89 34 24             	mov    %esi,(%esp)
  80400a:	85 c0                	test   %eax,%eax
  80400c:	75 1a                	jne    804028 <__umoddi3+0x48>
  80400e:	39 f7                	cmp    %esi,%edi
  804010:	0f 86 a2 00 00 00    	jbe    8040b8 <__umoddi3+0xd8>
  804016:	89 c8                	mov    %ecx,%eax
  804018:	89 f2                	mov    %esi,%edx
  80401a:	f7 f7                	div    %edi
  80401c:	89 d0                	mov    %edx,%eax
  80401e:	31 d2                	xor    %edx,%edx
  804020:	83 c4 1c             	add    $0x1c,%esp
  804023:	5b                   	pop    %ebx
  804024:	5e                   	pop    %esi
  804025:	5f                   	pop    %edi
  804026:	5d                   	pop    %ebp
  804027:	c3                   	ret    
  804028:	39 f0                	cmp    %esi,%eax
  80402a:	0f 87 ac 00 00 00    	ja     8040dc <__umoddi3+0xfc>
  804030:	0f bd e8             	bsr    %eax,%ebp
  804033:	83 f5 1f             	xor    $0x1f,%ebp
  804036:	0f 84 ac 00 00 00    	je     8040e8 <__umoddi3+0x108>
  80403c:	bf 20 00 00 00       	mov    $0x20,%edi
  804041:	29 ef                	sub    %ebp,%edi
  804043:	89 fe                	mov    %edi,%esi
  804045:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804049:	89 e9                	mov    %ebp,%ecx
  80404b:	d3 e0                	shl    %cl,%eax
  80404d:	89 d7                	mov    %edx,%edi
  80404f:	89 f1                	mov    %esi,%ecx
  804051:	d3 ef                	shr    %cl,%edi
  804053:	09 c7                	or     %eax,%edi
  804055:	89 e9                	mov    %ebp,%ecx
  804057:	d3 e2                	shl    %cl,%edx
  804059:	89 14 24             	mov    %edx,(%esp)
  80405c:	89 d8                	mov    %ebx,%eax
  80405e:	d3 e0                	shl    %cl,%eax
  804060:	89 c2                	mov    %eax,%edx
  804062:	8b 44 24 08          	mov    0x8(%esp),%eax
  804066:	d3 e0                	shl    %cl,%eax
  804068:	89 44 24 04          	mov    %eax,0x4(%esp)
  80406c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804070:	89 f1                	mov    %esi,%ecx
  804072:	d3 e8                	shr    %cl,%eax
  804074:	09 d0                	or     %edx,%eax
  804076:	d3 eb                	shr    %cl,%ebx
  804078:	89 da                	mov    %ebx,%edx
  80407a:	f7 f7                	div    %edi
  80407c:	89 d3                	mov    %edx,%ebx
  80407e:	f7 24 24             	mull   (%esp)
  804081:	89 c6                	mov    %eax,%esi
  804083:	89 d1                	mov    %edx,%ecx
  804085:	39 d3                	cmp    %edx,%ebx
  804087:	0f 82 87 00 00 00    	jb     804114 <__umoddi3+0x134>
  80408d:	0f 84 91 00 00 00    	je     804124 <__umoddi3+0x144>
  804093:	8b 54 24 04          	mov    0x4(%esp),%edx
  804097:	29 f2                	sub    %esi,%edx
  804099:	19 cb                	sbb    %ecx,%ebx
  80409b:	89 d8                	mov    %ebx,%eax
  80409d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8040a1:	d3 e0                	shl    %cl,%eax
  8040a3:	89 e9                	mov    %ebp,%ecx
  8040a5:	d3 ea                	shr    %cl,%edx
  8040a7:	09 d0                	or     %edx,%eax
  8040a9:	89 e9                	mov    %ebp,%ecx
  8040ab:	d3 eb                	shr    %cl,%ebx
  8040ad:	89 da                	mov    %ebx,%edx
  8040af:	83 c4 1c             	add    $0x1c,%esp
  8040b2:	5b                   	pop    %ebx
  8040b3:	5e                   	pop    %esi
  8040b4:	5f                   	pop    %edi
  8040b5:	5d                   	pop    %ebp
  8040b6:	c3                   	ret    
  8040b7:	90                   	nop
  8040b8:	89 fd                	mov    %edi,%ebp
  8040ba:	85 ff                	test   %edi,%edi
  8040bc:	75 0b                	jne    8040c9 <__umoddi3+0xe9>
  8040be:	b8 01 00 00 00       	mov    $0x1,%eax
  8040c3:	31 d2                	xor    %edx,%edx
  8040c5:	f7 f7                	div    %edi
  8040c7:	89 c5                	mov    %eax,%ebp
  8040c9:	89 f0                	mov    %esi,%eax
  8040cb:	31 d2                	xor    %edx,%edx
  8040cd:	f7 f5                	div    %ebp
  8040cf:	89 c8                	mov    %ecx,%eax
  8040d1:	f7 f5                	div    %ebp
  8040d3:	89 d0                	mov    %edx,%eax
  8040d5:	e9 44 ff ff ff       	jmp    80401e <__umoddi3+0x3e>
  8040da:	66 90                	xchg   %ax,%ax
  8040dc:	89 c8                	mov    %ecx,%eax
  8040de:	89 f2                	mov    %esi,%edx
  8040e0:	83 c4 1c             	add    $0x1c,%esp
  8040e3:	5b                   	pop    %ebx
  8040e4:	5e                   	pop    %esi
  8040e5:	5f                   	pop    %edi
  8040e6:	5d                   	pop    %ebp
  8040e7:	c3                   	ret    
  8040e8:	3b 04 24             	cmp    (%esp),%eax
  8040eb:	72 06                	jb     8040f3 <__umoddi3+0x113>
  8040ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8040f1:	77 0f                	ja     804102 <__umoddi3+0x122>
  8040f3:	89 f2                	mov    %esi,%edx
  8040f5:	29 f9                	sub    %edi,%ecx
  8040f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8040fb:	89 14 24             	mov    %edx,(%esp)
  8040fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804102:	8b 44 24 04          	mov    0x4(%esp),%eax
  804106:	8b 14 24             	mov    (%esp),%edx
  804109:	83 c4 1c             	add    $0x1c,%esp
  80410c:	5b                   	pop    %ebx
  80410d:	5e                   	pop    %esi
  80410e:	5f                   	pop    %edi
  80410f:	5d                   	pop    %ebp
  804110:	c3                   	ret    
  804111:	8d 76 00             	lea    0x0(%esi),%esi
  804114:	2b 04 24             	sub    (%esp),%eax
  804117:	19 fa                	sbb    %edi,%edx
  804119:	89 d1                	mov    %edx,%ecx
  80411b:	89 c6                	mov    %eax,%esi
  80411d:	e9 71 ff ff ff       	jmp    804093 <__umoddi3+0xb3>
  804122:	66 90                	xchg   %ax,%ax
  804124:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804128:	72 ea                	jb     804114 <__umoddi3+0x134>
  80412a:	89 d9                	mov    %ebx,%ecx
  80412c:	e9 62 ff ff ff       	jmp    804093 <__umoddi3+0xb3>
