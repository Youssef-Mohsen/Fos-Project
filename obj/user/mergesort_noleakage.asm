
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
  800041:	e8 61 20 00 00       	call   8020a7 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 43 80 00       	push   $0x804360
  80004e:	e8 00 0b 00 00       	call   800b53 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 43 80 00       	push   $0x804362
  80005e:	e8 f0 0a 00 00       	call   800b53 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 78 43 80 00       	push   $0x804378
  80006e:	e8 e0 0a 00 00       	call   800b53 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 43 80 00       	push   $0x804362
  80007e:	e8 d0 0a 00 00       	call   800b53 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 43 80 00       	push   $0x804360
  80008e:	e8 c0 0a 00 00       	call   800b53 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 90 43 80 00       	push   $0x804390
  8000a5:	e8 3d 11 00 00       	call   8011e7 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			cprintf("Chose the initialization method:\n") ;
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 b0 43 80 00       	push   $0x8043b0
  8000b5:	e8 99 0a 00 00       	call   800b53 <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 d2 43 80 00       	push   $0x8043d2
  8000c5:	e8 89 0a 00 00       	call   800b53 <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 e0 43 80 00       	push   $0x8043e0
  8000d5:	e8 79 0a 00 00       	call   800b53 <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	68 ef 43 80 00       	push   $0x8043ef
  8000e5:	e8 69 0a 00 00       	call   800b53 <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 ff 43 80 00       	push   $0x8043ff
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
  800134:	e8 88 1f 00 00       	call   8020c1 <sys_unlock_cons>
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
  8001da:	68 08 44 80 00       	push   $0x804408
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
  800204:	68 3c 44 80 00       	push   $0x80443c
  800209:	6a 4d                	push   $0x4d
  80020b:	68 5e 44 80 00       	push   $0x80445e
  800210:	e8 81 06 00 00       	call   800896 <_panic>
		else
		{
			//sys_lock_cons();
			sys_lock_cons();
  800215:	e8 8d 1e 00 00       	call   8020a7 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 7c 44 80 00       	push   $0x80447c
  800222:	e8 2c 09 00 00       	call   800b53 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 b0 44 80 00       	push   $0x8044b0
  800232:	e8 1c 09 00 00       	call   800b53 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 e4 44 80 00       	push   $0x8044e4
  800242:	e8 0c 09 00 00       	call   800b53 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  80024a:	e8 72 1e 00 00       	call   8020c1 <sys_unlock_cons>
			//sys_unlock_cons();
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 d0 1a 00 00       	call   801d2a <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  80025d:	e8 45 1e 00 00       	call   8020a7 <sys_lock_cons>
		{
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 42                	jmp    8002aa <_main+0x272>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 16 45 80 00       	push   $0x804516
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
  8002b6:	e8 06 1e 00 00       	call   8020c1 <sys_unlock_cons>
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
  80044a:	68 60 43 80 00       	push   $0x804360
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
  80046c:	68 34 45 80 00       	push   $0x804534
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
  80049a:	68 39 45 80 00       	push   $0x804539
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
  80072f:	e8 be 1a 00 00       	call   8021f2 <sys_cputc>
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
  800740:	e8 49 19 00 00       	call   80208e <sys_cgetc>
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
  80075d:	e8 c1 1b 00 00       	call   802323 <sys_getenvindex>
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
  8007cb:	e8 d7 18 00 00       	call   8020a7 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8007d0:	83 ec 0c             	sub    $0xc,%esp
  8007d3:	68 58 45 80 00       	push   $0x804558
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
  8007fb:	68 80 45 80 00       	push   $0x804580
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
  80082c:	68 a8 45 80 00       	push   $0x8045a8
  800831:	e8 1d 03 00 00       	call   800b53 <cprintf>
  800836:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800839:	a1 24 50 80 00       	mov    0x805024,%eax
  80083e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	50                   	push   %eax
  800848:	68 00 46 80 00       	push   $0x804600
  80084d:	e8 01 03 00 00       	call   800b53 <cprintf>
  800852:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800855:	83 ec 0c             	sub    $0xc,%esp
  800858:	68 58 45 80 00       	push   $0x804558
  80085d:	e8 f1 02 00 00       	call   800b53 <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800865:	e8 57 18 00 00       	call   8020c1 <sys_unlock_cons>
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
  80087d:	e8 6d 1a 00 00       	call   8022ef <sys_destroy_env>
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
  80088e:	e8 c2 1a 00 00       	call   802355 <sys_exit_env>
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
  8008b7:	68 14 46 80 00       	push   $0x804614
  8008bc:	e8 92 02 00 00       	call   800b53 <cprintf>
  8008c1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008c4:	a1 00 50 80 00       	mov    0x805000,%eax
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	ff 75 08             	pushl  0x8(%ebp)
  8008cf:	50                   	push   %eax
  8008d0:	68 19 46 80 00       	push   $0x804619
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
  8008f4:	68 35 46 80 00       	push   $0x804635
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
  800923:	68 38 46 80 00       	push   $0x804638
  800928:	6a 26                	push   $0x26
  80092a:	68 84 46 80 00       	push   $0x804684
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
  8009f8:	68 90 46 80 00       	push   $0x804690
  8009fd:	6a 3a                	push   $0x3a
  8009ff:	68 84 46 80 00       	push   $0x804684
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
  800a6b:	68 e4 46 80 00       	push   $0x8046e4
  800a70:	6a 44                	push   $0x44
  800a72:	68 84 46 80 00       	push   $0x804684
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
  800ac5:	e8 9b 15 00 00       	call   802065 <sys_cputs>
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
  800b3c:	e8 24 15 00 00       	call   802065 <sys_cputs>
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
  800b86:	e8 1c 15 00 00       	call   8020a7 <sys_lock_cons>
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
  800ba6:	e8 16 15 00 00       	call   8020c1 <sys_unlock_cons>
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
  800bf0:	e8 07 35 00 00       	call   8040fc <__udivdi3>
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
  800c40:	e8 c7 35 00 00       	call   80420c <__umoddi3>
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	05 54 49 80 00       	add    $0x804954,%eax
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
  800d9b:	8b 04 85 78 49 80 00 	mov    0x804978(,%eax,4),%eax
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
  800e7c:	8b 34 9d c0 47 80 00 	mov    0x8047c0(,%ebx,4),%esi
  800e83:	85 f6                	test   %esi,%esi
  800e85:	75 19                	jne    800ea0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e87:	53                   	push   %ebx
  800e88:	68 65 49 80 00       	push   $0x804965
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
  800ea1:	68 6e 49 80 00       	push   $0x80496e
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
  800ece:	be 71 49 80 00       	mov    $0x804971,%esi
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
  8011f9:	68 e8 4a 80 00       	push   $0x804ae8
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
  80123b:	68 eb 4a 80 00       	push   $0x804aeb
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
  8012ec:	e8 b6 0d 00 00       	call   8020a7 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f5:	74 13                	je     80130a <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012f7:	83 ec 08             	sub    $0x8,%esp
  8012fa:	ff 75 08             	pushl  0x8(%ebp)
  8012fd:	68 e8 4a 80 00       	push   $0x804ae8
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
  80133f:	68 eb 4a 80 00       	push   $0x804aeb
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
  8013e7:	e8 d5 0c 00 00       	call   8020c1 <sys_unlock_cons>
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
  801ae1:	68 fc 4a 80 00       	push   $0x804afc
  801ae6:	68 3f 01 00 00       	push   $0x13f
  801aeb:	68 1e 4b 80 00       	push   $0x804b1e
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
  801b01:	e8 0a 0b 00 00       	call   802610 <sys_sbrk>
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
  801b7c:	e8 13 09 00 00       	call   802494 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b81:	85 c0                	test   %eax,%eax
  801b83:	74 16                	je     801b9b <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b85:	83 ec 0c             	sub    $0xc,%esp
  801b88:	ff 75 08             	pushl  0x8(%ebp)
  801b8b:	e8 53 0e 00 00       	call   8029e3 <alloc_block_FF>
  801b90:	83 c4 10             	add    $0x10,%esp
  801b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b96:	e9 8a 01 00 00       	jmp    801d25 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b9b:	e8 25 09 00 00       	call   8024c5 <sys_isUHeapPlacementStrategyBESTFIT>
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	0f 84 7d 01 00 00    	je     801d25 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801ba8:	83 ec 0c             	sub    $0xc,%esp
  801bab:	ff 75 08             	pushl  0x8(%ebp)
  801bae:	e8 ec 12 00 00       	call   802e9f <alloc_block_BF>
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
		//cprintf("52\n");
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
			//cprintf("57\n");
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
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c10:	05 00 10 00 00       	add    $0x1000,%eax
  801c15:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801c18:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
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
						//cprintf("71\n");
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
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
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
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801cb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cbc:	75 16                	jne    801cd4 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801cbe:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801cc5:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801ccc:	0f 86 15 ff ff ff    	jbe    801be7 <malloc+0xdc>
  801cd2:	eb 01                	jmp    801cd5 <malloc+0x1ca>
				}
				//cprintf("79\n");

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
  801d14:	e8 2e 09 00 00       	call   802647 <sys_allocate_user_mem>
  801d19:	83 c4 10             	add    $0x10,%esp
  801d1c:	eb 07                	jmp    801d25 <malloc+0x21a>
		//cprintf("91\n");
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
  801d5c:	e8 02 09 00 00       	call   802663 <get_block_size>
  801d61:	83 c4 10             	add    $0x10,%esp
  801d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d67:	83 ec 0c             	sub    $0xc,%esp
  801d6a:	ff 75 08             	pushl  0x8(%ebp)
  801d6d:	e8 35 1b 00 00       	call   8038a7 <free_block>
  801d72:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
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
  801dc1:	eb 2f                	jmp    801df2 <free+0xc8>
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
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801def:	ff 45 f4             	incl   -0xc(%ebp)
  801df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801df8:	72 c9                	jb     801dc3 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	83 ec 08             	sub    $0x8,%esp
  801e00:	ff 75 ec             	pushl  -0x14(%ebp)
  801e03:	50                   	push   %eax
  801e04:	e8 22 08 00 00       	call   80262b <sys_free_user_mem>
  801e09:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801e0c:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801e0d:	eb 17                	jmp    801e26 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801e0f:	83 ec 04             	sub    $0x4,%esp
  801e12:	68 2c 4b 80 00       	push   $0x804b2c
  801e17:	68 85 00 00 00       	push   $0x85
  801e1c:	68 56 4b 80 00       	push   $0x804b56
  801e21:	e8 70 ea ff ff       	call   800896 <_panic>
	}
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	83 ec 28             	sub    $0x28,%esp
  801e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e31:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801e34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e38:	75 0a                	jne    801e44 <smalloc+0x1c>
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3f:	e9 9a 00 00 00       	jmp    801ede <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e57:	39 d0                	cmp    %edx,%eax
  801e59:	73 02                	jae    801e5d <smalloc+0x35>
  801e5b:	89 d0                	mov    %edx,%eax
  801e5d:	83 ec 0c             	sub    $0xc,%esp
  801e60:	50                   	push   %eax
  801e61:	e8 a5 fc ff ff       	call   801b0b <malloc>
  801e66:	83 c4 10             	add    $0x10,%esp
  801e69:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801e6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e70:	75 07                	jne    801e79 <smalloc+0x51>
  801e72:	b8 00 00 00 00       	mov    $0x0,%eax
  801e77:	eb 65                	jmp    801ede <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e79:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e7d:	ff 75 ec             	pushl  -0x14(%ebp)
  801e80:	50                   	push   %eax
  801e81:	ff 75 0c             	pushl  0xc(%ebp)
  801e84:	ff 75 08             	pushl  0x8(%ebp)
  801e87:	e8 a6 03 00 00       	call   802232 <sys_createSharedObject>
  801e8c:	83 c4 10             	add    $0x10,%esp
  801e8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e92:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e96:	74 06                	je     801e9e <smalloc+0x76>
  801e98:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e9c:	75 07                	jne    801ea5 <smalloc+0x7d>
  801e9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea3:	eb 39                	jmp    801ede <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801ea5:	83 ec 08             	sub    $0x8,%esp
  801ea8:	ff 75 ec             	pushl  -0x14(%ebp)
  801eab:	68 62 4b 80 00       	push   $0x804b62
  801eb0:	e8 9e ec ff ff       	call   800b53 <cprintf>
  801eb5:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801eb8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ebb:	a1 24 50 80 00       	mov    0x805024,%eax
  801ec0:	8b 40 78             	mov    0x78(%eax),%eax
  801ec3:	29 c2                	sub    %eax,%edx
  801ec5:	89 d0                	mov    %edx,%eax
  801ec7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ecc:	c1 e8 0c             	shr    $0xc,%eax
  801ecf:	89 c2                	mov    %eax,%edx
  801ed1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ed4:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801edb:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ee6:	83 ec 08             	sub    $0x8,%esp
  801ee9:	ff 75 0c             	pushl  0xc(%ebp)
  801eec:	ff 75 08             	pushl  0x8(%ebp)
  801eef:	e8 68 03 00 00       	call   80225c <sys_getSizeOfSharedObject>
  801ef4:	83 c4 10             	add    $0x10,%esp
  801ef7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801efa:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801efe:	75 07                	jne    801f07 <sget+0x27>
  801f00:	b8 00 00 00 00       	mov    $0x0,%eax
  801f05:	eb 7f                	jmp    801f86 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f0d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f14:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1a:	39 d0                	cmp    %edx,%eax
  801f1c:	7d 02                	jge    801f20 <sget+0x40>
  801f1e:	89 d0                	mov    %edx,%eax
  801f20:	83 ec 0c             	sub    $0xc,%esp
  801f23:	50                   	push   %eax
  801f24:	e8 e2 fb ff ff       	call   801b0b <malloc>
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801f2f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f33:	75 07                	jne    801f3c <sget+0x5c>
  801f35:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3a:	eb 4a                	jmp    801f86 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801f3c:	83 ec 04             	sub    $0x4,%esp
  801f3f:	ff 75 e8             	pushl  -0x18(%ebp)
  801f42:	ff 75 0c             	pushl  0xc(%ebp)
  801f45:	ff 75 08             	pushl  0x8(%ebp)
  801f48:	e8 2c 03 00 00       	call   802279 <sys_getSharedObject>
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801f53:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f56:	a1 24 50 80 00       	mov    0x805024,%eax
  801f5b:	8b 40 78             	mov    0x78(%eax),%eax
  801f5e:	29 c2                	sub    %eax,%edx
  801f60:	89 d0                	mov    %edx,%eax
  801f62:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f67:	c1 e8 0c             	shr    $0xc,%eax
  801f6a:	89 c2                	mov    %eax,%edx
  801f6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f6f:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801f76:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801f7a:	75 07                	jne    801f83 <sget+0xa3>
  801f7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f81:	eb 03                	jmp    801f86 <sget+0xa6>
	return ptr;
  801f83:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801f8e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f91:	a1 24 50 80 00       	mov    0x805024,%eax
  801f96:	8b 40 78             	mov    0x78(%eax),%eax
  801f99:	29 c2                	sub    %eax,%edx
  801f9b:	89 d0                	mov    %edx,%eax
  801f9d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fa2:	c1 e8 0c             	shr    $0xc,%eax
  801fa5:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801faf:	83 ec 08             	sub    $0x8,%esp
  801fb2:	ff 75 08             	pushl  0x8(%ebp)
  801fb5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb8:	e8 db 02 00 00       	call   802298 <sys_freeSharedObject>
  801fbd:	83 c4 10             	add    $0x10,%esp
  801fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801fc3:	90                   	nop
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fcc:	83 ec 04             	sub    $0x4,%esp
  801fcf:	68 74 4b 80 00       	push   $0x804b74
  801fd4:	68 de 00 00 00       	push   $0xde
  801fd9:	68 56 4b 80 00       	push   $0x804b56
  801fde:	e8 b3 e8 ff ff       	call   800896 <_panic>

00801fe3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
  801fe6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fe9:	83 ec 04             	sub    $0x4,%esp
  801fec:	68 9a 4b 80 00       	push   $0x804b9a
  801ff1:	68 ea 00 00 00       	push   $0xea
  801ff6:	68 56 4b 80 00       	push   $0x804b56
  801ffb:	e8 96 e8 ff ff       	call   800896 <_panic>

00802000 <shrink>:

}
void shrink(uint32 newSize)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802006:	83 ec 04             	sub    $0x4,%esp
  802009:	68 9a 4b 80 00       	push   $0x804b9a
  80200e:	68 ef 00 00 00       	push   $0xef
  802013:	68 56 4b 80 00       	push   $0x804b56
  802018:	e8 79 e8 ff ff       	call   800896 <_panic>

0080201d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802023:	83 ec 04             	sub    $0x4,%esp
  802026:	68 9a 4b 80 00       	push   $0x804b9a
  80202b:	68 f4 00 00 00       	push   $0xf4
  802030:	68 56 4b 80 00       	push   $0x804b56
  802035:	e8 5c e8 ff ff       	call   800896 <_panic>

0080203a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	57                   	push   %edi
  80203e:	56                   	push   %esi
  80203f:	53                   	push   %ebx
  802040:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	8b 55 0c             	mov    0xc(%ebp),%edx
  802049:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80204c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80204f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802052:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802055:	cd 30                	int    $0x30
  802057:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80205a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	5b                   	pop    %ebx
  802061:	5e                   	pop    %esi
  802062:	5f                   	pop    %edi
  802063:	5d                   	pop    %ebp
  802064:	c3                   	ret    

