
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
  800041:	e8 3c 21 00 00       	call   802182 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 44 80 00       	push   $0x804440
  80004e:	e8 00 0b 00 00       	call   800b53 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 44 80 00       	push   $0x804442
  80005e:	e8 f0 0a 00 00       	call   800b53 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 58 44 80 00       	push   $0x804458
  80006e:	e8 e0 0a 00 00       	call   800b53 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 44 80 00       	push   $0x804442
  80007e:	e8 d0 0a 00 00       	call   800b53 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 44 80 00       	push   $0x804440
  80008e:	e8 c0 0a 00 00       	call   800b53 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 70 44 80 00       	push   $0x804470
  8000a5:	e8 3d 11 00 00       	call   8011e7 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			cprintf("Chose the initialization method:\n") ;
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 90 44 80 00       	push   $0x804490
  8000b5:	e8 99 0a 00 00       	call   800b53 <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 b2 44 80 00       	push   $0x8044b2
  8000c5:	e8 89 0a 00 00       	call   800b53 <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 c0 44 80 00       	push   $0x8044c0
  8000d5:	e8 79 0a 00 00       	call   800b53 <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	68 cf 44 80 00       	push   $0x8044cf
  8000e5:	e8 69 0a 00 00       	call   800b53 <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 df 44 80 00       	push   $0x8044df
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
  800134:	e8 63 20 00 00       	call   80219c <sys_unlock_cons>
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
  8001da:	68 e8 44 80 00       	push   $0x8044e8
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
  800204:	68 1c 45 80 00       	push   $0x80451c
  800209:	6a 4d                	push   $0x4d
  80020b:	68 3e 45 80 00       	push   $0x80453e
  800210:	e8 81 06 00 00       	call   800896 <_panic>
		else
		{
			//sys_lock_cons();
			sys_lock_cons();
  800215:	e8 68 1f 00 00       	call   802182 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 5c 45 80 00       	push   $0x80455c
  800222:	e8 2c 09 00 00       	call   800b53 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 90 45 80 00       	push   $0x804590
  800232:	e8 1c 09 00 00       	call   800b53 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 c4 45 80 00       	push   $0x8045c4
  800242:	e8 0c 09 00 00       	call   800b53 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  80024a:	e8 4d 1f 00 00       	call   80219c <sys_unlock_cons>
			//sys_unlock_cons();
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 d0 1a 00 00       	call   801d2a <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  80025d:	e8 20 1f 00 00       	call   802182 <sys_lock_cons>
		{
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 42                	jmp    8002aa <_main+0x272>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 f6 45 80 00       	push   $0x8045f6
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
  8002b6:	e8 e1 1e 00 00       	call   80219c <sys_unlock_cons>
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
  80044a:	68 40 44 80 00       	push   $0x804440
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
  80046c:	68 14 46 80 00       	push   $0x804614
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
  80049a:	68 19 46 80 00       	push   $0x804619
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
  80072f:	e8 99 1b 00 00       	call   8022cd <sys_cputc>
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
  800740:	e8 24 1a 00 00       	call   802169 <sys_cgetc>
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
  80075d:	e8 9c 1c 00 00       	call   8023fe <sys_getenvindex>
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
  8007cb:	e8 b2 19 00 00       	call   802182 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8007d0:	83 ec 0c             	sub    $0xc,%esp
  8007d3:	68 38 46 80 00       	push   $0x804638
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
  8007fb:	68 60 46 80 00       	push   $0x804660
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
  80082c:	68 88 46 80 00       	push   $0x804688
  800831:	e8 1d 03 00 00       	call   800b53 <cprintf>
  800836:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800839:	a1 24 50 80 00       	mov    0x805024,%eax
  80083e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	50                   	push   %eax
  800848:	68 e0 46 80 00       	push   $0x8046e0
  80084d:	e8 01 03 00 00       	call   800b53 <cprintf>
  800852:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800855:	83 ec 0c             	sub    $0xc,%esp
  800858:	68 38 46 80 00       	push   $0x804638
  80085d:	e8 f1 02 00 00       	call   800b53 <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800865:	e8 32 19 00 00       	call   80219c <sys_unlock_cons>
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
  80087d:	e8 48 1b 00 00       	call   8023ca <sys_destroy_env>
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
  80088e:	e8 9d 1b 00 00       	call   802430 <sys_exit_env>
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
  8008a5:	a1 54 50 80 00       	mov    0x805054,%eax
  8008aa:	85 c0                	test   %eax,%eax
  8008ac:	74 16                	je     8008c4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008ae:	a1 54 50 80 00       	mov    0x805054,%eax
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	50                   	push   %eax
  8008b7:	68 f4 46 80 00       	push   $0x8046f4
  8008bc:	e8 92 02 00 00       	call   800b53 <cprintf>
  8008c1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008c4:	a1 00 50 80 00       	mov    0x805000,%eax
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	ff 75 08             	pushl  0x8(%ebp)
  8008cf:	50                   	push   %eax
  8008d0:	68 f9 46 80 00       	push   $0x8046f9
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
  8008f4:	68 15 47 80 00       	push   $0x804715
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
  800923:	68 18 47 80 00       	push   $0x804718
  800928:	6a 26                	push   $0x26
  80092a:	68 64 47 80 00       	push   $0x804764
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
  8009f8:	68 70 47 80 00       	push   $0x804770
  8009fd:	6a 3a                	push   $0x3a
  8009ff:	68 64 47 80 00       	push   $0x804764
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
  800a6b:	68 c4 47 80 00       	push   $0x8047c4
  800a70:	6a 44                	push   $0x44
  800a72:	68 64 47 80 00       	push   $0x804764
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
  800aaa:	a0 30 50 80 00       	mov    0x805030,%al
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
  800ac5:	e8 76 16 00 00       	call   802140 <sys_cputs>
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
  800b1f:	a0 30 50 80 00       	mov    0x805030,%al
  800b24:	0f b6 c0             	movzbl %al,%eax
  800b27:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b2d:	83 ec 04             	sub    $0x4,%esp
  800b30:	50                   	push   %eax
  800b31:	52                   	push   %edx
  800b32:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b38:	83 c0 08             	add    $0x8,%eax
  800b3b:	50                   	push   %eax
  800b3c:	e8 ff 15 00 00       	call   802140 <sys_cputs>
  800b41:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b44:	c6 05 30 50 80 00 00 	movb   $0x0,0x805030
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
  800b59:	c6 05 30 50 80 00 01 	movb   $0x1,0x805030
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
  800b86:	e8 f7 15 00 00       	call   802182 <sys_lock_cons>
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
  800ba6:	e8 f1 15 00 00       	call   80219c <sys_unlock_cons>
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
  800bf0:	e8 e3 35 00 00       	call   8041d8 <__udivdi3>
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
  800c40:	e8 a3 36 00 00       	call   8042e8 <__umoddi3>
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	05 34 4a 80 00       	add    $0x804a34,%eax
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
  800d9b:	8b 04 85 58 4a 80 00 	mov    0x804a58(,%eax,4),%eax
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
  800e7c:	8b 34 9d a0 48 80 00 	mov    0x8048a0(,%ebx,4),%esi
  800e83:	85 f6                	test   %esi,%esi
  800e85:	75 19                	jne    800ea0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e87:	53                   	push   %ebx
  800e88:	68 45 4a 80 00       	push   $0x804a45
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
  800ea1:	68 4e 4a 80 00       	push   $0x804a4e
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
  800ece:	be 51 4a 80 00       	mov    $0x804a51,%esi
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
  8010c6:	c6 05 30 50 80 00 00 	movb   $0x0,0x805030
			break;
  8010cd:	eb 2c                	jmp    8010fb <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010cf:	c6 05 30 50 80 00 01 	movb   $0x1,0x805030
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
  8011f9:	68 c8 4b 80 00       	push   $0x804bc8
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
  80123b:	68 cb 4b 80 00       	push   $0x804bcb
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
  8012ec:	e8 91 0e 00 00       	call   802182 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f5:	74 13                	je     80130a <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012f7:	83 ec 08             	sub    $0x8,%esp
  8012fa:	ff 75 08             	pushl  0x8(%ebp)
  8012fd:	68 c8 4b 80 00       	push   $0x804bc8
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
  80133f:	68 cb 4b 80 00       	push   $0x804bcb
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
  8013e7:	e8 b0 0d 00 00       	call   80219c <sys_unlock_cons>
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
  801ae1:	68 dc 4b 80 00       	push   $0x804bdc
  801ae6:	68 3f 01 00 00       	push   $0x13f
  801aeb:	68 fe 4b 80 00       	push   $0x804bfe
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
  801b01:	e8 e5 0b 00 00       	call   8026eb <sys_sbrk>
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
  801b7c:	e8 ee 09 00 00       	call   80256f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b81:	85 c0                	test   %eax,%eax
  801b83:	74 16                	je     801b9b <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b85:	83 ec 0c             	sub    $0xc,%esp
  801b88:	ff 75 08             	pushl  0x8(%ebp)
  801b8b:	e8 2e 0f 00 00       	call   802abe <alloc_block_FF>
  801b90:	83 c4 10             	add    $0x10,%esp
  801b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b96:	e9 8a 01 00 00       	jmp    801d25 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b9b:	e8 00 0a 00 00       	call   8025a0 <sys_isUHeapPlacementStrategyBESTFIT>
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	0f 84 7d 01 00 00    	je     801d25 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801ba8:	83 ec 0c             	sub    $0xc,%esp
  801bab:	ff 75 08             	pushl  0x8(%ebp)
  801bae:	e8 c7 13 00 00       	call   802f7a <alloc_block_BF>
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
  801bfe:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801c4b:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801ca2:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  801d04:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801d0b:	83 ec 08             	sub    $0x8,%esp
  801d0e:	ff 75 08             	pushl  0x8(%ebp)
  801d11:	ff 75 f0             	pushl  -0x10(%ebp)
  801d14:	e8 09 0a 00 00       	call   802722 <sys_allocate_user_mem>
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
  801d5c:	e8 dd 09 00 00       	call   80273e <get_block_size>
  801d61:	83 c4 10             	add    $0x10,%esp
  801d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d67:	83 ec 0c             	sub    $0xc,%esp
  801d6a:	ff 75 08             	pushl  0x8(%ebp)
  801d6d:	e8 10 1c 00 00       	call   803982 <free_block>
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
  801da7:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
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
  801de4:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801deb:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801def:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	83 ec 08             	sub    $0x8,%esp
  801df8:	52                   	push   %edx
  801df9:	50                   	push   %eax
  801dfa:	e8 07 09 00 00       	call   802706 <sys_free_user_mem>
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
  801e12:	68 0c 4c 80 00       	push   $0x804c0c
  801e17:	68 88 00 00 00       	push   $0x88
  801e1c:	68 36 4c 80 00       	push   $0x804c36
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
  801e40:	e9 ec 00 00 00       	jmp    801f31 <smalloc+0x108>
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
  801e71:	75 0a                	jne    801e7d <smalloc+0x54>
  801e73:	b8 00 00 00 00       	mov    $0x0,%eax
  801e78:	e9 b4 00 00 00       	jmp    801f31 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e7d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e81:	ff 75 ec             	pushl  -0x14(%ebp)
  801e84:	50                   	push   %eax
  801e85:	ff 75 0c             	pushl  0xc(%ebp)
  801e88:	ff 75 08             	pushl  0x8(%ebp)
  801e8b:	e8 7d 04 00 00       	call   80230d <sys_createSharedObject>
  801e90:	83 c4 10             	add    $0x10,%esp
  801e93:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e96:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e9a:	74 06                	je     801ea2 <smalloc+0x79>
  801e9c:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801ea0:	75 0a                	jne    801eac <smalloc+0x83>
  801ea2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea7:	e9 85 00 00 00       	jmp    801f31 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801eac:	83 ec 08             	sub    $0x8,%esp
  801eaf:	ff 75 ec             	pushl  -0x14(%ebp)
  801eb2:	68 42 4c 80 00       	push   $0x804c42
  801eb7:	e8 97 ec ff ff       	call   800b53 <cprintf>
  801ebc:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801ebf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ec2:	a1 24 50 80 00       	mov    0x805024,%eax
  801ec7:	8b 40 78             	mov    0x78(%eax),%eax
  801eca:	29 c2                	sub    %eax,%edx
  801ecc:	89 d0                	mov    %edx,%eax
  801ece:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ed3:	c1 e8 0c             	shr    $0xc,%eax
  801ed6:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801edc:	42                   	inc    %edx
  801edd:	89 15 28 50 80 00    	mov    %edx,0x805028
  801ee3:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801ee9:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801ef0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ef3:	a1 24 50 80 00       	mov    0x805024,%eax
  801ef8:	8b 40 78             	mov    0x78(%eax),%eax
  801efb:	29 c2                	sub    %eax,%edx
  801efd:	89 d0                	mov    %edx,%eax
  801eff:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f04:	c1 e8 0c             	shr    $0xc,%eax
  801f07:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801f0e:	a1 24 50 80 00       	mov    0x805024,%eax
  801f13:	8b 50 10             	mov    0x10(%eax),%edx
  801f16:	89 c8                	mov    %ecx,%eax
  801f18:	c1 e0 02             	shl    $0x2,%eax
  801f1b:	89 c1                	mov    %eax,%ecx
  801f1d:	c1 e1 09             	shl    $0x9,%ecx
  801f20:	01 c8                	add    %ecx,%eax
  801f22:	01 c2                	add    %eax,%edx
  801f24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f27:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801f2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f39:	83 ec 08             	sub    $0x8,%esp
  801f3c:	ff 75 0c             	pushl  0xc(%ebp)
  801f3f:	ff 75 08             	pushl  0x8(%ebp)
  801f42:	e8 f0 03 00 00       	call   802337 <sys_getSizeOfSharedObject>
  801f47:	83 c4 10             	add    $0x10,%esp
  801f4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801f4d:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801f51:	75 0a                	jne    801f5d <sget+0x2a>
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
  801f58:	e9 e7 00 00 00       	jmp    802044 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f63:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f70:	39 d0                	cmp    %edx,%eax
  801f72:	73 02                	jae    801f76 <sget+0x43>
  801f74:	89 d0                	mov    %edx,%eax
  801f76:	83 ec 0c             	sub    $0xc,%esp
  801f79:	50                   	push   %eax
  801f7a:	e8 8c fb ff ff       	call   801b0b <malloc>
  801f7f:	83 c4 10             	add    $0x10,%esp
  801f82:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801f85:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f89:	75 0a                	jne    801f95 <sget+0x62>
  801f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f90:	e9 af 00 00 00       	jmp    802044 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801f95:	83 ec 04             	sub    $0x4,%esp
  801f98:	ff 75 e8             	pushl  -0x18(%ebp)
  801f9b:	ff 75 0c             	pushl  0xc(%ebp)
  801f9e:	ff 75 08             	pushl  0x8(%ebp)
  801fa1:	e8 ae 03 00 00       	call   802354 <sys_getSharedObject>
  801fa6:	83 c4 10             	add    $0x10,%esp
  801fa9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801fac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801faf:	a1 24 50 80 00       	mov    0x805024,%eax
  801fb4:	8b 40 78             	mov    0x78(%eax),%eax
  801fb7:	29 c2                	sub    %eax,%edx
  801fb9:	89 d0                	mov    %edx,%eax
  801fbb:	2d 00 10 00 00       	sub    $0x1000,%eax
  801fc0:	c1 e8 0c             	shr    $0xc,%eax
  801fc3:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801fc9:	42                   	inc    %edx
  801fca:	89 15 28 50 80 00    	mov    %edx,0x805028
  801fd0:	8b 15 28 50 80 00    	mov    0x805028,%edx
  801fd6:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801fdd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fe0:	a1 24 50 80 00       	mov    0x805024,%eax
  801fe5:	8b 40 78             	mov    0x78(%eax),%eax
  801fe8:	29 c2                	sub    %eax,%edx
  801fea:	89 d0                	mov    %edx,%eax
  801fec:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ff1:	c1 e8 0c             	shr    $0xc,%eax
  801ff4:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801ffb:	a1 24 50 80 00       	mov    0x805024,%eax
  802000:	8b 50 10             	mov    0x10(%eax),%edx
  802003:	89 c8                	mov    %ecx,%eax
  802005:	c1 e0 02             	shl    $0x2,%eax
  802008:	89 c1                	mov    %eax,%ecx
  80200a:	c1 e1 09             	shl    $0x9,%ecx
  80200d:	01 c8                	add    %ecx,%eax
  80200f:	01 c2                	add    %eax,%edx
  802011:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802014:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  80201b:	a1 24 50 80 00       	mov    0x805024,%eax
  802020:	8b 40 10             	mov    0x10(%eax),%eax
  802023:	83 ec 08             	sub    $0x8,%esp
  802026:	50                   	push   %eax
  802027:	68 51 4c 80 00       	push   $0x804c51
  80202c:	e8 22 eb ff ff       	call   800b53 <cprintf>
  802031:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802034:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802038:	75 07                	jne    802041 <sget+0x10e>
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	eb 03                	jmp    802044 <sget+0x111>
	return ptr;
  802041:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  80204c:	8b 55 08             	mov    0x8(%ebp),%edx
  80204f:	a1 24 50 80 00       	mov    0x805024,%eax
  802054:	8b 40 78             	mov    0x78(%eax),%eax
  802057:	29 c2                	sub    %eax,%edx
  802059:	89 d0                	mov    %edx,%eax
  80205b:	2d 00 10 00 00       	sub    $0x1000,%eax
  802060:	c1 e8 0c             	shr    $0xc,%eax
  802063:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  80206a:	a1 24 50 80 00       	mov    0x805024,%eax
  80206f:	8b 50 10             	mov    0x10(%eax),%edx
  802072:	89 c8                	mov    %ecx,%eax
  802074:	c1 e0 02             	shl    $0x2,%eax
  802077:	89 c1                	mov    %eax,%ecx
  802079:	c1 e1 09             	shl    $0x9,%ecx
  80207c:	01 c8                	add    %ecx,%eax
  80207e:	01 d0                	add    %edx,%eax
  802080:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  802087:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80208a:	83 ec 08             	sub    $0x8,%esp
  80208d:	ff 75 08             	pushl  0x8(%ebp)
  802090:	ff 75 f4             	pushl  -0xc(%ebp)
  802093:	e8 db 02 00 00       	call   802373 <sys_freeSharedObject>
  802098:	83 c4 10             	add    $0x10,%esp
  80209b:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80209e:	90                   	nop
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8020a7:	83 ec 04             	sub    $0x4,%esp
  8020aa:	68 60 4c 80 00       	push   $0x804c60
  8020af:	68 e5 00 00 00       	push   $0xe5
  8020b4:	68 36 4c 80 00       	push   $0x804c36
  8020b9:	e8 d8 e7 ff ff       	call   800896 <_panic>

008020be <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
  8020c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020c4:	83 ec 04             	sub    $0x4,%esp
  8020c7:	68 86 4c 80 00       	push   $0x804c86
  8020cc:	68 f1 00 00 00       	push   $0xf1
  8020d1:	68 36 4c 80 00       	push   $0x804c36
  8020d6:	e8 bb e7 ff ff       	call   800896 <_panic>

008020db <shrink>:

}
void shrink(uint32 newSize)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020e1:	83 ec 04             	sub    $0x4,%esp
  8020e4:	68 86 4c 80 00       	push   $0x804c86
  8020e9:	68 f6 00 00 00       	push   $0xf6
  8020ee:	68 36 4c 80 00       	push   $0x804c36
  8020f3:	e8 9e e7 ff ff       	call   800896 <_panic>

008020f8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
  8020fb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020fe:	83 ec 04             	sub    $0x4,%esp
  802101:	68 86 4c 80 00       	push   $0x804c86
  802106:	68 fb 00 00 00       	push   $0xfb
  80210b:	68 36 4c 80 00       	push   $0x804c36
  802110:	e8 81 e7 ff ff       	call   800896 <_panic>

00802115 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	57                   	push   %edi
  802119:	56                   	push   %esi
  80211a:	53                   	push   %ebx
  80211b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80211e:	8b 45 08             	mov    0x8(%ebp),%eax
  802121:	8b 55 0c             	mov    0xc(%ebp),%edx
  802124:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802127:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80212a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80212d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802130:	cd 30                	int    $0x30
  802132:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802135:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802138:	83 c4 10             	add    $0x10,%esp
  80213b:	5b                   	pop    %ebx
  80213c:	5e                   	pop    %esi
  80213d:	5f                   	pop    %edi
  80213e:	5d                   	pop    %ebp
  80213f:	c3                   	ret    

00802140 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 04             	sub    $0x4,%esp
  802146:	8b 45 10             	mov    0x10(%ebp),%eax
  802149:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80214c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	52                   	push   %edx
  802158:	ff 75 0c             	pushl  0xc(%ebp)
  80215b:	50                   	push   %eax
  80215c:	6a 00                	push   $0x0
  80215e:	e8 b2 ff ff ff       	call   802115 <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
}
  802166:	90                   	nop
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <sys_cgetc>:

int
sys_cgetc(void)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 02                	push   $0x2
  802178:	e8 98 ff ff ff       	call   802115 <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 03                	push   $0x3
  802191:	e8 7f ff ff ff       	call   802115 <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
}
  802199:	90                   	nop
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 04                	push   $0x4
  8021ab:	e8 65 ff ff ff       	call   802115 <syscall>
  8021b0:	83 c4 18             	add    $0x18,%esp
}
  8021b3:	90                   	nop
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8021b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	52                   	push   %edx
  8021c6:	50                   	push   %eax
  8021c7:	6a 08                	push   $0x8
  8021c9:	e8 47 ff ff ff       	call   802115 <syscall>
  8021ce:	83 c4 18             	add    $0x18,%esp
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	56                   	push   %esi
  8021d7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021d8:	8b 75 18             	mov    0x18(%ebp),%esi
  8021db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	56                   	push   %esi
  8021e8:	53                   	push   %ebx
  8021e9:	51                   	push   %ecx
  8021ea:	52                   	push   %edx
  8021eb:	50                   	push   %eax
  8021ec:	6a 09                	push   $0x9
  8021ee:	e8 22 ff ff ff       	call   802115 <syscall>
  8021f3:	83 c4 18             	add    $0x18,%esp
}
  8021f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021f9:	5b                   	pop    %ebx
  8021fa:	5e                   	pop    %esi
  8021fb:	5d                   	pop    %ebp
  8021fc:	c3                   	ret    

008021fd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802200:	8b 55 0c             	mov    0xc(%ebp),%edx
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	52                   	push   %edx
  80220d:	50                   	push   %eax
  80220e:	6a 0a                	push   $0xa
  802210:	e8 00 ff ff ff       	call   802115 <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	ff 75 0c             	pushl  0xc(%ebp)
  802226:	ff 75 08             	pushl  0x8(%ebp)
  802229:	6a 0b                	push   $0xb
  80222b:	e8 e5 fe ff ff       	call   802115 <syscall>
  802230:	83 c4 18             	add    $0x18,%esp
}
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 0c                	push   $0xc
  802244:	e8 cc fe ff ff       	call   802115 <syscall>
  802249:	83 c4 18             	add    $0x18,%esp
}
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 0d                	push   $0xd
  80225d:	e8 b3 fe ff ff       	call   802115 <syscall>
  802262:	83 c4 18             	add    $0x18,%esp
}
  802265:	c9                   	leave  
  802266:	c3                   	ret    

00802267 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 0e                	push   $0xe
  802276:	e8 9a fe ff ff       	call   802115 <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 0f                	push   $0xf
  80228f:	e8 81 fe ff ff       	call   802115 <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	ff 75 08             	pushl  0x8(%ebp)
  8022a7:	6a 10                	push   $0x10
  8022a9:	e8 67 fe ff ff       	call   802115 <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 11                	push   $0x11
  8022c2:	e8 4e fe ff ff       	call   802115 <syscall>
  8022c7:	83 c4 18             	add    $0x18,%esp
}
  8022ca:	90                   	nop
  8022cb:	c9                   	leave  
  8022cc:	c3                   	ret    

008022cd <sys_cputc>:

void
sys_cputc(const char c)
{
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
  8022d0:	83 ec 04             	sub    $0x4,%esp
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022d9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	50                   	push   %eax
  8022e6:	6a 01                	push   $0x1
  8022e8:	e8 28 fe ff ff       	call   802115 <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
}
  8022f0:	90                   	nop
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 14                	push   $0x14
  802302:	e8 0e fe ff ff       	call   802115 <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
}
  80230a:	90                   	nop
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 04             	sub    $0x4,%esp
  802313:	8b 45 10             	mov    0x10(%ebp),%eax
  802316:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802319:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80231c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	6a 00                	push   $0x0
  802325:	51                   	push   %ecx
  802326:	52                   	push   %edx
  802327:	ff 75 0c             	pushl  0xc(%ebp)
  80232a:	50                   	push   %eax
  80232b:	6a 15                	push   $0x15
  80232d:	e8 e3 fd ff ff       	call   802115 <syscall>
  802332:	83 c4 18             	add    $0x18,%esp
}
  802335:	c9                   	leave  
  802336:	c3                   	ret    

00802337 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80233a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233d:	8b 45 08             	mov    0x8(%ebp),%eax
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	52                   	push   %edx
  802347:	50                   	push   %eax
  802348:	6a 16                	push   $0x16
  80234a:	e8 c6 fd ff ff       	call   802115 <syscall>
  80234f:	83 c4 18             	add    $0x18,%esp
}
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802357:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80235a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	51                   	push   %ecx
  802365:	52                   	push   %edx
  802366:	50                   	push   %eax
  802367:	6a 17                	push   $0x17
  802369:	e8 a7 fd ff ff       	call   802115 <syscall>
  80236e:	83 c4 18             	add    $0x18,%esp
}
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802376:	8b 55 0c             	mov    0xc(%ebp),%edx
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	52                   	push   %edx
  802383:	50                   	push   %eax
  802384:	6a 18                	push   $0x18
  802386:	e8 8a fd ff ff       	call   802115 <syscall>
  80238b:	83 c4 18             	add    $0x18,%esp
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	6a 00                	push   $0x0
  802398:	ff 75 14             	pushl  0x14(%ebp)
  80239b:	ff 75 10             	pushl  0x10(%ebp)
  80239e:	ff 75 0c             	pushl  0xc(%ebp)
  8023a1:	50                   	push   %eax
  8023a2:	6a 19                	push   $0x19
  8023a4:	e8 6c fd ff ff       	call   802115 <syscall>
  8023a9:	83 c4 18             	add    $0x18,%esp
}
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <sys_run_env>:

void sys_run_env(int32 envId)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	50                   	push   %eax
  8023bd:	6a 1a                	push   $0x1a
  8023bf:	e8 51 fd ff ff       	call   802115 <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
}
  8023c7:	90                   	nop
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	50                   	push   %eax
  8023d9:	6a 1b                	push   $0x1b
  8023db:	e8 35 fd ff ff       	call   802115 <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 05                	push   $0x5
  8023f4:	e8 1c fd ff ff       	call   802115 <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 06                	push   $0x6
  80240d:	e8 03 fd ff ff       	call   802115 <syscall>
  802412:	83 c4 18             	add    $0x18,%esp
}
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 07                	push   $0x7
  802426:	e8 ea fc ff ff       	call   802115 <syscall>
  80242b:	83 c4 18             	add    $0x18,%esp
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <sys_exit_env>:


void sys_exit_env(void)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 1c                	push   $0x1c
  80243f:	e8 d1 fc ff ff       	call   802115 <syscall>
  802444:	83 c4 18             	add    $0x18,%esp
}
  802447:	90                   	nop
  802448:	c9                   	leave  
  802449:	c3                   	ret    

0080244a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
  80244d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802450:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802453:	8d 50 04             	lea    0x4(%eax),%edx
  802456:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	52                   	push   %edx
  802460:	50                   	push   %eax
  802461:	6a 1d                	push   $0x1d
  802463:	e8 ad fc ff ff       	call   802115 <syscall>
  802468:	83 c4 18             	add    $0x18,%esp
	return result;
  80246b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80246e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802471:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802474:	89 01                	mov    %eax,(%ecx)
  802476:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	c9                   	leave  
  80247d:	c2 04 00             	ret    $0x4

00802480 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	ff 75 10             	pushl  0x10(%ebp)
  80248a:	ff 75 0c             	pushl  0xc(%ebp)
  80248d:	ff 75 08             	pushl  0x8(%ebp)
  802490:	6a 13                	push   $0x13
  802492:	e8 7e fc ff ff       	call   802115 <syscall>
  802497:	83 c4 18             	add    $0x18,%esp
	return ;
  80249a:	90                   	nop
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    

0080249d <sys_rcr2>:
uint32 sys_rcr2()
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 1e                	push   $0x1e
  8024ac:	e8 64 fc ff ff       	call   802115 <syscall>
  8024b1:	83 c4 18             	add    $0x18,%esp
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	83 ec 04             	sub    $0x4,%esp
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024c2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	50                   	push   %eax
  8024cf:	6a 1f                	push   $0x1f
  8024d1:	e8 3f fc ff ff       	call   802115 <syscall>
  8024d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d9:	90                   	nop
}
  8024da:	c9                   	leave  
  8024db:	c3                   	ret    

008024dc <rsttst>:
void rsttst()
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 21                	push   $0x21
  8024eb:	e8 25 fc ff ff       	call   802115 <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f3:	90                   	nop
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
  8024f9:	83 ec 04             	sub    $0x4,%esp
  8024fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802502:	8b 55 18             	mov    0x18(%ebp),%edx
  802505:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802509:	52                   	push   %edx
  80250a:	50                   	push   %eax
  80250b:	ff 75 10             	pushl  0x10(%ebp)
  80250e:	ff 75 0c             	pushl  0xc(%ebp)
  802511:	ff 75 08             	pushl  0x8(%ebp)
  802514:	6a 20                	push   $0x20
  802516:	e8 fa fb ff ff       	call   802115 <syscall>
  80251b:	83 c4 18             	add    $0x18,%esp
	return ;
  80251e:	90                   	nop
}
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <chktst>:
void chktst(uint32 n)
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	ff 75 08             	pushl  0x8(%ebp)
  80252f:	6a 22                	push   $0x22
  802531:	e8 df fb ff ff       	call   802115 <syscall>
  802536:	83 c4 18             	add    $0x18,%esp
	return ;
  802539:	90                   	nop
}
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    

0080253c <inctst>:

void inctst()
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 23                	push   $0x23
  80254b:	e8 c5 fb ff ff       	call   802115 <syscall>
  802550:	83 c4 18             	add    $0x18,%esp
	return ;
  802553:	90                   	nop
}
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <gettst>:
uint32 gettst()
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 24                	push   $0x24
  802565:	e8 ab fb ff ff       	call   802115 <syscall>
  80256a:	83 c4 18             	add    $0x18,%esp
}
  80256d:	c9                   	leave  
  80256e:	c3                   	ret    

0080256f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80256f:	55                   	push   %ebp
  802570:	89 e5                	mov    %esp,%ebp
  802572:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 25                	push   $0x25
  802581:	e8 8f fb ff ff       	call   802115 <syscall>
  802586:	83 c4 18             	add    $0x18,%esp
  802589:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80258c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802590:	75 07                	jne    802599 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802592:	b8 01 00 00 00       	mov    $0x1,%eax
  802597:	eb 05                	jmp    80259e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802599:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80259e:	c9                   	leave  
  80259f:	c3                   	ret    

008025a0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
  8025a3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 25                	push   $0x25
  8025b2:	e8 5e fb ff ff       	call   802115 <syscall>
  8025b7:	83 c4 18             	add    $0x18,%esp
  8025ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025bd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025c1:	75 07                	jne    8025ca <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c8:	eb 05                	jmp    8025cf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
  8025d4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 25                	push   $0x25
  8025e3:	e8 2d fb ff ff       	call   802115 <syscall>
  8025e8:	83 c4 18             	add    $0x18,%esp
  8025eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025ee:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025f2:	75 07                	jne    8025fb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f9:	eb 05                	jmp    802600 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802600:	c9                   	leave  
  802601:	c3                   	ret    

00802602 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 25                	push   $0x25
  802614:	e8 fc fa ff ff       	call   802115 <syscall>
  802619:	83 c4 18             	add    $0x18,%esp
  80261c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80261f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802623:	75 07                	jne    80262c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802625:	b8 01 00 00 00       	mov    $0x1,%eax
  80262a:	eb 05                	jmp    802631 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802631:	c9                   	leave  
  802632:	c3                   	ret    

00802633 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	ff 75 08             	pushl  0x8(%ebp)
  802641:	6a 26                	push   $0x26
  802643:	e8 cd fa ff ff       	call   802115 <syscall>
  802648:	83 c4 18             	add    $0x18,%esp
	return ;
  80264b:	90                   	nop
}
  80264c:	c9                   	leave  
  80264d:	c3                   	ret    

0080264e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80264e:	55                   	push   %ebp
  80264f:	89 e5                	mov    %esp,%ebp
  802651:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802652:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802655:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80265b:	8b 45 08             	mov    0x8(%ebp),%eax
  80265e:	6a 00                	push   $0x0
  802660:	53                   	push   %ebx
  802661:	51                   	push   %ecx
  802662:	52                   	push   %edx
  802663:	50                   	push   %eax
  802664:	6a 27                	push   $0x27
  802666:	e8 aa fa ff ff       	call   802115 <syscall>
  80266b:	83 c4 18             	add    $0x18,%esp
}
  80266e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802676:	8b 55 0c             	mov    0xc(%ebp),%edx
  802679:	8b 45 08             	mov    0x8(%ebp),%eax
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	52                   	push   %edx
  802683:	50                   	push   %eax
  802684:	6a 28                	push   $0x28
  802686:	e8 8a fa ff ff       	call   802115 <syscall>
  80268b:	83 c4 18             	add    $0x18,%esp
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802693:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802696:	8b 55 0c             	mov    0xc(%ebp),%edx
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	6a 00                	push   $0x0
  80269e:	51                   	push   %ecx
  80269f:	ff 75 10             	pushl  0x10(%ebp)
  8026a2:	52                   	push   %edx
  8026a3:	50                   	push   %eax
  8026a4:	6a 29                	push   $0x29
  8026a6:	e8 6a fa ff ff       	call   802115 <syscall>
  8026ab:	83 c4 18             	add    $0x18,%esp
}
  8026ae:	c9                   	leave  
  8026af:	c3                   	ret    

008026b0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	ff 75 10             	pushl  0x10(%ebp)
  8026ba:	ff 75 0c             	pushl  0xc(%ebp)
  8026bd:	ff 75 08             	pushl  0x8(%ebp)
  8026c0:	6a 12                	push   $0x12
  8026c2:	e8 4e fa ff ff       	call   802115 <syscall>
  8026c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ca:	90                   	nop
}
  8026cb:	c9                   	leave  
  8026cc:	c3                   	ret    

008026cd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8026cd:	55                   	push   %ebp
  8026ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8026d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	52                   	push   %edx
  8026dd:	50                   	push   %eax
  8026de:	6a 2a                	push   $0x2a
  8026e0:	e8 30 fa ff ff       	call   802115 <syscall>
  8026e5:	83 c4 18             	add    $0x18,%esp
	return;
  8026e8:	90                   	nop
}
  8026e9:	c9                   	leave  
  8026ea:	c3                   	ret    

008026eb <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8026ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f1:	6a 00                	push   $0x0
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 00                	push   $0x0
  8026f9:	50                   	push   %eax
  8026fa:	6a 2b                	push   $0x2b
  8026fc:	e8 14 fa ff ff       	call   802115 <syscall>
  802701:	83 c4 18             	add    $0x18,%esp
}
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	6a 00                	push   $0x0
  80270f:	ff 75 0c             	pushl  0xc(%ebp)
  802712:	ff 75 08             	pushl  0x8(%ebp)
  802715:	6a 2c                	push   $0x2c
  802717:	e8 f9 f9 ff ff       	call   802115 <syscall>
  80271c:	83 c4 18             	add    $0x18,%esp
	return;
  80271f:	90                   	nop
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	ff 75 0c             	pushl  0xc(%ebp)
  80272e:	ff 75 08             	pushl  0x8(%ebp)
  802731:	6a 2d                	push   $0x2d
  802733:	e8 dd f9 ff ff       	call   802115 <syscall>
  802738:	83 c4 18             	add    $0x18,%esp
	return;
  80273b:	90                   	nop
}
  80273c:	c9                   	leave  
  80273d:	c3                   	ret    

