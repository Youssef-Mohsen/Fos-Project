
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
  800041:	e8 9b 1e 00 00       	call   801ee1 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 41 80 00       	push   $0x8041a0
  80004e:	e8 a7 09 00 00       	call   8009fa <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 41 80 00       	push   $0x8041a2
  80005e:	e8 97 09 00 00       	call   8009fa <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 bb 41 80 00       	push   $0x8041bb
  80006e:	e8 87 09 00 00       	call   8009fa <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 41 80 00       	push   $0x8041a2
  80007e:	e8 77 09 00 00       	call   8009fa <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 41 80 00       	push   $0x8041a0
  80008e:	e8 67 09 00 00       	call   8009fa <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d4 41 80 00       	push   $0x8041d4
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
  8000c9:	68 f4 41 80 00       	push   $0x8041f4
  8000ce:	e8 27 09 00 00       	call   8009fa <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 16 42 80 00       	push   $0x804216
  8000de:	e8 17 09 00 00       	call   8009fa <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 24 42 80 00       	push   $0x804224
  8000ee:	e8 07 09 00 00       	call   8009fa <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000f6:	83 ec 0c             	sub    $0xc,%esp
  8000f9:	68 33 42 80 00       	push   $0x804233
  8000fe:	e8 f7 08 00 00       	call   8009fa <cprintf>
  800103:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	68 43 42 80 00       	push   $0x804243
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
  80014d:	e8 a9 1d 00 00       	call   801efb <sys_unlock_cons>
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
  8001d5:	e8 07 1d 00 00       	call   801ee1 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 4c 42 80 00       	push   $0x80424c
  8001e2:	e8 13 08 00 00       	call   8009fa <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 0c 1d 00 00       	call   801efb <sys_unlock_cons>
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
  80020c:	68 80 42 80 00       	push   $0x804280
  800211:	6a 54                	push   $0x54
  800213:	68 a2 42 80 00       	push   $0x8042a2
  800218:	e8 20 05 00 00       	call   80073d <_panic>
		else
		{
			//			sys_lock_cons();
			sys_lock_cons();
  80021d:	e8 bf 1c 00 00       	call   801ee1 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 bc 42 80 00       	push   $0x8042bc
  80022a:	e8 cb 07 00 00       	call   8009fa <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 f0 42 80 00       	push   $0x8042f0
  80023a:	e8 bb 07 00 00       	call   8009fa <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 24 43 80 00       	push   $0x804324
  80024a:	e8 ab 07 00 00       	call   8009fa <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800252:	e8 a4 1c 00 00       	call   801efb <sys_unlock_cons>


		}

		//		sys_lock_cons();
		sys_lock_cons();
  800257:	e8 85 1c 00 00       	call   801ee1 <sys_lock_cons>
		{
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 56 43 80 00       	push   $0x804356
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
  8002b0:	e8 46 1c 00 00       	call   801efb <sys_unlock_cons>
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
  800562:	68 a0 41 80 00       	push   $0x8041a0
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
  800584:	68 74 43 80 00       	push   $0x804374
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
  8005b2:	68 79 43 80 00       	push   $0x804379
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
  8005d6:	e8 51 1a 00 00       	call   80202c <sys_cputc>
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
  8005e7:	e8 dc 18 00 00       	call   801ec8 <sys_cgetc>
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
  800604:	e8 54 1b 00 00       	call   80215d <sys_getenvindex>
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
  800672:	e8 6a 18 00 00       	call   801ee1 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800677:	83 ec 0c             	sub    $0xc,%esp
  80067a:	68 98 43 80 00       	push   $0x804398
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
  8006a2:	68 c0 43 80 00       	push   $0x8043c0
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
  8006d3:	68 e8 43 80 00       	push   $0x8043e8
  8006d8:	e8 1d 03 00 00       	call   8009fa <cprintf>
  8006dd:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006e0:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e5:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	50                   	push   %eax
  8006ef:	68 40 44 80 00       	push   $0x804440
  8006f4:	e8 01 03 00 00       	call   8009fa <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	68 98 43 80 00       	push   $0x804398
  800704:	e8 f1 02 00 00       	call   8009fa <cprintf>
  800709:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80070c:	e8 ea 17 00 00       	call   801efb <sys_unlock_cons>
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
  800724:	e8 00 1a 00 00       	call   802129 <sys_destroy_env>
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
  800735:	e8 55 1a 00 00       	call   80218f <sys_exit_env>
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
  80075e:	68 54 44 80 00       	push   $0x804454
  800763:	e8 92 02 00 00       	call   8009fa <cprintf>
  800768:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80076b:	a1 00 50 80 00       	mov    0x805000,%eax
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	ff 75 08             	pushl  0x8(%ebp)
  800776:	50                   	push   %eax
  800777:	68 59 44 80 00       	push   $0x804459
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
  80079b:	68 75 44 80 00       	push   $0x804475
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
  8007ca:	68 78 44 80 00       	push   $0x804478
  8007cf:	6a 26                	push   $0x26
  8007d1:	68 c4 44 80 00       	push   $0x8044c4
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
  80089f:	68 d0 44 80 00       	push   $0x8044d0
  8008a4:	6a 3a                	push   $0x3a
  8008a6:	68 c4 44 80 00       	push   $0x8044c4
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
  800912:	68 24 45 80 00       	push   $0x804524
  800917:	6a 44                	push   $0x44
  800919:	68 c4 44 80 00       	push   $0x8044c4
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
  80096c:	e8 2e 15 00 00       	call   801e9f <sys_cputs>
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
  8009e3:	e8 b7 14 00 00       	call   801e9f <sys_cputs>
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
  800a2d:	e8 af 14 00 00       	call   801ee1 <sys_lock_cons>
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
  800a4d:	e8 a9 14 00 00       	call   801efb <sys_unlock_cons>
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
  800a97:	e8 9c 34 00 00       	call   803f38 <__udivdi3>
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
  800ae7:	e8 5c 35 00 00       	call   804048 <__umoddi3>
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	05 94 47 80 00       	add    $0x804794,%eax
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
  800c42:	8b 04 85 b8 47 80 00 	mov    0x8047b8(,%eax,4),%eax
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
  800d23:	8b 34 9d 00 46 80 00 	mov    0x804600(,%ebx,4),%esi
  800d2a:	85 f6                	test   %esi,%esi
  800d2c:	75 19                	jne    800d47 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d2e:	53                   	push   %ebx
  800d2f:	68 a5 47 80 00       	push   $0x8047a5
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
  800d48:	68 ae 47 80 00       	push   $0x8047ae
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
  800d75:	be b1 47 80 00       	mov    $0x8047b1,%esi
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
  8010a0:	68 28 49 80 00       	push   $0x804928
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
  8010e2:	68 2b 49 80 00       	push   $0x80492b
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
  801193:	e8 49 0d 00 00       	call   801ee1 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801198:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80119c:	74 13                	je     8011b1 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	ff 75 08             	pushl  0x8(%ebp)
  8011a4:	68 28 49 80 00       	push   $0x804928
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
  8011e6:	68 2b 49 80 00       	push   $0x80492b
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
  80128e:	e8 68 0c 00 00       	call   801efb <sys_unlock_cons>
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
  801988:	68 3c 49 80 00       	push   $0x80493c
  80198d:	68 3f 01 00 00       	push   $0x13f
  801992:	68 5e 49 80 00       	push   $0x80495e
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
  8019a8:	e8 9d 0a 00 00       	call   80244a <sys_sbrk>
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
  801a23:	e8 a6 08 00 00       	call   8022ce <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	74 16                	je     801a42 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a2c:	83 ec 0c             	sub    $0xc,%esp
  801a2f:	ff 75 08             	pushl  0x8(%ebp)
  801a32:	e8 e6 0d 00 00       	call   80281d <alloc_block_FF>
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a3d:	e9 8a 01 00 00       	jmp    801bcc <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801a42:	e8 b8 08 00 00       	call   8022ff <sys_isUHeapPlacementStrategyBESTFIT>
  801a47:	85 c0                	test   %eax,%eax
  801a49:	0f 84 7d 01 00 00    	je     801bcc <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	e8 7f 12 00 00       	call   802cd9 <alloc_block_BF>
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
  801bbb:	e8 c1 08 00 00       	call   802481 <sys_allocate_user_mem>
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
  801c03:	e8 95 08 00 00       	call   80249d <get_block_size>
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c0e:	83 ec 0c             	sub    $0xc,%esp
  801c11:	ff 75 08             	pushl  0x8(%ebp)
  801c14:	e8 c8 1a 00 00       	call   8036e1 <free_block>
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
  801cab:	e8 b5 07 00 00       	call   802465 <sys_free_user_mem>
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
  801cb9:	68 6c 49 80 00       	push   $0x80496c
  801cbe:	68 84 00 00 00       	push   $0x84
  801cc3:	68 96 49 80 00       	push   $0x804996
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
  801d2b:	e8 3c 03 00 00       	call   80206c <sys_createSharedObject>
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
  801d4c:	68 a2 49 80 00       	push   $0x8049a2
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
  801d61:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d64:	83 ec 08             	sub    $0x8,%esp
  801d67:	ff 75 0c             	pushl  0xc(%ebp)
  801d6a:	ff 75 08             	pushl  0x8(%ebp)
  801d6d:	e8 24 03 00 00       	call   802096 <sys_getSizeOfSharedObject>
  801d72:	83 c4 10             	add    $0x10,%esp
  801d75:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801d78:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801d7c:	75 07                	jne    801d85 <sget+0x27>
  801d7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d83:	eb 5c                	jmp    801de1 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d8b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d98:	39 d0                	cmp    %edx,%eax
  801d9a:	7d 02                	jge    801d9e <sget+0x40>
  801d9c:	89 d0                	mov    %edx,%eax
  801d9e:	83 ec 0c             	sub    $0xc,%esp
  801da1:	50                   	push   %eax
  801da2:	e8 0b fc ff ff       	call   8019b2 <malloc>
  801da7:	83 c4 10             	add    $0x10,%esp
  801daa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801dad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801db1:	75 07                	jne    801dba <sget+0x5c>
  801db3:	b8 00 00 00 00       	mov    $0x0,%eax
  801db8:	eb 27                	jmp    801de1 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801dba:	83 ec 04             	sub    $0x4,%esp
  801dbd:	ff 75 e8             	pushl  -0x18(%ebp)
  801dc0:	ff 75 0c             	pushl  0xc(%ebp)
  801dc3:	ff 75 08             	pushl  0x8(%ebp)
  801dc6:	e8 e8 02 00 00       	call   8020b3 <sys_getSharedObject>
  801dcb:	83 c4 10             	add    $0x10,%esp
  801dce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801dd1:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801dd5:	75 07                	jne    801dde <sget+0x80>
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddc:	eb 03                	jmp    801de1 <sget+0x83>
	return ptr;
  801dde:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801de9:	83 ec 04             	sub    $0x4,%esp
  801dec:	68 a8 49 80 00       	push   $0x8049a8
  801df1:	68 c2 00 00 00       	push   $0xc2
  801df6:	68 96 49 80 00       	push   $0x804996
  801dfb:	e8 3d e9 ff ff       	call   80073d <_panic>

00801e00 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e06:	83 ec 04             	sub    $0x4,%esp
  801e09:	68 cc 49 80 00       	push   $0x8049cc
  801e0e:	68 d9 00 00 00       	push   $0xd9
  801e13:	68 96 49 80 00       	push   $0x804996
  801e18:	e8 20 e9 ff ff       	call   80073d <_panic>

00801e1d <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e23:	83 ec 04             	sub    $0x4,%esp
  801e26:	68 f2 49 80 00       	push   $0x8049f2
  801e2b:	68 e5 00 00 00       	push   $0xe5
  801e30:	68 96 49 80 00       	push   $0x804996
  801e35:	e8 03 e9 ff ff       	call   80073d <_panic>

00801e3a <shrink>:

}
void shrink(uint32 newSize)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e40:	83 ec 04             	sub    $0x4,%esp
  801e43:	68 f2 49 80 00       	push   $0x8049f2
  801e48:	68 ea 00 00 00       	push   $0xea
  801e4d:	68 96 49 80 00       	push   $0x804996
  801e52:	e8 e6 e8 ff ff       	call   80073d <_panic>

00801e57 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e5d:	83 ec 04             	sub    $0x4,%esp
  801e60:	68 f2 49 80 00       	push   $0x8049f2
  801e65:	68 ef 00 00 00       	push   $0xef
  801e6a:	68 96 49 80 00       	push   $0x804996
  801e6f:	e8 c9 e8 ff ff       	call   80073d <_panic>

00801e74 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	57                   	push   %edi
  801e78:	56                   	push   %esi
  801e79:	53                   	push   %ebx
  801e7a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e83:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e86:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e89:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e8c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e8f:	cd 30                	int    $0x30
  801e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e97:	83 c4 10             	add    $0x10,%esp
  801e9a:	5b                   	pop    %ebx
  801e9b:	5e                   	pop    %esi
  801e9c:	5f                   	pop    %edi
  801e9d:	5d                   	pop    %ebp
  801e9e:	c3                   	ret    

00801e9f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 04             	sub    $0x4,%esp
  801ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801eab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	52                   	push   %edx
  801eb7:	ff 75 0c             	pushl  0xc(%ebp)
  801eba:	50                   	push   %eax
  801ebb:	6a 00                	push   $0x0
  801ebd:	e8 b2 ff ff ff       	call   801e74 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	90                   	nop
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 02                	push   $0x2
  801ed7:	e8 98 ff ff ff       	call   801e74 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 03                	push   $0x3
  801ef0:	e8 7f ff ff ff       	call   801e74 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	90                   	nop
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 04                	push   $0x4
  801f0a:	e8 65 ff ff ff       	call   801e74 <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
}
  801f12:	90                   	nop
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	52                   	push   %edx
  801f25:	50                   	push   %eax
  801f26:	6a 08                	push   $0x8
  801f28:	e8 47 ff ff ff       	call   801e74 <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	56                   	push   %esi
  801f36:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f37:	8b 75 18             	mov    0x18(%ebp),%esi
  801f3a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	56                   	push   %esi
  801f47:	53                   	push   %ebx
  801f48:	51                   	push   %ecx
  801f49:	52                   	push   %edx
  801f4a:	50                   	push   %eax
  801f4b:	6a 09                	push   $0x9
  801f4d:	e8 22 ff ff ff       	call   801e74 <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
}
  801f55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f58:	5b                   	pop    %ebx
  801f59:	5e                   	pop    %esi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    

00801f5c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	52                   	push   %edx
  801f6c:	50                   	push   %eax
  801f6d:	6a 0a                	push   $0xa
  801f6f:	e8 00 ff ff ff       	call   801e74 <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	ff 75 0c             	pushl  0xc(%ebp)
  801f85:	ff 75 08             	pushl  0x8(%ebp)
  801f88:	6a 0b                	push   $0xb
  801f8a:	e8 e5 fe ff ff       	call   801e74 <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 0c                	push   $0xc
  801fa3:	e8 cc fe ff ff       	call   801e74 <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 0d                	push   $0xd
  801fbc:	e8 b3 fe ff ff       	call   801e74 <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 0e                	push   $0xe
  801fd5:	e8 9a fe ff ff       	call   801e74 <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 0f                	push   $0xf
  801fee:	e8 81 fe ff ff       	call   801e74 <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	ff 75 08             	pushl  0x8(%ebp)
  802006:	6a 10                	push   $0x10
  802008:	e8 67 fe ff ff       	call   801e74 <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 11                	push   $0x11
  802021:	e8 4e fe ff ff       	call   801e74 <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
}
  802029:	90                   	nop
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <sys_cputc>:

void
sys_cputc(const char c)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	83 ec 04             	sub    $0x4,%esp
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802038:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	50                   	push   %eax
  802045:	6a 01                	push   $0x1
  802047:	e8 28 fe ff ff       	call   801e74 <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
}
  80204f:	90                   	nop
  802050:	c9                   	leave  
  802051:	c3                   	ret    