00802065 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 04             	sub    $0x4,%esp
  80206b:	8b 45 10             	mov    0x10(%ebp),%eax
  80206e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802071:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	52                   	push   %edx
  80207d:	ff 75 0c             	pushl  0xc(%ebp)
  802080:	50                   	push   %eax
  802081:	6a 00                	push   $0x0
  802083:	e8 b2 ff ff ff       	call   80203a <syscall>
  802088:	83 c4 18             	add    $0x18,%esp
}
  80208b:	90                   	nop
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <sys_cgetc>:

int
sys_cgetc(void)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 02                	push   $0x2
  80209d:	e8 98 ff ff ff       	call   80203a <syscall>
  8020a2:	83 c4 18             	add    $0x18,%esp
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 03                	push   $0x3
  8020b6:	e8 7f ff ff ff       	call   80203a <syscall>
  8020bb:	83 c4 18             	add    $0x18,%esp
}
  8020be:	90                   	nop
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 04                	push   $0x4
  8020d0:	e8 65 ff ff ff       	call   80203a <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	90                   	nop
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	52                   	push   %edx
  8020eb:	50                   	push   %eax
  8020ec:	6a 08                	push   $0x8
  8020ee:	e8 47 ff ff ff       	call   80203a <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	56                   	push   %esi
  8020fc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020fd:	8b 75 18             	mov    0x18(%ebp),%esi
  802100:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802103:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802106:	8b 55 0c             	mov    0xc(%ebp),%edx
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	56                   	push   %esi
  80210d:	53                   	push   %ebx
  80210e:	51                   	push   %ecx
  80210f:	52                   	push   %edx
  802110:	50                   	push   %eax
  802111:	6a 09                	push   $0x9
  802113:	e8 22 ff ff ff       	call   80203a <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
}
  80211b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80211e:	5b                   	pop    %ebx
  80211f:	5e                   	pop    %esi
  802120:	5d                   	pop    %ebp
  802121:	c3                   	ret    

00802122 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802125:	8b 55 0c             	mov    0xc(%ebp),%edx
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	52                   	push   %edx
  802132:	50                   	push   %eax
  802133:	6a 0a                	push   $0xa
  802135:	e8 00 ff ff ff       	call   80203a <syscall>
  80213a:	83 c4 18             	add    $0x18,%esp
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	ff 75 0c             	pushl  0xc(%ebp)
  80214b:	ff 75 08             	pushl  0x8(%ebp)
  80214e:	6a 0b                	push   $0xb
  802150:	e8 e5 fe ff ff       	call   80203a <syscall>
  802155:	83 c4 18             	add    $0x18,%esp
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 0c                	push   $0xc
  802169:	e8 cc fe ff ff       	call   80203a <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 0d                	push   $0xd
  802182:	e8 b3 fe ff ff       	call   80203a <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 0e                	push   $0xe
  80219b:	e8 9a fe ff ff       	call   80203a <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 0f                	push   $0xf
  8021b4:	e8 81 fe ff ff       	call   80203a <syscall>
  8021b9:	83 c4 18             	add    $0x18,%esp
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	ff 75 08             	pushl  0x8(%ebp)
  8021cc:	6a 10                	push   $0x10
  8021ce:	e8 67 fe ff ff       	call   80203a <syscall>
  8021d3:	83 c4 18             	add    $0x18,%esp
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 11                	push   $0x11
  8021e7:	e8 4e fe ff ff       	call   80203a <syscall>
  8021ec:	83 c4 18             	add    $0x18,%esp
}
  8021ef:	90                   	nop
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <sys_cputc>:

void
sys_cputc(const char c)
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
  8021f5:	83 ec 04             	sub    $0x4,%esp
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021fe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	50                   	push   %eax
  80220b:	6a 01                	push   $0x1
  80220d:	e8 28 fe ff ff       	call   80203a <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
}
  802215:	90                   	nop
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 14                	push   $0x14
  802227:	e8 0e fe ff ff       	call   80203a <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
}
  80222f:	90                   	nop
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	83 ec 04             	sub    $0x4,%esp
  802238:	8b 45 10             	mov    0x10(%ebp),%eax
  80223b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80223e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802241:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	6a 00                	push   $0x0
  80224a:	51                   	push   %ecx
  80224b:	52                   	push   %edx
  80224c:	ff 75 0c             	pushl  0xc(%ebp)
  80224f:	50                   	push   %eax
  802250:	6a 15                	push   $0x15
  802252:	e8 e3 fd ff ff       	call   80203a <syscall>
  802257:	83 c4 18             	add    $0x18,%esp
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80225f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	52                   	push   %edx
  80226c:	50                   	push   %eax
  80226d:	6a 16                	push   $0x16
  80226f:	e8 c6 fd ff ff       	call   80203a <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80227c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80227f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	51                   	push   %ecx
  80228a:	52                   	push   %edx
  80228b:	50                   	push   %eax
  80228c:	6a 17                	push   $0x17
  80228e:	e8 a7 fd ff ff       	call   80203a <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80229b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	52                   	push   %edx
  8022a8:	50                   	push   %eax
  8022a9:	6a 18                	push   $0x18
  8022ab:	e8 8a fd ff ff       	call   80203a <syscall>
  8022b0:	83 c4 18             	add    $0x18,%esp
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	6a 00                	push   $0x0
  8022bd:	ff 75 14             	pushl  0x14(%ebp)
  8022c0:	ff 75 10             	pushl  0x10(%ebp)
  8022c3:	ff 75 0c             	pushl  0xc(%ebp)
  8022c6:	50                   	push   %eax
  8022c7:	6a 19                	push   $0x19
  8022c9:	e8 6c fd ff ff       	call   80203a <syscall>
  8022ce:	83 c4 18             	add    $0x18,%esp
}
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    

008022d3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	50                   	push   %eax
  8022e2:	6a 1a                	push   $0x1a
  8022e4:	e8 51 fd ff ff       	call   80203a <syscall>
  8022e9:	83 c4 18             	add    $0x18,%esp
}
  8022ec:	90                   	nop
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    

008022ef <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	50                   	push   %eax
  8022fe:	6a 1b                	push   $0x1b
  802300:	e8 35 fd ff ff       	call   80203a <syscall>
  802305:	83 c4 18             	add    $0x18,%esp
}
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 05                	push   $0x5
  802319:	e8 1c fd ff ff       	call   80203a <syscall>
  80231e:	83 c4 18             	add    $0x18,%esp
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 06                	push   $0x6
  802332:	e8 03 fd ff ff       	call   80203a <syscall>
  802337:	83 c4 18             	add    $0x18,%esp
}
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 07                	push   $0x7
  80234b:	e8 ea fc ff ff       	call   80203a <syscall>
  802350:	83 c4 18             	add    $0x18,%esp
}
  802353:	c9                   	leave  
  802354:	c3                   	ret    

00802355 <sys_exit_env>:


void sys_exit_env(void)
{
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 1c                	push   $0x1c
  802364:	e8 d1 fc ff ff       	call   80203a <syscall>
  802369:	83 c4 18             	add    $0x18,%esp
}
  80236c:	90                   	nop
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
  802372:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802375:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802378:	8d 50 04             	lea    0x4(%eax),%edx
  80237b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	52                   	push   %edx
  802385:	50                   	push   %eax
  802386:	6a 1d                	push   $0x1d
  802388:	e8 ad fc ff ff       	call   80203a <syscall>
  80238d:	83 c4 18             	add    $0x18,%esp
	return result;
  802390:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802393:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802396:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802399:	89 01                	mov    %eax,(%ecx)
  80239b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	c9                   	leave  
  8023a2:	c2 04 00             	ret    $0x4

008023a5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	ff 75 10             	pushl  0x10(%ebp)
  8023af:	ff 75 0c             	pushl  0xc(%ebp)
  8023b2:	ff 75 08             	pushl  0x8(%ebp)
  8023b5:	6a 13                	push   $0x13
  8023b7:	e8 7e fc ff ff       	call   80203a <syscall>
  8023bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8023bf:	90                   	nop
}
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 1e                	push   $0x1e
  8023d1:	e8 64 fc ff ff       	call   80203a <syscall>
  8023d6:	83 c4 18             	add    $0x18,%esp
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	83 ec 04             	sub    $0x4,%esp
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023e7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	50                   	push   %eax
  8023f4:	6a 1f                	push   $0x1f
  8023f6:	e8 3f fc ff ff       	call   80203a <syscall>
  8023fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8023fe:	90                   	nop
}
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <rsttst>:
void rsttst()
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 21                	push   $0x21
  802410:	e8 25 fc ff ff       	call   80203a <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
	return ;
  802418:	90                   	nop
}
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	83 ec 04             	sub    $0x4,%esp
  802421:	8b 45 14             	mov    0x14(%ebp),%eax
  802424:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802427:	8b 55 18             	mov    0x18(%ebp),%edx
  80242a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80242e:	52                   	push   %edx
  80242f:	50                   	push   %eax
  802430:	ff 75 10             	pushl  0x10(%ebp)
  802433:	ff 75 0c             	pushl  0xc(%ebp)
  802436:	ff 75 08             	pushl  0x8(%ebp)
  802439:	6a 20                	push   $0x20
  80243b:	e8 fa fb ff ff       	call   80203a <syscall>
  802440:	83 c4 18             	add    $0x18,%esp
	return ;
  802443:	90                   	nop
}
  802444:	c9                   	leave  
  802445:	c3                   	ret    

00802446 <chktst>:
void chktst(uint32 n)
{
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	ff 75 08             	pushl  0x8(%ebp)
  802454:	6a 22                	push   $0x22
  802456:	e8 df fb ff ff       	call   80203a <syscall>
  80245b:	83 c4 18             	add    $0x18,%esp
	return ;
  80245e:	90                   	nop
}
  80245f:	c9                   	leave  
  802460:	c3                   	ret    

00802461 <inctst>:

void inctst()
{
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 23                	push   $0x23
  802470:	e8 c5 fb ff ff       	call   80203a <syscall>
  802475:	83 c4 18             	add    $0x18,%esp
	return ;
  802478:	90                   	nop
}
  802479:	c9                   	leave  
  80247a:	c3                   	ret    

0080247b <gettst>:
uint32 gettst()
{
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 24                	push   $0x24
  80248a:	e8 ab fb ff ff       	call   80203a <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 25                	push   $0x25
  8024a6:	e8 8f fb ff ff       	call   80203a <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
  8024ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024b1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024b5:	75 07                	jne    8024be <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8024bc:	eb 05                	jmp    8024c3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    

008024c5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
  8024c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 25                	push   $0x25
  8024d7:	e8 5e fb ff ff       	call   80203a <syscall>
  8024dc:	83 c4 18             	add    $0x18,%esp
  8024df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024e2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024e6:	75 07                	jne    8024ef <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ed:	eb 05                	jmp    8024f4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
  8024f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 25                	push   $0x25
  802508:	e8 2d fb ff ff       	call   80203a <syscall>
  80250d:	83 c4 18             	add    $0x18,%esp
  802510:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802513:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802517:	75 07                	jne    802520 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802519:	b8 01 00 00 00       	mov    $0x1,%eax
  80251e:	eb 05                	jmp    802525 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802520:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802525:	c9                   	leave  
  802526:	c3                   	ret    

00802527 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802527:	55                   	push   %ebp
  802528:	89 e5                	mov    %esp,%ebp
  80252a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 25                	push   $0x25
  802539:	e8 fc fa ff ff       	call   80203a <syscall>
  80253e:	83 c4 18             	add    $0x18,%esp
  802541:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802544:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802548:	75 07                	jne    802551 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80254a:	b8 01 00 00 00       	mov    $0x1,%eax
  80254f:	eb 05                	jmp    802556 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802551:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	ff 75 08             	pushl  0x8(%ebp)
  802566:	6a 26                	push   $0x26
  802568:	e8 cd fa ff ff       	call   80203a <syscall>
  80256d:	83 c4 18             	add    $0x18,%esp
	return ;
  802570:	90                   	nop
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802577:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80257a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80257d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802580:	8b 45 08             	mov    0x8(%ebp),%eax
  802583:	6a 00                	push   $0x0
  802585:	53                   	push   %ebx
  802586:	51                   	push   %ecx
  802587:	52                   	push   %edx
  802588:	50                   	push   %eax
  802589:	6a 27                	push   $0x27
  80258b:	e8 aa fa ff ff       	call   80203a <syscall>
  802590:	83 c4 18             	add    $0x18,%esp
}
  802593:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802596:	c9                   	leave  
  802597:	c3                   	ret    

00802598 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80259b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259e:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	52                   	push   %edx
  8025a8:	50                   	push   %eax
  8025a9:	6a 28                	push   $0x28
  8025ab:	e8 8a fa ff ff       	call   80203a <syscall>
  8025b0:	83 c4 18             	add    $0x18,%esp
}
  8025b3:	c9                   	leave  
  8025b4:	c3                   	ret    

008025b5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8025b8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8025bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025be:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c1:	6a 00                	push   $0x0
  8025c3:	51                   	push   %ecx
  8025c4:	ff 75 10             	pushl  0x10(%ebp)
  8025c7:	52                   	push   %edx
  8025c8:	50                   	push   %eax
  8025c9:	6a 29                	push   $0x29
  8025cb:	e8 6a fa ff ff       	call   80203a <syscall>
  8025d0:	83 c4 18             	add    $0x18,%esp
}
  8025d3:	c9                   	leave  
  8025d4:	c3                   	ret    

008025d5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8025d5:	55                   	push   %ebp
  8025d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	ff 75 10             	pushl  0x10(%ebp)
  8025df:	ff 75 0c             	pushl  0xc(%ebp)
  8025e2:	ff 75 08             	pushl  0x8(%ebp)
  8025e5:	6a 12                	push   $0x12
  8025e7:	e8 4e fa ff ff       	call   80203a <syscall>
  8025ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ef:	90                   	nop
}
  8025f0:	c9                   	leave  
  8025f1:	c3                   	ret    

008025f2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8025f2:	55                   	push   %ebp
  8025f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8025f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	52                   	push   %edx
  802602:	50                   	push   %eax
  802603:	6a 2a                	push   $0x2a
  802605:	e8 30 fa ff ff       	call   80203a <syscall>
  80260a:	83 c4 18             	add    $0x18,%esp
	return;
  80260d:	90                   	nop
}
  80260e:	c9                   	leave  
  80260f:	c3                   	ret    

00802610 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	50                   	push   %eax
  80261f:	6a 2b                	push   $0x2b
  802621:	e8 14 fa ff ff       	call   80203a <syscall>
  802626:	83 c4 18             	add    $0x18,%esp
}
  802629:	c9                   	leave  
  80262a:	c3                   	ret    

0080262b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	ff 75 0c             	pushl  0xc(%ebp)
  802637:	ff 75 08             	pushl  0x8(%ebp)
  80263a:	6a 2c                	push   $0x2c
  80263c:	e8 f9 f9 ff ff       	call   80203a <syscall>
  802641:	83 c4 18             	add    $0x18,%esp
	return;
  802644:	90                   	nop
}
  802645:	c9                   	leave  
  802646:	c3                   	ret    

00802647 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802647:	55                   	push   %ebp
  802648:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	ff 75 0c             	pushl  0xc(%ebp)
  802653:	ff 75 08             	pushl  0x8(%ebp)
  802656:	6a 2d                	push   $0x2d
  802658:	e8 dd f9 ff ff       	call   80203a <syscall>
  80265d:	83 c4 18             	add    $0x18,%esp
	return;
  802660:	90                   	nop
}
  802661:	c9                   	leave  
  802662:	c3                   	ret    

00802663 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
  802666:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	83 e8 04             	sub    $0x4,%eax
  80266f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802672:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802675:	8b 00                	mov    (%eax),%eax
  802677:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80267a:	c9                   	leave  
  80267b:	c3                   	ret    

0080267c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	83 e8 04             	sub    $0x4,%eax
  802688:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80268b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80268e:	8b 00                	mov    (%eax),%eax
  802690:	83 e0 01             	and    $0x1,%eax
  802693:	85 c0                	test   %eax,%eax
  802695:	0f 94 c0             	sete   %al
}
  802698:	c9                   	leave  
  802699:	c3                   	ret    