0080273e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
  802741:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802744:	8b 45 08             	mov    0x8(%ebp),%eax
  802747:	83 e8 04             	sub    $0x4,%eax
  80274a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80274d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802750:	8b 00                	mov    (%eax),%eax
  802752:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802755:	c9                   	leave  
  802756:	c3                   	ret    

00802757 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
  80275a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80275d:	8b 45 08             	mov    0x8(%ebp),%eax
  802760:	83 e8 04             	sub    $0x4,%eax
  802763:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802766:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802769:	8b 00                	mov    (%eax),%eax
  80276b:	83 e0 01             	and    $0x1,%eax
  80276e:	85 c0                	test   %eax,%eax
  802770:	0f 94 c0             	sete   %al
}
  802773:	c9                   	leave  
  802774:	c3                   	ret    

00802775 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802775:	55                   	push   %ebp
  802776:	89 e5                	mov    %esp,%ebp
  802778:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80277b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802782:	8b 45 0c             	mov    0xc(%ebp),%eax
  802785:	83 f8 02             	cmp    $0x2,%eax
  802788:	74 2b                	je     8027b5 <alloc_block+0x40>
  80278a:	83 f8 02             	cmp    $0x2,%eax
  80278d:	7f 07                	jg     802796 <alloc_block+0x21>
  80278f:	83 f8 01             	cmp    $0x1,%eax
  802792:	74 0e                	je     8027a2 <alloc_block+0x2d>
  802794:	eb 58                	jmp    8027ee <alloc_block+0x79>
  802796:	83 f8 03             	cmp    $0x3,%eax
  802799:	74 2d                	je     8027c8 <alloc_block+0x53>
  80279b:	83 f8 04             	cmp    $0x4,%eax
  80279e:	74 3b                	je     8027db <alloc_block+0x66>
  8027a0:	eb 4c                	jmp    8027ee <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8027a2:	83 ec 0c             	sub    $0xc,%esp
  8027a5:	ff 75 08             	pushl  0x8(%ebp)
  8027a8:	e8 11 03 00 00       	call   802abe <alloc_block_FF>
  8027ad:	83 c4 10             	add    $0x10,%esp
  8027b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027b3:	eb 4a                	jmp    8027ff <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8027b5:	83 ec 0c             	sub    $0xc,%esp
  8027b8:	ff 75 08             	pushl  0x8(%ebp)
  8027bb:	e8 fa 19 00 00       	call   8041ba <alloc_block_NF>
  8027c0:	83 c4 10             	add    $0x10,%esp
  8027c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027c6:	eb 37                	jmp    8027ff <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8027c8:	83 ec 0c             	sub    $0xc,%esp
  8027cb:	ff 75 08             	pushl  0x8(%ebp)
  8027ce:	e8 a7 07 00 00       	call   802f7a <alloc_block_BF>
  8027d3:	83 c4 10             	add    $0x10,%esp
  8027d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027d9:	eb 24                	jmp    8027ff <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8027db:	83 ec 0c             	sub    $0xc,%esp
  8027de:	ff 75 08             	pushl  0x8(%ebp)
  8027e1:	e8 b7 19 00 00       	call   80419d <alloc_block_WF>
  8027e6:	83 c4 10             	add    $0x10,%esp
  8027e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8027ec:	eb 11                	jmp    8027ff <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8027ee:	83 ec 0c             	sub    $0xc,%esp
  8027f1:	68 98 4c 80 00       	push   $0x804c98
  8027f6:	e8 58 e3 ff ff       	call   800b53 <cprintf>
  8027fb:	83 c4 10             	add    $0x10,%esp
		break;
  8027fe:	90                   	nop
	}
	return va;
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802802:	c9                   	leave  
  802803:	c3                   	ret    

00802804 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802804:	55                   	push   %ebp
  802805:	89 e5                	mov    %esp,%ebp
  802807:	53                   	push   %ebx
  802808:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80280b:	83 ec 0c             	sub    $0xc,%esp
  80280e:	68 b8 4c 80 00       	push   $0x804cb8
  802813:	e8 3b e3 ff ff       	call   800b53 <cprintf>
  802818:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80281b:	83 ec 0c             	sub    $0xc,%esp
  80281e:	68 e3 4c 80 00       	push   $0x804ce3
  802823:	e8 2b e3 ff ff       	call   800b53 <cprintf>
  802828:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802831:	eb 37                	jmp    80286a <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802833:	83 ec 0c             	sub    $0xc,%esp
  802836:	ff 75 f4             	pushl  -0xc(%ebp)
  802839:	e8 19 ff ff ff       	call   802757 <is_free_block>
  80283e:	83 c4 10             	add    $0x10,%esp
  802841:	0f be d8             	movsbl %al,%ebx
  802844:	83 ec 0c             	sub    $0xc,%esp
  802847:	ff 75 f4             	pushl  -0xc(%ebp)
  80284a:	e8 ef fe ff ff       	call   80273e <get_block_size>
  80284f:	83 c4 10             	add    $0x10,%esp
  802852:	83 ec 04             	sub    $0x4,%esp
  802855:	53                   	push   %ebx
  802856:	50                   	push   %eax
  802857:	68 fb 4c 80 00       	push   $0x804cfb
  80285c:	e8 f2 e2 ff ff       	call   800b53 <cprintf>
  802861:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802864:	8b 45 10             	mov    0x10(%ebp),%eax
  802867:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80286a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286e:	74 07                	je     802877 <print_blocks_list+0x73>
  802870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802873:	8b 00                	mov    (%eax),%eax
  802875:	eb 05                	jmp    80287c <print_blocks_list+0x78>
  802877:	b8 00 00 00 00       	mov    $0x0,%eax
  80287c:	89 45 10             	mov    %eax,0x10(%ebp)
  80287f:	8b 45 10             	mov    0x10(%ebp),%eax
  802882:	85 c0                	test   %eax,%eax
  802884:	75 ad                	jne    802833 <print_blocks_list+0x2f>
  802886:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288a:	75 a7                	jne    802833 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80288c:	83 ec 0c             	sub    $0xc,%esp
  80288f:	68 b8 4c 80 00       	push   $0x804cb8
  802894:	e8 ba e2 ff ff       	call   800b53 <cprintf>
  802899:	83 c4 10             	add    $0x10,%esp

}
  80289c:	90                   	nop
  80289d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028a0:	c9                   	leave  
  8028a1:	c3                   	ret    

008028a2 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8028a2:	55                   	push   %ebp
  8028a3:	89 e5                	mov    %esp,%ebp
  8028a5:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8028a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ab:	83 e0 01             	and    $0x1,%eax
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	74 03                	je     8028b5 <initialize_dynamic_allocator+0x13>
  8028b2:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8028b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028b9:	0f 84 c7 01 00 00    	je     802a86 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8028bf:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  8028c6:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8028c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028cf:	01 d0                	add    %edx,%eax
  8028d1:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8028d6:	0f 87 ad 01 00 00    	ja     802a89 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	85 c0                	test   %eax,%eax
  8028e1:	0f 89 a5 01 00 00    	jns    802a8c <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8028e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ed:	01 d0                	add    %edx,%eax
  8028ef:	83 e8 04             	sub    $0x4,%eax
  8028f2:	a3 4c 50 80 00       	mov    %eax,0x80504c
     struct BlockElement * element = NULL;
  8028f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8028fe:	a1 34 50 80 00       	mov    0x805034,%eax
  802903:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802906:	e9 87 00 00 00       	jmp    802992 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80290b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290f:	75 14                	jne    802925 <initialize_dynamic_allocator+0x83>
  802911:	83 ec 04             	sub    $0x4,%esp
  802914:	68 13 4d 80 00       	push   $0x804d13
  802919:	6a 79                	push   $0x79
  80291b:	68 31 4d 80 00       	push   $0x804d31
  802920:	e8 71 df ff ff       	call   800896 <_panic>
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 00                	mov    (%eax),%eax
  80292a:	85 c0                	test   %eax,%eax
  80292c:	74 10                	je     80293e <initialize_dynamic_allocator+0x9c>
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802936:	8b 52 04             	mov    0x4(%edx),%edx
  802939:	89 50 04             	mov    %edx,0x4(%eax)
  80293c:	eb 0b                	jmp    802949 <initialize_dynamic_allocator+0xa7>
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	8b 40 04             	mov    0x4(%eax),%eax
  802944:	a3 38 50 80 00       	mov    %eax,0x805038
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 40 04             	mov    0x4(%eax),%eax
  80294f:	85 c0                	test   %eax,%eax
  802951:	74 0f                	je     802962 <initialize_dynamic_allocator+0xc0>
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	8b 40 04             	mov    0x4(%eax),%eax
  802959:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295c:	8b 12                	mov    (%edx),%edx
  80295e:	89 10                	mov    %edx,(%eax)
  802960:	eb 0a                	jmp    80296c <initialize_dynamic_allocator+0xca>
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	a3 34 50 80 00       	mov    %eax,0x805034
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297f:	a1 40 50 80 00       	mov    0x805040,%eax
  802984:	48                   	dec    %eax
  802985:	a3 40 50 80 00       	mov    %eax,0x805040
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80298a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80298f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802992:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802996:	74 07                	je     80299f <initialize_dynamic_allocator+0xfd>
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	eb 05                	jmp    8029a4 <initialize_dynamic_allocator+0x102>
  80299f:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8029a9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	0f 85 55 ff ff ff    	jne    80290b <initialize_dynamic_allocator+0x69>
  8029b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ba:	0f 85 4b ff ff ff    	jne    80290b <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8029c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8029cf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029d4:	a3 48 50 80 00       	mov    %eax,0x805048
    end_block->info = 1;
  8029d9:	a1 48 50 80 00       	mov    0x805048,%eax
  8029de:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	83 c0 08             	add    $0x8,%eax
  8029ea:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	83 c0 04             	add    $0x4,%eax
  8029f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029f6:	83 ea 08             	sub    $0x8,%edx
  8029f9:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8029fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	01 d0                	add    %edx,%eax
  802a03:	83 e8 08             	sub    $0x8,%eax
  802a06:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a09:	83 ea 08             	sub    $0x8,%edx
  802a0c:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802a21:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a25:	75 17                	jne    802a3e <initialize_dynamic_allocator+0x19c>
  802a27:	83 ec 04             	sub    $0x4,%esp
  802a2a:	68 4c 4d 80 00       	push   $0x804d4c
  802a2f:	68 90 00 00 00       	push   $0x90
  802a34:	68 31 4d 80 00       	push   $0x804d31
  802a39:	e8 58 de ff ff       	call   800896 <_panic>
  802a3e:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a47:	89 10                	mov    %edx,(%eax)
  802a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	74 0d                	je     802a5f <initialize_dynamic_allocator+0x1bd>
  802a52:	a1 34 50 80 00       	mov    0x805034,%eax
  802a57:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a5a:	89 50 04             	mov    %edx,0x4(%eax)
  802a5d:	eb 08                	jmp    802a67 <initialize_dynamic_allocator+0x1c5>
  802a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a62:	a3 38 50 80 00       	mov    %eax,0x805038
  802a67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6a:	a3 34 50 80 00       	mov    %eax,0x805034
  802a6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a79:	a1 40 50 80 00       	mov    0x805040,%eax
  802a7e:	40                   	inc    %eax
  802a7f:	a3 40 50 80 00       	mov    %eax,0x805040
  802a84:	eb 07                	jmp    802a8d <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802a86:	90                   	nop
  802a87:	eb 04                	jmp    802a8d <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802a89:	90                   	nop
  802a8a:	eb 01                	jmp    802a8d <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802a8c:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802a8d:	c9                   	leave  
  802a8e:	c3                   	ret    

00802a8f <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802a8f:	55                   	push   %ebp
  802a90:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802a92:	8b 45 10             	mov    0x10(%ebp),%eax
  802a95:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802a98:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9b:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aa1:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	83 e8 04             	sub    $0x4,%eax
  802aa9:	8b 00                	mov    (%eax),%eax
  802aab:	83 e0 fe             	and    $0xfffffffe,%eax
  802aae:	8d 50 f8             	lea    -0x8(%eax),%edx
  802ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab4:	01 c2                	add    %eax,%edx
  802ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ab9:	89 02                	mov    %eax,(%edx)
}
  802abb:	90                   	nop
  802abc:	5d                   	pop    %ebp
  802abd:	c3                   	ret    

