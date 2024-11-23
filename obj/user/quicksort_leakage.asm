
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
  800041:	e8 e5 1e 00 00       	call   801f2b <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 42 80 00       	push   $0x804200
  80004e:	e8 a7 09 00 00       	call   8009fa <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 42 80 00       	push   $0x804202
  80005e:	e8 97 09 00 00       	call   8009fa <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 1b 42 80 00       	push   $0x80421b
  80006e:	e8 87 09 00 00       	call   8009fa <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 42 80 00       	push   $0x804202
  80007e:	e8 77 09 00 00       	call   8009fa <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 42 80 00       	push   $0x804200
  80008e:	e8 67 09 00 00       	call   8009fa <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 34 42 80 00       	push   $0x804234
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
  8000c9:	68 54 42 80 00       	push   $0x804254
  8000ce:	e8 27 09 00 00       	call   8009fa <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 76 42 80 00       	push   $0x804276
  8000de:	e8 17 09 00 00       	call   8009fa <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 84 42 80 00       	push   $0x804284
  8000ee:	e8 07 09 00 00       	call   8009fa <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 93 42 80 00       	push   $0x804293
  8000fe:	e8 f7 08 00 00       	call   8009fa <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 a3 42 80 00       	push   $0x8042a3
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
  80014d:	e8 f3 1d 00 00       	call   801f45 <sys_unlock_cons>
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
  8001d5:	e8 51 1d 00 00       	call   801f2b <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 ac 42 80 00       	push   $0x8042ac
  8001e2:	e8 13 08 00 00       	call   8009fa <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 56 1d 00 00       	call   801f45 <sys_unlock_cons>
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
  80020c:	68 e0 42 80 00       	push   $0x8042e0
  800211:	6a 54                	push   $0x54
  800213:	68 02 43 80 00       	push   $0x804302
  800218:	e8 20 05 00 00       	call   80073d <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 09 1d 00 00       	call   801f2b <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 1c 43 80 00       	push   $0x80431c
  80022a:	e8 cb 07 00 00       	call   8009fa <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 50 43 80 00       	push   $0x804350
  80023a:	e8 bb 07 00 00       	call   8009fa <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 84 43 80 00       	push   $0x804384
  80024a:	e8 ab 07 00 00       	call   8009fa <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 ee 1c 00 00       	call   801f45 <sys_unlock_cons>


		}

		//		sys_lock_cons();
		sys_lock_cons();
  800257:	e8 cf 1c 00 00       	call   801f2b <sys_lock_cons>
		{
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 b6 43 80 00       	push   $0x8043b6
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
  8002b0:	e8 90 1c 00 00       	call   801f45 <sys_unlock_cons>
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
  800562:	68 00 42 80 00       	push   $0x804200
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
  800584:	68 d4 43 80 00       	push   $0x8043d4
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
  8005b2:	68 d9 43 80 00       	push   $0x8043d9
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
  8005d6:	e8 9b 1a 00 00       	call   802076 <sys_cputc>
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
  8005e7:	e8 26 19 00 00       	call   801f12 <sys_cgetc>
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
  800604:	e8 9e 1b 00 00       	call   8021a7 <sys_getenvindex>
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
  800672:	e8 b4 18 00 00       	call   801f2b <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800677:	83 ec 0c             	sub    $0xc,%esp
  80067a:	68 f8 43 80 00       	push   $0x8043f8
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
  8006a2:	68 20 44 80 00       	push   $0x804420
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
  8006d3:	68 48 44 80 00       	push   $0x804448
  8006d8:	e8 1d 03 00 00       	call   8009fa <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006e0:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	50                   	push   %eax
  8006ef:	68 a0 44 80 00       	push   $0x8044a0
  8006f4:	e8 01 03 00 00       	call   8009fa <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	68 f8 43 80 00       	push   $0x8043f8
  800704:	e8 f1 02 00 00       	call   8009fa <cprintf>
  800709:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80070c:	e8 34 18 00 00       	call   801f45 <sys_unlock_cons>
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
  800724:	e8 4a 1a 00 00       	call   802173 <sys_destroy_env>
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
  800735:	e8 9f 1a 00 00       	call   8021d9 <sys_exit_env>
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
  80075e:	68 b4 44 80 00       	push   $0x8044b4
  800763:	e8 92 02 00 00       	call   8009fa <cprintf>
  800768:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80076b:	a1 00 50 80 00       	mov    0x805000,%eax
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	ff 75 08             	pushl  0x8(%ebp)
  800776:	50                   	push   %eax
  800777:	68 b9 44 80 00       	push   $0x8044b9
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
  80079b:	68 d5 44 80 00       	push   $0x8044d5
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
  8007ca:	68 d8 44 80 00       	push   $0x8044d8
  8007cf:	6a 26                	push   $0x26
  8007d1:	68 24 45 80 00       	push   $0x804524
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
  80089f:	68 30 45 80 00       	push   $0x804530
  8008a4:	6a 3a                	push   $0x3a
  8008a6:	68 24 45 80 00       	push   $0x804524
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
  800912:	68 84 45 80 00       	push   $0x804584
  800917:	6a 44                	push   $0x44
  800919:	68 24 45 80 00       	push   $0x804524
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
  80096c:	e8 78 15 00 00       	call   801ee9 <sys_cputs>
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
  8009e3:	e8 01 15 00 00       	call   801ee9 <sys_cputs>
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
  800a2d:	e8 f9 14 00 00       	call   801f2b <sys_lock_cons>
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
  800a4d:	e8 f3 14 00 00       	call   801f45 <sys_unlock_cons>
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
  800a97:	e8 e4 34 00 00       	call   803f80 <__udivdi3>
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
  800ae7:	e8 a4 35 00 00       	call   804090 <__umoddi3>
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	05 f4 47 80 00       	add    $0x8047f4,%eax
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
  800c42:	8b 04 85 18 48 80 00 	mov    0x804818(,%eax,4),%eax
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
  800d23:	8b 34 9d 60 46 80 00 	mov    0x804660(,%ebx,4),%esi
  800d2a:	85 f6                	test   %esi,%esi
  800d2c:	75 19                	jne    800d47 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d2e:	53                   	push   %ebx
  800d2f:	68 05 48 80 00       	push   $0x804805
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
  800d48:	68 0e 48 80 00       	push   $0x80480e
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
  800d75:	be 11 48 80 00       	mov    $0x804811,%esi
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
  8010a0:	68 88 49 80 00       	push   $0x804988
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
  8010e2:	68 8b 49 80 00       	push   $0x80498b
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
  801193:	e8 93 0d 00 00       	call   801f2b <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801198:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80119c:	74 13                	je     8011b1 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	ff 75 08             	pushl  0x8(%ebp)
  8011a4:	68 88 49 80 00       	push   $0x804988
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
  8011e6:	68 8b 49 80 00       	push   $0x80498b
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
  80128e:	e8 b2 0c 00 00       	call   801f45 <sys_unlock_cons>
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
  801988:	68 9c 49 80 00       	push   $0x80499c
  80198d:	68 3f 01 00 00       	push   $0x13f
  801992:	68 be 49 80 00       	push   $0x8049be
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
  8019a8:	e8 e7 0a 00 00       	call   802494 <sys_sbrk>
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
  801a23:	e8 f0 08 00 00       	call   802318 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	74 16                	je     801a42 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a2c:	83 ec 0c             	sub    $0xc,%esp
  801a2f:	ff 75 08             	pushl  0x8(%ebp)
  801a32:	e8 30 0e 00 00       	call   802867 <alloc_block_FF>
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a3d:	e9 8a 01 00 00       	jmp    801bcc <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801a42:	e8 02 09 00 00       	call   802349 <sys_isUHeapPlacementStrategyBESTFIT>
  801a47:	85 c0                	test   %eax,%eax
  801a49:	0f 84 7d 01 00 00    	je     801bcc <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	e8 c9 12 00 00       	call   802d23 <alloc_block_BF>
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
  801aa5:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801af2:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801bab:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801bb2:	83 ec 08             	sub    $0x8,%esp
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	ff 75 f0             	pushl  -0x10(%ebp)
  801bbb:	e8 0b 09 00 00       	call   8024cb <sys_allocate_user_mem>
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
  801c03:	e8 df 08 00 00       	call   8024e7 <get_block_size>
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c0e:	83 ec 0c             	sub    $0xc,%esp
  801c11:	ff 75 08             	pushl  0x8(%ebp)
  801c14:	e8 12 1b 00 00       	call   80372b <free_block>
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
  801c4e:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801c8b:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  801cab:	e8 ff 07 00 00       	call   8024af <sys_free_user_mem>
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
  801cb9:	68 cc 49 80 00       	push   $0x8049cc
  801cbe:	68 85 00 00 00       	push   $0x85
  801cc3:	68 f6 49 80 00       	push   $0x8049f6
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
  801cdf:	75 0a                	jne    801ceb <smalloc+0x1c>
  801ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce6:	e9 9a 00 00 00       	jmp    801d85 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cf1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801cf8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfe:	39 d0                	cmp    %edx,%eax
  801d00:	73 02                	jae    801d04 <smalloc+0x35>
  801d02:	89 d0                	mov    %edx,%eax
  801d04:	83 ec 0c             	sub    $0xc,%esp
  801d07:	50                   	push   %eax
  801d08:	e8 a5 fc ff ff       	call   8019b2 <malloc>
  801d0d:	83 c4 10             	add    $0x10,%esp
  801d10:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801d13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d17:	75 07                	jne    801d20 <smalloc+0x51>
  801d19:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1e:	eb 65                	jmp    801d85 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d20:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d24:	ff 75 ec             	pushl  -0x14(%ebp)
  801d27:	50                   	push   %eax
  801d28:	ff 75 0c             	pushl  0xc(%ebp)
  801d2b:	ff 75 08             	pushl  0x8(%ebp)
  801d2e:	e8 83 03 00 00       	call   8020b6 <sys_createSharedObject>
  801d33:	83 c4 10             	add    $0x10,%esp
  801d36:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801d39:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801d3d:	74 06                	je     801d45 <smalloc+0x76>
  801d3f:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801d43:	75 07                	jne    801d4c <smalloc+0x7d>
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4a:	eb 39                	jmp    801d85 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801d4c:	83 ec 08             	sub    $0x8,%esp
  801d4f:	ff 75 ec             	pushl  -0x14(%ebp)
  801d52:	68 02 4a 80 00       	push   $0x804a02
  801d57:	e8 9e ec ff ff       	call   8009fa <cprintf>
  801d5c:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801d5f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d62:	a1 24 50 80 00       	mov    0x805024,%eax
  801d67:	8b 40 78             	mov    0x78(%eax),%eax
  801d6a:	29 c2                	sub    %eax,%edx
  801d6c:	89 d0                	mov    %edx,%eax
  801d6e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d73:	c1 e8 0c             	shr    $0xc,%eax
  801d76:	89 c2                	mov    %eax,%edx
  801d78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d7b:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d8d:	83 ec 08             	sub    $0x8,%esp
  801d90:	ff 75 0c             	pushl  0xc(%ebp)
  801d93:	ff 75 08             	pushl  0x8(%ebp)
  801d96:	e8 45 03 00 00       	call   8020e0 <sys_getSizeOfSharedObject>
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801da1:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801da5:	75 07                	jne    801dae <sget+0x27>
  801da7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dac:	eb 5c                	jmp    801e0a <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801db4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801dbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc1:	39 d0                	cmp    %edx,%eax
  801dc3:	7d 02                	jge    801dc7 <sget+0x40>
  801dc5:	89 d0                	mov    %edx,%eax
  801dc7:	83 ec 0c             	sub    $0xc,%esp
  801dca:	50                   	push   %eax
  801dcb:	e8 e2 fb ff ff       	call   8019b2 <malloc>
  801dd0:	83 c4 10             	add    $0x10,%esp
  801dd3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801dd6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801dda:	75 07                	jne    801de3 <sget+0x5c>
  801ddc:	b8 00 00 00 00       	mov    $0x0,%eax
  801de1:	eb 27                	jmp    801e0a <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801de3:	83 ec 04             	sub    $0x4,%esp
  801de6:	ff 75 e8             	pushl  -0x18(%ebp)
  801de9:	ff 75 0c             	pushl  0xc(%ebp)
  801dec:	ff 75 08             	pushl  0x8(%ebp)
  801def:	e8 09 03 00 00       	call   8020fd <sys_getSharedObject>
  801df4:	83 c4 10             	add    $0x10,%esp
  801df7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801dfa:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801dfe:	75 07                	jne    801e07 <sget+0x80>
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
  801e05:	eb 03                	jmp    801e0a <sget+0x83>
	return ptr;
  801e07:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801e12:	8b 55 08             	mov    0x8(%ebp),%edx
  801e15:	a1 24 50 80 00       	mov    0x805024,%eax
  801e1a:	8b 40 78             	mov    0x78(%eax),%eax
  801e1d:	29 c2                	sub    %eax,%edx
  801e1f:	89 d0                	mov    %edx,%eax
  801e21:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e26:	c1 e8 0c             	shr    $0xc,%eax
  801e29:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801e30:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801e33:	83 ec 08             	sub    $0x8,%esp
  801e36:	ff 75 08             	pushl  0x8(%ebp)
  801e39:	ff 75 f4             	pushl  -0xc(%ebp)
  801e3c:	e8 db 02 00 00       	call   80211c <sys_freeSharedObject>
  801e41:	83 c4 10             	add    $0x10,%esp
  801e44:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801e47:	90                   	nop
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e50:	83 ec 04             	sub    $0x4,%esp
  801e53:	68 14 4a 80 00       	push   $0x804a14
  801e58:	68 dd 00 00 00       	push   $0xdd
  801e5d:	68 f6 49 80 00       	push   $0x8049f6
  801e62:	e8 d6 e8 ff ff       	call   80073d <_panic>

00801e67 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e6d:	83 ec 04             	sub    $0x4,%esp
  801e70:	68 3a 4a 80 00       	push   $0x804a3a
  801e75:	68 e9 00 00 00       	push   $0xe9
  801e7a:	68 f6 49 80 00       	push   $0x8049f6
  801e7f:	e8 b9 e8 ff ff       	call   80073d <_panic>

00801e84 <shrink>:

}
void shrink(uint32 newSize)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e8a:	83 ec 04             	sub    $0x4,%esp
  801e8d:	68 3a 4a 80 00       	push   $0x804a3a
  801e92:	68 ee 00 00 00       	push   $0xee
  801e97:	68 f6 49 80 00       	push   $0x8049f6
  801e9c:	e8 9c e8 ff ff       	call   80073d <_panic>

00801ea1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ea7:	83 ec 04             	sub    $0x4,%esp
  801eaa:	68 3a 4a 80 00       	push   $0x804a3a
  801eaf:	68 f3 00 00 00       	push   $0xf3
  801eb4:	68 f6 49 80 00       	push   $0x8049f6
  801eb9:	e8 7f e8 ff ff       	call   80073d <_panic>

00801ebe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	57                   	push   %edi
  801ec2:	56                   	push   %esi
  801ec3:	53                   	push   %ebx
  801ec4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ed0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ed3:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ed6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ed9:	cd 30                	int    $0x30
  801edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ee1:	83 c4 10             	add    $0x10,%esp
  801ee4:	5b                   	pop    %ebx
  801ee5:	5e                   	pop    %esi
  801ee6:	5f                   	pop    %edi
  801ee7:	5d                   	pop    %ebp
  801ee8:	c3                   	ret    

00801ee9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 04             	sub    $0x4,%esp
  801eef:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ef5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	52                   	push   %edx
  801f01:	ff 75 0c             	pushl  0xc(%ebp)
  801f04:	50                   	push   %eax
  801f05:	6a 00                	push   $0x0
  801f07:	e8 b2 ff ff ff       	call   801ebe <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	90                   	nop
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 02                	push   $0x2
  801f21:	e8 98 ff ff ff       	call   801ebe <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_lock_cons>:

void sys_lock_cons(void)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 03                	push   $0x3
  801f3a:	e8 7f ff ff ff       	call   801ebe <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
}
  801f42:	90                   	nop
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 04                	push   $0x4
  801f54:	e8 65 ff ff ff       	call   801ebe <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
}
  801f5c:	90                   	nop
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	52                   	push   %edx
  801f6f:	50                   	push   %eax
  801f70:	6a 08                	push   $0x8
  801f72:	e8 47 ff ff ff       	call   801ebe <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	56                   	push   %esi
  801f80:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f81:	8b 75 18             	mov    0x18(%ebp),%esi
  801f84:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f87:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	56                   	push   %esi
  801f91:	53                   	push   %ebx
  801f92:	51                   	push   %ecx
  801f93:	52                   	push   %edx
  801f94:	50                   	push   %eax
  801f95:	6a 09                	push   $0x9
  801f97:	e8 22 ff ff ff       	call   801ebe <syscall>
  801f9c:	83 c4 18             	add    $0x18,%esp
}
  801f9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fa2:	5b                   	pop    %ebx
  801fa3:	5e                   	pop    %esi
  801fa4:	5d                   	pop    %ebp
  801fa5:	c3                   	ret    

