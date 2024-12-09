
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 21 07 00 00       	call   800757 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp

	do
	{
		//2012: lock the interrupt
		//sys_lock_cons();
		sys_lock_cons();
  800041:	e8 4f 20 00 00       	call   802095 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 43 80 00       	push   $0x8043c0
  80004e:	e8 00 0b 00 00       	call   800b53 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 43 80 00       	push   $0x8043c2
  80005e:	e8 f0 0a 00 00       	call   800b53 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 d8 43 80 00       	push   $0x8043d8
  80006e:	e8 e0 0a 00 00       	call   800b53 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 43 80 00       	push   $0x8043c2
  80007e:	e8 d0 0a 00 00       	call   800b53 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 43 80 00       	push   $0x8043c0
  80008e:	e8 c0 0a 00 00       	call   800b53 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 f0 43 80 00       	push   $0x8043f0
  8000a5:	e8 3d 11 00 00       	call   8011e7 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			cprintf("Chose the initialization method:\n") ;
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 10 44 80 00       	push   $0x804410
  8000b5:	e8 99 0a 00 00       	call   800b53 <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 32 44 80 00       	push   $0x804432
  8000c5:	e8 89 0a 00 00       	call   800b53 <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 40 44 80 00       	push   $0x804440
  8000d5:	e8 79 0a 00 00       	call   800b53 <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	68 4f 44 80 00       	push   $0x80444f
  8000e5:	e8 69 0a 00 00       	call   800b53 <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 5f 44 80 00       	push   $0x80445f
  8000f5:	e8 59 0a 00 00       	call   800b53 <cprintf>
  8000fa:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  8000fd:	e8 38 06 00 00       	call   80073a <getchar>
  800102:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800105:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	50                   	push   %eax
  80010d:	e8 09 06 00 00       	call   80071b <cputchar>
  800112:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	6a 0a                	push   $0xa
  80011a:	e8 fc 05 00 00       	call   80071b <cputchar>
  80011f:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800122:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800126:	74 0c                	je     800134 <_main+0xfc>
  800128:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80012c:	74 06                	je     800134 <_main+0xfc>
  80012e:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800132:	75 b9                	jne    8000ed <_main+0xb5>
		}
		sys_unlock_cons();
  800134:	e8 76 1f 00 00       	call   8020af <sys_unlock_cons>
		//sys_unlock_cons();

		NumOfElements = strtol(Line, NULL, 10) ;
  800139:	83 ec 04             	sub    $0x4,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	6a 00                	push   $0x0
  800140:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800146:	50                   	push   %eax
  800147:	e8 03 16 00 00       	call   80174f <strtol>
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 aa 19 00 00       	call   801b0b <malloc>
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
  800183:	e8 ea 01 00 00       	call   800372 <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 08 02 00 00       	call   8003a3 <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 2a 02 00 00       	call   8003d8 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 17 02 00 00       	call   8003d8 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d6 02 00 00       	call   8004aa <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		atomic_cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 68 44 80 00       	push   $0x804468
  8001df:	e8 9c 09 00 00       	call   800b80 <atomic_cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 d3 00 00 00       	call   8002c8 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 9c 44 80 00       	push   $0x80449c
  800209:	6a 4d                	push   $0x4d
  80020b:	68 be 44 80 00       	push   $0x8044be
  800210:	e8 81 06 00 00       	call   800896 <_panic>
		else
		{
			//sys_lock_cons();
			sys_lock_cons();
  800215:	e8 7b 1e 00 00       	call   802095 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 dc 44 80 00       	push   $0x8044dc
  800222:	e8 2c 09 00 00       	call   800b53 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 10 45 80 00       	push   $0x804510
  800232:	e8 1c 09 00 00       	call   800b53 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 44 45 80 00       	push   $0x804544
  800242:	e8 0c 09 00 00       	call   800b53 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  80024a:	e8 60 1e 00 00       	call   8020af <sys_unlock_cons>
			//sys_unlock_cons();
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 d0 1a 00 00       	call   801d2a <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  80025d:	e8 33 1e 00 00       	call   802095 <sys_lock_cons>
		{
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 42                	jmp    8002aa <_main+0x272>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 76 45 80 00       	push   $0x804576
  800270:	e8 de 08 00 00       	call   800b53 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800278:	e8 bd 04 00 00       	call   80073a <getchar>
  80027d:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800280:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800284:	83 ec 0c             	sub    $0xc,%esp
  800287:	50                   	push   %eax
  800288:	e8 8e 04 00 00       	call   80071b <cputchar>
  80028d:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	6a 0a                	push   $0xa
  800295:	e8 81 04 00 00       	call   80071b <cputchar>
  80029a:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	6a 0a                	push   $0xa
  8002a2:	e8 74 04 00 00       	call   80071b <cputchar>
  8002a7:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002aa:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002ae:	74 06                	je     8002b6 <_main+0x27e>
  8002b0:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b4:	75 b2                	jne    800268 <_main+0x230>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b6:	e8 f4 1d 00 00       	call   8020af <sys_unlock_cons>
		//sys_unlock_cons();

	} while (Chose == 'y');
  8002bb:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bf:	0f 84 7c fd ff ff    	je     800041 <_main+0x9>

}
  8002c5:	90                   	nop
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002dc:	eb 33                	jmp    800311 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	8b 10                	mov    (%eax),%edx
  8002ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002f2:	40                   	inc    %eax
  8002f3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fd:	01 c8                	add    %ecx,%eax
  8002ff:	8b 00                	mov    (%eax),%eax
  800301:	39 c2                	cmp    %eax,%edx
  800303:	7e 09                	jle    80030e <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800305:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80030c:	eb 0c                	jmp    80031a <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030e:	ff 45 f8             	incl   -0x8(%ebp)
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	48                   	dec    %eax
  800315:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800318:	7f c4                	jg     8002de <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80031a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800325:	8b 45 0c             	mov    0xc(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
  800346:	01 c2                	add    %eax,%edx
  800348:	8b 45 10             	mov    0x10(%ebp),%eax
  80034b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	01 c8                	add    %ecx,%eax
  800357:	8b 00                	mov    (%eax),%eax
  800359:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80035b:	8b 45 10             	mov    0x10(%ebp),%eax
  80035e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	01 c2                	add    %eax,%edx
  80036a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80036d:	89 02                	mov    %eax,(%edx)
}
  80036f:	90                   	nop
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800378:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037f:	eb 17                	jmp    800398 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800381:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	01 c2                	add    %eax,%edx
  800390:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800393:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800395:	ff 45 fc             	incl   -0x4(%ebp)
  800398:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039e:	7c e1                	jl     800381 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b0:	eb 1b                	jmp    8003cd <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 c2                	add    %eax,%edx
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c7:	48                   	dec    %eax
  8003c8:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003ca:	ff 45 fc             	incl   -0x4(%ebp)
  8003cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d3:	7c dd                	jl     8003b2 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003e1:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e6:	f7 e9                	imul   %ecx
  8003e8:	c1 f9 1f             	sar    $0x1f,%ecx
  8003eb:	89 d0                	mov    %edx,%eax
  8003ed:	29 c8                	sub    %ecx,%eax
  8003ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f9:	eb 1e                	jmp    800419 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80040b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040e:	99                   	cltd   
  80040f:	f7 7d f8             	idivl  -0x8(%ebp)
  800412:	89 d0                	mov    %edx,%eax
  800414:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800416:	ff 45 fc             	incl   -0x4(%ebp)
  800419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80041c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041f:	7c da                	jl     8003fb <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("i=%d\n",i);
	}

}
  800421:	90                   	nop
  800422:	c9                   	leave  
  800423:	c3                   	ret    

00800424 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80042a:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800431:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800438:	eb 42                	jmp    80047c <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80043a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043d:	99                   	cltd   
  80043e:	f7 7d f0             	idivl  -0x10(%ebp)
  800441:	89 d0                	mov    %edx,%eax
  800443:	85 c0                	test   %eax,%eax
  800445:	75 10                	jne    800457 <PrintElements+0x33>
			cprintf("\n");
  800447:	83 ec 0c             	sub    $0xc,%esp
  80044a:	68 c0 43 80 00       	push   $0x8043c0
  80044f:	e8 ff 06 00 00       	call   800b53 <cprintf>
  800454:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80045a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	01 d0                	add    %edx,%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	50                   	push   %eax
  80046c:	68 94 45 80 00       	push   $0x804594
  800471:	e8 dd 06 00 00       	call   800b53 <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800479:	ff 45 f4             	incl   -0xc(%ebp)
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	48                   	dec    %eax
  800480:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800483:	7f b5                	jg     80043a <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800488:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	01 d0                	add    %edx,%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	50                   	push   %eax
  80049a:	68 99 45 80 00       	push   $0x804599
  80049f:	e8 af 06 00 00       	call   800b53 <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp

}
  8004a7:	90                   	nop
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <MSort>:


void MSort(int* A, int p, int r)
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b6:	7d 54                	jge    80050c <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004be:	01 d0                	add    %edx,%eax
  8004c0:	89 c2                	mov    %eax,%edx
  8004c2:	c1 ea 1f             	shr    $0x1f,%edx
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	d1 f8                	sar    %eax
  8004c9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004cc:	83 ec 04             	sub    $0x4,%esp
  8004cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	e8 cd ff ff ff       	call   8004aa <MSort>
  8004dd:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004e3:	40                   	inc    %eax
  8004e4:	83 ec 04             	sub    $0x4,%esp
  8004e7:	ff 75 10             	pushl  0x10(%ebp)
  8004ea:	50                   	push   %eax
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	e8 b7 ff ff ff       	call   8004aa <MSort>
  8004f3:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f6:	ff 75 10             	pushl  0x10(%ebp)
  8004f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fc:	ff 75 0c             	pushl  0xc(%ebp)
  8004ff:	ff 75 08             	pushl  0x8(%ebp)
  800502:	e8 08 00 00 00       	call   80050f <Merge>
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	eb 01                	jmp    80050d <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80050c:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800515:	8b 45 10             	mov    0x10(%ebp),%eax
  800518:	2b 45 0c             	sub    0xc(%ebp),%eax
  80051b:	40                   	inc    %eax
  80051c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	2b 45 10             	sub    0x10(%ebp),%eax
  800525:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800528:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800536:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800539:	c1 e0 02             	shl    $0x2,%eax
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	50                   	push   %eax
  800540:	e8 c6 15 00 00       	call   801b0b <malloc>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  80054b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054e:	c1 e0 02             	shl    $0x2,%eax
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	50                   	push   %eax
  800555:	e8 b1 15 00 00       	call   801b0b <malloc>
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800560:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800567:	eb 2f                	jmp    800598 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80056c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800573:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800576:	01 c2                	add    %eax,%edx
  800578:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80057b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057e:	01 c8                	add    %ecx,%eax
  800580:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800585:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	01 c8                	add    %ecx,%eax
  800591:	8b 00                	mov    (%eax),%eax
  800593:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800595:	ff 45 ec             	incl   -0x14(%ebp)
  800598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059e:	7c c9                	jl     800569 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a7:	eb 2a                	jmp    8005d3 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b6:	01 c2                	add    %eax,%edx
  8005b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005be:	01 c8                	add    %ecx,%eax
  8005c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	01 c8                	add    %ecx,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005d0:	ff 45 e8             	incl   -0x18(%ebp)
  8005d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d9:	7c ce                	jl     8005a9 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e1:	e9 0a 01 00 00       	jmp    8006f0 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005ec:	0f 8d 95 00 00 00    	jge    800687 <Merge+0x178>
  8005f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f8:	0f 8d 89 00 00 00    	jge    800687 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800601:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800608:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	8b 10                	mov    (%eax),%edx
  80060f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800612:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800619:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80061c:	01 c8                	add    %ecx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	39 c2                	cmp    %eax,%edx
  800622:	7d 33                	jge    800657 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800627:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80062c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800633:	8b 45 08             	mov    0x8(%ebp),%eax
  800636:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80063c:	8d 50 01             	lea    0x1(%eax),%edx
  80063f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800642:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800649:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80064c:	01 d0                	add    %edx,%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800652:	e9 96 00 00 00       	jmp    8006ed <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80065a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800666:	8b 45 08             	mov    0x8(%ebp),%eax
  800669:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066f:	8d 50 01             	lea    0x1(%eax),%edx
  800672:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800675:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067f:	01 d0                	add    %edx,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800685:	eb 66                	jmp    8006ed <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80068d:	7d 30                	jge    8006bf <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800692:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800697:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a7:	8d 50 01             	lea    0x1(%eax),%edx
  8006aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b7:	01 d0                	add    %edx,%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 01                	mov    %eax,(%ecx)
  8006bd:	eb 2e                	jmp    8006ed <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d7:	8d 50 01             	lea    0x1(%eax),%edx
  8006da:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006ed:	ff 45 e4             	incl   -0x1c(%ebp)
  8006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f3:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f6:	0f 8e ea fe ff ff    	jle    8005e6 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  8006fc:	83 ec 0c             	sub    $0xc,%esp
  8006ff:	ff 75 d8             	pushl  -0x28(%ebp)
  800702:	e8 23 16 00 00       	call   801d2a <free>
  800707:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800710:	e8 15 16 00 00       	call   801d2a <free>
  800715:	83 c4 10             	add    $0x10,%esp

}
  800718:	90                   	nop
  800719:	c9                   	leave  
  80071a:	c3                   	ret    

0080071b <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800727:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072b:	83 ec 0c             	sub    $0xc,%esp
  80072e:	50                   	push   %eax
  80072f:	e8 ac 1a 00 00       	call   8021e0 <sys_cputc>
  800734:	83 c4 10             	add    $0x10,%esp
}
  800737:	90                   	nop
  800738:	c9                   	leave  
  800739:	c3                   	ret    

0080073a <getchar>:


int
getchar(void)
{
  80073a:	55                   	push   %ebp
  80073b:	89 e5                	mov    %esp,%ebp
  80073d:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800740:	e8 37 19 00 00       	call   80207c <sys_cgetc>
  800745:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800748:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <iscons>:

int iscons(int fdnum)
{
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800750:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800755:	5d                   	pop    %ebp
  800756:	c3                   	ret    

00800757 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80075d:	e8 af 1b 00 00       	call   802311 <sys_getenvindex>
  800762:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800765:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800768:	89 d0                	mov    %edx,%eax
  80076a:	c1 e0 03             	shl    $0x3,%eax
  80076d:	01 d0                	add    %edx,%eax
  80076f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800776:	01 c8                	add    %ecx,%eax
  800778:	01 c0                	add    %eax,%eax
  80077a:	01 d0                	add    %edx,%eax
  80077c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800783:	01 c8                	add    %ecx,%eax
  800785:	01 d0                	add    %edx,%eax
  800787:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80078c:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800791:	a1 24 50 80 00       	mov    0x805024,%eax
  800796:	8a 40 20             	mov    0x20(%eax),%al
  800799:	84 c0                	test   %al,%al
  80079b:	74 0d                	je     8007aa <libmain+0x53>
		binaryname = myEnv->prog_name;
  80079d:	a1 24 50 80 00       	mov    0x805024,%eax
  8007a2:	83 c0 20             	add    $0x20,%eax
  8007a5:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007ae:	7e 0a                	jle    8007ba <libmain+0x63>
		binaryname = argv[0];
  8007b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	ff 75 0c             	pushl  0xc(%ebp)
  8007c0:	ff 75 08             	pushl  0x8(%ebp)
  8007c3:	e8 70 f8 ff ff       	call   800038 <_main>
  8007c8:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8007cb:	e8 c5 18 00 00       	call   802095 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8007d0:	83 ec 0c             	sub    $0xc,%esp
  8007d3:	68 b8 45 80 00       	push   $0x8045b8
  8007d8:	e8 76 03 00 00       	call   800b53 <cprintf>
  8007dd:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007e0:	a1 24 50 80 00       	mov    0x805024,%eax
  8007e5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8007eb:	a1 24 50 80 00       	mov    0x805024,%eax
  8007f0:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8007f6:	83 ec 04             	sub    $0x4,%esp
  8007f9:	52                   	push   %edx
  8007fa:	50                   	push   %eax
  8007fb:	68 e0 45 80 00       	push   $0x8045e0
  800800:	e8 4e 03 00 00       	call   800b53 <cprintf>
  800805:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800808:	a1 24 50 80 00       	mov    0x805024,%eax
  80080d:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800813:	a1 24 50 80 00       	mov    0x805024,%eax
  800818:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80081e:	a1 24 50 80 00       	mov    0x805024,%eax
  800823:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800829:	51                   	push   %ecx
  80082a:	52                   	push   %edx
  80082b:	50                   	push   %eax
  80082c:	68 08 46 80 00       	push   $0x804608
  800831:	e8 1d 03 00 00       	call   800b53 <cprintf>
  800836:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800839:	a1 24 50 80 00       	mov    0x805024,%eax
  80083e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	50                   	push   %eax
  800848:	68 60 46 80 00       	push   $0x804660
  80084d:	e8 01 03 00 00       	call   800b53 <cprintf>
  800852:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800855:	83 ec 0c             	sub    $0xc,%esp
  800858:	68 b8 45 80 00       	push   $0x8045b8
  80085d:	e8 f1 02 00 00       	call   800b53 <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800865:	e8 45 18 00 00       	call   8020af <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80086a:	e8 19 00 00 00       	call   800888 <exit>
}
  80086f:	90                   	nop
  800870:	c9                   	leave  
  800871:	c3                   	ret    

00800872 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800878:	83 ec 0c             	sub    $0xc,%esp
  80087b:	6a 00                	push   $0x0
  80087d:	e8 5b 1a 00 00       	call   8022dd <sys_destroy_env>
  800882:	83 c4 10             	add    $0x10,%esp
}
  800885:	90                   	nop
  800886:	c9                   	leave  
  800887:	c3                   	ret    

00800888 <exit>:

void
exit(void)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80088e:	e8 b0 1a 00 00       	call   802343 <sys_exit_env>
}
  800893:	90                   	nop
  800894:	c9                   	leave  
  800895:	c3                   	ret    

00800896 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80089c:	8d 45 10             	lea    0x10(%ebp),%eax
  80089f:	83 c0 04             	add    $0x4,%eax
  8008a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008a5:	a1 50 50 80 00       	mov    0x805050,%eax
  8008aa:	85 c0                	test   %eax,%eax
  8008ac:	74 16                	je     8008c4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008ae:	a1 50 50 80 00       	mov    0x805050,%eax
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	50                   	push   %eax
  8008b7:	68 74 46 80 00       	push   $0x804674
  8008bc:	e8 92 02 00 00       	call   800b53 <cprintf>
  8008c1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008c4:	a1 00 50 80 00       	mov    0x805000,%eax
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	ff 75 08             	pushl  0x8(%ebp)
  8008cf:	50                   	push   %eax
  8008d0:	68 79 46 80 00       	push   $0x804679
  8008d5:	e8 79 02 00 00       	call   800b53 <cprintf>
  8008da:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e6:	50                   	push   %eax
  8008e7:	e8 fc 01 00 00       	call   800ae8 <vcprintf>
  8008ec:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	6a 00                	push   $0x0
  8008f4:	68 95 46 80 00       	push   $0x804695
  8008f9:	e8 ea 01 00 00       	call   800ae8 <vcprintf>
  8008fe:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800901:	e8 82 ff ff ff       	call   800888 <exit>

	// should not return here
	while (1) ;
  800906:	eb fe                	jmp    800906 <_panic+0x70>

00800908 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80090e:	a1 24 50 80 00       	mov    0x805024,%eax
  800913:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800919:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091c:	39 c2                	cmp    %eax,%edx
  80091e:	74 14                	je     800934 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800920:	83 ec 04             	sub    $0x4,%esp
  800923:	68 98 46 80 00       	push   $0x804698
  800928:	6a 26                	push   $0x26
  80092a:	68 e4 46 80 00       	push   $0x8046e4
  80092f:	e8 62 ff ff ff       	call   800896 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800934:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80093b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800942:	e9 c5 00 00 00       	jmp    800a0c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	01 d0                	add    %edx,%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	85 c0                	test   %eax,%eax
  80095a:	75 08                	jne    800964 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80095c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80095f:	e9 a5 00 00 00       	jmp    800a09 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800964:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800972:	eb 69                	jmp    8009dd <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800974:	a1 24 50 80 00       	mov    0x805024,%eax
  800979:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80097f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800982:	89 d0                	mov    %edx,%eax
  800984:	01 c0                	add    %eax,%eax
  800986:	01 d0                	add    %edx,%eax
  800988:	c1 e0 03             	shl    $0x3,%eax
  80098b:	01 c8                	add    %ecx,%eax
  80098d:	8a 40 04             	mov    0x4(%eax),%al
  800990:	84 c0                	test   %al,%al
  800992:	75 46                	jne    8009da <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800994:	a1 24 50 80 00       	mov    0x805024,%eax
  800999:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80099f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009a2:	89 d0                	mov    %edx,%eax
  8009a4:	01 c0                	add    %eax,%eax
  8009a6:	01 d0                	add    %edx,%eax
  8009a8:	c1 e0 03             	shl    $0x3,%eax
  8009ab:	01 c8                	add    %ecx,%eax
  8009ad:	8b 00                	mov    (%eax),%eax
  8009af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009ba:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	01 c8                	add    %ecx,%eax
  8009cb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009cd:	39 c2                	cmp    %eax,%edx
  8009cf:	75 09                	jne    8009da <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8009d1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009d8:	eb 15                	jmp    8009ef <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009da:	ff 45 e8             	incl   -0x18(%ebp)
  8009dd:	a1 24 50 80 00       	mov    0x805024,%eax
  8009e2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8009e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009eb:	39 c2                	cmp    %eax,%edx
  8009ed:	77 85                	ja     800974 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009f3:	75 14                	jne    800a09 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8009f5:	83 ec 04             	sub    $0x4,%esp
  8009f8:	68 f0 46 80 00       	push   $0x8046f0
  8009fd:	6a 3a                	push   $0x3a
  8009ff:	68 e4 46 80 00       	push   $0x8046e4
  800a04:	e8 8d fe ff ff       	call   800896 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a09:	ff 45 f0             	incl   -0x10(%ebp)
  800a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a0f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a12:	0f 8c 2f ff ff ff    	jl     800947 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a18:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a1f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a26:	eb 26                	jmp    800a4e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a28:	a1 24 50 80 00       	mov    0x805024,%eax
  800a2d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800a33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a36:	89 d0                	mov    %edx,%eax
  800a38:	01 c0                	add    %eax,%eax
  800a3a:	01 d0                	add    %edx,%eax
  800a3c:	c1 e0 03             	shl    $0x3,%eax
  800a3f:	01 c8                	add    %ecx,%eax
  800a41:	8a 40 04             	mov    0x4(%eax),%al
  800a44:	3c 01                	cmp    $0x1,%al
  800a46:	75 03                	jne    800a4b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a48:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4b:	ff 45 e0             	incl   -0x20(%ebp)
  800a4e:	a1 24 50 80 00       	mov    0x805024,%eax
  800a53:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800a59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5c:	39 c2                	cmp    %eax,%edx
  800a5e:	77 c8                	ja     800a28 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a63:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a66:	74 14                	je     800a7c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a68:	83 ec 04             	sub    $0x4,%esp
  800a6b:	68 44 47 80 00       	push   $0x804744
  800a70:	6a 44                	push   $0x44
  800a72:	68 e4 46 80 00       	push   $0x8046e4
  800a77:	e8 1a fe ff ff       	call   800896 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a7c:	90                   	nop
  800a7d:	c9                   	leave  
  800a7e:	c3                   	ret    

00800a7f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a88:	8b 00                	mov    (%eax),%eax
  800a8a:	8d 48 01             	lea    0x1(%eax),%ecx
  800a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a90:	89 0a                	mov    %ecx,(%edx)
  800a92:	8b 55 08             	mov    0x8(%ebp),%edx
  800a95:	88 d1                	mov    %dl,%cl
  800a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa1:	8b 00                	mov    (%eax),%eax
  800aa3:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aa8:	75 2c                	jne    800ad6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800aaa:	a0 2c 50 80 00       	mov    0x80502c,%al
  800aaf:	0f b6 c0             	movzbl %al,%eax
  800ab2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab5:	8b 12                	mov    (%edx),%edx
  800ab7:	89 d1                	mov    %edx,%ecx
  800ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abc:	83 c2 08             	add    $0x8,%edx
  800abf:	83 ec 04             	sub    $0x4,%esp
  800ac2:	50                   	push   %eax
  800ac3:	51                   	push   %ecx
  800ac4:	52                   	push   %edx
  800ac5:	e8 89 15 00 00       	call   802053 <sys_cputs>
  800aca:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800acd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	8b 40 04             	mov    0x4(%eax),%eax
  800adc:	8d 50 01             	lea    0x1(%eax),%edx
  800adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae2:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ae5:	90                   	nop
  800ae6:	c9                   	leave  
  800ae7:	c3                   	ret    

00800ae8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800af1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800af8:	00 00 00 
	b.cnt = 0;
  800afb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b02:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	ff 75 08             	pushl  0x8(%ebp)
  800b0b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b11:	50                   	push   %eax
  800b12:	68 7f 0a 80 00       	push   $0x800a7f
  800b17:	e8 11 02 00 00       	call   800d2d <vprintfmt>
  800b1c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b1f:	a0 2c 50 80 00       	mov    0x80502c,%al
  800b24:	0f b6 c0             	movzbl %al,%eax
  800b27:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b2d:	83 ec 04             	sub    $0x4,%esp
  800b30:	50                   	push   %eax
  800b31:	52                   	push   %edx
  800b32:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b38:	83 c0 08             	add    $0x8,%eax
  800b3b:	50                   	push   %eax
  800b3c:	e8 12 15 00 00       	call   802053 <sys_cputs>
  800b41:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b44:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
	return b.cnt;
  800b4b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b59:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
	va_start(ap, fmt);
  800b60:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6f:	50                   	push   %eax
  800b70:	e8 73 ff ff ff       	call   800ae8 <vcprintf>
  800b75:	83 c4 10             	add    $0x10,%esp
  800b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b7e:	c9                   	leave  
  800b7f:	c3                   	ret    

00800b80 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b86:	e8 0a 15 00 00       	call   802095 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b8b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9a:	50                   	push   %eax
  800b9b:	e8 48 ff ff ff       	call   800ae8 <vcprintf>
  800ba0:	83 c4 10             	add    $0x10,%esp
  800ba3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800ba6:	e8 04 15 00 00       	call   8020af <sys_unlock_cons>
	return cnt;
  800bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bae:	c9                   	leave  
  800baf:	c3                   	ret    

