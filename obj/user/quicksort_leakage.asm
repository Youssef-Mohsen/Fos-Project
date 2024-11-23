
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
  800041:	e8 8b 1e 00 00       	call   801ed1 <sys_lock_cons>
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
  80014d:	e8 99 1d 00 00       	call   801eeb <sys_unlock_cons>
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
  8001d5:	e8 f7 1c 00 00       	call   801ed1 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 4c 42 80 00       	push   $0x80424c
  8001e2:	e8 13 08 00 00       	call   8009fa <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			//		PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ea:	e8 fc 1c 00 00       	call   801eeb <sys_unlock_cons>
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
  80021d:	e8 af 1c 00 00       	call   801ed1 <sys_lock_cons>
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
  800252:	e8 94 1c 00 00       	call   801eeb <sys_unlock_cons>


		}

		//		sys_lock_cons();
		sys_lock_cons();
  800257:	e8 75 1c 00 00       	call   801ed1 <sys_lock_cons>
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
  8002b0:	e8 36 1c 00 00       	call   801eeb <sys_unlock_cons>
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
  8005d6:	e8 41 1a 00 00       	call   80201c <sys_cputc>
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
  8005e7:	e8 cc 18 00 00       	call   801eb8 <sys_cgetc>
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
  800604:	e8 44 1b 00 00       	call   80214d <sys_getenvindex>
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
  800672:	e8 5a 18 00 00       	call   801ed1 <sys_lock_cons>
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
  80070c:	e8 da 17 00 00       	call   801eeb <sys_unlock_cons>
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
  800724:	e8 f0 19 00 00       	call   802119 <sys_destroy_env>
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
  800735:	e8 45 1a 00 00       	call   80217f <sys_exit_env>
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
  80096c:	e8 1e 15 00 00       	call   801e8f <sys_cputs>
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
  8009e3:	e8 a7 14 00 00       	call   801e8f <sys_cputs>
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
  800a2d:	e8 9f 14 00 00       	call   801ed1 <sys_lock_cons>
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
  800a4d:	e8 99 14 00 00       	call   801eeb <sys_unlock_cons>
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
  800a97:	e8 8c 34 00 00       	call   803f28 <__udivdi3>
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
  800ae7:	e8 4c 35 00 00       	call   804038 <__umoddi3>
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
  801193:	e8 39 0d 00 00       	call   801ed1 <sys_lock_cons>
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
  80128e:	e8 58 0c 00 00       	call   801eeb <sys_unlock_cons>
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
  8019a8:	e8 8d 0a 00 00       	call   80243a <sys_sbrk>
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
  801a23:	e8 96 08 00 00       	call   8022be <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	74 16                	je     801a42 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a2c:	83 ec 0c             	sub    $0xc,%esp
  801a2f:	ff 75 08             	pushl  0x8(%ebp)
  801a32:	e8 d6 0d 00 00       	call   80280d <alloc_block_FF>
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a3d:	e9 8a 01 00 00       	jmp    801bcc <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801a42:	e8 a8 08 00 00       	call   8022ef <sys_isUHeapPlacementStrategyBESTFIT>
  801a47:	85 c0                	test   %eax,%eax
  801a49:	0f 84 7d 01 00 00    	je     801bcc <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	e8 6f 12 00 00       	call   802cc9 <alloc_block_BF>
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
  801bbb:	e8 b1 08 00 00       	call   802471 <sys_allocate_user_mem>
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
  801c03:	e8 85 08 00 00       	call   80248d <get_block_size>
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c0e:	83 ec 0c             	sub    $0xc,%esp
  801c11:	ff 75 08             	pushl  0x8(%ebp)
  801c14:	e8 b8 1a 00 00       	call   8036d1 <free_block>
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
  801cab:	e8 a5 07 00 00       	call   802455 <sys_free_user_mem>
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
  801ce6:	eb 64                	jmp    801d4c <smalloc+0x7d>
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
  801d1b:	eb 2f                	jmp    801d4c <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d1d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d21:	ff 75 ec             	pushl  -0x14(%ebp)
  801d24:	50                   	push   %eax
  801d25:	ff 75 0c             	pushl  0xc(%ebp)
  801d28:	ff 75 08             	pushl  0x8(%ebp)
  801d2b:	e8 2c 03 00 00       	call   80205c <sys_createSharedObject>
  801d30:	83 c4 10             	add    $0x10,%esp
  801d33:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801d36:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801d3a:	74 06                	je     801d42 <smalloc+0x73>
  801d3c:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801d40:	75 07                	jne    801d49 <smalloc+0x7a>
  801d42:	b8 00 00 00 00       	mov    $0x0,%eax
  801d47:	eb 03                	jmp    801d4c <smalloc+0x7d>
	 return ptr;
  801d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d54:	83 ec 08             	sub    $0x8,%esp
  801d57:	ff 75 0c             	pushl  0xc(%ebp)
  801d5a:	ff 75 08             	pushl  0x8(%ebp)
  801d5d:	e8 24 03 00 00       	call   802086 <sys_getSizeOfSharedObject>
  801d62:	83 c4 10             	add    $0x10,%esp
  801d65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801d68:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801d6c:	75 07                	jne    801d75 <sget+0x27>
  801d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d73:	eb 5c                	jmp    801dd1 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d7b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d88:	39 d0                	cmp    %edx,%eax
  801d8a:	7d 02                	jge    801d8e <sget+0x40>
  801d8c:	89 d0                	mov    %edx,%eax
  801d8e:	83 ec 0c             	sub    $0xc,%esp
  801d91:	50                   	push   %eax
  801d92:	e8 1b fc ff ff       	call   8019b2 <malloc>
  801d97:	83 c4 10             	add    $0x10,%esp
  801d9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801d9d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801da1:	75 07                	jne    801daa <sget+0x5c>
  801da3:	b8 00 00 00 00       	mov    $0x0,%eax
  801da8:	eb 27                	jmp    801dd1 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801daa:	83 ec 04             	sub    $0x4,%esp
  801dad:	ff 75 e8             	pushl  -0x18(%ebp)
  801db0:	ff 75 0c             	pushl  0xc(%ebp)
  801db3:	ff 75 08             	pushl  0x8(%ebp)
  801db6:	e8 e8 02 00 00       	call   8020a3 <sys_getSharedObject>
  801dbb:	83 c4 10             	add    $0x10,%esp
  801dbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801dc1:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801dc5:	75 07                	jne    801dce <sget+0x80>
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcc:	eb 03                	jmp    801dd1 <sget+0x83>
	return ptr;
  801dce:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801dd9:	83 ec 04             	sub    $0x4,%esp
  801ddc:	68 a4 49 80 00       	push   $0x8049a4
  801de1:	68 c1 00 00 00       	push   $0xc1
  801de6:	68 96 49 80 00       	push   $0x804996
  801deb:	e8 4d e9 ff ff       	call   80073d <_panic>

00801df0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801df6:	83 ec 04             	sub    $0x4,%esp
  801df9:	68 c8 49 80 00       	push   $0x8049c8
  801dfe:	68 d8 00 00 00       	push   $0xd8
  801e03:	68 96 49 80 00       	push   $0x804996
  801e08:	e8 30 e9 ff ff       	call   80073d <_panic>

00801e0d <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e13:	83 ec 04             	sub    $0x4,%esp
  801e16:	68 ee 49 80 00       	push   $0x8049ee
  801e1b:	68 e4 00 00 00       	push   $0xe4
  801e20:	68 96 49 80 00       	push   $0x804996
  801e25:	e8 13 e9 ff ff       	call   80073d <_panic>

00801e2a <shrink>:

}
void shrink(uint32 newSize)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e30:	83 ec 04             	sub    $0x4,%esp
  801e33:	68 ee 49 80 00       	push   $0x8049ee
  801e38:	68 e9 00 00 00       	push   $0xe9
  801e3d:	68 96 49 80 00       	push   $0x804996
  801e42:	e8 f6 e8 ff ff       	call   80073d <_panic>

00801e47 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e4d:	83 ec 04             	sub    $0x4,%esp
  801e50:	68 ee 49 80 00       	push   $0x8049ee
  801e55:	68 ee 00 00 00       	push   $0xee
  801e5a:	68 96 49 80 00       	push   $0x804996
  801e5f:	e8 d9 e8 ff ff       	call   80073d <_panic>

00801e64 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	57                   	push   %edi
  801e68:	56                   	push   %esi
  801e69:	53                   	push   %ebx
  801e6a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e73:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e76:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e79:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e7c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e7f:	cd 30                	int    $0x30
  801e81:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e87:	83 c4 10             	add    $0x10,%esp
  801e8a:	5b                   	pop    %ebx
  801e8b:	5e                   	pop    %esi
  801e8c:	5f                   	pop    %edi
  801e8d:	5d                   	pop    %ebp
  801e8e:	c3                   	ret    

00801e8f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 04             	sub    $0x4,%esp
  801e95:	8b 45 10             	mov    0x10(%ebp),%eax
  801e98:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e9b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	52                   	push   %edx
  801ea7:	ff 75 0c             	pushl  0xc(%ebp)
  801eaa:	50                   	push   %eax
  801eab:	6a 00                	push   $0x0
  801ead:	e8 b2 ff ff ff       	call   801e64 <syscall>
  801eb2:	83 c4 18             	add    $0x18,%esp
}
  801eb5:	90                   	nop
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <sys_cgetc>:

int
sys_cgetc(void)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 02                	push   $0x2
  801ec7:	e8 98 ff ff ff       	call   801e64 <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 03                	push   $0x3
  801ee0:	e8 7f ff ff ff       	call   801e64 <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
}
  801ee8:	90                   	nop
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 04                	push   $0x4
  801efa:	e8 65 ff ff ff       	call   801e64 <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
}
  801f02:	90                   	nop
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	52                   	push   %edx
  801f15:	50                   	push   %eax
  801f16:	6a 08                	push   $0x8
  801f18:	e8 47 ff ff ff       	call   801e64 <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	56                   	push   %esi
  801f26:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f27:	8b 75 18             	mov    0x18(%ebp),%esi
  801f2a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	56                   	push   %esi
  801f37:	53                   	push   %ebx
  801f38:	51                   	push   %ecx
  801f39:	52                   	push   %edx
  801f3a:	50                   	push   %eax
  801f3b:	6a 09                	push   $0x9
  801f3d:	e8 22 ff ff ff       	call   801e64 <syscall>
  801f42:	83 c4 18             	add    $0x18,%esp
}
  801f45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f48:	5b                   	pop    %ebx
  801f49:	5e                   	pop    %esi
  801f4a:	5d                   	pop    %ebp
  801f4b:	c3                   	ret    

00801f4c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	52                   	push   %edx
  801f5c:	50                   	push   %eax
  801f5d:	6a 0a                	push   $0xa
  801f5f:	e8 00 ff ff ff       	call   801e64 <syscall>
  801f64:	83 c4 18             	add    $0x18,%esp
}
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	ff 75 0c             	pushl  0xc(%ebp)
  801f75:	ff 75 08             	pushl  0x8(%ebp)
  801f78:	6a 0b                	push   $0xb
  801f7a:	e8 e5 fe ff ff       	call   801e64 <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 0c                	push   $0xc
  801f93:	e8 cc fe ff ff       	call   801e64 <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 0d                	push   $0xd
  801fac:	e8 b3 fe ff ff       	call   801e64 <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 0e                	push   $0xe
  801fc5:	e8 9a fe ff ff       	call   801e64 <syscall>
  801fca:	83 c4 18             	add    $0x18,%esp
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 0f                	push   $0xf
  801fde:	e8 81 fe ff ff       	call   801e64 <syscall>
  801fe3:	83 c4 18             	add    $0x18,%esp
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	ff 75 08             	pushl  0x8(%ebp)
  801ff6:	6a 10                	push   $0x10
  801ff8:	e8 67 fe ff ff       	call   801e64 <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 11                	push   $0x11
  802011:	e8 4e fe ff ff       	call   801e64 <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
}
  802019:	90                   	nop
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_cputc>:

void
sys_cputc(const char c)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	83 ec 04             	sub    $0x4,%esp
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802028:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	50                   	push   %eax
  802035:	6a 01                	push   $0x1
  802037:	e8 28 fe ff ff       	call   801e64 <syscall>
  80203c:	83 c4 18             	add    $0x18,%esp
}
  80203f:	90                   	nop
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 14                	push   $0x14
  802051:	e8 0e fe ff ff       	call   801e64 <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	90                   	nop
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	83 ec 04             	sub    $0x4,%esp
  802062:	8b 45 10             	mov    0x10(%ebp),%eax
  802065:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802068:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80206b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	6a 00                	push   $0x0
  802074:	51                   	push   %ecx
  802075:	52                   	push   %edx
  802076:	ff 75 0c             	pushl  0xc(%ebp)
  802079:	50                   	push   %eax
  80207a:	6a 15                	push   $0x15
  80207c:	e8 e3 fd ff ff       	call   801e64 <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802089:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	52                   	push   %edx
  802096:	50                   	push   %eax
  802097:	6a 16                	push   $0x16
  802099:	e8 c6 fd ff ff       	call   801e64 <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	51                   	push   %ecx
  8020b4:	52                   	push   %edx
  8020b5:	50                   	push   %eax
  8020b6:	6a 17                	push   $0x17
  8020b8:	e8 a7 fd ff ff       	call   801e64 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	52                   	push   %edx
  8020d2:	50                   	push   %eax
  8020d3:	6a 18                	push   $0x18
  8020d5:	e8 8a fd ff ff       	call   801e64 <syscall>
  8020da:	83 c4 18             	add    $0x18,%esp
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	6a 00                	push   $0x0
  8020e7:	ff 75 14             	pushl  0x14(%ebp)
  8020ea:	ff 75 10             	pushl  0x10(%ebp)
  8020ed:	ff 75 0c             	pushl  0xc(%ebp)
  8020f0:	50                   	push   %eax
  8020f1:	6a 19                	push   $0x19
  8020f3:	e8 6c fd ff ff       	call   801e64 <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <sys_run_env>:

void sys_run_env(int32 envId)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	50                   	push   %eax
  80210c:	6a 1a                	push   $0x1a
  80210e:	e8 51 fd ff ff       	call   801e64 <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
}
  802116:	90                   	nop
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	50                   	push   %eax
  802128:	6a 1b                	push   $0x1b
  80212a:	e8 35 fd ff ff       	call   801e64 <syscall>
  80212f:	83 c4 18             	add    $0x18,%esp
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 05                	push   $0x5
  802143:	e8 1c fd ff ff       	call   801e64 <syscall>
  802148:	83 c4 18             	add    $0x18,%esp
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 06                	push   $0x6
  80215c:	e8 03 fd ff ff       	call   801e64 <syscall>
  802161:	83 c4 18             	add    $0x18,%esp
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 07                	push   $0x7
  802175:	e8 ea fc ff ff       	call   801e64 <syscall>
  80217a:	83 c4 18             	add    $0x18,%esp
}
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <sys_exit_env>:


void sys_exit_env(void)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 1c                	push   $0x1c
  80218e:	e8 d1 fc ff ff       	call   801e64 <syscall>
  802193:	83 c4 18             	add    $0x18,%esp
}
  802196:	90                   	nop
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
  80219c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80219f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021a2:	8d 50 04             	lea    0x4(%eax),%edx
  8021a5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	52                   	push   %edx
  8021af:	50                   	push   %eax
  8021b0:	6a 1d                	push   $0x1d
  8021b2:	e8 ad fc ff ff       	call   801e64 <syscall>
  8021b7:	83 c4 18             	add    $0x18,%esp
	return result;
  8021ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021c3:	89 01                	mov    %eax,(%ecx)
  8021c5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	c9                   	leave  
  8021cc:	c2 04 00             	ret    $0x4

