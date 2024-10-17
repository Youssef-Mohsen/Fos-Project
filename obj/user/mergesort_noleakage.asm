
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
  800041:	e8 54 1c 00 00       	call   801c9a <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 24 80 00       	push   $0x8024c0
  80004e:	e8 0e 0b 00 00       	call   800b61 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 24 80 00       	push   $0x8024c2
  80005e:	e8 fe 0a 00 00       	call   800b61 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 d8 24 80 00       	push   $0x8024d8
  80006e:	e8 ee 0a 00 00       	call   800b61 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 24 80 00       	push   $0x8024c2
  80007e:	e8 de 0a 00 00       	call   800b61 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 24 80 00       	push   $0x8024c0
  80008e:	e8 ce 0a 00 00       	call   800b61 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 f0 24 80 00       	push   $0x8024f0
  8000a5:	e8 4b 11 00 00       	call   8011f5 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			cprintf("Chose the initialization method:\n") ;
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 10 25 80 00       	push   $0x802510
  8000b5:	e8 a7 0a 00 00       	call   800b61 <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 32 25 80 00       	push   $0x802532
  8000c5:	e8 97 0a 00 00       	call   800b61 <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 40 25 80 00       	push   $0x802540
  8000d5:	e8 87 0a 00 00       	call   800b61 <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	68 4f 25 80 00       	push   $0x80254f
  8000e5:	e8 77 0a 00 00       	call   800b61 <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 5f 25 80 00       	push   $0x80255f
  8000f5:	e8 67 0a 00 00       	call   800b61 <cprintf>
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
  800134:	e8 7b 1b 00 00       	call   801cb4 <sys_unlock_cons>
		//sys_unlock_cons();

		NumOfElements = strtol(Line, NULL, 10) ;
  800139:	83 ec 04             	sub    $0x4,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	6a 00                	push   $0x0
  800140:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800146:	50                   	push   %eax
  800147:	e8 11 16 00 00       	call   80175d <strtol>
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 b8 19 00 00       	call   801b19 <malloc>
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
  8001da:	68 68 25 80 00       	push   $0x802568
  8001df:	e8 aa 09 00 00       	call   800b8e <atomic_cprintf>
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
  800204:	68 9c 25 80 00       	push   $0x80259c
  800209:	6a 4d                	push   $0x4d
  80020b:	68 be 25 80 00       	push   $0x8025be
  800210:	e8 8f 06 00 00       	call   8008a4 <_panic>
		else
		{
			//sys_lock_cons();
			sys_lock_cons();
  800215:	e8 80 1a 00 00       	call   801c9a <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 dc 25 80 00       	push   $0x8025dc
  800222:	e8 3a 09 00 00       	call   800b61 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 10 26 80 00       	push   $0x802610
  800232:	e8 2a 09 00 00       	call   800b61 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 44 26 80 00       	push   $0x802644
  800242:	e8 1a 09 00 00       	call   800b61 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  80024a:	e8 65 1a 00 00       	call   801cb4 <sys_unlock_cons>
			//sys_unlock_cons();
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 e8 18 00 00       	call   801b42 <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  80025d:	e8 38 1a 00 00       	call   801c9a <sys_lock_cons>
		{
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 42                	jmp    8002aa <_main+0x272>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 76 26 80 00       	push   $0x802676
  800270:	e8 ec 08 00 00       	call   800b61 <cprintf>
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
  8002b6:	e8 f9 19 00 00       	call   801cb4 <sys_unlock_cons>
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
  80044a:	68 c0 24 80 00       	push   $0x8024c0
  80044f:	e8 0d 07 00 00       	call   800b61 <cprintf>
  800454:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80045a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	01 d0                	add    %edx,%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	83 ec 08             	sub    $0x8,%esp
  80046b:	50                   	push   %eax
  80046c:	68 94 26 80 00       	push   $0x802694
  800471:	e8 eb 06 00 00       	call   800b61 <cprintf>
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
  80049a:	68 99 26 80 00       	push   $0x802699
  80049f:	e8 bd 06 00 00       	call   800b61 <cprintf>
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
  800540:	e8 d4 15 00 00       	call   801b19 <malloc>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  80054b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054e:	c1 e0 02             	shl    $0x2,%eax
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	50                   	push   %eax
  800555:	e8 bf 15 00 00       	call   801b19 <malloc>
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
  800702:	e8 3b 14 00 00       	call   801b42 <free>
  800707:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800710:	e8 2d 14 00 00       	call   801b42 <free>
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
  80072f:	e8 b1 16 00 00       	call   801de5 <sys_cputc>
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
  800740:	e8 3c 15 00 00       	call   801c81 <sys_cgetc>
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
  80075d:	e8 b4 17 00 00       	call   801f16 <sys_getenvindex>
  800762:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800765:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800768:	89 d0                	mov    %edx,%eax
  80076a:	c1 e0 06             	shl    $0x6,%eax
  80076d:	29 d0                	sub    %edx,%eax
  80076f:	c1 e0 02             	shl    $0x2,%eax
  800772:	01 d0                	add    %edx,%eax
  800774:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80077b:	01 c8                	add    %ecx,%eax
  80077d:	c1 e0 03             	shl    $0x3,%eax
  800780:	01 d0                	add    %edx,%eax
  800782:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800789:	29 c2                	sub    %eax,%edx
  80078b:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800792:	89 c2                	mov    %eax,%edx
  800794:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80079a:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80079f:	a1 08 30 80 00       	mov    0x803008,%eax
  8007a4:	8a 40 20             	mov    0x20(%eax),%al
  8007a7:	84 c0                	test   %al,%al
  8007a9:	74 0d                	je     8007b8 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8007ab:	a1 08 30 80 00       	mov    0x803008,%eax
  8007b0:	83 c0 20             	add    $0x20,%eax
  8007b3:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007bc:	7e 0a                	jle    8007c8 <libmain+0x71>
		binaryname = argv[0];
  8007be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ce:	ff 75 08             	pushl  0x8(%ebp)
  8007d1:	e8 62 f8 ff ff       	call   800038 <_main>
  8007d6:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8007d9:	e8 bc 14 00 00       	call   801c9a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8007de:	83 ec 0c             	sub    $0xc,%esp
  8007e1:	68 b8 26 80 00       	push   $0x8026b8
  8007e6:	e8 76 03 00 00       	call   800b61 <cprintf>
  8007eb:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007ee:	a1 08 30 80 00       	mov    0x803008,%eax
  8007f3:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8007f9:	a1 08 30 80 00       	mov    0x803008,%eax
  8007fe:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800804:	83 ec 04             	sub    $0x4,%esp
  800807:	52                   	push   %edx
  800808:	50                   	push   %eax
  800809:	68 e0 26 80 00       	push   $0x8026e0
  80080e:	e8 4e 03 00 00       	call   800b61 <cprintf>
  800813:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800816:	a1 08 30 80 00       	mov    0x803008,%eax
  80081b:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800821:	a1 08 30 80 00       	mov    0x803008,%eax
  800826:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80082c:	a1 08 30 80 00       	mov    0x803008,%eax
  800831:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800837:	51                   	push   %ecx
  800838:	52                   	push   %edx
  800839:	50                   	push   %eax
  80083a:	68 08 27 80 00       	push   $0x802708
  80083f:	e8 1d 03 00 00       	call   800b61 <cprintf>
  800844:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800847:	a1 08 30 80 00       	mov    0x803008,%eax
  80084c:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	50                   	push   %eax
  800856:	68 60 27 80 00       	push   $0x802760
  80085b:	e8 01 03 00 00       	call   800b61 <cprintf>
  800860:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800863:	83 ec 0c             	sub    $0xc,%esp
  800866:	68 b8 26 80 00       	push   $0x8026b8
  80086b:	e8 f1 02 00 00       	call   800b61 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800873:	e8 3c 14 00 00       	call   801cb4 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800878:	e8 19 00 00 00       	call   800896 <exit>
}
  80087d:	90                   	nop
  80087e:	c9                   	leave  
  80087f:	c3                   	ret    

00800880 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800886:	83 ec 0c             	sub    $0xc,%esp
  800889:	6a 00                	push   $0x0
  80088b:	e8 52 16 00 00       	call   801ee2 <sys_destroy_env>
  800890:	83 c4 10             	add    $0x10,%esp
}
  800893:	90                   	nop
  800894:	c9                   	leave  
  800895:	c3                   	ret    

00800896 <exit>:

void
exit(void)
{
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80089c:	e8 a7 16 00 00       	call   801f48 <sys_exit_env>
}
  8008a1:	90                   	nop
  8008a2:	c9                   	leave  
  8008a3:	c3                   	ret    

008008a4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
  8008a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008aa:	8d 45 10             	lea    0x10(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008b3:	a1 28 30 80 00       	mov    0x803028,%eax
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	74 16                	je     8008d2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008bc:	a1 28 30 80 00       	mov    0x803028,%eax
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	50                   	push   %eax
  8008c5:	68 74 27 80 00       	push   $0x802774
  8008ca:	e8 92 02 00 00       	call   800b61 <cprintf>
  8008cf:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008d2:	a1 00 30 80 00       	mov    0x803000,%eax
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	50                   	push   %eax
  8008de:	68 79 27 80 00       	push   $0x802779
  8008e3:	e8 79 02 00 00       	call   800b61 <cprintf>
  8008e8:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f4:	50                   	push   %eax
  8008f5:	e8 fc 01 00 00       	call   800af6 <vcprintf>
  8008fa:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	6a 00                	push   $0x0
  800902:	68 95 27 80 00       	push   $0x802795
  800907:	e8 ea 01 00 00       	call   800af6 <vcprintf>
  80090c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80090f:	e8 82 ff ff ff       	call   800896 <exit>

	// should not return here
	while (1) ;
  800914:	eb fe                	jmp    800914 <_panic+0x70>

00800916 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80091c:	a1 08 30 80 00       	mov    0x803008,%eax
  800921:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800927:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092a:	39 c2                	cmp    %eax,%edx
  80092c:	74 14                	je     800942 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80092e:	83 ec 04             	sub    $0x4,%esp
  800931:	68 98 27 80 00       	push   $0x802798
  800936:	6a 26                	push   $0x26
  800938:	68 e4 27 80 00       	push   $0x8027e4
  80093d:	e8 62 ff ff ff       	call   8008a4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800942:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800949:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800950:	e9 c5 00 00 00       	jmp    800a1a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800958:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	01 d0                	add    %edx,%eax
  800964:	8b 00                	mov    (%eax),%eax
  800966:	85 c0                	test   %eax,%eax
  800968:	75 08                	jne    800972 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80096a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80096d:	e9 a5 00 00 00       	jmp    800a17 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800972:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800979:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800980:	eb 69                	jmp    8009eb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800982:	a1 08 30 80 00       	mov    0x803008,%eax
  800987:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80098d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800990:	89 d0                	mov    %edx,%eax
  800992:	01 c0                	add    %eax,%eax
  800994:	01 d0                	add    %edx,%eax
  800996:	c1 e0 03             	shl    $0x3,%eax
  800999:	01 c8                	add    %ecx,%eax
  80099b:	8a 40 04             	mov    0x4(%eax),%al
  80099e:	84 c0                	test   %al,%al
  8009a0:	75 46                	jne    8009e8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009a2:	a1 08 30 80 00       	mov    0x803008,%eax
  8009a7:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8009ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009b0:	89 d0                	mov    %edx,%eax
  8009b2:	01 c0                	add    %eax,%eax
  8009b4:	01 d0                	add    %edx,%eax
  8009b6:	c1 e0 03             	shl    $0x3,%eax
  8009b9:	01 c8                	add    %ecx,%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	01 c8                	add    %ecx,%eax
  8009d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009db:	39 c2                	cmp    %eax,%edx
  8009dd:	75 09                	jne    8009e8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8009df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009e6:	eb 15                	jmp    8009fd <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009e8:	ff 45 e8             	incl   -0x18(%ebp)
  8009eb:	a1 08 30 80 00       	mov    0x803008,%eax
  8009f0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009f9:	39 c2                	cmp    %eax,%edx
  8009fb:	77 85                	ja     800982 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a01:	75 14                	jne    800a17 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a03:	83 ec 04             	sub    $0x4,%esp
  800a06:	68 f0 27 80 00       	push   $0x8027f0
  800a0b:	6a 3a                	push   $0x3a
  800a0d:	68 e4 27 80 00       	push   $0x8027e4
  800a12:	e8 8d fe ff ff       	call   8008a4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a17:	ff 45 f0             	incl   -0x10(%ebp)
  800a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a20:	0f 8c 2f ff ff ff    	jl     800955 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a2d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a34:	eb 26                	jmp    800a5c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a36:	a1 08 30 80 00       	mov    0x803008,%eax
  800a3b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800a41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a44:	89 d0                	mov    %edx,%eax
  800a46:	01 c0                	add    %eax,%eax
  800a48:	01 d0                	add    %edx,%eax
  800a4a:	c1 e0 03             	shl    $0x3,%eax
  800a4d:	01 c8                	add    %ecx,%eax
  800a4f:	8a 40 04             	mov    0x4(%eax),%al
  800a52:	3c 01                	cmp    $0x1,%al
  800a54:	75 03                	jne    800a59 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a56:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a59:	ff 45 e0             	incl   -0x20(%ebp)
  800a5c:	a1 08 30 80 00       	mov    0x803008,%eax
  800a61:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	77 c8                	ja     800a36 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a71:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a74:	74 14                	je     800a8a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a76:	83 ec 04             	sub    $0x4,%esp
  800a79:	68 44 28 80 00       	push   $0x802844
  800a7e:	6a 44                	push   $0x44
  800a80:	68 e4 27 80 00       	push   $0x8027e4
  800a85:	e8 1a fe ff ff       	call   8008a4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a8a:	90                   	nop
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a96:	8b 00                	mov    (%eax),%eax
  800a98:	8d 48 01             	lea    0x1(%eax),%ecx
  800a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9e:	89 0a                	mov    %ecx,(%edx)
  800aa0:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa3:	88 d1                	mov    %dl,%cl
  800aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaf:	8b 00                	mov    (%eax),%eax
  800ab1:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ab6:	75 2c                	jne    800ae4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ab8:	a0 0c 30 80 00       	mov    0x80300c,%al
  800abd:	0f b6 c0             	movzbl %al,%eax
  800ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac3:	8b 12                	mov    (%edx),%edx
  800ac5:	89 d1                	mov    %edx,%ecx
  800ac7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aca:	83 c2 08             	add    $0x8,%edx
  800acd:	83 ec 04             	sub    $0x4,%esp
  800ad0:	50                   	push   %eax
  800ad1:	51                   	push   %ecx
  800ad2:	52                   	push   %edx
  800ad3:	e8 80 11 00 00       	call   801c58 <sys_cputs>
  800ad8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800adb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ade:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae7:	8b 40 04             	mov    0x4(%eax),%eax
  800aea:	8d 50 01             	lea    0x1(%eax),%edx
  800aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af0:	89 50 04             	mov    %edx,0x4(%eax)
}
  800af3:	90                   	nop
  800af4:	c9                   	leave  
  800af5:	c3                   	ret    