00800bb0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	53                   	push   %ebx
  800bb4:	83 ec 14             	sub    $0x14,%esp
  800bb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc3:	8b 45 18             	mov    0x18(%ebp),%eax
  800bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bce:	77 55                	ja     800c25 <printnum+0x75>
  800bd0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd3:	72 05                	jb     800bda <printnum+0x2a>
  800bd5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bd8:	77 4b                	ja     800c25 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bda:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bdd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800be0:	8b 45 18             	mov    0x18(%ebp),%eax
  800be3:	ba 00 00 00 00       	mov    $0x0,%edx
  800be8:	52                   	push   %edx
  800be9:	50                   	push   %eax
  800bea:	ff 75 f4             	pushl  -0xc(%ebp)
  800bed:	ff 75 f0             	pushl  -0x10(%ebp)
  800bf0:	e8 5f 35 00 00       	call   804154 <__udivdi3>
  800bf5:	83 c4 10             	add    $0x10,%esp
  800bf8:	83 ec 04             	sub    $0x4,%esp
  800bfb:	ff 75 20             	pushl  0x20(%ebp)
  800bfe:	53                   	push   %ebx
  800bff:	ff 75 18             	pushl  0x18(%ebp)
  800c02:	52                   	push   %edx
  800c03:	50                   	push   %eax
  800c04:	ff 75 0c             	pushl  0xc(%ebp)
  800c07:	ff 75 08             	pushl  0x8(%ebp)
  800c0a:	e8 a1 ff ff ff       	call   800bb0 <printnum>
  800c0f:	83 c4 20             	add    $0x20,%esp
  800c12:	eb 1a                	jmp    800c2e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c14:	83 ec 08             	sub    $0x8,%esp
  800c17:	ff 75 0c             	pushl  0xc(%ebp)
  800c1a:	ff 75 20             	pushl  0x20(%ebp)
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	ff d0                	call   *%eax
  800c22:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c25:	ff 4d 1c             	decl   0x1c(%ebp)
  800c28:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c2c:	7f e6                	jg     800c14 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c2e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c31:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3c:	53                   	push   %ebx
  800c3d:	51                   	push   %ecx
  800c3e:	52                   	push   %edx
  800c3f:	50                   	push   %eax
  800c40:	e8 1f 36 00 00       	call   804264 <__umoddi3>
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	05 b4 49 80 00       	add    $0x8049b4,%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	0f be c0             	movsbl %al,%eax
  800c52:	83 ec 08             	sub    $0x8,%esp
  800c55:	ff 75 0c             	pushl  0xc(%ebp)
  800c58:	50                   	push   %eax
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	ff d0                	call   *%eax
  800c5e:	83 c4 10             	add    $0x10,%esp
}
  800c61:	90                   	nop
  800c62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c65:	c9                   	leave  
  800c66:	c3                   	ret    

00800c67 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c6a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c6e:	7e 1c                	jle    800c8c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	8b 00                	mov    (%eax),%eax
  800c75:	8d 50 08             	lea    0x8(%eax),%edx
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	89 10                	mov    %edx,(%eax)
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	8b 00                	mov    (%eax),%eax
  800c82:	83 e8 08             	sub    $0x8,%eax
  800c85:	8b 50 04             	mov    0x4(%eax),%edx
  800c88:	8b 00                	mov    (%eax),%eax
  800c8a:	eb 40                	jmp    800ccc <getuint+0x65>
	else if (lflag)
  800c8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c90:	74 1e                	je     800cb0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	8b 00                	mov    (%eax),%eax
  800c97:	8d 50 04             	lea    0x4(%eax),%edx
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	89 10                	mov    %edx,(%eax)
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8b 00                	mov    (%eax),%eax
  800ca4:	83 e8 04             	sub    $0x4,%eax
  800ca7:	8b 00                	mov    (%eax),%eax
  800ca9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cae:	eb 1c                	jmp    800ccc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8b 00                	mov    (%eax),%eax
  800cb5:	8d 50 04             	lea    0x4(%eax),%edx
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	89 10                	mov    %edx,(%eax)
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	8b 00                	mov    (%eax),%eax
  800cc2:	83 e8 04             	sub    $0x4,%eax
  800cc5:	8b 00                	mov    (%eax),%eax
  800cc7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd5:	7e 1c                	jle    800cf3 <getint+0x25>
		return va_arg(*ap, long long);
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8b 00                	mov    (%eax),%eax
  800cdc:	8d 50 08             	lea    0x8(%eax),%edx
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	89 10                	mov    %edx,(%eax)
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	8b 00                	mov    (%eax),%eax
  800ce9:	83 e8 08             	sub    $0x8,%eax
  800cec:	8b 50 04             	mov    0x4(%eax),%edx
  800cef:	8b 00                	mov    (%eax),%eax
  800cf1:	eb 38                	jmp    800d2b <getint+0x5d>
	else if (lflag)
  800cf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf7:	74 1a                	je     800d13 <getint+0x45>
		return va_arg(*ap, long);
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8b 00                	mov    (%eax),%eax
  800cfe:	8d 50 04             	lea    0x4(%eax),%edx
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	89 10                	mov    %edx,(%eax)
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8b 00                	mov    (%eax),%eax
  800d0b:	83 e8 04             	sub    $0x4,%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	99                   	cltd   
  800d11:	eb 18                	jmp    800d2b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8b 00                	mov    (%eax),%eax
  800d18:	8d 50 04             	lea    0x4(%eax),%edx
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 10                	mov    %edx,(%eax)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8b 00                	mov    (%eax),%eax
  800d25:	83 e8 04             	sub    $0x4,%eax
  800d28:	8b 00                	mov    (%eax),%eax
  800d2a:	99                   	cltd   
}
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	56                   	push   %esi
  800d31:	53                   	push   %ebx
  800d32:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d35:	eb 17                	jmp    800d4e <vprintfmt+0x21>
			if (ch == '\0')
  800d37:	85 db                	test   %ebx,%ebx
  800d39:	0f 84 c1 03 00 00    	je     801100 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d3f:	83 ec 08             	sub    $0x8,%esp
  800d42:	ff 75 0c             	pushl  0xc(%ebp)
  800d45:	53                   	push   %ebx
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	ff d0                	call   *%eax
  800d4b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d51:	8d 50 01             	lea    0x1(%eax),%edx
  800d54:	89 55 10             	mov    %edx,0x10(%ebp)
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	0f b6 d8             	movzbl %al,%ebx
  800d5c:	83 fb 25             	cmp    $0x25,%ebx
  800d5f:	75 d6                	jne    800d37 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d61:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d65:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d6c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d73:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d7a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d81:	8b 45 10             	mov    0x10(%ebp),%eax
  800d84:	8d 50 01             	lea    0x1(%eax),%edx
  800d87:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8a:	8a 00                	mov    (%eax),%al
  800d8c:	0f b6 d8             	movzbl %al,%ebx
  800d8f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d92:	83 f8 5b             	cmp    $0x5b,%eax
  800d95:	0f 87 3d 03 00 00    	ja     8010d8 <vprintfmt+0x3ab>
  800d9b:	8b 04 85 d8 49 80 00 	mov    0x8049d8(,%eax,4),%eax
  800da2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800da4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800da8:	eb d7                	jmp    800d81 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800daa:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800dae:	eb d1                	jmp    800d81 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800db0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800db7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dba:	89 d0                	mov    %edx,%eax
  800dbc:	c1 e0 02             	shl    $0x2,%eax
  800dbf:	01 d0                	add    %edx,%eax
  800dc1:	01 c0                	add    %eax,%eax
  800dc3:	01 d8                	add    %ebx,%eax
  800dc5:	83 e8 30             	sub    $0x30,%eax
  800dc8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dd3:	83 fb 2f             	cmp    $0x2f,%ebx
  800dd6:	7e 3e                	jle    800e16 <vprintfmt+0xe9>
  800dd8:	83 fb 39             	cmp    $0x39,%ebx
  800ddb:	7f 39                	jg     800e16 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ddd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800de0:	eb d5                	jmp    800db7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800de2:	8b 45 14             	mov    0x14(%ebp),%eax
  800de5:	83 c0 04             	add    $0x4,%eax
  800de8:	89 45 14             	mov    %eax,0x14(%ebp)
  800deb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dee:	83 e8 04             	sub    $0x4,%eax
  800df1:	8b 00                	mov    (%eax),%eax
  800df3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800df6:	eb 1f                	jmp    800e17 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800df8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfc:	79 83                	jns    800d81 <vprintfmt+0x54>
				width = 0;
  800dfe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e05:	e9 77 ff ff ff       	jmp    800d81 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e0a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e11:	e9 6b ff ff ff       	jmp    800d81 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e16:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e1b:	0f 89 60 ff ff ff    	jns    800d81 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e27:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e2e:	e9 4e ff ff ff       	jmp    800d81 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e33:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e36:	e9 46 ff ff ff       	jmp    800d81 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3e:	83 c0 04             	add    $0x4,%eax
  800e41:	89 45 14             	mov    %eax,0x14(%ebp)
  800e44:	8b 45 14             	mov    0x14(%ebp),%eax
  800e47:	83 e8 04             	sub    $0x4,%eax
  800e4a:	8b 00                	mov    (%eax),%eax
  800e4c:	83 ec 08             	sub    $0x8,%esp
  800e4f:	ff 75 0c             	pushl  0xc(%ebp)
  800e52:	50                   	push   %eax
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	ff d0                	call   *%eax
  800e58:	83 c4 10             	add    $0x10,%esp
			break;
  800e5b:	e9 9b 02 00 00       	jmp    8010fb <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e60:	8b 45 14             	mov    0x14(%ebp),%eax
  800e63:	83 c0 04             	add    $0x4,%eax
  800e66:	89 45 14             	mov    %eax,0x14(%ebp)
  800e69:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6c:	83 e8 04             	sub    $0x4,%eax
  800e6f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e71:	85 db                	test   %ebx,%ebx
  800e73:	79 02                	jns    800e77 <vprintfmt+0x14a>
				err = -err;
  800e75:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e77:	83 fb 64             	cmp    $0x64,%ebx
  800e7a:	7f 0b                	jg     800e87 <vprintfmt+0x15a>
  800e7c:	8b 34 9d 20 48 80 00 	mov    0x804820(,%ebx,4),%esi
  800e83:	85 f6                	test   %esi,%esi
  800e85:	75 19                	jne    800ea0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e87:	53                   	push   %ebx
  800e88:	68 c5 49 80 00       	push   $0x8049c5
  800e8d:	ff 75 0c             	pushl  0xc(%ebp)
  800e90:	ff 75 08             	pushl  0x8(%ebp)
  800e93:	e8 70 02 00 00       	call   801108 <printfmt>
  800e98:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e9b:	e9 5b 02 00 00       	jmp    8010fb <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ea0:	56                   	push   %esi
  800ea1:	68 ce 49 80 00       	push   $0x8049ce
  800ea6:	ff 75 0c             	pushl  0xc(%ebp)
  800ea9:	ff 75 08             	pushl  0x8(%ebp)
  800eac:	e8 57 02 00 00       	call   801108 <printfmt>
  800eb1:	83 c4 10             	add    $0x10,%esp
			break;
  800eb4:	e9 42 02 00 00       	jmp    8010fb <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eb9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebc:	83 c0 04             	add    $0x4,%eax
  800ebf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec5:	83 e8 04             	sub    $0x4,%eax
  800ec8:	8b 30                	mov    (%eax),%esi
  800eca:	85 f6                	test   %esi,%esi
  800ecc:	75 05                	jne    800ed3 <vprintfmt+0x1a6>
				p = "(null)";
  800ece:	be d1 49 80 00       	mov    $0x8049d1,%esi
			if (width > 0 && padc != '-')
  800ed3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed7:	7e 6d                	jle    800f46 <vprintfmt+0x219>
  800ed9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800edd:	74 67                	je     800f46 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800edf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee2:	83 ec 08             	sub    $0x8,%esp
  800ee5:	50                   	push   %eax
  800ee6:	56                   	push   %esi
  800ee7:	e8 26 05 00 00       	call   801412 <strnlen>
  800eec:	83 c4 10             	add    $0x10,%esp
  800eef:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ef2:	eb 16                	jmp    800f0a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ef4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ef8:	83 ec 08             	sub    $0x8,%esp
  800efb:	ff 75 0c             	pushl  0xc(%ebp)
  800efe:	50                   	push   %eax
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	ff d0                	call   *%eax
  800f04:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f07:	ff 4d e4             	decl   -0x1c(%ebp)
  800f0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0e:	7f e4                	jg     800ef4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f10:	eb 34                	jmp    800f46 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f12:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f16:	74 1c                	je     800f34 <vprintfmt+0x207>
  800f18:	83 fb 1f             	cmp    $0x1f,%ebx
  800f1b:	7e 05                	jle    800f22 <vprintfmt+0x1f5>
  800f1d:	83 fb 7e             	cmp    $0x7e,%ebx
  800f20:	7e 12                	jle    800f34 <vprintfmt+0x207>
					putch('?', putdat);
  800f22:	83 ec 08             	sub    $0x8,%esp
  800f25:	ff 75 0c             	pushl  0xc(%ebp)
  800f28:	6a 3f                	push   $0x3f
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	ff d0                	call   *%eax
  800f2f:	83 c4 10             	add    $0x10,%esp
  800f32:	eb 0f                	jmp    800f43 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f34:	83 ec 08             	sub    $0x8,%esp
  800f37:	ff 75 0c             	pushl  0xc(%ebp)
  800f3a:	53                   	push   %ebx
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	ff d0                	call   *%eax
  800f40:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f43:	ff 4d e4             	decl   -0x1c(%ebp)
  800f46:	89 f0                	mov    %esi,%eax
  800f48:	8d 70 01             	lea    0x1(%eax),%esi
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	0f be d8             	movsbl %al,%ebx
  800f50:	85 db                	test   %ebx,%ebx
  800f52:	74 24                	je     800f78 <vprintfmt+0x24b>
  800f54:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f58:	78 b8                	js     800f12 <vprintfmt+0x1e5>
  800f5a:	ff 4d e0             	decl   -0x20(%ebp)
  800f5d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f61:	79 af                	jns    800f12 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f63:	eb 13                	jmp    800f78 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	ff 75 0c             	pushl  0xc(%ebp)
  800f6b:	6a 20                	push   $0x20
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	ff d0                	call   *%eax
  800f72:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f75:	ff 4d e4             	decl   -0x1c(%ebp)
  800f78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7c:	7f e7                	jg     800f65 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f7e:	e9 78 01 00 00       	jmp    8010fb <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f83:	83 ec 08             	sub    $0x8,%esp
  800f86:	ff 75 e8             	pushl  -0x18(%ebp)
  800f89:	8d 45 14             	lea    0x14(%ebp),%eax
  800f8c:	50                   	push   %eax
  800f8d:	e8 3c fd ff ff       	call   800cce <getint>
  800f92:	83 c4 10             	add    $0x10,%esp
  800f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f98:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa1:	85 d2                	test   %edx,%edx
  800fa3:	79 23                	jns    800fc8 <vprintfmt+0x29b>
				putch('-', putdat);
  800fa5:	83 ec 08             	sub    $0x8,%esp
  800fa8:	ff 75 0c             	pushl  0xc(%ebp)
  800fab:	6a 2d                	push   $0x2d
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	ff d0                	call   *%eax
  800fb2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fbb:	f7 d8                	neg    %eax
  800fbd:	83 d2 00             	adc    $0x0,%edx
  800fc0:	f7 da                	neg    %edx
  800fc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fc8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fcf:	e9 bc 00 00 00       	jmp    801090 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fd4:	83 ec 08             	sub    $0x8,%esp
  800fd7:	ff 75 e8             	pushl  -0x18(%ebp)
  800fda:	8d 45 14             	lea    0x14(%ebp),%eax
  800fdd:	50                   	push   %eax
  800fde:	e8 84 fc ff ff       	call   800c67 <getuint>
  800fe3:	83 c4 10             	add    $0x10,%esp
  800fe6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ff3:	e9 98 00 00 00       	jmp    801090 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ff8:	83 ec 08             	sub    $0x8,%esp
  800ffb:	ff 75 0c             	pushl  0xc(%ebp)
  800ffe:	6a 58                	push   $0x58
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	ff d0                	call   *%eax
  801005:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801008:	83 ec 08             	sub    $0x8,%esp
  80100b:	ff 75 0c             	pushl  0xc(%ebp)
  80100e:	6a 58                	push   $0x58
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	ff d0                	call   *%eax
  801015:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801018:	83 ec 08             	sub    $0x8,%esp
  80101b:	ff 75 0c             	pushl  0xc(%ebp)
  80101e:	6a 58                	push   $0x58
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	ff d0                	call   *%eax
  801025:	83 c4 10             	add    $0x10,%esp
			break;
  801028:	e9 ce 00 00 00       	jmp    8010fb <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80102d:	83 ec 08             	sub    $0x8,%esp
  801030:	ff 75 0c             	pushl  0xc(%ebp)
  801033:	6a 30                	push   $0x30
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	ff d0                	call   *%eax
  80103a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80103d:	83 ec 08             	sub    $0x8,%esp
  801040:	ff 75 0c             	pushl  0xc(%ebp)
  801043:	6a 78                	push   $0x78
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	ff d0                	call   *%eax
  80104a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80104d:	8b 45 14             	mov    0x14(%ebp),%eax
  801050:	83 c0 04             	add    $0x4,%eax
  801053:	89 45 14             	mov    %eax,0x14(%ebp)
  801056:	8b 45 14             	mov    0x14(%ebp),%eax
  801059:	83 e8 04             	sub    $0x4,%eax
  80105c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80105e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801061:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801068:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80106f:	eb 1f                	jmp    801090 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801071:	83 ec 08             	sub    $0x8,%esp
  801074:	ff 75 e8             	pushl  -0x18(%ebp)
  801077:	8d 45 14             	lea    0x14(%ebp),%eax
  80107a:	50                   	push   %eax
  80107b:	e8 e7 fb ff ff       	call   800c67 <getuint>
  801080:	83 c4 10             	add    $0x10,%esp
  801083:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801086:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801089:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801090:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801094:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801097:	83 ec 04             	sub    $0x4,%esp
  80109a:	52                   	push   %edx
  80109b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80109e:	50                   	push   %eax
  80109f:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8010a5:	ff 75 0c             	pushl  0xc(%ebp)
  8010a8:	ff 75 08             	pushl  0x8(%ebp)
  8010ab:	e8 00 fb ff ff       	call   800bb0 <printnum>
  8010b0:	83 c4 20             	add    $0x20,%esp
			break;
  8010b3:	eb 46                	jmp    8010fb <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010b5:	83 ec 08             	sub    $0x8,%esp
  8010b8:	ff 75 0c             	pushl  0xc(%ebp)
  8010bb:	53                   	push   %ebx
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	ff d0                	call   *%eax
  8010c1:	83 c4 10             	add    $0x10,%esp
			break;
  8010c4:	eb 35                	jmp    8010fb <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010c6:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  8010cd:	eb 2c                	jmp    8010fb <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010cf:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
			break;
  8010d6:	eb 23                	jmp    8010fb <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010d8:	83 ec 08             	sub    $0x8,%esp
  8010db:	ff 75 0c             	pushl  0xc(%ebp)
  8010de:	6a 25                	push   $0x25
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	ff d0                	call   *%eax
  8010e5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010e8:	ff 4d 10             	decl   0x10(%ebp)
  8010eb:	eb 03                	jmp    8010f0 <vprintfmt+0x3c3>
  8010ed:	ff 4d 10             	decl   0x10(%ebp)
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	48                   	dec    %eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 25                	cmp    $0x25,%al
  8010f8:	75 f3                	jne    8010ed <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010fa:	90                   	nop
		}
	}
  8010fb:	e9 35 fc ff ff       	jmp    800d35 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801100:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801101:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801104:	5b                   	pop    %ebx
  801105:	5e                   	pop    %esi
  801106:	5d                   	pop    %ebp
  801107:	c3                   	ret    

00801108 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801108:	55                   	push   %ebp
  801109:	89 e5                	mov    %esp,%ebp
  80110b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80110e:	8d 45 10             	lea    0x10(%ebp),%eax
  801111:	83 c0 04             	add    $0x4,%eax
  801114:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801117:	8b 45 10             	mov    0x10(%ebp),%eax
  80111a:	ff 75 f4             	pushl  -0xc(%ebp)
  80111d:	50                   	push   %eax
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	ff 75 08             	pushl  0x8(%ebp)
  801124:	e8 04 fc ff ff       	call   800d2d <vprintfmt>
  801129:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80112c:	90                   	nop
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	8b 40 08             	mov    0x8(%eax),%eax
  801138:	8d 50 01             	lea    0x1(%eax),%edx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	8b 10                	mov    (%eax),%edx
  801146:	8b 45 0c             	mov    0xc(%ebp),%eax
  801149:	8b 40 04             	mov    0x4(%eax),%eax
  80114c:	39 c2                	cmp    %eax,%edx
  80114e:	73 12                	jae    801162 <sprintputch+0x33>
		*b->buf++ = ch;
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	8b 00                	mov    (%eax),%eax
  801155:	8d 48 01             	lea    0x1(%eax),%ecx
  801158:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115b:	89 0a                	mov    %ecx,(%edx)
  80115d:	8b 55 08             	mov    0x8(%ebp),%edx
  801160:	88 10                	mov    %dl,(%eax)
}
  801162:	90                   	nop
  801163:	5d                   	pop    %ebp
  801164:	c3                   	ret    

00801165 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801171:	8b 45 0c             	mov    0xc(%ebp),%eax
  801174:	8d 50 ff             	lea    -0x1(%eax),%edx
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	01 d0                	add    %edx,%eax
  80117c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80117f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801186:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80118a:	74 06                	je     801192 <vsnprintf+0x2d>
  80118c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801190:	7f 07                	jg     801199 <vsnprintf+0x34>
		return -E_INVAL;
  801192:	b8 03 00 00 00       	mov    $0x3,%eax
  801197:	eb 20                	jmp    8011b9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801199:	ff 75 14             	pushl  0x14(%ebp)
  80119c:	ff 75 10             	pushl  0x10(%ebp)
  80119f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011a2:	50                   	push   %eax
  8011a3:	68 2f 11 80 00       	push   $0x80112f
  8011a8:	e8 80 fb ff ff       	call   800d2d <vprintfmt>
  8011ad:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8011c4:	83 c0 04             	add    $0x4,%eax
  8011c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8011d0:	50                   	push   %eax
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	ff 75 08             	pushl  0x8(%ebp)
  8011d7:	e8 89 ff ff ff       	call   801165 <vsnprintf>
  8011dc:	83 c4 10             	add    $0x10,%esp
  8011df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011e5:	c9                   	leave  
  8011e6:	c3                   	ret    

008011e7 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8011ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f1:	74 13                	je     801206 <readline+0x1f>
		cprintf("%s", prompt);
  8011f3:	83 ec 08             	sub    $0x8,%esp
  8011f6:	ff 75 08             	pushl  0x8(%ebp)
  8011f9:	68 48 4b 80 00       	push   $0x804b48
  8011fe:	e8 50 f9 ff ff       	call   800b53 <cprintf>
  801203:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801206:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80120d:	83 ec 0c             	sub    $0xc,%esp
  801210:	6a 00                	push   $0x0
  801212:	e8 36 f5 ff ff       	call   80074d <iscons>
  801217:	83 c4 10             	add    $0x10,%esp
  80121a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80121d:	e8 18 f5 ff ff       	call   80073a <getchar>
  801222:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801225:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801229:	79 22                	jns    80124d <readline+0x66>
			if (c != -E_EOF)
  80122b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80122f:	0f 84 ad 00 00 00    	je     8012e2 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801235:	83 ec 08             	sub    $0x8,%esp
  801238:	ff 75 ec             	pushl  -0x14(%ebp)
  80123b:	68 4b 4b 80 00       	push   $0x804b4b
  801240:	e8 0e f9 ff ff       	call   800b53 <cprintf>
  801245:	83 c4 10             	add    $0x10,%esp
			break;
  801248:	e9 95 00 00 00       	jmp    8012e2 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80124d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801251:	7e 34                	jle    801287 <readline+0xa0>
  801253:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80125a:	7f 2b                	jg     801287 <readline+0xa0>
			if (echoing)
  80125c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801260:	74 0e                	je     801270 <readline+0x89>
				cputchar(c);
  801262:	83 ec 0c             	sub    $0xc,%esp
  801265:	ff 75 ec             	pushl  -0x14(%ebp)
  801268:	e8 ae f4 ff ff       	call   80071b <cputchar>
  80126d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801273:	8d 50 01             	lea    0x1(%eax),%edx
  801276:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801279:	89 c2                	mov    %eax,%edx
  80127b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127e:	01 d0                	add    %edx,%eax
  801280:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801283:	88 10                	mov    %dl,(%eax)
  801285:	eb 56                	jmp    8012dd <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801287:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80128b:	75 1f                	jne    8012ac <readline+0xc5>
  80128d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801291:	7e 19                	jle    8012ac <readline+0xc5>
			if (echoing)
  801293:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801297:	74 0e                	je     8012a7 <readline+0xc0>
				cputchar(c);
  801299:	83 ec 0c             	sub    $0xc,%esp
  80129c:	ff 75 ec             	pushl  -0x14(%ebp)
  80129f:	e8 77 f4 ff ff       	call   80071b <cputchar>
  8012a4:	83 c4 10             	add    $0x10,%esp

			i--;
  8012a7:	ff 4d f4             	decl   -0xc(%ebp)
  8012aa:	eb 31                	jmp    8012dd <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012ac:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012b0:	74 0a                	je     8012bc <readline+0xd5>
  8012b2:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012b6:	0f 85 61 ff ff ff    	jne    80121d <readline+0x36>
			if (echoing)
  8012bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012c0:	74 0e                	je     8012d0 <readline+0xe9>
				cputchar(c);
  8012c2:	83 ec 0c             	sub    $0xc,%esp
  8012c5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c8:	e8 4e f4 ff ff       	call   80071b <cputchar>
  8012cd:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	01 d0                	add    %edx,%eax
  8012d8:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8012db:	eb 06                	jmp    8012e3 <readline+0xfc>
		}
	}
  8012dd:	e9 3b ff ff ff       	jmp    80121d <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8012e2:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8012e3:	90                   	nop
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8012ec:	e8 a4 0d 00 00       	call   802095 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f5:	74 13                	je     80130a <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012f7:	83 ec 08             	sub    $0x8,%esp
  8012fa:	ff 75 08             	pushl  0x8(%ebp)
  8012fd:	68 48 4b 80 00       	push   $0x804b48
  801302:	e8 4c f8 ff ff       	call   800b53 <cprintf>
  801307:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80130a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801311:	83 ec 0c             	sub    $0xc,%esp
  801314:	6a 00                	push   $0x0
  801316:	e8 32 f4 ff ff       	call   80074d <iscons>
  80131b:	83 c4 10             	add    $0x10,%esp
  80131e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801321:	e8 14 f4 ff ff       	call   80073a <getchar>
  801326:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801329:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80132d:	79 22                	jns    801351 <atomic_readline+0x6b>
				if (c != -E_EOF)
  80132f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801333:	0f 84 ad 00 00 00    	je     8013e6 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801339:	83 ec 08             	sub    $0x8,%esp
  80133c:	ff 75 ec             	pushl  -0x14(%ebp)
  80133f:	68 4b 4b 80 00       	push   $0x804b4b
  801344:	e8 0a f8 ff ff       	call   800b53 <cprintf>
  801349:	83 c4 10             	add    $0x10,%esp
				break;
  80134c:	e9 95 00 00 00       	jmp    8013e6 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801351:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801355:	7e 34                	jle    80138b <atomic_readline+0xa5>
  801357:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80135e:	7f 2b                	jg     80138b <atomic_readline+0xa5>
				if (echoing)
  801360:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801364:	74 0e                	je     801374 <atomic_readline+0x8e>
					cputchar(c);
  801366:	83 ec 0c             	sub    $0xc,%esp
  801369:	ff 75 ec             	pushl  -0x14(%ebp)
  80136c:	e8 aa f3 ff ff       	call   80071b <cputchar>
  801371:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801377:	8d 50 01             	lea    0x1(%eax),%edx
  80137a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80137d:	89 c2                	mov    %eax,%edx
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	01 d0                	add    %edx,%eax
  801384:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801387:	88 10                	mov    %dl,(%eax)
  801389:	eb 56                	jmp    8013e1 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80138b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80138f:	75 1f                	jne    8013b0 <atomic_readline+0xca>
  801391:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801395:	7e 19                	jle    8013b0 <atomic_readline+0xca>
				if (echoing)
  801397:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80139b:	74 0e                	je     8013ab <atomic_readline+0xc5>
					cputchar(c);
  80139d:	83 ec 0c             	sub    $0xc,%esp
  8013a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8013a3:	e8 73 f3 ff ff       	call   80071b <cputchar>
  8013a8:	83 c4 10             	add    $0x10,%esp
				i--;
  8013ab:	ff 4d f4             	decl   -0xc(%ebp)
  8013ae:	eb 31                	jmp    8013e1 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8013b0:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013b4:	74 0a                	je     8013c0 <atomic_readline+0xda>
  8013b6:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013ba:	0f 85 61 ff ff ff    	jne    801321 <atomic_readline+0x3b>
				if (echoing)
  8013c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013c4:	74 0e                	je     8013d4 <atomic_readline+0xee>
					cputchar(c);
  8013c6:	83 ec 0c             	sub    $0xc,%esp
  8013c9:	ff 75 ec             	pushl  -0x14(%ebp)
  8013cc:	e8 4a f3 ff ff       	call   80071b <cputchar>
  8013d1:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8013d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013da:	01 d0                	add    %edx,%eax
  8013dc:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8013df:	eb 06                	jmp    8013e7 <atomic_readline+0x101>
			}
		}
  8013e1:	e9 3b ff ff ff       	jmp    801321 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8013e6:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8013e7:	e8 c3 0c 00 00       	call   8020af <sys_unlock_cons>
}
  8013ec:	90                   	nop
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013fc:	eb 06                	jmp    801404 <strlen+0x15>
		n++;
  8013fe:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801401:	ff 45 08             	incl   0x8(%ebp)
  801404:	8b 45 08             	mov    0x8(%ebp),%eax
  801407:	8a 00                	mov    (%eax),%al
  801409:	84 c0                	test   %al,%al
  80140b:	75 f1                	jne    8013fe <strlen+0xf>
		n++;
	return n;
  80140d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801410:	c9                   	leave  
  801411:	c3                   	ret    

