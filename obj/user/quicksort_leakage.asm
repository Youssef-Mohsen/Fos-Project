
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
  800041:	e8 e5 1a 00 00       	call   801b2b <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 23 80 00       	push   $0x802360
  80004e:	e8 9f 09 00 00       	call   8009f2 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 23 80 00       	push   $0x802362
  80005e:	e8 8f 09 00 00       	call   8009f2 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 7b 23 80 00       	push   $0x80237b
  80006e:	e8 7f 09 00 00       	call   8009f2 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 23 80 00       	push   $0x802362
  80007e:	e8 6f 09 00 00       	call   8009f2 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 23 80 00       	push   $0x802360
  80008e:	e8 5f 09 00 00       	call   8009f2 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 94 23 80 00       	push   $0x802394
  8000a5:	e8 dc 0f 00 00       	call   801086 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 2e 15 00 00       	call   8015ee <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 b4 23 80 00       	push   $0x8023b4
  8000ce:	e8 1f 09 00 00       	call   8009f2 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 d6 23 80 00       	push   $0x8023d6
  8000de:	e8 0f 09 00 00       	call   8009f2 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 e4 23 80 00       	push   $0x8023e4
  8000ee:	e8 ff 08 00 00       	call   8009f2 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 f3 23 80 00       	push   $0x8023f3
  8000fe:	e8 ef 08 00 00       	call   8009f2 <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 03 24 80 00       	push   $0x802403
  80010e:	e8 df 08 00 00       	call   8009f2 <cprintf>
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
  80014d:	e8 f3 19 00 00       	call   801b45 <sys_unlock_cons>
		//sys_unlock_cons();

		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 49 18 00 00       	call   8019aa <malloc>
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
  8001d5:	e8 51 19 00 00       	call   801b2b <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 0c 24 80 00       	push   $0x80240c
  8001e2:	e8 0b 08 00 00       	call   8009f2 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 56 19 00 00       	call   801b45 <sys_unlock_cons>
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
  80020c:	68 40 24 80 00       	push   $0x802440
  800211:	6a 54                	push   $0x54
  800213:	68 62 24 80 00       	push   $0x802462
  800218:	e8 18 05 00 00       	call   800735 <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 09 19 00 00       	call   801b2b <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 7c 24 80 00       	push   $0x80247c
  80022a:	e8 c3 07 00 00       	call   8009f2 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 b0 24 80 00       	push   $0x8024b0
  80023a:	e8 b3 07 00 00       	call   8009f2 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 e4 24 80 00       	push   $0x8024e4
  80024a:	e8 a3 07 00 00       	call   8009f2 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 ee 18 00 00       	call   801b45 <sys_unlock_cons>


		}

		//		sys_lock_cons();
		sys_lock_cons();
  800257:	e8 cf 18 00 00       	call   801b2b <sys_lock_cons>
		{
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 16 25 80 00       	push   $0x802516
  80026a:	e8 83 07 00 00       	call   8009f2 <cprintf>
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
  8002b0:	e8 90 18 00 00       	call   801b45 <sys_unlock_cons>
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
  800562:	68 60 23 80 00       	push   $0x802360
  800567:	e8 86 04 00 00       	call   8009f2 <cprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  80056f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	01 d0                	add    %edx,%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	50                   	push   %eax
  800584:	68 34 25 80 00       	push   $0x802534
  800589:	e8 64 04 00 00       	call   8009f2 <cprintf>
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
  8005b2:	68 39 25 80 00       	push   $0x802539
  8005b7:	e8 36 04 00 00       	call   8009f2 <cprintf>
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
  8005d6:	e8 9b 16 00 00       	call   801c76 <sys_cputc>
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
  8005e7:	e8 26 15 00 00       	call   801b12 <sys_cgetc>
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
  800604:	e8 9e 17 00 00       	call   801da7 <sys_getenvindex>
  800609:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80060c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	c1 e0 02             	shl    $0x2,%eax
  800614:	01 d0                	add    %edx,%eax
  800616:	01 c0                	add    %eax,%eax
  800618:	01 d0                	add    %edx,%eax
  80061a:	c1 e0 02             	shl    $0x2,%eax
  80061d:	01 d0                	add    %edx,%eax
  80061f:	01 c0                	add    %eax,%eax
  800621:	01 d0                	add    %edx,%eax
  800623:	c1 e0 04             	shl    $0x4,%eax
  800626:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80062b:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800630:	a1 08 30 80 00       	mov    0x803008,%eax
  800635:	8a 40 20             	mov    0x20(%eax),%al
  800638:	84 c0                	test   %al,%al
  80063a:	74 0d                	je     800649 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80063c:	a1 08 30 80 00       	mov    0x803008,%eax
  800641:	83 c0 20             	add    $0x20,%eax
  800644:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800649:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80064d:	7e 0a                	jle    800659 <libmain+0x5b>
		binaryname = argv[0];
  80064f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800659:	83 ec 08             	sub    $0x8,%esp
  80065c:	ff 75 0c             	pushl  0xc(%ebp)
  80065f:	ff 75 08             	pushl  0x8(%ebp)
  800662:	e8 d1 f9 ff ff       	call   800038 <_main>
  800667:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80066a:	e8 bc 14 00 00       	call   801b2b <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80066f:	83 ec 0c             	sub    $0xc,%esp
  800672:	68 58 25 80 00       	push   $0x802558
  800677:	e8 76 03 00 00       	call   8009f2 <cprintf>
  80067c:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80067f:	a1 08 30 80 00       	mov    0x803008,%eax
  800684:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80068a:	a1 08 30 80 00       	mov    0x803008,%eax
  80068f:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800695:	83 ec 04             	sub    $0x4,%esp
  800698:	52                   	push   %edx
  800699:	50                   	push   %eax
  80069a:	68 80 25 80 00       	push   $0x802580
  80069f:	e8 4e 03 00 00       	call   8009f2 <cprintf>
  8006a4:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006a7:	a1 08 30 80 00       	mov    0x803008,%eax
  8006ac:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8006b2:	a1 08 30 80 00       	mov    0x803008,%eax
  8006b7:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8006bd:	a1 08 30 80 00       	mov    0x803008,%eax
  8006c2:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8006c8:	51                   	push   %ecx
  8006c9:	52                   	push   %edx
  8006ca:	50                   	push   %eax
  8006cb:	68 a8 25 80 00       	push   $0x8025a8
  8006d0:	e8 1d 03 00 00       	call   8009f2 <cprintf>
  8006d5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006d8:	a1 08 30 80 00       	mov    0x803008,%eax
  8006dd:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	50                   	push   %eax
  8006e7:	68 00 26 80 00       	push   $0x802600
  8006ec:	e8 01 03 00 00       	call   8009f2 <cprintf>
  8006f1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006f4:	83 ec 0c             	sub    $0xc,%esp
  8006f7:	68 58 25 80 00       	push   $0x802558
  8006fc:	e8 f1 02 00 00       	call   8009f2 <cprintf>
  800701:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800704:	e8 3c 14 00 00       	call   801b45 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800709:	e8 19 00 00 00       	call   800727 <exit>
}
  80070e:	90                   	nop
  80070f:	c9                   	leave  
  800710:	c3                   	ret    

00800711 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800717:	83 ec 0c             	sub    $0xc,%esp
  80071a:	6a 00                	push   $0x0
  80071c:	e8 52 16 00 00       	call   801d73 <sys_destroy_env>
  800721:	83 c4 10             	add    $0x10,%esp
}
  800724:	90                   	nop
  800725:	c9                   	leave  
  800726:	c3                   	ret    

00800727 <exit>:

void
exit(void)
{
  800727:	55                   	push   %ebp
  800728:	89 e5                	mov    %esp,%ebp
  80072a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80072d:	e8 a7 16 00 00       	call   801dd9 <sys_exit_env>
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80073b:	8d 45 10             	lea    0x10(%ebp),%eax
  80073e:	83 c0 04             	add    $0x4,%eax
  800741:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800744:	a1 28 30 80 00       	mov    0x803028,%eax
  800749:	85 c0                	test   %eax,%eax
  80074b:	74 16                	je     800763 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80074d:	a1 28 30 80 00       	mov    0x803028,%eax
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	50                   	push   %eax
  800756:	68 14 26 80 00       	push   $0x802614
  80075b:	e8 92 02 00 00       	call   8009f2 <cprintf>
  800760:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800763:	a1 00 30 80 00       	mov    0x803000,%eax
  800768:	ff 75 0c             	pushl  0xc(%ebp)
  80076b:	ff 75 08             	pushl  0x8(%ebp)
  80076e:	50                   	push   %eax
  80076f:	68 19 26 80 00       	push   $0x802619
  800774:	e8 79 02 00 00       	call   8009f2 <cprintf>
  800779:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80077c:	8b 45 10             	mov    0x10(%ebp),%eax
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 f4             	pushl  -0xc(%ebp)
  800785:	50                   	push   %eax
  800786:	e8 fc 01 00 00       	call   800987 <vcprintf>
  80078b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	6a 00                	push   $0x0
  800793:	68 35 26 80 00       	push   $0x802635
  800798:	e8 ea 01 00 00       	call   800987 <vcprintf>
  80079d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007a0:	e8 82 ff ff ff       	call   800727 <exit>

	// should not return here
	while (1) ;
  8007a5:	eb fe                	jmp    8007a5 <_panic+0x70>

008007a7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
  8007aa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007ad:	a1 08 30 80 00       	mov    0x803008,%eax
  8007b2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8007b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 14                	je     8007d3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 38 26 80 00       	push   $0x802638
  8007c7:	6a 26                	push   $0x26
  8007c9:	68 84 26 80 00       	push   $0x802684
  8007ce:	e8 62 ff ff ff       	call   800735 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007e1:	e9 c5 00 00 00       	jmp    8008ab <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8007e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	01 d0                	add    %edx,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	85 c0                	test   %eax,%eax
  8007f9:	75 08                	jne    800803 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8007fb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007fe:	e9 a5 00 00 00       	jmp    8008a8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800803:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80080a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800811:	eb 69                	jmp    80087c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800813:	a1 08 30 80 00       	mov    0x803008,%eax
  800818:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80081e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800821:	89 d0                	mov    %edx,%eax
  800823:	01 c0                	add    %eax,%eax
  800825:	01 d0                	add    %edx,%eax
  800827:	c1 e0 03             	shl    $0x3,%eax
  80082a:	01 c8                	add    %ecx,%eax
  80082c:	8a 40 04             	mov    0x4(%eax),%al
  80082f:	84 c0                	test   %al,%al
  800831:	75 46                	jne    800879 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800833:	a1 08 30 80 00       	mov    0x803008,%eax
  800838:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80083e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800841:	89 d0                	mov    %edx,%eax
  800843:	01 c0                	add    %eax,%eax
  800845:	01 d0                	add    %edx,%eax
  800847:	c1 e0 03             	shl    $0x3,%eax
  80084a:	01 c8                	add    %ecx,%eax
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800851:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800854:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800859:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80085b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	01 c8                	add    %ecx,%eax
  80086a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80086c:	39 c2                	cmp    %eax,%edx
  80086e:	75 09                	jne    800879 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800870:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800877:	eb 15                	jmp    80088e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800879:	ff 45 e8             	incl   -0x18(%ebp)
  80087c:	a1 08 30 80 00       	mov    0x803008,%eax
  800881:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800887:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80088a:	39 c2                	cmp    %eax,%edx
  80088c:	77 85                	ja     800813 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80088e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800892:	75 14                	jne    8008a8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800894:	83 ec 04             	sub    $0x4,%esp
  800897:	68 90 26 80 00       	push   $0x802690
  80089c:	6a 3a                	push   $0x3a
  80089e:	68 84 26 80 00       	push   $0x802684
  8008a3:	e8 8d fe ff ff       	call   800735 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008a8:	ff 45 f0             	incl   -0x10(%ebp)
  8008ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008b1:	0f 8c 2f ff ff ff    	jl     8007e6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008c5:	eb 26                	jmp    8008ed <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008c7:	a1 08 30 80 00       	mov    0x803008,%eax
  8008cc:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8008d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008d5:	89 d0                	mov    %edx,%eax
  8008d7:	01 c0                	add    %eax,%eax
  8008d9:	01 d0                	add    %edx,%eax
  8008db:	c1 e0 03             	shl    $0x3,%eax
  8008de:	01 c8                	add    %ecx,%eax
  8008e0:	8a 40 04             	mov    0x4(%eax),%al
  8008e3:	3c 01                	cmp    $0x1,%al
  8008e5:	75 03                	jne    8008ea <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8008e7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008ea:	ff 45 e0             	incl   -0x20(%ebp)
  8008ed:	a1 08 30 80 00       	mov    0x803008,%eax
  8008f2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008fb:	39 c2                	cmp    %eax,%edx
  8008fd:	77 c8                	ja     8008c7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800902:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800905:	74 14                	je     80091b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800907:	83 ec 04             	sub    $0x4,%esp
  80090a:	68 e4 26 80 00       	push   $0x8026e4
  80090f:	6a 44                	push   $0x44
  800911:	68 84 26 80 00       	push   $0x802684
  800916:	e8 1a fe ff ff       	call   800735 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80091b:	90                   	nop
  80091c:	c9                   	leave  
  80091d:	c3                   	ret    

0080091e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	8b 00                	mov    (%eax),%eax
  800929:	8d 48 01             	lea    0x1(%eax),%ecx
  80092c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092f:	89 0a                	mov    %ecx,(%edx)
  800931:	8b 55 08             	mov    0x8(%ebp),%edx
  800934:	88 d1                	mov    %dl,%cl
  800936:	8b 55 0c             	mov    0xc(%ebp),%edx
  800939:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80093d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	3d ff 00 00 00       	cmp    $0xff,%eax
  800947:	75 2c                	jne    800975 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800949:	a0 0c 30 80 00       	mov    0x80300c,%al
  80094e:	0f b6 c0             	movzbl %al,%eax
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
  800954:	8b 12                	mov    (%edx),%edx
  800956:	89 d1                	mov    %edx,%ecx
  800958:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095b:	83 c2 08             	add    $0x8,%edx
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	50                   	push   %eax
  800962:	51                   	push   %ecx
  800963:	52                   	push   %edx
  800964:	e8 80 11 00 00       	call   801ae9 <sys_cputs>
  800969:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80096c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800975:	8b 45 0c             	mov    0xc(%ebp),%eax
  800978:	8b 40 04             	mov    0x4(%eax),%eax
  80097b:	8d 50 01             	lea    0x1(%eax),%edx
  80097e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800981:	89 50 04             	mov    %edx,0x4(%eax)
}
  800984:	90                   	nop
  800985:	c9                   	leave  
  800986:	c3                   	ret    