00802052 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 14                	push   $0x14
  802061:	e8 0e fe ff ff       	call   801e74 <syscall>
  802066:	83 c4 18             	add    $0x18,%esp
}
  802069:	90                   	nop
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 04             	sub    $0x4,%esp
  802072:	8b 45 10             	mov    0x10(%ebp),%eax
  802075:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802078:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80207b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	6a 00                	push   $0x0
  802084:	51                   	push   %ecx
  802085:	52                   	push   %edx
  802086:	ff 75 0c             	pushl  0xc(%ebp)
  802089:	50                   	push   %eax
  80208a:	6a 15                	push   $0x15
  80208c:	e8 e3 fd ff ff       	call   801e74 <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802099:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	52                   	push   %edx
  8020a6:	50                   	push   %eax
  8020a7:	6a 16                	push   $0x16
  8020a9:	e8 c6 fd ff ff       	call   801e74 <syscall>
  8020ae:	83 c4 18             	add    $0x18,%esp
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	51                   	push   %ecx
  8020c4:	52                   	push   %edx
  8020c5:	50                   	push   %eax
  8020c6:	6a 17                	push   $0x17
  8020c8:	e8 a7 fd ff ff       	call   801e74 <syscall>
  8020cd:	83 c4 18             	add    $0x18,%esp
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	52                   	push   %edx
  8020e2:	50                   	push   %eax
  8020e3:	6a 18                	push   $0x18
  8020e5:	e8 8a fd ff ff       	call   801e74 <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	6a 00                	push   $0x0
  8020f7:	ff 75 14             	pushl  0x14(%ebp)
  8020fa:	ff 75 10             	pushl  0x10(%ebp)
  8020fd:	ff 75 0c             	pushl  0xc(%ebp)
  802100:	50                   	push   %eax
  802101:	6a 19                	push   $0x19
  802103:	e8 6c fd ff ff       	call   801e74 <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	50                   	push   %eax
  80211c:	6a 1a                	push   $0x1a
  80211e:	e8 51 fd ff ff       	call   801e74 <syscall>
  802123:	83 c4 18             	add    $0x18,%esp
}
  802126:	90                   	nop
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	50                   	push   %eax
  802138:	6a 1b                	push   $0x1b
  80213a:	e8 35 fd ff ff       	call   801e74 <syscall>
  80213f:	83 c4 18             	add    $0x18,%esp
}
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 05                	push   $0x5
  802153:	e8 1c fd ff ff       	call   801e74 <syscall>
  802158:	83 c4 18             	add    $0x18,%esp
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 06                	push   $0x6
  80216c:	e8 03 fd ff ff       	call   801e74 <syscall>
  802171:	83 c4 18             	add    $0x18,%esp
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 07                	push   $0x7
  802185:	e8 ea fc ff ff       	call   801e74 <syscall>
  80218a:	83 c4 18             	add    $0x18,%esp
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <sys_exit_env>:


void sys_exit_env(void)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 1c                	push   $0x1c
  80219e:	e8 d1 fc ff ff       	call   801e74 <syscall>
  8021a3:	83 c4 18             	add    $0x18,%esp
}
  8021a6:	90                   	nop
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021af:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021b2:	8d 50 04             	lea    0x4(%eax),%edx
  8021b5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	52                   	push   %edx
  8021bf:	50                   	push   %eax
  8021c0:	6a 1d                	push   $0x1d
  8021c2:	e8 ad fc ff ff       	call   801e74 <syscall>
  8021c7:	83 c4 18             	add    $0x18,%esp
	return result;
  8021ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021d3:	89 01                	mov    %eax,(%ecx)
  8021d5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	c9                   	leave  
  8021dc:	c2 04 00             	ret    $0x4

008021df <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	ff 75 10             	pushl  0x10(%ebp)
  8021e9:	ff 75 0c             	pushl  0xc(%ebp)
  8021ec:	ff 75 08             	pushl  0x8(%ebp)
  8021ef:	6a 13                	push   $0x13
  8021f1:	e8 7e fc ff ff       	call   801e74 <syscall>
  8021f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f9:	90                   	nop
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <sys_rcr2>:
uint32 sys_rcr2()
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 1e                	push   $0x1e
  80220b:	e8 64 fc ff ff       	call   801e74 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
  802218:	83 ec 04             	sub    $0x4,%esp
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802221:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	50                   	push   %eax
  80222e:	6a 1f                	push   $0x1f
  802230:	e8 3f fc ff ff       	call   801e74 <syscall>
  802235:	83 c4 18             	add    $0x18,%esp
	return ;
  802238:	90                   	nop
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <rsttst>:
void rsttst()
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 21                	push   $0x21
  80224a:	e8 25 fc ff ff       	call   801e74 <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
	return ;
  802252:	90                   	nop
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	83 ec 04             	sub    $0x4,%esp
  80225b:	8b 45 14             	mov    0x14(%ebp),%eax
  80225e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802261:	8b 55 18             	mov    0x18(%ebp),%edx
  802264:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802268:	52                   	push   %edx
  802269:	50                   	push   %eax
  80226a:	ff 75 10             	pushl  0x10(%ebp)
  80226d:	ff 75 0c             	pushl  0xc(%ebp)
  802270:	ff 75 08             	pushl  0x8(%ebp)
  802273:	6a 20                	push   $0x20
  802275:	e8 fa fb ff ff       	call   801e74 <syscall>
  80227a:	83 c4 18             	add    $0x18,%esp
	return ;
  80227d:	90                   	nop
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <chktst>:
void chktst(uint32 n)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	ff 75 08             	pushl  0x8(%ebp)
  80228e:	6a 22                	push   $0x22
  802290:	e8 df fb ff ff       	call   801e74 <syscall>
  802295:	83 c4 18             	add    $0x18,%esp
	return ;
  802298:	90                   	nop
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <inctst>:

void inctst()
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 23                	push   $0x23
  8022aa:	e8 c5 fb ff ff       	call   801e74 <syscall>
  8022af:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b2:	90                   	nop
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <gettst>:
uint32 gettst()
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 24                	push   $0x24
  8022c4:	e8 ab fb ff ff       	call   801e74 <syscall>
  8022c9:	83 c4 18             	add    $0x18,%esp
}
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
  8022d1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 25                	push   $0x25
  8022e0:	e8 8f fb ff ff       	call   801e74 <syscall>
  8022e5:	83 c4 18             	add    $0x18,%esp
  8022e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8022eb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8022ef:	75 07                	jne    8022f8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8022f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f6:	eb 05                	jmp    8022fd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 25                	push   $0x25
  802311:	e8 5e fb ff ff       	call   801e74 <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
  802319:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80231c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802320:	75 07                	jne    802329 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802322:	b8 01 00 00 00       	mov    $0x1,%eax
  802327:	eb 05                	jmp    80232e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802329:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 25                	push   $0x25
  802342:	e8 2d fb ff ff       	call   801e74 <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
  80234a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80234d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802351:	75 07                	jne    80235a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802353:	b8 01 00 00 00       	mov    $0x1,%eax
  802358:	eb 05                	jmp    80235f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80235a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
  802364:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 25                	push   $0x25
  802373:	e8 fc fa ff ff       	call   801e74 <syscall>
  802378:	83 c4 18             	add    $0x18,%esp
  80237b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80237e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802382:	75 07                	jne    80238b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802384:	b8 01 00 00 00       	mov    $0x1,%eax
  802389:	eb 05                	jmp    802390 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80238b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	ff 75 08             	pushl  0x8(%ebp)
  8023a0:	6a 26                	push   $0x26
  8023a2:	e8 cd fa ff ff       	call   801e74 <syscall>
  8023a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8023aa:	90                   	nop
}
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
  8023b0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	6a 00                	push   $0x0
  8023bf:	53                   	push   %ebx
  8023c0:	51                   	push   %ecx
  8023c1:	52                   	push   %edx
  8023c2:	50                   	push   %eax
  8023c3:	6a 27                	push   $0x27
  8023c5:	e8 aa fa ff ff       	call   801e74 <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
}
  8023cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023d0:	c9                   	leave  
  8023d1:	c3                   	ret    

008023d2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	52                   	push   %edx
  8023e2:	50                   	push   %eax
  8023e3:	6a 28                	push   $0x28
  8023e5:	e8 8a fa ff ff       	call   801e74 <syscall>
  8023ea:	83 c4 18             	add    $0x18,%esp
}
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8023f2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	6a 00                	push   $0x0
  8023fd:	51                   	push   %ecx
  8023fe:	ff 75 10             	pushl  0x10(%ebp)
  802401:	52                   	push   %edx
  802402:	50                   	push   %eax
  802403:	6a 29                	push   $0x29
  802405:	e8 6a fa ff ff       	call   801e74 <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
}
  80240d:	c9                   	leave  
  80240e:	c3                   	ret    

0080240f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	ff 75 10             	pushl  0x10(%ebp)
  802419:	ff 75 0c             	pushl  0xc(%ebp)
  80241c:	ff 75 08             	pushl  0x8(%ebp)
  80241f:	6a 12                	push   $0x12
  802421:	e8 4e fa ff ff       	call   801e74 <syscall>
  802426:	83 c4 18             	add    $0x18,%esp
	return ;
  802429:	90                   	nop
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80242f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	52                   	push   %edx
  80243c:	50                   	push   %eax
  80243d:	6a 2a                	push   $0x2a
  80243f:	e8 30 fa ff ff       	call   801e74 <syscall>
  802444:	83 c4 18             	add    $0x18,%esp
	return;
  802447:	90                   	nop
}
  802448:	c9                   	leave  
  802449:	c3                   	ret    

0080244a <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80244d:	8b 45 08             	mov    0x8(%ebp),%eax
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	50                   	push   %eax
  802459:	6a 2b                	push   $0x2b
  80245b:	e8 14 fa ff ff       	call   801e74 <syscall>
  802460:	83 c4 18             	add    $0x18,%esp
}
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	ff 75 0c             	pushl  0xc(%ebp)
  802471:	ff 75 08             	pushl  0x8(%ebp)
  802474:	6a 2c                	push   $0x2c
  802476:	e8 f9 f9 ff ff       	call   801e74 <syscall>
  80247b:	83 c4 18             	add    $0x18,%esp
	return;
  80247e:	90                   	nop
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	ff 75 0c             	pushl  0xc(%ebp)
  80248d:	ff 75 08             	pushl  0x8(%ebp)
  802490:	6a 2d                	push   $0x2d
  802492:	e8 dd f9 ff ff       	call   801e74 <syscall>
  802497:	83 c4 18             	add    $0x18,%esp
	return;
  80249a:	90                   	nop
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    

0080249d <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
  8024a0:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8024a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a6:	83 e8 04             	sub    $0x4,%eax
  8024a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8024ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024af:	8b 00                	mov    (%eax),%eax
  8024b1:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	83 e8 04             	sub    $0x4,%eax
  8024c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8024c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c8:	8b 00                	mov    (%eax),%eax
  8024ca:	83 e0 01             	and    $0x1,%eax
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	0f 94 c0             	sete   %al
}
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    

008024d4 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
  8024d7:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8024da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8024e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e4:	83 f8 02             	cmp    $0x2,%eax
  8024e7:	74 2b                	je     802514 <alloc_block+0x40>
  8024e9:	83 f8 02             	cmp    $0x2,%eax
  8024ec:	7f 07                	jg     8024f5 <alloc_block+0x21>
  8024ee:	83 f8 01             	cmp    $0x1,%eax
  8024f1:	74 0e                	je     802501 <alloc_block+0x2d>
  8024f3:	eb 58                	jmp    80254d <alloc_block+0x79>
  8024f5:	83 f8 03             	cmp    $0x3,%eax
  8024f8:	74 2d                	je     802527 <alloc_block+0x53>
  8024fa:	83 f8 04             	cmp    $0x4,%eax
  8024fd:	74 3b                	je     80253a <alloc_block+0x66>
  8024ff:	eb 4c                	jmp    80254d <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802501:	83 ec 0c             	sub    $0xc,%esp
  802504:	ff 75 08             	pushl  0x8(%ebp)
  802507:	e8 11 03 00 00       	call   80281d <alloc_block_FF>
  80250c:	83 c4 10             	add    $0x10,%esp
  80250f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802512:	eb 4a                	jmp    80255e <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802514:	83 ec 0c             	sub    $0xc,%esp
  802517:	ff 75 08             	pushl  0x8(%ebp)
  80251a:	e8 fa 19 00 00       	call   803f19 <alloc_block_NF>
  80251f:	83 c4 10             	add    $0x10,%esp
  802522:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802525:	eb 37                	jmp    80255e <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802527:	83 ec 0c             	sub    $0xc,%esp
  80252a:	ff 75 08             	pushl  0x8(%ebp)
  80252d:	e8 a7 07 00 00       	call   802cd9 <alloc_block_BF>
  802532:	83 c4 10             	add    $0x10,%esp
  802535:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802538:	eb 24                	jmp    80255e <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80253a:	83 ec 0c             	sub    $0xc,%esp
  80253d:	ff 75 08             	pushl  0x8(%ebp)
  802540:	e8 b7 19 00 00       	call   803efc <alloc_block_WF>
  802545:	83 c4 10             	add    $0x10,%esp
  802548:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80254b:	eb 11                	jmp    80255e <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80254d:	83 ec 0c             	sub    $0xc,%esp
  802550:	68 04 4a 80 00       	push   $0x804a04
  802555:	e8 a0 e4 ff ff       	call   8009fa <cprintf>
  80255a:	83 c4 10             	add    $0x10,%esp
		break;
  80255d:	90                   	nop
	}
	return va;
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802561:	c9                   	leave  
  802562:	c3                   	ret    

00802563 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
  802566:	53                   	push   %ebx
  802567:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80256a:	83 ec 0c             	sub    $0xc,%esp
  80256d:	68 24 4a 80 00       	push   $0x804a24
  802572:	e8 83 e4 ff ff       	call   8009fa <cprintf>
  802577:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80257a:	83 ec 0c             	sub    $0xc,%esp
  80257d:	68 4f 4a 80 00       	push   $0x804a4f
  802582:	e8 73 e4 ff ff       	call   8009fa <cprintf>
  802587:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802590:	eb 37                	jmp    8025c9 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802592:	83 ec 0c             	sub    $0xc,%esp
  802595:	ff 75 f4             	pushl  -0xc(%ebp)
  802598:	e8 19 ff ff ff       	call   8024b6 <is_free_block>
  80259d:	83 c4 10             	add    $0x10,%esp
  8025a0:	0f be d8             	movsbl %al,%ebx
  8025a3:	83 ec 0c             	sub    $0xc,%esp
  8025a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8025a9:	e8 ef fe ff ff       	call   80249d <get_block_size>
  8025ae:	83 c4 10             	add    $0x10,%esp
  8025b1:	83 ec 04             	sub    $0x4,%esp
  8025b4:	53                   	push   %ebx
  8025b5:	50                   	push   %eax
  8025b6:	68 67 4a 80 00       	push   $0x804a67
  8025bb:	e8 3a e4 ff ff       	call   8009fa <cprintf>
  8025c0:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8025c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8025c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cd:	74 07                	je     8025d6 <print_blocks_list+0x73>
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	eb 05                	jmp    8025db <print_blocks_list+0x78>
  8025d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025db:	89 45 10             	mov    %eax,0x10(%ebp)
  8025de:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e1:	85 c0                	test   %eax,%eax
  8025e3:	75 ad                	jne    802592 <print_blocks_list+0x2f>
  8025e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e9:	75 a7                	jne    802592 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8025eb:	83 ec 0c             	sub    $0xc,%esp
  8025ee:	68 24 4a 80 00       	push   $0x804a24
  8025f3:	e8 02 e4 ff ff       	call   8009fa <cprintf>
  8025f8:	83 c4 10             	add    $0x10,%esp

}
  8025fb:	90                   	nop
  8025fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025ff:	c9                   	leave  
  802600:	c3                   	ret    