00802abe <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802abe:	55                   	push   %ebp
  802abf:	89 e5                	mov    %esp,%ebp
  802ac1:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	83 e0 01             	and    $0x1,%eax
  802aca:	85 c0                	test   %eax,%eax
  802acc:	74 03                	je     802ad1 <alloc_block_FF+0x13>
  802ace:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802ad1:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802ad5:	77 07                	ja     802ade <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802ad7:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802ade:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ae3:	85 c0                	test   %eax,%eax
  802ae5:	75 73                	jne    802b5a <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	83 c0 10             	add    $0x10,%eax
  802aed:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802af0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802af7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802afa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afd:	01 d0                	add    %edx,%eax
  802aff:	48                   	dec    %eax
  802b00:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802b03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b06:	ba 00 00 00 00       	mov    $0x0,%edx
  802b0b:	f7 75 ec             	divl   -0x14(%ebp)
  802b0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b11:	29 d0                	sub    %edx,%eax
  802b13:	c1 e8 0c             	shr    $0xc,%eax
  802b16:	83 ec 0c             	sub    $0xc,%esp
  802b19:	50                   	push   %eax
  802b1a:	e8 d6 ef ff ff       	call   801af5 <sbrk>
  802b1f:	83 c4 10             	add    $0x10,%esp
  802b22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802b25:	83 ec 0c             	sub    $0xc,%esp
  802b28:	6a 00                	push   $0x0
  802b2a:	e8 c6 ef ff ff       	call   801af5 <sbrk>
  802b2f:	83 c4 10             	add    $0x10,%esp
  802b32:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802b35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b38:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802b3b:	83 ec 08             	sub    $0x8,%esp
  802b3e:	50                   	push   %eax
  802b3f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b42:	e8 5b fd ff ff       	call   8028a2 <initialize_dynamic_allocator>
  802b47:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802b4a:	83 ec 0c             	sub    $0xc,%esp
  802b4d:	68 6f 4d 80 00       	push   $0x804d6f
  802b52:	e8 fc df ff ff       	call   800b53 <cprintf>
  802b57:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802b5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b5e:	75 0a                	jne    802b6a <alloc_block_FF+0xac>
	        return NULL;
  802b60:	b8 00 00 00 00       	mov    $0x0,%eax
  802b65:	e9 0e 04 00 00       	jmp    802f78 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802b6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802b71:	a1 34 50 80 00       	mov    0x805034,%eax
  802b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b79:	e9 f3 02 00 00       	jmp    802e71 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802b84:	83 ec 0c             	sub    $0xc,%esp
  802b87:	ff 75 bc             	pushl  -0x44(%ebp)
  802b8a:	e8 af fb ff ff       	call   80273e <get_block_size>
  802b8f:	83 c4 10             	add    $0x10,%esp
  802b92:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	83 c0 08             	add    $0x8,%eax
  802b9b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802b9e:	0f 87 c5 02 00 00    	ja     802e69 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba7:	83 c0 18             	add    $0x18,%eax
  802baa:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802bad:	0f 87 19 02 00 00    	ja     802dcc <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802bb3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bb6:	2b 45 08             	sub    0x8(%ebp),%eax
  802bb9:	83 e8 08             	sub    $0x8,%eax
  802bbc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	8d 50 08             	lea    0x8(%eax),%edx
  802bc5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bc8:	01 d0                	add    %edx,%eax
  802bca:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	83 c0 08             	add    $0x8,%eax
  802bd3:	83 ec 04             	sub    $0x4,%esp
  802bd6:	6a 01                	push   $0x1
  802bd8:	50                   	push   %eax
  802bd9:	ff 75 bc             	pushl  -0x44(%ebp)
  802bdc:	e8 ae fe ff ff       	call   802a8f <set_block_data>
  802be1:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 40 04             	mov    0x4(%eax),%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	75 68                	jne    802c56 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bee:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802bf2:	75 17                	jne    802c0b <alloc_block_FF+0x14d>
  802bf4:	83 ec 04             	sub    $0x4,%esp
  802bf7:	68 4c 4d 80 00       	push   $0x804d4c
  802bfc:	68 d7 00 00 00       	push   $0xd7
  802c01:	68 31 4d 80 00       	push   $0x804d31
  802c06:	e8 8b dc ff ff       	call   800896 <_panic>
  802c0b:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802c11:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c14:	89 10                	mov    %edx,(%eax)
  802c16:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c19:	8b 00                	mov    (%eax),%eax
  802c1b:	85 c0                	test   %eax,%eax
  802c1d:	74 0d                	je     802c2c <alloc_block_FF+0x16e>
  802c1f:	a1 34 50 80 00       	mov    0x805034,%eax
  802c24:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c27:	89 50 04             	mov    %edx,0x4(%eax)
  802c2a:	eb 08                	jmp    802c34 <alloc_block_FF+0x176>
  802c2c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c2f:	a3 38 50 80 00       	mov    %eax,0x805038
  802c34:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c37:	a3 34 50 80 00       	mov    %eax,0x805034
  802c3c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c46:	a1 40 50 80 00       	mov    0x805040,%eax
  802c4b:	40                   	inc    %eax
  802c4c:	a3 40 50 80 00       	mov    %eax,0x805040
  802c51:	e9 dc 00 00 00       	jmp    802d32 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 00                	mov    (%eax),%eax
  802c5b:	85 c0                	test   %eax,%eax
  802c5d:	75 65                	jne    802cc4 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c5f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802c63:	75 17                	jne    802c7c <alloc_block_FF+0x1be>
  802c65:	83 ec 04             	sub    $0x4,%esp
  802c68:	68 80 4d 80 00       	push   $0x804d80
  802c6d:	68 db 00 00 00       	push   $0xdb
  802c72:	68 31 4d 80 00       	push   $0x804d31
  802c77:	e8 1a dc ff ff       	call   800896 <_panic>
  802c7c:	8b 15 38 50 80 00    	mov    0x805038,%edx
  802c82:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c85:	89 50 04             	mov    %edx,0x4(%eax)
  802c88:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c8b:	8b 40 04             	mov    0x4(%eax),%eax
  802c8e:	85 c0                	test   %eax,%eax
  802c90:	74 0c                	je     802c9e <alloc_block_FF+0x1e0>
  802c92:	a1 38 50 80 00       	mov    0x805038,%eax
  802c97:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c9a:	89 10                	mov    %edx,(%eax)
  802c9c:	eb 08                	jmp    802ca6 <alloc_block_FF+0x1e8>
  802c9e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ca1:	a3 34 50 80 00       	mov    %eax,0x805034
  802ca6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ca9:	a3 38 50 80 00       	mov    %eax,0x805038
  802cae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb7:	a1 40 50 80 00       	mov    0x805040,%eax
  802cbc:	40                   	inc    %eax
  802cbd:	a3 40 50 80 00       	mov    %eax,0x805040
  802cc2:	eb 6e                	jmp    802d32 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802cc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc8:	74 06                	je     802cd0 <alloc_block_FF+0x212>
  802cca:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802cce:	75 17                	jne    802ce7 <alloc_block_FF+0x229>
  802cd0:	83 ec 04             	sub    $0x4,%esp
  802cd3:	68 a4 4d 80 00       	push   $0x804da4
  802cd8:	68 df 00 00 00       	push   $0xdf
  802cdd:	68 31 4d 80 00       	push   $0x804d31
  802ce2:	e8 af db ff ff       	call   800896 <_panic>
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	8b 10                	mov    (%eax),%edx
  802cec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cef:	89 10                	mov    %edx,(%eax)
  802cf1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cf4:	8b 00                	mov    (%eax),%eax
  802cf6:	85 c0                	test   %eax,%eax
  802cf8:	74 0b                	je     802d05 <alloc_block_FF+0x247>
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	8b 00                	mov    (%eax),%eax
  802cff:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d02:	89 50 04             	mov    %edx,0x4(%eax)
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802d0b:	89 10                	mov    %edx,(%eax)
  802d0d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d13:	89 50 04             	mov    %edx,0x4(%eax)
  802d16:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	85 c0                	test   %eax,%eax
  802d1d:	75 08                	jne    802d27 <alloc_block_FF+0x269>
  802d1f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d22:	a3 38 50 80 00       	mov    %eax,0x805038
  802d27:	a1 40 50 80 00       	mov    0x805040,%eax
  802d2c:	40                   	inc    %eax
  802d2d:	a3 40 50 80 00       	mov    %eax,0x805040
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d36:	75 17                	jne    802d4f <alloc_block_FF+0x291>
  802d38:	83 ec 04             	sub    $0x4,%esp
  802d3b:	68 13 4d 80 00       	push   $0x804d13
  802d40:	68 e1 00 00 00       	push   $0xe1
  802d45:	68 31 4d 80 00       	push   $0x804d31
  802d4a:	e8 47 db ff ff       	call   800896 <_panic>
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 00                	mov    (%eax),%eax
  802d54:	85 c0                	test   %eax,%eax
  802d56:	74 10                	je     802d68 <alloc_block_FF+0x2aa>
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	8b 00                	mov    (%eax),%eax
  802d5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d60:	8b 52 04             	mov    0x4(%edx),%edx
  802d63:	89 50 04             	mov    %edx,0x4(%eax)
  802d66:	eb 0b                	jmp    802d73 <alloc_block_FF+0x2b5>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 40 04             	mov    0x4(%eax),%eax
  802d6e:	a3 38 50 80 00       	mov    %eax,0x805038
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 40 04             	mov    0x4(%eax),%eax
  802d79:	85 c0                	test   %eax,%eax
  802d7b:	74 0f                	je     802d8c <alloc_block_FF+0x2ce>
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	8b 40 04             	mov    0x4(%eax),%eax
  802d83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d86:	8b 12                	mov    (%edx),%edx
  802d88:	89 10                	mov    %edx,(%eax)
  802d8a:	eb 0a                	jmp    802d96 <alloc_block_FF+0x2d8>
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 00                	mov    (%eax),%eax
  802d91:	a3 34 50 80 00       	mov    %eax,0x805034
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da9:	a1 40 50 80 00       	mov    0x805040,%eax
  802dae:	48                   	dec    %eax
  802daf:	a3 40 50 80 00       	mov    %eax,0x805040
				set_block_data(new_block_va, remaining_size, 0);
  802db4:	83 ec 04             	sub    $0x4,%esp
  802db7:	6a 00                	push   $0x0
  802db9:	ff 75 b4             	pushl  -0x4c(%ebp)
  802dbc:	ff 75 b0             	pushl  -0x50(%ebp)
  802dbf:	e8 cb fc ff ff       	call   802a8f <set_block_data>
  802dc4:	83 c4 10             	add    $0x10,%esp
  802dc7:	e9 95 00 00 00       	jmp    802e61 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802dcc:	83 ec 04             	sub    $0x4,%esp
  802dcf:	6a 01                	push   $0x1
  802dd1:	ff 75 b8             	pushl  -0x48(%ebp)
  802dd4:	ff 75 bc             	pushl  -0x44(%ebp)
  802dd7:	e8 b3 fc ff ff       	call   802a8f <set_block_data>
  802ddc:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802ddf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de3:	75 17                	jne    802dfc <alloc_block_FF+0x33e>
  802de5:	83 ec 04             	sub    $0x4,%esp
  802de8:	68 13 4d 80 00       	push   $0x804d13
  802ded:	68 e8 00 00 00       	push   $0xe8
  802df2:	68 31 4d 80 00       	push   $0x804d31
  802df7:	e8 9a da ff ff       	call   800896 <_panic>
  802dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dff:	8b 00                	mov    (%eax),%eax
  802e01:	85 c0                	test   %eax,%eax
  802e03:	74 10                	je     802e15 <alloc_block_FF+0x357>
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	8b 00                	mov    (%eax),%eax
  802e0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0d:	8b 52 04             	mov    0x4(%edx),%edx
  802e10:	89 50 04             	mov    %edx,0x4(%eax)
  802e13:	eb 0b                	jmp    802e20 <alloc_block_FF+0x362>
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	8b 40 04             	mov    0x4(%eax),%eax
  802e1b:	a3 38 50 80 00       	mov    %eax,0x805038
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 40 04             	mov    0x4(%eax),%eax
  802e26:	85 c0                	test   %eax,%eax
  802e28:	74 0f                	je     802e39 <alloc_block_FF+0x37b>
  802e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2d:	8b 40 04             	mov    0x4(%eax),%eax
  802e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e33:	8b 12                	mov    (%edx),%edx
  802e35:	89 10                	mov    %edx,(%eax)
  802e37:	eb 0a                	jmp    802e43 <alloc_block_FF+0x385>
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 00                	mov    (%eax),%eax
  802e3e:	a3 34 50 80 00       	mov    %eax,0x805034
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e56:	a1 40 50 80 00       	mov    0x805040,%eax
  802e5b:	48                   	dec    %eax
  802e5c:	a3 40 50 80 00       	mov    %eax,0x805040
	            }
	            return va;
  802e61:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e64:	e9 0f 01 00 00       	jmp    802f78 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802e69:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e75:	74 07                	je     802e7e <alloc_block_FF+0x3c0>
  802e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7a:	8b 00                	mov    (%eax),%eax
  802e7c:	eb 05                	jmp    802e83 <alloc_block_FF+0x3c5>
  802e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e83:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802e88:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e8d:	85 c0                	test   %eax,%eax
  802e8f:	0f 85 e9 fc ff ff    	jne    802b7e <alloc_block_FF+0xc0>
  802e95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e99:	0f 85 df fc ff ff    	jne    802b7e <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea2:	83 c0 08             	add    $0x8,%eax
  802ea5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ea8:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802eaf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eb2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802eb5:	01 d0                	add    %edx,%eax
  802eb7:	48                   	dec    %eax
  802eb8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802ebb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ebe:	ba 00 00 00 00       	mov    $0x0,%edx
  802ec3:	f7 75 d8             	divl   -0x28(%ebp)
  802ec6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ec9:	29 d0                	sub    %edx,%eax
  802ecb:	c1 e8 0c             	shr    $0xc,%eax
  802ece:	83 ec 0c             	sub    $0xc,%esp
  802ed1:	50                   	push   %eax
  802ed2:	e8 1e ec ff ff       	call   801af5 <sbrk>
  802ed7:	83 c4 10             	add    $0x10,%esp
  802eda:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802edd:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802ee1:	75 0a                	jne    802eed <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802ee3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee8:	e9 8b 00 00 00       	jmp    802f78 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802eed:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802ef4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ef7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802efa:	01 d0                	add    %edx,%eax
  802efc:	48                   	dec    %eax
  802efd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802f00:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f03:	ba 00 00 00 00       	mov    $0x0,%edx
  802f08:	f7 75 cc             	divl   -0x34(%ebp)
  802f0b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f0e:	29 d0                	sub    %edx,%eax
  802f10:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f13:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f16:	01 d0                	add    %edx,%eax
  802f18:	a3 48 50 80 00       	mov    %eax,0x805048
			end_block->info = 1;
  802f1d:	a1 48 50 80 00       	mov    0x805048,%eax
  802f22:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802f28:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802f2f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f32:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f35:	01 d0                	add    %edx,%eax
  802f37:	48                   	dec    %eax
  802f38:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802f3b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f3e:	ba 00 00 00 00       	mov    $0x0,%edx
  802f43:	f7 75 c4             	divl   -0x3c(%ebp)
  802f46:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802f49:	29 d0                	sub    %edx,%eax
  802f4b:	83 ec 04             	sub    $0x4,%esp
  802f4e:	6a 01                	push   $0x1
  802f50:	50                   	push   %eax
  802f51:	ff 75 d0             	pushl  -0x30(%ebp)
  802f54:	e8 36 fb ff ff       	call   802a8f <set_block_data>
  802f59:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802f5c:	83 ec 0c             	sub    $0xc,%esp
  802f5f:	ff 75 d0             	pushl  -0x30(%ebp)
  802f62:	e8 1b 0a 00 00       	call   803982 <free_block>
  802f67:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802f6a:	83 ec 0c             	sub    $0xc,%esp
  802f6d:	ff 75 08             	pushl  0x8(%ebp)
  802f70:	e8 49 fb ff ff       	call   802abe <alloc_block_FF>
  802f75:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802f78:	c9                   	leave  
  802f79:	c3                   	ret    