008021cf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	ff 75 10             	pushl  0x10(%ebp)
  8021d9:	ff 75 0c             	pushl  0xc(%ebp)
  8021dc:	ff 75 08             	pushl  0x8(%ebp)
  8021df:	6a 13                	push   $0x13
  8021e1:	e8 7e fc ff ff       	call   801e64 <syscall>
  8021e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e9:	90                   	nop
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <sys_rcr2>:
uint32 sys_rcr2()
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 1e                	push   $0x1e
  8021fb:	e8 64 fc ff ff       	call   801e64 <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 04             	sub    $0x4,%esp
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802211:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	50                   	push   %eax
  80221e:	6a 1f                	push   $0x1f
  802220:	e8 3f fc ff ff       	call   801e64 <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
	return ;
  802228:	90                   	nop
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <rsttst>:
void rsttst()
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 21                	push   $0x21
  80223a:	e8 25 fc ff ff       	call   801e64 <syscall>
  80223f:	83 c4 18             	add    $0x18,%esp
	return ;
  802242:	90                   	nop
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	83 ec 04             	sub    $0x4,%esp
  80224b:	8b 45 14             	mov    0x14(%ebp),%eax
  80224e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802251:	8b 55 18             	mov    0x18(%ebp),%edx
  802254:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802258:	52                   	push   %edx
  802259:	50                   	push   %eax
  80225a:	ff 75 10             	pushl  0x10(%ebp)
  80225d:	ff 75 0c             	pushl  0xc(%ebp)
  802260:	ff 75 08             	pushl  0x8(%ebp)
  802263:	6a 20                	push   $0x20
  802265:	e8 fa fb ff ff       	call   801e64 <syscall>
  80226a:	83 c4 18             	add    $0x18,%esp
	return ;
  80226d:	90                   	nop
}
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <chktst>:
void chktst(uint32 n)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	ff 75 08             	pushl  0x8(%ebp)
  80227e:	6a 22                	push   $0x22
  802280:	e8 df fb ff ff       	call   801e64 <syscall>
  802285:	83 c4 18             	add    $0x18,%esp
	return ;
  802288:	90                   	nop
}
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <inctst>:

void inctst()
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 23                	push   $0x23
  80229a:	e8 c5 fb ff ff       	call   801e64 <syscall>
  80229f:	83 c4 18             	add    $0x18,%esp
	return ;
  8022a2:	90                   	nop
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <gettst>:
uint32 gettst()
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 24                	push   $0x24
  8022b4:	e8 ab fb ff ff       	call   801e64 <syscall>
  8022b9:	83 c4 18             	add    $0x18,%esp
}
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 25                	push   $0x25
  8022d0:	e8 8f fb ff ff       	call   801e64 <syscall>
  8022d5:	83 c4 18             	add    $0x18,%esp
  8022d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8022db:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8022df:	75 07                	jne    8022e8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8022e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e6:	eb 05                	jmp    8022ed <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    

008022ef <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
  8022f2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 25                	push   $0x25
  802301:	e8 5e fb ff ff       	call   801e64 <syscall>
  802306:	83 c4 18             	add    $0x18,%esp
  802309:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80230c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802310:	75 07                	jne    802319 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802312:	b8 01 00 00 00       	mov    $0x1,%eax
  802317:	eb 05                	jmp    80231e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802319:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 25                	push   $0x25
  802332:	e8 2d fb ff ff       	call   801e64 <syscall>
  802337:	83 c4 18             	add    $0x18,%esp
  80233a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80233d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802341:	75 07                	jne    80234a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802343:	b8 01 00 00 00       	mov    $0x1,%eax
  802348:	eb 05                	jmp    80234f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80234a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

00802351 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 25                	push   $0x25
  802363:	e8 fc fa ff ff       	call   801e64 <syscall>
  802368:	83 c4 18             	add    $0x18,%esp
  80236b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80236e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802372:	75 07                	jne    80237b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802374:	b8 01 00 00 00       	mov    $0x1,%eax
  802379:	eb 05                	jmp    802380 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80237b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802380:	c9                   	leave  
  802381:	c3                   	ret    

00802382 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802382:	55                   	push   %ebp
  802383:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	ff 75 08             	pushl  0x8(%ebp)
  802390:	6a 26                	push   $0x26
  802392:	e8 cd fa ff ff       	call   801e64 <syscall>
  802397:	83 c4 18             	add    $0x18,%esp
	return ;
  80239a:	90                   	nop
}
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

0080239d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
  8023a0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ad:	6a 00                	push   $0x0
  8023af:	53                   	push   %ebx
  8023b0:	51                   	push   %ecx
  8023b1:	52                   	push   %edx
  8023b2:	50                   	push   %eax
  8023b3:	6a 27                	push   $0x27
  8023b5:	e8 aa fa ff ff       	call   801e64 <syscall>
  8023ba:	83 c4 18             	add    $0x18,%esp
}
  8023bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	52                   	push   %edx
  8023d2:	50                   	push   %eax
  8023d3:	6a 28                	push   $0x28
  8023d5:	e8 8a fa ff ff       	call   801e64 <syscall>
  8023da:	83 c4 18             	add    $0x18,%esp
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8023e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	6a 00                	push   $0x0
  8023ed:	51                   	push   %ecx
  8023ee:	ff 75 10             	pushl  0x10(%ebp)
  8023f1:	52                   	push   %edx
  8023f2:	50                   	push   %eax
  8023f3:	6a 29                	push   $0x29
  8023f5:	e8 6a fa ff ff       	call   801e64 <syscall>
  8023fa:	83 c4 18             	add    $0x18,%esp
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	ff 75 10             	pushl  0x10(%ebp)
  802409:	ff 75 0c             	pushl  0xc(%ebp)
  80240c:	ff 75 08             	pushl  0x8(%ebp)
  80240f:	6a 12                	push   $0x12
  802411:	e8 4e fa ff ff       	call   801e64 <syscall>
  802416:	83 c4 18             	add    $0x18,%esp
	return ;
  802419:	90                   	nop
}
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80241f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	52                   	push   %edx
  80242c:	50                   	push   %eax
  80242d:	6a 2a                	push   $0x2a
  80242f:	e8 30 fa ff ff       	call   801e64 <syscall>
  802434:	83 c4 18             	add    $0x18,%esp
	return;
  802437:	90                   	nop
}
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	50                   	push   %eax
  802449:	6a 2b                	push   $0x2b
  80244b:	e8 14 fa ff ff       	call   801e64 <syscall>
  802450:	83 c4 18             	add    $0x18,%esp
}
  802453:	c9                   	leave  
  802454:	c3                   	ret    

00802455 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	ff 75 0c             	pushl  0xc(%ebp)
  802461:	ff 75 08             	pushl  0x8(%ebp)
  802464:	6a 2c                	push   $0x2c
  802466:	e8 f9 f9 ff ff       	call   801e64 <syscall>
  80246b:	83 c4 18             	add    $0x18,%esp
	return;
  80246e:	90                   	nop
}
  80246f:	c9                   	leave  
  802470:	c3                   	ret    

00802471 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	ff 75 0c             	pushl  0xc(%ebp)
  80247d:	ff 75 08             	pushl  0x8(%ebp)
  802480:	6a 2d                	push   $0x2d
  802482:	e8 dd f9 ff ff       	call   801e64 <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
	return;
  80248a:	90                   	nop
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	83 e8 04             	sub    $0x4,%eax
  802499:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80249c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    

008024a6 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
  8024a9:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8024ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8024af:	83 e8 04             	sub    $0x4,%eax
  8024b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8024b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024b8:	8b 00                	mov    (%eax),%eax
  8024ba:	83 e0 01             	and    $0x1,%eax
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	0f 94 c0             	sete   %al
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8024ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8024d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d4:	83 f8 02             	cmp    $0x2,%eax
  8024d7:	74 2b                	je     802504 <alloc_block+0x40>
  8024d9:	83 f8 02             	cmp    $0x2,%eax
  8024dc:	7f 07                	jg     8024e5 <alloc_block+0x21>
  8024de:	83 f8 01             	cmp    $0x1,%eax
  8024e1:	74 0e                	je     8024f1 <alloc_block+0x2d>
  8024e3:	eb 58                	jmp    80253d <alloc_block+0x79>
  8024e5:	83 f8 03             	cmp    $0x3,%eax
  8024e8:	74 2d                	je     802517 <alloc_block+0x53>
  8024ea:	83 f8 04             	cmp    $0x4,%eax
  8024ed:	74 3b                	je     80252a <alloc_block+0x66>
  8024ef:	eb 4c                	jmp    80253d <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8024f1:	83 ec 0c             	sub    $0xc,%esp
  8024f4:	ff 75 08             	pushl  0x8(%ebp)
  8024f7:	e8 11 03 00 00       	call   80280d <alloc_block_FF>
  8024fc:	83 c4 10             	add    $0x10,%esp
  8024ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802502:	eb 4a                	jmp    80254e <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802504:	83 ec 0c             	sub    $0xc,%esp
  802507:	ff 75 08             	pushl  0x8(%ebp)
  80250a:	e8 fa 19 00 00       	call   803f09 <alloc_block_NF>
  80250f:	83 c4 10             	add    $0x10,%esp
  802512:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802515:	eb 37                	jmp    80254e <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802517:	83 ec 0c             	sub    $0xc,%esp
  80251a:	ff 75 08             	pushl  0x8(%ebp)
  80251d:	e8 a7 07 00 00       	call   802cc9 <alloc_block_BF>
  802522:	83 c4 10             	add    $0x10,%esp
  802525:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802528:	eb 24                	jmp    80254e <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80252a:	83 ec 0c             	sub    $0xc,%esp
  80252d:	ff 75 08             	pushl  0x8(%ebp)
  802530:	e8 b7 19 00 00       	call   803eec <alloc_block_WF>
  802535:	83 c4 10             	add    $0x10,%esp
  802538:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80253b:	eb 11                	jmp    80254e <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80253d:	83 ec 0c             	sub    $0xc,%esp
  802540:	68 00 4a 80 00       	push   $0x804a00
  802545:	e8 b0 e4 ff ff       	call   8009fa <cprintf>
  80254a:	83 c4 10             	add    $0x10,%esp
		break;
  80254d:	90                   	nop
	}
	return va;
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
  802556:	53                   	push   %ebx
  802557:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80255a:	83 ec 0c             	sub    $0xc,%esp
  80255d:	68 20 4a 80 00       	push   $0x804a20
  802562:	e8 93 e4 ff ff       	call   8009fa <cprintf>
  802567:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80256a:	83 ec 0c             	sub    $0xc,%esp
  80256d:	68 4b 4a 80 00       	push   $0x804a4b
  802572:	e8 83 e4 ff ff       	call   8009fa <cprintf>
  802577:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802580:	eb 37                	jmp    8025b9 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802582:	83 ec 0c             	sub    $0xc,%esp
  802585:	ff 75 f4             	pushl  -0xc(%ebp)
  802588:	e8 19 ff ff ff       	call   8024a6 <is_free_block>
  80258d:	83 c4 10             	add    $0x10,%esp
  802590:	0f be d8             	movsbl %al,%ebx
  802593:	83 ec 0c             	sub    $0xc,%esp
  802596:	ff 75 f4             	pushl  -0xc(%ebp)
  802599:	e8 ef fe ff ff       	call   80248d <get_block_size>
  80259e:	83 c4 10             	add    $0x10,%esp
  8025a1:	83 ec 04             	sub    $0x4,%esp
  8025a4:	53                   	push   %ebx
  8025a5:	50                   	push   %eax
  8025a6:	68 63 4a 80 00       	push   $0x804a63
  8025ab:	e8 4a e4 ff ff       	call   8009fa <cprintf>
  8025b0:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8025b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8025b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bd:	74 07                	je     8025c6 <print_blocks_list+0x73>
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	8b 00                	mov    (%eax),%eax
  8025c4:	eb 05                	jmp    8025cb <print_blocks_list+0x78>
  8025c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cb:	89 45 10             	mov    %eax,0x10(%ebp)
  8025ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d1:	85 c0                	test   %eax,%eax
  8025d3:	75 ad                	jne    802582 <print_blocks_list+0x2f>
  8025d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d9:	75 a7                	jne    802582 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8025db:	83 ec 0c             	sub    $0xc,%esp
  8025de:	68 20 4a 80 00       	push   $0x804a20
  8025e3:	e8 12 e4 ff ff       	call   8009fa <cprintf>
  8025e8:	83 c4 10             	add    $0x10,%esp

}
  8025eb:	90                   	nop
  8025ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025ef:	c9                   	leave  
  8025f0:	c3                   	ret    

008025f1 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
  8025f4:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8025f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025fa:	83 e0 01             	and    $0x1,%eax
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	74 03                	je     802604 <initialize_dynamic_allocator+0x13>
  802601:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802604:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802608:	0f 84 c7 01 00 00    	je     8027d5 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80260e:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802615:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802618:	8b 55 08             	mov    0x8(%ebp),%edx
  80261b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80261e:	01 d0                	add    %edx,%eax
  802620:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802625:	0f 87 ad 01 00 00    	ja     8027d8 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80262b:	8b 45 08             	mov    0x8(%ebp),%eax
  80262e:	85 c0                	test   %eax,%eax
  802630:	0f 89 a5 01 00 00    	jns    8027db <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802636:	8b 55 08             	mov    0x8(%ebp),%edx
  802639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80263c:	01 d0                	add    %edx,%eax
  80263e:	83 e8 04             	sub    $0x4,%eax
  802641:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  802646:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80264d:	a1 30 50 80 00       	mov    0x805030,%eax
  802652:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802655:	e9 87 00 00 00       	jmp    8026e1 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80265a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265e:	75 14                	jne    802674 <initialize_dynamic_allocator+0x83>
  802660:	83 ec 04             	sub    $0x4,%esp
  802663:	68 7b 4a 80 00       	push   $0x804a7b
  802668:	6a 79                	push   $0x79
  80266a:	68 99 4a 80 00       	push   $0x804a99
  80266f:	e8 c9 e0 ff ff       	call   80073d <_panic>
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 00                	mov    (%eax),%eax
  802679:	85 c0                	test   %eax,%eax
  80267b:	74 10                	je     80268d <initialize_dynamic_allocator+0x9c>
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 00                	mov    (%eax),%eax
  802682:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802685:	8b 52 04             	mov    0x4(%edx),%edx
  802688:	89 50 04             	mov    %edx,0x4(%eax)
  80268b:	eb 0b                	jmp    802698 <initialize_dynamic_allocator+0xa7>
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 40 04             	mov    0x4(%eax),%eax
  802693:	a3 34 50 80 00       	mov    %eax,0x805034
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	8b 40 04             	mov    0x4(%eax),%eax
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	74 0f                	je     8026b1 <initialize_dynamic_allocator+0xc0>
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 40 04             	mov    0x4(%eax),%eax
  8026a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ab:	8b 12                	mov    (%edx),%edx
  8026ad:	89 10                	mov    %edx,(%eax)
  8026af:	eb 0a                	jmp    8026bb <initialize_dynamic_allocator+0xca>
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 00                	mov    (%eax),%eax
  8026b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ce:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026d3:	48                   	dec    %eax
  8026d4:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8026d9:	a1 38 50 80 00       	mov    0x805038,%eax
  8026de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e5:	74 07                	je     8026ee <initialize_dynamic_allocator+0xfd>
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 00                	mov    (%eax),%eax
  8026ec:	eb 05                	jmp    8026f3 <initialize_dynamic_allocator+0x102>
  8026ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f3:	a3 38 50 80 00       	mov    %eax,0x805038
  8026f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	0f 85 55 ff ff ff    	jne    80265a <initialize_dynamic_allocator+0x69>
  802705:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802709:	0f 85 4b ff ff ff    	jne    80265a <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80270f:	8b 45 08             	mov    0x8(%ebp),%eax
  802712:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802718:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80271e:	a1 48 50 80 00       	mov    0x805048,%eax
  802723:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802728:	a1 44 50 80 00       	mov    0x805044,%eax
  80272d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802733:	8b 45 08             	mov    0x8(%ebp),%eax
  802736:	83 c0 08             	add    $0x8,%eax
  802739:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	83 c0 04             	add    $0x4,%eax
  802742:	8b 55 0c             	mov    0xc(%ebp),%edx
  802745:	83 ea 08             	sub    $0x8,%edx
  802748:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80274a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80274d:	8b 45 08             	mov    0x8(%ebp),%eax
  802750:	01 d0                	add    %edx,%eax
  802752:	83 e8 08             	sub    $0x8,%eax
  802755:	8b 55 0c             	mov    0xc(%ebp),%edx
  802758:	83 ea 08             	sub    $0x8,%edx
  80275b:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80275d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802760:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802769:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802770:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802774:	75 17                	jne    80278d <initialize_dynamic_allocator+0x19c>
  802776:	83 ec 04             	sub    $0x4,%esp
  802779:	68 b4 4a 80 00       	push   $0x804ab4
  80277e:	68 90 00 00 00       	push   $0x90
  802783:	68 99 4a 80 00       	push   $0x804a99
  802788:	e8 b0 df ff ff       	call   80073d <_panic>
  80278d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802793:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802796:	89 10                	mov    %edx,(%eax)
  802798:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279b:	8b 00                	mov    (%eax),%eax
  80279d:	85 c0                	test   %eax,%eax
  80279f:	74 0d                	je     8027ae <initialize_dynamic_allocator+0x1bd>
  8027a1:	a1 30 50 80 00       	mov    0x805030,%eax
  8027a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027a9:	89 50 04             	mov    %edx,0x4(%eax)
  8027ac:	eb 08                	jmp    8027b6 <initialize_dynamic_allocator+0x1c5>
  8027ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b1:	a3 34 50 80 00       	mov    %eax,0x805034
  8027b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027cd:	40                   	inc    %eax
  8027ce:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8027d3:	eb 07                	jmp    8027dc <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8027d5:	90                   	nop
  8027d6:	eb 04                	jmp    8027dc <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8027d8:	90                   	nop
  8027d9:	eb 01                	jmp    8027dc <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8027db:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8027dc:	c9                   	leave  
  8027dd:	c3                   	ret    