00800987 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800990:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800997:	00 00 00 
	b.cnt = 0;
  80099a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009a1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	ff 75 08             	pushl  0x8(%ebp)
  8009aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009b0:	50                   	push   %eax
  8009b1:	68 1e 09 80 00       	push   $0x80091e
  8009b6:	e8 11 02 00 00       	call   800bcc <vprintfmt>
  8009bb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009be:	a0 0c 30 80 00       	mov    0x80300c,%al
  8009c3:	0f b6 c0             	movzbl %al,%eax
  8009c6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009cc:	83 ec 04             	sub    $0x4,%esp
  8009cf:	50                   	push   %eax
  8009d0:	52                   	push   %edx
  8009d1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009d7:	83 c0 08             	add    $0x8,%eax
  8009da:	50                   	push   %eax
  8009db:	e8 09 11 00 00       	call   801ae9 <sys_cputs>
  8009e0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009e3:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  8009ea:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009f8:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  8009ff:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	83 ec 08             	sub    $0x8,%esp
  800a0b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a0e:	50                   	push   %eax
  800a0f:	e8 73 ff ff ff       	call   800987 <vcprintf>
  800a14:	83 c4 10             	add    $0x10,%esp
  800a17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a1d:	c9                   	leave  
  800a1e:	c3                   	ret    

00800a1f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a25:	e8 01 11 00 00       	call   801b2b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a2a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	ff 75 f4             	pushl  -0xc(%ebp)
  800a39:	50                   	push   %eax
  800a3a:	e8 48 ff ff ff       	call   800987 <vcprintf>
  800a3f:	83 c4 10             	add    $0x10,%esp
  800a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a45:	e8 fb 10 00 00       	call   801b45 <sys_unlock_cons>
	return cnt;
  800a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	53                   	push   %ebx
  800a53:	83 ec 14             	sub    $0x14,%esp
  800a56:	8b 45 10             	mov    0x10(%ebp),%eax
  800a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a62:	8b 45 18             	mov    0x18(%ebp),%eax
  800a65:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a6d:	77 55                	ja     800ac4 <printnum+0x75>
  800a6f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a72:	72 05                	jb     800a79 <printnum+0x2a>
  800a74:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a77:	77 4b                	ja     800ac4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a79:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a7c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a7f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a82:	ba 00 00 00 00       	mov    $0x0,%edx
  800a87:	52                   	push   %edx
  800a88:	50                   	push   %eax
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	ff 75 f0             	pushl  -0x10(%ebp)
  800a8f:	e8 54 16 00 00       	call   8020e8 <__udivdi3>
  800a94:	83 c4 10             	add    $0x10,%esp
  800a97:	83 ec 04             	sub    $0x4,%esp
  800a9a:	ff 75 20             	pushl  0x20(%ebp)
  800a9d:	53                   	push   %ebx
  800a9e:	ff 75 18             	pushl  0x18(%ebp)
  800aa1:	52                   	push   %edx
  800aa2:	50                   	push   %eax
  800aa3:	ff 75 0c             	pushl  0xc(%ebp)
  800aa6:	ff 75 08             	pushl  0x8(%ebp)
  800aa9:	e8 a1 ff ff ff       	call   800a4f <printnum>
  800aae:	83 c4 20             	add    $0x20,%esp
  800ab1:	eb 1a                	jmp    800acd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	ff 75 20             	pushl  0x20(%ebp)
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ac4:	ff 4d 1c             	decl   0x1c(%ebp)
  800ac7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800acb:	7f e6                	jg     800ab3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800acd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ad0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800adb:	53                   	push   %ebx
  800adc:	51                   	push   %ecx
  800add:	52                   	push   %edx
  800ade:	50                   	push   %eax
  800adf:	e8 14 17 00 00       	call   8021f8 <__umoddi3>
  800ae4:	83 c4 10             	add    $0x10,%esp
  800ae7:	05 54 29 80 00       	add    $0x802954,%eax
  800aec:	8a 00                	mov    (%eax),%al
  800aee:	0f be c0             	movsbl %al,%eax
  800af1:	83 ec 08             	sub    $0x8,%esp
  800af4:	ff 75 0c             	pushl  0xc(%ebp)
  800af7:	50                   	push   %eax
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	ff d0                	call   *%eax
  800afd:	83 c4 10             	add    $0x10,%esp
}
  800b00:	90                   	nop
  800b01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b04:	c9                   	leave  
  800b05:	c3                   	ret    

00800b06 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b09:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b0d:	7e 1c                	jle    800b2b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	8b 00                	mov    (%eax),%eax
  800b14:	8d 50 08             	lea    0x8(%eax),%edx
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	89 10                	mov    %edx,(%eax)
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	83 e8 08             	sub    $0x8,%eax
  800b24:	8b 50 04             	mov    0x4(%eax),%edx
  800b27:	8b 00                	mov    (%eax),%eax
  800b29:	eb 40                	jmp    800b6b <getuint+0x65>
	else if (lflag)
  800b2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b2f:	74 1e                	je     800b4f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8b 00                	mov    (%eax),%eax
  800b36:	8d 50 04             	lea    0x4(%eax),%edx
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	89 10                	mov    %edx,(%eax)
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	8b 00                	mov    (%eax),%eax
  800b43:	83 e8 04             	sub    $0x4,%eax
  800b46:	8b 00                	mov    (%eax),%eax
  800b48:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4d:	eb 1c                	jmp    800b6b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	8b 00                	mov    (%eax),%eax
  800b54:	8d 50 04             	lea    0x4(%eax),%edx
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	89 10                	mov    %edx,(%eax)
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	83 e8 04             	sub    $0x4,%eax
  800b64:	8b 00                	mov    (%eax),%eax
  800b66:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b6b:	5d                   	pop    %ebp
  800b6c:	c3                   	ret    