0080269a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80269a:	55                   	push   %ebp
  80269b:	89 e5                	mov    %esp,%ebp
  80269d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8026a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8026a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026aa:	83 f8 02             	cmp    $0x2,%eax
  8026ad:	74 2b                	je     8026da <alloc_block+0x40>
  8026af:	83 f8 02             	cmp    $0x2,%eax
  8026b2:	7f 07                	jg     8026bb <alloc_block+0x21>
  8026b4:	83 f8 01             	cmp    $0x1,%eax
  8026b7:	74 0e                	je     8026c7 <alloc_block+0x2d>
  8026b9:	eb 58                	jmp    802713 <alloc_block+0x79>
  8026bb:	83 f8 03             	cmp    $0x3,%eax
  8026be:	74 2d                	je     8026ed <alloc_block+0x53>
  8026c0:	83 f8 04             	cmp    $0x4,%eax
  8026c3:	74 3b                	je     802700 <alloc_block+0x66>
  8026c5:	eb 4c                	jmp    802713 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8026c7:	83 ec 0c             	sub    $0xc,%esp
  8026ca:	ff 75 08             	pushl  0x8(%ebp)
  8026cd:	e8 11 03 00 00       	call   8029e3 <alloc_block_FF>
  8026d2:	83 c4 10             	add    $0x10,%esp
  8026d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026d8:	eb 4a                	jmp    802724 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8026da:	83 ec 0c             	sub    $0xc,%esp
  8026dd:	ff 75 08             	pushl  0x8(%ebp)
  8026e0:	e8 fa 19 00 00       	call   8040df <alloc_block_NF>
  8026e5:	83 c4 10             	add    $0x10,%esp
  8026e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026eb:	eb 37                	jmp    802724 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8026ed:	83 ec 0c             	sub    $0xc,%esp
  8026f0:	ff 75 08             	pushl  0x8(%ebp)
  8026f3:	e8 a7 07 00 00       	call   802e9f <alloc_block_BF>
  8026f8:	83 c4 10             	add    $0x10,%esp
  8026fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026fe:	eb 24                	jmp    802724 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802700:	83 ec 0c             	sub    $0xc,%esp
  802703:	ff 75 08             	pushl  0x8(%ebp)
  802706:	e8 b7 19 00 00       	call   8040c2 <alloc_block_WF>
  80270b:	83 c4 10             	add    $0x10,%esp
  80270e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802711:	eb 11                	jmp    802724 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802713:	83 ec 0c             	sub    $0xc,%esp
  802716:	68 ac 4b 80 00       	push   $0x804bac
  80271b:	e8 33 e4 ff ff       	call   800b53 <cprintf>
  802720:	83 c4 10             	add    $0x10,%esp
		break;
  802723:	90                   	nop
	}
	return va;
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802727:	c9                   	leave  
  802728:	c3                   	ret    

00802729 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
  80272c:	53                   	push   %ebx
  80272d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802730:	83 ec 0c             	sub    $0xc,%esp
  802733:	68 cc 4b 80 00       	push   $0x804bcc
  802738:	e8 16 e4 ff ff       	call   800b53 <cprintf>
  80273d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802740:	83 ec 0c             	sub    $0xc,%esp
  802743:	68 f7 4b 80 00       	push   $0x804bf7
  802748:	e8 06 e4 ff ff       	call   800b53 <cprintf>
  80274d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802756:	eb 37                	jmp    80278f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802758:	83 ec 0c             	sub    $0xc,%esp
  80275b:	ff 75 f4             	pushl  -0xc(%ebp)
  80275e:	e8 19 ff ff ff       	call   80267c <is_free_block>
  802763:	83 c4 10             	add    $0x10,%esp
  802766:	0f be d8             	movsbl %al,%ebx
  802769:	83 ec 0c             	sub    $0xc,%esp
  80276c:	ff 75 f4             	pushl  -0xc(%ebp)
  80276f:	e8 ef fe ff ff       	call   802663 <get_block_size>
  802774:	83 c4 10             	add    $0x10,%esp
  802777:	83 ec 04             	sub    $0x4,%esp
  80277a:	53                   	push   %ebx
  80277b:	50                   	push   %eax
  80277c:	68 0f 4c 80 00       	push   $0x804c0f
  802781:	e8 cd e3 ff ff       	call   800b53 <cprintf>
  802786:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802789:	8b 45 10             	mov    0x10(%ebp),%eax
  80278c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802793:	74 07                	je     80279c <print_blocks_list+0x73>
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 00                	mov    (%eax),%eax
  80279a:	eb 05                	jmp    8027a1 <print_blocks_list+0x78>
  80279c:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a1:	89 45 10             	mov    %eax,0x10(%ebp)
  8027a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	75 ad                	jne    802758 <print_blocks_list+0x2f>
  8027ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027af:	75 a7                	jne    802758 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8027b1:	83 ec 0c             	sub    $0xc,%esp
  8027b4:	68 cc 4b 80 00       	push   $0x804bcc
  8027b9:	e8 95 e3 ff ff       	call   800b53 <cprintf>
  8027be:	83 c4 10             	add    $0x10,%esp

}
  8027c1:	90                   	nop
  8027c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027c5:	c9                   	leave  
  8027c6:	c3                   	ret    

008027c7 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8027c7:	55                   	push   %ebp
  8027c8:	89 e5                	mov    %esp,%ebp
  8027ca:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8027cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027d0:	83 e0 01             	and    $0x1,%eax
  8027d3:	85 c0                	test   %eax,%eax
  8027d5:	74 03                	je     8027da <initialize_dynamic_allocator+0x13>
  8027d7:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8027da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027de:	0f 84 c7 01 00 00    	je     8029ab <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8027e4:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8027eb:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8027ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f4:	01 d0                	add    %edx,%eax
  8027f6:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8027fb:	0f 87 ad 01 00 00    	ja     8029ae <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802801:	8b 45 08             	mov    0x8(%ebp),%eax
  802804:	85 c0                	test   %eax,%eax
  802806:	0f 89 a5 01 00 00    	jns    8029b1 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80280c:	8b 55 08             	mov    0x8(%ebp),%edx
  80280f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802812:	01 d0                	add    %edx,%eax
  802814:	83 e8 04             	sub    $0x4,%eax
  802817:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  80281c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802823:	a1 30 50 80 00       	mov    0x805030,%eax
  802828:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282b:	e9 87 00 00 00       	jmp    8028b7 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802830:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802834:	75 14                	jne    80284a <initialize_dynamic_allocator+0x83>
  802836:	83 ec 04             	sub    $0x4,%esp
  802839:	68 27 4c 80 00       	push   $0x804c27
  80283e:	6a 79                	push   $0x79
  802840:	68 45 4c 80 00       	push   $0x804c45
  802845:	e8 4c e0 ff ff       	call   800896 <_panic>
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 00                	mov    (%eax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	74 10                	je     802863 <initialize_dynamic_allocator+0x9c>
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 00                	mov    (%eax),%eax
  802858:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285b:	8b 52 04             	mov    0x4(%edx),%edx
  80285e:	89 50 04             	mov    %edx,0x4(%eax)
  802861:	eb 0b                	jmp    80286e <initialize_dynamic_allocator+0xa7>
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 40 04             	mov    0x4(%eax),%eax
  802869:	a3 34 50 80 00       	mov    %eax,0x805034
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 40 04             	mov    0x4(%eax),%eax
  802874:	85 c0                	test   %eax,%eax
  802876:	74 0f                	je     802887 <initialize_dynamic_allocator+0xc0>
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 40 04             	mov    0x4(%eax),%eax
  80287e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802881:	8b 12                	mov    (%edx),%edx
  802883:	89 10                	mov    %edx,(%eax)
  802885:	eb 0a                	jmp    802891 <initialize_dynamic_allocator+0xca>
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 00                	mov    (%eax),%eax
  80288c:	a3 30 50 80 00       	mov    %eax,0x805030
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8028a9:	48                   	dec    %eax
  8028aa:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8028af:	a1 38 50 80 00       	mov    0x805038,%eax
  8028b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bb:	74 07                	je     8028c4 <initialize_dynamic_allocator+0xfd>
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	8b 00                	mov    (%eax),%eax
  8028c2:	eb 05                	jmp    8028c9 <initialize_dynamic_allocator+0x102>
  8028c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c9:	a3 38 50 80 00       	mov    %eax,0x805038
  8028ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8028d3:	85 c0                	test   %eax,%eax
  8028d5:	0f 85 55 ff ff ff    	jne    802830 <initialize_dynamic_allocator+0x69>
  8028db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028df:	0f 85 4b ff ff ff    	jne    802830 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8028f4:	a1 48 50 80 00       	mov    0x805048,%eax
  8028f9:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8028fe:	a1 44 50 80 00       	mov    0x805044,%eax
  802903:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802909:	8b 45 08             	mov    0x8(%ebp),%eax
  80290c:	83 c0 08             	add    $0x8,%eax
  80290f:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802912:	8b 45 08             	mov    0x8(%ebp),%eax
  802915:	83 c0 04             	add    $0x4,%eax
  802918:	8b 55 0c             	mov    0xc(%ebp),%edx
  80291b:	83 ea 08             	sub    $0x8,%edx
  80291e:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802920:	8b 55 0c             	mov    0xc(%ebp),%edx
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	01 d0                	add    %edx,%eax
  802928:	83 e8 08             	sub    $0x8,%eax
  80292b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80292e:	83 ea 08             	sub    $0x8,%edx
  802931:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802933:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802936:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80293c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802946:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80294a:	75 17                	jne    802963 <initialize_dynamic_allocator+0x19c>
  80294c:	83 ec 04             	sub    $0x4,%esp
  80294f:	68 60 4c 80 00       	push   $0x804c60
  802954:	68 90 00 00 00       	push   $0x90
  802959:	68 45 4c 80 00       	push   $0x804c45
  80295e:	e8 33 df ff ff       	call   800896 <_panic>
  802963:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802969:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296c:	89 10                	mov    %edx,(%eax)
  80296e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802971:	8b 00                	mov    (%eax),%eax
  802973:	85 c0                	test   %eax,%eax
  802975:	74 0d                	je     802984 <initialize_dynamic_allocator+0x1bd>
  802977:	a1 30 50 80 00       	mov    0x805030,%eax
  80297c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80297f:	89 50 04             	mov    %edx,0x4(%eax)
  802982:	eb 08                	jmp    80298c <initialize_dynamic_allocator+0x1c5>
  802984:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802987:	a3 34 50 80 00       	mov    %eax,0x805034
  80298c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298f:	a3 30 50 80 00       	mov    %eax,0x805030
  802994:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802997:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80299e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8029a3:	40                   	inc    %eax
  8029a4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8029a9:	eb 07                	jmp    8029b2 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8029ab:	90                   	nop
  8029ac:	eb 04                	jmp    8029b2 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8029ae:	90                   	nop
  8029af:	eb 01                	jmp    8029b2 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8029b1:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8029b2:	c9                   	leave  
  8029b3:	c3                   	ret    

008029b4 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8029b4:	55                   	push   %ebp
  8029b5:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8029b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8029ba:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c0:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c6:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	83 e8 04             	sub    $0x4,%eax
  8029ce:	8b 00                	mov    (%eax),%eax
  8029d0:	83 e0 fe             	and    $0xfffffffe,%eax
  8029d3:	8d 50 f8             	lea    -0x8(%eax),%edx
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	01 c2                	add    %eax,%edx
  8029db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029de:	89 02                	mov    %eax,(%edx)
}
  8029e0:	90                   	nop
  8029e1:	5d                   	pop    %ebp
  8029e2:	c3                   	ret    

