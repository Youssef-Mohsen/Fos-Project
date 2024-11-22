
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
  800041:	e8 8c 1f 00 00       	call   801fd2 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 42 80 00       	push   $0x8042a0
  80004e:	e8 00 0b 00 00       	call   800b53 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 42 80 00       	push   $0x8042a2
  80005e:	e8 f0 0a 00 00       	call   800b53 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 b8 42 80 00       	push   $0x8042b8
  80006e:	e8 e0 0a 00 00       	call   800b53 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 42 80 00       	push   $0x8042a2
  80007e:	e8 d0 0a 00 00       	call   800b53 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 42 80 00       	push   $0x8042a0
  80008e:	e8 c0 0a 00 00       	call   800b53 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d0 42 80 00       	push   $0x8042d0
  8000a5:	e8 3d 11 00 00       	call   8011e7 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			cprintf("Chose the initialization method:\n") ;
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 f0 42 80 00       	push   $0x8042f0
  8000b5:	e8 99 0a 00 00       	call   800b53 <cprintf>
  8000ba:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	68 12 43 80 00       	push   $0x804312
  8000c5:	e8 89 0a 00 00       	call   800b53 <cprintf>
  8000ca:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	68 20 43 80 00       	push   $0x804320
  8000d5:	e8 79 0a 00 00       	call   800b53 <cprintf>
  8000da:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  8000dd:	83 ec 0c             	sub    $0xc,%esp
  8000e0:	68 2f 43 80 00       	push   $0x80432f
  8000e5:	e8 69 0a 00 00       	call   800b53 <cprintf>
  8000ea:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 3f 43 80 00       	push   $0x80433f
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
  800134:	e8 b3 1e 00 00       	call   801fec <sys_unlock_cons>
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
  8001da:	68 48 43 80 00       	push   $0x804348
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
  800204:	68 7c 43 80 00       	push   $0x80437c
  800209:	6a 4d                	push   $0x4d
  80020b:	68 9e 43 80 00       	push   $0x80439e
  800210:	e8 81 06 00 00       	call   800896 <_panic>
		else
		{
			//sys_lock_cons();
			sys_lock_cons();
  800215:	e8 b8 1d 00 00       	call   801fd2 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 bc 43 80 00       	push   $0x8043bc
  800222:	e8 2c 09 00 00       	call   800b53 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 f0 43 80 00       	push   $0x8043f0
  800232:	e8 1c 09 00 00       	call   800b53 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 24 44 80 00       	push   $0x804424
  800242:	e8 0c 09 00 00       	call   800b53 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  80024a:	e8 9d 1d 00 00       	call   801fec <sys_unlock_cons>
			//sys_unlock_cons();
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 d0 1a 00 00       	call   801d2a <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		//sys_lock_cons();
		sys_lock_cons();
  80025d:	e8 70 1d 00 00       	call   801fd2 <sys_lock_cons>
		{
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 42                	jmp    8002aa <_main+0x272>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 56 44 80 00       	push   $0x804456
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
  8002b6:	e8 31 1d 00 00       	call   801fec <sys_unlock_cons>
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
  80044a:	68 a0 42 80 00       	push   $0x8042a0
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
  80046c:	68 74 44 80 00       	push   $0x804474
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
  80049a:	68 79 44 80 00       	push   $0x804479
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
  80072f:	e8 e9 19 00 00       	call   80211d <sys_cputc>
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
  800740:	e8 74 18 00 00       	call   801fb9 <sys_cgetc>
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
  80075d:	e8 ec 1a 00 00       	call   80224e <sys_getenvindex>
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
  8007cb:	e8 02 18 00 00       	call   801fd2 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8007d0:	83 ec 0c             	sub    $0xc,%esp
  8007d3:	68 98 44 80 00       	push   $0x804498
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
  8007fb:	68 c0 44 80 00       	push   $0x8044c0
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
  80082c:	68 e8 44 80 00       	push   $0x8044e8
  800831:	e8 1d 03 00 00       	call   800b53 <cprintf>
  800836:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800839:	a1 24 50 80 00       	mov    0x805024,%eax
  80083e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	50                   	push   %eax
  800848:	68 40 45 80 00       	push   $0x804540
  80084d:	e8 01 03 00 00       	call   800b53 <cprintf>
  800852:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800855:	83 ec 0c             	sub    $0xc,%esp
  800858:	68 98 44 80 00       	push   $0x804498
  80085d:	e8 f1 02 00 00       	call   800b53 <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800865:	e8 82 17 00 00       	call   801fec <sys_unlock_cons>
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
  80087d:	e8 98 19 00 00       	call   80221a <sys_destroy_env>
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
  80088e:	e8 ed 19 00 00       	call   802280 <sys_exit_env>
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
  8008b7:	68 54 45 80 00       	push   $0x804554
  8008bc:	e8 92 02 00 00       	call   800b53 <cprintf>
  8008c1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008c4:	a1 00 50 80 00       	mov    0x805000,%eax
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	ff 75 08             	pushl  0x8(%ebp)
  8008cf:	50                   	push   %eax
  8008d0:	68 59 45 80 00       	push   $0x804559
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
  8008f4:	68 75 45 80 00       	push   $0x804575
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
  800923:	68 78 45 80 00       	push   $0x804578
  800928:	6a 26                	push   $0x26
  80092a:	68 c4 45 80 00       	push   $0x8045c4
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
  8009f8:	68 d0 45 80 00       	push   $0x8045d0
  8009fd:	6a 3a                	push   $0x3a
  8009ff:	68 c4 45 80 00       	push   $0x8045c4
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
  800a6b:	68 24 46 80 00       	push   $0x804624
  800a70:	6a 44                	push   $0x44
  800a72:	68 c4 45 80 00       	push   $0x8045c4
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
  800ac5:	e8 c6 14 00 00       	call   801f90 <sys_cputs>
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
  800b3c:	e8 4f 14 00 00       	call   801f90 <sys_cputs>
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
  800b86:	e8 47 14 00 00       	call   801fd2 <sys_lock_cons>
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
  800ba6:	e8 41 14 00 00       	call   801fec <sys_unlock_cons>
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
  800bf0:	e8 33 34 00 00       	call   804028 <__udivdi3>
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
  800c40:	e8 f3 34 00 00       	call   804138 <__umoddi3>
  800c45:	83 c4 10             	add    $0x10,%esp
  800c48:	05 94 48 80 00       	add    $0x804894,%eax
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
  800d9b:	8b 04 85 b8 48 80 00 	mov    0x8048b8(,%eax,4),%eax
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
  800e7c:	8b 34 9d 00 47 80 00 	mov    0x804700(,%ebx,4),%esi
  800e83:	85 f6                	test   %esi,%esi
  800e85:	75 19                	jne    800ea0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e87:	53                   	push   %ebx
  800e88:	68 a5 48 80 00       	push   $0x8048a5
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
  800ea1:	68 ae 48 80 00       	push   $0x8048ae
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
  800ece:	be b1 48 80 00       	mov    $0x8048b1,%esi
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
  8011f9:	68 28 4a 80 00       	push   $0x804a28
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
  80123b:	68 2b 4a 80 00       	push   $0x804a2b
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
  8012ec:	e8 e1 0c 00 00       	call   801fd2 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012f5:	74 13                	je     80130a <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012f7:	83 ec 08             	sub    $0x8,%esp
  8012fa:	ff 75 08             	pushl  0x8(%ebp)
  8012fd:	68 28 4a 80 00       	push   $0x804a28
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
  80133f:	68 2b 4a 80 00       	push   $0x804a2b
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
  8013e7:	e8 00 0c 00 00       	call   801fec <sys_unlock_cons>
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
  801ae1:	68 3c 4a 80 00       	push   $0x804a3c
  801ae6:	68 3f 01 00 00       	push   $0x13f
  801aeb:	68 5e 4a 80 00       	push   $0x804a5e
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
  801b01:	e8 35 0a 00 00       	call   80253b <sys_sbrk>
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
  801b7c:	e8 3e 08 00 00       	call   8023bf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b81:	85 c0                	test   %eax,%eax
  801b83:	74 16                	je     801b9b <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b85:	83 ec 0c             	sub    $0xc,%esp
  801b88:	ff 75 08             	pushl  0x8(%ebp)
  801b8b:	e8 7e 0d 00 00       	call   80290e <alloc_block_FF>
  801b90:	83 c4 10             	add    $0x10,%esp
  801b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b96:	e9 8a 01 00 00       	jmp    801d25 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b9b:	e8 50 08 00 00       	call   8023f0 <sys_isUHeapPlacementStrategyBESTFIT>
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	0f 84 7d 01 00 00    	je     801d25 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801ba8:	83 ec 0c             	sub    $0xc,%esp
  801bab:	ff 75 08             	pushl  0x8(%ebp)
  801bae:	e8 17 12 00 00       	call   802dca <alloc_block_BF>
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
  801bfe:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801c4b:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801ca2:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  801d04:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801d0b:	83 ec 08             	sub    $0x8,%esp
  801d0e:	ff 75 08             	pushl  0x8(%ebp)
  801d11:	ff 75 f0             	pushl  -0x10(%ebp)
  801d14:	e8 59 08 00 00       	call   802572 <sys_allocate_user_mem>
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
  801d5c:	e8 2d 08 00 00       	call   80258e <get_block_size>
  801d61:	83 c4 10             	add    $0x10,%esp
  801d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d67:	83 ec 0c             	sub    $0xc,%esp
  801d6a:	ff 75 08             	pushl  0x8(%ebp)
  801d6d:	e8 60 1a 00 00       	call   8037d2 <free_block>
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
  801da7:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801de4:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
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
  801e04:	e8 4d 07 00 00       	call   802556 <sys_free_user_mem>
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
  801e12:	68 6c 4a 80 00       	push   $0x804a6c
  801e17:	68 84 00 00 00       	push   $0x84
  801e1c:	68 96 4a 80 00       	push   $0x804a96
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
  801e38:	75 07                	jne    801e41 <smalloc+0x19>
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3f:	eb 74                	jmp    801eb5 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e47:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e54:	39 d0                	cmp    %edx,%eax
  801e56:	73 02                	jae    801e5a <smalloc+0x32>
  801e58:	89 d0                	mov    %edx,%eax
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	50                   	push   %eax
  801e5e:	e8 a8 fc ff ff       	call   801b0b <malloc>
  801e63:	83 c4 10             	add    $0x10,%esp
  801e66:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801e69:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e6d:	75 07                	jne    801e76 <smalloc+0x4e>
  801e6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e74:	eb 3f                	jmp    801eb5 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e76:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e7a:	ff 75 ec             	pushl  -0x14(%ebp)
  801e7d:	50                   	push   %eax
  801e7e:	ff 75 0c             	pushl  0xc(%ebp)
  801e81:	ff 75 08             	pushl  0x8(%ebp)
  801e84:	e8 d4 02 00 00       	call   80215d <sys_createSharedObject>
  801e89:	83 c4 10             	add    $0x10,%esp
  801e8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e8f:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e93:	74 06                	je     801e9b <smalloc+0x73>
  801e95:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e99:	75 07                	jne    801ea2 <smalloc+0x7a>
  801e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea0:	eb 13                	jmp    801eb5 <smalloc+0x8d>
	 cprintf("153\n");
  801ea2:	83 ec 0c             	sub    $0xc,%esp
  801ea5:	68 a2 4a 80 00       	push   $0x804aa2
  801eaa:	e8 a4 ec ff ff       	call   800b53 <cprintf>
  801eaf:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801ebd:	83 ec 04             	sub    $0x4,%esp
  801ec0:	68 a8 4a 80 00       	push   $0x804aa8
  801ec5:	68 a4 00 00 00       	push   $0xa4
  801eca:	68 96 4a 80 00       	push   $0x804a96
  801ecf:	e8 c2 e9 ff ff       	call   800896 <_panic>

00801ed4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801eda:	83 ec 04             	sub    $0x4,%esp
  801edd:	68 cc 4a 80 00       	push   $0x804acc
  801ee2:	68 bc 00 00 00       	push   $0xbc
  801ee7:	68 96 4a 80 00       	push   $0x804a96
  801eec:	e8 a5 e9 ff ff       	call   800896 <_panic>

00801ef1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ef7:	83 ec 04             	sub    $0x4,%esp
  801efa:	68 f0 4a 80 00       	push   $0x804af0
  801eff:	68 d3 00 00 00       	push   $0xd3
  801f04:	68 96 4a 80 00       	push   $0x804a96
  801f09:	e8 88 e9 ff ff       	call   800896 <_panic>

00801f0e <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
  801f11:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f14:	83 ec 04             	sub    $0x4,%esp
  801f17:	68 16 4b 80 00       	push   $0x804b16
  801f1c:	68 df 00 00 00       	push   $0xdf
  801f21:	68 96 4a 80 00       	push   $0x804a96
  801f26:	e8 6b e9 ff ff       	call   800896 <_panic>

00801f2b <shrink>:

}
void shrink(uint32 newSize)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f31:	83 ec 04             	sub    $0x4,%esp
  801f34:	68 16 4b 80 00       	push   $0x804b16
  801f39:	68 e4 00 00 00       	push   $0xe4
  801f3e:	68 96 4a 80 00       	push   $0x804a96
  801f43:	e8 4e e9 ff ff       	call   800896 <_panic>

00801f48 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f4e:	83 ec 04             	sub    $0x4,%esp
  801f51:	68 16 4b 80 00       	push   $0x804b16
  801f56:	68 e9 00 00 00       	push   $0xe9
  801f5b:	68 96 4a 80 00       	push   $0x804a96
  801f60:	e8 31 e9 ff ff       	call   800896 <_panic>

00801f65 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	57                   	push   %edi
  801f69:	56                   	push   %esi
  801f6a:	53                   	push   %ebx
  801f6b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f74:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f77:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f7a:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f7d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f80:	cd 30                	int    $0x30
  801f82:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	5b                   	pop    %ebx
  801f8c:	5e                   	pop    %esi
  801f8d:	5f                   	pop    %edi
  801f8e:	5d                   	pop    %ebp
  801f8f:	c3                   	ret    

00801f90 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	83 ec 04             	sub    $0x4,%esp
  801f96:	8b 45 10             	mov    0x10(%ebp),%eax
  801f99:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f9c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	52                   	push   %edx
  801fa8:	ff 75 0c             	pushl  0xc(%ebp)
  801fab:	50                   	push   %eax
  801fac:	6a 00                	push   $0x0
  801fae:	e8 b2 ff ff ff       	call   801f65 <syscall>
  801fb3:	83 c4 18             	add    $0x18,%esp
}
  801fb6:	90                   	nop
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <sys_cgetc>:

int
sys_cgetc(void)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 02                	push   $0x2
  801fc8:	e8 98 ff ff ff       	call   801f65 <syscall>
  801fcd:	83 c4 18             	add    $0x18,%esp
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 03                	push   $0x3
  801fe1:	e8 7f ff ff ff       	call   801f65 <syscall>
  801fe6:	83 c4 18             	add    $0x18,%esp
}
  801fe9:	90                   	nop
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 04                	push   $0x4
  801ffb:	e8 65 ff ff ff       	call   801f65 <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
}
  802003:	90                   	nop
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802009:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	52                   	push   %edx
  802016:	50                   	push   %eax
  802017:	6a 08                	push   $0x8
  802019:	e8 47 ff ff ff       	call   801f65 <syscall>
  80201e:	83 c4 18             	add    $0x18,%esp
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	56                   	push   %esi
  802027:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802028:	8b 75 18             	mov    0x18(%ebp),%esi
  80202b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80202e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802031:	8b 55 0c             	mov    0xc(%ebp),%edx
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	56                   	push   %esi
  802038:	53                   	push   %ebx
  802039:	51                   	push   %ecx
  80203a:	52                   	push   %edx
  80203b:	50                   	push   %eax
  80203c:	6a 09                	push   $0x9
  80203e:	e8 22 ff ff ff       	call   801f65 <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
}
  802046:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802049:	5b                   	pop    %ebx
  80204a:	5e                   	pop    %esi
  80204b:	5d                   	pop    %ebp
  80204c:	c3                   	ret    

0080204d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802050:	8b 55 0c             	mov    0xc(%ebp),%edx
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	52                   	push   %edx
  80205d:	50                   	push   %eax
  80205e:	6a 0a                	push   $0xa
  802060:	e8 00 ff ff ff       	call   801f65 <syscall>
  802065:	83 c4 18             	add    $0x18,%esp
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	ff 75 0c             	pushl  0xc(%ebp)
  802076:	ff 75 08             	pushl  0x8(%ebp)
  802079:	6a 0b                	push   $0xb
  80207b:	e8 e5 fe ff ff       	call   801f65 <syscall>
  802080:	83 c4 18             	add    $0x18,%esp
}
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 0c                	push   $0xc
  802094:	e8 cc fe ff ff       	call   801f65 <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
}
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 0d                	push   $0xd
  8020ad:	e8 b3 fe ff ff       	call   801f65 <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 0e                	push   $0xe
  8020c6:	e8 9a fe ff ff       	call   801f65 <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 0f                	push   $0xf
  8020df:	e8 81 fe ff ff       	call   801f65 <syscall>
  8020e4:	83 c4 18             	add    $0x18,%esp
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	ff 75 08             	pushl  0x8(%ebp)
  8020f7:	6a 10                	push   $0x10
  8020f9:	e8 67 fe ff ff       	call   801f65 <syscall>
  8020fe:	83 c4 18             	add    $0x18,%esp
}
  802101:	c9                   	leave  
  802102:	c3                   	ret    