008027de <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8027de:	55                   	push   %ebp
  8027df:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8027e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8027e4:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8027e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ea:	8d 50 fc             	lea    -0x4(%eax),%edx
  8027ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f0:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	83 e8 04             	sub    $0x4,%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	83 e0 fe             	and    $0xfffffffe,%eax
  8027fd:	8d 50 f8             	lea    -0x8(%eax),%edx
  802800:	8b 45 08             	mov    0x8(%ebp),%eax
  802803:	01 c2                	add    %eax,%edx
  802805:	8b 45 0c             	mov    0xc(%ebp),%eax
  802808:	89 02                	mov    %eax,(%edx)
}
  80280a:	90                   	nop
  80280b:	5d                   	pop    %ebp
  80280c:	c3                   	ret    

0080280d <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
  802810:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802813:	8b 45 08             	mov    0x8(%ebp),%eax
  802816:	83 e0 01             	and    $0x1,%eax
  802819:	85 c0                	test   %eax,%eax
  80281b:	74 03                	je     802820 <alloc_block_FF+0x13>
  80281d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802820:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802824:	77 07                	ja     80282d <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802826:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80282d:	a1 28 50 80 00       	mov    0x805028,%eax
  802832:	85 c0                	test   %eax,%eax
  802834:	75 73                	jne    8028a9 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802836:	8b 45 08             	mov    0x8(%ebp),%eax
  802839:	83 c0 10             	add    $0x10,%eax
  80283c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80283f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802846:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802849:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284c:	01 d0                	add    %edx,%eax
  80284e:	48                   	dec    %eax
  80284f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802852:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802855:	ba 00 00 00 00       	mov    $0x0,%edx
  80285a:	f7 75 ec             	divl   -0x14(%ebp)
  80285d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802860:	29 d0                	sub    %edx,%eax
  802862:	c1 e8 0c             	shr    $0xc,%eax
  802865:	83 ec 0c             	sub    $0xc,%esp
  802868:	50                   	push   %eax
  802869:	e8 2e f1 ff ff       	call   80199c <sbrk>
  80286e:	83 c4 10             	add    $0x10,%esp
  802871:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802874:	83 ec 0c             	sub    $0xc,%esp
  802877:	6a 00                	push   $0x0
  802879:	e8 1e f1 ff ff       	call   80199c <sbrk>
  80287e:	83 c4 10             	add    $0x10,%esp
  802881:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802884:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802887:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80288a:	83 ec 08             	sub    $0x8,%esp
  80288d:	50                   	push   %eax
  80288e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802891:	e8 5b fd ff ff       	call   8025f1 <initialize_dynamic_allocator>
  802896:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802899:	83 ec 0c             	sub    $0xc,%esp
  80289c:	68 d7 4a 80 00       	push   $0x804ad7
  8028a1:	e8 54 e1 ff ff       	call   8009fa <cprintf>
  8028a6:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8028a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028ad:	75 0a                	jne    8028b9 <alloc_block_FF+0xac>
	        return NULL;
  8028af:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b4:	e9 0e 04 00 00       	jmp    802cc7 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8028b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8028c0:	a1 30 50 80 00       	mov    0x805030,%eax
  8028c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c8:	e9 f3 02 00 00       	jmp    802bc0 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8028d3:	83 ec 0c             	sub    $0xc,%esp
  8028d6:	ff 75 bc             	pushl  -0x44(%ebp)
  8028d9:	e8 af fb ff ff       	call   80248d <get_block_size>
  8028de:	83 c4 10             	add    $0x10,%esp
  8028e1:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8028e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e7:	83 c0 08             	add    $0x8,%eax
  8028ea:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8028ed:	0f 87 c5 02 00 00    	ja     802bb8 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	83 c0 18             	add    $0x18,%eax
  8028f9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8028fc:	0f 87 19 02 00 00    	ja     802b1b <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802902:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802905:	2b 45 08             	sub    0x8(%ebp),%eax
  802908:	83 e8 08             	sub    $0x8,%eax
  80290b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	8d 50 08             	lea    0x8(%eax),%edx
  802914:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802917:	01 d0                	add    %edx,%eax
  802919:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	83 c0 08             	add    $0x8,%eax
  802922:	83 ec 04             	sub    $0x4,%esp
  802925:	6a 01                	push   $0x1
  802927:	50                   	push   %eax
  802928:	ff 75 bc             	pushl  -0x44(%ebp)
  80292b:	e8 ae fe ff ff       	call   8027de <set_block_data>
  802930:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 40 04             	mov    0x4(%eax),%eax
  802939:	85 c0                	test   %eax,%eax
  80293b:	75 68                	jne    8029a5 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80293d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802941:	75 17                	jne    80295a <alloc_block_FF+0x14d>
  802943:	83 ec 04             	sub    $0x4,%esp
  802946:	68 b4 4a 80 00       	push   $0x804ab4
  80294b:	68 d7 00 00 00       	push   $0xd7
  802950:	68 99 4a 80 00       	push   $0x804a99
  802955:	e8 e3 dd ff ff       	call   80073d <_panic>
  80295a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802960:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802963:	89 10                	mov    %edx,(%eax)
  802965:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	85 c0                	test   %eax,%eax
  80296c:	74 0d                	je     80297b <alloc_block_FF+0x16e>
  80296e:	a1 30 50 80 00       	mov    0x805030,%eax
  802973:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802976:	89 50 04             	mov    %edx,0x4(%eax)
  802979:	eb 08                	jmp    802983 <alloc_block_FF+0x176>
  80297b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80297e:	a3 34 50 80 00       	mov    %eax,0x805034
  802983:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802986:	a3 30 50 80 00       	mov    %eax,0x805030
  80298b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80298e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802995:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80299a:	40                   	inc    %eax
  80299b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8029a0:	e9 dc 00 00 00       	jmp    802a81 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	8b 00                	mov    (%eax),%eax
  8029aa:	85 c0                	test   %eax,%eax
  8029ac:	75 65                	jne    802a13 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029ae:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8029b2:	75 17                	jne    8029cb <alloc_block_FF+0x1be>
  8029b4:	83 ec 04             	sub    $0x4,%esp
  8029b7:	68 e8 4a 80 00       	push   $0x804ae8
  8029bc:	68 db 00 00 00       	push   $0xdb
  8029c1:	68 99 4a 80 00       	push   $0x804a99
  8029c6:	e8 72 dd ff ff       	call   80073d <_panic>
  8029cb:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8029d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029d4:	89 50 04             	mov    %edx,0x4(%eax)
  8029d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029da:	8b 40 04             	mov    0x4(%eax),%eax
  8029dd:	85 c0                	test   %eax,%eax
  8029df:	74 0c                	je     8029ed <alloc_block_FF+0x1e0>
  8029e1:	a1 34 50 80 00       	mov    0x805034,%eax
  8029e6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8029e9:	89 10                	mov    %edx,(%eax)
  8029eb:	eb 08                	jmp    8029f5 <alloc_block_FF+0x1e8>
  8029ed:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8029f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029f8:	a3 34 50 80 00       	mov    %eax,0x805034
  8029fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a06:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a0b:	40                   	inc    %eax
  802a0c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a11:	eb 6e                	jmp    802a81 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802a13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a17:	74 06                	je     802a1f <alloc_block_FF+0x212>
  802a19:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a1d:	75 17                	jne    802a36 <alloc_block_FF+0x229>
  802a1f:	83 ec 04             	sub    $0x4,%esp
  802a22:	68 0c 4b 80 00       	push   $0x804b0c
  802a27:	68 df 00 00 00       	push   $0xdf
  802a2c:	68 99 4a 80 00       	push   $0x804a99
  802a31:	e8 07 dd ff ff       	call   80073d <_panic>
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	8b 10                	mov    (%eax),%edx
  802a3b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a3e:	89 10                	mov    %edx,(%eax)
  802a40:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a43:	8b 00                	mov    (%eax),%eax
  802a45:	85 c0                	test   %eax,%eax
  802a47:	74 0b                	je     802a54 <alloc_block_FF+0x247>
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a51:	89 50 04             	mov    %edx,0x4(%eax)
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a5a:	89 10                	mov    %edx,(%eax)
  802a5c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a62:	89 50 04             	mov    %edx,0x4(%eax)
  802a65:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a68:	8b 00                	mov    (%eax),%eax
  802a6a:	85 c0                	test   %eax,%eax
  802a6c:	75 08                	jne    802a76 <alloc_block_FF+0x269>
  802a6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a71:	a3 34 50 80 00       	mov    %eax,0x805034
  802a76:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a7b:	40                   	inc    %eax
  802a7c:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802a81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a85:	75 17                	jne    802a9e <alloc_block_FF+0x291>
  802a87:	83 ec 04             	sub    $0x4,%esp
  802a8a:	68 7b 4a 80 00       	push   $0x804a7b
  802a8f:	68 e1 00 00 00       	push   $0xe1
  802a94:	68 99 4a 80 00       	push   $0x804a99
  802a99:	e8 9f dc ff ff       	call   80073d <_panic>
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 00                	mov    (%eax),%eax
  802aa3:	85 c0                	test   %eax,%eax
  802aa5:	74 10                	je     802ab7 <alloc_block_FF+0x2aa>
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aaf:	8b 52 04             	mov    0x4(%edx),%edx
  802ab2:	89 50 04             	mov    %edx,0x4(%eax)
  802ab5:	eb 0b                	jmp    802ac2 <alloc_block_FF+0x2b5>
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 40 04             	mov    0x4(%eax),%eax
  802abd:	a3 34 50 80 00       	mov    %eax,0x805034
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 40 04             	mov    0x4(%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 0f                	je     802adb <alloc_block_FF+0x2ce>
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 40 04             	mov    0x4(%eax),%eax
  802ad2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad5:	8b 12                	mov    (%edx),%edx
  802ad7:	89 10                	mov    %edx,(%eax)
  802ad9:	eb 0a                	jmp    802ae5 <alloc_block_FF+0x2d8>
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 00                	mov    (%eax),%eax
  802ae0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802afd:	48                   	dec    %eax
  802afe:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802b03:	83 ec 04             	sub    $0x4,%esp
  802b06:	6a 00                	push   $0x0
  802b08:	ff 75 b4             	pushl  -0x4c(%ebp)
  802b0b:	ff 75 b0             	pushl  -0x50(%ebp)
  802b0e:	e8 cb fc ff ff       	call   8027de <set_block_data>
  802b13:	83 c4 10             	add    $0x10,%esp
  802b16:	e9 95 00 00 00       	jmp    802bb0 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802b1b:	83 ec 04             	sub    $0x4,%esp
  802b1e:	6a 01                	push   $0x1
  802b20:	ff 75 b8             	pushl  -0x48(%ebp)
  802b23:	ff 75 bc             	pushl  -0x44(%ebp)
  802b26:	e8 b3 fc ff ff       	call   8027de <set_block_data>
  802b2b:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802b2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b32:	75 17                	jne    802b4b <alloc_block_FF+0x33e>
  802b34:	83 ec 04             	sub    $0x4,%esp
  802b37:	68 7b 4a 80 00       	push   $0x804a7b
  802b3c:	68 e8 00 00 00       	push   $0xe8
  802b41:	68 99 4a 80 00       	push   $0x804a99
  802b46:	e8 f2 db ff ff       	call   80073d <_panic>
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	8b 00                	mov    (%eax),%eax
  802b50:	85 c0                	test   %eax,%eax
  802b52:	74 10                	je     802b64 <alloc_block_FF+0x357>
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	8b 00                	mov    (%eax),%eax
  802b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b5c:	8b 52 04             	mov    0x4(%edx),%edx
  802b5f:	89 50 04             	mov    %edx,0x4(%eax)
  802b62:	eb 0b                	jmp    802b6f <alloc_block_FF+0x362>
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	8b 40 04             	mov    0x4(%eax),%eax
  802b6a:	a3 34 50 80 00       	mov    %eax,0x805034
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 40 04             	mov    0x4(%eax),%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	74 0f                	je     802b88 <alloc_block_FF+0x37b>
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	8b 40 04             	mov    0x4(%eax),%eax
  802b7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b82:	8b 12                	mov    (%edx),%edx
  802b84:	89 10                	mov    %edx,(%eax)
  802b86:	eb 0a                	jmp    802b92 <alloc_block_FF+0x385>
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	8b 00                	mov    (%eax),%eax
  802b8d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802baa:	48                   	dec    %eax
  802bab:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802bb0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bb3:	e9 0f 01 00 00       	jmp    802cc7 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802bb8:	a1 38 50 80 00       	mov    0x805038,%eax
  802bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc4:	74 07                	je     802bcd <alloc_block_FF+0x3c0>
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	8b 00                	mov    (%eax),%eax
  802bcb:	eb 05                	jmp    802bd2 <alloc_block_FF+0x3c5>
  802bcd:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd2:	a3 38 50 80 00       	mov    %eax,0x805038
  802bd7:	a1 38 50 80 00       	mov    0x805038,%eax
  802bdc:	85 c0                	test   %eax,%eax
  802bde:	0f 85 e9 fc ff ff    	jne    8028cd <alloc_block_FF+0xc0>
  802be4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be8:	0f 85 df fc ff ff    	jne    8028cd <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	83 c0 08             	add    $0x8,%eax
  802bf4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802bf7:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802bfe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c01:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c04:	01 d0                	add    %edx,%eax
  802c06:	48                   	dec    %eax
  802c07:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802c0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c0d:	ba 00 00 00 00       	mov    $0x0,%edx
  802c12:	f7 75 d8             	divl   -0x28(%ebp)
  802c15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c18:	29 d0                	sub    %edx,%eax
  802c1a:	c1 e8 0c             	shr    $0xc,%eax
  802c1d:	83 ec 0c             	sub    $0xc,%esp
  802c20:	50                   	push   %eax
  802c21:	e8 76 ed ff ff       	call   80199c <sbrk>
  802c26:	83 c4 10             	add    $0x10,%esp
  802c29:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802c2c:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802c30:	75 0a                	jne    802c3c <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802c32:	b8 00 00 00 00       	mov    $0x0,%eax
  802c37:	e9 8b 00 00 00       	jmp    802cc7 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c3c:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802c43:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c46:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c49:	01 d0                	add    %edx,%eax
  802c4b:	48                   	dec    %eax
  802c4c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802c4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c52:	ba 00 00 00 00       	mov    $0x0,%edx
  802c57:	f7 75 cc             	divl   -0x34(%ebp)
  802c5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c5d:	29 d0                	sub    %edx,%eax
  802c5f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c62:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c65:	01 d0                	add    %edx,%eax
  802c67:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802c6c:	a1 44 50 80 00       	mov    0x805044,%eax
  802c71:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c77:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c7e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c84:	01 d0                	add    %edx,%eax
  802c86:	48                   	dec    %eax
  802c87:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c8a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c8d:	ba 00 00 00 00       	mov    $0x0,%edx
  802c92:	f7 75 c4             	divl   -0x3c(%ebp)
  802c95:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c98:	29 d0                	sub    %edx,%eax
  802c9a:	83 ec 04             	sub    $0x4,%esp
  802c9d:	6a 01                	push   $0x1
  802c9f:	50                   	push   %eax
  802ca0:	ff 75 d0             	pushl  -0x30(%ebp)
  802ca3:	e8 36 fb ff ff       	call   8027de <set_block_data>
  802ca8:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802cab:	83 ec 0c             	sub    $0xc,%esp
  802cae:	ff 75 d0             	pushl  -0x30(%ebp)
  802cb1:	e8 1b 0a 00 00       	call   8036d1 <free_block>
  802cb6:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802cb9:	83 ec 0c             	sub    $0xc,%esp
  802cbc:	ff 75 08             	pushl  0x8(%ebp)
  802cbf:	e8 49 fb ff ff       	call   80280d <alloc_block_FF>
  802cc4:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802cc7:	c9                   	leave  
  802cc8:	c3                   	ret    

00802cc9 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802cc9:	55                   	push   %ebp
  802cca:	89 e5                	mov    %esp,%ebp
  802ccc:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	83 e0 01             	and    $0x1,%eax
  802cd5:	85 c0                	test   %eax,%eax
  802cd7:	74 03                	je     802cdc <alloc_block_BF+0x13>
  802cd9:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802cdc:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802ce0:	77 07                	ja     802ce9 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802ce2:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802ce9:	a1 28 50 80 00       	mov    0x805028,%eax
  802cee:	85 c0                	test   %eax,%eax
  802cf0:	75 73                	jne    802d65 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	83 c0 10             	add    $0x10,%eax
  802cf8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802cfb:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802d02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d08:	01 d0                	add    %edx,%eax
  802d0a:	48                   	dec    %eax
  802d0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d11:	ba 00 00 00 00       	mov    $0x0,%edx
  802d16:	f7 75 e0             	divl   -0x20(%ebp)
  802d19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d1c:	29 d0                	sub    %edx,%eax
  802d1e:	c1 e8 0c             	shr    $0xc,%eax
  802d21:	83 ec 0c             	sub    $0xc,%esp
  802d24:	50                   	push   %eax
  802d25:	e8 72 ec ff ff       	call   80199c <sbrk>
  802d2a:	83 c4 10             	add    $0x10,%esp
  802d2d:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802d30:	83 ec 0c             	sub    $0xc,%esp
  802d33:	6a 00                	push   $0x0
  802d35:	e8 62 ec ff ff       	call   80199c <sbrk>
  802d3a:	83 c4 10             	add    $0x10,%esp
  802d3d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802d40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d43:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802d46:	83 ec 08             	sub    $0x8,%esp
  802d49:	50                   	push   %eax
  802d4a:	ff 75 d8             	pushl  -0x28(%ebp)
  802d4d:	e8 9f f8 ff ff       	call   8025f1 <initialize_dynamic_allocator>
  802d52:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802d55:	83 ec 0c             	sub    $0xc,%esp
  802d58:	68 d7 4a 80 00       	push   $0x804ad7
  802d5d:	e8 98 dc ff ff       	call   8009fa <cprintf>
  802d62:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802d65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802d6c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802d73:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802d7a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802d81:	a1 30 50 80 00       	mov    0x805030,%eax
  802d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d89:	e9 1d 01 00 00       	jmp    802eab <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802d94:	83 ec 0c             	sub    $0xc,%esp
  802d97:	ff 75 a8             	pushl  -0x58(%ebp)
  802d9a:	e8 ee f6 ff ff       	call   80248d <get_block_size>
  802d9f:	83 c4 10             	add    $0x10,%esp
  802da2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802da5:	8b 45 08             	mov    0x8(%ebp),%eax
  802da8:	83 c0 08             	add    $0x8,%eax
  802dab:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802dae:	0f 87 ef 00 00 00    	ja     802ea3 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802db4:	8b 45 08             	mov    0x8(%ebp),%eax
  802db7:	83 c0 18             	add    $0x18,%eax
  802dba:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802dbd:	77 1d                	ja     802ddc <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802dbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802dc5:	0f 86 d8 00 00 00    	jbe    802ea3 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802dcb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802dce:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802dd1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802dd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802dd7:	e9 c7 00 00 00       	jmp    802ea3 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	83 c0 08             	add    $0x8,%eax
  802de2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802de5:	0f 85 9d 00 00 00    	jne    802e88 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802deb:	83 ec 04             	sub    $0x4,%esp
  802dee:	6a 01                	push   $0x1
  802df0:	ff 75 a4             	pushl  -0x5c(%ebp)
  802df3:	ff 75 a8             	pushl  -0x58(%ebp)
  802df6:	e8 e3 f9 ff ff       	call   8027de <set_block_data>
  802dfb:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802dfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e02:	75 17                	jne    802e1b <alloc_block_BF+0x152>
  802e04:	83 ec 04             	sub    $0x4,%esp
  802e07:	68 7b 4a 80 00       	push   $0x804a7b
  802e0c:	68 2c 01 00 00       	push   $0x12c
  802e11:	68 99 4a 80 00       	push   $0x804a99
  802e16:	e8 22 d9 ff ff       	call   80073d <_panic>
  802e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1e:	8b 00                	mov    (%eax),%eax
  802e20:	85 c0                	test   %eax,%eax
  802e22:	74 10                	je     802e34 <alloc_block_BF+0x16b>
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 00                	mov    (%eax),%eax
  802e29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2c:	8b 52 04             	mov    0x4(%edx),%edx
  802e2f:	89 50 04             	mov    %edx,0x4(%eax)
  802e32:	eb 0b                	jmp    802e3f <alloc_block_BF+0x176>
  802e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e37:	8b 40 04             	mov    0x4(%eax),%eax
  802e3a:	a3 34 50 80 00       	mov    %eax,0x805034
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	8b 40 04             	mov    0x4(%eax),%eax
  802e45:	85 c0                	test   %eax,%eax
  802e47:	74 0f                	je     802e58 <alloc_block_BF+0x18f>
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	8b 40 04             	mov    0x4(%eax),%eax
  802e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e52:	8b 12                	mov    (%edx),%edx
  802e54:	89 10                	mov    %edx,(%eax)
  802e56:	eb 0a                	jmp    802e62 <alloc_block_BF+0x199>
  802e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5b:	8b 00                	mov    (%eax),%eax
  802e5d:	a3 30 50 80 00       	mov    %eax,0x805030
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e75:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e7a:	48                   	dec    %eax
  802e7b:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802e80:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e83:	e9 24 04 00 00       	jmp    8032ac <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e8e:	76 13                	jbe    802ea3 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802e90:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802e97:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802e9d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ea0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802ea3:	a1 38 50 80 00       	mov    0x805038,%eax
  802ea8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eaf:	74 07                	je     802eb8 <alloc_block_BF+0x1ef>
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	8b 00                	mov    (%eax),%eax
  802eb6:	eb 05                	jmp    802ebd <alloc_block_BF+0x1f4>
  802eb8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ebd:	a3 38 50 80 00       	mov    %eax,0x805038
  802ec2:	a1 38 50 80 00       	mov    0x805038,%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	0f 85 bf fe ff ff    	jne    802d8e <alloc_block_BF+0xc5>
  802ecf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed3:	0f 85 b5 fe ff ff    	jne    802d8e <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802ed9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802edd:	0f 84 26 02 00 00    	je     803109 <alloc_block_BF+0x440>
  802ee3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ee7:	0f 85 1c 02 00 00    	jne    803109 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef0:	2b 45 08             	sub    0x8(%ebp),%eax
  802ef3:	83 e8 08             	sub    $0x8,%eax
  802ef6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	8d 50 08             	lea    0x8(%eax),%edx
  802eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f02:	01 d0                	add    %edx,%eax
  802f04:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	83 c0 08             	add    $0x8,%eax
  802f0d:	83 ec 04             	sub    $0x4,%esp
  802f10:	6a 01                	push   $0x1
  802f12:	50                   	push   %eax
  802f13:	ff 75 f0             	pushl  -0x10(%ebp)
  802f16:	e8 c3 f8 ff ff       	call   8027de <set_block_data>
  802f1b:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f21:	8b 40 04             	mov    0x4(%eax),%eax
  802f24:	85 c0                	test   %eax,%eax
  802f26:	75 68                	jne    802f90 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f28:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f2c:	75 17                	jne    802f45 <alloc_block_BF+0x27c>
  802f2e:	83 ec 04             	sub    $0x4,%esp
  802f31:	68 b4 4a 80 00       	push   $0x804ab4
  802f36:	68 45 01 00 00       	push   $0x145
  802f3b:	68 99 4a 80 00       	push   $0x804a99
  802f40:	e8 f8 d7 ff ff       	call   80073d <_panic>
  802f45:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f4e:	89 10                	mov    %edx,(%eax)
  802f50:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f53:	8b 00                	mov    (%eax),%eax
  802f55:	85 c0                	test   %eax,%eax
  802f57:	74 0d                	je     802f66 <alloc_block_BF+0x29d>
  802f59:	a1 30 50 80 00       	mov    0x805030,%eax
  802f5e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802f61:	89 50 04             	mov    %edx,0x4(%eax)
  802f64:	eb 08                	jmp    802f6e <alloc_block_BF+0x2a5>
  802f66:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f69:	a3 34 50 80 00       	mov    %eax,0x805034
  802f6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f71:	a3 30 50 80 00       	mov    %eax,0x805030
  802f76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802f79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f80:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f85:	40                   	inc    %eax
  802f86:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802f8b:	e9 dc 00 00 00       	jmp    80306c <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f93:	8b 00                	mov    (%eax),%eax
  802f95:	85 c0                	test   %eax,%eax
  802f97:	75 65                	jne    802ffe <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802f99:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802f9d:	75 17                	jne    802fb6 <alloc_block_BF+0x2ed>
  802f9f:	83 ec 04             	sub    $0x4,%esp
  802fa2:	68 e8 4a 80 00       	push   $0x804ae8
  802fa7:	68 4a 01 00 00       	push   $0x14a
  802fac:	68 99 4a 80 00       	push   $0x804a99
  802fb1:	e8 87 d7 ff ff       	call   80073d <_panic>
  802fb6:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802fbc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fbf:	89 50 04             	mov    %edx,0x4(%eax)
  802fc2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fc5:	8b 40 04             	mov    0x4(%eax),%eax
  802fc8:	85 c0                	test   %eax,%eax
  802fca:	74 0c                	je     802fd8 <alloc_block_BF+0x30f>
  802fcc:	a1 34 50 80 00       	mov    0x805034,%eax
  802fd1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802fd4:	89 10                	mov    %edx,(%eax)
  802fd6:	eb 08                	jmp    802fe0 <alloc_block_BF+0x317>
  802fd8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fdb:	a3 30 50 80 00       	mov    %eax,0x805030
  802fe0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802fe3:	a3 34 50 80 00       	mov    %eax,0x805034
  802fe8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802feb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ff6:	40                   	inc    %eax
  802ff7:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ffc:	eb 6e                	jmp    80306c <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ffe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803002:	74 06                	je     80300a <alloc_block_BF+0x341>
  803004:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803008:	75 17                	jne    803021 <alloc_block_BF+0x358>
  80300a:	83 ec 04             	sub    $0x4,%esp
  80300d:	68 0c 4b 80 00       	push   $0x804b0c
  803012:	68 4f 01 00 00       	push   $0x14f
  803017:	68 99 4a 80 00       	push   $0x804a99
  80301c:	e8 1c d7 ff ff       	call   80073d <_panic>
  803021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803024:	8b 10                	mov    (%eax),%edx
  803026:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803029:	89 10                	mov    %edx,(%eax)
  80302b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80302e:	8b 00                	mov    (%eax),%eax
  803030:	85 c0                	test   %eax,%eax
  803032:	74 0b                	je     80303f <alloc_block_BF+0x376>
  803034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803037:	8b 00                	mov    (%eax),%eax
  803039:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80303c:	89 50 04             	mov    %edx,0x4(%eax)
  80303f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803042:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803045:	89 10                	mov    %edx,(%eax)
  803047:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80304a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80304d:	89 50 04             	mov    %edx,0x4(%eax)
  803050:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	85 c0                	test   %eax,%eax
  803057:	75 08                	jne    803061 <alloc_block_BF+0x398>
  803059:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80305c:	a3 34 50 80 00       	mov    %eax,0x805034
  803061:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803066:	40                   	inc    %eax
  803067:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80306c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803070:	75 17                	jne    803089 <alloc_block_BF+0x3c0>
  803072:	83 ec 04             	sub    $0x4,%esp
  803075:	68 7b 4a 80 00       	push   $0x804a7b
  80307a:	68 51 01 00 00       	push   $0x151
  80307f:	68 99 4a 80 00       	push   $0x804a99
  803084:	e8 b4 d6 ff ff       	call   80073d <_panic>
  803089:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308c:	8b 00                	mov    (%eax),%eax
  80308e:	85 c0                	test   %eax,%eax
  803090:	74 10                	je     8030a2 <alloc_block_BF+0x3d9>
  803092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803095:	8b 00                	mov    (%eax),%eax
  803097:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80309a:	8b 52 04             	mov    0x4(%edx),%edx
  80309d:	89 50 04             	mov    %edx,0x4(%eax)
  8030a0:	eb 0b                	jmp    8030ad <alloc_block_BF+0x3e4>
  8030a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a5:	8b 40 04             	mov    0x4(%eax),%eax
  8030a8:	a3 34 50 80 00       	mov    %eax,0x805034
  8030ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b0:	8b 40 04             	mov    0x4(%eax),%eax
  8030b3:	85 c0                	test   %eax,%eax
  8030b5:	74 0f                	je     8030c6 <alloc_block_BF+0x3fd>
  8030b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ba:	8b 40 04             	mov    0x4(%eax),%eax
  8030bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c0:	8b 12                	mov    (%edx),%edx
  8030c2:	89 10                	mov    %edx,(%eax)
  8030c4:	eb 0a                	jmp    8030d0 <alloc_block_BF+0x407>
  8030c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c9:	8b 00                	mov    (%eax),%eax
  8030cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8030d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030e8:	48                   	dec    %eax
  8030e9:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  8030ee:	83 ec 04             	sub    $0x4,%esp
  8030f1:	6a 00                	push   $0x0
  8030f3:	ff 75 d0             	pushl  -0x30(%ebp)
  8030f6:	ff 75 cc             	pushl  -0x34(%ebp)
  8030f9:	e8 e0 f6 ff ff       	call   8027de <set_block_data>
  8030fe:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803104:	e9 a3 01 00 00       	jmp    8032ac <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803109:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80310d:	0f 85 9d 00 00 00    	jne    8031b0 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803113:	83 ec 04             	sub    $0x4,%esp
  803116:	6a 01                	push   $0x1
  803118:	ff 75 ec             	pushl  -0x14(%ebp)
  80311b:	ff 75 f0             	pushl  -0x10(%ebp)
  80311e:	e8 bb f6 ff ff       	call   8027de <set_block_data>
  803123:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803126:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80312a:	75 17                	jne    803143 <alloc_block_BF+0x47a>
  80312c:	83 ec 04             	sub    $0x4,%esp
  80312f:	68 7b 4a 80 00       	push   $0x804a7b
  803134:	68 58 01 00 00       	push   $0x158
  803139:	68 99 4a 80 00       	push   $0x804a99
  80313e:	e8 fa d5 ff ff       	call   80073d <_panic>
  803143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803146:	8b 00                	mov    (%eax),%eax
  803148:	85 c0                	test   %eax,%eax
  80314a:	74 10                	je     80315c <alloc_block_BF+0x493>
  80314c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314f:	8b 00                	mov    (%eax),%eax
  803151:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803154:	8b 52 04             	mov    0x4(%edx),%edx
  803157:	89 50 04             	mov    %edx,0x4(%eax)
  80315a:	eb 0b                	jmp    803167 <alloc_block_BF+0x49e>
  80315c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315f:	8b 40 04             	mov    0x4(%eax),%eax
  803162:	a3 34 50 80 00       	mov    %eax,0x805034
  803167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316a:	8b 40 04             	mov    0x4(%eax),%eax
  80316d:	85 c0                	test   %eax,%eax
  80316f:	74 0f                	je     803180 <alloc_block_BF+0x4b7>
  803171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803174:	8b 40 04             	mov    0x4(%eax),%eax
  803177:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80317a:	8b 12                	mov    (%edx),%edx
  80317c:	89 10                	mov    %edx,(%eax)
  80317e:	eb 0a                	jmp    80318a <alloc_block_BF+0x4c1>
  803180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803183:	8b 00                	mov    (%eax),%eax
  803185:	a3 30 50 80 00       	mov    %eax,0x805030
  80318a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803196:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80319d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031a2:	48                   	dec    %eax
  8031a3:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  8031a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ab:	e9 fc 00 00 00       	jmp    8032ac <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8031b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b3:	83 c0 08             	add    $0x8,%eax
  8031b6:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8031b9:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8031c0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031c3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8031c6:	01 d0                	add    %edx,%eax
  8031c8:	48                   	dec    %eax
  8031c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8031cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8031d4:	f7 75 c4             	divl   -0x3c(%ebp)
  8031d7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8031da:	29 d0                	sub    %edx,%eax
  8031dc:	c1 e8 0c             	shr    $0xc,%eax
  8031df:	83 ec 0c             	sub    $0xc,%esp
  8031e2:	50                   	push   %eax
  8031e3:	e8 b4 e7 ff ff       	call   80199c <sbrk>
  8031e8:	83 c4 10             	add    $0x10,%esp
  8031eb:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8031ee:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8031f2:	75 0a                	jne    8031fe <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8031f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f9:	e9 ae 00 00 00       	jmp    8032ac <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8031fe:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803205:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803208:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80320b:	01 d0                	add    %edx,%eax
  80320d:	48                   	dec    %eax
  80320e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803211:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803214:	ba 00 00 00 00       	mov    $0x0,%edx
  803219:	f7 75 b8             	divl   -0x48(%ebp)
  80321c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80321f:	29 d0                	sub    %edx,%eax
  803221:	8d 50 fc             	lea    -0x4(%eax),%edx
  803224:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803227:	01 d0                	add    %edx,%eax
  803229:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  80322e:	a1 44 50 80 00       	mov    0x805044,%eax
  803233:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803239:	83 ec 0c             	sub    $0xc,%esp
  80323c:	68 40 4b 80 00       	push   $0x804b40
  803241:	e8 b4 d7 ff ff       	call   8009fa <cprintf>
  803246:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803249:	83 ec 08             	sub    $0x8,%esp
  80324c:	ff 75 bc             	pushl  -0x44(%ebp)
  80324f:	68 45 4b 80 00       	push   $0x804b45
  803254:	e8 a1 d7 ff ff       	call   8009fa <cprintf>
  803259:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80325c:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803263:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803266:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803269:	01 d0                	add    %edx,%eax
  80326b:	48                   	dec    %eax
  80326c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80326f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803272:	ba 00 00 00 00       	mov    $0x0,%edx
  803277:	f7 75 b0             	divl   -0x50(%ebp)
  80327a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80327d:	29 d0                	sub    %edx,%eax
  80327f:	83 ec 04             	sub    $0x4,%esp
  803282:	6a 01                	push   $0x1
  803284:	50                   	push   %eax
  803285:	ff 75 bc             	pushl  -0x44(%ebp)
  803288:	e8 51 f5 ff ff       	call   8027de <set_block_data>
  80328d:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803290:	83 ec 0c             	sub    $0xc,%esp
  803293:	ff 75 bc             	pushl  -0x44(%ebp)
  803296:	e8 36 04 00 00       	call   8036d1 <free_block>
  80329b:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80329e:	83 ec 0c             	sub    $0xc,%esp
  8032a1:	ff 75 08             	pushl  0x8(%ebp)
  8032a4:	e8 20 fa ff ff       	call   802cc9 <alloc_block_BF>
  8032a9:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8032ac:	c9                   	leave  
  8032ad:	c3                   	ret    

008032ae <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8032ae:	55                   	push   %ebp
  8032af:	89 e5                	mov    %esp,%ebp
  8032b1:	53                   	push   %ebx
  8032b2:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8032b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8032bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8032c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c7:	74 1e                	je     8032e7 <merging+0x39>
  8032c9:	ff 75 08             	pushl  0x8(%ebp)
  8032cc:	e8 bc f1 ff ff       	call   80248d <get_block_size>
  8032d1:	83 c4 04             	add    $0x4,%esp
  8032d4:	89 c2                	mov    %eax,%edx
  8032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d9:	01 d0                	add    %edx,%eax
  8032db:	3b 45 10             	cmp    0x10(%ebp),%eax
  8032de:	75 07                	jne    8032e7 <merging+0x39>
		prev_is_free = 1;
  8032e0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8032e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032eb:	74 1e                	je     80330b <merging+0x5d>
  8032ed:	ff 75 10             	pushl  0x10(%ebp)
  8032f0:	e8 98 f1 ff ff       	call   80248d <get_block_size>
  8032f5:	83 c4 04             	add    $0x4,%esp
  8032f8:	89 c2                	mov    %eax,%edx
  8032fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8032fd:	01 d0                	add    %edx,%eax
  8032ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803302:	75 07                	jne    80330b <merging+0x5d>
		next_is_free = 1;
  803304:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80330b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80330f:	0f 84 cc 00 00 00    	je     8033e1 <merging+0x133>
  803315:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803319:	0f 84 c2 00 00 00    	je     8033e1 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80331f:	ff 75 08             	pushl  0x8(%ebp)
  803322:	e8 66 f1 ff ff       	call   80248d <get_block_size>
  803327:	83 c4 04             	add    $0x4,%esp
  80332a:	89 c3                	mov    %eax,%ebx
  80332c:	ff 75 10             	pushl  0x10(%ebp)
  80332f:	e8 59 f1 ff ff       	call   80248d <get_block_size>
  803334:	83 c4 04             	add    $0x4,%esp
  803337:	01 c3                	add    %eax,%ebx
  803339:	ff 75 0c             	pushl  0xc(%ebp)
  80333c:	e8 4c f1 ff ff       	call   80248d <get_block_size>
  803341:	83 c4 04             	add    $0x4,%esp
  803344:	01 d8                	add    %ebx,%eax
  803346:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803349:	6a 00                	push   $0x0
  80334b:	ff 75 ec             	pushl  -0x14(%ebp)
  80334e:	ff 75 08             	pushl  0x8(%ebp)
  803351:	e8 88 f4 ff ff       	call   8027de <set_block_data>
  803356:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803359:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80335d:	75 17                	jne    803376 <merging+0xc8>
  80335f:	83 ec 04             	sub    $0x4,%esp
  803362:	68 7b 4a 80 00       	push   $0x804a7b
  803367:	68 7d 01 00 00       	push   $0x17d
  80336c:	68 99 4a 80 00       	push   $0x804a99
  803371:	e8 c7 d3 ff ff       	call   80073d <_panic>
  803376:	8b 45 0c             	mov    0xc(%ebp),%eax
  803379:	8b 00                	mov    (%eax),%eax
  80337b:	85 c0                	test   %eax,%eax
  80337d:	74 10                	je     80338f <merging+0xe1>
  80337f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803382:	8b 00                	mov    (%eax),%eax
  803384:	8b 55 0c             	mov    0xc(%ebp),%edx
  803387:	8b 52 04             	mov    0x4(%edx),%edx
  80338a:	89 50 04             	mov    %edx,0x4(%eax)
  80338d:	eb 0b                	jmp    80339a <merging+0xec>
  80338f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803392:	8b 40 04             	mov    0x4(%eax),%eax
  803395:	a3 34 50 80 00       	mov    %eax,0x805034
  80339a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80339d:	8b 40 04             	mov    0x4(%eax),%eax
  8033a0:	85 c0                	test   %eax,%eax
  8033a2:	74 0f                	je     8033b3 <merging+0x105>
  8033a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a7:	8b 40 04             	mov    0x4(%eax),%eax
  8033aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033ad:	8b 12                	mov    (%edx),%edx
  8033af:	89 10                	mov    %edx,(%eax)
  8033b1:	eb 0a                	jmp    8033bd <merging+0x10f>
  8033b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b6:	8b 00                	mov    (%eax),%eax
  8033b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8033bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8033d5:	48                   	dec    %eax
  8033d6:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8033db:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8033dc:	e9 ea 02 00 00       	jmp    8036cb <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8033e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e5:	74 3b                	je     803422 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8033e7:	83 ec 0c             	sub    $0xc,%esp
  8033ea:	ff 75 08             	pushl  0x8(%ebp)
  8033ed:	e8 9b f0 ff ff       	call   80248d <get_block_size>
  8033f2:	83 c4 10             	add    $0x10,%esp
  8033f5:	89 c3                	mov    %eax,%ebx
  8033f7:	83 ec 0c             	sub    $0xc,%esp
  8033fa:	ff 75 10             	pushl  0x10(%ebp)
  8033fd:	e8 8b f0 ff ff       	call   80248d <get_block_size>
  803402:	83 c4 10             	add    $0x10,%esp
  803405:	01 d8                	add    %ebx,%eax
  803407:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80340a:	83 ec 04             	sub    $0x4,%esp
  80340d:	6a 00                	push   $0x0
  80340f:	ff 75 e8             	pushl  -0x18(%ebp)
  803412:	ff 75 08             	pushl  0x8(%ebp)
  803415:	e8 c4 f3 ff ff       	call   8027de <set_block_data>
  80341a:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80341d:	e9 a9 02 00 00       	jmp    8036cb <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803422:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803426:	0f 84 2d 01 00 00    	je     803559 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80342c:	83 ec 0c             	sub    $0xc,%esp
  80342f:	ff 75 10             	pushl  0x10(%ebp)
  803432:	e8 56 f0 ff ff       	call   80248d <get_block_size>
  803437:	83 c4 10             	add    $0x10,%esp
  80343a:	89 c3                	mov    %eax,%ebx
  80343c:	83 ec 0c             	sub    $0xc,%esp
  80343f:	ff 75 0c             	pushl  0xc(%ebp)
  803442:	e8 46 f0 ff ff       	call   80248d <get_block_size>
  803447:	83 c4 10             	add    $0x10,%esp
  80344a:	01 d8                	add    %ebx,%eax
  80344c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80344f:	83 ec 04             	sub    $0x4,%esp
  803452:	6a 00                	push   $0x0
  803454:	ff 75 e4             	pushl  -0x1c(%ebp)
  803457:	ff 75 10             	pushl  0x10(%ebp)
  80345a:	e8 7f f3 ff ff       	call   8027de <set_block_data>
  80345f:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803462:	8b 45 10             	mov    0x10(%ebp),%eax
  803465:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803468:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80346c:	74 06                	je     803474 <merging+0x1c6>
  80346e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803472:	75 17                	jne    80348b <merging+0x1dd>
  803474:	83 ec 04             	sub    $0x4,%esp
  803477:	68 54 4b 80 00       	push   $0x804b54
  80347c:	68 8d 01 00 00       	push   $0x18d
  803481:	68 99 4a 80 00       	push   $0x804a99
  803486:	e8 b2 d2 ff ff       	call   80073d <_panic>
  80348b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348e:	8b 50 04             	mov    0x4(%eax),%edx
  803491:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803494:	89 50 04             	mov    %edx,0x4(%eax)
  803497:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80349d:	89 10                	mov    %edx,(%eax)
  80349f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a2:	8b 40 04             	mov    0x4(%eax),%eax
  8034a5:	85 c0                	test   %eax,%eax
  8034a7:	74 0d                	je     8034b6 <merging+0x208>
  8034a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ac:	8b 40 04             	mov    0x4(%eax),%eax
  8034af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034b2:	89 10                	mov    %edx,(%eax)
  8034b4:	eb 08                	jmp    8034be <merging+0x210>
  8034b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8034be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034c4:	89 50 04             	mov    %edx,0x4(%eax)
  8034c7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034cc:	40                   	inc    %eax
  8034cd:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  8034d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034d6:	75 17                	jne    8034ef <merging+0x241>
  8034d8:	83 ec 04             	sub    $0x4,%esp
  8034db:	68 7b 4a 80 00       	push   $0x804a7b
  8034e0:	68 8e 01 00 00       	push   $0x18e
  8034e5:	68 99 4a 80 00       	push   $0x804a99
  8034ea:	e8 4e d2 ff ff       	call   80073d <_panic>
  8034ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f2:	8b 00                	mov    (%eax),%eax
  8034f4:	85 c0                	test   %eax,%eax
  8034f6:	74 10                	je     803508 <merging+0x25a>
  8034f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034fb:	8b 00                	mov    (%eax),%eax
  8034fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  803500:	8b 52 04             	mov    0x4(%edx),%edx
  803503:	89 50 04             	mov    %edx,0x4(%eax)
  803506:	eb 0b                	jmp    803513 <merging+0x265>
  803508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80350b:	8b 40 04             	mov    0x4(%eax),%eax
  80350e:	a3 34 50 80 00       	mov    %eax,0x805034
  803513:	8b 45 0c             	mov    0xc(%ebp),%eax
  803516:	8b 40 04             	mov    0x4(%eax),%eax
  803519:	85 c0                	test   %eax,%eax
  80351b:	74 0f                	je     80352c <merging+0x27e>
  80351d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803520:	8b 40 04             	mov    0x4(%eax),%eax
  803523:	8b 55 0c             	mov    0xc(%ebp),%edx
  803526:	8b 12                	mov    (%edx),%edx
  803528:	89 10                	mov    %edx,(%eax)
  80352a:	eb 0a                	jmp    803536 <merging+0x288>
  80352c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352f:	8b 00                	mov    (%eax),%eax
  803531:	a3 30 50 80 00       	mov    %eax,0x805030
  803536:	8b 45 0c             	mov    0xc(%ebp),%eax
  803539:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80353f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803542:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803549:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80354e:	48                   	dec    %eax
  80354f:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803554:	e9 72 01 00 00       	jmp    8036cb <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803559:	8b 45 10             	mov    0x10(%ebp),%eax
  80355c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80355f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803563:	74 79                	je     8035de <merging+0x330>
  803565:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803569:	74 73                	je     8035de <merging+0x330>
  80356b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80356f:	74 06                	je     803577 <merging+0x2c9>
  803571:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803575:	75 17                	jne    80358e <merging+0x2e0>
  803577:	83 ec 04             	sub    $0x4,%esp
  80357a:	68 0c 4b 80 00       	push   $0x804b0c
  80357f:	68 94 01 00 00       	push   $0x194
  803584:	68 99 4a 80 00       	push   $0x804a99
  803589:	e8 af d1 ff ff       	call   80073d <_panic>
  80358e:	8b 45 08             	mov    0x8(%ebp),%eax
  803591:	8b 10                	mov    (%eax),%edx
  803593:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803596:	89 10                	mov    %edx,(%eax)
  803598:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80359b:	8b 00                	mov    (%eax),%eax
  80359d:	85 c0                	test   %eax,%eax
  80359f:	74 0b                	je     8035ac <merging+0x2fe>
  8035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a4:	8b 00                	mov    (%eax),%eax
  8035a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035a9:	89 50 04             	mov    %edx,0x4(%eax)
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035b2:	89 10                	mov    %edx,(%eax)
  8035b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ba:	89 50 04             	mov    %edx,0x4(%eax)
  8035bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035c0:	8b 00                	mov    (%eax),%eax
  8035c2:	85 c0                	test   %eax,%eax
  8035c4:	75 08                	jne    8035ce <merging+0x320>
  8035c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035c9:	a3 34 50 80 00       	mov    %eax,0x805034
  8035ce:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035d3:	40                   	inc    %eax
  8035d4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035d9:	e9 ce 00 00 00       	jmp    8036ac <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8035de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e2:	74 65                	je     803649 <merging+0x39b>
  8035e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8035e8:	75 17                	jne    803601 <merging+0x353>
  8035ea:	83 ec 04             	sub    $0x4,%esp
  8035ed:	68 e8 4a 80 00       	push   $0x804ae8
  8035f2:	68 95 01 00 00       	push   $0x195
  8035f7:	68 99 4a 80 00       	push   $0x804a99
  8035fc:	e8 3c d1 ff ff       	call   80073d <_panic>
  803601:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80360a:	89 50 04             	mov    %edx,0x4(%eax)
  80360d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803610:	8b 40 04             	mov    0x4(%eax),%eax
  803613:	85 c0                	test   %eax,%eax
  803615:	74 0c                	je     803623 <merging+0x375>
  803617:	a1 34 50 80 00       	mov    0x805034,%eax
  80361c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80361f:	89 10                	mov    %edx,(%eax)
  803621:	eb 08                	jmp    80362b <merging+0x37d>
  803623:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803626:	a3 30 50 80 00       	mov    %eax,0x805030
  80362b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80362e:	a3 34 50 80 00       	mov    %eax,0x805034
  803633:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803636:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80363c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803641:	40                   	inc    %eax
  803642:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803647:	eb 63                	jmp    8036ac <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803649:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80364d:	75 17                	jne    803666 <merging+0x3b8>
  80364f:	83 ec 04             	sub    $0x4,%esp
  803652:	68 b4 4a 80 00       	push   $0x804ab4
  803657:	68 98 01 00 00       	push   $0x198
  80365c:	68 99 4a 80 00       	push   $0x804a99
  803661:	e8 d7 d0 ff ff       	call   80073d <_panic>
  803666:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80366c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80366f:	89 10                	mov    %edx,(%eax)
  803671:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803674:	8b 00                	mov    (%eax),%eax
  803676:	85 c0                	test   %eax,%eax
  803678:	74 0d                	je     803687 <merging+0x3d9>
  80367a:	a1 30 50 80 00       	mov    0x805030,%eax
  80367f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803682:	89 50 04             	mov    %edx,0x4(%eax)
  803685:	eb 08                	jmp    80368f <merging+0x3e1>
  803687:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80368a:	a3 34 50 80 00       	mov    %eax,0x805034
  80368f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803692:	a3 30 50 80 00       	mov    %eax,0x805030
  803697:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80369a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036a6:	40                   	inc    %eax
  8036a7:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  8036ac:	83 ec 0c             	sub    $0xc,%esp
  8036af:	ff 75 10             	pushl  0x10(%ebp)
  8036b2:	e8 d6 ed ff ff       	call   80248d <get_block_size>
  8036b7:	83 c4 10             	add    $0x10,%esp
  8036ba:	83 ec 04             	sub    $0x4,%esp
  8036bd:	6a 00                	push   $0x0
  8036bf:	50                   	push   %eax
  8036c0:	ff 75 10             	pushl  0x10(%ebp)
  8036c3:	e8 16 f1 ff ff       	call   8027de <set_block_data>
  8036c8:	83 c4 10             	add    $0x10,%esp
	}
}
  8036cb:	90                   	nop
  8036cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8036cf:	c9                   	leave  
  8036d0:	c3                   	ret    

