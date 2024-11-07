
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
  800041:	e8 3e 1c 00 00       	call   801c84 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 24 80 00       	push   $0x8024c0
  80004e:	e8 f8 0a 00 00       	call   800b4b <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 24 80 00       	push   $0x8024c2
  80005e:	e8 e8 0a 00 00       	call   800b4b <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 d8 24 80 00       	push   $0x8024d8
  80006e:	e8 d8 0a 00 00       	call   800b4b <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 24 80 00       	push   $0x8024c2
  80007e:	e8 c8 0a 00 00       	call   800b4b <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 24 80 00       	push   $0x8024c0
  80008e:	e8 b8 0a 00 00       	call   800b4b <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 f0 24 80 00       	push   $0x8024f0
  8000a5:	e8 35 11 00 00       	call   8011df <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			cprintf("Chose the initialization method:\n") ;
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 10 25 80 00       	push   $0x802510
  8000b5:	e8 91 0a 00 00       	call   800b4b <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 32 25 80 00       	push   $0x802532
  8000c5:	e8 81 0a 00 00       	call   800b4b <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 40 25 80 00       	push   $0x802540
  8000d5:	e8 71 0a 00 00       	call   800b4b <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	68 4f 25 80 00       	push   $0x80254f
  8000e5:	e8 61 0a 00 00       	call   800b4b <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 5f 25 80 00       	push   $0x80255f
  8000f5:	e8 51 0a 00 00       	call   800b4b <cprintf>
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
  800134:	e8 65 1b 00 00       	call   801c9e <sys_unlock_cons>
		//sys_unlock_cons();

		NumOfElements = strtol(Line, NULL, 10) ;
  800139:	83 ec 04             	sub    $0x4,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	6a 00                	push   $0x0
  800140:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800146:	50                   	push   %eax
  800147:	e8 fb 15 00 00       	call   801747 <strtol>
  80014c:	83 c4 10             	add    $0x10,%esp
  80014f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		Elements = malloc(sizeof(int) * NumOfElements) ;
  800152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	50                   	push   %eax
  80015c:	e8 a2 19 00 00       	call   801b03 <malloc>
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
  8001df:	e8 94 09 00 00       	call   800b78 <atomic_cprintf>
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
  800210:	e8 79 06 00 00       	call   80088e <_panic>
		else
		{
			//sys_lock_cons();
			sys_lock_cons();
  800215:	e8 6a 1a 00 00       	call   801c84 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 dc 25 80 00       	push   $0x8025dc
  800222:	e8 24 09 00 00       	call   800b4b <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 10 26 80 00       	push   $0x802610
  800232:	e8 14 09 00 00       	call   800b4b <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 44 26 80 00       	push   $0x802644
  800242:	e8 04 09 00 00       	call   800b4b <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  80024a:	e8 4f 1a 00 00       	call   801c9e <sys_unlock_cons>
			//sys_unlock_cons();
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 d2 18 00 00       	call   801b2c <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  80025d:	e8 22 1a 00 00       	call   801c84 <sys_lock_cons>
		{
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 42                	jmp    8002aa <_main+0x272>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 76 26 80 00       	push   $0x802676
  800270:	e8 d6 08 00 00       	call   800b4b <cprintf>
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
  8002b6:	e8 e3 19 00 00       	call   801c9e <sys_unlock_cons>
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
  80044f:	e8 f7 06 00 00       	call   800b4b <cprintf>
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
  800471:	e8 d5 06 00 00       	call   800b4b <cprintf>
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
  80049f:	e8 a7 06 00 00       	call   800b4b <cprintf>
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
  800540:	e8 be 15 00 00       	call   801b03 <malloc>
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  80054b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054e:	c1 e0 02             	shl    $0x2,%eax
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	50                   	push   %eax
  800555:	e8 a9 15 00 00       	call   801b03 <malloc>
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
  800702:	e8 25 14 00 00       	call   801b2c <free>
  800707:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  80070a:	83 ec 0c             	sub    $0xc,%esp
  80070d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800710:	e8 17 14 00 00       	call   801b2c <free>
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
  80072f:	e8 9b 16 00 00       	call   801dcf <sys_cputc>
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
  800740:	e8 26 15 00 00       	call   801c6b <sys_cgetc>
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
  80075d:	e8 9e 17 00 00       	call   801f00 <sys_getenvindex>
  800762:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800765:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800768:	89 d0                	mov    %edx,%eax
  80076a:	c1 e0 02             	shl    $0x2,%eax
  80076d:	01 d0                	add    %edx,%eax
  80076f:	01 c0                	add    %eax,%eax
  800771:	01 d0                	add    %edx,%eax
  800773:	c1 e0 02             	shl    $0x2,%eax
  800776:	01 d0                	add    %edx,%eax
  800778:	01 c0                	add    %eax,%eax
  80077a:	01 d0                	add    %edx,%eax
  80077c:	c1 e0 04             	shl    $0x4,%eax
  80077f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800784:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800789:	a1 08 30 80 00       	mov    0x803008,%eax
  80078e:	8a 40 20             	mov    0x20(%eax),%al
  800791:	84 c0                	test   %al,%al
  800793:	74 0d                	je     8007a2 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800795:	a1 08 30 80 00       	mov    0x803008,%eax
  80079a:	83 c0 20             	add    $0x20,%eax
  80079d:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007a6:	7e 0a                	jle    8007b2 <libmain+0x5b>
		binaryname = argv[0];
  8007a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	ff 75 08             	pushl  0x8(%ebp)
  8007bb:	e8 78 f8 ff ff       	call   800038 <_main>
  8007c0:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8007c3:	e8 bc 14 00 00       	call   801c84 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8007c8:	83 ec 0c             	sub    $0xc,%esp
  8007cb:	68 b8 26 80 00       	push   $0x8026b8
  8007d0:	e8 76 03 00 00       	call   800b4b <cprintf>
  8007d5:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007d8:	a1 08 30 80 00       	mov    0x803008,%eax
  8007dd:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8007e3:	a1 08 30 80 00       	mov    0x803008,%eax
  8007e8:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8007ee:	83 ec 04             	sub    $0x4,%esp
  8007f1:	52                   	push   %edx
  8007f2:	50                   	push   %eax
  8007f3:	68 e0 26 80 00       	push   $0x8026e0
  8007f8:	e8 4e 03 00 00       	call   800b4b <cprintf>
  8007fd:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800800:	a1 08 30 80 00       	mov    0x803008,%eax
  800805:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  80080b:	a1 08 30 80 00       	mov    0x803008,%eax
  800810:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800816:	a1 08 30 80 00       	mov    0x803008,%eax
  80081b:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800821:	51                   	push   %ecx
  800822:	52                   	push   %edx
  800823:	50                   	push   %eax
  800824:	68 08 27 80 00       	push   $0x802708
  800829:	e8 1d 03 00 00       	call   800b4b <cprintf>
  80082e:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800831:	a1 08 30 80 00       	mov    0x803008,%eax
  800836:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	50                   	push   %eax
  800840:	68 60 27 80 00       	push   $0x802760
  800845:	e8 01 03 00 00       	call   800b4b <cprintf>
  80084a:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80084d:	83 ec 0c             	sub    $0xc,%esp
  800850:	68 b8 26 80 00       	push   $0x8026b8
  800855:	e8 f1 02 00 00       	call   800b4b <cprintf>
  80085a:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80085d:	e8 3c 14 00 00       	call   801c9e <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800862:	e8 19 00 00 00       	call   800880 <exit>
}
  800867:	90                   	nop
  800868:	c9                   	leave  
  800869:	c3                   	ret    

0080086a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800870:	83 ec 0c             	sub    $0xc,%esp
  800873:	6a 00                	push   $0x0
  800875:	e8 52 16 00 00       	call   801ecc <sys_destroy_env>
  80087a:	83 c4 10             	add    $0x10,%esp
}
  80087d:	90                   	nop
  80087e:	c9                   	leave  
  80087f:	c3                   	ret    

00800880 <exit>:

void
exit(void)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800886:	e8 a7 16 00 00       	call   801f32 <sys_exit_env>
}
  80088b:	90                   	nop
  80088c:	c9                   	leave  
  80088d:	c3                   	ret    

0080088e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800894:	8d 45 10             	lea    0x10(%ebp),%eax
  800897:	83 c0 04             	add    $0x4,%eax
  80089a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80089d:	a1 28 30 80 00       	mov    0x803028,%eax
  8008a2:	85 c0                	test   %eax,%eax
  8008a4:	74 16                	je     8008bc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008a6:	a1 28 30 80 00       	mov    0x803028,%eax
  8008ab:	83 ec 08             	sub    $0x8,%esp
  8008ae:	50                   	push   %eax
  8008af:	68 74 27 80 00       	push   $0x802774
  8008b4:	e8 92 02 00 00       	call   800b4b <cprintf>
  8008b9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008bc:	a1 00 30 80 00       	mov    0x803000,%eax
  8008c1:	ff 75 0c             	pushl  0xc(%ebp)
  8008c4:	ff 75 08             	pushl  0x8(%ebp)
  8008c7:	50                   	push   %eax
  8008c8:	68 79 27 80 00       	push   $0x802779
  8008cd:	e8 79 02 00 00       	call   800b4b <cprintf>
  8008d2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 f4             	pushl  -0xc(%ebp)
  8008de:	50                   	push   %eax
  8008df:	e8 fc 01 00 00       	call   800ae0 <vcprintf>
  8008e4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	6a 00                	push   $0x0
  8008ec:	68 95 27 80 00       	push   $0x802795
  8008f1:	e8 ea 01 00 00       	call   800ae0 <vcprintf>
  8008f6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008f9:	e8 82 ff ff ff       	call   800880 <exit>

	// should not return here
	while (1) ;
  8008fe:	eb fe                	jmp    8008fe <_panic+0x70>

00800900 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800906:	a1 08 30 80 00       	mov    0x803008,%eax
  80090b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800911:	8b 45 0c             	mov    0xc(%ebp),%eax
  800914:	39 c2                	cmp    %eax,%edx
  800916:	74 14                	je     80092c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	68 98 27 80 00       	push   $0x802798
  800920:	6a 26                	push   $0x26
  800922:	68 e4 27 80 00       	push   $0x8027e4
  800927:	e8 62 ff ff ff       	call   80088e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80092c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800933:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80093a:	e9 c5 00 00 00       	jmp    800a04 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80093f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800942:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	01 d0                	add    %edx,%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	85 c0                	test   %eax,%eax
  800952:	75 08                	jne    80095c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800954:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800957:	e9 a5 00 00 00       	jmp    800a01 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80095c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800963:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80096a:	eb 69                	jmp    8009d5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80096c:	a1 08 30 80 00       	mov    0x803008,%eax
  800971:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800977:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80097a:	89 d0                	mov    %edx,%eax
  80097c:	01 c0                	add    %eax,%eax
  80097e:	01 d0                	add    %edx,%eax
  800980:	c1 e0 03             	shl    $0x3,%eax
  800983:	01 c8                	add    %ecx,%eax
  800985:	8a 40 04             	mov    0x4(%eax),%al
  800988:	84 c0                	test   %al,%al
  80098a:	75 46                	jne    8009d2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80098c:	a1 08 30 80 00       	mov    0x803008,%eax
  800991:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800997:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80099a:	89 d0                	mov    %edx,%eax
  80099c:	01 c0                	add    %eax,%eax
  80099e:	01 d0                	add    %edx,%eax
  8009a0:	c1 e0 03             	shl    $0x3,%eax
  8009a3:	01 c8                	add    %ecx,%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	01 c8                	add    %ecx,%eax
  8009c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009c5:	39 c2                	cmp    %eax,%edx
  8009c7:	75 09                	jne    8009d2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8009c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009d0:	eb 15                	jmp    8009e7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d2:	ff 45 e8             	incl   -0x18(%ebp)
  8009d5:	a1 08 30 80 00       	mov    0x803008,%eax
  8009da:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009e3:	39 c2                	cmp    %eax,%edx
  8009e5:	77 85                	ja     80096c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009eb:	75 14                	jne    800a01 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	68 f0 27 80 00       	push   $0x8027f0
  8009f5:	6a 3a                	push   $0x3a
  8009f7:	68 e4 27 80 00       	push   $0x8027e4
  8009fc:	e8 8d fe ff ff       	call   80088e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a01:	ff 45 f0             	incl   -0x10(%ebp)
  800a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a07:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a0a:	0f 8c 2f ff ff ff    	jl     80093f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a10:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a17:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a1e:	eb 26                	jmp    800a46 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a20:	a1 08 30 80 00       	mov    0x803008,%eax
  800a25:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800a2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	01 c0                	add    %eax,%eax
  800a32:	01 d0                	add    %edx,%eax
  800a34:	c1 e0 03             	shl    $0x3,%eax
  800a37:	01 c8                	add    %ecx,%eax
  800a39:	8a 40 04             	mov    0x4(%eax),%al
  800a3c:	3c 01                	cmp    $0x1,%al
  800a3e:	75 03                	jne    800a43 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a40:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a43:	ff 45 e0             	incl   -0x20(%ebp)
  800a46:	a1 08 30 80 00       	mov    0x803008,%eax
  800a4b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a54:	39 c2                	cmp    %eax,%edx
  800a56:	77 c8                	ja     800a20 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a5b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a5e:	74 14                	je     800a74 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a60:	83 ec 04             	sub    $0x4,%esp
  800a63:	68 44 28 80 00       	push   $0x802844
  800a68:	6a 44                	push   $0x44
  800a6a:	68 e4 27 80 00       	push   $0x8027e4
  800a6f:	e8 1a fe ff ff       	call   80088e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a74:	90                   	nop
  800a75:	c9                   	leave  
  800a76:	c3                   	ret    