00801fa6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	52                   	push   %edx
  801fb6:	50                   	push   %eax
  801fb7:	6a 0a                	push   $0xa
  801fb9:	e8 00 ff ff ff       	call   801ebe <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	ff 75 0c             	pushl  0xc(%ebp)
  801fcf:	ff 75 08             	pushl  0x8(%ebp)
  801fd2:	6a 0b                	push   $0xb
  801fd4:	e8 e5 fe ff ff       	call   801ebe <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 0c                	push   $0xc
  801fed:	e8 cc fe ff ff       	call   801ebe <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 0d                	push   $0xd
  802006:	e8 b3 fe ff ff       	call   801ebe <syscall>
  80200b:	83 c4 18             	add    $0x18,%esp
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 0e                	push   $0xe
  80201f:	e8 9a fe ff ff       	call   801ebe <syscall>
  802024:	83 c4 18             	add    $0x18,%esp
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 0f                	push   $0xf
  802038:	e8 81 fe ff ff       	call   801ebe <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	ff 75 08             	pushl  0x8(%ebp)
  802050:	6a 10                	push   $0x10
  802052:	e8 67 fe ff ff       	call   801ebe <syscall>
  802057:	83 c4 18             	add    $0x18,%esp
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 11                	push   $0x11
  80206b:	e8 4e fe ff ff       	call   801ebe <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	90                   	nop
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <sys_cputc>:

void
sys_cputc(const char c)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	83 ec 04             	sub    $0x4,%esp
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802082:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	50                   	push   %eax
  80208f:	6a 01                	push   $0x1
  802091:	e8 28 fe ff ff       	call   801ebe <syscall>
  802096:	83 c4 18             	add    $0x18,%esp
}
  802099:	90                   	nop
  80209a:	c9                   	leave  
  80209b:	c3                   	ret    

0080209c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 14                	push   $0x14
  8020ab:	e8 0e fe ff ff       	call   801ebe <syscall>
  8020b0:	83 c4 18             	add    $0x18,%esp
}
  8020b3:	90                   	nop
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 04             	sub    $0x4,%esp
  8020bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8020bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020c2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020c5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	6a 00                	push   $0x0
  8020ce:	51                   	push   %ecx
  8020cf:	52                   	push   %edx
  8020d0:	ff 75 0c             	pushl  0xc(%ebp)
  8020d3:	50                   	push   %eax
  8020d4:	6a 15                	push   $0x15
  8020d6:	e8 e3 fd ff ff       	call   801ebe <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8020e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	52                   	push   %edx
  8020f0:	50                   	push   %eax
  8020f1:	6a 16                	push   $0x16
  8020f3:	e8 c6 fd ff ff       	call   801ebe <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802100:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802103:	8b 55 0c             	mov    0xc(%ebp),%edx
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	51                   	push   %ecx
  80210e:	52                   	push   %edx
  80210f:	50                   	push   %eax
  802110:	6a 17                	push   $0x17
  802112:	e8 a7 fd ff ff       	call   801ebe <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80211f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	52                   	push   %edx
  80212c:	50                   	push   %eax
  80212d:	6a 18                	push   $0x18
  80212f:	e8 8a fd ff ff       	call   801ebe <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	6a 00                	push   $0x0
  802141:	ff 75 14             	pushl  0x14(%ebp)
  802144:	ff 75 10             	pushl  0x10(%ebp)
  802147:	ff 75 0c             	pushl  0xc(%ebp)
  80214a:	50                   	push   %eax
  80214b:	6a 19                	push   $0x19
  80214d:	e8 6c fd ff ff       	call   801ebe <syscall>
  802152:	83 c4 18             	add    $0x18,%esp
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	50                   	push   %eax
  802166:	6a 1a                	push   $0x1a
  802168:	e8 51 fd ff ff       	call   801ebe <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
}
  802170:	90                   	nop
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	50                   	push   %eax
  802182:	6a 1b                	push   $0x1b
  802184:	e8 35 fd ff ff       	call   801ebe <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 05                	push   $0x5
  80219d:	e8 1c fd ff ff       	call   801ebe <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 06                	push   $0x6
  8021b6:	e8 03 fd ff ff       	call   801ebe <syscall>
  8021bb:	83 c4 18             	add    $0x18,%esp
}
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 07                	push   $0x7
  8021cf:	e8 ea fc ff ff       	call   801ebe <syscall>
  8021d4:	83 c4 18             	add    $0x18,%esp
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <sys_exit_env>:


void sys_exit_env(void)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 1c                	push   $0x1c
  8021e8:	e8 d1 fc ff ff       	call   801ebe <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
}
  8021f0:	90                   	nop
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021f9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021fc:	8d 50 04             	lea    0x4(%eax),%edx
  8021ff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	52                   	push   %edx
  802209:	50                   	push   %eax
  80220a:	6a 1d                	push   $0x1d
  80220c:	e8 ad fc ff ff       	call   801ebe <syscall>
  802211:	83 c4 18             	add    $0x18,%esp
	return result;
  802214:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802217:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80221a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80221d:	89 01                	mov    %eax,(%ecx)
  80221f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	c9                   	leave  
  802226:	c2 04 00             	ret    $0x4

00802229 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	ff 75 10             	pushl  0x10(%ebp)
  802233:	ff 75 0c             	pushl  0xc(%ebp)
  802236:	ff 75 08             	pushl  0x8(%ebp)
  802239:	6a 13                	push   $0x13
  80223b:	e8 7e fc ff ff       	call   801ebe <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
	return ;
  802243:	90                   	nop
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <sys_rcr2>:
uint32 sys_rcr2()
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 1e                	push   $0x1e
  802255:	e8 64 fc ff ff       	call   801ebe <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
  802262:	83 ec 04             	sub    $0x4,%esp
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80226b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	50                   	push   %eax
  802278:	6a 1f                	push   $0x1f
  80227a:	e8 3f fc ff ff       	call   801ebe <syscall>
  80227f:	83 c4 18             	add    $0x18,%esp
	return ;
  802282:	90                   	nop
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <rsttst>:
void rsttst()
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 21                	push   $0x21
  802294:	e8 25 fc ff ff       	call   801ebe <syscall>
  802299:	83 c4 18             	add    $0x18,%esp
	return ;
  80229c:	90                   	nop
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
  8022a2:	83 ec 04             	sub    $0x4,%esp
  8022a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022ab:	8b 55 18             	mov    0x18(%ebp),%edx
  8022ae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022b2:	52                   	push   %edx
  8022b3:	50                   	push   %eax
  8022b4:	ff 75 10             	pushl  0x10(%ebp)
  8022b7:	ff 75 0c             	pushl  0xc(%ebp)
  8022ba:	ff 75 08             	pushl  0x8(%ebp)
  8022bd:	6a 20                	push   $0x20
  8022bf:	e8 fa fb ff ff       	call   801ebe <syscall>
  8022c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c7:	90                   	nop
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <chktst>:
void chktst(uint32 n)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	ff 75 08             	pushl  0x8(%ebp)
  8022d8:	6a 22                	push   $0x22
  8022da:	e8 df fb ff ff       	call   801ebe <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e2:	90                   	nop
}
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <inctst>:

void inctst()
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 23                	push   $0x23
  8022f4:	e8 c5 fb ff ff       	call   801ebe <syscall>
  8022f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8022fc:	90                   	nop
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <gettst>:
uint32 gettst()
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 24                	push   $0x24
  80230e:	e8 ab fb ff ff       	call   801ebe <syscall>
  802313:	83 c4 18             	add    $0x18,%esp
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 25                	push   $0x25
  80232a:	e8 8f fb ff ff       	call   801ebe <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
  802332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802335:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802339:	75 07                	jne    802342 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80233b:	b8 01 00 00 00       	mov    $0x1,%eax
  802340:	eb 05                	jmp    802347 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802342:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
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
  80235b:	e8 5e fb ff ff       	call   801ebe <syscall>
  802360:	83 c4 18             	add    $0x18,%esp
  802363:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802366:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80236a:	75 07                	jne    802373 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80236c:	b8 01 00 00 00       	mov    $0x1,%eax
  802371:	eb 05                	jmp    802378 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802373:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  80238c:	e8 2d fb ff ff       	call   801ebe <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
  802394:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802397:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80239b:	75 07                	jne    8023a4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80239d:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a2:	eb 05                	jmp    8023a9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  8023bd:	e8 fc fa ff ff       	call   801ebe <syscall>
  8023c2:	83 c4 18             	add    $0x18,%esp
  8023c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023c8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023cc:	75 07                	jne    8023d5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d3:	eb 05                	jmp    8023da <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023da:	c9                   	leave  
  8023db:	c3                   	ret    

008023dc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	ff 75 08             	pushl  0x8(%ebp)
  8023ea:	6a 26                	push   $0x26
  8023ec:	e8 cd fa ff ff       	call   801ebe <syscall>
  8023f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f4:	90                   	nop
}
  8023f5:	c9                   	leave  
  8023f6:	c3                   	ret    

008023f7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
  8023fa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802401:	8b 55 0c             	mov    0xc(%ebp),%edx
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	6a 00                	push   $0x0
  802409:	53                   	push   %ebx
  80240a:	51                   	push   %ecx
  80240b:	52                   	push   %edx
  80240c:	50                   	push   %eax
  80240d:	6a 27                	push   $0x27
  80240f:	e8 aa fa ff ff       	call   801ebe <syscall>
  802414:	83 c4 18             	add    $0x18,%esp
}
  802417:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80241f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	52                   	push   %edx
  80242c:	50                   	push   %eax
  80242d:	6a 28                	push   $0x28
  80242f:	e8 8a fa ff ff       	call   801ebe <syscall>
  802434:	83 c4 18             	add    $0x18,%esp
}
  802437:	c9                   	leave  
  802438:	c3                   	ret    

00802439 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80243c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80243f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	6a 00                	push   $0x0
  802447:	51                   	push   %ecx
  802448:	ff 75 10             	pushl  0x10(%ebp)
  80244b:	52                   	push   %edx
  80244c:	50                   	push   %eax
  80244d:	6a 29                	push   $0x29
  80244f:	e8 6a fa ff ff       	call   801ebe <syscall>
  802454:	83 c4 18             	add    $0x18,%esp
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	ff 75 10             	pushl  0x10(%ebp)
  802463:	ff 75 0c             	pushl  0xc(%ebp)
  802466:	ff 75 08             	pushl  0x8(%ebp)
  802469:	6a 12                	push   $0x12
  80246b:	e8 4e fa ff ff       	call   801ebe <syscall>
  802470:	83 c4 18             	add    $0x18,%esp
	return ;
  802473:	90                   	nop
}
  802474:	c9                   	leave  
  802475:	c3                   	ret    

00802476 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802476:	55                   	push   %ebp
  802477:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802479:	8b 55 0c             	mov    0xc(%ebp),%edx
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	52                   	push   %edx
  802486:	50                   	push   %eax
  802487:	6a 2a                	push   $0x2a
  802489:	e8 30 fa ff ff       	call   801ebe <syscall>
  80248e:	83 c4 18             	add    $0x18,%esp
	return;
  802491:	90                   	nop
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	50                   	push   %eax
  8024a3:	6a 2b                	push   $0x2b
  8024a5:	e8 14 fa ff ff       	call   801ebe <syscall>
  8024aa:	83 c4 18             	add    $0x18,%esp
}
  8024ad:	c9                   	leave  
  8024ae:	c3                   	ret    

008024af <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	ff 75 0c             	pushl  0xc(%ebp)
  8024bb:	ff 75 08             	pushl  0x8(%ebp)
  8024be:	6a 2c                	push   $0x2c
  8024c0:	e8 f9 f9 ff ff       	call   801ebe <syscall>
  8024c5:	83 c4 18             	add    $0x18,%esp
	return;
  8024c8:	90                   	nop
}
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	ff 75 0c             	pushl  0xc(%ebp)
  8024d7:	ff 75 08             	pushl  0x8(%ebp)
  8024da:	6a 2d                	push   $0x2d
  8024dc:	e8 dd f9 ff ff       	call   801ebe <syscall>
  8024e1:	83 c4 18             	add    $0x18,%esp
	return;
  8024e4:	90                   	nop
}
  8024e5:	c9                   	leave  
  8024e6:	c3                   	ret    

008024e7 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8024e7:	55                   	push   %ebp
  8024e8:	89 e5                	mov    %esp,%ebp
  8024ea:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8024ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f0:	83 e8 04             	sub    $0x4,%eax
  8024f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8024f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024f9:	8b 00                	mov    (%eax),%eax
  8024fb:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    

00802500 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	83 e8 04             	sub    $0x4,%eax
  80250c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80250f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802512:	8b 00                	mov    (%eax),%eax
  802514:	83 e0 01             	and    $0x1,%eax
  802517:	85 c0                	test   %eax,%eax
  802519:	0f 94 c0             	sete   %al
}
  80251c:	c9                   	leave  
  80251d:	c3                   	ret    