00802f7a <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802f7a:	55                   	push   %ebp
  802f7b:	89 e5                	mov    %esp,%ebp
  802f7d:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	83 e0 01             	and    $0x1,%eax
  802f86:	85 c0                	test   %eax,%eax
  802f88:	74 03                	je     802f8d <alloc_block_BF+0x13>
  802f8a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802f8d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802f91:	77 07                	ja     802f9a <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802f93:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802f9a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f9f:	85 c0                	test   %eax,%eax
  802fa1:	75 73                	jne    803016 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	83 c0 10             	add    $0x10,%eax
  802fa9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802fac:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802fb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb9:	01 d0                	add    %edx,%eax
  802fbb:	48                   	dec    %eax
  802fbc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802fbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc2:	ba 00 00 00 00       	mov    $0x0,%edx
  802fc7:	f7 75 e0             	divl   -0x20(%ebp)
  802fca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fcd:	29 d0                	sub    %edx,%eax
  802fcf:	c1 e8 0c             	shr    $0xc,%eax
  802fd2:	83 ec 0c             	sub    $0xc,%esp
  802fd5:	50                   	push   %eax
  802fd6:	e8 1a eb ff ff       	call   801af5 <sbrk>
  802fdb:	83 c4 10             	add    $0x10,%esp
  802fde:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802fe1:	83 ec 0c             	sub    $0xc,%esp
  802fe4:	6a 00                	push   $0x0
  802fe6:	e8 0a eb ff ff       	call   801af5 <sbrk>
  802feb:	83 c4 10             	add    $0x10,%esp
  802fee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802ff1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ff4:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802ff7:	83 ec 08             	sub    $0x8,%esp
  802ffa:	50                   	push   %eax
  802ffb:	ff 75 d8             	pushl  -0x28(%ebp)
  802ffe:	e8 9f f8 ff ff       	call   8028a2 <initialize_dynamic_allocator>
  803003:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803006:	83 ec 0c             	sub    $0xc,%esp
  803009:	68 6f 4d 80 00       	push   $0x804d6f
  80300e:	e8 40 db ff ff       	call   800b53 <cprintf>
  803013:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803016:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80301d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803024:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80302b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803032:	a1 34 50 80 00       	mov    0x805034,%eax
  803037:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80303a:	e9 1d 01 00 00       	jmp    80315c <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803045:	83 ec 0c             	sub    $0xc,%esp
  803048:	ff 75 a8             	pushl  -0x58(%ebp)
  80304b:	e8 ee f6 ff ff       	call   80273e <get_block_size>
  803050:	83 c4 10             	add    $0x10,%esp
  803053:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803056:	8b 45 08             	mov    0x8(%ebp),%eax
  803059:	83 c0 08             	add    $0x8,%eax
  80305c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80305f:	0f 87 ef 00 00 00    	ja     803154 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	83 c0 18             	add    $0x18,%eax
  80306b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80306e:	77 1d                	ja     80308d <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803070:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803073:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803076:	0f 86 d8 00 00 00    	jbe    803154 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80307c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80307f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803082:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803085:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803088:	e9 c7 00 00 00       	jmp    803154 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	83 c0 08             	add    $0x8,%eax
  803093:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803096:	0f 85 9d 00 00 00    	jne    803139 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80309c:	83 ec 04             	sub    $0x4,%esp
  80309f:	6a 01                	push   $0x1
  8030a1:	ff 75 a4             	pushl  -0x5c(%ebp)
  8030a4:	ff 75 a8             	pushl  -0x58(%ebp)
  8030a7:	e8 e3 f9 ff ff       	call   802a8f <set_block_data>
  8030ac:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8030af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b3:	75 17                	jne    8030cc <alloc_block_BF+0x152>
  8030b5:	83 ec 04             	sub    $0x4,%esp
  8030b8:	68 13 4d 80 00       	push   $0x804d13
  8030bd:	68 2c 01 00 00       	push   $0x12c
  8030c2:	68 31 4d 80 00       	push   $0x804d31
  8030c7:	e8 ca d7 ff ff       	call   800896 <_panic>
  8030cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cf:	8b 00                	mov    (%eax),%eax
  8030d1:	85 c0                	test   %eax,%eax
  8030d3:	74 10                	je     8030e5 <alloc_block_BF+0x16b>
  8030d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d8:	8b 00                	mov    (%eax),%eax
  8030da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030dd:	8b 52 04             	mov    0x4(%edx),%edx
  8030e0:	89 50 04             	mov    %edx,0x4(%eax)
  8030e3:	eb 0b                	jmp    8030f0 <alloc_block_BF+0x176>
  8030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e8:	8b 40 04             	mov    0x4(%eax),%eax
  8030eb:	a3 38 50 80 00       	mov    %eax,0x805038
  8030f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f3:	8b 40 04             	mov    0x4(%eax),%eax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	74 0f                	je     803109 <alloc_block_BF+0x18f>
  8030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fd:	8b 40 04             	mov    0x4(%eax),%eax
  803100:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803103:	8b 12                	mov    (%edx),%edx
  803105:	89 10                	mov    %edx,(%eax)
  803107:	eb 0a                	jmp    803113 <alloc_block_BF+0x199>
  803109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310c:	8b 00                	mov    (%eax),%eax
  80310e:	a3 34 50 80 00       	mov    %eax,0x805034
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803126:	a1 40 50 80 00       	mov    0x805040,%eax
  80312b:	48                   	dec    %eax
  80312c:	a3 40 50 80 00       	mov    %eax,0x805040
					return va;
  803131:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803134:	e9 24 04 00 00       	jmp    80355d <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803139:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80313f:	76 13                	jbe    803154 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803141:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803148:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80314b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80314e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803151:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803154:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803159:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80315c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803160:	74 07                	je     803169 <alloc_block_BF+0x1ef>
  803162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803165:	8b 00                	mov    (%eax),%eax
  803167:	eb 05                	jmp    80316e <alloc_block_BF+0x1f4>
  803169:	b8 00 00 00 00       	mov    $0x0,%eax
  80316e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803173:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803178:	85 c0                	test   %eax,%eax
  80317a:	0f 85 bf fe ff ff    	jne    80303f <alloc_block_BF+0xc5>
  803180:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803184:	0f 85 b5 fe ff ff    	jne    80303f <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80318a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80318e:	0f 84 26 02 00 00    	je     8033ba <alloc_block_BF+0x440>
  803194:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803198:	0f 85 1c 02 00 00    	jne    8033ba <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80319e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a1:	2b 45 08             	sub    0x8(%ebp),%eax
  8031a4:	83 e8 08             	sub    $0x8,%eax
  8031a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	8d 50 08             	lea    0x8(%eax),%edx
  8031b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b3:	01 d0                	add    %edx,%eax
  8031b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bb:	83 c0 08             	add    $0x8,%eax
  8031be:	83 ec 04             	sub    $0x4,%esp
  8031c1:	6a 01                	push   $0x1
  8031c3:	50                   	push   %eax
  8031c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8031c7:	e8 c3 f8 ff ff       	call   802a8f <set_block_data>
  8031cc:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8031cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d2:	8b 40 04             	mov    0x4(%eax),%eax
  8031d5:	85 c0                	test   %eax,%eax
  8031d7:	75 68                	jne    803241 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8031d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031dd:	75 17                	jne    8031f6 <alloc_block_BF+0x27c>
  8031df:	83 ec 04             	sub    $0x4,%esp
  8031e2:	68 4c 4d 80 00       	push   $0x804d4c
  8031e7:	68 45 01 00 00       	push   $0x145
  8031ec:	68 31 4d 80 00       	push   $0x804d31
  8031f1:	e8 a0 d6 ff ff       	call   800896 <_panic>
  8031f6:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8031fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ff:	89 10                	mov    %edx,(%eax)
  803201:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803204:	8b 00                	mov    (%eax),%eax
  803206:	85 c0                	test   %eax,%eax
  803208:	74 0d                	je     803217 <alloc_block_BF+0x29d>
  80320a:	a1 34 50 80 00       	mov    0x805034,%eax
  80320f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803212:	89 50 04             	mov    %edx,0x4(%eax)
  803215:	eb 08                	jmp    80321f <alloc_block_BF+0x2a5>
  803217:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80321a:	a3 38 50 80 00       	mov    %eax,0x805038
  80321f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803222:	a3 34 50 80 00       	mov    %eax,0x805034
  803227:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80322a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803231:	a1 40 50 80 00       	mov    0x805040,%eax
  803236:	40                   	inc    %eax
  803237:	a3 40 50 80 00       	mov    %eax,0x805040
  80323c:	e9 dc 00 00 00       	jmp    80331d <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803241:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803244:	8b 00                	mov    (%eax),%eax
  803246:	85 c0                	test   %eax,%eax
  803248:	75 65                	jne    8032af <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80324a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80324e:	75 17                	jne    803267 <alloc_block_BF+0x2ed>
  803250:	83 ec 04             	sub    $0x4,%esp
  803253:	68 80 4d 80 00       	push   $0x804d80
  803258:	68 4a 01 00 00       	push   $0x14a
  80325d:	68 31 4d 80 00       	push   $0x804d31
  803262:	e8 2f d6 ff ff       	call   800896 <_panic>
  803267:	8b 15 38 50 80 00    	mov    0x805038,%edx
  80326d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803270:	89 50 04             	mov    %edx,0x4(%eax)
  803273:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803276:	8b 40 04             	mov    0x4(%eax),%eax
  803279:	85 c0                	test   %eax,%eax
  80327b:	74 0c                	je     803289 <alloc_block_BF+0x30f>
  80327d:	a1 38 50 80 00       	mov    0x805038,%eax
  803282:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803285:	89 10                	mov    %edx,(%eax)
  803287:	eb 08                	jmp    803291 <alloc_block_BF+0x317>
  803289:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80328c:	a3 34 50 80 00       	mov    %eax,0x805034
  803291:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803294:	a3 38 50 80 00       	mov    %eax,0x805038
  803299:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80329c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a2:	a1 40 50 80 00       	mov    0x805040,%eax
  8032a7:	40                   	inc    %eax
  8032a8:	a3 40 50 80 00       	mov    %eax,0x805040
  8032ad:	eb 6e                	jmp    80331d <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8032af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032b3:	74 06                	je     8032bb <alloc_block_BF+0x341>
  8032b5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8032b9:	75 17                	jne    8032d2 <alloc_block_BF+0x358>
  8032bb:	83 ec 04             	sub    $0x4,%esp
  8032be:	68 a4 4d 80 00       	push   $0x804da4
  8032c3:	68 4f 01 00 00       	push   $0x14f
  8032c8:	68 31 4d 80 00       	push   $0x804d31
  8032cd:	e8 c4 d5 ff ff       	call   800896 <_panic>
  8032d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d5:	8b 10                	mov    (%eax),%edx
  8032d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032da:	89 10                	mov    %edx,(%eax)
  8032dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032df:	8b 00                	mov    (%eax),%eax
  8032e1:	85 c0                	test   %eax,%eax
  8032e3:	74 0b                	je     8032f0 <alloc_block_BF+0x376>
  8032e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e8:	8b 00                	mov    (%eax),%eax
  8032ea:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032ed:	89 50 04             	mov    %edx,0x4(%eax)
  8032f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8032f6:	89 10                	mov    %edx,(%eax)
  8032f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8032fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032fe:	89 50 04             	mov    %edx,0x4(%eax)
  803301:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803304:	8b 00                	mov    (%eax),%eax
  803306:	85 c0                	test   %eax,%eax
  803308:	75 08                	jne    803312 <alloc_block_BF+0x398>
  80330a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80330d:	a3 38 50 80 00       	mov    %eax,0x805038
  803312:	a1 40 50 80 00       	mov    0x805040,%eax
  803317:	40                   	inc    %eax
  803318:	a3 40 50 80 00       	mov    %eax,0x805040
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80331d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803321:	75 17                	jne    80333a <alloc_block_BF+0x3c0>
  803323:	83 ec 04             	sub    $0x4,%esp
  803326:	68 13 4d 80 00       	push   $0x804d13
  80332b:	68 51 01 00 00       	push   $0x151
  803330:	68 31 4d 80 00       	push   $0x804d31
  803335:	e8 5c d5 ff ff       	call   800896 <_panic>
  80333a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333d:	8b 00                	mov    (%eax),%eax
  80333f:	85 c0                	test   %eax,%eax
  803341:	74 10                	je     803353 <alloc_block_BF+0x3d9>
  803343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803346:	8b 00                	mov    (%eax),%eax
  803348:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80334b:	8b 52 04             	mov    0x4(%edx),%edx
  80334e:	89 50 04             	mov    %edx,0x4(%eax)
  803351:	eb 0b                	jmp    80335e <alloc_block_BF+0x3e4>
  803353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803356:	8b 40 04             	mov    0x4(%eax),%eax
  803359:	a3 38 50 80 00       	mov    %eax,0x805038
  80335e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803361:	8b 40 04             	mov    0x4(%eax),%eax
  803364:	85 c0                	test   %eax,%eax
  803366:	74 0f                	je     803377 <alloc_block_BF+0x3fd>
  803368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336b:	8b 40 04             	mov    0x4(%eax),%eax
  80336e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803371:	8b 12                	mov    (%edx),%edx
  803373:	89 10                	mov    %edx,(%eax)
  803375:	eb 0a                	jmp    803381 <alloc_block_BF+0x407>
  803377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	a3 34 50 80 00       	mov    %eax,0x805034
  803381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803384:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80338a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803394:	a1 40 50 80 00       	mov    0x805040,%eax
  803399:	48                   	dec    %eax
  80339a:	a3 40 50 80 00       	mov    %eax,0x805040
			set_block_data(new_block_va, remaining_size, 0);
  80339f:	83 ec 04             	sub    $0x4,%esp
  8033a2:	6a 00                	push   $0x0
  8033a4:	ff 75 d0             	pushl  -0x30(%ebp)
  8033a7:	ff 75 cc             	pushl  -0x34(%ebp)
  8033aa:	e8 e0 f6 ff ff       	call   802a8f <set_block_data>
  8033af:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8033b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b5:	e9 a3 01 00 00       	jmp    80355d <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8033ba:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8033be:	0f 85 9d 00 00 00    	jne    803461 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8033c4:	83 ec 04             	sub    $0x4,%esp
  8033c7:	6a 01                	push   $0x1
  8033c9:	ff 75 ec             	pushl  -0x14(%ebp)
  8033cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8033cf:	e8 bb f6 ff ff       	call   802a8f <set_block_data>
  8033d4:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8033d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033db:	75 17                	jne    8033f4 <alloc_block_BF+0x47a>
  8033dd:	83 ec 04             	sub    $0x4,%esp
  8033e0:	68 13 4d 80 00       	push   $0x804d13
  8033e5:	68 58 01 00 00       	push   $0x158
  8033ea:	68 31 4d 80 00       	push   $0x804d31
  8033ef:	e8 a2 d4 ff ff       	call   800896 <_panic>
  8033f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	85 c0                	test   %eax,%eax
  8033fb:	74 10                	je     80340d <alloc_block_BF+0x493>
  8033fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803400:	8b 00                	mov    (%eax),%eax
  803402:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803405:	8b 52 04             	mov    0x4(%edx),%edx
  803408:	89 50 04             	mov    %edx,0x4(%eax)
  80340b:	eb 0b                	jmp    803418 <alloc_block_BF+0x49e>
  80340d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803410:	8b 40 04             	mov    0x4(%eax),%eax
  803413:	a3 38 50 80 00       	mov    %eax,0x805038
  803418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341b:	8b 40 04             	mov    0x4(%eax),%eax
  80341e:	85 c0                	test   %eax,%eax
  803420:	74 0f                	je     803431 <alloc_block_BF+0x4b7>
  803422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803425:	8b 40 04             	mov    0x4(%eax),%eax
  803428:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80342b:	8b 12                	mov    (%edx),%edx
  80342d:	89 10                	mov    %edx,(%eax)
  80342f:	eb 0a                	jmp    80343b <alloc_block_BF+0x4c1>
  803431:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803434:	8b 00                	mov    (%eax),%eax
  803436:	a3 34 50 80 00       	mov    %eax,0x805034
  80343b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803447:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344e:	a1 40 50 80 00       	mov    0x805040,%eax
  803453:	48                   	dec    %eax
  803454:	a3 40 50 80 00       	mov    %eax,0x805040
		return best_va;
  803459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345c:	e9 fc 00 00 00       	jmp    80355d <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	83 c0 08             	add    $0x8,%eax
  803467:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80346a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803471:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803474:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803477:	01 d0                	add    %edx,%eax
  803479:	48                   	dec    %eax
  80347a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80347d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803480:	ba 00 00 00 00       	mov    $0x0,%edx
  803485:	f7 75 c4             	divl   -0x3c(%ebp)
  803488:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80348b:	29 d0                	sub    %edx,%eax
  80348d:	c1 e8 0c             	shr    $0xc,%eax
  803490:	83 ec 0c             	sub    $0xc,%esp
  803493:	50                   	push   %eax
  803494:	e8 5c e6 ff ff       	call   801af5 <sbrk>
  803499:	83 c4 10             	add    $0x10,%esp
  80349c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  80349f:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8034a3:	75 0a                	jne    8034af <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8034a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8034aa:	e9 ae 00 00 00       	jmp    80355d <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8034af:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8034b6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8034b9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8034bc:	01 d0                	add    %edx,%eax
  8034be:	48                   	dec    %eax
  8034bf:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8034c2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8034c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8034ca:	f7 75 b8             	divl   -0x48(%ebp)
  8034cd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8034d0:	29 d0                	sub    %edx,%eax
  8034d2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8034d5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8034d8:	01 d0                	add    %edx,%eax
  8034da:	a3 48 50 80 00       	mov    %eax,0x805048
				end_block->info = 1;
  8034df:	a1 48 50 80 00       	mov    0x805048,%eax
  8034e4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8034ea:	83 ec 0c             	sub    $0xc,%esp
  8034ed:	68 d8 4d 80 00       	push   $0x804dd8
  8034f2:	e8 5c d6 ff ff       	call   800b53 <cprintf>
  8034f7:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8034fa:	83 ec 08             	sub    $0x8,%esp
  8034fd:	ff 75 bc             	pushl  -0x44(%ebp)
  803500:	68 dd 4d 80 00       	push   $0x804ddd
  803505:	e8 49 d6 ff ff       	call   800b53 <cprintf>
  80350a:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80350d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803514:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803517:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80351a:	01 d0                	add    %edx,%eax
  80351c:	48                   	dec    %eax
  80351d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803520:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803523:	ba 00 00 00 00       	mov    $0x0,%edx
  803528:	f7 75 b0             	divl   -0x50(%ebp)
  80352b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80352e:	29 d0                	sub    %edx,%eax
  803530:	83 ec 04             	sub    $0x4,%esp
  803533:	6a 01                	push   $0x1
  803535:	50                   	push   %eax
  803536:	ff 75 bc             	pushl  -0x44(%ebp)
  803539:	e8 51 f5 ff ff       	call   802a8f <set_block_data>
  80353e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803541:	83 ec 0c             	sub    $0xc,%esp
  803544:	ff 75 bc             	pushl  -0x44(%ebp)
  803547:	e8 36 04 00 00       	call   803982 <free_block>
  80354c:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80354f:	83 ec 0c             	sub    $0xc,%esp
  803552:	ff 75 08             	pushl  0x8(%ebp)
  803555:	e8 20 fa ff ff       	call   802f7a <alloc_block_BF>
  80355a:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80355d:	c9                   	leave  
  80355e:	c3                   	ret    