00800a77 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a80:	8b 00                	mov    (%eax),%eax
  800a82:	8d 48 01             	lea    0x1(%eax),%ecx
  800a85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a88:	89 0a                	mov    %ecx,(%edx)
  800a8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a8d:	88 d1                	mov    %dl,%cl
  800a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a92:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a99:	8b 00                	mov    (%eax),%eax
  800a9b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aa0:	75 2c                	jne    800ace <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800aa2:	a0 0c 30 80 00       	mov    0x80300c,%al
  800aa7:	0f b6 c0             	movzbl %al,%eax
  800aaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aad:	8b 12                	mov    (%edx),%edx
  800aaf:	89 d1                	mov    %edx,%ecx
  800ab1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab4:	83 c2 08             	add    $0x8,%edx
  800ab7:	83 ec 04             	sub    $0x4,%esp
  800aba:	50                   	push   %eax
  800abb:	51                   	push   %ecx
  800abc:	52                   	push   %edx
  800abd:	e8 80 11 00 00       	call   801c42 <sys_cputs>
  800ac2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad1:	8b 40 04             	mov    0x4(%eax),%eax
  800ad4:	8d 50 01             	lea    0x1(%eax),%edx
  800ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ada:	89 50 04             	mov    %edx,0x4(%eax)
}
  800add:	90                   	nop
  800ade:	c9                   	leave  
  800adf:	c3                   	ret    

00800ae0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ae9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800af0:	00 00 00 
	b.cnt = 0;
  800af3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800afa:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	ff 75 08             	pushl  0x8(%ebp)
  800b03:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b09:	50                   	push   %eax
  800b0a:	68 77 0a 80 00       	push   $0x800a77
  800b0f:	e8 11 02 00 00       	call   800d25 <vprintfmt>
  800b14:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b17:	a0 0c 30 80 00       	mov    0x80300c,%al
  800b1c:	0f b6 c0             	movzbl %al,%eax
  800b1f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b25:	83 ec 04             	sub    $0x4,%esp
  800b28:	50                   	push   %eax
  800b29:	52                   	push   %edx
  800b2a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b30:	83 c0 08             	add    $0x8,%eax
  800b33:	50                   	push   %eax
  800b34:	e8 09 11 00 00       	call   801c42 <sys_cputs>
  800b39:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b3c:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800b43:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b51:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800b58:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	83 ec 08             	sub    $0x8,%esp
  800b64:	ff 75 f4             	pushl  -0xc(%ebp)
  800b67:	50                   	push   %eax
  800b68:	e8 73 ff ff ff       	call   800ae0 <vcprintf>
  800b6d:	83 c4 10             	add    $0x10,%esp
  800b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b76:	c9                   	leave  
  800b77:	c3                   	ret    

00800b78 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b7e:	e8 01 11 00 00       	call   801c84 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b83:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b86:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	83 ec 08             	sub    $0x8,%esp
  800b8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b92:	50                   	push   %eax
  800b93:	e8 48 ff ff ff       	call   800ae0 <vcprintf>
  800b98:	83 c4 10             	add    $0x10,%esp
  800b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b9e:	e8 fb 10 00 00       	call   801c9e <sys_unlock_cons>
	return cnt;
  800ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba6:	c9                   	leave  
  800ba7:	c3                   	ret    

00800ba8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	53                   	push   %ebx
  800bac:	83 ec 14             	sub    $0x14,%esp
  800baf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bbb:	8b 45 18             	mov    0x18(%ebp),%eax
  800bbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bc6:	77 55                	ja     800c1d <printnum+0x75>
  800bc8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bcb:	72 05                	jb     800bd2 <printnum+0x2a>
  800bcd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bd0:	77 4b                	ja     800c1d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bd5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bd8:	8b 45 18             	mov    0x18(%ebp),%eax
  800bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  800be0:	52                   	push   %edx
  800be1:	50                   	push   %eax
  800be2:	ff 75 f4             	pushl  -0xc(%ebp)
  800be5:	ff 75 f0             	pushl  -0x10(%ebp)
  800be8:	e8 53 16 00 00       	call   802240 <__udivdi3>
  800bed:	83 c4 10             	add    $0x10,%esp
  800bf0:	83 ec 04             	sub    $0x4,%esp
  800bf3:	ff 75 20             	pushl  0x20(%ebp)
  800bf6:	53                   	push   %ebx
  800bf7:	ff 75 18             	pushl  0x18(%ebp)
  800bfa:	52                   	push   %edx
  800bfb:	50                   	push   %eax
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	ff 75 08             	pushl  0x8(%ebp)
  800c02:	e8 a1 ff ff ff       	call   800ba8 <printnum>
  800c07:	83 c4 20             	add    $0x20,%esp
  800c0a:	eb 1a                	jmp    800c26 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c0c:	83 ec 08             	sub    $0x8,%esp
  800c0f:	ff 75 0c             	pushl  0xc(%ebp)
  800c12:	ff 75 20             	pushl  0x20(%ebp)
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	ff d0                	call   *%eax
  800c1a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c1d:	ff 4d 1c             	decl   0x1c(%ebp)
  800c20:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c24:	7f e6                	jg     800c0c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c26:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c29:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c34:	53                   	push   %ebx
  800c35:	51                   	push   %ecx
  800c36:	52                   	push   %edx
  800c37:	50                   	push   %eax
  800c38:	e8 13 17 00 00       	call   802350 <__umoddi3>
  800c3d:	83 c4 10             	add    $0x10,%esp
  800c40:	05 b4 2a 80 00       	add    $0x802ab4,%eax
  800c45:	8a 00                	mov    (%eax),%al
  800c47:	0f be c0             	movsbl %al,%eax
  800c4a:	83 ec 08             	sub    $0x8,%esp
  800c4d:	ff 75 0c             	pushl  0xc(%ebp)
  800c50:	50                   	push   %eax
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
}
  800c59:	90                   	nop
  800c5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c5d:	c9                   	leave  
  800c5e:	c3                   	ret    