00800af6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aff:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b06:	00 00 00 
	b.cnt = 0;
  800b09:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b10:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	ff 75 08             	pushl  0x8(%ebp)
  800b19:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b1f:	50                   	push   %eax
  800b20:	68 8d 0a 80 00       	push   $0x800a8d
  800b25:	e8 11 02 00 00       	call   800d3b <vprintfmt>
  800b2a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b2d:	a0 0c 30 80 00       	mov    0x80300c,%al
  800b32:	0f b6 c0             	movzbl %al,%eax
  800b35:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b3b:	83 ec 04             	sub    $0x4,%esp
  800b3e:	50                   	push   %eax
  800b3f:	52                   	push   %edx
  800b40:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b46:	83 c0 08             	add    $0x8,%eax
  800b49:	50                   	push   %eax
  800b4a:	e8 09 11 00 00       	call   801c58 <sys_cputs>
  800b4f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b52:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800b59:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b5f:	c9                   	leave  
  800b60:	c3                   	ret    

00800b61 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b67:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800b6e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	83 ec 08             	sub    $0x8,%esp
  800b7a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7d:	50                   	push   %eax
  800b7e:	e8 73 ff ff ff       	call   800af6 <vcprintf>
  800b83:	83 c4 10             	add    $0x10,%esp
  800b86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b8c:	c9                   	leave  
  800b8d:	c3                   	ret    

00800b8e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b94:	e8 01 11 00 00       	call   801c9a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b99:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	83 ec 08             	sub    $0x8,%esp
  800ba5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba8:	50                   	push   %eax
  800ba9:	e8 48 ff ff ff       	call   800af6 <vcprintf>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800bb4:	e8 fb 10 00 00       	call   801cb4 <sys_unlock_cons>
	return cnt;
  800bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	53                   	push   %ebx
  800bc2:	83 ec 14             	sub    $0x14,%esp
  800bc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bd1:	8b 45 18             	mov    0x18(%ebp),%eax
  800bd4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bdc:	77 55                	ja     800c33 <printnum+0x75>
  800bde:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800be1:	72 05                	jb     800be8 <printnum+0x2a>
  800be3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800be6:	77 4b                	ja     800c33 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800be8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800beb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bee:	8b 45 18             	mov    0x18(%ebp),%eax
  800bf1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf6:	52                   	push   %edx
  800bf7:	50                   	push   %eax
  800bf8:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfb:	ff 75 f0             	pushl  -0x10(%ebp)
  800bfe:	e8 59 16 00 00       	call   80225c <__udivdi3>
  800c03:	83 c4 10             	add    $0x10,%esp
  800c06:	83 ec 04             	sub    $0x4,%esp
  800c09:	ff 75 20             	pushl  0x20(%ebp)
  800c0c:	53                   	push   %ebx
  800c0d:	ff 75 18             	pushl  0x18(%ebp)
  800c10:	52                   	push   %edx
  800c11:	50                   	push   %eax
  800c12:	ff 75 0c             	pushl  0xc(%ebp)
  800c15:	ff 75 08             	pushl  0x8(%ebp)
  800c18:	e8 a1 ff ff ff       	call   800bbe <printnum>
  800c1d:	83 c4 20             	add    $0x20,%esp
  800c20:	eb 1a                	jmp    800c3c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c22:	83 ec 08             	sub    $0x8,%esp
  800c25:	ff 75 0c             	pushl  0xc(%ebp)
  800c28:	ff 75 20             	pushl  0x20(%ebp)
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	ff d0                	call   *%eax
  800c30:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c33:	ff 4d 1c             	decl   0x1c(%ebp)
  800c36:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c3a:	7f e6                	jg     800c22 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c3c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4a:	53                   	push   %ebx
  800c4b:	51                   	push   %ecx
  800c4c:	52                   	push   %edx
  800c4d:	50                   	push   %eax
  800c4e:	e8 19 17 00 00       	call   80236c <__umoddi3>
  800c53:	83 c4 10             	add    $0x10,%esp
  800c56:	05 b4 2a 80 00       	add    $0x802ab4,%eax
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f be c0             	movsbl %al,%eax
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 0c             	pushl  0xc(%ebp)
  800c66:	50                   	push   %eax
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
}
  800c6f:	90                   	nop
  800c70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c73:	c9                   	leave  
  800c74:	c3                   	ret    

00800c75 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c78:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c7c:	7e 1c                	jle    800c9a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8b 00                	mov    (%eax),%eax
  800c83:	8d 50 08             	lea    0x8(%eax),%edx
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	89 10                	mov    %edx,(%eax)
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8b 00                	mov    (%eax),%eax
  800c90:	83 e8 08             	sub    $0x8,%eax
  800c93:	8b 50 04             	mov    0x4(%eax),%edx
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	eb 40                	jmp    800cda <getuint+0x65>
	else if (lflag)
  800c9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9e:	74 1e                	je     800cbe <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	8b 00                	mov    (%eax),%eax
  800ca5:	8d 50 04             	lea    0x4(%eax),%edx
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	89 10                	mov    %edx,(%eax)
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	8b 00                	mov    (%eax),%eax
  800cb2:	83 e8 04             	sub    $0x4,%eax
  800cb5:	8b 00                	mov    (%eax),%eax
  800cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbc:	eb 1c                	jmp    800cda <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8b 00                	mov    (%eax),%eax
  800cc3:	8d 50 04             	lea    0x4(%eax),%edx
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	89 10                	mov    %edx,(%eax)
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	8b 00                	mov    (%eax),%eax
  800cd0:	83 e8 04             	sub    $0x4,%eax
  800cd3:	8b 00                	mov    (%eax),%eax
  800cd5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cda:	5d                   	pop    %ebp
  800cdb:	c3                   	ret    