008029e3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8029e3:	55                   	push   %ebp
  8029e4:	89 e5                	mov    %esp,%ebp
  8029e6:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8029e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ec:	83 e0 01             	and    $0x1,%eax
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	74 03                	je     8029f6 <alloc_block_FF+0x13>
  8029f3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8029f6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8029fa:	77 07                	ja     802a03 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8029fc:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a03:	a1 28 50 80 00       	mov    0x805028,%eax
  802a08:	85 c0                	test   %eax,%eax
  802a0a:	75 73                	jne    802a7f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	83 c0 10             	add    $0x10,%eax
  802a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a15:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a22:	01 d0                	add    %edx,%eax
  802a24:	48                   	dec    %eax
  802a25:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2b:	ba 00 00 00 00       	mov    $0x0,%edx
  802a30:	f7 75 ec             	divl   -0x14(%ebp)
  802a33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a36:	29 d0                	sub    %edx,%eax
  802a38:	c1 e8 0c             	shr    $0xc,%eax
  802a3b:	83 ec 0c             	sub    $0xc,%esp
  802a3e:	50                   	push   %eax
  802a3f:	e8 b1 f0 ff ff       	call   801af5 <sbrk>
  802a44:	83 c4 10             	add    $0x10,%esp
  802a47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a4a:	83 ec 0c             	sub    $0xc,%esp
  802a4d:	6a 00                	push   $0x0
  802a4f:	e8 a1 f0 ff ff       	call   801af5 <sbrk>
  802a54:	83 c4 10             	add    $0x10,%esp
  802a57:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a5d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802a60:	83 ec 08             	sub    $0x8,%esp
  802a63:	50                   	push   %eax
  802a64:	ff 75 e4             	pushl  -0x1c(%ebp)
  802a67:	e8 5b fd ff ff       	call   8027c7 <initialize_dynamic_allocator>
  802a6c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802a6f:	83 ec 0c             	sub    $0xc,%esp
  802a72:	68 83 4c 80 00       	push   $0x804c83
  802a77:	e8 d7 e0 ff ff       	call   800b53 <cprintf>
  802a7c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802a7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a83:	75 0a                	jne    802a8f <alloc_block_FF+0xac>
	        return NULL;
  802a85:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8a:	e9 0e 04 00 00       	jmp    802e9d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802a8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a96:	a1 30 50 80 00       	mov    0x805030,%eax
  802a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a9e:	e9 f3 02 00 00       	jmp    802d96 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802aa9:	83 ec 0c             	sub    $0xc,%esp
  802aac:	ff 75 bc             	pushl  -0x44(%ebp)
  802aaf:	e8 af fb ff ff       	call   802663 <get_block_size>
  802ab4:	83 c4 10             	add    $0x10,%esp
  802ab7:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	83 c0 08             	add    $0x8,%eax
  802ac0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802ac3:	0f 87 c5 02 00 00    	ja     802d8e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	83 c0 18             	add    $0x18,%eax
  802acf:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802ad2:	0f 87 19 02 00 00    	ja     802cf1 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802ad8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802adb:	2b 45 08             	sub    0x8(%ebp),%eax
  802ade:	83 e8 08             	sub    $0x8,%eax
  802ae1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae7:	8d 50 08             	lea    0x8(%eax),%edx
  802aea:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802aed:	01 d0                	add    %edx,%eax
  802aef:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	83 c0 08             	add    $0x8,%eax
  802af8:	83 ec 04             	sub    $0x4,%esp
  802afb:	6a 01                	push   $0x1
  802afd:	50                   	push   %eax
  802afe:	ff 75 bc             	pushl  -0x44(%ebp)
  802b01:	e8 ae fe ff ff       	call   8029b4 <set_block_data>
  802b06:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	8b 40 04             	mov    0x4(%eax),%eax
  802b0f:	85 c0                	test   %eax,%eax
  802b11:	75 68                	jne    802b7b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b13:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b17:	75 17                	jne    802b30 <alloc_block_FF+0x14d>
  802b19:	83 ec 04             	sub    $0x4,%esp
  802b1c:	68 60 4c 80 00       	push   $0x804c60
  802b21:	68 d7 00 00 00       	push   $0xd7
  802b26:	68 45 4c 80 00       	push   $0x804c45
  802b2b:	e8 66 dd ff ff       	call   800896 <_panic>
  802b30:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b36:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b39:	89 10                	mov    %edx,(%eax)
  802b3b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	85 c0                	test   %eax,%eax
  802b42:	74 0d                	je     802b51 <alloc_block_FF+0x16e>
  802b44:	a1 30 50 80 00       	mov    0x805030,%eax
  802b49:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b4c:	89 50 04             	mov    %edx,0x4(%eax)
  802b4f:	eb 08                	jmp    802b59 <alloc_block_FF+0x176>
  802b51:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b54:	a3 34 50 80 00       	mov    %eax,0x805034
  802b59:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b5c:	a3 30 50 80 00       	mov    %eax,0x805030
  802b61:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b70:	40                   	inc    %eax
  802b71:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b76:	e9 dc 00 00 00       	jmp    802c57 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7e:	8b 00                	mov    (%eax),%eax
  802b80:	85 c0                	test   %eax,%eax
  802b82:	75 65                	jne    802be9 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b84:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b88:	75 17                	jne    802ba1 <alloc_block_FF+0x1be>
  802b8a:	83 ec 04             	sub    $0x4,%esp
  802b8d:	68 94 4c 80 00       	push   $0x804c94
  802b92:	68 db 00 00 00       	push   $0xdb
  802b97:	68 45 4c 80 00       	push   $0x804c45
  802b9c:	e8 f5 dc ff ff       	call   800896 <_panic>
  802ba1:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802ba7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802baa:	89 50 04             	mov    %edx,0x4(%eax)
  802bad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bb0:	8b 40 04             	mov    0x4(%eax),%eax
  802bb3:	85 c0                	test   %eax,%eax
  802bb5:	74 0c                	je     802bc3 <alloc_block_FF+0x1e0>
  802bb7:	a1 34 50 80 00       	mov    0x805034,%eax
  802bbc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bbf:	89 10                	mov    %edx,(%eax)
  802bc1:	eb 08                	jmp    802bcb <alloc_block_FF+0x1e8>
  802bc3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc6:	a3 30 50 80 00       	mov    %eax,0x805030
  802bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bce:	a3 34 50 80 00       	mov    %eax,0x805034
  802bd3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bdc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802be1:	40                   	inc    %eax
  802be2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802be7:	eb 6e                	jmp    802c57 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802be9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bed:	74 06                	je     802bf5 <alloc_block_FF+0x212>
  802bef:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802bf3:	75 17                	jne    802c0c <alloc_block_FF+0x229>
  802bf5:	83 ec 04             	sub    $0x4,%esp
  802bf8:	68 b8 4c 80 00       	push   $0x804cb8
  802bfd:	68 df 00 00 00       	push   $0xdf
  802c02:	68 45 4c 80 00       	push   $0x804c45
  802c07:	e8 8a dc ff ff       	call   800896 <_panic>
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	8b 10                	mov    (%eax),%edx
  802c11:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c14:	89 10                	mov    %edx,(%eax)
  802c16:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c19:	8b 00                	mov    (%eax),%eax
  802c1b:	85 c0                	test   %eax,%eax
  802c1d:	74 0b                	je     802c2a <alloc_block_FF+0x247>
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c27:	89 50 04             	mov    %edx,0x4(%eax)
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c30:	89 10                	mov    %edx,(%eax)
  802c32:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c38:	89 50 04             	mov    %edx,0x4(%eax)
  802c3b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	85 c0                	test   %eax,%eax
  802c42:	75 08                	jne    802c4c <alloc_block_FF+0x269>
  802c44:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c47:	a3 34 50 80 00       	mov    %eax,0x805034
  802c4c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c51:	40                   	inc    %eax
  802c52:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802c57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5b:	75 17                	jne    802c74 <alloc_block_FF+0x291>
  802c5d:	83 ec 04             	sub    $0x4,%esp
  802c60:	68 27 4c 80 00       	push   $0x804c27
  802c65:	68 e1 00 00 00       	push   $0xe1
  802c6a:	68 45 4c 80 00       	push   $0x804c45
  802c6f:	e8 22 dc ff ff       	call   800896 <_panic>
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	74 10                	je     802c8d <alloc_block_FF+0x2aa>
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 00                	mov    (%eax),%eax
  802c82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c85:	8b 52 04             	mov    0x4(%edx),%edx
  802c88:	89 50 04             	mov    %edx,0x4(%eax)
  802c8b:	eb 0b                	jmp    802c98 <alloc_block_FF+0x2b5>
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 40 04             	mov    0x4(%eax),%eax
  802c93:	a3 34 50 80 00       	mov    %eax,0x805034
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	8b 40 04             	mov    0x4(%eax),%eax
  802c9e:	85 c0                	test   %eax,%eax
  802ca0:	74 0f                	je     802cb1 <alloc_block_FF+0x2ce>
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 40 04             	mov    0x4(%eax),%eax
  802ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cab:	8b 12                	mov    (%edx),%edx
  802cad:	89 10                	mov    %edx,(%eax)
  802caf:	eb 0a                	jmp    802cbb <alloc_block_FF+0x2d8>
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	a3 30 50 80 00       	mov    %eax,0x805030
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cce:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cd3:	48                   	dec    %eax
  802cd4:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802cd9:	83 ec 04             	sub    $0x4,%esp
  802cdc:	6a 00                	push   $0x0
  802cde:	ff 75 b4             	pushl  -0x4c(%ebp)
  802ce1:	ff 75 b0             	pushl  -0x50(%ebp)
  802ce4:	e8 cb fc ff ff       	call   8029b4 <set_block_data>
  802ce9:	83 c4 10             	add    $0x10,%esp
  802cec:	e9 95 00 00 00       	jmp    802d86 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	6a 01                	push   $0x1
  802cf6:	ff 75 b8             	pushl  -0x48(%ebp)
  802cf9:	ff 75 bc             	pushl  -0x44(%ebp)
  802cfc:	e8 b3 fc ff ff       	call   8029b4 <set_block_data>
  802d01:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802d04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d08:	75 17                	jne    802d21 <alloc_block_FF+0x33e>
  802d0a:	83 ec 04             	sub    $0x4,%esp
  802d0d:	68 27 4c 80 00       	push   $0x804c27
  802d12:	68 e8 00 00 00       	push   $0xe8
  802d17:	68 45 4c 80 00       	push   $0x804c45
  802d1c:	e8 75 db ff ff       	call   800896 <_panic>
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	8b 00                	mov    (%eax),%eax
  802d26:	85 c0                	test   %eax,%eax
  802d28:	74 10                	je     802d3a <alloc_block_FF+0x357>
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d32:	8b 52 04             	mov    0x4(%edx),%edx
  802d35:	89 50 04             	mov    %edx,0x4(%eax)
  802d38:	eb 0b                	jmp    802d45 <alloc_block_FF+0x362>
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 40 04             	mov    0x4(%eax),%eax
  802d40:	a3 34 50 80 00       	mov    %eax,0x805034
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 40 04             	mov    0x4(%eax),%eax
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	74 0f                	je     802d5e <alloc_block_FF+0x37b>
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 40 04             	mov    0x4(%eax),%eax
  802d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d58:	8b 12                	mov    (%edx),%edx
  802d5a:	89 10                	mov    %edx,(%eax)
  802d5c:	eb 0a                	jmp    802d68 <alloc_block_FF+0x385>
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	a3 30 50 80 00       	mov    %eax,0x805030
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d80:	48                   	dec    %eax
  802d81:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802d86:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d89:	e9 0f 01 00 00       	jmp    802e9d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802d8e:	a1 38 50 80 00       	mov    0x805038,%eax
  802d93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9a:	74 07                	je     802da3 <alloc_block_FF+0x3c0>
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 00                	mov    (%eax),%eax
  802da1:	eb 05                	jmp    802da8 <alloc_block_FF+0x3c5>
  802da3:	b8 00 00 00 00       	mov    $0x0,%eax
  802da8:	a3 38 50 80 00       	mov    %eax,0x805038
  802dad:	a1 38 50 80 00       	mov    0x805038,%eax
  802db2:	85 c0                	test   %eax,%eax
  802db4:	0f 85 e9 fc ff ff    	jne    802aa3 <alloc_block_FF+0xc0>
  802dba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dbe:	0f 85 df fc ff ff    	jne    802aa3 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc7:	83 c0 08             	add    $0x8,%eax
  802dca:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802dcd:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802dd4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dd7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dda:	01 d0                	add    %edx,%eax
  802ddc:	48                   	dec    %eax
  802ddd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802de0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802de3:	ba 00 00 00 00       	mov    $0x0,%edx
  802de8:	f7 75 d8             	divl   -0x28(%ebp)
  802deb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dee:	29 d0                	sub    %edx,%eax
  802df0:	c1 e8 0c             	shr    $0xc,%eax
  802df3:	83 ec 0c             	sub    $0xc,%esp
  802df6:	50                   	push   %eax
  802df7:	e8 f9 ec ff ff       	call   801af5 <sbrk>
  802dfc:	83 c4 10             	add    $0x10,%esp
  802dff:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802e02:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802e06:	75 0a                	jne    802e12 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802e08:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0d:	e9 8b 00 00 00       	jmp    802e9d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e12:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802e19:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e1c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802e1f:	01 d0                	add    %edx,%eax
  802e21:	48                   	dec    %eax
  802e22:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802e25:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e28:	ba 00 00 00 00       	mov    $0x0,%edx
  802e2d:	f7 75 cc             	divl   -0x34(%ebp)
  802e30:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e33:	29 d0                	sub    %edx,%eax
  802e35:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e3b:	01 d0                	add    %edx,%eax
  802e3d:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802e42:	a1 44 50 80 00       	mov    0x805044,%eax
  802e47:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e4d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e54:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e57:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e5a:	01 d0                	add    %edx,%eax
  802e5c:	48                   	dec    %eax
  802e5d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e63:	ba 00 00 00 00       	mov    $0x0,%edx
  802e68:	f7 75 c4             	divl   -0x3c(%ebp)
  802e6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e6e:	29 d0                	sub    %edx,%eax
  802e70:	83 ec 04             	sub    $0x4,%esp
  802e73:	6a 01                	push   $0x1
  802e75:	50                   	push   %eax
  802e76:	ff 75 d0             	pushl  -0x30(%ebp)
  802e79:	e8 36 fb ff ff       	call   8029b4 <set_block_data>
  802e7e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802e81:	83 ec 0c             	sub    $0xc,%esp
  802e84:	ff 75 d0             	pushl  -0x30(%ebp)
  802e87:	e8 1b 0a 00 00       	call   8038a7 <free_block>
  802e8c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802e8f:	83 ec 0c             	sub    $0xc,%esp
  802e92:	ff 75 08             	pushl  0x8(%ebp)
  802e95:	e8 49 fb ff ff       	call   8029e3 <alloc_block_FF>
  802e9a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802e9d:	c9                   	leave  
  802e9e:	c3                   	ret    