0080251e <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
  802521:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80252b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80252e:	83 f8 02             	cmp    $0x2,%eax
  802531:	74 2b                	je     80255e <alloc_block+0x40>
  802533:	83 f8 02             	cmp    $0x2,%eax
  802536:	7f 07                	jg     80253f <alloc_block+0x21>
  802538:	83 f8 01             	cmp    $0x1,%eax
  80253b:	74 0e                	je     80254b <alloc_block+0x2d>
  80253d:	eb 58                	jmp    802597 <alloc_block+0x79>
  80253f:	83 f8 03             	cmp    $0x3,%eax
  802542:	74 2d                	je     802571 <alloc_block+0x53>
  802544:	83 f8 04             	cmp    $0x4,%eax
  802547:	74 3b                	je     802584 <alloc_block+0x66>
  802549:	eb 4c                	jmp    802597 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80254b:	83 ec 0c             	sub    $0xc,%esp
  80254e:	ff 75 08             	pushl  0x8(%ebp)
  802551:	e8 11 03 00 00       	call   802867 <alloc_block_FF>
  802556:	83 c4 10             	add    $0x10,%esp
  802559:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80255c:	eb 4a                	jmp    8025a8 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80255e:	83 ec 0c             	sub    $0xc,%esp
  802561:	ff 75 08             	pushl  0x8(%ebp)
  802564:	e8 fa 19 00 00       	call   803f63 <alloc_block_NF>
  802569:	83 c4 10             	add    $0x10,%esp
  80256c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80256f:	eb 37                	jmp    8025a8 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802571:	83 ec 0c             	sub    $0xc,%esp
  802574:	ff 75 08             	pushl  0x8(%ebp)
  802577:	e8 a7 07 00 00       	call   802d23 <alloc_block_BF>
  80257c:	83 c4 10             	add    $0x10,%esp
  80257f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802582:	eb 24                	jmp    8025a8 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802584:	83 ec 0c             	sub    $0xc,%esp
  802587:	ff 75 08             	pushl  0x8(%ebp)
  80258a:	e8 b7 19 00 00       	call   803f46 <alloc_block_WF>
  80258f:	83 c4 10             	add    $0x10,%esp
  802592:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802595:	eb 11                	jmp    8025a8 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802597:	83 ec 0c             	sub    $0xc,%esp
  80259a:	68 4c 4a 80 00       	push   $0x804a4c
  80259f:	e8 56 e4 ff ff       	call   8009fa <cprintf>
  8025a4:	83 c4 10             	add    $0x10,%esp
		break;
  8025a7:	90                   	nop
	}
	return va;
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
  8025b0:	53                   	push   %ebx
  8025b1:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8025b4:	83 ec 0c             	sub    $0xc,%esp
  8025b7:	68 6c 4a 80 00       	push   $0x804a6c
  8025bc:	e8 39 e4 ff ff       	call   8009fa <cprintf>
  8025c1:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8025c4:	83 ec 0c             	sub    $0xc,%esp
  8025c7:	68 97 4a 80 00       	push   $0x804a97
  8025cc:	e8 29 e4 ff ff       	call   8009fa <cprintf>
  8025d1:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025da:	eb 37                	jmp    802613 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8025dc:	83 ec 0c             	sub    $0xc,%esp
  8025df:	ff 75 f4             	pushl  -0xc(%ebp)
  8025e2:	e8 19 ff ff ff       	call   802500 <is_free_block>
  8025e7:	83 c4 10             	add    $0x10,%esp
  8025ea:	0f be d8             	movsbl %al,%ebx
  8025ed:	83 ec 0c             	sub    $0xc,%esp
  8025f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8025f3:	e8 ef fe ff ff       	call   8024e7 <get_block_size>
  8025f8:	83 c4 10             	add    $0x10,%esp
  8025fb:	83 ec 04             	sub    $0x4,%esp
  8025fe:	53                   	push   %ebx
  8025ff:	50                   	push   %eax
  802600:	68 af 4a 80 00       	push   $0x804aaf
  802605:	e8 f0 e3 ff ff       	call   8009fa <cprintf>
  80260a:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80260d:	8b 45 10             	mov    0x10(%ebp),%eax
  802610:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802617:	74 07                	je     802620 <print_blocks_list+0x73>
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 00                	mov    (%eax),%eax
  80261e:	eb 05                	jmp    802625 <print_blocks_list+0x78>
  802620:	b8 00 00 00 00       	mov    $0x0,%eax
  802625:	89 45 10             	mov    %eax,0x10(%ebp)
  802628:	8b 45 10             	mov    0x10(%ebp),%eax
  80262b:	85 c0                	test   %eax,%eax
  80262d:	75 ad                	jne    8025dc <print_blocks_list+0x2f>
  80262f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802633:	75 a7                	jne    8025dc <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802635:	83 ec 0c             	sub    $0xc,%esp
  802638:	68 6c 4a 80 00       	push   $0x804a6c
  80263d:	e8 b8 e3 ff ff       	call   8009fa <cprintf>
  802642:	83 c4 10             	add    $0x10,%esp

}
  802645:	90                   	nop
  802646:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
  80264e:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802651:	8b 45 0c             	mov    0xc(%ebp),%eax
  802654:	83 e0 01             	and    $0x1,%eax
  802657:	85 c0                	test   %eax,%eax
  802659:	74 03                	je     80265e <initialize_dynamic_allocator+0x13>
  80265b:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80265e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802662:	0f 84 c7 01 00 00    	je     80282f <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802668:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  80266f:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802672:	8b 55 08             	mov    0x8(%ebp),%edx
  802675:	8b 45 0c             	mov    0xc(%ebp),%eax
  802678:	01 d0                	add    %edx,%eax
  80267a:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80267f:	0f 87 ad 01 00 00    	ja     802832 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802685:	8b 45 08             	mov    0x8(%ebp),%eax
  802688:	85 c0                	test   %eax,%eax
  80268a:	0f 89 a5 01 00 00    	jns    802835 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802690:	8b 55 08             	mov    0x8(%ebp),%edx
  802693:	8b 45 0c             	mov    0xc(%ebp),%eax
  802696:	01 d0                	add    %edx,%eax
  802698:	83 e8 04             	sub    $0x4,%eax
  80269b:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8026a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8026a7:	a1 30 50 80 00       	mov    0x805030,%eax
  8026ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026af:	e9 87 00 00 00       	jmp    80273b <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8026b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b8:	75 14                	jne    8026ce <initialize_dynamic_allocator+0x83>
  8026ba:	83 ec 04             	sub    $0x4,%esp
  8026bd:	68 c7 4a 80 00       	push   $0x804ac7
  8026c2:	6a 79                	push   $0x79
  8026c4:	68 e5 4a 80 00       	push   $0x804ae5
  8026c9:	e8 6f e0 ff ff       	call   80073d <_panic>
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 00                	mov    (%eax),%eax
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	74 10                	je     8026e7 <initialize_dynamic_allocator+0x9c>
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 00                	mov    (%eax),%eax
  8026dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026df:	8b 52 04             	mov    0x4(%edx),%edx
  8026e2:	89 50 04             	mov    %edx,0x4(%eax)
  8026e5:	eb 0b                	jmp    8026f2 <initialize_dynamic_allocator+0xa7>
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 40 04             	mov    0x4(%eax),%eax
  8026ed:	a3 34 50 80 00       	mov    %eax,0x805034
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 40 04             	mov    0x4(%eax),%eax
  8026f8:	85 c0                	test   %eax,%eax
  8026fa:	74 0f                	je     80270b <initialize_dynamic_allocator+0xc0>
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 40 04             	mov    0x4(%eax),%eax
  802702:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802705:	8b 12                	mov    (%edx),%edx
  802707:	89 10                	mov    %edx,(%eax)
  802709:	eb 0a                	jmp    802715 <initialize_dynamic_allocator+0xca>
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	a3 30 50 80 00       	mov    %eax,0x805030
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802728:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80272d:	48                   	dec    %eax
  80272e:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802733:	a1 38 50 80 00       	mov    0x805038,%eax
  802738:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273f:	74 07                	je     802748 <initialize_dynamic_allocator+0xfd>
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 00                	mov    (%eax),%eax
  802746:	eb 05                	jmp    80274d <initialize_dynamic_allocator+0x102>
  802748:	b8 00 00 00 00       	mov    $0x0,%eax
  80274d:	a3 38 50 80 00       	mov    %eax,0x805038
  802752:	a1 38 50 80 00       	mov    0x805038,%eax
  802757:	85 c0                	test   %eax,%eax
  802759:	0f 85 55 ff ff ff    	jne    8026b4 <initialize_dynamic_allocator+0x69>
  80275f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802763:	0f 85 4b ff ff ff    	jne    8026b4 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80276f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802772:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802778:	a1 48 50 80 00       	mov    0x805048,%eax
  80277d:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802782:	a1 44 50 80 00       	mov    0x805044,%eax
  802787:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80278d:	8b 45 08             	mov    0x8(%ebp),%eax
  802790:	83 c0 08             	add    $0x8,%eax
  802793:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802796:	8b 45 08             	mov    0x8(%ebp),%eax
  802799:	83 c0 04             	add    $0x4,%eax
  80279c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80279f:	83 ea 08             	sub    $0x8,%edx
  8027a2:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027aa:	01 d0                	add    %edx,%eax
  8027ac:	83 e8 08             	sub    $0x8,%eax
  8027af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027b2:	83 ea 08             	sub    $0x8,%edx
  8027b5:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8027b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8027c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8027ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027ce:	75 17                	jne    8027e7 <initialize_dynamic_allocator+0x19c>
  8027d0:	83 ec 04             	sub    $0x4,%esp
  8027d3:	68 00 4b 80 00       	push   $0x804b00
  8027d8:	68 90 00 00 00       	push   $0x90
  8027dd:	68 e5 4a 80 00       	push   $0x804ae5
  8027e2:	e8 56 df ff ff       	call   80073d <_panic>
  8027e7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8027ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f0:	89 10                	mov    %edx,(%eax)
  8027f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	74 0d                	je     802808 <initialize_dynamic_allocator+0x1bd>
  8027fb:	a1 30 50 80 00       	mov    0x805030,%eax
  802800:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802803:	89 50 04             	mov    %edx,0x4(%eax)
  802806:	eb 08                	jmp    802810 <initialize_dynamic_allocator+0x1c5>
  802808:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280b:	a3 34 50 80 00       	mov    %eax,0x805034
  802810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802813:	a3 30 50 80 00       	mov    %eax,0x805030
  802818:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802822:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802827:	40                   	inc    %eax
  802828:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80282d:	eb 07                	jmp    802836 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80282f:	90                   	nop
  802830:	eb 04                	jmp    802836 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802832:	90                   	nop
  802833:	eb 01                	jmp    802836 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802835:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802836:	c9                   	leave  
  802837:	c3                   	ret    

00802838 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80283b:	8b 45 10             	mov    0x10(%ebp),%eax
  80283e:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802841:	8b 45 08             	mov    0x8(%ebp),%eax
  802844:	8d 50 fc             	lea    -0x4(%eax),%edx
  802847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80284a:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80284c:	8b 45 08             	mov    0x8(%ebp),%eax
  80284f:	83 e8 04             	sub    $0x4,%eax
  802852:	8b 00                	mov    (%eax),%eax
  802854:	83 e0 fe             	and    $0xfffffffe,%eax
  802857:	8d 50 f8             	lea    -0x8(%eax),%edx
  80285a:	8b 45 08             	mov    0x8(%ebp),%eax
  80285d:	01 c2                	add    %eax,%edx
  80285f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802862:	89 02                	mov    %eax,(%edx)
}
  802864:	90                   	nop
  802865:	5d                   	pop    %ebp
  802866:	c3                   	ret    

00802867 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802867:	55                   	push   %ebp
  802868:	89 e5                	mov    %esp,%ebp
  80286a:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	83 e0 01             	and    $0x1,%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	74 03                	je     80287a <alloc_block_FF+0x13>
  802877:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80287a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80287e:	77 07                	ja     802887 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802880:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802887:	a1 28 50 80 00       	mov    0x805028,%eax
  80288c:	85 c0                	test   %eax,%eax
  80288e:	75 73                	jne    802903 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	83 c0 10             	add    $0x10,%eax
  802896:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802899:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8028a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a6:	01 d0                	add    %edx,%eax
  8028a8:	48                   	dec    %eax
  8028a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8028ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028af:	ba 00 00 00 00       	mov    $0x0,%edx
  8028b4:	f7 75 ec             	divl   -0x14(%ebp)
  8028b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ba:	29 d0                	sub    %edx,%eax
  8028bc:	c1 e8 0c             	shr    $0xc,%eax
  8028bf:	83 ec 0c             	sub    $0xc,%esp
  8028c2:	50                   	push   %eax
  8028c3:	e8 d4 f0 ff ff       	call   80199c <sbrk>
  8028c8:	83 c4 10             	add    $0x10,%esp
  8028cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028ce:	83 ec 0c             	sub    $0xc,%esp
  8028d1:	6a 00                	push   $0x0
  8028d3:	e8 c4 f0 ff ff       	call   80199c <sbrk>
  8028d8:	83 c4 10             	add    $0x10,%esp
  8028db:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8028de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8028e4:	83 ec 08             	sub    $0x8,%esp
  8028e7:	50                   	push   %eax
  8028e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8028eb:	e8 5b fd ff ff       	call   80264b <initialize_dynamic_allocator>
  8028f0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8028f3:	83 ec 0c             	sub    $0xc,%esp
  8028f6:	68 23 4b 80 00       	push   $0x804b23
  8028fb:	e8 fa e0 ff ff       	call   8009fa <cprintf>
  802900:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802903:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802907:	75 0a                	jne    802913 <alloc_block_FF+0xac>
	        return NULL;
  802909:	b8 00 00 00 00       	mov    $0x0,%eax
  80290e:	e9 0e 04 00 00       	jmp    802d21 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802913:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80291a:	a1 30 50 80 00       	mov    0x805030,%eax
  80291f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802922:	e9 f3 02 00 00       	jmp    802c1a <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80292d:	83 ec 0c             	sub    $0xc,%esp
  802930:	ff 75 bc             	pushl  -0x44(%ebp)
  802933:	e8 af fb ff ff       	call   8024e7 <get_block_size>
  802938:	83 c4 10             	add    $0x10,%esp
  80293b:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	83 c0 08             	add    $0x8,%eax
  802944:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802947:	0f 87 c5 02 00 00    	ja     802c12 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80294d:	8b 45 08             	mov    0x8(%ebp),%eax
  802950:	83 c0 18             	add    $0x18,%eax
  802953:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802956:	0f 87 19 02 00 00    	ja     802b75 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80295c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80295f:	2b 45 08             	sub    0x8(%ebp),%eax
  802962:	83 e8 08             	sub    $0x8,%eax
  802965:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802968:	8b 45 08             	mov    0x8(%ebp),%eax
  80296b:	8d 50 08             	lea    0x8(%eax),%edx
  80296e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802971:	01 d0                	add    %edx,%eax
  802973:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	83 c0 08             	add    $0x8,%eax
  80297c:	83 ec 04             	sub    $0x4,%esp
  80297f:	6a 01                	push   $0x1
  802981:	50                   	push   %eax
  802982:	ff 75 bc             	pushl  -0x44(%ebp)
  802985:	e8 ae fe ff ff       	call   802838 <set_block_data>
  80298a:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 40 04             	mov    0x4(%eax),%eax
  802993:	85 c0                	test   %eax,%eax
  802995:	75 68                	jne    8029ff <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802997:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80299b:	75 17                	jne    8029b4 <alloc_block_FF+0x14d>
  80299d:	83 ec 04             	sub    $0x4,%esp
  8029a0:	68 00 4b 80 00       	push   $0x804b00
  8029a5:	68 d7 00 00 00       	push   $0xd7
  8029aa:	68 e5 4a 80 00       	push   $0x804ae5
  8029af:	e8 89 dd ff ff       	call   80073d <_panic>
  8029b4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029bd:	89 10                	mov    %edx,(%eax)
  8029bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029c2:	8b 00                	mov    (%eax),%eax
  8029c4:	85 c0                	test   %eax,%eax
  8029c6:	74 0d                	je     8029d5 <alloc_block_FF+0x16e>
  8029c8:	a1 30 50 80 00       	mov    0x805030,%eax
  8029cd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029d0:	89 50 04             	mov    %edx,0x4(%eax)
  8029d3:	eb 08                	jmp    8029dd <alloc_block_FF+0x176>
  8029d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029d8:	a3 34 50 80 00       	mov    %eax,0x805034
  8029dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8029e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ef:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8029f4:	40                   	inc    %eax
  8029f5:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8029fa:	e9 dc 00 00 00       	jmp    802adb <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 00                	mov    (%eax),%eax
  802a04:	85 c0                	test   %eax,%eax
  802a06:	75 65                	jne    802a6d <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a08:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a0c:	75 17                	jne    802a25 <alloc_block_FF+0x1be>
  802a0e:	83 ec 04             	sub    $0x4,%esp
  802a11:	68 34 4b 80 00       	push   $0x804b34
  802a16:	68 db 00 00 00       	push   $0xdb
  802a1b:	68 e5 4a 80 00       	push   $0x804ae5
  802a20:	e8 18 dd ff ff       	call   80073d <_panic>
  802a25:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802a2b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a2e:	89 50 04             	mov    %edx,0x4(%eax)
  802a31:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a34:	8b 40 04             	mov    0x4(%eax),%eax
  802a37:	85 c0                	test   %eax,%eax
  802a39:	74 0c                	je     802a47 <alloc_block_FF+0x1e0>
  802a3b:	a1 34 50 80 00       	mov    0x805034,%eax
  802a40:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a43:	89 10                	mov    %edx,(%eax)
  802a45:	eb 08                	jmp    802a4f <alloc_block_FF+0x1e8>
  802a47:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a4a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a4f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a52:	a3 34 50 80 00       	mov    %eax,0x805034
  802a57:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a60:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a65:	40                   	inc    %eax
  802a66:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a6b:	eb 6e                	jmp    802adb <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802a6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a71:	74 06                	je     802a79 <alloc_block_FF+0x212>
  802a73:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a77:	75 17                	jne    802a90 <alloc_block_FF+0x229>
  802a79:	83 ec 04             	sub    $0x4,%esp
  802a7c:	68 58 4b 80 00       	push   $0x804b58
  802a81:	68 df 00 00 00       	push   $0xdf
  802a86:	68 e5 4a 80 00       	push   $0x804ae5
  802a8b:	e8 ad dc ff ff       	call   80073d <_panic>
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 10                	mov    (%eax),%edx
  802a95:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a98:	89 10                	mov    %edx,(%eax)
  802a9a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a9d:	8b 00                	mov    (%eax),%eax
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	74 0b                	je     802aae <alloc_block_FF+0x247>
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	8b 00                	mov    (%eax),%eax
  802aa8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802aab:	89 50 04             	mov    %edx,0x4(%eax)
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ab4:	89 10                	mov    %edx,(%eax)
  802ab6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ab9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802abc:	89 50 04             	mov    %edx,0x4(%eax)
  802abf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac2:	8b 00                	mov    (%eax),%eax
  802ac4:	85 c0                	test   %eax,%eax
  802ac6:	75 08                	jne    802ad0 <alloc_block_FF+0x269>
  802ac8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802acb:	a3 34 50 80 00       	mov    %eax,0x805034
  802ad0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ad5:	40                   	inc    %eax
  802ad6:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802adb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802adf:	75 17                	jne    802af8 <alloc_block_FF+0x291>
  802ae1:	83 ec 04             	sub    $0x4,%esp
  802ae4:	68 c7 4a 80 00       	push   $0x804ac7
  802ae9:	68 e1 00 00 00       	push   $0xe1
  802aee:	68 e5 4a 80 00       	push   $0x804ae5
  802af3:	e8 45 dc ff ff       	call   80073d <_panic>
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	85 c0                	test   %eax,%eax
  802aff:	74 10                	je     802b11 <alloc_block_FF+0x2aa>
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 00                	mov    (%eax),%eax
  802b06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b09:	8b 52 04             	mov    0x4(%edx),%edx
  802b0c:	89 50 04             	mov    %edx,0x4(%eax)
  802b0f:	eb 0b                	jmp    802b1c <alloc_block_FF+0x2b5>
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 40 04             	mov    0x4(%eax),%eax
  802b17:	a3 34 50 80 00       	mov    %eax,0x805034
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 40 04             	mov    0x4(%eax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	74 0f                	je     802b35 <alloc_block_FF+0x2ce>
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 40 04             	mov    0x4(%eax),%eax
  802b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2f:	8b 12                	mov    (%edx),%edx
  802b31:	89 10                	mov    %edx,(%eax)
  802b33:	eb 0a                	jmp    802b3f <alloc_block_FF+0x2d8>
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	a3 30 50 80 00       	mov    %eax,0x805030
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b52:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b57:	48                   	dec    %eax
  802b58:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802b5d:	83 ec 04             	sub    $0x4,%esp
  802b60:	6a 00                	push   $0x0
  802b62:	ff 75 b4             	pushl  -0x4c(%ebp)
  802b65:	ff 75 b0             	pushl  -0x50(%ebp)
  802b68:	e8 cb fc ff ff       	call   802838 <set_block_data>
  802b6d:	83 c4 10             	add    $0x10,%esp
  802b70:	e9 95 00 00 00       	jmp    802c0a <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802b75:	83 ec 04             	sub    $0x4,%esp
  802b78:	6a 01                	push   $0x1
  802b7a:	ff 75 b8             	pushl  -0x48(%ebp)
  802b7d:	ff 75 bc             	pushl  -0x44(%ebp)
  802b80:	e8 b3 fc ff ff       	call   802838 <set_block_data>
  802b85:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802b88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8c:	75 17                	jne    802ba5 <alloc_block_FF+0x33e>
  802b8e:	83 ec 04             	sub    $0x4,%esp
  802b91:	68 c7 4a 80 00       	push   $0x804ac7
  802b96:	68 e8 00 00 00       	push   $0xe8
  802b9b:	68 e5 4a 80 00       	push   $0x804ae5
  802ba0:	e8 98 db ff ff       	call   80073d <_panic>
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	85 c0                	test   %eax,%eax
  802bac:	74 10                	je     802bbe <alloc_block_FF+0x357>
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	8b 00                	mov    (%eax),%eax
  802bb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb6:	8b 52 04             	mov    0x4(%edx),%edx
  802bb9:	89 50 04             	mov    %edx,0x4(%eax)
  802bbc:	eb 0b                	jmp    802bc9 <alloc_block_FF+0x362>
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	8b 40 04             	mov    0x4(%eax),%eax
  802bc4:	a3 34 50 80 00       	mov    %eax,0x805034
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 40 04             	mov    0x4(%eax),%eax
  802bcf:	85 c0                	test   %eax,%eax
  802bd1:	74 0f                	je     802be2 <alloc_block_FF+0x37b>
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	8b 40 04             	mov    0x4(%eax),%eax
  802bd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bdc:	8b 12                	mov    (%edx),%edx
  802bde:	89 10                	mov    %edx,(%eax)
  802be0:	eb 0a                	jmp    802bec <alloc_block_FF+0x385>
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
	            }
	            return va;
  802c0a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c0d:	e9 0f 01 00 00       	jmp    802d21 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c12:	a1 38 50 80 00       	mov    0x805038,%eax
  802c17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1e:	74 07                	je     802c27 <alloc_block_FF+0x3c0>
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	8b 00                	mov    (%eax),%eax
  802c25:	eb 05                	jmp    802c2c <alloc_block_FF+0x3c5>
  802c27:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2c:	a3 38 50 80 00       	mov    %eax,0x805038
  802c31:	a1 38 50 80 00       	mov    0x805038,%eax
  802c36:	85 c0                	test   %eax,%eax
  802c38:	0f 85 e9 fc ff ff    	jne    802927 <alloc_block_FF+0xc0>
  802c3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c42:	0f 85 df fc ff ff    	jne    802927 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	83 c0 08             	add    $0x8,%eax
  802c4e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c51:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802c58:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c5e:	01 d0                	add    %edx,%eax
  802c60:	48                   	dec    %eax
  802c61:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802c64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c67:	ba 00 00 00 00       	mov    $0x0,%edx
  802c6c:	f7 75 d8             	divl   -0x28(%ebp)
  802c6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c72:	29 d0                	sub    %edx,%eax
  802c74:	c1 e8 0c             	shr    $0xc,%eax
  802c77:	83 ec 0c             	sub    $0xc,%esp
  802c7a:	50                   	push   %eax
  802c7b:	e8 1c ed ff ff       	call   80199c <sbrk>
  802c80:	83 c4 10             	add    $0x10,%esp
  802c83:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802c86:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802c8a:	75 0a                	jne    802c96 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c91:	e9 8b 00 00 00       	jmp    802d21 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c96:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802c9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ca0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ca3:	01 d0                	add    %edx,%eax
  802ca5:	48                   	dec    %eax
  802ca6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802ca9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802cac:	ba 00 00 00 00       	mov    $0x0,%edx
  802cb1:	f7 75 cc             	divl   -0x34(%ebp)
  802cb4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802cb7:	29 d0                	sub    %edx,%eax
  802cb9:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cbc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802cbf:	01 d0                	add    %edx,%eax
  802cc1:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802cc6:	a1 44 50 80 00       	mov    0x805044,%eax
  802ccb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802cd1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802cd8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cdb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cde:	01 d0                	add    %edx,%eax
  802ce0:	48                   	dec    %eax
  802ce1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ce4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ce7:	ba 00 00 00 00       	mov    $0x0,%edx
  802cec:	f7 75 c4             	divl   -0x3c(%ebp)
  802cef:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cf2:	29 d0                	sub    %edx,%eax
  802cf4:	83 ec 04             	sub    $0x4,%esp
  802cf7:	6a 01                	push   $0x1
  802cf9:	50                   	push   %eax
  802cfa:	ff 75 d0             	pushl  -0x30(%ebp)
  802cfd:	e8 36 fb ff ff       	call   802838 <set_block_data>
  802d02:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802d05:	83 ec 0c             	sub    $0xc,%esp
  802d08:	ff 75 d0             	pushl  -0x30(%ebp)
  802d0b:	e8 1b 0a 00 00       	call   80372b <free_block>
  802d10:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802d13:	83 ec 0c             	sub    $0xc,%esp
  802d16:	ff 75 08             	pushl  0x8(%ebp)
  802d19:	e8 49 fb ff ff       	call   802867 <alloc_block_FF>
  802d1e:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802d21:	c9                   	leave  
  802d22:	c3                   	ret    