00802103 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 11                	push   $0x11
  802112:	e8 4e fe ff ff       	call   801f65 <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
}
  80211a:	90                   	nop
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <sys_cputc>:

void
sys_cputc(const char c)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	83 ec 04             	sub    $0x4,%esp
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802129:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	50                   	push   %eax
  802136:	6a 01                	push   $0x1
  802138:	e8 28 fe ff ff       	call   801f65 <syscall>
  80213d:	83 c4 18             	add    $0x18,%esp
}
  802140:	90                   	nop
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 14                	push   $0x14
  802152:	e8 0e fe ff ff       	call   801f65 <syscall>
  802157:	83 c4 18             	add    $0x18,%esp
}
  80215a:	90                   	nop
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 04             	sub    $0x4,%esp
  802163:	8b 45 10             	mov    0x10(%ebp),%eax
  802166:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802169:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80216c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	6a 00                	push   $0x0
  802175:	51                   	push   %ecx
  802176:	52                   	push   %edx
  802177:	ff 75 0c             	pushl  0xc(%ebp)
  80217a:	50                   	push   %eax
  80217b:	6a 15                	push   $0x15
  80217d:	e8 e3 fd ff ff       	call   801f65 <syscall>
  802182:	83 c4 18             	add    $0x18,%esp
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80218a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	52                   	push   %edx
  802197:	50                   	push   %eax
  802198:	6a 16                	push   $0x16
  80219a:	e8 c6 fd ff ff       	call   801f65 <syscall>
  80219f:	83 c4 18             	add    $0x18,%esp
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	51                   	push   %ecx
  8021b5:	52                   	push   %edx
  8021b6:	50                   	push   %eax
  8021b7:	6a 17                	push   $0x17
  8021b9:	e8 a7 fd ff ff       	call   801f65 <syscall>
  8021be:	83 c4 18             	add    $0x18,%esp
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	52                   	push   %edx
  8021d3:	50                   	push   %eax
  8021d4:	6a 18                	push   $0x18
  8021d6:	e8 8a fd ff ff       	call   801f65 <syscall>
  8021db:	83 c4 18             	add    $0x18,%esp
}
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	6a 00                	push   $0x0
  8021e8:	ff 75 14             	pushl  0x14(%ebp)
  8021eb:	ff 75 10             	pushl  0x10(%ebp)
  8021ee:	ff 75 0c             	pushl  0xc(%ebp)
  8021f1:	50                   	push   %eax
  8021f2:	6a 19                	push   $0x19
  8021f4:	e8 6c fd ff ff       	call   801f65 <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <sys_run_env>:

void sys_run_env(int32 envId)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	50                   	push   %eax
  80220d:	6a 1a                	push   $0x1a
  80220f:	e8 51 fd ff ff       	call   801f65 <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	90                   	nop
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	50                   	push   %eax
  802229:	6a 1b                	push   $0x1b
  80222b:	e8 35 fd ff ff       	call   801f65 <syscall>
  802230:	83 c4 18             	add    $0x18,%esp
}
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	6a 05                	push   $0x5
  802244:	e8 1c fd ff ff       	call   801f65 <syscall>
  802249:	83 c4 18             	add    $0x18,%esp
}
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 06                	push   $0x6
  80225d:	e8 03 fd ff ff       	call   801f65 <syscall>
  802262:	83 c4 18             	add    $0x18,%esp
}
  802265:	c9                   	leave  
  802266:	c3                   	ret    

00802267 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 07                	push   $0x7
  802276:	e8 ea fc ff ff       	call   801f65 <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_exit_env>:


void sys_exit_env(void)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 1c                	push   $0x1c
  80228f:	e8 d1 fc ff ff       	call   801f65 <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
}
  802297:	90                   	nop
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022a0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022a3:	8d 50 04             	lea    0x4(%eax),%edx
  8022a6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	52                   	push   %edx
  8022b0:	50                   	push   %eax
  8022b1:	6a 1d                	push   $0x1d
  8022b3:	e8 ad fc ff ff       	call   801f65 <syscall>
  8022b8:	83 c4 18             	add    $0x18,%esp
	return result;
  8022bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022c4:	89 01                	mov    %eax,(%ecx)
  8022c6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	c9                   	leave  
  8022cd:	c2 04 00             	ret    $0x4

008022d0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	ff 75 10             	pushl  0x10(%ebp)
  8022da:	ff 75 0c             	pushl  0xc(%ebp)
  8022dd:	ff 75 08             	pushl  0x8(%ebp)
  8022e0:	6a 13                	push   $0x13
  8022e2:	e8 7e fc ff ff       	call   801f65 <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ea:	90                   	nop
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <sys_rcr2>:
uint32 sys_rcr2()
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 1e                	push   $0x1e
  8022fc:	e8 64 fc ff ff       	call   801f65 <syscall>
  802301:	83 c4 18             	add    $0x18,%esp
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	83 ec 04             	sub    $0x4,%esp
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802312:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	50                   	push   %eax
  80231f:	6a 1f                	push   $0x1f
  802321:	e8 3f fc ff ff       	call   801f65 <syscall>
  802326:	83 c4 18             	add    $0x18,%esp
	return ;
  802329:	90                   	nop
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <rsttst>:
void rsttst()
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 21                	push   $0x21
  80233b:	e8 25 fc ff ff       	call   801f65 <syscall>
  802340:	83 c4 18             	add    $0x18,%esp
	return ;
  802343:	90                   	nop
}
  802344:	c9                   	leave  
  802345:	c3                   	ret    

00802346 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802346:	55                   	push   %ebp
  802347:	89 e5                	mov    %esp,%ebp
  802349:	83 ec 04             	sub    $0x4,%esp
  80234c:	8b 45 14             	mov    0x14(%ebp),%eax
  80234f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802352:	8b 55 18             	mov    0x18(%ebp),%edx
  802355:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802359:	52                   	push   %edx
  80235a:	50                   	push   %eax
  80235b:	ff 75 10             	pushl  0x10(%ebp)
  80235e:	ff 75 0c             	pushl  0xc(%ebp)
  802361:	ff 75 08             	pushl  0x8(%ebp)
  802364:	6a 20                	push   $0x20
  802366:	e8 fa fb ff ff       	call   801f65 <syscall>
  80236b:	83 c4 18             	add    $0x18,%esp
	return ;
  80236e:	90                   	nop
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <chktst>:
void chktst(uint32 n)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	ff 75 08             	pushl  0x8(%ebp)
  80237f:	6a 22                	push   $0x22
  802381:	e8 df fb ff ff       	call   801f65 <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
	return ;
  802389:	90                   	nop
}
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <inctst>:

void inctst()
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 23                	push   $0x23
  80239b:	e8 c5 fb ff ff       	call   801f65 <syscall>
  8023a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a3:	90                   	nop
}
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

008023a6 <gettst>:
uint32 gettst()
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 24                	push   $0x24
  8023b5:	e8 ab fb ff ff       	call   801f65 <syscall>
  8023ba:	83 c4 18             	add    $0x18,%esp
}
  8023bd:	c9                   	leave  
  8023be:	c3                   	ret    

008023bf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 25                	push   $0x25
  8023d1:	e8 8f fb ff ff       	call   801f65 <syscall>
  8023d6:	83 c4 18             	add    $0x18,%esp
  8023d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023dc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023e0:	75 07                	jne    8023e9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e7:	eb 05                	jmp    8023ee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ee:	c9                   	leave  
  8023ef:	c3                   	ret    

008023f0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 25                	push   $0x25
  802402:	e8 5e fb ff ff       	call   801f65 <syscall>
  802407:	83 c4 18             	add    $0x18,%esp
  80240a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80240d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802411:	75 07                	jne    80241a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802413:	b8 01 00 00 00       	mov    $0x1,%eax
  802418:	eb 05                	jmp    80241f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80241a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80241f:	c9                   	leave  
  802420:	c3                   	ret    

00802421 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
  802424:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 25                	push   $0x25
  802433:	e8 2d fb ff ff       	call   801f65 <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
  80243b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80243e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802442:	75 07                	jne    80244b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802444:	b8 01 00 00 00       	mov    $0x1,%eax
  802449:	eb 05                	jmp    802450 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80244b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 25                	push   $0x25
  802464:	e8 fc fa ff ff       	call   801f65 <syscall>
  802469:	83 c4 18             	add    $0x18,%esp
  80246c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80246f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802473:	75 07                	jne    80247c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802475:	b8 01 00 00 00       	mov    $0x1,%eax
  80247a:	eb 05                	jmp    802481 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80247c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	ff 75 08             	pushl  0x8(%ebp)
  802491:	6a 26                	push   $0x26
  802493:	e8 cd fa ff ff       	call   801f65 <syscall>
  802498:	83 c4 18             	add    $0x18,%esp
	return ;
  80249b:	90                   	nop
}
  80249c:	c9                   	leave  
  80249d:	c3                   	ret    

0080249e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
  8024a1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	6a 00                	push   $0x0
  8024b0:	53                   	push   %ebx
  8024b1:	51                   	push   %ecx
  8024b2:	52                   	push   %edx
  8024b3:	50                   	push   %eax
  8024b4:	6a 27                	push   $0x27
  8024b6:	e8 aa fa ff ff       	call   801f65 <syscall>
  8024bb:	83 c4 18             	add    $0x18,%esp
}
  8024be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    

008024c3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	52                   	push   %edx
  8024d3:	50                   	push   %eax
  8024d4:	6a 28                	push   $0x28
  8024d6:	e8 8a fa ff ff       	call   801f65 <syscall>
  8024db:	83 c4 18             	add    $0x18,%esp
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8024e3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ec:	6a 00                	push   $0x0
  8024ee:	51                   	push   %ecx
  8024ef:	ff 75 10             	pushl  0x10(%ebp)
  8024f2:	52                   	push   %edx
  8024f3:	50                   	push   %eax
  8024f4:	6a 29                	push   $0x29
  8024f6:	e8 6a fa ff ff       	call   801f65 <syscall>
  8024fb:	83 c4 18             	add    $0x18,%esp
}
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    

00802500 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	ff 75 10             	pushl  0x10(%ebp)
  80250a:	ff 75 0c             	pushl  0xc(%ebp)
  80250d:	ff 75 08             	pushl  0x8(%ebp)
  802510:	6a 12                	push   $0x12
  802512:	e8 4e fa ff ff       	call   801f65 <syscall>
  802517:	83 c4 18             	add    $0x18,%esp
	return ;
  80251a:	90                   	nop
}
  80251b:	c9                   	leave  
  80251c:	c3                   	ret    

0080251d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80251d:	55                   	push   %ebp
  80251e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802520:	8b 55 0c             	mov    0xc(%ebp),%edx
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	52                   	push   %edx
  80252d:	50                   	push   %eax
  80252e:	6a 2a                	push   $0x2a
  802530:	e8 30 fa ff ff       	call   801f65 <syscall>
  802535:	83 c4 18             	add    $0x18,%esp
	return;
  802538:	90                   	nop
}
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80253e:	8b 45 08             	mov    0x8(%ebp),%eax
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	50                   	push   %eax
  80254a:	6a 2b                	push   $0x2b
  80254c:	e8 14 fa ff ff       	call   801f65 <syscall>
  802551:	83 c4 18             	add    $0x18,%esp
}
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	ff 75 0c             	pushl  0xc(%ebp)
  802562:	ff 75 08             	pushl  0x8(%ebp)
  802565:	6a 2c                	push   $0x2c
  802567:	e8 f9 f9 ff ff       	call   801f65 <syscall>
  80256c:	83 c4 18             	add    $0x18,%esp
	return;
  80256f:	90                   	nop
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	ff 75 0c             	pushl  0xc(%ebp)
  80257e:	ff 75 08             	pushl  0x8(%ebp)
  802581:	6a 2d                	push   $0x2d
  802583:	e8 dd f9 ff ff       	call   801f65 <syscall>
  802588:	83 c4 18             	add    $0x18,%esp
	return;
  80258b:	90                   	nop
}
  80258c:	c9                   	leave  
  80258d:	c3                   	ret    

0080258e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80258e:	55                   	push   %ebp
  80258f:	89 e5                	mov    %esp,%ebp
  802591:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802594:	8b 45 08             	mov    0x8(%ebp),%eax
  802597:	83 e8 04             	sub    $0x4,%eax
  80259a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80259d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a0:	8b 00                	mov    (%eax),%eax
  8025a2:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
  8025aa:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8025ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b0:	83 e8 04             	sub    $0x4,%eax
  8025b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8025b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025b9:	8b 00                	mov    (%eax),%eax
  8025bb:	83 e0 01             	and    $0x1,%eax
  8025be:	85 c0                	test   %eax,%eax
  8025c0:	0f 94 c0             	sete   %al
}
  8025c3:	c9                   	leave  
  8025c4:	c3                   	ret    

008025c5 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8025c5:	55                   	push   %ebp
  8025c6:	89 e5                	mov    %esp,%ebp
  8025c8:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8025cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8025d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d5:	83 f8 02             	cmp    $0x2,%eax
  8025d8:	74 2b                	je     802605 <alloc_block+0x40>
  8025da:	83 f8 02             	cmp    $0x2,%eax
  8025dd:	7f 07                	jg     8025e6 <alloc_block+0x21>
  8025df:	83 f8 01             	cmp    $0x1,%eax
  8025e2:	74 0e                	je     8025f2 <alloc_block+0x2d>
  8025e4:	eb 58                	jmp    80263e <alloc_block+0x79>
  8025e6:	83 f8 03             	cmp    $0x3,%eax
  8025e9:	74 2d                	je     802618 <alloc_block+0x53>
  8025eb:	83 f8 04             	cmp    $0x4,%eax
  8025ee:	74 3b                	je     80262b <alloc_block+0x66>
  8025f0:	eb 4c                	jmp    80263e <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8025f2:	83 ec 0c             	sub    $0xc,%esp
  8025f5:	ff 75 08             	pushl  0x8(%ebp)
  8025f8:	e8 11 03 00 00       	call   80290e <alloc_block_FF>
  8025fd:	83 c4 10             	add    $0x10,%esp
  802600:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802603:	eb 4a                	jmp    80264f <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802605:	83 ec 0c             	sub    $0xc,%esp
  802608:	ff 75 08             	pushl  0x8(%ebp)
  80260b:	e8 fa 19 00 00       	call   80400a <alloc_block_NF>
  802610:	83 c4 10             	add    $0x10,%esp
  802613:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802616:	eb 37                	jmp    80264f <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802618:	83 ec 0c             	sub    $0xc,%esp
  80261b:	ff 75 08             	pushl  0x8(%ebp)
  80261e:	e8 a7 07 00 00       	call   802dca <alloc_block_BF>
  802623:	83 c4 10             	add    $0x10,%esp
  802626:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802629:	eb 24                	jmp    80264f <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80262b:	83 ec 0c             	sub    $0xc,%esp
  80262e:	ff 75 08             	pushl  0x8(%ebp)
  802631:	e8 b7 19 00 00       	call   803fed <alloc_block_WF>
  802636:	83 c4 10             	add    $0x10,%esp
  802639:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80263c:	eb 11                	jmp    80264f <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80263e:	83 ec 0c             	sub    $0xc,%esp
  802641:	68 28 4b 80 00       	push   $0x804b28
  802646:	e8 08 e5 ff ff       	call   800b53 <cprintf>
  80264b:	83 c4 10             	add    $0x10,%esp
		break;
  80264e:	90                   	nop
	}
	return va;
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802652:	c9                   	leave  
  802653:	c3                   	ret    