00802e9f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e9f:	55                   	push   %ebp
  802ea0:	89 e5                	mov    %esp,%ebp
  802ea2:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea8:	83 e0 01             	and    $0x1,%eax
  802eab:	85 c0                	test   %eax,%eax
  802ead:	74 03                	je     802eb2 <alloc_block_BF+0x13>
  802eaf:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802eb2:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802eb6:	77 07                	ja     802ebf <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802eb8:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802ebf:	a1 28 50 80 00       	mov    0x805028,%eax
  802ec4:	85 c0                	test   %eax,%eax
  802ec6:	75 73                	jne    802f3b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	83 c0 10             	add    $0x10,%eax
  802ece:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802ed1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802edb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ede:	01 d0                	add    %edx,%eax
  802ee0:	48                   	dec    %eax
  802ee1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ee4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee7:	ba 00 00 00 00       	mov    $0x0,%edx
  802eec:	f7 75 e0             	divl   -0x20(%ebp)
  802eef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef2:	29 d0                	sub    %edx,%eax
  802ef4:	c1 e8 0c             	shr    $0xc,%eax
  802ef7:	83 ec 0c             	sub    $0xc,%esp
  802efa:	50                   	push   %eax
  802efb:	e8 f5 eb ff ff       	call   801af5 <sbrk>
  802f00:	83 c4 10             	add    $0x10,%esp
  802f03:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802f06:	83 ec 0c             	sub    $0xc,%esp
  802f09:	6a 00                	push   $0x0
  802f0b:	e8 e5 eb ff ff       	call   801af5 <sbrk>
  802f10:	83 c4 10             	add    $0x10,%esp
  802f13:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802f16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f19:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802f1c:	83 ec 08             	sub    $0x8,%esp
  802f1f:	50                   	push   %eax
  802f20:	ff 75 d8             	pushl  -0x28(%ebp)
  802f23:	e8 9f f8 ff ff       	call   8027c7 <initialize_dynamic_allocator>
  802f28:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802f2b:	83 ec 0c             	sub    $0xc,%esp
  802f2e:	68 83 4c 80 00       	push   $0x804c83
  802f33:	e8 1b dc ff ff       	call   800b53 <cprintf>
  802f38:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802f3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802f42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802f49:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802f50:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802f57:	a1 30 50 80 00       	mov    0x805030,%eax
  802f5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f5f:	e9 1d 01 00 00       	jmp    803081 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802f6a:	83 ec 0c             	sub    $0xc,%esp
  802f6d:	ff 75 a8             	pushl  -0x58(%ebp)
  802f70:	e8 ee f6 ff ff       	call   802663 <get_block_size>
  802f75:	83 c4 10             	add    $0x10,%esp
  802f78:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	83 c0 08             	add    $0x8,%eax
  802f81:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f84:	0f 87 ef 00 00 00    	ja     803079 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8d:	83 c0 18             	add    $0x18,%eax
  802f90:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f93:	77 1d                	ja     802fb2 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802f95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f98:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f9b:	0f 86 d8 00 00 00    	jbe    803079 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802fa1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802fa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802fa7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802faa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802fad:	e9 c7 00 00 00       	jmp    803079 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	83 c0 08             	add    $0x8,%eax
  802fb8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802fbb:	0f 85 9d 00 00 00    	jne    80305e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802fc1:	83 ec 04             	sub    $0x4,%esp
  802fc4:	6a 01                	push   $0x1
  802fc6:	ff 75 a4             	pushl  -0x5c(%ebp)
  802fc9:	ff 75 a8             	pushl  -0x58(%ebp)
  802fcc:	e8 e3 f9 ff ff       	call   8029b4 <set_block_data>
  802fd1:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802fd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd8:	75 17                	jne    802ff1 <alloc_block_BF+0x152>
  802fda:	83 ec 04             	sub    $0x4,%esp
  802fdd:	68 27 4c 80 00       	push   $0x804c27
  802fe2:	68 2c 01 00 00       	push   $0x12c
  802fe7:	68 45 4c 80 00       	push   $0x804c45
  802fec:	e8 a5 d8 ff ff       	call   800896 <_panic>
  802ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff4:	8b 00                	mov    (%eax),%eax
  802ff6:	85 c0                	test   %eax,%eax
  802ff8:	74 10                	je     80300a <alloc_block_BF+0x16b>
  802ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803002:	8b 52 04             	mov    0x4(%edx),%edx
  803005:	89 50 04             	mov    %edx,0x4(%eax)
  803008:	eb 0b                	jmp    803015 <alloc_block_BF+0x176>
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	8b 40 04             	mov    0x4(%eax),%eax
  803010:	a3 34 50 80 00       	mov    %eax,0x805034
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 40 04             	mov    0x4(%eax),%eax
  80301b:	85 c0                	test   %eax,%eax
  80301d:	74 0f                	je     80302e <alloc_block_BF+0x18f>
  80301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803022:	8b 40 04             	mov    0x4(%eax),%eax
  803025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803028:	8b 12                	mov    (%edx),%edx
  80302a:	89 10                	mov    %edx,(%eax)
  80302c:	eb 0a                	jmp    803038 <alloc_block_BF+0x199>
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	8b 00                	mov    (%eax),%eax
  803033:	a3 30 50 80 00       	mov    %eax,0x805030
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803044:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803050:	48                   	dec    %eax
  803051:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  803056:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803059:	e9 24 04 00 00       	jmp    803482 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80305e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803061:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803064:	76 13                	jbe    803079 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803066:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80306d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803070:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803073:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803076:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803079:	a1 38 50 80 00       	mov    0x805038,%eax
  80307e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803081:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803085:	74 07                	je     80308e <alloc_block_BF+0x1ef>
  803087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308a:	8b 00                	mov    (%eax),%eax
  80308c:	eb 05                	jmp    803093 <alloc_block_BF+0x1f4>
  80308e:	b8 00 00 00 00       	mov    $0x0,%eax
  803093:	a3 38 50 80 00       	mov    %eax,0x805038
  803098:	a1 38 50 80 00       	mov    0x805038,%eax
  80309d:	85 c0                	test   %eax,%eax
  80309f:	0f 85 bf fe ff ff    	jne    802f64 <alloc_block_BF+0xc5>
  8030a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a9:	0f 85 b5 fe ff ff    	jne    802f64 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8030af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030b3:	0f 84 26 02 00 00    	je     8032df <alloc_block_BF+0x440>
  8030b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030bd:	0f 85 1c 02 00 00    	jne    8032df <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8030c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c6:	2b 45 08             	sub    0x8(%ebp),%eax
  8030c9:	83 e8 08             	sub    $0x8,%eax
  8030cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	8d 50 08             	lea    0x8(%eax),%edx
  8030d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d8:	01 d0                	add    %edx,%eax
  8030da:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	83 c0 08             	add    $0x8,%eax
  8030e3:	83 ec 04             	sub    $0x4,%esp
  8030e6:	6a 01                	push   $0x1
  8030e8:	50                   	push   %eax
  8030e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8030ec:	e8 c3 f8 ff ff       	call   8029b4 <set_block_data>
  8030f1:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8030f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f7:	8b 40 04             	mov    0x4(%eax),%eax
  8030fa:	85 c0                	test   %eax,%eax
  8030fc:	75 68                	jne    803166 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030fe:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803102:	75 17                	jne    80311b <alloc_block_BF+0x27c>
  803104:	83 ec 04             	sub    $0x4,%esp
  803107:	68 60 4c 80 00       	push   $0x804c60
  80310c:	68 45 01 00 00       	push   $0x145
  803111:	68 45 4c 80 00       	push   $0x804c45
  803116:	e8 7b d7 ff ff       	call   800896 <_panic>
  80311b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803121:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803124:	89 10                	mov    %edx,(%eax)
  803126:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803129:	8b 00                	mov    (%eax),%eax
  80312b:	85 c0                	test   %eax,%eax
  80312d:	74 0d                	je     80313c <alloc_block_BF+0x29d>
  80312f:	a1 30 50 80 00       	mov    0x805030,%eax
  803134:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803137:	89 50 04             	mov    %edx,0x4(%eax)
  80313a:	eb 08                	jmp    803144 <alloc_block_BF+0x2a5>
  80313c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80313f:	a3 34 50 80 00       	mov    %eax,0x805034
  803144:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803147:	a3 30 50 80 00       	mov    %eax,0x805030
  80314c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80314f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803156:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80315b:	40                   	inc    %eax
  80315c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803161:	e9 dc 00 00 00       	jmp    803242 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803166:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803169:	8b 00                	mov    (%eax),%eax
  80316b:	85 c0                	test   %eax,%eax
  80316d:	75 65                	jne    8031d4 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80316f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803173:	75 17                	jne    80318c <alloc_block_BF+0x2ed>
  803175:	83 ec 04             	sub    $0x4,%esp
  803178:	68 94 4c 80 00       	push   $0x804c94
  80317d:	68 4a 01 00 00       	push   $0x14a
  803182:	68 45 4c 80 00       	push   $0x804c45
  803187:	e8 0a d7 ff ff       	call   800896 <_panic>
  80318c:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803192:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803195:	89 50 04             	mov    %edx,0x4(%eax)
  803198:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80319b:	8b 40 04             	mov    0x4(%eax),%eax
  80319e:	85 c0                	test   %eax,%eax
  8031a0:	74 0c                	je     8031ae <alloc_block_BF+0x30f>
  8031a2:	a1 34 50 80 00       	mov    0x805034,%eax
  8031a7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031aa:	89 10                	mov    %edx,(%eax)
  8031ac:	eb 08                	jmp    8031b6 <alloc_block_BF+0x317>
  8031ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031b1:	a3 30 50 80 00       	mov    %eax,0x805030
  8031b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031b9:	a3 34 50 80 00       	mov    %eax,0x805034
  8031be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031cc:	40                   	inc    %eax
  8031cd:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8031d2:	eb 6e                	jmp    803242 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8031d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031d8:	74 06                	je     8031e0 <alloc_block_BF+0x341>
  8031da:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031de:	75 17                	jne    8031f7 <alloc_block_BF+0x358>
  8031e0:	83 ec 04             	sub    $0x4,%esp
  8031e3:	68 b8 4c 80 00       	push   $0x804cb8
  8031e8:	68 4f 01 00 00       	push   $0x14f
  8031ed:	68 45 4c 80 00       	push   $0x804c45
  8031f2:	e8 9f d6 ff ff       	call   800896 <_panic>
  8031f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fa:	8b 10                	mov    (%eax),%edx
  8031fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ff:	89 10                	mov    %edx,(%eax)
  803201:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803204:	8b 00                	mov    (%eax),%eax
  803206:	85 c0                	test   %eax,%eax
  803208:	74 0b                	je     803215 <alloc_block_BF+0x376>
  80320a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320d:	8b 00                	mov    (%eax),%eax
  80320f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803212:	89 50 04             	mov    %edx,0x4(%eax)
  803215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803218:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80321b:	89 10                	mov    %edx,(%eax)
  80321d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803220:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803223:	89 50 04             	mov    %edx,0x4(%eax)
  803226:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803229:	8b 00                	mov    (%eax),%eax
  80322b:	85 c0                	test   %eax,%eax
  80322d:	75 08                	jne    803237 <alloc_block_BF+0x398>
  80322f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803232:	a3 34 50 80 00       	mov    %eax,0x805034
  803237:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80323c:	40                   	inc    %eax
  80323d:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803242:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803246:	75 17                	jne    80325f <alloc_block_BF+0x3c0>
  803248:	83 ec 04             	sub    $0x4,%esp
  80324b:	68 27 4c 80 00       	push   $0x804c27
  803250:	68 51 01 00 00       	push   $0x151
  803255:	68 45 4c 80 00       	push   $0x804c45
  80325a:	e8 37 d6 ff ff       	call   800896 <_panic>
  80325f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803262:	8b 00                	mov    (%eax),%eax
  803264:	85 c0                	test   %eax,%eax
  803266:	74 10                	je     803278 <alloc_block_BF+0x3d9>
  803268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326b:	8b 00                	mov    (%eax),%eax
  80326d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803270:	8b 52 04             	mov    0x4(%edx),%edx
  803273:	89 50 04             	mov    %edx,0x4(%eax)
  803276:	eb 0b                	jmp    803283 <alloc_block_BF+0x3e4>
  803278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327b:	8b 40 04             	mov    0x4(%eax),%eax
  80327e:	a3 34 50 80 00       	mov    %eax,0x805034
  803283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803286:	8b 40 04             	mov    0x4(%eax),%eax
  803289:	85 c0                	test   %eax,%eax
  80328b:	74 0f                	je     80329c <alloc_block_BF+0x3fd>
  80328d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803290:	8b 40 04             	mov    0x4(%eax),%eax
  803293:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803296:	8b 12                	mov    (%edx),%edx
  803298:	89 10                	mov    %edx,(%eax)
  80329a:	eb 0a                	jmp    8032a6 <alloc_block_BF+0x407>
  80329c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329f:	8b 00                	mov    (%eax),%eax
  8032a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8032a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032be:	48                   	dec    %eax
  8032bf:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  8032c4:	83 ec 04             	sub    $0x4,%esp
  8032c7:	6a 00                	push   $0x0
  8032c9:	ff 75 d0             	pushl  -0x30(%ebp)
  8032cc:	ff 75 cc             	pushl  -0x34(%ebp)
  8032cf:	e8 e0 f6 ff ff       	call   8029b4 <set_block_data>
  8032d4:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8032d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032da:	e9 a3 01 00 00       	jmp    803482 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8032df:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8032e3:	0f 85 9d 00 00 00    	jne    803386 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8032e9:	83 ec 04             	sub    $0x4,%esp
  8032ec:	6a 01                	push   $0x1
  8032ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8032f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8032f4:	e8 bb f6 ff ff       	call   8029b4 <set_block_data>
  8032f9:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8032fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803300:	75 17                	jne    803319 <alloc_block_BF+0x47a>
  803302:	83 ec 04             	sub    $0x4,%esp
  803305:	68 27 4c 80 00       	push   $0x804c27
  80330a:	68 58 01 00 00       	push   $0x158
  80330f:	68 45 4c 80 00       	push   $0x804c45
  803314:	e8 7d d5 ff ff       	call   800896 <_panic>
  803319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331c:	8b 00                	mov    (%eax),%eax
  80331e:	85 c0                	test   %eax,%eax
  803320:	74 10                	je     803332 <alloc_block_BF+0x493>
  803322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803325:	8b 00                	mov    (%eax),%eax
  803327:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80332a:	8b 52 04             	mov    0x4(%edx),%edx
  80332d:	89 50 04             	mov    %edx,0x4(%eax)
  803330:	eb 0b                	jmp    80333d <alloc_block_BF+0x49e>
  803332:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803335:	8b 40 04             	mov    0x4(%eax),%eax
  803338:	a3 34 50 80 00       	mov    %eax,0x805034
  80333d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803340:	8b 40 04             	mov    0x4(%eax),%eax
  803343:	85 c0                	test   %eax,%eax
  803345:	74 0f                	je     803356 <alloc_block_BF+0x4b7>
  803347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334a:	8b 40 04             	mov    0x4(%eax),%eax
  80334d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803350:	8b 12                	mov    (%edx),%edx
  803352:	89 10                	mov    %edx,(%eax)
  803354:	eb 0a                	jmp    803360 <alloc_block_BF+0x4c1>
  803356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803359:	8b 00                	mov    (%eax),%eax
  80335b:	a3 30 50 80 00       	mov    %eax,0x805030
  803360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803363:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803373:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803378:	48                   	dec    %eax
  803379:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  80337e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803381:	e9 fc 00 00 00       	jmp    803482 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	83 c0 08             	add    $0x8,%eax
  80338c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80338f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803396:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803399:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80339c:	01 d0                	add    %edx,%eax
  80339e:	48                   	dec    %eax
  80339f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8033a2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8033a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8033aa:	f7 75 c4             	divl   -0x3c(%ebp)
  8033ad:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8033b0:	29 d0                	sub    %edx,%eax
  8033b2:	c1 e8 0c             	shr    $0xc,%eax
  8033b5:	83 ec 0c             	sub    $0xc,%esp
  8033b8:	50                   	push   %eax
  8033b9:	e8 37 e7 ff ff       	call   801af5 <sbrk>
  8033be:	83 c4 10             	add    $0x10,%esp
  8033c1:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8033c4:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8033c8:	75 0a                	jne    8033d4 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8033ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8033cf:	e9 ae 00 00 00       	jmp    803482 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8033d4:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8033db:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033de:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8033e1:	01 d0                	add    %edx,%eax
  8033e3:	48                   	dec    %eax
  8033e4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8033e7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8033ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8033ef:	f7 75 b8             	divl   -0x48(%ebp)
  8033f2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8033f5:	29 d0                	sub    %edx,%eax
  8033f7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8033fa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8033fd:	01 d0                	add    %edx,%eax
  8033ff:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  803404:	a1 44 50 80 00       	mov    0x805044,%eax
  803409:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80340f:	83 ec 0c             	sub    $0xc,%esp
  803412:	68 ec 4c 80 00       	push   $0x804cec
  803417:	e8 37 d7 ff ff       	call   800b53 <cprintf>
  80341c:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80341f:	83 ec 08             	sub    $0x8,%esp
  803422:	ff 75 bc             	pushl  -0x44(%ebp)
  803425:	68 f1 4c 80 00       	push   $0x804cf1
  80342a:	e8 24 d7 ff ff       	call   800b53 <cprintf>
  80342f:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803432:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803439:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80343c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80343f:	01 d0                	add    %edx,%eax
  803441:	48                   	dec    %eax
  803442:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803445:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803448:	ba 00 00 00 00       	mov    $0x0,%edx
  80344d:	f7 75 b0             	divl   -0x50(%ebp)
  803450:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803453:	29 d0                	sub    %edx,%eax
  803455:	83 ec 04             	sub    $0x4,%esp
  803458:	6a 01                	push   $0x1
  80345a:	50                   	push   %eax
  80345b:	ff 75 bc             	pushl  -0x44(%ebp)
  80345e:	e8 51 f5 ff ff       	call   8029b4 <set_block_data>
  803463:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803466:	83 ec 0c             	sub    $0xc,%esp
  803469:	ff 75 bc             	pushl  -0x44(%ebp)
  80346c:	e8 36 04 00 00       	call   8038a7 <free_block>
  803471:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803474:	83 ec 0c             	sub    $0xc,%esp
  803477:	ff 75 08             	pushl  0x8(%ebp)
  80347a:	e8 20 fa ff ff       	call   802e9f <alloc_block_BF>
  80347f:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803482:	c9                   	leave  
  803483:	c3                   	ret    