00800cdc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800cdc:	55                   	push   %ebp
  800cdd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cdf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ce3:	7e 1c                	jle    800d01 <getint+0x25>
		return va_arg(*ap, long long);
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8b 00                	mov    (%eax),%eax
  800cea:	8d 50 08             	lea    0x8(%eax),%edx
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	89 10                	mov    %edx,(%eax)
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	83 e8 08             	sub    $0x8,%eax
  800cfa:	8b 50 04             	mov    0x4(%eax),%edx
  800cfd:	8b 00                	mov    (%eax),%eax
  800cff:	eb 38                	jmp    800d39 <getint+0x5d>
	else if (lflag)
  800d01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d05:	74 1a                	je     800d21 <getint+0x45>
		return va_arg(*ap, long);
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8b 00                	mov    (%eax),%eax
  800d0c:	8d 50 04             	lea    0x4(%eax),%edx
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 10                	mov    %edx,(%eax)
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8b 00                	mov    (%eax),%eax
  800d19:	83 e8 04             	sub    $0x4,%eax
  800d1c:	8b 00                	mov    (%eax),%eax
  800d1e:	99                   	cltd   
  800d1f:	eb 18                	jmp    800d39 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8b 00                	mov    (%eax),%eax
  800d26:	8d 50 04             	lea    0x4(%eax),%edx
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	89 10                	mov    %edx,(%eax)
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8b 00                	mov    (%eax),%eax
  800d33:	83 e8 04             	sub    $0x4,%eax
  800d36:	8b 00                	mov    (%eax),%eax
  800d38:	99                   	cltd   
}
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	56                   	push   %esi
  800d3f:	53                   	push   %ebx
  800d40:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d43:	eb 17                	jmp    800d5c <vprintfmt+0x21>
			if (ch == '\0')
  800d45:	85 db                	test   %ebx,%ebx
  800d47:	0f 84 c1 03 00 00    	je     80110e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d4d:	83 ec 08             	sub    $0x8,%esp
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	53                   	push   %ebx
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	ff d0                	call   *%eax
  800d59:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5f:	8d 50 01             	lea    0x1(%eax),%edx
  800d62:	89 55 10             	mov    %edx,0x10(%ebp)
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	0f b6 d8             	movzbl %al,%ebx
  800d6a:	83 fb 25             	cmp    $0x25,%ebx
  800d6d:	75 d6                	jne    800d45 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d6f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d73:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d7a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d81:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d88:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d92:	8d 50 01             	lea    0x1(%eax),%edx
  800d95:	89 55 10             	mov    %edx,0x10(%ebp)
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	0f b6 d8             	movzbl %al,%ebx
  800d9d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800da0:	83 f8 5b             	cmp    $0x5b,%eax
  800da3:	0f 87 3d 03 00 00    	ja     8010e6 <vprintfmt+0x3ab>
  800da9:	8b 04 85 d8 2a 80 00 	mov    0x802ad8(,%eax,4),%eax
  800db0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800db2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800db6:	eb d7                	jmp    800d8f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800db8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800dbc:	eb d1                	jmp    800d8f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dbe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800dc5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dc8:	89 d0                	mov    %edx,%eax
  800dca:	c1 e0 02             	shl    $0x2,%eax
  800dcd:	01 d0                	add    %edx,%eax
  800dcf:	01 c0                	add    %eax,%eax
  800dd1:	01 d8                	add    %ebx,%eax
  800dd3:	83 e8 30             	sub    $0x30,%eax
  800dd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800de1:	83 fb 2f             	cmp    $0x2f,%ebx
  800de4:	7e 3e                	jle    800e24 <vprintfmt+0xe9>
  800de6:	83 fb 39             	cmp    $0x39,%ebx
  800de9:	7f 39                	jg     800e24 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800deb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dee:	eb d5                	jmp    800dc5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800df0:	8b 45 14             	mov    0x14(%ebp),%eax
  800df3:	83 c0 04             	add    $0x4,%eax
  800df6:	89 45 14             	mov    %eax,0x14(%ebp)
  800df9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfc:	83 e8 04             	sub    $0x4,%eax
  800dff:	8b 00                	mov    (%eax),%eax
  800e01:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e04:	eb 1f                	jmp    800e25 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e0a:	79 83                	jns    800d8f <vprintfmt+0x54>
				width = 0;
  800e0c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e13:	e9 77 ff ff ff       	jmp    800d8f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e18:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e1f:	e9 6b ff ff ff       	jmp    800d8f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e24:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e29:	0f 89 60 ff ff ff    	jns    800d8f <vprintfmt+0x54>
				width = precision, precision = -1;
  800e2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e35:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e3c:	e9 4e ff ff ff       	jmp    800d8f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e41:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e44:	e9 46 ff ff ff       	jmp    800d8f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e49:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4c:	83 c0 04             	add    $0x4,%eax
  800e4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e52:	8b 45 14             	mov    0x14(%ebp),%eax
  800e55:	83 e8 04             	sub    $0x4,%eax
  800e58:	8b 00                	mov    (%eax),%eax
  800e5a:	83 ec 08             	sub    $0x8,%esp
  800e5d:	ff 75 0c             	pushl  0xc(%ebp)
  800e60:	50                   	push   %eax
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	ff d0                	call   *%eax
  800e66:	83 c4 10             	add    $0x10,%esp
			break;
  800e69:	e9 9b 02 00 00       	jmp    801109 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e71:	83 c0 04             	add    $0x4,%eax
  800e74:	89 45 14             	mov    %eax,0x14(%ebp)
  800e77:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7a:	83 e8 04             	sub    $0x4,%eax
  800e7d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e7f:	85 db                	test   %ebx,%ebx
  800e81:	79 02                	jns    800e85 <vprintfmt+0x14a>
				err = -err;
  800e83:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e85:	83 fb 64             	cmp    $0x64,%ebx
  800e88:	7f 0b                	jg     800e95 <vprintfmt+0x15a>
  800e8a:	8b 34 9d 20 29 80 00 	mov    0x802920(,%ebx,4),%esi
  800e91:	85 f6                	test   %esi,%esi
  800e93:	75 19                	jne    800eae <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e95:	53                   	push   %ebx
  800e96:	68 c5 2a 80 00       	push   $0x802ac5
  800e9b:	ff 75 0c             	pushl  0xc(%ebp)
  800e9e:	ff 75 08             	pushl  0x8(%ebp)
  800ea1:	e8 70 02 00 00       	call   801116 <printfmt>
  800ea6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ea9:	e9 5b 02 00 00       	jmp    801109 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800eae:	56                   	push   %esi
  800eaf:	68 ce 2a 80 00       	push   $0x802ace
  800eb4:	ff 75 0c             	pushl  0xc(%ebp)
  800eb7:	ff 75 08             	pushl  0x8(%ebp)
  800eba:	e8 57 02 00 00       	call   801116 <printfmt>
  800ebf:	83 c4 10             	add    $0x10,%esp
			break;
  800ec2:	e9 42 02 00 00       	jmp    801109 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ec7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eca:	83 c0 04             	add    $0x4,%eax
  800ecd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed3:	83 e8 04             	sub    $0x4,%eax
  800ed6:	8b 30                	mov    (%eax),%esi
  800ed8:	85 f6                	test   %esi,%esi
  800eda:	75 05                	jne    800ee1 <vprintfmt+0x1a6>
				p = "(null)";
  800edc:	be d1 2a 80 00       	mov    $0x802ad1,%esi
			if (width > 0 && padc != '-')
  800ee1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ee5:	7e 6d                	jle    800f54 <vprintfmt+0x219>
  800ee7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800eeb:	74 67                	je     800f54 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800eed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ef0:	83 ec 08             	sub    $0x8,%esp
  800ef3:	50                   	push   %eax
  800ef4:	56                   	push   %esi
  800ef5:	e8 26 05 00 00       	call   801420 <strnlen>
  800efa:	83 c4 10             	add    $0x10,%esp
  800efd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f00:	eb 16                	jmp    800f18 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f02:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f06:	83 ec 08             	sub    $0x8,%esp
  800f09:	ff 75 0c             	pushl  0xc(%ebp)
  800f0c:	50                   	push   %eax
  800f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f10:	ff d0                	call   *%eax
  800f12:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f15:	ff 4d e4             	decl   -0x1c(%ebp)
  800f18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1c:	7f e4                	jg     800f02 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f1e:	eb 34                	jmp    800f54 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f20:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f24:	74 1c                	je     800f42 <vprintfmt+0x207>
  800f26:	83 fb 1f             	cmp    $0x1f,%ebx
  800f29:	7e 05                	jle    800f30 <vprintfmt+0x1f5>
  800f2b:	83 fb 7e             	cmp    $0x7e,%ebx
  800f2e:	7e 12                	jle    800f42 <vprintfmt+0x207>
					putch('?', putdat);
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	6a 3f                	push   $0x3f
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	ff d0                	call   *%eax
  800f3d:	83 c4 10             	add    $0x10,%esp
  800f40:	eb 0f                	jmp    800f51 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f42:	83 ec 08             	sub    $0x8,%esp
  800f45:	ff 75 0c             	pushl  0xc(%ebp)
  800f48:	53                   	push   %ebx
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	ff d0                	call   *%eax
  800f4e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f51:	ff 4d e4             	decl   -0x1c(%ebp)
  800f54:	89 f0                	mov    %esi,%eax
  800f56:	8d 70 01             	lea    0x1(%eax),%esi
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f be d8             	movsbl %al,%ebx
  800f5e:	85 db                	test   %ebx,%ebx
  800f60:	74 24                	je     800f86 <vprintfmt+0x24b>
  800f62:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f66:	78 b8                	js     800f20 <vprintfmt+0x1e5>
  800f68:	ff 4d e0             	decl   -0x20(%ebp)
  800f6b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f6f:	79 af                	jns    800f20 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f71:	eb 13                	jmp    800f86 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f73:	83 ec 08             	sub    $0x8,%esp
  800f76:	ff 75 0c             	pushl  0xc(%ebp)
  800f79:	6a 20                	push   $0x20
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	ff d0                	call   *%eax
  800f80:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f83:	ff 4d e4             	decl   -0x1c(%ebp)
  800f86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f8a:	7f e7                	jg     800f73 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f8c:	e9 78 01 00 00       	jmp    801109 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f91:	83 ec 08             	sub    $0x8,%esp
  800f94:	ff 75 e8             	pushl  -0x18(%ebp)
  800f97:	8d 45 14             	lea    0x14(%ebp),%eax
  800f9a:	50                   	push   %eax
  800f9b:	e8 3c fd ff ff       	call   800cdc <getint>
  800fa0:	83 c4 10             	add    $0x10,%esp
  800fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800faf:	85 d2                	test   %edx,%edx
  800fb1:	79 23                	jns    800fd6 <vprintfmt+0x29b>
				putch('-', putdat);
  800fb3:	83 ec 08             	sub    $0x8,%esp
  800fb6:	ff 75 0c             	pushl  0xc(%ebp)
  800fb9:	6a 2d                	push   $0x2d
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	ff d0                	call   *%eax
  800fc0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc9:	f7 d8                	neg    %eax
  800fcb:	83 d2 00             	adc    $0x0,%edx
  800fce:	f7 da                	neg    %edx
  800fd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fd6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fdd:	e9 bc 00 00 00       	jmp    80109e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fe2:	83 ec 08             	sub    $0x8,%esp
  800fe5:	ff 75 e8             	pushl  -0x18(%ebp)
  800fe8:	8d 45 14             	lea    0x14(%ebp),%eax
  800feb:	50                   	push   %eax
  800fec:	e8 84 fc ff ff       	call   800c75 <getuint>
  800ff1:	83 c4 10             	add    $0x10,%esp
  800ff4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ffa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801001:	e9 98 00 00 00       	jmp    80109e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	6a 58                	push   $0x58
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	ff d0                	call   *%eax
  801013:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801016:	83 ec 08             	sub    $0x8,%esp
  801019:	ff 75 0c             	pushl  0xc(%ebp)
  80101c:	6a 58                	push   $0x58
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	ff d0                	call   *%eax
  801023:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801026:	83 ec 08             	sub    $0x8,%esp
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	6a 58                	push   $0x58
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	ff d0                	call   *%eax
  801033:	83 c4 10             	add    $0x10,%esp
			break;
  801036:	e9 ce 00 00 00       	jmp    801109 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80103b:	83 ec 08             	sub    $0x8,%esp
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	6a 30                	push   $0x30
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	ff d0                	call   *%eax
  801048:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80104b:	83 ec 08             	sub    $0x8,%esp
  80104e:	ff 75 0c             	pushl  0xc(%ebp)
  801051:	6a 78                	push   $0x78
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	ff d0                	call   *%eax
  801058:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80105b:	8b 45 14             	mov    0x14(%ebp),%eax
  80105e:	83 c0 04             	add    $0x4,%eax
  801061:	89 45 14             	mov    %eax,0x14(%ebp)
  801064:	8b 45 14             	mov    0x14(%ebp),%eax
  801067:	83 e8 04             	sub    $0x4,%eax
  80106a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80106c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80106f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801076:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80107d:	eb 1f                	jmp    80109e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80107f:	83 ec 08             	sub    $0x8,%esp
  801082:	ff 75 e8             	pushl  -0x18(%ebp)
  801085:	8d 45 14             	lea    0x14(%ebp),%eax
  801088:	50                   	push   %eax
  801089:	e8 e7 fb ff ff       	call   800c75 <getuint>
  80108e:	83 c4 10             	add    $0x10,%esp
  801091:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801094:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801097:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80109e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010a5:	83 ec 04             	sub    $0x4,%esp
  8010a8:	52                   	push   %edx
  8010a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010ac:	50                   	push   %eax
  8010ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8010b3:	ff 75 0c             	pushl  0xc(%ebp)
  8010b6:	ff 75 08             	pushl  0x8(%ebp)
  8010b9:	e8 00 fb ff ff       	call   800bbe <printnum>
  8010be:	83 c4 20             	add    $0x20,%esp
			break;
  8010c1:	eb 46                	jmp    801109 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010c3:	83 ec 08             	sub    $0x8,%esp
  8010c6:	ff 75 0c             	pushl  0xc(%ebp)
  8010c9:	53                   	push   %ebx
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	ff d0                	call   *%eax
  8010cf:	83 c4 10             	add    $0x10,%esp
			break;
  8010d2:	eb 35                	jmp    801109 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010d4:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  8010db:	eb 2c                	jmp    801109 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010dd:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  8010e4:	eb 23                	jmp    801109 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010e6:	83 ec 08             	sub    $0x8,%esp
  8010e9:	ff 75 0c             	pushl  0xc(%ebp)
  8010ec:	6a 25                	push   $0x25
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	ff d0                	call   *%eax
  8010f3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010f6:	ff 4d 10             	decl   0x10(%ebp)
  8010f9:	eb 03                	jmp    8010fe <vprintfmt+0x3c3>
  8010fb:	ff 4d 10             	decl   0x10(%ebp)
  8010fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801101:	48                   	dec    %eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	3c 25                	cmp    $0x25,%al
  801106:	75 f3                	jne    8010fb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801108:	90                   	nop
		}
	}
  801109:	e9 35 fc ff ff       	jmp    800d43 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80110e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80110f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801112:	5b                   	pop    %ebx
  801113:	5e                   	pop    %esi
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    

00801116 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80111c:	8d 45 10             	lea    0x10(%ebp),%eax
  80111f:	83 c0 04             	add    $0x4,%eax
  801122:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801125:	8b 45 10             	mov    0x10(%ebp),%eax
  801128:	ff 75 f4             	pushl  -0xc(%ebp)
  80112b:	50                   	push   %eax
  80112c:	ff 75 0c             	pushl  0xc(%ebp)
  80112f:	ff 75 08             	pushl  0x8(%ebp)
  801132:	e8 04 fc ff ff       	call   800d3b <vprintfmt>
  801137:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80113a:	90                   	nop
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	8b 40 08             	mov    0x8(%eax),%eax
  801146:	8d 50 01             	lea    0x1(%eax),%edx
  801149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	8b 10                	mov    (%eax),%edx
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	8b 40 04             	mov    0x4(%eax),%eax
  80115a:	39 c2                	cmp    %eax,%edx
  80115c:	73 12                	jae    801170 <sprintputch+0x33>
		*b->buf++ = ch;
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	8b 00                	mov    (%eax),%eax
  801163:	8d 48 01             	lea    0x1(%eax),%ecx
  801166:	8b 55 0c             	mov    0xc(%ebp),%edx
  801169:	89 0a                	mov    %ecx,(%edx)
  80116b:	8b 55 08             	mov    0x8(%ebp),%edx
  80116e:	88 10                	mov    %dl,(%eax)
}
  801170:	90                   	nop
  801171:	5d                   	pop    %ebp
  801172:	c3                   	ret    