00802601 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
  802604:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80260a:	83 e0 01             	and    $0x1,%eax
  80260d:	85 c0                	test   %eax,%eax
  80260f:	74 03                	je     802614 <initialize_dynamic_allocator+0x13>
  802611:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802614:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802618:	0f 84 c7 01 00 00    	je     8027e5 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80261e:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802625:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802628:	8b 55 08             	mov    0x8(%ebp),%edx
  80262b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262e:	01 d0                	add    %edx,%eax
  802630:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802635:	0f 87 ad 01 00 00    	ja     8027e8 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	85 c0                	test   %eax,%eax
  802640:	0f 89 a5 01 00 00    	jns    8027eb <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802646:	8b 55 08             	mov    0x8(%ebp),%edx
  802649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80264c:	01 d0                	add    %edx,%eax
  80264e:	83 e8 04             	sub    $0x4,%eax
  802651:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  802656:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80265d:	a1 30 50 80 00       	mov    0x805030,%eax
  802662:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802665:	e9 87 00 00 00       	jmp    8026f1 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80266a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266e:	75 14                	jne    802684 <initialize_dynamic_allocator+0x83>
  802670:	83 ec 04             	sub    $0x4,%esp
  802673:	68 7f 4a 80 00       	push   $0x804a7f
  802678:	6a 79                	push   $0x79
  80267a:	68 9d 4a 80 00       	push   $0x804a9d
  80267f:	e8 b9 e0 ff ff       	call   80073d <_panic>
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 00                	mov    (%eax),%eax
  802689:	85 c0                	test   %eax,%eax
  80268b:	74 10                	je     80269d <initialize_dynamic_allocator+0x9c>
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 00                	mov    (%eax),%eax
  802692:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802695:	8b 52 04             	mov    0x4(%edx),%edx
  802698:	89 50 04             	mov    %edx,0x4(%eax)
  80269b:	eb 0b                	jmp    8026a8 <initialize_dynamic_allocator+0xa7>
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	8b 40 04             	mov    0x4(%eax),%eax
  8026a3:	a3 34 50 80 00       	mov    %eax,0x805034
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 40 04             	mov    0x4(%eax),%eax
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	74 0f                	je     8026c1 <initialize_dynamic_allocator+0xc0>
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 40 04             	mov    0x4(%eax),%eax
  8026b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bb:	8b 12                	mov    (%edx),%edx
  8026bd:	89 10                	mov    %edx,(%eax)
  8026bf:	eb 0a                	jmp    8026cb <initialize_dynamic_allocator+0xca>
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	8b 00                	mov    (%eax),%eax
  8026c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026de:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026e3:	48                   	dec    %eax
  8026e4:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8026e9:	a1 38 50 80 00       	mov    0x805038,%eax
  8026ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f5:	74 07                	je     8026fe <initialize_dynamic_allocator+0xfd>
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 00                	mov    (%eax),%eax
  8026fc:	eb 05                	jmp    802703 <initialize_dynamic_allocator+0x102>
  8026fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802703:	a3 38 50 80 00       	mov    %eax,0x805038
  802708:	a1 38 50 80 00       	mov    0x805038,%eax
  80270d:	85 c0                	test   %eax,%eax
  80270f:	0f 85 55 ff ff ff    	jne    80266a <initialize_dynamic_allocator+0x69>
  802715:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802719:	0f 85 4b ff ff ff    	jne    80266a <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80271f:	8b 45 08             	mov    0x8(%ebp),%eax
  802722:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802728:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80272e:	a1 48 50 80 00       	mov    0x805048,%eax
  802733:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802738:	a1 44 50 80 00       	mov    0x805044,%eax
  80273d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802743:	8b 45 08             	mov    0x8(%ebp),%eax
  802746:	83 c0 08             	add    $0x8,%eax
  802749:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80274c:	8b 45 08             	mov    0x8(%ebp),%eax
  80274f:	83 c0 04             	add    $0x4,%eax
  802752:	8b 55 0c             	mov    0xc(%ebp),%edx
  802755:	83 ea 08             	sub    $0x8,%edx
  802758:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80275a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80275d:	8b 45 08             	mov    0x8(%ebp),%eax
  802760:	01 d0                	add    %edx,%eax
  802762:	83 e8 08             	sub    $0x8,%eax
  802765:	8b 55 0c             	mov    0xc(%ebp),%edx
  802768:	83 ea 08             	sub    $0x8,%edx
  80276b:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80276d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802770:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802776:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802779:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802780:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802784:	75 17                	jne    80279d <initialize_dynamic_allocator+0x19c>
  802786:	83 ec 04             	sub    $0x4,%esp
  802789:	68 b8 4a 80 00       	push   $0x804ab8
  80278e:	68 90 00 00 00       	push   $0x90
  802793:	68 9d 4a 80 00       	push   $0x804a9d
  802798:	e8 a0 df ff ff       	call   80073d <_panic>
  80279d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8027a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a6:	89 10                	mov    %edx,(%eax)
  8027a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	74 0d                	je     8027be <initialize_dynamic_allocator+0x1bd>
  8027b1:	a1 30 50 80 00       	mov    0x805030,%eax
  8027b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b9:	89 50 04             	mov    %edx,0x4(%eax)
  8027bc:	eb 08                	jmp    8027c6 <initialize_dynamic_allocator+0x1c5>
  8027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c1:	a3 34 50 80 00       	mov    %eax,0x805034
  8027c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8027ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027dd:	40                   	inc    %eax
  8027de:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8027e3:	eb 07                	jmp    8027ec <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8027e5:	90                   	nop
  8027e6:	eb 04                	jmp    8027ec <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8027e8:	90                   	nop
  8027e9:	eb 01                	jmp    8027ec <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8027eb:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8027ec:	c9                   	leave  
  8027ed:	c3                   	ret    

008027ee <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8027f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8027f4:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8027f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fa:	8d 50 fc             	lea    -0x4(%eax),%edx
  8027fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802800:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802802:	8b 45 08             	mov    0x8(%ebp),%eax
  802805:	83 e8 04             	sub    $0x4,%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	83 e0 fe             	and    $0xfffffffe,%eax
  80280d:	8d 50 f8             	lea    -0x8(%eax),%edx
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	01 c2                	add    %eax,%edx
  802815:	8b 45 0c             	mov    0xc(%ebp),%eax
  802818:	89 02                	mov    %eax,(%edx)
}
  80281a:	90                   	nop
  80281b:	5d                   	pop    %ebp
  80281c:	c3                   	ret    

0080281d <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80281d:	55                   	push   %ebp
  80281e:	89 e5                	mov    %esp,%ebp
  802820:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802823:	8b 45 08             	mov    0x8(%ebp),%eax
  802826:	83 e0 01             	and    $0x1,%eax
  802829:	85 c0                	test   %eax,%eax
  80282b:	74 03                	je     802830 <alloc_block_FF+0x13>
  80282d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802830:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802834:	77 07                	ja     80283d <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802836:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80283d:	a1 28 50 80 00       	mov    0x805028,%eax
  802842:	85 c0                	test   %eax,%eax
  802844:	75 73                	jne    8028b9 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802846:	8b 45 08             	mov    0x8(%ebp),%eax
  802849:	83 c0 10             	add    $0x10,%eax
  80284c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80284f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802856:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802859:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285c:	01 d0                	add    %edx,%eax
  80285e:	48                   	dec    %eax
  80285f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802862:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802865:	ba 00 00 00 00       	mov    $0x0,%edx
  80286a:	f7 75 ec             	divl   -0x14(%ebp)
  80286d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802870:	29 d0                	sub    %edx,%eax
  802872:	c1 e8 0c             	shr    $0xc,%eax
  802875:	83 ec 0c             	sub    $0xc,%esp
  802878:	50                   	push   %eax
  802879:	e8 1e f1 ff ff       	call   80199c <sbrk>
  80287e:	83 c4 10             	add    $0x10,%esp
  802881:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802884:	83 ec 0c             	sub    $0xc,%esp
  802887:	6a 00                	push   $0x0
  802889:	e8 0e f1 ff ff       	call   80199c <sbrk>
  80288e:	83 c4 10             	add    $0x10,%esp
  802891:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802894:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802897:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80289a:	83 ec 08             	sub    $0x8,%esp
  80289d:	50                   	push   %eax
  80289e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8028a1:	e8 5b fd ff ff       	call   802601 <initialize_dynamic_allocator>
  8028a6:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8028a9:	83 ec 0c             	sub    $0xc,%esp
  8028ac:	68 db 4a 80 00       	push   $0x804adb
  8028b1:	e8 44 e1 ff ff       	call   8009fa <cprintf>
  8028b6:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8028b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028bd:	75 0a                	jne    8028c9 <alloc_block_FF+0xac>
	        return NULL;
  8028bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c4:	e9 0e 04 00 00       	jmp    802cd7 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8028c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8028d0:	a1 30 50 80 00       	mov    0x805030,%eax
  8028d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d8:	e9 f3 02 00 00       	jmp    802bd0 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8028e3:	83 ec 0c             	sub    $0xc,%esp
  8028e6:	ff 75 bc             	pushl  -0x44(%ebp)
  8028e9:	e8 af fb ff ff       	call   80249d <get_block_size>
  8028ee:	83 c4 10             	add    $0x10,%esp
  8028f1:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	83 c0 08             	add    $0x8,%eax
  8028fa:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8028fd:	0f 87 c5 02 00 00    	ja     802bc8 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	83 c0 18             	add    $0x18,%eax
  802909:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80290c:	0f 87 19 02 00 00    	ja     802b2b <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802912:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802915:	2b 45 08             	sub    0x8(%ebp),%eax
  802918:	83 e8 08             	sub    $0x8,%eax
  80291b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	8d 50 08             	lea    0x8(%eax),%edx
  802924:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802927:	01 d0                	add    %edx,%eax
  802929:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	83 c0 08             	add    $0x8,%eax
  802932:	83 ec 04             	sub    $0x4,%esp
  802935:	6a 01                	push   $0x1
  802937:	50                   	push   %eax
  802938:	ff 75 bc             	pushl  -0x44(%ebp)
  80293b:	e8 ae fe ff ff       	call   8027ee <set_block_data>
  802940:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	8b 40 04             	mov    0x4(%eax),%eax
  802949:	85 c0                	test   %eax,%eax
  80294b:	75 68                	jne    8029b5 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80294d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802951:	75 17                	jne    80296a <alloc_block_FF+0x14d>
  802953:	83 ec 04             	sub    $0x4,%esp
  802956:	68 b8 4a 80 00       	push   $0x804ab8
  80295b:	68 d7 00 00 00       	push   $0xd7
  802960:	68 9d 4a 80 00       	push   $0x804a9d
  802965:	e8 d3 dd ff ff       	call   80073d <_panic>
  80296a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802970:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802973:	89 10                	mov    %edx,(%eax)
  802975:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802978:	8b 00                	mov    (%eax),%eax
  80297a:	85 c0                	test   %eax,%eax
  80297c:	74 0d                	je     80298b <alloc_block_FF+0x16e>
  80297e:	a1 30 50 80 00       	mov    0x805030,%eax
  802983:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802986:	89 50 04             	mov    %edx,0x4(%eax)
  802989:	eb 08                	jmp    802993 <alloc_block_FF+0x176>
  80298b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80298e:	a3 34 50 80 00       	mov    %eax,0x805034
  802993:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802996:	a3 30 50 80 00       	mov    %eax,0x805030
  80299b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80299e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8029aa:	40                   	inc    %eax
  8029ab:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8029b0:	e9 dc 00 00 00       	jmp    802a91 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	8b 00                	mov    (%eax),%eax
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	75 65                	jne    802a23 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029be:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029c2:	75 17                	jne    8029db <alloc_block_FF+0x1be>
  8029c4:	83 ec 04             	sub    $0x4,%esp
  8029c7:	68 ec 4a 80 00       	push   $0x804aec
  8029cc:	68 db 00 00 00       	push   $0xdb
  8029d1:	68 9d 4a 80 00       	push   $0x804a9d
  8029d6:	e8 62 dd ff ff       	call   80073d <_panic>
  8029db:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8029e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029e4:	89 50 04             	mov    %edx,0x4(%eax)
  8029e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029ea:	8b 40 04             	mov    0x4(%eax),%eax
  8029ed:	85 c0                	test   %eax,%eax
  8029ef:	74 0c                	je     8029fd <alloc_block_FF+0x1e0>
  8029f1:	a1 34 50 80 00       	mov    0x805034,%eax
  8029f6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029f9:	89 10                	mov    %edx,(%eax)
  8029fb:	eb 08                	jmp    802a05 <alloc_block_FF+0x1e8>
  8029fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a00:	a3 30 50 80 00       	mov    %eax,0x805030
  802a05:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a08:	a3 34 50 80 00       	mov    %eax,0x805034
  802a0d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a16:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a1b:	40                   	inc    %eax
  802a1c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a21:	eb 6e                	jmp    802a91 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802a23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a27:	74 06                	je     802a2f <alloc_block_FF+0x212>
  802a29:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a2d:	75 17                	jne    802a46 <alloc_block_FF+0x229>
  802a2f:	83 ec 04             	sub    $0x4,%esp
  802a32:	68 10 4b 80 00       	push   $0x804b10
  802a37:	68 df 00 00 00       	push   $0xdf
  802a3c:	68 9d 4a 80 00       	push   $0x804a9d
  802a41:	e8 f7 dc ff ff       	call   80073d <_panic>
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 10                	mov    (%eax),%edx
  802a4b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a4e:	89 10                	mov    %edx,(%eax)
  802a50:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a53:	8b 00                	mov    (%eax),%eax
  802a55:	85 c0                	test   %eax,%eax
  802a57:	74 0b                	je     802a64 <alloc_block_FF+0x247>
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 00                	mov    (%eax),%eax
  802a5e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a61:	89 50 04             	mov    %edx,0x4(%eax)
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a6a:	89 10                	mov    %edx,(%eax)
  802a6c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a72:	89 50 04             	mov    %edx,0x4(%eax)
  802a75:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a78:	8b 00                	mov    (%eax),%eax
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	75 08                	jne    802a86 <alloc_block_FF+0x269>
  802a7e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a81:	a3 34 50 80 00       	mov    %eax,0x805034
  802a86:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a8b:	40                   	inc    %eax
  802a8c:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802a91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a95:	75 17                	jne    802aae <alloc_block_FF+0x291>
  802a97:	83 ec 04             	sub    $0x4,%esp
  802a9a:	68 7f 4a 80 00       	push   $0x804a7f
  802a9f:	68 e1 00 00 00       	push   $0xe1
  802aa4:	68 9d 4a 80 00       	push   $0x804a9d
  802aa9:	e8 8f dc ff ff       	call   80073d <_panic>
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 00                	mov    (%eax),%eax
  802ab3:	85 c0                	test   %eax,%eax
  802ab5:	74 10                	je     802ac7 <alloc_block_FF+0x2aa>
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 00                	mov    (%eax),%eax
  802abc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802abf:	8b 52 04             	mov    0x4(%edx),%edx
  802ac2:	89 50 04             	mov    %edx,0x4(%eax)
  802ac5:	eb 0b                	jmp    802ad2 <alloc_block_FF+0x2b5>
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	8b 40 04             	mov    0x4(%eax),%eax
  802acd:	a3 34 50 80 00       	mov    %eax,0x805034
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	8b 40 04             	mov    0x4(%eax),%eax
  802ad8:	85 c0                	test   %eax,%eax
  802ada:	74 0f                	je     802aeb <alloc_block_FF+0x2ce>
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 40 04             	mov    0x4(%eax),%eax
  802ae2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae5:	8b 12                	mov    (%edx),%edx
  802ae7:	89 10                	mov    %edx,(%eax)
  802ae9:	eb 0a                	jmp    802af5 <alloc_block_FF+0x2d8>
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	8b 00                	mov    (%eax),%eax
  802af0:	a3 30 50 80 00       	mov    %eax,0x805030
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b08:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b0d:	48                   	dec    %eax
  802b0e:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802b13:	83 ec 04             	sub    $0x4,%esp
  802b16:	6a 00                	push   $0x0
  802b18:	ff 75 b4             	pushl  -0x4c(%ebp)
  802b1b:	ff 75 b0             	pushl  -0x50(%ebp)
  802b1e:	e8 cb fc ff ff       	call   8027ee <set_block_data>
  802b23:	83 c4 10             	add    $0x10,%esp
  802b26:	e9 95 00 00 00       	jmp    802bc0 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802b2b:	83 ec 04             	sub    $0x4,%esp
  802b2e:	6a 01                	push   $0x1
  802b30:	ff 75 b8             	pushl  -0x48(%ebp)
  802b33:	ff 75 bc             	pushl  -0x44(%ebp)
  802b36:	e8 b3 fc ff ff       	call   8027ee <set_block_data>
  802b3b:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802b3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b42:	75 17                	jne    802b5b <alloc_block_FF+0x33e>
  802b44:	83 ec 04             	sub    $0x4,%esp
  802b47:	68 7f 4a 80 00       	push   $0x804a7f
  802b4c:	68 e8 00 00 00       	push   $0xe8
  802b51:	68 9d 4a 80 00       	push   $0x804a9d
  802b56:	e8 e2 db ff ff       	call   80073d <_panic>
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 00                	mov    (%eax),%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	74 10                	je     802b74 <alloc_block_FF+0x357>
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	8b 00                	mov    (%eax),%eax
  802b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b6c:	8b 52 04             	mov    0x4(%edx),%edx
  802b6f:	89 50 04             	mov    %edx,0x4(%eax)
  802b72:	eb 0b                	jmp    802b7f <alloc_block_FF+0x362>
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 40 04             	mov    0x4(%eax),%eax
  802b7a:	a3 34 50 80 00       	mov    %eax,0x805034
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 40 04             	mov    0x4(%eax),%eax
  802b85:	85 c0                	test   %eax,%eax
  802b87:	74 0f                	je     802b98 <alloc_block_FF+0x37b>
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 40 04             	mov    0x4(%eax),%eax
  802b8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b92:	8b 12                	mov    (%edx),%edx
  802b94:	89 10                	mov    %edx,(%eax)
  802b96:	eb 0a                	jmp    802ba2 <alloc_block_FF+0x385>
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	8b 00                	mov    (%eax),%eax
  802b9d:	a3 30 50 80 00       	mov    %eax,0x805030
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bba:	48                   	dec    %eax
  802bbb:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802bc0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bc3:	e9 0f 01 00 00       	jmp    802cd7 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802bc8:	a1 38 50 80 00       	mov    0x805038,%eax
  802bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd4:	74 07                	je     802bdd <alloc_block_FF+0x3c0>
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	eb 05                	jmp    802be2 <alloc_block_FF+0x3c5>
  802bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  802be2:	a3 38 50 80 00       	mov    %eax,0x805038
  802be7:	a1 38 50 80 00       	mov    0x805038,%eax
  802bec:	85 c0                	test   %eax,%eax
  802bee:	0f 85 e9 fc ff ff    	jne    8028dd <alloc_block_FF+0xc0>
  802bf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf8:	0f 85 df fc ff ff    	jne    8028dd <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	83 c0 08             	add    $0x8,%eax
  802c04:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c07:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802c0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c11:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c14:	01 d0                	add    %edx,%eax
  802c16:	48                   	dec    %eax
  802c17:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802c1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c1d:	ba 00 00 00 00       	mov    $0x0,%edx
  802c22:	f7 75 d8             	divl   -0x28(%ebp)
  802c25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c28:	29 d0                	sub    %edx,%eax
  802c2a:	c1 e8 0c             	shr    $0xc,%eax
  802c2d:	83 ec 0c             	sub    $0xc,%esp
  802c30:	50                   	push   %eax
  802c31:	e8 66 ed ff ff       	call   80199c <sbrk>
  802c36:	83 c4 10             	add    $0x10,%esp
  802c39:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802c3c:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802c40:	75 0a                	jne    802c4c <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802c42:	b8 00 00 00 00       	mov    $0x0,%eax
  802c47:	e9 8b 00 00 00       	jmp    802cd7 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c4c:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802c53:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c59:	01 d0                	add    %edx,%eax
  802c5b:	48                   	dec    %eax
  802c5c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802c5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c62:	ba 00 00 00 00       	mov    $0x0,%edx
  802c67:	f7 75 cc             	divl   -0x34(%ebp)
  802c6a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c6d:	29 d0                	sub    %edx,%eax
  802c6f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c72:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c75:	01 d0                	add    %edx,%eax
  802c77:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802c7c:	a1 44 50 80 00       	mov    0x805044,%eax
  802c81:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c87:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c91:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c94:	01 d0                	add    %edx,%eax
  802c96:	48                   	dec    %eax
  802c97:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c9a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c9d:	ba 00 00 00 00       	mov    $0x0,%edx
  802ca2:	f7 75 c4             	divl   -0x3c(%ebp)
  802ca5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ca8:	29 d0                	sub    %edx,%eax
  802caa:	83 ec 04             	sub    $0x4,%esp
  802cad:	6a 01                	push   $0x1
  802caf:	50                   	push   %eax
  802cb0:	ff 75 d0             	pushl  -0x30(%ebp)
  802cb3:	e8 36 fb ff ff       	call   8027ee <set_block_data>
  802cb8:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802cbb:	83 ec 0c             	sub    $0xc,%esp
  802cbe:	ff 75 d0             	pushl  -0x30(%ebp)
  802cc1:	e8 1b 0a 00 00       	call   8036e1 <free_block>
  802cc6:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802cc9:	83 ec 0c             	sub    $0xc,%esp
  802ccc:	ff 75 08             	pushl  0x8(%ebp)
  802ccf:	e8 49 fb ff ff       	call   80281d <alloc_block_FF>
  802cd4:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802cd7:	c9                   	leave  
  802cd8:	c3                   	ret    