00801412 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141f:	eb 09                	jmp    80142a <strnlen+0x18>
		n++;
  801421:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801424:	ff 45 08             	incl   0x8(%ebp)
  801427:	ff 4d 0c             	decl   0xc(%ebp)
  80142a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80142e:	74 09                	je     801439 <strnlen+0x27>
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	84 c0                	test   %al,%al
  801437:	75 e8                	jne    801421 <strnlen+0xf>
		n++;
	return n;
  801439:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80144a:	90                   	nop
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8d 50 01             	lea    0x1(%eax),%edx
  801451:	89 55 08             	mov    %edx,0x8(%ebp)
  801454:	8b 55 0c             	mov    0xc(%ebp),%edx
  801457:	8d 4a 01             	lea    0x1(%edx),%ecx
  80145a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80145d:	8a 12                	mov    (%edx),%dl
  80145f:	88 10                	mov    %dl,(%eax)
  801461:	8a 00                	mov    (%eax),%al
  801463:	84 c0                	test   %al,%al
  801465:	75 e4                	jne    80144b <strcpy+0xd>
		/* do nothing */;
	return ret;
  801467:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801478:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80147f:	eb 1f                	jmp    8014a0 <strncpy+0x34>
		*dst++ = *src;
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8d 50 01             	lea    0x1(%eax),%edx
  801487:	89 55 08             	mov    %edx,0x8(%ebp)
  80148a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148d:	8a 12                	mov    (%edx),%dl
  80148f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801491:	8b 45 0c             	mov    0xc(%ebp),%eax
  801494:	8a 00                	mov    (%eax),%al
  801496:	84 c0                	test   %al,%al
  801498:	74 03                	je     80149d <strncpy+0x31>
			src++;
  80149a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80149d:	ff 45 fc             	incl   -0x4(%ebp)
  8014a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014a6:	72 d9                	jb     801481 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    

008014ad <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
  8014b0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014bd:	74 30                	je     8014ef <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014bf:	eb 16                	jmp    8014d7 <strlcpy+0x2a>
			*dst++ = *src++;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	8d 50 01             	lea    0x1(%eax),%edx
  8014c7:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014d0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014d3:	8a 12                	mov    (%edx),%dl
  8014d5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014d7:	ff 4d 10             	decl   0x10(%ebp)
  8014da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014de:	74 09                	je     8014e9 <strlcpy+0x3c>
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	8a 00                	mov    (%eax),%al
  8014e5:	84 c0                	test   %al,%al
  8014e7:	75 d8                	jne    8014c1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f5:	29 c2                	sub    %eax,%edx
  8014f7:	89 d0                	mov    %edx,%eax
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014fe:	eb 06                	jmp    801506 <strcmp+0xb>
		p++, q++;
  801500:	ff 45 08             	incl   0x8(%ebp)
  801503:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	84 c0                	test   %al,%al
  80150d:	74 0e                	je     80151d <strcmp+0x22>
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 10                	mov    (%eax),%dl
  801514:	8b 45 0c             	mov    0xc(%ebp),%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	38 c2                	cmp    %al,%dl
  80151b:	74 e3                	je     801500 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	0f b6 d0             	movzbl %al,%edx
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	8a 00                	mov    (%eax),%al
  80152a:	0f b6 c0             	movzbl %al,%eax
  80152d:	29 c2                	sub    %eax,%edx
  80152f:	89 d0                	mov    %edx,%eax
}
  801531:	5d                   	pop    %ebp
  801532:	c3                   	ret    

00801533 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801536:	eb 09                	jmp    801541 <strncmp+0xe>
		n--, p++, q++;
  801538:	ff 4d 10             	decl   0x10(%ebp)
  80153b:	ff 45 08             	incl   0x8(%ebp)
  80153e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801541:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801545:	74 17                	je     80155e <strncmp+0x2b>
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	8a 00                	mov    (%eax),%al
  80154c:	84 c0                	test   %al,%al
  80154e:	74 0e                	je     80155e <strncmp+0x2b>
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	8a 10                	mov    (%eax),%dl
  801555:	8b 45 0c             	mov    0xc(%ebp),%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	38 c2                	cmp    %al,%dl
  80155c:	74 da                	je     801538 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80155e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801562:	75 07                	jne    80156b <strncmp+0x38>
		return 0;
  801564:	b8 00 00 00 00       	mov    $0x0,%eax
  801569:	eb 14                	jmp    80157f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f b6 d0             	movzbl %al,%edx
  801573:	8b 45 0c             	mov    0xc(%ebp),%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	0f b6 c0             	movzbl %al,%eax
  80157b:	29 c2                	sub    %eax,%edx
  80157d:	89 d0                	mov    %edx,%eax
}
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    

00801581 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80158d:	eb 12                	jmp    8015a1 <strchr+0x20>
		if (*s == c)
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801597:	75 05                	jne    80159e <strchr+0x1d>
			return (char *) s;
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	eb 11                	jmp    8015af <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80159e:	ff 45 08             	incl   0x8(%ebp)
  8015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a4:	8a 00                	mov    (%eax),%al
  8015a6:	84 c0                	test   %al,%al
  8015a8:	75 e5                	jne    80158f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 04             	sub    $0x4,%esp
  8015b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015bd:	eb 0d                	jmp    8015cc <strfind+0x1b>
		if (*s == c)
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	8a 00                	mov    (%eax),%al
  8015c4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015c7:	74 0e                	je     8015d7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015c9:	ff 45 08             	incl   0x8(%ebp)
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	84 c0                	test   %al,%al
  8015d3:	75 ea                	jne    8015bf <strfind+0xe>
  8015d5:	eb 01                	jmp    8015d8 <strfind+0x27>
		if (*s == c)
			break;
  8015d7:	90                   	nop
	return (char *) s;
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015ef:	eb 0e                	jmp    8015ff <memset+0x22>
		*p++ = c;
  8015f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f4:	8d 50 01             	lea    0x1(%eax),%edx
  8015f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015ff:	ff 4d f8             	decl   -0x8(%ebp)
  801602:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801606:	79 e9                	jns    8015f1 <memset+0x14>
		*p++ = c;

	return v;
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801613:	8b 45 0c             	mov    0xc(%ebp),%eax
  801616:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80161f:	eb 16                	jmp    801637 <memcpy+0x2a>
		*d++ = *s++;
  801621:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801624:	8d 50 01             	lea    0x1(%eax),%edx
  801627:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80162a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801630:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801633:	8a 12                	mov    (%edx),%dl
  801635:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801637:	8b 45 10             	mov    0x10(%ebp),%eax
  80163a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80163d:	89 55 10             	mov    %edx,0x10(%ebp)
  801640:	85 c0                	test   %eax,%eax
  801642:	75 dd                	jne    801621 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80164f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801652:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80165b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80165e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801661:	73 50                	jae    8016b3 <memmove+0x6a>
  801663:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801666:	8b 45 10             	mov    0x10(%ebp),%eax
  801669:	01 d0                	add    %edx,%eax
  80166b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80166e:	76 43                	jbe    8016b3 <memmove+0x6a>
		s += n;
  801670:	8b 45 10             	mov    0x10(%ebp),%eax
  801673:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801676:	8b 45 10             	mov    0x10(%ebp),%eax
  801679:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80167c:	eb 10                	jmp    80168e <memmove+0x45>
			*--d = *--s;
  80167e:	ff 4d f8             	decl   -0x8(%ebp)
  801681:	ff 4d fc             	decl   -0x4(%ebp)
  801684:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801687:	8a 10                	mov    (%eax),%dl
  801689:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80168e:	8b 45 10             	mov    0x10(%ebp),%eax
  801691:	8d 50 ff             	lea    -0x1(%eax),%edx
  801694:	89 55 10             	mov    %edx,0x10(%ebp)
  801697:	85 c0                	test   %eax,%eax
  801699:	75 e3                	jne    80167e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80169b:	eb 23                	jmp    8016c0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80169d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a0:	8d 50 01             	lea    0x1(%eax),%edx
  8016a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016ac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016af:	8a 12                	mov    (%edx),%dl
  8016b1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	75 dd                	jne    80169d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016d7:	eb 2a                	jmp    801703 <memcmp+0x3e>
		if (*s1 != *s2)
  8016d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016dc:	8a 10                	mov    (%eax),%dl
  8016de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e1:	8a 00                	mov    (%eax),%al
  8016e3:	38 c2                	cmp    %al,%dl
  8016e5:	74 16                	je     8016fd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ea:	8a 00                	mov    (%eax),%al
  8016ec:	0f b6 d0             	movzbl %al,%edx
  8016ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	0f b6 c0             	movzbl %al,%eax
  8016f7:	29 c2                	sub    %eax,%edx
  8016f9:	89 d0                	mov    %edx,%eax
  8016fb:	eb 18                	jmp    801715 <memcmp+0x50>
		s1++, s2++;
  8016fd:	ff 45 fc             	incl   -0x4(%ebp)
  801700:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801703:	8b 45 10             	mov    0x10(%ebp),%eax
  801706:	8d 50 ff             	lea    -0x1(%eax),%edx
  801709:	89 55 10             	mov    %edx,0x10(%ebp)
  80170c:	85 c0                	test   %eax,%eax
  80170e:	75 c9                	jne    8016d9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801710:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80171d:	8b 55 08             	mov    0x8(%ebp),%edx
  801720:	8b 45 10             	mov    0x10(%ebp),%eax
  801723:	01 d0                	add    %edx,%eax
  801725:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801728:	eb 15                	jmp    80173f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8a 00                	mov    (%eax),%al
  80172f:	0f b6 d0             	movzbl %al,%edx
  801732:	8b 45 0c             	mov    0xc(%ebp),%eax
  801735:	0f b6 c0             	movzbl %al,%eax
  801738:	39 c2                	cmp    %eax,%edx
  80173a:	74 0d                	je     801749 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80173c:	ff 45 08             	incl   0x8(%ebp)
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801745:	72 e3                	jb     80172a <memfind+0x13>
  801747:	eb 01                	jmp    80174a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801749:	90                   	nop
	return (void *) s;
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801755:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80175c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801763:	eb 03                	jmp    801768 <strtol+0x19>
		s++;
  801765:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	8a 00                	mov    (%eax),%al
  80176d:	3c 20                	cmp    $0x20,%al
  80176f:	74 f4                	je     801765 <strtol+0x16>
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	8a 00                	mov    (%eax),%al
  801776:	3c 09                	cmp    $0x9,%al
  801778:	74 eb                	je     801765 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	8a 00                	mov    (%eax),%al
  80177f:	3c 2b                	cmp    $0x2b,%al
  801781:	75 05                	jne    801788 <strtol+0x39>
		s++;
  801783:	ff 45 08             	incl   0x8(%ebp)
  801786:	eb 13                	jmp    80179b <strtol+0x4c>
	else if (*s == '-')
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8a 00                	mov    (%eax),%al
  80178d:	3c 2d                	cmp    $0x2d,%al
  80178f:	75 0a                	jne    80179b <strtol+0x4c>
		s++, neg = 1;
  801791:	ff 45 08             	incl   0x8(%ebp)
  801794:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80179b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80179f:	74 06                	je     8017a7 <strtol+0x58>
  8017a1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017a5:	75 20                	jne    8017c7 <strtol+0x78>
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	8a 00                	mov    (%eax),%al
  8017ac:	3c 30                	cmp    $0x30,%al
  8017ae:	75 17                	jne    8017c7 <strtol+0x78>
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	40                   	inc    %eax
  8017b4:	8a 00                	mov    (%eax),%al
  8017b6:	3c 78                	cmp    $0x78,%al
  8017b8:	75 0d                	jne    8017c7 <strtol+0x78>
		s += 2, base = 16;
  8017ba:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017be:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017c5:	eb 28                	jmp    8017ef <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017cb:	75 15                	jne    8017e2 <strtol+0x93>
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	3c 30                	cmp    $0x30,%al
  8017d4:	75 0c                	jne    8017e2 <strtol+0x93>
		s++, base = 8;
  8017d6:	ff 45 08             	incl   0x8(%ebp)
  8017d9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017e0:	eb 0d                	jmp    8017ef <strtol+0xa0>
	else if (base == 0)
  8017e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e6:	75 07                	jne    8017ef <strtol+0xa0>
		base = 10;
  8017e8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	8a 00                	mov    (%eax),%al
  8017f4:	3c 2f                	cmp    $0x2f,%al
  8017f6:	7e 19                	jle    801811 <strtol+0xc2>
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	8a 00                	mov    (%eax),%al
  8017fd:	3c 39                	cmp    $0x39,%al
  8017ff:	7f 10                	jg     801811 <strtol+0xc2>
			dig = *s - '0';
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	8a 00                	mov    (%eax),%al
  801806:	0f be c0             	movsbl %al,%eax
  801809:	83 e8 30             	sub    $0x30,%eax
  80180c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80180f:	eb 42                	jmp    801853 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	8a 00                	mov    (%eax),%al
  801816:	3c 60                	cmp    $0x60,%al
  801818:	7e 19                	jle    801833 <strtol+0xe4>
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	8a 00                	mov    (%eax),%al
  80181f:	3c 7a                	cmp    $0x7a,%al
  801821:	7f 10                	jg     801833 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	8a 00                	mov    (%eax),%al
  801828:	0f be c0             	movsbl %al,%eax
  80182b:	83 e8 57             	sub    $0x57,%eax
  80182e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801831:	eb 20                	jmp    801853 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	8a 00                	mov    (%eax),%al
  801838:	3c 40                	cmp    $0x40,%al
  80183a:	7e 39                	jle    801875 <strtol+0x126>
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	8a 00                	mov    (%eax),%al
  801841:	3c 5a                	cmp    $0x5a,%al
  801843:	7f 30                	jg     801875 <strtol+0x126>
			dig = *s - 'A' + 10;
  801845:	8b 45 08             	mov    0x8(%ebp),%eax
  801848:	8a 00                	mov    (%eax),%al
  80184a:	0f be c0             	movsbl %al,%eax
  80184d:	83 e8 37             	sub    $0x37,%eax
  801850:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801856:	3b 45 10             	cmp    0x10(%ebp),%eax
  801859:	7d 19                	jge    801874 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80185b:	ff 45 08             	incl   0x8(%ebp)
  80185e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801861:	0f af 45 10          	imul   0x10(%ebp),%eax
  801865:	89 c2                	mov    %eax,%edx
  801867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186a:	01 d0                	add    %edx,%eax
  80186c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80186f:	e9 7b ff ff ff       	jmp    8017ef <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801874:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801875:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801879:	74 08                	je     801883 <strtol+0x134>
		*endptr = (char *) s;
  80187b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187e:	8b 55 08             	mov    0x8(%ebp),%edx
  801881:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801883:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801887:	74 07                	je     801890 <strtol+0x141>
  801889:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80188c:	f7 d8                	neg    %eax
  80188e:	eb 03                	jmp    801893 <strtol+0x144>
  801890:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <ltostr>:

void
ltostr(long value, char *str)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80189b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018a2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ad:	79 13                	jns    8018c2 <ltostr+0x2d>
	{
		neg = 1;
  8018af:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018bc:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018bf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018ca:	99                   	cltd   
  8018cb:	f7 f9                	idiv   %ecx
  8018cd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d3:	8d 50 01             	lea    0x1(%eax),%edx
  8018d6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018d9:	89 c2                	mov    %eax,%edx
  8018db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018de:	01 d0                	add    %edx,%eax
  8018e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018e3:	83 c2 30             	add    $0x30,%edx
  8018e6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018eb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018f0:	f7 e9                	imul   %ecx
  8018f2:	c1 fa 02             	sar    $0x2,%edx
  8018f5:	89 c8                	mov    %ecx,%eax
  8018f7:	c1 f8 1f             	sar    $0x1f,%eax
  8018fa:	29 c2                	sub    %eax,%edx
  8018fc:	89 d0                	mov    %edx,%eax
  8018fe:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801901:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801905:	75 bb                	jne    8018c2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801907:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80190e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801911:	48                   	dec    %eax
  801912:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801915:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801919:	74 3d                	je     801958 <ltostr+0xc3>
		start = 1 ;
  80191b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801922:	eb 34                	jmp    801958 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801924:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801927:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192a:	01 d0                	add    %edx,%eax
  80192c:	8a 00                	mov    (%eax),%al
  80192e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801931:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801934:	8b 45 0c             	mov    0xc(%ebp),%eax
  801937:	01 c2                	add    %eax,%edx
  801939:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80193c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193f:	01 c8                	add    %ecx,%eax
  801941:	8a 00                	mov    (%eax),%al
  801943:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801945:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194b:	01 c2                	add    %eax,%edx
  80194d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801950:	88 02                	mov    %al,(%edx)
		start++ ;
  801952:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801955:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80195e:	7c c4                	jl     801924 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801960:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	01 d0                	add    %edx,%eax
  801968:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80196b:	90                   	nop
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801974:	ff 75 08             	pushl  0x8(%ebp)
  801977:	e8 73 fa ff ff       	call   8013ef <strlen>
  80197c:	83 c4 04             	add    $0x4,%esp
  80197f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801982:	ff 75 0c             	pushl  0xc(%ebp)
  801985:	e8 65 fa ff ff       	call   8013ef <strlen>
  80198a:	83 c4 04             	add    $0x4,%esp
  80198d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801990:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801997:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80199e:	eb 17                	jmp    8019b7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a6:	01 c2                	add    %eax,%edx
  8019a8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	01 c8                	add    %ecx,%eax
  8019b0:	8a 00                	mov    (%eax),%al
  8019b2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019b4:	ff 45 fc             	incl   -0x4(%ebp)
  8019b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ba:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019bd:	7c e1                	jl     8019a0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019cd:	eb 1f                	jmp    8019ee <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d2:	8d 50 01             	lea    0x1(%eax),%edx
  8019d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019d8:	89 c2                	mov    %eax,%edx
  8019da:	8b 45 10             	mov    0x10(%ebp),%eax
  8019dd:	01 c2                	add    %eax,%edx
  8019df:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e5:	01 c8                	add    %ecx,%eax
  8019e7:	8a 00                	mov    (%eax),%al
  8019e9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019eb:	ff 45 f8             	incl   -0x8(%ebp)
  8019ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019f4:	7c d9                	jl     8019cf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fc:	01 d0                	add    %edx,%eax
  8019fe:	c6 00 00             	movb   $0x0,(%eax)
}
  801a01:	90                   	nop
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a07:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a10:	8b 45 14             	mov    0x14(%ebp),%eax
  801a13:	8b 00                	mov    (%eax),%eax
  801a15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a1f:	01 d0                	add    %edx,%eax
  801a21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a27:	eb 0c                	jmp    801a35 <strsplit+0x31>
			*string++ = 0;
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8d 50 01             	lea    0x1(%eax),%edx
  801a2f:	89 55 08             	mov    %edx,0x8(%ebp)
  801a32:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	8a 00                	mov    (%eax),%al
  801a3a:	84 c0                	test   %al,%al
  801a3c:	74 18                	je     801a56 <strsplit+0x52>
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	0f be c0             	movsbl %al,%eax
  801a46:	50                   	push   %eax
  801a47:	ff 75 0c             	pushl  0xc(%ebp)
  801a4a:	e8 32 fb ff ff       	call   801581 <strchr>
  801a4f:	83 c4 08             	add    $0x8,%esp
  801a52:	85 c0                	test   %eax,%eax
  801a54:	75 d3                	jne    801a29 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	8a 00                	mov    (%eax),%al
  801a5b:	84 c0                	test   %al,%al
  801a5d:	74 5a                	je     801ab9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a5f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a62:	8b 00                	mov    (%eax),%eax
  801a64:	83 f8 0f             	cmp    $0xf,%eax
  801a67:	75 07                	jne    801a70 <strsplit+0x6c>
		{
			return 0;
  801a69:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6e:	eb 66                	jmp    801ad6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a70:	8b 45 14             	mov    0x14(%ebp),%eax
  801a73:	8b 00                	mov    (%eax),%eax
  801a75:	8d 48 01             	lea    0x1(%eax),%ecx
  801a78:	8b 55 14             	mov    0x14(%ebp),%edx
  801a7b:	89 0a                	mov    %ecx,(%edx)
  801a7d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a84:	8b 45 10             	mov    0x10(%ebp),%eax
  801a87:	01 c2                	add    %eax,%edx
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a8e:	eb 03                	jmp    801a93 <strsplit+0x8f>
			string++;
  801a90:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	8a 00                	mov    (%eax),%al
  801a98:	84 c0                	test   %al,%al
  801a9a:	74 8b                	je     801a27 <strsplit+0x23>
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8a 00                	mov    (%eax),%al
  801aa1:	0f be c0             	movsbl %al,%eax
  801aa4:	50                   	push   %eax
  801aa5:	ff 75 0c             	pushl  0xc(%ebp)
  801aa8:	e8 d4 fa ff ff       	call   801581 <strchr>
  801aad:	83 c4 08             	add    $0x8,%esp
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	74 dc                	je     801a90 <strsplit+0x8c>
			string++;
	}
  801ab4:	e9 6e ff ff ff       	jmp    801a27 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ab9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801aba:	8b 45 14             	mov    0x14(%ebp),%eax
  801abd:	8b 00                	mov    (%eax),%eax
  801abf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac9:	01 d0                	add    %edx,%eax
  801acb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ad1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801ade:	83 ec 04             	sub    $0x4,%esp
  801ae1:	68 5c 4b 80 00       	push   $0x804b5c
  801ae6:	68 3f 01 00 00       	push   $0x13f
  801aeb:	68 7e 4b 80 00       	push   $0x804b7e
  801af0:	e8 a1 ed ff ff       	call   800896 <_panic>