00801173 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	8d 50 ff             	lea    -0x1(%eax),%edx
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	01 d0                	add    %edx,%eax
  80118a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80118d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801194:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801198:	74 06                	je     8011a0 <vsnprintf+0x2d>
  80119a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80119e:	7f 07                	jg     8011a7 <vsnprintf+0x34>
		return -E_INVAL;
  8011a0:	b8 03 00 00 00       	mov    $0x3,%eax
  8011a5:	eb 20                	jmp    8011c7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011a7:	ff 75 14             	pushl  0x14(%ebp)
  8011aa:	ff 75 10             	pushl  0x10(%ebp)
  8011ad:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011b0:	50                   	push   %eax
  8011b1:	68 3d 11 80 00       	push   $0x80113d
  8011b6:	e8 80 fb ff ff       	call   800d3b <vprintfmt>
  8011bb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011c1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011c7:	c9                   	leave  
  8011c8:	c3                   	ret    

008011c9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011cf:	8d 45 10             	lea    0x10(%ebp),%eax
  8011d2:	83 c0 04             	add    $0x4,%eax
  8011d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011db:	ff 75 f4             	pushl  -0xc(%ebp)
  8011de:	50                   	push   %eax
  8011df:	ff 75 0c             	pushl  0xc(%ebp)
  8011e2:	ff 75 08             	pushl  0x8(%ebp)
  8011e5:	e8 89 ff ff ff       	call   801173 <vsnprintf>
  8011ea:	83 c4 10             	add    $0x10,%esp
  8011ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011f3:	c9                   	leave  
  8011f4:	c3                   	ret    

008011f5 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8011fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ff:	74 13                	je     801214 <readline+0x1f>
		cprintf("%s", prompt);
  801201:	83 ec 08             	sub    $0x8,%esp
  801204:	ff 75 08             	pushl  0x8(%ebp)
  801207:	68 48 2c 80 00       	push   $0x802c48
  80120c:	e8 50 f9 ff ff       	call   800b61 <cprintf>
  801211:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801214:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80121b:	83 ec 0c             	sub    $0xc,%esp
  80121e:	6a 00                	push   $0x0
  801220:	e8 28 f5 ff ff       	call   80074d <iscons>
  801225:	83 c4 10             	add    $0x10,%esp
  801228:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80122b:	e8 0a f5 ff ff       	call   80073a <getchar>
  801230:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801233:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801237:	79 22                	jns    80125b <readline+0x66>
			if (c != -E_EOF)
  801239:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80123d:	0f 84 ad 00 00 00    	je     8012f0 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 ec             	pushl  -0x14(%ebp)
  801249:	68 4b 2c 80 00       	push   $0x802c4b
  80124e:	e8 0e f9 ff ff       	call   800b61 <cprintf>
  801253:	83 c4 10             	add    $0x10,%esp
			break;
  801256:	e9 95 00 00 00       	jmp    8012f0 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80125b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80125f:	7e 34                	jle    801295 <readline+0xa0>
  801261:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801268:	7f 2b                	jg     801295 <readline+0xa0>
			if (echoing)
  80126a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126e:	74 0e                	je     80127e <readline+0x89>
				cputchar(c);
  801270:	83 ec 0c             	sub    $0xc,%esp
  801273:	ff 75 ec             	pushl  -0x14(%ebp)
  801276:	e8 a0 f4 ff ff       	call   80071b <cputchar>
  80127b:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80127e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801281:	8d 50 01             	lea    0x1(%eax),%edx
  801284:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801287:	89 c2                	mov    %eax,%edx
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801291:	88 10                	mov    %dl,(%eax)
  801293:	eb 56                	jmp    8012eb <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801295:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801299:	75 1f                	jne    8012ba <readline+0xc5>
  80129b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80129f:	7e 19                	jle    8012ba <readline+0xc5>
			if (echoing)
  8012a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a5:	74 0e                	je     8012b5 <readline+0xc0>
				cputchar(c);
  8012a7:	83 ec 0c             	sub    $0xc,%esp
  8012aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ad:	e8 69 f4 ff ff       	call   80071b <cputchar>
  8012b2:	83 c4 10             	add    $0x10,%esp

			i--;
  8012b5:	ff 4d f4             	decl   -0xc(%ebp)
  8012b8:	eb 31                	jmp    8012eb <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012ba:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012be:	74 0a                	je     8012ca <readline+0xd5>
  8012c0:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012c4:	0f 85 61 ff ff ff    	jne    80122b <readline+0x36>
			if (echoing)
  8012ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ce:	74 0e                	je     8012de <readline+0xe9>
				cputchar(c);
  8012d0:	83 ec 0c             	sub    $0xc,%esp
  8012d3:	ff 75 ec             	pushl  -0x14(%ebp)
  8012d6:	e8 40 f4 ff ff       	call   80071b <cputchar>
  8012db:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e4:	01 d0                	add    %edx,%eax
  8012e6:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8012e9:	eb 06                	jmp    8012f1 <readline+0xfc>
		}
	}
  8012eb:	e9 3b ff ff ff       	jmp    80122b <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8012f0:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8012f1:	90                   	nop
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8012fa:	e8 9b 09 00 00       	call   801c9a <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801303:	74 13                	je     801318 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801305:	83 ec 08             	sub    $0x8,%esp
  801308:	ff 75 08             	pushl  0x8(%ebp)
  80130b:	68 48 2c 80 00       	push   $0x802c48
  801310:	e8 4c f8 ff ff       	call   800b61 <cprintf>
  801315:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801318:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  80131f:	83 ec 0c             	sub    $0xc,%esp
  801322:	6a 00                	push   $0x0
  801324:	e8 24 f4 ff ff       	call   80074d <iscons>
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  80132f:	e8 06 f4 ff ff       	call   80073a <getchar>
  801334:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801337:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80133b:	79 22                	jns    80135f <atomic_readline+0x6b>
				if (c != -E_EOF)
  80133d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801341:	0f 84 ad 00 00 00    	je     8013f4 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801347:	83 ec 08             	sub    $0x8,%esp
  80134a:	ff 75 ec             	pushl  -0x14(%ebp)
  80134d:	68 4b 2c 80 00       	push   $0x802c4b
  801352:	e8 0a f8 ff ff       	call   800b61 <cprintf>
  801357:	83 c4 10             	add    $0x10,%esp
				break;
  80135a:	e9 95 00 00 00       	jmp    8013f4 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  80135f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801363:	7e 34                	jle    801399 <atomic_readline+0xa5>
  801365:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80136c:	7f 2b                	jg     801399 <atomic_readline+0xa5>
				if (echoing)
  80136e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801372:	74 0e                	je     801382 <atomic_readline+0x8e>
					cputchar(c);
  801374:	83 ec 0c             	sub    $0xc,%esp
  801377:	ff 75 ec             	pushl  -0x14(%ebp)
  80137a:	e8 9c f3 ff ff       	call   80071b <cputchar>
  80137f:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801385:	8d 50 01             	lea    0x1(%eax),%edx
  801388:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80138b:	89 c2                	mov    %eax,%edx
  80138d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801390:	01 d0                	add    %edx,%eax
  801392:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801395:	88 10                	mov    %dl,(%eax)
  801397:	eb 56                	jmp    8013ef <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801399:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80139d:	75 1f                	jne    8013be <atomic_readline+0xca>
  80139f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013a3:	7e 19                	jle    8013be <atomic_readline+0xca>
				if (echoing)
  8013a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013a9:	74 0e                	je     8013b9 <atomic_readline+0xc5>
					cputchar(c);
  8013ab:	83 ec 0c             	sub    $0xc,%esp
  8013ae:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b1:	e8 65 f3 ff ff       	call   80071b <cputchar>
  8013b6:	83 c4 10             	add    $0x10,%esp
				i--;
  8013b9:	ff 4d f4             	decl   -0xc(%ebp)
  8013bc:	eb 31                	jmp    8013ef <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8013be:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013c2:	74 0a                	je     8013ce <atomic_readline+0xda>
  8013c4:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013c8:	0f 85 61 ff ff ff    	jne    80132f <atomic_readline+0x3b>
				if (echoing)
  8013ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013d2:	74 0e                	je     8013e2 <atomic_readline+0xee>
					cputchar(c);
  8013d4:	83 ec 0c             	sub    $0xc,%esp
  8013d7:	ff 75 ec             	pushl  -0x14(%ebp)
  8013da:	e8 3c f3 ff ff       	call   80071b <cputchar>
  8013df:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8013e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e8:	01 d0                	add    %edx,%eax
  8013ea:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8013ed:	eb 06                	jmp    8013f5 <atomic_readline+0x101>
			}
		}
  8013ef:	e9 3b ff ff ff       	jmp    80132f <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8013f4:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8013f5:	e8 ba 08 00 00       	call   801cb4 <sys_unlock_cons>
}
  8013fa:	90                   	nop
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801403:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80140a:	eb 06                	jmp    801412 <strlen+0x15>
		n++;
  80140c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80140f:	ff 45 08             	incl   0x8(%ebp)
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	84 c0                	test   %al,%al
  801419:	75 f1                	jne    80140c <strlen+0xf>
		n++;
	return n;
  80141b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801426:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80142d:	eb 09                	jmp    801438 <strnlen+0x18>
		n++;
  80142f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801432:	ff 45 08             	incl   0x8(%ebp)
  801435:	ff 4d 0c             	decl   0xc(%ebp)
  801438:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80143c:	74 09                	je     801447 <strnlen+0x27>
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	84 c0                	test   %al,%al
  801445:	75 e8                	jne    80142f <strnlen+0xf>
		n++;
	return n;
  801447:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801458:	90                   	nop
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8d 50 01             	lea    0x1(%eax),%edx
  80145f:	89 55 08             	mov    %edx,0x8(%ebp)
  801462:	8b 55 0c             	mov    0xc(%ebp),%edx
  801465:	8d 4a 01             	lea    0x1(%edx),%ecx
  801468:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80146b:	8a 12                	mov    (%edx),%dl
  80146d:	88 10                	mov    %dl,(%eax)
  80146f:	8a 00                	mov    (%eax),%al
  801471:	84 c0                	test   %al,%al
  801473:	75 e4                	jne    801459 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801475:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801478:	c9                   	leave  
  801479:	c3                   	ret    

0080147a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
  80147d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801486:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80148d:	eb 1f                	jmp    8014ae <strncpy+0x34>
		*dst++ = *src;
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8d 50 01             	lea    0x1(%eax),%edx
  801495:	89 55 08             	mov    %edx,0x8(%ebp)
  801498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149b:	8a 12                	mov    (%edx),%dl
  80149d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80149f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a2:	8a 00                	mov    (%eax),%al
  8014a4:	84 c0                	test   %al,%al
  8014a6:	74 03                	je     8014ab <strncpy+0x31>
			src++;
  8014a8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014ab:	ff 45 fc             	incl   -0x4(%ebp)
  8014ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014b4:	72 d9                	jb     80148f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014cb:	74 30                	je     8014fd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014cd:	eb 16                	jmp    8014e5 <strlcpy+0x2a>
			*dst++ = *src++;
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014de:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014e1:	8a 12                	mov    (%edx),%dl
  8014e3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014e5:	ff 4d 10             	decl   0x10(%ebp)
  8014e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ec:	74 09                	je     8014f7 <strlcpy+0x3c>
  8014ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f1:	8a 00                	mov    (%eax),%al
  8014f3:	84 c0                	test   %al,%al
  8014f5:	75 d8                	jne    8014cf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801500:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801503:	29 c2                	sub    %eax,%edx
  801505:	89 d0                	mov    %edx,%eax
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80150c:	eb 06                	jmp    801514 <strcmp+0xb>
		p++, q++;
  80150e:	ff 45 08             	incl   0x8(%ebp)
  801511:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	84 c0                	test   %al,%al
  80151b:	74 0e                	je     80152b <strcmp+0x22>
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 10                	mov    (%eax),%dl
  801522:	8b 45 0c             	mov    0xc(%ebp),%eax
  801525:	8a 00                	mov    (%eax),%al
  801527:	38 c2                	cmp    %al,%dl
  801529:	74 e3                	je     80150e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	0f b6 d0             	movzbl %al,%edx
  801533:	8b 45 0c             	mov    0xc(%ebp),%eax
  801536:	8a 00                	mov    (%eax),%al
  801538:	0f b6 c0             	movzbl %al,%eax
  80153b:	29 c2                	sub    %eax,%edx
  80153d:	89 d0                	mov    %edx,%eax
}
  80153f:	5d                   	pop    %ebp
  801540:	c3                   	ret    

