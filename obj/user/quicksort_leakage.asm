
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
  800041:	e8 08 1f 00 00       	call   801f4e <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 42 80 00       	push   $0x804220
  80004e:	e8 a7 09 00 00       	call   8009fa <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 42 80 00       	push   $0x804222
  80005e:	e8 97 09 00 00       	call   8009fa <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 3b 42 80 00       	push   $0x80423b
  80006e:	e8 87 09 00 00       	call   8009fa <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 42 80 00       	push   $0x804222
  80007e:	e8 77 09 00 00       	call   8009fa <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 42 80 00       	push   $0x804220
  80008e:	e8 67 09 00 00       	call   8009fa <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 54 42 80 00       	push   $0x804254
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
  8000c9:	68 74 42 80 00       	push   $0x804274
  8000ce:	e8 27 09 00 00       	call   8009fa <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 96 42 80 00       	push   $0x804296
  8000de:	e8 17 09 00 00       	call   8009fa <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 a4 42 80 00       	push   $0x8042a4
  8000ee:	e8 07 09 00 00       	call   8009fa <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 b3 42 80 00       	push   $0x8042b3
  8000fe:	e8 f7 08 00 00       	call   8009fa <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 c3 42 80 00       	push   $0x8042c3
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
  80014d:	e8 16 1e 00 00       	call   801f68 <sys_unlock_cons>
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
  8001d5:	e8 74 1d 00 00       	call   801f4e <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 cc 42 80 00       	push   $0x8042cc
  8001e2:	e8 13 08 00 00       	call   8009fa <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 79 1d 00 00       	call   801f68 <sys_unlock_cons>
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
  80020c:	68 00 43 80 00       	push   $0x804300
  800211:	6a 54                	push   $0x54
  800213:	68 22 43 80 00       	push   $0x804322
  800218:	e8 20 05 00 00       	call   80073d <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 2c 1d 00 00       	call   801f4e <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 3c 43 80 00       	push   $0x80433c
  80022a:	e8 cb 07 00 00       	call   8009fa <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 70 43 80 00       	push   $0x804370
  80023a:	e8 bb 07 00 00       	call   8009fa <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 a4 43 80 00       	push   $0x8043a4
  80024a:	e8 ab 07 00 00       	call   8009fa <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 11 1d 00 00       	call   801f68 <sys_unlock_cons>


		}

		//		sys_lock_cons();
		sys_lock_cons();
  800257:	e8 f2 1c 00 00       	call   801f4e <sys_lock_cons>
		{
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 d6 43 80 00       	push   $0x8043d6
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
  8002b0:	e8 b3 1c 00 00       	call   801f68 <sys_unlock_cons>
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
  800562:	68 20 42 80 00       	push   $0x804220
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
  800584:	68 f4 43 80 00       	push   $0x8043f4
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
  8005b2:	68 f9 43 80 00       	push   $0x8043f9
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
  8005d6:	e8 be 1a 00 00       	call   802099 <sys_cputc>
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
  8005e7:	e8 49 19 00 00       	call   801f35 <sys_cgetc>
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
  800604:	e8 c1 1b 00 00       	call   8021ca <sys_getenvindex>
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
  800672:	e8 d7 18 00 00       	call   801f4e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800677:	83 ec 0c             	sub    $0xc,%esp
  80067a:	68 18 44 80 00       	push   $0x804418
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
  8006a2:	68 40 44 80 00       	push   $0x804440
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
  8006d3:	68 68 44 80 00       	push   $0x804468
  8006d8:	e8 1d 03 00 00       	call   8009fa <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006e0:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	50                   	push   %eax
  8006ef:	68 c0 44 80 00       	push   $0x8044c0
  8006f4:	e8 01 03 00 00       	call   8009fa <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	68 18 44 80 00       	push   $0x804418
  800704:	e8 f1 02 00 00       	call   8009fa <cprintf>
  800709:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80070c:	e8 57 18 00 00       	call   801f68 <sys_unlock_cons>
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
  800724:	e8 6d 1a 00 00       	call   802196 <sys_destroy_env>
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
  800735:	e8 c2 1a 00 00       	call   8021fc <sys_exit_env>
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
  80075e:	68 d4 44 80 00       	push   $0x8044d4
  800763:	e8 92 02 00 00       	call   8009fa <cprintf>
  800768:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80076b:	a1 00 50 80 00       	mov    0x805000,%eax
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	ff 75 08             	pushl  0x8(%ebp)
  800776:	50                   	push   %eax
  800777:	68 d9 44 80 00       	push   $0x8044d9
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
  80079b:	68 f5 44 80 00       	push   $0x8044f5
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
  8007ca:	68 f8 44 80 00       	push   $0x8044f8
  8007cf:	6a 26                	push   $0x26
  8007d1:	68 44 45 80 00       	push   $0x804544
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
  80089f:	68 50 45 80 00       	push   $0x804550
  8008a4:	6a 3a                	push   $0x3a
  8008a6:	68 44 45 80 00       	push   $0x804544
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
  800912:	68 a4 45 80 00       	push   $0x8045a4
  800917:	6a 44                	push   $0x44
  800919:	68 44 45 80 00       	push   $0x804544
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
  80096c:	e8 9b 15 00 00       	call   801f0c <sys_cputs>
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
  8009e3:	e8 24 15 00 00       	call   801f0c <sys_cputs>
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
  800a2d:	e8 1c 15 00 00       	call   801f4e <sys_lock_cons>
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
  800a4d:	e8 16 15 00 00       	call   801f68 <sys_unlock_cons>
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
  800a97:	e8 08 35 00 00       	call   803fa4 <__udivdi3>
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
  800ae7:	e8 c8 35 00 00       	call   8040b4 <__umoddi3>
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	05 14 48 80 00       	add    $0x804814,%eax
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
  800c42:	8b 04 85 38 48 80 00 	mov    0x804838(,%eax,4),%eax
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
  800d23:	8b 34 9d 80 46 80 00 	mov    0x804680(,%ebx,4),%esi
  800d2a:	85 f6                	test   %esi,%esi
  800d2c:	75 19                	jne    800d47 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d2e:	53                   	push   %ebx
  800d2f:	68 25 48 80 00       	push   $0x804825
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
  800d48:	68 2e 48 80 00       	push   $0x80482e
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
  800d75:	be 31 48 80 00       	mov    $0x804831,%esi
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
  8010a0:	68 a8 49 80 00       	push   $0x8049a8
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
  8010e2:	68 ab 49 80 00       	push   $0x8049ab
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
  801193:	e8 b6 0d 00 00       	call   801f4e <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801198:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80119c:	74 13                	je     8011b1 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	ff 75 08             	pushl  0x8(%ebp)
  8011a4:	68 a8 49 80 00       	push   $0x8049a8
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
  8011e6:	68 ab 49 80 00       	push   $0x8049ab
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
  80128e:	e8 d5 0c 00 00       	call   801f68 <sys_unlock_cons>
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
  801988:	68 bc 49 80 00       	push   $0x8049bc
  80198d:	68 3f 01 00 00       	push   $0x13f
  801992:	68 de 49 80 00       	push   $0x8049de
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
  8019a8:	e8 0a 0b 00 00       	call   8024b7 <sys_sbrk>
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
  801a23:	e8 13 09 00 00       	call   80233b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	74 16                	je     801a42 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a2c:	83 ec 0c             	sub    $0xc,%esp
  801a2f:	ff 75 08             	pushl  0x8(%ebp)
  801a32:	e8 53 0e 00 00       	call   80288a <alloc_block_FF>
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a3d:	e9 8a 01 00 00       	jmp    801bcc <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801a42:	e8 25 09 00 00       	call   80236c <sys_isUHeapPlacementStrategyBESTFIT>
  801a47:	85 c0                	test   %eax,%eax
  801a49:	0f 84 7d 01 00 00    	je     801bcc <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	e8 ec 12 00 00       	call   802d46 <alloc_block_BF>
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
  801bbb:	e8 2e 09 00 00       	call   8024ee <sys_allocate_user_mem>
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
  801c03:	e8 02 09 00 00       	call   80250a <get_block_size>
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c0e:	83 ec 0c             	sub    $0xc,%esp
  801c11:	ff 75 08             	pushl  0x8(%ebp)
  801c14:	e8 35 1b 00 00       	call   80374e <free_block>
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
  801cab:	e8 22 08 00 00       	call   8024d2 <sys_free_user_mem>
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
  801cb9:	68 ec 49 80 00       	push   $0x8049ec
  801cbe:	68 85 00 00 00       	push   $0x85
  801cc3:	68 16 4a 80 00       	push   $0x804a16
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
  801d2e:	e8 a6 03 00 00       	call   8020d9 <sys_createSharedObject>
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
  801d52:	68 22 4a 80 00       	push   $0x804a22
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
  801d96:	e8 68 03 00 00       	call   802103 <sys_getSizeOfSharedObject>
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801da1:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801da5:	75 07                	jne    801dae <sget+0x27>
  801da7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dac:	eb 7f                	jmp    801e2d <sget+0xa6>
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
  801de1:	eb 4a                	jmp    801e2d <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801de3:	83 ec 04             	sub    $0x4,%esp
  801de6:	ff 75 e8             	pushl  -0x18(%ebp)
  801de9:	ff 75 0c             	pushl  0xc(%ebp)
  801dec:	ff 75 08             	pushl  0x8(%ebp)
  801def:	e8 2c 03 00 00       	call   802120 <sys_getSharedObject>
  801df4:	83 c4 10             	add    $0x10,%esp
  801df7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801dfa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801dfd:	a1 24 50 80 00       	mov    0x805024,%eax
  801e02:	8b 40 78             	mov    0x78(%eax),%eax
  801e05:	29 c2                	sub    %eax,%edx
  801e07:	89 d0                	mov    %edx,%eax
  801e09:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e0e:	c1 e8 0c             	shr    $0xc,%eax
  801e11:	89 c2                	mov    %eax,%edx
  801e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e16:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801e1d:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801e21:	75 07                	jne    801e2a <sget+0xa3>
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
  801e28:	eb 03                	jmp    801e2d <sget+0xa6>
	return ptr;
  801e2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801e35:	8b 55 08             	mov    0x8(%ebp),%edx
  801e38:	a1 24 50 80 00       	mov    0x805024,%eax
  801e3d:	8b 40 78             	mov    0x78(%eax),%eax
  801e40:	29 c2                	sub    %eax,%edx
  801e42:	89 d0                	mov    %edx,%eax
  801e44:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e49:	c1 e8 0c             	shr    $0xc,%eax
  801e4c:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801e53:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801e56:	83 ec 08             	sub    $0x8,%esp
  801e59:	ff 75 08             	pushl  0x8(%ebp)
  801e5c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e5f:	e8 db 02 00 00       	call   80213f <sys_freeSharedObject>
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801e6a:	90                   	nop
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e73:	83 ec 04             	sub    $0x4,%esp
  801e76:	68 34 4a 80 00       	push   $0x804a34
  801e7b:	68 de 00 00 00       	push   $0xde
  801e80:	68 16 4a 80 00       	push   $0x804a16
  801e85:	e8 b3 e8 ff ff       	call   80073d <_panic>

00801e8a <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	68 5a 4a 80 00       	push   $0x804a5a
  801e98:	68 ea 00 00 00       	push   $0xea
  801e9d:	68 16 4a 80 00       	push   $0x804a16
  801ea2:	e8 96 e8 ff ff       	call   80073d <_panic>

00801ea7 <shrink>:

}
void shrink(uint32 newSize)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ead:	83 ec 04             	sub    $0x4,%esp
  801eb0:	68 5a 4a 80 00       	push   $0x804a5a
  801eb5:	68 ef 00 00 00       	push   $0xef
  801eba:	68 16 4a 80 00       	push   $0x804a16
  801ebf:	e8 79 e8 ff ff       	call   80073d <_panic>

00801ec4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eca:	83 ec 04             	sub    $0x4,%esp
  801ecd:	68 5a 4a 80 00       	push   $0x804a5a
  801ed2:	68 f4 00 00 00       	push   $0xf4
  801ed7:	68 16 4a 80 00       	push   $0x804a16
  801edc:	e8 5c e8 ff ff       	call   80073d <_panic>

00801ee1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	57                   	push   %edi
  801ee5:	56                   	push   %esi
  801ee6:	53                   	push   %ebx
  801ee7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef6:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ef9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801efc:	cd 30                	int    $0x30
  801efe:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f04:	83 c4 10             	add    $0x10,%esp
  801f07:	5b                   	pop    %ebx
  801f08:	5e                   	pop    %esi
  801f09:	5f                   	pop    %edi
  801f0a:	5d                   	pop    %ebp
  801f0b:	c3                   	ret    

00801f0c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	83 ec 04             	sub    $0x4,%esp
  801f12:	8b 45 10             	mov    0x10(%ebp),%eax
  801f15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f18:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	52                   	push   %edx
  801f24:	ff 75 0c             	pushl  0xc(%ebp)
  801f27:	50                   	push   %eax
  801f28:	6a 00                	push   $0x0
  801f2a:	e8 b2 ff ff ff       	call   801ee1 <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
}
  801f32:	90                   	nop
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 02                	push   $0x2
  801f44:	e8 98 ff ff ff       	call   801ee1 <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <sys_lock_cons>:

void sys_lock_cons(void)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 03                	push   $0x3
  801f5d:	e8 7f ff ff ff       	call   801ee1 <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
}
  801f65:	90                   	nop
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 04                	push   $0x4
  801f77:	e8 65 ff ff ff       	call   801ee1 <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
}
  801f7f:	90                   	nop
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	52                   	push   %edx
  801f92:	50                   	push   %eax
  801f93:	6a 08                	push   $0x8
  801f95:	e8 47 ff ff ff       	call   801ee1 <syscall>
  801f9a:	83 c4 18             	add    $0x18,%esp
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	56                   	push   %esi
  801fa3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fa4:	8b 75 18             	mov    0x18(%ebp),%esi
  801fa7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801faa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	56                   	push   %esi
  801fb4:	53                   	push   %ebx
  801fb5:	51                   	push   %ecx
  801fb6:	52                   	push   %edx
  801fb7:	50                   	push   %eax
  801fb8:	6a 09                	push   $0x9
  801fba:	e8 22 ff ff ff       	call   801ee1 <syscall>
  801fbf:	83 c4 18             	add    $0x18,%esp
}
  801fc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc5:	5b                   	pop    %ebx
  801fc6:	5e                   	pop    %esi
  801fc7:	5d                   	pop    %ebp
  801fc8:	c3                   	ret    

00801fc9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	52                   	push   %edx
  801fd9:	50                   	push   %eax
  801fda:	6a 0a                	push   $0xa
  801fdc:	e8 00 ff ff ff       	call   801ee1 <syscall>
  801fe1:	83 c4 18             	add    $0x18,%esp
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	ff 75 0c             	pushl  0xc(%ebp)
  801ff2:	ff 75 08             	pushl  0x8(%ebp)
  801ff5:	6a 0b                	push   $0xb
  801ff7:	e8 e5 fe ff ff       	call   801ee1 <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 0c                	push   $0xc
  802010:	e8 cc fe ff ff       	call   801ee1 <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 0d                	push   $0xd
  802029:	e8 b3 fe ff ff       	call   801ee1 <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 0e                	push   $0xe
  802042:	e8 9a fe ff ff       	call   801ee1 <syscall>
  802047:	83 c4 18             	add    $0x18,%esp
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 0f                	push   $0xf
  80205b:	e8 81 fe ff ff       	call   801ee1 <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	ff 75 08             	pushl  0x8(%ebp)
  802073:	6a 10                	push   $0x10
  802075:	e8 67 fe ff ff       	call   801ee1 <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 11                	push   $0x11
  80208e:	e8 4e fe ff ff       	call   801ee1 <syscall>
  802093:	83 c4 18             	add    $0x18,%esp
}
  802096:	90                   	nop
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <sys_cputc>:

void
sys_cputc(const char c)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 04             	sub    $0x4,%esp
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020a5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	50                   	push   %eax
  8020b2:	6a 01                	push   $0x1
  8020b4:	e8 28 fe ff ff       	call   801ee1 <syscall>
  8020b9:	83 c4 18             	add    $0x18,%esp
}
  8020bc:	90                   	nop
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 14                	push   $0x14
  8020ce:	e8 0e fe ff ff       	call   801ee1 <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
}
  8020d6:	90                   	nop
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020e5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020e8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	6a 00                	push   $0x0
  8020f1:	51                   	push   %ecx
  8020f2:	52                   	push   %edx
  8020f3:	ff 75 0c             	pushl  0xc(%ebp)
  8020f6:	50                   	push   %eax
  8020f7:	6a 15                	push   $0x15
  8020f9:	e8 e3 fd ff ff       	call   801ee1 <syscall>
  8020fe:	83 c4 18             	add    $0x18,%esp
}
  802101:	c9                   	leave  
  802102:	c3                   	ret    