00801af5 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801afb:	83 ec 0c             	sub    $0xc,%esp
  801afe:	ff 75 08             	pushl  0x8(%ebp)
  801b01:	e8 f8 0a 00 00       	call   8025fe <sys_sbrk>
  801b06:	83 c4 10             	add    $0x10,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b15:	75 0a                	jne    801b21 <malloc+0x16>
  801b17:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1c:	e9 07 02 00 00       	jmp    801d28 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801b21:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801b28:	8b 55 08             	mov    0x8(%ebp),%edx
  801b2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b2e:	01 d0                	add    %edx,%eax
  801b30:	48                   	dec    %eax
  801b31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b34:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b37:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3c:	f7 75 dc             	divl   -0x24(%ebp)
  801b3f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b42:	29 d0                	sub    %edx,%eax
  801b44:	c1 e8 0c             	shr    $0xc,%eax
  801b47:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801b4a:	a1 24 50 80 00       	mov    0x805024,%eax
  801b4f:	8b 40 78             	mov    0x78(%eax),%eax
  801b52:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801b57:	29 c2                	sub    %eax,%edx
  801b59:	89 d0                	mov    %edx,%eax
  801b5b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b61:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b66:	c1 e8 0c             	shr    $0xc,%eax
  801b69:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801b6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801b73:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801b7a:	77 42                	ja     801bbe <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801b7c:	e8 01 09 00 00       	call   802482 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b81:	85 c0                	test   %eax,%eax
  801b83:	74 16                	je     801b9b <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801b85:	83 ec 0c             	sub    $0xc,%esp
  801b88:	ff 75 08             	pushl  0x8(%ebp)
  801b8b:	e8 dd 0e 00 00       	call   802a6d <alloc_block_FF>
  801b90:	83 c4 10             	add    $0x10,%esp
  801b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b96:	e9 8a 01 00 00       	jmp    801d25 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b9b:	e8 13 09 00 00       	call   8024b3 <sys_isUHeapPlacementStrategyBESTFIT>
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	0f 84 7d 01 00 00    	je     801d25 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801ba8:	83 ec 0c             	sub    $0xc,%esp
  801bab:	ff 75 08             	pushl  0x8(%ebp)
  801bae:	e8 76 13 00 00       	call   802f29 <alloc_block_BF>
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bb9:	e9 67 01 00 00       	jmp    801d25 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801bbe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801bc1:	48                   	dec    %eax
  801bc2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801bc5:	0f 86 53 01 00 00    	jbe    801d1e <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801bcb:	a1 24 50 80 00       	mov    0x805024,%eax
  801bd0:	8b 40 78             	mov    0x78(%eax),%eax
  801bd3:	05 00 10 00 00       	add    $0x1000,%eax
  801bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801bdb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801be2:	e9 de 00 00 00       	jmp    801cc5 <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801be7:	a1 24 50 80 00       	mov    0x805024,%eax
  801bec:	8b 40 78             	mov    0x78(%eax),%eax
  801bef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bf2:	29 c2                	sub    %eax,%edx
  801bf4:	89 d0                	mov    %edx,%eax
  801bf6:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bfb:	c1 e8 0c             	shr    $0xc,%eax
  801bfe:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801c05:	85 c0                	test   %eax,%eax
  801c07:	0f 85 ab 00 00 00    	jne    801cb8 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c10:	05 00 10 00 00       	add    $0x1000,%eax
  801c15:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801c18:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  801c1f:	eb 47                	jmp    801c68 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801c21:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801c28:	76 0a                	jbe    801c34 <malloc+0x129>
  801c2a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2f:	e9 f4 00 00 00       	jmp    801d28 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801c34:	a1 24 50 80 00       	mov    0x805024,%eax
  801c39:	8b 40 78             	mov    0x78(%eax),%eax
  801c3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c3f:	29 c2                	sub    %eax,%edx
  801c41:	89 d0                	mov    %edx,%eax
  801c43:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c48:	c1 e8 0c             	shr    $0xc,%eax
  801c4b:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801c52:	85 c0                	test   %eax,%eax
  801c54:	74 08                	je     801c5e <malloc+0x153>
					{
						
						i = j;
  801c56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801c5c:	eb 5a                	jmp    801cb8 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801c5e:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801c65:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  801c68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c6b:	48                   	dec    %eax
  801c6c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c6f:	77 b0                	ja     801c21 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801c71:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801c78:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c7f:	eb 2f                	jmp    801cb0 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801c81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c84:	c1 e0 0c             	shl    $0xc,%eax
  801c87:	89 c2                	mov    %eax,%edx
  801c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8c:	01 c2                	add    %eax,%edx
  801c8e:	a1 24 50 80 00       	mov    0x805024,%eax
  801c93:	8b 40 78             	mov    0x78(%eax),%eax
  801c96:	29 c2                	sub    %eax,%edx
  801c98:	89 d0                	mov    %edx,%eax
  801c9a:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c9f:	c1 e8 0c             	shr    $0xc,%eax
  801ca2:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  801ca9:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801cad:	ff 45 e0             	incl   -0x20(%ebp)
  801cb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cb3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801cb6:	72 c9                	jb     801c81 <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  801cb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cbc:	75 16                	jne    801cd4 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801cbe:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801cc5:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801ccc:	0f 86 15 ff ff ff    	jbe    801be7 <malloc+0xdc>
  801cd2:	eb 01                	jmp    801cd5 <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  801cd4:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801cd5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cd9:	75 07                	jne    801ce2 <malloc+0x1d7>
  801cdb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce0:	eb 46                	jmp    801d28 <malloc+0x21d>
		ptr = (void*)i;
  801ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801ce8:	a1 24 50 80 00       	mov    0x805024,%eax
  801ced:	8b 40 78             	mov    0x78(%eax),%eax
  801cf0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cf3:	29 c2                	sub    %eax,%edx
  801cf5:	89 d0                	mov    %edx,%eax
  801cf7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cfc:	c1 e8 0c             	shr    $0xc,%eax
  801cff:	89 c2                	mov    %eax,%edx
  801d01:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d04:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801d0b:	83 ec 08             	sub    $0x8,%esp
  801d0e:	ff 75 08             	pushl  0x8(%ebp)
  801d11:	ff 75 f0             	pushl  -0x10(%ebp)
  801d14:	e8 1c 09 00 00       	call   802635 <sys_allocate_user_mem>
  801d19:	83 c4 10             	add    $0x10,%esp
  801d1c:	eb 07                	jmp    801d25 <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  801d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d23:	eb 03                	jmp    801d28 <malloc+0x21d>
	}
	return ptr;
  801d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801d30:	a1 24 50 80 00       	mov    0x805024,%eax
  801d35:	8b 40 78             	mov    0x78(%eax),%eax
  801d38:	05 00 10 00 00       	add    $0x1000,%eax
  801d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801d40:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801d47:	a1 24 50 80 00       	mov    0x805024,%eax
  801d4c:	8b 50 78             	mov    0x78(%eax),%edx
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	39 c2                	cmp    %eax,%edx
  801d54:	76 24                	jbe    801d7a <free+0x50>
		size = get_block_size(va);
  801d56:	83 ec 0c             	sub    $0xc,%esp
  801d59:	ff 75 08             	pushl  0x8(%ebp)
  801d5c:	e8 8c 09 00 00       	call   8026ed <get_block_size>
  801d61:	83 c4 10             	add    $0x10,%esp
  801d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d67:	83 ec 0c             	sub    $0xc,%esp
  801d6a:	ff 75 08             	pushl  0x8(%ebp)
  801d6d:	e8 9c 1b 00 00       	call   80390e <free_block>
  801d72:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801d75:	e9 ac 00 00 00       	jmp    801e26 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d80:	0f 82 89 00 00 00    	jb     801e0f <free+0xe5>
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801d8e:	77 7f                	ja     801e0f <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801d90:	8b 55 08             	mov    0x8(%ebp),%edx
  801d93:	a1 24 50 80 00       	mov    0x805024,%eax
  801d98:	8b 40 78             	mov    0x78(%eax),%eax
  801d9b:	29 c2                	sub    %eax,%edx
  801d9d:	89 d0                	mov    %edx,%eax
  801d9f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801da4:	c1 e8 0c             	shr    $0xc,%eax
  801da7:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801dae:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801db4:	c1 e0 0c             	shl    $0xc,%eax
  801db7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801dba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801dc1:	eb 42                	jmp    801e05 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc6:	c1 e0 0c             	shl    $0xc,%eax
  801dc9:	89 c2                	mov    %eax,%edx
  801dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dce:	01 c2                	add    %eax,%edx
  801dd0:	a1 24 50 80 00       	mov    0x805024,%eax
  801dd5:	8b 40 78             	mov    0x78(%eax),%eax
  801dd8:	29 c2                	sub    %eax,%edx
  801dda:	89 d0                	mov    %edx,%eax
  801ddc:	2d 00 10 00 00       	sub    $0x1000,%eax
  801de1:	c1 e8 0c             	shr    $0xc,%eax
  801de4:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801deb:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801def:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	83 ec 08             	sub    $0x8,%esp
  801df8:	52                   	push   %edx
  801df9:	50                   	push   %eax
  801dfa:	e8 1a 08 00 00       	call   802619 <sys_free_user_mem>
  801dff:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801e02:	ff 45 f4             	incl   -0xc(%ebp)
  801e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e08:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801e0b:	72 b6                	jb     801dc3 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801e0d:	eb 17                	jmp    801e26 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801e0f:	83 ec 04             	sub    $0x4,%esp
  801e12:	68 8c 4b 80 00       	push   $0x804b8c
  801e17:	68 87 00 00 00       	push   $0x87
  801e1c:	68 b6 4b 80 00       	push   $0x804bb6
  801e21:	e8 70 ea ff ff       	call   800896 <_panic>
	}
}
  801e26:	90                   	nop
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 28             	sub    $0x28,%esp
  801e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e32:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801e35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e39:	75 0a                	jne    801e45 <smalloc+0x1c>
  801e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e40:	e9 87 00 00 00       	jmp    801ecc <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e58:	39 d0                	cmp    %edx,%eax
  801e5a:	73 02                	jae    801e5e <smalloc+0x35>
  801e5c:	89 d0                	mov    %edx,%eax
  801e5e:	83 ec 0c             	sub    $0xc,%esp
  801e61:	50                   	push   %eax
  801e62:	e8 a4 fc ff ff       	call   801b0b <malloc>
  801e67:	83 c4 10             	add    $0x10,%esp
  801e6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801e6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e71:	75 07                	jne    801e7a <smalloc+0x51>
  801e73:	b8 00 00 00 00       	mov    $0x0,%eax
  801e78:	eb 52                	jmp    801ecc <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e7a:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e7e:	ff 75 ec             	pushl  -0x14(%ebp)
  801e81:	50                   	push   %eax
  801e82:	ff 75 0c             	pushl  0xc(%ebp)
  801e85:	ff 75 08             	pushl  0x8(%ebp)
  801e88:	e8 93 03 00 00       	call   802220 <sys_createSharedObject>
  801e8d:	83 c4 10             	add    $0x10,%esp
  801e90:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e93:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e97:	74 06                	je     801e9f <smalloc+0x76>
  801e99:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e9d:	75 07                	jne    801ea6 <smalloc+0x7d>
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea4:	eb 26                	jmp    801ecc <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801ea6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ea9:	a1 24 50 80 00       	mov    0x805024,%eax
  801eae:	8b 40 78             	mov    0x78(%eax),%eax
  801eb1:	29 c2                	sub    %eax,%edx
  801eb3:	89 d0                	mov    %edx,%eax
  801eb5:	2d 00 10 00 00       	sub    $0x1000,%eax
  801eba:	c1 e8 0c             	shr    $0xc,%eax
  801ebd:	89 c2                	mov    %eax,%edx
  801ebf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ec2:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ed4:	83 ec 08             	sub    $0x8,%esp
  801ed7:	ff 75 0c             	pushl  0xc(%ebp)
  801eda:	ff 75 08             	pushl  0x8(%ebp)
  801edd:	e8 68 03 00 00       	call   80224a <sys_getSizeOfSharedObject>
  801ee2:	83 c4 10             	add    $0x10,%esp
  801ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801ee8:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801eec:	75 07                	jne    801ef5 <sget+0x27>
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef3:	eb 7f                	jmp    801f74 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801efb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f08:	39 d0                	cmp    %edx,%eax
  801f0a:	73 02                	jae    801f0e <sget+0x40>
  801f0c:	89 d0                	mov    %edx,%eax
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	50                   	push   %eax
  801f12:	e8 f4 fb ff ff       	call   801b0b <malloc>
  801f17:	83 c4 10             	add    $0x10,%esp
  801f1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801f1d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f21:	75 07                	jne    801f2a <sget+0x5c>
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
  801f28:	eb 4a                	jmp    801f74 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801f2a:	83 ec 04             	sub    $0x4,%esp
  801f2d:	ff 75 e8             	pushl  -0x18(%ebp)
  801f30:	ff 75 0c             	pushl  0xc(%ebp)
  801f33:	ff 75 08             	pushl  0x8(%ebp)
  801f36:	e8 2c 03 00 00       	call   802267 <sys_getSharedObject>
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801f41:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f44:	a1 24 50 80 00       	mov    0x805024,%eax
  801f49:	8b 40 78             	mov    0x78(%eax),%eax
  801f4c:	29 c2                	sub    %eax,%edx
  801f4e:	89 d0                	mov    %edx,%eax
  801f50:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f55:	c1 e8 0c             	shr    $0xc,%eax
  801f58:	89 c2                	mov    %eax,%edx
  801f5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f5d:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801f64:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801f68:	75 07                	jne    801f71 <sget+0xa3>
  801f6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6f:	eb 03                	jmp    801f74 <sget+0xa6>
	return ptr;
  801f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801f7c:	8b 55 08             	mov    0x8(%ebp),%edx
  801f7f:	a1 24 50 80 00       	mov    0x805024,%eax
  801f84:	8b 40 78             	mov    0x78(%eax),%eax
  801f87:	29 c2                	sub    %eax,%edx
  801f89:	89 d0                	mov    %edx,%eax
  801f8b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f90:	c1 e8 0c             	shr    $0xc,%eax
  801f93:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801f9d:	83 ec 08             	sub    $0x8,%esp
  801fa0:	ff 75 08             	pushl  0x8(%ebp)
  801fa3:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa6:	e8 db 02 00 00       	call   802286 <sys_freeSharedObject>
  801fab:	83 c4 10             	add    $0x10,%esp
  801fae:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801fb1:	90                   	nop
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fba:	83 ec 04             	sub    $0x4,%esp
  801fbd:	68 c4 4b 80 00       	push   $0x804bc4
  801fc2:	68 e4 00 00 00       	push   $0xe4
  801fc7:	68 b6 4b 80 00       	push   $0x804bb6
  801fcc:	e8 c5 e8 ff ff       	call   800896 <_panic>

00801fd1 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fd7:	83 ec 04             	sub    $0x4,%esp
  801fda:	68 ea 4b 80 00       	push   $0x804bea
  801fdf:	68 f0 00 00 00       	push   $0xf0
  801fe4:	68 b6 4b 80 00       	push   $0x804bb6
  801fe9:	e8 a8 e8 ff ff       	call   800896 <_panic>

00801fee <shrink>:

}
void shrink(uint32 newSize)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ff4:	83 ec 04             	sub    $0x4,%esp
  801ff7:	68 ea 4b 80 00       	push   $0x804bea
  801ffc:	68 f5 00 00 00       	push   $0xf5
  802001:	68 b6 4b 80 00       	push   $0x804bb6
  802006:	e8 8b e8 ff ff       	call   800896 <_panic>

0080200b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802011:	83 ec 04             	sub    $0x4,%esp
  802014:	68 ea 4b 80 00       	push   $0x804bea
  802019:	68 fa 00 00 00       	push   $0xfa
  80201e:	68 b6 4b 80 00       	push   $0x804bb6
  802023:	e8 6e e8 ff ff       	call   800896 <_panic>

00802028 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	57                   	push   %edi
  80202c:	56                   	push   %esi
  80202d:	53                   	push   %ebx
  80202e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	8b 55 0c             	mov    0xc(%ebp),%edx
  802037:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80203a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80203d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802040:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802043:	cd 30                	int    $0x30
  802045:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802048:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80204b:	83 c4 10             	add    $0x10,%esp
  80204e:	5b                   	pop    %ebx
  80204f:	5e                   	pop    %esi
  802050:	5f                   	pop    %edi
  802051:	5d                   	pop    %ebp
  802052:	c3                   	ret    

00802053 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	8b 45 10             	mov    0x10(%ebp),%eax
  80205c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80205f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	52                   	push   %edx
  80206b:	ff 75 0c             	pushl  0xc(%ebp)
  80206e:	50                   	push   %eax
  80206f:	6a 00                	push   $0x0
  802071:	e8 b2 ff ff ff       	call   802028 <syscall>
  802076:	83 c4 18             	add    $0x18,%esp
}
  802079:	90                   	nop
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <sys_cgetc>:

int
sys_cgetc(void)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 02                	push   $0x2
  80208b:	e8 98 ff ff ff       	call   802028 <syscall>
  802090:	83 c4 18             	add    $0x18,%esp
}
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 03                	push   $0x3
  8020a4:	e8 7f ff ff ff       	call   802028 <syscall>
  8020a9:	83 c4 18             	add    $0x18,%esp
}
  8020ac:	90                   	nop
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 04                	push   $0x4
  8020be:	e8 65 ff ff ff       	call   802028 <syscall>
  8020c3:	83 c4 18             	add    $0x18,%esp
}
  8020c6:	90                   	nop
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	52                   	push   %edx
  8020d9:	50                   	push   %eax
  8020da:	6a 08                	push   $0x8
  8020dc:	e8 47 ff ff ff       	call   802028 <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	56                   	push   %esi
  8020ea:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020eb:	8b 75 18             	mov    0x18(%ebp),%esi
  8020ee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	56                   	push   %esi
  8020fb:	53                   	push   %ebx
  8020fc:	51                   	push   %ecx
  8020fd:	52                   	push   %edx
  8020fe:	50                   	push   %eax
  8020ff:	6a 09                	push   $0x9
  802101:	e8 22 ff ff ff       	call   802028 <syscall>
  802106:	83 c4 18             	add    $0x18,%esp
}
  802109:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80210c:	5b                   	pop    %ebx
  80210d:	5e                   	pop    %esi
  80210e:	5d                   	pop    %ebp
  80210f:	c3                   	ret    

00802110 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802113:	8b 55 0c             	mov    0xc(%ebp),%edx
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	52                   	push   %edx
  802120:	50                   	push   %eax
  802121:	6a 0a                	push   $0xa
  802123:	e8 00 ff ff ff       	call   802028 <syscall>
  802128:	83 c4 18             	add    $0x18,%esp
}
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	ff 75 0c             	pushl  0xc(%ebp)
  802139:	ff 75 08             	pushl  0x8(%ebp)
  80213c:	6a 0b                	push   $0xb
  80213e:	e8 e5 fe ff ff       	call   802028 <syscall>
  802143:	83 c4 18             	add    $0x18,%esp
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 0c                	push   $0xc
  802157:	e8 cc fe ff ff       	call   802028 <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 0d                	push   $0xd
  802170:	e8 b3 fe ff ff       	call   802028 <syscall>
  802175:	83 c4 18             	add    $0x18,%esp
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 0e                	push   $0xe
  802189:	e8 9a fe ff ff       	call   802028 <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
}
  802191:	c9                   	leave  
  802192:	c3                   	ret    

00802193 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 0f                	push   $0xf
  8021a2:	e8 81 fe ff ff       	call   802028 <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	ff 75 08             	pushl  0x8(%ebp)
  8021ba:	6a 10                	push   $0x10
  8021bc:	e8 67 fe ff ff       	call   802028 <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 11                	push   $0x11
  8021d5:	e8 4e fe ff ff       	call   802028 <syscall>
  8021da:	83 c4 18             	add    $0x18,%esp
}
  8021dd:	90                   	nop
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <sys_cputc>:

void
sys_cputc(const char c)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	83 ec 04             	sub    $0x4,%esp
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021ec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	50                   	push   %eax
  8021f9:	6a 01                	push   $0x1
  8021fb:	e8 28 fe ff ff       	call   802028 <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
}
  802203:	90                   	nop
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 14                	push   $0x14
  802215:	e8 0e fe ff ff       	call   802028 <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
}
  80221d:	90                   	nop
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
  802223:	83 ec 04             	sub    $0x4,%esp
  802226:	8b 45 10             	mov    0x10(%ebp),%eax
  802229:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80222c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80222f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	6a 00                	push   $0x0
  802238:	51                   	push   %ecx
  802239:	52                   	push   %edx
  80223a:	ff 75 0c             	pushl  0xc(%ebp)
  80223d:	50                   	push   %eax
  80223e:	6a 15                	push   $0x15
  802240:	e8 e3 fd ff ff       	call   802028 <syscall>
  802245:	83 c4 18             	add    $0x18,%esp
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80224d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	52                   	push   %edx
  80225a:	50                   	push   %eax
  80225b:	6a 16                	push   $0x16
  80225d:	e8 c6 fd ff ff       	call   802028 <syscall>
  802262:	83 c4 18             	add    $0x18,%esp
}
  802265:	c9                   	leave  
  802266:	c3                   	ret    

00802267 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80226a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80226d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802270:	8b 45 08             	mov    0x8(%ebp),%eax
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	51                   	push   %ecx
  802278:	52                   	push   %edx
  802279:	50                   	push   %eax
  80227a:	6a 17                	push   $0x17
  80227c:	e8 a7 fd ff ff       	call   802028 <syscall>
  802281:	83 c4 18             	add    $0x18,%esp
}
  802284:	c9                   	leave  
  802285:	c3                   	ret    

00802286 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802286:	55                   	push   %ebp
  802287:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802289:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228c:	8b 45 08             	mov    0x8(%ebp),%eax
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	52                   	push   %edx
  802296:	50                   	push   %eax
  802297:	6a 18                	push   $0x18
  802299:	e8 8a fd ff ff       	call   802028 <syscall>
  80229e:	83 c4 18             	add    $0x18,%esp
}
  8022a1:	c9                   	leave  
  8022a2:	c3                   	ret    

008022a3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022a3:	55                   	push   %ebp
  8022a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	6a 00                	push   $0x0
  8022ab:	ff 75 14             	pushl  0x14(%ebp)
  8022ae:	ff 75 10             	pushl  0x10(%ebp)
  8022b1:	ff 75 0c             	pushl  0xc(%ebp)
  8022b4:	50                   	push   %eax
  8022b5:	6a 19                	push   $0x19
  8022b7:	e8 6c fd ff ff       	call   802028 <syscall>
  8022bc:	83 c4 18             	add    $0x18,%esp
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	50                   	push   %eax
  8022d0:	6a 1a                	push   $0x1a
  8022d2:	e8 51 fd ff ff       	call   802028 <syscall>
  8022d7:	83 c4 18             	add    $0x18,%esp
}
  8022da:	90                   	nop
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	50                   	push   %eax
  8022ec:	6a 1b                	push   $0x1b
  8022ee:	e8 35 fd ff ff       	call   802028 <syscall>
  8022f3:	83 c4 18             	add    $0x18,%esp
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 05                	push   $0x5
  802307:	e8 1c fd ff ff       	call   802028 <syscall>
  80230c:	83 c4 18             	add    $0x18,%esp
}
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 06                	push   $0x6
  802320:	e8 03 fd ff ff       	call   802028 <syscall>
  802325:	83 c4 18             	add    $0x18,%esp
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 07                	push   $0x7
  802339:	e8 ea fc ff ff       	call   802028 <syscall>
  80233e:	83 c4 18             	add    $0x18,%esp
}
  802341:	c9                   	leave  
  802342:	c3                   	ret    

00802343 <sys_exit_env>:


void sys_exit_env(void)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 1c                	push   $0x1c
  802352:	e8 d1 fc ff ff       	call   802028 <syscall>
  802357:	83 c4 18             	add    $0x18,%esp
}
  80235a:	90                   	nop
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802363:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802366:	8d 50 04             	lea    0x4(%eax),%edx
  802369:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	52                   	push   %edx
  802373:	50                   	push   %eax
  802374:	6a 1d                	push   $0x1d
  802376:	e8 ad fc ff ff       	call   802028 <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
	return result;
  80237e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802381:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802384:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802387:	89 01                	mov    %eax,(%ecx)
  802389:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	c9                   	leave  
  802390:	c2 04 00             	ret    $0x4

00802393 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	ff 75 10             	pushl  0x10(%ebp)
  80239d:	ff 75 0c             	pushl  0xc(%ebp)
  8023a0:	ff 75 08             	pushl  0x8(%ebp)
  8023a3:	6a 13                	push   $0x13
  8023a5:	e8 7e fc ff ff       	call   802028 <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ad:	90                   	nop
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 1e                	push   $0x1e
  8023bf:	e8 64 fc ff ff       	call   802028 <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
}
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	83 ec 04             	sub    $0x4,%esp
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023d5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	50                   	push   %eax
  8023e2:	6a 1f                	push   $0x1f
  8023e4:	e8 3f fc ff ff       	call   802028 <syscall>
  8023e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ec:	90                   	nop
}
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <rsttst>:
void rsttst()
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 21                	push   $0x21
  8023fe:	e8 25 fc ff ff       	call   802028 <syscall>
  802403:	83 c4 18             	add    $0x18,%esp
	return ;
  802406:	90                   	nop
}
  802407:	c9                   	leave  
  802408:	c3                   	ret    

00802409 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
  80240c:	83 ec 04             	sub    $0x4,%esp
  80240f:	8b 45 14             	mov    0x14(%ebp),%eax
  802412:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802415:	8b 55 18             	mov    0x18(%ebp),%edx
  802418:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80241c:	52                   	push   %edx
  80241d:	50                   	push   %eax
  80241e:	ff 75 10             	pushl  0x10(%ebp)
  802421:	ff 75 0c             	pushl  0xc(%ebp)
  802424:	ff 75 08             	pushl  0x8(%ebp)
  802427:	6a 20                	push   $0x20
  802429:	e8 fa fb ff ff       	call   802028 <syscall>
  80242e:	83 c4 18             	add    $0x18,%esp
	return ;
  802431:	90                   	nop
}
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <chktst>:
void chktst(uint32 n)
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	ff 75 08             	pushl  0x8(%ebp)
  802442:	6a 22                	push   $0x22
  802444:	e8 df fb ff ff       	call   802028 <syscall>
  802449:	83 c4 18             	add    $0x18,%esp
	return ;
  80244c:	90                   	nop
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <inctst>:

void inctst()
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 23                	push   $0x23
  80245e:	e8 c5 fb ff ff       	call   802028 <syscall>
  802463:	83 c4 18             	add    $0x18,%esp
	return ;
  802466:	90                   	nop
}
  802467:	c9                   	leave  
  802468:	c3                   	ret    

00802469 <gettst>:
uint32 gettst()
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 24                	push   $0x24
  802478:	e8 ab fb ff ff       	call   802028 <syscall>
  80247d:	83 c4 18             	add    $0x18,%esp
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 25                	push   $0x25
  802494:	e8 8f fb ff ff       	call   802028 <syscall>
  802499:	83 c4 18             	add    $0x18,%esp
  80249c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80249f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024a3:	75 07                	jne    8024ac <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8024aa:	eb 05                	jmp    8024b1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
  8024b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 25                	push   $0x25
  8024c5:	e8 5e fb ff ff       	call   802028 <syscall>
  8024ca:	83 c4 18             	add    $0x18,%esp
  8024cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024d0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024d4:	75 07                	jne    8024dd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024db:	eb 05                	jmp    8024e2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e2:	c9                   	leave  
  8024e3:	c3                   	ret    

008024e4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
  8024e7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 25                	push   $0x25
  8024f6:	e8 2d fb ff ff       	call   802028 <syscall>
  8024fb:	83 c4 18             	add    $0x18,%esp
  8024fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802501:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802505:	75 07                	jne    80250e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802507:	b8 01 00 00 00       	mov    $0x1,%eax
  80250c:	eb 05                	jmp    802513 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80250e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 00                	push   $0x0
  802525:	6a 25                	push   $0x25
  802527:	e8 fc fa ff ff       	call   802028 <syscall>
  80252c:	83 c4 18             	add    $0x18,%esp
  80252f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802532:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802536:	75 07                	jne    80253f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802538:	b8 01 00 00 00       	mov    $0x1,%eax
  80253d:	eb 05                	jmp    802544 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80253f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	ff 75 08             	pushl  0x8(%ebp)
  802554:	6a 26                	push   $0x26
  802556:	e8 cd fa ff ff       	call   802028 <syscall>
  80255b:	83 c4 18             	add    $0x18,%esp
	return ;
  80255e:	90                   	nop
}
  80255f:	c9                   	leave  
  802560:	c3                   	ret    

00802561 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
  802564:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802565:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802568:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80256b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80256e:	8b 45 08             	mov    0x8(%ebp),%eax
  802571:	6a 00                	push   $0x0
  802573:	53                   	push   %ebx
  802574:	51                   	push   %ecx
  802575:	52                   	push   %edx
  802576:	50                   	push   %eax
  802577:	6a 27                	push   $0x27
  802579:	e8 aa fa ff ff       	call   802028 <syscall>
  80257e:	83 c4 18             	add    $0x18,%esp
}
  802581:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802584:	c9                   	leave  
  802585:	c3                   	ret    

00802586 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802589:	8b 55 0c             	mov    0xc(%ebp),%edx
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	52                   	push   %edx
  802596:	50                   	push   %eax
  802597:	6a 28                	push   $0x28
  802599:	e8 8a fa ff ff       	call   802028 <syscall>
  80259e:	83 c4 18             	add    $0x18,%esp
}
  8025a1:	c9                   	leave  
  8025a2:	c3                   	ret    