00801541 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801544:	eb 09                	jmp    80154f <strncmp+0xe>
		n--, p++, q++;
  801546:	ff 4d 10             	decl   0x10(%ebp)
  801549:	ff 45 08             	incl   0x8(%ebp)
  80154c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80154f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801553:	74 17                	je     80156c <strncmp+0x2b>
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	84 c0                	test   %al,%al
  80155c:	74 0e                	je     80156c <strncmp+0x2b>
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	8a 10                	mov    (%eax),%dl
  801563:	8b 45 0c             	mov    0xc(%ebp),%eax
  801566:	8a 00                	mov    (%eax),%al
  801568:	38 c2                	cmp    %al,%dl
  80156a:	74 da                	je     801546 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80156c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801570:	75 07                	jne    801579 <strncmp+0x38>
		return 0;
  801572:	b8 00 00 00 00       	mov    $0x0,%eax
  801577:	eb 14                	jmp    80158d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	0f b6 d0             	movzbl %al,%edx
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	8a 00                	mov    (%eax),%al
  801586:	0f b6 c0             	movzbl %al,%eax
  801589:	29 c2                	sub    %eax,%edx
  80158b:	89 d0                	mov    %edx,%eax
}
  80158d:	5d                   	pop    %ebp
  80158e:	c3                   	ret    

0080158f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	83 ec 04             	sub    $0x4,%esp
  801595:	8b 45 0c             	mov    0xc(%ebp),%eax
  801598:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80159b:	eb 12                	jmp    8015af <strchr+0x20>
		if (*s == c)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015a5:	75 05                	jne    8015ac <strchr+0x1d>
			return (char *) s;
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	eb 11                	jmp    8015bd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015ac:	ff 45 08             	incl   0x8(%ebp)
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	8a 00                	mov    (%eax),%al
  8015b4:	84 c0                	test   %al,%al
  8015b6:	75 e5                	jne    80159d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	83 ec 04             	sub    $0x4,%esp
  8015c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015cb:	eb 0d                	jmp    8015da <strfind+0x1b>
		if (*s == c)
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015d5:	74 0e                	je     8015e5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015d7:	ff 45 08             	incl   0x8(%ebp)
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	8a 00                	mov    (%eax),%al
  8015df:	84 c0                	test   %al,%al
  8015e1:	75 ea                	jne    8015cd <strfind+0xe>
  8015e3:	eb 01                	jmp    8015e6 <strfind+0x27>
		if (*s == c)
			break;
  8015e5:	90                   	nop
	return (char *) s;
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015fd:	eb 0e                	jmp    80160d <memset+0x22>
		*p++ = c;
  8015ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801602:	8d 50 01             	lea    0x1(%eax),%edx
  801605:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801608:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80160d:	ff 4d f8             	decl   -0x8(%ebp)
  801610:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801614:	79 e9                	jns    8015ff <memset+0x14>
		*p++ = c;

	return v;
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801621:	8b 45 0c             	mov    0xc(%ebp),%eax
  801624:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80162d:	eb 16                	jmp    801645 <memcpy+0x2a>
		*d++ = *s++;
  80162f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801632:	8d 50 01             	lea    0x1(%eax),%edx
  801635:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801638:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80163e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801641:	8a 12                	mov    (%edx),%dl
  801643:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801645:	8b 45 10             	mov    0x10(%ebp),%eax
  801648:	8d 50 ff             	lea    -0x1(%eax),%edx
  80164b:	89 55 10             	mov    %edx,0x10(%ebp)
  80164e:	85 c0                	test   %eax,%eax
  801650:	75 dd                	jne    80162f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80165d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801660:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801669:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80166f:	73 50                	jae    8016c1 <memmove+0x6a>
  801671:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801674:	8b 45 10             	mov    0x10(%ebp),%eax
  801677:	01 d0                	add    %edx,%eax
  801679:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80167c:	76 43                	jbe    8016c1 <memmove+0x6a>
		s += n;
  80167e:	8b 45 10             	mov    0x10(%ebp),%eax
  801681:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801684:	8b 45 10             	mov    0x10(%ebp),%eax
  801687:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80168a:	eb 10                	jmp    80169c <memmove+0x45>
			*--d = *--s;
  80168c:	ff 4d f8             	decl   -0x8(%ebp)
  80168f:	ff 4d fc             	decl   -0x4(%ebp)
  801692:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801695:	8a 10                	mov    (%eax),%dl
  801697:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80169c:	8b 45 10             	mov    0x10(%ebp),%eax
  80169f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	75 e3                	jne    80168c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016a9:	eb 23                	jmp    8016ce <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ae:	8d 50 01             	lea    0x1(%eax),%edx
  8016b1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016ba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016bd:	8a 12                	mov    (%edx),%dl
  8016bf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016c7:	89 55 10             	mov    %edx,0x10(%ebp)
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	75 dd                	jne    8016ab <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016e5:	eb 2a                	jmp    801711 <memcmp+0x3e>
		if (*s1 != *s2)
  8016e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ea:	8a 10                	mov    (%eax),%dl
  8016ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ef:	8a 00                	mov    (%eax),%al
  8016f1:	38 c2                	cmp    %al,%dl
  8016f3:	74 16                	je     80170b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f8:	8a 00                	mov    (%eax),%al
  8016fa:	0f b6 d0             	movzbl %al,%edx
  8016fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	0f b6 c0             	movzbl %al,%eax
  801705:	29 c2                	sub    %eax,%edx
  801707:	89 d0                	mov    %edx,%eax
  801709:	eb 18                	jmp    801723 <memcmp+0x50>
		s1++, s2++;
  80170b:	ff 45 fc             	incl   -0x4(%ebp)
  80170e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801711:	8b 45 10             	mov    0x10(%ebp),%eax
  801714:	8d 50 ff             	lea    -0x1(%eax),%edx
  801717:	89 55 10             	mov    %edx,0x10(%ebp)
  80171a:	85 c0                	test   %eax,%eax
  80171c:	75 c9                	jne    8016e7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80171e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80172b:	8b 55 08             	mov    0x8(%ebp),%edx
  80172e:	8b 45 10             	mov    0x10(%ebp),%eax
  801731:	01 d0                	add    %edx,%eax
  801733:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801736:	eb 15                	jmp    80174d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	0f b6 d0             	movzbl %al,%edx
  801740:	8b 45 0c             	mov    0xc(%ebp),%eax
  801743:	0f b6 c0             	movzbl %al,%eax
  801746:	39 c2                	cmp    %eax,%edx
  801748:	74 0d                	je     801757 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80174a:	ff 45 08             	incl   0x8(%ebp)
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801753:	72 e3                	jb     801738 <memfind+0x13>
  801755:	eb 01                	jmp    801758 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801757:	90                   	nop
	return (void *) s;
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801763:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80176a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801771:	eb 03                	jmp    801776 <strtol+0x19>
		s++;
  801773:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8a 00                	mov    (%eax),%al
  80177b:	3c 20                	cmp    $0x20,%al
  80177d:	74 f4                	je     801773 <strtol+0x16>
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8a 00                	mov    (%eax),%al
  801784:	3c 09                	cmp    $0x9,%al
  801786:	74 eb                	je     801773 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8a 00                	mov    (%eax),%al
  80178d:	3c 2b                	cmp    $0x2b,%al
  80178f:	75 05                	jne    801796 <strtol+0x39>
		s++;
  801791:	ff 45 08             	incl   0x8(%ebp)
  801794:	eb 13                	jmp    8017a9 <strtol+0x4c>
	else if (*s == '-')
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8a 00                	mov    (%eax),%al
  80179b:	3c 2d                	cmp    $0x2d,%al
  80179d:	75 0a                	jne    8017a9 <strtol+0x4c>
		s++, neg = 1;
  80179f:	ff 45 08             	incl   0x8(%ebp)
  8017a2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ad:	74 06                	je     8017b5 <strtol+0x58>
  8017af:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017b3:	75 20                	jne    8017d5 <strtol+0x78>
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	3c 30                	cmp    $0x30,%al
  8017bc:	75 17                	jne    8017d5 <strtol+0x78>
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	40                   	inc    %eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	3c 78                	cmp    $0x78,%al
  8017c6:	75 0d                	jne    8017d5 <strtol+0x78>
		s += 2, base = 16;
  8017c8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017cc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017d3:	eb 28                	jmp    8017fd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d9:	75 15                	jne    8017f0 <strtol+0x93>
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	8a 00                	mov    (%eax),%al
  8017e0:	3c 30                	cmp    $0x30,%al
  8017e2:	75 0c                	jne    8017f0 <strtol+0x93>
		s++, base = 8;
  8017e4:	ff 45 08             	incl   0x8(%ebp)
  8017e7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017ee:	eb 0d                	jmp    8017fd <strtol+0xa0>
	else if (base == 0)
  8017f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f4:	75 07                	jne    8017fd <strtol+0xa0>
		base = 10;
  8017f6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8a 00                	mov    (%eax),%al
  801802:	3c 2f                	cmp    $0x2f,%al
  801804:	7e 19                	jle    80181f <strtol+0xc2>
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	8a 00                	mov    (%eax),%al
  80180b:	3c 39                	cmp    $0x39,%al
  80180d:	7f 10                	jg     80181f <strtol+0xc2>
			dig = *s - '0';
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	8a 00                	mov    (%eax),%al
  801814:	0f be c0             	movsbl %al,%eax
  801817:	83 e8 30             	sub    $0x30,%eax
  80181a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80181d:	eb 42                	jmp    801861 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	3c 60                	cmp    $0x60,%al
  801826:	7e 19                	jle    801841 <strtol+0xe4>
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	8a 00                	mov    (%eax),%al
  80182d:	3c 7a                	cmp    $0x7a,%al
  80182f:	7f 10                	jg     801841 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	8a 00                	mov    (%eax),%al
  801836:	0f be c0             	movsbl %al,%eax
  801839:	83 e8 57             	sub    $0x57,%eax
  80183c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80183f:	eb 20                	jmp    801861 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	3c 40                	cmp    $0x40,%al
  801848:	7e 39                	jle    801883 <strtol+0x126>
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	8a 00                	mov    (%eax),%al
  80184f:	3c 5a                	cmp    $0x5a,%al
  801851:	7f 30                	jg     801883 <strtol+0x126>
			dig = *s - 'A' + 10;
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	8a 00                	mov    (%eax),%al
  801858:	0f be c0             	movsbl %al,%eax
  80185b:	83 e8 37             	sub    $0x37,%eax
  80185e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801864:	3b 45 10             	cmp    0x10(%ebp),%eax
  801867:	7d 19                	jge    801882 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801869:	ff 45 08             	incl   0x8(%ebp)
  80186c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801873:	89 c2                	mov    %eax,%edx
  801875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801878:	01 d0                	add    %edx,%eax
  80187a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80187d:	e9 7b ff ff ff       	jmp    8017fd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801882:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801883:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801887:	74 08                	je     801891 <strtol+0x134>
		*endptr = (char *) s;
  801889:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188c:	8b 55 08             	mov    0x8(%ebp),%edx
  80188f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801891:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801895:	74 07                	je     80189e <strtol+0x141>
  801897:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189a:	f7 d8                	neg    %eax
  80189c:	eb 03                	jmp    8018a1 <strtol+0x144>
  80189e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <ltostr>:

void
ltostr(long value, char *str)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018bb:	79 13                	jns    8018d0 <ltostr+0x2d>
	{
		neg = 1;
  8018bd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018ca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018cd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018d8:	99                   	cltd   
  8018d9:	f7 f9                	idiv   %ecx
  8018db:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e1:	8d 50 01             	lea    0x1(%eax),%edx
  8018e4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018e7:	89 c2                	mov    %eax,%edx
  8018e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ec:	01 d0                	add    %edx,%eax
  8018ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018f1:	83 c2 30             	add    $0x30,%edx
  8018f4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018fe:	f7 e9                	imul   %ecx
  801900:	c1 fa 02             	sar    $0x2,%edx
  801903:	89 c8                	mov    %ecx,%eax
  801905:	c1 f8 1f             	sar    $0x1f,%eax
  801908:	29 c2                	sub    %eax,%edx
  80190a:	89 d0                	mov    %edx,%eax
  80190c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80190f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801913:	75 bb                	jne    8018d0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801915:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80191c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191f:	48                   	dec    %eax
  801920:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801923:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801927:	74 3d                	je     801966 <ltostr+0xc3>
		start = 1 ;
  801929:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801930:	eb 34                	jmp    801966 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801932:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801935:	8b 45 0c             	mov    0xc(%ebp),%eax
  801938:	01 d0                	add    %edx,%eax
  80193a:	8a 00                	mov    (%eax),%al
  80193c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80193f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801942:	8b 45 0c             	mov    0xc(%ebp),%eax
  801945:	01 c2                	add    %eax,%edx
  801947:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80194a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194d:	01 c8                	add    %ecx,%eax
  80194f:	8a 00                	mov    (%eax),%al
  801951:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801953:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801956:	8b 45 0c             	mov    0xc(%ebp),%eax
  801959:	01 c2                	add    %eax,%edx
  80195b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80195e:	88 02                	mov    %al,(%edx)
		start++ ;
  801960:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801963:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801969:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80196c:	7c c4                	jl     801932 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80196e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801971:	8b 45 0c             	mov    0xc(%ebp),%eax
  801974:	01 d0                	add    %edx,%eax
  801976:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801979:	90                   	nop
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801982:	ff 75 08             	pushl  0x8(%ebp)
  801985:	e8 73 fa ff ff       	call   8013fd <strlen>
  80198a:	83 c4 04             	add    $0x4,%esp
  80198d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801990:	ff 75 0c             	pushl  0xc(%ebp)
  801993:	e8 65 fa ff ff       	call   8013fd <strlen>
  801998:	83 c4 04             	add    $0x4,%esp
  80199b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80199e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019ac:	eb 17                	jmp    8019c5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b4:	01 c2                	add    %eax,%edx
  8019b6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	01 c8                	add    %ecx,%eax
  8019be:	8a 00                	mov    (%eax),%al
  8019c0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019c2:	ff 45 fc             	incl   -0x4(%ebp)
  8019c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019cb:	7c e1                	jl     8019ae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019db:	eb 1f                	jmp    8019fc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019e0:	8d 50 01             	lea    0x1(%eax),%edx
  8019e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019e6:	89 c2                	mov    %eax,%edx
  8019e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019eb:	01 c2                	add    %eax,%edx
  8019ed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f3:	01 c8                	add    %ecx,%eax
  8019f5:	8a 00                	mov    (%eax),%al
  8019f7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019f9:	ff 45 f8             	incl   -0x8(%ebp)
  8019fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a02:	7c d9                	jl     8019dd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a07:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0a:	01 d0                	add    %edx,%eax
  801a0c:	c6 00 00             	movb   $0x0,(%eax)
}
  801a0f:	90                   	nop
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a15:	8b 45 14             	mov    0x14(%ebp),%eax
  801a18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a21:	8b 00                	mov    (%eax),%eax
  801a23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2d:	01 d0                	add    %edx,%eax
  801a2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a35:	eb 0c                	jmp    801a43 <strsplit+0x31>
			*string++ = 0;
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	8d 50 01             	lea    0x1(%eax),%edx
  801a3d:	89 55 08             	mov    %edx,0x8(%ebp)
  801a40:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	8a 00                	mov    (%eax),%al
  801a48:	84 c0                	test   %al,%al
  801a4a:	74 18                	je     801a64 <strsplit+0x52>
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	8a 00                	mov    (%eax),%al
  801a51:	0f be c0             	movsbl %al,%eax
  801a54:	50                   	push   %eax
  801a55:	ff 75 0c             	pushl  0xc(%ebp)
  801a58:	e8 32 fb ff ff       	call   80158f <strchr>
  801a5d:	83 c4 08             	add    $0x8,%esp
  801a60:	85 c0                	test   %eax,%eax
  801a62:	75 d3                	jne    801a37 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8a 00                	mov    (%eax),%al
  801a69:	84 c0                	test   %al,%al
  801a6b:	74 5a                	je     801ac7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a70:	8b 00                	mov    (%eax),%eax
  801a72:	83 f8 0f             	cmp    $0xf,%eax
  801a75:	75 07                	jne    801a7e <strsplit+0x6c>
		{
			return 0;
  801a77:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7c:	eb 66                	jmp    801ae4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a81:	8b 00                	mov    (%eax),%eax
  801a83:	8d 48 01             	lea    0x1(%eax),%ecx
  801a86:	8b 55 14             	mov    0x14(%ebp),%edx
  801a89:	89 0a                	mov    %ecx,(%edx)
  801a8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a92:	8b 45 10             	mov    0x10(%ebp),%eax
  801a95:	01 c2                	add    %eax,%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a9c:	eb 03                	jmp    801aa1 <strsplit+0x8f>
			string++;
  801a9e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	8a 00                	mov    (%eax),%al
  801aa6:	84 c0                	test   %al,%al
  801aa8:	74 8b                	je     801a35 <strsplit+0x23>
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	8a 00                	mov    (%eax),%al
  801aaf:	0f be c0             	movsbl %al,%eax
  801ab2:	50                   	push   %eax
  801ab3:	ff 75 0c             	pushl  0xc(%ebp)
  801ab6:	e8 d4 fa ff ff       	call   80158f <strchr>
  801abb:	83 c4 08             	add    $0x8,%esp
  801abe:	85 c0                	test   %eax,%eax
  801ac0:	74 dc                	je     801a9e <strsplit+0x8c>
			string++;
	}
  801ac2:	e9 6e ff ff ff       	jmp    801a35 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ac7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ac8:	8b 45 14             	mov    0x14(%ebp),%eax
  801acb:	8b 00                	mov    (%eax),%eax
  801acd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad7:	01 d0                	add    %edx,%eax
  801ad9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801adf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801aec:	83 ec 04             	sub    $0x4,%esp
  801aef:	68 5c 2c 80 00       	push   $0x802c5c
  801af4:	68 3f 01 00 00       	push   $0x13f
  801af9:	68 7e 2c 80 00       	push   $0x802c7e
  801afe:	e8 a1 ed ff ff       	call   8008a4 <_panic>

00801b03 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801b09:	83 ec 0c             	sub    $0xc,%esp
  801b0c:	ff 75 08             	pushl  0x8(%ebp)
  801b0f:	e8 ef 06 00 00       	call   802203 <sys_sbrk>
  801b14:	83 c4 10             	add    $0x10,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b23:	75 07                	jne    801b2c <malloc+0x13>
  801b25:	b8 00 00 00 00       	mov    $0x0,%eax
  801b2a:	eb 14                	jmp    801b40 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801b2c:	83 ec 04             	sub    $0x4,%esp
  801b2f:	68 8c 2c 80 00       	push   $0x802c8c
  801b34:	6a 1b                	push   $0x1b
  801b36:	68 b1 2c 80 00       	push   $0x802cb1
  801b3b:	e8 64 ed ff ff       	call   8008a4 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801b48:	83 ec 04             	sub    $0x4,%esp
  801b4b:	68 c0 2c 80 00       	push   $0x802cc0
  801b50:	6a 29                	push   $0x29
  801b52:	68 b1 2c 80 00       	push   $0x802cb1
  801b57:	e8 48 ed ff ff       	call   8008a4 <_panic>

00801b5c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	83 ec 18             	sub    $0x18,%esp
  801b62:	8b 45 10             	mov    0x10(%ebp),%eax
  801b65:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b6c:	75 07                	jne    801b75 <smalloc+0x19>
  801b6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b73:	eb 14                	jmp    801b89 <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801b75:	83 ec 04             	sub    $0x4,%esp
  801b78:	68 e4 2c 80 00       	push   $0x802ce4
  801b7d:	6a 38                	push   $0x38
  801b7f:	68 b1 2c 80 00       	push   $0x802cb1
  801b84:	e8 1b ed ff ff       	call   8008a4 <_panic>
	return NULL;
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801b91:	83 ec 04             	sub    $0x4,%esp
  801b94:	68 0c 2d 80 00       	push   $0x802d0c
  801b99:	6a 43                	push   $0x43
  801b9b:	68 b1 2c 80 00       	push   $0x802cb1
  801ba0:	e8 ff ec ff ff       	call   8008a4 <_panic>

00801ba5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bab:	83 ec 04             	sub    $0x4,%esp
  801bae:	68 30 2d 80 00       	push   $0x802d30
  801bb3:	6a 5b                	push   $0x5b
  801bb5:	68 b1 2c 80 00       	push   $0x802cb1
  801bba:	e8 e5 ec ff ff       	call   8008a4 <_panic>

00801bbf <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bc5:	83 ec 04             	sub    $0x4,%esp
  801bc8:	68 54 2d 80 00       	push   $0x802d54
  801bcd:	6a 72                	push   $0x72
  801bcf:	68 b1 2c 80 00       	push   $0x802cb1
  801bd4:	e8 cb ec ff ff       	call   8008a4 <_panic>

00801bd9 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bdf:	83 ec 04             	sub    $0x4,%esp
  801be2:	68 7a 2d 80 00       	push   $0x802d7a
  801be7:	6a 7e                	push   $0x7e
  801be9:	68 b1 2c 80 00       	push   $0x802cb1
  801bee:	e8 b1 ec ff ff       	call   8008a4 <_panic>

00801bf3 <shrink>:

}
void shrink(uint32 newSize)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bf9:	83 ec 04             	sub    $0x4,%esp
  801bfc:	68 7a 2d 80 00       	push   $0x802d7a
  801c01:	68 83 00 00 00       	push   $0x83
  801c06:	68 b1 2c 80 00       	push   $0x802cb1
  801c0b:	e8 94 ec ff ff       	call   8008a4 <_panic>

00801c10 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c16:	83 ec 04             	sub    $0x4,%esp
  801c19:	68 7a 2d 80 00       	push   $0x802d7a
  801c1e:	68 88 00 00 00       	push   $0x88
  801c23:	68 b1 2c 80 00       	push   $0x802cb1
  801c28:	e8 77 ec ff ff       	call   8008a4 <_panic>

00801c2d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	57                   	push   %edi
  801c31:	56                   	push   %esi
  801c32:	53                   	push   %ebx
  801c33:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c3f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c42:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c45:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c48:	cd 30                	int    $0x30
  801c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c50:	83 c4 10             	add    $0x10,%esp
  801c53:	5b                   	pop    %ebx
  801c54:	5e                   	pop    %esi
  801c55:	5f                   	pop    %edi
  801c56:	5d                   	pop    %ebp
  801c57:	c3                   	ret    

00801c58 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	83 ec 04             	sub    $0x4,%esp
  801c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c61:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c64:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	52                   	push   %edx
  801c70:	ff 75 0c             	pushl  0xc(%ebp)
  801c73:	50                   	push   %eax
  801c74:	6a 00                	push   $0x0
  801c76:	e8 b2 ff ff ff       	call   801c2d <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	90                   	nop
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 02                	push   $0x2
  801c90:	e8 98 ff ff ff       	call   801c2d <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_lock_cons>:

void sys_lock_cons(void)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 03                	push   $0x3
  801ca9:	e8 7f ff ff ff       	call   801c2d <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
}
  801cb1:	90                   	nop
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 04                	push   $0x4
  801cc3:	e8 65 ff ff ff       	call   801c2d <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
}
  801ccb:	90                   	nop
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	52                   	push   %edx
  801cde:	50                   	push   %eax
  801cdf:	6a 08                	push   $0x8
  801ce1:	e8 47 ff ff ff       	call   801c2d <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	56                   	push   %esi
  801cef:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cf0:	8b 75 18             	mov    0x18(%ebp),%esi
  801cf3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	56                   	push   %esi
  801d00:	53                   	push   %ebx
  801d01:	51                   	push   %ecx
  801d02:	52                   	push   %edx
  801d03:	50                   	push   %eax
  801d04:	6a 09                	push   $0x9
  801d06:	e8 22 ff ff ff       	call   801c2d <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d11:	5b                   	pop    %ebx
  801d12:	5e                   	pop    %esi
  801d13:	5d                   	pop    %ebp
  801d14:	c3                   	ret    