00802103 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802106:	8b 55 0c             	mov    0xc(%ebp),%edx
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	52                   	push   %edx
  802113:	50                   	push   %eax
  802114:	6a 16                	push   $0x16
  802116:	e8 c6 fd ff ff       	call   801ee1 <syscall>
  80211b:	83 c4 18             	add    $0x18,%esp
}
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802123:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802126:	8b 55 0c             	mov    0xc(%ebp),%edx
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	51                   	push   %ecx
  802131:	52                   	push   %edx
  802132:	50                   	push   %eax
  802133:	6a 17                	push   $0x17
  802135:	e8 a7 fd ff ff       	call   801ee1 <syscall>
  80213a:	83 c4 18             	add    $0x18,%esp
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802142:	8b 55 0c             	mov    0xc(%ebp),%edx
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	52                   	push   %edx
  80214f:	50                   	push   %eax
  802150:	6a 18                	push   $0x18
  802152:	e8 8a fd ff ff       	call   801ee1 <syscall>
  802157:	83 c4 18             	add    $0x18,%esp
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	6a 00                	push   $0x0
  802164:	ff 75 14             	pushl  0x14(%ebp)
  802167:	ff 75 10             	pushl  0x10(%ebp)
  80216a:	ff 75 0c             	pushl  0xc(%ebp)
  80216d:	50                   	push   %eax
  80216e:	6a 19                	push   $0x19
  802170:	e8 6c fd ff ff       	call   801ee1 <syscall>
  802175:	83 c4 18             	add    $0x18,%esp
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	50                   	push   %eax
  802189:	6a 1a                	push   $0x1a
  80218b:	e8 51 fd ff ff       	call   801ee1 <syscall>
  802190:	83 c4 18             	add    $0x18,%esp
}
  802193:	90                   	nop
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	50                   	push   %eax
  8021a5:	6a 1b                	push   $0x1b
  8021a7:	e8 35 fd ff ff       	call   801ee1 <syscall>
  8021ac:	83 c4 18             	add    $0x18,%esp
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 05                	push   $0x5
  8021c0:	e8 1c fd ff ff       	call   801ee1 <syscall>
  8021c5:	83 c4 18             	add    $0x18,%esp
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 06                	push   $0x6
  8021d9:	e8 03 fd ff ff       	call   801ee1 <syscall>
  8021de:	83 c4 18             	add    $0x18,%esp
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 07                	push   $0x7
  8021f2:	e8 ea fc ff ff       	call   801ee1 <syscall>
  8021f7:	83 c4 18             	add    $0x18,%esp
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <sys_exit_env>:


void sys_exit_env(void)
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 1c                	push   $0x1c
  80220b:	e8 d1 fc ff ff       	call   801ee1 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
}
  802213:	90                   	nop
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80221c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80221f:	8d 50 04             	lea    0x4(%eax),%edx
  802222:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	52                   	push   %edx
  80222c:	50                   	push   %eax
  80222d:	6a 1d                	push   $0x1d
  80222f:	e8 ad fc ff ff       	call   801ee1 <syscall>
  802234:	83 c4 18             	add    $0x18,%esp
	return result;
  802237:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80223a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80223d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802240:	89 01                	mov    %eax,(%ecx)
  802242:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	c9                   	leave  
  802249:	c2 04 00             	ret    $0x4

0080224c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	ff 75 10             	pushl  0x10(%ebp)
  802256:	ff 75 0c             	pushl  0xc(%ebp)
  802259:	ff 75 08             	pushl  0x8(%ebp)
  80225c:	6a 13                	push   $0x13
  80225e:	e8 7e fc ff ff       	call   801ee1 <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
	return ;
  802266:	90                   	nop
}
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <sys_rcr2>:
uint32 sys_rcr2()
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 1e                	push   $0x1e
  802278:	e8 64 fc ff ff       	call   801ee1 <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	83 ec 04             	sub    $0x4,%esp
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80228e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	50                   	push   %eax
  80229b:	6a 1f                	push   $0x1f
  80229d:	e8 3f fc ff ff       	call   801ee1 <syscall>
  8022a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022a5:	90                   	nop
}
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <rsttst>:
void rsttst()
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 21                	push   $0x21
  8022b7:	e8 25 fc ff ff       	call   801ee1 <syscall>
  8022bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8022bf:	90                   	nop
}
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    

008022c2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	83 ec 04             	sub    $0x4,%esp
  8022c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8022cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022ce:	8b 55 18             	mov    0x18(%ebp),%edx
  8022d1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022d5:	52                   	push   %edx
  8022d6:	50                   	push   %eax
  8022d7:	ff 75 10             	pushl  0x10(%ebp)
  8022da:	ff 75 0c             	pushl  0xc(%ebp)
  8022dd:	ff 75 08             	pushl  0x8(%ebp)
  8022e0:	6a 20                	push   $0x20
  8022e2:	e8 fa fb ff ff       	call   801ee1 <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ea:	90                   	nop
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <chktst>:
void chktst(uint32 n)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	ff 75 08             	pushl  0x8(%ebp)
  8022fb:	6a 22                	push   $0x22
  8022fd:	e8 df fb ff ff       	call   801ee1 <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
	return ;
  802305:	90                   	nop
}
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <inctst>:

void inctst()
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 23                	push   $0x23
  802317:	e8 c5 fb ff ff       	call   801ee1 <syscall>
  80231c:	83 c4 18             	add    $0x18,%esp
	return ;
  80231f:	90                   	nop
}
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <gettst>:
uint32 gettst()
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 24                	push   $0x24
  802331:	e8 ab fb ff ff       	call   801ee1 <syscall>
  802336:	83 c4 18             	add    $0x18,%esp
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 25                	push   $0x25
  80234d:	e8 8f fb ff ff       	call   801ee1 <syscall>
  802352:	83 c4 18             	add    $0x18,%esp
  802355:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802358:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80235c:	75 07                	jne    802365 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
  802363:	eb 05                	jmp    80236a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802365:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 25                	push   $0x25
  80237e:	e8 5e fb ff ff       	call   801ee1 <syscall>
  802383:	83 c4 18             	add    $0x18,%esp
  802386:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802389:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80238d:	75 07                	jne    802396 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80238f:	b8 01 00 00 00       	mov    $0x1,%eax
  802394:	eb 05                	jmp    80239b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802396:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

0080239d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
  8023a0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 25                	push   $0x25
  8023af:	e8 2d fb ff ff       	call   801ee1 <syscall>
  8023b4:	83 c4 18             	add    $0x18,%esp
  8023b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023ba:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023be:	75 07                	jne    8023c7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c5:	eb 05                	jmp    8023cc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cc:	c9                   	leave  
  8023cd:	c3                   	ret    

008023ce <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
  8023d1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 25                	push   $0x25
  8023e0:	e8 fc fa ff ff       	call   801ee1 <syscall>
  8023e5:	83 c4 18             	add    $0x18,%esp
  8023e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023eb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023ef:	75 07                	jne    8023f8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f6:	eb 05                	jmp    8023fd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	ff 75 08             	pushl  0x8(%ebp)
  80240d:	6a 26                	push   $0x26
  80240f:	e8 cd fa ff ff       	call   801ee1 <syscall>
  802414:	83 c4 18             	add    $0x18,%esp
	return ;
  802417:	90                   	nop
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80241e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802421:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802424:	8b 55 0c             	mov    0xc(%ebp),%edx
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	6a 00                	push   $0x0
  80242c:	53                   	push   %ebx
  80242d:	51                   	push   %ecx
  80242e:	52                   	push   %edx
  80242f:	50                   	push   %eax
  802430:	6a 27                	push   $0x27
  802432:	e8 aa fa ff ff       	call   801ee1 <syscall>
  802437:	83 c4 18             	add    $0x18,%esp
}
  80243a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802442:	8b 55 0c             	mov    0xc(%ebp),%edx
  802445:	8b 45 08             	mov    0x8(%ebp),%eax
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	52                   	push   %edx
  80244f:	50                   	push   %eax
  802450:	6a 28                	push   $0x28
  802452:	e8 8a fa ff ff       	call   801ee1 <syscall>
  802457:	83 c4 18             	add    $0x18,%esp
}
  80245a:	c9                   	leave  
  80245b:	c3                   	ret    

0080245c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80245f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802462:	8b 55 0c             	mov    0xc(%ebp),%edx
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	6a 00                	push   $0x0
  80246a:	51                   	push   %ecx
  80246b:	ff 75 10             	pushl  0x10(%ebp)
  80246e:	52                   	push   %edx
  80246f:	50                   	push   %eax
  802470:	6a 29                	push   $0x29
  802472:	e8 6a fa ff ff       	call   801ee1 <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	ff 75 10             	pushl  0x10(%ebp)
  802486:	ff 75 0c             	pushl  0xc(%ebp)
  802489:	ff 75 08             	pushl  0x8(%ebp)
  80248c:	6a 12                	push   $0x12
  80248e:	e8 4e fa ff ff       	call   801ee1 <syscall>
  802493:	83 c4 18             	add    $0x18,%esp
	return ;
  802496:	90                   	nop
}
  802497:	c9                   	leave  
  802498:	c3                   	ret    

00802499 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80249c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	52                   	push   %edx
  8024a9:	50                   	push   %eax
  8024aa:	6a 2a                	push   $0x2a
  8024ac:	e8 30 fa ff ff       	call   801ee1 <syscall>
  8024b1:	83 c4 18             	add    $0x18,%esp
	return;
  8024b4:	90                   	nop
}
  8024b5:	c9                   	leave  
  8024b6:	c3                   	ret    

008024b7 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8024b7:	55                   	push   %ebp
  8024b8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	50                   	push   %eax
  8024c6:	6a 2b                	push   $0x2b
  8024c8:	e8 14 fa ff ff       	call   801ee1 <syscall>
  8024cd:	83 c4 18             	add    $0x18,%esp
}
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	ff 75 0c             	pushl  0xc(%ebp)
  8024de:	ff 75 08             	pushl  0x8(%ebp)
  8024e1:	6a 2c                	push   $0x2c
  8024e3:	e8 f9 f9 ff ff       	call   801ee1 <syscall>
  8024e8:	83 c4 18             	add    $0x18,%esp
	return;
  8024eb:	90                   	nop
}
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	ff 75 0c             	pushl  0xc(%ebp)
  8024fa:	ff 75 08             	pushl  0x8(%ebp)
  8024fd:	6a 2d                	push   $0x2d
  8024ff:	e8 dd f9 ff ff       	call   801ee1 <syscall>
  802504:	83 c4 18             	add    $0x18,%esp
	return;
  802507:	90                   	nop
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	83 e8 04             	sub    $0x4,%eax
  802516:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802519:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802521:	c9                   	leave  
  802522:	c3                   	ret    

00802523 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
  802526:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	83 e8 04             	sub    $0x4,%eax
  80252f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802532:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	83 e0 01             	and    $0x1,%eax
  80253a:	85 c0                	test   %eax,%eax
  80253c:	0f 94 c0             	sete   %al
}
  80253f:	c9                   	leave  
  802540:	c3                   	ret    

00802541 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
  802544:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802547:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80254e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802551:	83 f8 02             	cmp    $0x2,%eax
  802554:	74 2b                	je     802581 <alloc_block+0x40>
  802556:	83 f8 02             	cmp    $0x2,%eax
  802559:	7f 07                	jg     802562 <alloc_block+0x21>
  80255b:	83 f8 01             	cmp    $0x1,%eax
  80255e:	74 0e                	je     80256e <alloc_block+0x2d>
  802560:	eb 58                	jmp    8025ba <alloc_block+0x79>
  802562:	83 f8 03             	cmp    $0x3,%eax
  802565:	74 2d                	je     802594 <alloc_block+0x53>
  802567:	83 f8 04             	cmp    $0x4,%eax
  80256a:	74 3b                	je     8025a7 <alloc_block+0x66>
  80256c:	eb 4c                	jmp    8025ba <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80256e:	83 ec 0c             	sub    $0xc,%esp
  802571:	ff 75 08             	pushl  0x8(%ebp)
  802574:	e8 11 03 00 00       	call   80288a <alloc_block_FF>
  802579:	83 c4 10             	add    $0x10,%esp
  80257c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80257f:	eb 4a                	jmp    8025cb <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802581:	83 ec 0c             	sub    $0xc,%esp
  802584:	ff 75 08             	pushl  0x8(%ebp)
  802587:	e8 fa 19 00 00       	call   803f86 <alloc_block_NF>
  80258c:	83 c4 10             	add    $0x10,%esp
  80258f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802592:	eb 37                	jmp    8025cb <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802594:	83 ec 0c             	sub    $0xc,%esp
  802597:	ff 75 08             	pushl  0x8(%ebp)
  80259a:	e8 a7 07 00 00       	call   802d46 <alloc_block_BF>
  80259f:	83 c4 10             	add    $0x10,%esp
  8025a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025a5:	eb 24                	jmp    8025cb <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8025a7:	83 ec 0c             	sub    $0xc,%esp
  8025aa:	ff 75 08             	pushl  0x8(%ebp)
  8025ad:	e8 b7 19 00 00       	call   803f69 <alloc_block_WF>
  8025b2:	83 c4 10             	add    $0x10,%esp
  8025b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025b8:	eb 11                	jmp    8025cb <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8025ba:	83 ec 0c             	sub    $0xc,%esp
  8025bd:	68 6c 4a 80 00       	push   $0x804a6c
  8025c2:	e8 33 e4 ff ff       	call   8009fa <cprintf>
  8025c7:	83 c4 10             	add    $0x10,%esp
		break;
  8025ca:	90                   	nop
	}
	return va;
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    