00802654 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802654:	55                   	push   %ebp
  802655:	89 e5                	mov    %esp,%ebp
  802657:	53                   	push   %ebx
  802658:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80265b:	83 ec 0c             	sub    $0xc,%esp
  80265e:	68 48 4b 80 00       	push   $0x804b48
  802663:	e8 eb e4 ff ff       	call   800b53 <cprintf>
  802668:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80266b:	83 ec 0c             	sub    $0xc,%esp
  80266e:	68 73 4b 80 00       	push   $0x804b73
  802673:	e8 db e4 ff ff       	call   800b53 <cprintf>
  802678:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802681:	eb 37                	jmp    8026ba <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802683:	83 ec 0c             	sub    $0xc,%esp
  802686:	ff 75 f4             	pushl  -0xc(%ebp)
  802689:	e8 19 ff ff ff       	call   8025a7 <is_free_block>
  80268e:	83 c4 10             	add    $0x10,%esp
  802691:	0f be d8             	movsbl %al,%ebx
  802694:	83 ec 0c             	sub    $0xc,%esp
  802697:	ff 75 f4             	pushl  -0xc(%ebp)
  80269a:	e8 ef fe ff ff       	call   80258e <get_block_size>
  80269f:	83 c4 10             	add    $0x10,%esp
  8026a2:	83 ec 04             	sub    $0x4,%esp
  8026a5:	53                   	push   %ebx
  8026a6:	50                   	push   %eax
  8026a7:	68 8b 4b 80 00       	push   $0x804b8b
  8026ac:	e8 a2 e4 ff ff       	call   800b53 <cprintf>
  8026b1:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8026b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026be:	74 07                	je     8026c7 <print_blocks_list+0x73>
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 00                	mov    (%eax),%eax
  8026c5:	eb 05                	jmp    8026cc <print_blocks_list+0x78>
  8026c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cc:	89 45 10             	mov    %eax,0x10(%ebp)
  8026cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8026d2:	85 c0                	test   %eax,%eax
  8026d4:	75 ad                	jne    802683 <print_blocks_list+0x2f>
  8026d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026da:	75 a7                	jne    802683 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8026dc:	83 ec 0c             	sub    $0xc,%esp
  8026df:	68 48 4b 80 00       	push   $0x804b48
  8026e4:	e8 6a e4 ff ff       	call   800b53 <cprintf>
  8026e9:	83 c4 10             	add    $0x10,%esp

}
  8026ec:	90                   	nop
  8026ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026f0:	c9                   	leave  
  8026f1:	c3                   	ret    

008026f2 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8026f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026fb:	83 e0 01             	and    $0x1,%eax
  8026fe:	85 c0                	test   %eax,%eax
  802700:	74 03                	je     802705 <initialize_dynamic_allocator+0x13>
  802702:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802705:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802709:	0f 84 c7 01 00 00    	je     8028d6 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80270f:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802716:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802719:	8b 55 08             	mov    0x8(%ebp),%edx
  80271c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80271f:	01 d0                	add    %edx,%eax
  802721:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802726:	0f 87 ad 01 00 00    	ja     8028d9 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  80272c:	8b 45 08             	mov    0x8(%ebp),%eax
  80272f:	85 c0                	test   %eax,%eax
  802731:	0f 89 a5 01 00 00    	jns    8028dc <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802737:	8b 55 08             	mov    0x8(%ebp),%edx
  80273a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273d:	01 d0                	add    %edx,%eax
  80273f:	83 e8 04             	sub    $0x4,%eax
  802742:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  802747:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80274e:	a1 30 50 80 00       	mov    0x805030,%eax
  802753:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802756:	e9 87 00 00 00       	jmp    8027e2 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80275b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275f:	75 14                	jne    802775 <initialize_dynamic_allocator+0x83>
  802761:	83 ec 04             	sub    $0x4,%esp
  802764:	68 a3 4b 80 00       	push   $0x804ba3
  802769:	6a 79                	push   $0x79
  80276b:	68 c1 4b 80 00       	push   $0x804bc1
  802770:	e8 21 e1 ff ff       	call   800896 <_panic>
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	8b 00                	mov    (%eax),%eax
  80277a:	85 c0                	test   %eax,%eax
  80277c:	74 10                	je     80278e <initialize_dynamic_allocator+0x9c>
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 00                	mov    (%eax),%eax
  802783:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802786:	8b 52 04             	mov    0x4(%edx),%edx
  802789:	89 50 04             	mov    %edx,0x4(%eax)
  80278c:	eb 0b                	jmp    802799 <initialize_dynamic_allocator+0xa7>
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 40 04             	mov    0x4(%eax),%eax
  802794:	a3 34 50 80 00       	mov    %eax,0x805034
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 04             	mov    0x4(%eax),%eax
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	74 0f                	je     8027b2 <initialize_dynamic_allocator+0xc0>
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 40 04             	mov    0x4(%eax),%eax
  8027a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ac:	8b 12                	mov    (%edx),%edx
  8027ae:	89 10                	mov    %edx,(%eax)
  8027b0:	eb 0a                	jmp    8027bc <initialize_dynamic_allocator+0xca>
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	8b 00                	mov    (%eax),%eax
  8027b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027cf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027d4:	48                   	dec    %eax
  8027d5:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8027da:	a1 38 50 80 00       	mov    0x805038,%eax
  8027df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e6:	74 07                	je     8027ef <initialize_dynamic_allocator+0xfd>
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	eb 05                	jmp    8027f4 <initialize_dynamic_allocator+0x102>
  8027ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f4:	a3 38 50 80 00       	mov    %eax,0x805038
  8027f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	0f 85 55 ff ff ff    	jne    80275b <initialize_dynamic_allocator+0x69>
  802806:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280a:	0f 85 4b ff ff ff    	jne    80275b <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802819:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80281f:	a1 48 50 80 00       	mov    0x805048,%eax
  802824:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802829:	a1 44 50 80 00       	mov    0x805044,%eax
  80282e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802834:	8b 45 08             	mov    0x8(%ebp),%eax
  802837:	83 c0 08             	add    $0x8,%eax
  80283a:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80283d:	8b 45 08             	mov    0x8(%ebp),%eax
  802840:	83 c0 04             	add    $0x4,%eax
  802843:	8b 55 0c             	mov    0xc(%ebp),%edx
  802846:	83 ea 08             	sub    $0x8,%edx
  802849:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80284b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80284e:	8b 45 08             	mov    0x8(%ebp),%eax
  802851:	01 d0                	add    %edx,%eax
  802853:	83 e8 08             	sub    $0x8,%eax
  802856:	8b 55 0c             	mov    0xc(%ebp),%edx
  802859:	83 ea 08             	sub    $0x8,%edx
  80285c:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80285e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802861:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802871:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802875:	75 17                	jne    80288e <initialize_dynamic_allocator+0x19c>
  802877:	83 ec 04             	sub    $0x4,%esp
  80287a:	68 dc 4b 80 00       	push   $0x804bdc
  80287f:	68 90 00 00 00       	push   $0x90
  802884:	68 c1 4b 80 00       	push   $0x804bc1
  802889:	e8 08 e0 ff ff       	call   800896 <_panic>
  80288e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802897:	89 10                	mov    %edx,(%eax)
  802899:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	74 0d                	je     8028af <initialize_dynamic_allocator+0x1bd>
  8028a2:	a1 30 50 80 00       	mov    0x805030,%eax
  8028a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028aa:	89 50 04             	mov    %edx,0x4(%eax)
  8028ad:	eb 08                	jmp    8028b7 <initialize_dynamic_allocator+0x1c5>
  8028af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b2:	a3 34 50 80 00       	mov    %eax,0x805034
  8028b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8028bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8028ce:	40                   	inc    %eax
  8028cf:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8028d4:	eb 07                	jmp    8028dd <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8028d6:	90                   	nop
  8028d7:	eb 04                	jmp    8028dd <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8028d9:	90                   	nop
  8028da:	eb 01                	jmp    8028dd <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8028dc:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8028dd:	c9                   	leave  
  8028de:	c3                   	ret    

008028df <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8028df:	55                   	push   %ebp
  8028e0:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8028e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8028e5:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8028e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028eb:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028f1:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	83 e8 04             	sub    $0x4,%eax
  8028f9:	8b 00                	mov    (%eax),%eax
  8028fb:	83 e0 fe             	and    $0xfffffffe,%eax
  8028fe:	8d 50 f8             	lea    -0x8(%eax),%edx
  802901:	8b 45 08             	mov    0x8(%ebp),%eax
  802904:	01 c2                	add    %eax,%edx
  802906:	8b 45 0c             	mov    0xc(%ebp),%eax
  802909:	89 02                	mov    %eax,(%edx)
}
  80290b:	90                   	nop
  80290c:	5d                   	pop    %ebp
  80290d:	c3                   	ret    

0080290e <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80290e:	55                   	push   %ebp
  80290f:	89 e5                	mov    %esp,%ebp
  802911:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802914:	8b 45 08             	mov    0x8(%ebp),%eax
  802917:	83 e0 01             	and    $0x1,%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	74 03                	je     802921 <alloc_block_FF+0x13>
  80291e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802921:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802925:	77 07                	ja     80292e <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802927:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80292e:	a1 28 50 80 00       	mov    0x805028,%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	75 73                	jne    8029aa <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	83 c0 10             	add    $0x10,%eax
  80293d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802940:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802947:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80294a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294d:	01 d0                	add    %edx,%eax
  80294f:	48                   	dec    %eax
  802950:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802953:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802956:	ba 00 00 00 00       	mov    $0x0,%edx
  80295b:	f7 75 ec             	divl   -0x14(%ebp)
  80295e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802961:	29 d0                	sub    %edx,%eax
  802963:	c1 e8 0c             	shr    $0xc,%eax
  802966:	83 ec 0c             	sub    $0xc,%esp
  802969:	50                   	push   %eax
  80296a:	e8 86 f1 ff ff       	call   801af5 <sbrk>
  80296f:	83 c4 10             	add    $0x10,%esp
  802972:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802975:	83 ec 0c             	sub    $0xc,%esp
  802978:	6a 00                	push   $0x0
  80297a:	e8 76 f1 ff ff       	call   801af5 <sbrk>
  80297f:	83 c4 10             	add    $0x10,%esp
  802982:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802985:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802988:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80298b:	83 ec 08             	sub    $0x8,%esp
  80298e:	50                   	push   %eax
  80298f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802992:	e8 5b fd ff ff       	call   8026f2 <initialize_dynamic_allocator>
  802997:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80299a:	83 ec 0c             	sub    $0xc,%esp
  80299d:	68 ff 4b 80 00       	push   $0x804bff
  8029a2:	e8 ac e1 ff ff       	call   800b53 <cprintf>
  8029a7:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8029aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ae:	75 0a                	jne    8029ba <alloc_block_FF+0xac>
	        return NULL;
  8029b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b5:	e9 0e 04 00 00       	jmp    802dc8 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8029ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8029c1:	a1 30 50 80 00       	mov    0x805030,%eax
  8029c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c9:	e9 f3 02 00 00       	jmp    802cc1 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8029d4:	83 ec 0c             	sub    $0xc,%esp
  8029d7:	ff 75 bc             	pushl  -0x44(%ebp)
  8029da:	e8 af fb ff ff       	call   80258e <get_block_size>
  8029df:	83 c4 10             	add    $0x10,%esp
  8029e2:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e8:	83 c0 08             	add    $0x8,%eax
  8029eb:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8029ee:	0f 87 c5 02 00 00    	ja     802cb9 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f7:	83 c0 18             	add    $0x18,%eax
  8029fa:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8029fd:	0f 87 19 02 00 00    	ja     802c1c <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802a03:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a06:	2b 45 08             	sub    0x8(%ebp),%eax
  802a09:	83 e8 08             	sub    $0x8,%eax
  802a0c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	8d 50 08             	lea    0x8(%eax),%edx
  802a15:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a18:	01 d0                	add    %edx,%eax
  802a1a:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	83 c0 08             	add    $0x8,%eax
  802a23:	83 ec 04             	sub    $0x4,%esp
  802a26:	6a 01                	push   $0x1
  802a28:	50                   	push   %eax
  802a29:	ff 75 bc             	pushl  -0x44(%ebp)
  802a2c:	e8 ae fe ff ff       	call   8028df <set_block_data>
  802a31:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 40 04             	mov    0x4(%eax),%eax
  802a3a:	85 c0                	test   %eax,%eax
  802a3c:	75 68                	jne    802aa6 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a3e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a42:	75 17                	jne    802a5b <alloc_block_FF+0x14d>
  802a44:	83 ec 04             	sub    $0x4,%esp
  802a47:	68 dc 4b 80 00       	push   $0x804bdc
  802a4c:	68 d7 00 00 00       	push   $0xd7
  802a51:	68 c1 4b 80 00       	push   $0x804bc1
  802a56:	e8 3b de ff ff       	call   800896 <_panic>
  802a5b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a61:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a64:	89 10                	mov    %edx,(%eax)
  802a66:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	74 0d                	je     802a7c <alloc_block_FF+0x16e>
  802a6f:	a1 30 50 80 00       	mov    0x805030,%eax
  802a74:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a77:	89 50 04             	mov    %edx,0x4(%eax)
  802a7a:	eb 08                	jmp    802a84 <alloc_block_FF+0x176>
  802a7c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a7f:	a3 34 50 80 00       	mov    %eax,0x805034
  802a84:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a87:	a3 30 50 80 00       	mov    %eax,0x805030
  802a8c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a96:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a9b:	40                   	inc    %eax
  802a9c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802aa1:	e9 dc 00 00 00       	jmp    802b82 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 00                	mov    (%eax),%eax
  802aab:	85 c0                	test   %eax,%eax
  802aad:	75 65                	jne    802b14 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802aaf:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ab3:	75 17                	jne    802acc <alloc_block_FF+0x1be>
  802ab5:	83 ec 04             	sub    $0x4,%esp
  802ab8:	68 10 4c 80 00       	push   $0x804c10
  802abd:	68 db 00 00 00       	push   $0xdb
  802ac2:	68 c1 4b 80 00       	push   $0x804bc1
  802ac7:	e8 ca dd ff ff       	call   800896 <_panic>
  802acc:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802ad2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ad5:	89 50 04             	mov    %edx,0x4(%eax)
  802ad8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802adb:	8b 40 04             	mov    0x4(%eax),%eax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	74 0c                	je     802aee <alloc_block_FF+0x1e0>
  802ae2:	a1 34 50 80 00       	mov    0x805034,%eax
  802ae7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802aea:	89 10                	mov    %edx,(%eax)
  802aec:	eb 08                	jmp    802af6 <alloc_block_FF+0x1e8>
  802aee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802af1:	a3 30 50 80 00       	mov    %eax,0x805030
  802af6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802af9:	a3 34 50 80 00       	mov    %eax,0x805034
  802afe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b07:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b0c:	40                   	inc    %eax
  802b0d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b12:	eb 6e                	jmp    802b82 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802b14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b18:	74 06                	je     802b20 <alloc_block_FF+0x212>
  802b1a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b1e:	75 17                	jne    802b37 <alloc_block_FF+0x229>
  802b20:	83 ec 04             	sub    $0x4,%esp
  802b23:	68 34 4c 80 00       	push   $0x804c34
  802b28:	68 df 00 00 00       	push   $0xdf
  802b2d:	68 c1 4b 80 00       	push   $0x804bc1
  802b32:	e8 5f dd ff ff       	call   800896 <_panic>
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	8b 10                	mov    (%eax),%edx
  802b3c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b3f:	89 10                	mov    %edx,(%eax)
  802b41:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b44:	8b 00                	mov    (%eax),%eax
  802b46:	85 c0                	test   %eax,%eax
  802b48:	74 0b                	je     802b55 <alloc_block_FF+0x247>
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 00                	mov    (%eax),%eax
  802b4f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b52:	89 50 04             	mov    %edx,0x4(%eax)
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b5b:	89 10                	mov    %edx,(%eax)
  802b5d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b63:	89 50 04             	mov    %edx,0x4(%eax)
  802b66:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b69:	8b 00                	mov    (%eax),%eax
  802b6b:	85 c0                	test   %eax,%eax
  802b6d:	75 08                	jne    802b77 <alloc_block_FF+0x269>
  802b6f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b72:	a3 34 50 80 00       	mov    %eax,0x805034
  802b77:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b7c:	40                   	inc    %eax
  802b7d:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802b82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b86:	75 17                	jne    802b9f <alloc_block_FF+0x291>
  802b88:	83 ec 04             	sub    $0x4,%esp
  802b8b:	68 a3 4b 80 00       	push   $0x804ba3
  802b90:	68 e1 00 00 00       	push   $0xe1
  802b95:	68 c1 4b 80 00       	push   $0x804bc1
  802b9a:	e8 f7 dc ff ff       	call   800896 <_panic>
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 10                	je     802bb8 <alloc_block_FF+0x2aa>
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	8b 00                	mov    (%eax),%eax
  802bad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb0:	8b 52 04             	mov    0x4(%edx),%edx
  802bb3:	89 50 04             	mov    %edx,0x4(%eax)
  802bb6:	eb 0b                	jmp    802bc3 <alloc_block_FF+0x2b5>
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 40 04             	mov    0x4(%eax),%eax
  802bbe:	a3 34 50 80 00       	mov    %eax,0x805034
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	8b 40 04             	mov    0x4(%eax),%eax
  802bc9:	85 c0                	test   %eax,%eax
  802bcb:	74 0f                	je     802bdc <alloc_block_FF+0x2ce>
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	8b 40 04             	mov    0x4(%eax),%eax
  802bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd6:	8b 12                	mov    (%edx),%edx
  802bd8:	89 10                	mov    %edx,(%eax)
  802bda:	eb 0a                	jmp    802be6 <alloc_block_FF+0x2d8>
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	a3 30 50 80 00       	mov    %eax,0x805030
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bfe:	48                   	dec    %eax
  802bff:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802c04:	83 ec 04             	sub    $0x4,%esp
  802c07:	6a 00                	push   $0x0
  802c09:	ff 75 b4             	pushl  -0x4c(%ebp)
  802c0c:	ff 75 b0             	pushl  -0x50(%ebp)
  802c0f:	e8 cb fc ff ff       	call   8028df <set_block_data>
  802c14:	83 c4 10             	add    $0x10,%esp
  802c17:	e9 95 00 00 00       	jmp    802cb1 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802c1c:	83 ec 04             	sub    $0x4,%esp
  802c1f:	6a 01                	push   $0x1
  802c21:	ff 75 b8             	pushl  -0x48(%ebp)
  802c24:	ff 75 bc             	pushl  -0x44(%ebp)
  802c27:	e8 b3 fc ff ff       	call   8028df <set_block_data>
  802c2c:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802c2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c33:	75 17                	jne    802c4c <alloc_block_FF+0x33e>
  802c35:	83 ec 04             	sub    $0x4,%esp
  802c38:	68 a3 4b 80 00       	push   $0x804ba3
  802c3d:	68 e8 00 00 00       	push   $0xe8
  802c42:	68 c1 4b 80 00       	push   $0x804bc1
  802c47:	e8 4a dc ff ff       	call   800896 <_panic>
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 00                	mov    (%eax),%eax
  802c51:	85 c0                	test   %eax,%eax
  802c53:	74 10                	je     802c65 <alloc_block_FF+0x357>
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 00                	mov    (%eax),%eax
  802c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5d:	8b 52 04             	mov    0x4(%edx),%edx
  802c60:	89 50 04             	mov    %edx,0x4(%eax)
  802c63:	eb 0b                	jmp    802c70 <alloc_block_FF+0x362>
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 40 04             	mov    0x4(%eax),%eax
  802c6b:	a3 34 50 80 00       	mov    %eax,0x805034
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 40 04             	mov    0x4(%eax),%eax
  802c76:	85 c0                	test   %eax,%eax
  802c78:	74 0f                	je     802c89 <alloc_block_FF+0x37b>
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 40 04             	mov    0x4(%eax),%eax
  802c80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c83:	8b 12                	mov    (%edx),%edx
  802c85:	89 10                	mov    %edx,(%eax)
  802c87:	eb 0a                	jmp    802c93 <alloc_block_FF+0x385>
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	a3 30 50 80 00       	mov    %eax,0x805030
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cab:	48                   	dec    %eax
  802cac:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802cb1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cb4:	e9 0f 01 00 00       	jmp    802dc8 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802cb9:	a1 38 50 80 00       	mov    0x805038,%eax
  802cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc5:	74 07                	je     802cce <alloc_block_FF+0x3c0>
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	8b 00                	mov    (%eax),%eax
  802ccc:	eb 05                	jmp    802cd3 <alloc_block_FF+0x3c5>
  802cce:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd3:	a3 38 50 80 00       	mov    %eax,0x805038
  802cd8:	a1 38 50 80 00       	mov    0x805038,%eax
  802cdd:	85 c0                	test   %eax,%eax
  802cdf:	0f 85 e9 fc ff ff    	jne    8029ce <alloc_block_FF+0xc0>
  802ce5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce9:	0f 85 df fc ff ff    	jne    8029ce <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	83 c0 08             	add    $0x8,%eax
  802cf5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cf8:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802cff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d02:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d05:	01 d0                	add    %edx,%eax
  802d07:	48                   	dec    %eax
  802d08:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802d0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d0e:	ba 00 00 00 00       	mov    $0x0,%edx
  802d13:	f7 75 d8             	divl   -0x28(%ebp)
  802d16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d19:	29 d0                	sub    %edx,%eax
  802d1b:	c1 e8 0c             	shr    $0xc,%eax
  802d1e:	83 ec 0c             	sub    $0xc,%esp
  802d21:	50                   	push   %eax
  802d22:	e8 ce ed ff ff       	call   801af5 <sbrk>
  802d27:	83 c4 10             	add    $0x10,%esp
  802d2a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802d2d:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d31:	75 0a                	jne    802d3d <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802d33:	b8 00 00 00 00       	mov    $0x0,%eax
  802d38:	e9 8b 00 00 00       	jmp    802dc8 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d3d:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802d44:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d47:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d4a:	01 d0                	add    %edx,%eax
  802d4c:	48                   	dec    %eax
  802d4d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802d50:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d53:	ba 00 00 00 00       	mov    $0x0,%edx
  802d58:	f7 75 cc             	divl   -0x34(%ebp)
  802d5b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d5e:	29 d0                	sub    %edx,%eax
  802d60:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d66:	01 d0                	add    %edx,%eax
  802d68:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802d6d:	a1 44 50 80 00       	mov    0x805044,%eax
  802d72:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d78:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d7f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d82:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d85:	01 d0                	add    %edx,%eax
  802d87:	48                   	dec    %eax
  802d88:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d8b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d8e:	ba 00 00 00 00       	mov    $0x0,%edx
  802d93:	f7 75 c4             	divl   -0x3c(%ebp)
  802d96:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d99:	29 d0                	sub    %edx,%eax
  802d9b:	83 ec 04             	sub    $0x4,%esp
  802d9e:	6a 01                	push   $0x1
  802da0:	50                   	push   %eax
  802da1:	ff 75 d0             	pushl  -0x30(%ebp)
  802da4:	e8 36 fb ff ff       	call   8028df <set_block_data>
  802da9:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802dac:	83 ec 0c             	sub    $0xc,%esp
  802daf:	ff 75 d0             	pushl  -0x30(%ebp)
  802db2:	e8 1b 0a 00 00       	call   8037d2 <free_block>
  802db7:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802dba:	83 ec 0c             	sub    $0xc,%esp
  802dbd:	ff 75 08             	pushl  0x8(%ebp)
  802dc0:	e8 49 fb ff ff       	call   80290e <alloc_block_FF>
  802dc5:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802dc8:	c9                   	leave  
  802dc9:	c3                   	ret    