00802cd9 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802cd9:	55                   	push   %ebp
  802cda:	89 e5                	mov    %esp,%ebp
  802cdc:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	83 e0 01             	and    $0x1,%eax
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	74 03                	je     802cec <alloc_block_BF+0x13>
  802ce9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802cec:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802cf0:	77 07                	ja     802cf9 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802cf2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802cf9:	a1 28 50 80 00       	mov    0x805028,%eax
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	75 73                	jne    802d75 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	83 c0 10             	add    $0x10,%eax
  802d08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802d0b:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802d12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d18:	01 d0                	add    %edx,%eax
  802d1a:	48                   	dec    %eax
  802d1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d21:	ba 00 00 00 00       	mov    $0x0,%edx
  802d26:	f7 75 e0             	divl   -0x20(%ebp)
  802d29:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d2c:	29 d0                	sub    %edx,%eax
  802d2e:	c1 e8 0c             	shr    $0xc,%eax
  802d31:	83 ec 0c             	sub    $0xc,%esp
  802d34:	50                   	push   %eax
  802d35:	e8 62 ec ff ff       	call   80199c <sbrk>
  802d3a:	83 c4 10             	add    $0x10,%esp
  802d3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802d40:	83 ec 0c             	sub    $0xc,%esp
  802d43:	6a 00                	push   $0x0
  802d45:	e8 52 ec ff ff       	call   80199c <sbrk>
  802d4a:	83 c4 10             	add    $0x10,%esp
  802d4d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802d50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d53:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802d56:	83 ec 08             	sub    $0x8,%esp
  802d59:	50                   	push   %eax
  802d5a:	ff 75 d8             	pushl  -0x28(%ebp)
  802d5d:	e8 9f f8 ff ff       	call   802601 <initialize_dynamic_allocator>
  802d62:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802d65:	83 ec 0c             	sub    $0xc,%esp
  802d68:	68 db 4a 80 00       	push   $0x804adb
  802d6d:	e8 88 dc ff ff       	call   8009fa <cprintf>
  802d72:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802d75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802d7c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802d83:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802d8a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802d91:	a1 30 50 80 00       	mov    0x805030,%eax
  802d96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d99:	e9 1d 01 00 00       	jmp    802ebb <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da1:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802da4:	83 ec 0c             	sub    $0xc,%esp
  802da7:	ff 75 a8             	pushl  -0x58(%ebp)
  802daa:	e8 ee f6 ff ff       	call   80249d <get_block_size>
  802daf:	83 c4 10             	add    $0x10,%esp
  802db2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	83 c0 08             	add    $0x8,%eax
  802dbb:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802dbe:	0f 87 ef 00 00 00    	ja     802eb3 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc7:	83 c0 18             	add    $0x18,%eax
  802dca:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802dcd:	77 1d                	ja     802dec <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802dcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802dd5:	0f 86 d8 00 00 00    	jbe    802eb3 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802ddb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802dde:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802de1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802de4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802de7:	e9 c7 00 00 00       	jmp    802eb3 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	83 c0 08             	add    $0x8,%eax
  802df2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802df5:	0f 85 9d 00 00 00    	jne    802e98 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802dfb:	83 ec 04             	sub    $0x4,%esp
  802dfe:	6a 01                	push   $0x1
  802e00:	ff 75 a4             	pushl  -0x5c(%ebp)
  802e03:	ff 75 a8             	pushl  -0x58(%ebp)
  802e06:	e8 e3 f9 ff ff       	call   8027ee <set_block_data>
  802e0b:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802e0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e12:	75 17                	jne    802e2b <alloc_block_BF+0x152>
  802e14:	83 ec 04             	sub    $0x4,%esp
  802e17:	68 7f 4a 80 00       	push   $0x804a7f
  802e1c:	68 2c 01 00 00       	push   $0x12c
  802e21:	68 9d 4a 80 00       	push   $0x804a9d
  802e26:	e8 12 d9 ff ff       	call   80073d <_panic>
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	8b 00                	mov    (%eax),%eax
  802e30:	85 c0                	test   %eax,%eax
  802e32:	74 10                	je     802e44 <alloc_block_BF+0x16b>
  802e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e37:	8b 00                	mov    (%eax),%eax
  802e39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e3c:	8b 52 04             	mov    0x4(%edx),%edx
  802e3f:	89 50 04             	mov    %edx,0x4(%eax)
  802e42:	eb 0b                	jmp    802e4f <alloc_block_BF+0x176>
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	8b 40 04             	mov    0x4(%eax),%eax
  802e4a:	a3 34 50 80 00       	mov    %eax,0x805034
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 40 04             	mov    0x4(%eax),%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	74 0f                	je     802e68 <alloc_block_BF+0x18f>
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	8b 40 04             	mov    0x4(%eax),%eax
  802e5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e62:	8b 12                	mov    (%edx),%edx
  802e64:	89 10                	mov    %edx,(%eax)
  802e66:	eb 0a                	jmp    802e72 <alloc_block_BF+0x199>
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 00                	mov    (%eax),%eax
  802e6d:	a3 30 50 80 00       	mov    %eax,0x805030
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e85:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e8a:	48                   	dec    %eax
  802e8b:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802e90:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e93:	e9 24 04 00 00       	jmp    8032bc <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e9e:	76 13                	jbe    802eb3 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802ea0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802ea7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802eaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802ead:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802eb0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802eb3:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebf:	74 07                	je     802ec8 <alloc_block_BF+0x1ef>
  802ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec4:	8b 00                	mov    (%eax),%eax
  802ec6:	eb 05                	jmp    802ecd <alloc_block_BF+0x1f4>
  802ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ecd:	a3 38 50 80 00       	mov    %eax,0x805038
  802ed2:	a1 38 50 80 00       	mov    0x805038,%eax
  802ed7:	85 c0                	test   %eax,%eax
  802ed9:	0f 85 bf fe ff ff    	jne    802d9e <alloc_block_BF+0xc5>
  802edf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee3:	0f 85 b5 fe ff ff    	jne    802d9e <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802ee9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eed:	0f 84 26 02 00 00    	je     803119 <alloc_block_BF+0x440>
  802ef3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ef7:	0f 85 1c 02 00 00    	jne    803119 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f00:	2b 45 08             	sub    0x8(%ebp),%eax
  802f03:	83 e8 08             	sub    $0x8,%eax
  802f06:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	8d 50 08             	lea    0x8(%eax),%edx
  802f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f12:	01 d0                	add    %edx,%eax
  802f14:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	83 c0 08             	add    $0x8,%eax
  802f1d:	83 ec 04             	sub    $0x4,%esp
  802f20:	6a 01                	push   $0x1
  802f22:	50                   	push   %eax
  802f23:	ff 75 f0             	pushl  -0x10(%ebp)
  802f26:	e8 c3 f8 ff ff       	call   8027ee <set_block_data>
  802f2b:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f31:	8b 40 04             	mov    0x4(%eax),%eax
  802f34:	85 c0                	test   %eax,%eax
  802f36:	75 68                	jne    802fa0 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f38:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f3c:	75 17                	jne    802f55 <alloc_block_BF+0x27c>
  802f3e:	83 ec 04             	sub    $0x4,%esp
  802f41:	68 b8 4a 80 00       	push   $0x804ab8
  802f46:	68 45 01 00 00       	push   $0x145
  802f4b:	68 9d 4a 80 00       	push   $0x804a9d
  802f50:	e8 e8 d7 ff ff       	call   80073d <_panic>
  802f55:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f5e:	89 10                	mov    %edx,(%eax)
  802f60:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f63:	8b 00                	mov    (%eax),%eax
  802f65:	85 c0                	test   %eax,%eax
  802f67:	74 0d                	je     802f76 <alloc_block_BF+0x29d>
  802f69:	a1 30 50 80 00       	mov    0x805030,%eax
  802f6e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f71:	89 50 04             	mov    %edx,0x4(%eax)
  802f74:	eb 08                	jmp    802f7e <alloc_block_BF+0x2a5>
  802f76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f79:	a3 34 50 80 00       	mov    %eax,0x805034
  802f7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f81:	a3 30 50 80 00       	mov    %eax,0x805030
  802f86:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f90:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f95:	40                   	inc    %eax
  802f96:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802f9b:	e9 dc 00 00 00       	jmp    80307c <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa3:	8b 00                	mov    (%eax),%eax
  802fa5:	85 c0                	test   %eax,%eax
  802fa7:	75 65                	jne    80300e <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802fa9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fad:	75 17                	jne    802fc6 <alloc_block_BF+0x2ed>
  802faf:	83 ec 04             	sub    $0x4,%esp
  802fb2:	68 ec 4a 80 00       	push   $0x804aec
  802fb7:	68 4a 01 00 00       	push   $0x14a
  802fbc:	68 9d 4a 80 00       	push   $0x804a9d
  802fc1:	e8 77 d7 ff ff       	call   80073d <_panic>
  802fc6:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802fcc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fcf:	89 50 04             	mov    %edx,0x4(%eax)
  802fd2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fd5:	8b 40 04             	mov    0x4(%eax),%eax
  802fd8:	85 c0                	test   %eax,%eax
  802fda:	74 0c                	je     802fe8 <alloc_block_BF+0x30f>
  802fdc:	a1 34 50 80 00       	mov    0x805034,%eax
  802fe1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fe4:	89 10                	mov    %edx,(%eax)
  802fe6:	eb 08                	jmp    802ff0 <alloc_block_BF+0x317>
  802fe8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802feb:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ff3:	a3 34 50 80 00       	mov    %eax,0x805034
  802ff8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ffb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803001:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803006:	40                   	inc    %eax
  803007:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80300c:	eb 6e                	jmp    80307c <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80300e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803012:	74 06                	je     80301a <alloc_block_BF+0x341>
  803014:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803018:	75 17                	jne    803031 <alloc_block_BF+0x358>
  80301a:	83 ec 04             	sub    $0x4,%esp
  80301d:	68 10 4b 80 00       	push   $0x804b10
  803022:	68 4f 01 00 00       	push   $0x14f
  803027:	68 9d 4a 80 00       	push   $0x804a9d
  80302c:	e8 0c d7 ff ff       	call   80073d <_panic>
  803031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803034:	8b 10                	mov    (%eax),%edx
  803036:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803039:	89 10                	mov    %edx,(%eax)
  80303b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80303e:	8b 00                	mov    (%eax),%eax
  803040:	85 c0                	test   %eax,%eax
  803042:	74 0b                	je     80304f <alloc_block_BF+0x376>
  803044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803047:	8b 00                	mov    (%eax),%eax
  803049:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80304c:	89 50 04             	mov    %edx,0x4(%eax)
  80304f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803052:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803055:	89 10                	mov    %edx,(%eax)
  803057:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80305a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80305d:	89 50 04             	mov    %edx,0x4(%eax)
  803060:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803063:	8b 00                	mov    (%eax),%eax
  803065:	85 c0                	test   %eax,%eax
  803067:	75 08                	jne    803071 <alloc_block_BF+0x398>
  803069:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80306c:	a3 34 50 80 00       	mov    %eax,0x805034
  803071:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803076:	40                   	inc    %eax
  803077:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80307c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803080:	75 17                	jne    803099 <alloc_block_BF+0x3c0>
  803082:	83 ec 04             	sub    $0x4,%esp
  803085:	68 7f 4a 80 00       	push   $0x804a7f
  80308a:	68 51 01 00 00       	push   $0x151
  80308f:	68 9d 4a 80 00       	push   $0x804a9d
  803094:	e8 a4 d6 ff ff       	call   80073d <_panic>
  803099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	74 10                	je     8030b2 <alloc_block_BF+0x3d9>
  8030a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a5:	8b 00                	mov    (%eax),%eax
  8030a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030aa:	8b 52 04             	mov    0x4(%edx),%edx
  8030ad:	89 50 04             	mov    %edx,0x4(%eax)
  8030b0:	eb 0b                	jmp    8030bd <alloc_block_BF+0x3e4>
  8030b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b5:	8b 40 04             	mov    0x4(%eax),%eax
  8030b8:	a3 34 50 80 00       	mov    %eax,0x805034
  8030bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c0:	8b 40 04             	mov    0x4(%eax),%eax
  8030c3:	85 c0                	test   %eax,%eax
  8030c5:	74 0f                	je     8030d6 <alloc_block_BF+0x3fd>
  8030c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ca:	8b 40 04             	mov    0x4(%eax),%eax
  8030cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030d0:	8b 12                	mov    (%edx),%edx
  8030d2:	89 10                	mov    %edx,(%eax)
  8030d4:	eb 0a                	jmp    8030e0 <alloc_block_BF+0x407>
  8030d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d9:	8b 00                	mov    (%eax),%eax
  8030db:	a3 30 50 80 00       	mov    %eax,0x805030
  8030e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030f8:	48                   	dec    %eax
  8030f9:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  8030fe:	83 ec 04             	sub    $0x4,%esp
  803101:	6a 00                	push   $0x0
  803103:	ff 75 d0             	pushl  -0x30(%ebp)
  803106:	ff 75 cc             	pushl  -0x34(%ebp)
  803109:	e8 e0 f6 ff ff       	call   8027ee <set_block_data>
  80310e:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803114:	e9 a3 01 00 00       	jmp    8032bc <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803119:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80311d:	0f 85 9d 00 00 00    	jne    8031c0 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803123:	83 ec 04             	sub    $0x4,%esp
  803126:	6a 01                	push   $0x1
  803128:	ff 75 ec             	pushl  -0x14(%ebp)
  80312b:	ff 75 f0             	pushl  -0x10(%ebp)
  80312e:	e8 bb f6 ff ff       	call   8027ee <set_block_data>
  803133:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803136:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80313a:	75 17                	jne    803153 <alloc_block_BF+0x47a>
  80313c:	83 ec 04             	sub    $0x4,%esp
  80313f:	68 7f 4a 80 00       	push   $0x804a7f
  803144:	68 58 01 00 00       	push   $0x158
  803149:	68 9d 4a 80 00       	push   $0x804a9d
  80314e:	e8 ea d5 ff ff       	call   80073d <_panic>
  803153:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803156:	8b 00                	mov    (%eax),%eax
  803158:	85 c0                	test   %eax,%eax
  80315a:	74 10                	je     80316c <alloc_block_BF+0x493>
  80315c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315f:	8b 00                	mov    (%eax),%eax
  803161:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803164:	8b 52 04             	mov    0x4(%edx),%edx
  803167:	89 50 04             	mov    %edx,0x4(%eax)
  80316a:	eb 0b                	jmp    803177 <alloc_block_BF+0x49e>
  80316c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316f:	8b 40 04             	mov    0x4(%eax),%eax
  803172:	a3 34 50 80 00       	mov    %eax,0x805034
  803177:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317a:	8b 40 04             	mov    0x4(%eax),%eax
  80317d:	85 c0                	test   %eax,%eax
  80317f:	74 0f                	je     803190 <alloc_block_BF+0x4b7>
  803181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803184:	8b 40 04             	mov    0x4(%eax),%eax
  803187:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80318a:	8b 12                	mov    (%edx),%edx
  80318c:	89 10                	mov    %edx,(%eax)
  80318e:	eb 0a                	jmp    80319a <alloc_block_BF+0x4c1>
  803190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803193:	8b 00                	mov    (%eax),%eax
  803195:	a3 30 50 80 00       	mov    %eax,0x805030
  80319a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ad:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031b2:	48                   	dec    %eax
  8031b3:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  8031b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bb:	e9 fc 00 00 00       	jmp    8032bc <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8031c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c3:	83 c0 08             	add    $0x8,%eax
  8031c6:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8031c9:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8031d0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031d3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8031d6:	01 d0                	add    %edx,%eax
  8031d8:	48                   	dec    %eax
  8031d9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8031dc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031df:	ba 00 00 00 00       	mov    $0x0,%edx
  8031e4:	f7 75 c4             	divl   -0x3c(%ebp)
  8031e7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031ea:	29 d0                	sub    %edx,%eax
  8031ec:	c1 e8 0c             	shr    $0xc,%eax
  8031ef:	83 ec 0c             	sub    $0xc,%esp
  8031f2:	50                   	push   %eax
  8031f3:	e8 a4 e7 ff ff       	call   80199c <sbrk>
  8031f8:	83 c4 10             	add    $0x10,%esp
  8031fb:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8031fe:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803202:	75 0a                	jne    80320e <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803204:	b8 00 00 00 00       	mov    $0x0,%eax
  803209:	e9 ae 00 00 00       	jmp    8032bc <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80320e:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803215:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803218:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80321b:	01 d0                	add    %edx,%eax
  80321d:	48                   	dec    %eax
  80321e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803221:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803224:	ba 00 00 00 00       	mov    $0x0,%edx
  803229:	f7 75 b8             	divl   -0x48(%ebp)
  80322c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80322f:	29 d0                	sub    %edx,%eax
  803231:	8d 50 fc             	lea    -0x4(%eax),%edx
  803234:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803237:	01 d0                	add    %edx,%eax
  803239:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  80323e:	a1 44 50 80 00       	mov    0x805044,%eax
  803243:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803249:	83 ec 0c             	sub    $0xc,%esp
  80324c:	68 44 4b 80 00       	push   $0x804b44
  803251:	e8 a4 d7 ff ff       	call   8009fa <cprintf>
  803256:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803259:	83 ec 08             	sub    $0x8,%esp
  80325c:	ff 75 bc             	pushl  -0x44(%ebp)
  80325f:	68 49 4b 80 00       	push   $0x804b49
  803264:	e8 91 d7 ff ff       	call   8009fa <cprintf>
  803269:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80326c:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803273:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803276:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803279:	01 d0                	add    %edx,%eax
  80327b:	48                   	dec    %eax
  80327c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80327f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803282:	ba 00 00 00 00       	mov    $0x0,%edx
  803287:	f7 75 b0             	divl   -0x50(%ebp)
  80328a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80328d:	29 d0                	sub    %edx,%eax
  80328f:	83 ec 04             	sub    $0x4,%esp
  803292:	6a 01                	push   $0x1
  803294:	50                   	push   %eax
  803295:	ff 75 bc             	pushl  -0x44(%ebp)
  803298:	e8 51 f5 ff ff       	call   8027ee <set_block_data>
  80329d:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8032a0:	83 ec 0c             	sub    $0xc,%esp
  8032a3:	ff 75 bc             	pushl  -0x44(%ebp)
  8032a6:	e8 36 04 00 00       	call   8036e1 <free_block>
  8032ab:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8032ae:	83 ec 0c             	sub    $0xc,%esp
  8032b1:	ff 75 08             	pushl  0x8(%ebp)
  8032b4:	e8 20 fa ff ff       	call   802cd9 <alloc_block_BF>
  8032b9:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8032bc:	c9                   	leave  
  8032bd:	c3                   	ret    