008025d0 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	53                   	push   %ebx
  8025d4:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8025d7:	83 ec 0c             	sub    $0xc,%esp
  8025da:	68 8c 4a 80 00       	push   $0x804a8c
  8025df:	e8 16 e4 ff ff       	call   8009fa <cprintf>
  8025e4:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8025e7:	83 ec 0c             	sub    $0xc,%esp
  8025ea:	68 b7 4a 80 00       	push   $0x804ab7
  8025ef:	e8 06 e4 ff ff       	call   8009fa <cprintf>
  8025f4:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8025f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fd:	eb 37                	jmp    802636 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8025ff:	83 ec 0c             	sub    $0xc,%esp
  802602:	ff 75 f4             	pushl  -0xc(%ebp)
  802605:	e8 19 ff ff ff       	call   802523 <is_free_block>
  80260a:	83 c4 10             	add    $0x10,%esp
  80260d:	0f be d8             	movsbl %al,%ebx
  802610:	83 ec 0c             	sub    $0xc,%esp
  802613:	ff 75 f4             	pushl  -0xc(%ebp)
  802616:	e8 ef fe ff ff       	call   80250a <get_block_size>
  80261b:	83 c4 10             	add    $0x10,%esp
  80261e:	83 ec 04             	sub    $0x4,%esp
  802621:	53                   	push   %ebx
  802622:	50                   	push   %eax
  802623:	68 cf 4a 80 00       	push   $0x804acf
  802628:	e8 cd e3 ff ff       	call   8009fa <cprintf>
  80262d:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802630:	8b 45 10             	mov    0x10(%ebp),%eax
  802633:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802636:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263a:	74 07                	je     802643 <print_blocks_list+0x73>
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	8b 00                	mov    (%eax),%eax
  802641:	eb 05                	jmp    802648 <print_blocks_list+0x78>
  802643:	b8 00 00 00 00       	mov    $0x0,%eax
  802648:	89 45 10             	mov    %eax,0x10(%ebp)
  80264b:	8b 45 10             	mov    0x10(%ebp),%eax
  80264e:	85 c0                	test   %eax,%eax
  802650:	75 ad                	jne    8025ff <print_blocks_list+0x2f>
  802652:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802656:	75 a7                	jne    8025ff <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802658:	83 ec 0c             	sub    $0xc,%esp
  80265b:	68 8c 4a 80 00       	push   $0x804a8c
  802660:	e8 95 e3 ff ff       	call   8009fa <cprintf>
  802665:	83 c4 10             	add    $0x10,%esp

}
  802668:	90                   	nop
  802669:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802674:	8b 45 0c             	mov    0xc(%ebp),%eax
  802677:	83 e0 01             	and    $0x1,%eax
  80267a:	85 c0                	test   %eax,%eax
  80267c:	74 03                	je     802681 <initialize_dynamic_allocator+0x13>
  80267e:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802681:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802685:	0f 84 c7 01 00 00    	je     802852 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80268b:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802692:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802695:	8b 55 08             	mov    0x8(%ebp),%edx
  802698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80269b:	01 d0                	add    %edx,%eax
  80269d:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8026a2:	0f 87 ad 01 00 00    	ja     802855 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8026a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	0f 89 a5 01 00 00    	jns    802858 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8026b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026b9:	01 d0                	add    %edx,%eax
  8026bb:	83 e8 04             	sub    $0x4,%eax
  8026be:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8026c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8026ca:	a1 30 50 80 00       	mov    0x805030,%eax
  8026cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d2:	e9 87 00 00 00       	jmp    80275e <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8026d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026db:	75 14                	jne    8026f1 <initialize_dynamic_allocator+0x83>
  8026dd:	83 ec 04             	sub    $0x4,%esp
  8026e0:	68 e7 4a 80 00       	push   $0x804ae7
  8026e5:	6a 79                	push   $0x79
  8026e7:	68 05 4b 80 00       	push   $0x804b05
  8026ec:	e8 4c e0 ff ff       	call   80073d <_panic>
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	8b 00                	mov    (%eax),%eax
  8026f6:	85 c0                	test   %eax,%eax
  8026f8:	74 10                	je     80270a <initialize_dynamic_allocator+0x9c>
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	8b 00                	mov    (%eax),%eax
  8026ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802702:	8b 52 04             	mov    0x4(%edx),%edx
  802705:	89 50 04             	mov    %edx,0x4(%eax)
  802708:	eb 0b                	jmp    802715 <initialize_dynamic_allocator+0xa7>
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 40 04             	mov    0x4(%eax),%eax
  802710:	a3 34 50 80 00       	mov    %eax,0x805034
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	8b 40 04             	mov    0x4(%eax),%eax
  80271b:	85 c0                	test   %eax,%eax
  80271d:	74 0f                	je     80272e <initialize_dynamic_allocator+0xc0>
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 40 04             	mov    0x4(%eax),%eax
  802725:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802728:	8b 12                	mov    (%edx),%edx
  80272a:	89 10                	mov    %edx,(%eax)
  80272c:	eb 0a                	jmp    802738 <initialize_dynamic_allocator+0xca>
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	8b 00                	mov    (%eax),%eax
  802733:	a3 30 50 80 00       	mov    %eax,0x805030
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80274b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802750:	48                   	dec    %eax
  802751:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802756:	a1 38 50 80 00       	mov    0x805038,%eax
  80275b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802762:	74 07                	je     80276b <initialize_dynamic_allocator+0xfd>
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 00                	mov    (%eax),%eax
  802769:	eb 05                	jmp    802770 <initialize_dynamic_allocator+0x102>
  80276b:	b8 00 00 00 00       	mov    $0x0,%eax
  802770:	a3 38 50 80 00       	mov    %eax,0x805038
  802775:	a1 38 50 80 00       	mov    0x805038,%eax
  80277a:	85 c0                	test   %eax,%eax
  80277c:	0f 85 55 ff ff ff    	jne    8026d7 <initialize_dynamic_allocator+0x69>
  802782:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802786:	0f 85 4b ff ff ff    	jne    8026d7 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80278c:	8b 45 08             	mov    0x8(%ebp),%eax
  80278f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802795:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80279b:	a1 48 50 80 00       	mov    0x805048,%eax
  8027a0:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8027a5:	a1 44 50 80 00       	mov    0x805044,%eax
  8027aa:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8027b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b3:	83 c0 08             	add    $0x8,%eax
  8027b6:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bc:	83 c0 04             	add    $0x4,%eax
  8027bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c2:	83 ea 08             	sub    $0x8,%edx
  8027c5:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8027c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cd:	01 d0                	add    %edx,%eax
  8027cf:	83 e8 08             	sub    $0x8,%eax
  8027d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d5:	83 ea 08             	sub    $0x8,%edx
  8027d8:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8027da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8027e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8027ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027f1:	75 17                	jne    80280a <initialize_dynamic_allocator+0x19c>
  8027f3:	83 ec 04             	sub    $0x4,%esp
  8027f6:	68 20 4b 80 00       	push   $0x804b20
  8027fb:	68 90 00 00 00       	push   $0x90
  802800:	68 05 4b 80 00       	push   $0x804b05
  802805:	e8 33 df ff ff       	call   80073d <_panic>
  80280a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802813:	89 10                	mov    %edx,(%eax)
  802815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 0d                	je     80282b <initialize_dynamic_allocator+0x1bd>
  80281e:	a1 30 50 80 00       	mov    0x805030,%eax
  802823:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802826:	89 50 04             	mov    %edx,0x4(%eax)
  802829:	eb 08                	jmp    802833 <initialize_dynamic_allocator+0x1c5>
  80282b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282e:	a3 34 50 80 00       	mov    %eax,0x805034
  802833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802836:	a3 30 50 80 00       	mov    %eax,0x805030
  80283b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802845:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80284a:	40                   	inc    %eax
  80284b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802850:	eb 07                	jmp    802859 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802852:	90                   	nop
  802853:	eb 04                	jmp    802859 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802855:	90                   	nop
  802856:	eb 01                	jmp    802859 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802858:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802859:	c9                   	leave  
  80285a:	c3                   	ret    

0080285b <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80285e:	8b 45 10             	mov    0x10(%ebp),%eax
  802861:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	8d 50 fc             	lea    -0x4(%eax),%edx
  80286a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80286d:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80286f:	8b 45 08             	mov    0x8(%ebp),%eax
  802872:	83 e8 04             	sub    $0x4,%eax
  802875:	8b 00                	mov    (%eax),%eax
  802877:	83 e0 fe             	and    $0xfffffffe,%eax
  80287a:	8d 50 f8             	lea    -0x8(%eax),%edx
  80287d:	8b 45 08             	mov    0x8(%ebp),%eax
  802880:	01 c2                	add    %eax,%edx
  802882:	8b 45 0c             	mov    0xc(%ebp),%eax
  802885:	89 02                	mov    %eax,(%edx)
}
  802887:	90                   	nop
  802888:	5d                   	pop    %ebp
  802889:	c3                   	ret    

0080288a <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80288a:	55                   	push   %ebp
  80288b:	89 e5                	mov    %esp,%ebp
  80288d:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	83 e0 01             	and    $0x1,%eax
  802896:	85 c0                	test   %eax,%eax
  802898:	74 03                	je     80289d <alloc_block_FF+0x13>
  80289a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80289d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028a1:	77 07                	ja     8028aa <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028a3:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028aa:	a1 28 50 80 00       	mov    0x805028,%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	75 73                	jne    802926 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	83 c0 10             	add    $0x10,%eax
  8028b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8028bc:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8028c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c9:	01 d0                	add    %edx,%eax
  8028cb:	48                   	dec    %eax
  8028cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8028cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8028d7:	f7 75 ec             	divl   -0x14(%ebp)
  8028da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028dd:	29 d0                	sub    %edx,%eax
  8028df:	c1 e8 0c             	shr    $0xc,%eax
  8028e2:	83 ec 0c             	sub    $0xc,%esp
  8028e5:	50                   	push   %eax
  8028e6:	e8 b1 f0 ff ff       	call   80199c <sbrk>
  8028eb:	83 c4 10             	add    $0x10,%esp
  8028ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8028f1:	83 ec 0c             	sub    $0xc,%esp
  8028f4:	6a 00                	push   $0x0
  8028f6:	e8 a1 f0 ff ff       	call   80199c <sbrk>
  8028fb:	83 c4 10             	add    $0x10,%esp
  8028fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802901:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802904:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802907:	83 ec 08             	sub    $0x8,%esp
  80290a:	50                   	push   %eax
  80290b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80290e:	e8 5b fd ff ff       	call   80266e <initialize_dynamic_allocator>
  802913:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802916:	83 ec 0c             	sub    $0xc,%esp
  802919:	68 43 4b 80 00       	push   $0x804b43
  80291e:	e8 d7 e0 ff ff       	call   8009fa <cprintf>
  802923:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802926:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80292a:	75 0a                	jne    802936 <alloc_block_FF+0xac>
	        return NULL;
  80292c:	b8 00 00 00 00       	mov    $0x0,%eax
  802931:	e9 0e 04 00 00       	jmp    802d44 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802936:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80293d:	a1 30 50 80 00       	mov    0x805030,%eax
  802942:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802945:	e9 f3 02 00 00       	jmp    802c3d <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802950:	83 ec 0c             	sub    $0xc,%esp
  802953:	ff 75 bc             	pushl  -0x44(%ebp)
  802956:	e8 af fb ff ff       	call   80250a <get_block_size>
  80295b:	83 c4 10             	add    $0x10,%esp
  80295e:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	83 c0 08             	add    $0x8,%eax
  802967:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80296a:	0f 87 c5 02 00 00    	ja     802c35 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	83 c0 18             	add    $0x18,%eax
  802976:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802979:	0f 87 19 02 00 00    	ja     802b98 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80297f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802982:	2b 45 08             	sub    0x8(%ebp),%eax
  802985:	83 e8 08             	sub    $0x8,%eax
  802988:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	8d 50 08             	lea    0x8(%eax),%edx
  802991:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802994:	01 d0                	add    %edx,%eax
  802996:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	83 c0 08             	add    $0x8,%eax
  80299f:	83 ec 04             	sub    $0x4,%esp
  8029a2:	6a 01                	push   $0x1
  8029a4:	50                   	push   %eax
  8029a5:	ff 75 bc             	pushl  -0x44(%ebp)
  8029a8:	e8 ae fe ff ff       	call   80285b <set_block_data>
  8029ad:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	8b 40 04             	mov    0x4(%eax),%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	75 68                	jne    802a22 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029ba:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029be:	75 17                	jne    8029d7 <alloc_block_FF+0x14d>
  8029c0:	83 ec 04             	sub    $0x4,%esp
  8029c3:	68 20 4b 80 00       	push   $0x804b20
  8029c8:	68 d7 00 00 00       	push   $0xd7
  8029cd:	68 05 4b 80 00       	push   $0x804b05
  8029d2:	e8 66 dd ff ff       	call   80073d <_panic>
  8029d7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029e0:	89 10                	mov    %edx,(%eax)
  8029e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029e5:	8b 00                	mov    (%eax),%eax
  8029e7:	85 c0                	test   %eax,%eax
  8029e9:	74 0d                	je     8029f8 <alloc_block_FF+0x16e>
  8029eb:	a1 30 50 80 00       	mov    0x805030,%eax
  8029f0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029f3:	89 50 04             	mov    %edx,0x4(%eax)
  8029f6:	eb 08                	jmp    802a00 <alloc_block_FF+0x176>
  8029f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029fb:	a3 34 50 80 00       	mov    %eax,0x805034
  802a00:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a03:	a3 30 50 80 00       	mov    %eax,0x805030
  802a08:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a12:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a17:	40                   	inc    %eax
  802a18:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a1d:	e9 dc 00 00 00       	jmp    802afe <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 00                	mov    (%eax),%eax
  802a27:	85 c0                	test   %eax,%eax
  802a29:	75 65                	jne    802a90 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a2b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a2f:	75 17                	jne    802a48 <alloc_block_FF+0x1be>
  802a31:	83 ec 04             	sub    $0x4,%esp
  802a34:	68 54 4b 80 00       	push   $0x804b54
  802a39:	68 db 00 00 00       	push   $0xdb
  802a3e:	68 05 4b 80 00       	push   $0x804b05
  802a43:	e8 f5 dc ff ff       	call   80073d <_panic>
  802a48:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802a4e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a51:	89 50 04             	mov    %edx,0x4(%eax)
  802a54:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a57:	8b 40 04             	mov    0x4(%eax),%eax
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	74 0c                	je     802a6a <alloc_block_FF+0x1e0>
  802a5e:	a1 34 50 80 00       	mov    0x805034,%eax
  802a63:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a66:	89 10                	mov    %edx,(%eax)
  802a68:	eb 08                	jmp    802a72 <alloc_block_FF+0x1e8>
  802a6a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a6d:	a3 30 50 80 00       	mov    %eax,0x805030
  802a72:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a75:	a3 34 50 80 00       	mov    %eax,0x805034
  802a7a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a83:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a88:	40                   	inc    %eax
  802a89:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a8e:	eb 6e                	jmp    802afe <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802a90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a94:	74 06                	je     802a9c <alloc_block_FF+0x212>
  802a96:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a9a:	75 17                	jne    802ab3 <alloc_block_FF+0x229>
  802a9c:	83 ec 04             	sub    $0x4,%esp
  802a9f:	68 78 4b 80 00       	push   $0x804b78
  802aa4:	68 df 00 00 00       	push   $0xdf
  802aa9:	68 05 4b 80 00       	push   $0x804b05
  802aae:	e8 8a dc ff ff       	call   80073d <_panic>
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 10                	mov    (%eax),%edx
  802ab8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802abb:	89 10                	mov    %edx,(%eax)
  802abd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	74 0b                	je     802ad1 <alloc_block_FF+0x247>
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 00                	mov    (%eax),%eax
  802acb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ace:	89 50 04             	mov    %edx,0x4(%eax)
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ad7:	89 10                	mov    %edx,(%eax)
  802ad9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802adc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802adf:	89 50 04             	mov    %edx,0x4(%eax)
  802ae2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae5:	8b 00                	mov    (%eax),%eax
  802ae7:	85 c0                	test   %eax,%eax
  802ae9:	75 08                	jne    802af3 <alloc_block_FF+0x269>
  802aeb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aee:	a3 34 50 80 00       	mov    %eax,0x805034
  802af3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802af8:	40                   	inc    %eax
  802af9:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802afe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b02:	75 17                	jne    802b1b <alloc_block_FF+0x291>
  802b04:	83 ec 04             	sub    $0x4,%esp
  802b07:	68 e7 4a 80 00       	push   $0x804ae7
  802b0c:	68 e1 00 00 00       	push   $0xe1
  802b11:	68 05 4b 80 00       	push   $0x804b05
  802b16:	e8 22 dc ff ff       	call   80073d <_panic>
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	8b 00                	mov    (%eax),%eax
  802b20:	85 c0                	test   %eax,%eax
  802b22:	74 10                	je     802b34 <alloc_block_FF+0x2aa>
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	8b 00                	mov    (%eax),%eax
  802b29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2c:	8b 52 04             	mov    0x4(%edx),%edx
  802b2f:	89 50 04             	mov    %edx,0x4(%eax)
  802b32:	eb 0b                	jmp    802b3f <alloc_block_FF+0x2b5>
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	8b 40 04             	mov    0x4(%eax),%eax
  802b3a:	a3 34 50 80 00       	mov    %eax,0x805034
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	8b 40 04             	mov    0x4(%eax),%eax
  802b45:	85 c0                	test   %eax,%eax
  802b47:	74 0f                	je     802b58 <alloc_block_FF+0x2ce>
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 40 04             	mov    0x4(%eax),%eax
  802b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b52:	8b 12                	mov    (%edx),%edx
  802b54:	89 10                	mov    %edx,(%eax)
  802b56:	eb 0a                	jmp    802b62 <alloc_block_FF+0x2d8>
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 00                	mov    (%eax),%eax
  802b5d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b75:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b7a:	48                   	dec    %eax
  802b7b:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802b80:	83 ec 04             	sub    $0x4,%esp
  802b83:	6a 00                	push   $0x0
  802b85:	ff 75 b4             	pushl  -0x4c(%ebp)
  802b88:	ff 75 b0             	pushl  -0x50(%ebp)
  802b8b:	e8 cb fc ff ff       	call   80285b <set_block_data>
  802b90:	83 c4 10             	add    $0x10,%esp
  802b93:	e9 95 00 00 00       	jmp    802c2d <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802b98:	83 ec 04             	sub    $0x4,%esp
  802b9b:	6a 01                	push   $0x1
  802b9d:	ff 75 b8             	pushl  -0x48(%ebp)
  802ba0:	ff 75 bc             	pushl  -0x44(%ebp)
  802ba3:	e8 b3 fc ff ff       	call   80285b <set_block_data>
  802ba8:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802bab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802baf:	75 17                	jne    802bc8 <alloc_block_FF+0x33e>
  802bb1:	83 ec 04             	sub    $0x4,%esp
  802bb4:	68 e7 4a 80 00       	push   $0x804ae7
  802bb9:	68 e8 00 00 00       	push   $0xe8
  802bbe:	68 05 4b 80 00       	push   $0x804b05
  802bc3:	e8 75 db ff ff       	call   80073d <_panic>
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	8b 00                	mov    (%eax),%eax
  802bcd:	85 c0                	test   %eax,%eax
  802bcf:	74 10                	je     802be1 <alloc_block_FF+0x357>
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 00                	mov    (%eax),%eax
  802bd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd9:	8b 52 04             	mov    0x4(%edx),%edx
  802bdc:	89 50 04             	mov    %edx,0x4(%eax)
  802bdf:	eb 0b                	jmp    802bec <alloc_block_FF+0x362>
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	8b 40 04             	mov    0x4(%eax),%eax
  802be7:	a3 34 50 80 00       	mov    %eax,0x805034
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 40 04             	mov    0x4(%eax),%eax
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	74 0f                	je     802c05 <alloc_block_FF+0x37b>
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 40 04             	mov    0x4(%eax),%eax
  802bfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bff:	8b 12                	mov    (%edx),%edx
  802c01:	89 10                	mov    %edx,(%eax)
  802c03:	eb 0a                	jmp    802c0f <alloc_block_FF+0x385>
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 00                	mov    (%eax),%eax
  802c0a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c22:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c27:	48                   	dec    %eax
  802c28:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802c2d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c30:	e9 0f 01 00 00       	jmp    802d44 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c35:	a1 38 50 80 00       	mov    0x805038,%eax
  802c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c41:	74 07                	je     802c4a <alloc_block_FF+0x3c0>
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 00                	mov    (%eax),%eax
  802c48:	eb 05                	jmp    802c4f <alloc_block_FF+0x3c5>
  802c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4f:	a3 38 50 80 00       	mov    %eax,0x805038
  802c54:	a1 38 50 80 00       	mov    0x805038,%eax
  802c59:	85 c0                	test   %eax,%eax
  802c5b:	0f 85 e9 fc ff ff    	jne    80294a <alloc_block_FF+0xc0>
  802c61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c65:	0f 85 df fc ff ff    	jne    80294a <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	83 c0 08             	add    $0x8,%eax
  802c71:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c74:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802c7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c81:	01 d0                	add    %edx,%eax
  802c83:	48                   	dec    %eax
  802c84:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802c87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  802c8f:	f7 75 d8             	divl   -0x28(%ebp)
  802c92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c95:	29 d0                	sub    %edx,%eax
  802c97:	c1 e8 0c             	shr    $0xc,%eax
  802c9a:	83 ec 0c             	sub    $0xc,%esp
  802c9d:	50                   	push   %eax
  802c9e:	e8 f9 ec ff ff       	call   80199c <sbrk>
  802ca3:	83 c4 10             	add    $0x10,%esp
  802ca6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802ca9:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802cad:	75 0a                	jne    802cb9 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802caf:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb4:	e9 8b 00 00 00       	jmp    802d44 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cb9:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802cc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cc3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cc6:	01 d0                	add    %edx,%eax
  802cc8:	48                   	dec    %eax
  802cc9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802ccc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  802cd4:	f7 75 cc             	divl   -0x34(%ebp)
  802cd7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802cda:	29 d0                	sub    %edx,%eax
  802cdc:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cdf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ce2:	01 d0                	add    %edx,%eax
  802ce4:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802ce9:	a1 44 50 80 00       	mov    0x805044,%eax
  802cee:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802cf4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802cfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cfe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d01:	01 d0                	add    %edx,%eax
  802d03:	48                   	dec    %eax
  802d04:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d07:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d0a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d0f:	f7 75 c4             	divl   -0x3c(%ebp)
  802d12:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d15:	29 d0                	sub    %edx,%eax
  802d17:	83 ec 04             	sub    $0x4,%esp
  802d1a:	6a 01                	push   $0x1
  802d1c:	50                   	push   %eax
  802d1d:	ff 75 d0             	pushl  -0x30(%ebp)
  802d20:	e8 36 fb ff ff       	call   80285b <set_block_data>
  802d25:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802d28:	83 ec 0c             	sub    $0xc,%esp
  802d2b:	ff 75 d0             	pushl  -0x30(%ebp)
  802d2e:	e8 1b 0a 00 00       	call   80374e <free_block>
  802d33:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802d36:	83 ec 0c             	sub    $0xc,%esp
  802d39:	ff 75 08             	pushl  0x8(%ebp)
  802d3c:	e8 49 fb ff ff       	call   80288a <alloc_block_FF>
  802d41:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802d44:	c9                   	leave  
  802d45:	c3                   	ret    