0080355f <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80355f:	55                   	push   %ebp
  803560:	89 e5                	mov    %esp,%ebp
  803562:	53                   	push   %ebx
  803563:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803566:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80356d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803574:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803578:	74 1e                	je     803598 <merging+0x39>
  80357a:	ff 75 08             	pushl  0x8(%ebp)
  80357d:	e8 bc f1 ff ff       	call   80273e <get_block_size>
  803582:	83 c4 04             	add    $0x4,%esp
  803585:	89 c2                	mov    %eax,%edx
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	01 d0                	add    %edx,%eax
  80358c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80358f:	75 07                	jne    803598 <merging+0x39>
		prev_is_free = 1;
  803591:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803598:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80359c:	74 1e                	je     8035bc <merging+0x5d>
  80359e:	ff 75 10             	pushl  0x10(%ebp)
  8035a1:	e8 98 f1 ff ff       	call   80273e <get_block_size>
  8035a6:	83 c4 04             	add    $0x4,%esp
  8035a9:	89 c2                	mov    %eax,%edx
  8035ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8035ae:	01 d0                	add    %edx,%eax
  8035b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035b3:	75 07                	jne    8035bc <merging+0x5d>
		next_is_free = 1;
  8035b5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8035bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c0:	0f 84 cc 00 00 00    	je     803692 <merging+0x133>
  8035c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035ca:	0f 84 c2 00 00 00    	je     803692 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8035d0:	ff 75 08             	pushl  0x8(%ebp)
  8035d3:	e8 66 f1 ff ff       	call   80273e <get_block_size>
  8035d8:	83 c4 04             	add    $0x4,%esp
  8035db:	89 c3                	mov    %eax,%ebx
  8035dd:	ff 75 10             	pushl  0x10(%ebp)
  8035e0:	e8 59 f1 ff ff       	call   80273e <get_block_size>
  8035e5:	83 c4 04             	add    $0x4,%esp
  8035e8:	01 c3                	add    %eax,%ebx
  8035ea:	ff 75 0c             	pushl  0xc(%ebp)
  8035ed:	e8 4c f1 ff ff       	call   80273e <get_block_size>
  8035f2:	83 c4 04             	add    $0x4,%esp
  8035f5:	01 d8                	add    %ebx,%eax
  8035f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8035fa:	6a 00                	push   $0x0
  8035fc:	ff 75 ec             	pushl  -0x14(%ebp)
  8035ff:	ff 75 08             	pushl  0x8(%ebp)
  803602:	e8 88 f4 ff ff       	call   802a8f <set_block_data>
  803607:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80360a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80360e:	75 17                	jne    803627 <merging+0xc8>
  803610:	83 ec 04             	sub    $0x4,%esp
  803613:	68 13 4d 80 00       	push   $0x804d13
  803618:	68 7d 01 00 00       	push   $0x17d
  80361d:	68 31 4d 80 00       	push   $0x804d31
  803622:	e8 6f d2 ff ff       	call   800896 <_panic>
  803627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362a:	8b 00                	mov    (%eax),%eax
  80362c:	85 c0                	test   %eax,%eax
  80362e:	74 10                	je     803640 <merging+0xe1>
  803630:	8b 45 0c             	mov    0xc(%ebp),%eax
  803633:	8b 00                	mov    (%eax),%eax
  803635:	8b 55 0c             	mov    0xc(%ebp),%edx
  803638:	8b 52 04             	mov    0x4(%edx),%edx
  80363b:	89 50 04             	mov    %edx,0x4(%eax)
  80363e:	eb 0b                	jmp    80364b <merging+0xec>
  803640:	8b 45 0c             	mov    0xc(%ebp),%eax
  803643:	8b 40 04             	mov    0x4(%eax),%eax
  803646:	a3 38 50 80 00       	mov    %eax,0x805038
  80364b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80364e:	8b 40 04             	mov    0x4(%eax),%eax
  803651:	85 c0                	test   %eax,%eax
  803653:	74 0f                	je     803664 <merging+0x105>
  803655:	8b 45 0c             	mov    0xc(%ebp),%eax
  803658:	8b 40 04             	mov    0x4(%eax),%eax
  80365b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80365e:	8b 12                	mov    (%edx),%edx
  803660:	89 10                	mov    %edx,(%eax)
  803662:	eb 0a                	jmp    80366e <merging+0x10f>
  803664:	8b 45 0c             	mov    0xc(%ebp),%eax
  803667:	8b 00                	mov    (%eax),%eax
  803669:	a3 34 50 80 00       	mov    %eax,0x805034
  80366e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803671:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803677:	8b 45 0c             	mov    0xc(%ebp),%eax
  80367a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803681:	a1 40 50 80 00       	mov    0x805040,%eax
  803686:	48                   	dec    %eax
  803687:	a3 40 50 80 00       	mov    %eax,0x805040
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80368c:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80368d:	e9 ea 02 00 00       	jmp    80397c <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803696:	74 3b                	je     8036d3 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803698:	83 ec 0c             	sub    $0xc,%esp
  80369b:	ff 75 08             	pushl  0x8(%ebp)
  80369e:	e8 9b f0 ff ff       	call   80273e <get_block_size>
  8036a3:	83 c4 10             	add    $0x10,%esp
  8036a6:	89 c3                	mov    %eax,%ebx
  8036a8:	83 ec 0c             	sub    $0xc,%esp
  8036ab:	ff 75 10             	pushl  0x10(%ebp)
  8036ae:	e8 8b f0 ff ff       	call   80273e <get_block_size>
  8036b3:	83 c4 10             	add    $0x10,%esp
  8036b6:	01 d8                	add    %ebx,%eax
  8036b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8036bb:	83 ec 04             	sub    $0x4,%esp
  8036be:	6a 00                	push   $0x0
  8036c0:	ff 75 e8             	pushl  -0x18(%ebp)
  8036c3:	ff 75 08             	pushl  0x8(%ebp)
  8036c6:	e8 c4 f3 ff ff       	call   802a8f <set_block_data>
  8036cb:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8036ce:	e9 a9 02 00 00       	jmp    80397c <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8036d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036d7:	0f 84 2d 01 00 00    	je     80380a <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8036dd:	83 ec 0c             	sub    $0xc,%esp
  8036e0:	ff 75 10             	pushl  0x10(%ebp)
  8036e3:	e8 56 f0 ff ff       	call   80273e <get_block_size>
  8036e8:	83 c4 10             	add    $0x10,%esp
  8036eb:	89 c3                	mov    %eax,%ebx
  8036ed:	83 ec 0c             	sub    $0xc,%esp
  8036f0:	ff 75 0c             	pushl  0xc(%ebp)
  8036f3:	e8 46 f0 ff ff       	call   80273e <get_block_size>
  8036f8:	83 c4 10             	add    $0x10,%esp
  8036fb:	01 d8                	add    %ebx,%eax
  8036fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803700:	83 ec 04             	sub    $0x4,%esp
  803703:	6a 00                	push   $0x0
  803705:	ff 75 e4             	pushl  -0x1c(%ebp)
  803708:	ff 75 10             	pushl  0x10(%ebp)
  80370b:	e8 7f f3 ff ff       	call   802a8f <set_block_data>
  803710:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803713:	8b 45 10             	mov    0x10(%ebp),%eax
  803716:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803719:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80371d:	74 06                	je     803725 <merging+0x1c6>
  80371f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803723:	75 17                	jne    80373c <merging+0x1dd>
  803725:	83 ec 04             	sub    $0x4,%esp
  803728:	68 ec 4d 80 00       	push   $0x804dec
  80372d:	68 8d 01 00 00       	push   $0x18d
  803732:	68 31 4d 80 00       	push   $0x804d31
  803737:	e8 5a d1 ff ff       	call   800896 <_panic>
  80373c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80373f:	8b 50 04             	mov    0x4(%eax),%edx
  803742:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803745:	89 50 04             	mov    %edx,0x4(%eax)
  803748:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80374b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80374e:	89 10                	mov    %edx,(%eax)
  803750:	8b 45 0c             	mov    0xc(%ebp),%eax
  803753:	8b 40 04             	mov    0x4(%eax),%eax
  803756:	85 c0                	test   %eax,%eax
  803758:	74 0d                	je     803767 <merging+0x208>
  80375a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80375d:	8b 40 04             	mov    0x4(%eax),%eax
  803760:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803763:	89 10                	mov    %edx,(%eax)
  803765:	eb 08                	jmp    80376f <merging+0x210>
  803767:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80376a:	a3 34 50 80 00       	mov    %eax,0x805034
  80376f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803772:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803775:	89 50 04             	mov    %edx,0x4(%eax)
  803778:	a1 40 50 80 00       	mov    0x805040,%eax
  80377d:	40                   	inc    %eax
  80377e:	a3 40 50 80 00       	mov    %eax,0x805040
		LIST_REMOVE(&freeBlocksList, next_block);
  803783:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803787:	75 17                	jne    8037a0 <merging+0x241>
  803789:	83 ec 04             	sub    $0x4,%esp
  80378c:	68 13 4d 80 00       	push   $0x804d13
  803791:	68 8e 01 00 00       	push   $0x18e
  803796:	68 31 4d 80 00       	push   $0x804d31
  80379b:	e8 f6 d0 ff ff       	call   800896 <_panic>
  8037a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037a3:	8b 00                	mov    (%eax),%eax
  8037a5:	85 c0                	test   %eax,%eax
  8037a7:	74 10                	je     8037b9 <merging+0x25a>
  8037a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ac:	8b 00                	mov    (%eax),%eax
  8037ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037b1:	8b 52 04             	mov    0x4(%edx),%edx
  8037b4:	89 50 04             	mov    %edx,0x4(%eax)
  8037b7:	eb 0b                	jmp    8037c4 <merging+0x265>
  8037b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037bc:	8b 40 04             	mov    0x4(%eax),%eax
  8037bf:	a3 38 50 80 00       	mov    %eax,0x805038
  8037c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037c7:	8b 40 04             	mov    0x4(%eax),%eax
  8037ca:	85 c0                	test   %eax,%eax
  8037cc:	74 0f                	je     8037dd <merging+0x27e>
  8037ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d1:	8b 40 04             	mov    0x4(%eax),%eax
  8037d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037d7:	8b 12                	mov    (%edx),%edx
  8037d9:	89 10                	mov    %edx,(%eax)
  8037db:	eb 0a                	jmp    8037e7 <merging+0x288>
  8037dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e0:	8b 00                	mov    (%eax),%eax
  8037e2:	a3 34 50 80 00       	mov    %eax,0x805034
  8037e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8037ff:	48                   	dec    %eax
  803800:	a3 40 50 80 00       	mov    %eax,0x805040
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803805:	e9 72 01 00 00       	jmp    80397c <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80380a:	8b 45 10             	mov    0x10(%ebp),%eax
  80380d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803810:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803814:	74 79                	je     80388f <merging+0x330>
  803816:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80381a:	74 73                	je     80388f <merging+0x330>
  80381c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803820:	74 06                	je     803828 <merging+0x2c9>
  803822:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803826:	75 17                	jne    80383f <merging+0x2e0>
  803828:	83 ec 04             	sub    $0x4,%esp
  80382b:	68 a4 4d 80 00       	push   $0x804da4
  803830:	68 94 01 00 00       	push   $0x194
  803835:	68 31 4d 80 00       	push   $0x804d31
  80383a:	e8 57 d0 ff ff       	call   800896 <_panic>
  80383f:	8b 45 08             	mov    0x8(%ebp),%eax
  803842:	8b 10                	mov    (%eax),%edx
  803844:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803847:	89 10                	mov    %edx,(%eax)
  803849:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80384c:	8b 00                	mov    (%eax),%eax
  80384e:	85 c0                	test   %eax,%eax
  803850:	74 0b                	je     80385d <merging+0x2fe>
  803852:	8b 45 08             	mov    0x8(%ebp),%eax
  803855:	8b 00                	mov    (%eax),%eax
  803857:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80385a:	89 50 04             	mov    %edx,0x4(%eax)
  80385d:	8b 45 08             	mov    0x8(%ebp),%eax
  803860:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803863:	89 10                	mov    %edx,(%eax)
  803865:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803868:	8b 55 08             	mov    0x8(%ebp),%edx
  80386b:	89 50 04             	mov    %edx,0x4(%eax)
  80386e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803871:	8b 00                	mov    (%eax),%eax
  803873:	85 c0                	test   %eax,%eax
  803875:	75 08                	jne    80387f <merging+0x320>
  803877:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80387a:	a3 38 50 80 00       	mov    %eax,0x805038
  80387f:	a1 40 50 80 00       	mov    0x805040,%eax
  803884:	40                   	inc    %eax
  803885:	a3 40 50 80 00       	mov    %eax,0x805040
  80388a:	e9 ce 00 00 00       	jmp    80395d <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80388f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803893:	74 65                	je     8038fa <merging+0x39b>
  803895:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803899:	75 17                	jne    8038b2 <merging+0x353>
  80389b:	83 ec 04             	sub    $0x4,%esp
  80389e:	68 80 4d 80 00       	push   $0x804d80
  8038a3:	68 95 01 00 00       	push   $0x195
  8038a8:	68 31 4d 80 00       	push   $0x804d31
  8038ad:	e8 e4 cf ff ff       	call   800896 <_panic>
  8038b2:	8b 15 38 50 80 00    	mov    0x805038,%edx
  8038b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038bb:	89 50 04             	mov    %edx,0x4(%eax)
  8038be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038c1:	8b 40 04             	mov    0x4(%eax),%eax
  8038c4:	85 c0                	test   %eax,%eax
  8038c6:	74 0c                	je     8038d4 <merging+0x375>
  8038c8:	a1 38 50 80 00       	mov    0x805038,%eax
  8038cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038d0:	89 10                	mov    %edx,(%eax)
  8038d2:	eb 08                	jmp    8038dc <merging+0x37d>
  8038d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8038dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038df:	a3 38 50 80 00       	mov    %eax,0x805038
  8038e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ed:	a1 40 50 80 00       	mov    0x805040,%eax
  8038f2:	40                   	inc    %eax
  8038f3:	a3 40 50 80 00       	mov    %eax,0x805040
  8038f8:	eb 63                	jmp    80395d <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8038fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8038fe:	75 17                	jne    803917 <merging+0x3b8>
  803900:	83 ec 04             	sub    $0x4,%esp
  803903:	68 4c 4d 80 00       	push   $0x804d4c
  803908:	68 98 01 00 00       	push   $0x198
  80390d:	68 31 4d 80 00       	push   $0x804d31
  803912:	e8 7f cf ff ff       	call   800896 <_panic>
  803917:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80391d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803920:	89 10                	mov    %edx,(%eax)
  803922:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803925:	8b 00                	mov    (%eax),%eax
  803927:	85 c0                	test   %eax,%eax
  803929:	74 0d                	je     803938 <merging+0x3d9>
  80392b:	a1 34 50 80 00       	mov    0x805034,%eax
  803930:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803933:	89 50 04             	mov    %edx,0x4(%eax)
  803936:	eb 08                	jmp    803940 <merging+0x3e1>
  803938:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80393b:	a3 38 50 80 00       	mov    %eax,0x805038
  803940:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803943:	a3 34 50 80 00       	mov    %eax,0x805034
  803948:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80394b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803952:	a1 40 50 80 00       	mov    0x805040,%eax
  803957:	40                   	inc    %eax
  803958:	a3 40 50 80 00       	mov    %eax,0x805040
		}
		set_block_data(va, get_block_size(va), 0);
  80395d:	83 ec 0c             	sub    $0xc,%esp
  803960:	ff 75 10             	pushl  0x10(%ebp)
  803963:	e8 d6 ed ff ff       	call   80273e <get_block_size>
  803968:	83 c4 10             	add    $0x10,%esp
  80396b:	83 ec 04             	sub    $0x4,%esp
  80396e:	6a 00                	push   $0x0
  803970:	50                   	push   %eax
  803971:	ff 75 10             	pushl  0x10(%ebp)
  803974:	e8 16 f1 ff ff       	call   802a8f <set_block_data>
  803979:	83 c4 10             	add    $0x10,%esp
	}
}
  80397c:	90                   	nop
  80397d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803980:	c9                   	leave  
  803981:	c3                   	ret    

00803982 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803982:	55                   	push   %ebp
  803983:	89 e5                	mov    %esp,%ebp
  803985:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803988:	a1 34 50 80 00       	mov    0x805034,%eax
  80398d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803990:	a1 38 50 80 00       	mov    0x805038,%eax
  803995:	3b 45 08             	cmp    0x8(%ebp),%eax
  803998:	73 1b                	jae    8039b5 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80399a:	a1 38 50 80 00       	mov    0x805038,%eax
  80399f:	83 ec 04             	sub    $0x4,%esp
  8039a2:	ff 75 08             	pushl  0x8(%ebp)
  8039a5:	6a 00                	push   $0x0
  8039a7:	50                   	push   %eax
  8039a8:	e8 b2 fb ff ff       	call   80355f <merging>
  8039ad:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039b0:	e9 8b 00 00 00       	jmp    803a40 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8039b5:	a1 34 50 80 00       	mov    0x805034,%eax
  8039ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039bd:	76 18                	jbe    8039d7 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8039bf:	a1 34 50 80 00       	mov    0x805034,%eax
  8039c4:	83 ec 04             	sub    $0x4,%esp
  8039c7:	ff 75 08             	pushl  0x8(%ebp)
  8039ca:	50                   	push   %eax
  8039cb:	6a 00                	push   $0x0
  8039cd:	e8 8d fb ff ff       	call   80355f <merging>
  8039d2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8039d5:	eb 69                	jmp    803a40 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8039d7:	a1 34 50 80 00       	mov    0x805034,%eax
  8039dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039df:	eb 39                	jmp    803a1a <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8039e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039e7:	73 29                	jae    803a12 <free_block+0x90>
  8039e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ec:	8b 00                	mov    (%eax),%eax
  8039ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039f1:	76 1f                	jbe    803a12 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8039f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f6:	8b 00                	mov    (%eax),%eax
  8039f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8039fb:	83 ec 04             	sub    $0x4,%esp
  8039fe:	ff 75 08             	pushl  0x8(%ebp)
  803a01:	ff 75 f0             	pushl  -0x10(%ebp)
  803a04:	ff 75 f4             	pushl  -0xc(%ebp)
  803a07:	e8 53 fb ff ff       	call   80355f <merging>
  803a0c:	83 c4 10             	add    $0x10,%esp
			break;
  803a0f:	90                   	nop
		}
	}
}
  803a10:	eb 2e                	jmp    803a40 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803a12:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a1e:	74 07                	je     803a27 <free_block+0xa5>
  803a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a23:	8b 00                	mov    (%eax),%eax
  803a25:	eb 05                	jmp    803a2c <free_block+0xaa>
  803a27:	b8 00 00 00 00       	mov    $0x0,%eax
  803a2c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803a31:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a36:	85 c0                	test   %eax,%eax
  803a38:	75 a7                	jne    8039e1 <free_block+0x5f>
  803a3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a3e:	75 a1                	jne    8039e1 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803a40:	90                   	nop
  803a41:	c9                   	leave  
  803a42:	c3                   	ret    

00803a43 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803a43:	55                   	push   %ebp
  803a44:	89 e5                	mov    %esp,%ebp
  803a46:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803a49:	ff 75 08             	pushl  0x8(%ebp)
  803a4c:	e8 ed ec ff ff       	call   80273e <get_block_size>
  803a51:	83 c4 04             	add    $0x4,%esp
  803a54:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803a57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803a5e:	eb 17                	jmp    803a77 <copy_data+0x34>
  803a60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803a63:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a66:	01 c2                	add    %eax,%edx
  803a68:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6e:	01 c8                	add    %ecx,%eax
  803a70:	8a 00                	mov    (%eax),%al
  803a72:	88 02                	mov    %al,(%edx)
  803a74:	ff 45 fc             	incl   -0x4(%ebp)
  803a77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803a7d:	72 e1                	jb     803a60 <copy_data+0x1d>
}
  803a7f:	90                   	nop
  803a80:	c9                   	leave  
  803a81:	c3                   	ret    