008025a3 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8025a3:	55                   	push   %ebp
  8025a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8025a6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8025af:	6a 00                	push   $0x0
  8025b1:	51                   	push   %ecx
  8025b2:	ff 75 10             	pushl  0x10(%ebp)
  8025b5:	52                   	push   %edx
  8025b6:	50                   	push   %eax
  8025b7:	6a 29                	push   $0x29
  8025b9:	e8 6a fa ff ff       	call   802028 <syscall>
  8025be:	83 c4 18             	add    $0x18,%esp
}
  8025c1:	c9                   	leave  
  8025c2:	c3                   	ret    

008025c3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	ff 75 10             	pushl  0x10(%ebp)
  8025cd:	ff 75 0c             	pushl  0xc(%ebp)
  8025d0:	ff 75 08             	pushl  0x8(%ebp)
  8025d3:	6a 12                	push   $0x12
  8025d5:	e8 4e fa ff ff       	call   802028 <syscall>
  8025da:	83 c4 18             	add    $0x18,%esp
	return ;
  8025dd:	90                   	nop
}
  8025de:	c9                   	leave  
  8025df:	c3                   	ret    

008025e0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8025e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	52                   	push   %edx
  8025f0:	50                   	push   %eax
  8025f1:	6a 2a                	push   $0x2a
  8025f3:	e8 30 fa ff ff       	call   802028 <syscall>
  8025f8:	83 c4 18             	add    $0x18,%esp
	return;
  8025fb:	90                   	nop
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	50                   	push   %eax
  80260d:	6a 2b                	push   $0x2b
  80260f:	e8 14 fa ff ff       	call   802028 <syscall>
  802614:	83 c4 18             	add    $0x18,%esp
}
  802617:	c9                   	leave  
  802618:	c3                   	ret    

00802619 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	ff 75 0c             	pushl  0xc(%ebp)
  802625:	ff 75 08             	pushl  0x8(%ebp)
  802628:	6a 2c                	push   $0x2c
  80262a:	e8 f9 f9 ff ff       	call   802028 <syscall>
  80262f:	83 c4 18             	add    $0x18,%esp
	return;
  802632:	90                   	nop
}
  802633:	c9                   	leave  
  802634:	c3                   	ret    

00802635 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	ff 75 0c             	pushl  0xc(%ebp)
  802641:	ff 75 08             	pushl  0x8(%ebp)
  802644:	6a 2d                	push   $0x2d
  802646:	e8 dd f9 ff ff       	call   802028 <syscall>
  80264b:	83 c4 18             	add    $0x18,%esp
	return;
  80264e:	90                   	nop
}
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 2e                	push   $0x2e
  802663:	e8 c0 f9 ff ff       	call   802028 <syscall>
  802668:	83 c4 18             	add    $0x18,%esp
  80266b:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  80266e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  802676:	8b 45 08             	mov    0x8(%ebp),%eax
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	50                   	push   %eax
  802682:	6a 2f                	push   $0x2f
  802684:	e8 9f f9 ff ff       	call   802028 <syscall>
  802689:	83 c4 18             	add    $0x18,%esp
	return;
  80268c:	90                   	nop
}
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  802692:	8b 55 0c             	mov    0xc(%ebp),%edx
  802695:	8b 45 08             	mov    0x8(%ebp),%eax
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	52                   	push   %edx
  80269f:	50                   	push   %eax
  8026a0:	6a 30                	push   $0x30
  8026a2:	e8 81 f9 ff ff       	call   802028 <syscall>
  8026a7:	83 c4 18             	add    $0x18,%esp
	return;
  8026aa:	90                   	nop
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	50                   	push   %eax
  8026bf:	6a 31                	push   $0x31
  8026c1:	e8 62 f9 ff ff       	call   802028 <syscall>
  8026c6:	83 c4 18             	add    $0x18,%esp
  8026c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8026cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  8026d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	50                   	push   %eax
  8026e0:	6a 32                	push   $0x32
  8026e2:	e8 41 f9 ff ff       	call   802028 <syscall>
  8026e7:	83 c4 18             	add    $0x18,%esp
	return;
  8026ea:	90                   	nop
}
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
  8026f0:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f6:	83 e8 04             	sub    $0x4,%eax
  8026f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8026fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026ff:	8b 00                	mov    (%eax),%eax
  802701:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	83 e8 04             	sub    $0x4,%eax
  802712:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802715:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802718:	8b 00                	mov    (%eax),%eax
  80271a:	83 e0 01             	and    $0x1,%eax
  80271d:	85 c0                	test   %eax,%eax
  80271f:	0f 94 c0             	sete   %al
}
  802722:	c9                   	leave  
  802723:	c3                   	ret    

00802724 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
  802727:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80272a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802731:	8b 45 0c             	mov    0xc(%ebp),%eax
  802734:	83 f8 02             	cmp    $0x2,%eax
  802737:	74 2b                	je     802764 <alloc_block+0x40>
  802739:	83 f8 02             	cmp    $0x2,%eax
  80273c:	7f 07                	jg     802745 <alloc_block+0x21>
  80273e:	83 f8 01             	cmp    $0x1,%eax
  802741:	74 0e                	je     802751 <alloc_block+0x2d>
  802743:	eb 58                	jmp    80279d <alloc_block+0x79>
  802745:	83 f8 03             	cmp    $0x3,%eax
  802748:	74 2d                	je     802777 <alloc_block+0x53>
  80274a:	83 f8 04             	cmp    $0x4,%eax
  80274d:	74 3b                	je     80278a <alloc_block+0x66>
  80274f:	eb 4c                	jmp    80279d <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802751:	83 ec 0c             	sub    $0xc,%esp
  802754:	ff 75 08             	pushl  0x8(%ebp)
  802757:	e8 11 03 00 00       	call   802a6d <alloc_block_FF>
  80275c:	83 c4 10             	add    $0x10,%esp
  80275f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802762:	eb 4a                	jmp    8027ae <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802764:	83 ec 0c             	sub    $0xc,%esp
  802767:	ff 75 08             	pushl  0x8(%ebp)
  80276a:	e8 c7 19 00 00       	call   804136 <alloc_block_NF>
  80276f:	83 c4 10             	add    $0x10,%esp
  802772:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802775:	eb 37                	jmp    8027ae <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802777:	83 ec 0c             	sub    $0xc,%esp
  80277a:	ff 75 08             	pushl  0x8(%ebp)
  80277d:	e8 a7 07 00 00       	call   802f29 <alloc_block_BF>
  802782:	83 c4 10             	add    $0x10,%esp
  802785:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802788:	eb 24                	jmp    8027ae <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80278a:	83 ec 0c             	sub    $0xc,%esp
  80278d:	ff 75 08             	pushl  0x8(%ebp)
  802790:	e8 84 19 00 00       	call   804119 <alloc_block_WF>
  802795:	83 c4 10             	add    $0x10,%esp
  802798:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80279b:	eb 11                	jmp    8027ae <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80279d:	83 ec 0c             	sub    $0xc,%esp
  8027a0:	68 fc 4b 80 00       	push   $0x804bfc
  8027a5:	e8 a9 e3 ff ff       	call   800b53 <cprintf>
  8027aa:	83 c4 10             	add    $0x10,%esp
		break;
  8027ad:	90                   	nop
	}
	return va;
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8027b1:	c9                   	leave  
  8027b2:	c3                   	ret    

008027b3 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8027b3:	55                   	push   %ebp
  8027b4:	89 e5                	mov    %esp,%ebp
  8027b6:	53                   	push   %ebx
  8027b7:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8027ba:	83 ec 0c             	sub    $0xc,%esp
  8027bd:	68 1c 4c 80 00       	push   $0x804c1c
  8027c2:	e8 8c e3 ff ff       	call   800b53 <cprintf>
  8027c7:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8027ca:	83 ec 0c             	sub    $0xc,%esp
  8027cd:	68 47 4c 80 00       	push   $0x804c47
  8027d2:	e8 7c e3 ff ff       	call   800b53 <cprintf>
  8027d7:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e0:	eb 37                	jmp    802819 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8027e2:	83 ec 0c             	sub    $0xc,%esp
  8027e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8027e8:	e8 19 ff ff ff       	call   802706 <is_free_block>
  8027ed:	83 c4 10             	add    $0x10,%esp
  8027f0:	0f be d8             	movsbl %al,%ebx
  8027f3:	83 ec 0c             	sub    $0xc,%esp
  8027f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8027f9:	e8 ef fe ff ff       	call   8026ed <get_block_size>
  8027fe:	83 c4 10             	add    $0x10,%esp
  802801:	83 ec 04             	sub    $0x4,%esp
  802804:	53                   	push   %ebx
  802805:	50                   	push   %eax
  802806:	68 5f 4c 80 00       	push   $0x804c5f
  80280b:	e8 43 e3 ff ff       	call   800b53 <cprintf>
  802810:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802813:	8b 45 10             	mov    0x10(%ebp),%eax
  802816:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802819:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281d:	74 07                	je     802826 <print_blocks_list+0x73>
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 00                	mov    (%eax),%eax
  802824:	eb 05                	jmp    80282b <print_blocks_list+0x78>
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
  80282b:	89 45 10             	mov    %eax,0x10(%ebp)
  80282e:	8b 45 10             	mov    0x10(%ebp),%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	75 ad                	jne    8027e2 <print_blocks_list+0x2f>
  802835:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802839:	75 a7                	jne    8027e2 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80283b:	83 ec 0c             	sub    $0xc,%esp
  80283e:	68 1c 4c 80 00       	push   $0x804c1c
  802843:	e8 0b e3 ff ff       	call   800b53 <cprintf>
  802848:	83 c4 10             	add    $0x10,%esp

}
  80284b:	90                   	nop
  80284c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
  802854:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802857:	8b 45 0c             	mov    0xc(%ebp),%eax
  80285a:	83 e0 01             	and    $0x1,%eax
  80285d:	85 c0                	test   %eax,%eax
  80285f:	74 03                	je     802864 <initialize_dynamic_allocator+0x13>
  802861:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802864:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802868:	0f 84 c7 01 00 00    	je     802a35 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80286e:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802875:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802878:	8b 55 08             	mov    0x8(%ebp),%edx
  80287b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80287e:	01 d0                	add    %edx,%eax
  802880:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802885:	0f 87 ad 01 00 00    	ja     802a38 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	85 c0                	test   %eax,%eax
  802890:	0f 89 a5 01 00 00    	jns    802a3b <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802896:	8b 55 08             	mov    0x8(%ebp),%edx
  802899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80289c:	01 d0                	add    %edx,%eax
  80289e:	83 e8 04             	sub    $0x4,%eax
  8028a1:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8028a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8028ad:	a1 30 50 80 00       	mov    0x805030,%eax
  8028b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b5:	e9 87 00 00 00       	jmp    802941 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8028ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028be:	75 14                	jne    8028d4 <initialize_dynamic_allocator+0x83>
  8028c0:	83 ec 04             	sub    $0x4,%esp
  8028c3:	68 77 4c 80 00       	push   $0x804c77
  8028c8:	6a 79                	push   $0x79
  8028ca:	68 95 4c 80 00       	push   $0x804c95
  8028cf:	e8 c2 df ff ff       	call   800896 <_panic>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	74 10                	je     8028ed <initialize_dynamic_allocator+0x9c>
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 00                	mov    (%eax),%eax
  8028e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e5:	8b 52 04             	mov    0x4(%edx),%edx
  8028e8:	89 50 04             	mov    %edx,0x4(%eax)
  8028eb:	eb 0b                	jmp    8028f8 <initialize_dynamic_allocator+0xa7>
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 40 04             	mov    0x4(%eax),%eax
  8028f3:	a3 34 50 80 00       	mov    %eax,0x805034
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 40 04             	mov    0x4(%eax),%eax
  8028fe:	85 c0                	test   %eax,%eax
  802900:	74 0f                	je     802911 <initialize_dynamic_allocator+0xc0>
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	8b 40 04             	mov    0x4(%eax),%eax
  802908:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290b:	8b 12                	mov    (%edx),%edx
  80290d:	89 10                	mov    %edx,(%eax)
  80290f:	eb 0a                	jmp    80291b <initialize_dynamic_allocator+0xca>
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 00                	mov    (%eax),%eax
  802916:	a3 30 50 80 00       	mov    %eax,0x805030
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802933:	48                   	dec    %eax
  802934:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802939:	a1 38 50 80 00       	mov    0x805038,%eax
  80293e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802941:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802945:	74 07                	je     80294e <initialize_dynamic_allocator+0xfd>
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 00                	mov    (%eax),%eax
  80294c:	eb 05                	jmp    802953 <initialize_dynamic_allocator+0x102>
  80294e:	b8 00 00 00 00       	mov    $0x0,%eax
  802953:	a3 38 50 80 00       	mov    %eax,0x805038
  802958:	a1 38 50 80 00       	mov    0x805038,%eax
  80295d:	85 c0                	test   %eax,%eax
  80295f:	0f 85 55 ff ff ff    	jne    8028ba <initialize_dynamic_allocator+0x69>
  802965:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802969:	0f 85 4b ff ff ff    	jne    8028ba <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802978:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80297e:	a1 48 50 80 00       	mov    0x805048,%eax
  802983:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802988:	a1 44 50 80 00       	mov    0x805044,%eax
  80298d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	83 c0 08             	add    $0x8,%eax
  802999:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80299c:	8b 45 08             	mov    0x8(%ebp),%eax
  80299f:	83 c0 04             	add    $0x4,%eax
  8029a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a5:	83 ea 08             	sub    $0x8,%edx
  8029a8:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	01 d0                	add    %edx,%eax
  8029b2:	83 e8 08             	sub    $0x8,%eax
  8029b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029b8:	83 ea 08             	sub    $0x8,%edx
  8029bb:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8029bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8029c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8029d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029d4:	75 17                	jne    8029ed <initialize_dynamic_allocator+0x19c>
  8029d6:	83 ec 04             	sub    $0x4,%esp
  8029d9:	68 b0 4c 80 00       	push   $0x804cb0
  8029de:	68 90 00 00 00       	push   $0x90
  8029e3:	68 95 4c 80 00       	push   $0x804c95
  8029e8:	e8 a9 de ff ff       	call   800896 <_panic>
  8029ed:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f6:	89 10                	mov    %edx,(%eax)
  8029f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fb:	8b 00                	mov    (%eax),%eax
  8029fd:	85 c0                	test   %eax,%eax
  8029ff:	74 0d                	je     802a0e <initialize_dynamic_allocator+0x1bd>
  802a01:	a1 30 50 80 00       	mov    0x805030,%eax
  802a06:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a09:	89 50 04             	mov    %edx,0x4(%eax)
  802a0c:	eb 08                	jmp    802a16 <initialize_dynamic_allocator+0x1c5>
  802a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a11:	a3 34 50 80 00       	mov    %eax,0x805034
  802a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a19:	a3 30 50 80 00       	mov    %eax,0x805030
  802a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a28:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a2d:	40                   	inc    %eax
  802a2e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a33:	eb 07                	jmp    802a3c <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802a35:	90                   	nop
  802a36:	eb 04                	jmp    802a3c <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802a38:	90                   	nop
  802a39:	eb 01                	jmp    802a3c <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802a3b:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802a3c:	c9                   	leave  
  802a3d:	c3                   	ret    

00802a3e <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802a3e:	55                   	push   %ebp
  802a3f:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802a41:	8b 45 10             	mov    0x10(%ebp),%eax
  802a44:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802a47:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4a:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a50:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802a52:	8b 45 08             	mov    0x8(%ebp),%eax
  802a55:	83 e8 04             	sub    $0x4,%eax
  802a58:	8b 00                	mov    (%eax),%eax
  802a5a:	83 e0 fe             	and    $0xfffffffe,%eax
  802a5d:	8d 50 f8             	lea    -0x8(%eax),%edx
  802a60:	8b 45 08             	mov    0x8(%ebp),%eax
  802a63:	01 c2                	add    %eax,%edx
  802a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a68:	89 02                	mov    %eax,(%edx)
}
  802a6a:	90                   	nop
  802a6b:	5d                   	pop    %ebp
  802a6c:	c3                   	ret    

00802a6d <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
  802a70:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	83 e0 01             	and    $0x1,%eax
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	74 03                	je     802a80 <alloc_block_FF+0x13>
  802a7d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802a80:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802a84:	77 07                	ja     802a8d <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802a86:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a8d:	a1 28 50 80 00       	mov    0x805028,%eax
  802a92:	85 c0                	test   %eax,%eax
  802a94:	75 73                	jne    802b09 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	83 c0 10             	add    $0x10,%eax
  802a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a9f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802aa6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aac:	01 d0                	add    %edx,%eax
  802aae:	48                   	dec    %eax
  802aaf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ab2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  802aba:	f7 75 ec             	divl   -0x14(%ebp)
  802abd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac0:	29 d0                	sub    %edx,%eax
  802ac2:	c1 e8 0c             	shr    $0xc,%eax
  802ac5:	83 ec 0c             	sub    $0xc,%esp
  802ac8:	50                   	push   %eax
  802ac9:	e8 27 f0 ff ff       	call   801af5 <sbrk>
  802ace:	83 c4 10             	add    $0x10,%esp
  802ad1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802ad4:	83 ec 0c             	sub    $0xc,%esp
  802ad7:	6a 00                	push   $0x0
  802ad9:	e8 17 f0 ff ff       	call   801af5 <sbrk>
  802ade:	83 c4 10             	add    $0x10,%esp
  802ae1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae7:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802aea:	83 ec 08             	sub    $0x8,%esp
  802aed:	50                   	push   %eax
  802aee:	ff 75 e4             	pushl  -0x1c(%ebp)
  802af1:	e8 5b fd ff ff       	call   802851 <initialize_dynamic_allocator>
  802af6:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802af9:	83 ec 0c             	sub    $0xc,%esp
  802afc:	68 d3 4c 80 00       	push   $0x804cd3
  802b01:	e8 4d e0 ff ff       	call   800b53 <cprintf>
  802b06:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802b09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b0d:	75 0a                	jne    802b19 <alloc_block_FF+0xac>
	        return NULL;
  802b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b14:	e9 0e 04 00 00       	jmp    802f27 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802b19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b20:	a1 30 50 80 00       	mov    0x805030,%eax
  802b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b28:	e9 f3 02 00 00       	jmp    802e20 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802b33:	83 ec 0c             	sub    $0xc,%esp
  802b36:	ff 75 bc             	pushl  -0x44(%ebp)
  802b39:	e8 af fb ff ff       	call   8026ed <get_block_size>
  802b3e:	83 c4 10             	add    $0x10,%esp
  802b41:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802b44:	8b 45 08             	mov    0x8(%ebp),%eax
  802b47:	83 c0 08             	add    $0x8,%eax
  802b4a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b4d:	0f 87 c5 02 00 00    	ja     802e18 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	83 c0 18             	add    $0x18,%eax
  802b59:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b5c:	0f 87 19 02 00 00    	ja     802d7b <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802b62:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b65:	2b 45 08             	sub    0x8(%ebp),%eax
  802b68:	83 e8 08             	sub    $0x8,%eax
  802b6b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	8d 50 08             	lea    0x8(%eax),%edx
  802b74:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b77:	01 d0                	add    %edx,%eax
  802b79:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	83 c0 08             	add    $0x8,%eax
  802b82:	83 ec 04             	sub    $0x4,%esp
  802b85:	6a 01                	push   $0x1
  802b87:	50                   	push   %eax
  802b88:	ff 75 bc             	pushl  -0x44(%ebp)
  802b8b:	e8 ae fe ff ff       	call   802a3e <set_block_data>
  802b90:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	8b 40 04             	mov    0x4(%eax),%eax
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	75 68                	jne    802c05 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b9d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ba1:	75 17                	jne    802bba <alloc_block_FF+0x14d>
  802ba3:	83 ec 04             	sub    $0x4,%esp
  802ba6:	68 b0 4c 80 00       	push   $0x804cb0
  802bab:	68 d7 00 00 00       	push   $0xd7
  802bb0:	68 95 4c 80 00       	push   $0x804c95
  802bb5:	e8 dc dc ff ff       	call   800896 <_panic>
  802bba:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802bc0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc3:	89 10                	mov    %edx,(%eax)
  802bc5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	74 0d                	je     802bdb <alloc_block_FF+0x16e>
  802bce:	a1 30 50 80 00       	mov    0x805030,%eax
  802bd3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bd6:	89 50 04             	mov    %edx,0x4(%eax)
  802bd9:	eb 08                	jmp    802be3 <alloc_block_FF+0x176>
  802bdb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bde:	a3 34 50 80 00       	mov    %eax,0x805034
  802be3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802be6:	a3 30 50 80 00       	mov    %eax,0x805030
  802beb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bfa:	40                   	inc    %eax
  802bfb:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802c00:	e9 dc 00 00 00       	jmp    802ce1 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 00                	mov    (%eax),%eax
  802c0a:	85 c0                	test   %eax,%eax
  802c0c:	75 65                	jne    802c73 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c0e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c12:	75 17                	jne    802c2b <alloc_block_FF+0x1be>
  802c14:	83 ec 04             	sub    $0x4,%esp
  802c17:	68 e4 4c 80 00       	push   $0x804ce4
  802c1c:	68 db 00 00 00       	push   $0xdb
  802c21:	68 95 4c 80 00       	push   $0x804c95
  802c26:	e8 6b dc ff ff       	call   800896 <_panic>
  802c2b:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802c31:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c34:	89 50 04             	mov    %edx,0x4(%eax)
  802c37:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c3a:	8b 40 04             	mov    0x4(%eax),%eax
  802c3d:	85 c0                	test   %eax,%eax
  802c3f:	74 0c                	je     802c4d <alloc_block_FF+0x1e0>
  802c41:	a1 34 50 80 00       	mov    0x805034,%eax
  802c46:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c49:	89 10                	mov    %edx,(%eax)
  802c4b:	eb 08                	jmp    802c55 <alloc_block_FF+0x1e8>
  802c4d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c50:	a3 30 50 80 00       	mov    %eax,0x805030
  802c55:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c58:	a3 34 50 80 00       	mov    %eax,0x805034
  802c5d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c66:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c6b:	40                   	inc    %eax
  802c6c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802c71:	eb 6e                	jmp    802ce1 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802c73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c77:	74 06                	je     802c7f <alloc_block_FF+0x212>
  802c79:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c7d:	75 17                	jne    802c96 <alloc_block_FF+0x229>
  802c7f:	83 ec 04             	sub    $0x4,%esp
  802c82:	68 08 4d 80 00       	push   $0x804d08
  802c87:	68 df 00 00 00       	push   $0xdf
  802c8c:	68 95 4c 80 00       	push   $0x804c95
  802c91:	e8 00 dc ff ff       	call   800896 <_panic>
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	8b 10                	mov    (%eax),%edx
  802c9b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c9e:	89 10                	mov    %edx,(%eax)
  802ca0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ca3:	8b 00                	mov    (%eax),%eax
  802ca5:	85 c0                	test   %eax,%eax
  802ca7:	74 0b                	je     802cb4 <alloc_block_FF+0x247>
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 00                	mov    (%eax),%eax
  802cae:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cb1:	89 50 04             	mov    %edx,0x4(%eax)
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802cba:	89 10                	mov    %edx,(%eax)
  802cbc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc2:	89 50 04             	mov    %edx,0x4(%eax)
  802cc5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cc8:	8b 00                	mov    (%eax),%eax
  802cca:	85 c0                	test   %eax,%eax
  802ccc:	75 08                	jne    802cd6 <alloc_block_FF+0x269>
  802cce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cd1:	a3 34 50 80 00       	mov    %eax,0x805034
  802cd6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cdb:	40                   	inc    %eax
  802cdc:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802ce1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce5:	75 17                	jne    802cfe <alloc_block_FF+0x291>
  802ce7:	83 ec 04             	sub    $0x4,%esp
  802cea:	68 77 4c 80 00       	push   $0x804c77
  802cef:	68 e1 00 00 00       	push   $0xe1
  802cf4:	68 95 4c 80 00       	push   $0x804c95
  802cf9:	e8 98 db ff ff       	call   800896 <_panic>
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	85 c0                	test   %eax,%eax
  802d05:	74 10                	je     802d17 <alloc_block_FF+0x2aa>
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	8b 00                	mov    (%eax),%eax
  802d0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0f:	8b 52 04             	mov    0x4(%edx),%edx
  802d12:	89 50 04             	mov    %edx,0x4(%eax)
  802d15:	eb 0b                	jmp    802d22 <alloc_block_FF+0x2b5>
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 40 04             	mov    0x4(%eax),%eax
  802d1d:	a3 34 50 80 00       	mov    %eax,0x805034
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 40 04             	mov    0x4(%eax),%eax
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	74 0f                	je     802d3b <alloc_block_FF+0x2ce>
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 40 04             	mov    0x4(%eax),%eax
  802d32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d35:	8b 12                	mov    (%edx),%edx
  802d37:	89 10                	mov    %edx,(%eax)
  802d39:	eb 0a                	jmp    802d45 <alloc_block_FF+0x2d8>
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	8b 00                	mov    (%eax),%eax
  802d40:	a3 30 50 80 00       	mov    %eax,0x805030
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d58:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d5d:	48                   	dec    %eax
  802d5e:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802d63:	83 ec 04             	sub    $0x4,%esp
  802d66:	6a 00                	push   $0x0
  802d68:	ff 75 b4             	pushl  -0x4c(%ebp)
  802d6b:	ff 75 b0             	pushl  -0x50(%ebp)
  802d6e:	e8 cb fc ff ff       	call   802a3e <set_block_data>
  802d73:	83 c4 10             	add    $0x10,%esp
  802d76:	e9 95 00 00 00       	jmp    802e10 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802d7b:	83 ec 04             	sub    $0x4,%esp
  802d7e:	6a 01                	push   $0x1
  802d80:	ff 75 b8             	pushl  -0x48(%ebp)
  802d83:	ff 75 bc             	pushl  -0x44(%ebp)
  802d86:	e8 b3 fc ff ff       	call   802a3e <set_block_data>
  802d8b:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802d8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d92:	75 17                	jne    802dab <alloc_block_FF+0x33e>
  802d94:	83 ec 04             	sub    $0x4,%esp
  802d97:	68 77 4c 80 00       	push   $0x804c77
  802d9c:	68 e8 00 00 00       	push   $0xe8
  802da1:	68 95 4c 80 00       	push   $0x804c95
  802da6:	e8 eb da ff ff       	call   800896 <_panic>
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	8b 00                	mov    (%eax),%eax
  802db0:	85 c0                	test   %eax,%eax
  802db2:	74 10                	je     802dc4 <alloc_block_FF+0x357>
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 00                	mov    (%eax),%eax
  802db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbc:	8b 52 04             	mov    0x4(%edx),%edx
  802dbf:	89 50 04             	mov    %edx,0x4(%eax)
  802dc2:	eb 0b                	jmp    802dcf <alloc_block_FF+0x362>
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 40 04             	mov    0x4(%eax),%eax
  802dca:	a3 34 50 80 00       	mov    %eax,0x805034
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	85 c0                	test   %eax,%eax
  802dd7:	74 0f                	je     802de8 <alloc_block_FF+0x37b>
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	8b 40 04             	mov    0x4(%eax),%eax
  802ddf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de2:	8b 12                	mov    (%edx),%edx
  802de4:	89 10                	mov    %edx,(%eax)
  802de6:	eb 0a                	jmp    802df2 <alloc_block_FF+0x385>
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	8b 00                	mov    (%eax),%eax
  802ded:	a3 30 50 80 00       	mov    %eax,0x805030
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e05:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e0a:	48                   	dec    %eax
  802e0b:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802e10:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e13:	e9 0f 01 00 00       	jmp    802f27 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802e18:	a1 38 50 80 00       	mov    0x805038,%eax
  802e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e24:	74 07                	je     802e2d <alloc_block_FF+0x3c0>
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 00                	mov    (%eax),%eax
  802e2b:	eb 05                	jmp    802e32 <alloc_block_FF+0x3c5>
  802e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e32:	a3 38 50 80 00       	mov    %eax,0x805038
  802e37:	a1 38 50 80 00       	mov    0x805038,%eax
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	0f 85 e9 fc ff ff    	jne    802b2d <alloc_block_FF+0xc0>
  802e44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e48:	0f 85 df fc ff ff    	jne    802b2d <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	83 c0 08             	add    $0x8,%eax
  802e54:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802e57:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802e5e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e61:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e64:	01 d0                	add    %edx,%eax
  802e66:	48                   	dec    %eax
  802e67:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802e6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e6d:	ba 00 00 00 00       	mov    $0x0,%edx
  802e72:	f7 75 d8             	divl   -0x28(%ebp)
  802e75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e78:	29 d0                	sub    %edx,%eax
  802e7a:	c1 e8 0c             	shr    $0xc,%eax
  802e7d:	83 ec 0c             	sub    $0xc,%esp
  802e80:	50                   	push   %eax
  802e81:	e8 6f ec ff ff       	call   801af5 <sbrk>
  802e86:	83 c4 10             	add    $0x10,%esp
  802e89:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802e8c:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802e90:	75 0a                	jne    802e9c <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802e92:	b8 00 00 00 00       	mov    $0x0,%eax
  802e97:	e9 8b 00 00 00       	jmp    802f27 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e9c:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802ea3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ea6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ea9:	01 d0                	add    %edx,%eax
  802eab:	48                   	dec    %eax
  802eac:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802eaf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802eb2:	ba 00 00 00 00       	mov    $0x0,%edx
  802eb7:	f7 75 cc             	divl   -0x34(%ebp)
  802eba:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ebd:	29 d0                	sub    %edx,%eax
  802ebf:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ec2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ec5:	01 d0                	add    %edx,%eax
  802ec7:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802ecc:	a1 44 50 80 00       	mov    0x805044,%eax
  802ed1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ed7:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ede:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ee1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ee4:	01 d0                	add    %edx,%eax
  802ee6:	48                   	dec    %eax
  802ee7:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802eea:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802eed:	ba 00 00 00 00       	mov    $0x0,%edx
  802ef2:	f7 75 c4             	divl   -0x3c(%ebp)
  802ef5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ef8:	29 d0                	sub    %edx,%eax
  802efa:	83 ec 04             	sub    $0x4,%esp
  802efd:	6a 01                	push   $0x1
  802eff:	50                   	push   %eax
  802f00:	ff 75 d0             	pushl  -0x30(%ebp)
  802f03:	e8 36 fb ff ff       	call   802a3e <set_block_data>
  802f08:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802f0b:	83 ec 0c             	sub    $0xc,%esp
  802f0e:	ff 75 d0             	pushl  -0x30(%ebp)
  802f11:	e8 f8 09 00 00       	call   80390e <free_block>
  802f16:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802f19:	83 ec 0c             	sub    $0xc,%esp
  802f1c:	ff 75 08             	pushl  0x8(%ebp)
  802f1f:	e8 49 fb ff ff       	call   802a6d <alloc_block_FF>
  802f24:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802f27:	c9                   	leave  
  802f28:	c3                   	ret    