00802d46 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802d46:	55                   	push   %ebp
  802d47:	89 e5                	mov    %esp,%ebp
  802d49:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	83 e0 01             	and    $0x1,%eax
  802d52:	85 c0                	test   %eax,%eax
  802d54:	74 03                	je     802d59 <alloc_block_BF+0x13>
  802d56:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802d59:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802d5d:	77 07                	ja     802d66 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802d5f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802d66:	a1 28 50 80 00       	mov    0x805028,%eax
  802d6b:	85 c0                	test   %eax,%eax
  802d6d:	75 73                	jne    802de2 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d72:	83 c0 10             	add    $0x10,%eax
  802d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802d78:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802d7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d85:	01 d0                	add    %edx,%eax
  802d87:	48                   	dec    %eax
  802d88:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d8e:	ba 00 00 00 00       	mov    $0x0,%edx
  802d93:	f7 75 e0             	divl   -0x20(%ebp)
  802d96:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d99:	29 d0                	sub    %edx,%eax
  802d9b:	c1 e8 0c             	shr    $0xc,%eax
  802d9e:	83 ec 0c             	sub    $0xc,%esp
  802da1:	50                   	push   %eax
  802da2:	e8 f5 eb ff ff       	call   80199c <sbrk>
  802da7:	83 c4 10             	add    $0x10,%esp
  802daa:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802dad:	83 ec 0c             	sub    $0xc,%esp
  802db0:	6a 00                	push   $0x0
  802db2:	e8 e5 eb ff ff       	call   80199c <sbrk>
  802db7:	83 c4 10             	add    $0x10,%esp
  802dba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802dbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dc0:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802dc3:	83 ec 08             	sub    $0x8,%esp
  802dc6:	50                   	push   %eax
  802dc7:	ff 75 d8             	pushl  -0x28(%ebp)
  802dca:	e8 9f f8 ff ff       	call   80266e <initialize_dynamic_allocator>
  802dcf:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802dd2:	83 ec 0c             	sub    $0xc,%esp
  802dd5:	68 43 4b 80 00       	push   $0x804b43
  802dda:	e8 1b dc ff ff       	call   8009fa <cprintf>
  802ddf:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802de2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802de9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802df0:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802df7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802dfe:	a1 30 50 80 00       	mov    0x805030,%eax
  802e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e06:	e9 1d 01 00 00       	jmp    802f28 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0e:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802e11:	83 ec 0c             	sub    $0xc,%esp
  802e14:	ff 75 a8             	pushl  -0x58(%ebp)
  802e17:	e8 ee f6 ff ff       	call   80250a <get_block_size>
  802e1c:	83 c4 10             	add    $0x10,%esp
  802e1f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802e22:	8b 45 08             	mov    0x8(%ebp),%eax
  802e25:	83 c0 08             	add    $0x8,%eax
  802e28:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e2b:	0f 87 ef 00 00 00    	ja     802f20 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	83 c0 18             	add    $0x18,%eax
  802e37:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e3a:	77 1d                	ja     802e59 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e42:	0f 86 d8 00 00 00    	jbe    802f20 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802e48:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802e4e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802e51:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e54:	e9 c7 00 00 00       	jmp    802f20 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802e59:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5c:	83 c0 08             	add    $0x8,%eax
  802e5f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e62:	0f 85 9d 00 00 00    	jne    802f05 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802e68:	83 ec 04             	sub    $0x4,%esp
  802e6b:	6a 01                	push   $0x1
  802e6d:	ff 75 a4             	pushl  -0x5c(%ebp)
  802e70:	ff 75 a8             	pushl  -0x58(%ebp)
  802e73:	e8 e3 f9 ff ff       	call   80285b <set_block_data>
  802e78:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802e7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7f:	75 17                	jne    802e98 <alloc_block_BF+0x152>
  802e81:	83 ec 04             	sub    $0x4,%esp
  802e84:	68 e7 4a 80 00       	push   $0x804ae7
  802e89:	68 2c 01 00 00       	push   $0x12c
  802e8e:	68 05 4b 80 00       	push   $0x804b05
  802e93:	e8 a5 d8 ff ff       	call   80073d <_panic>
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	85 c0                	test   %eax,%eax
  802e9f:	74 10                	je     802eb1 <alloc_block_BF+0x16b>
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	8b 00                	mov    (%eax),%eax
  802ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea9:	8b 52 04             	mov    0x4(%edx),%edx
  802eac:	89 50 04             	mov    %edx,0x4(%eax)
  802eaf:	eb 0b                	jmp    802ebc <alloc_block_BF+0x176>
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	8b 40 04             	mov    0x4(%eax),%eax
  802eb7:	a3 34 50 80 00       	mov    %eax,0x805034
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 40 04             	mov    0x4(%eax),%eax
  802ec2:	85 c0                	test   %eax,%eax
  802ec4:	74 0f                	je     802ed5 <alloc_block_BF+0x18f>
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 40 04             	mov    0x4(%eax),%eax
  802ecc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ecf:	8b 12                	mov    (%edx),%edx
  802ed1:	89 10                	mov    %edx,(%eax)
  802ed3:	eb 0a                	jmp    802edf <alloc_block_BF+0x199>
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 00                	mov    (%eax),%eax
  802eda:	a3 30 50 80 00       	mov    %eax,0x805030
  802edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ef7:	48                   	dec    %eax
  802ef8:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802efd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f00:	e9 24 04 00 00       	jmp    803329 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f08:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f0b:	76 13                	jbe    802f20 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802f0d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802f14:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f17:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802f1a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f1d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802f20:	a1 38 50 80 00       	mov    0x805038,%eax
  802f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2c:	74 07                	je     802f35 <alloc_block_BF+0x1ef>
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	8b 00                	mov    (%eax),%eax
  802f33:	eb 05                	jmp    802f3a <alloc_block_BF+0x1f4>
  802f35:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3a:	a3 38 50 80 00       	mov    %eax,0x805038
  802f3f:	a1 38 50 80 00       	mov    0x805038,%eax
  802f44:	85 c0                	test   %eax,%eax
  802f46:	0f 85 bf fe ff ff    	jne    802e0b <alloc_block_BF+0xc5>
  802f4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f50:	0f 85 b5 fe ff ff    	jne    802e0b <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802f56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f5a:	0f 84 26 02 00 00    	je     803186 <alloc_block_BF+0x440>
  802f60:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f64:	0f 85 1c 02 00 00    	jne    803186 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802f6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6d:	2b 45 08             	sub    0x8(%ebp),%eax
  802f70:	83 e8 08             	sub    $0x8,%eax
  802f73:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	8d 50 08             	lea    0x8(%eax),%edx
  802f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7f:	01 d0                	add    %edx,%eax
  802f81:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802f84:	8b 45 08             	mov    0x8(%ebp),%eax
  802f87:	83 c0 08             	add    $0x8,%eax
  802f8a:	83 ec 04             	sub    $0x4,%esp
  802f8d:	6a 01                	push   $0x1
  802f8f:	50                   	push   %eax
  802f90:	ff 75 f0             	pushl  -0x10(%ebp)
  802f93:	e8 c3 f8 ff ff       	call   80285b <set_block_data>
  802f98:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9e:	8b 40 04             	mov    0x4(%eax),%eax
  802fa1:	85 c0                	test   %eax,%eax
  802fa3:	75 68                	jne    80300d <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802fa5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fa9:	75 17                	jne    802fc2 <alloc_block_BF+0x27c>
  802fab:	83 ec 04             	sub    $0x4,%esp
  802fae:	68 20 4b 80 00       	push   $0x804b20
  802fb3:	68 45 01 00 00       	push   $0x145
  802fb8:	68 05 4b 80 00       	push   $0x804b05
  802fbd:	e8 7b d7 ff ff       	call   80073d <_panic>
  802fc2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fc8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fcb:	89 10                	mov    %edx,(%eax)
  802fcd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fd0:	8b 00                	mov    (%eax),%eax
  802fd2:	85 c0                	test   %eax,%eax
  802fd4:	74 0d                	je     802fe3 <alloc_block_BF+0x29d>
  802fd6:	a1 30 50 80 00       	mov    0x805030,%eax
  802fdb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fde:	89 50 04             	mov    %edx,0x4(%eax)
  802fe1:	eb 08                	jmp    802feb <alloc_block_BF+0x2a5>
  802fe3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fe6:	a3 34 50 80 00       	mov    %eax,0x805034
  802feb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fee:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ff6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803002:	40                   	inc    %eax
  803003:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803008:	e9 dc 00 00 00       	jmp    8030e9 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80300d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803010:	8b 00                	mov    (%eax),%eax
  803012:	85 c0                	test   %eax,%eax
  803014:	75 65                	jne    80307b <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803016:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80301a:	75 17                	jne    803033 <alloc_block_BF+0x2ed>
  80301c:	83 ec 04             	sub    $0x4,%esp
  80301f:	68 54 4b 80 00       	push   $0x804b54
  803024:	68 4a 01 00 00       	push   $0x14a
  803029:	68 05 4b 80 00       	push   $0x804b05
  80302e:	e8 0a d7 ff ff       	call   80073d <_panic>
  803033:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803039:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80303c:	89 50 04             	mov    %edx,0x4(%eax)
  80303f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	74 0c                	je     803055 <alloc_block_BF+0x30f>
  803049:	a1 34 50 80 00       	mov    0x805034,%eax
  80304e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803051:	89 10                	mov    %edx,(%eax)
  803053:	eb 08                	jmp    80305d <alloc_block_BF+0x317>
  803055:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803058:	a3 30 50 80 00       	mov    %eax,0x805030
  80305d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803060:	a3 34 50 80 00       	mov    %eax,0x805034
  803065:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803068:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803073:	40                   	inc    %eax
  803074:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803079:	eb 6e                	jmp    8030e9 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80307b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80307f:	74 06                	je     803087 <alloc_block_BF+0x341>
  803081:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803085:	75 17                	jne    80309e <alloc_block_BF+0x358>
  803087:	83 ec 04             	sub    $0x4,%esp
  80308a:	68 78 4b 80 00       	push   $0x804b78
  80308f:	68 4f 01 00 00       	push   $0x14f
  803094:	68 05 4b 80 00       	push   $0x804b05
  803099:	e8 9f d6 ff ff       	call   80073d <_panic>
  80309e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a1:	8b 10                	mov    (%eax),%edx
  8030a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a6:	89 10                	mov    %edx,(%eax)
  8030a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030ab:	8b 00                	mov    (%eax),%eax
  8030ad:	85 c0                	test   %eax,%eax
  8030af:	74 0b                	je     8030bc <alloc_block_BF+0x376>
  8030b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b4:	8b 00                	mov    (%eax),%eax
  8030b6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030b9:	89 50 04             	mov    %edx,0x4(%eax)
  8030bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bf:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030c2:	89 10                	mov    %edx,(%eax)
  8030c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030ca:	89 50 04             	mov    %edx,0x4(%eax)
  8030cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030d0:	8b 00                	mov    (%eax),%eax
  8030d2:	85 c0                	test   %eax,%eax
  8030d4:	75 08                	jne    8030de <alloc_block_BF+0x398>
  8030d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030d9:	a3 34 50 80 00       	mov    %eax,0x805034
  8030de:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030e3:	40                   	inc    %eax
  8030e4:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8030e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ed:	75 17                	jne    803106 <alloc_block_BF+0x3c0>
  8030ef:	83 ec 04             	sub    $0x4,%esp
  8030f2:	68 e7 4a 80 00       	push   $0x804ae7
  8030f7:	68 51 01 00 00       	push   $0x151
  8030fc:	68 05 4b 80 00       	push   $0x804b05
  803101:	e8 37 d6 ff ff       	call   80073d <_panic>
  803106:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803109:	8b 00                	mov    (%eax),%eax
  80310b:	85 c0                	test   %eax,%eax
  80310d:	74 10                	je     80311f <alloc_block_BF+0x3d9>
  80310f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803112:	8b 00                	mov    (%eax),%eax
  803114:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803117:	8b 52 04             	mov    0x4(%edx),%edx
  80311a:	89 50 04             	mov    %edx,0x4(%eax)
  80311d:	eb 0b                	jmp    80312a <alloc_block_BF+0x3e4>
  80311f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803122:	8b 40 04             	mov    0x4(%eax),%eax
  803125:	a3 34 50 80 00       	mov    %eax,0x805034
  80312a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312d:	8b 40 04             	mov    0x4(%eax),%eax
  803130:	85 c0                	test   %eax,%eax
  803132:	74 0f                	je     803143 <alloc_block_BF+0x3fd>
  803134:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803137:	8b 40 04             	mov    0x4(%eax),%eax
  80313a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80313d:	8b 12                	mov    (%edx),%edx
  80313f:	89 10                	mov    %edx,(%eax)
  803141:	eb 0a                	jmp    80314d <alloc_block_BF+0x407>
  803143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803146:	8b 00                	mov    (%eax),%eax
  803148:	a3 30 50 80 00       	mov    %eax,0x805030
  80314d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803150:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803156:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803159:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803160:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803165:	48                   	dec    %eax
  803166:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  80316b:	83 ec 04             	sub    $0x4,%esp
  80316e:	6a 00                	push   $0x0
  803170:	ff 75 d0             	pushl  -0x30(%ebp)
  803173:	ff 75 cc             	pushl  -0x34(%ebp)
  803176:	e8 e0 f6 ff ff       	call   80285b <set_block_data>
  80317b:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80317e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803181:	e9 a3 01 00 00       	jmp    803329 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803186:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80318a:	0f 85 9d 00 00 00    	jne    80322d <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803190:	83 ec 04             	sub    $0x4,%esp
  803193:	6a 01                	push   $0x1
  803195:	ff 75 ec             	pushl  -0x14(%ebp)
  803198:	ff 75 f0             	pushl  -0x10(%ebp)
  80319b:	e8 bb f6 ff ff       	call   80285b <set_block_data>
  8031a0:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8031a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031a7:	75 17                	jne    8031c0 <alloc_block_BF+0x47a>
  8031a9:	83 ec 04             	sub    $0x4,%esp
  8031ac:	68 e7 4a 80 00       	push   $0x804ae7
  8031b1:	68 58 01 00 00       	push   $0x158
  8031b6:	68 05 4b 80 00       	push   $0x804b05
  8031bb:	e8 7d d5 ff ff       	call   80073d <_panic>
  8031c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c3:	8b 00                	mov    (%eax),%eax
  8031c5:	85 c0                	test   %eax,%eax
  8031c7:	74 10                	je     8031d9 <alloc_block_BF+0x493>
  8031c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cc:	8b 00                	mov    (%eax),%eax
  8031ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d1:	8b 52 04             	mov    0x4(%edx),%edx
  8031d4:	89 50 04             	mov    %edx,0x4(%eax)
  8031d7:	eb 0b                	jmp    8031e4 <alloc_block_BF+0x49e>
  8031d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031dc:	8b 40 04             	mov    0x4(%eax),%eax
  8031df:	a3 34 50 80 00       	mov    %eax,0x805034
  8031e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ea:	85 c0                	test   %eax,%eax
  8031ec:	74 0f                	je     8031fd <alloc_block_BF+0x4b7>
  8031ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f1:	8b 40 04             	mov    0x4(%eax),%eax
  8031f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031f7:	8b 12                	mov    (%edx),%edx
  8031f9:	89 10                	mov    %edx,(%eax)
  8031fb:	eb 0a                	jmp    803207 <alloc_block_BF+0x4c1>
  8031fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803200:	8b 00                	mov    (%eax),%eax
  803202:	a3 30 50 80 00       	mov    %eax,0x805030
  803207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803213:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80321f:	48                   	dec    %eax
  803220:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  803225:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803228:	e9 fc 00 00 00       	jmp    803329 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	83 c0 08             	add    $0x8,%eax
  803233:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803236:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80323d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803240:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803243:	01 d0                	add    %edx,%eax
  803245:	48                   	dec    %eax
  803246:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803249:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80324c:	ba 00 00 00 00       	mov    $0x0,%edx
  803251:	f7 75 c4             	divl   -0x3c(%ebp)
  803254:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803257:	29 d0                	sub    %edx,%eax
  803259:	c1 e8 0c             	shr    $0xc,%eax
  80325c:	83 ec 0c             	sub    $0xc,%esp
  80325f:	50                   	push   %eax
  803260:	e8 37 e7 ff ff       	call   80199c <sbrk>
  803265:	83 c4 10             	add    $0x10,%esp
  803268:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80326b:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80326f:	75 0a                	jne    80327b <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803271:	b8 00 00 00 00       	mov    $0x0,%eax
  803276:	e9 ae 00 00 00       	jmp    803329 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80327b:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803282:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803285:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803288:	01 d0                	add    %edx,%eax
  80328a:	48                   	dec    %eax
  80328b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80328e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803291:	ba 00 00 00 00       	mov    $0x0,%edx
  803296:	f7 75 b8             	divl   -0x48(%ebp)
  803299:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80329c:	29 d0                	sub    %edx,%eax
  80329e:	8d 50 fc             	lea    -0x4(%eax),%edx
  8032a1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8032a4:	01 d0                	add    %edx,%eax
  8032a6:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  8032ab:	a1 44 50 80 00       	mov    0x805044,%eax
  8032b0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8032b6:	83 ec 0c             	sub    $0xc,%esp
  8032b9:	68 ac 4b 80 00       	push   $0x804bac
  8032be:	e8 37 d7 ff ff       	call   8009fa <cprintf>
  8032c3:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8032c6:	83 ec 08             	sub    $0x8,%esp
  8032c9:	ff 75 bc             	pushl  -0x44(%ebp)
  8032cc:	68 b1 4b 80 00       	push   $0x804bb1
  8032d1:	e8 24 d7 ff ff       	call   8009fa <cprintf>
  8032d6:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8032d9:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8032e0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8032e6:	01 d0                	add    %edx,%eax
  8032e8:	48                   	dec    %eax
  8032e9:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8032ec:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8032ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8032f4:	f7 75 b0             	divl   -0x50(%ebp)
  8032f7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8032fa:	29 d0                	sub    %edx,%eax
  8032fc:	83 ec 04             	sub    $0x4,%esp
  8032ff:	6a 01                	push   $0x1
  803301:	50                   	push   %eax
  803302:	ff 75 bc             	pushl  -0x44(%ebp)
  803305:	e8 51 f5 ff ff       	call   80285b <set_block_data>
  80330a:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80330d:	83 ec 0c             	sub    $0xc,%esp
  803310:	ff 75 bc             	pushl  -0x44(%ebp)
  803313:	e8 36 04 00 00       	call   80374e <free_block>
  803318:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80331b:	83 ec 0c             	sub    $0xc,%esp
  80331e:	ff 75 08             	pushl  0x8(%ebp)
  803321:	e8 20 fa ff ff       	call   802d46 <alloc_block_BF>
  803326:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803329:	c9                   	leave  
  80332a:	c3                   	ret    