00803a82 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803a82:	55                   	push   %ebp
  803a83:	89 e5                	mov    %esp,%ebp
  803a85:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803a88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a8c:	75 23                	jne    803ab1 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803a8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803a92:	74 13                	je     803aa7 <realloc_block_FF+0x25>
  803a94:	83 ec 0c             	sub    $0xc,%esp
  803a97:	ff 75 0c             	pushl  0xc(%ebp)
  803a9a:	e8 1f f0 ff ff       	call   802abe <alloc_block_FF>
  803a9f:	83 c4 10             	add    $0x10,%esp
  803aa2:	e9 f4 06 00 00       	jmp    80419b <realloc_block_FF+0x719>
		return NULL;
  803aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  803aac:	e9 ea 06 00 00       	jmp    80419b <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803ab1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803ab5:	75 18                	jne    803acf <realloc_block_FF+0x4d>
	{
		free_block(va);
  803ab7:	83 ec 0c             	sub    $0xc,%esp
  803aba:	ff 75 08             	pushl  0x8(%ebp)
  803abd:	e8 c0 fe ff ff       	call   803982 <free_block>
  803ac2:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  803aca:	e9 cc 06 00 00       	jmp    80419b <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803acf:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803ad3:	77 07                	ja     803adc <realloc_block_FF+0x5a>
  803ad5:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  803adf:	83 e0 01             	and    $0x1,%eax
  803ae2:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ae8:	83 c0 08             	add    $0x8,%eax
  803aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803aee:	83 ec 0c             	sub    $0xc,%esp
  803af1:	ff 75 08             	pushl  0x8(%ebp)
  803af4:	e8 45 ec ff ff       	call   80273e <get_block_size>
  803af9:	83 c4 10             	add    $0x10,%esp
  803afc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b02:	83 e8 08             	sub    $0x8,%eax
  803b05:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803b08:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0b:	83 e8 04             	sub    $0x4,%eax
  803b0e:	8b 00                	mov    (%eax),%eax
  803b10:	83 e0 fe             	and    $0xfffffffe,%eax
  803b13:	89 c2                	mov    %eax,%edx
  803b15:	8b 45 08             	mov    0x8(%ebp),%eax
  803b18:	01 d0                	add    %edx,%eax
  803b1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803b1d:	83 ec 0c             	sub    $0xc,%esp
  803b20:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b23:	e8 16 ec ff ff       	call   80273e <get_block_size>
  803b28:	83 c4 10             	add    $0x10,%esp
  803b2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803b2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b31:	83 e8 08             	sub    $0x8,%eax
  803b34:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b3a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b3d:	75 08                	jne    803b47 <realloc_block_FF+0xc5>
	{
		 return va;
  803b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b42:	e9 54 06 00 00       	jmp    80419b <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b4a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b4d:	0f 83 e5 03 00 00    	jae    803f38 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803b53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b56:	2b 45 0c             	sub    0xc(%ebp),%eax
  803b59:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803b5c:	83 ec 0c             	sub    $0xc,%esp
  803b5f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803b62:	e8 f0 eb ff ff       	call   802757 <is_free_block>
  803b67:	83 c4 10             	add    $0x10,%esp
  803b6a:	84 c0                	test   %al,%al
  803b6c:	0f 84 3b 01 00 00    	je     803cad <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803b72:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b75:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b78:	01 d0                	add    %edx,%eax
  803b7a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803b7d:	83 ec 04             	sub    $0x4,%esp
  803b80:	6a 01                	push   $0x1
  803b82:	ff 75 f0             	pushl  -0x10(%ebp)
  803b85:	ff 75 08             	pushl  0x8(%ebp)
  803b88:	e8 02 ef ff ff       	call   802a8f <set_block_data>
  803b8d:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803b90:	8b 45 08             	mov    0x8(%ebp),%eax
  803b93:	83 e8 04             	sub    $0x4,%eax
  803b96:	8b 00                	mov    (%eax),%eax
  803b98:	83 e0 fe             	and    $0xfffffffe,%eax
  803b9b:	89 c2                	mov    %eax,%edx
  803b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba0:	01 d0                	add    %edx,%eax
  803ba2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803ba5:	83 ec 04             	sub    $0x4,%esp
  803ba8:	6a 00                	push   $0x0
  803baa:	ff 75 cc             	pushl  -0x34(%ebp)
  803bad:	ff 75 c8             	pushl  -0x38(%ebp)
  803bb0:	e8 da ee ff ff       	call   802a8f <set_block_data>
  803bb5:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803bb8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bbc:	74 06                	je     803bc4 <realloc_block_FF+0x142>
  803bbe:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803bc2:	75 17                	jne    803bdb <realloc_block_FF+0x159>
  803bc4:	83 ec 04             	sub    $0x4,%esp
  803bc7:	68 a4 4d 80 00       	push   $0x804da4
  803bcc:	68 f6 01 00 00       	push   $0x1f6
  803bd1:	68 31 4d 80 00       	push   $0x804d31
  803bd6:	e8 bb cc ff ff       	call   800896 <_panic>
  803bdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bde:	8b 10                	mov    (%eax),%edx
  803be0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803be3:	89 10                	mov    %edx,(%eax)
  803be5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803be8:	8b 00                	mov    (%eax),%eax
  803bea:	85 c0                	test   %eax,%eax
  803bec:	74 0b                	je     803bf9 <realloc_block_FF+0x177>
  803bee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf1:	8b 00                	mov    (%eax),%eax
  803bf3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bf6:	89 50 04             	mov    %edx,0x4(%eax)
  803bf9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bfc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803bff:	89 10                	mov    %edx,(%eax)
  803c01:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c07:	89 50 04             	mov    %edx,0x4(%eax)
  803c0a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c0d:	8b 00                	mov    (%eax),%eax
  803c0f:	85 c0                	test   %eax,%eax
  803c11:	75 08                	jne    803c1b <realloc_block_FF+0x199>
  803c13:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803c16:	a3 38 50 80 00       	mov    %eax,0x805038
  803c1b:	a1 40 50 80 00       	mov    0x805040,%eax
  803c20:	40                   	inc    %eax
  803c21:	a3 40 50 80 00       	mov    %eax,0x805040
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803c26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c2a:	75 17                	jne    803c43 <realloc_block_FF+0x1c1>
  803c2c:	83 ec 04             	sub    $0x4,%esp
  803c2f:	68 13 4d 80 00       	push   $0x804d13
  803c34:	68 f7 01 00 00       	push   $0x1f7
  803c39:	68 31 4d 80 00       	push   $0x804d31
  803c3e:	e8 53 cc ff ff       	call   800896 <_panic>
  803c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c46:	8b 00                	mov    (%eax),%eax
  803c48:	85 c0                	test   %eax,%eax
  803c4a:	74 10                	je     803c5c <realloc_block_FF+0x1da>
  803c4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c4f:	8b 00                	mov    (%eax),%eax
  803c51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c54:	8b 52 04             	mov    0x4(%edx),%edx
  803c57:	89 50 04             	mov    %edx,0x4(%eax)
  803c5a:	eb 0b                	jmp    803c67 <realloc_block_FF+0x1e5>
  803c5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5f:	8b 40 04             	mov    0x4(%eax),%eax
  803c62:	a3 38 50 80 00       	mov    %eax,0x805038
  803c67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c6a:	8b 40 04             	mov    0x4(%eax),%eax
  803c6d:	85 c0                	test   %eax,%eax
  803c6f:	74 0f                	je     803c80 <realloc_block_FF+0x1fe>
  803c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c74:	8b 40 04             	mov    0x4(%eax),%eax
  803c77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c7a:	8b 12                	mov    (%edx),%edx
  803c7c:	89 10                	mov    %edx,(%eax)
  803c7e:	eb 0a                	jmp    803c8a <realloc_block_FF+0x208>
  803c80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c83:	8b 00                	mov    (%eax),%eax
  803c85:	a3 34 50 80 00       	mov    %eax,0x805034
  803c8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c9d:	a1 40 50 80 00       	mov    0x805040,%eax
  803ca2:	48                   	dec    %eax
  803ca3:	a3 40 50 80 00       	mov    %eax,0x805040
  803ca8:	e9 83 02 00 00       	jmp    803f30 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803cad:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803cb1:	0f 86 69 02 00 00    	jbe    803f20 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803cb7:	83 ec 04             	sub    $0x4,%esp
  803cba:	6a 01                	push   $0x1
  803cbc:	ff 75 f0             	pushl  -0x10(%ebp)
  803cbf:	ff 75 08             	pushl  0x8(%ebp)
  803cc2:	e8 c8 ed ff ff       	call   802a8f <set_block_data>
  803cc7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803cca:	8b 45 08             	mov    0x8(%ebp),%eax
  803ccd:	83 e8 04             	sub    $0x4,%eax
  803cd0:	8b 00                	mov    (%eax),%eax
  803cd2:	83 e0 fe             	and    $0xfffffffe,%eax
  803cd5:	89 c2                	mov    %eax,%edx
  803cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cda:	01 d0                	add    %edx,%eax
  803cdc:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803cdf:	a1 40 50 80 00       	mov    0x805040,%eax
  803ce4:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803ce7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803ceb:	75 68                	jne    803d55 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ced:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cf1:	75 17                	jne    803d0a <realloc_block_FF+0x288>
  803cf3:	83 ec 04             	sub    $0x4,%esp
  803cf6:	68 4c 4d 80 00       	push   $0x804d4c
  803cfb:	68 06 02 00 00       	push   $0x206
  803d00:	68 31 4d 80 00       	push   $0x804d31
  803d05:	e8 8c cb ff ff       	call   800896 <_panic>
  803d0a:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803d10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d13:	89 10                	mov    %edx,(%eax)
  803d15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d18:	8b 00                	mov    (%eax),%eax
  803d1a:	85 c0                	test   %eax,%eax
  803d1c:	74 0d                	je     803d2b <realloc_block_FF+0x2a9>
  803d1e:	a1 34 50 80 00       	mov    0x805034,%eax
  803d23:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d26:	89 50 04             	mov    %edx,0x4(%eax)
  803d29:	eb 08                	jmp    803d33 <realloc_block_FF+0x2b1>
  803d2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d2e:	a3 38 50 80 00       	mov    %eax,0x805038
  803d33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d36:	a3 34 50 80 00       	mov    %eax,0x805034
  803d3b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d45:	a1 40 50 80 00       	mov    0x805040,%eax
  803d4a:	40                   	inc    %eax
  803d4b:	a3 40 50 80 00       	mov    %eax,0x805040
  803d50:	e9 b0 01 00 00       	jmp    803f05 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803d55:	a1 34 50 80 00       	mov    0x805034,%eax
  803d5a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d5d:	76 68                	jbe    803dc7 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803d5f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d63:	75 17                	jne    803d7c <realloc_block_FF+0x2fa>
  803d65:	83 ec 04             	sub    $0x4,%esp
  803d68:	68 4c 4d 80 00       	push   $0x804d4c
  803d6d:	68 0b 02 00 00       	push   $0x20b
  803d72:	68 31 4d 80 00       	push   $0x804d31
  803d77:	e8 1a cb ff ff       	call   800896 <_panic>
  803d7c:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803d82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d85:	89 10                	mov    %edx,(%eax)
  803d87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d8a:	8b 00                	mov    (%eax),%eax
  803d8c:	85 c0                	test   %eax,%eax
  803d8e:	74 0d                	je     803d9d <realloc_block_FF+0x31b>
  803d90:	a1 34 50 80 00       	mov    0x805034,%eax
  803d95:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d98:	89 50 04             	mov    %edx,0x4(%eax)
  803d9b:	eb 08                	jmp    803da5 <realloc_block_FF+0x323>
  803d9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803da0:	a3 38 50 80 00       	mov    %eax,0x805038
  803da5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803da8:	a3 34 50 80 00       	mov    %eax,0x805034
  803dad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803db0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803db7:	a1 40 50 80 00       	mov    0x805040,%eax
  803dbc:	40                   	inc    %eax
  803dbd:	a3 40 50 80 00       	mov    %eax,0x805040
  803dc2:	e9 3e 01 00 00       	jmp    803f05 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803dc7:	a1 34 50 80 00       	mov    0x805034,%eax
  803dcc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803dcf:	73 68                	jae    803e39 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803dd1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803dd5:	75 17                	jne    803dee <realloc_block_FF+0x36c>
  803dd7:	83 ec 04             	sub    $0x4,%esp
  803dda:	68 80 4d 80 00       	push   $0x804d80
  803ddf:	68 10 02 00 00       	push   $0x210
  803de4:	68 31 4d 80 00       	push   $0x804d31
  803de9:	e8 a8 ca ff ff       	call   800896 <_panic>
  803dee:	8b 15 38 50 80 00    	mov    0x805038,%edx
  803df4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803df7:	89 50 04             	mov    %edx,0x4(%eax)
  803dfa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dfd:	8b 40 04             	mov    0x4(%eax),%eax
  803e00:	85 c0                	test   %eax,%eax
  803e02:	74 0c                	je     803e10 <realloc_block_FF+0x38e>
  803e04:	a1 38 50 80 00       	mov    0x805038,%eax
  803e09:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e0c:	89 10                	mov    %edx,(%eax)
  803e0e:	eb 08                	jmp    803e18 <realloc_block_FF+0x396>
  803e10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e13:	a3 34 50 80 00       	mov    %eax,0x805034
  803e18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e1b:	a3 38 50 80 00       	mov    %eax,0x805038
  803e20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e29:	a1 40 50 80 00       	mov    0x805040,%eax
  803e2e:	40                   	inc    %eax
  803e2f:	a3 40 50 80 00       	mov    %eax,0x805040
  803e34:	e9 cc 00 00 00       	jmp    803f05 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803e39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803e40:	a1 34 50 80 00       	mov    0x805034,%eax
  803e45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e48:	e9 8a 00 00 00       	jmp    803ed7 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e50:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e53:	73 7a                	jae    803ecf <realloc_block_FF+0x44d>
  803e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e58:	8b 00                	mov    (%eax),%eax
  803e5a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803e5d:	73 70                	jae    803ecf <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803e5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e63:	74 06                	je     803e6b <realloc_block_FF+0x3e9>
  803e65:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803e69:	75 17                	jne    803e82 <realloc_block_FF+0x400>
  803e6b:	83 ec 04             	sub    $0x4,%esp
  803e6e:	68 a4 4d 80 00       	push   $0x804da4
  803e73:	68 1a 02 00 00       	push   $0x21a
  803e78:	68 31 4d 80 00       	push   $0x804d31
  803e7d:	e8 14 ca ff ff       	call   800896 <_panic>
  803e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e85:	8b 10                	mov    (%eax),%edx
  803e87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e8a:	89 10                	mov    %edx,(%eax)
  803e8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803e8f:	8b 00                	mov    (%eax),%eax
  803e91:	85 c0                	test   %eax,%eax
  803e93:	74 0b                	je     803ea0 <realloc_block_FF+0x41e>
  803e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e98:	8b 00                	mov    (%eax),%eax
  803e9a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803e9d:	89 50 04             	mov    %edx,0x4(%eax)
  803ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ea6:	89 10                	mov    %edx,(%eax)
  803ea8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803eae:	89 50 04             	mov    %edx,0x4(%eax)
  803eb1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803eb4:	8b 00                	mov    (%eax),%eax
  803eb6:	85 c0                	test   %eax,%eax
  803eb8:	75 08                	jne    803ec2 <realloc_block_FF+0x440>
  803eba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ebd:	a3 38 50 80 00       	mov    %eax,0x805038
  803ec2:	a1 40 50 80 00       	mov    0x805040,%eax
  803ec7:	40                   	inc    %eax
  803ec8:	a3 40 50 80 00       	mov    %eax,0x805040
							break;
  803ecd:	eb 36                	jmp    803f05 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803ecf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ed4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ed7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803edb:	74 07                	je     803ee4 <realloc_block_FF+0x462>
  803edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee0:	8b 00                	mov    (%eax),%eax
  803ee2:	eb 05                	jmp    803ee9 <realloc_block_FF+0x467>
  803ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  803ee9:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803eee:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ef3:	85 c0                	test   %eax,%eax
  803ef5:	0f 85 52 ff ff ff    	jne    803e4d <realloc_block_FF+0x3cb>
  803efb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eff:	0f 85 48 ff ff ff    	jne    803e4d <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803f05:	83 ec 04             	sub    $0x4,%esp
  803f08:	6a 00                	push   $0x0
  803f0a:	ff 75 d8             	pushl  -0x28(%ebp)
  803f0d:	ff 75 d4             	pushl  -0x2c(%ebp)
  803f10:	e8 7a eb ff ff       	call   802a8f <set_block_data>
  803f15:	83 c4 10             	add    $0x10,%esp
				return va;
  803f18:	8b 45 08             	mov    0x8(%ebp),%eax
  803f1b:	e9 7b 02 00 00       	jmp    80419b <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803f20:	83 ec 0c             	sub    $0xc,%esp
  803f23:	68 21 4e 80 00       	push   $0x804e21
  803f28:	e8 26 cc ff ff       	call   800b53 <cprintf>
  803f2d:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803f30:	8b 45 08             	mov    0x8(%ebp),%eax
  803f33:	e9 63 02 00 00       	jmp    80419b <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f3b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803f3e:	0f 86 4d 02 00 00    	jbe    804191 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803f44:	83 ec 0c             	sub    $0xc,%esp
  803f47:	ff 75 e4             	pushl  -0x1c(%ebp)
  803f4a:	e8 08 e8 ff ff       	call   802757 <is_free_block>
  803f4f:	83 c4 10             	add    $0x10,%esp
  803f52:	84 c0                	test   %al,%al
  803f54:	0f 84 37 02 00 00    	je     804191 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f5d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803f60:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803f63:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f66:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803f69:	76 38                	jbe    803fa3 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803f6b:	83 ec 0c             	sub    $0xc,%esp
  803f6e:	ff 75 08             	pushl  0x8(%ebp)
  803f71:	e8 0c fa ff ff       	call   803982 <free_block>
  803f76:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803f79:	83 ec 0c             	sub    $0xc,%esp
  803f7c:	ff 75 0c             	pushl  0xc(%ebp)
  803f7f:	e8 3a eb ff ff       	call   802abe <alloc_block_FF>
  803f84:	83 c4 10             	add    $0x10,%esp
  803f87:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803f8a:	83 ec 08             	sub    $0x8,%esp
  803f8d:	ff 75 c0             	pushl  -0x40(%ebp)
  803f90:	ff 75 08             	pushl  0x8(%ebp)
  803f93:	e8 ab fa ff ff       	call   803a43 <copy_data>
  803f98:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803f9b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803f9e:	e9 f8 01 00 00       	jmp    80419b <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803fa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fa6:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803fa9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803fac:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803fb0:	0f 87 a0 00 00 00    	ja     804056 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803fb6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fba:	75 17                	jne    803fd3 <realloc_block_FF+0x551>
  803fbc:	83 ec 04             	sub    $0x4,%esp
  803fbf:	68 13 4d 80 00       	push   $0x804d13
  803fc4:	68 38 02 00 00       	push   $0x238
  803fc9:	68 31 4d 80 00       	push   $0x804d31
  803fce:	e8 c3 c8 ff ff       	call   800896 <_panic>
  803fd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd6:	8b 00                	mov    (%eax),%eax
  803fd8:	85 c0                	test   %eax,%eax
  803fda:	74 10                	je     803fec <realloc_block_FF+0x56a>
  803fdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fdf:	8b 00                	mov    (%eax),%eax
  803fe1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fe4:	8b 52 04             	mov    0x4(%edx),%edx
  803fe7:	89 50 04             	mov    %edx,0x4(%eax)
  803fea:	eb 0b                	jmp    803ff7 <realloc_block_FF+0x575>
  803fec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fef:	8b 40 04             	mov    0x4(%eax),%eax
  803ff2:	a3 38 50 80 00       	mov    %eax,0x805038
  803ff7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ffa:	8b 40 04             	mov    0x4(%eax),%eax
  803ffd:	85 c0                	test   %eax,%eax
  803fff:	74 0f                	je     804010 <realloc_block_FF+0x58e>
  804001:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804004:	8b 40 04             	mov    0x4(%eax),%eax
  804007:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80400a:	8b 12                	mov    (%edx),%edx
  80400c:	89 10                	mov    %edx,(%eax)
  80400e:	eb 0a                	jmp    80401a <realloc_block_FF+0x598>
  804010:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804013:	8b 00                	mov    (%eax),%eax
  804015:	a3 34 50 80 00       	mov    %eax,0x805034
  80401a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80401d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804023:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804026:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80402d:	a1 40 50 80 00       	mov    0x805040,%eax
  804032:	48                   	dec    %eax
  804033:	a3 40 50 80 00       	mov    %eax,0x805040

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804038:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80403b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80403e:	01 d0                	add    %edx,%eax
  804040:	83 ec 04             	sub    $0x4,%esp
  804043:	6a 01                	push   $0x1
  804045:	50                   	push   %eax
  804046:	ff 75 08             	pushl  0x8(%ebp)
  804049:	e8 41 ea ff ff       	call   802a8f <set_block_data>
  80404e:	83 c4 10             	add    $0x10,%esp
  804051:	e9 36 01 00 00       	jmp    80418c <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804056:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804059:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80405c:	01 d0                	add    %edx,%eax
  80405e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804061:	83 ec 04             	sub    $0x4,%esp
  804064:	6a 01                	push   $0x1
  804066:	ff 75 f0             	pushl  -0x10(%ebp)
  804069:	ff 75 08             	pushl  0x8(%ebp)
  80406c:	e8 1e ea ff ff       	call   802a8f <set_block_data>
  804071:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804074:	8b 45 08             	mov    0x8(%ebp),%eax
  804077:	83 e8 04             	sub    $0x4,%eax
  80407a:	8b 00                	mov    (%eax),%eax
  80407c:	83 e0 fe             	and    $0xfffffffe,%eax
  80407f:	89 c2                	mov    %eax,%edx
  804081:	8b 45 08             	mov    0x8(%ebp),%eax
  804084:	01 d0                	add    %edx,%eax
  804086:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804089:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80408d:	74 06                	je     804095 <realloc_block_FF+0x613>
  80408f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804093:	75 17                	jne    8040ac <realloc_block_FF+0x62a>
  804095:	83 ec 04             	sub    $0x4,%esp
  804098:	68 a4 4d 80 00       	push   $0x804da4
  80409d:	68 44 02 00 00       	push   $0x244
  8040a2:	68 31 4d 80 00       	push   $0x804d31
  8040a7:	e8 ea c7 ff ff       	call   800896 <_panic>
  8040ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040af:	8b 10                	mov    (%eax),%edx
  8040b1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040b4:	89 10                	mov    %edx,(%eax)
  8040b6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040b9:	8b 00                	mov    (%eax),%eax
  8040bb:	85 c0                	test   %eax,%eax
  8040bd:	74 0b                	je     8040ca <realloc_block_FF+0x648>
  8040bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040c2:	8b 00                	mov    (%eax),%eax
  8040c4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8040c7:	89 50 04             	mov    %edx,0x4(%eax)
  8040ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040cd:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8040d0:	89 10                	mov    %edx,(%eax)
  8040d2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040d8:	89 50 04             	mov    %edx,0x4(%eax)
  8040db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040de:	8b 00                	mov    (%eax),%eax
  8040e0:	85 c0                	test   %eax,%eax
  8040e2:	75 08                	jne    8040ec <realloc_block_FF+0x66a>
  8040e4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8040e7:	a3 38 50 80 00       	mov    %eax,0x805038
  8040ec:	a1 40 50 80 00       	mov    0x805040,%eax
  8040f1:	40                   	inc    %eax
  8040f2:	a3 40 50 80 00       	mov    %eax,0x805040
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8040f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040fb:	75 17                	jne    804114 <realloc_block_FF+0x692>
  8040fd:	83 ec 04             	sub    $0x4,%esp
  804100:	68 13 4d 80 00       	push   $0x804d13
  804105:	68 45 02 00 00       	push   $0x245
  80410a:	68 31 4d 80 00       	push   $0x804d31
  80410f:	e8 82 c7 ff ff       	call   800896 <_panic>
  804114:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804117:	8b 00                	mov    (%eax),%eax
  804119:	85 c0                	test   %eax,%eax
  80411b:	74 10                	je     80412d <realloc_block_FF+0x6ab>
  80411d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804120:	8b 00                	mov    (%eax),%eax
  804122:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804125:	8b 52 04             	mov    0x4(%edx),%edx
  804128:	89 50 04             	mov    %edx,0x4(%eax)
  80412b:	eb 0b                	jmp    804138 <realloc_block_FF+0x6b6>
  80412d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804130:	8b 40 04             	mov    0x4(%eax),%eax
  804133:	a3 38 50 80 00       	mov    %eax,0x805038
  804138:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80413b:	8b 40 04             	mov    0x4(%eax),%eax
  80413e:	85 c0                	test   %eax,%eax
  804140:	74 0f                	je     804151 <realloc_block_FF+0x6cf>
  804142:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804145:	8b 40 04             	mov    0x4(%eax),%eax
  804148:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80414b:	8b 12                	mov    (%edx),%edx
  80414d:	89 10                	mov    %edx,(%eax)
  80414f:	eb 0a                	jmp    80415b <realloc_block_FF+0x6d9>
  804151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804154:	8b 00                	mov    (%eax),%eax
  804156:	a3 34 50 80 00       	mov    %eax,0x805034
  80415b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80415e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804167:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80416e:	a1 40 50 80 00       	mov    0x805040,%eax
  804173:	48                   	dec    %eax
  804174:	a3 40 50 80 00       	mov    %eax,0x805040
				set_block_data(next_new_va, remaining_size, 0);
  804179:	83 ec 04             	sub    $0x4,%esp
  80417c:	6a 00                	push   $0x0
  80417e:	ff 75 bc             	pushl  -0x44(%ebp)
  804181:	ff 75 b8             	pushl  -0x48(%ebp)
  804184:	e8 06 e9 ff ff       	call   802a8f <set_block_data>
  804189:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80418c:	8b 45 08             	mov    0x8(%ebp),%eax
  80418f:	eb 0a                	jmp    80419b <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804191:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804198:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80419b:	c9                   	leave  
  80419c:	c3                   	ret    

0080419d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80419d:	55                   	push   %ebp
  80419e:	89 e5                	mov    %esp,%ebp
  8041a0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8041a3:	83 ec 04             	sub    $0x4,%esp
  8041a6:	68 28 4e 80 00       	push   $0x804e28
  8041ab:	68 58 02 00 00       	push   $0x258
  8041b0:	68 31 4d 80 00       	push   $0x804d31
  8041b5:	e8 dc c6 ff ff       	call   800896 <_panic>

008041ba <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8041ba:	55                   	push   %ebp
  8041bb:	89 e5                	mov    %esp,%ebp
  8041bd:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8041c0:	83 ec 04             	sub    $0x4,%esp
  8041c3:	68 50 4e 80 00       	push   $0x804e50
  8041c8:	68 61 02 00 00       	push   $0x261
  8041cd:	68 31 4d 80 00       	push   $0x804d31
  8041d2:	e8 bf c6 ff ff       	call   800896 <_panic>
  8041d7:	90                   	nop

008041d8 <__udivdi3>:
  8041d8:	55                   	push   %ebp
  8041d9:	57                   	push   %edi
  8041da:	56                   	push   %esi
  8041db:	53                   	push   %ebx
  8041dc:	83 ec 1c             	sub    $0x1c,%esp
  8041df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8041e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8041e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8041ef:	89 ca                	mov    %ecx,%edx
  8041f1:	89 f8                	mov    %edi,%eax
  8041f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8041f7:	85 f6                	test   %esi,%esi
  8041f9:	75 2d                	jne    804228 <__udivdi3+0x50>
  8041fb:	39 cf                	cmp    %ecx,%edi
  8041fd:	77 65                	ja     804264 <__udivdi3+0x8c>
  8041ff:	89 fd                	mov    %edi,%ebp
  804201:	85 ff                	test   %edi,%edi
  804203:	75 0b                	jne    804210 <__udivdi3+0x38>
  804205:	b8 01 00 00 00       	mov    $0x1,%eax
  80420a:	31 d2                	xor    %edx,%edx
  80420c:	f7 f7                	div    %edi
  80420e:	89 c5                	mov    %eax,%ebp
  804210:	31 d2                	xor    %edx,%edx
  804212:	89 c8                	mov    %ecx,%eax
  804214:	f7 f5                	div    %ebp
  804216:	89 c1                	mov    %eax,%ecx
  804218:	89 d8                	mov    %ebx,%eax
  80421a:	f7 f5                	div    %ebp
  80421c:	89 cf                	mov    %ecx,%edi
  80421e:	89 fa                	mov    %edi,%edx
  804220:	83 c4 1c             	add    $0x1c,%esp
  804223:	5b                   	pop    %ebx
  804224:	5e                   	pop    %esi
  804225:	5f                   	pop    %edi
  804226:	5d                   	pop    %ebp
  804227:	c3                   	ret    
  804228:	39 ce                	cmp    %ecx,%esi
  80422a:	77 28                	ja     804254 <__udivdi3+0x7c>
  80422c:	0f bd fe             	bsr    %esi,%edi
  80422f:	83 f7 1f             	xor    $0x1f,%edi
  804232:	75 40                	jne    804274 <__udivdi3+0x9c>
  804234:	39 ce                	cmp    %ecx,%esi
  804236:	72 0a                	jb     804242 <__udivdi3+0x6a>
  804238:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80423c:	0f 87 9e 00 00 00    	ja     8042e0 <__udivdi3+0x108>
  804242:	b8 01 00 00 00       	mov    $0x1,%eax
  804247:	89 fa                	mov    %edi,%edx
  804249:	83 c4 1c             	add    $0x1c,%esp
  80424c:	5b                   	pop    %ebx
  80424d:	5e                   	pop    %esi
  80424e:	5f                   	pop    %edi
  80424f:	5d                   	pop    %ebp
  804250:	c3                   	ret    
  804251:	8d 76 00             	lea    0x0(%esi),%esi
  804254:	31 ff                	xor    %edi,%edi
  804256:	31 c0                	xor    %eax,%eax
  804258:	89 fa                	mov    %edi,%edx
  80425a:	83 c4 1c             	add    $0x1c,%esp
  80425d:	5b                   	pop    %ebx
  80425e:	5e                   	pop    %esi
  80425f:	5f                   	pop    %edi
  804260:	5d                   	pop    %ebp
  804261:	c3                   	ret    
  804262:	66 90                	xchg   %ax,%ax
  804264:	89 d8                	mov    %ebx,%eax
  804266:	f7 f7                	div    %edi
  804268:	31 ff                	xor    %edi,%edi
  80426a:	89 fa                	mov    %edi,%edx
  80426c:	83 c4 1c             	add    $0x1c,%esp
  80426f:	5b                   	pop    %ebx
  804270:	5e                   	pop    %esi
  804271:	5f                   	pop    %edi
  804272:	5d                   	pop    %ebp
  804273:	c3                   	ret    
  804274:	bd 20 00 00 00       	mov    $0x20,%ebp
  804279:	89 eb                	mov    %ebp,%ebx
  80427b:	29 fb                	sub    %edi,%ebx
  80427d:	89 f9                	mov    %edi,%ecx
  80427f:	d3 e6                	shl    %cl,%esi
  804281:	89 c5                	mov    %eax,%ebp
  804283:	88 d9                	mov    %bl,%cl
  804285:	d3 ed                	shr    %cl,%ebp
  804287:	89 e9                	mov    %ebp,%ecx
  804289:	09 f1                	or     %esi,%ecx
  80428b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80428f:	89 f9                	mov    %edi,%ecx
  804291:	d3 e0                	shl    %cl,%eax
  804293:	89 c5                	mov    %eax,%ebp
  804295:	89 d6                	mov    %edx,%esi
  804297:	88 d9                	mov    %bl,%cl
  804299:	d3 ee                	shr    %cl,%esi
  80429b:	89 f9                	mov    %edi,%ecx
  80429d:	d3 e2                	shl    %cl,%edx
  80429f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042a3:	88 d9                	mov    %bl,%cl
  8042a5:	d3 e8                	shr    %cl,%eax
  8042a7:	09 c2                	or     %eax,%edx
  8042a9:	89 d0                	mov    %edx,%eax
  8042ab:	89 f2                	mov    %esi,%edx
  8042ad:	f7 74 24 0c          	divl   0xc(%esp)
  8042b1:	89 d6                	mov    %edx,%esi
  8042b3:	89 c3                	mov    %eax,%ebx
  8042b5:	f7 e5                	mul    %ebp
  8042b7:	39 d6                	cmp    %edx,%esi
  8042b9:	72 19                	jb     8042d4 <__udivdi3+0xfc>
  8042bb:	74 0b                	je     8042c8 <__udivdi3+0xf0>
  8042bd:	89 d8                	mov    %ebx,%eax
  8042bf:	31 ff                	xor    %edi,%edi
  8042c1:	e9 58 ff ff ff       	jmp    80421e <__udivdi3+0x46>
  8042c6:	66 90                	xchg   %ax,%ax
  8042c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8042cc:	89 f9                	mov    %edi,%ecx
  8042ce:	d3 e2                	shl    %cl,%edx
  8042d0:	39 c2                	cmp    %eax,%edx
  8042d2:	73 e9                	jae    8042bd <__udivdi3+0xe5>
  8042d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8042d7:	31 ff                	xor    %edi,%edi
  8042d9:	e9 40 ff ff ff       	jmp    80421e <__udivdi3+0x46>
  8042de:	66 90                	xchg   %ax,%ax
  8042e0:	31 c0                	xor    %eax,%eax
  8042e2:	e9 37 ff ff ff       	jmp    80421e <__udivdi3+0x46>
  8042e7:	90                   	nop

008042e8 <__umoddi3>:
  8042e8:	55                   	push   %ebp
  8042e9:	57                   	push   %edi
  8042ea:	56                   	push   %esi
  8042eb:	53                   	push   %ebx
  8042ec:	83 ec 1c             	sub    $0x1c,%esp
  8042ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8042f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8042f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8042ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804303:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804307:	89 f3                	mov    %esi,%ebx
  804309:	89 fa                	mov    %edi,%edx
  80430b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80430f:	89 34 24             	mov    %esi,(%esp)
  804312:	85 c0                	test   %eax,%eax
  804314:	75 1a                	jne    804330 <__umoddi3+0x48>
  804316:	39 f7                	cmp    %esi,%edi
  804318:	0f 86 a2 00 00 00    	jbe    8043c0 <__umoddi3+0xd8>
  80431e:	89 c8                	mov    %ecx,%eax
  804320:	89 f2                	mov    %esi,%edx
  804322:	f7 f7                	div    %edi
  804324:	89 d0                	mov    %edx,%eax
  804326:	31 d2                	xor    %edx,%edx
  804328:	83 c4 1c             	add    $0x1c,%esp
  80432b:	5b                   	pop    %ebx
  80432c:	5e                   	pop    %esi
  80432d:	5f                   	pop    %edi
  80432e:	5d                   	pop    %ebp
  80432f:	c3                   	ret    
  804330:	39 f0                	cmp    %esi,%eax
  804332:	0f 87 ac 00 00 00    	ja     8043e4 <__umoddi3+0xfc>
  804338:	0f bd e8             	bsr    %eax,%ebp
  80433b:	83 f5 1f             	xor    $0x1f,%ebp
  80433e:	0f 84 ac 00 00 00    	je     8043f0 <__umoddi3+0x108>
  804344:	bf 20 00 00 00       	mov    $0x20,%edi
  804349:	29 ef                	sub    %ebp,%edi
  80434b:	89 fe                	mov    %edi,%esi
  80434d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804351:	89 e9                	mov    %ebp,%ecx
  804353:	d3 e0                	shl    %cl,%eax
  804355:	89 d7                	mov    %edx,%edi
  804357:	89 f1                	mov    %esi,%ecx
  804359:	d3 ef                	shr    %cl,%edi
  80435b:	09 c7                	or     %eax,%edi
  80435d:	89 e9                	mov    %ebp,%ecx
  80435f:	d3 e2                	shl    %cl,%edx
  804361:	89 14 24             	mov    %edx,(%esp)
  804364:	89 d8                	mov    %ebx,%eax
  804366:	d3 e0                	shl    %cl,%eax
  804368:	89 c2                	mov    %eax,%edx
  80436a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80436e:	d3 e0                	shl    %cl,%eax
  804370:	89 44 24 04          	mov    %eax,0x4(%esp)
  804374:	8b 44 24 08          	mov    0x8(%esp),%eax
  804378:	89 f1                	mov    %esi,%ecx
  80437a:	d3 e8                	shr    %cl,%eax
  80437c:	09 d0                	or     %edx,%eax
  80437e:	d3 eb                	shr    %cl,%ebx
  804380:	89 da                	mov    %ebx,%edx
  804382:	f7 f7                	div    %edi
  804384:	89 d3                	mov    %edx,%ebx
  804386:	f7 24 24             	mull   (%esp)
  804389:	89 c6                	mov    %eax,%esi
  80438b:	89 d1                	mov    %edx,%ecx
  80438d:	39 d3                	cmp    %edx,%ebx
  80438f:	0f 82 87 00 00 00    	jb     80441c <__umoddi3+0x134>
  804395:	0f 84 91 00 00 00    	je     80442c <__umoddi3+0x144>
  80439b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80439f:	29 f2                	sub    %esi,%edx
  8043a1:	19 cb                	sbb    %ecx,%ebx
  8043a3:	89 d8                	mov    %ebx,%eax
  8043a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8043a9:	d3 e0                	shl    %cl,%eax
  8043ab:	89 e9                	mov    %ebp,%ecx
  8043ad:	d3 ea                	shr    %cl,%edx
  8043af:	09 d0                	or     %edx,%eax
  8043b1:	89 e9                	mov    %ebp,%ecx
  8043b3:	d3 eb                	shr    %cl,%ebx
  8043b5:	89 da                	mov    %ebx,%edx
  8043b7:	83 c4 1c             	add    $0x1c,%esp
  8043ba:	5b                   	pop    %ebx
  8043bb:	5e                   	pop    %esi
  8043bc:	5f                   	pop    %edi
  8043bd:	5d                   	pop    %ebp
  8043be:	c3                   	ret    
  8043bf:	90                   	nop
  8043c0:	89 fd                	mov    %edi,%ebp
  8043c2:	85 ff                	test   %edi,%edi
  8043c4:	75 0b                	jne    8043d1 <__umoddi3+0xe9>
  8043c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8043cb:	31 d2                	xor    %edx,%edx
  8043cd:	f7 f7                	div    %edi
  8043cf:	89 c5                	mov    %eax,%ebp
  8043d1:	89 f0                	mov    %esi,%eax
  8043d3:	31 d2                	xor    %edx,%edx
  8043d5:	f7 f5                	div    %ebp
  8043d7:	89 c8                	mov    %ecx,%eax
  8043d9:	f7 f5                	div    %ebp
  8043db:	89 d0                	mov    %edx,%eax
  8043dd:	e9 44 ff ff ff       	jmp    804326 <__umoddi3+0x3e>
  8043e2:	66 90                	xchg   %ax,%ax
  8043e4:	89 c8                	mov    %ecx,%eax
  8043e6:	89 f2                	mov    %esi,%edx
  8043e8:	83 c4 1c             	add    $0x1c,%esp
  8043eb:	5b                   	pop    %ebx
  8043ec:	5e                   	pop    %esi
  8043ed:	5f                   	pop    %edi
  8043ee:	5d                   	pop    %ebp
  8043ef:	c3                   	ret    
  8043f0:	3b 04 24             	cmp    (%esp),%eax
  8043f3:	72 06                	jb     8043fb <__umoddi3+0x113>
  8043f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8043f9:	77 0f                	ja     80440a <__umoddi3+0x122>
  8043fb:	89 f2                	mov    %esi,%edx
  8043fd:	29 f9                	sub    %edi,%ecx
  8043ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804403:	89 14 24             	mov    %edx,(%esp)
  804406:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80440a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80440e:	8b 14 24             	mov    (%esp),%edx
  804411:	83 c4 1c             	add    $0x1c,%esp
  804414:	5b                   	pop    %ebx
  804415:	5e                   	pop    %esi
  804416:	5f                   	pop    %edi
  804417:	5d                   	pop    %ebp
  804418:	c3                   	ret    
  804419:	8d 76 00             	lea    0x0(%esi),%esi
  80441c:	2b 04 24             	sub    (%esp),%eax
  80441f:	19 fa                	sbb    %edi,%edx
  804421:	89 d1                	mov    %edx,%ecx
  804423:	89 c6                	mov    %eax,%esi
  804425:	e9 71 ff ff ff       	jmp    80439b <__umoddi3+0xb3>
  80442a:	66 90                	xchg   %ax,%ax
  80442c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804430:	72 ea                	jb     80441c <__umoddi3+0x134>
  804432:	89 d9                	mov    %ebx,%ecx
  804434:	e9 62 ff ff ff       	jmp    80439b <__umoddi3+0xb3>