00802f29 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802f29:	55                   	push   %ebp
  802f2a:	89 e5                	mov    %esp,%ebp
  802f2c:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	83 e0 01             	and    $0x1,%eax
  802f35:	85 c0                	test   %eax,%eax
  802f37:	74 03                	je     802f3c <alloc_block_BF+0x13>
  802f39:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f3c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f40:	77 07                	ja     802f49 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f42:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f49:	a1 28 50 80 00       	mov    0x805028,%eax
  802f4e:	85 c0                	test   %eax,%eax
  802f50:	75 73                	jne    802fc5 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	83 c0 10             	add    $0x10,%eax
  802f58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802f5b:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802f62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f68:	01 d0                	add    %edx,%eax
  802f6a:	48                   	dec    %eax
  802f6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f71:	ba 00 00 00 00       	mov    $0x0,%edx
  802f76:	f7 75 e0             	divl   -0x20(%ebp)
  802f79:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f7c:	29 d0                	sub    %edx,%eax
  802f7e:	c1 e8 0c             	shr    $0xc,%eax
  802f81:	83 ec 0c             	sub    $0xc,%esp
  802f84:	50                   	push   %eax
  802f85:	e8 6b eb ff ff       	call   801af5 <sbrk>
  802f8a:	83 c4 10             	add    $0x10,%esp
  802f8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802f90:	83 ec 0c             	sub    $0xc,%esp
  802f93:	6a 00                	push   $0x0
  802f95:	e8 5b eb ff ff       	call   801af5 <sbrk>
  802f9a:	83 c4 10             	add    $0x10,%esp
  802f9d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802fa0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fa3:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802fa6:	83 ec 08             	sub    $0x8,%esp
  802fa9:	50                   	push   %eax
  802faa:	ff 75 d8             	pushl  -0x28(%ebp)
  802fad:	e8 9f f8 ff ff       	call   802851 <initialize_dynamic_allocator>
  802fb2:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802fb5:	83 ec 0c             	sub    $0xc,%esp
  802fb8:	68 d3 4c 80 00       	push   $0x804cd3
  802fbd:	e8 91 db ff ff       	call   800b53 <cprintf>
  802fc2:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802fc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802fcc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802fd3:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802fda:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802fe1:	a1 30 50 80 00       	mov    0x805030,%eax
  802fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe9:	e9 1d 01 00 00       	jmp    80310b <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff1:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802ff4:	83 ec 0c             	sub    $0xc,%esp
  802ff7:	ff 75 a8             	pushl  -0x58(%ebp)
  802ffa:	e8 ee f6 ff ff       	call   8026ed <get_block_size>
  802fff:	83 c4 10             	add    $0x10,%esp
  803002:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	83 c0 08             	add    $0x8,%eax
  80300b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80300e:	0f 87 ef 00 00 00    	ja     803103 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	83 c0 18             	add    $0x18,%eax
  80301a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80301d:	77 1d                	ja     80303c <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80301f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803022:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803025:	0f 86 d8 00 00 00    	jbe    803103 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80302b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80302e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803031:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803034:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803037:	e9 c7 00 00 00       	jmp    803103 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80303c:	8b 45 08             	mov    0x8(%ebp),%eax
  80303f:	83 c0 08             	add    $0x8,%eax
  803042:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803045:	0f 85 9d 00 00 00    	jne    8030e8 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80304b:	83 ec 04             	sub    $0x4,%esp
  80304e:	6a 01                	push   $0x1
  803050:	ff 75 a4             	pushl  -0x5c(%ebp)
  803053:	ff 75 a8             	pushl  -0x58(%ebp)
  803056:	e8 e3 f9 ff ff       	call   802a3e <set_block_data>
  80305b:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80305e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803062:	75 17                	jne    80307b <alloc_block_BF+0x152>
  803064:	83 ec 04             	sub    $0x4,%esp
  803067:	68 77 4c 80 00       	push   $0x804c77
  80306c:	68 2c 01 00 00       	push   $0x12c
  803071:	68 95 4c 80 00       	push   $0x804c95
  803076:	e8 1b d8 ff ff       	call   800896 <_panic>
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	8b 00                	mov    (%eax),%eax
  803080:	85 c0                	test   %eax,%eax
  803082:	74 10                	je     803094 <alloc_block_BF+0x16b>
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	8b 00                	mov    (%eax),%eax
  803089:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80308c:	8b 52 04             	mov    0x4(%edx),%edx
  80308f:	89 50 04             	mov    %edx,0x4(%eax)
  803092:	eb 0b                	jmp    80309f <alloc_block_BF+0x176>
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 40 04             	mov    0x4(%eax),%eax
  80309a:	a3 34 50 80 00       	mov    %eax,0x805034
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	8b 40 04             	mov    0x4(%eax),%eax
  8030a5:	85 c0                	test   %eax,%eax
  8030a7:	74 0f                	je     8030b8 <alloc_block_BF+0x18f>
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	8b 40 04             	mov    0x4(%eax),%eax
  8030af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b2:	8b 12                	mov    (%edx),%edx
  8030b4:	89 10                	mov    %edx,(%eax)
  8030b6:	eb 0a                	jmp    8030c2 <alloc_block_BF+0x199>
  8030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bb:	8b 00                	mov    (%eax),%eax
  8030bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030da:	48                   	dec    %eax
  8030db:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  8030e0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030e3:	e9 01 04 00 00       	jmp    8034e9 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  8030e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030eb:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8030ee:	76 13                	jbe    803103 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8030f0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8030f7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8030fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8030fd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803100:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803103:	a1 38 50 80 00       	mov    0x805038,%eax
  803108:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310f:	74 07                	je     803118 <alloc_block_BF+0x1ef>
  803111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803114:	8b 00                	mov    (%eax),%eax
  803116:	eb 05                	jmp    80311d <alloc_block_BF+0x1f4>
  803118:	b8 00 00 00 00       	mov    $0x0,%eax
  80311d:	a3 38 50 80 00       	mov    %eax,0x805038
  803122:	a1 38 50 80 00       	mov    0x805038,%eax
  803127:	85 c0                	test   %eax,%eax
  803129:	0f 85 bf fe ff ff    	jne    802fee <alloc_block_BF+0xc5>
  80312f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803133:	0f 85 b5 fe ff ff    	jne    802fee <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803139:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80313d:	0f 84 26 02 00 00    	je     803369 <alloc_block_BF+0x440>
  803143:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803147:	0f 85 1c 02 00 00    	jne    803369 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80314d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803150:	2b 45 08             	sub    0x8(%ebp),%eax
  803153:	83 e8 08             	sub    $0x8,%eax
  803156:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	8d 50 08             	lea    0x8(%eax),%edx
  80315f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803162:	01 d0                	add    %edx,%eax
  803164:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803167:	8b 45 08             	mov    0x8(%ebp),%eax
  80316a:	83 c0 08             	add    $0x8,%eax
  80316d:	83 ec 04             	sub    $0x4,%esp
  803170:	6a 01                	push   $0x1
  803172:	50                   	push   %eax
  803173:	ff 75 f0             	pushl  -0x10(%ebp)
  803176:	e8 c3 f8 ff ff       	call   802a3e <set_block_data>
  80317b:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80317e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803181:	8b 40 04             	mov    0x4(%eax),%eax
  803184:	85 c0                	test   %eax,%eax
  803186:	75 68                	jne    8031f0 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803188:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80318c:	75 17                	jne    8031a5 <alloc_block_BF+0x27c>
  80318e:	83 ec 04             	sub    $0x4,%esp
  803191:	68 b0 4c 80 00       	push   $0x804cb0
  803196:	68 45 01 00 00       	push   $0x145
  80319b:	68 95 4c 80 00       	push   $0x804c95
  8031a0:	e8 f1 d6 ff ff       	call   800896 <_panic>
  8031a5:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8031ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ae:	89 10                	mov    %edx,(%eax)
  8031b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031b3:	8b 00                	mov    (%eax),%eax
  8031b5:	85 c0                	test   %eax,%eax
  8031b7:	74 0d                	je     8031c6 <alloc_block_BF+0x29d>
  8031b9:	a1 30 50 80 00       	mov    0x805030,%eax
  8031be:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031c1:	89 50 04             	mov    %edx,0x4(%eax)
  8031c4:	eb 08                	jmp    8031ce <alloc_block_BF+0x2a5>
  8031c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031c9:	a3 34 50 80 00       	mov    %eax,0x805034
  8031ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031d1:	a3 30 50 80 00       	mov    %eax,0x805030
  8031d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031e5:	40                   	inc    %eax
  8031e6:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8031eb:	e9 dc 00 00 00       	jmp    8032cc <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8031f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f3:	8b 00                	mov    (%eax),%eax
  8031f5:	85 c0                	test   %eax,%eax
  8031f7:	75 65                	jne    80325e <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031f9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031fd:	75 17                	jne    803216 <alloc_block_BF+0x2ed>
  8031ff:	83 ec 04             	sub    $0x4,%esp
  803202:	68 e4 4c 80 00       	push   $0x804ce4
  803207:	68 4a 01 00 00       	push   $0x14a
  80320c:	68 95 4c 80 00       	push   $0x804c95
  803211:	e8 80 d6 ff ff       	call   800896 <_panic>
  803216:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80321c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80321f:	89 50 04             	mov    %edx,0x4(%eax)
  803222:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803225:	8b 40 04             	mov    0x4(%eax),%eax
  803228:	85 c0                	test   %eax,%eax
  80322a:	74 0c                	je     803238 <alloc_block_BF+0x30f>
  80322c:	a1 34 50 80 00       	mov    0x805034,%eax
  803231:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803234:	89 10                	mov    %edx,(%eax)
  803236:	eb 08                	jmp    803240 <alloc_block_BF+0x317>
  803238:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80323b:	a3 30 50 80 00       	mov    %eax,0x805030
  803240:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803243:	a3 34 50 80 00       	mov    %eax,0x805034
  803248:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80324b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803251:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803256:	40                   	inc    %eax
  803257:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80325c:	eb 6e                	jmp    8032cc <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80325e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803262:	74 06                	je     80326a <alloc_block_BF+0x341>
  803264:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803268:	75 17                	jne    803281 <alloc_block_BF+0x358>
  80326a:	83 ec 04             	sub    $0x4,%esp
  80326d:	68 08 4d 80 00       	push   $0x804d08
  803272:	68 4f 01 00 00       	push   $0x14f
  803277:	68 95 4c 80 00       	push   $0x804c95
  80327c:	e8 15 d6 ff ff       	call   800896 <_panic>
  803281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803284:	8b 10                	mov    (%eax),%edx
  803286:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803289:	89 10                	mov    %edx,(%eax)
  80328b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80328e:	8b 00                	mov    (%eax),%eax
  803290:	85 c0                	test   %eax,%eax
  803292:	74 0b                	je     80329f <alloc_block_BF+0x376>
  803294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803297:	8b 00                	mov    (%eax),%eax
  803299:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80329c:	89 50 04             	mov    %edx,0x4(%eax)
  80329f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032a5:	89 10                	mov    %edx,(%eax)
  8032a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ad:	89 50 04             	mov    %edx,0x4(%eax)
  8032b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	85 c0                	test   %eax,%eax
  8032b7:	75 08                	jne    8032c1 <alloc_block_BF+0x398>
  8032b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032bc:	a3 34 50 80 00       	mov    %eax,0x805034
  8032c1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032c6:	40                   	inc    %eax
  8032c7:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8032cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032d0:	75 17                	jne    8032e9 <alloc_block_BF+0x3c0>
  8032d2:	83 ec 04             	sub    $0x4,%esp
  8032d5:	68 77 4c 80 00       	push   $0x804c77
  8032da:	68 51 01 00 00       	push   $0x151
  8032df:	68 95 4c 80 00       	push   $0x804c95
  8032e4:	e8 ad d5 ff ff       	call   800896 <_panic>
  8032e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ec:	8b 00                	mov    (%eax),%eax
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	74 10                	je     803302 <alloc_block_BF+0x3d9>
  8032f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f5:	8b 00                	mov    (%eax),%eax
  8032f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032fa:	8b 52 04             	mov    0x4(%edx),%edx
  8032fd:	89 50 04             	mov    %edx,0x4(%eax)
  803300:	eb 0b                	jmp    80330d <alloc_block_BF+0x3e4>
  803302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803305:	8b 40 04             	mov    0x4(%eax),%eax
  803308:	a3 34 50 80 00       	mov    %eax,0x805034
  80330d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803310:	8b 40 04             	mov    0x4(%eax),%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	74 0f                	je     803326 <alloc_block_BF+0x3fd>
  803317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331a:	8b 40 04             	mov    0x4(%eax),%eax
  80331d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803320:	8b 12                	mov    (%edx),%edx
  803322:	89 10                	mov    %edx,(%eax)
  803324:	eb 0a                	jmp    803330 <alloc_block_BF+0x407>
  803326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803329:	8b 00                	mov    (%eax),%eax
  80332b:	a3 30 50 80 00       	mov    %eax,0x805030
  803330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803333:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803343:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803348:	48                   	dec    %eax
  803349:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  80334e:	83 ec 04             	sub    $0x4,%esp
  803351:	6a 00                	push   $0x0
  803353:	ff 75 d0             	pushl  -0x30(%ebp)
  803356:	ff 75 cc             	pushl  -0x34(%ebp)
  803359:	e8 e0 f6 ff ff       	call   802a3e <set_block_data>
  80335e:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803364:	e9 80 01 00 00       	jmp    8034e9 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  803369:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80336d:	0f 85 9d 00 00 00    	jne    803410 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803373:	83 ec 04             	sub    $0x4,%esp
  803376:	6a 01                	push   $0x1
  803378:	ff 75 ec             	pushl  -0x14(%ebp)
  80337b:	ff 75 f0             	pushl  -0x10(%ebp)
  80337e:	e8 bb f6 ff ff       	call   802a3e <set_block_data>
  803383:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803386:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80338a:	75 17                	jne    8033a3 <alloc_block_BF+0x47a>
  80338c:	83 ec 04             	sub    $0x4,%esp
  80338f:	68 77 4c 80 00       	push   $0x804c77
  803394:	68 58 01 00 00       	push   $0x158
  803399:	68 95 4c 80 00       	push   $0x804c95
  80339e:	e8 f3 d4 ff ff       	call   800896 <_panic>
  8033a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a6:	8b 00                	mov    (%eax),%eax
  8033a8:	85 c0                	test   %eax,%eax
  8033aa:	74 10                	je     8033bc <alloc_block_BF+0x493>
  8033ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033b4:	8b 52 04             	mov    0x4(%edx),%edx
  8033b7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ba:	eb 0b                	jmp    8033c7 <alloc_block_BF+0x49e>
  8033bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bf:	8b 40 04             	mov    0x4(%eax),%eax
  8033c2:	a3 34 50 80 00       	mov    %eax,0x805034
  8033c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ca:	8b 40 04             	mov    0x4(%eax),%eax
  8033cd:	85 c0                	test   %eax,%eax
  8033cf:	74 0f                	je     8033e0 <alloc_block_BF+0x4b7>
  8033d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d4:	8b 40 04             	mov    0x4(%eax),%eax
  8033d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033da:	8b 12                	mov    (%edx),%edx
  8033dc:	89 10                	mov    %edx,(%eax)
  8033de:	eb 0a                	jmp    8033ea <alloc_block_BF+0x4c1>
  8033e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e3:	8b 00                	mov    (%eax),%eax
  8033e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8033ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033fd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803402:	48                   	dec    %eax
  803403:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  803408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340b:	e9 d9 00 00 00       	jmp    8034e9 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803410:	8b 45 08             	mov    0x8(%ebp),%eax
  803413:	83 c0 08             	add    $0x8,%eax
  803416:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803419:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803420:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803423:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803426:	01 d0                	add    %edx,%eax
  803428:	48                   	dec    %eax
  803429:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80342c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80342f:	ba 00 00 00 00       	mov    $0x0,%edx
  803434:	f7 75 c4             	divl   -0x3c(%ebp)
  803437:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80343a:	29 d0                	sub    %edx,%eax
  80343c:	c1 e8 0c             	shr    $0xc,%eax
  80343f:	83 ec 0c             	sub    $0xc,%esp
  803442:	50                   	push   %eax
  803443:	e8 ad e6 ff ff       	call   801af5 <sbrk>
  803448:	83 c4 10             	add    $0x10,%esp
  80344b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80344e:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803452:	75 0a                	jne    80345e <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803454:	b8 00 00 00 00       	mov    $0x0,%eax
  803459:	e9 8b 00 00 00       	jmp    8034e9 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80345e:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803465:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803468:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80346b:	01 d0                	add    %edx,%eax
  80346d:	48                   	dec    %eax
  80346e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803471:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803474:	ba 00 00 00 00       	mov    $0x0,%edx
  803479:	f7 75 b8             	divl   -0x48(%ebp)
  80347c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80347f:	29 d0                	sub    %edx,%eax
  803481:	8d 50 fc             	lea    -0x4(%eax),%edx
  803484:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803487:	01 d0                	add    %edx,%eax
  803489:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  80348e:	a1 44 50 80 00       	mov    0x805044,%eax
  803493:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803499:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8034a0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8034a6:	01 d0                	add    %edx,%eax
  8034a8:	48                   	dec    %eax
  8034a9:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8034ac:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034af:	ba 00 00 00 00       	mov    $0x0,%edx
  8034b4:	f7 75 b0             	divl   -0x50(%ebp)
  8034b7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8034ba:	29 d0                	sub    %edx,%eax
  8034bc:	83 ec 04             	sub    $0x4,%esp
  8034bf:	6a 01                	push   $0x1
  8034c1:	50                   	push   %eax
  8034c2:	ff 75 bc             	pushl  -0x44(%ebp)
  8034c5:	e8 74 f5 ff ff       	call   802a3e <set_block_data>
  8034ca:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8034cd:	83 ec 0c             	sub    $0xc,%esp
  8034d0:	ff 75 bc             	pushl  -0x44(%ebp)
  8034d3:	e8 36 04 00 00       	call   80390e <free_block>
  8034d8:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8034db:	83 ec 0c             	sub    $0xc,%esp
  8034de:	ff 75 08             	pushl  0x8(%ebp)
  8034e1:	e8 43 fa ff ff       	call   802f29 <alloc_block_BF>
  8034e6:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8034e9:	c9                   	leave  
  8034ea:	c3                   	ret    