0080332b <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80332b:	55                   	push   %ebp
  80332c:	89 e5                	mov    %esp,%ebp
  80332e:	53                   	push   %ebx
  80332f:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803332:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803339:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803344:	74 1e                	je     803364 <merging+0x39>
  803346:	ff 75 08             	pushl  0x8(%ebp)
  803349:	e8 bc f1 ff ff       	call   80250a <get_block_size>
  80334e:	83 c4 04             	add    $0x4,%esp
  803351:	89 c2                	mov    %eax,%edx
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	01 d0                	add    %edx,%eax
  803358:	3b 45 10             	cmp    0x10(%ebp),%eax
  80335b:	75 07                	jne    803364 <merging+0x39>
		prev_is_free = 1;
  80335d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803364:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803368:	74 1e                	je     803388 <merging+0x5d>
  80336a:	ff 75 10             	pushl  0x10(%ebp)
  80336d:	e8 98 f1 ff ff       	call   80250a <get_block_size>
  803372:	83 c4 04             	add    $0x4,%esp
  803375:	89 c2                	mov    %eax,%edx
  803377:	8b 45 10             	mov    0x10(%ebp),%eax
  80337a:	01 d0                	add    %edx,%eax
  80337c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80337f:	75 07                	jne    803388 <merging+0x5d>
		next_is_free = 1;
  803381:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338c:	0f 84 cc 00 00 00    	je     80345e <merging+0x133>
  803392:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803396:	0f 84 c2 00 00 00    	je     80345e <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80339c:	ff 75 08             	pushl  0x8(%ebp)
  80339f:	e8 66 f1 ff ff       	call   80250a <get_block_size>
  8033a4:	83 c4 04             	add    $0x4,%esp
  8033a7:	89 c3                	mov    %eax,%ebx
  8033a9:	ff 75 10             	pushl  0x10(%ebp)
  8033ac:	e8 59 f1 ff ff       	call   80250a <get_block_size>
  8033b1:	83 c4 04             	add    $0x4,%esp
  8033b4:	01 c3                	add    %eax,%ebx
  8033b6:	ff 75 0c             	pushl  0xc(%ebp)
  8033b9:	e8 4c f1 ff ff       	call   80250a <get_block_size>
  8033be:	83 c4 04             	add    $0x4,%esp
  8033c1:	01 d8                	add    %ebx,%eax
  8033c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8033c6:	6a 00                	push   $0x0
  8033c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8033cb:	ff 75 08             	pushl  0x8(%ebp)
  8033ce:	e8 88 f4 ff ff       	call   80285b <set_block_data>
  8033d3:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8033d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033da:	75 17                	jne    8033f3 <merging+0xc8>
  8033dc:	83 ec 04             	sub    $0x4,%esp
  8033df:	68 e7 4a 80 00       	push   $0x804ae7
  8033e4:	68 7d 01 00 00       	push   $0x17d
  8033e9:	68 05 4b 80 00       	push   $0x804b05
  8033ee:	e8 4a d3 ff ff       	call   80073d <_panic>
  8033f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f6:	8b 00                	mov    (%eax),%eax
  8033f8:	85 c0                	test   %eax,%eax
  8033fa:	74 10                	je     80340c <merging+0xe1>
  8033fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ff:	8b 00                	mov    (%eax),%eax
  803401:	8b 55 0c             	mov    0xc(%ebp),%edx
  803404:	8b 52 04             	mov    0x4(%edx),%edx
  803407:	89 50 04             	mov    %edx,0x4(%eax)
  80340a:	eb 0b                	jmp    803417 <merging+0xec>
  80340c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80340f:	8b 40 04             	mov    0x4(%eax),%eax
  803412:	a3 34 50 80 00       	mov    %eax,0x805034
  803417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80341a:	8b 40 04             	mov    0x4(%eax),%eax
  80341d:	85 c0                	test   %eax,%eax
  80341f:	74 0f                	je     803430 <merging+0x105>
  803421:	8b 45 0c             	mov    0xc(%ebp),%eax
  803424:	8b 40 04             	mov    0x4(%eax),%eax
  803427:	8b 55 0c             	mov    0xc(%ebp),%edx
  80342a:	8b 12                	mov    (%edx),%edx
  80342c:	89 10                	mov    %edx,(%eax)
  80342e:	eb 0a                	jmp    80343a <merging+0x10f>
  803430:	8b 45 0c             	mov    0xc(%ebp),%eax
  803433:	8b 00                	mov    (%eax),%eax
  803435:	a3 30 50 80 00       	mov    %eax,0x805030
  80343a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80343d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803443:	8b 45 0c             	mov    0xc(%ebp),%eax
  803446:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803452:	48                   	dec    %eax
  803453:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803458:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803459:	e9 ea 02 00 00       	jmp    803748 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80345e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803462:	74 3b                	je     80349f <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803464:	83 ec 0c             	sub    $0xc,%esp
  803467:	ff 75 08             	pushl  0x8(%ebp)
  80346a:	e8 9b f0 ff ff       	call   80250a <get_block_size>
  80346f:	83 c4 10             	add    $0x10,%esp
  803472:	89 c3                	mov    %eax,%ebx
  803474:	83 ec 0c             	sub    $0xc,%esp
  803477:	ff 75 10             	pushl  0x10(%ebp)
  80347a:	e8 8b f0 ff ff       	call   80250a <get_block_size>
  80347f:	83 c4 10             	add    $0x10,%esp
  803482:	01 d8                	add    %ebx,%eax
  803484:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803487:	83 ec 04             	sub    $0x4,%esp
  80348a:	6a 00                	push   $0x0
  80348c:	ff 75 e8             	pushl  -0x18(%ebp)
  80348f:	ff 75 08             	pushl  0x8(%ebp)
  803492:	e8 c4 f3 ff ff       	call   80285b <set_block_data>
  803497:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80349a:	e9 a9 02 00 00       	jmp    803748 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80349f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034a3:	0f 84 2d 01 00 00    	je     8035d6 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8034a9:	83 ec 0c             	sub    $0xc,%esp
  8034ac:	ff 75 10             	pushl  0x10(%ebp)
  8034af:	e8 56 f0 ff ff       	call   80250a <get_block_size>
  8034b4:	83 c4 10             	add    $0x10,%esp
  8034b7:	89 c3                	mov    %eax,%ebx
  8034b9:	83 ec 0c             	sub    $0xc,%esp
  8034bc:	ff 75 0c             	pushl  0xc(%ebp)
  8034bf:	e8 46 f0 ff ff       	call   80250a <get_block_size>
  8034c4:	83 c4 10             	add    $0x10,%esp
  8034c7:	01 d8                	add    %ebx,%eax
  8034c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8034cc:	83 ec 04             	sub    $0x4,%esp
  8034cf:	6a 00                	push   $0x0
  8034d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034d4:	ff 75 10             	pushl  0x10(%ebp)
  8034d7:	e8 7f f3 ff ff       	call   80285b <set_block_data>
  8034dc:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8034df:	8b 45 10             	mov    0x10(%ebp),%eax
  8034e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8034e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034e9:	74 06                	je     8034f1 <merging+0x1c6>
  8034eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034ef:	75 17                	jne    803508 <merging+0x1dd>
  8034f1:	83 ec 04             	sub    $0x4,%esp
  8034f4:	68 c0 4b 80 00       	push   $0x804bc0
  8034f9:	68 8d 01 00 00       	push   $0x18d
  8034fe:	68 05 4b 80 00       	push   $0x804b05
  803503:	e8 35 d2 ff ff       	call   80073d <_panic>
  803508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80350b:	8b 50 04             	mov    0x4(%eax),%edx
  80350e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803511:	89 50 04             	mov    %edx,0x4(%eax)
  803514:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803517:	8b 55 0c             	mov    0xc(%ebp),%edx
  80351a:	89 10                	mov    %edx,(%eax)
  80351c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351f:	8b 40 04             	mov    0x4(%eax),%eax
  803522:	85 c0                	test   %eax,%eax
  803524:	74 0d                	je     803533 <merging+0x208>
  803526:	8b 45 0c             	mov    0xc(%ebp),%eax
  803529:	8b 40 04             	mov    0x4(%eax),%eax
  80352c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80352f:	89 10                	mov    %edx,(%eax)
  803531:	eb 08                	jmp    80353b <merging+0x210>
  803533:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803536:	a3 30 50 80 00       	mov    %eax,0x805030
  80353b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80353e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803541:	89 50 04             	mov    %edx,0x4(%eax)
  803544:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803549:	40                   	inc    %eax
  80354a:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  80354f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803553:	75 17                	jne    80356c <merging+0x241>
  803555:	83 ec 04             	sub    $0x4,%esp
  803558:	68 e7 4a 80 00       	push   $0x804ae7
  80355d:	68 8e 01 00 00       	push   $0x18e
  803562:	68 05 4b 80 00       	push   $0x804b05
  803567:	e8 d1 d1 ff ff       	call   80073d <_panic>
  80356c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80356f:	8b 00                	mov    (%eax),%eax
  803571:	85 c0                	test   %eax,%eax
  803573:	74 10                	je     803585 <merging+0x25a>
  803575:	8b 45 0c             	mov    0xc(%ebp),%eax
  803578:	8b 00                	mov    (%eax),%eax
  80357a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80357d:	8b 52 04             	mov    0x4(%edx),%edx
  803580:	89 50 04             	mov    %edx,0x4(%eax)
  803583:	eb 0b                	jmp    803590 <merging+0x265>
  803585:	8b 45 0c             	mov    0xc(%ebp),%eax
  803588:	8b 40 04             	mov    0x4(%eax),%eax
  80358b:	a3 34 50 80 00       	mov    %eax,0x805034
  803590:	8b 45 0c             	mov    0xc(%ebp),%eax
  803593:	8b 40 04             	mov    0x4(%eax),%eax
  803596:	85 c0                	test   %eax,%eax
  803598:	74 0f                	je     8035a9 <merging+0x27e>
  80359a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80359d:	8b 40 04             	mov    0x4(%eax),%eax
  8035a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035a3:	8b 12                	mov    (%edx),%edx
  8035a5:	89 10                	mov    %edx,(%eax)
  8035a7:	eb 0a                	jmp    8035b3 <merging+0x288>
  8035a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ac:	8b 00                	mov    (%eax),%eax
  8035ae:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035cb:	48                   	dec    %eax
  8035cc:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035d1:	e9 72 01 00 00       	jmp    803748 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8035d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8035d9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8035dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e0:	74 79                	je     80365b <merging+0x330>
  8035e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035e6:	74 73                	je     80365b <merging+0x330>
  8035e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ec:	74 06                	je     8035f4 <merging+0x2c9>
  8035ee:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035f2:	75 17                	jne    80360b <merging+0x2e0>
  8035f4:	83 ec 04             	sub    $0x4,%esp
  8035f7:	68 78 4b 80 00       	push   $0x804b78
  8035fc:	68 94 01 00 00       	push   $0x194
  803601:	68 05 4b 80 00       	push   $0x804b05
  803606:	e8 32 d1 ff ff       	call   80073d <_panic>
  80360b:	8b 45 08             	mov    0x8(%ebp),%eax
  80360e:	8b 10                	mov    (%eax),%edx
  803610:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803613:	89 10                	mov    %edx,(%eax)
  803615:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803618:	8b 00                	mov    (%eax),%eax
  80361a:	85 c0                	test   %eax,%eax
  80361c:	74 0b                	je     803629 <merging+0x2fe>
  80361e:	8b 45 08             	mov    0x8(%ebp),%eax
  803621:	8b 00                	mov    (%eax),%eax
  803623:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803626:	89 50 04             	mov    %edx,0x4(%eax)
  803629:	8b 45 08             	mov    0x8(%ebp),%eax
  80362c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80362f:	89 10                	mov    %edx,(%eax)
  803631:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803634:	8b 55 08             	mov    0x8(%ebp),%edx
  803637:	89 50 04             	mov    %edx,0x4(%eax)
  80363a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80363d:	8b 00                	mov    (%eax),%eax
  80363f:	85 c0                	test   %eax,%eax
  803641:	75 08                	jne    80364b <merging+0x320>
  803643:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803646:	a3 34 50 80 00       	mov    %eax,0x805034
  80364b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803650:	40                   	inc    %eax
  803651:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803656:	e9 ce 00 00 00       	jmp    803729 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80365b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80365f:	74 65                	je     8036c6 <merging+0x39b>
  803661:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803665:	75 17                	jne    80367e <merging+0x353>
  803667:	83 ec 04             	sub    $0x4,%esp
  80366a:	68 54 4b 80 00       	push   $0x804b54
  80366f:	68 95 01 00 00       	push   $0x195
  803674:	68 05 4b 80 00       	push   $0x804b05
  803679:	e8 bf d0 ff ff       	call   80073d <_panic>
  80367e:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803684:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803687:	89 50 04             	mov    %edx,0x4(%eax)
  80368a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80368d:	8b 40 04             	mov    0x4(%eax),%eax
  803690:	85 c0                	test   %eax,%eax
  803692:	74 0c                	je     8036a0 <merging+0x375>
  803694:	a1 34 50 80 00       	mov    0x805034,%eax
  803699:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80369c:	89 10                	mov    %edx,(%eax)
  80369e:	eb 08                	jmp    8036a8 <merging+0x37d>
  8036a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8036a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ab:	a3 34 50 80 00       	mov    %eax,0x805034
  8036b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036b9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036be:	40                   	inc    %eax
  8036bf:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036c4:	eb 63                	jmp    803729 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8036c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036ca:	75 17                	jne    8036e3 <merging+0x3b8>
  8036cc:	83 ec 04             	sub    $0x4,%esp
  8036cf:	68 20 4b 80 00       	push   $0x804b20
  8036d4:	68 98 01 00 00       	push   $0x198
  8036d9:	68 05 4b 80 00       	push   $0x804b05
  8036de:	e8 5a d0 ff ff       	call   80073d <_panic>
  8036e3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8036e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ec:	89 10                	mov    %edx,(%eax)
  8036ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f1:	8b 00                	mov    (%eax),%eax
  8036f3:	85 c0                	test   %eax,%eax
  8036f5:	74 0d                	je     803704 <merging+0x3d9>
  8036f7:	a1 30 50 80 00       	mov    0x805030,%eax
  8036fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036ff:	89 50 04             	mov    %edx,0x4(%eax)
  803702:	eb 08                	jmp    80370c <merging+0x3e1>
  803704:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803707:	a3 34 50 80 00       	mov    %eax,0x805034
  80370c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80370f:	a3 30 50 80 00       	mov    %eax,0x805030
  803714:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803717:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80371e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803723:	40                   	inc    %eax
  803724:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803729:	83 ec 0c             	sub    $0xc,%esp
  80372c:	ff 75 10             	pushl  0x10(%ebp)
  80372f:	e8 d6 ed ff ff       	call   80250a <get_block_size>
  803734:	83 c4 10             	add    $0x10,%esp
  803737:	83 ec 04             	sub    $0x4,%esp
  80373a:	6a 00                	push   $0x0
  80373c:	50                   	push   %eax
  80373d:	ff 75 10             	pushl  0x10(%ebp)
  803740:	e8 16 f1 ff ff       	call   80285b <set_block_data>
  803745:	83 c4 10             	add    $0x10,%esp
	}
}
  803748:	90                   	nop
  803749:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80374c:	c9                   	leave  
  80374d:	c3                   	ret    