008036d1 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8036d1:	55                   	push   %ebp
  8036d2:	89 e5                	mov    %esp,%ebp
  8036d4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8036d7:	a1 30 50 80 00       	mov    0x805030,%eax
  8036dc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8036df:	a1 34 50 80 00       	mov    0x805034,%eax
  8036e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036e7:	73 1b                	jae    803704 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8036e9:	a1 34 50 80 00       	mov    0x805034,%eax
  8036ee:	83 ec 04             	sub    $0x4,%esp
  8036f1:	ff 75 08             	pushl  0x8(%ebp)
  8036f4:	6a 00                	push   $0x0
  8036f6:	50                   	push   %eax
  8036f7:	e8 b2 fb ff ff       	call   8032ae <merging>
  8036fc:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8036ff:	e9 8b 00 00 00       	jmp    80378f <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803704:	a1 30 50 80 00       	mov    0x805030,%eax
  803709:	3b 45 08             	cmp    0x8(%ebp),%eax
  80370c:	76 18                	jbe    803726 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80370e:	a1 30 50 80 00       	mov    0x805030,%eax
  803713:	83 ec 04             	sub    $0x4,%esp
  803716:	ff 75 08             	pushl  0x8(%ebp)
  803719:	50                   	push   %eax
  80371a:	6a 00                	push   $0x0
  80371c:	e8 8d fb ff ff       	call   8032ae <merging>
  803721:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803724:	eb 69                	jmp    80378f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803726:	a1 30 50 80 00       	mov    0x805030,%eax
  80372b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80372e:	eb 39                	jmp    803769 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803733:	3b 45 08             	cmp    0x8(%ebp),%eax
  803736:	73 29                	jae    803761 <free_block+0x90>
  803738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373b:	8b 00                	mov    (%eax),%eax
  80373d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803740:	76 1f                	jbe    803761 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803745:	8b 00                	mov    (%eax),%eax
  803747:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80374a:	83 ec 04             	sub    $0x4,%esp
  80374d:	ff 75 08             	pushl  0x8(%ebp)
  803750:	ff 75 f0             	pushl  -0x10(%ebp)
  803753:	ff 75 f4             	pushl  -0xc(%ebp)
  803756:	e8 53 fb ff ff       	call   8032ae <merging>
  80375b:	83 c4 10             	add    $0x10,%esp
			break;
  80375e:	90                   	nop
		}
	}
}
  80375f:	eb 2e                	jmp    80378f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803761:	a1 38 50 80 00       	mov    0x805038,%eax
  803766:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803769:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80376d:	74 07                	je     803776 <free_block+0xa5>
  80376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803772:	8b 00                	mov    (%eax),%eax
  803774:	eb 05                	jmp    80377b <free_block+0xaa>
  803776:	b8 00 00 00 00       	mov    $0x0,%eax
  80377b:	a3 38 50 80 00       	mov    %eax,0x805038
  803780:	a1 38 50 80 00       	mov    0x805038,%eax
  803785:	85 c0                	test   %eax,%eax
  803787:	75 a7                	jne    803730 <free_block+0x5f>
  803789:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80378d:	75 a1                	jne    803730 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80378f:	90                   	nop
  803790:	c9                   	leave  
  803791:	c3                   	ret    