008034eb <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8034eb:	55                   	push   %ebp
  8034ec:	89 e5                	mov    %esp,%ebp
  8034ee:	53                   	push   %ebx
  8034ef:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8034f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8034f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803500:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803504:	74 1e                	je     803524 <merging+0x39>
  803506:	ff 75 08             	pushl  0x8(%ebp)
  803509:	e8 df f1 ff ff       	call   8026ed <get_block_size>
  80350e:	83 c4 04             	add    $0x4,%esp
  803511:	89 c2                	mov    %eax,%edx
  803513:	8b 45 08             	mov    0x8(%ebp),%eax
  803516:	01 d0                	add    %edx,%eax
  803518:	3b 45 10             	cmp    0x10(%ebp),%eax
  80351b:	75 07                	jne    803524 <merging+0x39>
		prev_is_free = 1;
  80351d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803524:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803528:	74 1e                	je     803548 <merging+0x5d>
  80352a:	ff 75 10             	pushl  0x10(%ebp)
  80352d:	e8 bb f1 ff ff       	call   8026ed <get_block_size>
  803532:	83 c4 04             	add    $0x4,%esp
  803535:	89 c2                	mov    %eax,%edx
  803537:	8b 45 10             	mov    0x10(%ebp),%eax
  80353a:	01 d0                	add    %edx,%eax
  80353c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80353f:	75 07                	jne    803548 <merging+0x5d>
		next_is_free = 1;
  803541:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80354c:	0f 84 cc 00 00 00    	je     80361e <merging+0x133>
  803552:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803556:	0f 84 c2 00 00 00    	je     80361e <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80355c:	ff 75 08             	pushl  0x8(%ebp)
  80355f:	e8 89 f1 ff ff       	call   8026ed <get_block_size>
  803564:	83 c4 04             	add    $0x4,%esp
  803567:	89 c3                	mov    %eax,%ebx
  803569:	ff 75 10             	pushl  0x10(%ebp)
  80356c:	e8 7c f1 ff ff       	call   8026ed <get_block_size>
  803571:	83 c4 04             	add    $0x4,%esp
  803574:	01 c3                	add    %eax,%ebx
  803576:	ff 75 0c             	pushl  0xc(%ebp)
  803579:	e8 6f f1 ff ff       	call   8026ed <get_block_size>
  80357e:	83 c4 04             	add    $0x4,%esp
  803581:	01 d8                	add    %ebx,%eax
  803583:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803586:	6a 00                	push   $0x0
  803588:	ff 75 ec             	pushl  -0x14(%ebp)
  80358b:	ff 75 08             	pushl  0x8(%ebp)
  80358e:	e8 ab f4 ff ff       	call   802a3e <set_block_data>
  803593:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803596:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80359a:	75 17                	jne    8035b3 <merging+0xc8>
  80359c:	83 ec 04             	sub    $0x4,%esp
  80359f:	68 77 4c 80 00       	push   $0x804c77
  8035a4:	68 7d 01 00 00       	push   $0x17d
  8035a9:	68 95 4c 80 00       	push   $0x804c95
  8035ae:	e8 e3 d2 ff ff       	call   800896 <_panic>
  8035b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b6:	8b 00                	mov    (%eax),%eax
  8035b8:	85 c0                	test   %eax,%eax
  8035ba:	74 10                	je     8035cc <merging+0xe1>
  8035bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035bf:	8b 00                	mov    (%eax),%eax
  8035c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035c4:	8b 52 04             	mov    0x4(%edx),%edx
  8035c7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ca:	eb 0b                	jmp    8035d7 <merging+0xec>
  8035cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035cf:	8b 40 04             	mov    0x4(%eax),%eax
  8035d2:	a3 34 50 80 00       	mov    %eax,0x805034
  8035d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035da:	8b 40 04             	mov    0x4(%eax),%eax
  8035dd:	85 c0                	test   %eax,%eax
  8035df:	74 0f                	je     8035f0 <merging+0x105>
  8035e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e4:	8b 40 04             	mov    0x4(%eax),%eax
  8035e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035ea:	8b 12                	mov    (%edx),%edx
  8035ec:	89 10                	mov    %edx,(%eax)
  8035ee:	eb 0a                	jmp    8035fa <merging+0x10f>
  8035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f3:	8b 00                	mov    (%eax),%eax
  8035f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8035fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803603:	8b 45 0c             	mov    0xc(%ebp),%eax
  803606:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80360d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803612:	48                   	dec    %eax
  803613:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803618:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803619:	e9 ea 02 00 00       	jmp    803908 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80361e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803622:	74 3b                	je     80365f <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803624:	83 ec 0c             	sub    $0xc,%esp
  803627:	ff 75 08             	pushl  0x8(%ebp)
  80362a:	e8 be f0 ff ff       	call   8026ed <get_block_size>
  80362f:	83 c4 10             	add    $0x10,%esp
  803632:	89 c3                	mov    %eax,%ebx
  803634:	83 ec 0c             	sub    $0xc,%esp
  803637:	ff 75 10             	pushl  0x10(%ebp)
  80363a:	e8 ae f0 ff ff       	call   8026ed <get_block_size>
  80363f:	83 c4 10             	add    $0x10,%esp
  803642:	01 d8                	add    %ebx,%eax
  803644:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803647:	83 ec 04             	sub    $0x4,%esp
  80364a:	6a 00                	push   $0x0
  80364c:	ff 75 e8             	pushl  -0x18(%ebp)
  80364f:	ff 75 08             	pushl  0x8(%ebp)
  803652:	e8 e7 f3 ff ff       	call   802a3e <set_block_data>
  803657:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80365a:	e9 a9 02 00 00       	jmp    803908 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80365f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803663:	0f 84 2d 01 00 00    	je     803796 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803669:	83 ec 0c             	sub    $0xc,%esp
  80366c:	ff 75 10             	pushl  0x10(%ebp)
  80366f:	e8 79 f0 ff ff       	call   8026ed <get_block_size>
  803674:	83 c4 10             	add    $0x10,%esp
  803677:	89 c3                	mov    %eax,%ebx
  803679:	83 ec 0c             	sub    $0xc,%esp
  80367c:	ff 75 0c             	pushl  0xc(%ebp)
  80367f:	e8 69 f0 ff ff       	call   8026ed <get_block_size>
  803684:	83 c4 10             	add    $0x10,%esp
  803687:	01 d8                	add    %ebx,%eax
  803689:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80368c:	83 ec 04             	sub    $0x4,%esp
  80368f:	6a 00                	push   $0x0
  803691:	ff 75 e4             	pushl  -0x1c(%ebp)
  803694:	ff 75 10             	pushl  0x10(%ebp)
  803697:	e8 a2 f3 ff ff       	call   802a3e <set_block_data>
  80369c:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80369f:	8b 45 10             	mov    0x10(%ebp),%eax
  8036a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8036a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036a9:	74 06                	je     8036b1 <merging+0x1c6>
  8036ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8036af:	75 17                	jne    8036c8 <merging+0x1dd>
  8036b1:	83 ec 04             	sub    $0x4,%esp
  8036b4:	68 3c 4d 80 00       	push   $0x804d3c
  8036b9:	68 8d 01 00 00       	push   $0x18d
  8036be:	68 95 4c 80 00       	push   $0x804c95
  8036c3:	e8 ce d1 ff ff       	call   800896 <_panic>
  8036c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036cb:	8b 50 04             	mov    0x4(%eax),%edx
  8036ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036d1:	89 50 04             	mov    %edx,0x4(%eax)
  8036d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036da:	89 10                	mov    %edx,(%eax)
  8036dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036df:	8b 40 04             	mov    0x4(%eax),%eax
  8036e2:	85 c0                	test   %eax,%eax
  8036e4:	74 0d                	je     8036f3 <merging+0x208>
  8036e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e9:	8b 40 04             	mov    0x4(%eax),%eax
  8036ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036ef:	89 10                	mov    %edx,(%eax)
  8036f1:	eb 08                	jmp    8036fb <merging+0x210>
  8036f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036f6:	a3 30 50 80 00       	mov    %eax,0x805030
  8036fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803701:	89 50 04             	mov    %edx,0x4(%eax)
  803704:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803709:	40                   	inc    %eax
  80370a:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  80370f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803713:	75 17                	jne    80372c <merging+0x241>
  803715:	83 ec 04             	sub    $0x4,%esp
  803718:	68 77 4c 80 00       	push   $0x804c77
  80371d:	68 8e 01 00 00       	push   $0x18e
  803722:	68 95 4c 80 00       	push   $0x804c95
  803727:	e8 6a d1 ff ff       	call   800896 <_panic>
  80372c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80372f:	8b 00                	mov    (%eax),%eax
  803731:	85 c0                	test   %eax,%eax
  803733:	74 10                	je     803745 <merging+0x25a>
  803735:	8b 45 0c             	mov    0xc(%ebp),%eax
  803738:	8b 00                	mov    (%eax),%eax
  80373a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80373d:	8b 52 04             	mov    0x4(%edx),%edx
  803740:	89 50 04             	mov    %edx,0x4(%eax)
  803743:	eb 0b                	jmp    803750 <merging+0x265>
  803745:	8b 45 0c             	mov    0xc(%ebp),%eax
  803748:	8b 40 04             	mov    0x4(%eax),%eax
  80374b:	a3 34 50 80 00       	mov    %eax,0x805034
  803750:	8b 45 0c             	mov    0xc(%ebp),%eax
  803753:	8b 40 04             	mov    0x4(%eax),%eax
  803756:	85 c0                	test   %eax,%eax
  803758:	74 0f                	je     803769 <merging+0x27e>
  80375a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80375d:	8b 40 04             	mov    0x4(%eax),%eax
  803760:	8b 55 0c             	mov    0xc(%ebp),%edx
  803763:	8b 12                	mov    (%edx),%edx
  803765:	89 10                	mov    %edx,(%eax)
  803767:	eb 0a                	jmp    803773 <merging+0x288>
  803769:	8b 45 0c             	mov    0xc(%ebp),%eax
  80376c:	8b 00                	mov    (%eax),%eax
  80376e:	a3 30 50 80 00       	mov    %eax,0x805030
  803773:	8b 45 0c             	mov    0xc(%ebp),%eax
  803776:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80377c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80377f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803786:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80378b:	48                   	dec    %eax
  80378c:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803791:	e9 72 01 00 00       	jmp    803908 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803796:	8b 45 10             	mov    0x10(%ebp),%eax
  803799:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80379c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037a0:	74 79                	je     80381b <merging+0x330>
  8037a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8037a6:	74 73                	je     80381b <merging+0x330>
  8037a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037ac:	74 06                	je     8037b4 <merging+0x2c9>
  8037ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037b2:	75 17                	jne    8037cb <merging+0x2e0>
  8037b4:	83 ec 04             	sub    $0x4,%esp
  8037b7:	68 08 4d 80 00       	push   $0x804d08
  8037bc:	68 94 01 00 00       	push   $0x194
  8037c1:	68 95 4c 80 00       	push   $0x804c95
  8037c6:	e8 cb d0 ff ff       	call   800896 <_panic>
  8037cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ce:	8b 10                	mov    (%eax),%edx
  8037d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d3:	89 10                	mov    %edx,(%eax)
  8037d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037d8:	8b 00                	mov    (%eax),%eax
  8037da:	85 c0                	test   %eax,%eax
  8037dc:	74 0b                	je     8037e9 <merging+0x2fe>
  8037de:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e1:	8b 00                	mov    (%eax),%eax
  8037e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037e6:	89 50 04             	mov    %edx,0x4(%eax)
  8037e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037ef:	89 10                	mov    %edx,(%eax)
  8037f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8037f7:	89 50 04             	mov    %edx,0x4(%eax)
  8037fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037fd:	8b 00                	mov    (%eax),%eax
  8037ff:	85 c0                	test   %eax,%eax
  803801:	75 08                	jne    80380b <merging+0x320>
  803803:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803806:	a3 34 50 80 00       	mov    %eax,0x805034
  80380b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803810:	40                   	inc    %eax
  803811:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803816:	e9 ce 00 00 00       	jmp    8038e9 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80381b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80381f:	74 65                	je     803886 <merging+0x39b>
  803821:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803825:	75 17                	jne    80383e <merging+0x353>
  803827:	83 ec 04             	sub    $0x4,%esp
  80382a:	68 e4 4c 80 00       	push   $0x804ce4
  80382f:	68 95 01 00 00       	push   $0x195
  803834:	68 95 4c 80 00       	push   $0x804c95
  803839:	e8 58 d0 ff ff       	call   800896 <_panic>
  80383e:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803844:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803847:	89 50 04             	mov    %edx,0x4(%eax)
  80384a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80384d:	8b 40 04             	mov    0x4(%eax),%eax
  803850:	85 c0                	test   %eax,%eax
  803852:	74 0c                	je     803860 <merging+0x375>
  803854:	a1 34 50 80 00       	mov    0x805034,%eax
  803859:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80385c:	89 10                	mov    %edx,(%eax)
  80385e:	eb 08                	jmp    803868 <merging+0x37d>
  803860:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803863:	a3 30 50 80 00       	mov    %eax,0x805030
  803868:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80386b:	a3 34 50 80 00       	mov    %eax,0x805034
  803870:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803873:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803879:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80387e:	40                   	inc    %eax
  80387f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803884:	eb 63                	jmp    8038e9 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803886:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80388a:	75 17                	jne    8038a3 <merging+0x3b8>
  80388c:	83 ec 04             	sub    $0x4,%esp
  80388f:	68 b0 4c 80 00       	push   $0x804cb0
  803894:	68 98 01 00 00       	push   $0x198
  803899:	68 95 4c 80 00       	push   $0x804c95
  80389e:	e8 f3 cf ff ff       	call   800896 <_panic>
  8038a3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8038a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038ac:	89 10                	mov    %edx,(%eax)
  8038ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038b1:	8b 00                	mov    (%eax),%eax
  8038b3:	85 c0                	test   %eax,%eax
  8038b5:	74 0d                	je     8038c4 <merging+0x3d9>
  8038b7:	a1 30 50 80 00       	mov    0x805030,%eax
  8038bc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038bf:	89 50 04             	mov    %edx,0x4(%eax)
  8038c2:	eb 08                	jmp    8038cc <merging+0x3e1>
  8038c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038c7:	a3 34 50 80 00       	mov    %eax,0x805034
  8038cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038cf:	a3 30 50 80 00       	mov    %eax,0x805030
  8038d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038de:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8038e3:	40                   	inc    %eax
  8038e4:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  8038e9:	83 ec 0c             	sub    $0xc,%esp
  8038ec:	ff 75 10             	pushl  0x10(%ebp)
  8038ef:	e8 f9 ed ff ff       	call   8026ed <get_block_size>
  8038f4:	83 c4 10             	add    $0x10,%esp
  8038f7:	83 ec 04             	sub    $0x4,%esp
  8038fa:	6a 00                	push   $0x0
  8038fc:	50                   	push   %eax
  8038fd:	ff 75 10             	pushl  0x10(%ebp)
  803900:	e8 39 f1 ff ff       	call   802a3e <set_block_data>
  803905:	83 c4 10             	add    $0x10,%esp
	}
}
  803908:	90                   	nop
  803909:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80390c:	c9                   	leave  
  80390d:	c3                   	ret    

0080390e <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80390e:	55                   	push   %ebp
  80390f:	89 e5                	mov    %esp,%ebp
  803911:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803914:	a1 30 50 80 00       	mov    0x805030,%eax
  803919:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80391c:	a1 34 50 80 00       	mov    0x805034,%eax
  803921:	3b 45 08             	cmp    0x8(%ebp),%eax
  803924:	73 1b                	jae    803941 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803926:	a1 34 50 80 00       	mov    0x805034,%eax
  80392b:	83 ec 04             	sub    $0x4,%esp
  80392e:	ff 75 08             	pushl  0x8(%ebp)
  803931:	6a 00                	push   $0x0
  803933:	50                   	push   %eax
  803934:	e8 b2 fb ff ff       	call   8034eb <merging>
  803939:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80393c:	e9 8b 00 00 00       	jmp    8039cc <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803941:	a1 30 50 80 00       	mov    0x805030,%eax
  803946:	3b 45 08             	cmp    0x8(%ebp),%eax
  803949:	76 18                	jbe    803963 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80394b:	a1 30 50 80 00       	mov    0x805030,%eax
  803950:	83 ec 04             	sub    $0x4,%esp
  803953:	ff 75 08             	pushl  0x8(%ebp)
  803956:	50                   	push   %eax
  803957:	6a 00                	push   $0x0
  803959:	e8 8d fb ff ff       	call   8034eb <merging>
  80395e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803961:	eb 69                	jmp    8039cc <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803963:	a1 30 50 80 00       	mov    0x805030,%eax
  803968:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80396b:	eb 39                	jmp    8039a6 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80396d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803970:	3b 45 08             	cmp    0x8(%ebp),%eax
  803973:	73 29                	jae    80399e <free_block+0x90>
  803975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803978:	8b 00                	mov    (%eax),%eax
  80397a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80397d:	76 1f                	jbe    80399e <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80397f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803982:	8b 00                	mov    (%eax),%eax
  803984:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803987:	83 ec 04             	sub    $0x4,%esp
  80398a:	ff 75 08             	pushl  0x8(%ebp)
  80398d:	ff 75 f0             	pushl  -0x10(%ebp)
  803990:	ff 75 f4             	pushl  -0xc(%ebp)
  803993:	e8 53 fb ff ff       	call   8034eb <merging>
  803998:	83 c4 10             	add    $0x10,%esp
			break;
  80399b:	90                   	nop
		}
	}
}
  80399c:	eb 2e                	jmp    8039cc <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80399e:	a1 38 50 80 00       	mov    0x805038,%eax
  8039a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039aa:	74 07                	je     8039b3 <free_block+0xa5>
  8039ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039af:	8b 00                	mov    (%eax),%eax
  8039b1:	eb 05                	jmp    8039b8 <free_block+0xaa>
  8039b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b8:	a3 38 50 80 00       	mov    %eax,0x805038
  8039bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8039c2:	85 c0                	test   %eax,%eax
  8039c4:	75 a7                	jne    80396d <free_block+0x5f>
  8039c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ca:	75 a1                	jne    80396d <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039cc:	90                   	nop
  8039cd:	c9                   	leave  
  8039ce:	c3                   	ret    

008039cf <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8039cf:	55                   	push   %ebp
  8039d0:	89 e5                	mov    %esp,%ebp
  8039d2:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8039d5:	ff 75 08             	pushl  0x8(%ebp)
  8039d8:	e8 10 ed ff ff       	call   8026ed <get_block_size>
  8039dd:	83 c4 04             	add    $0x4,%esp
  8039e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8039e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8039ea:	eb 17                	jmp    803a03 <copy_data+0x34>
  8039ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8039ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039f2:	01 c2                	add    %eax,%edx
  8039f4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8039f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fa:	01 c8                	add    %ecx,%eax
  8039fc:	8a 00                	mov    (%eax),%al
  8039fe:	88 02                	mov    %al,(%edx)
  803a00:	ff 45 fc             	incl   -0x4(%ebp)
  803a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a06:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803a09:	72 e1                	jb     8039ec <copy_data+0x1d>
}
  803a0b:	90                   	nop
  803a0c:	c9                   	leave  
  803a0d:	c3                   	ret    