00802dca <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802dca:	55                   	push   %ebp
  802dcb:	89 e5                	mov    %esp,%ebp
  802dcd:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	83 e0 01             	and    $0x1,%eax
  802dd6:	85 c0                	test   %eax,%eax
  802dd8:	74 03                	je     802ddd <alloc_block_BF+0x13>
  802dda:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802ddd:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802de1:	77 07                	ja     802dea <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802de3:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802dea:	a1 28 50 80 00       	mov    0x805028,%eax
  802def:	85 c0                	test   %eax,%eax
  802df1:	75 73                	jne    802e66 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	83 c0 10             	add    $0x10,%eax
  802df9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802dfc:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802e03:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e09:	01 d0                	add    %edx,%eax
  802e0b:	48                   	dec    %eax
  802e0c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e12:	ba 00 00 00 00       	mov    $0x0,%edx
  802e17:	f7 75 e0             	divl   -0x20(%ebp)
  802e1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e1d:	29 d0                	sub    %edx,%eax
  802e1f:	c1 e8 0c             	shr    $0xc,%eax
  802e22:	83 ec 0c             	sub    $0xc,%esp
  802e25:	50                   	push   %eax
  802e26:	e8 ca ec ff ff       	call   801af5 <sbrk>
  802e2b:	83 c4 10             	add    $0x10,%esp
  802e2e:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802e31:	83 ec 0c             	sub    $0xc,%esp
  802e34:	6a 00                	push   $0x0
  802e36:	e8 ba ec ff ff       	call   801af5 <sbrk>
  802e3b:	83 c4 10             	add    $0x10,%esp
  802e3e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802e41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e44:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802e47:	83 ec 08             	sub    $0x8,%esp
  802e4a:	50                   	push   %eax
  802e4b:	ff 75 d8             	pushl  -0x28(%ebp)
  802e4e:	e8 9f f8 ff ff       	call   8026f2 <initialize_dynamic_allocator>
  802e53:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802e56:	83 ec 0c             	sub    $0xc,%esp
  802e59:	68 ff 4b 80 00       	push   $0x804bff
  802e5e:	e8 f0 dc ff ff       	call   800b53 <cprintf>
  802e63:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802e66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802e6d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802e74:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802e7b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802e82:	a1 30 50 80 00       	mov    0x805030,%eax
  802e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8a:	e9 1d 01 00 00       	jmp    802fac <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e92:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802e95:	83 ec 0c             	sub    $0xc,%esp
  802e98:	ff 75 a8             	pushl  -0x58(%ebp)
  802e9b:	e8 ee f6 ff ff       	call   80258e <get_block_size>
  802ea0:	83 c4 10             	add    $0x10,%esp
  802ea3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	83 c0 08             	add    $0x8,%eax
  802eac:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802eaf:	0f 87 ef 00 00 00    	ja     802fa4 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	83 c0 18             	add    $0x18,%eax
  802ebb:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ebe:	77 1d                	ja     802edd <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802ec0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ec6:	0f 86 d8 00 00 00    	jbe    802fa4 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802ecc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ecf:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802ed2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ed5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ed8:	e9 c7 00 00 00       	jmp    802fa4 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	83 c0 08             	add    $0x8,%eax
  802ee3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ee6:	0f 85 9d 00 00 00    	jne    802f89 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802eec:	83 ec 04             	sub    $0x4,%esp
  802eef:	6a 01                	push   $0x1
  802ef1:	ff 75 a4             	pushl  -0x5c(%ebp)
  802ef4:	ff 75 a8             	pushl  -0x58(%ebp)
  802ef7:	e8 e3 f9 ff ff       	call   8028df <set_block_data>
  802efc:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802eff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f03:	75 17                	jne    802f1c <alloc_block_BF+0x152>
  802f05:	83 ec 04             	sub    $0x4,%esp
  802f08:	68 a3 4b 80 00       	push   $0x804ba3
  802f0d:	68 2c 01 00 00       	push   $0x12c
  802f12:	68 c1 4b 80 00       	push   $0x804bc1
  802f17:	e8 7a d9 ff ff       	call   800896 <_panic>
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	8b 00                	mov    (%eax),%eax
  802f21:	85 c0                	test   %eax,%eax
  802f23:	74 10                	je     802f35 <alloc_block_BF+0x16b>
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f2d:	8b 52 04             	mov    0x4(%edx),%edx
  802f30:	89 50 04             	mov    %edx,0x4(%eax)
  802f33:	eb 0b                	jmp    802f40 <alloc_block_BF+0x176>
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	8b 40 04             	mov    0x4(%eax),%eax
  802f3b:	a3 34 50 80 00       	mov    %eax,0x805034
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	8b 40 04             	mov    0x4(%eax),%eax
  802f46:	85 c0                	test   %eax,%eax
  802f48:	74 0f                	je     802f59 <alloc_block_BF+0x18f>
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	8b 40 04             	mov    0x4(%eax),%eax
  802f50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f53:	8b 12                	mov    (%edx),%edx
  802f55:	89 10                	mov    %edx,(%eax)
  802f57:	eb 0a                	jmp    802f63 <alloc_block_BF+0x199>
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	a3 30 50 80 00       	mov    %eax,0x805030
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f76:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f7b:	48                   	dec    %eax
  802f7c:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802f81:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f84:	e9 24 04 00 00       	jmp    8033ad <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802f89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f8f:	76 13                	jbe    802fa4 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802f91:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802f98:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802f9e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802fa1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802fa4:	a1 38 50 80 00       	mov    0x805038,%eax
  802fa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb0:	74 07                	je     802fb9 <alloc_block_BF+0x1ef>
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 00                	mov    (%eax),%eax
  802fb7:	eb 05                	jmp    802fbe <alloc_block_BF+0x1f4>
  802fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  802fbe:	a3 38 50 80 00       	mov    %eax,0x805038
  802fc3:	a1 38 50 80 00       	mov    0x805038,%eax
  802fc8:	85 c0                	test   %eax,%eax
  802fca:	0f 85 bf fe ff ff    	jne    802e8f <alloc_block_BF+0xc5>
  802fd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd4:	0f 85 b5 fe ff ff    	jne    802e8f <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802fda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fde:	0f 84 26 02 00 00    	je     80320a <alloc_block_BF+0x440>
  802fe4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fe8:	0f 85 1c 02 00 00    	jne    80320a <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802fee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff1:	2b 45 08             	sub    0x8(%ebp),%eax
  802ff4:	83 e8 08             	sub    $0x8,%eax
  802ff7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	8d 50 08             	lea    0x8(%eax),%edx
  803000:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803003:	01 d0                	add    %edx,%eax
  803005:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803008:	8b 45 08             	mov    0x8(%ebp),%eax
  80300b:	83 c0 08             	add    $0x8,%eax
  80300e:	83 ec 04             	sub    $0x4,%esp
  803011:	6a 01                	push   $0x1
  803013:	50                   	push   %eax
  803014:	ff 75 f0             	pushl  -0x10(%ebp)
  803017:	e8 c3 f8 ff ff       	call   8028df <set_block_data>
  80301c:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80301f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803022:	8b 40 04             	mov    0x4(%eax),%eax
  803025:	85 c0                	test   %eax,%eax
  803027:	75 68                	jne    803091 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803029:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80302d:	75 17                	jne    803046 <alloc_block_BF+0x27c>
  80302f:	83 ec 04             	sub    $0x4,%esp
  803032:	68 dc 4b 80 00       	push   $0x804bdc
  803037:	68 45 01 00 00       	push   $0x145
  80303c:	68 c1 4b 80 00       	push   $0x804bc1
  803041:	e8 50 d8 ff ff       	call   800896 <_panic>
  803046:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80304c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80304f:	89 10                	mov    %edx,(%eax)
  803051:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803054:	8b 00                	mov    (%eax),%eax
  803056:	85 c0                	test   %eax,%eax
  803058:	74 0d                	je     803067 <alloc_block_BF+0x29d>
  80305a:	a1 30 50 80 00       	mov    0x805030,%eax
  80305f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803062:	89 50 04             	mov    %edx,0x4(%eax)
  803065:	eb 08                	jmp    80306f <alloc_block_BF+0x2a5>
  803067:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80306a:	a3 34 50 80 00       	mov    %eax,0x805034
  80306f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803072:	a3 30 50 80 00       	mov    %eax,0x805030
  803077:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80307a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803081:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803086:	40                   	inc    %eax
  803087:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80308c:	e9 dc 00 00 00       	jmp    80316d <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803094:	8b 00                	mov    (%eax),%eax
  803096:	85 c0                	test   %eax,%eax
  803098:	75 65                	jne    8030ff <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80309a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80309e:	75 17                	jne    8030b7 <alloc_block_BF+0x2ed>
  8030a0:	83 ec 04             	sub    $0x4,%esp
  8030a3:	68 10 4c 80 00       	push   $0x804c10
  8030a8:	68 4a 01 00 00       	push   $0x14a
  8030ad:	68 c1 4b 80 00       	push   $0x804bc1
  8030b2:	e8 df d7 ff ff       	call   800896 <_panic>
  8030b7:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8030bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c0:	89 50 04             	mov    %edx,0x4(%eax)
  8030c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c6:	8b 40 04             	mov    0x4(%eax),%eax
  8030c9:	85 c0                	test   %eax,%eax
  8030cb:	74 0c                	je     8030d9 <alloc_block_BF+0x30f>
  8030cd:	a1 34 50 80 00       	mov    0x805034,%eax
  8030d2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030d5:	89 10                	mov    %edx,(%eax)
  8030d7:	eb 08                	jmp    8030e1 <alloc_block_BF+0x317>
  8030d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030dc:	a3 30 50 80 00       	mov    %eax,0x805030
  8030e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030e4:	a3 34 50 80 00       	mov    %eax,0x805034
  8030e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030f7:	40                   	inc    %eax
  8030f8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8030fd:	eb 6e                	jmp    80316d <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8030ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803103:	74 06                	je     80310b <alloc_block_BF+0x341>
  803105:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803109:	75 17                	jne    803122 <alloc_block_BF+0x358>
  80310b:	83 ec 04             	sub    $0x4,%esp
  80310e:	68 34 4c 80 00       	push   $0x804c34
  803113:	68 4f 01 00 00       	push   $0x14f
  803118:	68 c1 4b 80 00       	push   $0x804bc1
  80311d:	e8 74 d7 ff ff       	call   800896 <_panic>
  803122:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803125:	8b 10                	mov    (%eax),%edx
  803127:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80312a:	89 10                	mov    %edx,(%eax)
  80312c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80312f:	8b 00                	mov    (%eax),%eax
  803131:	85 c0                	test   %eax,%eax
  803133:	74 0b                	je     803140 <alloc_block_BF+0x376>
  803135:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803138:	8b 00                	mov    (%eax),%eax
  80313a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80313d:	89 50 04             	mov    %edx,0x4(%eax)
  803140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803143:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803146:	89 10                	mov    %edx,(%eax)
  803148:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80314b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80314e:	89 50 04             	mov    %edx,0x4(%eax)
  803151:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803154:	8b 00                	mov    (%eax),%eax
  803156:	85 c0                	test   %eax,%eax
  803158:	75 08                	jne    803162 <alloc_block_BF+0x398>
  80315a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80315d:	a3 34 50 80 00       	mov    %eax,0x805034
  803162:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803167:	40                   	inc    %eax
  803168:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80316d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803171:	75 17                	jne    80318a <alloc_block_BF+0x3c0>
  803173:	83 ec 04             	sub    $0x4,%esp
  803176:	68 a3 4b 80 00       	push   $0x804ba3
  80317b:	68 51 01 00 00       	push   $0x151
  803180:	68 c1 4b 80 00       	push   $0x804bc1
  803185:	e8 0c d7 ff ff       	call   800896 <_panic>
  80318a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318d:	8b 00                	mov    (%eax),%eax
  80318f:	85 c0                	test   %eax,%eax
  803191:	74 10                	je     8031a3 <alloc_block_BF+0x3d9>
  803193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803196:	8b 00                	mov    (%eax),%eax
  803198:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80319b:	8b 52 04             	mov    0x4(%edx),%edx
  80319e:	89 50 04             	mov    %edx,0x4(%eax)
  8031a1:	eb 0b                	jmp    8031ae <alloc_block_BF+0x3e4>
  8031a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a6:	8b 40 04             	mov    0x4(%eax),%eax
  8031a9:	a3 34 50 80 00       	mov    %eax,0x805034
  8031ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b1:	8b 40 04             	mov    0x4(%eax),%eax
  8031b4:	85 c0                	test   %eax,%eax
  8031b6:	74 0f                	je     8031c7 <alloc_block_BF+0x3fd>
  8031b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bb:	8b 40 04             	mov    0x4(%eax),%eax
  8031be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031c1:	8b 12                	mov    (%edx),%edx
  8031c3:	89 10                	mov    %edx,(%eax)
  8031c5:	eb 0a                	jmp    8031d1 <alloc_block_BF+0x407>
  8031c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8031d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031e9:	48                   	dec    %eax
  8031ea:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  8031ef:	83 ec 04             	sub    $0x4,%esp
  8031f2:	6a 00                	push   $0x0
  8031f4:	ff 75 d0             	pushl  -0x30(%ebp)
  8031f7:	ff 75 cc             	pushl  -0x34(%ebp)
  8031fa:	e8 e0 f6 ff ff       	call   8028df <set_block_data>
  8031ff:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803205:	e9 a3 01 00 00       	jmp    8033ad <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80320a:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80320e:	0f 85 9d 00 00 00    	jne    8032b1 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803214:	83 ec 04             	sub    $0x4,%esp
  803217:	6a 01                	push   $0x1
  803219:	ff 75 ec             	pushl  -0x14(%ebp)
  80321c:	ff 75 f0             	pushl  -0x10(%ebp)
  80321f:	e8 bb f6 ff ff       	call   8028df <set_block_data>
  803224:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803227:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80322b:	75 17                	jne    803244 <alloc_block_BF+0x47a>
  80322d:	83 ec 04             	sub    $0x4,%esp
  803230:	68 a3 4b 80 00       	push   $0x804ba3
  803235:	68 58 01 00 00       	push   $0x158
  80323a:	68 c1 4b 80 00       	push   $0x804bc1
  80323f:	e8 52 d6 ff ff       	call   800896 <_panic>
  803244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803247:	8b 00                	mov    (%eax),%eax
  803249:	85 c0                	test   %eax,%eax
  80324b:	74 10                	je     80325d <alloc_block_BF+0x493>
  80324d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803255:	8b 52 04             	mov    0x4(%edx),%edx
  803258:	89 50 04             	mov    %edx,0x4(%eax)
  80325b:	eb 0b                	jmp    803268 <alloc_block_BF+0x49e>
  80325d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803260:	8b 40 04             	mov    0x4(%eax),%eax
  803263:	a3 34 50 80 00       	mov    %eax,0x805034
  803268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326b:	8b 40 04             	mov    0x4(%eax),%eax
  80326e:	85 c0                	test   %eax,%eax
  803270:	74 0f                	je     803281 <alloc_block_BF+0x4b7>
  803272:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803275:	8b 40 04             	mov    0x4(%eax),%eax
  803278:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80327b:	8b 12                	mov    (%edx),%edx
  80327d:	89 10                	mov    %edx,(%eax)
  80327f:	eb 0a                	jmp    80328b <alloc_block_BF+0x4c1>
  803281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	a3 30 50 80 00       	mov    %eax,0x805030
  80328b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803297:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032a3:	48                   	dec    %eax
  8032a4:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  8032a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ac:	e9 fc 00 00 00       	jmp    8033ad <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b4:	83 c0 08             	add    $0x8,%eax
  8032b7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8032ba:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8032c1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8032c7:	01 d0                	add    %edx,%eax
  8032c9:	48                   	dec    %eax
  8032ca:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8032cd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8032d5:	f7 75 c4             	divl   -0x3c(%ebp)
  8032d8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032db:	29 d0                	sub    %edx,%eax
  8032dd:	c1 e8 0c             	shr    $0xc,%eax
  8032e0:	83 ec 0c             	sub    $0xc,%esp
  8032e3:	50                   	push   %eax
  8032e4:	e8 0c e8 ff ff       	call   801af5 <sbrk>
  8032e9:	83 c4 10             	add    $0x10,%esp
  8032ec:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8032ef:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8032f3:	75 0a                	jne    8032ff <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8032f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8032fa:	e9 ae 00 00 00       	jmp    8033ad <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8032ff:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803306:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803309:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80330c:	01 d0                	add    %edx,%eax
  80330e:	48                   	dec    %eax
  80330f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803312:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803315:	ba 00 00 00 00       	mov    $0x0,%edx
  80331a:	f7 75 b8             	divl   -0x48(%ebp)
  80331d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803320:	29 d0                	sub    %edx,%eax
  803322:	8d 50 fc             	lea    -0x4(%eax),%edx
  803325:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803328:	01 d0                	add    %edx,%eax
  80332a:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  80332f:	a1 44 50 80 00       	mov    0x805044,%eax
  803334:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80333a:	83 ec 0c             	sub    $0xc,%esp
  80333d:	68 68 4c 80 00       	push   $0x804c68
  803342:	e8 0c d8 ff ff       	call   800b53 <cprintf>
  803347:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80334a:	83 ec 08             	sub    $0x8,%esp
  80334d:	ff 75 bc             	pushl  -0x44(%ebp)
  803350:	68 6d 4c 80 00       	push   $0x804c6d
  803355:	e8 f9 d7 ff ff       	call   800b53 <cprintf>
  80335a:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80335d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803364:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803367:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80336a:	01 d0                	add    %edx,%eax
  80336c:	48                   	dec    %eax
  80336d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803370:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803373:	ba 00 00 00 00       	mov    $0x0,%edx
  803378:	f7 75 b0             	divl   -0x50(%ebp)
  80337b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80337e:	29 d0                	sub    %edx,%eax
  803380:	83 ec 04             	sub    $0x4,%esp
  803383:	6a 01                	push   $0x1
  803385:	50                   	push   %eax
  803386:	ff 75 bc             	pushl  -0x44(%ebp)
  803389:	e8 51 f5 ff ff       	call   8028df <set_block_data>
  80338e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803391:	83 ec 0c             	sub    $0xc,%esp
  803394:	ff 75 bc             	pushl  -0x44(%ebp)
  803397:	e8 36 04 00 00       	call   8037d2 <free_block>
  80339c:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80339f:	83 ec 0c             	sub    $0xc,%esp
  8033a2:	ff 75 08             	pushl  0x8(%ebp)
  8033a5:	e8 20 fa ff ff       	call   802dca <alloc_block_BF>
  8033aa:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8033ad:	c9                   	leave  
  8033ae:	c3                   	ret    