00802d23 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802d23:	55                   	push   %ebp
  802d24:	89 e5                	mov    %esp,%ebp
  802d26:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	83 e0 01             	and    $0x1,%eax
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	74 03                	je     802d36 <alloc_block_BF+0x13>
  802d33:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802d36:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802d3a:	77 07                	ja     802d43 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802d3c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802d43:	a1 28 50 80 00       	mov    0x805028,%eax
  802d48:	85 c0                	test   %eax,%eax
  802d4a:	75 73                	jne    802dbf <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	83 c0 10             	add    $0x10,%eax
  802d52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802d55:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802d5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d62:	01 d0                	add    %edx,%eax
  802d64:	48                   	dec    %eax
  802d65:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  802d70:	f7 75 e0             	divl   -0x20(%ebp)
  802d73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d76:	29 d0                	sub    %edx,%eax
  802d78:	c1 e8 0c             	shr    $0xc,%eax
  802d7b:	83 ec 0c             	sub    $0xc,%esp
  802d7e:	50                   	push   %eax
  802d7f:	e8 18 ec ff ff       	call   80199c <sbrk>
  802d84:	83 c4 10             	add    $0x10,%esp
  802d87:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802d8a:	83 ec 0c             	sub    $0xc,%esp
  802d8d:	6a 00                	push   $0x0
  802d8f:	e8 08 ec ff ff       	call   80199c <sbrk>
  802d94:	83 c4 10             	add    $0x10,%esp
  802d97:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802d9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d9d:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802da0:	83 ec 08             	sub    $0x8,%esp
  802da3:	50                   	push   %eax
  802da4:	ff 75 d8             	pushl  -0x28(%ebp)
  802da7:	e8 9f f8 ff ff       	call   80264b <initialize_dynamic_allocator>
  802dac:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802daf:	83 ec 0c             	sub    $0xc,%esp
  802db2:	68 23 4b 80 00       	push   $0x804b23
  802db7:	e8 3e dc ff ff       	call   8009fa <cprintf>
  802dbc:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802dbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802dc6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802dcd:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802dd4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802ddb:	a1 30 50 80 00       	mov    0x805030,%eax
  802de0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de3:	e9 1d 01 00 00       	jmp    802f05 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802dee:	83 ec 0c             	sub    $0xc,%esp
  802df1:	ff 75 a8             	pushl  -0x58(%ebp)
  802df4:	e8 ee f6 ff ff       	call   8024e7 <get_block_size>
  802df9:	83 c4 10             	add    $0x10,%esp
  802dfc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	83 c0 08             	add    $0x8,%eax
  802e05:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e08:	0f 87 ef 00 00 00    	ja     802efd <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	83 c0 18             	add    $0x18,%eax
  802e14:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e17:	77 1d                	ja     802e36 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e1f:	0f 86 d8 00 00 00    	jbe    802efd <alloc_block_BF+0x1da>
				{
					best_va = va;
  802e25:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802e2b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e31:	e9 c7 00 00 00       	jmp    802efd <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	83 c0 08             	add    $0x8,%eax
  802e3c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e3f:	0f 85 9d 00 00 00    	jne    802ee2 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802e45:	83 ec 04             	sub    $0x4,%esp
  802e48:	6a 01                	push   $0x1
  802e4a:	ff 75 a4             	pushl  -0x5c(%ebp)
  802e4d:	ff 75 a8             	pushl  -0x58(%ebp)
  802e50:	e8 e3 f9 ff ff       	call   802838 <set_block_data>
  802e55:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802e58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5c:	75 17                	jne    802e75 <alloc_block_BF+0x152>
  802e5e:	83 ec 04             	sub    $0x4,%esp
  802e61:	68 c7 4a 80 00       	push   $0x804ac7
  802e66:	68 2c 01 00 00       	push   $0x12c
  802e6b:	68 e5 4a 80 00       	push   $0x804ae5
  802e70:	e8 c8 d8 ff ff       	call   80073d <_panic>
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	8b 00                	mov    (%eax),%eax
  802e7a:	85 c0                	test   %eax,%eax
  802e7c:	74 10                	je     802e8e <alloc_block_BF+0x16b>
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	8b 00                	mov    (%eax),%eax
  802e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e86:	8b 52 04             	mov    0x4(%edx),%edx
  802e89:	89 50 04             	mov    %edx,0x4(%eax)
  802e8c:	eb 0b                	jmp    802e99 <alloc_block_BF+0x176>
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	8b 40 04             	mov    0x4(%eax),%eax
  802e94:	a3 34 50 80 00       	mov    %eax,0x805034
  802e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9c:	8b 40 04             	mov    0x4(%eax),%eax
  802e9f:	85 c0                	test   %eax,%eax
  802ea1:	74 0f                	je     802eb2 <alloc_block_BF+0x18f>
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	8b 40 04             	mov    0x4(%eax),%eax
  802ea9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eac:	8b 12                	mov    (%edx),%edx
  802eae:	89 10                	mov    %edx,(%eax)
  802eb0:	eb 0a                	jmp    802ebc <alloc_block_BF+0x199>
  802eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb5:	8b 00                	mov    (%eax),%eax
  802eb7:	a3 30 50 80 00       	mov    %eax,0x805030
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ecf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ed4:	48                   	dec    %eax
  802ed5:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802eda:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802edd:	e9 24 04 00 00       	jmp    803306 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802ee2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ee8:	76 13                	jbe    802efd <alloc_block_BF+0x1da>
					{
						internal = 1;
  802eea:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802ef1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802ef7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802efa:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802efd:	a1 38 50 80 00       	mov    0x805038,%eax
  802f02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f09:	74 07                	je     802f12 <alloc_block_BF+0x1ef>
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 00                	mov    (%eax),%eax
  802f10:	eb 05                	jmp    802f17 <alloc_block_BF+0x1f4>
  802f12:	b8 00 00 00 00       	mov    $0x0,%eax
  802f17:	a3 38 50 80 00       	mov    %eax,0x805038
  802f1c:	a1 38 50 80 00       	mov    0x805038,%eax
  802f21:	85 c0                	test   %eax,%eax
  802f23:	0f 85 bf fe ff ff    	jne    802de8 <alloc_block_BF+0xc5>
  802f29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2d:	0f 85 b5 fe ff ff    	jne    802de8 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802f33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f37:	0f 84 26 02 00 00    	je     803163 <alloc_block_BF+0x440>
  802f3d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f41:	0f 85 1c 02 00 00    	jne    803163 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4a:	2b 45 08             	sub    0x8(%ebp),%eax
  802f4d:	83 e8 08             	sub    $0x8,%eax
  802f50:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	8d 50 08             	lea    0x8(%eax),%edx
  802f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5c:	01 d0                	add    %edx,%eax
  802f5e:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802f61:	8b 45 08             	mov    0x8(%ebp),%eax
  802f64:	83 c0 08             	add    $0x8,%eax
  802f67:	83 ec 04             	sub    $0x4,%esp
  802f6a:	6a 01                	push   $0x1
  802f6c:	50                   	push   %eax
  802f6d:	ff 75 f0             	pushl  -0x10(%ebp)
  802f70:	e8 c3 f8 ff ff       	call   802838 <set_block_data>
  802f75:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7b:	8b 40 04             	mov    0x4(%eax),%eax
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	75 68                	jne    802fea <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f82:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f86:	75 17                	jne    802f9f <alloc_block_BF+0x27c>
  802f88:	83 ec 04             	sub    $0x4,%esp
  802f8b:	68 00 4b 80 00       	push   $0x804b00
  802f90:	68 45 01 00 00       	push   $0x145
  802f95:	68 e5 4a 80 00       	push   $0x804ae5
  802f9a:	e8 9e d7 ff ff       	call   80073d <_panic>
  802f9f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fa5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fa8:	89 10                	mov    %edx,(%eax)
  802faa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	85 c0                	test   %eax,%eax
  802fb1:	74 0d                	je     802fc0 <alloc_block_BF+0x29d>
  802fb3:	a1 30 50 80 00       	mov    0x805030,%eax
  802fb8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fbb:	89 50 04             	mov    %edx,0x4(%eax)
  802fbe:	eb 08                	jmp    802fc8 <alloc_block_BF+0x2a5>
  802fc0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fc3:	a3 34 50 80 00       	mov    %eax,0x805034
  802fc8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fcb:	a3 30 50 80 00       	mov    %eax,0x805030
  802fd0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fda:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fdf:	40                   	inc    %eax
  802fe0:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802fe5:	e9 dc 00 00 00       	jmp    8030c6 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	85 c0                	test   %eax,%eax
  802ff1:	75 65                	jne    803058 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ff3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ff7:	75 17                	jne    803010 <alloc_block_BF+0x2ed>
  802ff9:	83 ec 04             	sub    $0x4,%esp
  802ffc:	68 34 4b 80 00       	push   $0x804b34
  803001:	68 4a 01 00 00       	push   $0x14a
  803006:	68 e5 4a 80 00       	push   $0x804ae5
  80300b:	e8 2d d7 ff ff       	call   80073d <_panic>
  803010:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803016:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803019:	89 50 04             	mov    %edx,0x4(%eax)
  80301c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80301f:	8b 40 04             	mov    0x4(%eax),%eax
  803022:	85 c0                	test   %eax,%eax
  803024:	74 0c                	je     803032 <alloc_block_BF+0x30f>
  803026:	a1 34 50 80 00       	mov    0x805034,%eax
  80302b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80302e:	89 10                	mov    %edx,(%eax)
  803030:	eb 08                	jmp    80303a <alloc_block_BF+0x317>
  803032:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803035:	a3 30 50 80 00       	mov    %eax,0x805030
  80303a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80303d:	a3 34 50 80 00       	mov    %eax,0x805034
  803042:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803045:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80304b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803050:	40                   	inc    %eax
  803051:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803056:	eb 6e                	jmp    8030c6 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803058:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80305c:	74 06                	je     803064 <alloc_block_BF+0x341>
  80305e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803062:	75 17                	jne    80307b <alloc_block_BF+0x358>
  803064:	83 ec 04             	sub    $0x4,%esp
  803067:	68 58 4b 80 00       	push   $0x804b58
  80306c:	68 4f 01 00 00       	push   $0x14f
  803071:	68 e5 4a 80 00       	push   $0x804ae5
  803076:	e8 c2 d6 ff ff       	call   80073d <_panic>
  80307b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307e:	8b 10                	mov    (%eax),%edx
  803080:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803083:	89 10                	mov    %edx,(%eax)
  803085:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803088:	8b 00                	mov    (%eax),%eax
  80308a:	85 c0                	test   %eax,%eax
  80308c:	74 0b                	je     803099 <alloc_block_BF+0x376>
  80308e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803091:	8b 00                	mov    (%eax),%eax
  803093:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803096:	89 50 04             	mov    %edx,0x4(%eax)
  803099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80309f:	89 10                	mov    %edx,(%eax)
  8030a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030a7:	89 50 04             	mov    %edx,0x4(%eax)
  8030aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030ad:	8b 00                	mov    (%eax),%eax
  8030af:	85 c0                	test   %eax,%eax
  8030b1:	75 08                	jne    8030bb <alloc_block_BF+0x398>
  8030b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b6:	a3 34 50 80 00       	mov    %eax,0x805034
  8030bb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030c0:	40                   	inc    %eax
  8030c1:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8030c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ca:	75 17                	jne    8030e3 <alloc_block_BF+0x3c0>
  8030cc:	83 ec 04             	sub    $0x4,%esp
  8030cf:	68 c7 4a 80 00       	push   $0x804ac7
  8030d4:	68 51 01 00 00       	push   $0x151
  8030d9:	68 e5 4a 80 00       	push   $0x804ae5
  8030de:	e8 5a d6 ff ff       	call   80073d <_panic>
  8030e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e6:	8b 00                	mov    (%eax),%eax
  8030e8:	85 c0                	test   %eax,%eax
  8030ea:	74 10                	je     8030fc <alloc_block_BF+0x3d9>
  8030ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ef:	8b 00                	mov    (%eax),%eax
  8030f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030f4:	8b 52 04             	mov    0x4(%edx),%edx
  8030f7:	89 50 04             	mov    %edx,0x4(%eax)
  8030fa:	eb 0b                	jmp    803107 <alloc_block_BF+0x3e4>
  8030fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ff:	8b 40 04             	mov    0x4(%eax),%eax
  803102:	a3 34 50 80 00       	mov    %eax,0x805034
  803107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310a:	8b 40 04             	mov    0x4(%eax),%eax
  80310d:	85 c0                	test   %eax,%eax
  80310f:	74 0f                	je     803120 <alloc_block_BF+0x3fd>
  803111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803114:	8b 40 04             	mov    0x4(%eax),%eax
  803117:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80311a:	8b 12                	mov    (%edx),%edx
  80311c:	89 10                	mov    %edx,(%eax)
  80311e:	eb 0a                	jmp    80312a <alloc_block_BF+0x407>
  803120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803123:	8b 00                	mov    (%eax),%eax
  803125:	a3 30 50 80 00       	mov    %eax,0x805030
  80312a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803136:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803142:	48                   	dec    %eax
  803143:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  803148:	83 ec 04             	sub    $0x4,%esp
  80314b:	6a 00                	push   $0x0
  80314d:	ff 75 d0             	pushl  -0x30(%ebp)
  803150:	ff 75 cc             	pushl  -0x34(%ebp)
  803153:	e8 e0 f6 ff ff       	call   802838 <set_block_data>
  803158:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80315b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315e:	e9 a3 01 00 00       	jmp    803306 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803163:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803167:	0f 85 9d 00 00 00    	jne    80320a <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80316d:	83 ec 04             	sub    $0x4,%esp
  803170:	6a 01                	push   $0x1
  803172:	ff 75 ec             	pushl  -0x14(%ebp)
  803175:	ff 75 f0             	pushl  -0x10(%ebp)
  803178:	e8 bb f6 ff ff       	call   802838 <set_block_data>
  80317d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803180:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803184:	75 17                	jne    80319d <alloc_block_BF+0x47a>
  803186:	83 ec 04             	sub    $0x4,%esp
  803189:	68 c7 4a 80 00       	push   $0x804ac7
  80318e:	68 58 01 00 00       	push   $0x158
  803193:	68 e5 4a 80 00       	push   $0x804ae5
  803198:	e8 a0 d5 ff ff       	call   80073d <_panic>
  80319d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a0:	8b 00                	mov    (%eax),%eax
  8031a2:	85 c0                	test   %eax,%eax
  8031a4:	74 10                	je     8031b6 <alloc_block_BF+0x493>
  8031a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a9:	8b 00                	mov    (%eax),%eax
  8031ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ae:	8b 52 04             	mov    0x4(%edx),%edx
  8031b1:	89 50 04             	mov    %edx,0x4(%eax)
  8031b4:	eb 0b                	jmp    8031c1 <alloc_block_BF+0x49e>
  8031b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b9:	8b 40 04             	mov    0x4(%eax),%eax
  8031bc:	a3 34 50 80 00       	mov    %eax,0x805034
  8031c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c4:	8b 40 04             	mov    0x4(%eax),%eax
  8031c7:	85 c0                	test   %eax,%eax
  8031c9:	74 0f                	je     8031da <alloc_block_BF+0x4b7>
  8031cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ce:	8b 40 04             	mov    0x4(%eax),%eax
  8031d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d4:	8b 12                	mov    (%edx),%edx
  8031d6:	89 10                	mov    %edx,(%eax)
  8031d8:	eb 0a                	jmp    8031e4 <alloc_block_BF+0x4c1>
  8031da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031dd:	8b 00                	mov    (%eax),%eax
  8031df:	a3 30 50 80 00       	mov    %eax,0x805030
  8031e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031fc:	48                   	dec    %eax
  8031fd:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  803202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803205:	e9 fc 00 00 00       	jmp    803306 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80320a:	8b 45 08             	mov    0x8(%ebp),%eax
  80320d:	83 c0 08             	add    $0x8,%eax
  803210:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803213:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80321a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80321d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803220:	01 d0                	add    %edx,%eax
  803222:	48                   	dec    %eax
  803223:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803226:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803229:	ba 00 00 00 00       	mov    $0x0,%edx
  80322e:	f7 75 c4             	divl   -0x3c(%ebp)
  803231:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803234:	29 d0                	sub    %edx,%eax
  803236:	c1 e8 0c             	shr    $0xc,%eax
  803239:	83 ec 0c             	sub    $0xc,%esp
  80323c:	50                   	push   %eax
  80323d:	e8 5a e7 ff ff       	call   80199c <sbrk>
  803242:	83 c4 10             	add    $0x10,%esp
  803245:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803248:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80324c:	75 0a                	jne    803258 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80324e:	b8 00 00 00 00       	mov    $0x0,%eax
  803253:	e9 ae 00 00 00       	jmp    803306 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803258:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80325f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803262:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803265:	01 d0                	add    %edx,%eax
  803267:	48                   	dec    %eax
  803268:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80326b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80326e:	ba 00 00 00 00       	mov    $0x0,%edx
  803273:	f7 75 b8             	divl   -0x48(%ebp)
  803276:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803279:	29 d0                	sub    %edx,%eax
  80327b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80327e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803281:	01 d0                	add    %edx,%eax
  803283:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  803288:	a1 44 50 80 00       	mov    0x805044,%eax
  80328d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803293:	83 ec 0c             	sub    $0xc,%esp
  803296:	68 8c 4b 80 00       	push   $0x804b8c
  80329b:	e8 5a d7 ff ff       	call   8009fa <cprintf>
  8032a0:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8032a3:	83 ec 08             	sub    $0x8,%esp
  8032a6:	ff 75 bc             	pushl  -0x44(%ebp)
  8032a9:	68 91 4b 80 00       	push   $0x804b91
  8032ae:	e8 47 d7 ff ff       	call   8009fa <cprintf>
  8032b3:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8032b6:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8032bd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032c0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032c3:	01 d0                	add    %edx,%eax
  8032c5:	48                   	dec    %eax
  8032c6:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8032c9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8032cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8032d1:	f7 75 b0             	divl   -0x50(%ebp)
  8032d4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8032d7:	29 d0                	sub    %edx,%eax
  8032d9:	83 ec 04             	sub    $0x4,%esp
  8032dc:	6a 01                	push   $0x1
  8032de:	50                   	push   %eax
  8032df:	ff 75 bc             	pushl  -0x44(%ebp)
  8032e2:	e8 51 f5 ff ff       	call   802838 <set_block_data>
  8032e7:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8032ea:	83 ec 0c             	sub    $0xc,%esp
  8032ed:	ff 75 bc             	pushl  -0x44(%ebp)
  8032f0:	e8 36 04 00 00       	call   80372b <free_block>
  8032f5:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8032f8:	83 ec 0c             	sub    $0xc,%esp
  8032fb:	ff 75 08             	pushl  0x8(%ebp)
  8032fe:	e8 20 fa ff ff       	call   802d23 <alloc_block_BF>
  803303:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803306:	c9                   	leave  
  803307:	c3                   	ret    

00803308 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803308:	55                   	push   %ebp
  803309:	89 e5                	mov    %esp,%ebp
  80330b:	53                   	push   %ebx
  80330c:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80330f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803316:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80331d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803321:	74 1e                	je     803341 <merging+0x39>
  803323:	ff 75 08             	pushl  0x8(%ebp)
  803326:	e8 bc f1 ff ff       	call   8024e7 <get_block_size>
  80332b:	83 c4 04             	add    $0x4,%esp
  80332e:	89 c2                	mov    %eax,%edx
  803330:	8b 45 08             	mov    0x8(%ebp),%eax
  803333:	01 d0                	add    %edx,%eax
  803335:	3b 45 10             	cmp    0x10(%ebp),%eax
  803338:	75 07                	jne    803341 <merging+0x39>
		prev_is_free = 1;
  80333a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803341:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803345:	74 1e                	je     803365 <merging+0x5d>
  803347:	ff 75 10             	pushl  0x10(%ebp)
  80334a:	e8 98 f1 ff ff       	call   8024e7 <get_block_size>
  80334f:	83 c4 04             	add    $0x4,%esp
  803352:	89 c2                	mov    %eax,%edx
  803354:	8b 45 10             	mov    0x10(%ebp),%eax
  803357:	01 d0                	add    %edx,%eax
  803359:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80335c:	75 07                	jne    803365 <merging+0x5d>
		next_is_free = 1;
  80335e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803369:	0f 84 cc 00 00 00    	je     80343b <merging+0x133>
  80336f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803373:	0f 84 c2 00 00 00    	je     80343b <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803379:	ff 75 08             	pushl  0x8(%ebp)
  80337c:	e8 66 f1 ff ff       	call   8024e7 <get_block_size>
  803381:	83 c4 04             	add    $0x4,%esp
  803384:	89 c3                	mov    %eax,%ebx
  803386:	ff 75 10             	pushl  0x10(%ebp)
  803389:	e8 59 f1 ff ff       	call   8024e7 <get_block_size>
  80338e:	83 c4 04             	add    $0x4,%esp
  803391:	01 c3                	add    %eax,%ebx
  803393:	ff 75 0c             	pushl  0xc(%ebp)
  803396:	e8 4c f1 ff ff       	call   8024e7 <get_block_size>
  80339b:	83 c4 04             	add    $0x4,%esp
  80339e:	01 d8                	add    %ebx,%eax
  8033a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8033a3:	6a 00                	push   $0x0
  8033a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8033a8:	ff 75 08             	pushl  0x8(%ebp)
  8033ab:	e8 88 f4 ff ff       	call   802838 <set_block_data>
  8033b0:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8033b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033b7:	75 17                	jne    8033d0 <merging+0xc8>
  8033b9:	83 ec 04             	sub    $0x4,%esp
  8033bc:	68 c7 4a 80 00       	push   $0x804ac7
  8033c1:	68 7d 01 00 00       	push   $0x17d
  8033c6:	68 e5 4a 80 00       	push   $0x804ae5
  8033cb:	e8 6d d3 ff ff       	call   80073d <_panic>
  8033d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d3:	8b 00                	mov    (%eax),%eax
  8033d5:	85 c0                	test   %eax,%eax
  8033d7:	74 10                	je     8033e9 <merging+0xe1>
  8033d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033dc:	8b 00                	mov    (%eax),%eax
  8033de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033e1:	8b 52 04             	mov    0x4(%edx),%edx
  8033e4:	89 50 04             	mov    %edx,0x4(%eax)
  8033e7:	eb 0b                	jmp    8033f4 <merging+0xec>
  8033e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ec:	8b 40 04             	mov    0x4(%eax),%eax
  8033ef:	a3 34 50 80 00       	mov    %eax,0x805034
  8033f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f7:	8b 40 04             	mov    0x4(%eax),%eax
  8033fa:	85 c0                	test   %eax,%eax
  8033fc:	74 0f                	je     80340d <merging+0x105>
  8033fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803401:	8b 40 04             	mov    0x4(%eax),%eax
  803404:	8b 55 0c             	mov    0xc(%ebp),%edx
  803407:	8b 12                	mov    (%edx),%edx
  803409:	89 10                	mov    %edx,(%eax)
  80340b:	eb 0a                	jmp    803417 <merging+0x10f>
  80340d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803410:	8b 00                	mov    (%eax),%eax
  803412:	a3 30 50 80 00       	mov    %eax,0x805030
  803417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80341a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803420:	8b 45 0c             	mov    0xc(%ebp),%eax
  803423:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80342f:	48                   	dec    %eax
  803430:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803435:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803436:	e9 ea 02 00 00       	jmp    803725 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80343b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80343f:	74 3b                	je     80347c <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803441:	83 ec 0c             	sub    $0xc,%esp
  803444:	ff 75 08             	pushl  0x8(%ebp)
  803447:	e8 9b f0 ff ff       	call   8024e7 <get_block_size>
  80344c:	83 c4 10             	add    $0x10,%esp
  80344f:	89 c3                	mov    %eax,%ebx
  803451:	83 ec 0c             	sub    $0xc,%esp
  803454:	ff 75 10             	pushl  0x10(%ebp)
  803457:	e8 8b f0 ff ff       	call   8024e7 <get_block_size>
  80345c:	83 c4 10             	add    $0x10,%esp
  80345f:	01 d8                	add    %ebx,%eax
  803461:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803464:	83 ec 04             	sub    $0x4,%esp
  803467:	6a 00                	push   $0x0
  803469:	ff 75 e8             	pushl  -0x18(%ebp)
  80346c:	ff 75 08             	pushl  0x8(%ebp)
  80346f:	e8 c4 f3 ff ff       	call   802838 <set_block_data>
  803474:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803477:	e9 a9 02 00 00       	jmp    803725 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80347c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803480:	0f 84 2d 01 00 00    	je     8035b3 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803486:	83 ec 0c             	sub    $0xc,%esp
  803489:	ff 75 10             	pushl  0x10(%ebp)
  80348c:	e8 56 f0 ff ff       	call   8024e7 <get_block_size>
  803491:	83 c4 10             	add    $0x10,%esp
  803494:	89 c3                	mov    %eax,%ebx
  803496:	83 ec 0c             	sub    $0xc,%esp
  803499:	ff 75 0c             	pushl  0xc(%ebp)
  80349c:	e8 46 f0 ff ff       	call   8024e7 <get_block_size>
  8034a1:	83 c4 10             	add    $0x10,%esp
  8034a4:	01 d8                	add    %ebx,%eax
  8034a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8034a9:	83 ec 04             	sub    $0x4,%esp
  8034ac:	6a 00                	push   $0x0
  8034ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034b1:	ff 75 10             	pushl  0x10(%ebp)
  8034b4:	e8 7f f3 ff ff       	call   802838 <set_block_data>
  8034b9:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8034bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8034bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8034c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034c6:	74 06                	je     8034ce <merging+0x1c6>
  8034c8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034cc:	75 17                	jne    8034e5 <merging+0x1dd>
  8034ce:	83 ec 04             	sub    $0x4,%esp
  8034d1:	68 a0 4b 80 00       	push   $0x804ba0
  8034d6:	68 8d 01 00 00       	push   $0x18d
  8034db:	68 e5 4a 80 00       	push   $0x804ae5
  8034e0:	e8 58 d2 ff ff       	call   80073d <_panic>
  8034e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e8:	8b 50 04             	mov    0x4(%eax),%edx
  8034eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034ee:	89 50 04             	mov    %edx,0x4(%eax)
  8034f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034f7:	89 10                	mov    %edx,(%eax)
  8034f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034fc:	8b 40 04             	mov    0x4(%eax),%eax
  8034ff:	85 c0                	test   %eax,%eax
  803501:	74 0d                	je     803510 <merging+0x208>
  803503:	8b 45 0c             	mov    0xc(%ebp),%eax
  803506:	8b 40 04             	mov    0x4(%eax),%eax
  803509:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80350c:	89 10                	mov    %edx,(%eax)
  80350e:	eb 08                	jmp    803518 <merging+0x210>
  803510:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803513:	a3 30 50 80 00       	mov    %eax,0x805030
  803518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80351e:	89 50 04             	mov    %edx,0x4(%eax)
  803521:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803526:	40                   	inc    %eax
  803527:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  80352c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803530:	75 17                	jne    803549 <merging+0x241>
  803532:	83 ec 04             	sub    $0x4,%esp
  803535:	68 c7 4a 80 00       	push   $0x804ac7
  80353a:	68 8e 01 00 00       	push   $0x18e
  80353f:	68 e5 4a 80 00       	push   $0x804ae5
  803544:	e8 f4 d1 ff ff       	call   80073d <_panic>
  803549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80354c:	8b 00                	mov    (%eax),%eax
  80354e:	85 c0                	test   %eax,%eax
  803550:	74 10                	je     803562 <merging+0x25a>
  803552:	8b 45 0c             	mov    0xc(%ebp),%eax
  803555:	8b 00                	mov    (%eax),%eax
  803557:	8b 55 0c             	mov    0xc(%ebp),%edx
  80355a:	8b 52 04             	mov    0x4(%edx),%edx
  80355d:	89 50 04             	mov    %edx,0x4(%eax)
  803560:	eb 0b                	jmp    80356d <merging+0x265>
  803562:	8b 45 0c             	mov    0xc(%ebp),%eax
  803565:	8b 40 04             	mov    0x4(%eax),%eax
  803568:	a3 34 50 80 00       	mov    %eax,0x805034
  80356d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803570:	8b 40 04             	mov    0x4(%eax),%eax
  803573:	85 c0                	test   %eax,%eax
  803575:	74 0f                	je     803586 <merging+0x27e>
  803577:	8b 45 0c             	mov    0xc(%ebp),%eax
  80357a:	8b 40 04             	mov    0x4(%eax),%eax
  80357d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803580:	8b 12                	mov    (%edx),%edx
  803582:	89 10                	mov    %edx,(%eax)
  803584:	eb 0a                	jmp    803590 <merging+0x288>
  803586:	8b 45 0c             	mov    0xc(%ebp),%eax
  803589:	8b 00                	mov    (%eax),%eax
  80358b:	a3 30 50 80 00       	mov    %eax,0x805030
  803590:	8b 45 0c             	mov    0xc(%ebp),%eax
  803593:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803599:	8b 45 0c             	mov    0xc(%ebp),%eax
  80359c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035a8:	48                   	dec    %eax
  8035a9:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035ae:	e9 72 01 00 00       	jmp    803725 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8035b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8035b6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8035b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035bd:	74 79                	je     803638 <merging+0x330>
  8035bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035c3:	74 73                	je     803638 <merging+0x330>
  8035c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035c9:	74 06                	je     8035d1 <merging+0x2c9>
  8035cb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035cf:	75 17                	jne    8035e8 <merging+0x2e0>
  8035d1:	83 ec 04             	sub    $0x4,%esp
  8035d4:	68 58 4b 80 00       	push   $0x804b58
  8035d9:	68 94 01 00 00       	push   $0x194
  8035de:	68 e5 4a 80 00       	push   $0x804ae5
  8035e3:	e8 55 d1 ff ff       	call   80073d <_panic>
  8035e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035eb:	8b 10                	mov    (%eax),%edx
  8035ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035f0:	89 10                	mov    %edx,(%eax)
  8035f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035f5:	8b 00                	mov    (%eax),%eax
  8035f7:	85 c0                	test   %eax,%eax
  8035f9:	74 0b                	je     803606 <merging+0x2fe>
  8035fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fe:	8b 00                	mov    (%eax),%eax
  803600:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803603:	89 50 04             	mov    %edx,0x4(%eax)
  803606:	8b 45 08             	mov    0x8(%ebp),%eax
  803609:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80360c:	89 10                	mov    %edx,(%eax)
  80360e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803611:	8b 55 08             	mov    0x8(%ebp),%edx
  803614:	89 50 04             	mov    %edx,0x4(%eax)
  803617:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80361a:	8b 00                	mov    (%eax),%eax
  80361c:	85 c0                	test   %eax,%eax
  80361e:	75 08                	jne    803628 <merging+0x320>
  803620:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803623:	a3 34 50 80 00       	mov    %eax,0x805034
  803628:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80362d:	40                   	inc    %eax
  80362e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803633:	e9 ce 00 00 00       	jmp    803706 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803638:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80363c:	74 65                	je     8036a3 <merging+0x39b>
  80363e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803642:	75 17                	jne    80365b <merging+0x353>
  803644:	83 ec 04             	sub    $0x4,%esp
  803647:	68 34 4b 80 00       	push   $0x804b34
  80364c:	68 95 01 00 00       	push   $0x195
  803651:	68 e5 4a 80 00       	push   $0x804ae5
  803656:	e8 e2 d0 ff ff       	call   80073d <_panic>
  80365b:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803661:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803664:	89 50 04             	mov    %edx,0x4(%eax)
  803667:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80366a:	8b 40 04             	mov    0x4(%eax),%eax
  80366d:	85 c0                	test   %eax,%eax
  80366f:	74 0c                	je     80367d <merging+0x375>
  803671:	a1 34 50 80 00       	mov    0x805034,%eax
  803676:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803679:	89 10                	mov    %edx,(%eax)
  80367b:	eb 08                	jmp    803685 <merging+0x37d>
  80367d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803680:	a3 30 50 80 00       	mov    %eax,0x805030
  803685:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803688:	a3 34 50 80 00       	mov    %eax,0x805034
  80368d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803696:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80369b:	40                   	inc    %eax
  80369c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036a1:	eb 63                	jmp    803706 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8036a3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036a7:	75 17                	jne    8036c0 <merging+0x3b8>
  8036a9:	83 ec 04             	sub    $0x4,%esp
  8036ac:	68 00 4b 80 00       	push   $0x804b00
  8036b1:	68 98 01 00 00       	push   $0x198
  8036b6:	68 e5 4a 80 00       	push   $0x804ae5
  8036bb:	e8 7d d0 ff ff       	call   80073d <_panic>
  8036c0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036c9:	89 10                	mov    %edx,(%eax)
  8036cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ce:	8b 00                	mov    (%eax),%eax
  8036d0:	85 c0                	test   %eax,%eax
  8036d2:	74 0d                	je     8036e1 <merging+0x3d9>
  8036d4:	a1 30 50 80 00       	mov    0x805030,%eax
  8036d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036dc:	89 50 04             	mov    %edx,0x4(%eax)
  8036df:	eb 08                	jmp    8036e9 <merging+0x3e1>
  8036e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036e4:	a3 34 50 80 00       	mov    %eax,0x805034
  8036e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ec:	a3 30 50 80 00       	mov    %eax,0x805030
  8036f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036fb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803700:	40                   	inc    %eax
  803701:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803706:	83 ec 0c             	sub    $0xc,%esp
  803709:	ff 75 10             	pushl  0x10(%ebp)
  80370c:	e8 d6 ed ff ff       	call   8024e7 <get_block_size>
  803711:	83 c4 10             	add    $0x10,%esp
  803714:	83 ec 04             	sub    $0x4,%esp
  803717:	6a 00                	push   $0x0
  803719:	50                   	push   %eax
  80371a:	ff 75 10             	pushl  0x10(%ebp)
  80371d:	e8 16 f1 ff ff       	call   802838 <set_block_data>
  803722:	83 c4 10             	add    $0x10,%esp
	}
}
  803725:	90                   	nop
  803726:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803729:	c9                   	leave  
  80372a:	c3                   	ret    