00800b6d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b70:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b74:	7e 1c                	jle    800b92 <getint+0x25>
		return va_arg(*ap, long long);
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 00                	mov    (%eax),%eax
  800b7b:	8d 50 08             	lea    0x8(%eax),%edx
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	89 10                	mov    %edx,(%eax)
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8b 00                	mov    (%eax),%eax
  800b88:	83 e8 08             	sub    $0x8,%eax
  800b8b:	8b 50 04             	mov    0x4(%eax),%edx
  800b8e:	8b 00                	mov    (%eax),%eax
  800b90:	eb 38                	jmp    800bca <getint+0x5d>
	else if (lflag)
  800b92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b96:	74 1a                	je     800bb2 <getint+0x45>
		return va_arg(*ap, long);
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8b 00                	mov    (%eax),%eax
  800b9d:	8d 50 04             	lea    0x4(%eax),%edx
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	89 10                	mov    %edx,(%eax)
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	8b 00                	mov    (%eax),%eax
  800baa:	83 e8 04             	sub    $0x4,%eax
  800bad:	8b 00                	mov    (%eax),%eax
  800baf:	99                   	cltd   
  800bb0:	eb 18                	jmp    800bca <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	8b 00                	mov    (%eax),%eax
  800bb7:	8d 50 04             	lea    0x4(%eax),%edx
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	89 10                	mov    %edx,(%eax)
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	8b 00                	mov    (%eax),%eax
  800bc4:	83 e8 04             	sub    $0x4,%eax
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	99                   	cltd   
}
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	56                   	push   %esi
  800bd0:	53                   	push   %ebx
  800bd1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd4:	eb 17                	jmp    800bed <vprintfmt+0x21>
			if (ch == '\0')
  800bd6:	85 db                	test   %ebx,%ebx
  800bd8:	0f 84 c1 03 00 00    	je     800f9f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800bde:	83 ec 08             	sub    $0x8,%esp
  800be1:	ff 75 0c             	pushl  0xc(%ebp)
  800be4:	53                   	push   %ebx
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	ff d0                	call   *%eax
  800bea:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bed:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf0:	8d 50 01             	lea    0x1(%eax),%edx
  800bf3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	0f b6 d8             	movzbl %al,%ebx
  800bfb:	83 fb 25             	cmp    $0x25,%ebx
  800bfe:	75 d6                	jne    800bd6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c00:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c04:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c0b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c12:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c19:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c20:	8b 45 10             	mov    0x10(%ebp),%eax
  800c23:	8d 50 01             	lea    0x1(%eax),%edx
  800c26:	89 55 10             	mov    %edx,0x10(%ebp)
  800c29:	8a 00                	mov    (%eax),%al
  800c2b:	0f b6 d8             	movzbl %al,%ebx
  800c2e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c31:	83 f8 5b             	cmp    $0x5b,%eax
  800c34:	0f 87 3d 03 00 00    	ja     800f77 <vprintfmt+0x3ab>
  800c3a:	8b 04 85 78 29 80 00 	mov    0x802978(,%eax,4),%eax
  800c41:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c43:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c47:	eb d7                	jmp    800c20 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c49:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c4d:	eb d1                	jmp    800c20 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c4f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c59:	89 d0                	mov    %edx,%eax
  800c5b:	c1 e0 02             	shl    $0x2,%eax
  800c5e:	01 d0                	add    %edx,%eax
  800c60:	01 c0                	add    %eax,%eax
  800c62:	01 d8                	add    %ebx,%eax
  800c64:	83 e8 30             	sub    $0x30,%eax
  800c67:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6d:	8a 00                	mov    (%eax),%al
  800c6f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c72:	83 fb 2f             	cmp    $0x2f,%ebx
  800c75:	7e 3e                	jle    800cb5 <vprintfmt+0xe9>
  800c77:	83 fb 39             	cmp    $0x39,%ebx
  800c7a:	7f 39                	jg     800cb5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c7c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c7f:	eb d5                	jmp    800c56 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c81:	8b 45 14             	mov    0x14(%ebp),%eax
  800c84:	83 c0 04             	add    $0x4,%eax
  800c87:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8d:	83 e8 04             	sub    $0x4,%eax
  800c90:	8b 00                	mov    (%eax),%eax
  800c92:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c95:	eb 1f                	jmp    800cb6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9b:	79 83                	jns    800c20 <vprintfmt+0x54>
				width = 0;
  800c9d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ca4:	e9 77 ff ff ff       	jmp    800c20 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ca9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cb0:	e9 6b ff ff ff       	jmp    800c20 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cb5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cb6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cba:	0f 89 60 ff ff ff    	jns    800c20 <vprintfmt+0x54>
				width = precision, precision = -1;
  800cc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cc6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ccd:	e9 4e ff ff ff       	jmp    800c20 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cd2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cd5:	e9 46 ff ff ff       	jmp    800c20 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cda:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdd:	83 c0 04             	add    $0x4,%eax
  800ce0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce6:	83 e8 04             	sub    $0x4,%eax
  800ce9:	8b 00                	mov    (%eax),%eax
  800ceb:	83 ec 08             	sub    $0x8,%esp
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	50                   	push   %eax
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	ff d0                	call   *%eax
  800cf7:	83 c4 10             	add    $0x10,%esp
			break;
  800cfa:	e9 9b 02 00 00       	jmp    800f9a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cff:	8b 45 14             	mov    0x14(%ebp),%eax
  800d02:	83 c0 04             	add    $0x4,%eax
  800d05:	89 45 14             	mov    %eax,0x14(%ebp)
  800d08:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0b:	83 e8 04             	sub    $0x4,%eax
  800d0e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d10:	85 db                	test   %ebx,%ebx
  800d12:	79 02                	jns    800d16 <vprintfmt+0x14a>
				err = -err;
  800d14:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d16:	83 fb 64             	cmp    $0x64,%ebx
  800d19:	7f 0b                	jg     800d26 <vprintfmt+0x15a>
  800d1b:	8b 34 9d c0 27 80 00 	mov    0x8027c0(,%ebx,4),%esi
  800d22:	85 f6                	test   %esi,%esi
  800d24:	75 19                	jne    800d3f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d26:	53                   	push   %ebx
  800d27:	68 65 29 80 00       	push   $0x802965
  800d2c:	ff 75 0c             	pushl  0xc(%ebp)
  800d2f:	ff 75 08             	pushl  0x8(%ebp)
  800d32:	e8 70 02 00 00       	call   800fa7 <printfmt>
  800d37:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d3a:	e9 5b 02 00 00       	jmp    800f9a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d3f:	56                   	push   %esi
  800d40:	68 6e 29 80 00       	push   $0x80296e
  800d45:	ff 75 0c             	pushl  0xc(%ebp)
  800d48:	ff 75 08             	pushl  0x8(%ebp)
  800d4b:	e8 57 02 00 00       	call   800fa7 <printfmt>
  800d50:	83 c4 10             	add    $0x10,%esp
			break;
  800d53:	e9 42 02 00 00       	jmp    800f9a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d58:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5b:	83 c0 04             	add    $0x4,%eax
  800d5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d61:	8b 45 14             	mov    0x14(%ebp),%eax
  800d64:	83 e8 04             	sub    $0x4,%eax
  800d67:	8b 30                	mov    (%eax),%esi
  800d69:	85 f6                	test   %esi,%esi
  800d6b:	75 05                	jne    800d72 <vprintfmt+0x1a6>
				p = "(null)";
  800d6d:	be 71 29 80 00       	mov    $0x802971,%esi
			if (width > 0 && padc != '-')
  800d72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d76:	7e 6d                	jle    800de5 <vprintfmt+0x219>
  800d78:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d7c:	74 67                	je     800de5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	50                   	push   %eax
  800d85:	56                   	push   %esi
  800d86:	e8 26 05 00 00       	call   8012b1 <strnlen>
  800d8b:	83 c4 10             	add    $0x10,%esp
  800d8e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d91:	eb 16                	jmp    800da9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d93:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	50                   	push   %eax
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	ff d0                	call   *%eax
  800da3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800da6:	ff 4d e4             	decl   -0x1c(%ebp)
  800da9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dad:	7f e4                	jg     800d93 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800daf:	eb 34                	jmp    800de5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800db1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800db5:	74 1c                	je     800dd3 <vprintfmt+0x207>
  800db7:	83 fb 1f             	cmp    $0x1f,%ebx
  800dba:	7e 05                	jle    800dc1 <vprintfmt+0x1f5>
  800dbc:	83 fb 7e             	cmp    $0x7e,%ebx
  800dbf:	7e 12                	jle    800dd3 <vprintfmt+0x207>
					putch('?', putdat);
  800dc1:	83 ec 08             	sub    $0x8,%esp
  800dc4:	ff 75 0c             	pushl  0xc(%ebp)
  800dc7:	6a 3f                	push   $0x3f
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	ff d0                	call   *%eax
  800dce:	83 c4 10             	add    $0x10,%esp
  800dd1:	eb 0f                	jmp    800de2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dd3:	83 ec 08             	sub    $0x8,%esp
  800dd6:	ff 75 0c             	pushl  0xc(%ebp)
  800dd9:	53                   	push   %ebx
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	ff d0                	call   *%eax
  800ddf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800de2:	ff 4d e4             	decl   -0x1c(%ebp)
  800de5:	89 f0                	mov    %esi,%eax
  800de7:	8d 70 01             	lea    0x1(%eax),%esi
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	0f be d8             	movsbl %al,%ebx
  800def:	85 db                	test   %ebx,%ebx
  800df1:	74 24                	je     800e17 <vprintfmt+0x24b>
  800df3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800df7:	78 b8                	js     800db1 <vprintfmt+0x1e5>
  800df9:	ff 4d e0             	decl   -0x20(%ebp)
  800dfc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e00:	79 af                	jns    800db1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e02:	eb 13                	jmp    800e17 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e04:	83 ec 08             	sub    $0x8,%esp
  800e07:	ff 75 0c             	pushl  0xc(%ebp)
  800e0a:	6a 20                	push   $0x20
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	ff d0                	call   *%eax
  800e11:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e14:	ff 4d e4             	decl   -0x1c(%ebp)
  800e17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e1b:	7f e7                	jg     800e04 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e1d:	e9 78 01 00 00       	jmp    800f9a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e22:	83 ec 08             	sub    $0x8,%esp
  800e25:	ff 75 e8             	pushl  -0x18(%ebp)
  800e28:	8d 45 14             	lea    0x14(%ebp),%eax
  800e2b:	50                   	push   %eax
  800e2c:	e8 3c fd ff ff       	call   800b6d <getint>
  800e31:	83 c4 10             	add    $0x10,%esp
  800e34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e37:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e40:	85 d2                	test   %edx,%edx
  800e42:	79 23                	jns    800e67 <vprintfmt+0x29b>
				putch('-', putdat);
  800e44:	83 ec 08             	sub    $0x8,%esp
  800e47:	ff 75 0c             	pushl  0xc(%ebp)
  800e4a:	6a 2d                	push   $0x2d
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	ff d0                	call   *%eax
  800e51:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5a:	f7 d8                	neg    %eax
  800e5c:	83 d2 00             	adc    $0x0,%edx
  800e5f:	f7 da                	neg    %edx
  800e61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e64:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e67:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e6e:	e9 bc 00 00 00       	jmp    800f2f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e73:	83 ec 08             	sub    $0x8,%esp
  800e76:	ff 75 e8             	pushl  -0x18(%ebp)
  800e79:	8d 45 14             	lea    0x14(%ebp),%eax
  800e7c:	50                   	push   %eax
  800e7d:	e8 84 fc ff ff       	call   800b06 <getuint>
  800e82:	83 c4 10             	add    $0x10,%esp
  800e85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e8b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e92:	e9 98 00 00 00       	jmp    800f2f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 58                	push   $0x58
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ea7:	83 ec 08             	sub    $0x8,%esp
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	6a 58                	push   $0x58
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	ff d0                	call   *%eax
  800eb4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800eb7:	83 ec 08             	sub    $0x8,%esp
  800eba:	ff 75 0c             	pushl  0xc(%ebp)
  800ebd:	6a 58                	push   $0x58
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	ff d0                	call   *%eax
  800ec4:	83 c4 10             	add    $0x10,%esp
			break;
  800ec7:	e9 ce 00 00 00       	jmp    800f9a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ecc:	83 ec 08             	sub    $0x8,%esp
  800ecf:	ff 75 0c             	pushl  0xc(%ebp)
  800ed2:	6a 30                	push   $0x30
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	ff d0                	call   *%eax
  800ed9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800edc:	83 ec 08             	sub    $0x8,%esp
  800edf:	ff 75 0c             	pushl  0xc(%ebp)
  800ee2:	6a 78                	push   $0x78
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	ff d0                	call   *%eax
  800ee9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800eec:	8b 45 14             	mov    0x14(%ebp),%eax
  800eef:	83 c0 04             	add    $0x4,%eax
  800ef2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ef5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef8:	83 e8 04             	sub    $0x4,%eax
  800efb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800efd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f0e:	eb 1f                	jmp    800f2f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f10:	83 ec 08             	sub    $0x8,%esp
  800f13:	ff 75 e8             	pushl  -0x18(%ebp)
  800f16:	8d 45 14             	lea    0x14(%ebp),%eax
  800f19:	50                   	push   %eax
  800f1a:	e8 e7 fb ff ff       	call   800b06 <getuint>
  800f1f:	83 c4 10             	add    $0x10,%esp
  800f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f25:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f28:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f2f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f36:	83 ec 04             	sub    $0x4,%esp
  800f39:	52                   	push   %edx
  800f3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f3d:	50                   	push   %eax
  800f3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f41:	ff 75 f0             	pushl  -0x10(%ebp)
  800f44:	ff 75 0c             	pushl  0xc(%ebp)
  800f47:	ff 75 08             	pushl  0x8(%ebp)
  800f4a:	e8 00 fb ff ff       	call   800a4f <printnum>
  800f4f:	83 c4 20             	add    $0x20,%esp
			break;
  800f52:	eb 46                	jmp    800f9a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f54:	83 ec 08             	sub    $0x8,%esp
  800f57:	ff 75 0c             	pushl  0xc(%ebp)
  800f5a:	53                   	push   %ebx
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	ff d0                	call   *%eax
  800f60:	83 c4 10             	add    $0x10,%esp
			break;
  800f63:	eb 35                	jmp    800f9a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f65:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800f6c:	eb 2c                	jmp    800f9a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f6e:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800f75:	eb 23                	jmp    800f9a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f77:	83 ec 08             	sub    $0x8,%esp
  800f7a:	ff 75 0c             	pushl  0xc(%ebp)
  800f7d:	6a 25                	push   $0x25
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	ff d0                	call   *%eax
  800f84:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f87:	ff 4d 10             	decl   0x10(%ebp)
  800f8a:	eb 03                	jmp    800f8f <vprintfmt+0x3c3>
  800f8c:	ff 4d 10             	decl   0x10(%ebp)
  800f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f92:	48                   	dec    %eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	3c 25                	cmp    $0x25,%al
  800f97:	75 f3                	jne    800f8c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800f99:	90                   	nop
		}
	}
  800f9a:	e9 35 fc ff ff       	jmp    800bd4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f9f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fa3:	5b                   	pop    %ebx
  800fa4:	5e                   	pop    %esi
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    

00800fa7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fad:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb0:	83 c0 04             	add    $0x4,%eax
  800fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbc:	50                   	push   %eax
  800fbd:	ff 75 0c             	pushl  0xc(%ebp)
  800fc0:	ff 75 08             	pushl  0x8(%ebp)
  800fc3:	e8 04 fc ff ff       	call   800bcc <vprintfmt>
  800fc8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fcb:	90                   	nop
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	8b 40 08             	mov    0x8(%eax),%eax
  800fd7:	8d 50 01             	lea    0x1(%eax),%edx
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe3:	8b 10                	mov    (%eax),%edx
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	8b 40 04             	mov    0x4(%eax),%eax
  800feb:	39 c2                	cmp    %eax,%edx
  800fed:	73 12                	jae    801001 <sprintputch+0x33>
		*b->buf++ = ch;
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	8b 00                	mov    (%eax),%eax
  800ff4:	8d 48 01             	lea    0x1(%eax),%ecx
  800ff7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffa:	89 0a                	mov    %ecx,(%edx)
  800ffc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fff:	88 10                	mov    %dl,(%eax)
}
  801001:	90                   	nop
  801002:	5d                   	pop    %ebp
  801003:	c3                   	ret    