008033af <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8033af:	55                   	push   %ebp
  8033b0:	89 e5                	mov    %esp,%ebp
  8033b2:	53                   	push   %ebx
  8033b3:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8033b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8033c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033c8:	74 1e                	je     8033e8 <merging+0x39>
  8033ca:	ff 75 08             	pushl  0x8(%ebp)
  8033cd:	e8 bc f1 ff ff       	call   80258e <get_block_size>
  8033d2:	83 c4 04             	add    $0x4,%esp
  8033d5:	89 c2                	mov    %eax,%edx
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	01 d0                	add    %edx,%eax
  8033dc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8033df:	75 07                	jne    8033e8 <merging+0x39>
		prev_is_free = 1;
  8033e1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8033e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033ec:	74 1e                	je     80340c <merging+0x5d>
  8033ee:	ff 75 10             	pushl  0x10(%ebp)
  8033f1:	e8 98 f1 ff ff       	call   80258e <get_block_size>
  8033f6:	83 c4 04             	add    $0x4,%esp
  8033f9:	89 c2                	mov    %eax,%edx
  8033fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8033fe:	01 d0                	add    %edx,%eax
  803400:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803403:	75 07                	jne    80340c <merging+0x5d>
		next_is_free = 1;
  803405:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80340c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803410:	0f 84 cc 00 00 00    	je     8034e2 <merging+0x133>
  803416:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80341a:	0f 84 c2 00 00 00    	je     8034e2 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803420:	ff 75 08             	pushl  0x8(%ebp)
  803423:	e8 66 f1 ff ff       	call   80258e <get_block_size>
  803428:	83 c4 04             	add    $0x4,%esp
  80342b:	89 c3                	mov    %eax,%ebx
  80342d:	ff 75 10             	pushl  0x10(%ebp)
  803430:	e8 59 f1 ff ff       	call   80258e <get_block_size>
  803435:	83 c4 04             	add    $0x4,%esp
  803438:	01 c3                	add    %eax,%ebx
  80343a:	ff 75 0c             	pushl  0xc(%ebp)
  80343d:	e8 4c f1 ff ff       	call   80258e <get_block_size>
  803442:	83 c4 04             	add    $0x4,%esp
  803445:	01 d8                	add    %ebx,%eax
  803447:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80344a:	6a 00                	push   $0x0
  80344c:	ff 75 ec             	pushl  -0x14(%ebp)
  80344f:	ff 75 08             	pushl  0x8(%ebp)
  803452:	e8 88 f4 ff ff       	call   8028df <set_block_data>
  803457:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80345a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80345e:	75 17                	jne    803477 <merging+0xc8>
  803460:	83 ec 04             	sub    $0x4,%esp
  803463:	68 a3 4b 80 00       	push   $0x804ba3
  803468:	68 7d 01 00 00       	push   $0x17d
  80346d:	68 c1 4b 80 00       	push   $0x804bc1
  803472:	e8 1f d4 ff ff       	call   800896 <_panic>
  803477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80347a:	8b 00                	mov    (%eax),%eax
  80347c:	85 c0                	test   %eax,%eax
  80347e:	74 10                	je     803490 <merging+0xe1>
  803480:	8b 45 0c             	mov    0xc(%ebp),%eax
  803483:	8b 00                	mov    (%eax),%eax
  803485:	8b 55 0c             	mov    0xc(%ebp),%edx
  803488:	8b 52 04             	mov    0x4(%edx),%edx
  80348b:	89 50 04             	mov    %edx,0x4(%eax)
  80348e:	eb 0b                	jmp    80349b <merging+0xec>
  803490:	8b 45 0c             	mov    0xc(%ebp),%eax
  803493:	8b 40 04             	mov    0x4(%eax),%eax
  803496:	a3 34 50 80 00       	mov    %eax,0x805034
  80349b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349e:	8b 40 04             	mov    0x4(%eax),%eax
  8034a1:	85 c0                	test   %eax,%eax
  8034a3:	74 0f                	je     8034b4 <merging+0x105>
  8034a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a8:	8b 40 04             	mov    0x4(%eax),%eax
  8034ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034ae:	8b 12                	mov    (%edx),%edx
  8034b0:	89 10                	mov    %edx,(%eax)
  8034b2:	eb 0a                	jmp    8034be <merging+0x10f>
  8034b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b7:	8b 00                	mov    (%eax),%eax
  8034b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8034be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034d6:	48                   	dec    %eax
  8034d7:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8034dc:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034dd:	e9 ea 02 00 00       	jmp    8037cc <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8034e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e6:	74 3b                	je     803523 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8034e8:	83 ec 0c             	sub    $0xc,%esp
  8034eb:	ff 75 08             	pushl  0x8(%ebp)
  8034ee:	e8 9b f0 ff ff       	call   80258e <get_block_size>
  8034f3:	83 c4 10             	add    $0x10,%esp
  8034f6:	89 c3                	mov    %eax,%ebx
  8034f8:	83 ec 0c             	sub    $0xc,%esp
  8034fb:	ff 75 10             	pushl  0x10(%ebp)
  8034fe:	e8 8b f0 ff ff       	call   80258e <get_block_size>
  803503:	83 c4 10             	add    $0x10,%esp
  803506:	01 d8                	add    %ebx,%eax
  803508:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80350b:	83 ec 04             	sub    $0x4,%esp
  80350e:	6a 00                	push   $0x0
  803510:	ff 75 e8             	pushl  -0x18(%ebp)
  803513:	ff 75 08             	pushl  0x8(%ebp)
  803516:	e8 c4 f3 ff ff       	call   8028df <set_block_data>
  80351b:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80351e:	e9 a9 02 00 00       	jmp    8037cc <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803523:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803527:	0f 84 2d 01 00 00    	je     80365a <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80352d:	83 ec 0c             	sub    $0xc,%esp
  803530:	ff 75 10             	pushl  0x10(%ebp)
  803533:	e8 56 f0 ff ff       	call   80258e <get_block_size>
  803538:	83 c4 10             	add    $0x10,%esp
  80353b:	89 c3                	mov    %eax,%ebx
  80353d:	83 ec 0c             	sub    $0xc,%esp
  803540:	ff 75 0c             	pushl  0xc(%ebp)
  803543:	e8 46 f0 ff ff       	call   80258e <get_block_size>
  803548:	83 c4 10             	add    $0x10,%esp
  80354b:	01 d8                	add    %ebx,%eax
  80354d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803550:	83 ec 04             	sub    $0x4,%esp
  803553:	6a 00                	push   $0x0
  803555:	ff 75 e4             	pushl  -0x1c(%ebp)
  803558:	ff 75 10             	pushl  0x10(%ebp)
  80355b:	e8 7f f3 ff ff       	call   8028df <set_block_data>
  803560:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803563:	8b 45 10             	mov    0x10(%ebp),%eax
  803566:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803569:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80356d:	74 06                	je     803575 <merging+0x1c6>
  80356f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803573:	75 17                	jne    80358c <merging+0x1dd>
  803575:	83 ec 04             	sub    $0x4,%esp
  803578:	68 7c 4c 80 00       	push   $0x804c7c
  80357d:	68 8d 01 00 00       	push   $0x18d
  803582:	68 c1 4b 80 00       	push   $0x804bc1
  803587:	e8 0a d3 ff ff       	call   800896 <_panic>
  80358c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80358f:	8b 50 04             	mov    0x4(%eax),%edx
  803592:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803595:	89 50 04             	mov    %edx,0x4(%eax)
  803598:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80359b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80359e:	89 10                	mov    %edx,(%eax)
  8035a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035a3:	8b 40 04             	mov    0x4(%eax),%eax
  8035a6:	85 c0                	test   %eax,%eax
  8035a8:	74 0d                	je     8035b7 <merging+0x208>
  8035aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ad:	8b 40 04             	mov    0x4(%eax),%eax
  8035b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035b3:	89 10                	mov    %edx,(%eax)
  8035b5:	eb 08                	jmp    8035bf <merging+0x210>
  8035b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8035bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035c5:	89 50 04             	mov    %edx,0x4(%eax)
  8035c8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035cd:	40                   	inc    %eax
  8035ce:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  8035d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035d7:	75 17                	jne    8035f0 <merging+0x241>
  8035d9:	83 ec 04             	sub    $0x4,%esp
  8035dc:	68 a3 4b 80 00       	push   $0x804ba3
  8035e1:	68 8e 01 00 00       	push   $0x18e
  8035e6:	68 c1 4b 80 00       	push   $0x804bc1
  8035eb:	e8 a6 d2 ff ff       	call   800896 <_panic>
  8035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f3:	8b 00                	mov    (%eax),%eax
  8035f5:	85 c0                	test   %eax,%eax
  8035f7:	74 10                	je     803609 <merging+0x25a>
  8035f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fc:	8b 00                	mov    (%eax),%eax
  8035fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  803601:	8b 52 04             	mov    0x4(%edx),%edx
  803604:	89 50 04             	mov    %edx,0x4(%eax)
  803607:	eb 0b                	jmp    803614 <merging+0x265>
  803609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80360c:	8b 40 04             	mov    0x4(%eax),%eax
  80360f:	a3 34 50 80 00       	mov    %eax,0x805034
  803614:	8b 45 0c             	mov    0xc(%ebp),%eax
  803617:	8b 40 04             	mov    0x4(%eax),%eax
  80361a:	85 c0                	test   %eax,%eax
  80361c:	74 0f                	je     80362d <merging+0x27e>
  80361e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803621:	8b 40 04             	mov    0x4(%eax),%eax
  803624:	8b 55 0c             	mov    0xc(%ebp),%edx
  803627:	8b 12                	mov    (%edx),%edx
  803629:	89 10                	mov    %edx,(%eax)
  80362b:	eb 0a                	jmp    803637 <merging+0x288>
  80362d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803630:	8b 00                	mov    (%eax),%eax
  803632:	a3 30 50 80 00       	mov    %eax,0x805030
  803637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80363a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803640:	8b 45 0c             	mov    0xc(%ebp),%eax
  803643:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80364a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80364f:	48                   	dec    %eax
  803650:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803655:	e9 72 01 00 00       	jmp    8037cc <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80365a:	8b 45 10             	mov    0x10(%ebp),%eax
  80365d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803660:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803664:	74 79                	je     8036df <merging+0x330>
  803666:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80366a:	74 73                	je     8036df <merging+0x330>
  80366c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803670:	74 06                	je     803678 <merging+0x2c9>
  803672:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803676:	75 17                	jne    80368f <merging+0x2e0>
  803678:	83 ec 04             	sub    $0x4,%esp
  80367b:	68 34 4c 80 00       	push   $0x804c34
  803680:	68 94 01 00 00       	push   $0x194
  803685:	68 c1 4b 80 00       	push   $0x804bc1
  80368a:	e8 07 d2 ff ff       	call   800896 <_panic>
  80368f:	8b 45 08             	mov    0x8(%ebp),%eax
  803692:	8b 10                	mov    (%eax),%edx
  803694:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803697:	89 10                	mov    %edx,(%eax)
  803699:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80369c:	8b 00                	mov    (%eax),%eax
  80369e:	85 c0                	test   %eax,%eax
  8036a0:	74 0b                	je     8036ad <merging+0x2fe>
  8036a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a5:	8b 00                	mov    (%eax),%eax
  8036a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036aa:	89 50 04             	mov    %edx,0x4(%eax)
  8036ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036b3:	89 10                	mov    %edx,(%eax)
  8036b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8036bb:	89 50 04             	mov    %edx,0x4(%eax)
  8036be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036c1:	8b 00                	mov    (%eax),%eax
  8036c3:	85 c0                	test   %eax,%eax
  8036c5:	75 08                	jne    8036cf <merging+0x320>
  8036c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036ca:	a3 34 50 80 00       	mov    %eax,0x805034
  8036cf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036d4:	40                   	inc    %eax
  8036d5:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036da:	e9 ce 00 00 00       	jmp    8037ad <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8036df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e3:	74 65                	je     80374a <merging+0x39b>
  8036e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036e9:	75 17                	jne    803702 <merging+0x353>
  8036eb:	83 ec 04             	sub    $0x4,%esp
  8036ee:	68 10 4c 80 00       	push   $0x804c10
  8036f3:	68 95 01 00 00       	push   $0x195
  8036f8:	68 c1 4b 80 00       	push   $0x804bc1
  8036fd:	e8 94 d1 ff ff       	call   800896 <_panic>
  803702:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803708:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80370b:	89 50 04             	mov    %edx,0x4(%eax)
  80370e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803711:	8b 40 04             	mov    0x4(%eax),%eax
  803714:	85 c0                	test   %eax,%eax
  803716:	74 0c                	je     803724 <merging+0x375>
  803718:	a1 34 50 80 00       	mov    0x805034,%eax
  80371d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803720:	89 10                	mov    %edx,(%eax)
  803722:	eb 08                	jmp    80372c <merging+0x37d>
  803724:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803727:	a3 30 50 80 00       	mov    %eax,0x805030
  80372c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80372f:	a3 34 50 80 00       	mov    %eax,0x805034
  803734:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803737:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80373d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803742:	40                   	inc    %eax
  803743:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803748:	eb 63                	jmp    8037ad <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80374a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80374e:	75 17                	jne    803767 <merging+0x3b8>
  803750:	83 ec 04             	sub    $0x4,%esp
  803753:	68 dc 4b 80 00       	push   $0x804bdc
  803758:	68 98 01 00 00       	push   $0x198
  80375d:	68 c1 4b 80 00       	push   $0x804bc1
  803762:	e8 2f d1 ff ff       	call   800896 <_panic>
  803767:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80376d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803770:	89 10                	mov    %edx,(%eax)
  803772:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803775:	8b 00                	mov    (%eax),%eax
  803777:	85 c0                	test   %eax,%eax
  803779:	74 0d                	je     803788 <merging+0x3d9>
  80377b:	a1 30 50 80 00       	mov    0x805030,%eax
  803780:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803783:	89 50 04             	mov    %edx,0x4(%eax)
  803786:	eb 08                	jmp    803790 <merging+0x3e1>
  803788:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80378b:	a3 34 50 80 00       	mov    %eax,0x805034
  803790:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803793:	a3 30 50 80 00       	mov    %eax,0x805030
  803798:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80379b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037a7:	40                   	inc    %eax
  8037a8:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  8037ad:	83 ec 0c             	sub    $0xc,%esp
  8037b0:	ff 75 10             	pushl  0x10(%ebp)
  8037b3:	e8 d6 ed ff ff       	call   80258e <get_block_size>
  8037b8:	83 c4 10             	add    $0x10,%esp
  8037bb:	83 ec 04             	sub    $0x4,%esp
  8037be:	6a 00                	push   $0x0
  8037c0:	50                   	push   %eax
  8037c1:	ff 75 10             	pushl  0x10(%ebp)
  8037c4:	e8 16 f1 ff ff       	call   8028df <set_block_data>
  8037c9:	83 c4 10             	add    $0x10,%esp
	}
}
  8037cc:	90                   	nop
  8037cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8037d0:	c9                   	leave  
  8037d1:	c3                   	ret    