00801d15 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	52                   	push   %edx
  801d25:	50                   	push   %eax
  801d26:	6a 0a                	push   $0xa
  801d28:	e8 00 ff ff ff       	call   801c2d <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	ff 75 0c             	pushl  0xc(%ebp)
  801d3e:	ff 75 08             	pushl  0x8(%ebp)
  801d41:	6a 0b                	push   $0xb
  801d43:	e8 e5 fe ff ff       	call   801c2d <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 0c                	push   $0xc
  801d5c:	e8 cc fe ff ff       	call   801c2d <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 0d                	push   $0xd
  801d75:	e8 b3 fe ff ff       	call   801c2d <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 0e                	push   $0xe
  801d8e:	e8 9a fe ff ff       	call   801c2d <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 0f                	push   $0xf
  801da7:	e8 81 fe ff ff       	call   801c2d <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	ff 75 08             	pushl  0x8(%ebp)
  801dbf:	6a 10                	push   $0x10
  801dc1:	e8 67 fe ff ff       	call   801c2d <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_scarce_memory>:

void sys_scarce_memory()
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 11                	push   $0x11
  801dda:	e8 4e fe ff ff       	call   801c2d <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	90                   	nop
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_cputc>:

void
sys_cputc(const char c)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 04             	sub    $0x4,%esp
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801df1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	50                   	push   %eax
  801dfe:	6a 01                	push   $0x1
  801e00:	e8 28 fe ff ff       	call   801c2d <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
}
  801e08:	90                   	nop
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 14                	push   $0x14
  801e1a:	e8 0e fe ff ff       	call   801c2d <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	90                   	nop
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 04             	sub    $0x4,%esp
  801e2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e31:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e34:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	6a 00                	push   $0x0
  801e3d:	51                   	push   %ecx
  801e3e:	52                   	push   %edx
  801e3f:	ff 75 0c             	pushl  0xc(%ebp)
  801e42:	50                   	push   %eax
  801e43:	6a 15                	push   $0x15
  801e45:	e8 e3 fd ff ff       	call   801c2d <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	52                   	push   %edx
  801e5f:	50                   	push   %eax
  801e60:	6a 16                	push   $0x16
  801e62:	e8 c6 fd ff ff       	call   801c2d <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	51                   	push   %ecx
  801e7d:	52                   	push   %edx
  801e7e:	50                   	push   %eax
  801e7f:	6a 17                	push   $0x17
  801e81:	e8 a7 fd ff ff       	call   801c2d <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	52                   	push   %edx
  801e9b:	50                   	push   %eax
  801e9c:	6a 18                	push   $0x18
  801e9e:	e8 8a fd ff ff       	call   801c2d <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	6a 00                	push   $0x0
  801eb0:	ff 75 14             	pushl  0x14(%ebp)
  801eb3:	ff 75 10             	pushl  0x10(%ebp)
  801eb6:	ff 75 0c             	pushl  0xc(%ebp)
  801eb9:	50                   	push   %eax
  801eba:	6a 19                	push   $0x19
  801ebc:	e8 6c fd ff ff       	call   801c2d <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	50                   	push   %eax
  801ed5:	6a 1a                	push   $0x1a
  801ed7:	e8 51 fd ff ff       	call   801c2d <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	90                   	nop
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	50                   	push   %eax
  801ef1:	6a 1b                	push   $0x1b
  801ef3:	e8 35 fd ff ff       	call   801c2d <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <sys_getenvid>:

int32 sys_getenvid(void)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 05                	push   $0x5
  801f0c:	e8 1c fd ff ff       	call   801c2d <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 06                	push   $0x6
  801f25:	e8 03 fd ff ff       	call   801c2d <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
}
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 07                	push   $0x7
  801f3e:	e8 ea fc ff ff       	call   801c2d <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <sys_exit_env>:


void sys_exit_env(void)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 1c                	push   $0x1c
  801f57:	e8 d1 fc ff ff       	call   801c2d <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
}
  801f5f:	90                   	nop
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f68:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f6b:	8d 50 04             	lea    0x4(%eax),%edx
  801f6e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	52                   	push   %edx
  801f78:	50                   	push   %eax
  801f79:	6a 1d                	push   $0x1d
  801f7b:	e8 ad fc ff ff       	call   801c2d <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
	return result;
  801f83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f89:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f8c:	89 01                	mov    %eax,(%ecx)
  801f8e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	c9                   	leave  
  801f95:	c2 04 00             	ret    $0x4

00801f98 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	ff 75 10             	pushl  0x10(%ebp)
  801fa2:	ff 75 0c             	pushl  0xc(%ebp)
  801fa5:	ff 75 08             	pushl  0x8(%ebp)
  801fa8:	6a 13                	push   $0x13
  801faa:	e8 7e fc ff ff       	call   801c2d <syscall>
  801faf:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb2:	90                   	nop
}
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 1e                	push   $0x1e
  801fc4:	e8 64 fc ff ff       	call   801c2d <syscall>
  801fc9:	83 c4 18             	add    $0x18,%esp
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 04             	sub    $0x4,%esp
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fda:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	50                   	push   %eax
  801fe7:	6a 1f                	push   $0x1f
  801fe9:	e8 3f fc ff ff       	call   801c2d <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff1:	90                   	nop
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <rsttst>:
void rsttst()
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 21                	push   $0x21
  802003:	e8 25 fc ff ff       	call   801c2d <syscall>
  802008:	83 c4 18             	add    $0x18,%esp
	return ;
  80200b:	90                   	nop
}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 04             	sub    $0x4,%esp
  802014:	8b 45 14             	mov    0x14(%ebp),%eax
  802017:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80201a:	8b 55 18             	mov    0x18(%ebp),%edx
  80201d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802021:	52                   	push   %edx
  802022:	50                   	push   %eax
  802023:	ff 75 10             	pushl  0x10(%ebp)
  802026:	ff 75 0c             	pushl  0xc(%ebp)
  802029:	ff 75 08             	pushl  0x8(%ebp)
  80202c:	6a 20                	push   $0x20
  80202e:	e8 fa fb ff ff       	call   801c2d <syscall>
  802033:	83 c4 18             	add    $0x18,%esp
	return ;
  802036:	90                   	nop
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <chktst>:
void chktst(uint32 n)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	ff 75 08             	pushl  0x8(%ebp)
  802047:	6a 22                	push   $0x22
  802049:	e8 df fb ff ff       	call   801c2d <syscall>
  80204e:	83 c4 18             	add    $0x18,%esp
	return ;
  802051:	90                   	nop
}
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <inctst>:

void inctst()
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 23                	push   $0x23
  802063:	e8 c5 fb ff ff       	call   801c2d <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
	return ;
  80206b:	90                   	nop
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <gettst>:
uint32 gettst()
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 24                	push   $0x24
  80207d:	e8 ab fb ff ff       	call   801c2d <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 25                	push   $0x25
  802099:	e8 8f fb ff ff       	call   801c2d <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
  8020a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020a4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020a8:	75 07                	jne    8020b1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8020af:	eb 05                	jmp    8020b6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
  8020bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 25                	push   $0x25
  8020ca:	e8 5e fb ff ff       	call   801c2d <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
  8020d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020d5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020d9:	75 07                	jne    8020e2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020db:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e0:	eb 05                	jmp    8020e7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 25                	push   $0x25
  8020fb:	e8 2d fb ff ff       	call   801c2d <syscall>
  802100:	83 c4 18             	add    $0x18,%esp
  802103:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802106:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80210a:	75 07                	jne    802113 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80210c:	b8 01 00 00 00       	mov    $0x1,%eax
  802111:	eb 05                	jmp    802118 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802113:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 25                	push   $0x25
  80212c:	e8 fc fa ff ff       	call   801c2d <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
  802134:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802137:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80213b:	75 07                	jne    802144 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80213d:	b8 01 00 00 00       	mov    $0x1,%eax
  802142:	eb 05                	jmp    802149 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802144:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	ff 75 08             	pushl  0x8(%ebp)
  802159:	6a 26                	push   $0x26
  80215b:	e8 cd fa ff ff       	call   801c2d <syscall>
  802160:	83 c4 18             	add    $0x18,%esp
	return ;
  802163:	90                   	nop
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80216a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80216d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802170:	8b 55 0c             	mov    0xc(%ebp),%edx
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	6a 00                	push   $0x0
  802178:	53                   	push   %ebx
  802179:	51                   	push   %ecx
  80217a:	52                   	push   %edx
  80217b:	50                   	push   %eax
  80217c:	6a 27                	push   $0x27
  80217e:	e8 aa fa ff ff       	call   801c2d <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
}
  802186:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80218e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	52                   	push   %edx
  80219b:	50                   	push   %eax
  80219c:	6a 28                	push   $0x28
  80219e:	e8 8a fa ff ff       	call   801c2d <syscall>
  8021a3:	83 c4 18             	add    $0x18,%esp
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8021ab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	6a 00                	push   $0x0
  8021b6:	51                   	push   %ecx
  8021b7:	ff 75 10             	pushl  0x10(%ebp)
  8021ba:	52                   	push   %edx
  8021bb:	50                   	push   %eax
  8021bc:	6a 29                	push   $0x29
  8021be:	e8 6a fa ff ff       	call   801c2d <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	ff 75 10             	pushl  0x10(%ebp)
  8021d2:	ff 75 0c             	pushl  0xc(%ebp)
  8021d5:	ff 75 08             	pushl  0x8(%ebp)
  8021d8:	6a 12                	push   $0x12
  8021da:	e8 4e fa ff ff       	call   801c2d <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e2:	90                   	nop
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8021e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	52                   	push   %edx
  8021f5:	50                   	push   %eax
  8021f6:	6a 2a                	push   $0x2a
  8021f8:	e8 30 fa ff ff       	call   801c2d <syscall>
  8021fd:	83 c4 18             	add    $0x18,%esp
	return;
  802200:	90                   	nop
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802209:	83 ec 04             	sub    $0x4,%esp
  80220c:	68 8a 2d 80 00       	push   $0x802d8a
  802211:	68 2e 01 00 00       	push   $0x12e
  802216:	68 9e 2d 80 00       	push   $0x802d9e
  80221b:	e8 84 e6 ff ff       	call   8008a4 <_panic>

00802220 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
  802223:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802226:	83 ec 04             	sub    $0x4,%esp
  802229:	68 8a 2d 80 00       	push   $0x802d8a
  80222e:	68 35 01 00 00       	push   $0x135
  802233:	68 9e 2d 80 00       	push   $0x802d9e
  802238:	e8 67 e6 ff ff       	call   8008a4 <_panic>

0080223d <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802243:	83 ec 04             	sub    $0x4,%esp
  802246:	68 8a 2d 80 00       	push   $0x802d8a
  80224b:	68 3b 01 00 00       	push   $0x13b
  802250:	68 9e 2d 80 00       	push   $0x802d9e
  802255:	e8 4a e6 ff ff       	call   8008a4 <_panic>
  80225a:	66 90                	xchg   %ax,%ax