0080374e <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80374e:	55                   	push   %ebp
  80374f:	89 e5                	mov    %esp,%ebp
  803751:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803754:	a1 30 50 80 00       	mov    0x805030,%eax
  803759:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80375c:	a1 34 50 80 00       	mov    0x805034,%eax
  803761:	3b 45 08             	cmp    0x8(%ebp),%eax
  803764:	73 1b                	jae    803781 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803766:	a1 34 50 80 00       	mov    0x805034,%eax
  80376b:	83 ec 04             	sub    $0x4,%esp
  80376e:	ff 75 08             	pushl  0x8(%ebp)
  803771:	6a 00                	push   $0x0
  803773:	50                   	push   %eax
  803774:	e8 b2 fb ff ff       	call   80332b <merging>
  803779:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80377c:	e9 8b 00 00 00       	jmp    80380c <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803781:	a1 30 50 80 00       	mov    0x805030,%eax
  803786:	3b 45 08             	cmp    0x8(%ebp),%eax
  803789:	76 18                	jbe    8037a3 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80378b:	a1 30 50 80 00       	mov    0x805030,%eax
  803790:	83 ec 04             	sub    $0x4,%esp
  803793:	ff 75 08             	pushl  0x8(%ebp)
  803796:	50                   	push   %eax
  803797:	6a 00                	push   $0x0
  803799:	e8 8d fb ff ff       	call   80332b <merging>
  80379e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037a1:	eb 69                	jmp    80380c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8037a3:	a1 30 50 80 00       	mov    0x805030,%eax
  8037a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037ab:	eb 39                	jmp    8037e6 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8037ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037b3:	73 29                	jae    8037de <free_block+0x90>
  8037b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b8:	8b 00                	mov    (%eax),%eax
  8037ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037bd:	76 1f                	jbe    8037de <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8037bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c2:	8b 00                	mov    (%eax),%eax
  8037c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8037c7:	83 ec 04             	sub    $0x4,%esp
  8037ca:	ff 75 08             	pushl  0x8(%ebp)
  8037cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8037d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8037d3:	e8 53 fb ff ff       	call   80332b <merging>
  8037d8:	83 c4 10             	add    $0x10,%esp
			break;
  8037db:	90                   	nop
		}
	}
}
  8037dc:	eb 2e                	jmp    80380c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8037de:	a1 38 50 80 00       	mov    0x805038,%eax
  8037e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ea:	74 07                	je     8037f3 <free_block+0xa5>
  8037ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ef:	8b 00                	mov    (%eax),%eax
  8037f1:	eb 05                	jmp    8037f8 <free_block+0xaa>
  8037f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f8:	a3 38 50 80 00       	mov    %eax,0x805038
  8037fd:	a1 38 50 80 00       	mov    0x805038,%eax
  803802:	85 c0                	test   %eax,%eax
  803804:	75 a7                	jne    8037ad <free_block+0x5f>
  803806:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80380a:	75 a1                	jne    8037ad <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80380c:	90                   	nop
  80380d:	c9                   	leave  
  80380e:	c3                   	ret    

0080380f <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80380f:	55                   	push   %ebp
  803810:	89 e5                	mov    %esp,%ebp
  803812:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803815:	ff 75 08             	pushl  0x8(%ebp)
  803818:	e8 ed ec ff ff       	call   80250a <get_block_size>
  80381d:	83 c4 04             	add    $0x4,%esp
  803820:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803823:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80382a:	eb 17                	jmp    803843 <copy_data+0x34>
  80382c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80382f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803832:	01 c2                	add    %eax,%edx
  803834:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803837:	8b 45 08             	mov    0x8(%ebp),%eax
  80383a:	01 c8                	add    %ecx,%eax
  80383c:	8a 00                	mov    (%eax),%al
  80383e:	88 02                	mov    %al,(%edx)
  803840:	ff 45 fc             	incl   -0x4(%ebp)
  803843:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803846:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803849:	72 e1                	jb     80382c <copy_data+0x1d>
}
  80384b:	90                   	nop
  80384c:	c9                   	leave  
  80384d:	c3                   	ret    