008032be <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8032be:	55                   	push   %ebp
  8032bf:	89 e5                	mov    %esp,%ebp
  8032c1:	53                   	push   %ebx
  8032c2:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8032c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8032cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8032d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d7:	74 1e                	je     8032f7 <merging+0x39>
  8032d9:	ff 75 08             	pushl  0x8(%ebp)
  8032dc:	e8 bc f1 ff ff       	call   80249d <get_block_size>
  8032e1:	83 c4 04             	add    $0x4,%esp
  8032e4:	89 c2                	mov    %eax,%edx
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	01 d0                	add    %edx,%eax
  8032eb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8032ee:	75 07                	jne    8032f7 <merging+0x39>
		prev_is_free = 1;
  8032f0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8032f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032fb:	74 1e                	je     80331b <merging+0x5d>
  8032fd:	ff 75 10             	pushl  0x10(%ebp)
  803300:	e8 98 f1 ff ff       	call   80249d <get_block_size>
  803305:	83 c4 04             	add    $0x4,%esp
  803308:	89 c2                	mov    %eax,%edx
  80330a:	8b 45 10             	mov    0x10(%ebp),%eax
  80330d:	01 d0                	add    %edx,%eax
  80330f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803312:	75 07                	jne    80331b <merging+0x5d>
		next_is_free = 1;
  803314:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80331b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80331f:	0f 84 cc 00 00 00    	je     8033f1 <merging+0x133>
  803325:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803329:	0f 84 c2 00 00 00    	je     8033f1 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80332f:	ff 75 08             	pushl  0x8(%ebp)
  803332:	e8 66 f1 ff ff       	call   80249d <get_block_size>
  803337:	83 c4 04             	add    $0x4,%esp
  80333a:	89 c3                	mov    %eax,%ebx
  80333c:	ff 75 10             	pushl  0x10(%ebp)
  80333f:	e8 59 f1 ff ff       	call   80249d <get_block_size>
  803344:	83 c4 04             	add    $0x4,%esp
  803347:	01 c3                	add    %eax,%ebx
  803349:	ff 75 0c             	pushl  0xc(%ebp)
  80334c:	e8 4c f1 ff ff       	call   80249d <get_block_size>
  803351:	83 c4 04             	add    $0x4,%esp
  803354:	01 d8                	add    %ebx,%eax
  803356:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803359:	6a 00                	push   $0x0
  80335b:	ff 75 ec             	pushl  -0x14(%ebp)
  80335e:	ff 75 08             	pushl  0x8(%ebp)
  803361:	e8 88 f4 ff ff       	call   8027ee <set_block_data>
  803366:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803369:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80336d:	75 17                	jne    803386 <merging+0xc8>
  80336f:	83 ec 04             	sub    $0x4,%esp
  803372:	68 7f 4a 80 00       	push   $0x804a7f
  803377:	68 7d 01 00 00       	push   $0x17d
  80337c:	68 9d 4a 80 00       	push   $0x804a9d
  803381:	e8 b7 d3 ff ff       	call   80073d <_panic>
  803386:	8b 45 0c             	mov    0xc(%ebp),%eax
  803389:	8b 00                	mov    (%eax),%eax
  80338b:	85 c0                	test   %eax,%eax
  80338d:	74 10                	je     80339f <merging+0xe1>
  80338f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803392:	8b 00                	mov    (%eax),%eax
  803394:	8b 55 0c             	mov    0xc(%ebp),%edx
  803397:	8b 52 04             	mov    0x4(%edx),%edx
  80339a:	89 50 04             	mov    %edx,0x4(%eax)
  80339d:	eb 0b                	jmp    8033aa <merging+0xec>
  80339f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a2:	8b 40 04             	mov    0x4(%eax),%eax
  8033a5:	a3 34 50 80 00       	mov    %eax,0x805034
  8033aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ad:	8b 40 04             	mov    0x4(%eax),%eax
  8033b0:	85 c0                	test   %eax,%eax
  8033b2:	74 0f                	je     8033c3 <merging+0x105>
  8033b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b7:	8b 40 04             	mov    0x4(%eax),%eax
  8033ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033bd:	8b 12                	mov    (%edx),%edx
  8033bf:	89 10                	mov    %edx,(%eax)
  8033c1:	eb 0a                	jmp    8033cd <merging+0x10f>
  8033c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c6:	8b 00                	mov    (%eax),%eax
  8033c8:	a3 30 50 80 00       	mov    %eax,0x805030
  8033cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8033e5:	48                   	dec    %eax
  8033e6:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8033eb:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8033ec:	e9 ea 02 00 00       	jmp    8036db <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8033f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f5:	74 3b                	je     803432 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8033f7:	83 ec 0c             	sub    $0xc,%esp
  8033fa:	ff 75 08             	pushl  0x8(%ebp)
  8033fd:	e8 9b f0 ff ff       	call   80249d <get_block_size>
  803402:	83 c4 10             	add    $0x10,%esp
  803405:	89 c3                	mov    %eax,%ebx
  803407:	83 ec 0c             	sub    $0xc,%esp
  80340a:	ff 75 10             	pushl  0x10(%ebp)
  80340d:	e8 8b f0 ff ff       	call   80249d <get_block_size>
  803412:	83 c4 10             	add    $0x10,%esp
  803415:	01 d8                	add    %ebx,%eax
  803417:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80341a:	83 ec 04             	sub    $0x4,%esp
  80341d:	6a 00                	push   $0x0
  80341f:	ff 75 e8             	pushl  -0x18(%ebp)
  803422:	ff 75 08             	pushl  0x8(%ebp)
  803425:	e8 c4 f3 ff ff       	call   8027ee <set_block_data>
  80342a:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80342d:	e9 a9 02 00 00       	jmp    8036db <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803432:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803436:	0f 84 2d 01 00 00    	je     803569 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80343c:	83 ec 0c             	sub    $0xc,%esp
  80343f:	ff 75 10             	pushl  0x10(%ebp)
  803442:	e8 56 f0 ff ff       	call   80249d <get_block_size>
  803447:	83 c4 10             	add    $0x10,%esp
  80344a:	89 c3                	mov    %eax,%ebx
  80344c:	83 ec 0c             	sub    $0xc,%esp
  80344f:	ff 75 0c             	pushl  0xc(%ebp)
  803452:	e8 46 f0 ff ff       	call   80249d <get_block_size>
  803457:	83 c4 10             	add    $0x10,%esp
  80345a:	01 d8                	add    %ebx,%eax
  80345c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80345f:	83 ec 04             	sub    $0x4,%esp
  803462:	6a 00                	push   $0x0
  803464:	ff 75 e4             	pushl  -0x1c(%ebp)
  803467:	ff 75 10             	pushl  0x10(%ebp)
  80346a:	e8 7f f3 ff ff       	call   8027ee <set_block_data>
  80346f:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803472:	8b 45 10             	mov    0x10(%ebp),%eax
  803475:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803478:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80347c:	74 06                	je     803484 <merging+0x1c6>
  80347e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803482:	75 17                	jne    80349b <merging+0x1dd>
  803484:	83 ec 04             	sub    $0x4,%esp
  803487:	68 58 4b 80 00       	push   $0x804b58
  80348c:	68 8d 01 00 00       	push   $0x18d
  803491:	68 9d 4a 80 00       	push   $0x804a9d
  803496:	e8 a2 d2 ff ff       	call   80073d <_panic>
  80349b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349e:	8b 50 04             	mov    0x4(%eax),%edx
  8034a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034a4:	89 50 04             	mov    %edx,0x4(%eax)
  8034a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034ad:	89 10                	mov    %edx,(%eax)
  8034af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b2:	8b 40 04             	mov    0x4(%eax),%eax
  8034b5:	85 c0                	test   %eax,%eax
  8034b7:	74 0d                	je     8034c6 <merging+0x208>
  8034b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034bc:	8b 40 04             	mov    0x4(%eax),%eax
  8034bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034c2:	89 10                	mov    %edx,(%eax)
  8034c4:	eb 08                	jmp    8034ce <merging+0x210>
  8034c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034d4:	89 50 04             	mov    %edx,0x4(%eax)
  8034d7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034dc:	40                   	inc    %eax
  8034dd:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  8034e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034e6:	75 17                	jne    8034ff <merging+0x241>
  8034e8:	83 ec 04             	sub    $0x4,%esp
  8034eb:	68 7f 4a 80 00       	push   $0x804a7f
  8034f0:	68 8e 01 00 00       	push   $0x18e
  8034f5:	68 9d 4a 80 00       	push   $0x804a9d
  8034fa:	e8 3e d2 ff ff       	call   80073d <_panic>
  8034ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803502:	8b 00                	mov    (%eax),%eax
  803504:	85 c0                	test   %eax,%eax
  803506:	74 10                	je     803518 <merging+0x25a>
  803508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80350b:	8b 00                	mov    (%eax),%eax
  80350d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803510:	8b 52 04             	mov    0x4(%edx),%edx
  803513:	89 50 04             	mov    %edx,0x4(%eax)
  803516:	eb 0b                	jmp    803523 <merging+0x265>
  803518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351b:	8b 40 04             	mov    0x4(%eax),%eax
  80351e:	a3 34 50 80 00       	mov    %eax,0x805034
  803523:	8b 45 0c             	mov    0xc(%ebp),%eax
  803526:	8b 40 04             	mov    0x4(%eax),%eax
  803529:	85 c0                	test   %eax,%eax
  80352b:	74 0f                	je     80353c <merging+0x27e>
  80352d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803530:	8b 40 04             	mov    0x4(%eax),%eax
  803533:	8b 55 0c             	mov    0xc(%ebp),%edx
  803536:	8b 12                	mov    (%edx),%edx
  803538:	89 10                	mov    %edx,(%eax)
  80353a:	eb 0a                	jmp    803546 <merging+0x288>
  80353c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80353f:	8b 00                	mov    (%eax),%eax
  803541:	a3 30 50 80 00       	mov    %eax,0x805030
  803546:	8b 45 0c             	mov    0xc(%ebp),%eax
  803549:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80354f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803552:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803559:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80355e:	48                   	dec    %eax
  80355f:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803564:	e9 72 01 00 00       	jmp    8036db <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803569:	8b 45 10             	mov    0x10(%ebp),%eax
  80356c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80356f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803573:	74 79                	je     8035ee <merging+0x330>
  803575:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803579:	74 73                	je     8035ee <merging+0x330>
  80357b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80357f:	74 06                	je     803587 <merging+0x2c9>
  803581:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803585:	75 17                	jne    80359e <merging+0x2e0>
  803587:	83 ec 04             	sub    $0x4,%esp
  80358a:	68 10 4b 80 00       	push   $0x804b10
  80358f:	68 94 01 00 00       	push   $0x194
  803594:	68 9d 4a 80 00       	push   $0x804a9d
  803599:	e8 9f d1 ff ff       	call   80073d <_panic>
  80359e:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a1:	8b 10                	mov    (%eax),%edx
  8035a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035a6:	89 10                	mov    %edx,(%eax)
  8035a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035ab:	8b 00                	mov    (%eax),%eax
  8035ad:	85 c0                	test   %eax,%eax
  8035af:	74 0b                	je     8035bc <merging+0x2fe>
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	8b 00                	mov    (%eax),%eax
  8035b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035b9:	89 50 04             	mov    %edx,0x4(%eax)
  8035bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035c2:	89 10                	mov    %edx,(%eax)
  8035c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ca:	89 50 04             	mov    %edx,0x4(%eax)
  8035cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035d0:	8b 00                	mov    (%eax),%eax
  8035d2:	85 c0                	test   %eax,%eax
  8035d4:	75 08                	jne    8035de <merging+0x320>
  8035d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035d9:	a3 34 50 80 00       	mov    %eax,0x805034
  8035de:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035e3:	40                   	inc    %eax
  8035e4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035e9:	e9 ce 00 00 00       	jmp    8036bc <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8035ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f2:	74 65                	je     803659 <merging+0x39b>
  8035f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035f8:	75 17                	jne    803611 <merging+0x353>
  8035fa:	83 ec 04             	sub    $0x4,%esp
  8035fd:	68 ec 4a 80 00       	push   $0x804aec
  803602:	68 95 01 00 00       	push   $0x195
  803607:	68 9d 4a 80 00       	push   $0x804a9d
  80360c:	e8 2c d1 ff ff       	call   80073d <_panic>
  803611:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803617:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80361a:	89 50 04             	mov    %edx,0x4(%eax)
  80361d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803620:	8b 40 04             	mov    0x4(%eax),%eax
  803623:	85 c0                	test   %eax,%eax
  803625:	74 0c                	je     803633 <merging+0x375>
  803627:	a1 34 50 80 00       	mov    0x805034,%eax
  80362c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80362f:	89 10                	mov    %edx,(%eax)
  803631:	eb 08                	jmp    80363b <merging+0x37d>
  803633:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803636:	a3 30 50 80 00       	mov    %eax,0x805030
  80363b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80363e:	a3 34 50 80 00       	mov    %eax,0x805034
  803643:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803646:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80364c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803651:	40                   	inc    %eax
  803652:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803657:	eb 63                	jmp    8036bc <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803659:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80365d:	75 17                	jne    803676 <merging+0x3b8>
  80365f:	83 ec 04             	sub    $0x4,%esp
  803662:	68 b8 4a 80 00       	push   $0x804ab8
  803667:	68 98 01 00 00       	push   $0x198
  80366c:	68 9d 4a 80 00       	push   $0x804a9d
  803671:	e8 c7 d0 ff ff       	call   80073d <_panic>
  803676:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80367c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80367f:	89 10                	mov    %edx,(%eax)
  803681:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803684:	8b 00                	mov    (%eax),%eax
  803686:	85 c0                	test   %eax,%eax
  803688:	74 0d                	je     803697 <merging+0x3d9>
  80368a:	a1 30 50 80 00       	mov    0x805030,%eax
  80368f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803692:	89 50 04             	mov    %edx,0x4(%eax)
  803695:	eb 08                	jmp    80369f <merging+0x3e1>
  803697:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80369a:	a3 34 50 80 00       	mov    %eax,0x805034
  80369f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8036a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036b1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036b6:	40                   	inc    %eax
  8036b7:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  8036bc:	83 ec 0c             	sub    $0xc,%esp
  8036bf:	ff 75 10             	pushl  0x10(%ebp)
  8036c2:	e8 d6 ed ff ff       	call   80249d <get_block_size>
  8036c7:	83 c4 10             	add    $0x10,%esp
  8036ca:	83 ec 04             	sub    $0x4,%esp
  8036cd:	6a 00                	push   $0x0
  8036cf:	50                   	push   %eax
  8036d0:	ff 75 10             	pushl  0x10(%ebp)
  8036d3:	e8 16 f1 ff ff       	call   8027ee <set_block_data>
  8036d8:	83 c4 10             	add    $0x10,%esp
	}
}
  8036db:	90                   	nop
  8036dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8036df:	c9                   	leave  
  8036e0:	c3                   	ret    