00800c5f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c62:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c66:	7e 1c                	jle    800c84 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8b 00                	mov    (%eax),%eax
  800c6d:	8d 50 08             	lea    0x8(%eax),%edx
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	89 10                	mov    %edx,(%eax)
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8b 00                	mov    (%eax),%eax
  800c7a:	83 e8 08             	sub    $0x8,%eax
  800c7d:	8b 50 04             	mov    0x4(%eax),%edx
  800c80:	8b 00                	mov    (%eax),%eax
  800c82:	eb 40                	jmp    800cc4 <getuint+0x65>
	else if (lflag)
  800c84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c88:	74 1e                	je     800ca8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8b 00                	mov    (%eax),%eax
  800c8f:	8d 50 04             	lea    0x4(%eax),%edx
  800c92:	8b 45 08             	mov    0x8(%ebp),%eax
  800c95:	89 10                	mov    %edx,(%eax)
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8b 00                	mov    (%eax),%eax
  800c9c:	83 e8 04             	sub    $0x4,%eax
  800c9f:	8b 00                	mov    (%eax),%eax
  800ca1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca6:	eb 1c                	jmp    800cc4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	8d 50 04             	lea    0x4(%eax),%edx
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 10                	mov    %edx,(%eax)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8b 00                	mov    (%eax),%eax
  800cba:	83 e8 04             	sub    $0x4,%eax
  800cbd:	8b 00                	mov    (%eax),%eax
  800cbf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cc9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ccd:	7e 1c                	jle    800ceb <getint+0x25>
		return va_arg(*ap, long long);
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8b 00                	mov    (%eax),%eax
  800cd4:	8d 50 08             	lea    0x8(%eax),%edx
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	89 10                	mov    %edx,(%eax)
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8b 00                	mov    (%eax),%eax
  800ce1:	83 e8 08             	sub    $0x8,%eax
  800ce4:	8b 50 04             	mov    0x4(%eax),%edx
  800ce7:	8b 00                	mov    (%eax),%eax
  800ce9:	eb 38                	jmp    800d23 <getint+0x5d>
	else if (lflag)
  800ceb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cef:	74 1a                	je     800d0b <getint+0x45>
		return va_arg(*ap, long);
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8b 00                	mov    (%eax),%eax
  800cf6:	8d 50 04             	lea    0x4(%eax),%edx
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 10                	mov    %edx,(%eax)
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	8b 00                	mov    (%eax),%eax
  800d03:	83 e8 04             	sub    $0x4,%eax
  800d06:	8b 00                	mov    (%eax),%eax
  800d08:	99                   	cltd   
  800d09:	eb 18                	jmp    800d23 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	8d 50 04             	lea    0x4(%eax),%edx
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	89 10                	mov    %edx,(%eax)
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8b 00                	mov    (%eax),%eax
  800d1d:	83 e8 04             	sub    $0x4,%eax
  800d20:	8b 00                	mov    (%eax),%eax
  800d22:	99                   	cltd   
}
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
  800d2a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d2d:	eb 17                	jmp    800d46 <vprintfmt+0x21>
			if (ch == '\0')
  800d2f:	85 db                	test   %ebx,%ebx
  800d31:	0f 84 c1 03 00 00    	je     8010f8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d37:	83 ec 08             	sub    $0x8,%esp
  800d3a:	ff 75 0c             	pushl  0xc(%ebp)
  800d3d:	53                   	push   %ebx
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	ff d0                	call   *%eax
  800d43:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d46:	8b 45 10             	mov    0x10(%ebp),%eax
  800d49:	8d 50 01             	lea    0x1(%eax),%edx
  800d4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	0f b6 d8             	movzbl %al,%ebx
  800d54:	83 fb 25             	cmp    $0x25,%ebx
  800d57:	75 d6                	jne    800d2f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d59:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d5d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d64:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d6b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d72:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d79:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7c:	8d 50 01             	lea    0x1(%eax),%edx
  800d7f:	89 55 10             	mov    %edx,0x10(%ebp)
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	0f b6 d8             	movzbl %al,%ebx
  800d87:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d8a:	83 f8 5b             	cmp    $0x5b,%eax
  800d8d:	0f 87 3d 03 00 00    	ja     8010d0 <vprintfmt+0x3ab>
  800d93:	8b 04 85 d8 2a 80 00 	mov    0x802ad8(,%eax,4),%eax
  800d9a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d9c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800da0:	eb d7                	jmp    800d79 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800da2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800da6:	eb d1                	jmp    800d79 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800da8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800daf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800db2:	89 d0                	mov    %edx,%eax
  800db4:	c1 e0 02             	shl    $0x2,%eax
  800db7:	01 d0                	add    %edx,%eax
  800db9:	01 c0                	add    %eax,%eax
  800dbb:	01 d8                	add    %ebx,%eax
  800dbd:	83 e8 30             	sub    $0x30,%eax
  800dc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dcb:	83 fb 2f             	cmp    $0x2f,%ebx
  800dce:	7e 3e                	jle    800e0e <vprintfmt+0xe9>
  800dd0:	83 fb 39             	cmp    $0x39,%ebx
  800dd3:	7f 39                	jg     800e0e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dd5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dd8:	eb d5                	jmp    800daf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800dda:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddd:	83 c0 04             	add    $0x4,%eax
  800de0:	89 45 14             	mov    %eax,0x14(%ebp)
  800de3:	8b 45 14             	mov    0x14(%ebp),%eax
  800de6:	83 e8 04             	sub    $0x4,%eax
  800de9:	8b 00                	mov    (%eax),%eax
  800deb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800dee:	eb 1f                	jmp    800e0f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800df0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df4:	79 83                	jns    800d79 <vprintfmt+0x54>
				width = 0;
  800df6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800dfd:	e9 77 ff ff ff       	jmp    800d79 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e02:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e09:	e9 6b ff ff ff       	jmp    800d79 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e0e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e13:	0f 89 60 ff ff ff    	jns    800d79 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e1f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e26:	e9 4e ff ff ff       	jmp    800d79 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e2b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e2e:	e9 46 ff ff ff       	jmp    800d79 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e33:	8b 45 14             	mov    0x14(%ebp),%eax
  800e36:	83 c0 04             	add    $0x4,%eax
  800e39:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3f:	83 e8 04             	sub    $0x4,%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	83 ec 08             	sub    $0x8,%esp
  800e47:	ff 75 0c             	pushl  0xc(%ebp)
  800e4a:	50                   	push   %eax
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	ff d0                	call   *%eax
  800e50:	83 c4 10             	add    $0x10,%esp
			break;
  800e53:	e9 9b 02 00 00       	jmp    8010f3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e58:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5b:	83 c0 04             	add    $0x4,%eax
  800e5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800e61:	8b 45 14             	mov    0x14(%ebp),%eax
  800e64:	83 e8 04             	sub    $0x4,%eax
  800e67:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e69:	85 db                	test   %ebx,%ebx
  800e6b:	79 02                	jns    800e6f <vprintfmt+0x14a>
				err = -err;
  800e6d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e6f:	83 fb 64             	cmp    $0x64,%ebx
  800e72:	7f 0b                	jg     800e7f <vprintfmt+0x15a>
  800e74:	8b 34 9d 20 29 80 00 	mov    0x802920(,%ebx,4),%esi
  800e7b:	85 f6                	test   %esi,%esi
  800e7d:	75 19                	jne    800e98 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e7f:	53                   	push   %ebx
  800e80:	68 c5 2a 80 00       	push   $0x802ac5
  800e85:	ff 75 0c             	pushl  0xc(%ebp)
  800e88:	ff 75 08             	pushl  0x8(%ebp)
  800e8b:	e8 70 02 00 00       	call   801100 <printfmt>
  800e90:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e93:	e9 5b 02 00 00       	jmp    8010f3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e98:	56                   	push   %esi
  800e99:	68 ce 2a 80 00       	push   $0x802ace
  800e9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ea1:	ff 75 08             	pushl  0x8(%ebp)
  800ea4:	e8 57 02 00 00       	call   801100 <printfmt>
  800ea9:	83 c4 10             	add    $0x10,%esp
			break;
  800eac:	e9 42 02 00 00       	jmp    8010f3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb4:	83 c0 04             	add    $0x4,%eax
  800eb7:	89 45 14             	mov    %eax,0x14(%ebp)
  800eba:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebd:	83 e8 04             	sub    $0x4,%eax
  800ec0:	8b 30                	mov    (%eax),%esi
  800ec2:	85 f6                	test   %esi,%esi
  800ec4:	75 05                	jne    800ecb <vprintfmt+0x1a6>
				p = "(null)";
  800ec6:	be d1 2a 80 00       	mov    $0x802ad1,%esi
			if (width > 0 && padc != '-')
  800ecb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ecf:	7e 6d                	jle    800f3e <vprintfmt+0x219>
  800ed1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ed5:	74 67                	je     800f3e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ed7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	50                   	push   %eax
  800ede:	56                   	push   %esi
  800edf:	e8 26 05 00 00       	call   80140a <strnlen>
  800ee4:	83 c4 10             	add    $0x10,%esp
  800ee7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800eea:	eb 16                	jmp    800f02 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800eec:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ef0:	83 ec 08             	sub    $0x8,%esp
  800ef3:	ff 75 0c             	pushl  0xc(%ebp)
  800ef6:	50                   	push   %eax
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	ff d0                	call   *%eax
  800efc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eff:	ff 4d e4             	decl   -0x1c(%ebp)
  800f02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f06:	7f e4                	jg     800eec <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f08:	eb 34                	jmp    800f3e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f0a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f0e:	74 1c                	je     800f2c <vprintfmt+0x207>
  800f10:	83 fb 1f             	cmp    $0x1f,%ebx
  800f13:	7e 05                	jle    800f1a <vprintfmt+0x1f5>
  800f15:	83 fb 7e             	cmp    $0x7e,%ebx
  800f18:	7e 12                	jle    800f2c <vprintfmt+0x207>
					putch('?', putdat);
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	ff 75 0c             	pushl  0xc(%ebp)
  800f20:	6a 3f                	push   $0x3f
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	ff d0                	call   *%eax
  800f27:	83 c4 10             	add    $0x10,%esp
  800f2a:	eb 0f                	jmp    800f3b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f2c:	83 ec 08             	sub    $0x8,%esp
  800f2f:	ff 75 0c             	pushl  0xc(%ebp)
  800f32:	53                   	push   %ebx
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	ff d0                	call   *%eax
  800f38:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f3b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f3e:	89 f0                	mov    %esi,%eax
  800f40:	8d 70 01             	lea    0x1(%eax),%esi
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	0f be d8             	movsbl %al,%ebx
  800f48:	85 db                	test   %ebx,%ebx
  800f4a:	74 24                	je     800f70 <vprintfmt+0x24b>
  800f4c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f50:	78 b8                	js     800f0a <vprintfmt+0x1e5>
  800f52:	ff 4d e0             	decl   -0x20(%ebp)
  800f55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f59:	79 af                	jns    800f0a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f5b:	eb 13                	jmp    800f70 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f5d:	83 ec 08             	sub    $0x8,%esp
  800f60:	ff 75 0c             	pushl  0xc(%ebp)
  800f63:	6a 20                	push   $0x20
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	ff d0                	call   *%eax
  800f6a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f6d:	ff 4d e4             	decl   -0x1c(%ebp)
  800f70:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f74:	7f e7                	jg     800f5d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f76:	e9 78 01 00 00       	jmp    8010f3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f7b:	83 ec 08             	sub    $0x8,%esp
  800f7e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f81:	8d 45 14             	lea    0x14(%ebp),%eax
  800f84:	50                   	push   %eax
  800f85:	e8 3c fd ff ff       	call   800cc6 <getint>
  800f8a:	83 c4 10             	add    $0x10,%esp
  800f8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f90:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f99:	85 d2                	test   %edx,%edx
  800f9b:	79 23                	jns    800fc0 <vprintfmt+0x29b>
				putch('-', putdat);
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	ff 75 0c             	pushl  0xc(%ebp)
  800fa3:	6a 2d                	push   $0x2d
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb3:	f7 d8                	neg    %eax
  800fb5:	83 d2 00             	adc    $0x0,%edx
  800fb8:	f7 da                	neg    %edx
  800fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fc0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fc7:	e9 bc 00 00 00       	jmp    801088 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fcc:	83 ec 08             	sub    $0x8,%esp
  800fcf:	ff 75 e8             	pushl  -0x18(%ebp)
  800fd2:	8d 45 14             	lea    0x14(%ebp),%eax
  800fd5:	50                   	push   %eax
  800fd6:	e8 84 fc ff ff       	call   800c5f <getuint>
  800fdb:	83 c4 10             	add    $0x10,%esp
  800fde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fe4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800feb:	e9 98 00 00 00       	jmp    801088 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 0c             	pushl  0xc(%ebp)
  800ff6:	6a 58                	push   $0x58
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	ff d0                	call   *%eax
  800ffd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801000:	83 ec 08             	sub    $0x8,%esp
  801003:	ff 75 0c             	pushl  0xc(%ebp)
  801006:	6a 58                	push   $0x58
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	ff d0                	call   *%eax
  80100d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801010:	83 ec 08             	sub    $0x8,%esp
  801013:	ff 75 0c             	pushl  0xc(%ebp)
  801016:	6a 58                	push   $0x58
  801018:	8b 45 08             	mov    0x8(%ebp),%eax
  80101b:	ff d0                	call   *%eax
  80101d:	83 c4 10             	add    $0x10,%esp
			break;
  801020:	e9 ce 00 00 00       	jmp    8010f3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	6a 30                	push   $0x30
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	ff d0                	call   *%eax
  801032:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801035:	83 ec 08             	sub    $0x8,%esp
  801038:	ff 75 0c             	pushl  0xc(%ebp)
  80103b:	6a 78                	push   $0x78
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	ff d0                	call   *%eax
  801042:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801045:	8b 45 14             	mov    0x14(%ebp),%eax
  801048:	83 c0 04             	add    $0x4,%eax
  80104b:	89 45 14             	mov    %eax,0x14(%ebp)
  80104e:	8b 45 14             	mov    0x14(%ebp),%eax
  801051:	83 e8 04             	sub    $0x4,%eax
  801054:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801056:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801059:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801060:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801067:	eb 1f                	jmp    801088 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801069:	83 ec 08             	sub    $0x8,%esp
  80106c:	ff 75 e8             	pushl  -0x18(%ebp)
  80106f:	8d 45 14             	lea    0x14(%ebp),%eax
  801072:	50                   	push   %eax
  801073:	e8 e7 fb ff ff       	call   800c5f <getuint>
  801078:	83 c4 10             	add    $0x10,%esp
  80107b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80107e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801081:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801088:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80108c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80108f:	83 ec 04             	sub    $0x4,%esp
  801092:	52                   	push   %edx
  801093:	ff 75 e4             	pushl  -0x1c(%ebp)
  801096:	50                   	push   %eax
  801097:	ff 75 f4             	pushl  -0xc(%ebp)
  80109a:	ff 75 f0             	pushl  -0x10(%ebp)
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	ff 75 08             	pushl  0x8(%ebp)
  8010a3:	e8 00 fb ff ff       	call   800ba8 <printnum>
  8010a8:	83 c4 20             	add    $0x20,%esp
			break;
  8010ab:	eb 46                	jmp    8010f3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ad:	83 ec 08             	sub    $0x8,%esp
  8010b0:	ff 75 0c             	pushl  0xc(%ebp)
  8010b3:	53                   	push   %ebx
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	ff d0                	call   *%eax
  8010b9:	83 c4 10             	add    $0x10,%esp
			break;
  8010bc:	eb 35                	jmp    8010f3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010be:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  8010c5:	eb 2c                	jmp    8010f3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010c7:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  8010ce:	eb 23                	jmp    8010f3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010d0:	83 ec 08             	sub    $0x8,%esp
  8010d3:	ff 75 0c             	pushl  0xc(%ebp)
  8010d6:	6a 25                	push   $0x25
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	ff d0                	call   *%eax
  8010dd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010e0:	ff 4d 10             	decl   0x10(%ebp)
  8010e3:	eb 03                	jmp    8010e8 <vprintfmt+0x3c3>
  8010e5:	ff 4d 10             	decl   0x10(%ebp)
  8010e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010eb:	48                   	dec    %eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	3c 25                	cmp    $0x25,%al
  8010f0:	75 f3                	jne    8010e5 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010f2:	90                   	nop
		}
	}
  8010f3:	e9 35 fc ff ff       	jmp    800d2d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010f8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010fc:	5b                   	pop    %ebx
  8010fd:	5e                   	pop    %esi
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    

00801100 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801106:	8d 45 10             	lea    0x10(%ebp),%eax
  801109:	83 c0 04             	add    $0x4,%eax
  80110c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80110f:	8b 45 10             	mov    0x10(%ebp),%eax
  801112:	ff 75 f4             	pushl  -0xc(%ebp)
  801115:	50                   	push   %eax
  801116:	ff 75 0c             	pushl  0xc(%ebp)
  801119:	ff 75 08             	pushl  0x8(%ebp)
  80111c:	e8 04 fc ff ff       	call   800d25 <vprintfmt>
  801121:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801124:	90                   	nop
  801125:	c9                   	leave  
  801126:	c3                   	ret    