0080384e <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80384e:	55                   	push   %ebp
  80384f:	89 e5                	mov    %esp,%ebp
  803851:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803854:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803858:	75 23                	jne    80387d <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80385a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80385e:	74 13                	je     803873 <realloc_block_FF+0x25>
  803860:	83 ec 0c             	sub    $0xc,%esp
  803863:	ff 75 0c             	pushl  0xc(%ebp)
  803866:	e8 1f f0 ff ff       	call   80288a <alloc_block_FF>
  80386b:	83 c4 10             	add    $0x10,%esp
  80386e:	e9 f4 06 00 00       	jmp    803f67 <realloc_block_FF+0x719>
		return NULL;
  803873:	b8 00 00 00 00       	mov    $0x0,%eax
  803878:	e9 ea 06 00 00       	jmp    803f67 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80387d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803881:	75 18                	jne    80389b <realloc_block_FF+0x4d>
	{
		free_block(va);
  803883:	83 ec 0c             	sub    $0xc,%esp
  803886:	ff 75 08             	pushl  0x8(%ebp)
  803889:	e8 c0 fe ff ff       	call   80374e <free_block>
  80388e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803891:	b8 00 00 00 00       	mov    $0x0,%eax
  803896:	e9 cc 06 00 00       	jmp    803f67 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80389b:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80389f:	77 07                	ja     8038a8 <realloc_block_FF+0x5a>
  8038a1:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8038a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038ab:	83 e0 01             	and    $0x1,%eax
  8038ae:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8038b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b4:	83 c0 08             	add    $0x8,%eax
  8038b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8038ba:	83 ec 0c             	sub    $0xc,%esp
  8038bd:	ff 75 08             	pushl  0x8(%ebp)
  8038c0:	e8 45 ec ff ff       	call   80250a <get_block_size>
  8038c5:	83 c4 10             	add    $0x10,%esp
  8038c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8038cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ce:	83 e8 08             	sub    $0x8,%eax
  8038d1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8038d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d7:	83 e8 04             	sub    $0x4,%eax
  8038da:	8b 00                	mov    (%eax),%eax
  8038dc:	83 e0 fe             	and    $0xfffffffe,%eax
  8038df:	89 c2                	mov    %eax,%edx
  8038e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e4:	01 d0                	add    %edx,%eax
  8038e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8038e9:	83 ec 0c             	sub    $0xc,%esp
  8038ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038ef:	e8 16 ec ff ff       	call   80250a <get_block_size>
  8038f4:	83 c4 10             	add    $0x10,%esp
  8038f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8038fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038fd:	83 e8 08             	sub    $0x8,%eax
  803900:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803903:	8b 45 0c             	mov    0xc(%ebp),%eax
  803906:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803909:	75 08                	jne    803913 <realloc_block_FF+0xc5>
	{
		 return va;
  80390b:	8b 45 08             	mov    0x8(%ebp),%eax
  80390e:	e9 54 06 00 00       	jmp    803f67 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803913:	8b 45 0c             	mov    0xc(%ebp),%eax
  803916:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803919:	0f 83 e5 03 00 00    	jae    803d04 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80391f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803922:	2b 45 0c             	sub    0xc(%ebp),%eax
  803925:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803928:	83 ec 0c             	sub    $0xc,%esp
  80392b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80392e:	e8 f0 eb ff ff       	call   802523 <is_free_block>
  803933:	83 c4 10             	add    $0x10,%esp
  803936:	84 c0                	test   %al,%al
  803938:	0f 84 3b 01 00 00    	je     803a79 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80393e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803941:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803944:	01 d0                	add    %edx,%eax
  803946:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803949:	83 ec 04             	sub    $0x4,%esp
  80394c:	6a 01                	push   $0x1
  80394e:	ff 75 f0             	pushl  -0x10(%ebp)
  803951:	ff 75 08             	pushl  0x8(%ebp)
  803954:	e8 02 ef ff ff       	call   80285b <set_block_data>
  803959:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80395c:	8b 45 08             	mov    0x8(%ebp),%eax
  80395f:	83 e8 04             	sub    $0x4,%eax
  803962:	8b 00                	mov    (%eax),%eax
  803964:	83 e0 fe             	and    $0xfffffffe,%eax
  803967:	89 c2                	mov    %eax,%edx
  803969:	8b 45 08             	mov    0x8(%ebp),%eax
  80396c:	01 d0                	add    %edx,%eax
  80396e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803971:	83 ec 04             	sub    $0x4,%esp
  803974:	6a 00                	push   $0x0
  803976:	ff 75 cc             	pushl  -0x34(%ebp)
  803979:	ff 75 c8             	pushl  -0x38(%ebp)
  80397c:	e8 da ee ff ff       	call   80285b <set_block_data>
  803981:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803984:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803988:	74 06                	je     803990 <realloc_block_FF+0x142>
  80398a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80398e:	75 17                	jne    8039a7 <realloc_block_FF+0x159>
  803990:	83 ec 04             	sub    $0x4,%esp
  803993:	68 78 4b 80 00       	push   $0x804b78
  803998:	68 f6 01 00 00       	push   $0x1f6
  80399d:	68 05 4b 80 00       	push   $0x804b05
  8039a2:	e8 96 cd ff ff       	call   80073d <_panic>
  8039a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039aa:	8b 10                	mov    (%eax),%edx
  8039ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039af:	89 10                	mov    %edx,(%eax)
  8039b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039b4:	8b 00                	mov    (%eax),%eax
  8039b6:	85 c0                	test   %eax,%eax
  8039b8:	74 0b                	je     8039c5 <realloc_block_FF+0x177>
  8039ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bd:	8b 00                	mov    (%eax),%eax
  8039bf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039c2:	89 50 04             	mov    %edx,0x4(%eax)
  8039c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8039cb:	89 10                	mov    %edx,(%eax)
  8039cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039d3:	89 50 04             	mov    %edx,0x4(%eax)
  8039d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039d9:	8b 00                	mov    (%eax),%eax
  8039db:	85 c0                	test   %eax,%eax
  8039dd:	75 08                	jne    8039e7 <realloc_block_FF+0x199>
  8039df:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039e2:	a3 34 50 80 00       	mov    %eax,0x805034
  8039e7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039ec:	40                   	inc    %eax
  8039ed:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8039f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039f6:	75 17                	jne    803a0f <realloc_block_FF+0x1c1>
  8039f8:	83 ec 04             	sub    $0x4,%esp
  8039fb:	68 e7 4a 80 00       	push   $0x804ae7
  803a00:	68 f7 01 00 00       	push   $0x1f7
  803a05:	68 05 4b 80 00       	push   $0x804b05
  803a0a:	e8 2e cd ff ff       	call   80073d <_panic>
  803a0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a12:	8b 00                	mov    (%eax),%eax
  803a14:	85 c0                	test   %eax,%eax
  803a16:	74 10                	je     803a28 <realloc_block_FF+0x1da>
  803a18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a1b:	8b 00                	mov    (%eax),%eax
  803a1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a20:	8b 52 04             	mov    0x4(%edx),%edx
  803a23:	89 50 04             	mov    %edx,0x4(%eax)
  803a26:	eb 0b                	jmp    803a33 <realloc_block_FF+0x1e5>
  803a28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2b:	8b 40 04             	mov    0x4(%eax),%eax
  803a2e:	a3 34 50 80 00       	mov    %eax,0x805034
  803a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a36:	8b 40 04             	mov    0x4(%eax),%eax
  803a39:	85 c0                	test   %eax,%eax
  803a3b:	74 0f                	je     803a4c <realloc_block_FF+0x1fe>
  803a3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a40:	8b 40 04             	mov    0x4(%eax),%eax
  803a43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a46:	8b 12                	mov    (%edx),%edx
  803a48:	89 10                	mov    %edx,(%eax)
  803a4a:	eb 0a                	jmp    803a56 <realloc_block_FF+0x208>
  803a4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4f:	8b 00                	mov    (%eax),%eax
  803a51:	a3 30 50 80 00       	mov    %eax,0x805030
  803a56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a69:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a6e:	48                   	dec    %eax
  803a6f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a74:	e9 83 02 00 00       	jmp    803cfc <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803a79:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803a7d:	0f 86 69 02 00 00    	jbe    803cec <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803a83:	83 ec 04             	sub    $0x4,%esp
  803a86:	6a 01                	push   $0x1
  803a88:	ff 75 f0             	pushl  -0x10(%ebp)
  803a8b:	ff 75 08             	pushl  0x8(%ebp)
  803a8e:	e8 c8 ed ff ff       	call   80285b <set_block_data>
  803a93:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a96:	8b 45 08             	mov    0x8(%ebp),%eax
  803a99:	83 e8 04             	sub    $0x4,%eax
  803a9c:	8b 00                	mov    (%eax),%eax
  803a9e:	83 e0 fe             	and    $0xfffffffe,%eax
  803aa1:	89 c2                	mov    %eax,%edx
  803aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa6:	01 d0                	add    %edx,%eax
  803aa8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803aab:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ab0:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803ab3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ab7:	75 68                	jne    803b21 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ab9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803abd:	75 17                	jne    803ad6 <realloc_block_FF+0x288>
  803abf:	83 ec 04             	sub    $0x4,%esp
  803ac2:	68 20 4b 80 00       	push   $0x804b20
  803ac7:	68 06 02 00 00       	push   $0x206
  803acc:	68 05 4b 80 00       	push   $0x804b05
  803ad1:	e8 67 cc ff ff       	call   80073d <_panic>
  803ad6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803adc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803adf:	89 10                	mov    %edx,(%eax)
  803ae1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae4:	8b 00                	mov    (%eax),%eax
  803ae6:	85 c0                	test   %eax,%eax
  803ae8:	74 0d                	je     803af7 <realloc_block_FF+0x2a9>
  803aea:	a1 30 50 80 00       	mov    0x805030,%eax
  803aef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803af2:	89 50 04             	mov    %edx,0x4(%eax)
  803af5:	eb 08                	jmp    803aff <realloc_block_FF+0x2b1>
  803af7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803afa:	a3 34 50 80 00       	mov    %eax,0x805034
  803aff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b02:	a3 30 50 80 00       	mov    %eax,0x805030
  803b07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b11:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b16:	40                   	inc    %eax
  803b17:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b1c:	e9 b0 01 00 00       	jmp    803cd1 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803b21:	a1 30 50 80 00       	mov    0x805030,%eax
  803b26:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b29:	76 68                	jbe    803b93 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b2b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b2f:	75 17                	jne    803b48 <realloc_block_FF+0x2fa>
  803b31:	83 ec 04             	sub    $0x4,%esp
  803b34:	68 20 4b 80 00       	push   $0x804b20
  803b39:	68 0b 02 00 00       	push   $0x20b
  803b3e:	68 05 4b 80 00       	push   $0x804b05
  803b43:	e8 f5 cb ff ff       	call   80073d <_panic>
  803b48:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b51:	89 10                	mov    %edx,(%eax)
  803b53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b56:	8b 00                	mov    (%eax),%eax
  803b58:	85 c0                	test   %eax,%eax
  803b5a:	74 0d                	je     803b69 <realloc_block_FF+0x31b>
  803b5c:	a1 30 50 80 00       	mov    0x805030,%eax
  803b61:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b64:	89 50 04             	mov    %edx,0x4(%eax)
  803b67:	eb 08                	jmp    803b71 <realloc_block_FF+0x323>
  803b69:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b6c:	a3 34 50 80 00       	mov    %eax,0x805034
  803b71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b74:	a3 30 50 80 00       	mov    %eax,0x805030
  803b79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b83:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b88:	40                   	inc    %eax
  803b89:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b8e:	e9 3e 01 00 00       	jmp    803cd1 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803b93:	a1 30 50 80 00       	mov    0x805030,%eax
  803b98:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b9b:	73 68                	jae    803c05 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b9d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ba1:	75 17                	jne    803bba <realloc_block_FF+0x36c>
  803ba3:	83 ec 04             	sub    $0x4,%esp
  803ba6:	68 54 4b 80 00       	push   $0x804b54
  803bab:	68 10 02 00 00       	push   $0x210
  803bb0:	68 05 4b 80 00       	push   $0x804b05
  803bb5:	e8 83 cb ff ff       	call   80073d <_panic>
  803bba:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803bc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc3:	89 50 04             	mov    %edx,0x4(%eax)
  803bc6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc9:	8b 40 04             	mov    0x4(%eax),%eax
  803bcc:	85 c0                	test   %eax,%eax
  803bce:	74 0c                	je     803bdc <realloc_block_FF+0x38e>
  803bd0:	a1 34 50 80 00       	mov    0x805034,%eax
  803bd5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bd8:	89 10                	mov    %edx,(%eax)
  803bda:	eb 08                	jmp    803be4 <realloc_block_FF+0x396>
  803bdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bdf:	a3 30 50 80 00       	mov    %eax,0x805030
  803be4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be7:	a3 34 50 80 00       	mov    %eax,0x805034
  803bec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bf5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bfa:	40                   	inc    %eax
  803bfb:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c00:	e9 cc 00 00 00       	jmp    803cd1 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803c05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803c0c:	a1 30 50 80 00       	mov    0x805030,%eax
  803c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c14:	e9 8a 00 00 00       	jmp    803ca3 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c1c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c1f:	73 7a                	jae    803c9b <realloc_block_FF+0x44d>
  803c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c24:	8b 00                	mov    (%eax),%eax
  803c26:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c29:	73 70                	jae    803c9b <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803c2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c2f:	74 06                	je     803c37 <realloc_block_FF+0x3e9>
  803c31:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c35:	75 17                	jne    803c4e <realloc_block_FF+0x400>
  803c37:	83 ec 04             	sub    $0x4,%esp
  803c3a:	68 78 4b 80 00       	push   $0x804b78
  803c3f:	68 1a 02 00 00       	push   $0x21a
  803c44:	68 05 4b 80 00       	push   $0x804b05
  803c49:	e8 ef ca ff ff       	call   80073d <_panic>
  803c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c51:	8b 10                	mov    (%eax),%edx
  803c53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c56:	89 10                	mov    %edx,(%eax)
  803c58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c5b:	8b 00                	mov    (%eax),%eax
  803c5d:	85 c0                	test   %eax,%eax
  803c5f:	74 0b                	je     803c6c <realloc_block_FF+0x41e>
  803c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c64:	8b 00                	mov    (%eax),%eax
  803c66:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c69:	89 50 04             	mov    %edx,0x4(%eax)
  803c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c72:	89 10                	mov    %edx,(%eax)
  803c74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c7a:	89 50 04             	mov    %edx,0x4(%eax)
  803c7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c80:	8b 00                	mov    (%eax),%eax
  803c82:	85 c0                	test   %eax,%eax
  803c84:	75 08                	jne    803c8e <realloc_block_FF+0x440>
  803c86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c89:	a3 34 50 80 00       	mov    %eax,0x805034
  803c8e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c93:	40                   	inc    %eax
  803c94:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803c99:	eb 36                	jmp    803cd1 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803c9b:	a1 38 50 80 00       	mov    0x805038,%eax
  803ca0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ca3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ca7:	74 07                	je     803cb0 <realloc_block_FF+0x462>
  803ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cac:	8b 00                	mov    (%eax),%eax
  803cae:	eb 05                	jmp    803cb5 <realloc_block_FF+0x467>
  803cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  803cb5:	a3 38 50 80 00       	mov    %eax,0x805038
  803cba:	a1 38 50 80 00       	mov    0x805038,%eax
  803cbf:	85 c0                	test   %eax,%eax
  803cc1:	0f 85 52 ff ff ff    	jne    803c19 <realloc_block_FF+0x3cb>
  803cc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ccb:	0f 85 48 ff ff ff    	jne    803c19 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803cd1:	83 ec 04             	sub    $0x4,%esp
  803cd4:	6a 00                	push   $0x0
  803cd6:	ff 75 d8             	pushl  -0x28(%ebp)
  803cd9:	ff 75 d4             	pushl  -0x2c(%ebp)
  803cdc:	e8 7a eb ff ff       	call   80285b <set_block_data>
  803ce1:	83 c4 10             	add    $0x10,%esp
				return va;
  803ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce7:	e9 7b 02 00 00       	jmp    803f67 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803cec:	83 ec 0c             	sub    $0xc,%esp
  803cef:	68 f5 4b 80 00       	push   $0x804bf5
  803cf4:	e8 01 cd ff ff       	call   8009fa <cprintf>
  803cf9:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  803cff:	e9 63 02 00 00       	jmp    803f67 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d07:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d0a:	0f 86 4d 02 00 00    	jbe    803f5d <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803d10:	83 ec 0c             	sub    $0xc,%esp
  803d13:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d16:	e8 08 e8 ff ff       	call   802523 <is_free_block>
  803d1b:	83 c4 10             	add    $0x10,%esp
  803d1e:	84 c0                	test   %al,%al
  803d20:	0f 84 37 02 00 00    	je     803f5d <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d29:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d2c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803d2f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d32:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d35:	76 38                	jbe    803d6f <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803d37:	83 ec 0c             	sub    $0xc,%esp
  803d3a:	ff 75 08             	pushl  0x8(%ebp)
  803d3d:	e8 0c fa ff ff       	call   80374e <free_block>
  803d42:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803d45:	83 ec 0c             	sub    $0xc,%esp
  803d48:	ff 75 0c             	pushl  0xc(%ebp)
  803d4b:	e8 3a eb ff ff       	call   80288a <alloc_block_FF>
  803d50:	83 c4 10             	add    $0x10,%esp
  803d53:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803d56:	83 ec 08             	sub    $0x8,%esp
  803d59:	ff 75 c0             	pushl  -0x40(%ebp)
  803d5c:	ff 75 08             	pushl  0x8(%ebp)
  803d5f:	e8 ab fa ff ff       	call   80380f <copy_data>
  803d64:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803d67:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803d6a:	e9 f8 01 00 00       	jmp    803f67 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803d6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d72:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803d75:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803d78:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803d7c:	0f 87 a0 00 00 00    	ja     803e22 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803d82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d86:	75 17                	jne    803d9f <realloc_block_FF+0x551>
  803d88:	83 ec 04             	sub    $0x4,%esp
  803d8b:	68 e7 4a 80 00       	push   $0x804ae7
  803d90:	68 38 02 00 00       	push   $0x238
  803d95:	68 05 4b 80 00       	push   $0x804b05
  803d9a:	e8 9e c9 ff ff       	call   80073d <_panic>
  803d9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da2:	8b 00                	mov    (%eax),%eax
  803da4:	85 c0                	test   %eax,%eax
  803da6:	74 10                	je     803db8 <realloc_block_FF+0x56a>
  803da8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dab:	8b 00                	mov    (%eax),%eax
  803dad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803db0:	8b 52 04             	mov    0x4(%edx),%edx
  803db3:	89 50 04             	mov    %edx,0x4(%eax)
  803db6:	eb 0b                	jmp    803dc3 <realloc_block_FF+0x575>
  803db8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbb:	8b 40 04             	mov    0x4(%eax),%eax
  803dbe:	a3 34 50 80 00       	mov    %eax,0x805034
  803dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc6:	8b 40 04             	mov    0x4(%eax),%eax
  803dc9:	85 c0                	test   %eax,%eax
  803dcb:	74 0f                	je     803ddc <realloc_block_FF+0x58e>
  803dcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd0:	8b 40 04             	mov    0x4(%eax),%eax
  803dd3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dd6:	8b 12                	mov    (%edx),%edx
  803dd8:	89 10                	mov    %edx,(%eax)
  803dda:	eb 0a                	jmp    803de6 <realloc_block_FF+0x598>
  803ddc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ddf:	8b 00                	mov    (%eax),%eax
  803de1:	a3 30 50 80 00       	mov    %eax,0x805030
  803de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803def:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803df9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803dfe:	48                   	dec    %eax
  803dff:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803e04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e0a:	01 d0                	add    %edx,%eax
  803e0c:	83 ec 04             	sub    $0x4,%esp
  803e0f:	6a 01                	push   $0x1
  803e11:	50                   	push   %eax
  803e12:	ff 75 08             	pushl  0x8(%ebp)
  803e15:	e8 41 ea ff ff       	call   80285b <set_block_data>
  803e1a:	83 c4 10             	add    $0x10,%esp
  803e1d:	e9 36 01 00 00       	jmp    803f58 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803e22:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e25:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e28:	01 d0                	add    %edx,%eax
  803e2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803e2d:	83 ec 04             	sub    $0x4,%esp
  803e30:	6a 01                	push   $0x1
  803e32:	ff 75 f0             	pushl  -0x10(%ebp)
  803e35:	ff 75 08             	pushl  0x8(%ebp)
  803e38:	e8 1e ea ff ff       	call   80285b <set_block_data>
  803e3d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803e40:	8b 45 08             	mov    0x8(%ebp),%eax
  803e43:	83 e8 04             	sub    $0x4,%eax
  803e46:	8b 00                	mov    (%eax),%eax
  803e48:	83 e0 fe             	and    $0xfffffffe,%eax
  803e4b:	89 c2                	mov    %eax,%edx
  803e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e50:	01 d0                	add    %edx,%eax
  803e52:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803e55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e59:	74 06                	je     803e61 <realloc_block_FF+0x613>
  803e5b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803e5f:	75 17                	jne    803e78 <realloc_block_FF+0x62a>
  803e61:	83 ec 04             	sub    $0x4,%esp
  803e64:	68 78 4b 80 00       	push   $0x804b78
  803e69:	68 44 02 00 00       	push   $0x244
  803e6e:	68 05 4b 80 00       	push   $0x804b05
  803e73:	e8 c5 c8 ff ff       	call   80073d <_panic>
  803e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e7b:	8b 10                	mov    (%eax),%edx
  803e7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e80:	89 10                	mov    %edx,(%eax)
  803e82:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e85:	8b 00                	mov    (%eax),%eax
  803e87:	85 c0                	test   %eax,%eax
  803e89:	74 0b                	je     803e96 <realloc_block_FF+0x648>
  803e8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e8e:	8b 00                	mov    (%eax),%eax
  803e90:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e93:	89 50 04             	mov    %edx,0x4(%eax)
  803e96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e99:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e9c:	89 10                	mov    %edx,(%eax)
  803e9e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ea1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ea4:	89 50 04             	mov    %edx,0x4(%eax)
  803ea7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803eaa:	8b 00                	mov    (%eax),%eax
  803eac:	85 c0                	test   %eax,%eax
  803eae:	75 08                	jne    803eb8 <realloc_block_FF+0x66a>
  803eb0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803eb3:	a3 34 50 80 00       	mov    %eax,0x805034
  803eb8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ebd:	40                   	inc    %eax
  803ebe:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ec3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ec7:	75 17                	jne    803ee0 <realloc_block_FF+0x692>
  803ec9:	83 ec 04             	sub    $0x4,%esp
  803ecc:	68 e7 4a 80 00       	push   $0x804ae7
  803ed1:	68 45 02 00 00       	push   $0x245
  803ed6:	68 05 4b 80 00       	push   $0x804b05
  803edb:	e8 5d c8 ff ff       	call   80073d <_panic>
  803ee0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee3:	8b 00                	mov    (%eax),%eax
  803ee5:	85 c0                	test   %eax,%eax
  803ee7:	74 10                	je     803ef9 <realloc_block_FF+0x6ab>
  803ee9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eec:	8b 00                	mov    (%eax),%eax
  803eee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ef1:	8b 52 04             	mov    0x4(%edx),%edx
  803ef4:	89 50 04             	mov    %edx,0x4(%eax)
  803ef7:	eb 0b                	jmp    803f04 <realloc_block_FF+0x6b6>
  803ef9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efc:	8b 40 04             	mov    0x4(%eax),%eax
  803eff:	a3 34 50 80 00       	mov    %eax,0x805034
  803f04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f07:	8b 40 04             	mov    0x4(%eax),%eax
  803f0a:	85 c0                	test   %eax,%eax
  803f0c:	74 0f                	je     803f1d <realloc_block_FF+0x6cf>
  803f0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f11:	8b 40 04             	mov    0x4(%eax),%eax
  803f14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f17:	8b 12                	mov    (%edx),%edx
  803f19:	89 10                	mov    %edx,(%eax)
  803f1b:	eb 0a                	jmp    803f27 <realloc_block_FF+0x6d9>
  803f1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f20:	8b 00                	mov    (%eax),%eax
  803f22:	a3 30 50 80 00       	mov    %eax,0x805030
  803f27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f3a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f3f:	48                   	dec    %eax
  803f40:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803f45:	83 ec 04             	sub    $0x4,%esp
  803f48:	6a 00                	push   $0x0
  803f4a:	ff 75 bc             	pushl  -0x44(%ebp)
  803f4d:	ff 75 b8             	pushl  -0x48(%ebp)
  803f50:	e8 06 e9 ff ff       	call   80285b <set_block_data>
  803f55:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803f58:	8b 45 08             	mov    0x8(%ebp),%eax
  803f5b:	eb 0a                	jmp    803f67 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803f5d:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803f64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803f67:	c9                   	leave  
  803f68:	c3                   	ret    

00803f69 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803f69:	55                   	push   %ebp
  803f6a:	89 e5                	mov    %esp,%ebp
  803f6c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803f6f:	83 ec 04             	sub    $0x4,%esp
  803f72:	68 fc 4b 80 00       	push   $0x804bfc
  803f77:	68 58 02 00 00       	push   $0x258
  803f7c:	68 05 4b 80 00       	push   $0x804b05
  803f81:	e8 b7 c7 ff ff       	call   80073d <_panic>

00803f86 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803f86:	55                   	push   %ebp
  803f87:	89 e5                	mov    %esp,%ebp
  803f89:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803f8c:	83 ec 04             	sub    $0x4,%esp
  803f8f:	68 24 4c 80 00       	push   $0x804c24
  803f94:	68 61 02 00 00       	push   $0x261
  803f99:	68 05 4b 80 00       	push   $0x804b05
  803f9e:	e8 9a c7 ff ff       	call   80073d <_panic>
  803fa3:	90                   	nop

00803fa4 <__udivdi3>:
  803fa4:	55                   	push   %ebp
  803fa5:	57                   	push   %edi
  803fa6:	56                   	push   %esi
  803fa7:	53                   	push   %ebx
  803fa8:	83 ec 1c             	sub    $0x1c,%esp
  803fab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803faf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803fb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fb7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803fbb:	89 ca                	mov    %ecx,%edx
  803fbd:	89 f8                	mov    %edi,%eax
  803fbf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803fc3:	85 f6                	test   %esi,%esi
  803fc5:	75 2d                	jne    803ff4 <__udivdi3+0x50>
  803fc7:	39 cf                	cmp    %ecx,%edi
  803fc9:	77 65                	ja     804030 <__udivdi3+0x8c>
  803fcb:	89 fd                	mov    %edi,%ebp
  803fcd:	85 ff                	test   %edi,%edi
  803fcf:	75 0b                	jne    803fdc <__udivdi3+0x38>
  803fd1:	b8 01 00 00 00       	mov    $0x1,%eax
  803fd6:	31 d2                	xor    %edx,%edx
  803fd8:	f7 f7                	div    %edi
  803fda:	89 c5                	mov    %eax,%ebp
  803fdc:	31 d2                	xor    %edx,%edx
  803fde:	89 c8                	mov    %ecx,%eax
  803fe0:	f7 f5                	div    %ebp
  803fe2:	89 c1                	mov    %eax,%ecx
  803fe4:	89 d8                	mov    %ebx,%eax
  803fe6:	f7 f5                	div    %ebp
  803fe8:	89 cf                	mov    %ecx,%edi
  803fea:	89 fa                	mov    %edi,%edx
  803fec:	83 c4 1c             	add    $0x1c,%esp
  803fef:	5b                   	pop    %ebx
  803ff0:	5e                   	pop    %esi
  803ff1:	5f                   	pop    %edi
  803ff2:	5d                   	pop    %ebp
  803ff3:	c3                   	ret    
  803ff4:	39 ce                	cmp    %ecx,%esi
  803ff6:	77 28                	ja     804020 <__udivdi3+0x7c>
  803ff8:	0f bd fe             	bsr    %esi,%edi
  803ffb:	83 f7 1f             	xor    $0x1f,%edi
  803ffe:	75 40                	jne    804040 <__udivdi3+0x9c>
  804000:	39 ce                	cmp    %ecx,%esi
  804002:	72 0a                	jb     80400e <__udivdi3+0x6a>
  804004:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804008:	0f 87 9e 00 00 00    	ja     8040ac <__udivdi3+0x108>
  80400e:	b8 01 00 00 00       	mov    $0x1,%eax
  804013:	89 fa                	mov    %edi,%edx
  804015:	83 c4 1c             	add    $0x1c,%esp
  804018:	5b                   	pop    %ebx
  804019:	5e                   	pop    %esi
  80401a:	5f                   	pop    %edi
  80401b:	5d                   	pop    %ebp
  80401c:	c3                   	ret    
  80401d:	8d 76 00             	lea    0x0(%esi),%esi
  804020:	31 ff                	xor    %edi,%edi
  804022:	31 c0                	xor    %eax,%eax
  804024:	89 fa                	mov    %edi,%edx
  804026:	83 c4 1c             	add    $0x1c,%esp
  804029:	5b                   	pop    %ebx
  80402a:	5e                   	pop    %esi
  80402b:	5f                   	pop    %edi
  80402c:	5d                   	pop    %ebp
  80402d:	c3                   	ret    
  80402e:	66 90                	xchg   %ax,%ax
  804030:	89 d8                	mov    %ebx,%eax
  804032:	f7 f7                	div    %edi
  804034:	31 ff                	xor    %edi,%edi
  804036:	89 fa                	mov    %edi,%edx
  804038:	83 c4 1c             	add    $0x1c,%esp
  80403b:	5b                   	pop    %ebx
  80403c:	5e                   	pop    %esi
  80403d:	5f                   	pop    %edi
  80403e:	5d                   	pop    %ebp
  80403f:	c3                   	ret    
  804040:	bd 20 00 00 00       	mov    $0x20,%ebp
  804045:	89 eb                	mov    %ebp,%ebx
  804047:	29 fb                	sub    %edi,%ebx
  804049:	89 f9                	mov    %edi,%ecx
  80404b:	d3 e6                	shl    %cl,%esi
  80404d:	89 c5                	mov    %eax,%ebp
  80404f:	88 d9                	mov    %bl,%cl
  804051:	d3 ed                	shr    %cl,%ebp
  804053:	89 e9                	mov    %ebp,%ecx
  804055:	09 f1                	or     %esi,%ecx
  804057:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80405b:	89 f9                	mov    %edi,%ecx
  80405d:	d3 e0                	shl    %cl,%eax
  80405f:	89 c5                	mov    %eax,%ebp
  804061:	89 d6                	mov    %edx,%esi
  804063:	88 d9                	mov    %bl,%cl
  804065:	d3 ee                	shr    %cl,%esi
  804067:	89 f9                	mov    %edi,%ecx
  804069:	d3 e2                	shl    %cl,%edx
  80406b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80406f:	88 d9                	mov    %bl,%cl
  804071:	d3 e8                	shr    %cl,%eax
  804073:	09 c2                	or     %eax,%edx
  804075:	89 d0                	mov    %edx,%eax
  804077:	89 f2                	mov    %esi,%edx
  804079:	f7 74 24 0c          	divl   0xc(%esp)
  80407d:	89 d6                	mov    %edx,%esi
  80407f:	89 c3                	mov    %eax,%ebx
  804081:	f7 e5                	mul    %ebp
  804083:	39 d6                	cmp    %edx,%esi
  804085:	72 19                	jb     8040a0 <__udivdi3+0xfc>
  804087:	74 0b                	je     804094 <__udivdi3+0xf0>
  804089:	89 d8                	mov    %ebx,%eax
  80408b:	31 ff                	xor    %edi,%edi
  80408d:	e9 58 ff ff ff       	jmp    803fea <__udivdi3+0x46>
  804092:	66 90                	xchg   %ax,%ax
  804094:	8b 54 24 08          	mov    0x8(%esp),%edx
  804098:	89 f9                	mov    %edi,%ecx
  80409a:	d3 e2                	shl    %cl,%edx
  80409c:	39 c2                	cmp    %eax,%edx
  80409e:	73 e9                	jae    804089 <__udivdi3+0xe5>
  8040a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8040a3:	31 ff                	xor    %edi,%edi
  8040a5:	e9 40 ff ff ff       	jmp    803fea <__udivdi3+0x46>
  8040aa:	66 90                	xchg   %ax,%ax
  8040ac:	31 c0                	xor    %eax,%eax
  8040ae:	e9 37 ff ff ff       	jmp    803fea <__udivdi3+0x46>
  8040b3:	90                   	nop

008040b4 <__umoddi3>:
  8040b4:	55                   	push   %ebp
  8040b5:	57                   	push   %edi
  8040b6:	56                   	push   %esi
  8040b7:	53                   	push   %ebx
  8040b8:	83 ec 1c             	sub    $0x1c,%esp
  8040bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8040bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8040c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040d3:	89 f3                	mov    %esi,%ebx
  8040d5:	89 fa                	mov    %edi,%edx
  8040d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040db:	89 34 24             	mov    %esi,(%esp)
  8040de:	85 c0                	test   %eax,%eax
  8040e0:	75 1a                	jne    8040fc <__umoddi3+0x48>
  8040e2:	39 f7                	cmp    %esi,%edi
  8040e4:	0f 86 a2 00 00 00    	jbe    80418c <__umoddi3+0xd8>
  8040ea:	89 c8                	mov    %ecx,%eax
  8040ec:	89 f2                	mov    %esi,%edx
  8040ee:	f7 f7                	div    %edi
  8040f0:	89 d0                	mov    %edx,%eax
  8040f2:	31 d2                	xor    %edx,%edx
  8040f4:	83 c4 1c             	add    $0x1c,%esp
  8040f7:	5b                   	pop    %ebx
  8040f8:	5e                   	pop    %esi
  8040f9:	5f                   	pop    %edi
  8040fa:	5d                   	pop    %ebp
  8040fb:	c3                   	ret    
  8040fc:	39 f0                	cmp    %esi,%eax
  8040fe:	0f 87 ac 00 00 00    	ja     8041b0 <__umoddi3+0xfc>
  804104:	0f bd e8             	bsr    %eax,%ebp
  804107:	83 f5 1f             	xor    $0x1f,%ebp
  80410a:	0f 84 ac 00 00 00    	je     8041bc <__umoddi3+0x108>
  804110:	bf 20 00 00 00       	mov    $0x20,%edi
  804115:	29 ef                	sub    %ebp,%edi
  804117:	89 fe                	mov    %edi,%esi
  804119:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80411d:	89 e9                	mov    %ebp,%ecx
  80411f:	d3 e0                	shl    %cl,%eax
  804121:	89 d7                	mov    %edx,%edi
  804123:	89 f1                	mov    %esi,%ecx
  804125:	d3 ef                	shr    %cl,%edi
  804127:	09 c7                	or     %eax,%edi
  804129:	89 e9                	mov    %ebp,%ecx
  80412b:	d3 e2                	shl    %cl,%edx
  80412d:	89 14 24             	mov    %edx,(%esp)
  804130:	89 d8                	mov    %ebx,%eax
  804132:	d3 e0                	shl    %cl,%eax
  804134:	89 c2                	mov    %eax,%edx
  804136:	8b 44 24 08          	mov    0x8(%esp),%eax
  80413a:	d3 e0                	shl    %cl,%eax
  80413c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804140:	8b 44 24 08          	mov    0x8(%esp),%eax
  804144:	89 f1                	mov    %esi,%ecx
  804146:	d3 e8                	shr    %cl,%eax
  804148:	09 d0                	or     %edx,%eax
  80414a:	d3 eb                	shr    %cl,%ebx
  80414c:	89 da                	mov    %ebx,%edx
  80414e:	f7 f7                	div    %edi
  804150:	89 d3                	mov    %edx,%ebx
  804152:	f7 24 24             	mull   (%esp)
  804155:	89 c6                	mov    %eax,%esi
  804157:	89 d1                	mov    %edx,%ecx
  804159:	39 d3                	cmp    %edx,%ebx
  80415b:	0f 82 87 00 00 00    	jb     8041e8 <__umoddi3+0x134>
  804161:	0f 84 91 00 00 00    	je     8041f8 <__umoddi3+0x144>
  804167:	8b 54 24 04          	mov    0x4(%esp),%edx
  80416b:	29 f2                	sub    %esi,%edx
  80416d:	19 cb                	sbb    %ecx,%ebx
  80416f:	89 d8                	mov    %ebx,%eax
  804171:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804175:	d3 e0                	shl    %cl,%eax
  804177:	89 e9                	mov    %ebp,%ecx
  804179:	d3 ea                	shr    %cl,%edx
  80417b:	09 d0                	or     %edx,%eax
  80417d:	89 e9                	mov    %ebp,%ecx
  80417f:	d3 eb                	shr    %cl,%ebx
  804181:	89 da                	mov    %ebx,%edx
  804183:	83 c4 1c             	add    $0x1c,%esp
  804186:	5b                   	pop    %ebx
  804187:	5e                   	pop    %esi
  804188:	5f                   	pop    %edi
  804189:	5d                   	pop    %ebp
  80418a:	c3                   	ret    
  80418b:	90                   	nop
  80418c:	89 fd                	mov    %edi,%ebp
  80418e:	85 ff                	test   %edi,%edi
  804190:	75 0b                	jne    80419d <__umoddi3+0xe9>
  804192:	b8 01 00 00 00       	mov    $0x1,%eax
  804197:	31 d2                	xor    %edx,%edx
  804199:	f7 f7                	div    %edi
  80419b:	89 c5                	mov    %eax,%ebp
  80419d:	89 f0                	mov    %esi,%eax
  80419f:	31 d2                	xor    %edx,%edx
  8041a1:	f7 f5                	div    %ebp
  8041a3:	89 c8                	mov    %ecx,%eax
  8041a5:	f7 f5                	div    %ebp
  8041a7:	89 d0                	mov    %edx,%eax
  8041a9:	e9 44 ff ff ff       	jmp    8040f2 <__umoddi3+0x3e>
  8041ae:	66 90                	xchg   %ax,%ax
  8041b0:	89 c8                	mov    %ecx,%eax
  8041b2:	89 f2                	mov    %esi,%edx
  8041b4:	83 c4 1c             	add    $0x1c,%esp
  8041b7:	5b                   	pop    %ebx
  8041b8:	5e                   	pop    %esi
  8041b9:	5f                   	pop    %edi
  8041ba:	5d                   	pop    %ebp
  8041bb:	c3                   	ret    
  8041bc:	3b 04 24             	cmp    (%esp),%eax
  8041bf:	72 06                	jb     8041c7 <__umoddi3+0x113>
  8041c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8041c5:	77 0f                	ja     8041d6 <__umoddi3+0x122>
  8041c7:	89 f2                	mov    %esi,%edx
  8041c9:	29 f9                	sub    %edi,%ecx
  8041cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8041cf:	89 14 24             	mov    %edx,(%esp)
  8041d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8041da:	8b 14 24             	mov    (%esp),%edx
  8041dd:	83 c4 1c             	add    $0x1c,%esp
  8041e0:	5b                   	pop    %ebx
  8041e1:	5e                   	pop    %esi
  8041e2:	5f                   	pop    %edi
  8041e3:	5d                   	pop    %ebp
  8041e4:	c3                   	ret    
  8041e5:	8d 76 00             	lea    0x0(%esi),%esi
  8041e8:	2b 04 24             	sub    (%esp),%eax
  8041eb:	19 fa                	sbb    %edi,%edx
  8041ed:	89 d1                	mov    %edx,%ecx
  8041ef:	89 c6                	mov    %eax,%esi
  8041f1:	e9 71 ff ff ff       	jmp    804167 <__umoddi3+0xb3>
  8041f6:	66 90                	xchg   %ax,%ax
  8041f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041fc:	72 ea                	jb     8041e8 <__umoddi3+0x134>
  8041fe:	89 d9                	mov    %ebx,%ecx
  804200:	e9 62 ff ff ff       	jmp    804167 <__umoddi3+0xb3>