0080372b <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80372b:	55                   	push   %ebp
  80372c:	89 e5                	mov    %esp,%ebp
  80372e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803731:	a1 30 50 80 00       	mov    0x805030,%eax
  803736:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803739:	a1 34 50 80 00       	mov    0x805034,%eax
  80373e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803741:	73 1b                	jae    80375e <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803743:	a1 34 50 80 00       	mov    0x805034,%eax
  803748:	83 ec 04             	sub    $0x4,%esp
  80374b:	ff 75 08             	pushl  0x8(%ebp)
  80374e:	6a 00                	push   $0x0
  803750:	50                   	push   %eax
  803751:	e8 b2 fb ff ff       	call   803308 <merging>
  803756:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803759:	e9 8b 00 00 00       	jmp    8037e9 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80375e:	a1 30 50 80 00       	mov    0x805030,%eax
  803763:	3b 45 08             	cmp    0x8(%ebp),%eax
  803766:	76 18                	jbe    803780 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803768:	a1 30 50 80 00       	mov    0x805030,%eax
  80376d:	83 ec 04             	sub    $0x4,%esp
  803770:	ff 75 08             	pushl  0x8(%ebp)
  803773:	50                   	push   %eax
  803774:	6a 00                	push   $0x0
  803776:	e8 8d fb ff ff       	call   803308 <merging>
  80377b:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80377e:	eb 69                	jmp    8037e9 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803780:	a1 30 50 80 00       	mov    0x805030,%eax
  803785:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803788:	eb 39                	jmp    8037c3 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80378a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803790:	73 29                	jae    8037bb <free_block+0x90>
  803792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803795:	8b 00                	mov    (%eax),%eax
  803797:	3b 45 08             	cmp    0x8(%ebp),%eax
  80379a:	76 1f                	jbe    8037bb <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80379c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379f:	8b 00                	mov    (%eax),%eax
  8037a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8037a4:	83 ec 04             	sub    $0x4,%esp
  8037a7:	ff 75 08             	pushl  0x8(%ebp)
  8037aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8037ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8037b0:	e8 53 fb ff ff       	call   803308 <merging>
  8037b5:	83 c4 10             	add    $0x10,%esp
			break;
  8037b8:	90                   	nop
		}
	}
}
  8037b9:	eb 2e                	jmp    8037e9 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8037bb:	a1 38 50 80 00       	mov    0x805038,%eax
  8037c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037c7:	74 07                	je     8037d0 <free_block+0xa5>
  8037c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cc:	8b 00                	mov    (%eax),%eax
  8037ce:	eb 05                	jmp    8037d5 <free_block+0xaa>
  8037d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8037d5:	a3 38 50 80 00       	mov    %eax,0x805038
  8037da:	a1 38 50 80 00       	mov    0x805038,%eax
  8037df:	85 c0                	test   %eax,%eax
  8037e1:	75 a7                	jne    80378a <free_block+0x5f>
  8037e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e7:	75 a1                	jne    80378a <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037e9:	90                   	nop
  8037ea:	c9                   	leave  
  8037eb:	c3                   	ret    