008037d2 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8037d2:	55                   	push   %ebp
  8037d3:	89 e5                	mov    %esp,%ebp
  8037d5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8037d8:	a1 30 50 80 00       	mov    0x805030,%eax
  8037dd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8037e0:	a1 34 50 80 00       	mov    0x805034,%eax
  8037e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037e8:	73 1b                	jae    803805 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8037ea:	a1 34 50 80 00       	mov    0x805034,%eax
  8037ef:	83 ec 04             	sub    $0x4,%esp
  8037f2:	ff 75 08             	pushl  0x8(%ebp)
  8037f5:	6a 00                	push   $0x0
  8037f7:	50                   	push   %eax
  8037f8:	e8 b2 fb ff ff       	call   8033af <merging>
  8037fd:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803800:	e9 8b 00 00 00       	jmp    803890 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803805:	a1 30 50 80 00       	mov    0x805030,%eax
  80380a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80380d:	76 18                	jbe    803827 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80380f:	a1 30 50 80 00       	mov    0x805030,%eax
  803814:	83 ec 04             	sub    $0x4,%esp
  803817:	ff 75 08             	pushl  0x8(%ebp)
  80381a:	50                   	push   %eax
  80381b:	6a 00                	push   $0x0
  80381d:	e8 8d fb ff ff       	call   8033af <merging>
  803822:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803825:	eb 69                	jmp    803890 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803827:	a1 30 50 80 00       	mov    0x805030,%eax
  80382c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80382f:	eb 39                	jmp    80386a <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803834:	3b 45 08             	cmp    0x8(%ebp),%eax
  803837:	73 29                	jae    803862 <free_block+0x90>
  803839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383c:	8b 00                	mov    (%eax),%eax
  80383e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803841:	76 1f                	jbe    803862 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803846:	8b 00                	mov    (%eax),%eax
  803848:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80384b:	83 ec 04             	sub    $0x4,%esp
  80384e:	ff 75 08             	pushl  0x8(%ebp)
  803851:	ff 75 f0             	pushl  -0x10(%ebp)
  803854:	ff 75 f4             	pushl  -0xc(%ebp)
  803857:	e8 53 fb ff ff       	call   8033af <merging>
  80385c:	83 c4 10             	add    $0x10,%esp
			break;
  80385f:	90                   	nop
		}
	}
}
  803860:	eb 2e                	jmp    803890 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803862:	a1 38 50 80 00       	mov    0x805038,%eax
  803867:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80386a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80386e:	74 07                	je     803877 <free_block+0xa5>
  803870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803873:	8b 00                	mov    (%eax),%eax
  803875:	eb 05                	jmp    80387c <free_block+0xaa>
  803877:	b8 00 00 00 00       	mov    $0x0,%eax
  80387c:	a3 38 50 80 00       	mov    %eax,0x805038
  803881:	a1 38 50 80 00       	mov    0x805038,%eax
  803886:	85 c0                	test   %eax,%eax
  803888:	75 a7                	jne    803831 <free_block+0x5f>
  80388a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80388e:	75 a1                	jne    803831 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803890:	90                   	nop
  803891:	c9                   	leave  
  803892:	c3                   	ret    

00803893 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803893:	55                   	push   %ebp
  803894:	89 e5                	mov    %esp,%ebp
  803896:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803899:	ff 75 08             	pushl  0x8(%ebp)
  80389c:	e8 ed ec ff ff       	call   80258e <get_block_size>
  8038a1:	83 c4 04             	add    $0x4,%esp
  8038a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8038a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8038ae:	eb 17                	jmp    8038c7 <copy_data+0x34>
  8038b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8038b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b6:	01 c2                	add    %eax,%edx
  8038b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8038bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038be:	01 c8                	add    %ecx,%eax
  8038c0:	8a 00                	mov    (%eax),%al
  8038c2:	88 02                	mov    %al,(%edx)
  8038c4:	ff 45 fc             	incl   -0x4(%ebp)
  8038c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8038ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8038cd:	72 e1                	jb     8038b0 <copy_data+0x1d>
}
  8038cf:	90                   	nop
  8038d0:	c9                   	leave  
  8038d1:	c3                   	ret    