00803484 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803484:	55                   	push   %ebp
  803485:	89 e5                	mov    %esp,%ebp
  803487:	53                   	push   %ebx
  803488:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80348b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803492:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803499:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80349d:	74 1e                	je     8034bd <merging+0x39>
  80349f:	ff 75 08             	pushl  0x8(%ebp)
  8034a2:	e8 bc f1 ff ff       	call   802663 <get_block_size>
  8034a7:	83 c4 04             	add    $0x4,%esp
  8034aa:	89 c2                	mov    %eax,%edx
  8034ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8034af:	01 d0                	add    %edx,%eax
  8034b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8034b4:	75 07                	jne    8034bd <merging+0x39>
		prev_is_free = 1;
  8034b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8034bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034c1:	74 1e                	je     8034e1 <merging+0x5d>
  8034c3:	ff 75 10             	pushl  0x10(%ebp)
  8034c6:	e8 98 f1 ff ff       	call   802663 <get_block_size>
  8034cb:	83 c4 04             	add    $0x4,%esp
  8034ce:	89 c2                	mov    %eax,%edx
  8034d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8034d3:	01 d0                	add    %edx,%eax
  8034d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034d8:	75 07                	jne    8034e1 <merging+0x5d>
		next_is_free = 1;
  8034da:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8034e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e5:	0f 84 cc 00 00 00    	je     8035b7 <merging+0x133>
  8034eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034ef:	0f 84 c2 00 00 00    	je     8035b7 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8034f5:	ff 75 08             	pushl  0x8(%ebp)
  8034f8:	e8 66 f1 ff ff       	call   802663 <get_block_size>
  8034fd:	83 c4 04             	add    $0x4,%esp
  803500:	89 c3                	mov    %eax,%ebx
  803502:	ff 75 10             	pushl  0x10(%ebp)
  803505:	e8 59 f1 ff ff       	call   802663 <get_block_size>
  80350a:	83 c4 04             	add    $0x4,%esp
  80350d:	01 c3                	add    %eax,%ebx
  80350f:	ff 75 0c             	pushl  0xc(%ebp)
  803512:	e8 4c f1 ff ff       	call   802663 <get_block_size>
  803517:	83 c4 04             	add    $0x4,%esp
  80351a:	01 d8                	add    %ebx,%eax
  80351c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80351f:	6a 00                	push   $0x0
  803521:	ff 75 ec             	pushl  -0x14(%ebp)
  803524:	ff 75 08             	pushl  0x8(%ebp)
  803527:	e8 88 f4 ff ff       	call   8029b4 <set_block_data>
  80352c:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80352f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803533:	75 17                	jne    80354c <merging+0xc8>
  803535:	83 ec 04             	sub    $0x4,%esp
  803538:	68 27 4c 80 00       	push   $0x804c27
  80353d:	68 7d 01 00 00       	push   $0x17d
  803542:	68 45 4c 80 00       	push   $0x804c45
  803547:	e8 4a d3 ff ff       	call   800896 <_panic>
  80354c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80354f:	8b 00                	mov    (%eax),%eax
  803551:	85 c0                	test   %eax,%eax
  803553:	74 10                	je     803565 <merging+0xe1>
  803555:	8b 45 0c             	mov    0xc(%ebp),%eax
  803558:	8b 00                	mov    (%eax),%eax
  80355a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80355d:	8b 52 04             	mov    0x4(%edx),%edx
  803560:	89 50 04             	mov    %edx,0x4(%eax)
  803563:	eb 0b                	jmp    803570 <merging+0xec>
  803565:	8b 45 0c             	mov    0xc(%ebp),%eax
  803568:	8b 40 04             	mov    0x4(%eax),%eax
  80356b:	a3 34 50 80 00       	mov    %eax,0x805034
  803570:	8b 45 0c             	mov    0xc(%ebp),%eax
  803573:	8b 40 04             	mov    0x4(%eax),%eax
  803576:	85 c0                	test   %eax,%eax
  803578:	74 0f                	je     803589 <merging+0x105>
  80357a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80357d:	8b 40 04             	mov    0x4(%eax),%eax
  803580:	8b 55 0c             	mov    0xc(%ebp),%edx
  803583:	8b 12                	mov    (%edx),%edx
  803585:	89 10                	mov    %edx,(%eax)
  803587:	eb 0a                	jmp    803593 <merging+0x10f>
  803589:	8b 45 0c             	mov    0xc(%ebp),%eax
  80358c:	8b 00                	mov    (%eax),%eax
  80358e:	a3 30 50 80 00       	mov    %eax,0x805030
  803593:	8b 45 0c             	mov    0xc(%ebp),%eax
  803596:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80359c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80359f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035ab:	48                   	dec    %eax
  8035ac:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8035b1:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035b2:	e9 ea 02 00 00       	jmp    8038a1 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8035b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035bb:	74 3b                	je     8035f8 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8035bd:	83 ec 0c             	sub    $0xc,%esp
  8035c0:	ff 75 08             	pushl  0x8(%ebp)
  8035c3:	e8 9b f0 ff ff       	call   802663 <get_block_size>
  8035c8:	83 c4 10             	add    $0x10,%esp
  8035cb:	89 c3                	mov    %eax,%ebx
  8035cd:	83 ec 0c             	sub    $0xc,%esp
  8035d0:	ff 75 10             	pushl  0x10(%ebp)
  8035d3:	e8 8b f0 ff ff       	call   802663 <get_block_size>
  8035d8:	83 c4 10             	add    $0x10,%esp
  8035db:	01 d8                	add    %ebx,%eax
  8035dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8035e0:	83 ec 04             	sub    $0x4,%esp
  8035e3:	6a 00                	push   $0x0
  8035e5:	ff 75 e8             	pushl  -0x18(%ebp)
  8035e8:	ff 75 08             	pushl  0x8(%ebp)
  8035eb:	e8 c4 f3 ff ff       	call   8029b4 <set_block_data>
  8035f0:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035f3:	e9 a9 02 00 00       	jmp    8038a1 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8035f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035fc:	0f 84 2d 01 00 00    	je     80372f <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803602:	83 ec 0c             	sub    $0xc,%esp
  803605:	ff 75 10             	pushl  0x10(%ebp)
  803608:	e8 56 f0 ff ff       	call   802663 <get_block_size>
  80360d:	83 c4 10             	add    $0x10,%esp
  803610:	89 c3                	mov    %eax,%ebx
  803612:	83 ec 0c             	sub    $0xc,%esp
  803615:	ff 75 0c             	pushl  0xc(%ebp)
  803618:	e8 46 f0 ff ff       	call   802663 <get_block_size>
  80361d:	83 c4 10             	add    $0x10,%esp
  803620:	01 d8                	add    %ebx,%eax
  803622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803625:	83 ec 04             	sub    $0x4,%esp
  803628:	6a 00                	push   $0x0
  80362a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80362d:	ff 75 10             	pushl  0x10(%ebp)
  803630:	e8 7f f3 ff ff       	call   8029b4 <set_block_data>
  803635:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803638:	8b 45 10             	mov    0x10(%ebp),%eax
  80363b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80363e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803642:	74 06                	je     80364a <merging+0x1c6>
  803644:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803648:	75 17                	jne    803661 <merging+0x1dd>
  80364a:	83 ec 04             	sub    $0x4,%esp
  80364d:	68 00 4d 80 00       	push   $0x804d00
  803652:	68 8d 01 00 00       	push   $0x18d
  803657:	68 45 4c 80 00       	push   $0x804c45
  80365c:	e8 35 d2 ff ff       	call   800896 <_panic>
  803661:	8b 45 0c             	mov    0xc(%ebp),%eax
  803664:	8b 50 04             	mov    0x4(%eax),%edx
  803667:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80366a:	89 50 04             	mov    %edx,0x4(%eax)
  80366d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803670:	8b 55 0c             	mov    0xc(%ebp),%edx
  803673:	89 10                	mov    %edx,(%eax)
  803675:	8b 45 0c             	mov    0xc(%ebp),%eax
  803678:	8b 40 04             	mov    0x4(%eax),%eax
  80367b:	85 c0                	test   %eax,%eax
  80367d:	74 0d                	je     80368c <merging+0x208>
  80367f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803682:	8b 40 04             	mov    0x4(%eax),%eax
  803685:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803688:	89 10                	mov    %edx,(%eax)
  80368a:	eb 08                	jmp    803694 <merging+0x210>
  80368c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80368f:	a3 30 50 80 00       	mov    %eax,0x805030
  803694:	8b 45 0c             	mov    0xc(%ebp),%eax
  803697:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80369a:	89 50 04             	mov    %edx,0x4(%eax)
  80369d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036a2:	40                   	inc    %eax
  8036a3:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  8036a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036ac:	75 17                	jne    8036c5 <merging+0x241>
  8036ae:	83 ec 04             	sub    $0x4,%esp
  8036b1:	68 27 4c 80 00       	push   $0x804c27
  8036b6:	68 8e 01 00 00       	push   $0x18e
  8036bb:	68 45 4c 80 00       	push   $0x804c45
  8036c0:	e8 d1 d1 ff ff       	call   800896 <_panic>
  8036c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c8:	8b 00                	mov    (%eax),%eax
  8036ca:	85 c0                	test   %eax,%eax
  8036cc:	74 10                	je     8036de <merging+0x25a>
  8036ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d1:	8b 00                	mov    (%eax),%eax
  8036d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036d6:	8b 52 04             	mov    0x4(%edx),%edx
  8036d9:	89 50 04             	mov    %edx,0x4(%eax)
  8036dc:	eb 0b                	jmp    8036e9 <merging+0x265>
  8036de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e1:	8b 40 04             	mov    0x4(%eax),%eax
  8036e4:	a3 34 50 80 00       	mov    %eax,0x805034
  8036e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ec:	8b 40 04             	mov    0x4(%eax),%eax
  8036ef:	85 c0                	test   %eax,%eax
  8036f1:	74 0f                	je     803702 <merging+0x27e>
  8036f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f6:	8b 40 04             	mov    0x4(%eax),%eax
  8036f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036fc:	8b 12                	mov    (%edx),%edx
  8036fe:	89 10                	mov    %edx,(%eax)
  803700:	eb 0a                	jmp    80370c <merging+0x288>
  803702:	8b 45 0c             	mov    0xc(%ebp),%eax
  803705:	8b 00                	mov    (%eax),%eax
  803707:	a3 30 50 80 00       	mov    %eax,0x805030
  80370c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80370f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803715:	8b 45 0c             	mov    0xc(%ebp),%eax
  803718:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80371f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803724:	48                   	dec    %eax
  803725:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80372a:	e9 72 01 00 00       	jmp    8038a1 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80372f:	8b 45 10             	mov    0x10(%ebp),%eax
  803732:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803735:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803739:	74 79                	je     8037b4 <merging+0x330>
  80373b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80373f:	74 73                	je     8037b4 <merging+0x330>
  803741:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803745:	74 06                	je     80374d <merging+0x2c9>
  803747:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80374b:	75 17                	jne    803764 <merging+0x2e0>
  80374d:	83 ec 04             	sub    $0x4,%esp
  803750:	68 b8 4c 80 00       	push   $0x804cb8
  803755:	68 94 01 00 00       	push   $0x194
  80375a:	68 45 4c 80 00       	push   $0x804c45
  80375f:	e8 32 d1 ff ff       	call   800896 <_panic>
  803764:	8b 45 08             	mov    0x8(%ebp),%eax
  803767:	8b 10                	mov    (%eax),%edx
  803769:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80376c:	89 10                	mov    %edx,(%eax)
  80376e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803771:	8b 00                	mov    (%eax),%eax
  803773:	85 c0                	test   %eax,%eax
  803775:	74 0b                	je     803782 <merging+0x2fe>
  803777:	8b 45 08             	mov    0x8(%ebp),%eax
  80377a:	8b 00                	mov    (%eax),%eax
  80377c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80377f:	89 50 04             	mov    %edx,0x4(%eax)
  803782:	8b 45 08             	mov    0x8(%ebp),%eax
  803785:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803788:	89 10                	mov    %edx,(%eax)
  80378a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80378d:	8b 55 08             	mov    0x8(%ebp),%edx
  803790:	89 50 04             	mov    %edx,0x4(%eax)
  803793:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803796:	8b 00                	mov    (%eax),%eax
  803798:	85 c0                	test   %eax,%eax
  80379a:	75 08                	jne    8037a4 <merging+0x320>
  80379c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80379f:	a3 34 50 80 00       	mov    %eax,0x805034
  8037a4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037a9:	40                   	inc    %eax
  8037aa:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8037af:	e9 ce 00 00 00       	jmp    803882 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8037b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037b8:	74 65                	je     80381f <merging+0x39b>
  8037ba:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037be:	75 17                	jne    8037d7 <merging+0x353>
  8037c0:	83 ec 04             	sub    $0x4,%esp
  8037c3:	68 94 4c 80 00       	push   $0x804c94
  8037c8:	68 95 01 00 00       	push   $0x195
  8037cd:	68 45 4c 80 00       	push   $0x804c45
  8037d2:	e8 bf d0 ff ff       	call   800896 <_panic>
  8037d7:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8037dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037e0:	89 50 04             	mov    %edx,0x4(%eax)
  8037e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037e6:	8b 40 04             	mov    0x4(%eax),%eax
  8037e9:	85 c0                	test   %eax,%eax
  8037eb:	74 0c                	je     8037f9 <merging+0x375>
  8037ed:	a1 34 50 80 00       	mov    0x805034,%eax
  8037f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037f5:	89 10                	mov    %edx,(%eax)
  8037f7:	eb 08                	jmp    803801 <merging+0x37d>
  8037f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037fc:	a3 30 50 80 00       	mov    %eax,0x805030
  803801:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803804:	a3 34 50 80 00       	mov    %eax,0x805034
  803809:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80380c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803812:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803817:	40                   	inc    %eax
  803818:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80381d:	eb 63                	jmp    803882 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80381f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803823:	75 17                	jne    80383c <merging+0x3b8>
  803825:	83 ec 04             	sub    $0x4,%esp
  803828:	68 60 4c 80 00       	push   $0x804c60
  80382d:	68 98 01 00 00       	push   $0x198
  803832:	68 45 4c 80 00       	push   $0x804c45
  803837:	e8 5a d0 ff ff       	call   800896 <_panic>
  80383c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803842:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803845:	89 10                	mov    %edx,(%eax)
  803847:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80384a:	8b 00                	mov    (%eax),%eax
  80384c:	85 c0                	test   %eax,%eax
  80384e:	74 0d                	je     80385d <merging+0x3d9>
  803850:	a1 30 50 80 00       	mov    0x805030,%eax
  803855:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803858:	89 50 04             	mov    %edx,0x4(%eax)
  80385b:	eb 08                	jmp    803865 <merging+0x3e1>
  80385d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803860:	a3 34 50 80 00       	mov    %eax,0x805034
  803865:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803868:	a3 30 50 80 00       	mov    %eax,0x805030
  80386d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803870:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803877:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80387c:	40                   	inc    %eax
  80387d:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803882:	83 ec 0c             	sub    $0xc,%esp
  803885:	ff 75 10             	pushl  0x10(%ebp)
  803888:	e8 d6 ed ff ff       	call   802663 <get_block_size>
  80388d:	83 c4 10             	add    $0x10,%esp
  803890:	83 ec 04             	sub    $0x4,%esp
  803893:	6a 00                	push   $0x0
  803895:	50                   	push   %eax
  803896:	ff 75 10             	pushl  0x10(%ebp)
  803899:	e8 16 f1 ff ff       	call   8029b4 <set_block_data>
  80389e:	83 c4 10             	add    $0x10,%esp
	}
}
  8038a1:	90                   	nop
  8038a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8038a5:	c9                   	leave  
  8038a6:	c3                   	ret    

008038a7 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8038a7:	55                   	push   %ebp
  8038a8:	89 e5                	mov    %esp,%ebp
  8038aa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8038ad:	a1 30 50 80 00       	mov    0x805030,%eax
  8038b2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8038b5:	a1 34 50 80 00       	mov    0x805034,%eax
  8038ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038bd:	73 1b                	jae    8038da <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8038bf:	a1 34 50 80 00       	mov    0x805034,%eax
  8038c4:	83 ec 04             	sub    $0x4,%esp
  8038c7:	ff 75 08             	pushl  0x8(%ebp)
  8038ca:	6a 00                	push   $0x0
  8038cc:	50                   	push   %eax
  8038cd:	e8 b2 fb ff ff       	call   803484 <merging>
  8038d2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038d5:	e9 8b 00 00 00       	jmp    803965 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8038da:	a1 30 50 80 00       	mov    0x805030,%eax
  8038df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038e2:	76 18                	jbe    8038fc <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8038e4:	a1 30 50 80 00       	mov    0x805030,%eax
  8038e9:	83 ec 04             	sub    $0x4,%esp
  8038ec:	ff 75 08             	pushl  0x8(%ebp)
  8038ef:	50                   	push   %eax
  8038f0:	6a 00                	push   $0x0
  8038f2:	e8 8d fb ff ff       	call   803484 <merging>
  8038f7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038fa:	eb 69                	jmp    803965 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8038fc:	a1 30 50 80 00       	mov    0x805030,%eax
  803901:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803904:	eb 39                	jmp    80393f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803909:	3b 45 08             	cmp    0x8(%ebp),%eax
  80390c:	73 29                	jae    803937 <free_block+0x90>
  80390e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803911:	8b 00                	mov    (%eax),%eax
  803913:	3b 45 08             	cmp    0x8(%ebp),%eax
  803916:	76 1f                	jbe    803937 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391b:	8b 00                	mov    (%eax),%eax
  80391d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803920:	83 ec 04             	sub    $0x4,%esp
  803923:	ff 75 08             	pushl  0x8(%ebp)
  803926:	ff 75 f0             	pushl  -0x10(%ebp)
  803929:	ff 75 f4             	pushl  -0xc(%ebp)
  80392c:	e8 53 fb ff ff       	call   803484 <merging>
  803931:	83 c4 10             	add    $0x10,%esp
			break;
  803934:	90                   	nop
		}
	}
}
  803935:	eb 2e                	jmp    803965 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803937:	a1 38 50 80 00       	mov    0x805038,%eax
  80393c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80393f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803943:	74 07                	je     80394c <free_block+0xa5>
  803945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803948:	8b 00                	mov    (%eax),%eax
  80394a:	eb 05                	jmp    803951 <free_block+0xaa>
  80394c:	b8 00 00 00 00       	mov    $0x0,%eax
  803951:	a3 38 50 80 00       	mov    %eax,0x805038
  803956:	a1 38 50 80 00       	mov    0x805038,%eax
  80395b:	85 c0                	test   %eax,%eax
  80395d:	75 a7                	jne    803906 <free_block+0x5f>
  80395f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803963:	75 a1                	jne    803906 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803965:	90                   	nop
  803966:	c9                   	leave  
  803967:	c3                   	ret    

00803968 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803968:	55                   	push   %ebp
  803969:	89 e5                	mov    %esp,%ebp
  80396b:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80396e:	ff 75 08             	pushl  0x8(%ebp)
  803971:	e8 ed ec ff ff       	call   802663 <get_block_size>
  803976:	83 c4 04             	add    $0x4,%esp
  803979:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80397c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803983:	eb 17                	jmp    80399c <copy_data+0x34>
  803985:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80398b:	01 c2                	add    %eax,%edx
  80398d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803990:	8b 45 08             	mov    0x8(%ebp),%eax
  803993:	01 c8                	add    %ecx,%eax
  803995:	8a 00                	mov    (%eax),%al
  803997:	88 02                	mov    %al,(%edx)
  803999:	ff 45 fc             	incl   -0x4(%ebp)
  80399c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80399f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8039a2:	72 e1                	jb     803985 <copy_data+0x1d>
}
  8039a4:	90                   	nop
  8039a5:	c9                   	leave  
  8039a6:	c3                   	ret    