00801127 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	8b 40 08             	mov    0x8(%eax),%eax
  801130:	8d 50 01             	lea    0x1(%eax),%edx
  801133:	8b 45 0c             	mov    0xc(%ebp),%eax
  801136:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113c:	8b 10                	mov    (%eax),%edx
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	8b 40 04             	mov    0x4(%eax),%eax
  801144:	39 c2                	cmp    %eax,%edx
  801146:	73 12                	jae    80115a <sprintputch+0x33>
		*b->buf++ = ch;
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	8b 00                	mov    (%eax),%eax
  80114d:	8d 48 01             	lea    0x1(%eax),%ecx
  801150:	8b 55 0c             	mov    0xc(%ebp),%edx
  801153:	89 0a                	mov    %ecx,(%edx)
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	88 10                	mov    %dl,(%eax)
}
  80115a:	90                   	nop
  80115b:	5d                   	pop    %ebp
  80115c:	c3                   	ret    

0080115d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	01 d0                	add    %edx,%eax
  801174:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801177:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80117e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801182:	74 06                	je     80118a <vsnprintf+0x2d>
  801184:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801188:	7f 07                	jg     801191 <vsnprintf+0x34>
		return -E_INVAL;
  80118a:	b8 03 00 00 00       	mov    $0x3,%eax
  80118f:	eb 20                	jmp    8011b1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801191:	ff 75 14             	pushl  0x14(%ebp)
  801194:	ff 75 10             	pushl  0x10(%ebp)
  801197:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80119a:	50                   	push   %eax
  80119b:	68 27 11 80 00       	push   $0x801127
  8011a0:	e8 80 fb ff ff       	call   800d25 <vprintfmt>
  8011a5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011ab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011b1:	c9                   	leave  
  8011b2:	c3                   	ret    

008011b3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8011bc:	83 c0 04             	add    $0x4,%eax
  8011bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c8:	50                   	push   %eax
  8011c9:	ff 75 0c             	pushl  0xc(%ebp)
  8011cc:	ff 75 08             	pushl  0x8(%ebp)
  8011cf:	e8 89 ff ff ff       	call   80115d <vsnprintf>
  8011d4:	83 c4 10             	add    $0x10,%esp
  8011d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8011e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e9:	74 13                	je     8011fe <readline+0x1f>
		cprintf("%s", prompt);
  8011eb:	83 ec 08             	sub    $0x8,%esp
  8011ee:	ff 75 08             	pushl  0x8(%ebp)
  8011f1:	68 48 2c 80 00       	push   $0x802c48
  8011f6:	e8 50 f9 ff ff       	call   800b4b <cprintf>
  8011fb:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801205:	83 ec 0c             	sub    $0xc,%esp
  801208:	6a 00                	push   $0x0
  80120a:	e8 3e f5 ff ff       	call   80074d <iscons>
  80120f:	83 c4 10             	add    $0x10,%esp
  801212:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801215:	e8 20 f5 ff ff       	call   80073a <getchar>
  80121a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80121d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801221:	79 22                	jns    801245 <readline+0x66>
			if (c != -E_EOF)
  801223:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801227:	0f 84 ad 00 00 00    	je     8012da <readline+0xfb>
				cprintf("read error: %e\n", c);
  80122d:	83 ec 08             	sub    $0x8,%esp
  801230:	ff 75 ec             	pushl  -0x14(%ebp)
  801233:	68 4b 2c 80 00       	push   $0x802c4b
  801238:	e8 0e f9 ff ff       	call   800b4b <cprintf>
  80123d:	83 c4 10             	add    $0x10,%esp
			break;
  801240:	e9 95 00 00 00       	jmp    8012da <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801245:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801249:	7e 34                	jle    80127f <readline+0xa0>
  80124b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801252:	7f 2b                	jg     80127f <readline+0xa0>
			if (echoing)
  801254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801258:	74 0e                	je     801268 <readline+0x89>
				cputchar(c);
  80125a:	83 ec 0c             	sub    $0xc,%esp
  80125d:	ff 75 ec             	pushl  -0x14(%ebp)
  801260:	e8 b6 f4 ff ff       	call   80071b <cputchar>
  801265:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126b:	8d 50 01             	lea    0x1(%eax),%edx
  80126e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801271:	89 c2                	mov    %eax,%edx
  801273:	8b 45 0c             	mov    0xc(%ebp),%eax
  801276:	01 d0                	add    %edx,%eax
  801278:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80127b:	88 10                	mov    %dl,(%eax)
  80127d:	eb 56                	jmp    8012d5 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80127f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801283:	75 1f                	jne    8012a4 <readline+0xc5>
  801285:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801289:	7e 19                	jle    8012a4 <readline+0xc5>
			if (echoing)
  80128b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80128f:	74 0e                	je     80129f <readline+0xc0>
				cputchar(c);
  801291:	83 ec 0c             	sub    $0xc,%esp
  801294:	ff 75 ec             	pushl  -0x14(%ebp)
  801297:	e8 7f f4 ff ff       	call   80071b <cputchar>
  80129c:	83 c4 10             	add    $0x10,%esp

			i--;
  80129f:	ff 4d f4             	decl   -0xc(%ebp)
  8012a2:	eb 31                	jmp    8012d5 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012a4:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012a8:	74 0a                	je     8012b4 <readline+0xd5>
  8012aa:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012ae:	0f 85 61 ff ff ff    	jne    801215 <readline+0x36>
			if (echoing)
  8012b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b8:	74 0e                	je     8012c8 <readline+0xe9>
				cputchar(c);
  8012ba:	83 ec 0c             	sub    $0xc,%esp
  8012bd:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c0:	e8 56 f4 ff ff       	call   80071b <cputchar>
  8012c5:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8012d3:	eb 06                	jmp    8012db <readline+0xfc>
		}
	}
  8012d5:	e9 3b ff ff ff       	jmp    801215 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8012da:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8012db:	90                   	nop
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    

008012de <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8012e4:	e8 9b 09 00 00       	call   801c84 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ed:	74 13                	je     801302 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012ef:	83 ec 08             	sub    $0x8,%esp
  8012f2:	ff 75 08             	pushl  0x8(%ebp)
  8012f5:	68 48 2c 80 00       	push   $0x802c48
  8012fa:	e8 4c f8 ff ff       	call   800b4b <cprintf>
  8012ff:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801302:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801309:	83 ec 0c             	sub    $0xc,%esp
  80130c:	6a 00                	push   $0x0
  80130e:	e8 3a f4 ff ff       	call   80074d <iscons>
  801313:	83 c4 10             	add    $0x10,%esp
  801316:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801319:	e8 1c f4 ff ff       	call   80073a <getchar>
  80131e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801321:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801325:	79 22                	jns    801349 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801327:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80132b:	0f 84 ad 00 00 00    	je     8013de <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801331:	83 ec 08             	sub    $0x8,%esp
  801334:	ff 75 ec             	pushl  -0x14(%ebp)
  801337:	68 4b 2c 80 00       	push   $0x802c4b
  80133c:	e8 0a f8 ff ff       	call   800b4b <cprintf>
  801341:	83 c4 10             	add    $0x10,%esp
				break;
  801344:	e9 95 00 00 00       	jmp    8013de <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801349:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80134d:	7e 34                	jle    801383 <atomic_readline+0xa5>
  80134f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801356:	7f 2b                	jg     801383 <atomic_readline+0xa5>
				if (echoing)
  801358:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80135c:	74 0e                	je     80136c <atomic_readline+0x8e>
					cputchar(c);
  80135e:	83 ec 0c             	sub    $0xc,%esp
  801361:	ff 75 ec             	pushl  -0x14(%ebp)
  801364:	e8 b2 f3 ff ff       	call   80071b <cputchar>
  801369:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80136c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136f:	8d 50 01             	lea    0x1(%eax),%edx
  801372:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801375:	89 c2                	mov    %eax,%edx
  801377:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137a:	01 d0                	add    %edx,%eax
  80137c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80137f:	88 10                	mov    %dl,(%eax)
  801381:	eb 56                	jmp    8013d9 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801383:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801387:	75 1f                	jne    8013a8 <atomic_readline+0xca>
  801389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80138d:	7e 19                	jle    8013a8 <atomic_readline+0xca>
				if (echoing)
  80138f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801393:	74 0e                	je     8013a3 <atomic_readline+0xc5>
					cputchar(c);
  801395:	83 ec 0c             	sub    $0xc,%esp
  801398:	ff 75 ec             	pushl  -0x14(%ebp)
  80139b:	e8 7b f3 ff ff       	call   80071b <cputchar>
  8013a0:	83 c4 10             	add    $0x10,%esp
				i--;
  8013a3:	ff 4d f4             	decl   -0xc(%ebp)
  8013a6:	eb 31                	jmp    8013d9 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8013a8:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013ac:	74 0a                	je     8013b8 <atomic_readline+0xda>
  8013ae:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013b2:	0f 85 61 ff ff ff    	jne    801319 <atomic_readline+0x3b>
				if (echoing)
  8013b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013bc:	74 0e                	je     8013cc <atomic_readline+0xee>
					cputchar(c);
  8013be:	83 ec 0c             	sub    $0xc,%esp
  8013c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8013c4:	e8 52 f3 ff ff       	call   80071b <cputchar>
  8013c9:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8013cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8013d7:	eb 06                	jmp    8013df <atomic_readline+0x101>
			}
		}
  8013d9:	e9 3b ff ff ff       	jmp    801319 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8013de:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8013df:	e8 ba 08 00 00       	call   801c9e <sys_unlock_cons>
}
  8013e4:	90                   	nop
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    

008013e7 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f4:	eb 06                	jmp    8013fc <strlen+0x15>
		n++;
  8013f6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013f9:	ff 45 08             	incl   0x8(%ebp)
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	8a 00                	mov    (%eax),%al
  801401:	84 c0                	test   %al,%al
  801403:	75 f1                	jne    8013f6 <strlen+0xf>
		n++;
	return n;
  801405:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801408:	c9                   	leave  
  801409:	c3                   	ret    

0080140a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
  80140d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801417:	eb 09                	jmp    801422 <strnlen+0x18>
		n++;
  801419:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80141c:	ff 45 08             	incl   0x8(%ebp)
  80141f:	ff 4d 0c             	decl   0xc(%ebp)
  801422:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801426:	74 09                	je     801431 <strnlen+0x27>
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	84 c0                	test   %al,%al
  80142f:	75 e8                	jne    801419 <strnlen+0xf>
		n++;
	return n;
  801431:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801442:	90                   	nop
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	8d 50 01             	lea    0x1(%eax),%edx
  801449:	89 55 08             	mov    %edx,0x8(%ebp)
  80144c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801452:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801455:	8a 12                	mov    (%edx),%dl
  801457:	88 10                	mov    %dl,(%eax)
  801459:	8a 00                	mov    (%eax),%al
  80145b:	84 c0                	test   %al,%al
  80145d:	75 e4                	jne    801443 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80145f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801470:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801477:	eb 1f                	jmp    801498 <strncpy+0x34>
		*dst++ = *src;
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8d 50 01             	lea    0x1(%eax),%edx
  80147f:	89 55 08             	mov    %edx,0x8(%ebp)
  801482:	8b 55 0c             	mov    0xc(%ebp),%edx
  801485:	8a 12                	mov    (%edx),%dl
  801487:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	84 c0                	test   %al,%al
  801490:	74 03                	je     801495 <strncpy+0x31>
			src++;
  801492:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801495:	ff 45 fc             	incl   -0x4(%ebp)
  801498:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80149e:	72 d9                	jb     801479 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b5:	74 30                	je     8014e7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014b7:	eb 16                	jmp    8014cf <strlcpy+0x2a>
			*dst++ = *src++;
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	8d 50 01             	lea    0x1(%eax),%edx
  8014bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014cb:	8a 12                	mov    (%edx),%dl
  8014cd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014cf:	ff 4d 10             	decl   0x10(%ebp)
  8014d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d6:	74 09                	je     8014e1 <strlcpy+0x3c>
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	84 c0                	test   %al,%al
  8014df:	75 d8                	jne    8014b9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ed:	29 c2                	sub    %eax,%edx
  8014ef:	89 d0                	mov    %edx,%eax
}
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014f6:	eb 06                	jmp    8014fe <strcmp+0xb>
		p++, q++;
  8014f8:	ff 45 08             	incl   0x8(%ebp)
  8014fb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	84 c0                	test   %al,%al
  801505:	74 0e                	je     801515 <strcmp+0x22>
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 10                	mov    (%eax),%dl
  80150c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150f:	8a 00                	mov    (%eax),%al
  801511:	38 c2                	cmp    %al,%dl
  801513:	74 e3                	je     8014f8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8a 00                	mov    (%eax),%al
  80151a:	0f b6 d0             	movzbl %al,%edx
  80151d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	0f b6 c0             	movzbl %al,%eax
  801525:	29 c2                	sub    %eax,%edx
  801527:	89 d0                	mov    %edx,%eax
}
  801529:	5d                   	pop    %ebp
  80152a:	c3                   	ret    