00803a0e <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803a0e:	55                   	push   %ebp
  803a0f:	89 e5                	mov    %esp,%ebp
  803a11:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803a14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a18:	75 23                	jne    803a3d <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803a1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a1e:	74 13                	je     803a33 <realloc_block_FF+0x25>
  803a20:	83 ec 0c             	sub    $0xc,%esp
  803a23:	ff 75 0c             	pushl  0xc(%ebp)
  803a26:	e8 42 f0 ff ff       	call   802a6d <alloc_block_FF>
  803a2b:	83 c4 10             	add    $0x10,%esp
  803a2e:	e9 e4 06 00 00       	jmp    804117 <realloc_block_FF+0x709>
		return NULL;
  803a33:	b8 00 00 00 00       	mov    $0x0,%eax
  803a38:	e9 da 06 00 00       	jmp    804117 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803a3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a41:	75 18                	jne    803a5b <realloc_block_FF+0x4d>
	{
		free_block(va);
  803a43:	83 ec 0c             	sub    $0xc,%esp
  803a46:	ff 75 08             	pushl  0x8(%ebp)
  803a49:	e8 c0 fe ff ff       	call   80390e <free_block>
  803a4e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803a51:	b8 00 00 00 00       	mov    $0x0,%eax
  803a56:	e9 bc 06 00 00       	jmp    804117 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803a5b:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803a5f:	77 07                	ja     803a68 <realloc_block_FF+0x5a>
  803a61:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a6b:	83 e0 01             	and    $0x1,%eax
  803a6e:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a74:	83 c0 08             	add    $0x8,%eax
  803a77:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803a7a:	83 ec 0c             	sub    $0xc,%esp
  803a7d:	ff 75 08             	pushl  0x8(%ebp)
  803a80:	e8 68 ec ff ff       	call   8026ed <get_block_size>
  803a85:	83 c4 10             	add    $0x10,%esp
  803a88:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a8e:	83 e8 08             	sub    $0x8,%eax
  803a91:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803a94:	8b 45 08             	mov    0x8(%ebp),%eax
  803a97:	83 e8 04             	sub    $0x4,%eax
  803a9a:	8b 00                	mov    (%eax),%eax
  803a9c:	83 e0 fe             	and    $0xfffffffe,%eax
  803a9f:	89 c2                	mov    %eax,%edx
  803aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa4:	01 d0                	add    %edx,%eax
  803aa6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803aa9:	83 ec 0c             	sub    $0xc,%esp
  803aac:	ff 75 e4             	pushl  -0x1c(%ebp)
  803aaf:	e8 39 ec ff ff       	call   8026ed <get_block_size>
  803ab4:	83 c4 10             	add    $0x10,%esp
  803ab7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803aba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803abd:	83 e8 08             	sub    $0x8,%eax
  803ac0:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ac6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ac9:	75 08                	jne    803ad3 <realloc_block_FF+0xc5>
	{
		 return va;
  803acb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ace:	e9 44 06 00 00       	jmp    804117 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ad6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ad9:	0f 83 d5 03 00 00    	jae    803eb4 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803adf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae2:	2b 45 0c             	sub    0xc(%ebp),%eax
  803ae5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803ae8:	83 ec 0c             	sub    $0xc,%esp
  803aeb:	ff 75 e4             	pushl  -0x1c(%ebp)
  803aee:	e8 13 ec ff ff       	call   802706 <is_free_block>
  803af3:	83 c4 10             	add    $0x10,%esp
  803af6:	84 c0                	test   %al,%al
  803af8:	0f 84 3b 01 00 00    	je     803c39 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803afe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b01:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b04:	01 d0                	add    %edx,%eax
  803b06:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803b09:	83 ec 04             	sub    $0x4,%esp
  803b0c:	6a 01                	push   $0x1
  803b0e:	ff 75 f0             	pushl  -0x10(%ebp)
  803b11:	ff 75 08             	pushl  0x8(%ebp)
  803b14:	e8 25 ef ff ff       	call   802a3e <set_block_data>
  803b19:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1f:	83 e8 04             	sub    $0x4,%eax
  803b22:	8b 00                	mov    (%eax),%eax
  803b24:	83 e0 fe             	and    $0xfffffffe,%eax
  803b27:	89 c2                	mov    %eax,%edx
  803b29:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2c:	01 d0                	add    %edx,%eax
  803b2e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803b31:	83 ec 04             	sub    $0x4,%esp
  803b34:	6a 00                	push   $0x0
  803b36:	ff 75 cc             	pushl  -0x34(%ebp)
  803b39:	ff 75 c8             	pushl  -0x38(%ebp)
  803b3c:	e8 fd ee ff ff       	call   802a3e <set_block_data>
  803b41:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803b44:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b48:	74 06                	je     803b50 <realloc_block_FF+0x142>
  803b4a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803b4e:	75 17                	jne    803b67 <realloc_block_FF+0x159>
  803b50:	83 ec 04             	sub    $0x4,%esp
  803b53:	68 08 4d 80 00       	push   $0x804d08
  803b58:	68 f6 01 00 00       	push   $0x1f6
  803b5d:	68 95 4c 80 00       	push   $0x804c95
  803b62:	e8 2f cd ff ff       	call   800896 <_panic>
  803b67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b6a:	8b 10                	mov    (%eax),%edx
  803b6c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b6f:	89 10                	mov    %edx,(%eax)
  803b71:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b74:	8b 00                	mov    (%eax),%eax
  803b76:	85 c0                	test   %eax,%eax
  803b78:	74 0b                	je     803b85 <realloc_block_FF+0x177>
  803b7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7d:	8b 00                	mov    (%eax),%eax
  803b7f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b82:	89 50 04             	mov    %edx,0x4(%eax)
  803b85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b88:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b8b:	89 10                	mov    %edx,(%eax)
  803b8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b93:	89 50 04             	mov    %edx,0x4(%eax)
  803b96:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b99:	8b 00                	mov    (%eax),%eax
  803b9b:	85 c0                	test   %eax,%eax
  803b9d:	75 08                	jne    803ba7 <realloc_block_FF+0x199>
  803b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ba2:	a3 34 50 80 00       	mov    %eax,0x805034
  803ba7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bac:	40                   	inc    %eax
  803bad:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803bb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bb6:	75 17                	jne    803bcf <realloc_block_FF+0x1c1>
  803bb8:	83 ec 04             	sub    $0x4,%esp
  803bbb:	68 77 4c 80 00       	push   $0x804c77
  803bc0:	68 f7 01 00 00       	push   $0x1f7
  803bc5:	68 95 4c 80 00       	push   $0x804c95
  803bca:	e8 c7 cc ff ff       	call   800896 <_panic>
  803bcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd2:	8b 00                	mov    (%eax),%eax
  803bd4:	85 c0                	test   %eax,%eax
  803bd6:	74 10                	je     803be8 <realloc_block_FF+0x1da>
  803bd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bdb:	8b 00                	mov    (%eax),%eax
  803bdd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803be0:	8b 52 04             	mov    0x4(%edx),%edx
  803be3:	89 50 04             	mov    %edx,0x4(%eax)
  803be6:	eb 0b                	jmp    803bf3 <realloc_block_FF+0x1e5>
  803be8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803beb:	8b 40 04             	mov    0x4(%eax),%eax
  803bee:	a3 34 50 80 00       	mov    %eax,0x805034
  803bf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf6:	8b 40 04             	mov    0x4(%eax),%eax
  803bf9:	85 c0                	test   %eax,%eax
  803bfb:	74 0f                	je     803c0c <realloc_block_FF+0x1fe>
  803bfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c00:	8b 40 04             	mov    0x4(%eax),%eax
  803c03:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c06:	8b 12                	mov    (%edx),%edx
  803c08:	89 10                	mov    %edx,(%eax)
  803c0a:	eb 0a                	jmp    803c16 <realloc_block_FF+0x208>
  803c0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c0f:	8b 00                	mov    (%eax),%eax
  803c11:	a3 30 50 80 00       	mov    %eax,0x805030
  803c16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c29:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c2e:	48                   	dec    %eax
  803c2f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c34:	e9 73 02 00 00       	jmp    803eac <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803c39:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803c3d:	0f 86 69 02 00 00    	jbe    803eac <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803c43:	83 ec 04             	sub    $0x4,%esp
  803c46:	6a 01                	push   $0x1
  803c48:	ff 75 f0             	pushl  -0x10(%ebp)
  803c4b:	ff 75 08             	pushl  0x8(%ebp)
  803c4e:	e8 eb ed ff ff       	call   802a3e <set_block_data>
  803c53:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803c56:	8b 45 08             	mov    0x8(%ebp),%eax
  803c59:	83 e8 04             	sub    $0x4,%eax
  803c5c:	8b 00                	mov    (%eax),%eax
  803c5e:	83 e0 fe             	and    $0xfffffffe,%eax
  803c61:	89 c2                	mov    %eax,%edx
  803c63:	8b 45 08             	mov    0x8(%ebp),%eax
  803c66:	01 d0                	add    %edx,%eax
  803c68:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803c6b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c70:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803c73:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803c77:	75 68                	jne    803ce1 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c79:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c7d:	75 17                	jne    803c96 <realloc_block_FF+0x288>
  803c7f:	83 ec 04             	sub    $0x4,%esp
  803c82:	68 b0 4c 80 00       	push   $0x804cb0
  803c87:	68 06 02 00 00       	push   $0x206
  803c8c:	68 95 4c 80 00       	push   $0x804c95
  803c91:	e8 00 cc ff ff       	call   800896 <_panic>
  803c96:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803c9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c9f:	89 10                	mov    %edx,(%eax)
  803ca1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca4:	8b 00                	mov    (%eax),%eax
  803ca6:	85 c0                	test   %eax,%eax
  803ca8:	74 0d                	je     803cb7 <realloc_block_FF+0x2a9>
  803caa:	a1 30 50 80 00       	mov    0x805030,%eax
  803caf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cb2:	89 50 04             	mov    %edx,0x4(%eax)
  803cb5:	eb 08                	jmp    803cbf <realloc_block_FF+0x2b1>
  803cb7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cba:	a3 34 50 80 00       	mov    %eax,0x805034
  803cbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc2:	a3 30 50 80 00       	mov    %eax,0x805030
  803cc7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cd1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803cd6:	40                   	inc    %eax
  803cd7:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803cdc:	e9 b0 01 00 00       	jmp    803e91 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803ce1:	a1 30 50 80 00       	mov    0x805030,%eax
  803ce6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ce9:	76 68                	jbe    803d53 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ceb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cef:	75 17                	jne    803d08 <realloc_block_FF+0x2fa>
  803cf1:	83 ec 04             	sub    $0x4,%esp
  803cf4:	68 b0 4c 80 00       	push   $0x804cb0
  803cf9:	68 0b 02 00 00       	push   $0x20b
  803cfe:	68 95 4c 80 00       	push   $0x804c95
  803d03:	e8 8e cb ff ff       	call   800896 <_panic>
  803d08:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803d0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d11:	89 10                	mov    %edx,(%eax)
  803d13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d16:	8b 00                	mov    (%eax),%eax
  803d18:	85 c0                	test   %eax,%eax
  803d1a:	74 0d                	je     803d29 <realloc_block_FF+0x31b>
  803d1c:	a1 30 50 80 00       	mov    0x805030,%eax
  803d21:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d24:	89 50 04             	mov    %edx,0x4(%eax)
  803d27:	eb 08                	jmp    803d31 <realloc_block_FF+0x323>
  803d29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d2c:	a3 34 50 80 00       	mov    %eax,0x805034
  803d31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d34:	a3 30 50 80 00       	mov    %eax,0x805030
  803d39:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d43:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d48:	40                   	inc    %eax
  803d49:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803d4e:	e9 3e 01 00 00       	jmp    803e91 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803d53:	a1 30 50 80 00       	mov    0x805030,%eax
  803d58:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d5b:	73 68                	jae    803dc5 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d5d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d61:	75 17                	jne    803d7a <realloc_block_FF+0x36c>
  803d63:	83 ec 04             	sub    $0x4,%esp
  803d66:	68 e4 4c 80 00       	push   $0x804ce4
  803d6b:	68 10 02 00 00       	push   $0x210
  803d70:	68 95 4c 80 00       	push   $0x804c95
  803d75:	e8 1c cb ff ff       	call   800896 <_panic>
  803d7a:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803d80:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d83:	89 50 04             	mov    %edx,0x4(%eax)
  803d86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d89:	8b 40 04             	mov    0x4(%eax),%eax
  803d8c:	85 c0                	test   %eax,%eax
  803d8e:	74 0c                	je     803d9c <realloc_block_FF+0x38e>
  803d90:	a1 34 50 80 00       	mov    0x805034,%eax
  803d95:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d98:	89 10                	mov    %edx,(%eax)
  803d9a:	eb 08                	jmp    803da4 <realloc_block_FF+0x396>
  803d9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d9f:	a3 30 50 80 00       	mov    %eax,0x805030
  803da4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803da7:	a3 34 50 80 00       	mov    %eax,0x805034
  803dac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803daf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803db5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803dba:	40                   	inc    %eax
  803dbb:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803dc0:	e9 cc 00 00 00       	jmp    803e91 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803dc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803dcc:	a1 30 50 80 00       	mov    0x805030,%eax
  803dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803dd4:	e9 8a 00 00 00       	jmp    803e63 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ddc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ddf:	73 7a                	jae    803e5b <realloc_block_FF+0x44d>
  803de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de4:	8b 00                	mov    (%eax),%eax
  803de6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803de9:	73 70                	jae    803e5b <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803deb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803def:	74 06                	je     803df7 <realloc_block_FF+0x3e9>
  803df1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803df5:	75 17                	jne    803e0e <realloc_block_FF+0x400>
  803df7:	83 ec 04             	sub    $0x4,%esp
  803dfa:	68 08 4d 80 00       	push   $0x804d08
  803dff:	68 1a 02 00 00       	push   $0x21a
  803e04:	68 95 4c 80 00       	push   $0x804c95
  803e09:	e8 88 ca ff ff       	call   800896 <_panic>
  803e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e11:	8b 10                	mov    (%eax),%edx
  803e13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e16:	89 10                	mov    %edx,(%eax)
  803e18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e1b:	8b 00                	mov    (%eax),%eax
  803e1d:	85 c0                	test   %eax,%eax
  803e1f:	74 0b                	je     803e2c <realloc_block_FF+0x41e>
  803e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e24:	8b 00                	mov    (%eax),%eax
  803e26:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e29:	89 50 04             	mov    %edx,0x4(%eax)
  803e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e32:	89 10                	mov    %edx,(%eax)
  803e34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e3a:	89 50 04             	mov    %edx,0x4(%eax)
  803e3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e40:	8b 00                	mov    (%eax),%eax
  803e42:	85 c0                	test   %eax,%eax
  803e44:	75 08                	jne    803e4e <realloc_block_FF+0x440>
  803e46:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e49:	a3 34 50 80 00       	mov    %eax,0x805034
  803e4e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e53:	40                   	inc    %eax
  803e54:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803e59:	eb 36                	jmp    803e91 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803e5b:	a1 38 50 80 00       	mov    0x805038,%eax
  803e60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e67:	74 07                	je     803e70 <realloc_block_FF+0x462>
  803e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e6c:	8b 00                	mov    (%eax),%eax
  803e6e:	eb 05                	jmp    803e75 <realloc_block_FF+0x467>
  803e70:	b8 00 00 00 00       	mov    $0x0,%eax
  803e75:	a3 38 50 80 00       	mov    %eax,0x805038
  803e7a:	a1 38 50 80 00       	mov    0x805038,%eax
  803e7f:	85 c0                	test   %eax,%eax
  803e81:	0f 85 52 ff ff ff    	jne    803dd9 <realloc_block_FF+0x3cb>
  803e87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e8b:	0f 85 48 ff ff ff    	jne    803dd9 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803e91:	83 ec 04             	sub    $0x4,%esp
  803e94:	6a 00                	push   $0x0
  803e96:	ff 75 d8             	pushl  -0x28(%ebp)
  803e99:	ff 75 d4             	pushl  -0x2c(%ebp)
  803e9c:	e8 9d eb ff ff       	call   802a3e <set_block_data>
  803ea1:	83 c4 10             	add    $0x10,%esp
				return va;
  803ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea7:	e9 6b 02 00 00       	jmp    804117 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803eac:	8b 45 08             	mov    0x8(%ebp),%eax
  803eaf:	e9 63 02 00 00       	jmp    804117 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803eb7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803eba:	0f 86 4d 02 00 00    	jbe    80410d <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803ec0:	83 ec 0c             	sub    $0xc,%esp
  803ec3:	ff 75 e4             	pushl  -0x1c(%ebp)
  803ec6:	e8 3b e8 ff ff       	call   802706 <is_free_block>
  803ecb:	83 c4 10             	add    $0x10,%esp
  803ece:	84 c0                	test   %al,%al
  803ed0:	0f 84 37 02 00 00    	je     80410d <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ed9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803edc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803edf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803ee2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803ee5:	76 38                	jbe    803f1f <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803ee7:	83 ec 0c             	sub    $0xc,%esp
  803eea:	ff 75 0c             	pushl  0xc(%ebp)
  803eed:	e8 7b eb ff ff       	call   802a6d <alloc_block_FF>
  803ef2:	83 c4 10             	add    $0x10,%esp
  803ef5:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803ef8:	83 ec 08             	sub    $0x8,%esp
  803efb:	ff 75 c0             	pushl  -0x40(%ebp)
  803efe:	ff 75 08             	pushl  0x8(%ebp)
  803f01:	e8 c9 fa ff ff       	call   8039cf <copy_data>
  803f06:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803f09:	83 ec 0c             	sub    $0xc,%esp
  803f0c:	ff 75 08             	pushl  0x8(%ebp)
  803f0f:	e8 fa f9 ff ff       	call   80390e <free_block>
  803f14:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803f17:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803f1a:	e9 f8 01 00 00       	jmp    804117 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803f1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f22:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803f25:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803f28:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803f2c:	0f 87 a0 00 00 00    	ja     803fd2 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803f32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f36:	75 17                	jne    803f4f <realloc_block_FF+0x541>
  803f38:	83 ec 04             	sub    $0x4,%esp
  803f3b:	68 77 4c 80 00       	push   $0x804c77
  803f40:	68 38 02 00 00       	push   $0x238
  803f45:	68 95 4c 80 00       	push   $0x804c95
  803f4a:	e8 47 c9 ff ff       	call   800896 <_panic>
  803f4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f52:	8b 00                	mov    (%eax),%eax
  803f54:	85 c0                	test   %eax,%eax
  803f56:	74 10                	je     803f68 <realloc_block_FF+0x55a>
  803f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f5b:	8b 00                	mov    (%eax),%eax
  803f5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f60:	8b 52 04             	mov    0x4(%edx),%edx
  803f63:	89 50 04             	mov    %edx,0x4(%eax)
  803f66:	eb 0b                	jmp    803f73 <realloc_block_FF+0x565>
  803f68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f6b:	8b 40 04             	mov    0x4(%eax),%eax
  803f6e:	a3 34 50 80 00       	mov    %eax,0x805034
  803f73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f76:	8b 40 04             	mov    0x4(%eax),%eax
  803f79:	85 c0                	test   %eax,%eax
  803f7b:	74 0f                	je     803f8c <realloc_block_FF+0x57e>
  803f7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f80:	8b 40 04             	mov    0x4(%eax),%eax
  803f83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f86:	8b 12                	mov    (%edx),%edx
  803f88:	89 10                	mov    %edx,(%eax)
  803f8a:	eb 0a                	jmp    803f96 <realloc_block_FF+0x588>
  803f8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f8f:	8b 00                	mov    (%eax),%eax
  803f91:	a3 30 50 80 00       	mov    %eax,0x805030
  803f96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fa9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803fae:	48                   	dec    %eax
  803faf:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803fb4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fba:	01 d0                	add    %edx,%eax
  803fbc:	83 ec 04             	sub    $0x4,%esp
  803fbf:	6a 01                	push   $0x1
  803fc1:	50                   	push   %eax
  803fc2:	ff 75 08             	pushl  0x8(%ebp)
  803fc5:	e8 74 ea ff ff       	call   802a3e <set_block_data>
  803fca:	83 c4 10             	add    $0x10,%esp
  803fcd:	e9 36 01 00 00       	jmp    804108 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803fd2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803fd5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803fd8:	01 d0                	add    %edx,%eax
  803fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803fdd:	83 ec 04             	sub    $0x4,%esp
  803fe0:	6a 01                	push   $0x1
  803fe2:	ff 75 f0             	pushl  -0x10(%ebp)
  803fe5:	ff 75 08             	pushl  0x8(%ebp)
  803fe8:	e8 51 ea ff ff       	call   802a3e <set_block_data>
  803fed:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ff3:	83 e8 04             	sub    $0x4,%eax
  803ff6:	8b 00                	mov    (%eax),%eax
  803ff8:	83 e0 fe             	and    $0xfffffffe,%eax
  803ffb:	89 c2                	mov    %eax,%edx
  803ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  804000:	01 d0                	add    %edx,%eax
  804002:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804005:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804009:	74 06                	je     804011 <realloc_block_FF+0x603>
  80400b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80400f:	75 17                	jne    804028 <realloc_block_FF+0x61a>
  804011:	83 ec 04             	sub    $0x4,%esp
  804014:	68 08 4d 80 00       	push   $0x804d08
  804019:	68 44 02 00 00       	push   $0x244
  80401e:	68 95 4c 80 00       	push   $0x804c95
  804023:	e8 6e c8 ff ff       	call   800896 <_panic>
  804028:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80402b:	8b 10                	mov    (%eax),%edx
  80402d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804030:	89 10                	mov    %edx,(%eax)
  804032:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804035:	8b 00                	mov    (%eax),%eax
  804037:	85 c0                	test   %eax,%eax
  804039:	74 0b                	je     804046 <realloc_block_FF+0x638>
  80403b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80403e:	8b 00                	mov    (%eax),%eax
  804040:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804043:	89 50 04             	mov    %edx,0x4(%eax)
  804046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804049:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80404c:	89 10                	mov    %edx,(%eax)
  80404e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804051:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804054:	89 50 04             	mov    %edx,0x4(%eax)
  804057:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80405a:	8b 00                	mov    (%eax),%eax
  80405c:	85 c0                	test   %eax,%eax
  80405e:	75 08                	jne    804068 <realloc_block_FF+0x65a>
  804060:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804063:	a3 34 50 80 00       	mov    %eax,0x805034
  804068:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80406d:	40                   	inc    %eax
  80406e:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804073:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804077:	75 17                	jne    804090 <realloc_block_FF+0x682>
  804079:	83 ec 04             	sub    $0x4,%esp
  80407c:	68 77 4c 80 00       	push   $0x804c77
  804081:	68 45 02 00 00       	push   $0x245
  804086:	68 95 4c 80 00       	push   $0x804c95
  80408b:	e8 06 c8 ff ff       	call   800896 <_panic>
  804090:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804093:	8b 00                	mov    (%eax),%eax
  804095:	85 c0                	test   %eax,%eax
  804097:	74 10                	je     8040a9 <realloc_block_FF+0x69b>
  804099:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80409c:	8b 00                	mov    (%eax),%eax
  80409e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040a1:	8b 52 04             	mov    0x4(%edx),%edx
  8040a4:	89 50 04             	mov    %edx,0x4(%eax)
  8040a7:	eb 0b                	jmp    8040b4 <realloc_block_FF+0x6a6>
  8040a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040ac:	8b 40 04             	mov    0x4(%eax),%eax
  8040af:	a3 34 50 80 00       	mov    %eax,0x805034
  8040b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040b7:	8b 40 04             	mov    0x4(%eax),%eax
  8040ba:	85 c0                	test   %eax,%eax
  8040bc:	74 0f                	je     8040cd <realloc_block_FF+0x6bf>
  8040be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c1:	8b 40 04             	mov    0x4(%eax),%eax
  8040c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040c7:	8b 12                	mov    (%edx),%edx
  8040c9:	89 10                	mov    %edx,(%eax)
  8040cb:	eb 0a                	jmp    8040d7 <realloc_block_FF+0x6c9>
  8040cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040d0:	8b 00                	mov    (%eax),%eax
  8040d2:	a3 30 50 80 00       	mov    %eax,0x805030
  8040d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040ea:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8040ef:	48                   	dec    %eax
  8040f0:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  8040f5:	83 ec 04             	sub    $0x4,%esp
  8040f8:	6a 00                	push   $0x0
  8040fa:	ff 75 bc             	pushl  -0x44(%ebp)
  8040fd:	ff 75 b8             	pushl  -0x48(%ebp)
  804100:	e8 39 e9 ff ff       	call   802a3e <set_block_data>
  804105:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804108:	8b 45 08             	mov    0x8(%ebp),%eax
  80410b:	eb 0a                	jmp    804117 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80410d:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804114:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804117:	c9                   	leave  
  804118:	c3                   	ret    

00804119 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804119:	55                   	push   %ebp
  80411a:	89 e5                	mov    %esp,%ebp
  80411c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80411f:	83 ec 04             	sub    $0x4,%esp
  804122:	68 74 4d 80 00       	push   $0x804d74
  804127:	68 58 02 00 00       	push   $0x258
  80412c:	68 95 4c 80 00       	push   $0x804c95
  804131:	e8 60 c7 ff ff       	call   800896 <_panic>

00804136 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804136:	55                   	push   %ebp
  804137:	89 e5                	mov    %esp,%ebp
  804139:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80413c:	83 ec 04             	sub    $0x4,%esp
  80413f:	68 9c 4d 80 00       	push   $0x804d9c
  804144:	68 61 02 00 00       	push   $0x261
  804149:	68 95 4c 80 00       	push   $0x804c95
  80414e:	e8 43 c7 ff ff       	call   800896 <_panic>
  804153:	90                   	nop

00804154 <__udivdi3>:
  804154:	55                   	push   %ebp
  804155:	57                   	push   %edi
  804156:	56                   	push   %esi
  804157:	53                   	push   %ebx
  804158:	83 ec 1c             	sub    $0x1c,%esp
  80415b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80415f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804163:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804167:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80416b:	89 ca                	mov    %ecx,%edx
  80416d:	89 f8                	mov    %edi,%eax
  80416f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804173:	85 f6                	test   %esi,%esi
  804175:	75 2d                	jne    8041a4 <__udivdi3+0x50>
  804177:	39 cf                	cmp    %ecx,%edi
  804179:	77 65                	ja     8041e0 <__udivdi3+0x8c>
  80417b:	89 fd                	mov    %edi,%ebp
  80417d:	85 ff                	test   %edi,%edi
  80417f:	75 0b                	jne    80418c <__udivdi3+0x38>
  804181:	b8 01 00 00 00       	mov    $0x1,%eax
  804186:	31 d2                	xor    %edx,%edx
  804188:	f7 f7                	div    %edi
  80418a:	89 c5                	mov    %eax,%ebp
  80418c:	31 d2                	xor    %edx,%edx
  80418e:	89 c8                	mov    %ecx,%eax
  804190:	f7 f5                	div    %ebp
  804192:	89 c1                	mov    %eax,%ecx
  804194:	89 d8                	mov    %ebx,%eax
  804196:	f7 f5                	div    %ebp
  804198:	89 cf                	mov    %ecx,%edi
  80419a:	89 fa                	mov    %edi,%edx
  80419c:	83 c4 1c             	add    $0x1c,%esp
  80419f:	5b                   	pop    %ebx
  8041a0:	5e                   	pop    %esi
  8041a1:	5f                   	pop    %edi
  8041a2:	5d                   	pop    %ebp
  8041a3:	c3                   	ret    
  8041a4:	39 ce                	cmp    %ecx,%esi
  8041a6:	77 28                	ja     8041d0 <__udivdi3+0x7c>
  8041a8:	0f bd fe             	bsr    %esi,%edi
  8041ab:	83 f7 1f             	xor    $0x1f,%edi
  8041ae:	75 40                	jne    8041f0 <__udivdi3+0x9c>
  8041b0:	39 ce                	cmp    %ecx,%esi
  8041b2:	72 0a                	jb     8041be <__udivdi3+0x6a>
  8041b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8041b8:	0f 87 9e 00 00 00    	ja     80425c <__udivdi3+0x108>
  8041be:	b8 01 00 00 00       	mov    $0x1,%eax
  8041c3:	89 fa                	mov    %edi,%edx
  8041c5:	83 c4 1c             	add    $0x1c,%esp
  8041c8:	5b                   	pop    %ebx
  8041c9:	5e                   	pop    %esi
  8041ca:	5f                   	pop    %edi
  8041cb:	5d                   	pop    %ebp
  8041cc:	c3                   	ret    
  8041cd:	8d 76 00             	lea    0x0(%esi),%esi
  8041d0:	31 ff                	xor    %edi,%edi
  8041d2:	31 c0                	xor    %eax,%eax
  8041d4:	89 fa                	mov    %edi,%edx
  8041d6:	83 c4 1c             	add    $0x1c,%esp
  8041d9:	5b                   	pop    %ebx
  8041da:	5e                   	pop    %esi
  8041db:	5f                   	pop    %edi
  8041dc:	5d                   	pop    %ebp
  8041dd:	c3                   	ret    
  8041de:	66 90                	xchg   %ax,%ax
  8041e0:	89 d8                	mov    %ebx,%eax
  8041e2:	f7 f7                	div    %edi
  8041e4:	31 ff                	xor    %edi,%edi
  8041e6:	89 fa                	mov    %edi,%edx
  8041e8:	83 c4 1c             	add    $0x1c,%esp
  8041eb:	5b                   	pop    %ebx
  8041ec:	5e                   	pop    %esi
  8041ed:	5f                   	pop    %edi
  8041ee:	5d                   	pop    %ebp
  8041ef:	c3                   	ret    
  8041f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8041f5:	89 eb                	mov    %ebp,%ebx
  8041f7:	29 fb                	sub    %edi,%ebx
  8041f9:	89 f9                	mov    %edi,%ecx
  8041fb:	d3 e6                	shl    %cl,%esi
  8041fd:	89 c5                	mov    %eax,%ebp
  8041ff:	88 d9                	mov    %bl,%cl
  804201:	d3 ed                	shr    %cl,%ebp
  804203:	89 e9                	mov    %ebp,%ecx
  804205:	09 f1                	or     %esi,%ecx
  804207:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80420b:	89 f9                	mov    %edi,%ecx
  80420d:	d3 e0                	shl    %cl,%eax
  80420f:	89 c5                	mov    %eax,%ebp
  804211:	89 d6                	mov    %edx,%esi
  804213:	88 d9                	mov    %bl,%cl
  804215:	d3 ee                	shr    %cl,%esi
  804217:	89 f9                	mov    %edi,%ecx
  804219:	d3 e2                	shl    %cl,%edx
  80421b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80421f:	88 d9                	mov    %bl,%cl
  804221:	d3 e8                	shr    %cl,%eax
  804223:	09 c2                	or     %eax,%edx
  804225:	89 d0                	mov    %edx,%eax
  804227:	89 f2                	mov    %esi,%edx
  804229:	f7 74 24 0c          	divl   0xc(%esp)
  80422d:	89 d6                	mov    %edx,%esi
  80422f:	89 c3                	mov    %eax,%ebx
  804231:	f7 e5                	mul    %ebp
  804233:	39 d6                	cmp    %edx,%esi
  804235:	72 19                	jb     804250 <__udivdi3+0xfc>
  804237:	74 0b                	je     804244 <__udivdi3+0xf0>
  804239:	89 d8                	mov    %ebx,%eax
  80423b:	31 ff                	xor    %edi,%edi
  80423d:	e9 58 ff ff ff       	jmp    80419a <__udivdi3+0x46>
  804242:	66 90                	xchg   %ax,%ax
  804244:	8b 54 24 08          	mov    0x8(%esp),%edx
  804248:	89 f9                	mov    %edi,%ecx
  80424a:	d3 e2                	shl    %cl,%edx
  80424c:	39 c2                	cmp    %eax,%edx
  80424e:	73 e9                	jae    804239 <__udivdi3+0xe5>
  804250:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804253:	31 ff                	xor    %edi,%edi
  804255:	e9 40 ff ff ff       	jmp    80419a <__udivdi3+0x46>
  80425a:	66 90                	xchg   %ax,%ax
  80425c:	31 c0                	xor    %eax,%eax
  80425e:	e9 37 ff ff ff       	jmp    80419a <__udivdi3+0x46>
  804263:	90                   	nop

00804264 <__umoddi3>:
  804264:	55                   	push   %ebp
  804265:	57                   	push   %edi
  804266:	56                   	push   %esi
  804267:	53                   	push   %ebx
  804268:	83 ec 1c             	sub    $0x1c,%esp
  80426b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80426f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804273:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804277:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80427b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80427f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804283:	89 f3                	mov    %esi,%ebx
  804285:	89 fa                	mov    %edi,%edx
  804287:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80428b:	89 34 24             	mov    %esi,(%esp)
  80428e:	85 c0                	test   %eax,%eax
  804290:	75 1a                	jne    8042ac <__umoddi3+0x48>
  804292:	39 f7                	cmp    %esi,%edi
  804294:	0f 86 a2 00 00 00    	jbe    80433c <__umoddi3+0xd8>
  80429a:	89 c8                	mov    %ecx,%eax
  80429c:	89 f2                	mov    %esi,%edx
  80429e:	f7 f7                	div    %edi
  8042a0:	89 d0                	mov    %edx,%eax
  8042a2:	31 d2                	xor    %edx,%edx
  8042a4:	83 c4 1c             	add    $0x1c,%esp
  8042a7:	5b                   	pop    %ebx
  8042a8:	5e                   	pop    %esi
  8042a9:	5f                   	pop    %edi
  8042aa:	5d                   	pop    %ebp
  8042ab:	c3                   	ret    
  8042ac:	39 f0                	cmp    %esi,%eax
  8042ae:	0f 87 ac 00 00 00    	ja     804360 <__umoddi3+0xfc>
  8042b4:	0f bd e8             	bsr    %eax,%ebp
  8042b7:	83 f5 1f             	xor    $0x1f,%ebp
  8042ba:	0f 84 ac 00 00 00    	je     80436c <__umoddi3+0x108>
  8042c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8042c5:	29 ef                	sub    %ebp,%edi
  8042c7:	89 fe                	mov    %edi,%esi
  8042c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8042cd:	89 e9                	mov    %ebp,%ecx
  8042cf:	d3 e0                	shl    %cl,%eax
  8042d1:	89 d7                	mov    %edx,%edi
  8042d3:	89 f1                	mov    %esi,%ecx
  8042d5:	d3 ef                	shr    %cl,%edi
  8042d7:	09 c7                	or     %eax,%edi
  8042d9:	89 e9                	mov    %ebp,%ecx
  8042db:	d3 e2                	shl    %cl,%edx
  8042dd:	89 14 24             	mov    %edx,(%esp)
  8042e0:	89 d8                	mov    %ebx,%eax
  8042e2:	d3 e0                	shl    %cl,%eax
  8042e4:	89 c2                	mov    %eax,%edx
  8042e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042ea:	d3 e0                	shl    %cl,%eax
  8042ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042f4:	89 f1                	mov    %esi,%ecx
  8042f6:	d3 e8                	shr    %cl,%eax
  8042f8:	09 d0                	or     %edx,%eax
  8042fa:	d3 eb                	shr    %cl,%ebx
  8042fc:	89 da                	mov    %ebx,%edx
  8042fe:	f7 f7                	div    %edi
  804300:	89 d3                	mov    %edx,%ebx
  804302:	f7 24 24             	mull   (%esp)
  804305:	89 c6                	mov    %eax,%esi
  804307:	89 d1                	mov    %edx,%ecx
  804309:	39 d3                	cmp    %edx,%ebx
  80430b:	0f 82 87 00 00 00    	jb     804398 <__umoddi3+0x134>
  804311:	0f 84 91 00 00 00    	je     8043a8 <__umoddi3+0x144>
  804317:	8b 54 24 04          	mov    0x4(%esp),%edx
  80431b:	29 f2                	sub    %esi,%edx
  80431d:	19 cb                	sbb    %ecx,%ebx
  80431f:	89 d8                	mov    %ebx,%eax
  804321:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804325:	d3 e0                	shl    %cl,%eax
  804327:	89 e9                	mov    %ebp,%ecx
  804329:	d3 ea                	shr    %cl,%edx
  80432b:	09 d0                	or     %edx,%eax
  80432d:	89 e9                	mov    %ebp,%ecx
  80432f:	d3 eb                	shr    %cl,%ebx
  804331:	89 da                	mov    %ebx,%edx
  804333:	83 c4 1c             	add    $0x1c,%esp
  804336:	5b                   	pop    %ebx
  804337:	5e                   	pop    %esi
  804338:	5f                   	pop    %edi
  804339:	5d                   	pop    %ebp
  80433a:	c3                   	ret    
  80433b:	90                   	nop
  80433c:	89 fd                	mov    %edi,%ebp
  80433e:	85 ff                	test   %edi,%edi
  804340:	75 0b                	jne    80434d <__umoddi3+0xe9>
  804342:	b8 01 00 00 00       	mov    $0x1,%eax
  804347:	31 d2                	xor    %edx,%edx
  804349:	f7 f7                	div    %edi
  80434b:	89 c5                	mov    %eax,%ebp
  80434d:	89 f0                	mov    %esi,%eax
  80434f:	31 d2                	xor    %edx,%edx
  804351:	f7 f5                	div    %ebp
  804353:	89 c8                	mov    %ecx,%eax
  804355:	f7 f5                	div    %ebp
  804357:	89 d0                	mov    %edx,%eax
  804359:	e9 44 ff ff ff       	jmp    8042a2 <__umoddi3+0x3e>
  80435e:	66 90                	xchg   %ax,%ax
  804360:	89 c8                	mov    %ecx,%eax
  804362:	89 f2                	mov    %esi,%edx
  804364:	83 c4 1c             	add    $0x1c,%esp
  804367:	5b                   	pop    %ebx
  804368:	5e                   	pop    %esi
  804369:	5f                   	pop    %edi
  80436a:	5d                   	pop    %ebp
  80436b:	c3                   	ret    
  80436c:	3b 04 24             	cmp    (%esp),%eax
  80436f:	72 06                	jb     804377 <__umoddi3+0x113>
  804371:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804375:	77 0f                	ja     804386 <__umoddi3+0x122>
  804377:	89 f2                	mov    %esi,%edx
  804379:	29 f9                	sub    %edi,%ecx
  80437b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80437f:	89 14 24             	mov    %edx,(%esp)
  804382:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804386:	8b 44 24 04          	mov    0x4(%esp),%eax
  80438a:	8b 14 24             	mov    (%esp),%edx
  80438d:	83 c4 1c             	add    $0x1c,%esp
  804390:	5b                   	pop    %ebx
  804391:	5e                   	pop    %esi
  804392:	5f                   	pop    %edi
  804393:	5d                   	pop    %ebp
  804394:	c3                   	ret    
  804395:	8d 76 00             	lea    0x0(%esi),%esi
  804398:	2b 04 24             	sub    (%esp),%eax
  80439b:	19 fa                	sbb    %edi,%edx
  80439d:	89 d1                	mov    %edx,%ecx
  80439f:	89 c6                	mov    %eax,%esi
  8043a1:	e9 71 ff ff ff       	jmp    804317 <__umoddi3+0xb3>
  8043a6:	66 90                	xchg   %ax,%ax
  8043a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8043ac:	72 ea                	jb     804398 <__umoddi3+0x134>
  8043ae:	89 d9                	mov    %ebx,%ecx
  8043b0:	e9 62 ff ff ff       	jmp    804317 <__umoddi3+0xb3>