00801004 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	8d 50 ff             	lea    -0x1(%eax),%edx
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	01 d0                	add    %edx,%eax
  80101b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80101e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801025:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801029:	74 06                	je     801031 <vsnprintf+0x2d>
  80102b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102f:	7f 07                	jg     801038 <vsnprintf+0x34>
		return -E_INVAL;
  801031:	b8 03 00 00 00       	mov    $0x3,%eax
  801036:	eb 20                	jmp    801058 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801038:	ff 75 14             	pushl  0x14(%ebp)
  80103b:	ff 75 10             	pushl  0x10(%ebp)
  80103e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801041:	50                   	push   %eax
  801042:	68 ce 0f 80 00       	push   $0x800fce
  801047:	e8 80 fb ff ff       	call   800bcc <vprintfmt>
  80104c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80104f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801052:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801055:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801060:	8d 45 10             	lea    0x10(%ebp),%eax
  801063:	83 c0 04             	add    $0x4,%eax
  801066:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801069:	8b 45 10             	mov    0x10(%ebp),%eax
  80106c:	ff 75 f4             	pushl  -0xc(%ebp)
  80106f:	50                   	push   %eax
  801070:	ff 75 0c             	pushl  0xc(%ebp)
  801073:	ff 75 08             	pushl  0x8(%ebp)
  801076:	e8 89 ff ff ff       	call   801004 <vsnprintf>
  80107b:	83 c4 10             	add    $0x10,%esp
  80107e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801081:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801084:	c9                   	leave  
  801085:	c3                   	ret    

00801086 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80108c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801090:	74 13                	je     8010a5 <readline+0x1f>
		cprintf("%s", prompt);
  801092:	83 ec 08             	sub    $0x8,%esp
  801095:	ff 75 08             	pushl  0x8(%ebp)
  801098:	68 e8 2a 80 00       	push   $0x802ae8
  80109d:	e8 50 f9 ff ff       	call   8009f2 <cprintf>
  8010a2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010ac:	83 ec 0c             	sub    $0xc,%esp
  8010af:	6a 00                	push   $0x0
  8010b1:	e8 3e f5 ff ff       	call   8005f4 <iscons>
  8010b6:	83 c4 10             	add    $0x10,%esp
  8010b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010bc:	e8 20 f5 ff ff       	call   8005e1 <getchar>
  8010c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010c8:	79 22                	jns    8010ec <readline+0x66>
			if (c != -E_EOF)
  8010ca:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010ce:	0f 84 ad 00 00 00    	je     801181 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010d4:	83 ec 08             	sub    $0x8,%esp
  8010d7:	ff 75 ec             	pushl  -0x14(%ebp)
  8010da:	68 eb 2a 80 00       	push   $0x802aeb
  8010df:	e8 0e f9 ff ff       	call   8009f2 <cprintf>
  8010e4:	83 c4 10             	add    $0x10,%esp
			break;
  8010e7:	e9 95 00 00 00       	jmp    801181 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010ec:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010f0:	7e 34                	jle    801126 <readline+0xa0>
  8010f2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8010f9:	7f 2b                	jg     801126 <readline+0xa0>
			if (echoing)
  8010fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010ff:	74 0e                	je     80110f <readline+0x89>
				cputchar(c);
  801101:	83 ec 0c             	sub    $0xc,%esp
  801104:	ff 75 ec             	pushl  -0x14(%ebp)
  801107:	e8 b6 f4 ff ff       	call   8005c2 <cputchar>
  80110c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80110f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801112:	8d 50 01             	lea    0x1(%eax),%edx
  801115:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801118:	89 c2                	mov    %eax,%edx
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	01 d0                	add    %edx,%eax
  80111f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801122:	88 10                	mov    %dl,(%eax)
  801124:	eb 56                	jmp    80117c <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801126:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80112a:	75 1f                	jne    80114b <readline+0xc5>
  80112c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801130:	7e 19                	jle    80114b <readline+0xc5>
			if (echoing)
  801132:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801136:	74 0e                	je     801146 <readline+0xc0>
				cputchar(c);
  801138:	83 ec 0c             	sub    $0xc,%esp
  80113b:	ff 75 ec             	pushl  -0x14(%ebp)
  80113e:	e8 7f f4 ff ff       	call   8005c2 <cputchar>
  801143:	83 c4 10             	add    $0x10,%esp

			i--;
  801146:	ff 4d f4             	decl   -0xc(%ebp)
  801149:	eb 31                	jmp    80117c <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80114b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80114f:	74 0a                	je     80115b <readline+0xd5>
  801151:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801155:	0f 85 61 ff ff ff    	jne    8010bc <readline+0x36>
			if (echoing)
  80115b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80115f:	74 0e                	je     80116f <readline+0xe9>
				cputchar(c);
  801161:	83 ec 0c             	sub    $0xc,%esp
  801164:	ff 75 ec             	pushl  -0x14(%ebp)
  801167:	e8 56 f4 ff ff       	call   8005c2 <cputchar>
  80116c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80116f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	01 d0                	add    %edx,%eax
  801177:	c6 00 00             	movb   $0x0,(%eax)
			break;
  80117a:	eb 06                	jmp    801182 <readline+0xfc>
		}
	}
  80117c:	e9 3b ff ff ff       	jmp    8010bc <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801181:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801182:	90                   	nop
  801183:	c9                   	leave  
  801184:	c3                   	ret    

00801185 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
  801188:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  80118b:	e8 9b 09 00 00       	call   801b2b <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801190:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801194:	74 13                	je     8011a9 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801196:	83 ec 08             	sub    $0x8,%esp
  801199:	ff 75 08             	pushl  0x8(%ebp)
  80119c:	68 e8 2a 80 00       	push   $0x802ae8
  8011a1:	e8 4c f8 ff ff       	call   8009f2 <cprintf>
  8011a6:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8011a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8011b0:	83 ec 0c             	sub    $0xc,%esp
  8011b3:	6a 00                	push   $0x0
  8011b5:	e8 3a f4 ff ff       	call   8005f4 <iscons>
  8011ba:	83 c4 10             	add    $0x10,%esp
  8011bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8011c0:	e8 1c f4 ff ff       	call   8005e1 <getchar>
  8011c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8011c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011cc:	79 22                	jns    8011f0 <atomic_readline+0x6b>
				if (c != -E_EOF)
  8011ce:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011d2:	0f 84 ad 00 00 00    	je     801285 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8011d8:	83 ec 08             	sub    $0x8,%esp
  8011db:	ff 75 ec             	pushl  -0x14(%ebp)
  8011de:	68 eb 2a 80 00       	push   $0x802aeb
  8011e3:	e8 0a f8 ff ff       	call   8009f2 <cprintf>
  8011e8:	83 c4 10             	add    $0x10,%esp
				break;
  8011eb:	e9 95 00 00 00       	jmp    801285 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8011f0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011f4:	7e 34                	jle    80122a <atomic_readline+0xa5>
  8011f6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011fd:	7f 2b                	jg     80122a <atomic_readline+0xa5>
				if (echoing)
  8011ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801203:	74 0e                	je     801213 <atomic_readline+0x8e>
					cputchar(c);
  801205:	83 ec 0c             	sub    $0xc,%esp
  801208:	ff 75 ec             	pushl  -0x14(%ebp)
  80120b:	e8 b2 f3 ff ff       	call   8005c2 <cputchar>
  801210:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801216:	8d 50 01             	lea    0x1(%eax),%edx
  801219:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80121c:	89 c2                	mov    %eax,%edx
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	01 d0                	add    %edx,%eax
  801223:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801226:	88 10                	mov    %dl,(%eax)
  801228:	eb 56                	jmp    801280 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80122a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80122e:	75 1f                	jne    80124f <atomic_readline+0xca>
  801230:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801234:	7e 19                	jle    80124f <atomic_readline+0xca>
				if (echoing)
  801236:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80123a:	74 0e                	je     80124a <atomic_readline+0xc5>
					cputchar(c);
  80123c:	83 ec 0c             	sub    $0xc,%esp
  80123f:	ff 75 ec             	pushl  -0x14(%ebp)
  801242:	e8 7b f3 ff ff       	call   8005c2 <cputchar>
  801247:	83 c4 10             	add    $0x10,%esp
				i--;
  80124a:	ff 4d f4             	decl   -0xc(%ebp)
  80124d:	eb 31                	jmp    801280 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80124f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801253:	74 0a                	je     80125f <atomic_readline+0xda>
  801255:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801259:	0f 85 61 ff ff ff    	jne    8011c0 <atomic_readline+0x3b>
				if (echoing)
  80125f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801263:	74 0e                	je     801273 <atomic_readline+0xee>
					cputchar(c);
  801265:	83 ec 0c             	sub    $0xc,%esp
  801268:	ff 75 ec             	pushl  -0x14(%ebp)
  80126b:	e8 52 f3 ff ff       	call   8005c2 <cputchar>
  801270:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801273:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	01 d0                	add    %edx,%eax
  80127b:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80127e:	eb 06                	jmp    801286 <atomic_readline+0x101>
			}
		}
  801280:	e9 3b ff ff ff       	jmp    8011c0 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801285:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801286:	e8 ba 08 00 00       	call   801b45 <sys_unlock_cons>
}
  80128b:	90                   	nop
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    

0080128e <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801294:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80129b:	eb 06                	jmp    8012a3 <strlen+0x15>
		n++;
  80129d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012a0:	ff 45 08             	incl   0x8(%ebp)
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	84 c0                	test   %al,%al
  8012aa:	75 f1                	jne    80129d <strlen+0xf>
		n++;
	return n;
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012be:	eb 09                	jmp    8012c9 <strnlen+0x18>
		n++;
  8012c0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012c3:	ff 45 08             	incl   0x8(%ebp)
  8012c6:	ff 4d 0c             	decl   0xc(%ebp)
  8012c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012cd:	74 09                	je     8012d8 <strnlen+0x27>
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	84 c0                	test   %al,%al
  8012d6:	75 e8                	jne    8012c0 <strnlen+0xf>
		n++;
	return n;
  8012d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012db:	c9                   	leave  
  8012dc:	c3                   	ret    

008012dd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012e9:	90                   	nop
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8d 50 01             	lea    0x1(%eax),%edx
  8012f0:	89 55 08             	mov    %edx,0x8(%ebp)
  8012f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012f9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012fc:	8a 12                	mov    (%edx),%dl
  8012fe:	88 10                	mov    %dl,(%eax)
  801300:	8a 00                	mov    (%eax),%al
  801302:	84 c0                	test   %al,%al
  801304:	75 e4                	jne    8012ea <strcpy+0xd>
		/* do nothing */;
	return ret;
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801317:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80131e:	eb 1f                	jmp    80133f <strncpy+0x34>
		*dst++ = *src;
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	8d 50 01             	lea    0x1(%eax),%edx
  801326:	89 55 08             	mov    %edx,0x8(%ebp)
  801329:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132c:	8a 12                	mov    (%edx),%dl
  80132e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801330:	8b 45 0c             	mov    0xc(%ebp),%eax
  801333:	8a 00                	mov    (%eax),%al
  801335:	84 c0                	test   %al,%al
  801337:	74 03                	je     80133c <strncpy+0x31>
			src++;
  801339:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80133c:	ff 45 fc             	incl   -0x4(%ebp)
  80133f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801342:	3b 45 10             	cmp    0x10(%ebp),%eax
  801345:	72 d9                	jb     801320 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801347:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801358:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80135c:	74 30                	je     80138e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80135e:	eb 16                	jmp    801376 <strlcpy+0x2a>
			*dst++ = *src++;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	8d 50 01             	lea    0x1(%eax),%edx
  801366:	89 55 08             	mov    %edx,0x8(%ebp)
  801369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80136f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801372:	8a 12                	mov    (%edx),%dl
  801374:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801376:	ff 4d 10             	decl   0x10(%ebp)
  801379:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137d:	74 09                	je     801388 <strlcpy+0x3c>
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	84 c0                	test   %al,%al
  801386:	75 d8                	jne    801360 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80138e:	8b 55 08             	mov    0x8(%ebp),%edx
  801391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801394:	29 c2                	sub    %eax,%edx
  801396:	89 d0                	mov    %edx,%eax
}
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80139d:	eb 06                	jmp    8013a5 <strcmp+0xb>
		p++, q++;
  80139f:	ff 45 08             	incl   0x8(%ebp)
  8013a2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	84 c0                	test   %al,%al
  8013ac:	74 0e                	je     8013bc <strcmp+0x22>
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 10                	mov    (%eax),%dl
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	8a 00                	mov    (%eax),%al
  8013b8:	38 c2                	cmp    %al,%dl
  8013ba:	74 e3                	je     80139f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	8a 00                	mov    (%eax),%al
  8013c1:	0f b6 d0             	movzbl %al,%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	8a 00                	mov    (%eax),%al
  8013c9:	0f b6 c0             	movzbl %al,%eax
  8013cc:	29 c2                	sub    %eax,%edx
  8013ce:	89 d0                	mov    %edx,%eax
}
  8013d0:	5d                   	pop    %ebp
  8013d1:	c3                   	ret    