0080152b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80152e:	eb 09                	jmp    801539 <strncmp+0xe>
		n--, p++, q++;
  801530:	ff 4d 10             	decl   0x10(%ebp)
  801533:	ff 45 08             	incl   0x8(%ebp)
  801536:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801539:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80153d:	74 17                	je     801556 <strncmp+0x2b>
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	84 c0                	test   %al,%al
  801546:	74 0e                	je     801556 <strncmp+0x2b>
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 10                	mov    (%eax),%dl
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	8a 00                	mov    (%eax),%al
  801552:	38 c2                	cmp    %al,%dl
  801554:	74 da                	je     801530 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801556:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80155a:	75 07                	jne    801563 <strncmp+0x38>
		return 0;
  80155c:	b8 00 00 00 00       	mov    $0x0,%eax
  801561:	eb 14                	jmp    801577 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	8a 00                	mov    (%eax),%al
  801568:	0f b6 d0             	movzbl %al,%edx
  80156b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f b6 c0             	movzbl %al,%eax
  801573:	29 c2                	sub    %eax,%edx
  801575:	89 d0                	mov    %edx,%eax
}
  801577:	5d                   	pop    %ebp
  801578:	c3                   	ret    

00801579 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 04             	sub    $0x4,%esp
  80157f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801582:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801585:	eb 12                	jmp    801599 <strchr+0x20>
		if (*s == c)
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80158f:	75 05                	jne    801596 <strchr+0x1d>
			return (char *) s;
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	eb 11                	jmp    8015a7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801596:	ff 45 08             	incl   0x8(%ebp)
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	8a 00                	mov    (%eax),%al
  80159e:	84 c0                	test   %al,%al
  8015a0:	75 e5                	jne    801587 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b5:	eb 0d                	jmp    8015c4 <strfind+0x1b>
		if (*s == c)
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	8a 00                	mov    (%eax),%al
  8015bc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015bf:	74 0e                	je     8015cf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015c1:	ff 45 08             	incl   0x8(%ebp)
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	84 c0                	test   %al,%al
  8015cb:	75 ea                	jne    8015b7 <strfind+0xe>
  8015cd:	eb 01                	jmp    8015d0 <strfind+0x27>
		if (*s == c)
			break;
  8015cf:	90                   	nop
	return (char *) s;
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015e7:	eb 0e                	jmp    8015f7 <memset+0x22>
		*p++ = c;
  8015e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ec:	8d 50 01             	lea    0x1(%eax),%edx
  8015ef:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015f7:	ff 4d f8             	decl   -0x8(%ebp)
  8015fa:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015fe:	79 e9                	jns    8015e9 <memset+0x14>
		*p++ = c;

	return v;
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80160b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801617:	eb 16                	jmp    80162f <memcpy+0x2a>
		*d++ = *s++;
  801619:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80161c:	8d 50 01             	lea    0x1(%eax),%edx
  80161f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801622:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801625:	8d 4a 01             	lea    0x1(%edx),%ecx
  801628:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80162b:	8a 12                	mov    (%edx),%dl
  80162d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80162f:	8b 45 10             	mov    0x10(%ebp),%eax
  801632:	8d 50 ff             	lea    -0x1(%eax),%edx
  801635:	89 55 10             	mov    %edx,0x10(%ebp)
  801638:	85 c0                	test   %eax,%eax
  80163a:	75 dd                	jne    801619 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80163f:	c9                   	leave  
  801640:	c3                   	ret    

00801641 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801653:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801656:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801659:	73 50                	jae    8016ab <memmove+0x6a>
  80165b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	01 d0                	add    %edx,%eax
  801663:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801666:	76 43                	jbe    8016ab <memmove+0x6a>
		s += n;
  801668:	8b 45 10             	mov    0x10(%ebp),%eax
  80166b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80166e:	8b 45 10             	mov    0x10(%ebp),%eax
  801671:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801674:	eb 10                	jmp    801686 <memmove+0x45>
			*--d = *--s;
  801676:	ff 4d f8             	decl   -0x8(%ebp)
  801679:	ff 4d fc             	decl   -0x4(%ebp)
  80167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80167f:	8a 10                	mov    (%eax),%dl
  801681:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801684:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801686:	8b 45 10             	mov    0x10(%ebp),%eax
  801689:	8d 50 ff             	lea    -0x1(%eax),%edx
  80168c:	89 55 10             	mov    %edx,0x10(%ebp)
  80168f:	85 c0                	test   %eax,%eax
  801691:	75 e3                	jne    801676 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801693:	eb 23                	jmp    8016b8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801695:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801698:	8d 50 01             	lea    0x1(%eax),%edx
  80169b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80169e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016a4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016a7:	8a 12                	mov    (%edx),%dl
  8016a9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	75 dd                	jne    801695 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016cf:	eb 2a                	jmp    8016fb <memcmp+0x3e>
		if (*s1 != *s2)
  8016d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d4:	8a 10                	mov    (%eax),%dl
  8016d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	38 c2                	cmp    %al,%dl
  8016dd:	74 16                	je     8016f5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	0f b6 d0             	movzbl %al,%edx
  8016e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ea:	8a 00                	mov    (%eax),%al
  8016ec:	0f b6 c0             	movzbl %al,%eax
  8016ef:	29 c2                	sub    %eax,%edx
  8016f1:	89 d0                	mov    %edx,%eax
  8016f3:	eb 18                	jmp    80170d <memcmp+0x50>
		s1++, s2++;
  8016f5:	ff 45 fc             	incl   -0x4(%ebp)
  8016f8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  801701:	89 55 10             	mov    %edx,0x10(%ebp)
  801704:	85 c0                	test   %eax,%eax
  801706:	75 c9                	jne    8016d1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801708:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801715:	8b 55 08             	mov    0x8(%ebp),%edx
  801718:	8b 45 10             	mov    0x10(%ebp),%eax
  80171b:	01 d0                	add    %edx,%eax
  80171d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801720:	eb 15                	jmp    801737 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	8a 00                	mov    (%eax),%al
  801727:	0f b6 d0             	movzbl %al,%edx
  80172a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172d:	0f b6 c0             	movzbl %al,%eax
  801730:	39 c2                	cmp    %eax,%edx
  801732:	74 0d                	je     801741 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801734:	ff 45 08             	incl   0x8(%ebp)
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80173d:	72 e3                	jb     801722 <memfind+0x13>
  80173f:	eb 01                	jmp    801742 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801741:	90                   	nop
	return (void *) s;
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80174d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801754:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80175b:	eb 03                	jmp    801760 <strtol+0x19>
		s++;
  80175d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	3c 20                	cmp    $0x20,%al
  801767:	74 f4                	je     80175d <strtol+0x16>
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	8a 00                	mov    (%eax),%al
  80176e:	3c 09                	cmp    $0x9,%al
  801770:	74 eb                	je     80175d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	8a 00                	mov    (%eax),%al
  801777:	3c 2b                	cmp    $0x2b,%al
  801779:	75 05                	jne    801780 <strtol+0x39>
		s++;
  80177b:	ff 45 08             	incl   0x8(%ebp)
  80177e:	eb 13                	jmp    801793 <strtol+0x4c>
	else if (*s == '-')
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	8a 00                	mov    (%eax),%al
  801785:	3c 2d                	cmp    $0x2d,%al
  801787:	75 0a                	jne    801793 <strtol+0x4c>
		s++, neg = 1;
  801789:	ff 45 08             	incl   0x8(%ebp)
  80178c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801793:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801797:	74 06                	je     80179f <strtol+0x58>
  801799:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80179d:	75 20                	jne    8017bf <strtol+0x78>
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	3c 30                	cmp    $0x30,%al
  8017a6:	75 17                	jne    8017bf <strtol+0x78>
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	40                   	inc    %eax
  8017ac:	8a 00                	mov    (%eax),%al
  8017ae:	3c 78                	cmp    $0x78,%al
  8017b0:	75 0d                	jne    8017bf <strtol+0x78>
		s += 2, base = 16;
  8017b2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017b6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017bd:	eb 28                	jmp    8017e7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c3:	75 15                	jne    8017da <strtol+0x93>
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	8a 00                	mov    (%eax),%al
  8017ca:	3c 30                	cmp    $0x30,%al
  8017cc:	75 0c                	jne    8017da <strtol+0x93>
		s++, base = 8;
  8017ce:	ff 45 08             	incl   0x8(%ebp)
  8017d1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017d8:	eb 0d                	jmp    8017e7 <strtol+0xa0>
	else if (base == 0)
  8017da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017de:	75 07                	jne    8017e7 <strtol+0xa0>
		base = 10;
  8017e0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	8a 00                	mov    (%eax),%al
  8017ec:	3c 2f                	cmp    $0x2f,%al
  8017ee:	7e 19                	jle    801809 <strtol+0xc2>
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	8a 00                	mov    (%eax),%al
  8017f5:	3c 39                	cmp    $0x39,%al
  8017f7:	7f 10                	jg     801809 <strtol+0xc2>
			dig = *s - '0';
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	8a 00                	mov    (%eax),%al
  8017fe:	0f be c0             	movsbl %al,%eax
  801801:	83 e8 30             	sub    $0x30,%eax
  801804:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801807:	eb 42                	jmp    80184b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	8a 00                	mov    (%eax),%al
  80180e:	3c 60                	cmp    $0x60,%al
  801810:	7e 19                	jle    80182b <strtol+0xe4>
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	8a 00                	mov    (%eax),%al
  801817:	3c 7a                	cmp    $0x7a,%al
  801819:	7f 10                	jg     80182b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	8a 00                	mov    (%eax),%al
  801820:	0f be c0             	movsbl %al,%eax
  801823:	83 e8 57             	sub    $0x57,%eax
  801826:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801829:	eb 20                	jmp    80184b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	8a 00                	mov    (%eax),%al
  801830:	3c 40                	cmp    $0x40,%al
  801832:	7e 39                	jle    80186d <strtol+0x126>
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	8a 00                	mov    (%eax),%al
  801839:	3c 5a                	cmp    $0x5a,%al
  80183b:	7f 30                	jg     80186d <strtol+0x126>
			dig = *s - 'A' + 10;
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	0f be c0             	movsbl %al,%eax
  801845:	83 e8 37             	sub    $0x37,%eax
  801848:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80184b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801851:	7d 19                	jge    80186c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801853:	ff 45 08             	incl   0x8(%ebp)
  801856:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801859:	0f af 45 10          	imul   0x10(%ebp),%eax
  80185d:	89 c2                	mov    %eax,%edx
  80185f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801862:	01 d0                	add    %edx,%eax
  801864:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801867:	e9 7b ff ff ff       	jmp    8017e7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80186c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80186d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801871:	74 08                	je     80187b <strtol+0x134>
		*endptr = (char *) s;
  801873:	8b 45 0c             	mov    0xc(%ebp),%eax
  801876:	8b 55 08             	mov    0x8(%ebp),%edx
  801879:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80187b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80187f:	74 07                	je     801888 <strtol+0x141>
  801881:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801884:	f7 d8                	neg    %eax
  801886:	eb 03                	jmp    80188b <strtol+0x144>
  801888:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <ltostr>:

void
ltostr(long value, char *str)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801893:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80189a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a5:	79 13                	jns    8018ba <ltostr+0x2d>
	{
		neg = 1;
  8018a7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018b4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018b7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018c2:	99                   	cltd   
  8018c3:	f7 f9                	idiv   %ecx
  8018c5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cb:	8d 50 01             	lea    0x1(%eax),%edx
  8018ce:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018d1:	89 c2                	mov    %eax,%edx
  8018d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d6:	01 d0                	add    %edx,%eax
  8018d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018db:	83 c2 30             	add    $0x30,%edx
  8018de:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018e8:	f7 e9                	imul   %ecx
  8018ea:	c1 fa 02             	sar    $0x2,%edx
  8018ed:	89 c8                	mov    %ecx,%eax
  8018ef:	c1 f8 1f             	sar    $0x1f,%eax
  8018f2:	29 c2                	sub    %eax,%edx
  8018f4:	89 d0                	mov    %edx,%eax
  8018f6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018fd:	75 bb                	jne    8018ba <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801906:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801909:	48                   	dec    %eax
  80190a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80190d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801911:	74 3d                	je     801950 <ltostr+0xc3>
		start = 1 ;
  801913:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80191a:	eb 34                	jmp    801950 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80191c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80191f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801922:	01 d0                	add    %edx,%eax
  801924:	8a 00                	mov    (%eax),%al
  801926:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192f:	01 c2                	add    %eax,%edx
  801931:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801934:	8b 45 0c             	mov    0xc(%ebp),%eax
  801937:	01 c8                	add    %ecx,%eax
  801939:	8a 00                	mov    (%eax),%al
  80193b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80193d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	01 c2                	add    %eax,%edx
  801945:	8a 45 eb             	mov    -0x15(%ebp),%al
  801948:	88 02                	mov    %al,(%edx)
		start++ ;
  80194a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80194d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801953:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801956:	7c c4                	jl     80191c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801958:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80195b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195e:	01 d0                	add    %edx,%eax
  801960:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801963:	90                   	nop
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80196c:	ff 75 08             	pushl  0x8(%ebp)
  80196f:	e8 73 fa ff ff       	call   8013e7 <strlen>
  801974:	83 c4 04             	add    $0x4,%esp
  801977:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80197a:	ff 75 0c             	pushl  0xc(%ebp)
  80197d:	e8 65 fa ff ff       	call   8013e7 <strlen>
  801982:	83 c4 04             	add    $0x4,%esp
  801985:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801988:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80198f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801996:	eb 17                	jmp    8019af <strcconcat+0x49>
		final[s] = str1[s] ;
  801998:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80199b:	8b 45 10             	mov    0x10(%ebp),%eax
  80199e:	01 c2                	add    %eax,%edx
  8019a0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	01 c8                	add    %ecx,%eax
  8019a8:	8a 00                	mov    (%eax),%al
  8019aa:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019ac:	ff 45 fc             	incl   -0x4(%ebp)
  8019af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019b5:	7c e1                	jl     801998 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019c5:	eb 1f                	jmp    8019e6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ca:	8d 50 01             	lea    0x1(%eax),%edx
  8019cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019d0:	89 c2                	mov    %eax,%edx
  8019d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d5:	01 c2                	add    %eax,%edx
  8019d7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019dd:	01 c8                	add    %ecx,%eax
  8019df:	8a 00                	mov    (%eax),%al
  8019e1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019e3:	ff 45 f8             	incl   -0x8(%ebp)
  8019e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019ec:	7c d9                	jl     8019c7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f4:	01 d0                	add    %edx,%eax
  8019f6:	c6 00 00             	movb   $0x0,(%eax)
}
  8019f9:	90                   	nop
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801a02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a08:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0b:	8b 00                	mov    (%eax),%eax
  801a0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a14:	8b 45 10             	mov    0x10(%ebp),%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a1f:	eb 0c                	jmp    801a2d <strsplit+0x31>
			*string++ = 0;
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	8d 50 01             	lea    0x1(%eax),%edx
  801a27:	89 55 08             	mov    %edx,0x8(%ebp)
  801a2a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	8a 00                	mov    (%eax),%al
  801a32:	84 c0                	test   %al,%al
  801a34:	74 18                	je     801a4e <strsplit+0x52>
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8a 00                	mov    (%eax),%al
  801a3b:	0f be c0             	movsbl %al,%eax
  801a3e:	50                   	push   %eax
  801a3f:	ff 75 0c             	pushl  0xc(%ebp)
  801a42:	e8 32 fb ff ff       	call   801579 <strchr>
  801a47:	83 c4 08             	add    $0x8,%esp
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	75 d3                	jne    801a21 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	8a 00                	mov    (%eax),%al
  801a53:	84 c0                	test   %al,%al
  801a55:	74 5a                	je     801ab1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a57:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5a:	8b 00                	mov    (%eax),%eax
  801a5c:	83 f8 0f             	cmp    $0xf,%eax
  801a5f:	75 07                	jne    801a68 <strsplit+0x6c>
		{
			return 0;
  801a61:	b8 00 00 00 00       	mov    $0x0,%eax
  801a66:	eb 66                	jmp    801ace <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a68:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6b:	8b 00                	mov    (%eax),%eax
  801a6d:	8d 48 01             	lea    0x1(%eax),%ecx
  801a70:	8b 55 14             	mov    0x14(%ebp),%edx
  801a73:	89 0a                	mov    %ecx,(%edx)
  801a75:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7f:	01 c2                	add    %eax,%edx
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a86:	eb 03                	jmp    801a8b <strsplit+0x8f>
			string++;
  801a88:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	8a 00                	mov    (%eax),%al
  801a90:	84 c0                	test   %al,%al
  801a92:	74 8b                	je     801a1f <strsplit+0x23>
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	8a 00                	mov    (%eax),%al
  801a99:	0f be c0             	movsbl %al,%eax
  801a9c:	50                   	push   %eax
  801a9d:	ff 75 0c             	pushl  0xc(%ebp)
  801aa0:	e8 d4 fa ff ff       	call   801579 <strchr>
  801aa5:	83 c4 08             	add    $0x8,%esp
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	74 dc                	je     801a88 <strsplit+0x8c>
			string++;
	}
  801aac:	e9 6e ff ff ff       	jmp    801a1f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ab1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab5:	8b 00                	mov    (%eax),%eax
  801ab7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801abe:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac1:	01 d0                	add    %edx,%eax
  801ac3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ac9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801ad6:	83 ec 04             	sub    $0x4,%esp
  801ad9:	68 5c 2c 80 00       	push   $0x802c5c
  801ade:	68 3f 01 00 00       	push   $0x13f
  801ae3:	68 7e 2c 80 00       	push   $0x802c7e
  801ae8:	e8 a1 ed ff ff       	call   80088e <_panic>

00801aed <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801af3:	83 ec 0c             	sub    $0xc,%esp
  801af6:	ff 75 08             	pushl  0x8(%ebp)
  801af9:	e8 ef 06 00 00       	call   8021ed <sys_sbrk>
  801afe:	83 c4 10             	add    $0x10,%esp
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b0d:	75 07                	jne    801b16 <malloc+0x13>
  801b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b14:	eb 14                	jmp    801b2a <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801b16:	83 ec 04             	sub    $0x4,%esp
  801b19:	68 8c 2c 80 00       	push   $0x802c8c
  801b1e:	6a 1b                	push   $0x1b
  801b20:	68 b1 2c 80 00       	push   $0x802cb1
  801b25:	e8 64 ed ff ff       	call   80088e <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801b32:	83 ec 04             	sub    $0x4,%esp
  801b35:	68 c0 2c 80 00       	push   $0x802cc0
  801b3a:	6a 29                	push   $0x29
  801b3c:	68 b1 2c 80 00       	push   $0x802cb1
  801b41:	e8 48 ed ff ff       	call   80088e <_panic>

00801b46 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	83 ec 18             	sub    $0x18,%esp
  801b4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b56:	75 07                	jne    801b5f <smalloc+0x19>
  801b58:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5d:	eb 14                	jmp    801b73 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801b5f:	83 ec 04             	sub    $0x4,%esp
  801b62:	68 e4 2c 80 00       	push   $0x802ce4
  801b67:	6a 38                	push   $0x38
  801b69:	68 b1 2c 80 00       	push   $0x802cb1
  801b6e:	e8 1b ed ff ff       	call   80088e <_panic>
	return NULL;
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801b7b:	83 ec 04             	sub    $0x4,%esp
  801b7e:	68 0c 2d 80 00       	push   $0x802d0c
  801b83:	6a 43                	push   $0x43
  801b85:	68 b1 2c 80 00       	push   $0x802cb1
  801b8a:	e8 ff ec ff ff       	call   80088e <_panic>

00801b8f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	68 30 2d 80 00       	push   $0x802d30
  801b9d:	6a 5b                	push   $0x5b
  801b9f:	68 b1 2c 80 00       	push   $0x802cb1
  801ba4:	e8 e5 ec ff ff       	call   80088e <_panic>

00801ba9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	68 54 2d 80 00       	push   $0x802d54
  801bb7:	6a 72                	push   $0x72
  801bb9:	68 b1 2c 80 00       	push   $0x802cb1
  801bbe:	e8 cb ec ff ff       	call   80088e <_panic>

00801bc3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	68 7a 2d 80 00       	push   $0x802d7a
  801bd1:	6a 7e                	push   $0x7e
  801bd3:	68 b1 2c 80 00       	push   $0x802cb1
  801bd8:	e8 b1 ec ff ff       	call   80088e <_panic>

00801bdd <shrink>:

}
void shrink(uint32 newSize)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801be3:	83 ec 04             	sub    $0x4,%esp
  801be6:	68 7a 2d 80 00       	push   $0x802d7a
  801beb:	68 83 00 00 00       	push   $0x83
  801bf0:	68 b1 2c 80 00       	push   $0x802cb1
  801bf5:	e8 94 ec ff ff       	call   80088e <_panic>

00801bfa <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	68 7a 2d 80 00       	push   $0x802d7a
  801c08:	68 88 00 00 00       	push   $0x88
  801c0d:	68 b1 2c 80 00       	push   $0x802cb1
  801c12:	e8 77 ec ff ff       	call   80088e <_panic>

00801c17 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	57                   	push   %edi
  801c1b:	56                   	push   %esi
  801c1c:	53                   	push   %ebx
  801c1d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c26:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c29:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c2c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c2f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c32:	cd 30                	int    $0x30
  801c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c3a:	83 c4 10             	add    $0x10,%esp
  801c3d:	5b                   	pop    %ebx
  801c3e:	5e                   	pop    %esi
  801c3f:	5f                   	pop    %edi
  801c40:	5d                   	pop    %ebp
  801c41:	c3                   	ret    

00801c42 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	83 ec 04             	sub    $0x4,%esp
  801c48:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c4e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	52                   	push   %edx
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	50                   	push   %eax
  801c5e:	6a 00                	push   $0x0
  801c60:	e8 b2 ff ff ff       	call   801c17 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	90                   	nop
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_cgetc>:

int
sys_cgetc(void)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 02                	push   $0x2
  801c7a:	e8 98 ff ff ff       	call   801c17 <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
}
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 03                	push   $0x3
  801c93:	e8 7f ff ff ff       	call   801c17 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	90                   	nop
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 04                	push   $0x4
  801cad:	e8 65 ff ff ff       	call   801c17 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	90                   	nop
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	52                   	push   %edx
  801cc8:	50                   	push   %eax
  801cc9:	6a 08                	push   $0x8
  801ccb:	e8 47 ff ff ff       	call   801c17 <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	56                   	push   %esi
  801cd9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cda:	8b 75 18             	mov    0x18(%ebp),%esi
  801cdd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ce0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	56                   	push   %esi
  801cea:	53                   	push   %ebx
  801ceb:	51                   	push   %ecx
  801cec:	52                   	push   %edx
  801ced:	50                   	push   %eax
  801cee:	6a 09                	push   $0x9
  801cf0:	e8 22 ff ff ff       	call   801c17 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
}
  801cf8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5d                   	pop    %ebp
  801cfe:	c3                   	ret    