008039a7 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8039a7:	55                   	push   %ebp
  8039a8:	89 e5                	mov    %esp,%ebp
  8039aa:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8039ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039b1:	75 23                	jne    8039d6 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8039b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039b7:	74 13                	je     8039cc <realloc_block_FF+0x25>
  8039b9:	83 ec 0c             	sub    $0xc,%esp
  8039bc:	ff 75 0c             	pushl  0xc(%ebp)
  8039bf:	e8 1f f0 ff ff       	call   8029e3 <alloc_block_FF>
  8039c4:	83 c4 10             	add    $0x10,%esp
  8039c7:	e9 f4 06 00 00       	jmp    8040c0 <realloc_block_FF+0x719>
		return NULL;
  8039cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8039d1:	e9 ea 06 00 00       	jmp    8040c0 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8039d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039da:	75 18                	jne    8039f4 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8039dc:	83 ec 0c             	sub    $0xc,%esp
  8039df:	ff 75 08             	pushl  0x8(%ebp)
  8039e2:	e8 c0 fe ff ff       	call   8038a7 <free_block>
  8039e7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8039ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ef:	e9 cc 06 00 00       	jmp    8040c0 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8039f4:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8039f8:	77 07                	ja     803a01 <realloc_block_FF+0x5a>
  8039fa:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a04:	83 e0 01             	and    $0x1,%eax
  803a07:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a0d:	83 c0 08             	add    $0x8,%eax
  803a10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803a13:	83 ec 0c             	sub    $0xc,%esp
  803a16:	ff 75 08             	pushl  0x8(%ebp)
  803a19:	e8 45 ec ff ff       	call   802663 <get_block_size>
  803a1e:	83 c4 10             	add    $0x10,%esp
  803a21:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a27:	83 e8 08             	sub    $0x8,%eax
  803a2a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a30:	83 e8 04             	sub    $0x4,%eax
  803a33:	8b 00                	mov    (%eax),%eax
  803a35:	83 e0 fe             	and    $0xfffffffe,%eax
  803a38:	89 c2                	mov    %eax,%edx
  803a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3d:	01 d0                	add    %edx,%eax
  803a3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803a42:	83 ec 0c             	sub    $0xc,%esp
  803a45:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a48:	e8 16 ec ff ff       	call   802663 <get_block_size>
  803a4d:	83 c4 10             	add    $0x10,%esp
  803a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a56:	83 e8 08             	sub    $0x8,%eax
  803a59:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a5f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a62:	75 08                	jne    803a6c <realloc_block_FF+0xc5>
	{
		 return va;
  803a64:	8b 45 08             	mov    0x8(%ebp),%eax
  803a67:	e9 54 06 00 00       	jmp    8040c0 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a6f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a72:	0f 83 e5 03 00 00    	jae    803e5d <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803a78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7b:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803a81:	83 ec 0c             	sub    $0xc,%esp
  803a84:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a87:	e8 f0 eb ff ff       	call   80267c <is_free_block>
  803a8c:	83 c4 10             	add    $0x10,%esp
  803a8f:	84 c0                	test   %al,%al
  803a91:	0f 84 3b 01 00 00    	je     803bd2 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803a97:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a9d:	01 d0                	add    %edx,%eax
  803a9f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803aa2:	83 ec 04             	sub    $0x4,%esp
  803aa5:	6a 01                	push   $0x1
  803aa7:	ff 75 f0             	pushl  -0x10(%ebp)
  803aaa:	ff 75 08             	pushl  0x8(%ebp)
  803aad:	e8 02 ef ff ff       	call   8029b4 <set_block_data>
  803ab2:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab8:	83 e8 04             	sub    $0x4,%eax
  803abb:	8b 00                	mov    (%eax),%eax
  803abd:	83 e0 fe             	and    $0xfffffffe,%eax
  803ac0:	89 c2                	mov    %eax,%edx
  803ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac5:	01 d0                	add    %edx,%eax
  803ac7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803aca:	83 ec 04             	sub    $0x4,%esp
  803acd:	6a 00                	push   $0x0
  803acf:	ff 75 cc             	pushl  -0x34(%ebp)
  803ad2:	ff 75 c8             	pushl  -0x38(%ebp)
  803ad5:	e8 da ee ff ff       	call   8029b4 <set_block_data>
  803ada:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803add:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ae1:	74 06                	je     803ae9 <realloc_block_FF+0x142>
  803ae3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803ae7:	75 17                	jne    803b00 <realloc_block_FF+0x159>
  803ae9:	83 ec 04             	sub    $0x4,%esp
  803aec:	68 b8 4c 80 00       	push   $0x804cb8
  803af1:	68 f6 01 00 00       	push   $0x1f6
  803af6:	68 45 4c 80 00       	push   $0x804c45
  803afb:	e8 96 cd ff ff       	call   800896 <_panic>
  803b00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b03:	8b 10                	mov    (%eax),%edx
  803b05:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b08:	89 10                	mov    %edx,(%eax)
  803b0a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b0d:	8b 00                	mov    (%eax),%eax
  803b0f:	85 c0                	test   %eax,%eax
  803b11:	74 0b                	je     803b1e <realloc_block_FF+0x177>
  803b13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b16:	8b 00                	mov    (%eax),%eax
  803b18:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b1b:	89 50 04             	mov    %edx,0x4(%eax)
  803b1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b21:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b24:	89 10                	mov    %edx,(%eax)
  803b26:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b29:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b2c:	89 50 04             	mov    %edx,0x4(%eax)
  803b2f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b32:	8b 00                	mov    (%eax),%eax
  803b34:	85 c0                	test   %eax,%eax
  803b36:	75 08                	jne    803b40 <realloc_block_FF+0x199>
  803b38:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b3b:	a3 34 50 80 00       	mov    %eax,0x805034
  803b40:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b45:	40                   	inc    %eax
  803b46:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803b4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b4f:	75 17                	jne    803b68 <realloc_block_FF+0x1c1>
  803b51:	83 ec 04             	sub    $0x4,%esp
  803b54:	68 27 4c 80 00       	push   $0x804c27
  803b59:	68 f7 01 00 00       	push   $0x1f7
  803b5e:	68 45 4c 80 00       	push   $0x804c45
  803b63:	e8 2e cd ff ff       	call   800896 <_panic>
  803b68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b6b:	8b 00                	mov    (%eax),%eax
  803b6d:	85 c0                	test   %eax,%eax
  803b6f:	74 10                	je     803b81 <realloc_block_FF+0x1da>
  803b71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b74:	8b 00                	mov    (%eax),%eax
  803b76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b79:	8b 52 04             	mov    0x4(%edx),%edx
  803b7c:	89 50 04             	mov    %edx,0x4(%eax)
  803b7f:	eb 0b                	jmp    803b8c <realloc_block_FF+0x1e5>
  803b81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b84:	8b 40 04             	mov    0x4(%eax),%eax
  803b87:	a3 34 50 80 00       	mov    %eax,0x805034
  803b8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b8f:	8b 40 04             	mov    0x4(%eax),%eax
  803b92:	85 c0                	test   %eax,%eax
  803b94:	74 0f                	je     803ba5 <realloc_block_FF+0x1fe>
  803b96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b99:	8b 40 04             	mov    0x4(%eax),%eax
  803b9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b9f:	8b 12                	mov    (%edx),%edx
  803ba1:	89 10                	mov    %edx,(%eax)
  803ba3:	eb 0a                	jmp    803baf <realloc_block_FF+0x208>
  803ba5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba8:	8b 00                	mov    (%eax),%eax
  803baa:	a3 30 50 80 00       	mov    %eax,0x805030
  803baf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bc2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bc7:	48                   	dec    %eax
  803bc8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803bcd:	e9 83 02 00 00       	jmp    803e55 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803bd2:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803bd6:	0f 86 69 02 00 00    	jbe    803e45 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803bdc:	83 ec 04             	sub    $0x4,%esp
  803bdf:	6a 01                	push   $0x1
  803be1:	ff 75 f0             	pushl  -0x10(%ebp)
  803be4:	ff 75 08             	pushl  0x8(%ebp)
  803be7:	e8 c8 ed ff ff       	call   8029b4 <set_block_data>
  803bec:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803bef:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf2:	83 e8 04             	sub    $0x4,%eax
  803bf5:	8b 00                	mov    (%eax),%eax
  803bf7:	83 e0 fe             	and    $0xfffffffe,%eax
  803bfa:	89 c2                	mov    %eax,%edx
  803bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  803bff:	01 d0                	add    %edx,%eax
  803c01:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803c04:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c09:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803c0c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803c10:	75 68                	jne    803c7a <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c12:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c16:	75 17                	jne    803c2f <realloc_block_FF+0x288>
  803c18:	83 ec 04             	sub    $0x4,%esp
  803c1b:	68 60 4c 80 00       	push   $0x804c60
  803c20:	68 06 02 00 00       	push   $0x206
  803c25:	68 45 4c 80 00       	push   $0x804c45
  803c2a:	e8 67 cc ff ff       	call   800896 <_panic>
  803c2f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803c35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c38:	89 10                	mov    %edx,(%eax)
  803c3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c3d:	8b 00                	mov    (%eax),%eax
  803c3f:	85 c0                	test   %eax,%eax
  803c41:	74 0d                	je     803c50 <realloc_block_FF+0x2a9>
  803c43:	a1 30 50 80 00       	mov    0x805030,%eax
  803c48:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c4b:	89 50 04             	mov    %edx,0x4(%eax)
  803c4e:	eb 08                	jmp    803c58 <realloc_block_FF+0x2b1>
  803c50:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c53:	a3 34 50 80 00       	mov    %eax,0x805034
  803c58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c5b:	a3 30 50 80 00       	mov    %eax,0x805030
  803c60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c6a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c6f:	40                   	inc    %eax
  803c70:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c75:	e9 b0 01 00 00       	jmp    803e2a <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803c7a:	a1 30 50 80 00       	mov    0x805030,%eax
  803c7f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c82:	76 68                	jbe    803cec <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c84:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c88:	75 17                	jne    803ca1 <realloc_block_FF+0x2fa>
  803c8a:	83 ec 04             	sub    $0x4,%esp
  803c8d:	68 60 4c 80 00       	push   $0x804c60
  803c92:	68 0b 02 00 00       	push   $0x20b
  803c97:	68 45 4c 80 00       	push   $0x804c45
  803c9c:	e8 f5 cb ff ff       	call   800896 <_panic>
  803ca1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803ca7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803caa:	89 10                	mov    %edx,(%eax)
  803cac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803caf:	8b 00                	mov    (%eax),%eax
  803cb1:	85 c0                	test   %eax,%eax
  803cb3:	74 0d                	je     803cc2 <realloc_block_FF+0x31b>
  803cb5:	a1 30 50 80 00       	mov    0x805030,%eax
  803cba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cbd:	89 50 04             	mov    %edx,0x4(%eax)
  803cc0:	eb 08                	jmp    803cca <realloc_block_FF+0x323>
  803cc2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc5:	a3 34 50 80 00       	mov    %eax,0x805034
  803cca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ccd:	a3 30 50 80 00       	mov    %eax,0x805030
  803cd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cdc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ce1:	40                   	inc    %eax
  803ce2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803ce7:	e9 3e 01 00 00       	jmp    803e2a <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803cec:	a1 30 50 80 00       	mov    0x805030,%eax
  803cf1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803cf4:	73 68                	jae    803d5e <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803cf6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cfa:	75 17                	jne    803d13 <realloc_block_FF+0x36c>
  803cfc:	83 ec 04             	sub    $0x4,%esp
  803cff:	68 94 4c 80 00       	push   $0x804c94
  803d04:	68 10 02 00 00       	push   $0x210
  803d09:	68 45 4c 80 00       	push   $0x804c45
  803d0e:	e8 83 cb ff ff       	call   800896 <_panic>
  803d13:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803d19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d1c:	89 50 04             	mov    %edx,0x4(%eax)
  803d1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d22:	8b 40 04             	mov    0x4(%eax),%eax
  803d25:	85 c0                	test   %eax,%eax
  803d27:	74 0c                	je     803d35 <realloc_block_FF+0x38e>
  803d29:	a1 34 50 80 00       	mov    0x805034,%eax
  803d2e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d31:	89 10                	mov    %edx,(%eax)
  803d33:	eb 08                	jmp    803d3d <realloc_block_FF+0x396>
  803d35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d38:	a3 30 50 80 00       	mov    %eax,0x805030
  803d3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d40:	a3 34 50 80 00       	mov    %eax,0x805034
  803d45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d4e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d53:	40                   	inc    %eax
  803d54:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803d59:	e9 cc 00 00 00       	jmp    803e2a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803d5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803d65:	a1 30 50 80 00       	mov    0x805030,%eax
  803d6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d6d:	e9 8a 00 00 00       	jmp    803dfc <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d75:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d78:	73 7a                	jae    803df4 <realloc_block_FF+0x44d>
  803d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d7d:	8b 00                	mov    (%eax),%eax
  803d7f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d82:	73 70                	jae    803df4 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803d84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d88:	74 06                	je     803d90 <realloc_block_FF+0x3e9>
  803d8a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d8e:	75 17                	jne    803da7 <realloc_block_FF+0x400>
  803d90:	83 ec 04             	sub    $0x4,%esp
  803d93:	68 b8 4c 80 00       	push   $0x804cb8
  803d98:	68 1a 02 00 00       	push   $0x21a
  803d9d:	68 45 4c 80 00       	push   $0x804c45
  803da2:	e8 ef ca ff ff       	call   800896 <_panic>
  803da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803daa:	8b 10                	mov    (%eax),%edx
  803dac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803daf:	89 10                	mov    %edx,(%eax)
  803db1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803db4:	8b 00                	mov    (%eax),%eax
  803db6:	85 c0                	test   %eax,%eax
  803db8:	74 0b                	je     803dc5 <realloc_block_FF+0x41e>
  803dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbd:	8b 00                	mov    (%eax),%eax
  803dbf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dc2:	89 50 04             	mov    %edx,0x4(%eax)
  803dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dcb:	89 10                	mov    %edx,(%eax)
  803dcd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dd3:	89 50 04             	mov    %edx,0x4(%eax)
  803dd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dd9:	8b 00                	mov    (%eax),%eax
  803ddb:	85 c0                	test   %eax,%eax
  803ddd:	75 08                	jne    803de7 <realloc_block_FF+0x440>
  803ddf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803de2:	a3 34 50 80 00       	mov    %eax,0x805034
  803de7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803dec:	40                   	inc    %eax
  803ded:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803df2:	eb 36                	jmp    803e2a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803df4:	a1 38 50 80 00       	mov    0x805038,%eax
  803df9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803dfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e00:	74 07                	je     803e09 <realloc_block_FF+0x462>
  803e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e05:	8b 00                	mov    (%eax),%eax
  803e07:	eb 05                	jmp    803e0e <realloc_block_FF+0x467>
  803e09:	b8 00 00 00 00       	mov    $0x0,%eax
  803e0e:	a3 38 50 80 00       	mov    %eax,0x805038
  803e13:	a1 38 50 80 00       	mov    0x805038,%eax
  803e18:	85 c0                	test   %eax,%eax
  803e1a:	0f 85 52 ff ff ff    	jne    803d72 <realloc_block_FF+0x3cb>
  803e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e24:	0f 85 48 ff ff ff    	jne    803d72 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803e2a:	83 ec 04             	sub    $0x4,%esp
  803e2d:	6a 00                	push   $0x0
  803e2f:	ff 75 d8             	pushl  -0x28(%ebp)
  803e32:	ff 75 d4             	pushl  -0x2c(%ebp)
  803e35:	e8 7a eb ff ff       	call   8029b4 <set_block_data>
  803e3a:	83 c4 10             	add    $0x10,%esp
				return va;
  803e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e40:	e9 7b 02 00 00       	jmp    8040c0 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803e45:	83 ec 0c             	sub    $0xc,%esp
  803e48:	68 35 4d 80 00       	push   $0x804d35
  803e4d:	e8 01 cd ff ff       	call   800b53 <cprintf>
  803e52:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803e55:	8b 45 08             	mov    0x8(%ebp),%eax
  803e58:	e9 63 02 00 00       	jmp    8040c0 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e60:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803e63:	0f 86 4d 02 00 00    	jbe    8040b6 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803e69:	83 ec 0c             	sub    $0xc,%esp
  803e6c:	ff 75 e4             	pushl  -0x1c(%ebp)
  803e6f:	e8 08 e8 ff ff       	call   80267c <is_free_block>
  803e74:	83 c4 10             	add    $0x10,%esp
  803e77:	84 c0                	test   %al,%al
  803e79:	0f 84 37 02 00 00    	je     8040b6 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e82:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803e85:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803e88:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e8b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e8e:	76 38                	jbe    803ec8 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803e90:	83 ec 0c             	sub    $0xc,%esp
  803e93:	ff 75 08             	pushl  0x8(%ebp)
  803e96:	e8 0c fa ff ff       	call   8038a7 <free_block>
  803e9b:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803e9e:	83 ec 0c             	sub    $0xc,%esp
  803ea1:	ff 75 0c             	pushl  0xc(%ebp)
  803ea4:	e8 3a eb ff ff       	call   8029e3 <alloc_block_FF>
  803ea9:	83 c4 10             	add    $0x10,%esp
  803eac:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803eaf:	83 ec 08             	sub    $0x8,%esp
  803eb2:	ff 75 c0             	pushl  -0x40(%ebp)
  803eb5:	ff 75 08             	pushl  0x8(%ebp)
  803eb8:	e8 ab fa ff ff       	call   803968 <copy_data>
  803ebd:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803ec0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803ec3:	e9 f8 01 00 00       	jmp    8040c0 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803ec8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ecb:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803ece:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803ed1:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803ed5:	0f 87 a0 00 00 00    	ja     803f7b <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803edb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803edf:	75 17                	jne    803ef8 <realloc_block_FF+0x551>
  803ee1:	83 ec 04             	sub    $0x4,%esp
  803ee4:	68 27 4c 80 00       	push   $0x804c27
  803ee9:	68 38 02 00 00       	push   $0x238
  803eee:	68 45 4c 80 00       	push   $0x804c45
  803ef3:	e8 9e c9 ff ff       	call   800896 <_panic>
  803ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efb:	8b 00                	mov    (%eax),%eax
  803efd:	85 c0                	test   %eax,%eax
  803eff:	74 10                	je     803f11 <realloc_block_FF+0x56a>
  803f01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f04:	8b 00                	mov    (%eax),%eax
  803f06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f09:	8b 52 04             	mov    0x4(%edx),%edx
  803f0c:	89 50 04             	mov    %edx,0x4(%eax)
  803f0f:	eb 0b                	jmp    803f1c <realloc_block_FF+0x575>
  803f11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f14:	8b 40 04             	mov    0x4(%eax),%eax
  803f17:	a3 34 50 80 00       	mov    %eax,0x805034
  803f1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f1f:	8b 40 04             	mov    0x4(%eax),%eax
  803f22:	85 c0                	test   %eax,%eax
  803f24:	74 0f                	je     803f35 <realloc_block_FF+0x58e>
  803f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f29:	8b 40 04             	mov    0x4(%eax),%eax
  803f2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f2f:	8b 12                	mov    (%edx),%edx
  803f31:	89 10                	mov    %edx,(%eax)
  803f33:	eb 0a                	jmp    803f3f <realloc_block_FF+0x598>
  803f35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f38:	8b 00                	mov    (%eax),%eax
  803f3a:	a3 30 50 80 00       	mov    %eax,0x805030
  803f3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f52:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f57:	48                   	dec    %eax
  803f58:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803f5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f63:	01 d0                	add    %edx,%eax
  803f65:	83 ec 04             	sub    $0x4,%esp
  803f68:	6a 01                	push   $0x1
  803f6a:	50                   	push   %eax
  803f6b:	ff 75 08             	pushl  0x8(%ebp)
  803f6e:	e8 41 ea ff ff       	call   8029b4 <set_block_data>
  803f73:	83 c4 10             	add    $0x10,%esp
  803f76:	e9 36 01 00 00       	jmp    8040b1 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803f7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f7e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f81:	01 d0                	add    %edx,%eax
  803f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803f86:	83 ec 04             	sub    $0x4,%esp
  803f89:	6a 01                	push   $0x1
  803f8b:	ff 75 f0             	pushl  -0x10(%ebp)
  803f8e:	ff 75 08             	pushl  0x8(%ebp)
  803f91:	e8 1e ea ff ff       	call   8029b4 <set_block_data>
  803f96:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803f99:	8b 45 08             	mov    0x8(%ebp),%eax
  803f9c:	83 e8 04             	sub    $0x4,%eax
  803f9f:	8b 00                	mov    (%eax),%eax
  803fa1:	83 e0 fe             	and    $0xfffffffe,%eax
  803fa4:	89 c2                	mov    %eax,%edx
  803fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa9:	01 d0                	add    %edx,%eax
  803fab:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803fae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fb2:	74 06                	je     803fba <realloc_block_FF+0x613>
  803fb4:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803fb8:	75 17                	jne    803fd1 <realloc_block_FF+0x62a>
  803fba:	83 ec 04             	sub    $0x4,%esp
  803fbd:	68 b8 4c 80 00       	push   $0x804cb8
  803fc2:	68 44 02 00 00       	push   $0x244
  803fc7:	68 45 4c 80 00       	push   $0x804c45
  803fcc:	e8 c5 c8 ff ff       	call   800896 <_panic>
  803fd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd4:	8b 10                	mov    (%eax),%edx
  803fd6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fd9:	89 10                	mov    %edx,(%eax)
  803fdb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fde:	8b 00                	mov    (%eax),%eax
  803fe0:	85 c0                	test   %eax,%eax
  803fe2:	74 0b                	je     803fef <realloc_block_FF+0x648>
  803fe4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe7:	8b 00                	mov    (%eax),%eax
  803fe9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803fec:	89 50 04             	mov    %edx,0x4(%eax)
  803fef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ff5:	89 10                	mov    %edx,(%eax)
  803ff7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ffa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ffd:	89 50 04             	mov    %edx,0x4(%eax)
  804000:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804003:	8b 00                	mov    (%eax),%eax
  804005:	85 c0                	test   %eax,%eax
  804007:	75 08                	jne    804011 <realloc_block_FF+0x66a>
  804009:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80400c:	a3 34 50 80 00       	mov    %eax,0x805034
  804011:	a1 3c 50 80 00       	mov    0x80503c,%eax
  804016:	40                   	inc    %eax
  804017:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80401c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804020:	75 17                	jne    804039 <realloc_block_FF+0x692>
  804022:	83 ec 04             	sub    $0x4,%esp
  804025:	68 27 4c 80 00       	push   $0x804c27
  80402a:	68 45 02 00 00       	push   $0x245
  80402f:	68 45 4c 80 00       	push   $0x804c45
  804034:	e8 5d c8 ff ff       	call   800896 <_panic>
  804039:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80403c:	8b 00                	mov    (%eax),%eax
  80403e:	85 c0                	test   %eax,%eax
  804040:	74 10                	je     804052 <realloc_block_FF+0x6ab>
  804042:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804045:	8b 00                	mov    (%eax),%eax
  804047:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80404a:	8b 52 04             	mov    0x4(%edx),%edx
  80404d:	89 50 04             	mov    %edx,0x4(%eax)
  804050:	eb 0b                	jmp    80405d <realloc_block_FF+0x6b6>
  804052:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804055:	8b 40 04             	mov    0x4(%eax),%eax
  804058:	a3 34 50 80 00       	mov    %eax,0x805034
  80405d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804060:	8b 40 04             	mov    0x4(%eax),%eax
  804063:	85 c0                	test   %eax,%eax
  804065:	74 0f                	je     804076 <realloc_block_FF+0x6cf>
  804067:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80406a:	8b 40 04             	mov    0x4(%eax),%eax
  80406d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804070:	8b 12                	mov    (%edx),%edx
  804072:	89 10                	mov    %edx,(%eax)
  804074:	eb 0a                	jmp    804080 <realloc_block_FF+0x6d9>
  804076:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804079:	8b 00                	mov    (%eax),%eax
  80407b:	a3 30 50 80 00       	mov    %eax,0x805030
  804080:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804083:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804089:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80408c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804093:	a1 3c 50 80 00       	mov    0x80503c,%eax
  804098:	48                   	dec    %eax
  804099:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  80409e:	83 ec 04             	sub    $0x4,%esp
  8040a1:	6a 00                	push   $0x0
  8040a3:	ff 75 bc             	pushl  -0x44(%ebp)
  8040a6:	ff 75 b8             	pushl  -0x48(%ebp)
  8040a9:	e8 06 e9 ff ff       	call   8029b4 <set_block_data>
  8040ae:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8040b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b4:	eb 0a                	jmp    8040c0 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8040b6:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8040bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8040c0:	c9                   	leave  
  8040c1:	c3                   	ret    

008040c2 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8040c2:	55                   	push   %ebp
  8040c3:	89 e5                	mov    %esp,%ebp
  8040c5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8040c8:	83 ec 04             	sub    $0x4,%esp
  8040cb:	68 3c 4d 80 00       	push   $0x804d3c
  8040d0:	68 58 02 00 00       	push   $0x258
  8040d5:	68 45 4c 80 00       	push   $0x804c45
  8040da:	e8 b7 c7 ff ff       	call   800896 <_panic>

008040df <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8040df:	55                   	push   %ebp
  8040e0:	89 e5                	mov    %esp,%ebp
  8040e2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8040e5:	83 ec 04             	sub    $0x4,%esp
  8040e8:	68 64 4d 80 00       	push   $0x804d64
  8040ed:	68 61 02 00 00       	push   $0x261
  8040f2:	68 45 4c 80 00       	push   $0x804c45
  8040f7:	e8 9a c7 ff ff       	call   800896 <_panic>

008040fc <__udivdi3>:
  8040fc:	55                   	push   %ebp
  8040fd:	57                   	push   %edi
  8040fe:	56                   	push   %esi
  8040ff:	53                   	push   %ebx
  804100:	83 ec 1c             	sub    $0x1c,%esp
  804103:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804107:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80410b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80410f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804113:	89 ca                	mov    %ecx,%edx
  804115:	89 f8                	mov    %edi,%eax
  804117:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80411b:	85 f6                	test   %esi,%esi
  80411d:	75 2d                	jne    80414c <__udivdi3+0x50>
  80411f:	39 cf                	cmp    %ecx,%edi
  804121:	77 65                	ja     804188 <__udivdi3+0x8c>
  804123:	89 fd                	mov    %edi,%ebp
  804125:	85 ff                	test   %edi,%edi
  804127:	75 0b                	jne    804134 <__udivdi3+0x38>
  804129:	b8 01 00 00 00       	mov    $0x1,%eax
  80412e:	31 d2                	xor    %edx,%edx
  804130:	f7 f7                	div    %edi
  804132:	89 c5                	mov    %eax,%ebp
  804134:	31 d2                	xor    %edx,%edx
  804136:	89 c8                	mov    %ecx,%eax
  804138:	f7 f5                	div    %ebp
  80413a:	89 c1                	mov    %eax,%ecx
  80413c:	89 d8                	mov    %ebx,%eax
  80413e:	f7 f5                	div    %ebp
  804140:	89 cf                	mov    %ecx,%edi
  804142:	89 fa                	mov    %edi,%edx
  804144:	83 c4 1c             	add    $0x1c,%esp
  804147:	5b                   	pop    %ebx
  804148:	5e                   	pop    %esi
  804149:	5f                   	pop    %edi
  80414a:	5d                   	pop    %ebp
  80414b:	c3                   	ret    
  80414c:	39 ce                	cmp    %ecx,%esi
  80414e:	77 28                	ja     804178 <__udivdi3+0x7c>
  804150:	0f bd fe             	bsr    %esi,%edi
  804153:	83 f7 1f             	xor    $0x1f,%edi
  804156:	75 40                	jne    804198 <__udivdi3+0x9c>
  804158:	39 ce                	cmp    %ecx,%esi
  80415a:	72 0a                	jb     804166 <__udivdi3+0x6a>
  80415c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804160:	0f 87 9e 00 00 00    	ja     804204 <__udivdi3+0x108>
  804166:	b8 01 00 00 00       	mov    $0x1,%eax
  80416b:	89 fa                	mov    %edi,%edx
  80416d:	83 c4 1c             	add    $0x1c,%esp
  804170:	5b                   	pop    %ebx
  804171:	5e                   	pop    %esi
  804172:	5f                   	pop    %edi
  804173:	5d                   	pop    %ebp
  804174:	c3                   	ret    
  804175:	8d 76 00             	lea    0x0(%esi),%esi
  804178:	31 ff                	xor    %edi,%edi
  80417a:	31 c0                	xor    %eax,%eax
  80417c:	89 fa                	mov    %edi,%edx
  80417e:	83 c4 1c             	add    $0x1c,%esp
  804181:	5b                   	pop    %ebx
  804182:	5e                   	pop    %esi
  804183:	5f                   	pop    %edi
  804184:	5d                   	pop    %ebp
  804185:	c3                   	ret    
  804186:	66 90                	xchg   %ax,%ax
  804188:	89 d8                	mov    %ebx,%eax
  80418a:	f7 f7                	div    %edi
  80418c:	31 ff                	xor    %edi,%edi
  80418e:	89 fa                	mov    %edi,%edx
  804190:	83 c4 1c             	add    $0x1c,%esp
  804193:	5b                   	pop    %ebx
  804194:	5e                   	pop    %esi
  804195:	5f                   	pop    %edi
  804196:	5d                   	pop    %ebp
  804197:	c3                   	ret    
  804198:	bd 20 00 00 00       	mov    $0x20,%ebp
  80419d:	89 eb                	mov    %ebp,%ebx
  80419f:	29 fb                	sub    %edi,%ebx
  8041a1:	89 f9                	mov    %edi,%ecx
  8041a3:	d3 e6                	shl    %cl,%esi
  8041a5:	89 c5                	mov    %eax,%ebp
  8041a7:	88 d9                	mov    %bl,%cl
  8041a9:	d3 ed                	shr    %cl,%ebp
  8041ab:	89 e9                	mov    %ebp,%ecx
  8041ad:	09 f1                	or     %esi,%ecx
  8041af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8041b3:	89 f9                	mov    %edi,%ecx
  8041b5:	d3 e0                	shl    %cl,%eax
  8041b7:	89 c5                	mov    %eax,%ebp
  8041b9:	89 d6                	mov    %edx,%esi
  8041bb:	88 d9                	mov    %bl,%cl
  8041bd:	d3 ee                	shr    %cl,%esi
  8041bf:	89 f9                	mov    %edi,%ecx
  8041c1:	d3 e2                	shl    %cl,%edx
  8041c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041c7:	88 d9                	mov    %bl,%cl
  8041c9:	d3 e8                	shr    %cl,%eax
  8041cb:	09 c2                	or     %eax,%edx
  8041cd:	89 d0                	mov    %edx,%eax
  8041cf:	89 f2                	mov    %esi,%edx
  8041d1:	f7 74 24 0c          	divl   0xc(%esp)
  8041d5:	89 d6                	mov    %edx,%esi
  8041d7:	89 c3                	mov    %eax,%ebx
  8041d9:	f7 e5                	mul    %ebp
  8041db:	39 d6                	cmp    %edx,%esi
  8041dd:	72 19                	jb     8041f8 <__udivdi3+0xfc>
  8041df:	74 0b                	je     8041ec <__udivdi3+0xf0>
  8041e1:	89 d8                	mov    %ebx,%eax
  8041e3:	31 ff                	xor    %edi,%edi
  8041e5:	e9 58 ff ff ff       	jmp    804142 <__udivdi3+0x46>
  8041ea:	66 90                	xchg   %ax,%ax
  8041ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8041f0:	89 f9                	mov    %edi,%ecx
  8041f2:	d3 e2                	shl    %cl,%edx
  8041f4:	39 c2                	cmp    %eax,%edx
  8041f6:	73 e9                	jae    8041e1 <__udivdi3+0xe5>
  8041f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8041fb:	31 ff                	xor    %edi,%edi
  8041fd:	e9 40 ff ff ff       	jmp    804142 <__udivdi3+0x46>
  804202:	66 90                	xchg   %ax,%ax
  804204:	31 c0                	xor    %eax,%eax
  804206:	e9 37 ff ff ff       	jmp    804142 <__udivdi3+0x46>
  80420b:	90                   	nop

0080420c <__umoddi3>:
  80420c:	55                   	push   %ebp
  80420d:	57                   	push   %edi
  80420e:	56                   	push   %esi
  80420f:	53                   	push   %ebx
  804210:	83 ec 1c             	sub    $0x1c,%esp
  804213:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804217:	8b 74 24 34          	mov    0x34(%esp),%esi
  80421b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80421f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804223:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804227:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80422b:	89 f3                	mov    %esi,%ebx
  80422d:	89 fa                	mov    %edi,%edx
  80422f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804233:	89 34 24             	mov    %esi,(%esp)
  804236:	85 c0                	test   %eax,%eax
  804238:	75 1a                	jne    804254 <__umoddi3+0x48>
  80423a:	39 f7                	cmp    %esi,%edi
  80423c:	0f 86 a2 00 00 00    	jbe    8042e4 <__umoddi3+0xd8>
  804242:	89 c8                	mov    %ecx,%eax
  804244:	89 f2                	mov    %esi,%edx
  804246:	f7 f7                	div    %edi
  804248:	89 d0                	mov    %edx,%eax
  80424a:	31 d2                	xor    %edx,%edx
  80424c:	83 c4 1c             	add    $0x1c,%esp
  80424f:	5b                   	pop    %ebx
  804250:	5e                   	pop    %esi
  804251:	5f                   	pop    %edi
  804252:	5d                   	pop    %ebp
  804253:	c3                   	ret    
  804254:	39 f0                	cmp    %esi,%eax
  804256:	0f 87 ac 00 00 00    	ja     804308 <__umoddi3+0xfc>
  80425c:	0f bd e8             	bsr    %eax,%ebp
  80425f:	83 f5 1f             	xor    $0x1f,%ebp
  804262:	0f 84 ac 00 00 00    	je     804314 <__umoddi3+0x108>
  804268:	bf 20 00 00 00       	mov    $0x20,%edi
  80426d:	29 ef                	sub    %ebp,%edi
  80426f:	89 fe                	mov    %edi,%esi
  804271:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804275:	89 e9                	mov    %ebp,%ecx
  804277:	d3 e0                	shl    %cl,%eax
  804279:	89 d7                	mov    %edx,%edi
  80427b:	89 f1                	mov    %esi,%ecx
  80427d:	d3 ef                	shr    %cl,%edi
  80427f:	09 c7                	or     %eax,%edi
  804281:	89 e9                	mov    %ebp,%ecx
  804283:	d3 e2                	shl    %cl,%edx
  804285:	89 14 24             	mov    %edx,(%esp)
  804288:	89 d8                	mov    %ebx,%eax
  80428a:	d3 e0                	shl    %cl,%eax
  80428c:	89 c2                	mov    %eax,%edx
  80428e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804292:	d3 e0                	shl    %cl,%eax
  804294:	89 44 24 04          	mov    %eax,0x4(%esp)
  804298:	8b 44 24 08          	mov    0x8(%esp),%eax
  80429c:	89 f1                	mov    %esi,%ecx
  80429e:	d3 e8                	shr    %cl,%eax
  8042a0:	09 d0                	or     %edx,%eax
  8042a2:	d3 eb                	shr    %cl,%ebx
  8042a4:	89 da                	mov    %ebx,%edx
  8042a6:	f7 f7                	div    %edi
  8042a8:	89 d3                	mov    %edx,%ebx
  8042aa:	f7 24 24             	mull   (%esp)
  8042ad:	89 c6                	mov    %eax,%esi
  8042af:	89 d1                	mov    %edx,%ecx
  8042b1:	39 d3                	cmp    %edx,%ebx
  8042b3:	0f 82 87 00 00 00    	jb     804340 <__umoddi3+0x134>
  8042b9:	0f 84 91 00 00 00    	je     804350 <__umoddi3+0x144>
  8042bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8042c3:	29 f2                	sub    %esi,%edx
  8042c5:	19 cb                	sbb    %ecx,%ebx
  8042c7:	89 d8                	mov    %ebx,%eax
  8042c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8042cd:	d3 e0                	shl    %cl,%eax
  8042cf:	89 e9                	mov    %ebp,%ecx
  8042d1:	d3 ea                	shr    %cl,%edx
  8042d3:	09 d0                	or     %edx,%eax
  8042d5:	89 e9                	mov    %ebp,%ecx
  8042d7:	d3 eb                	shr    %cl,%ebx
  8042d9:	89 da                	mov    %ebx,%edx
  8042db:	83 c4 1c             	add    $0x1c,%esp
  8042de:	5b                   	pop    %ebx
  8042df:	5e                   	pop    %esi
  8042e0:	5f                   	pop    %edi
  8042e1:	5d                   	pop    %ebp
  8042e2:	c3                   	ret    
  8042e3:	90                   	nop
  8042e4:	89 fd                	mov    %edi,%ebp
  8042e6:	85 ff                	test   %edi,%edi
  8042e8:	75 0b                	jne    8042f5 <__umoddi3+0xe9>
  8042ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8042ef:	31 d2                	xor    %edx,%edx
  8042f1:	f7 f7                	div    %edi
  8042f3:	89 c5                	mov    %eax,%ebp
  8042f5:	89 f0                	mov    %esi,%eax
  8042f7:	31 d2                	xor    %edx,%edx
  8042f9:	f7 f5                	div    %ebp
  8042fb:	89 c8                	mov    %ecx,%eax
  8042fd:	f7 f5                	div    %ebp
  8042ff:	89 d0                	mov    %edx,%eax
  804301:	e9 44 ff ff ff       	jmp    80424a <__umoddi3+0x3e>
  804306:	66 90                	xchg   %ax,%ax
  804308:	89 c8                	mov    %ecx,%eax
  80430a:	89 f2                	mov    %esi,%edx
  80430c:	83 c4 1c             	add    $0x1c,%esp
  80430f:	5b                   	pop    %ebx
  804310:	5e                   	pop    %esi
  804311:	5f                   	pop    %edi
  804312:	5d                   	pop    %ebp
  804313:	c3                   	ret    
  804314:	3b 04 24             	cmp    (%esp),%eax
  804317:	72 06                	jb     80431f <__umoddi3+0x113>
  804319:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80431d:	77 0f                	ja     80432e <__umoddi3+0x122>
  80431f:	89 f2                	mov    %esi,%edx
  804321:	29 f9                	sub    %edi,%ecx
  804323:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804327:	89 14 24             	mov    %edx,(%esp)
  80432a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80432e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804332:	8b 14 24             	mov    (%esp),%edx
  804335:	83 c4 1c             	add    $0x1c,%esp
  804338:	5b                   	pop    %ebx
  804339:	5e                   	pop    %esi
  80433a:	5f                   	pop    %edi
  80433b:	5d                   	pop    %ebp
  80433c:	c3                   	ret    
  80433d:	8d 76 00             	lea    0x0(%esi),%esi
  804340:	2b 04 24             	sub    (%esp),%eax
  804343:	19 fa                	sbb    %edi,%edx
  804345:	89 d1                	mov    %edx,%ecx
  804347:	89 c6                	mov    %eax,%esi
  804349:	e9 71 ff ff ff       	jmp    8042bf <__umoddi3+0xb3>
  80434e:	66 90                	xchg   %ax,%ax
  804350:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804354:	72 ea                	jb     804340 <__umoddi3+0x134>
  804356:	89 d9                	mov    %ebx,%ecx
  804358:	e9 62 ff ff ff       	jmp    8042bf <__umoddi3+0xb3>