008013d2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013d5:	eb 09                	jmp    8013e0 <strncmp+0xe>
		n--, p++, q++;
  8013d7:	ff 4d 10             	decl   0x10(%ebp)
  8013da:	ff 45 08             	incl   0x8(%ebp)
  8013dd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e4:	74 17                	je     8013fd <strncmp+0x2b>
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	84 c0                	test   %al,%al
  8013ed:	74 0e                	je     8013fd <strncmp+0x2b>
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8a 10                	mov    (%eax),%dl
  8013f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	38 c2                	cmp    %al,%dl
  8013fb:	74 da                	je     8013d7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801401:	75 07                	jne    80140a <strncmp+0x38>
		return 0;
  801403:	b8 00 00 00 00       	mov    $0x0,%eax
  801408:	eb 14                	jmp    80141e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80140a:	8b 45 08             	mov    0x8(%ebp),%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	0f b6 d0             	movzbl %al,%edx
  801412:	8b 45 0c             	mov    0xc(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	0f b6 c0             	movzbl %al,%eax
  80141a:	29 c2                	sub    %eax,%edx
  80141c:	89 d0                	mov    %edx,%eax
}
  80141e:	5d                   	pop    %ebp
  80141f:	c3                   	ret    

00801420 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	83 ec 04             	sub    $0x4,%esp
  801426:	8b 45 0c             	mov    0xc(%ebp),%eax
  801429:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80142c:	eb 12                	jmp    801440 <strchr+0x20>
		if (*s == c)
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8a 00                	mov    (%eax),%al
  801433:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801436:	75 05                	jne    80143d <strchr+0x1d>
			return (char *) s;
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	eb 11                	jmp    80144e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80143d:	ff 45 08             	incl   0x8(%ebp)
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	84 c0                	test   %al,%al
  801447:	75 e5                	jne    80142e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801449:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 04             	sub    $0x4,%esp
  801456:	8b 45 0c             	mov    0xc(%ebp),%eax
  801459:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80145c:	eb 0d                	jmp    80146b <strfind+0x1b>
		if (*s == c)
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	8a 00                	mov    (%eax),%al
  801463:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801466:	74 0e                	je     801476 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801468:	ff 45 08             	incl   0x8(%ebp)
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	84 c0                	test   %al,%al
  801472:	75 ea                	jne    80145e <strfind+0xe>
  801474:	eb 01                	jmp    801477 <strfind+0x27>
		if (*s == c)
			break;
  801476:	90                   	nop
	return (char *) s;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801488:	8b 45 10             	mov    0x10(%ebp),%eax
  80148b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80148e:	eb 0e                	jmp    80149e <memset+0x22>
		*p++ = c;
  801490:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801493:	8d 50 01             	lea    0x1(%eax),%edx
  801496:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80149e:	ff 4d f8             	decl   -0x8(%ebp)
  8014a1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014a5:	79 e9                	jns    801490 <memset+0x14>
		*p++ = c;

	return v;
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014be:	eb 16                	jmp    8014d6 <memcpy+0x2a>
		*d++ = *s++;
  8014c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c3:	8d 50 01             	lea    0x1(%eax),%edx
  8014c6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014cf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014d2:	8a 12                	mov    (%edx),%dl
  8014d4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	75 dd                	jne    8014c0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801500:	73 50                	jae    801552 <memmove+0x6a>
  801502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801505:	8b 45 10             	mov    0x10(%ebp),%eax
  801508:	01 d0                	add    %edx,%eax
  80150a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80150d:	76 43                	jbe    801552 <memmove+0x6a>
		s += n;
  80150f:	8b 45 10             	mov    0x10(%ebp),%eax
  801512:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80151b:	eb 10                	jmp    80152d <memmove+0x45>
			*--d = *--s;
  80151d:	ff 4d f8             	decl   -0x8(%ebp)
  801520:	ff 4d fc             	decl   -0x4(%ebp)
  801523:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801526:	8a 10                	mov    (%eax),%dl
  801528:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80152d:	8b 45 10             	mov    0x10(%ebp),%eax
  801530:	8d 50 ff             	lea    -0x1(%eax),%edx
  801533:	89 55 10             	mov    %edx,0x10(%ebp)
  801536:	85 c0                	test   %eax,%eax
  801538:	75 e3                	jne    80151d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80153a:	eb 23                	jmp    80155f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80153c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153f:	8d 50 01             	lea    0x1(%eax),%edx
  801542:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801545:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801548:	8d 4a 01             	lea    0x1(%edx),%ecx
  80154b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80154e:	8a 12                	mov    (%edx),%dl
  801550:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801552:	8b 45 10             	mov    0x10(%ebp),%eax
  801555:	8d 50 ff             	lea    -0x1(%eax),%edx
  801558:	89 55 10             	mov    %edx,0x10(%ebp)
  80155b:	85 c0                	test   %eax,%eax
  80155d:	75 dd                	jne    80153c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801570:	8b 45 0c             	mov    0xc(%ebp),%eax
  801573:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801576:	eb 2a                	jmp    8015a2 <memcmp+0x3e>
		if (*s1 != *s2)
  801578:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80157b:	8a 10                	mov    (%eax),%dl
  80157d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801580:	8a 00                	mov    (%eax),%al
  801582:	38 c2                	cmp    %al,%dl
  801584:	74 16                	je     80159c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801586:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801589:	8a 00                	mov    (%eax),%al
  80158b:	0f b6 d0             	movzbl %al,%edx
  80158e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801591:	8a 00                	mov    (%eax),%al
  801593:	0f b6 c0             	movzbl %al,%eax
  801596:	29 c2                	sub    %eax,%edx
  801598:	89 d0                	mov    %edx,%eax
  80159a:	eb 18                	jmp    8015b4 <memcmp+0x50>
		s1++, s2++;
  80159c:	ff 45 fc             	incl   -0x4(%ebp)
  80159f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ab:	85 c0                	test   %eax,%eax
  8015ad:	75 c9                	jne    801578 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8015bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c2:	01 d0                	add    %edx,%eax
  8015c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015c7:	eb 15                	jmp    8015de <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8a 00                	mov    (%eax),%al
  8015ce:	0f b6 d0             	movzbl %al,%edx
  8015d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d4:	0f b6 c0             	movzbl %al,%eax
  8015d7:	39 c2                	cmp    %eax,%edx
  8015d9:	74 0d                	je     8015e8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015db:	ff 45 08             	incl   0x8(%ebp)
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015e4:	72 e3                	jb     8015c9 <memfind+0x13>
  8015e6:	eb 01                	jmp    8015e9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015e8:	90                   	nop
	return (void *) s;
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801602:	eb 03                	jmp    801607 <strtol+0x19>
		s++;
  801604:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	3c 20                	cmp    $0x20,%al
  80160e:	74 f4                	je     801604 <strtol+0x16>
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	8a 00                	mov    (%eax),%al
  801615:	3c 09                	cmp    $0x9,%al
  801617:	74 eb                	je     801604 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8a 00                	mov    (%eax),%al
  80161e:	3c 2b                	cmp    $0x2b,%al
  801620:	75 05                	jne    801627 <strtol+0x39>
		s++;
  801622:	ff 45 08             	incl   0x8(%ebp)
  801625:	eb 13                	jmp    80163a <strtol+0x4c>
	else if (*s == '-')
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	8a 00                	mov    (%eax),%al
  80162c:	3c 2d                	cmp    $0x2d,%al
  80162e:	75 0a                	jne    80163a <strtol+0x4c>
		s++, neg = 1;
  801630:	ff 45 08             	incl   0x8(%ebp)
  801633:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80163a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163e:	74 06                	je     801646 <strtol+0x58>
  801640:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801644:	75 20                	jne    801666 <strtol+0x78>
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	3c 30                	cmp    $0x30,%al
  80164d:	75 17                	jne    801666 <strtol+0x78>
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	40                   	inc    %eax
  801653:	8a 00                	mov    (%eax),%al
  801655:	3c 78                	cmp    $0x78,%al
  801657:	75 0d                	jne    801666 <strtol+0x78>
		s += 2, base = 16;
  801659:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80165d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801664:	eb 28                	jmp    80168e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801666:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80166a:	75 15                	jne    801681 <strtol+0x93>
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	8a 00                	mov    (%eax),%al
  801671:	3c 30                	cmp    $0x30,%al
  801673:	75 0c                	jne    801681 <strtol+0x93>
		s++, base = 8;
  801675:	ff 45 08             	incl   0x8(%ebp)
  801678:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80167f:	eb 0d                	jmp    80168e <strtol+0xa0>
	else if (base == 0)
  801681:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801685:	75 07                	jne    80168e <strtol+0xa0>
		base = 10;
  801687:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	8a 00                	mov    (%eax),%al
  801693:	3c 2f                	cmp    $0x2f,%al
  801695:	7e 19                	jle    8016b0 <strtol+0xc2>
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	8a 00                	mov    (%eax),%al
  80169c:	3c 39                	cmp    $0x39,%al
  80169e:	7f 10                	jg     8016b0 <strtol+0xc2>
			dig = *s - '0';
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	8a 00                	mov    (%eax),%al
  8016a5:	0f be c0             	movsbl %al,%eax
  8016a8:	83 e8 30             	sub    $0x30,%eax
  8016ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ae:	eb 42                	jmp    8016f2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	3c 60                	cmp    $0x60,%al
  8016b7:	7e 19                	jle    8016d2 <strtol+0xe4>
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	3c 7a                	cmp    $0x7a,%al
  8016c0:	7f 10                	jg     8016d2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8a 00                	mov    (%eax),%al
  8016c7:	0f be c0             	movsbl %al,%eax
  8016ca:	83 e8 57             	sub    $0x57,%eax
  8016cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d0:	eb 20                	jmp    8016f2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 00                	mov    (%eax),%al
  8016d7:	3c 40                	cmp    $0x40,%al
  8016d9:	7e 39                	jle    801714 <strtol+0x126>
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8a 00                	mov    (%eax),%al
  8016e0:	3c 5a                	cmp    $0x5a,%al
  8016e2:	7f 30                	jg     801714 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	8a 00                	mov    (%eax),%al
  8016e9:	0f be c0             	movsbl %al,%eax
  8016ec:	83 e8 37             	sub    $0x37,%eax
  8016ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016f8:	7d 19                	jge    801713 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016fa:	ff 45 08             	incl   0x8(%ebp)
  8016fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801700:	0f af 45 10          	imul   0x10(%ebp),%eax
  801704:	89 c2                	mov    %eax,%edx
  801706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801709:	01 d0                	add    %edx,%eax
  80170b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80170e:	e9 7b ff ff ff       	jmp    80168e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801713:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801714:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801718:	74 08                	je     801722 <strtol+0x134>
		*endptr = (char *) s;
  80171a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171d:	8b 55 08             	mov    0x8(%ebp),%edx
  801720:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801722:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801726:	74 07                	je     80172f <strtol+0x141>
  801728:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172b:	f7 d8                	neg    %eax
  80172d:	eb 03                	jmp    801732 <strtol+0x144>
  80172f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <ltostr>:

void
ltostr(long value, char *str)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80173a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801741:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801748:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80174c:	79 13                	jns    801761 <ltostr+0x2d>
	{
		neg = 1;
  80174e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801755:	8b 45 0c             	mov    0xc(%ebp),%eax
  801758:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80175b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80175e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801769:	99                   	cltd   
  80176a:	f7 f9                	idiv   %ecx
  80176c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80176f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801772:	8d 50 01             	lea    0x1(%eax),%edx
  801775:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801778:	89 c2                	mov    %eax,%edx
  80177a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177d:	01 d0                	add    %edx,%eax
  80177f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801782:	83 c2 30             	add    $0x30,%edx
  801785:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801787:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80178a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80178f:	f7 e9                	imul   %ecx
  801791:	c1 fa 02             	sar    $0x2,%edx
  801794:	89 c8                	mov    %ecx,%eax
  801796:	c1 f8 1f             	sar    $0x1f,%eax
  801799:	29 c2                	sub    %eax,%edx
  80179b:	89 d0                	mov    %edx,%eax
  80179d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8017a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017a4:	75 bb                	jne    801761 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b0:	48                   	dec    %eax
  8017b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017b8:	74 3d                	je     8017f7 <ltostr+0xc3>
		start = 1 ;
  8017ba:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017c1:	eb 34                	jmp    8017f7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	01 d0                	add    %edx,%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d6:	01 c2                	add    %eax,%edx
  8017d8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017de:	01 c8                	add    %ecx,%eax
  8017e0:	8a 00                	mov    (%eax),%al
  8017e2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ea:	01 c2                	add    %eax,%edx
  8017ec:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017ef:	88 02                	mov    %al,(%edx)
		start++ ;
  8017f1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017f4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017fd:	7c c4                	jl     8017c3 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017ff:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801802:	8b 45 0c             	mov    0xc(%ebp),%eax
  801805:	01 d0                	add    %edx,%eax
  801807:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80180a:	90                   	nop
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	e8 73 fa ff ff       	call   80128e <strlen>
  80181b:	83 c4 04             	add    $0x4,%esp
  80181e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801821:	ff 75 0c             	pushl  0xc(%ebp)
  801824:	e8 65 fa ff ff       	call   80128e <strlen>
  801829:	83 c4 04             	add    $0x4,%esp
  80182c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80182f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801836:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80183d:	eb 17                	jmp    801856 <strcconcat+0x49>
		final[s] = str1[s] ;
  80183f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801842:	8b 45 10             	mov    0x10(%ebp),%eax
  801845:	01 c2                	add    %eax,%edx
  801847:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	01 c8                	add    %ecx,%eax
  80184f:	8a 00                	mov    (%eax),%al
  801851:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801853:	ff 45 fc             	incl   -0x4(%ebp)
  801856:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801859:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80185c:	7c e1                	jl     80183f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80185e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801865:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80186c:	eb 1f                	jmp    80188d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80186e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801871:	8d 50 01             	lea    0x1(%eax),%edx
  801874:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801877:	89 c2                	mov    %eax,%edx
  801879:	8b 45 10             	mov    0x10(%ebp),%eax
  80187c:	01 c2                	add    %eax,%edx
  80187e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801881:	8b 45 0c             	mov    0xc(%ebp),%eax
  801884:	01 c8                	add    %ecx,%eax
  801886:	8a 00                	mov    (%eax),%al
  801888:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80188a:	ff 45 f8             	incl   -0x8(%ebp)
  80188d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801890:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801893:	7c d9                	jl     80186e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801895:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801898:	8b 45 10             	mov    0x10(%ebp),%eax
  80189b:	01 d0                	add    %edx,%eax
  80189d:	c6 00 00             	movb   $0x0,(%eax)
}
  8018a0:	90                   	nop
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018af:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b2:	8b 00                	mov    (%eax),%eax
  8018b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018be:	01 d0                	add    %edx,%eax
  8018c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018c6:	eb 0c                	jmp    8018d4 <strsplit+0x31>
			*string++ = 0;
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	8d 50 01             	lea    0x1(%eax),%edx
  8018ce:	89 55 08             	mov    %edx,0x8(%ebp)
  8018d1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	8a 00                	mov    (%eax),%al
  8018d9:	84 c0                	test   %al,%al
  8018db:	74 18                	je     8018f5 <strsplit+0x52>
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	8a 00                	mov    (%eax),%al
  8018e2:	0f be c0             	movsbl %al,%eax
  8018e5:	50                   	push   %eax
  8018e6:	ff 75 0c             	pushl  0xc(%ebp)
  8018e9:	e8 32 fb ff ff       	call   801420 <strchr>
  8018ee:	83 c4 08             	add    $0x8,%esp
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	75 d3                	jne    8018c8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	8a 00                	mov    (%eax),%al
  8018fa:	84 c0                	test   %al,%al
  8018fc:	74 5a                	je     801958 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801901:	8b 00                	mov    (%eax),%eax
  801903:	83 f8 0f             	cmp    $0xf,%eax
  801906:	75 07                	jne    80190f <strsplit+0x6c>
		{
			return 0;
  801908:	b8 00 00 00 00       	mov    $0x0,%eax
  80190d:	eb 66                	jmp    801975 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80190f:	8b 45 14             	mov    0x14(%ebp),%eax
  801912:	8b 00                	mov    (%eax),%eax
  801914:	8d 48 01             	lea    0x1(%eax),%ecx
  801917:	8b 55 14             	mov    0x14(%ebp),%edx
  80191a:	89 0a                	mov    %ecx,(%edx)
  80191c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801923:	8b 45 10             	mov    0x10(%ebp),%eax
  801926:	01 c2                	add    %eax,%edx
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80192d:	eb 03                	jmp    801932 <strsplit+0x8f>
			string++;
  80192f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	84 c0                	test   %al,%al
  801939:	74 8b                	je     8018c6 <strsplit+0x23>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	8a 00                	mov    (%eax),%al
  801940:	0f be c0             	movsbl %al,%eax
  801943:	50                   	push   %eax
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	e8 d4 fa ff ff       	call   801420 <strchr>
  80194c:	83 c4 08             	add    $0x8,%esp
  80194f:	85 c0                	test   %eax,%eax
  801951:	74 dc                	je     80192f <strsplit+0x8c>
			string++;
	}
  801953:	e9 6e ff ff ff       	jmp    8018c6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801958:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801959:	8b 45 14             	mov    0x14(%ebp),%eax
  80195c:	8b 00                	mov    (%eax),%eax
  80195e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801965:	8b 45 10             	mov    0x10(%ebp),%eax
  801968:	01 d0                	add    %edx,%eax
  80196a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801970:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80197d:	83 ec 04             	sub    $0x4,%esp
  801980:	68 fc 2a 80 00       	push   $0x802afc
  801985:	68 3f 01 00 00       	push   $0x13f
  80198a:	68 1e 2b 80 00       	push   $0x802b1e
  80198f:	e8 a1 ed ff ff       	call   800735 <_panic>

00801994 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80199a:	83 ec 0c             	sub    $0xc,%esp
  80199d:	ff 75 08             	pushl  0x8(%ebp)
  8019a0:	e8 ef 06 00 00       	call   802094 <sys_sbrk>
  8019a5:	83 c4 10             	add    $0x10,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8019b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019b4:	75 07                	jne    8019bd <malloc+0x13>
  8019b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bb:	eb 14                	jmp    8019d1 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	68 2c 2b 80 00       	push   $0x802b2c
  8019c5:	6a 1b                	push   $0x1b
  8019c7:	68 51 2b 80 00       	push   $0x802b51
  8019cc:	e8 64 ed ff ff       	call   800735 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	68 60 2b 80 00       	push   $0x802b60
  8019e1:	6a 29                	push   $0x29
  8019e3:	68 51 2b 80 00       	push   $0x802b51
  8019e8:	e8 48 ed ff ff       	call   800735 <_panic>

008019ed <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	83 ec 18             	sub    $0x18,%esp
  8019f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f6:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8019f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019fd:	75 07                	jne    801a06 <smalloc+0x19>
  8019ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801a04:	eb 14                	jmp    801a1a <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801a06:	83 ec 04             	sub    $0x4,%esp
  801a09:	68 84 2b 80 00       	push   $0x802b84
  801a0e:	6a 38                	push   $0x38
  801a10:	68 51 2b 80 00       	push   $0x802b51
  801a15:	e8 1b ed ff ff       	call   800735 <_panic>
	return NULL;
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a22:	83 ec 04             	sub    $0x4,%esp
  801a25:	68 ac 2b 80 00       	push   $0x802bac
  801a2a:	6a 43                	push   $0x43
  801a2c:	68 51 2b 80 00       	push   $0x802b51
  801a31:	e8 ff ec ff ff       	call   800735 <_panic>

00801a36 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a3c:	83 ec 04             	sub    $0x4,%esp
  801a3f:	68 d0 2b 80 00       	push   $0x802bd0
  801a44:	6a 5b                	push   $0x5b
  801a46:	68 51 2b 80 00       	push   $0x802b51
  801a4b:	e8 e5 ec ff ff       	call   800735 <_panic>

00801a50 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a56:	83 ec 04             	sub    $0x4,%esp
  801a59:	68 f4 2b 80 00       	push   $0x802bf4
  801a5e:	6a 72                	push   $0x72
  801a60:	68 51 2b 80 00       	push   $0x802b51
  801a65:	e8 cb ec ff ff       	call   800735 <_panic>

00801a6a <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a70:	83 ec 04             	sub    $0x4,%esp
  801a73:	68 1a 2c 80 00       	push   $0x802c1a
  801a78:	6a 7e                	push   $0x7e
  801a7a:	68 51 2b 80 00       	push   $0x802b51
  801a7f:	e8 b1 ec ff ff       	call   800735 <_panic>

00801a84 <shrink>:

}
void shrink(uint32 newSize)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	68 1a 2c 80 00       	push   $0x802c1a
  801a92:	68 83 00 00 00       	push   $0x83
  801a97:	68 51 2b 80 00       	push   $0x802b51
  801a9c:	e8 94 ec ff ff       	call   800735 <_panic>

00801aa1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	68 1a 2c 80 00       	push   $0x802c1a
  801aaf:	68 88 00 00 00       	push   $0x88
  801ab4:	68 51 2b 80 00       	push   $0x802b51
  801ab9:	e8 77 ec ff ff       	call   800735 <_panic>

00801abe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	57                   	push   %edi
  801ac2:	56                   	push   %esi
  801ac3:	53                   	push   %ebx
  801ac4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad3:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ad6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ad9:	cd 30                	int    $0x30
  801adb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ae1:	83 c4 10             	add    $0x10,%esp
  801ae4:	5b                   	pop    %ebx
  801ae5:	5e                   	pop    %esi
  801ae6:	5f                   	pop    %edi
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    

00801ae9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	83 ec 04             	sub    $0x4,%esp
  801aef:	8b 45 10             	mov    0x10(%ebp),%eax
  801af2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801af5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	52                   	push   %edx
  801b01:	ff 75 0c             	pushl  0xc(%ebp)
  801b04:	50                   	push   %eax
  801b05:	6a 00                	push   $0x0
  801b07:	e8 b2 ff ff ff       	call   801abe <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 02                	push   $0x2
  801b21:	e8 98 ff ff ff       	call   801abe <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 03                	push   $0x3
  801b3a:	e8 7f ff ff ff       	call   801abe <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	90                   	nop
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 04                	push   $0x4
  801b54:	e8 65 ff ff ff       	call   801abe <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	90                   	nop
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	52                   	push   %edx
  801b6f:	50                   	push   %eax
  801b70:	6a 08                	push   $0x8
  801b72:	e8 47 ff ff ff       	call   801abe <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	56                   	push   %esi
  801b80:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b81:	8b 75 18             	mov    0x18(%ebp),%esi
  801b84:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b87:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	56                   	push   %esi
  801b91:	53                   	push   %ebx
  801b92:	51                   	push   %ecx
  801b93:	52                   	push   %edx
  801b94:	50                   	push   %eax
  801b95:	6a 09                	push   $0x9
  801b97:	e8 22 ff ff ff       	call   801abe <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba2:	5b                   	pop    %ebx
  801ba3:	5e                   	pop    %esi
  801ba4:	5d                   	pop    %ebp
  801ba5:	c3                   	ret    