008036e1 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8036e1:	55                   	push   %ebp
  8036e2:	89 e5                	mov    %esp,%ebp
  8036e4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8036e7:	a1 30 50 80 00       	mov    0x805030,%eax
  8036ec:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8036ef:	a1 34 50 80 00       	mov    0x805034,%eax
  8036f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036f7:	73 1b                	jae    803714 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8036f9:	a1 34 50 80 00       	mov    0x805034,%eax
  8036fe:	83 ec 04             	sub    $0x4,%esp
  803701:	ff 75 08             	pushl  0x8(%ebp)
  803704:	6a 00                	push   $0x0
  803706:	50                   	push   %eax
  803707:	e8 b2 fb ff ff       	call   8032be <merging>
  80370c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80370f:	e9 8b 00 00 00       	jmp    80379f <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803714:	a1 30 50 80 00       	mov    0x805030,%eax
  803719:	3b 45 08             	cmp    0x8(%ebp),%eax
  80371c:	76 18                	jbe    803736 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80371e:	a1 30 50 80 00       	mov    0x805030,%eax
  803723:	83 ec 04             	sub    $0x4,%esp
  803726:	ff 75 08             	pushl  0x8(%ebp)
  803729:	50                   	push   %eax
  80372a:	6a 00                	push   $0x0
  80372c:	e8 8d fb ff ff       	call   8032be <merging>
  803731:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803734:	eb 69                	jmp    80379f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803736:	a1 30 50 80 00       	mov    0x805030,%eax
  80373b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80373e:	eb 39                	jmp    803779 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803743:	3b 45 08             	cmp    0x8(%ebp),%eax
  803746:	73 29                	jae    803771 <free_block+0x90>
  803748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374b:	8b 00                	mov    (%eax),%eax
  80374d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803750:	76 1f                	jbe    803771 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803755:	8b 00                	mov    (%eax),%eax
  803757:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80375a:	83 ec 04             	sub    $0x4,%esp
  80375d:	ff 75 08             	pushl  0x8(%ebp)
  803760:	ff 75 f0             	pushl  -0x10(%ebp)
  803763:	ff 75 f4             	pushl  -0xc(%ebp)
  803766:	e8 53 fb ff ff       	call   8032be <merging>
  80376b:	83 c4 10             	add    $0x10,%esp
			break;
  80376e:	90                   	nop
		}
	}
}
  80376f:	eb 2e                	jmp    80379f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803771:	a1 38 50 80 00       	mov    0x805038,%eax
  803776:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80377d:	74 07                	je     803786 <free_block+0xa5>
  80377f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803782:	8b 00                	mov    (%eax),%eax
  803784:	eb 05                	jmp    80378b <free_block+0xaa>
  803786:	b8 00 00 00 00       	mov    $0x0,%eax
  80378b:	a3 38 50 80 00       	mov    %eax,0x805038
  803790:	a1 38 50 80 00       	mov    0x805038,%eax
  803795:	85 c0                	test   %eax,%eax
  803797:	75 a7                	jne    803740 <free_block+0x5f>
  803799:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80379d:	75 a1                	jne    803740 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80379f:	90                   	nop
  8037a0:	c9                   	leave  
  8037a1:	c3                   	ret    

008037a2 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8037a2:	55                   	push   %ebp
  8037a3:	89 e5                	mov    %esp,%ebp
  8037a5:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8037a8:	ff 75 08             	pushl  0x8(%ebp)
  8037ab:	e8 ed ec ff ff       	call   80249d <get_block_size>
  8037b0:	83 c4 04             	add    $0x4,%esp
  8037b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8037b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8037bd:	eb 17                	jmp    8037d6 <copy_data+0x34>
  8037bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8037c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037c5:	01 c2                	add    %eax,%edx
  8037c7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8037ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cd:	01 c8                	add    %ecx,%eax
  8037cf:	8a 00                	mov    (%eax),%al
  8037d1:	88 02                	mov    %al,(%edx)
  8037d3:	ff 45 fc             	incl   -0x4(%ebp)
  8037d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8037dc:	72 e1                	jb     8037bf <copy_data+0x1d>
}
  8037de:	90                   	nop
  8037df:	c9                   	leave  
  8037e0:	c3                   	ret    