008038d2 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8038d2:	55                   	push   %ebp
  8038d3:	89 e5                	mov    %esp,%ebp
  8038d5:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8038d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038dc:	75 23                	jne    803901 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8038de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038e2:	74 13                	je     8038f7 <realloc_block_FF+0x25>
  8038e4:	83 ec 0c             	sub    $0xc,%esp
  8038e7:	ff 75 0c             	pushl  0xc(%ebp)
  8038ea:	e8 1f f0 ff ff       	call   80290e <alloc_block_FF>
  8038ef:	83 c4 10             	add    $0x10,%esp
  8038f2:	e9 f4 06 00 00       	jmp    803feb <realloc_block_FF+0x719>
		return NULL;
  8038f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038fc:	e9 ea 06 00 00       	jmp    803feb <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803901:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803905:	75 18                	jne    80391f <realloc_block_FF+0x4d>
	{
		free_block(va);
  803907:	83 ec 0c             	sub    $0xc,%esp
  80390a:	ff 75 08             	pushl  0x8(%ebp)
  80390d:	e8 c0 fe ff ff       	call   8037d2 <free_block>
  803912:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803915:	b8 00 00 00 00       	mov    $0x0,%eax
  80391a:	e9 cc 06 00 00       	jmp    803feb <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80391f:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803923:	77 07                	ja     80392c <realloc_block_FF+0x5a>
  803925:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80392c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80392f:	83 e0 01             	and    $0x1,%eax
  803932:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803935:	8b 45 0c             	mov    0xc(%ebp),%eax
  803938:	83 c0 08             	add    $0x8,%eax
  80393b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80393e:	83 ec 0c             	sub    $0xc,%esp
  803941:	ff 75 08             	pushl  0x8(%ebp)
  803944:	e8 45 ec ff ff       	call   80258e <get_block_size>
  803949:	83 c4 10             	add    $0x10,%esp
  80394c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80394f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803952:	83 e8 08             	sub    $0x8,%eax
  803955:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803958:	8b 45 08             	mov    0x8(%ebp),%eax
  80395b:	83 e8 04             	sub    $0x4,%eax
  80395e:	8b 00                	mov    (%eax),%eax
  803960:	83 e0 fe             	and    $0xfffffffe,%eax
  803963:	89 c2                	mov    %eax,%edx
  803965:	8b 45 08             	mov    0x8(%ebp),%eax
  803968:	01 d0                	add    %edx,%eax
  80396a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80396d:	83 ec 0c             	sub    $0xc,%esp
  803970:	ff 75 e4             	pushl  -0x1c(%ebp)
  803973:	e8 16 ec ff ff       	call   80258e <get_block_size>
  803978:	83 c4 10             	add    $0x10,%esp
  80397b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80397e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803981:	83 e8 08             	sub    $0x8,%eax
  803984:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80398a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80398d:	75 08                	jne    803997 <realloc_block_FF+0xc5>
	{
		 return va;
  80398f:	8b 45 08             	mov    0x8(%ebp),%eax
  803992:	e9 54 06 00 00       	jmp    803feb <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803997:	8b 45 0c             	mov    0xc(%ebp),%eax
  80399a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80399d:	0f 83 e5 03 00 00    	jae    803d88 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8039a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a6:	2b 45 0c             	sub    0xc(%ebp),%eax
  8039a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8039ac:	83 ec 0c             	sub    $0xc,%esp
  8039af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039b2:	e8 f0 eb ff ff       	call   8025a7 <is_free_block>
  8039b7:	83 c4 10             	add    $0x10,%esp
  8039ba:	84 c0                	test   %al,%al
  8039bc:	0f 84 3b 01 00 00    	je     803afd <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8039c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039c8:	01 d0                	add    %edx,%eax
  8039ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8039cd:	83 ec 04             	sub    $0x4,%esp
  8039d0:	6a 01                	push   $0x1
  8039d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8039d5:	ff 75 08             	pushl  0x8(%ebp)
  8039d8:	e8 02 ef ff ff       	call   8028df <set_block_data>
  8039dd:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8039e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e3:	83 e8 04             	sub    $0x4,%eax
  8039e6:	8b 00                	mov    (%eax),%eax
  8039e8:	83 e0 fe             	and    $0xfffffffe,%eax
  8039eb:	89 c2                	mov    %eax,%edx
  8039ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f0:	01 d0                	add    %edx,%eax
  8039f2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8039f5:	83 ec 04             	sub    $0x4,%esp
  8039f8:	6a 00                	push   $0x0
  8039fa:	ff 75 cc             	pushl  -0x34(%ebp)
  8039fd:	ff 75 c8             	pushl  -0x38(%ebp)
  803a00:	e8 da ee ff ff       	call   8028df <set_block_data>
  803a05:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a0c:	74 06                	je     803a14 <realloc_block_FF+0x142>
  803a0e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803a12:	75 17                	jne    803a2b <realloc_block_FF+0x159>
  803a14:	83 ec 04             	sub    $0x4,%esp
  803a17:	68 34 4c 80 00       	push   $0x804c34
  803a1c:	68 f6 01 00 00       	push   $0x1f6
  803a21:	68 c1 4b 80 00       	push   $0x804bc1
  803a26:	e8 6b ce ff ff       	call   800896 <_panic>
  803a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2e:	8b 10                	mov    (%eax),%edx
  803a30:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a33:	89 10                	mov    %edx,(%eax)
  803a35:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a38:	8b 00                	mov    (%eax),%eax
  803a3a:	85 c0                	test   %eax,%eax
  803a3c:	74 0b                	je     803a49 <realloc_block_FF+0x177>
  803a3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a41:	8b 00                	mov    (%eax),%eax
  803a43:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a46:	89 50 04             	mov    %edx,0x4(%eax)
  803a49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a4c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a4f:	89 10                	mov    %edx,(%eax)
  803a51:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a57:	89 50 04             	mov    %edx,0x4(%eax)
  803a5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a5d:	8b 00                	mov    (%eax),%eax
  803a5f:	85 c0                	test   %eax,%eax
  803a61:	75 08                	jne    803a6b <realloc_block_FF+0x199>
  803a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a66:	a3 34 50 80 00       	mov    %eax,0x805034
  803a6b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a70:	40                   	inc    %eax
  803a71:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a7a:	75 17                	jne    803a93 <realloc_block_FF+0x1c1>
  803a7c:	83 ec 04             	sub    $0x4,%esp
  803a7f:	68 a3 4b 80 00       	push   $0x804ba3
  803a84:	68 f7 01 00 00       	push   $0x1f7
  803a89:	68 c1 4b 80 00       	push   $0x804bc1
  803a8e:	e8 03 ce ff ff       	call   800896 <_panic>
  803a93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a96:	8b 00                	mov    (%eax),%eax
  803a98:	85 c0                	test   %eax,%eax
  803a9a:	74 10                	je     803aac <realloc_block_FF+0x1da>
  803a9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9f:	8b 00                	mov    (%eax),%eax
  803aa1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aa4:	8b 52 04             	mov    0x4(%edx),%edx
  803aa7:	89 50 04             	mov    %edx,0x4(%eax)
  803aaa:	eb 0b                	jmp    803ab7 <realloc_block_FF+0x1e5>
  803aac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aaf:	8b 40 04             	mov    0x4(%eax),%eax
  803ab2:	a3 34 50 80 00       	mov    %eax,0x805034
  803ab7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aba:	8b 40 04             	mov    0x4(%eax),%eax
  803abd:	85 c0                	test   %eax,%eax
  803abf:	74 0f                	je     803ad0 <realloc_block_FF+0x1fe>
  803ac1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac4:	8b 40 04             	mov    0x4(%eax),%eax
  803ac7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aca:	8b 12                	mov    (%edx),%edx
  803acc:	89 10                	mov    %edx,(%eax)
  803ace:	eb 0a                	jmp    803ada <realloc_block_FF+0x208>
  803ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad3:	8b 00                	mov    (%eax),%eax
  803ad5:	a3 30 50 80 00       	mov    %eax,0x805030
  803ada:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803add:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ae3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aed:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803af2:	48                   	dec    %eax
  803af3:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803af8:	e9 83 02 00 00       	jmp    803d80 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803afd:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803b01:	0f 86 69 02 00 00    	jbe    803d70 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803b07:	83 ec 04             	sub    $0x4,%esp
  803b0a:	6a 01                	push   $0x1
  803b0c:	ff 75 f0             	pushl  -0x10(%ebp)
  803b0f:	ff 75 08             	pushl  0x8(%ebp)
  803b12:	e8 c8 ed ff ff       	call   8028df <set_block_data>
  803b17:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1d:	83 e8 04             	sub    $0x4,%eax
  803b20:	8b 00                	mov    (%eax),%eax
  803b22:	83 e0 fe             	and    $0xfffffffe,%eax
  803b25:	89 c2                	mov    %eax,%edx
  803b27:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2a:	01 d0                	add    %edx,%eax
  803b2c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803b2f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b34:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803b37:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b3b:	75 68                	jne    803ba5 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b3d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b41:	75 17                	jne    803b5a <realloc_block_FF+0x288>
  803b43:	83 ec 04             	sub    $0x4,%esp
  803b46:	68 dc 4b 80 00       	push   $0x804bdc
  803b4b:	68 06 02 00 00       	push   $0x206
  803b50:	68 c1 4b 80 00       	push   $0x804bc1
  803b55:	e8 3c cd ff ff       	call   800896 <_panic>
  803b5a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b63:	89 10                	mov    %edx,(%eax)
  803b65:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b68:	8b 00                	mov    (%eax),%eax
  803b6a:	85 c0                	test   %eax,%eax
  803b6c:	74 0d                	je     803b7b <realloc_block_FF+0x2a9>
  803b6e:	a1 30 50 80 00       	mov    0x805030,%eax
  803b73:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b76:	89 50 04             	mov    %edx,0x4(%eax)
  803b79:	eb 08                	jmp    803b83 <realloc_block_FF+0x2b1>
  803b7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b7e:	a3 34 50 80 00       	mov    %eax,0x805034
  803b83:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b86:	a3 30 50 80 00       	mov    %eax,0x805030
  803b8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b95:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b9a:	40                   	inc    %eax
  803b9b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803ba0:	e9 b0 01 00 00       	jmp    803d55 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803ba5:	a1 30 50 80 00       	mov    0x805030,%eax
  803baa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bad:	76 68                	jbe    803c17 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803baf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bb3:	75 17                	jne    803bcc <realloc_block_FF+0x2fa>
  803bb5:	83 ec 04             	sub    $0x4,%esp
  803bb8:	68 dc 4b 80 00       	push   $0x804bdc
  803bbd:	68 0b 02 00 00       	push   $0x20b
  803bc2:	68 c1 4b 80 00       	push   $0x804bc1
  803bc7:	e8 ca cc ff ff       	call   800896 <_panic>
  803bcc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803bd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bd5:	89 10                	mov    %edx,(%eax)
  803bd7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bda:	8b 00                	mov    (%eax),%eax
  803bdc:	85 c0                	test   %eax,%eax
  803bde:	74 0d                	je     803bed <realloc_block_FF+0x31b>
  803be0:	a1 30 50 80 00       	mov    0x805030,%eax
  803be5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803be8:	89 50 04             	mov    %edx,0x4(%eax)
  803beb:	eb 08                	jmp    803bf5 <realloc_block_FF+0x323>
  803bed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bf0:	a3 34 50 80 00       	mov    %eax,0x805034
  803bf5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bf8:	a3 30 50 80 00       	mov    %eax,0x805030
  803bfd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c07:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c0c:	40                   	inc    %eax
  803c0d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c12:	e9 3e 01 00 00       	jmp    803d55 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803c17:	a1 30 50 80 00       	mov    0x805030,%eax
  803c1c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c1f:	73 68                	jae    803c89 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c21:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c25:	75 17                	jne    803c3e <realloc_block_FF+0x36c>
  803c27:	83 ec 04             	sub    $0x4,%esp
  803c2a:	68 10 4c 80 00       	push   $0x804c10
  803c2f:	68 10 02 00 00       	push   $0x210
  803c34:	68 c1 4b 80 00       	push   $0x804bc1
  803c39:	e8 58 cc ff ff       	call   800896 <_panic>
  803c3e:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803c44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c47:	89 50 04             	mov    %edx,0x4(%eax)
  803c4a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c4d:	8b 40 04             	mov    0x4(%eax),%eax
  803c50:	85 c0                	test   %eax,%eax
  803c52:	74 0c                	je     803c60 <realloc_block_FF+0x38e>
  803c54:	a1 34 50 80 00       	mov    0x805034,%eax
  803c59:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c5c:	89 10                	mov    %edx,(%eax)
  803c5e:	eb 08                	jmp    803c68 <realloc_block_FF+0x396>
  803c60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c63:	a3 30 50 80 00       	mov    %eax,0x805030
  803c68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c6b:	a3 34 50 80 00       	mov    %eax,0x805034
  803c70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c79:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c7e:	40                   	inc    %eax
  803c7f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c84:	e9 cc 00 00 00       	jmp    803d55 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803c89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803c90:	a1 30 50 80 00       	mov    0x805030,%eax
  803c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c98:	e9 8a 00 00 00       	jmp    803d27 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803ca3:	73 7a                	jae    803d1f <realloc_block_FF+0x44d>
  803ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca8:	8b 00                	mov    (%eax),%eax
  803caa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803cad:	73 70                	jae    803d1f <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803caf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cb3:	74 06                	je     803cbb <realloc_block_FF+0x3e9>
  803cb5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cb9:	75 17                	jne    803cd2 <realloc_block_FF+0x400>
  803cbb:	83 ec 04             	sub    $0x4,%esp
  803cbe:	68 34 4c 80 00       	push   $0x804c34
  803cc3:	68 1a 02 00 00       	push   $0x21a
  803cc8:	68 c1 4b 80 00       	push   $0x804bc1
  803ccd:	e8 c4 cb ff ff       	call   800896 <_panic>
  803cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd5:	8b 10                	mov    (%eax),%edx
  803cd7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cda:	89 10                	mov    %edx,(%eax)
  803cdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cdf:	8b 00                	mov    (%eax),%eax
  803ce1:	85 c0                	test   %eax,%eax
  803ce3:	74 0b                	je     803cf0 <realloc_block_FF+0x41e>
  803ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce8:	8b 00                	mov    (%eax),%eax
  803cea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ced:	89 50 04             	mov    %edx,0x4(%eax)
  803cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cf6:	89 10                	mov    %edx,(%eax)
  803cf8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cfe:	89 50 04             	mov    %edx,0x4(%eax)
  803d01:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d04:	8b 00                	mov    (%eax),%eax
  803d06:	85 c0                	test   %eax,%eax
  803d08:	75 08                	jne    803d12 <realloc_block_FF+0x440>
  803d0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d0d:	a3 34 50 80 00       	mov    %eax,0x805034
  803d12:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d17:	40                   	inc    %eax
  803d18:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803d1d:	eb 36                	jmp    803d55 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803d1f:	a1 38 50 80 00       	mov    0x805038,%eax
  803d24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d2b:	74 07                	je     803d34 <realloc_block_FF+0x462>
  803d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d30:	8b 00                	mov    (%eax),%eax
  803d32:	eb 05                	jmp    803d39 <realloc_block_FF+0x467>
  803d34:	b8 00 00 00 00       	mov    $0x0,%eax
  803d39:	a3 38 50 80 00       	mov    %eax,0x805038
  803d3e:	a1 38 50 80 00       	mov    0x805038,%eax
  803d43:	85 c0                	test   %eax,%eax
  803d45:	0f 85 52 ff ff ff    	jne    803c9d <realloc_block_FF+0x3cb>
  803d4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d4f:	0f 85 48 ff ff ff    	jne    803c9d <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803d55:	83 ec 04             	sub    $0x4,%esp
  803d58:	6a 00                	push   $0x0
  803d5a:	ff 75 d8             	pushl  -0x28(%ebp)
  803d5d:	ff 75 d4             	pushl  -0x2c(%ebp)
  803d60:	e8 7a eb ff ff       	call   8028df <set_block_data>
  803d65:	83 c4 10             	add    $0x10,%esp
				return va;
  803d68:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6b:	e9 7b 02 00 00       	jmp    803feb <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803d70:	83 ec 0c             	sub    $0xc,%esp
  803d73:	68 b1 4c 80 00       	push   $0x804cb1
  803d78:	e8 d6 cd ff ff       	call   800b53 <cprintf>
  803d7d:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803d80:	8b 45 08             	mov    0x8(%ebp),%eax
  803d83:	e9 63 02 00 00       	jmp    803feb <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d8b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d8e:	0f 86 4d 02 00 00    	jbe    803fe1 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803d94:	83 ec 0c             	sub    $0xc,%esp
  803d97:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d9a:	e8 08 e8 ff ff       	call   8025a7 <is_free_block>
  803d9f:	83 c4 10             	add    $0x10,%esp
  803da2:	84 c0                	test   %al,%al
  803da4:	0f 84 37 02 00 00    	je     803fe1 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dad:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803db0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803db3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803db6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803db9:	76 38                	jbe    803df3 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803dbb:	83 ec 0c             	sub    $0xc,%esp
  803dbe:	ff 75 08             	pushl  0x8(%ebp)
  803dc1:	e8 0c fa ff ff       	call   8037d2 <free_block>
  803dc6:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803dc9:	83 ec 0c             	sub    $0xc,%esp
  803dcc:	ff 75 0c             	pushl  0xc(%ebp)
  803dcf:	e8 3a eb ff ff       	call   80290e <alloc_block_FF>
  803dd4:	83 c4 10             	add    $0x10,%esp
  803dd7:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803dda:	83 ec 08             	sub    $0x8,%esp
  803ddd:	ff 75 c0             	pushl  -0x40(%ebp)
  803de0:	ff 75 08             	pushl  0x8(%ebp)
  803de3:	e8 ab fa ff ff       	call   803893 <copy_data>
  803de8:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803deb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803dee:	e9 f8 01 00 00       	jmp    803feb <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803df3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803df6:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803df9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803dfc:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803e00:	0f 87 a0 00 00 00    	ja     803ea6 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803e06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e0a:	75 17                	jne    803e23 <realloc_block_FF+0x551>
  803e0c:	83 ec 04             	sub    $0x4,%esp
  803e0f:	68 a3 4b 80 00       	push   $0x804ba3
  803e14:	68 38 02 00 00       	push   $0x238
  803e19:	68 c1 4b 80 00       	push   $0x804bc1
  803e1e:	e8 73 ca ff ff       	call   800896 <_panic>
  803e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e26:	8b 00                	mov    (%eax),%eax
  803e28:	85 c0                	test   %eax,%eax
  803e2a:	74 10                	je     803e3c <realloc_block_FF+0x56a>
  803e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e2f:	8b 00                	mov    (%eax),%eax
  803e31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e34:	8b 52 04             	mov    0x4(%edx),%edx
  803e37:	89 50 04             	mov    %edx,0x4(%eax)
  803e3a:	eb 0b                	jmp    803e47 <realloc_block_FF+0x575>
  803e3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e3f:	8b 40 04             	mov    0x4(%eax),%eax
  803e42:	a3 34 50 80 00       	mov    %eax,0x805034
  803e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e4a:	8b 40 04             	mov    0x4(%eax),%eax
  803e4d:	85 c0                	test   %eax,%eax
  803e4f:	74 0f                	je     803e60 <realloc_block_FF+0x58e>
  803e51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e54:	8b 40 04             	mov    0x4(%eax),%eax
  803e57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e5a:	8b 12                	mov    (%edx),%edx
  803e5c:	89 10                	mov    %edx,(%eax)
  803e5e:	eb 0a                	jmp    803e6a <realloc_block_FF+0x598>
  803e60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e63:	8b 00                	mov    (%eax),%eax
  803e65:	a3 30 50 80 00       	mov    %eax,0x805030
  803e6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e7d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e82:	48                   	dec    %eax
  803e83:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803e88:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e8e:	01 d0                	add    %edx,%eax
  803e90:	83 ec 04             	sub    $0x4,%esp
  803e93:	6a 01                	push   $0x1
  803e95:	50                   	push   %eax
  803e96:	ff 75 08             	pushl  0x8(%ebp)
  803e99:	e8 41 ea ff ff       	call   8028df <set_block_data>
  803e9e:	83 c4 10             	add    $0x10,%esp
  803ea1:	e9 36 01 00 00       	jmp    803fdc <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803ea6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ea9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803eac:	01 d0                	add    %edx,%eax
  803eae:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803eb1:	83 ec 04             	sub    $0x4,%esp
  803eb4:	6a 01                	push   $0x1
  803eb6:	ff 75 f0             	pushl  -0x10(%ebp)
  803eb9:	ff 75 08             	pushl  0x8(%ebp)
  803ebc:	e8 1e ea ff ff       	call   8028df <set_block_data>
  803ec1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec7:	83 e8 04             	sub    $0x4,%eax
  803eca:	8b 00                	mov    (%eax),%eax
  803ecc:	83 e0 fe             	and    $0xfffffffe,%eax
  803ecf:	89 c2                	mov    %eax,%edx
  803ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed4:	01 d0                	add    %edx,%eax
  803ed6:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803ed9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803edd:	74 06                	je     803ee5 <realloc_block_FF+0x613>
  803edf:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803ee3:	75 17                	jne    803efc <realloc_block_FF+0x62a>
  803ee5:	83 ec 04             	sub    $0x4,%esp
  803ee8:	68 34 4c 80 00       	push   $0x804c34
  803eed:	68 44 02 00 00       	push   $0x244
  803ef2:	68 c1 4b 80 00       	push   $0x804bc1
  803ef7:	e8 9a c9 ff ff       	call   800896 <_panic>
  803efc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eff:	8b 10                	mov    (%eax),%edx
  803f01:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f04:	89 10                	mov    %edx,(%eax)
  803f06:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f09:	8b 00                	mov    (%eax),%eax
  803f0b:	85 c0                	test   %eax,%eax
  803f0d:	74 0b                	je     803f1a <realloc_block_FF+0x648>
  803f0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f12:	8b 00                	mov    (%eax),%eax
  803f14:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f17:	89 50 04             	mov    %edx,0x4(%eax)
  803f1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f1d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f20:	89 10                	mov    %edx,(%eax)
  803f22:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f28:	89 50 04             	mov    %edx,0x4(%eax)
  803f2b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f2e:	8b 00                	mov    (%eax),%eax
  803f30:	85 c0                	test   %eax,%eax
  803f32:	75 08                	jne    803f3c <realloc_block_FF+0x66a>
  803f34:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f37:	a3 34 50 80 00       	mov    %eax,0x805034
  803f3c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f41:	40                   	inc    %eax
  803f42:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803f47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f4b:	75 17                	jne    803f64 <realloc_block_FF+0x692>
  803f4d:	83 ec 04             	sub    $0x4,%esp
  803f50:	68 a3 4b 80 00       	push   $0x804ba3
  803f55:	68 45 02 00 00       	push   $0x245
  803f5a:	68 c1 4b 80 00       	push   $0x804bc1
  803f5f:	e8 32 c9 ff ff       	call   800896 <_panic>
  803f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f67:	8b 00                	mov    (%eax),%eax
  803f69:	85 c0                	test   %eax,%eax
  803f6b:	74 10                	je     803f7d <realloc_block_FF+0x6ab>
  803f6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f70:	8b 00                	mov    (%eax),%eax
  803f72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f75:	8b 52 04             	mov    0x4(%edx),%edx
  803f78:	89 50 04             	mov    %edx,0x4(%eax)
  803f7b:	eb 0b                	jmp    803f88 <realloc_block_FF+0x6b6>
  803f7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f80:	8b 40 04             	mov    0x4(%eax),%eax
  803f83:	a3 34 50 80 00       	mov    %eax,0x805034
  803f88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f8b:	8b 40 04             	mov    0x4(%eax),%eax
  803f8e:	85 c0                	test   %eax,%eax
  803f90:	74 0f                	je     803fa1 <realloc_block_FF+0x6cf>
  803f92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f95:	8b 40 04             	mov    0x4(%eax),%eax
  803f98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f9b:	8b 12                	mov    (%edx),%edx
  803f9d:	89 10                	mov    %edx,(%eax)
  803f9f:	eb 0a                	jmp    803fab <realloc_block_FF+0x6d9>
  803fa1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa4:	8b 00                	mov    (%eax),%eax
  803fa6:	a3 30 50 80 00       	mov    %eax,0x805030
  803fab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fbe:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803fc3:	48                   	dec    %eax
  803fc4:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803fc9:	83 ec 04             	sub    $0x4,%esp
  803fcc:	6a 00                	push   $0x0
  803fce:	ff 75 bc             	pushl  -0x44(%ebp)
  803fd1:	ff 75 b8             	pushl  -0x48(%ebp)
  803fd4:	e8 06 e9 ff ff       	call   8028df <set_block_data>
  803fd9:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  803fdf:	eb 0a                	jmp    803feb <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803fe1:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803fe8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803feb:	c9                   	leave  
  803fec:	c3                   	ret    

00803fed <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803fed:	55                   	push   %ebp
  803fee:	89 e5                	mov    %esp,%ebp
  803ff0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803ff3:	83 ec 04             	sub    $0x4,%esp
  803ff6:	68 b8 4c 80 00       	push   $0x804cb8
  803ffb:	68 58 02 00 00       	push   $0x258
  804000:	68 c1 4b 80 00       	push   $0x804bc1
  804005:	e8 8c c8 ff ff       	call   800896 <_panic>

0080400a <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80400a:	55                   	push   %ebp
  80400b:	89 e5                	mov    %esp,%ebp
  80400d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804010:	83 ec 04             	sub    $0x4,%esp
  804013:	68 e0 4c 80 00       	push   $0x804ce0
  804018:	68 61 02 00 00       	push   $0x261
  80401d:	68 c1 4b 80 00       	push   $0x804bc1
  804022:	e8 6f c8 ff ff       	call   800896 <_panic>
  804027:	90                   	nop

00804028 <__udivdi3>:
  804028:	55                   	push   %ebp
  804029:	57                   	push   %edi
  80402a:	56                   	push   %esi
  80402b:	53                   	push   %ebx
  80402c:	83 ec 1c             	sub    $0x1c,%esp
  80402f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804033:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804037:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80403b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80403f:	89 ca                	mov    %ecx,%edx
  804041:	89 f8                	mov    %edi,%eax
  804043:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804047:	85 f6                	test   %esi,%esi
  804049:	75 2d                	jne    804078 <__udivdi3+0x50>
  80404b:	39 cf                	cmp    %ecx,%edi
  80404d:	77 65                	ja     8040b4 <__udivdi3+0x8c>
  80404f:	89 fd                	mov    %edi,%ebp
  804051:	85 ff                	test   %edi,%edi
  804053:	75 0b                	jne    804060 <__udivdi3+0x38>
  804055:	b8 01 00 00 00       	mov    $0x1,%eax
  80405a:	31 d2                	xor    %edx,%edx
  80405c:	f7 f7                	div    %edi
  80405e:	89 c5                	mov    %eax,%ebp
  804060:	31 d2                	xor    %edx,%edx
  804062:	89 c8                	mov    %ecx,%eax
  804064:	f7 f5                	div    %ebp
  804066:	89 c1                	mov    %eax,%ecx
  804068:	89 d8                	mov    %ebx,%eax
  80406a:	f7 f5                	div    %ebp
  80406c:	89 cf                	mov    %ecx,%edi
  80406e:	89 fa                	mov    %edi,%edx
  804070:	83 c4 1c             	add    $0x1c,%esp
  804073:	5b                   	pop    %ebx
  804074:	5e                   	pop    %esi
  804075:	5f                   	pop    %edi
  804076:	5d                   	pop    %ebp
  804077:	c3                   	ret    
  804078:	39 ce                	cmp    %ecx,%esi
  80407a:	77 28                	ja     8040a4 <__udivdi3+0x7c>
  80407c:	0f bd fe             	bsr    %esi,%edi
  80407f:	83 f7 1f             	xor    $0x1f,%edi
  804082:	75 40                	jne    8040c4 <__udivdi3+0x9c>
  804084:	39 ce                	cmp    %ecx,%esi
  804086:	72 0a                	jb     804092 <__udivdi3+0x6a>
  804088:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80408c:	0f 87 9e 00 00 00    	ja     804130 <__udivdi3+0x108>
  804092:	b8 01 00 00 00       	mov    $0x1,%eax
  804097:	89 fa                	mov    %edi,%edx
  804099:	83 c4 1c             	add    $0x1c,%esp
  80409c:	5b                   	pop    %ebx
  80409d:	5e                   	pop    %esi
  80409e:	5f                   	pop    %edi
  80409f:	5d                   	pop    %ebp
  8040a0:	c3                   	ret    
  8040a1:	8d 76 00             	lea    0x0(%esi),%esi
  8040a4:	31 ff                	xor    %edi,%edi
  8040a6:	31 c0                	xor    %eax,%eax
  8040a8:	89 fa                	mov    %edi,%edx
  8040aa:	83 c4 1c             	add    $0x1c,%esp
  8040ad:	5b                   	pop    %ebx
  8040ae:	5e                   	pop    %esi
  8040af:	5f                   	pop    %edi
  8040b0:	5d                   	pop    %ebp
  8040b1:	c3                   	ret    
  8040b2:	66 90                	xchg   %ax,%ax
  8040b4:	89 d8                	mov    %ebx,%eax
  8040b6:	f7 f7                	div    %edi
  8040b8:	31 ff                	xor    %edi,%edi
  8040ba:	89 fa                	mov    %edi,%edx
  8040bc:	83 c4 1c             	add    $0x1c,%esp
  8040bf:	5b                   	pop    %ebx
  8040c0:	5e                   	pop    %esi
  8040c1:	5f                   	pop    %edi
  8040c2:	5d                   	pop    %ebp
  8040c3:	c3                   	ret    
  8040c4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040c9:	89 eb                	mov    %ebp,%ebx
  8040cb:	29 fb                	sub    %edi,%ebx
  8040cd:	89 f9                	mov    %edi,%ecx
  8040cf:	d3 e6                	shl    %cl,%esi
  8040d1:	89 c5                	mov    %eax,%ebp
  8040d3:	88 d9                	mov    %bl,%cl
  8040d5:	d3 ed                	shr    %cl,%ebp
  8040d7:	89 e9                	mov    %ebp,%ecx
  8040d9:	09 f1                	or     %esi,%ecx
  8040db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040df:	89 f9                	mov    %edi,%ecx
  8040e1:	d3 e0                	shl    %cl,%eax
  8040e3:	89 c5                	mov    %eax,%ebp
  8040e5:	89 d6                	mov    %edx,%esi
  8040e7:	88 d9                	mov    %bl,%cl
  8040e9:	d3 ee                	shr    %cl,%esi
  8040eb:	89 f9                	mov    %edi,%ecx
  8040ed:	d3 e2                	shl    %cl,%edx
  8040ef:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040f3:	88 d9                	mov    %bl,%cl
  8040f5:	d3 e8                	shr    %cl,%eax
  8040f7:	09 c2                	or     %eax,%edx
  8040f9:	89 d0                	mov    %edx,%eax
  8040fb:	89 f2                	mov    %esi,%edx
  8040fd:	f7 74 24 0c          	divl   0xc(%esp)
  804101:	89 d6                	mov    %edx,%esi
  804103:	89 c3                	mov    %eax,%ebx
  804105:	f7 e5                	mul    %ebp
  804107:	39 d6                	cmp    %edx,%esi
  804109:	72 19                	jb     804124 <__udivdi3+0xfc>
  80410b:	74 0b                	je     804118 <__udivdi3+0xf0>
  80410d:	89 d8                	mov    %ebx,%eax
  80410f:	31 ff                	xor    %edi,%edi
  804111:	e9 58 ff ff ff       	jmp    80406e <__udivdi3+0x46>
  804116:	66 90                	xchg   %ax,%ax
  804118:	8b 54 24 08          	mov    0x8(%esp),%edx
  80411c:	89 f9                	mov    %edi,%ecx
  80411e:	d3 e2                	shl    %cl,%edx
  804120:	39 c2                	cmp    %eax,%edx
  804122:	73 e9                	jae    80410d <__udivdi3+0xe5>
  804124:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804127:	31 ff                	xor    %edi,%edi
  804129:	e9 40 ff ff ff       	jmp    80406e <__udivdi3+0x46>
  80412e:	66 90                	xchg   %ax,%ax
  804130:	31 c0                	xor    %eax,%eax
  804132:	e9 37 ff ff ff       	jmp    80406e <__udivdi3+0x46>
  804137:	90                   	nop

00804138 <__umoddi3>:
  804138:	55                   	push   %ebp
  804139:	57                   	push   %edi
  80413a:	56                   	push   %esi
  80413b:	53                   	push   %ebx
  80413c:	83 ec 1c             	sub    $0x1c,%esp
  80413f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804143:	8b 74 24 34          	mov    0x34(%esp),%esi
  804147:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80414b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80414f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804153:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804157:	89 f3                	mov    %esi,%ebx
  804159:	89 fa                	mov    %edi,%edx
  80415b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80415f:	89 34 24             	mov    %esi,(%esp)
  804162:	85 c0                	test   %eax,%eax
  804164:	75 1a                	jne    804180 <__umoddi3+0x48>
  804166:	39 f7                	cmp    %esi,%edi
  804168:	0f 86 a2 00 00 00    	jbe    804210 <__umoddi3+0xd8>
  80416e:	89 c8                	mov    %ecx,%eax
  804170:	89 f2                	mov    %esi,%edx
  804172:	f7 f7                	div    %edi
  804174:	89 d0                	mov    %edx,%eax
  804176:	31 d2                	xor    %edx,%edx
  804178:	83 c4 1c             	add    $0x1c,%esp
  80417b:	5b                   	pop    %ebx
  80417c:	5e                   	pop    %esi
  80417d:	5f                   	pop    %edi
  80417e:	5d                   	pop    %ebp
  80417f:	c3                   	ret    
  804180:	39 f0                	cmp    %esi,%eax
  804182:	0f 87 ac 00 00 00    	ja     804234 <__umoddi3+0xfc>
  804188:	0f bd e8             	bsr    %eax,%ebp
  80418b:	83 f5 1f             	xor    $0x1f,%ebp
  80418e:	0f 84 ac 00 00 00    	je     804240 <__umoddi3+0x108>
  804194:	bf 20 00 00 00       	mov    $0x20,%edi
  804199:	29 ef                	sub    %ebp,%edi
  80419b:	89 fe                	mov    %edi,%esi
  80419d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041a1:	89 e9                	mov    %ebp,%ecx
  8041a3:	d3 e0                	shl    %cl,%eax
  8041a5:	89 d7                	mov    %edx,%edi
  8041a7:	89 f1                	mov    %esi,%ecx
  8041a9:	d3 ef                	shr    %cl,%edi
  8041ab:	09 c7                	or     %eax,%edi
  8041ad:	89 e9                	mov    %ebp,%ecx
  8041af:	d3 e2                	shl    %cl,%edx
  8041b1:	89 14 24             	mov    %edx,(%esp)
  8041b4:	89 d8                	mov    %ebx,%eax
  8041b6:	d3 e0                	shl    %cl,%eax
  8041b8:	89 c2                	mov    %eax,%edx
  8041ba:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041be:	d3 e0                	shl    %cl,%eax
  8041c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041c4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041c8:	89 f1                	mov    %esi,%ecx
  8041ca:	d3 e8                	shr    %cl,%eax
  8041cc:	09 d0                	or     %edx,%eax
  8041ce:	d3 eb                	shr    %cl,%ebx
  8041d0:	89 da                	mov    %ebx,%edx
  8041d2:	f7 f7                	div    %edi
  8041d4:	89 d3                	mov    %edx,%ebx
  8041d6:	f7 24 24             	mull   (%esp)
  8041d9:	89 c6                	mov    %eax,%esi
  8041db:	89 d1                	mov    %edx,%ecx
  8041dd:	39 d3                	cmp    %edx,%ebx
  8041df:	0f 82 87 00 00 00    	jb     80426c <__umoddi3+0x134>
  8041e5:	0f 84 91 00 00 00    	je     80427c <__umoddi3+0x144>
  8041eb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041ef:	29 f2                	sub    %esi,%edx
  8041f1:	19 cb                	sbb    %ecx,%ebx
  8041f3:	89 d8                	mov    %ebx,%eax
  8041f5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041f9:	d3 e0                	shl    %cl,%eax
  8041fb:	89 e9                	mov    %ebp,%ecx
  8041fd:	d3 ea                	shr    %cl,%edx
  8041ff:	09 d0                	or     %edx,%eax
  804201:	89 e9                	mov    %ebp,%ecx
  804203:	d3 eb                	shr    %cl,%ebx
  804205:	89 da                	mov    %ebx,%edx
  804207:	83 c4 1c             	add    $0x1c,%esp
  80420a:	5b                   	pop    %ebx
  80420b:	5e                   	pop    %esi
  80420c:	5f                   	pop    %edi
  80420d:	5d                   	pop    %ebp
  80420e:	c3                   	ret    
  80420f:	90                   	nop
  804210:	89 fd                	mov    %edi,%ebp
  804212:	85 ff                	test   %edi,%edi
  804214:	75 0b                	jne    804221 <__umoddi3+0xe9>
  804216:	b8 01 00 00 00       	mov    $0x1,%eax
  80421b:	31 d2                	xor    %edx,%edx
  80421d:	f7 f7                	div    %edi
  80421f:	89 c5                	mov    %eax,%ebp
  804221:	89 f0                	mov    %esi,%eax
  804223:	31 d2                	xor    %edx,%edx
  804225:	f7 f5                	div    %ebp
  804227:	89 c8                	mov    %ecx,%eax
  804229:	f7 f5                	div    %ebp
  80422b:	89 d0                	mov    %edx,%eax
  80422d:	e9 44 ff ff ff       	jmp    804176 <__umoddi3+0x3e>
  804232:	66 90                	xchg   %ax,%ax
  804234:	89 c8                	mov    %ecx,%eax
  804236:	89 f2                	mov    %esi,%edx
  804238:	83 c4 1c             	add    $0x1c,%esp
  80423b:	5b                   	pop    %ebx
  80423c:	5e                   	pop    %esi
  80423d:	5f                   	pop    %edi
  80423e:	5d                   	pop    %ebp
  80423f:	c3                   	ret    
  804240:	3b 04 24             	cmp    (%esp),%eax
  804243:	72 06                	jb     80424b <__umoddi3+0x113>
  804245:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804249:	77 0f                	ja     80425a <__umoddi3+0x122>
  80424b:	89 f2                	mov    %esi,%edx
  80424d:	29 f9                	sub    %edi,%ecx
  80424f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804253:	89 14 24             	mov    %edx,(%esp)
  804256:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80425a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80425e:	8b 14 24             	mov    (%esp),%edx
  804261:	83 c4 1c             	add    $0x1c,%esp
  804264:	5b                   	pop    %ebx
  804265:	5e                   	pop    %esi
  804266:	5f                   	pop    %edi
  804267:	5d                   	pop    %ebp
  804268:	c3                   	ret    
  804269:	8d 76 00             	lea    0x0(%esi),%esi
  80426c:	2b 04 24             	sub    (%esp),%eax
  80426f:	19 fa                	sbb    %edi,%edx
  804271:	89 d1                	mov    %edx,%ecx
  804273:	89 c6                	mov    %eax,%esi
  804275:	e9 71 ff ff ff       	jmp    8041eb <__umoddi3+0xb3>
  80427a:	66 90                	xchg   %ax,%ax
  80427c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804280:	72 ea                	jb     80426c <__umoddi3+0x134>
  804282:	89 d9                	mov    %ebx,%ecx
  804284:	e9 62 ff ff ff       	jmp    8041eb <__umoddi3+0xb3>