00801ba6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ba9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	52                   	push   %edx
  801bb6:	50                   	push   %eax
  801bb7:	6a 0a                	push   $0xa
  801bb9:	e8 00 ff ff ff       	call   801abe <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	ff 75 0c             	pushl  0xc(%ebp)
  801bcf:	ff 75 08             	pushl  0x8(%ebp)
  801bd2:	6a 0b                	push   $0xb
  801bd4:	e8 e5 fe ff ff       	call   801abe <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 0c                	push   $0xc
  801bed:	e8 cc fe ff ff       	call   801abe <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 0d                	push   $0xd
  801c06:	e8 b3 fe ff ff       	call   801abe <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 0e                	push   $0xe
  801c1f:	e8 9a fe ff ff       	call   801abe <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 0f                	push   $0xf
  801c38:	e8 81 fe ff ff       	call   801abe <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	ff 75 08             	pushl  0x8(%ebp)
  801c50:	6a 10                	push   $0x10
  801c52:	e8 67 fe ff ff       	call   801abe <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 11                	push   $0x11
  801c6b:	e8 4e fe ff ff       	call   801abe <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	90                   	nop
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_cputc>:

void
sys_cputc(const char c)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 04             	sub    $0x4,%esp
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c82:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	50                   	push   %eax
  801c8f:	6a 01                	push   $0x1
  801c91:	e8 28 fe ff ff       	call   801abe <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
}
  801c99:	90                   	nop
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 14                	push   $0x14
  801cab:	e8 0e fe ff ff       	call   801abe <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
}
  801cb3:	90                   	nop
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 04             	sub    $0x4,%esp
  801cbc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cc2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cc5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	6a 00                	push   $0x0
  801cce:	51                   	push   %ecx
  801ccf:	52                   	push   %edx
  801cd0:	ff 75 0c             	pushl  0xc(%ebp)
  801cd3:	50                   	push   %eax
  801cd4:	6a 15                	push   $0x15
  801cd6:	e8 e3 fd ff ff       	call   801abe <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	52                   	push   %edx
  801cf0:	50                   	push   %eax
  801cf1:	6a 16                	push   $0x16
  801cf3:	e8 c6 fd ff ff       	call   801abe <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	51                   	push   %ecx
  801d0e:	52                   	push   %edx
  801d0f:	50                   	push   %eax
  801d10:	6a 17                	push   $0x17
  801d12:	e8 a7 fd ff ff       	call   801abe <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d22:	8b 45 08             	mov    0x8(%ebp),%eax
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	52                   	push   %edx
  801d2c:	50                   	push   %eax
  801d2d:	6a 18                	push   $0x18
  801d2f:	e8 8a fd ff ff       	call   801abe <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	6a 00                	push   $0x0
  801d41:	ff 75 14             	pushl  0x14(%ebp)
  801d44:	ff 75 10             	pushl  0x10(%ebp)
  801d47:	ff 75 0c             	pushl  0xc(%ebp)
  801d4a:	50                   	push   %eax
  801d4b:	6a 19                	push   $0x19
  801d4d:	e8 6c fd ff ff       	call   801abe <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	50                   	push   %eax
  801d66:	6a 1a                	push   $0x1a
  801d68:	e8 51 fd ff ff       	call   801abe <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
}
  801d70:	90                   	nop
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d76:	8b 45 08             	mov    0x8(%ebp),%eax
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	50                   	push   %eax
  801d82:	6a 1b                	push   $0x1b
  801d84:	e8 35 fd ff ff       	call   801abe <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 05                	push   $0x5
  801d9d:	e8 1c fd ff ff       	call   801abe <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 06                	push   $0x6
  801db6:	e8 03 fd ff ff       	call   801abe <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 07                	push   $0x7
  801dcf:	e8 ea fc ff ff       	call   801abe <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <sys_exit_env>:


void sys_exit_env(void)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 1c                	push   $0x1c
  801de8:	e8 d1 fc ff ff       	call   801abe <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	90                   	nop
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801df9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dfc:	8d 50 04             	lea    0x4(%eax),%edx
  801dff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	52                   	push   %edx
  801e09:	50                   	push   %eax
  801e0a:	6a 1d                	push   $0x1d
  801e0c:	e8 ad fc ff ff       	call   801abe <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
	return result;
  801e14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e1d:	89 01                	mov    %eax,(%ecx)
  801e1f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e22:	8b 45 08             	mov    0x8(%ebp),%eax
  801e25:	c9                   	leave  
  801e26:	c2 04 00             	ret    $0x4

00801e29 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	ff 75 10             	pushl  0x10(%ebp)
  801e33:	ff 75 0c             	pushl  0xc(%ebp)
  801e36:	ff 75 08             	pushl  0x8(%ebp)
  801e39:	6a 13                	push   $0x13
  801e3b:	e8 7e fc ff ff       	call   801abe <syscall>
  801e40:	83 c4 18             	add    $0x18,%esp
	return ;
  801e43:	90                   	nop
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 1e                	push   $0x1e
  801e55:	e8 64 fc ff ff       	call   801abe <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	83 ec 04             	sub    $0x4,%esp
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e6b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	50                   	push   %eax
  801e78:	6a 1f                	push   $0x1f
  801e7a:	e8 3f fc ff ff       	call   801abe <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e82:	90                   	nop
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <rsttst>:
void rsttst()
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 21                	push   $0x21
  801e94:	e8 25 fc ff ff       	call   801abe <syscall>
  801e99:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9c:	90                   	nop
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 04             	sub    $0x4,%esp
  801ea5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ea8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801eab:	8b 55 18             	mov    0x18(%ebp),%edx
  801eae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eb2:	52                   	push   %edx
  801eb3:	50                   	push   %eax
  801eb4:	ff 75 10             	pushl  0x10(%ebp)
  801eb7:	ff 75 0c             	pushl  0xc(%ebp)
  801eba:	ff 75 08             	pushl  0x8(%ebp)
  801ebd:	6a 20                	push   $0x20
  801ebf:	e8 fa fb ff ff       	call   801abe <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec7:	90                   	nop
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <chktst>:
void chktst(uint32 n)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	ff 75 08             	pushl  0x8(%ebp)
  801ed8:	6a 22                	push   $0x22
  801eda:	e8 df fb ff ff       	call   801abe <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee2:	90                   	nop
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <inctst>:

void inctst()
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 23                	push   $0x23
  801ef4:	e8 c5 fb ff ff       	call   801abe <syscall>
  801ef9:	83 c4 18             	add    $0x18,%esp
	return ;
  801efc:	90                   	nop
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <gettst>:
uint32 gettst()
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 24                	push   $0x24
  801f0e:	e8 ab fb ff ff       	call   801abe <syscall>
  801f13:	83 c4 18             	add    $0x18,%esp
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 25                	push   $0x25
  801f2a:	e8 8f fb ff ff       	call   801abe <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
  801f32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f35:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f39:	75 07                	jne    801f42 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f40:	eb 05                	jmp    801f47 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 25                	push   $0x25
  801f5b:	e8 5e fb ff ff       	call   801abe <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
  801f63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f66:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f6a:	75 07                	jne    801f73 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801f71:	eb 05                	jmp    801f78 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 25                	push   $0x25
  801f8c:	e8 2d fb ff ff       	call   801abe <syscall>
  801f91:	83 c4 18             	add    $0x18,%esp
  801f94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f97:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f9b:	75 07                	jne    801fa4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa2:	eb 05                	jmp    801fa9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 25                	push   $0x25
  801fbd:	e8 fc fa ff ff       	call   801abe <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
  801fc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fc8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fcc:	75 07                	jne    801fd5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fce:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd3:	eb 05                	jmp    801fda <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	ff 75 08             	pushl  0x8(%ebp)
  801fea:	6a 26                	push   $0x26
  801fec:	e8 cd fa ff ff       	call   801abe <syscall>
  801ff1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff4:	90                   	nop
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ffb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ffe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802001:	8b 55 0c             	mov    0xc(%ebp),%edx
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	6a 00                	push   $0x0
  802009:	53                   	push   %ebx
  80200a:	51                   	push   %ecx
  80200b:	52                   	push   %edx
  80200c:	50                   	push   %eax
  80200d:	6a 27                	push   $0x27
  80200f:	e8 aa fa ff ff       	call   801abe <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
}
  802017:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80201f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	52                   	push   %edx
  80202c:	50                   	push   %eax
  80202d:	6a 28                	push   $0x28
  80202f:	e8 8a fa ff ff       	call   801abe <syscall>
  802034:	83 c4 18             	add    $0x18,%esp
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80203c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80203f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	6a 00                	push   $0x0
  802047:	51                   	push   %ecx
  802048:	ff 75 10             	pushl  0x10(%ebp)
  80204b:	52                   	push   %edx
  80204c:	50                   	push   %eax
  80204d:	6a 29                	push   $0x29
  80204f:	e8 6a fa ff ff       	call   801abe <syscall>
  802054:	83 c4 18             	add    $0x18,%esp
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	ff 75 10             	pushl  0x10(%ebp)
  802063:	ff 75 0c             	pushl  0xc(%ebp)
  802066:	ff 75 08             	pushl  0x8(%ebp)
  802069:	6a 12                	push   $0x12
  80206b:	e8 4e fa ff ff       	call   801abe <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
	return ;
  802073:	90                   	nop
}
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802079:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	52                   	push   %edx
  802086:	50                   	push   %eax
  802087:	6a 2a                	push   $0x2a
  802089:	e8 30 fa ff ff       	call   801abe <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
	return;
  802091:	90                   	nop
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	50                   	push   %eax
  8020a3:	6a 2b                	push   $0x2b
  8020a5:	e8 14 fa ff ff       	call   801abe <syscall>
  8020aa:	83 c4 18             	add    $0x18,%esp
}
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	ff 75 0c             	pushl  0xc(%ebp)
  8020bb:	ff 75 08             	pushl  0x8(%ebp)
  8020be:	6a 2c                	push   $0x2c
  8020c0:	e8 f9 f9 ff ff       	call   801abe <syscall>
  8020c5:	83 c4 18             	add    $0x18,%esp
	return;
  8020c8:	90                   	nop
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	ff 75 0c             	pushl  0xc(%ebp)
  8020d7:	ff 75 08             	pushl  0x8(%ebp)
  8020da:	6a 2d                	push   $0x2d
  8020dc:	e8 dd f9 ff ff       	call   801abe <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
	return;
  8020e4:	90                   	nop
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    
  8020e7:	90                   	nop