00801cff <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	52                   	push   %edx
  801d0f:	50                   	push   %eax
  801d10:	6a 0a                	push   $0xa
  801d12:	e8 00 ff ff ff       	call   801c17 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	ff 75 0c             	pushl  0xc(%ebp)
  801d28:	ff 75 08             	pushl  0x8(%ebp)
  801d2b:	6a 0b                	push   $0xb
  801d2d:	e8 e5 fe ff ff       	call   801c17 <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 0c                	push   $0xc
  801d46:	e8 cc fe ff ff       	call   801c17 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 0d                	push   $0xd
  801d5f:	e8 b3 fe ff ff       	call   801c17 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 0e                	push   $0xe
  801d78:	e8 9a fe ff ff       	call   801c17 <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 0f                	push   $0xf
  801d91:	e8 81 fe ff ff       	call   801c17 <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	ff 75 08             	pushl  0x8(%ebp)
  801da9:	6a 10                	push   $0x10
  801dab:	e8 67 fe ff ff       	call   801c17 <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 11                	push   $0x11
  801dc4:	e8 4e fe ff ff       	call   801c17 <syscall>
  801dc9:	83 c4 18             	add    $0x18,%esp
}
  801dcc:	90                   	nop
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_cputc>:

void
sys_cputc(const char c)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	83 ec 04             	sub    $0x4,%esp
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ddb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	50                   	push   %eax
  801de8:	6a 01                	push   $0x1
  801dea:	e8 28 fe ff ff       	call   801c17 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	90                   	nop
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 14                	push   $0x14
  801e04:	e8 0e fe ff ff       	call   801c17 <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
}
  801e0c:	90                   	nop
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	83 ec 04             	sub    $0x4,%esp
  801e15:	8b 45 10             	mov    0x10(%ebp),%eax
  801e18:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e1b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e1e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e22:	8b 45 08             	mov    0x8(%ebp),%eax
  801e25:	6a 00                	push   $0x0
  801e27:	51                   	push   %ecx
  801e28:	52                   	push   %edx
  801e29:	ff 75 0c             	pushl  0xc(%ebp)
  801e2c:	50                   	push   %eax
  801e2d:	6a 15                	push   $0x15
  801e2f:	e8 e3 fd ff ff       	call   801c17 <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	52                   	push   %edx
  801e49:	50                   	push   %eax
  801e4a:	6a 16                	push   $0x16
  801e4c:	e8 c6 fd ff ff       	call   801c17 <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e59:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	51                   	push   %ecx
  801e67:	52                   	push   %edx
  801e68:	50                   	push   %eax
  801e69:	6a 17                	push   $0x17
  801e6b:	e8 a7 fd ff ff       	call   801c17 <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
}
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	52                   	push   %edx
  801e85:	50                   	push   %eax
  801e86:	6a 18                	push   $0x18
  801e88:	e8 8a fd ff ff       	call   801c17 <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	6a 00                	push   $0x0
  801e9a:	ff 75 14             	pushl  0x14(%ebp)
  801e9d:	ff 75 10             	pushl  0x10(%ebp)
  801ea0:	ff 75 0c             	pushl  0xc(%ebp)
  801ea3:	50                   	push   %eax
  801ea4:	6a 19                	push   $0x19
  801ea6:	e8 6c fd ff ff       	call   801c17 <syscall>
  801eab:	83 c4 18             	add    $0x18,%esp
}
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	50                   	push   %eax
  801ebf:	6a 1a                	push   $0x1a
  801ec1:	e8 51 fd ff ff       	call   801c17 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
}
  801ec9:	90                   	nop
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	50                   	push   %eax
  801edb:	6a 1b                	push   $0x1b
  801edd:	e8 35 fd ff ff       	call   801c17 <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 05                	push   $0x5
  801ef6:	e8 1c fd ff ff       	call   801c17 <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 06                	push   $0x6
  801f0f:	e8 03 fd ff ff       	call   801c17 <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 07                	push   $0x7
  801f28:	e8 ea fc ff ff       	call   801c17 <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <sys_exit_env>:


void sys_exit_env(void)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 1c                	push   $0x1c
  801f41:	e8 d1 fc ff ff       	call   801c17 <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
}
  801f49:	90                   	nop
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f52:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f55:	8d 50 04             	lea    0x4(%eax),%edx
  801f58:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	52                   	push   %edx
  801f62:	50                   	push   %eax
  801f63:	6a 1d                	push   $0x1d
  801f65:	e8 ad fc ff ff       	call   801c17 <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
	return result;
  801f6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f73:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f76:	89 01                	mov    %eax,(%ecx)
  801f78:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	c9                   	leave  
  801f7f:	c2 04 00             	ret    $0x4

00801f82 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	ff 75 10             	pushl  0x10(%ebp)
  801f8c:	ff 75 0c             	pushl  0xc(%ebp)
  801f8f:	ff 75 08             	pushl  0x8(%ebp)
  801f92:	6a 13                	push   $0x13
  801f94:	e8 7e fc ff ff       	call   801c17 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9c:	90                   	nop
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <sys_rcr2>:
uint32 sys_rcr2()
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 1e                	push   $0x1e
  801fae:	e8 64 fc ff ff       	call   801c17 <syscall>
  801fb3:	83 c4 18             	add    $0x18,%esp
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fc4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	50                   	push   %eax
  801fd1:	6a 1f                	push   $0x1f
  801fd3:	e8 3f fc ff ff       	call   801c17 <syscall>
  801fd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801fdb:	90                   	nop
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <rsttst>:
void rsttst()
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 21                	push   $0x21
  801fed:	e8 25 fc ff ff       	call   801c17 <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff5:	90                   	nop
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
  801ffb:	83 ec 04             	sub    $0x4,%esp
  801ffe:	8b 45 14             	mov    0x14(%ebp),%eax
  802001:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802004:	8b 55 18             	mov    0x18(%ebp),%edx
  802007:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80200b:	52                   	push   %edx
  80200c:	50                   	push   %eax
  80200d:	ff 75 10             	pushl  0x10(%ebp)
  802010:	ff 75 0c             	pushl  0xc(%ebp)
  802013:	ff 75 08             	pushl  0x8(%ebp)
  802016:	6a 20                	push   $0x20
  802018:	e8 fa fb ff ff       	call   801c17 <syscall>
  80201d:	83 c4 18             	add    $0x18,%esp
	return ;
  802020:	90                   	nop
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <chktst>:
void chktst(uint32 n)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	ff 75 08             	pushl  0x8(%ebp)
  802031:	6a 22                	push   $0x22
  802033:	e8 df fb ff ff       	call   801c17 <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
	return ;
  80203b:	90                   	nop
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <inctst>:

void inctst()
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 23                	push   $0x23
  80204d:	e8 c5 fb ff ff       	call   801c17 <syscall>
  802052:	83 c4 18             	add    $0x18,%esp
	return ;
  802055:	90                   	nop
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <gettst>:
uint32 gettst()
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 24                	push   $0x24
  802067:	e8 ab fb ff ff       	call   801c17 <syscall>
  80206c:	83 c4 18             	add    $0x18,%esp
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 25                	push   $0x25
  802083:	e8 8f fb ff ff       	call   801c17 <syscall>
  802088:	83 c4 18             	add    $0x18,%esp
  80208b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80208e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802092:	75 07                	jne    80209b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802094:	b8 01 00 00 00       	mov    $0x1,%eax
  802099:	eb 05                	jmp    8020a0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80209b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
  8020a5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 25                	push   $0x25
  8020b4:	e8 5e fb ff ff       	call   801c17 <syscall>
  8020b9:	83 c4 18             	add    $0x18,%esp
  8020bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020bf:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020c3:	75 07                	jne    8020cc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ca:	eb 05                	jmp    8020d1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 25                	push   $0x25
  8020e5:	e8 2d fb ff ff       	call   801c17 <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
  8020ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020f0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020f4:	75 07                	jne    8020fd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020fb:	eb 05                	jmp    802102 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 25                	push   $0x25
  802116:	e8 fc fa ff ff       	call   801c17 <syscall>
  80211b:	83 c4 18             	add    $0x18,%esp
  80211e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802121:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802125:	75 07                	jne    80212e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802127:	b8 01 00 00 00       	mov    $0x1,%eax
  80212c:	eb 05                	jmp    802133 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80212e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	ff 75 08             	pushl  0x8(%ebp)
  802143:	6a 26                	push   $0x26
  802145:	e8 cd fa ff ff       	call   801c17 <syscall>
  80214a:	83 c4 18             	add    $0x18,%esp
	return ;
  80214d:	90                   	nop
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802154:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802157:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80215a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	6a 00                	push   $0x0
  802162:	53                   	push   %ebx
  802163:	51                   	push   %ecx
  802164:	52                   	push   %edx
  802165:	50                   	push   %eax
  802166:	6a 27                	push   $0x27
  802168:	e8 aa fa ff ff       	call   801c17 <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
}
  802170:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802178:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	52                   	push   %edx
  802185:	50                   	push   %eax
  802186:	6a 28                	push   $0x28
  802188:	e8 8a fa ff ff       	call   801c17 <syscall>
  80218d:	83 c4 18             	add    $0x18,%esp
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802195:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802198:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	6a 00                	push   $0x0
  8021a0:	51                   	push   %ecx
  8021a1:	ff 75 10             	pushl  0x10(%ebp)
  8021a4:	52                   	push   %edx
  8021a5:	50                   	push   %eax
  8021a6:	6a 29                	push   $0x29
  8021a8:	e8 6a fa ff ff       	call   801c17 <syscall>
  8021ad:	83 c4 18             	add    $0x18,%esp
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	ff 75 10             	pushl  0x10(%ebp)
  8021bc:	ff 75 0c             	pushl  0xc(%ebp)
  8021bf:	ff 75 08             	pushl  0x8(%ebp)
  8021c2:	6a 12                	push   $0x12
  8021c4:	e8 4e fa ff ff       	call   801c17 <syscall>
  8021c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021cc:	90                   	nop
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8021d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	52                   	push   %edx
  8021df:	50                   	push   %eax
  8021e0:	6a 2a                	push   $0x2a
  8021e2:	e8 30 fa ff ff       	call   801c17 <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
	return;
  8021ea:	90                   	nop
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	50                   	push   %eax
  8021fc:	6a 2b                	push   $0x2b
  8021fe:	e8 14 fa ff ff       	call   801c17 <syscall>
  802203:	83 c4 18             	add    $0x18,%esp
}
  802206:	c9                   	leave  
  802207:	c3                   	ret    