008037e1 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8037e1:	55                   	push   %ebp
  8037e2:	89 e5                	mov    %esp,%ebp
  8037e4:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8037e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037eb:	75 23                	jne    803810 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8037ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037f1:	74 13                	je     803806 <realloc_block_FF+0x25>
  8037f3:	83 ec 0c             	sub    $0xc,%esp
  8037f6:	ff 75 0c             	pushl  0xc(%ebp)
  8037f9:	e8 1f f0 ff ff       	call   80281d <alloc_block_FF>
  8037fe:	83 c4 10             	add    $0x10,%esp
  803801:	e9 f4 06 00 00       	jmp    803efa <realloc_block_FF+0x719>
		return NULL;
  803806:	b8 00 00 00 00       	mov    $0x0,%eax
  80380b:	e9 ea 06 00 00       	jmp    803efa <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803810:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803814:	75 18                	jne    80382e <realloc_block_FF+0x4d>
	{
		free_block(va);
  803816:	83 ec 0c             	sub    $0xc,%esp
  803819:	ff 75 08             	pushl  0x8(%ebp)
  80381c:	e8 c0 fe ff ff       	call   8036e1 <free_block>
  803821:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803824:	b8 00 00 00 00       	mov    $0x0,%eax
  803829:	e9 cc 06 00 00       	jmp    803efa <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80382e:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803832:	77 07                	ja     80383b <realloc_block_FF+0x5a>
  803834:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80383b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80383e:	83 e0 01             	and    $0x1,%eax
  803841:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803844:	8b 45 0c             	mov    0xc(%ebp),%eax
  803847:	83 c0 08             	add    $0x8,%eax
  80384a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80384d:	83 ec 0c             	sub    $0xc,%esp
  803850:	ff 75 08             	pushl  0x8(%ebp)
  803853:	e8 45 ec ff ff       	call   80249d <get_block_size>
  803858:	83 c4 10             	add    $0x10,%esp
  80385b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80385e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803861:	83 e8 08             	sub    $0x8,%eax
  803864:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803867:	8b 45 08             	mov    0x8(%ebp),%eax
  80386a:	83 e8 04             	sub    $0x4,%eax
  80386d:	8b 00                	mov    (%eax),%eax
  80386f:	83 e0 fe             	and    $0xfffffffe,%eax
  803872:	89 c2                	mov    %eax,%edx
  803874:	8b 45 08             	mov    0x8(%ebp),%eax
  803877:	01 d0                	add    %edx,%eax
  803879:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80387c:	83 ec 0c             	sub    $0xc,%esp
  80387f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803882:	e8 16 ec ff ff       	call   80249d <get_block_size>
  803887:	83 c4 10             	add    $0x10,%esp
  80388a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80388d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803890:	83 e8 08             	sub    $0x8,%eax
  803893:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803896:	8b 45 0c             	mov    0xc(%ebp),%eax
  803899:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80389c:	75 08                	jne    8038a6 <realloc_block_FF+0xc5>
	{
		 return va;
  80389e:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a1:	e9 54 06 00 00       	jmp    803efa <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8038a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038a9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038ac:	0f 83 e5 03 00 00    	jae    803c97 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8038b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b5:	2b 45 0c             	sub    0xc(%ebp),%eax
  8038b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8038bb:	83 ec 0c             	sub    $0xc,%esp
  8038be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038c1:	e8 f0 eb ff ff       	call   8024b6 <is_free_block>
  8038c6:	83 c4 10             	add    $0x10,%esp
  8038c9:	84 c0                	test   %al,%al
  8038cb:	0f 84 3b 01 00 00    	je     803a0c <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8038d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038d7:	01 d0                	add    %edx,%eax
  8038d9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8038dc:	83 ec 04             	sub    $0x4,%esp
  8038df:	6a 01                	push   $0x1
  8038e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8038e4:	ff 75 08             	pushl  0x8(%ebp)
  8038e7:	e8 02 ef ff ff       	call   8027ee <set_block_data>
  8038ec:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8038ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f2:	83 e8 04             	sub    $0x4,%eax
  8038f5:	8b 00                	mov    (%eax),%eax
  8038f7:	83 e0 fe             	and    $0xfffffffe,%eax
  8038fa:	89 c2                	mov    %eax,%edx
  8038fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ff:	01 d0                	add    %edx,%eax
  803901:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803904:	83 ec 04             	sub    $0x4,%esp
  803907:	6a 00                	push   $0x0
  803909:	ff 75 cc             	pushl  -0x34(%ebp)
  80390c:	ff 75 c8             	pushl  -0x38(%ebp)
  80390f:	e8 da ee ff ff       	call   8027ee <set_block_data>
  803914:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803917:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80391b:	74 06                	je     803923 <realloc_block_FF+0x142>
  80391d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803921:	75 17                	jne    80393a <realloc_block_FF+0x159>
  803923:	83 ec 04             	sub    $0x4,%esp
  803926:	68 10 4b 80 00       	push   $0x804b10
  80392b:	68 f6 01 00 00       	push   $0x1f6
  803930:	68 9d 4a 80 00       	push   $0x804a9d
  803935:	e8 03 ce ff ff       	call   80073d <_panic>
  80393a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393d:	8b 10                	mov    (%eax),%edx
  80393f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803942:	89 10                	mov    %edx,(%eax)
  803944:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803947:	8b 00                	mov    (%eax),%eax
  803949:	85 c0                	test   %eax,%eax
  80394b:	74 0b                	je     803958 <realloc_block_FF+0x177>
  80394d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803950:	8b 00                	mov    (%eax),%eax
  803952:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803955:	89 50 04             	mov    %edx,0x4(%eax)
  803958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80395e:	89 10                	mov    %edx,(%eax)
  803960:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803963:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803966:	89 50 04             	mov    %edx,0x4(%eax)
  803969:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80396c:	8b 00                	mov    (%eax),%eax
  80396e:	85 c0                	test   %eax,%eax
  803970:	75 08                	jne    80397a <realloc_block_FF+0x199>
  803972:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803975:	a3 34 50 80 00       	mov    %eax,0x805034
  80397a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80397f:	40                   	inc    %eax
  803980:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803985:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803989:	75 17                	jne    8039a2 <realloc_block_FF+0x1c1>
  80398b:	83 ec 04             	sub    $0x4,%esp
  80398e:	68 7f 4a 80 00       	push   $0x804a7f
  803993:	68 f7 01 00 00       	push   $0x1f7
  803998:	68 9d 4a 80 00       	push   $0x804a9d
  80399d:	e8 9b cd ff ff       	call   80073d <_panic>
  8039a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a5:	8b 00                	mov    (%eax),%eax
  8039a7:	85 c0                	test   %eax,%eax
  8039a9:	74 10                	je     8039bb <realloc_block_FF+0x1da>
  8039ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ae:	8b 00                	mov    (%eax),%eax
  8039b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039b3:	8b 52 04             	mov    0x4(%edx),%edx
  8039b6:	89 50 04             	mov    %edx,0x4(%eax)
  8039b9:	eb 0b                	jmp    8039c6 <realloc_block_FF+0x1e5>
  8039bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039be:	8b 40 04             	mov    0x4(%eax),%eax
  8039c1:	a3 34 50 80 00       	mov    %eax,0x805034
  8039c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c9:	8b 40 04             	mov    0x4(%eax),%eax
  8039cc:	85 c0                	test   %eax,%eax
  8039ce:	74 0f                	je     8039df <realloc_block_FF+0x1fe>
  8039d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d3:	8b 40 04             	mov    0x4(%eax),%eax
  8039d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039d9:	8b 12                	mov    (%edx),%edx
  8039db:	89 10                	mov    %edx,(%eax)
  8039dd:	eb 0a                	jmp    8039e9 <realloc_block_FF+0x208>
  8039df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e2:	8b 00                	mov    (%eax),%eax
  8039e4:	a3 30 50 80 00       	mov    %eax,0x805030
  8039e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039fc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a01:	48                   	dec    %eax
  803a02:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a07:	e9 83 02 00 00       	jmp    803c8f <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803a0c:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803a10:	0f 86 69 02 00 00    	jbe    803c7f <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803a16:	83 ec 04             	sub    $0x4,%esp
  803a19:	6a 01                	push   $0x1
  803a1b:	ff 75 f0             	pushl  -0x10(%ebp)
  803a1e:	ff 75 08             	pushl  0x8(%ebp)
  803a21:	e8 c8 ed ff ff       	call   8027ee <set_block_data>
  803a26:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a29:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2c:	83 e8 04             	sub    $0x4,%eax
  803a2f:	8b 00                	mov    (%eax),%eax
  803a31:	83 e0 fe             	and    $0xfffffffe,%eax
  803a34:	89 c2                	mov    %eax,%edx
  803a36:	8b 45 08             	mov    0x8(%ebp),%eax
  803a39:	01 d0                	add    %edx,%eax
  803a3b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803a3e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a43:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803a46:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803a4a:	75 68                	jne    803ab4 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a4c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a50:	75 17                	jne    803a69 <realloc_block_FF+0x288>
  803a52:	83 ec 04             	sub    $0x4,%esp
  803a55:	68 b8 4a 80 00       	push   $0x804ab8
  803a5a:	68 06 02 00 00       	push   $0x206
  803a5f:	68 9d 4a 80 00       	push   $0x804a9d
  803a64:	e8 d4 cc ff ff       	call   80073d <_panic>
  803a69:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a72:	89 10                	mov    %edx,(%eax)
  803a74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a77:	8b 00                	mov    (%eax),%eax
  803a79:	85 c0                	test   %eax,%eax
  803a7b:	74 0d                	je     803a8a <realloc_block_FF+0x2a9>
  803a7d:	a1 30 50 80 00       	mov    0x805030,%eax
  803a82:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a85:	89 50 04             	mov    %edx,0x4(%eax)
  803a88:	eb 08                	jmp    803a92 <realloc_block_FF+0x2b1>
  803a8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a8d:	a3 34 50 80 00       	mov    %eax,0x805034
  803a92:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a95:	a3 30 50 80 00       	mov    %eax,0x805030
  803a9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aa4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803aa9:	40                   	inc    %eax
  803aaa:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803aaf:	e9 b0 01 00 00       	jmp    803c64 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803ab4:	a1 30 50 80 00       	mov    0x805030,%eax
  803ab9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803abc:	76 68                	jbe    803b26 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803abe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ac2:	75 17                	jne    803adb <realloc_block_FF+0x2fa>
  803ac4:	83 ec 04             	sub    $0x4,%esp
  803ac7:	68 b8 4a 80 00       	push   $0x804ab8
  803acc:	68 0b 02 00 00       	push   $0x20b
  803ad1:	68 9d 4a 80 00       	push   $0x804a9d
  803ad6:	e8 62 cc ff ff       	call   80073d <_panic>
  803adb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803ae1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae4:	89 10                	mov    %edx,(%eax)
  803ae6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ae9:	8b 00                	mov    (%eax),%eax
  803aeb:	85 c0                	test   %eax,%eax
  803aed:	74 0d                	je     803afc <realloc_block_FF+0x31b>
  803aef:	a1 30 50 80 00       	mov    0x805030,%eax
  803af4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803af7:	89 50 04             	mov    %edx,0x4(%eax)
  803afa:	eb 08                	jmp    803b04 <realloc_block_FF+0x323>
  803afc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aff:	a3 34 50 80 00       	mov    %eax,0x805034
  803b04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b07:	a3 30 50 80 00       	mov    %eax,0x805030
  803b0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b16:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b1b:	40                   	inc    %eax
  803b1c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b21:	e9 3e 01 00 00       	jmp    803c64 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803b26:	a1 30 50 80 00       	mov    0x805030,%eax
  803b2b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b2e:	73 68                	jae    803b98 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b30:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b34:	75 17                	jne    803b4d <realloc_block_FF+0x36c>
  803b36:	83 ec 04             	sub    $0x4,%esp
  803b39:	68 ec 4a 80 00       	push   $0x804aec
  803b3e:	68 10 02 00 00       	push   $0x210
  803b43:	68 9d 4a 80 00       	push   $0x804a9d
  803b48:	e8 f0 cb ff ff       	call   80073d <_panic>
  803b4d:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803b53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b56:	89 50 04             	mov    %edx,0x4(%eax)
  803b59:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b5c:	8b 40 04             	mov    0x4(%eax),%eax
  803b5f:	85 c0                	test   %eax,%eax
  803b61:	74 0c                	je     803b6f <realloc_block_FF+0x38e>
  803b63:	a1 34 50 80 00       	mov    0x805034,%eax
  803b68:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b6b:	89 10                	mov    %edx,(%eax)
  803b6d:	eb 08                	jmp    803b77 <realloc_block_FF+0x396>
  803b6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b72:	a3 30 50 80 00       	mov    %eax,0x805030
  803b77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b7a:	a3 34 50 80 00       	mov    %eax,0x805034
  803b7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b88:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b8d:	40                   	inc    %eax
  803b8e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b93:	e9 cc 00 00 00       	jmp    803c64 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803b98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803b9f:	a1 30 50 80 00       	mov    0x805030,%eax
  803ba4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ba7:	e9 8a 00 00 00       	jmp    803c36 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803baf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bb2:	73 7a                	jae    803c2e <realloc_block_FF+0x44d>
  803bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb7:	8b 00                	mov    (%eax),%eax
  803bb9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bbc:	73 70                	jae    803c2e <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803bbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bc2:	74 06                	je     803bca <realloc_block_FF+0x3e9>
  803bc4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bc8:	75 17                	jne    803be1 <realloc_block_FF+0x400>
  803bca:	83 ec 04             	sub    $0x4,%esp
  803bcd:	68 10 4b 80 00       	push   $0x804b10
  803bd2:	68 1a 02 00 00       	push   $0x21a
  803bd7:	68 9d 4a 80 00       	push   $0x804a9d
  803bdc:	e8 5c cb ff ff       	call   80073d <_panic>
  803be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be4:	8b 10                	mov    (%eax),%edx
  803be6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be9:	89 10                	mov    %edx,(%eax)
  803beb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bee:	8b 00                	mov    (%eax),%eax
  803bf0:	85 c0                	test   %eax,%eax
  803bf2:	74 0b                	je     803bff <realloc_block_FF+0x41e>
  803bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf7:	8b 00                	mov    (%eax),%eax
  803bf9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bfc:	89 50 04             	mov    %edx,0x4(%eax)
  803bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c02:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c05:	89 10                	mov    %edx,(%eax)
  803c07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c0d:	89 50 04             	mov    %edx,0x4(%eax)
  803c10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c13:	8b 00                	mov    (%eax),%eax
  803c15:	85 c0                	test   %eax,%eax
  803c17:	75 08                	jne    803c21 <realloc_block_FF+0x440>
  803c19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c1c:	a3 34 50 80 00       	mov    %eax,0x805034
  803c21:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c26:	40                   	inc    %eax
  803c27:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803c2c:	eb 36                	jmp    803c64 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803c2e:	a1 38 50 80 00       	mov    0x805038,%eax
  803c33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c3a:	74 07                	je     803c43 <realloc_block_FF+0x462>
  803c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c3f:	8b 00                	mov    (%eax),%eax
  803c41:	eb 05                	jmp    803c48 <realloc_block_FF+0x467>
  803c43:	b8 00 00 00 00       	mov    $0x0,%eax
  803c48:	a3 38 50 80 00       	mov    %eax,0x805038
  803c4d:	a1 38 50 80 00       	mov    0x805038,%eax
  803c52:	85 c0                	test   %eax,%eax
  803c54:	0f 85 52 ff ff ff    	jne    803bac <realloc_block_FF+0x3cb>
  803c5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c5e:	0f 85 48 ff ff ff    	jne    803bac <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803c64:	83 ec 04             	sub    $0x4,%esp
  803c67:	6a 00                	push   $0x0
  803c69:	ff 75 d8             	pushl  -0x28(%ebp)
  803c6c:	ff 75 d4             	pushl  -0x2c(%ebp)
  803c6f:	e8 7a eb ff ff       	call   8027ee <set_block_data>
  803c74:	83 c4 10             	add    $0x10,%esp
				return va;
  803c77:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7a:	e9 7b 02 00 00       	jmp    803efa <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803c7f:	83 ec 0c             	sub    $0xc,%esp
  803c82:	68 8d 4b 80 00       	push   $0x804b8d
  803c87:	e8 6e cd ff ff       	call   8009fa <cprintf>
  803c8c:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c92:	e9 63 02 00 00       	jmp    803efa <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c9a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c9d:	0f 86 4d 02 00 00    	jbe    803ef0 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803ca3:	83 ec 0c             	sub    $0xc,%esp
  803ca6:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ca9:	e8 08 e8 ff ff       	call   8024b6 <is_free_block>
  803cae:	83 c4 10             	add    $0x10,%esp
  803cb1:	84 c0                	test   %al,%al
  803cb3:	0f 84 37 02 00 00    	je     803ef0 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cbc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803cbf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803cc2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803cc5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803cc8:	76 38                	jbe    803d02 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803cca:	83 ec 0c             	sub    $0xc,%esp
  803ccd:	ff 75 08             	pushl  0x8(%ebp)
  803cd0:	e8 0c fa ff ff       	call   8036e1 <free_block>
  803cd5:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803cd8:	83 ec 0c             	sub    $0xc,%esp
  803cdb:	ff 75 0c             	pushl  0xc(%ebp)
  803cde:	e8 3a eb ff ff       	call   80281d <alloc_block_FF>
  803ce3:	83 c4 10             	add    $0x10,%esp
  803ce6:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803ce9:	83 ec 08             	sub    $0x8,%esp
  803cec:	ff 75 c0             	pushl  -0x40(%ebp)
  803cef:	ff 75 08             	pushl  0x8(%ebp)
  803cf2:	e8 ab fa ff ff       	call   8037a2 <copy_data>
  803cf7:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803cfa:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803cfd:	e9 f8 01 00 00       	jmp    803efa <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803d02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d05:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803d08:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803d0b:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803d0f:	0f 87 a0 00 00 00    	ja     803db5 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d19:	75 17                	jne    803d32 <realloc_block_FF+0x551>
  803d1b:	83 ec 04             	sub    $0x4,%esp
  803d1e:	68 7f 4a 80 00       	push   $0x804a7f
  803d23:	68 38 02 00 00       	push   $0x238
  803d28:	68 9d 4a 80 00       	push   $0x804a9d
  803d2d:	e8 0b ca ff ff       	call   80073d <_panic>
  803d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d35:	8b 00                	mov    (%eax),%eax
  803d37:	85 c0                	test   %eax,%eax
  803d39:	74 10                	je     803d4b <realloc_block_FF+0x56a>
  803d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3e:	8b 00                	mov    (%eax),%eax
  803d40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d43:	8b 52 04             	mov    0x4(%edx),%edx
  803d46:	89 50 04             	mov    %edx,0x4(%eax)
  803d49:	eb 0b                	jmp    803d56 <realloc_block_FF+0x575>
  803d4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4e:	8b 40 04             	mov    0x4(%eax),%eax
  803d51:	a3 34 50 80 00       	mov    %eax,0x805034
  803d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d59:	8b 40 04             	mov    0x4(%eax),%eax
  803d5c:	85 c0                	test   %eax,%eax
  803d5e:	74 0f                	je     803d6f <realloc_block_FF+0x58e>
  803d60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d63:	8b 40 04             	mov    0x4(%eax),%eax
  803d66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d69:	8b 12                	mov    (%edx),%edx
  803d6b:	89 10                	mov    %edx,(%eax)
  803d6d:	eb 0a                	jmp    803d79 <realloc_block_FF+0x598>
  803d6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d72:	8b 00                	mov    (%eax),%eax
  803d74:	a3 30 50 80 00       	mov    %eax,0x805030
  803d79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d8c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d91:	48                   	dec    %eax
  803d92:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803d97:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d9d:	01 d0                	add    %edx,%eax
  803d9f:	83 ec 04             	sub    $0x4,%esp
  803da2:	6a 01                	push   $0x1
  803da4:	50                   	push   %eax
  803da5:	ff 75 08             	pushl  0x8(%ebp)
  803da8:	e8 41 ea ff ff       	call   8027ee <set_block_data>
  803dad:	83 c4 10             	add    $0x10,%esp
  803db0:	e9 36 01 00 00       	jmp    803eeb <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803db5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803db8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803dbb:	01 d0                	add    %edx,%eax
  803dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803dc0:	83 ec 04             	sub    $0x4,%esp
  803dc3:	6a 01                	push   $0x1
  803dc5:	ff 75 f0             	pushl  -0x10(%ebp)
  803dc8:	ff 75 08             	pushl  0x8(%ebp)
  803dcb:	e8 1e ea ff ff       	call   8027ee <set_block_data>
  803dd0:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd6:	83 e8 04             	sub    $0x4,%eax
  803dd9:	8b 00                	mov    (%eax),%eax
  803ddb:	83 e0 fe             	and    $0xfffffffe,%eax
  803dde:	89 c2                	mov    %eax,%edx
  803de0:	8b 45 08             	mov    0x8(%ebp),%eax
  803de3:	01 d0                	add    %edx,%eax
  803de5:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803de8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803dec:	74 06                	je     803df4 <realloc_block_FF+0x613>
  803dee:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803df2:	75 17                	jne    803e0b <realloc_block_FF+0x62a>
  803df4:	83 ec 04             	sub    $0x4,%esp
  803df7:	68 10 4b 80 00       	push   $0x804b10
  803dfc:	68 44 02 00 00       	push   $0x244
  803e01:	68 9d 4a 80 00       	push   $0x804a9d
  803e06:	e8 32 c9 ff ff       	call   80073d <_panic>
  803e0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e0e:	8b 10                	mov    (%eax),%edx
  803e10:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e13:	89 10                	mov    %edx,(%eax)
  803e15:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e18:	8b 00                	mov    (%eax),%eax
  803e1a:	85 c0                	test   %eax,%eax
  803e1c:	74 0b                	je     803e29 <realloc_block_FF+0x648>
  803e1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e21:	8b 00                	mov    (%eax),%eax
  803e23:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e26:	89 50 04             	mov    %edx,0x4(%eax)
  803e29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e2c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e2f:	89 10                	mov    %edx,(%eax)
  803e31:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e37:	89 50 04             	mov    %edx,0x4(%eax)
  803e3a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e3d:	8b 00                	mov    (%eax),%eax
  803e3f:	85 c0                	test   %eax,%eax
  803e41:	75 08                	jne    803e4b <realloc_block_FF+0x66a>
  803e43:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e46:	a3 34 50 80 00       	mov    %eax,0x805034
  803e4b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e50:	40                   	inc    %eax
  803e51:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803e56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e5a:	75 17                	jne    803e73 <realloc_block_FF+0x692>
  803e5c:	83 ec 04             	sub    $0x4,%esp
  803e5f:	68 7f 4a 80 00       	push   $0x804a7f
  803e64:	68 45 02 00 00       	push   $0x245
  803e69:	68 9d 4a 80 00       	push   $0x804a9d
  803e6e:	e8 ca c8 ff ff       	call   80073d <_panic>
  803e73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e76:	8b 00                	mov    (%eax),%eax
  803e78:	85 c0                	test   %eax,%eax
  803e7a:	74 10                	je     803e8c <realloc_block_FF+0x6ab>
  803e7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e7f:	8b 00                	mov    (%eax),%eax
  803e81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e84:	8b 52 04             	mov    0x4(%edx),%edx
  803e87:	89 50 04             	mov    %edx,0x4(%eax)
  803e8a:	eb 0b                	jmp    803e97 <realloc_block_FF+0x6b6>
  803e8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e8f:	8b 40 04             	mov    0x4(%eax),%eax
  803e92:	a3 34 50 80 00       	mov    %eax,0x805034
  803e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e9a:	8b 40 04             	mov    0x4(%eax),%eax
  803e9d:	85 c0                	test   %eax,%eax
  803e9f:	74 0f                	je     803eb0 <realloc_block_FF+0x6cf>
  803ea1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea4:	8b 40 04             	mov    0x4(%eax),%eax
  803ea7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803eaa:	8b 12                	mov    (%edx),%edx
  803eac:	89 10                	mov    %edx,(%eax)
  803eae:	eb 0a                	jmp    803eba <realloc_block_FF+0x6d9>
  803eb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb3:	8b 00                	mov    (%eax),%eax
  803eb5:	a3 30 50 80 00       	mov    %eax,0x805030
  803eba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ebd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ec3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ecd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ed2:	48                   	dec    %eax
  803ed3:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803ed8:	83 ec 04             	sub    $0x4,%esp
  803edb:	6a 00                	push   $0x0
  803edd:	ff 75 bc             	pushl  -0x44(%ebp)
  803ee0:	ff 75 b8             	pushl  -0x48(%ebp)
  803ee3:	e8 06 e9 ff ff       	call   8027ee <set_block_data>
  803ee8:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  803eee:	eb 0a                	jmp    803efa <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803ef0:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803ef7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803efa:	c9                   	leave  
  803efb:	c3                   	ret    

00803efc <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803efc:	55                   	push   %ebp
  803efd:	89 e5                	mov    %esp,%ebp
  803eff:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803f02:	83 ec 04             	sub    $0x4,%esp
  803f05:	68 94 4b 80 00       	push   $0x804b94
  803f0a:	68 58 02 00 00       	push   $0x258
  803f0f:	68 9d 4a 80 00       	push   $0x804a9d
  803f14:	e8 24 c8 ff ff       	call   80073d <_panic>

00803f19 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803f19:	55                   	push   %ebp
  803f1a:	89 e5                	mov    %esp,%ebp
  803f1c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803f1f:	83 ec 04             	sub    $0x4,%esp
  803f22:	68 bc 4b 80 00       	push   $0x804bbc
  803f27:	68 61 02 00 00       	push   $0x261
  803f2c:	68 9d 4a 80 00       	push   $0x804a9d
  803f31:	e8 07 c8 ff ff       	call   80073d <_panic>
  803f36:	66 90                	xchg   %ax,%ax

00803f38 <__udivdi3>:
  803f38:	55                   	push   %ebp
  803f39:	57                   	push   %edi
  803f3a:	56                   	push   %esi
  803f3b:	53                   	push   %ebx
  803f3c:	83 ec 1c             	sub    $0x1c,%esp
  803f3f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f43:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f4b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f4f:	89 ca                	mov    %ecx,%edx
  803f51:	89 f8                	mov    %edi,%eax
  803f53:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f57:	85 f6                	test   %esi,%esi
  803f59:	75 2d                	jne    803f88 <__udivdi3+0x50>
  803f5b:	39 cf                	cmp    %ecx,%edi
  803f5d:	77 65                	ja     803fc4 <__udivdi3+0x8c>
  803f5f:	89 fd                	mov    %edi,%ebp
  803f61:	85 ff                	test   %edi,%edi
  803f63:	75 0b                	jne    803f70 <__udivdi3+0x38>
  803f65:	b8 01 00 00 00       	mov    $0x1,%eax
  803f6a:	31 d2                	xor    %edx,%edx
  803f6c:	f7 f7                	div    %edi
  803f6e:	89 c5                	mov    %eax,%ebp
  803f70:	31 d2                	xor    %edx,%edx
  803f72:	89 c8                	mov    %ecx,%eax
  803f74:	f7 f5                	div    %ebp
  803f76:	89 c1                	mov    %eax,%ecx
  803f78:	89 d8                	mov    %ebx,%eax
  803f7a:	f7 f5                	div    %ebp
  803f7c:	89 cf                	mov    %ecx,%edi
  803f7e:	89 fa                	mov    %edi,%edx
  803f80:	83 c4 1c             	add    $0x1c,%esp
  803f83:	5b                   	pop    %ebx
  803f84:	5e                   	pop    %esi
  803f85:	5f                   	pop    %edi
  803f86:	5d                   	pop    %ebp
  803f87:	c3                   	ret    
  803f88:	39 ce                	cmp    %ecx,%esi
  803f8a:	77 28                	ja     803fb4 <__udivdi3+0x7c>
  803f8c:	0f bd fe             	bsr    %esi,%edi
  803f8f:	83 f7 1f             	xor    $0x1f,%edi
  803f92:	75 40                	jne    803fd4 <__udivdi3+0x9c>
  803f94:	39 ce                	cmp    %ecx,%esi
  803f96:	72 0a                	jb     803fa2 <__udivdi3+0x6a>
  803f98:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f9c:	0f 87 9e 00 00 00    	ja     804040 <__udivdi3+0x108>
  803fa2:	b8 01 00 00 00       	mov    $0x1,%eax
  803fa7:	89 fa                	mov    %edi,%edx
  803fa9:	83 c4 1c             	add    $0x1c,%esp
  803fac:	5b                   	pop    %ebx
  803fad:	5e                   	pop    %esi
  803fae:	5f                   	pop    %edi
  803faf:	5d                   	pop    %ebp
  803fb0:	c3                   	ret    
  803fb1:	8d 76 00             	lea    0x0(%esi),%esi
  803fb4:	31 ff                	xor    %edi,%edi
  803fb6:	31 c0                	xor    %eax,%eax
  803fb8:	89 fa                	mov    %edi,%edx
  803fba:	83 c4 1c             	add    $0x1c,%esp
  803fbd:	5b                   	pop    %ebx
  803fbe:	5e                   	pop    %esi
  803fbf:	5f                   	pop    %edi
  803fc0:	5d                   	pop    %ebp
  803fc1:	c3                   	ret    
  803fc2:	66 90                	xchg   %ax,%ax
  803fc4:	89 d8                	mov    %ebx,%eax
  803fc6:	f7 f7                	div    %edi
  803fc8:	31 ff                	xor    %edi,%edi
  803fca:	89 fa                	mov    %edi,%edx
  803fcc:	83 c4 1c             	add    $0x1c,%esp
  803fcf:	5b                   	pop    %ebx
  803fd0:	5e                   	pop    %esi
  803fd1:	5f                   	pop    %edi
  803fd2:	5d                   	pop    %ebp
  803fd3:	c3                   	ret    
  803fd4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803fd9:	89 eb                	mov    %ebp,%ebx
  803fdb:	29 fb                	sub    %edi,%ebx
  803fdd:	89 f9                	mov    %edi,%ecx
  803fdf:	d3 e6                	shl    %cl,%esi
  803fe1:	89 c5                	mov    %eax,%ebp
  803fe3:	88 d9                	mov    %bl,%cl
  803fe5:	d3 ed                	shr    %cl,%ebp
  803fe7:	89 e9                	mov    %ebp,%ecx
  803fe9:	09 f1                	or     %esi,%ecx
  803feb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803fef:	89 f9                	mov    %edi,%ecx
  803ff1:	d3 e0                	shl    %cl,%eax
  803ff3:	89 c5                	mov    %eax,%ebp
  803ff5:	89 d6                	mov    %edx,%esi
  803ff7:	88 d9                	mov    %bl,%cl
  803ff9:	d3 ee                	shr    %cl,%esi
  803ffb:	89 f9                	mov    %edi,%ecx
  803ffd:	d3 e2                	shl    %cl,%edx
  803fff:	8b 44 24 08          	mov    0x8(%esp),%eax
  804003:	88 d9                	mov    %bl,%cl
  804005:	d3 e8                	shr    %cl,%eax
  804007:	09 c2                	or     %eax,%edx
  804009:	89 d0                	mov    %edx,%eax
  80400b:	89 f2                	mov    %esi,%edx
  80400d:	f7 74 24 0c          	divl   0xc(%esp)
  804011:	89 d6                	mov    %edx,%esi
  804013:	89 c3                	mov    %eax,%ebx
  804015:	f7 e5                	mul    %ebp
  804017:	39 d6                	cmp    %edx,%esi
  804019:	72 19                	jb     804034 <__udivdi3+0xfc>
  80401b:	74 0b                	je     804028 <__udivdi3+0xf0>
  80401d:	89 d8                	mov    %ebx,%eax
  80401f:	31 ff                	xor    %edi,%edi
  804021:	e9 58 ff ff ff       	jmp    803f7e <__udivdi3+0x46>
  804026:	66 90                	xchg   %ax,%ax
  804028:	8b 54 24 08          	mov    0x8(%esp),%edx
  80402c:	89 f9                	mov    %edi,%ecx
  80402e:	d3 e2                	shl    %cl,%edx
  804030:	39 c2                	cmp    %eax,%edx
  804032:	73 e9                	jae    80401d <__udivdi3+0xe5>
  804034:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804037:	31 ff                	xor    %edi,%edi
  804039:	e9 40 ff ff ff       	jmp    803f7e <__udivdi3+0x46>
  80403e:	66 90                	xchg   %ax,%ax
  804040:	31 c0                	xor    %eax,%eax
  804042:	e9 37 ff ff ff       	jmp    803f7e <__udivdi3+0x46>
  804047:	90                   	nop

00804048 <__umoddi3>:
  804048:	55                   	push   %ebp
  804049:	57                   	push   %edi
  80404a:	56                   	push   %esi
  80404b:	53                   	push   %ebx
  80404c:	83 ec 1c             	sub    $0x1c,%esp
  80404f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804053:	8b 74 24 34          	mov    0x34(%esp),%esi
  804057:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80405b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80405f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804063:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804067:	89 f3                	mov    %esi,%ebx
  804069:	89 fa                	mov    %edi,%edx
  80406b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80406f:	89 34 24             	mov    %esi,(%esp)
  804072:	85 c0                	test   %eax,%eax
  804074:	75 1a                	jne    804090 <__umoddi3+0x48>
  804076:	39 f7                	cmp    %esi,%edi
  804078:	0f 86 a2 00 00 00    	jbe    804120 <__umoddi3+0xd8>
  80407e:	89 c8                	mov    %ecx,%eax
  804080:	89 f2                	mov    %esi,%edx
  804082:	f7 f7                	div    %edi
  804084:	89 d0                	mov    %edx,%eax
  804086:	31 d2                	xor    %edx,%edx
  804088:	83 c4 1c             	add    $0x1c,%esp
  80408b:	5b                   	pop    %ebx
  80408c:	5e                   	pop    %esi
  80408d:	5f                   	pop    %edi
  80408e:	5d                   	pop    %ebp
  80408f:	c3                   	ret    
  804090:	39 f0                	cmp    %esi,%eax
  804092:	0f 87 ac 00 00 00    	ja     804144 <__umoddi3+0xfc>
  804098:	0f bd e8             	bsr    %eax,%ebp
  80409b:	83 f5 1f             	xor    $0x1f,%ebp
  80409e:	0f 84 ac 00 00 00    	je     804150 <__umoddi3+0x108>
  8040a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8040a9:	29 ef                	sub    %ebp,%edi
  8040ab:	89 fe                	mov    %edi,%esi
  8040ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040b1:	89 e9                	mov    %ebp,%ecx
  8040b3:	d3 e0                	shl    %cl,%eax
  8040b5:	89 d7                	mov    %edx,%edi
  8040b7:	89 f1                	mov    %esi,%ecx
  8040b9:	d3 ef                	shr    %cl,%edi
  8040bb:	09 c7                	or     %eax,%edi
  8040bd:	89 e9                	mov    %ebp,%ecx
  8040bf:	d3 e2                	shl    %cl,%edx
  8040c1:	89 14 24             	mov    %edx,(%esp)
  8040c4:	89 d8                	mov    %ebx,%eax
  8040c6:	d3 e0                	shl    %cl,%eax
  8040c8:	89 c2                	mov    %eax,%edx
  8040ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040ce:	d3 e0                	shl    %cl,%eax
  8040d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040d8:	89 f1                	mov    %esi,%ecx
  8040da:	d3 e8                	shr    %cl,%eax
  8040dc:	09 d0                	or     %edx,%eax
  8040de:	d3 eb                	shr    %cl,%ebx
  8040e0:	89 da                	mov    %ebx,%edx
  8040e2:	f7 f7                	div    %edi
  8040e4:	89 d3                	mov    %edx,%ebx
  8040e6:	f7 24 24             	mull   (%esp)
  8040e9:	89 c6                	mov    %eax,%esi
  8040eb:	89 d1                	mov    %edx,%ecx
  8040ed:	39 d3                	cmp    %edx,%ebx
  8040ef:	0f 82 87 00 00 00    	jb     80417c <__umoddi3+0x134>
  8040f5:	0f 84 91 00 00 00    	je     80418c <__umoddi3+0x144>
  8040fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8040ff:	29 f2                	sub    %esi,%edx
  804101:	19 cb                	sbb    %ecx,%ebx
  804103:	89 d8                	mov    %ebx,%eax
  804105:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804109:	d3 e0                	shl    %cl,%eax
  80410b:	89 e9                	mov    %ebp,%ecx
  80410d:	d3 ea                	shr    %cl,%edx
  80410f:	09 d0                	or     %edx,%eax
  804111:	89 e9                	mov    %ebp,%ecx
  804113:	d3 eb                	shr    %cl,%ebx
  804115:	89 da                	mov    %ebx,%edx
  804117:	83 c4 1c             	add    $0x1c,%esp
  80411a:	5b                   	pop    %ebx
  80411b:	5e                   	pop    %esi
  80411c:	5f                   	pop    %edi
  80411d:	5d                   	pop    %ebp
  80411e:	c3                   	ret    
  80411f:	90                   	nop
  804120:	89 fd                	mov    %edi,%ebp
  804122:	85 ff                	test   %edi,%edi
  804124:	75 0b                	jne    804131 <__umoddi3+0xe9>
  804126:	b8 01 00 00 00       	mov    $0x1,%eax
  80412b:	31 d2                	xor    %edx,%edx
  80412d:	f7 f7                	div    %edi
  80412f:	89 c5                	mov    %eax,%ebp
  804131:	89 f0                	mov    %esi,%eax
  804133:	31 d2                	xor    %edx,%edx
  804135:	f7 f5                	div    %ebp
  804137:	89 c8                	mov    %ecx,%eax
  804139:	f7 f5                	div    %ebp
  80413b:	89 d0                	mov    %edx,%eax
  80413d:	e9 44 ff ff ff       	jmp    804086 <__umoddi3+0x3e>
  804142:	66 90                	xchg   %ax,%ax
  804144:	89 c8                	mov    %ecx,%eax
  804146:	89 f2                	mov    %esi,%edx
  804148:	83 c4 1c             	add    $0x1c,%esp
  80414b:	5b                   	pop    %ebx
  80414c:	5e                   	pop    %esi
  80414d:	5f                   	pop    %edi
  80414e:	5d                   	pop    %ebp
  80414f:	c3                   	ret    
  804150:	3b 04 24             	cmp    (%esp),%eax
  804153:	72 06                	jb     80415b <__umoddi3+0x113>
  804155:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804159:	77 0f                	ja     80416a <__umoddi3+0x122>
  80415b:	89 f2                	mov    %esi,%edx
  80415d:	29 f9                	sub    %edi,%ecx
  80415f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804163:	89 14 24             	mov    %edx,(%esp)
  804166:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80416a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80416e:	8b 14 24             	mov    (%esp),%edx
  804171:	83 c4 1c             	add    $0x1c,%esp
  804174:	5b                   	pop    %ebx
  804175:	5e                   	pop    %esi
  804176:	5f                   	pop    %edi
  804177:	5d                   	pop    %ebp
  804178:	c3                   	ret    
  804179:	8d 76 00             	lea    0x0(%esi),%esi
  80417c:	2b 04 24             	sub    (%esp),%eax
  80417f:	19 fa                	sbb    %edi,%edx
  804181:	89 d1                	mov    %edx,%ecx
  804183:	89 c6                	mov    %eax,%esi
  804185:	e9 71 ff ff ff       	jmp    8040fb <__umoddi3+0xb3>
  80418a:	66 90                	xchg   %ax,%ax
  80418c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804190:	72 ea                	jb     80417c <__umoddi3+0x134>
  804192:	89 d9                	mov    %ebx,%ecx
  804194:	e9 62 ff ff ff       	jmp    8040fb <__umoddi3+0xb3>