008020e8 <__udivdi3>:
  8020e8:	55                   	push   %ebp
  8020e9:	57                   	push   %edi
  8020ea:	56                   	push   %esi
  8020eb:	53                   	push   %ebx
  8020ec:	83 ec 1c             	sub    $0x1c,%esp
  8020ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020ff:	89 ca                	mov    %ecx,%edx
  802101:	89 f8                	mov    %edi,%eax
  802103:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802107:	85 f6                	test   %esi,%esi
  802109:	75 2d                	jne    802138 <__udivdi3+0x50>
  80210b:	39 cf                	cmp    %ecx,%edi
  80210d:	77 65                	ja     802174 <__udivdi3+0x8c>
  80210f:	89 fd                	mov    %edi,%ebp
  802111:	85 ff                	test   %edi,%edi
  802113:	75 0b                	jne    802120 <__udivdi3+0x38>
  802115:	b8 01 00 00 00       	mov    $0x1,%eax
  80211a:	31 d2                	xor    %edx,%edx
  80211c:	f7 f7                	div    %edi
  80211e:	89 c5                	mov    %eax,%ebp
  802120:	31 d2                	xor    %edx,%edx
  802122:	89 c8                	mov    %ecx,%eax
  802124:	f7 f5                	div    %ebp
  802126:	89 c1                	mov    %eax,%ecx
  802128:	89 d8                	mov    %ebx,%eax
  80212a:	f7 f5                	div    %ebp
  80212c:	89 cf                	mov    %ecx,%edi
  80212e:	89 fa                	mov    %edi,%edx
  802130:	83 c4 1c             	add    $0x1c,%esp
  802133:	5b                   	pop    %ebx
  802134:	5e                   	pop    %esi
  802135:	5f                   	pop    %edi
  802136:	5d                   	pop    %ebp
  802137:	c3                   	ret    
  802138:	39 ce                	cmp    %ecx,%esi
  80213a:	77 28                	ja     802164 <__udivdi3+0x7c>
  80213c:	0f bd fe             	bsr    %esi,%edi
  80213f:	83 f7 1f             	xor    $0x1f,%edi
  802142:	75 40                	jne    802184 <__udivdi3+0x9c>
  802144:	39 ce                	cmp    %ecx,%esi
  802146:	72 0a                	jb     802152 <__udivdi3+0x6a>
  802148:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80214c:	0f 87 9e 00 00 00    	ja     8021f0 <__udivdi3+0x108>
  802152:	b8 01 00 00 00       	mov    $0x1,%eax
  802157:	89 fa                	mov    %edi,%edx
  802159:	83 c4 1c             	add    $0x1c,%esp
  80215c:	5b                   	pop    %ebx
  80215d:	5e                   	pop    %esi
  80215e:	5f                   	pop    %edi
  80215f:	5d                   	pop    %ebp
  802160:	c3                   	ret    
  802161:	8d 76 00             	lea    0x0(%esi),%esi
  802164:	31 ff                	xor    %edi,%edi
  802166:	31 c0                	xor    %eax,%eax
  802168:	89 fa                	mov    %edi,%edx
  80216a:	83 c4 1c             	add    $0x1c,%esp
  80216d:	5b                   	pop    %ebx
  80216e:	5e                   	pop    %esi
  80216f:	5f                   	pop    %edi
  802170:	5d                   	pop    %ebp
  802171:	c3                   	ret    
  802172:	66 90                	xchg   %ax,%ax
  802174:	89 d8                	mov    %ebx,%eax
  802176:	f7 f7                	div    %edi
  802178:	31 ff                	xor    %edi,%edi
  80217a:	89 fa                	mov    %edi,%edx
  80217c:	83 c4 1c             	add    $0x1c,%esp
  80217f:	5b                   	pop    %ebx
  802180:	5e                   	pop    %esi
  802181:	5f                   	pop    %edi
  802182:	5d                   	pop    %ebp
  802183:	c3                   	ret    
  802184:	bd 20 00 00 00       	mov    $0x20,%ebp
  802189:	89 eb                	mov    %ebp,%ebx
  80218b:	29 fb                	sub    %edi,%ebx
  80218d:	89 f9                	mov    %edi,%ecx
  80218f:	d3 e6                	shl    %cl,%esi
  802191:	89 c5                	mov    %eax,%ebp
  802193:	88 d9                	mov    %bl,%cl
  802195:	d3 ed                	shr    %cl,%ebp
  802197:	89 e9                	mov    %ebp,%ecx
  802199:	09 f1                	or     %esi,%ecx
  80219b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80219f:	89 f9                	mov    %edi,%ecx
  8021a1:	d3 e0                	shl    %cl,%eax
  8021a3:	89 c5                	mov    %eax,%ebp
  8021a5:	89 d6                	mov    %edx,%esi
  8021a7:	88 d9                	mov    %bl,%cl
  8021a9:	d3 ee                	shr    %cl,%esi
  8021ab:	89 f9                	mov    %edi,%ecx
  8021ad:	d3 e2                	shl    %cl,%edx
  8021af:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021b3:	88 d9                	mov    %bl,%cl
  8021b5:	d3 e8                	shr    %cl,%eax
  8021b7:	09 c2                	or     %eax,%edx
  8021b9:	89 d0                	mov    %edx,%eax
  8021bb:	89 f2                	mov    %esi,%edx
  8021bd:	f7 74 24 0c          	divl   0xc(%esp)
  8021c1:	89 d6                	mov    %edx,%esi
  8021c3:	89 c3                	mov    %eax,%ebx
  8021c5:	f7 e5                	mul    %ebp
  8021c7:	39 d6                	cmp    %edx,%esi
  8021c9:	72 19                	jb     8021e4 <__udivdi3+0xfc>
  8021cb:	74 0b                	je     8021d8 <__udivdi3+0xf0>
  8021cd:	89 d8                	mov    %ebx,%eax
  8021cf:	31 ff                	xor    %edi,%edi
  8021d1:	e9 58 ff ff ff       	jmp    80212e <__udivdi3+0x46>
  8021d6:	66 90                	xchg   %ax,%ax
  8021d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021dc:	89 f9                	mov    %edi,%ecx
  8021de:	d3 e2                	shl    %cl,%edx
  8021e0:	39 c2                	cmp    %eax,%edx
  8021e2:	73 e9                	jae    8021cd <__udivdi3+0xe5>
  8021e4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021e7:	31 ff                	xor    %edi,%edi
  8021e9:	e9 40 ff ff ff       	jmp    80212e <__udivdi3+0x46>
  8021ee:	66 90                	xchg   %ax,%ax
  8021f0:	31 c0                	xor    %eax,%eax
  8021f2:	e9 37 ff ff ff       	jmp    80212e <__udivdi3+0x46>
  8021f7:	90                   	nop

008021f8 <__umoddi3>:
  8021f8:	55                   	push   %ebp
  8021f9:	57                   	push   %edi
  8021fa:	56                   	push   %esi
  8021fb:	53                   	push   %ebx
  8021fc:	83 ec 1c             	sub    $0x1c,%esp
  8021ff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802203:	8b 74 24 34          	mov    0x34(%esp),%esi
  802207:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80220b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80220f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802213:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802217:	89 f3                	mov    %esi,%ebx
  802219:	89 fa                	mov    %edi,%edx
  80221b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80221f:	89 34 24             	mov    %esi,(%esp)
  802222:	85 c0                	test   %eax,%eax
  802224:	75 1a                	jne    802240 <__umoddi3+0x48>
  802226:	39 f7                	cmp    %esi,%edi
  802228:	0f 86 a2 00 00 00    	jbe    8022d0 <__umoddi3+0xd8>
  80222e:	89 c8                	mov    %ecx,%eax
  802230:	89 f2                	mov    %esi,%edx
  802232:	f7 f7                	div    %edi
  802234:	89 d0                	mov    %edx,%eax
  802236:	31 d2                	xor    %edx,%edx
  802238:	83 c4 1c             	add    $0x1c,%esp
  80223b:	5b                   	pop    %ebx
  80223c:	5e                   	pop    %esi
  80223d:	5f                   	pop    %edi
  80223e:	5d                   	pop    %ebp
  80223f:	c3                   	ret    
  802240:	39 f0                	cmp    %esi,%eax
  802242:	0f 87 ac 00 00 00    	ja     8022f4 <__umoddi3+0xfc>
  802248:	0f bd e8             	bsr    %eax,%ebp
  80224b:	83 f5 1f             	xor    $0x1f,%ebp
  80224e:	0f 84 ac 00 00 00    	je     802300 <__umoddi3+0x108>
  802254:	bf 20 00 00 00       	mov    $0x20,%edi
  802259:	29 ef                	sub    %ebp,%edi
  80225b:	89 fe                	mov    %edi,%esi
  80225d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802261:	89 e9                	mov    %ebp,%ecx
  802263:	d3 e0                	shl    %cl,%eax
  802265:	89 d7                	mov    %edx,%edi
  802267:	89 f1                	mov    %esi,%ecx
  802269:	d3 ef                	shr    %cl,%edi
  80226b:	09 c7                	or     %eax,%edi
  80226d:	89 e9                	mov    %ebp,%ecx
  80226f:	d3 e2                	shl    %cl,%edx
  802271:	89 14 24             	mov    %edx,(%esp)
  802274:	89 d8                	mov    %ebx,%eax
  802276:	d3 e0                	shl    %cl,%eax
  802278:	89 c2                	mov    %eax,%edx
  80227a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80227e:	d3 e0                	shl    %cl,%eax
  802280:	89 44 24 04          	mov    %eax,0x4(%esp)
  802284:	8b 44 24 08          	mov    0x8(%esp),%eax
  802288:	89 f1                	mov    %esi,%ecx
  80228a:	d3 e8                	shr    %cl,%eax
  80228c:	09 d0                	or     %edx,%eax
  80228e:	d3 eb                	shr    %cl,%ebx
  802290:	89 da                	mov    %ebx,%edx
  802292:	f7 f7                	div    %edi
  802294:	89 d3                	mov    %edx,%ebx
  802296:	f7 24 24             	mull   (%esp)
  802299:	89 c6                	mov    %eax,%esi
  80229b:	89 d1                	mov    %edx,%ecx
  80229d:	39 d3                	cmp    %edx,%ebx
  80229f:	0f 82 87 00 00 00    	jb     80232c <__umoddi3+0x134>
  8022a5:	0f 84 91 00 00 00    	je     80233c <__umoddi3+0x144>
  8022ab:	8b 54 24 04          	mov    0x4(%esp),%edx
  8022af:	29 f2                	sub    %esi,%edx
  8022b1:	19 cb                	sbb    %ecx,%ebx
  8022b3:	89 d8                	mov    %ebx,%eax
  8022b5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8022b9:	d3 e0                	shl    %cl,%eax
  8022bb:	89 e9                	mov    %ebp,%ecx
  8022bd:	d3 ea                	shr    %cl,%edx
  8022bf:	09 d0                	or     %edx,%eax
  8022c1:	89 e9                	mov    %ebp,%ecx
  8022c3:	d3 eb                	shr    %cl,%ebx
  8022c5:	89 da                	mov    %ebx,%edx
  8022c7:	83 c4 1c             	add    $0x1c,%esp
  8022ca:	5b                   	pop    %ebx
  8022cb:	5e                   	pop    %esi
  8022cc:	5f                   	pop    %edi
  8022cd:	5d                   	pop    %ebp
  8022ce:	c3                   	ret    
  8022cf:	90                   	nop
  8022d0:	89 fd                	mov    %edi,%ebp
  8022d2:	85 ff                	test   %edi,%edi
  8022d4:	75 0b                	jne    8022e1 <__umoddi3+0xe9>
  8022d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022db:	31 d2                	xor    %edx,%edx
  8022dd:	f7 f7                	div    %edi
  8022df:	89 c5                	mov    %eax,%ebp
  8022e1:	89 f0                	mov    %esi,%eax
  8022e3:	31 d2                	xor    %edx,%edx
  8022e5:	f7 f5                	div    %ebp
  8022e7:	89 c8                	mov    %ecx,%eax
  8022e9:	f7 f5                	div    %ebp
  8022eb:	89 d0                	mov    %edx,%eax
  8022ed:	e9 44 ff ff ff       	jmp    802236 <__umoddi3+0x3e>
  8022f2:	66 90                	xchg   %ax,%ax
  8022f4:	89 c8                	mov    %ecx,%eax
  8022f6:	89 f2                	mov    %esi,%edx
  8022f8:	83 c4 1c             	add    $0x1c,%esp
  8022fb:	5b                   	pop    %ebx
  8022fc:	5e                   	pop    %esi
  8022fd:	5f                   	pop    %edi
  8022fe:	5d                   	pop    %ebp
  8022ff:	c3                   	ret    
  802300:	3b 04 24             	cmp    (%esp),%eax
  802303:	72 06                	jb     80230b <__umoddi3+0x113>
  802305:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802309:	77 0f                	ja     80231a <__umoddi3+0x122>
  80230b:	89 f2                	mov    %esi,%edx
  80230d:	29 f9                	sub    %edi,%ecx
  80230f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802313:	89 14 24             	mov    %edx,(%esp)
  802316:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80231a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80231e:	8b 14 24             	mov    (%esp),%edx
  802321:	83 c4 1c             	add    $0x1c,%esp
  802324:	5b                   	pop    %ebx
  802325:	5e                   	pop    %esi
  802326:	5f                   	pop    %edi
  802327:	5d                   	pop    %ebp
  802328:	c3                   	ret    
  802329:	8d 76 00             	lea    0x0(%esi),%esi
  80232c:	2b 04 24             	sub    (%esp),%eax
  80232f:	19 fa                	sbb    %edi,%edx
  802331:	89 d1                	mov    %edx,%ecx
  802333:	89 c6                	mov    %eax,%esi
  802335:	e9 71 ff ff ff       	jmp    8022ab <__umoddi3+0xb3>
  80233a:	66 90                	xchg   %ax,%ax
  80233c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802340:	72 ea                	jb     80232c <__umoddi3+0x134>
  802342:	89 d9                	mov    %ebx,%ecx
  802344:	e9 62 ff ff ff       	jmp    8022ab <__umoddi3+0xb3>