0080225c <__udivdi3>:
  80225c:	55                   	push   %ebp
  80225d:	57                   	push   %edi
  80225e:	56                   	push   %esi
  80225f:	53                   	push   %ebx
  802260:	83 ec 1c             	sub    $0x1c,%esp
  802263:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802267:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80226b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80226f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802273:	89 ca                	mov    %ecx,%edx
  802275:	89 f8                	mov    %edi,%eax
  802277:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80227b:	85 f6                	test   %esi,%esi
  80227d:	75 2d                	jne    8022ac <__udivdi3+0x50>
  80227f:	39 cf                	cmp    %ecx,%edi
  802281:	77 65                	ja     8022e8 <__udivdi3+0x8c>
  802283:	89 fd                	mov    %edi,%ebp
  802285:	85 ff                	test   %edi,%edi
  802287:	75 0b                	jne    802294 <__udivdi3+0x38>
  802289:	b8 01 00 00 00       	mov    $0x1,%eax
  80228e:	31 d2                	xor    %edx,%edx
  802290:	f7 f7                	div    %edi
  802292:	89 c5                	mov    %eax,%ebp
  802294:	31 d2                	xor    %edx,%edx
  802296:	89 c8                	mov    %ecx,%eax
  802298:	f7 f5                	div    %ebp
  80229a:	89 c1                	mov    %eax,%ecx
  80229c:	89 d8                	mov    %ebx,%eax
  80229e:	f7 f5                	div    %ebp
  8022a0:	89 cf                	mov    %ecx,%edi
  8022a2:	89 fa                	mov    %edi,%edx
  8022a4:	83 c4 1c             	add    $0x1c,%esp
  8022a7:	5b                   	pop    %ebx
  8022a8:	5e                   	pop    %esi
  8022a9:	5f                   	pop    %edi
  8022aa:	5d                   	pop    %ebp
  8022ab:	c3                   	ret    
  8022ac:	39 ce                	cmp    %ecx,%esi
  8022ae:	77 28                	ja     8022d8 <__udivdi3+0x7c>
  8022b0:	0f bd fe             	bsr    %esi,%edi
  8022b3:	83 f7 1f             	xor    $0x1f,%edi
  8022b6:	75 40                	jne    8022f8 <__udivdi3+0x9c>
  8022b8:	39 ce                	cmp    %ecx,%esi
  8022ba:	72 0a                	jb     8022c6 <__udivdi3+0x6a>
  8022bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8022c0:	0f 87 9e 00 00 00    	ja     802364 <__udivdi3+0x108>
  8022c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cb:	89 fa                	mov    %edi,%edx
  8022cd:	83 c4 1c             	add    $0x1c,%esp
  8022d0:	5b                   	pop    %ebx
  8022d1:	5e                   	pop    %esi
  8022d2:	5f                   	pop    %edi
  8022d3:	5d                   	pop    %ebp
  8022d4:	c3                   	ret    
  8022d5:	8d 76 00             	lea    0x0(%esi),%esi
  8022d8:	31 ff                	xor    %edi,%edi
  8022da:	31 c0                	xor    %eax,%eax
  8022dc:	89 fa                	mov    %edi,%edx
  8022de:	83 c4 1c             	add    $0x1c,%esp
  8022e1:	5b                   	pop    %ebx
  8022e2:	5e                   	pop    %esi
  8022e3:	5f                   	pop    %edi
  8022e4:	5d                   	pop    %ebp
  8022e5:	c3                   	ret    
  8022e6:	66 90                	xchg   %ax,%ax
  8022e8:	89 d8                	mov    %ebx,%eax
  8022ea:	f7 f7                	div    %edi
  8022ec:	31 ff                	xor    %edi,%edi
  8022ee:	89 fa                	mov    %edi,%edx
  8022f0:	83 c4 1c             	add    $0x1c,%esp
  8022f3:	5b                   	pop    %ebx
  8022f4:	5e                   	pop    %esi
  8022f5:	5f                   	pop    %edi
  8022f6:	5d                   	pop    %ebp
  8022f7:	c3                   	ret    
  8022f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8022fd:	89 eb                	mov    %ebp,%ebx
  8022ff:	29 fb                	sub    %edi,%ebx
  802301:	89 f9                	mov    %edi,%ecx
  802303:	d3 e6                	shl    %cl,%esi
  802305:	89 c5                	mov    %eax,%ebp
  802307:	88 d9                	mov    %bl,%cl
  802309:	d3 ed                	shr    %cl,%ebp
  80230b:	89 e9                	mov    %ebp,%ecx
  80230d:	09 f1                	or     %esi,%ecx
  80230f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802313:	89 f9                	mov    %edi,%ecx
  802315:	d3 e0                	shl    %cl,%eax
  802317:	89 c5                	mov    %eax,%ebp
  802319:	89 d6                	mov    %edx,%esi
  80231b:	88 d9                	mov    %bl,%cl
  80231d:	d3 ee                	shr    %cl,%esi
  80231f:	89 f9                	mov    %edi,%ecx
  802321:	d3 e2                	shl    %cl,%edx
  802323:	8b 44 24 08          	mov    0x8(%esp),%eax
  802327:	88 d9                	mov    %bl,%cl
  802329:	d3 e8                	shr    %cl,%eax
  80232b:	09 c2                	or     %eax,%edx
  80232d:	89 d0                	mov    %edx,%eax
  80232f:	89 f2                	mov    %esi,%edx
  802331:	f7 74 24 0c          	divl   0xc(%esp)
  802335:	89 d6                	mov    %edx,%esi
  802337:	89 c3                	mov    %eax,%ebx
  802339:	f7 e5                	mul    %ebp
  80233b:	39 d6                	cmp    %edx,%esi
  80233d:	72 19                	jb     802358 <__udivdi3+0xfc>
  80233f:	74 0b                	je     80234c <__udivdi3+0xf0>
  802341:	89 d8                	mov    %ebx,%eax
  802343:	31 ff                	xor    %edi,%edi
  802345:	e9 58 ff ff ff       	jmp    8022a2 <__udivdi3+0x46>
  80234a:	66 90                	xchg   %ax,%ax
  80234c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802350:	89 f9                	mov    %edi,%ecx
  802352:	d3 e2                	shl    %cl,%edx
  802354:	39 c2                	cmp    %eax,%edx
  802356:	73 e9                	jae    802341 <__udivdi3+0xe5>
  802358:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80235b:	31 ff                	xor    %edi,%edi
  80235d:	e9 40 ff ff ff       	jmp    8022a2 <__udivdi3+0x46>
  802362:	66 90                	xchg   %ax,%ax
  802364:	31 c0                	xor    %eax,%eax
  802366:	e9 37 ff ff ff       	jmp    8022a2 <__udivdi3+0x46>
  80236b:	90                   	nop

0080236c <__umoddi3>:
  80236c:	55                   	push   %ebp
  80236d:	57                   	push   %edi
  80236e:	56                   	push   %esi
  80236f:	53                   	push   %ebx
  802370:	83 ec 1c             	sub    $0x1c,%esp
  802373:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802377:	8b 74 24 34          	mov    0x34(%esp),%esi
  80237b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80237f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802383:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802387:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80238b:	89 f3                	mov    %esi,%ebx
  80238d:	89 fa                	mov    %edi,%edx
  80238f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802393:	89 34 24             	mov    %esi,(%esp)
  802396:	85 c0                	test   %eax,%eax
  802398:	75 1a                	jne    8023b4 <__umoddi3+0x48>
  80239a:	39 f7                	cmp    %esi,%edi
  80239c:	0f 86 a2 00 00 00    	jbe    802444 <__umoddi3+0xd8>
  8023a2:	89 c8                	mov    %ecx,%eax
  8023a4:	89 f2                	mov    %esi,%edx
  8023a6:	f7 f7                	div    %edi
  8023a8:	89 d0                	mov    %edx,%eax
  8023aa:	31 d2                	xor    %edx,%edx
  8023ac:	83 c4 1c             	add    $0x1c,%esp
  8023af:	5b                   	pop    %ebx
  8023b0:	5e                   	pop    %esi
  8023b1:	5f                   	pop    %edi
  8023b2:	5d                   	pop    %ebp
  8023b3:	c3                   	ret    
  8023b4:	39 f0                	cmp    %esi,%eax
  8023b6:	0f 87 ac 00 00 00    	ja     802468 <__umoddi3+0xfc>
  8023bc:	0f bd e8             	bsr    %eax,%ebp
  8023bf:	83 f5 1f             	xor    $0x1f,%ebp
  8023c2:	0f 84 ac 00 00 00    	je     802474 <__umoddi3+0x108>
  8023c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8023cd:	29 ef                	sub    %ebp,%edi
  8023cf:	89 fe                	mov    %edi,%esi
  8023d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023d5:	89 e9                	mov    %ebp,%ecx
  8023d7:	d3 e0                	shl    %cl,%eax
  8023d9:	89 d7                	mov    %edx,%edi
  8023db:	89 f1                	mov    %esi,%ecx
  8023dd:	d3 ef                	shr    %cl,%edi
  8023df:	09 c7                	or     %eax,%edi
  8023e1:	89 e9                	mov    %ebp,%ecx
  8023e3:	d3 e2                	shl    %cl,%edx
  8023e5:	89 14 24             	mov    %edx,(%esp)
  8023e8:	89 d8                	mov    %ebx,%eax
  8023ea:	d3 e0                	shl    %cl,%eax
  8023ec:	89 c2                	mov    %eax,%edx
  8023ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023f2:	d3 e0                	shl    %cl,%eax
  8023f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023fc:	89 f1                	mov    %esi,%ecx
  8023fe:	d3 e8                	shr    %cl,%eax
  802400:	09 d0                	or     %edx,%eax
  802402:	d3 eb                	shr    %cl,%ebx
  802404:	89 da                	mov    %ebx,%edx
  802406:	f7 f7                	div    %edi
  802408:	89 d3                	mov    %edx,%ebx
  80240a:	f7 24 24             	mull   (%esp)
  80240d:	89 c6                	mov    %eax,%esi
  80240f:	89 d1                	mov    %edx,%ecx
  802411:	39 d3                	cmp    %edx,%ebx
  802413:	0f 82 87 00 00 00    	jb     8024a0 <__umoddi3+0x134>
  802419:	0f 84 91 00 00 00    	je     8024b0 <__umoddi3+0x144>
  80241f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802423:	29 f2                	sub    %esi,%edx
  802425:	19 cb                	sbb    %ecx,%ebx
  802427:	89 d8                	mov    %ebx,%eax
  802429:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80242d:	d3 e0                	shl    %cl,%eax
  80242f:	89 e9                	mov    %ebp,%ecx
  802431:	d3 ea                	shr    %cl,%edx
  802433:	09 d0                	or     %edx,%eax
  802435:	89 e9                	mov    %ebp,%ecx
  802437:	d3 eb                	shr    %cl,%ebx
  802439:	89 da                	mov    %ebx,%edx
  80243b:	83 c4 1c             	add    $0x1c,%esp
  80243e:	5b                   	pop    %ebx
  80243f:	5e                   	pop    %esi
  802440:	5f                   	pop    %edi
  802441:	5d                   	pop    %ebp
  802442:	c3                   	ret    
  802443:	90                   	nop
  802444:	89 fd                	mov    %edi,%ebp
  802446:	85 ff                	test   %edi,%edi
  802448:	75 0b                	jne    802455 <__umoddi3+0xe9>
  80244a:	b8 01 00 00 00       	mov    $0x1,%eax
  80244f:	31 d2                	xor    %edx,%edx
  802451:	f7 f7                	div    %edi
  802453:	89 c5                	mov    %eax,%ebp
  802455:	89 f0                	mov    %esi,%eax
  802457:	31 d2                	xor    %edx,%edx
  802459:	f7 f5                	div    %ebp
  80245b:	89 c8                	mov    %ecx,%eax
  80245d:	f7 f5                	div    %ebp
  80245f:	89 d0                	mov    %edx,%eax
  802461:	e9 44 ff ff ff       	jmp    8023aa <__umoddi3+0x3e>
  802466:	66 90                	xchg   %ax,%ax
  802468:	89 c8                	mov    %ecx,%eax
  80246a:	89 f2                	mov    %esi,%edx
  80246c:	83 c4 1c             	add    $0x1c,%esp
  80246f:	5b                   	pop    %ebx
  802470:	5e                   	pop    %esi
  802471:	5f                   	pop    %edi
  802472:	5d                   	pop    %ebp
  802473:	c3                   	ret    
  802474:	3b 04 24             	cmp    (%esp),%eax
  802477:	72 06                	jb     80247f <__umoddi3+0x113>
  802479:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80247d:	77 0f                	ja     80248e <__umoddi3+0x122>
  80247f:	89 f2                	mov    %esi,%edx
  802481:	29 f9                	sub    %edi,%ecx
  802483:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802487:	89 14 24             	mov    %edx,(%esp)
  80248a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80248e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802492:	8b 14 24             	mov    (%esp),%edx
  802495:	83 c4 1c             	add    $0x1c,%esp
  802498:	5b                   	pop    %ebx
  802499:	5e                   	pop    %esi
  80249a:	5f                   	pop    %edi
  80249b:	5d                   	pop    %ebp
  80249c:	c3                   	ret    
  80249d:	8d 76 00             	lea    0x0(%esi),%esi
  8024a0:	2b 04 24             	sub    (%esp),%eax
  8024a3:	19 fa                	sbb    %edi,%edx
  8024a5:	89 d1                	mov    %edx,%ecx
  8024a7:	89 c6                	mov    %eax,%esi
  8024a9:	e9 71 ff ff ff       	jmp    80241f <__umoddi3+0xb3>
  8024ae:	66 90                	xchg   %ax,%ax
  8024b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8024b4:	72 ea                	jb     8024a0 <__umoddi3+0x134>
  8024b6:	89 d9                	mov    %ebx,%ecx
  8024b8:	e9 62 ff ff ff       	jmp    80241f <__umoddi3+0xb3>