00802208 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	ff 75 0c             	pushl  0xc(%ebp)
  802214:	ff 75 08             	pushl  0x8(%ebp)
  802217:	6a 2c                	push   $0x2c
  802219:	e8 f9 f9 ff ff       	call   801c17 <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
	return;
  802221:	90                   	nop
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	ff 75 0c             	pushl  0xc(%ebp)
  802230:	ff 75 08             	pushl  0x8(%ebp)
  802233:	6a 2d                	push   $0x2d
  802235:	e8 dd f9 ff ff       	call   801c17 <syscall>
  80223a:	83 c4 18             	add    $0x18,%esp
	return;
  80223d:	90                   	nop
}
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <__udivdi3>:
  802240:	55                   	push   %ebp
  802241:	57                   	push   %edi
  802242:	56                   	push   %esi
  802243:	53                   	push   %ebx
  802244:	83 ec 1c             	sub    $0x1c,%esp
  802247:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80224b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80224f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802253:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802257:	89 ca                	mov    %ecx,%edx
  802259:	89 f8                	mov    %edi,%eax
  80225b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80225f:	85 f6                	test   %esi,%esi
  802261:	75 2d                	jne    802290 <__udivdi3+0x50>
  802263:	39 cf                	cmp    %ecx,%edi
  802265:	77 65                	ja     8022cc <__udivdi3+0x8c>
  802267:	89 fd                	mov    %edi,%ebp
  802269:	85 ff                	test   %edi,%edi
  80226b:	75 0b                	jne    802278 <__udivdi3+0x38>
  80226d:	b8 01 00 00 00       	mov    $0x1,%eax
  802272:	31 d2                	xor    %edx,%edx
  802274:	f7 f7                	div    %edi
  802276:	89 c5                	mov    %eax,%ebp
  802278:	31 d2                	xor    %edx,%edx
  80227a:	89 c8                	mov    %ecx,%eax
  80227c:	f7 f5                	div    %ebp
  80227e:	89 c1                	mov    %eax,%ecx
  802280:	89 d8                	mov    %ebx,%eax
  802282:	f7 f5                	div    %ebp
  802284:	89 cf                	mov    %ecx,%edi
  802286:	89 fa                	mov    %edi,%edx
  802288:	83 c4 1c             	add    $0x1c,%esp
  80228b:	5b                   	pop    %ebx
  80228c:	5e                   	pop    %esi
  80228d:	5f                   	pop    %edi
  80228e:	5d                   	pop    %ebp
  80228f:	c3                   	ret    
  802290:	39 ce                	cmp    %ecx,%esi
  802292:	77 28                	ja     8022bc <__udivdi3+0x7c>
  802294:	0f bd fe             	bsr    %esi,%edi
  802297:	83 f7 1f             	xor    $0x1f,%edi
  80229a:	75 40                	jne    8022dc <__udivdi3+0x9c>
  80229c:	39 ce                	cmp    %ecx,%esi
  80229e:	72 0a                	jb     8022aa <__udivdi3+0x6a>
  8022a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8022a4:	0f 87 9e 00 00 00    	ja     802348 <__udivdi3+0x108>
  8022aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8022af:	89 fa                	mov    %edi,%edx
  8022b1:	83 c4 1c             	add    $0x1c,%esp
  8022b4:	5b                   	pop    %ebx
  8022b5:	5e                   	pop    %esi
  8022b6:	5f                   	pop    %edi
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    
  8022b9:	8d 76 00             	lea    0x0(%esi),%esi
  8022bc:	31 ff                	xor    %edi,%edi
  8022be:	31 c0                	xor    %eax,%eax
  8022c0:	89 fa                	mov    %edi,%edx
  8022c2:	83 c4 1c             	add    $0x1c,%esp
  8022c5:	5b                   	pop    %ebx
  8022c6:	5e                   	pop    %esi
  8022c7:	5f                   	pop    %edi
  8022c8:	5d                   	pop    %ebp
  8022c9:	c3                   	ret    
  8022ca:	66 90                	xchg   %ax,%ax
  8022cc:	89 d8                	mov    %ebx,%eax
  8022ce:	f7 f7                	div    %edi
  8022d0:	31 ff                	xor    %edi,%edi
  8022d2:	89 fa                	mov    %edi,%edx
  8022d4:	83 c4 1c             	add    $0x1c,%esp
  8022d7:	5b                   	pop    %ebx
  8022d8:	5e                   	pop    %esi
  8022d9:	5f                   	pop    %edi
  8022da:	5d                   	pop    %ebp
  8022db:	c3                   	ret    
  8022dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8022e1:	89 eb                	mov    %ebp,%ebx
  8022e3:	29 fb                	sub    %edi,%ebx
  8022e5:	89 f9                	mov    %edi,%ecx
  8022e7:	d3 e6                	shl    %cl,%esi
  8022e9:	89 c5                	mov    %eax,%ebp
  8022eb:	88 d9                	mov    %bl,%cl
  8022ed:	d3 ed                	shr    %cl,%ebp
  8022ef:	89 e9                	mov    %ebp,%ecx
  8022f1:	09 f1                	or     %esi,%ecx
  8022f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8022f7:	89 f9                	mov    %edi,%ecx
  8022f9:	d3 e0                	shl    %cl,%eax
  8022fb:	89 c5                	mov    %eax,%ebp
  8022fd:	89 d6                	mov    %edx,%esi
  8022ff:	88 d9                	mov    %bl,%cl
  802301:	d3 ee                	shr    %cl,%esi
  802303:	89 f9                	mov    %edi,%ecx
  802305:	d3 e2                	shl    %cl,%edx
  802307:	8b 44 24 08          	mov    0x8(%esp),%eax
  80230b:	88 d9                	mov    %bl,%cl
  80230d:	d3 e8                	shr    %cl,%eax
  80230f:	09 c2                	or     %eax,%edx
  802311:	89 d0                	mov    %edx,%eax
  802313:	89 f2                	mov    %esi,%edx
  802315:	f7 74 24 0c          	divl   0xc(%esp)
  802319:	89 d6                	mov    %edx,%esi
  80231b:	89 c3                	mov    %eax,%ebx
  80231d:	f7 e5                	mul    %ebp
  80231f:	39 d6                	cmp    %edx,%esi
  802321:	72 19                	jb     80233c <__udivdi3+0xfc>
  802323:	74 0b                	je     802330 <__udivdi3+0xf0>
  802325:	89 d8                	mov    %ebx,%eax
  802327:	31 ff                	xor    %edi,%edi
  802329:	e9 58 ff ff ff       	jmp    802286 <__udivdi3+0x46>
  80232e:	66 90                	xchg   %ax,%ax
  802330:	8b 54 24 08          	mov    0x8(%esp),%edx
  802334:	89 f9                	mov    %edi,%ecx
  802336:	d3 e2                	shl    %cl,%edx
  802338:	39 c2                	cmp    %eax,%edx
  80233a:	73 e9                	jae    802325 <__udivdi3+0xe5>
  80233c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80233f:	31 ff                	xor    %edi,%edi
  802341:	e9 40 ff ff ff       	jmp    802286 <__udivdi3+0x46>
  802346:	66 90                	xchg   %ax,%ax
  802348:	31 c0                	xor    %eax,%eax
  80234a:	e9 37 ff ff ff       	jmp    802286 <__udivdi3+0x46>
  80234f:	90                   	nop

00802350 <__umoddi3>:
  802350:	55                   	push   %ebp
  802351:	57                   	push   %edi
  802352:	56                   	push   %esi
  802353:	53                   	push   %ebx
  802354:	83 ec 1c             	sub    $0x1c,%esp
  802357:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80235b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80235f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802363:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802367:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80236b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80236f:	89 f3                	mov    %esi,%ebx
  802371:	89 fa                	mov    %edi,%edx
  802373:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802377:	89 34 24             	mov    %esi,(%esp)
  80237a:	85 c0                	test   %eax,%eax
  80237c:	75 1a                	jne    802398 <__umoddi3+0x48>
  80237e:	39 f7                	cmp    %esi,%edi
  802380:	0f 86 a2 00 00 00    	jbe    802428 <__umoddi3+0xd8>
  802386:	89 c8                	mov    %ecx,%eax
  802388:	89 f2                	mov    %esi,%edx
  80238a:	f7 f7                	div    %edi
  80238c:	89 d0                	mov    %edx,%eax
  80238e:	31 d2                	xor    %edx,%edx
  802390:	83 c4 1c             	add    $0x1c,%esp
  802393:	5b                   	pop    %ebx
  802394:	5e                   	pop    %esi
  802395:	5f                   	pop    %edi
  802396:	5d                   	pop    %ebp
  802397:	c3                   	ret    
  802398:	39 f0                	cmp    %esi,%eax
  80239a:	0f 87 ac 00 00 00    	ja     80244c <__umoddi3+0xfc>
  8023a0:	0f bd e8             	bsr    %eax,%ebp
  8023a3:	83 f5 1f             	xor    $0x1f,%ebp
  8023a6:	0f 84 ac 00 00 00    	je     802458 <__umoddi3+0x108>
  8023ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8023b1:	29 ef                	sub    %ebp,%edi
  8023b3:	89 fe                	mov    %edi,%esi
  8023b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023b9:	89 e9                	mov    %ebp,%ecx
  8023bb:	d3 e0                	shl    %cl,%eax
  8023bd:	89 d7                	mov    %edx,%edi
  8023bf:	89 f1                	mov    %esi,%ecx
  8023c1:	d3 ef                	shr    %cl,%edi
  8023c3:	09 c7                	or     %eax,%edi
  8023c5:	89 e9                	mov    %ebp,%ecx
  8023c7:	d3 e2                	shl    %cl,%edx
  8023c9:	89 14 24             	mov    %edx,(%esp)
  8023cc:	89 d8                	mov    %ebx,%eax
  8023ce:	d3 e0                	shl    %cl,%eax
  8023d0:	89 c2                	mov    %eax,%edx
  8023d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023d6:	d3 e0                	shl    %cl,%eax
  8023d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023e0:	89 f1                	mov    %esi,%ecx
  8023e2:	d3 e8                	shr    %cl,%eax
  8023e4:	09 d0                	or     %edx,%eax
  8023e6:	d3 eb                	shr    %cl,%ebx
  8023e8:	89 da                	mov    %ebx,%edx
  8023ea:	f7 f7                	div    %edi
  8023ec:	89 d3                	mov    %edx,%ebx
  8023ee:	f7 24 24             	mull   (%esp)
  8023f1:	89 c6                	mov    %eax,%esi
  8023f3:	89 d1                	mov    %edx,%ecx
  8023f5:	39 d3                	cmp    %edx,%ebx
  8023f7:	0f 82 87 00 00 00    	jb     802484 <__umoddi3+0x134>
  8023fd:	0f 84 91 00 00 00    	je     802494 <__umoddi3+0x144>
  802403:	8b 54 24 04          	mov    0x4(%esp),%edx
  802407:	29 f2                	sub    %esi,%edx
  802409:	19 cb                	sbb    %ecx,%ebx
  80240b:	89 d8                	mov    %ebx,%eax
  80240d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802411:	d3 e0                	shl    %cl,%eax
  802413:	89 e9                	mov    %ebp,%ecx
  802415:	d3 ea                	shr    %cl,%edx
  802417:	09 d0                	or     %edx,%eax
  802419:	89 e9                	mov    %ebp,%ecx
  80241b:	d3 eb                	shr    %cl,%ebx
  80241d:	89 da                	mov    %ebx,%edx
  80241f:	83 c4 1c             	add    $0x1c,%esp
  802422:	5b                   	pop    %ebx
  802423:	5e                   	pop    %esi
  802424:	5f                   	pop    %edi
  802425:	5d                   	pop    %ebp
  802426:	c3                   	ret    
  802427:	90                   	nop
  802428:	89 fd                	mov    %edi,%ebp
  80242a:	85 ff                	test   %edi,%edi
  80242c:	75 0b                	jne    802439 <__umoddi3+0xe9>
  80242e:	b8 01 00 00 00       	mov    $0x1,%eax
  802433:	31 d2                	xor    %edx,%edx
  802435:	f7 f7                	div    %edi
  802437:	89 c5                	mov    %eax,%ebp
  802439:	89 f0                	mov    %esi,%eax
  80243b:	31 d2                	xor    %edx,%edx
  80243d:	f7 f5                	div    %ebp
  80243f:	89 c8                	mov    %ecx,%eax
  802441:	f7 f5                	div    %ebp
  802443:	89 d0                	mov    %edx,%eax
  802445:	e9 44 ff ff ff       	jmp    80238e <__umoddi3+0x3e>
  80244a:	66 90                	xchg   %ax,%ax
  80244c:	89 c8                	mov    %ecx,%eax
  80244e:	89 f2                	mov    %esi,%edx
  802450:	83 c4 1c             	add    $0x1c,%esp
  802453:	5b                   	pop    %ebx
  802454:	5e                   	pop    %esi
  802455:	5f                   	pop    %edi
  802456:	5d                   	pop    %ebp
  802457:	c3                   	ret    
  802458:	3b 04 24             	cmp    (%esp),%eax
  80245b:	72 06                	jb     802463 <__umoddi3+0x113>
  80245d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802461:	77 0f                	ja     802472 <__umoddi3+0x122>
  802463:	89 f2                	mov    %esi,%edx
  802465:	29 f9                	sub    %edi,%ecx
  802467:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80246b:	89 14 24             	mov    %edx,(%esp)
  80246e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802472:	8b 44 24 04          	mov    0x4(%esp),%eax
  802476:	8b 14 24             	mov    (%esp),%edx
  802479:	83 c4 1c             	add    $0x1c,%esp
  80247c:	5b                   	pop    %ebx
  80247d:	5e                   	pop    %esi
  80247e:	5f                   	pop    %edi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    
  802481:	8d 76 00             	lea    0x0(%esi),%esi
  802484:	2b 04 24             	sub    (%esp),%eax
  802487:	19 fa                	sbb    %edi,%edx
  802489:	89 d1                	mov    %edx,%ecx
  80248b:	89 c6                	mov    %eax,%esi
  80248d:	e9 71 ff ff ff       	jmp    802403 <__umoddi3+0xb3>
  802492:	66 90                	xchg   %ax,%ax
  802494:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802498:	72 ea                	jb     802484 <__umoddi3+0x134>
  80249a:	89 d9                	mov    %ebx,%ecx
  80249c:	e9 62 ff ff ff       	jmp    802403 <__umoddi3+0xb3>