008037ec <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8037ec:	55                   	push   %ebp
  8037ed:	89 e5                	mov    %esp,%ebp
  8037ef:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8037f2:	ff 75 08             	pushl  0x8(%ebp)
  8037f5:	e8 ed ec ff ff       	call   8024e7 <get_block_size>
  8037fa:	83 c4 04             	add    $0x4,%esp
  8037fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803800:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803807:	eb 17                	jmp    803820 <copy_data+0x34>
  803809:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80380c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80380f:	01 c2                	add    %eax,%edx
  803811:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803814:	8b 45 08             	mov    0x8(%ebp),%eax
  803817:	01 c8                	add    %ecx,%eax
  803819:	8a 00                	mov    (%eax),%al
  80381b:	88 02                	mov    %al,(%edx)
  80381d:	ff 45 fc             	incl   -0x4(%ebp)
  803820:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803823:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803826:	72 e1                	jb     803809 <copy_data+0x1d>
}
  803828:	90                   	nop
  803829:	c9                   	leave  
  80382a:	c3                   	ret    

0080382b <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80382b:	55                   	push   %ebp
  80382c:	89 e5                	mov    %esp,%ebp
  80382e:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803831:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803835:	75 23                	jne    80385a <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803837:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80383b:	74 13                	je     803850 <realloc_block_FF+0x25>
  80383d:	83 ec 0c             	sub    $0xc,%esp
  803840:	ff 75 0c             	pushl  0xc(%ebp)
  803843:	e8 1f f0 ff ff       	call   802867 <alloc_block_FF>
  803848:	83 c4 10             	add    $0x10,%esp
  80384b:	e9 f4 06 00 00       	jmp    803f44 <realloc_block_FF+0x719>
		return NULL;
  803850:	b8 00 00 00 00       	mov    $0x0,%eax
  803855:	e9 ea 06 00 00       	jmp    803f44 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80385a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80385e:	75 18                	jne    803878 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803860:	83 ec 0c             	sub    $0xc,%esp
  803863:	ff 75 08             	pushl  0x8(%ebp)
  803866:	e8 c0 fe ff ff       	call   80372b <free_block>
  80386b:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80386e:	b8 00 00 00 00       	mov    $0x0,%eax
  803873:	e9 cc 06 00 00       	jmp    803f44 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803878:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80387c:	77 07                	ja     803885 <realloc_block_FF+0x5a>
  80387e:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803885:	8b 45 0c             	mov    0xc(%ebp),%eax
  803888:	83 e0 01             	and    $0x1,%eax
  80388b:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80388e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803891:	83 c0 08             	add    $0x8,%eax
  803894:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803897:	83 ec 0c             	sub    $0xc,%esp
  80389a:	ff 75 08             	pushl  0x8(%ebp)
  80389d:	e8 45 ec ff ff       	call   8024e7 <get_block_size>
  8038a2:	83 c4 10             	add    $0x10,%esp
  8038a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8038a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ab:	83 e8 08             	sub    $0x8,%eax
  8038ae:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8038b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b4:	83 e8 04             	sub    $0x4,%eax
  8038b7:	8b 00                	mov    (%eax),%eax
  8038b9:	83 e0 fe             	and    $0xfffffffe,%eax
  8038bc:	89 c2                	mov    %eax,%edx
  8038be:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c1:	01 d0                	add    %edx,%eax
  8038c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8038c6:	83 ec 0c             	sub    $0xc,%esp
  8038c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038cc:	e8 16 ec ff ff       	call   8024e7 <get_block_size>
  8038d1:	83 c4 10             	add    $0x10,%esp
  8038d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8038d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038da:	83 e8 08             	sub    $0x8,%eax
  8038dd:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8038e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038e6:	75 08                	jne    8038f0 <realloc_block_FF+0xc5>
	{
		 return va;
  8038e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038eb:	e9 54 06 00 00       	jmp    803f44 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8038f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038f3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038f6:	0f 83 e5 03 00 00    	jae    803ce1 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8038fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ff:	2b 45 0c             	sub    0xc(%ebp),%eax
  803902:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803905:	83 ec 0c             	sub    $0xc,%esp
  803908:	ff 75 e4             	pushl  -0x1c(%ebp)
  80390b:	e8 f0 eb ff ff       	call   802500 <is_free_block>
  803910:	83 c4 10             	add    $0x10,%esp
  803913:	84 c0                	test   %al,%al
  803915:	0f 84 3b 01 00 00    	je     803a56 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80391b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80391e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803921:	01 d0                	add    %edx,%eax
  803923:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803926:	83 ec 04             	sub    $0x4,%esp
  803929:	6a 01                	push   $0x1
  80392b:	ff 75 f0             	pushl  -0x10(%ebp)
  80392e:	ff 75 08             	pushl  0x8(%ebp)
  803931:	e8 02 ef ff ff       	call   802838 <set_block_data>
  803936:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803939:	8b 45 08             	mov    0x8(%ebp),%eax
  80393c:	83 e8 04             	sub    $0x4,%eax
  80393f:	8b 00                	mov    (%eax),%eax
  803941:	83 e0 fe             	and    $0xfffffffe,%eax
  803944:	89 c2                	mov    %eax,%edx
  803946:	8b 45 08             	mov    0x8(%ebp),%eax
  803949:	01 d0                	add    %edx,%eax
  80394b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80394e:	83 ec 04             	sub    $0x4,%esp
  803951:	6a 00                	push   $0x0
  803953:	ff 75 cc             	pushl  -0x34(%ebp)
  803956:	ff 75 c8             	pushl  -0x38(%ebp)
  803959:	e8 da ee ff ff       	call   802838 <set_block_data>
  80395e:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803961:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803965:	74 06                	je     80396d <realloc_block_FF+0x142>
  803967:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80396b:	75 17                	jne    803984 <realloc_block_FF+0x159>
  80396d:	83 ec 04             	sub    $0x4,%esp
  803970:	68 58 4b 80 00       	push   $0x804b58
  803975:	68 f6 01 00 00       	push   $0x1f6
  80397a:	68 e5 4a 80 00       	push   $0x804ae5
  80397f:	e8 b9 cd ff ff       	call   80073d <_panic>
  803984:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803987:	8b 10                	mov    (%eax),%edx
  803989:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80398c:	89 10                	mov    %edx,(%eax)
  80398e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803991:	8b 00                	mov    (%eax),%eax
  803993:	85 c0                	test   %eax,%eax
  803995:	74 0b                	je     8039a2 <realloc_block_FF+0x177>
  803997:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399a:	8b 00                	mov    (%eax),%eax
  80399c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80399f:	89 50 04             	mov    %edx,0x4(%eax)
  8039a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039a8:	89 10                	mov    %edx,(%eax)
  8039aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039b0:	89 50 04             	mov    %edx,0x4(%eax)
  8039b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039b6:	8b 00                	mov    (%eax),%eax
  8039b8:	85 c0                	test   %eax,%eax
  8039ba:	75 08                	jne    8039c4 <realloc_block_FF+0x199>
  8039bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039bf:	a3 34 50 80 00       	mov    %eax,0x805034
  8039c4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039c9:	40                   	inc    %eax
  8039ca:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8039cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039d3:	75 17                	jne    8039ec <realloc_block_FF+0x1c1>
  8039d5:	83 ec 04             	sub    $0x4,%esp
  8039d8:	68 c7 4a 80 00       	push   $0x804ac7
  8039dd:	68 f7 01 00 00       	push   $0x1f7
  8039e2:	68 e5 4a 80 00       	push   $0x804ae5
  8039e7:	e8 51 cd ff ff       	call   80073d <_panic>
  8039ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ef:	8b 00                	mov    (%eax),%eax
  8039f1:	85 c0                	test   %eax,%eax
  8039f3:	74 10                	je     803a05 <realloc_block_FF+0x1da>
  8039f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f8:	8b 00                	mov    (%eax),%eax
  8039fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039fd:	8b 52 04             	mov    0x4(%edx),%edx
  803a00:	89 50 04             	mov    %edx,0x4(%eax)
  803a03:	eb 0b                	jmp    803a10 <realloc_block_FF+0x1e5>
  803a05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a08:	8b 40 04             	mov    0x4(%eax),%eax
  803a0b:	a3 34 50 80 00       	mov    %eax,0x805034
  803a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a13:	8b 40 04             	mov    0x4(%eax),%eax
  803a16:	85 c0                	test   %eax,%eax
  803a18:	74 0f                	je     803a29 <realloc_block_FF+0x1fe>
  803a1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1d:	8b 40 04             	mov    0x4(%eax),%eax
  803a20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a23:	8b 12                	mov    (%edx),%edx
  803a25:	89 10                	mov    %edx,(%eax)
  803a27:	eb 0a                	jmp    803a33 <realloc_block_FF+0x208>
  803a29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2c:	8b 00                	mov    (%eax),%eax
  803a2e:	a3 30 50 80 00       	mov    %eax,0x805030
  803a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a46:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a4b:	48                   	dec    %eax
  803a4c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a51:	e9 83 02 00 00       	jmp    803cd9 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803a56:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803a5a:	0f 86 69 02 00 00    	jbe    803cc9 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803a60:	83 ec 04             	sub    $0x4,%esp
  803a63:	6a 01                	push   $0x1
  803a65:	ff 75 f0             	pushl  -0x10(%ebp)
  803a68:	ff 75 08             	pushl  0x8(%ebp)
  803a6b:	e8 c8 ed ff ff       	call   802838 <set_block_data>
  803a70:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a73:	8b 45 08             	mov    0x8(%ebp),%eax
  803a76:	83 e8 04             	sub    $0x4,%eax
  803a79:	8b 00                	mov    (%eax),%eax
  803a7b:	83 e0 fe             	and    $0xfffffffe,%eax
  803a7e:	89 c2                	mov    %eax,%edx
  803a80:	8b 45 08             	mov    0x8(%ebp),%eax
  803a83:	01 d0                	add    %edx,%eax
  803a85:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803a88:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a8d:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803a90:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803a94:	75 68                	jne    803afe <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a96:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a9a:	75 17                	jne    803ab3 <realloc_block_FF+0x288>
  803a9c:	83 ec 04             	sub    $0x4,%esp
  803a9f:	68 00 4b 80 00       	push   $0x804b00
  803aa4:	68 06 02 00 00       	push   $0x206
  803aa9:	68 e5 4a 80 00       	push   $0x804ae5
  803aae:	e8 8a cc ff ff       	call   80073d <_panic>
  803ab3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803ab9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803abc:	89 10                	mov    %edx,(%eax)
  803abe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ac1:	8b 00                	mov    (%eax),%eax
  803ac3:	85 c0                	test   %eax,%eax
  803ac5:	74 0d                	je     803ad4 <realloc_block_FF+0x2a9>
  803ac7:	a1 30 50 80 00       	mov    0x805030,%eax
  803acc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803acf:	89 50 04             	mov    %edx,0x4(%eax)
  803ad2:	eb 08                	jmp    803adc <realloc_block_FF+0x2b1>
  803ad4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ad7:	a3 34 50 80 00       	mov    %eax,0x805034
  803adc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803adf:	a3 30 50 80 00       	mov    %eax,0x805030
  803ae4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aee:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803af3:	40                   	inc    %eax
  803af4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803af9:	e9 b0 01 00 00       	jmp    803cae <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803afe:	a1 30 50 80 00       	mov    0x805030,%eax
  803b03:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b06:	76 68                	jbe    803b70 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b08:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b0c:	75 17                	jne    803b25 <realloc_block_FF+0x2fa>
  803b0e:	83 ec 04             	sub    $0x4,%esp
  803b11:	68 00 4b 80 00       	push   $0x804b00
  803b16:	68 0b 02 00 00       	push   $0x20b
  803b1b:	68 e5 4a 80 00       	push   $0x804ae5
  803b20:	e8 18 cc ff ff       	call   80073d <_panic>
  803b25:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b2e:	89 10                	mov    %edx,(%eax)
  803b30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b33:	8b 00                	mov    (%eax),%eax
  803b35:	85 c0                	test   %eax,%eax
  803b37:	74 0d                	je     803b46 <realloc_block_FF+0x31b>
  803b39:	a1 30 50 80 00       	mov    0x805030,%eax
  803b3e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b41:	89 50 04             	mov    %edx,0x4(%eax)
  803b44:	eb 08                	jmp    803b4e <realloc_block_FF+0x323>
  803b46:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b49:	a3 34 50 80 00       	mov    %eax,0x805034
  803b4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b51:	a3 30 50 80 00       	mov    %eax,0x805030
  803b56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b60:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b65:	40                   	inc    %eax
  803b66:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b6b:	e9 3e 01 00 00       	jmp    803cae <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803b70:	a1 30 50 80 00       	mov    0x805030,%eax
  803b75:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b78:	73 68                	jae    803be2 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b7a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b7e:	75 17                	jne    803b97 <realloc_block_FF+0x36c>
  803b80:	83 ec 04             	sub    $0x4,%esp
  803b83:	68 34 4b 80 00       	push   $0x804b34
  803b88:	68 10 02 00 00       	push   $0x210
  803b8d:	68 e5 4a 80 00       	push   $0x804ae5
  803b92:	e8 a6 cb ff ff       	call   80073d <_panic>
  803b97:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803b9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ba0:	89 50 04             	mov    %edx,0x4(%eax)
  803ba3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ba6:	8b 40 04             	mov    0x4(%eax),%eax
  803ba9:	85 c0                	test   %eax,%eax
  803bab:	74 0c                	je     803bb9 <realloc_block_FF+0x38e>
  803bad:	a1 34 50 80 00       	mov    0x805034,%eax
  803bb2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bb5:	89 10                	mov    %edx,(%eax)
  803bb7:	eb 08                	jmp    803bc1 <realloc_block_FF+0x396>
  803bb9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bbc:	a3 30 50 80 00       	mov    %eax,0x805030
  803bc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc4:	a3 34 50 80 00       	mov    %eax,0x805034
  803bc9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bd2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bd7:	40                   	inc    %eax
  803bd8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803bdd:	e9 cc 00 00 00       	jmp    803cae <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803be2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803be9:	a1 30 50 80 00       	mov    0x805030,%eax
  803bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bf1:	e9 8a 00 00 00       	jmp    803c80 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bfc:	73 7a                	jae    803c78 <realloc_block_FF+0x44d>
  803bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c01:	8b 00                	mov    (%eax),%eax
  803c03:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c06:	73 70                	jae    803c78 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803c08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c0c:	74 06                	je     803c14 <realloc_block_FF+0x3e9>
  803c0e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c12:	75 17                	jne    803c2b <realloc_block_FF+0x400>
  803c14:	83 ec 04             	sub    $0x4,%esp
  803c17:	68 58 4b 80 00       	push   $0x804b58
  803c1c:	68 1a 02 00 00       	push   $0x21a
  803c21:	68 e5 4a 80 00       	push   $0x804ae5
  803c26:	e8 12 cb ff ff       	call   80073d <_panic>
  803c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2e:	8b 10                	mov    (%eax),%edx
  803c30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c33:	89 10                	mov    %edx,(%eax)
  803c35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c38:	8b 00                	mov    (%eax),%eax
  803c3a:	85 c0                	test   %eax,%eax
  803c3c:	74 0b                	je     803c49 <realloc_block_FF+0x41e>
  803c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c41:	8b 00                	mov    (%eax),%eax
  803c43:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c46:	89 50 04             	mov    %edx,0x4(%eax)
  803c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c4f:	89 10                	mov    %edx,(%eax)
  803c51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c57:	89 50 04             	mov    %edx,0x4(%eax)
  803c5a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c5d:	8b 00                	mov    (%eax),%eax
  803c5f:	85 c0                	test   %eax,%eax
  803c61:	75 08                	jne    803c6b <realloc_block_FF+0x440>
  803c63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c66:	a3 34 50 80 00       	mov    %eax,0x805034
  803c6b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c70:	40                   	inc    %eax
  803c71:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803c76:	eb 36                	jmp    803cae <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803c78:	a1 38 50 80 00       	mov    0x805038,%eax
  803c7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c84:	74 07                	je     803c8d <realloc_block_FF+0x462>
  803c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c89:	8b 00                	mov    (%eax),%eax
  803c8b:	eb 05                	jmp    803c92 <realloc_block_FF+0x467>
  803c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c92:	a3 38 50 80 00       	mov    %eax,0x805038
  803c97:	a1 38 50 80 00       	mov    0x805038,%eax
  803c9c:	85 c0                	test   %eax,%eax
  803c9e:	0f 85 52 ff ff ff    	jne    803bf6 <realloc_block_FF+0x3cb>
  803ca4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ca8:	0f 85 48 ff ff ff    	jne    803bf6 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803cae:	83 ec 04             	sub    $0x4,%esp
  803cb1:	6a 00                	push   $0x0
  803cb3:	ff 75 d8             	pushl  -0x28(%ebp)
  803cb6:	ff 75 d4             	pushl  -0x2c(%ebp)
  803cb9:	e8 7a eb ff ff       	call   802838 <set_block_data>
  803cbe:	83 c4 10             	add    $0x10,%esp
				return va;
  803cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc4:	e9 7b 02 00 00       	jmp    803f44 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803cc9:	83 ec 0c             	sub    $0xc,%esp
  803ccc:	68 d5 4b 80 00       	push   $0x804bd5
  803cd1:	e8 24 cd ff ff       	call   8009fa <cprintf>
  803cd6:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  803cdc:	e9 63 02 00 00       	jmp    803f44 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ce4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ce7:	0f 86 4d 02 00 00    	jbe    803f3a <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803ced:	83 ec 0c             	sub    $0xc,%esp
  803cf0:	ff 75 e4             	pushl  -0x1c(%ebp)
  803cf3:	e8 08 e8 ff ff       	call   802500 <is_free_block>
  803cf8:	83 c4 10             	add    $0x10,%esp
  803cfb:	84 c0                	test   %al,%al
  803cfd:	0f 84 37 02 00 00    	je     803f3a <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d06:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d09:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803d0c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d0f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d12:	76 38                	jbe    803d4c <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803d14:	83 ec 0c             	sub    $0xc,%esp
  803d17:	ff 75 08             	pushl  0x8(%ebp)
  803d1a:	e8 0c fa ff ff       	call   80372b <free_block>
  803d1f:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803d22:	83 ec 0c             	sub    $0xc,%esp
  803d25:	ff 75 0c             	pushl  0xc(%ebp)
  803d28:	e8 3a eb ff ff       	call   802867 <alloc_block_FF>
  803d2d:	83 c4 10             	add    $0x10,%esp
  803d30:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803d33:	83 ec 08             	sub    $0x8,%esp
  803d36:	ff 75 c0             	pushl  -0x40(%ebp)
  803d39:	ff 75 08             	pushl  0x8(%ebp)
  803d3c:	e8 ab fa ff ff       	call   8037ec <copy_data>
  803d41:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803d44:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803d47:	e9 f8 01 00 00       	jmp    803f44 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803d4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d4f:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803d52:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803d55:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803d59:	0f 87 a0 00 00 00    	ja     803dff <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803d5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d63:	75 17                	jne    803d7c <realloc_block_FF+0x551>
  803d65:	83 ec 04             	sub    $0x4,%esp
  803d68:	68 c7 4a 80 00       	push   $0x804ac7
  803d6d:	68 38 02 00 00       	push   $0x238
  803d72:	68 e5 4a 80 00       	push   $0x804ae5
  803d77:	e8 c1 c9 ff ff       	call   80073d <_panic>
  803d7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d7f:	8b 00                	mov    (%eax),%eax
  803d81:	85 c0                	test   %eax,%eax
  803d83:	74 10                	je     803d95 <realloc_block_FF+0x56a>
  803d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d88:	8b 00                	mov    (%eax),%eax
  803d8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d8d:	8b 52 04             	mov    0x4(%edx),%edx
  803d90:	89 50 04             	mov    %edx,0x4(%eax)
  803d93:	eb 0b                	jmp    803da0 <realloc_block_FF+0x575>
  803d95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d98:	8b 40 04             	mov    0x4(%eax),%eax
  803d9b:	a3 34 50 80 00       	mov    %eax,0x805034
  803da0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da3:	8b 40 04             	mov    0x4(%eax),%eax
  803da6:	85 c0                	test   %eax,%eax
  803da8:	74 0f                	je     803db9 <realloc_block_FF+0x58e>
  803daa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dad:	8b 40 04             	mov    0x4(%eax),%eax
  803db0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803db3:	8b 12                	mov    (%edx),%edx
  803db5:	89 10                	mov    %edx,(%eax)
  803db7:	eb 0a                	jmp    803dc3 <realloc_block_FF+0x598>
  803db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbc:	8b 00                	mov    (%eax),%eax
  803dbe:	a3 30 50 80 00       	mov    %eax,0x805030
  803dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dcf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dd6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ddb:	48                   	dec    %eax
  803ddc:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803de1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803de4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803de7:	01 d0                	add    %edx,%eax
  803de9:	83 ec 04             	sub    $0x4,%esp
  803dec:	6a 01                	push   $0x1
  803dee:	50                   	push   %eax
  803def:	ff 75 08             	pushl  0x8(%ebp)
  803df2:	e8 41 ea ff ff       	call   802838 <set_block_data>
  803df7:	83 c4 10             	add    $0x10,%esp
  803dfa:	e9 36 01 00 00       	jmp    803f35 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803dff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e02:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e05:	01 d0                	add    %edx,%eax
  803e07:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803e0a:	83 ec 04             	sub    $0x4,%esp
  803e0d:	6a 01                	push   $0x1
  803e0f:	ff 75 f0             	pushl  -0x10(%ebp)
  803e12:	ff 75 08             	pushl  0x8(%ebp)
  803e15:	e8 1e ea ff ff       	call   802838 <set_block_data>
  803e1a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e20:	83 e8 04             	sub    $0x4,%eax
  803e23:	8b 00                	mov    (%eax),%eax
  803e25:	83 e0 fe             	and    $0xfffffffe,%eax
  803e28:	89 c2                	mov    %eax,%edx
  803e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2d:	01 d0                	add    %edx,%eax
  803e2f:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803e32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e36:	74 06                	je     803e3e <realloc_block_FF+0x613>
  803e38:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803e3c:	75 17                	jne    803e55 <realloc_block_FF+0x62a>
  803e3e:	83 ec 04             	sub    $0x4,%esp
  803e41:	68 58 4b 80 00       	push   $0x804b58
  803e46:	68 44 02 00 00       	push   $0x244
  803e4b:	68 e5 4a 80 00       	push   $0x804ae5
  803e50:	e8 e8 c8 ff ff       	call   80073d <_panic>
  803e55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e58:	8b 10                	mov    (%eax),%edx
  803e5a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e5d:	89 10                	mov    %edx,(%eax)
  803e5f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e62:	8b 00                	mov    (%eax),%eax
  803e64:	85 c0                	test   %eax,%eax
  803e66:	74 0b                	je     803e73 <realloc_block_FF+0x648>
  803e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e6b:	8b 00                	mov    (%eax),%eax
  803e6d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e70:	89 50 04             	mov    %edx,0x4(%eax)
  803e73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e76:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e79:	89 10                	mov    %edx,(%eax)
  803e7b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e81:	89 50 04             	mov    %edx,0x4(%eax)
  803e84:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e87:	8b 00                	mov    (%eax),%eax
  803e89:	85 c0                	test   %eax,%eax
  803e8b:	75 08                	jne    803e95 <realloc_block_FF+0x66a>
  803e8d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e90:	a3 34 50 80 00       	mov    %eax,0x805034
  803e95:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e9a:	40                   	inc    %eax
  803e9b:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ea0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ea4:	75 17                	jne    803ebd <realloc_block_FF+0x692>
  803ea6:	83 ec 04             	sub    $0x4,%esp
  803ea9:	68 c7 4a 80 00       	push   $0x804ac7
  803eae:	68 45 02 00 00       	push   $0x245
  803eb3:	68 e5 4a 80 00       	push   $0x804ae5
  803eb8:	e8 80 c8 ff ff       	call   80073d <_panic>
  803ebd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec0:	8b 00                	mov    (%eax),%eax
  803ec2:	85 c0                	test   %eax,%eax
  803ec4:	74 10                	je     803ed6 <realloc_block_FF+0x6ab>
  803ec6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec9:	8b 00                	mov    (%eax),%eax
  803ecb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ece:	8b 52 04             	mov    0x4(%edx),%edx
  803ed1:	89 50 04             	mov    %edx,0x4(%eax)
  803ed4:	eb 0b                	jmp    803ee1 <realloc_block_FF+0x6b6>
  803ed6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed9:	8b 40 04             	mov    0x4(%eax),%eax
  803edc:	a3 34 50 80 00       	mov    %eax,0x805034
  803ee1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee4:	8b 40 04             	mov    0x4(%eax),%eax
  803ee7:	85 c0                	test   %eax,%eax
  803ee9:	74 0f                	je     803efa <realloc_block_FF+0x6cf>
  803eeb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eee:	8b 40 04             	mov    0x4(%eax),%eax
  803ef1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ef4:	8b 12                	mov    (%edx),%edx
  803ef6:	89 10                	mov    %edx,(%eax)
  803ef8:	eb 0a                	jmp    803f04 <realloc_block_FF+0x6d9>
  803efa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efd:	8b 00                	mov    (%eax),%eax
  803eff:	a3 30 50 80 00       	mov    %eax,0x805030
  803f04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f17:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f1c:	48                   	dec    %eax
  803f1d:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803f22:	83 ec 04             	sub    $0x4,%esp
  803f25:	6a 00                	push   $0x0
  803f27:	ff 75 bc             	pushl  -0x44(%ebp)
  803f2a:	ff 75 b8             	pushl  -0x48(%ebp)
  803f2d:	e8 06 e9 ff ff       	call   802838 <set_block_data>
  803f32:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803f35:	8b 45 08             	mov    0x8(%ebp),%eax
  803f38:	eb 0a                	jmp    803f44 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803f3a:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803f41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803f44:	c9                   	leave  
  803f45:	c3                   	ret    

00803f46 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803f46:	55                   	push   %ebp
  803f47:	89 e5                	mov    %esp,%ebp
  803f49:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803f4c:	83 ec 04             	sub    $0x4,%esp
  803f4f:	68 dc 4b 80 00       	push   $0x804bdc
  803f54:	68 58 02 00 00       	push   $0x258
  803f59:	68 e5 4a 80 00       	push   $0x804ae5
  803f5e:	e8 da c7 ff ff       	call   80073d <_panic>

00803f63 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803f63:	55                   	push   %ebp
  803f64:	89 e5                	mov    %esp,%ebp
  803f66:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803f69:	83 ec 04             	sub    $0x4,%esp
  803f6c:	68 04 4c 80 00       	push   $0x804c04
  803f71:	68 61 02 00 00       	push   $0x261
  803f76:	68 e5 4a 80 00       	push   $0x804ae5
  803f7b:	e8 bd c7 ff ff       	call   80073d <_panic>

00803f80 <__udivdi3>:
  803f80:	55                   	push   %ebp
  803f81:	57                   	push   %edi
  803f82:	56                   	push   %esi
  803f83:	53                   	push   %ebx
  803f84:	83 ec 1c             	sub    $0x1c,%esp
  803f87:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f8b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f97:	89 ca                	mov    %ecx,%edx
  803f99:	89 f8                	mov    %edi,%eax
  803f9b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f9f:	85 f6                	test   %esi,%esi
  803fa1:	75 2d                	jne    803fd0 <__udivdi3+0x50>
  803fa3:	39 cf                	cmp    %ecx,%edi
  803fa5:	77 65                	ja     80400c <__udivdi3+0x8c>
  803fa7:	89 fd                	mov    %edi,%ebp
  803fa9:	85 ff                	test   %edi,%edi
  803fab:	75 0b                	jne    803fb8 <__udivdi3+0x38>
  803fad:	b8 01 00 00 00       	mov    $0x1,%eax
  803fb2:	31 d2                	xor    %edx,%edx
  803fb4:	f7 f7                	div    %edi
  803fb6:	89 c5                	mov    %eax,%ebp
  803fb8:	31 d2                	xor    %edx,%edx
  803fba:	89 c8                	mov    %ecx,%eax
  803fbc:	f7 f5                	div    %ebp
  803fbe:	89 c1                	mov    %eax,%ecx
  803fc0:	89 d8                	mov    %ebx,%eax
  803fc2:	f7 f5                	div    %ebp
  803fc4:	89 cf                	mov    %ecx,%edi
  803fc6:	89 fa                	mov    %edi,%edx
  803fc8:	83 c4 1c             	add    $0x1c,%esp
  803fcb:	5b                   	pop    %ebx
  803fcc:	5e                   	pop    %esi
  803fcd:	5f                   	pop    %edi
  803fce:	5d                   	pop    %ebp
  803fcf:	c3                   	ret    
  803fd0:	39 ce                	cmp    %ecx,%esi
  803fd2:	77 28                	ja     803ffc <__udivdi3+0x7c>
  803fd4:	0f bd fe             	bsr    %esi,%edi
  803fd7:	83 f7 1f             	xor    $0x1f,%edi
  803fda:	75 40                	jne    80401c <__udivdi3+0x9c>
  803fdc:	39 ce                	cmp    %ecx,%esi
  803fde:	72 0a                	jb     803fea <__udivdi3+0x6a>
  803fe0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803fe4:	0f 87 9e 00 00 00    	ja     804088 <__udivdi3+0x108>
  803fea:	b8 01 00 00 00       	mov    $0x1,%eax
  803fef:	89 fa                	mov    %edi,%edx
  803ff1:	83 c4 1c             	add    $0x1c,%esp
  803ff4:	5b                   	pop    %ebx
  803ff5:	5e                   	pop    %esi
  803ff6:	5f                   	pop    %edi
  803ff7:	5d                   	pop    %ebp
  803ff8:	c3                   	ret    
  803ff9:	8d 76 00             	lea    0x0(%esi),%esi
  803ffc:	31 ff                	xor    %edi,%edi
  803ffe:	31 c0                	xor    %eax,%eax
  804000:	89 fa                	mov    %edi,%edx
  804002:	83 c4 1c             	add    $0x1c,%esp
  804005:	5b                   	pop    %ebx
  804006:	5e                   	pop    %esi
  804007:	5f                   	pop    %edi
  804008:	5d                   	pop    %ebp
  804009:	c3                   	ret    
  80400a:	66 90                	xchg   %ax,%ax
  80400c:	89 d8                	mov    %ebx,%eax
  80400e:	f7 f7                	div    %edi
  804010:	31 ff                	xor    %edi,%edi
  804012:	89 fa                	mov    %edi,%edx
  804014:	83 c4 1c             	add    $0x1c,%esp
  804017:	5b                   	pop    %ebx
  804018:	5e                   	pop    %esi
  804019:	5f                   	pop    %edi
  80401a:	5d                   	pop    %ebp
  80401b:	c3                   	ret    
  80401c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804021:	89 eb                	mov    %ebp,%ebx
  804023:	29 fb                	sub    %edi,%ebx
  804025:	89 f9                	mov    %edi,%ecx
  804027:	d3 e6                	shl    %cl,%esi
  804029:	89 c5                	mov    %eax,%ebp
  80402b:	88 d9                	mov    %bl,%cl
  80402d:	d3 ed                	shr    %cl,%ebp
  80402f:	89 e9                	mov    %ebp,%ecx
  804031:	09 f1                	or     %esi,%ecx
  804033:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804037:	89 f9                	mov    %edi,%ecx
  804039:	d3 e0                	shl    %cl,%eax
  80403b:	89 c5                	mov    %eax,%ebp
  80403d:	89 d6                	mov    %edx,%esi
  80403f:	88 d9                	mov    %bl,%cl
  804041:	d3 ee                	shr    %cl,%esi
  804043:	89 f9                	mov    %edi,%ecx
  804045:	d3 e2                	shl    %cl,%edx
  804047:	8b 44 24 08          	mov    0x8(%esp),%eax
  80404b:	88 d9                	mov    %bl,%cl
  80404d:	d3 e8                	shr    %cl,%eax
  80404f:	09 c2                	or     %eax,%edx
  804051:	89 d0                	mov    %edx,%eax
  804053:	89 f2                	mov    %esi,%edx
  804055:	f7 74 24 0c          	divl   0xc(%esp)
  804059:	89 d6                	mov    %edx,%esi
  80405b:	89 c3                	mov    %eax,%ebx
  80405d:	f7 e5                	mul    %ebp
  80405f:	39 d6                	cmp    %edx,%esi
  804061:	72 19                	jb     80407c <__udivdi3+0xfc>
  804063:	74 0b                	je     804070 <__udivdi3+0xf0>
  804065:	89 d8                	mov    %ebx,%eax
  804067:	31 ff                	xor    %edi,%edi
  804069:	e9 58 ff ff ff       	jmp    803fc6 <__udivdi3+0x46>
  80406e:	66 90                	xchg   %ax,%ax
  804070:	8b 54 24 08          	mov    0x8(%esp),%edx
  804074:	89 f9                	mov    %edi,%ecx
  804076:	d3 e2                	shl    %cl,%edx
  804078:	39 c2                	cmp    %eax,%edx
  80407a:	73 e9                	jae    804065 <__udivdi3+0xe5>
  80407c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80407f:	31 ff                	xor    %edi,%edi
  804081:	e9 40 ff ff ff       	jmp    803fc6 <__udivdi3+0x46>
  804086:	66 90                	xchg   %ax,%ax
  804088:	31 c0                	xor    %eax,%eax
  80408a:	e9 37 ff ff ff       	jmp    803fc6 <__udivdi3+0x46>
  80408f:	90                   	nop

00804090 <__umoddi3>:
  804090:	55                   	push   %ebp
  804091:	57                   	push   %edi
  804092:	56                   	push   %esi
  804093:	53                   	push   %ebx
  804094:	83 ec 1c             	sub    $0x1c,%esp
  804097:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80409b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80409f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040af:	89 f3                	mov    %esi,%ebx
  8040b1:	89 fa                	mov    %edi,%edx
  8040b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040b7:	89 34 24             	mov    %esi,(%esp)
  8040ba:	85 c0                	test   %eax,%eax
  8040bc:	75 1a                	jne    8040d8 <__umoddi3+0x48>
  8040be:	39 f7                	cmp    %esi,%edi
  8040c0:	0f 86 a2 00 00 00    	jbe    804168 <__umoddi3+0xd8>
  8040c6:	89 c8                	mov    %ecx,%eax
  8040c8:	89 f2                	mov    %esi,%edx
  8040ca:	f7 f7                	div    %edi
  8040cc:	89 d0                	mov    %edx,%eax
  8040ce:	31 d2                	xor    %edx,%edx
  8040d0:	83 c4 1c             	add    $0x1c,%esp
  8040d3:	5b                   	pop    %ebx
  8040d4:	5e                   	pop    %esi
  8040d5:	5f                   	pop    %edi
  8040d6:	5d                   	pop    %ebp
  8040d7:	c3                   	ret    
  8040d8:	39 f0                	cmp    %esi,%eax
  8040da:	0f 87 ac 00 00 00    	ja     80418c <__umoddi3+0xfc>
  8040e0:	0f bd e8             	bsr    %eax,%ebp
  8040e3:	83 f5 1f             	xor    $0x1f,%ebp
  8040e6:	0f 84 ac 00 00 00    	je     804198 <__umoddi3+0x108>
  8040ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8040f1:	29 ef                	sub    %ebp,%edi
  8040f3:	89 fe                	mov    %edi,%esi
  8040f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040f9:	89 e9                	mov    %ebp,%ecx
  8040fb:	d3 e0                	shl    %cl,%eax
  8040fd:	89 d7                	mov    %edx,%edi
  8040ff:	89 f1                	mov    %esi,%ecx
  804101:	d3 ef                	shr    %cl,%edi
  804103:	09 c7                	or     %eax,%edi
  804105:	89 e9                	mov    %ebp,%ecx
  804107:	d3 e2                	shl    %cl,%edx
  804109:	89 14 24             	mov    %edx,(%esp)
  80410c:	89 d8                	mov    %ebx,%eax
  80410e:	d3 e0                	shl    %cl,%eax
  804110:	89 c2                	mov    %eax,%edx
  804112:	8b 44 24 08          	mov    0x8(%esp),%eax
  804116:	d3 e0                	shl    %cl,%eax
  804118:	89 44 24 04          	mov    %eax,0x4(%esp)
  80411c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804120:	89 f1                	mov    %esi,%ecx
  804122:	d3 e8                	shr    %cl,%eax
  804124:	09 d0                	or     %edx,%eax
  804126:	d3 eb                	shr    %cl,%ebx
  804128:	89 da                	mov    %ebx,%edx
  80412a:	f7 f7                	div    %edi
  80412c:	89 d3                	mov    %edx,%ebx
  80412e:	f7 24 24             	mull   (%esp)
  804131:	89 c6                	mov    %eax,%esi
  804133:	89 d1                	mov    %edx,%ecx
  804135:	39 d3                	cmp    %edx,%ebx
  804137:	0f 82 87 00 00 00    	jb     8041c4 <__umoddi3+0x134>
  80413d:	0f 84 91 00 00 00    	je     8041d4 <__umoddi3+0x144>
  804143:	8b 54 24 04          	mov    0x4(%esp),%edx
  804147:	29 f2                	sub    %esi,%edx
  804149:	19 cb                	sbb    %ecx,%ebx
  80414b:	89 d8                	mov    %ebx,%eax
  80414d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804151:	d3 e0                	shl    %cl,%eax
  804153:	89 e9                	mov    %ebp,%ecx
  804155:	d3 ea                	shr    %cl,%edx
  804157:	09 d0                	or     %edx,%eax
  804159:	89 e9                	mov    %ebp,%ecx
  80415b:	d3 eb                	shr    %cl,%ebx
  80415d:	89 da                	mov    %ebx,%edx
  80415f:	83 c4 1c             	add    $0x1c,%esp
  804162:	5b                   	pop    %ebx
  804163:	5e                   	pop    %esi
  804164:	5f                   	pop    %edi
  804165:	5d                   	pop    %ebp
  804166:	c3                   	ret    
  804167:	90                   	nop
  804168:	89 fd                	mov    %edi,%ebp
  80416a:	85 ff                	test   %edi,%edi
  80416c:	75 0b                	jne    804179 <__umoddi3+0xe9>
  80416e:	b8 01 00 00 00       	mov    $0x1,%eax
  804173:	31 d2                	xor    %edx,%edx
  804175:	f7 f7                	div    %edi
  804177:	89 c5                	mov    %eax,%ebp
  804179:	89 f0                	mov    %esi,%eax
  80417b:	31 d2                	xor    %edx,%edx
  80417d:	f7 f5                	div    %ebp
  80417f:	89 c8                	mov    %ecx,%eax
  804181:	f7 f5                	div    %ebp
  804183:	89 d0                	mov    %edx,%eax
  804185:	e9 44 ff ff ff       	jmp    8040ce <__umoddi3+0x3e>
  80418a:	66 90                	xchg   %ax,%ax
  80418c:	89 c8                	mov    %ecx,%eax
  80418e:	89 f2                	mov    %esi,%edx
  804190:	83 c4 1c             	add    $0x1c,%esp
  804193:	5b                   	pop    %ebx
  804194:	5e                   	pop    %esi
  804195:	5f                   	pop    %edi
  804196:	5d                   	pop    %ebp
  804197:	c3                   	ret    
  804198:	3b 04 24             	cmp    (%esp),%eax
  80419b:	72 06                	jb     8041a3 <__umoddi3+0x113>
  80419d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8041a1:	77 0f                	ja     8041b2 <__umoddi3+0x122>
  8041a3:	89 f2                	mov    %esi,%edx
  8041a5:	29 f9                	sub    %edi,%ecx
  8041a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8041ab:	89 14 24             	mov    %edx,(%esp)
  8041ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041b6:	8b 14 24             	mov    (%esp),%edx
  8041b9:	83 c4 1c             	add    $0x1c,%esp
  8041bc:	5b                   	pop    %ebx
  8041bd:	5e                   	pop    %esi
  8041be:	5f                   	pop    %edi
  8041bf:	5d                   	pop    %ebp
  8041c0:	c3                   	ret    
  8041c1:	8d 76 00             	lea    0x0(%esi),%esi
  8041c4:	2b 04 24             	sub    (%esp),%eax
  8041c7:	19 fa                	sbb    %edi,%edx
  8041c9:	89 d1                	mov    %edx,%ecx
  8041cb:	89 c6                	mov    %eax,%esi
  8041cd:	e9 71 ff ff ff       	jmp    804143 <__umoddi3+0xb3>
  8041d2:	66 90                	xchg   %ax,%ax
  8041d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041d8:	72 ea                	jb     8041c4 <__umoddi3+0x134>
  8041da:	89 d9                	mov    %ebx,%ecx
  8041dc:	e9 62 ff ff ff       	jmp    804143 <__umoddi3+0xb3>