00803792 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803792:	55                   	push   %ebp
  803793:	89 e5                	mov    %esp,%ebp
  803795:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803798:	ff 75 08             	pushl  0x8(%ebp)
  80379b:	e8 ed ec ff ff       	call   80248d <get_block_size>
  8037a0:	83 c4 04             	add    $0x4,%esp
  8037a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8037a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8037ad:	eb 17                	jmp    8037c6 <copy_data+0x34>
  8037af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8037b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b5:	01 c2                	add    %eax,%edx
  8037b7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8037ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bd:	01 c8                	add    %ecx,%eax
  8037bf:	8a 00                	mov    (%eax),%al
  8037c1:	88 02                	mov    %al,(%edx)
  8037c3:	ff 45 fc             	incl   -0x4(%ebp)
  8037c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8037cc:	72 e1                	jb     8037af <copy_data+0x1d>
}
  8037ce:	90                   	nop
  8037cf:	c9                   	leave  
  8037d0:	c3                   	ret    

008037d1 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8037d1:	55                   	push   %ebp
  8037d2:	89 e5                	mov    %esp,%ebp
  8037d4:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8037d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037db:	75 23                	jne    803800 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8037dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037e1:	74 13                	je     8037f6 <realloc_block_FF+0x25>
  8037e3:	83 ec 0c             	sub    $0xc,%esp
  8037e6:	ff 75 0c             	pushl  0xc(%ebp)
  8037e9:	e8 1f f0 ff ff       	call   80280d <alloc_block_FF>
  8037ee:	83 c4 10             	add    $0x10,%esp
  8037f1:	e9 f4 06 00 00       	jmp    803eea <realloc_block_FF+0x719>
		return NULL;
  8037f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8037fb:	e9 ea 06 00 00       	jmp    803eea <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803800:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803804:	75 18                	jne    80381e <realloc_block_FF+0x4d>
	{
		free_block(va);
  803806:	83 ec 0c             	sub    $0xc,%esp
  803809:	ff 75 08             	pushl  0x8(%ebp)
  80380c:	e8 c0 fe ff ff       	call   8036d1 <free_block>
  803811:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803814:	b8 00 00 00 00       	mov    $0x0,%eax
  803819:	e9 cc 06 00 00       	jmp    803eea <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80381e:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803822:	77 07                	ja     80382b <realloc_block_FF+0x5a>
  803824:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80382b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80382e:	83 e0 01             	and    $0x1,%eax
  803831:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803834:	8b 45 0c             	mov    0xc(%ebp),%eax
  803837:	83 c0 08             	add    $0x8,%eax
  80383a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80383d:	83 ec 0c             	sub    $0xc,%esp
  803840:	ff 75 08             	pushl  0x8(%ebp)
  803843:	e8 45 ec ff ff       	call   80248d <get_block_size>
  803848:	83 c4 10             	add    $0x10,%esp
  80384b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80384e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803851:	83 e8 08             	sub    $0x8,%eax
  803854:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803857:	8b 45 08             	mov    0x8(%ebp),%eax
  80385a:	83 e8 04             	sub    $0x4,%eax
  80385d:	8b 00                	mov    (%eax),%eax
  80385f:	83 e0 fe             	and    $0xfffffffe,%eax
  803862:	89 c2                	mov    %eax,%edx
  803864:	8b 45 08             	mov    0x8(%ebp),%eax
  803867:	01 d0                	add    %edx,%eax
  803869:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80386c:	83 ec 0c             	sub    $0xc,%esp
  80386f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803872:	e8 16 ec ff ff       	call   80248d <get_block_size>
  803877:	83 c4 10             	add    $0x10,%esp
  80387a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80387d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803880:	83 e8 08             	sub    $0x8,%eax
  803883:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803886:	8b 45 0c             	mov    0xc(%ebp),%eax
  803889:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80388c:	75 08                	jne    803896 <realloc_block_FF+0xc5>
	{
		 return va;
  80388e:	8b 45 08             	mov    0x8(%ebp),%eax
  803891:	e9 54 06 00 00       	jmp    803eea <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803896:	8b 45 0c             	mov    0xc(%ebp),%eax
  803899:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80389c:	0f 83 e5 03 00 00    	jae    803c87 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8038a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a5:	2b 45 0c             	sub    0xc(%ebp),%eax
  8038a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8038ab:	83 ec 0c             	sub    $0xc,%esp
  8038ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038b1:	e8 f0 eb ff ff       	call   8024a6 <is_free_block>
  8038b6:	83 c4 10             	add    $0x10,%esp
  8038b9:	84 c0                	test   %al,%al
  8038bb:	0f 84 3b 01 00 00    	je     8039fc <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8038c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038c7:	01 d0                	add    %edx,%eax
  8038c9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8038cc:	83 ec 04             	sub    $0x4,%esp
  8038cf:	6a 01                	push   $0x1
  8038d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8038d4:	ff 75 08             	pushl  0x8(%ebp)
  8038d7:	e8 02 ef ff ff       	call   8027de <set_block_data>
  8038dc:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8038df:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e2:	83 e8 04             	sub    $0x4,%eax
  8038e5:	8b 00                	mov    (%eax),%eax
  8038e7:	83 e0 fe             	and    $0xfffffffe,%eax
  8038ea:	89 c2                	mov    %eax,%edx
  8038ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ef:	01 d0                	add    %edx,%eax
  8038f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8038f4:	83 ec 04             	sub    $0x4,%esp
  8038f7:	6a 00                	push   $0x0
  8038f9:	ff 75 cc             	pushl  -0x34(%ebp)
  8038fc:	ff 75 c8             	pushl  -0x38(%ebp)
  8038ff:	e8 da ee ff ff       	call   8027de <set_block_data>
  803904:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803907:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80390b:	74 06                	je     803913 <realloc_block_FF+0x142>
  80390d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803911:	75 17                	jne    80392a <realloc_block_FF+0x159>
  803913:	83 ec 04             	sub    $0x4,%esp
  803916:	68 0c 4b 80 00       	push   $0x804b0c
  80391b:	68 f6 01 00 00       	push   $0x1f6
  803920:	68 99 4a 80 00       	push   $0x804a99
  803925:	e8 13 ce ff ff       	call   80073d <_panic>
  80392a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392d:	8b 10                	mov    (%eax),%edx
  80392f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803932:	89 10                	mov    %edx,(%eax)
  803934:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803937:	8b 00                	mov    (%eax),%eax
  803939:	85 c0                	test   %eax,%eax
  80393b:	74 0b                	je     803948 <realloc_block_FF+0x177>
  80393d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803940:	8b 00                	mov    (%eax),%eax
  803942:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803945:	89 50 04             	mov    %edx,0x4(%eax)
  803948:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80394e:	89 10                	mov    %edx,(%eax)
  803950:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803953:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803956:	89 50 04             	mov    %edx,0x4(%eax)
  803959:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80395c:	8b 00                	mov    (%eax),%eax
  80395e:	85 c0                	test   %eax,%eax
  803960:	75 08                	jne    80396a <realloc_block_FF+0x199>
  803962:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803965:	a3 34 50 80 00       	mov    %eax,0x805034
  80396a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80396f:	40                   	inc    %eax
  803970:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803975:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803979:	75 17                	jne    803992 <realloc_block_FF+0x1c1>
  80397b:	83 ec 04             	sub    $0x4,%esp
  80397e:	68 7b 4a 80 00       	push   $0x804a7b
  803983:	68 f7 01 00 00       	push   $0x1f7
  803988:	68 99 4a 80 00       	push   $0x804a99
  80398d:	e8 ab cd ff ff       	call   80073d <_panic>
  803992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803995:	8b 00                	mov    (%eax),%eax
  803997:	85 c0                	test   %eax,%eax
  803999:	74 10                	je     8039ab <realloc_block_FF+0x1da>
  80399b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399e:	8b 00                	mov    (%eax),%eax
  8039a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039a3:	8b 52 04             	mov    0x4(%edx),%edx
  8039a6:	89 50 04             	mov    %edx,0x4(%eax)
  8039a9:	eb 0b                	jmp    8039b6 <realloc_block_FF+0x1e5>
  8039ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ae:	8b 40 04             	mov    0x4(%eax),%eax
  8039b1:	a3 34 50 80 00       	mov    %eax,0x805034
  8039b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b9:	8b 40 04             	mov    0x4(%eax),%eax
  8039bc:	85 c0                	test   %eax,%eax
  8039be:	74 0f                	je     8039cf <realloc_block_FF+0x1fe>
  8039c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c3:	8b 40 04             	mov    0x4(%eax),%eax
  8039c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039c9:	8b 12                	mov    (%edx),%edx
  8039cb:	89 10                	mov    %edx,(%eax)
  8039cd:	eb 0a                	jmp    8039d9 <realloc_block_FF+0x208>
  8039cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d2:	8b 00                	mov    (%eax),%eax
  8039d4:	a3 30 50 80 00       	mov    %eax,0x805030
  8039d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ec:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039f1:	48                   	dec    %eax
  8039f2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8039f7:	e9 83 02 00 00       	jmp    803c7f <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8039fc:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803a00:	0f 86 69 02 00 00    	jbe    803c6f <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803a06:	83 ec 04             	sub    $0x4,%esp
  803a09:	6a 01                	push   $0x1
  803a0b:	ff 75 f0             	pushl  -0x10(%ebp)
  803a0e:	ff 75 08             	pushl  0x8(%ebp)
  803a11:	e8 c8 ed ff ff       	call   8027de <set_block_data>
  803a16:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a19:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1c:	83 e8 04             	sub    $0x4,%eax
  803a1f:	8b 00                	mov    (%eax),%eax
  803a21:	83 e0 fe             	and    $0xfffffffe,%eax
  803a24:	89 c2                	mov    %eax,%edx
  803a26:	8b 45 08             	mov    0x8(%ebp),%eax
  803a29:	01 d0                	add    %edx,%eax
  803a2b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803a2e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a33:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803a36:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803a3a:	75 68                	jne    803aa4 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803a3c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803a40:	75 17                	jne    803a59 <realloc_block_FF+0x288>
  803a42:	83 ec 04             	sub    $0x4,%esp
  803a45:	68 b4 4a 80 00       	push   $0x804ab4
  803a4a:	68 06 02 00 00       	push   $0x206
  803a4f:	68 99 4a 80 00       	push   $0x804a99
  803a54:	e8 e4 cc ff ff       	call   80073d <_panic>
  803a59:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803a5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a62:	89 10                	mov    %edx,(%eax)
  803a64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a67:	8b 00                	mov    (%eax),%eax
  803a69:	85 c0                	test   %eax,%eax
  803a6b:	74 0d                	je     803a7a <realloc_block_FF+0x2a9>
  803a6d:	a1 30 50 80 00       	mov    0x805030,%eax
  803a72:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803a75:	89 50 04             	mov    %edx,0x4(%eax)
  803a78:	eb 08                	jmp    803a82 <realloc_block_FF+0x2b1>
  803a7a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a7d:	a3 34 50 80 00       	mov    %eax,0x805034
  803a82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a85:	a3 30 50 80 00       	mov    %eax,0x805030
  803a8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a94:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a99:	40                   	inc    %eax
  803a9a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a9f:	e9 b0 01 00 00       	jmp    803c54 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803aa4:	a1 30 50 80 00       	mov    0x805030,%eax
  803aa9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803aac:	76 68                	jbe    803b16 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803aae:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ab2:	75 17                	jne    803acb <realloc_block_FF+0x2fa>
  803ab4:	83 ec 04             	sub    $0x4,%esp
  803ab7:	68 b4 4a 80 00       	push   $0x804ab4
  803abc:	68 0b 02 00 00       	push   $0x20b
  803ac1:	68 99 4a 80 00       	push   $0x804a99
  803ac6:	e8 72 cc ff ff       	call   80073d <_panic>
  803acb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803ad1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ad4:	89 10                	mov    %edx,(%eax)
  803ad6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ad9:	8b 00                	mov    (%eax),%eax
  803adb:	85 c0                	test   %eax,%eax
  803add:	74 0d                	je     803aec <realloc_block_FF+0x31b>
  803adf:	a1 30 50 80 00       	mov    0x805030,%eax
  803ae4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ae7:	89 50 04             	mov    %edx,0x4(%eax)
  803aea:	eb 08                	jmp    803af4 <realloc_block_FF+0x323>
  803aec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aef:	a3 34 50 80 00       	mov    %eax,0x805034
  803af4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803af7:	a3 30 50 80 00       	mov    %eax,0x805030
  803afc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803aff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b06:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b0b:	40                   	inc    %eax
  803b0c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b11:	e9 3e 01 00 00       	jmp    803c54 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803b16:	a1 30 50 80 00       	mov    0x805030,%eax
  803b1b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b1e:	73 68                	jae    803b88 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b20:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b24:	75 17                	jne    803b3d <realloc_block_FF+0x36c>
  803b26:	83 ec 04             	sub    $0x4,%esp
  803b29:	68 e8 4a 80 00       	push   $0x804ae8
  803b2e:	68 10 02 00 00       	push   $0x210
  803b33:	68 99 4a 80 00       	push   $0x804a99
  803b38:	e8 00 cc ff ff       	call   80073d <_panic>
  803b3d:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803b43:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b46:	89 50 04             	mov    %edx,0x4(%eax)
  803b49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b4c:	8b 40 04             	mov    0x4(%eax),%eax
  803b4f:	85 c0                	test   %eax,%eax
  803b51:	74 0c                	je     803b5f <realloc_block_FF+0x38e>
  803b53:	a1 34 50 80 00       	mov    0x805034,%eax
  803b58:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b5b:	89 10                	mov    %edx,(%eax)
  803b5d:	eb 08                	jmp    803b67 <realloc_block_FF+0x396>
  803b5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b62:	a3 30 50 80 00       	mov    %eax,0x805030
  803b67:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b6a:	a3 34 50 80 00       	mov    %eax,0x805034
  803b6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b78:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b7d:	40                   	inc    %eax
  803b7e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b83:	e9 cc 00 00 00       	jmp    803c54 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803b88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803b8f:	a1 30 50 80 00       	mov    0x805030,%eax
  803b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b97:	e9 8a 00 00 00       	jmp    803c26 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ba2:	73 7a                	jae    803c1e <realloc_block_FF+0x44d>
  803ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba7:	8b 00                	mov    (%eax),%eax
  803ba9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bac:	73 70                	jae    803c1e <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803bae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bb2:	74 06                	je     803bba <realloc_block_FF+0x3e9>
  803bb4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bb8:	75 17                	jne    803bd1 <realloc_block_FF+0x400>
  803bba:	83 ec 04             	sub    $0x4,%esp
  803bbd:	68 0c 4b 80 00       	push   $0x804b0c
  803bc2:	68 1a 02 00 00       	push   $0x21a
  803bc7:	68 99 4a 80 00       	push   $0x804a99
  803bcc:	e8 6c cb ff ff       	call   80073d <_panic>
  803bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd4:	8b 10                	mov    (%eax),%edx
  803bd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bd9:	89 10                	mov    %edx,(%eax)
  803bdb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bde:	8b 00                	mov    (%eax),%eax
  803be0:	85 c0                	test   %eax,%eax
  803be2:	74 0b                	je     803bef <realloc_block_FF+0x41e>
  803be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be7:	8b 00                	mov    (%eax),%eax
  803be9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bec:	89 50 04             	mov    %edx,0x4(%eax)
  803bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bf5:	89 10                	mov    %edx,(%eax)
  803bf7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bfd:	89 50 04             	mov    %edx,0x4(%eax)
  803c00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c03:	8b 00                	mov    (%eax),%eax
  803c05:	85 c0                	test   %eax,%eax
  803c07:	75 08                	jne    803c11 <realloc_block_FF+0x440>
  803c09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c0c:	a3 34 50 80 00       	mov    %eax,0x805034
  803c11:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c16:	40                   	inc    %eax
  803c17:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803c1c:	eb 36                	jmp    803c54 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803c1e:	a1 38 50 80 00       	mov    0x805038,%eax
  803c23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c2a:	74 07                	je     803c33 <realloc_block_FF+0x462>
  803c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2f:	8b 00                	mov    (%eax),%eax
  803c31:	eb 05                	jmp    803c38 <realloc_block_FF+0x467>
  803c33:	b8 00 00 00 00       	mov    $0x0,%eax
  803c38:	a3 38 50 80 00       	mov    %eax,0x805038
  803c3d:	a1 38 50 80 00       	mov    0x805038,%eax
  803c42:	85 c0                	test   %eax,%eax
  803c44:	0f 85 52 ff ff ff    	jne    803b9c <realloc_block_FF+0x3cb>
  803c4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c4e:	0f 85 48 ff ff ff    	jne    803b9c <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803c54:	83 ec 04             	sub    $0x4,%esp
  803c57:	6a 00                	push   $0x0
  803c59:	ff 75 d8             	pushl  -0x28(%ebp)
  803c5c:	ff 75 d4             	pushl  -0x2c(%ebp)
  803c5f:	e8 7a eb ff ff       	call   8027de <set_block_data>
  803c64:	83 c4 10             	add    $0x10,%esp
				return va;
  803c67:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6a:	e9 7b 02 00 00       	jmp    803eea <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803c6f:	83 ec 0c             	sub    $0xc,%esp
  803c72:	68 89 4b 80 00       	push   $0x804b89
  803c77:	e8 7e cd ff ff       	call   8009fa <cprintf>
  803c7c:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c82:	e9 63 02 00 00       	jmp    803eea <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c8a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803c8d:	0f 86 4d 02 00 00    	jbe    803ee0 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803c93:	83 ec 0c             	sub    $0xc,%esp
  803c96:	ff 75 e4             	pushl  -0x1c(%ebp)
  803c99:	e8 08 e8 ff ff       	call   8024a6 <is_free_block>
  803c9e:	83 c4 10             	add    $0x10,%esp
  803ca1:	84 c0                	test   %al,%al
  803ca3:	0f 84 37 02 00 00    	je     803ee0 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cac:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803caf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803cb2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803cb5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803cb8:	76 38                	jbe    803cf2 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803cba:	83 ec 0c             	sub    $0xc,%esp
  803cbd:	ff 75 08             	pushl  0x8(%ebp)
  803cc0:	e8 0c fa ff ff       	call   8036d1 <free_block>
  803cc5:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803cc8:	83 ec 0c             	sub    $0xc,%esp
  803ccb:	ff 75 0c             	pushl  0xc(%ebp)
  803cce:	e8 3a eb ff ff       	call   80280d <alloc_block_FF>
  803cd3:	83 c4 10             	add    $0x10,%esp
  803cd6:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803cd9:	83 ec 08             	sub    $0x8,%esp
  803cdc:	ff 75 c0             	pushl  -0x40(%ebp)
  803cdf:	ff 75 08             	pushl  0x8(%ebp)
  803ce2:	e8 ab fa ff ff       	call   803792 <copy_data>
  803ce7:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803cea:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803ced:	e9 f8 01 00 00       	jmp    803eea <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803cf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cf5:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803cf8:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803cfb:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803cff:	0f 87 a0 00 00 00    	ja     803da5 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803d05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d09:	75 17                	jne    803d22 <realloc_block_FF+0x551>
  803d0b:	83 ec 04             	sub    $0x4,%esp
  803d0e:	68 7b 4a 80 00       	push   $0x804a7b
  803d13:	68 38 02 00 00       	push   $0x238
  803d18:	68 99 4a 80 00       	push   $0x804a99
  803d1d:	e8 1b ca ff ff       	call   80073d <_panic>
  803d22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d25:	8b 00                	mov    (%eax),%eax
  803d27:	85 c0                	test   %eax,%eax
  803d29:	74 10                	je     803d3b <realloc_block_FF+0x56a>
  803d2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2e:	8b 00                	mov    (%eax),%eax
  803d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d33:	8b 52 04             	mov    0x4(%edx),%edx
  803d36:	89 50 04             	mov    %edx,0x4(%eax)
  803d39:	eb 0b                	jmp    803d46 <realloc_block_FF+0x575>
  803d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3e:	8b 40 04             	mov    0x4(%eax),%eax
  803d41:	a3 34 50 80 00       	mov    %eax,0x805034
  803d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d49:	8b 40 04             	mov    0x4(%eax),%eax
  803d4c:	85 c0                	test   %eax,%eax
  803d4e:	74 0f                	je     803d5f <realloc_block_FF+0x58e>
  803d50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d53:	8b 40 04             	mov    0x4(%eax),%eax
  803d56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d59:	8b 12                	mov    (%edx),%edx
  803d5b:	89 10                	mov    %edx,(%eax)
  803d5d:	eb 0a                	jmp    803d69 <realloc_block_FF+0x598>
  803d5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d62:	8b 00                	mov    (%eax),%eax
  803d64:	a3 30 50 80 00       	mov    %eax,0x805030
  803d69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d7c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d81:	48                   	dec    %eax
  803d82:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803d87:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d8d:	01 d0                	add    %edx,%eax
  803d8f:	83 ec 04             	sub    $0x4,%esp
  803d92:	6a 01                	push   $0x1
  803d94:	50                   	push   %eax
  803d95:	ff 75 08             	pushl  0x8(%ebp)
  803d98:	e8 41 ea ff ff       	call   8027de <set_block_data>
  803d9d:	83 c4 10             	add    $0x10,%esp
  803da0:	e9 36 01 00 00       	jmp    803edb <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803da5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803da8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803dab:	01 d0                	add    %edx,%eax
  803dad:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803db0:	83 ec 04             	sub    $0x4,%esp
  803db3:	6a 01                	push   $0x1
  803db5:	ff 75 f0             	pushl  -0x10(%ebp)
  803db8:	ff 75 08             	pushl  0x8(%ebp)
  803dbb:	e8 1e ea ff ff       	call   8027de <set_block_data>
  803dc0:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc6:	83 e8 04             	sub    $0x4,%eax
  803dc9:	8b 00                	mov    (%eax),%eax
  803dcb:	83 e0 fe             	and    $0xfffffffe,%eax
  803dce:	89 c2                	mov    %eax,%edx
  803dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd3:	01 d0                	add    %edx,%eax
  803dd5:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803dd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ddc:	74 06                	je     803de4 <realloc_block_FF+0x613>
  803dde:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803de2:	75 17                	jne    803dfb <realloc_block_FF+0x62a>
  803de4:	83 ec 04             	sub    $0x4,%esp
  803de7:	68 0c 4b 80 00       	push   $0x804b0c
  803dec:	68 44 02 00 00       	push   $0x244
  803df1:	68 99 4a 80 00       	push   $0x804a99
  803df6:	e8 42 c9 ff ff       	call   80073d <_panic>
  803dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dfe:	8b 10                	mov    (%eax),%edx
  803e00:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e03:	89 10                	mov    %edx,(%eax)
  803e05:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e08:	8b 00                	mov    (%eax),%eax
  803e0a:	85 c0                	test   %eax,%eax
  803e0c:	74 0b                	je     803e19 <realloc_block_FF+0x648>
  803e0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e11:	8b 00                	mov    (%eax),%eax
  803e13:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e16:	89 50 04             	mov    %edx,0x4(%eax)
  803e19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e1c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803e1f:	89 10                	mov    %edx,(%eax)
  803e21:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e27:	89 50 04             	mov    %edx,0x4(%eax)
  803e2a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e2d:	8b 00                	mov    (%eax),%eax
  803e2f:	85 c0                	test   %eax,%eax
  803e31:	75 08                	jne    803e3b <realloc_block_FF+0x66a>
  803e33:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e36:	a3 34 50 80 00       	mov    %eax,0x805034
  803e3b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e40:	40                   	inc    %eax
  803e41:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803e46:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e4a:	75 17                	jne    803e63 <realloc_block_FF+0x692>
  803e4c:	83 ec 04             	sub    $0x4,%esp
  803e4f:	68 7b 4a 80 00       	push   $0x804a7b
  803e54:	68 45 02 00 00       	push   $0x245
  803e59:	68 99 4a 80 00       	push   $0x804a99
  803e5e:	e8 da c8 ff ff       	call   80073d <_panic>
  803e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e66:	8b 00                	mov    (%eax),%eax
  803e68:	85 c0                	test   %eax,%eax
  803e6a:	74 10                	je     803e7c <realloc_block_FF+0x6ab>
  803e6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e6f:	8b 00                	mov    (%eax),%eax
  803e71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e74:	8b 52 04             	mov    0x4(%edx),%edx
  803e77:	89 50 04             	mov    %edx,0x4(%eax)
  803e7a:	eb 0b                	jmp    803e87 <realloc_block_FF+0x6b6>
  803e7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e7f:	8b 40 04             	mov    0x4(%eax),%eax
  803e82:	a3 34 50 80 00       	mov    %eax,0x805034
  803e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e8a:	8b 40 04             	mov    0x4(%eax),%eax
  803e8d:	85 c0                	test   %eax,%eax
  803e8f:	74 0f                	je     803ea0 <realloc_block_FF+0x6cf>
  803e91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e94:	8b 40 04             	mov    0x4(%eax),%eax
  803e97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e9a:	8b 12                	mov    (%edx),%edx
  803e9c:	89 10                	mov    %edx,(%eax)
  803e9e:	eb 0a                	jmp    803eaa <realloc_block_FF+0x6d9>
  803ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea3:	8b 00                	mov    (%eax),%eax
  803ea5:	a3 30 50 80 00       	mov    %eax,0x805030
  803eaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ead:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ebd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ec2:	48                   	dec    %eax
  803ec3:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803ec8:	83 ec 04             	sub    $0x4,%esp
  803ecb:	6a 00                	push   $0x0
  803ecd:	ff 75 bc             	pushl  -0x44(%ebp)
  803ed0:	ff 75 b8             	pushl  -0x48(%ebp)
  803ed3:	e8 06 e9 ff ff       	call   8027de <set_block_data>
  803ed8:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803edb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ede:	eb 0a                	jmp    803eea <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803ee0:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803ee7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803eea:	c9                   	leave  
  803eeb:	c3                   	ret    

00803eec <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803eec:	55                   	push   %ebp
  803eed:	89 e5                	mov    %esp,%ebp
  803eef:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803ef2:	83 ec 04             	sub    $0x4,%esp
  803ef5:	68 90 4b 80 00       	push   $0x804b90
  803efa:	68 58 02 00 00       	push   $0x258
  803eff:	68 99 4a 80 00       	push   $0x804a99
  803f04:	e8 34 c8 ff ff       	call   80073d <_panic>

00803f09 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803f09:	55                   	push   %ebp
  803f0a:	89 e5                	mov    %esp,%ebp
  803f0c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803f0f:	83 ec 04             	sub    $0x4,%esp
  803f12:	68 b8 4b 80 00       	push   $0x804bb8
  803f17:	68 61 02 00 00       	push   $0x261
  803f1c:	68 99 4a 80 00       	push   $0x804a99
  803f21:	e8 17 c8 ff ff       	call   80073d <_panic>
  803f26:	66 90                	xchg   %ax,%ax

00803f28 <__udivdi3>:
  803f28:	55                   	push   %ebp
  803f29:	57                   	push   %edi
  803f2a:	56                   	push   %esi
  803f2b:	53                   	push   %ebx
  803f2c:	83 ec 1c             	sub    $0x1c,%esp
  803f2f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f33:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f3f:	89 ca                	mov    %ecx,%edx
  803f41:	89 f8                	mov    %edi,%eax
  803f43:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f47:	85 f6                	test   %esi,%esi
  803f49:	75 2d                	jne    803f78 <__udivdi3+0x50>
  803f4b:	39 cf                	cmp    %ecx,%edi
  803f4d:	77 65                	ja     803fb4 <__udivdi3+0x8c>
  803f4f:	89 fd                	mov    %edi,%ebp
  803f51:	85 ff                	test   %edi,%edi
  803f53:	75 0b                	jne    803f60 <__udivdi3+0x38>
  803f55:	b8 01 00 00 00       	mov    $0x1,%eax
  803f5a:	31 d2                	xor    %edx,%edx
  803f5c:	f7 f7                	div    %edi
  803f5e:	89 c5                	mov    %eax,%ebp
  803f60:	31 d2                	xor    %edx,%edx
  803f62:	89 c8                	mov    %ecx,%eax
  803f64:	f7 f5                	div    %ebp
  803f66:	89 c1                	mov    %eax,%ecx
  803f68:	89 d8                	mov    %ebx,%eax
  803f6a:	f7 f5                	div    %ebp
  803f6c:	89 cf                	mov    %ecx,%edi
  803f6e:	89 fa                	mov    %edi,%edx
  803f70:	83 c4 1c             	add    $0x1c,%esp
  803f73:	5b                   	pop    %ebx
  803f74:	5e                   	pop    %esi
  803f75:	5f                   	pop    %edi
  803f76:	5d                   	pop    %ebp
  803f77:	c3                   	ret    
  803f78:	39 ce                	cmp    %ecx,%esi
  803f7a:	77 28                	ja     803fa4 <__udivdi3+0x7c>
  803f7c:	0f bd fe             	bsr    %esi,%edi
  803f7f:	83 f7 1f             	xor    $0x1f,%edi
  803f82:	75 40                	jne    803fc4 <__udivdi3+0x9c>
  803f84:	39 ce                	cmp    %ecx,%esi
  803f86:	72 0a                	jb     803f92 <__udivdi3+0x6a>
  803f88:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f8c:	0f 87 9e 00 00 00    	ja     804030 <__udivdi3+0x108>
  803f92:	b8 01 00 00 00       	mov    $0x1,%eax
  803f97:	89 fa                	mov    %edi,%edx
  803f99:	83 c4 1c             	add    $0x1c,%esp
  803f9c:	5b                   	pop    %ebx
  803f9d:	5e                   	pop    %esi
  803f9e:	5f                   	pop    %edi
  803f9f:	5d                   	pop    %ebp
  803fa0:	c3                   	ret    
  803fa1:	8d 76 00             	lea    0x0(%esi),%esi
  803fa4:	31 ff                	xor    %edi,%edi
  803fa6:	31 c0                	xor    %eax,%eax
  803fa8:	89 fa                	mov    %edi,%edx
  803faa:	83 c4 1c             	add    $0x1c,%esp
  803fad:	5b                   	pop    %ebx
  803fae:	5e                   	pop    %esi
  803faf:	5f                   	pop    %edi
  803fb0:	5d                   	pop    %ebp
  803fb1:	c3                   	ret    
  803fb2:	66 90                	xchg   %ax,%ax
  803fb4:	89 d8                	mov    %ebx,%eax
  803fb6:	f7 f7                	div    %edi
  803fb8:	31 ff                	xor    %edi,%edi
  803fba:	89 fa                	mov    %edi,%edx
  803fbc:	83 c4 1c             	add    $0x1c,%esp
  803fbf:	5b                   	pop    %ebx
  803fc0:	5e                   	pop    %esi
  803fc1:	5f                   	pop    %edi
  803fc2:	5d                   	pop    %ebp
  803fc3:	c3                   	ret    
  803fc4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803fc9:	89 eb                	mov    %ebp,%ebx
  803fcb:	29 fb                	sub    %edi,%ebx
  803fcd:	89 f9                	mov    %edi,%ecx
  803fcf:	d3 e6                	shl    %cl,%esi
  803fd1:	89 c5                	mov    %eax,%ebp
  803fd3:	88 d9                	mov    %bl,%cl
  803fd5:	d3 ed                	shr    %cl,%ebp
  803fd7:	89 e9                	mov    %ebp,%ecx
  803fd9:	09 f1                	or     %esi,%ecx
  803fdb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803fdf:	89 f9                	mov    %edi,%ecx
  803fe1:	d3 e0                	shl    %cl,%eax
  803fe3:	89 c5                	mov    %eax,%ebp
  803fe5:	89 d6                	mov    %edx,%esi
  803fe7:	88 d9                	mov    %bl,%cl
  803fe9:	d3 ee                	shr    %cl,%esi
  803feb:	89 f9                	mov    %edi,%ecx
  803fed:	d3 e2                	shl    %cl,%edx
  803fef:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ff3:	88 d9                	mov    %bl,%cl
  803ff5:	d3 e8                	shr    %cl,%eax
  803ff7:	09 c2                	or     %eax,%edx
  803ff9:	89 d0                	mov    %edx,%eax
  803ffb:	89 f2                	mov    %esi,%edx
  803ffd:	f7 74 24 0c          	divl   0xc(%esp)
  804001:	89 d6                	mov    %edx,%esi
  804003:	89 c3                	mov    %eax,%ebx
  804005:	f7 e5                	mul    %ebp
  804007:	39 d6                	cmp    %edx,%esi
  804009:	72 19                	jb     804024 <__udivdi3+0xfc>
  80400b:	74 0b                	je     804018 <__udivdi3+0xf0>
  80400d:	89 d8                	mov    %ebx,%eax
  80400f:	31 ff                	xor    %edi,%edi
  804011:	e9 58 ff ff ff       	jmp    803f6e <__udivdi3+0x46>
  804016:	66 90                	xchg   %ax,%ax
  804018:	8b 54 24 08          	mov    0x8(%esp),%edx
  80401c:	89 f9                	mov    %edi,%ecx
  80401e:	d3 e2                	shl    %cl,%edx
  804020:	39 c2                	cmp    %eax,%edx
  804022:	73 e9                	jae    80400d <__udivdi3+0xe5>
  804024:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804027:	31 ff                	xor    %edi,%edi
  804029:	e9 40 ff ff ff       	jmp    803f6e <__udivdi3+0x46>
  80402e:	66 90                	xchg   %ax,%ax
  804030:	31 c0                	xor    %eax,%eax
  804032:	e9 37 ff ff ff       	jmp    803f6e <__udivdi3+0x46>
  804037:	90                   	nop

00804038 <__umoddi3>:
  804038:	55                   	push   %ebp
  804039:	57                   	push   %edi
  80403a:	56                   	push   %esi
  80403b:	53                   	push   %ebx
  80403c:	83 ec 1c             	sub    $0x1c,%esp
  80403f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804043:	8b 74 24 34          	mov    0x34(%esp),%esi
  804047:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80404b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80404f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804053:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804057:	89 f3                	mov    %esi,%ebx
  804059:	89 fa                	mov    %edi,%edx
  80405b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80405f:	89 34 24             	mov    %esi,(%esp)
  804062:	85 c0                	test   %eax,%eax
  804064:	75 1a                	jne    804080 <__umoddi3+0x48>
  804066:	39 f7                	cmp    %esi,%edi
  804068:	0f 86 a2 00 00 00    	jbe    804110 <__umoddi3+0xd8>
  80406e:	89 c8                	mov    %ecx,%eax
  804070:	89 f2                	mov    %esi,%edx
  804072:	f7 f7                	div    %edi
  804074:	89 d0                	mov    %edx,%eax
  804076:	31 d2                	xor    %edx,%edx
  804078:	83 c4 1c             	add    $0x1c,%esp
  80407b:	5b                   	pop    %ebx
  80407c:	5e                   	pop    %esi
  80407d:	5f                   	pop    %edi
  80407e:	5d                   	pop    %ebp
  80407f:	c3                   	ret    
  804080:	39 f0                	cmp    %esi,%eax
  804082:	0f 87 ac 00 00 00    	ja     804134 <__umoddi3+0xfc>
  804088:	0f bd e8             	bsr    %eax,%ebp
  80408b:	83 f5 1f             	xor    $0x1f,%ebp
  80408e:	0f 84 ac 00 00 00    	je     804140 <__umoddi3+0x108>
  804094:	bf 20 00 00 00       	mov    $0x20,%edi
  804099:	29 ef                	sub    %ebp,%edi
  80409b:	89 fe                	mov    %edi,%esi
  80409d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040a1:	89 e9                	mov    %ebp,%ecx
  8040a3:	d3 e0                	shl    %cl,%eax
  8040a5:	89 d7                	mov    %edx,%edi
  8040a7:	89 f1                	mov    %esi,%ecx
  8040a9:	d3 ef                	shr    %cl,%edi
  8040ab:	09 c7                	or     %eax,%edi
  8040ad:	89 e9                	mov    %ebp,%ecx
  8040af:	d3 e2                	shl    %cl,%edx
  8040b1:	89 14 24             	mov    %edx,(%esp)
  8040b4:	89 d8                	mov    %ebx,%eax
  8040b6:	d3 e0                	shl    %cl,%eax
  8040b8:	89 c2                	mov    %eax,%edx
  8040ba:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040be:	d3 e0                	shl    %cl,%eax
  8040c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040c4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040c8:	89 f1                	mov    %esi,%ecx
  8040ca:	d3 e8                	shr    %cl,%eax
  8040cc:	09 d0                	or     %edx,%eax
  8040ce:	d3 eb                	shr    %cl,%ebx
  8040d0:	89 da                	mov    %ebx,%edx
  8040d2:	f7 f7                	div    %edi
  8040d4:	89 d3                	mov    %edx,%ebx
  8040d6:	f7 24 24             	mull   (%esp)
  8040d9:	89 c6                	mov    %eax,%esi
  8040db:	89 d1                	mov    %edx,%ecx
  8040dd:	39 d3                	cmp    %edx,%ebx
  8040df:	0f 82 87 00 00 00    	jb     80416c <__umoddi3+0x134>
  8040e5:	0f 84 91 00 00 00    	je     80417c <__umoddi3+0x144>
  8040eb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8040ef:	29 f2                	sub    %esi,%edx
  8040f1:	19 cb                	sbb    %ecx,%ebx
  8040f3:	89 d8                	mov    %ebx,%eax
  8040f5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8040f9:	d3 e0                	shl    %cl,%eax
  8040fb:	89 e9                	mov    %ebp,%ecx
  8040fd:	d3 ea                	shr    %cl,%edx
  8040ff:	09 d0                	or     %edx,%eax
  804101:	89 e9                	mov    %ebp,%ecx
  804103:	d3 eb                	shr    %cl,%ebx
  804105:	89 da                	mov    %ebx,%edx
  804107:	83 c4 1c             	add    $0x1c,%esp
  80410a:	5b                   	pop    %ebx
  80410b:	5e                   	pop    %esi
  80410c:	5f                   	pop    %edi
  80410d:	5d                   	pop    %ebp
  80410e:	c3                   	ret    
  80410f:	90                   	nop
  804110:	89 fd                	mov    %edi,%ebp
  804112:	85 ff                	test   %edi,%edi
  804114:	75 0b                	jne    804121 <__umoddi3+0xe9>
  804116:	b8 01 00 00 00       	mov    $0x1,%eax
  80411b:	31 d2                	xor    %edx,%edx
  80411d:	f7 f7                	div    %edi
  80411f:	89 c5                	mov    %eax,%ebp
  804121:	89 f0                	mov    %esi,%eax
  804123:	31 d2                	xor    %edx,%edx
  804125:	f7 f5                	div    %ebp
  804127:	89 c8                	mov    %ecx,%eax
  804129:	f7 f5                	div    %ebp
  80412b:	89 d0                	mov    %edx,%eax
  80412d:	e9 44 ff ff ff       	jmp    804076 <__umoddi3+0x3e>
  804132:	66 90                	xchg   %ax,%ax
  804134:	89 c8                	mov    %ecx,%eax
  804136:	89 f2                	mov    %esi,%edx
  804138:	83 c4 1c             	add    $0x1c,%esp
  80413b:	5b                   	pop    %ebx
  80413c:	5e                   	pop    %esi
  80413d:	5f                   	pop    %edi
  80413e:	5d                   	pop    %ebp
  80413f:	c3                   	ret    
  804140:	3b 04 24             	cmp    (%esp),%eax
  804143:	72 06                	jb     80414b <__umoddi3+0x113>
  804145:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804149:	77 0f                	ja     80415a <__umoddi3+0x122>
  80414b:	89 f2                	mov    %esi,%edx
  80414d:	29 f9                	sub    %edi,%ecx
  80414f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804153:	89 14 24             	mov    %edx,(%esp)
  804156:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80415a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80415e:	8b 14 24             	mov    (%esp),%edx
  804161:	83 c4 1c             	add    $0x1c,%esp
  804164:	5b                   	pop    %ebx
  804165:	5e                   	pop    %esi
  804166:	5f                   	pop    %edi
  804167:	5d                   	pop    %ebp
  804168:	c3                   	ret    
  804169:	8d 76 00             	lea    0x0(%esi),%esi
  80416c:	2b 04 24             	sub    (%esp),%eax
  80416f:	19 fa                	sbb    %edi,%edx
  804171:	89 d1                	mov    %edx,%ecx
  804173:	89 c6                	mov    %eax,%esi
  804175:	e9 71 ff ff ff       	jmp    8040eb <__umoddi3+0xb3>
  80417a:	66 90                	xchg   %ax,%ax
  80417c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804180:	72 ea                	jb     80416c <__umoddi3+0x134>
  804182:	89 d9                	mov    %ebx,%ecx
  804184:	e9 62 ff ff ff       	jmp    8040eb <__umoddi3+0xb3>
