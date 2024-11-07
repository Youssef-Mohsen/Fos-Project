
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 01 07 00 00       	call   800737 <libmain>
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
	{
		//2012: lock the interrupt
//		sys_lock_cons();
		int NumOfElements;
		int *Elements;
		sys_lock_cons();
  800041:	e8 1e 1c 00 00       	call   801c64 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 24 80 00       	push   $0x8024a0
  80004e:	e8 d8 0a 00 00       	call   800b2b <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 24 80 00       	push   $0x8024a2
  80005e:	e8 c8 0a 00 00       	call   800b2b <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 b8 24 80 00       	push   $0x8024b8
  80006e:	e8 b8 0a 00 00       	call   800b2b <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 24 80 00       	push   $0x8024a2
  80007e:	e8 a8 0a 00 00       	call   800b2b <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 24 80 00       	push   $0x8024a0
  80008e:	e8 98 0a 00 00       	call   800b2b <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d0 24 80 00       	push   $0x8024d0
  8000a5:	e8 15 11 00 00       	call   8011bf <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 67 16 00 00       	call   801727 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 0e 1a 00 00       	call   801ae3 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 f0 24 80 00       	push   $0x8024f0
  8000e3:	e8 43 0a 00 00       	call   800b2b <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 12 25 80 00       	push   $0x802512
  8000f3:	e8 33 0a 00 00       	call   800b2b <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 20 25 80 00       	push   $0x802520
  800103:	e8 23 0a 00 00       	call   800b2b <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 2f 25 80 00       	push   $0x80252f
  800113:	e8 13 0a 00 00       	call   800b2b <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 3f 25 80 00       	push   $0x80253f
  800123:	e8 03 0a 00 00       	call   800b2b <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  80012b:	e8 ea 05 00 00       	call   80071a <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>
		}
		sys_unlock_cons();
  800162:	e8 17 1b 00 00       	call   801c7e <sys_unlock_cons>
//		sys_unlock_cons();

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

//		sys_lock_cons();
		sys_lock_cons();
  8001d7:	e8 88 1a 00 00       	call   801c64 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 48 25 80 00       	push   $0x802548
  8001e4:	e8 42 09 00 00       	call   800b2b <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
			//PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ec:	e8 8d 1a 00 00       	call   801c7e <sys_unlock_cons>
//		sys_unlock_cons();

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 7c 25 80 00       	push   $0x80257c
  800213:	6a 51                	push   $0x51
  800215:	68 9e 25 80 00       	push   $0x80259e
  80021a:	e8 4f 06 00 00       	call   80086e <_panic>
		else
		{
//			sys_lock_cons();
			sys_lock_cons();
  80021f:	e8 40 1a 00 00       	call   801c64 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 b8 25 80 00       	push   $0x8025b8
  80022c:	e8 fa 08 00 00       	call   800b2b <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 ec 25 80 00       	push   $0x8025ec
  80023c:	e8 ea 08 00 00       	call   800b2b <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 20 26 80 00       	push   $0x802620
  80024c:	e8 da 08 00 00       	call   800b2b <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800254:	e8 25 1a 00 00       	call   801c7e <sys_unlock_cons>
		}

		//free(Elements) ;

//		sys_lock_cons();
		sys_lock_cons();
  800259:	e8 06 1a 00 00       	call   801c64 <sys_lock_cons>
		{
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 52 26 80 00       	push   $0x802652
  80026c:	e8 ba 08 00 00       	call   800b2b <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 a1 04 00 00       	call   80071a <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

//		sys_lock_cons();
		sys_lock_cons();
		{
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		}
		sys_unlock_cons();
  8002b2:	e8 c7 19 00 00       	call   801c7e <sys_unlock_cons>
//		sys_unlock_cons();

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 a0 24 80 00       	push   $0x8024a0
  80044b:	e8 db 06 00 00       	call   800b2b <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 70 26 80 00       	push   $0x802670
  80046d:	e8 b9 06 00 00       	call   800b2b <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 75 26 80 00       	push   $0x802675
  80049b:	e8 8b 06 00 00       	call   800b2b <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 a2 15 00 00       	call   801ae3 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 8d 15 00 00       	call   801ae3 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 9b 16 00 00       	call   801daf <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <getchar>:


int
getchar(void)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800720:	e8 26 15 00 00       	call   801c4b <sys_cgetc>
  800725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800728:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80072b:	c9                   	leave  
  80072c:	c3                   	ret    

0080072d <iscons>:

int iscons(int fdnum)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800730:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800735:	5d                   	pop    %ebp
  800736:	c3                   	ret    

00800737 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800737:	55                   	push   %ebp
  800738:	89 e5                	mov    %esp,%ebp
  80073a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80073d:	e8 9e 17 00 00       	call   801ee0 <sys_getenvindex>
  800742:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800745:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800748:	89 d0                	mov    %edx,%eax
  80074a:	c1 e0 02             	shl    $0x2,%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	01 c0                	add    %eax,%eax
  800751:	01 d0                	add    %edx,%eax
  800753:	c1 e0 02             	shl    $0x2,%eax
  800756:	01 d0                	add    %edx,%eax
  800758:	01 c0                	add    %eax,%eax
  80075a:	01 d0                	add    %edx,%eax
  80075c:	c1 e0 04             	shl    $0x4,%eax
  80075f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800764:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800769:	a1 08 30 80 00       	mov    0x803008,%eax
  80076e:	8a 40 20             	mov    0x20(%eax),%al
  800771:	84 c0                	test   %al,%al
  800773:	74 0d                	je     800782 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800775:	a1 08 30 80 00       	mov    0x803008,%eax
  80077a:	83 c0 20             	add    $0x20,%eax
  80077d:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800782:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800786:	7e 0a                	jle    800792 <libmain+0x5b>
		binaryname = argv[0];
  800788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	ff 75 0c             	pushl  0xc(%ebp)
  800798:	ff 75 08             	pushl  0x8(%ebp)
  80079b:	e8 98 f8 ff ff       	call   800038 <_main>
  8007a0:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8007a3:	e8 bc 14 00 00       	call   801c64 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8007a8:	83 ec 0c             	sub    $0xc,%esp
  8007ab:	68 94 26 80 00       	push   $0x802694
  8007b0:	e8 76 03 00 00       	call   800b2b <cprintf>
  8007b5:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007b8:	a1 08 30 80 00       	mov    0x803008,%eax
  8007bd:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8007c3:	a1 08 30 80 00       	mov    0x803008,%eax
  8007c8:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8007ce:	83 ec 04             	sub    $0x4,%esp
  8007d1:	52                   	push   %edx
  8007d2:	50                   	push   %eax
  8007d3:	68 bc 26 80 00       	push   $0x8026bc
  8007d8:	e8 4e 03 00 00       	call   800b2b <cprintf>
  8007dd:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007e0:	a1 08 30 80 00       	mov    0x803008,%eax
  8007e5:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8007eb:	a1 08 30 80 00       	mov    0x803008,%eax
  8007f0:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8007f6:	a1 08 30 80 00       	mov    0x803008,%eax
  8007fb:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800801:	51                   	push   %ecx
  800802:	52                   	push   %edx
  800803:	50                   	push   %eax
  800804:	68 e4 26 80 00       	push   $0x8026e4
  800809:	e8 1d 03 00 00       	call   800b2b <cprintf>
  80080e:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800811:	a1 08 30 80 00       	mov    0x803008,%eax
  800816:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	50                   	push   %eax
  800820:	68 3c 27 80 00       	push   $0x80273c
  800825:	e8 01 03 00 00       	call   800b2b <cprintf>
  80082a:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	68 94 26 80 00       	push   $0x802694
  800835:	e8 f1 02 00 00       	call   800b2b <cprintf>
  80083a:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80083d:	e8 3c 14 00 00       	call   801c7e <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800842:	e8 19 00 00 00       	call   800860 <exit>
}
  800847:	90                   	nop
  800848:	c9                   	leave  
  800849:	c3                   	ret    

0080084a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80084a:	55                   	push   %ebp
  80084b:	89 e5                	mov    %esp,%ebp
  80084d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800850:	83 ec 0c             	sub    $0xc,%esp
  800853:	6a 00                	push   $0x0
  800855:	e8 52 16 00 00       	call   801eac <sys_destroy_env>
  80085a:	83 c4 10             	add    $0x10,%esp
}
  80085d:	90                   	nop
  80085e:	c9                   	leave  
  80085f:	c3                   	ret    

00800860 <exit>:

void
exit(void)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800866:	e8 a7 16 00 00       	call   801f12 <sys_exit_env>
}
  80086b:	90                   	nop
  80086c:	c9                   	leave  
  80086d:	c3                   	ret    

0080086e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800874:	8d 45 10             	lea    0x10(%ebp),%eax
  800877:	83 c0 04             	add    $0x4,%eax
  80087a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80087d:	a1 28 30 80 00       	mov    0x803028,%eax
  800882:	85 c0                	test   %eax,%eax
  800884:	74 16                	je     80089c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800886:	a1 28 30 80 00       	mov    0x803028,%eax
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	50                   	push   %eax
  80088f:	68 50 27 80 00       	push   $0x802750
  800894:	e8 92 02 00 00       	call   800b2b <cprintf>
  800899:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80089c:	a1 00 30 80 00       	mov    0x803000,%eax
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	ff 75 08             	pushl  0x8(%ebp)
  8008a7:	50                   	push   %eax
  8008a8:	68 55 27 80 00       	push   $0x802755
  8008ad:	e8 79 02 00 00       	call   800b2b <cprintf>
  8008b2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8008be:	50                   	push   %eax
  8008bf:	e8 fc 01 00 00       	call   800ac0 <vcprintf>
  8008c4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008c7:	83 ec 08             	sub    $0x8,%esp
  8008ca:	6a 00                	push   $0x0
  8008cc:	68 71 27 80 00       	push   $0x802771
  8008d1:	e8 ea 01 00 00       	call   800ac0 <vcprintf>
  8008d6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008d9:	e8 82 ff ff ff       	call   800860 <exit>

	// should not return here
	while (1) ;
  8008de:	eb fe                	jmp    8008de <_panic+0x70>

008008e0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008e6:	a1 08 30 80 00       	mov    0x803008,%eax
  8008eb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f4:	39 c2                	cmp    %eax,%edx
  8008f6:	74 14                	je     80090c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008f8:	83 ec 04             	sub    $0x4,%esp
  8008fb:	68 74 27 80 00       	push   $0x802774
  800900:	6a 26                	push   $0x26
  800902:	68 c0 27 80 00       	push   $0x8027c0
  800907:	e8 62 ff ff ff       	call   80086e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80090c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800913:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80091a:	e9 c5 00 00 00       	jmp    8009e4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80091f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800922:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	01 d0                	add    %edx,%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	85 c0                	test   %eax,%eax
  800932:	75 08                	jne    80093c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800934:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800937:	e9 a5 00 00 00       	jmp    8009e1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80093c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800943:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80094a:	eb 69                	jmp    8009b5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80094c:	a1 08 30 80 00       	mov    0x803008,%eax
  800951:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800957:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80095a:	89 d0                	mov    %edx,%eax
  80095c:	01 c0                	add    %eax,%eax
  80095e:	01 d0                	add    %edx,%eax
  800960:	c1 e0 03             	shl    $0x3,%eax
  800963:	01 c8                	add    %ecx,%eax
  800965:	8a 40 04             	mov    0x4(%eax),%al
  800968:	84 c0                	test   %al,%al
  80096a:	75 46                	jne    8009b2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80096c:	a1 08 30 80 00       	mov    0x803008,%eax
  800971:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800977:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80097a:	89 d0                	mov    %edx,%eax
  80097c:	01 c0                	add    %eax,%eax
  80097e:	01 d0                	add    %edx,%eax
  800980:	c1 e0 03             	shl    $0x3,%eax
  800983:	01 c8                	add    %ecx,%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80098a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80098d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800992:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800997:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	01 c8                	add    %ecx,%eax
  8009a3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009a5:	39 c2                	cmp    %eax,%edx
  8009a7:	75 09                	jne    8009b2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8009a9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009b0:	eb 15                	jmp    8009c7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009b2:	ff 45 e8             	incl   -0x18(%ebp)
  8009b5:	a1 08 30 80 00       	mov    0x803008,%eax
  8009ba:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009c3:	39 c2                	cmp    %eax,%edx
  8009c5:	77 85                	ja     80094c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009cb:	75 14                	jne    8009e1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8009cd:	83 ec 04             	sub    $0x4,%esp
  8009d0:	68 cc 27 80 00       	push   $0x8027cc
  8009d5:	6a 3a                	push   $0x3a
  8009d7:	68 c0 27 80 00       	push   $0x8027c0
  8009dc:	e8 8d fe ff ff       	call   80086e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009e1:	ff 45 f0             	incl   -0x10(%ebp)
  8009e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009ea:	0f 8c 2f ff ff ff    	jl     80091f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009f7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009fe:	eb 26                	jmp    800a26 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a00:	a1 08 30 80 00       	mov    0x803008,%eax
  800a05:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800a0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0e:	89 d0                	mov    %edx,%eax
  800a10:	01 c0                	add    %eax,%eax
  800a12:	01 d0                	add    %edx,%eax
  800a14:	c1 e0 03             	shl    $0x3,%eax
  800a17:	01 c8                	add    %ecx,%eax
  800a19:	8a 40 04             	mov    0x4(%eax),%al
  800a1c:	3c 01                	cmp    $0x1,%al
  800a1e:	75 03                	jne    800a23 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a20:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a23:	ff 45 e0             	incl   -0x20(%ebp)
  800a26:	a1 08 30 80 00       	mov    0x803008,%eax
  800a2b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	77 c8                	ja     800a00 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a3b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a3e:	74 14                	je     800a54 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a40:	83 ec 04             	sub    $0x4,%esp
  800a43:	68 20 28 80 00       	push   $0x802820
  800a48:	6a 44                	push   $0x44
  800a4a:	68 c0 27 80 00       	push   $0x8027c0
  800a4f:	e8 1a fe ff ff       	call   80086e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a54:	90                   	nop
  800a55:	c9                   	leave  
  800a56:	c3                   	ret    

00800a57 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a60:	8b 00                	mov    (%eax),%eax
  800a62:	8d 48 01             	lea    0x1(%eax),%ecx
  800a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a68:	89 0a                	mov    %ecx,(%edx)
  800a6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a6d:	88 d1                	mov    %dl,%cl
  800a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a72:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a79:	8b 00                	mov    (%eax),%eax
  800a7b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a80:	75 2c                	jne    800aae <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a82:	a0 0c 30 80 00       	mov    0x80300c,%al
  800a87:	0f b6 c0             	movzbl %al,%eax
  800a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8d:	8b 12                	mov    (%edx),%edx
  800a8f:	89 d1                	mov    %edx,%ecx
  800a91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a94:	83 c2 08             	add    $0x8,%edx
  800a97:	83 ec 04             	sub    $0x4,%esp
  800a9a:	50                   	push   %eax
  800a9b:	51                   	push   %ecx
  800a9c:	52                   	push   %edx
  800a9d:	e8 80 11 00 00       	call   801c22 <sys_cputs>
  800aa2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab1:	8b 40 04             	mov    0x4(%eax),%eax
  800ab4:	8d 50 01             	lea    0x1(%eax),%edx
  800ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aba:	89 50 04             	mov    %edx,0x4(%eax)
}
  800abd:	90                   	nop
  800abe:	c9                   	leave  
  800abf:	c3                   	ret    

00800ac0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ac9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ad0:	00 00 00 
	b.cnt = 0;
  800ad3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ada:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	ff 75 08             	pushl  0x8(%ebp)
  800ae3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ae9:	50                   	push   %eax
  800aea:	68 57 0a 80 00       	push   $0x800a57
  800aef:	e8 11 02 00 00       	call   800d05 <vprintfmt>
  800af4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800af7:	a0 0c 30 80 00       	mov    0x80300c,%al
  800afc:	0f b6 c0             	movzbl %al,%eax
  800aff:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b05:	83 ec 04             	sub    $0x4,%esp
  800b08:	50                   	push   %eax
  800b09:	52                   	push   %edx
  800b0a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b10:	83 c0 08             	add    $0x8,%eax
  800b13:	50                   	push   %eax
  800b14:	e8 09 11 00 00       	call   801c22 <sys_cputs>
  800b19:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b1c:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800b23:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b31:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800b38:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	83 ec 08             	sub    $0x8,%esp
  800b44:	ff 75 f4             	pushl  -0xc(%ebp)
  800b47:	50                   	push   %eax
  800b48:	e8 73 ff ff ff       	call   800ac0 <vcprintf>
  800b4d:	83 c4 10             	add    $0x10,%esp
  800b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b56:	c9                   	leave  
  800b57:	c3                   	ret    

00800b58 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b5e:	e8 01 11 00 00       	call   801c64 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b63:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b72:	50                   	push   %eax
  800b73:	e8 48 ff ff ff       	call   800ac0 <vcprintf>
  800b78:	83 c4 10             	add    $0x10,%esp
  800b7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b7e:	e8 fb 10 00 00       	call   801c7e <sys_unlock_cons>
	return cnt;
  800b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b86:	c9                   	leave  
  800b87:	c3                   	ret    

00800b88 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	53                   	push   %ebx
  800b8c:	83 ec 14             	sub    $0x14,%esp
  800b8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b95:	8b 45 14             	mov    0x14(%ebp),%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b9b:	8b 45 18             	mov    0x18(%ebp),%eax
  800b9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ba6:	77 55                	ja     800bfd <printnum+0x75>
  800ba8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bab:	72 05                	jb     800bb2 <printnum+0x2a>
  800bad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bb0:	77 4b                	ja     800bfd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bb2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bb5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bb8:	8b 45 18             	mov    0x18(%ebp),%eax
  800bbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc0:	52                   	push   %edx
  800bc1:	50                   	push   %eax
  800bc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc5:	ff 75 f0             	pushl  -0x10(%ebp)
  800bc8:	e8 53 16 00 00       	call   802220 <__udivdi3>
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	83 ec 04             	sub    $0x4,%esp
  800bd3:	ff 75 20             	pushl  0x20(%ebp)
  800bd6:	53                   	push   %ebx
  800bd7:	ff 75 18             	pushl  0x18(%ebp)
  800bda:	52                   	push   %edx
  800bdb:	50                   	push   %eax
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	ff 75 08             	pushl  0x8(%ebp)
  800be2:	e8 a1 ff ff ff       	call   800b88 <printnum>
  800be7:	83 c4 20             	add    $0x20,%esp
  800bea:	eb 1a                	jmp    800c06 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bec:	83 ec 08             	sub    $0x8,%esp
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	ff 75 20             	pushl  0x20(%ebp)
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	ff d0                	call   *%eax
  800bfa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bfd:	ff 4d 1c             	decl   0x1c(%ebp)
  800c00:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c04:	7f e6                	jg     800bec <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c06:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c14:	53                   	push   %ebx
  800c15:	51                   	push   %ecx
  800c16:	52                   	push   %edx
  800c17:	50                   	push   %eax
  800c18:	e8 13 17 00 00       	call   802330 <__umoddi3>
  800c1d:	83 c4 10             	add    $0x10,%esp
  800c20:	05 94 2a 80 00       	add    $0x802a94,%eax
  800c25:	8a 00                	mov    (%eax),%al
  800c27:	0f be c0             	movsbl %al,%eax
  800c2a:	83 ec 08             	sub    $0x8,%esp
  800c2d:	ff 75 0c             	pushl  0xc(%ebp)
  800c30:	50                   	push   %eax
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	ff d0                	call   *%eax
  800c36:	83 c4 10             	add    $0x10,%esp
}
  800c39:	90                   	nop
  800c3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c3d:	c9                   	leave  
  800c3e:	c3                   	ret    

00800c3f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c42:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c46:	7e 1c                	jle    800c64 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8b 00                	mov    (%eax),%eax
  800c4d:	8d 50 08             	lea    0x8(%eax),%edx
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	89 10                	mov    %edx,(%eax)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8b 00                	mov    (%eax),%eax
  800c5a:	83 e8 08             	sub    $0x8,%eax
  800c5d:	8b 50 04             	mov    0x4(%eax),%edx
  800c60:	8b 00                	mov    (%eax),%eax
  800c62:	eb 40                	jmp    800ca4 <getuint+0x65>
	else if (lflag)
  800c64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c68:	74 1e                	je     800c88 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8b 00                	mov    (%eax),%eax
  800c6f:	8d 50 04             	lea    0x4(%eax),%edx
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	89 10                	mov    %edx,(%eax)
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	83 e8 04             	sub    $0x4,%eax
  800c7f:	8b 00                	mov    (%eax),%eax
  800c81:	ba 00 00 00 00       	mov    $0x0,%edx
  800c86:	eb 1c                	jmp    800ca4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	8b 00                	mov    (%eax),%eax
  800c8d:	8d 50 04             	lea    0x4(%eax),%edx
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	89 10                	mov    %edx,(%eax)
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	8b 00                	mov    (%eax),%eax
  800c9a:	83 e8 04             	sub    $0x4,%eax
  800c9d:	8b 00                	mov    (%eax),%eax
  800c9f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ca9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cad:	7e 1c                	jle    800ccb <getint+0x25>
		return va_arg(*ap, long long);
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	8b 00                	mov    (%eax),%eax
  800cb4:	8d 50 08             	lea    0x8(%eax),%edx
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 10                	mov    %edx,(%eax)
  800cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbf:	8b 00                	mov    (%eax),%eax
  800cc1:	83 e8 08             	sub    $0x8,%eax
  800cc4:	8b 50 04             	mov    0x4(%eax),%edx
  800cc7:	8b 00                	mov    (%eax),%eax
  800cc9:	eb 38                	jmp    800d03 <getint+0x5d>
	else if (lflag)
  800ccb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ccf:	74 1a                	je     800ceb <getint+0x45>
		return va_arg(*ap, long);
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8b 00                	mov    (%eax),%eax
  800cd6:	8d 50 04             	lea    0x4(%eax),%edx
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	89 10                	mov    %edx,(%eax)
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	8b 00                	mov    (%eax),%eax
  800ce3:	83 e8 04             	sub    $0x4,%eax
  800ce6:	8b 00                	mov    (%eax),%eax
  800ce8:	99                   	cltd   
  800ce9:	eb 18                	jmp    800d03 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8b 00                	mov    (%eax),%eax
  800cf0:	8d 50 04             	lea    0x4(%eax),%edx
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	89 10                	mov    %edx,(%eax)
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8b 00                	mov    (%eax),%eax
  800cfd:	83 e8 04             	sub    $0x4,%eax
  800d00:	8b 00                	mov    (%eax),%eax
  800d02:	99                   	cltd   
}
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
  800d0a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d0d:	eb 17                	jmp    800d26 <vprintfmt+0x21>
			if (ch == '\0')
  800d0f:	85 db                	test   %ebx,%ebx
  800d11:	0f 84 c1 03 00 00    	je     8010d8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	53                   	push   %ebx
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	ff d0                	call   *%eax
  800d23:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d26:	8b 45 10             	mov    0x10(%ebp),%eax
  800d29:	8d 50 01             	lea    0x1(%eax),%edx
  800d2c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	0f b6 d8             	movzbl %al,%ebx
  800d34:	83 fb 25             	cmp    $0x25,%ebx
  800d37:	75 d6                	jne    800d0f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d39:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d3d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d44:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d4b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d52:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d59:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5c:	8d 50 01             	lea    0x1(%eax),%edx
  800d5f:	89 55 10             	mov    %edx,0x10(%ebp)
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	0f b6 d8             	movzbl %al,%ebx
  800d67:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d6a:	83 f8 5b             	cmp    $0x5b,%eax
  800d6d:	0f 87 3d 03 00 00    	ja     8010b0 <vprintfmt+0x3ab>
  800d73:	8b 04 85 b8 2a 80 00 	mov    0x802ab8(,%eax,4),%eax
  800d7a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d7c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d80:	eb d7                	jmp    800d59 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d82:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d86:	eb d1                	jmp    800d59 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d88:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d92:	89 d0                	mov    %edx,%eax
  800d94:	c1 e0 02             	shl    $0x2,%eax
  800d97:	01 d0                	add    %edx,%eax
  800d99:	01 c0                	add    %eax,%eax
  800d9b:	01 d8                	add    %ebx,%eax
  800d9d:	83 e8 30             	sub    $0x30,%eax
  800da0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800da3:	8b 45 10             	mov    0x10(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dab:	83 fb 2f             	cmp    $0x2f,%ebx
  800dae:	7e 3e                	jle    800dee <vprintfmt+0xe9>
  800db0:	83 fb 39             	cmp    $0x39,%ebx
  800db3:	7f 39                	jg     800dee <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800db5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800db8:	eb d5                	jmp    800d8f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800dba:	8b 45 14             	mov    0x14(%ebp),%eax
  800dbd:	83 c0 04             	add    $0x4,%eax
  800dc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800dc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc6:	83 e8 04             	sub    $0x4,%eax
  800dc9:	8b 00                	mov    (%eax),%eax
  800dcb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800dce:	eb 1f                	jmp    800def <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800dd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd4:	79 83                	jns    800d59 <vprintfmt+0x54>
				width = 0;
  800dd6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ddd:	e9 77 ff ff ff       	jmp    800d59 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800de2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800de9:	e9 6b ff ff ff       	jmp    800d59 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800dee:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800def:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df3:	0f 89 60 ff ff ff    	jns    800d59 <vprintfmt+0x54>
				width = precision, precision = -1;
  800df9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dfc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e06:	e9 4e ff ff ff       	jmp    800d59 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e0b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e0e:	e9 46 ff ff ff       	jmp    800d59 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e13:	8b 45 14             	mov    0x14(%ebp),%eax
  800e16:	83 c0 04             	add    $0x4,%eax
  800e19:	89 45 14             	mov    %eax,0x14(%ebp)
  800e1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1f:	83 e8 04             	sub    $0x4,%eax
  800e22:	8b 00                	mov    (%eax),%eax
  800e24:	83 ec 08             	sub    $0x8,%esp
  800e27:	ff 75 0c             	pushl  0xc(%ebp)
  800e2a:	50                   	push   %eax
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	ff d0                	call   *%eax
  800e30:	83 c4 10             	add    $0x10,%esp
			break;
  800e33:	e9 9b 02 00 00       	jmp    8010d3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e38:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3b:	83 c0 04             	add    $0x4,%eax
  800e3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800e41:	8b 45 14             	mov    0x14(%ebp),%eax
  800e44:	83 e8 04             	sub    $0x4,%eax
  800e47:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e49:	85 db                	test   %ebx,%ebx
  800e4b:	79 02                	jns    800e4f <vprintfmt+0x14a>
				err = -err;
  800e4d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e4f:	83 fb 64             	cmp    $0x64,%ebx
  800e52:	7f 0b                	jg     800e5f <vprintfmt+0x15a>
  800e54:	8b 34 9d 00 29 80 00 	mov    0x802900(,%ebx,4),%esi
  800e5b:	85 f6                	test   %esi,%esi
  800e5d:	75 19                	jne    800e78 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e5f:	53                   	push   %ebx
  800e60:	68 a5 2a 80 00       	push   $0x802aa5
  800e65:	ff 75 0c             	pushl  0xc(%ebp)
  800e68:	ff 75 08             	pushl  0x8(%ebp)
  800e6b:	e8 70 02 00 00       	call   8010e0 <printfmt>
  800e70:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e73:	e9 5b 02 00 00       	jmp    8010d3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e78:	56                   	push   %esi
  800e79:	68 ae 2a 80 00       	push   $0x802aae
  800e7e:	ff 75 0c             	pushl  0xc(%ebp)
  800e81:	ff 75 08             	pushl  0x8(%ebp)
  800e84:	e8 57 02 00 00       	call   8010e0 <printfmt>
  800e89:	83 c4 10             	add    $0x10,%esp
			break;
  800e8c:	e9 42 02 00 00       	jmp    8010d3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e91:	8b 45 14             	mov    0x14(%ebp),%eax
  800e94:	83 c0 04             	add    $0x4,%eax
  800e97:	89 45 14             	mov    %eax,0x14(%ebp)
  800e9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9d:	83 e8 04             	sub    $0x4,%eax
  800ea0:	8b 30                	mov    (%eax),%esi
  800ea2:	85 f6                	test   %esi,%esi
  800ea4:	75 05                	jne    800eab <vprintfmt+0x1a6>
				p = "(null)";
  800ea6:	be b1 2a 80 00       	mov    $0x802ab1,%esi
			if (width > 0 && padc != '-')
  800eab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eaf:	7e 6d                	jle    800f1e <vprintfmt+0x219>
  800eb1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800eb5:	74 67                	je     800f1e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800eb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eba:	83 ec 08             	sub    $0x8,%esp
  800ebd:	50                   	push   %eax
  800ebe:	56                   	push   %esi
  800ebf:	e8 26 05 00 00       	call   8013ea <strnlen>
  800ec4:	83 c4 10             	add    $0x10,%esp
  800ec7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800eca:	eb 16                	jmp    800ee2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ecc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	ff 75 0c             	pushl  0xc(%ebp)
  800ed6:	50                   	push   %eax
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	ff d0                	call   *%eax
  800edc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800edf:	ff 4d e4             	decl   -0x1c(%ebp)
  800ee2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ee6:	7f e4                	jg     800ecc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ee8:	eb 34                	jmp    800f1e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800eea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800eee:	74 1c                	je     800f0c <vprintfmt+0x207>
  800ef0:	83 fb 1f             	cmp    $0x1f,%ebx
  800ef3:	7e 05                	jle    800efa <vprintfmt+0x1f5>
  800ef5:	83 fb 7e             	cmp    $0x7e,%ebx
  800ef8:	7e 12                	jle    800f0c <vprintfmt+0x207>
					putch('?', putdat);
  800efa:	83 ec 08             	sub    $0x8,%esp
  800efd:	ff 75 0c             	pushl  0xc(%ebp)
  800f00:	6a 3f                	push   $0x3f
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	ff d0                	call   *%eax
  800f07:	83 c4 10             	add    $0x10,%esp
  800f0a:	eb 0f                	jmp    800f1b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f0c:	83 ec 08             	sub    $0x8,%esp
  800f0f:	ff 75 0c             	pushl  0xc(%ebp)
  800f12:	53                   	push   %ebx
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	ff d0                	call   *%eax
  800f18:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f1b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f1e:	89 f0                	mov    %esi,%eax
  800f20:	8d 70 01             	lea    0x1(%eax),%esi
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	0f be d8             	movsbl %al,%ebx
  800f28:	85 db                	test   %ebx,%ebx
  800f2a:	74 24                	je     800f50 <vprintfmt+0x24b>
  800f2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f30:	78 b8                	js     800eea <vprintfmt+0x1e5>
  800f32:	ff 4d e0             	decl   -0x20(%ebp)
  800f35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f39:	79 af                	jns    800eea <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f3b:	eb 13                	jmp    800f50 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f3d:	83 ec 08             	sub    $0x8,%esp
  800f40:	ff 75 0c             	pushl  0xc(%ebp)
  800f43:	6a 20                	push   $0x20
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	ff d0                	call   *%eax
  800f4a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f4d:	ff 4d e4             	decl   -0x1c(%ebp)
  800f50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f54:	7f e7                	jg     800f3d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f56:	e9 78 01 00 00       	jmp    8010d3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f5b:	83 ec 08             	sub    $0x8,%esp
  800f5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f61:	8d 45 14             	lea    0x14(%ebp),%eax
  800f64:	50                   	push   %eax
  800f65:	e8 3c fd ff ff       	call   800ca6 <getint>
  800f6a:	83 c4 10             	add    $0x10,%esp
  800f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f79:	85 d2                	test   %edx,%edx
  800f7b:	79 23                	jns    800fa0 <vprintfmt+0x29b>
				putch('-', putdat);
  800f7d:	83 ec 08             	sub    $0x8,%esp
  800f80:	ff 75 0c             	pushl  0xc(%ebp)
  800f83:	6a 2d                	push   $0x2d
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	ff d0                	call   *%eax
  800f8a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f93:	f7 d8                	neg    %eax
  800f95:	83 d2 00             	adc    $0x0,%edx
  800f98:	f7 da                	neg    %edx
  800f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fa0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fa7:	e9 bc 00 00 00       	jmp    801068 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fac:	83 ec 08             	sub    $0x8,%esp
  800faf:	ff 75 e8             	pushl  -0x18(%ebp)
  800fb2:	8d 45 14             	lea    0x14(%ebp),%eax
  800fb5:	50                   	push   %eax
  800fb6:	e8 84 fc ff ff       	call   800c3f <getuint>
  800fbb:	83 c4 10             	add    $0x10,%esp
  800fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fc4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fcb:	e9 98 00 00 00       	jmp    801068 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fd0:	83 ec 08             	sub    $0x8,%esp
  800fd3:	ff 75 0c             	pushl  0xc(%ebp)
  800fd6:	6a 58                	push   $0x58
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	ff d0                	call   *%eax
  800fdd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fe0:	83 ec 08             	sub    $0x8,%esp
  800fe3:	ff 75 0c             	pushl  0xc(%ebp)
  800fe6:	6a 58                	push   $0x58
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	ff d0                	call   *%eax
  800fed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 0c             	pushl  0xc(%ebp)
  800ff6:	6a 58                	push   $0x58
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	ff d0                	call   *%eax
  800ffd:	83 c4 10             	add    $0x10,%esp
			break;
  801000:	e9 ce 00 00 00       	jmp    8010d3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801005:	83 ec 08             	sub    $0x8,%esp
  801008:	ff 75 0c             	pushl  0xc(%ebp)
  80100b:	6a 30                	push   $0x30
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	ff d0                	call   *%eax
  801012:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801015:	83 ec 08             	sub    $0x8,%esp
  801018:	ff 75 0c             	pushl  0xc(%ebp)
  80101b:	6a 78                	push   $0x78
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	ff d0                	call   *%eax
  801022:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801025:	8b 45 14             	mov    0x14(%ebp),%eax
  801028:	83 c0 04             	add    $0x4,%eax
  80102b:	89 45 14             	mov    %eax,0x14(%ebp)
  80102e:	8b 45 14             	mov    0x14(%ebp),%eax
  801031:	83 e8 04             	sub    $0x4,%eax
  801034:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801036:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801039:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801040:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801047:	eb 1f                	jmp    801068 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801049:	83 ec 08             	sub    $0x8,%esp
  80104c:	ff 75 e8             	pushl  -0x18(%ebp)
  80104f:	8d 45 14             	lea    0x14(%ebp),%eax
  801052:	50                   	push   %eax
  801053:	e8 e7 fb ff ff       	call   800c3f <getuint>
  801058:	83 c4 10             	add    $0x10,%esp
  80105b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801061:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801068:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80106c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80106f:	83 ec 04             	sub    $0x4,%esp
  801072:	52                   	push   %edx
  801073:	ff 75 e4             	pushl  -0x1c(%ebp)
  801076:	50                   	push   %eax
  801077:	ff 75 f4             	pushl  -0xc(%ebp)
  80107a:	ff 75 f0             	pushl  -0x10(%ebp)
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	ff 75 08             	pushl  0x8(%ebp)
  801083:	e8 00 fb ff ff       	call   800b88 <printnum>
  801088:	83 c4 20             	add    $0x20,%esp
			break;
  80108b:	eb 46                	jmp    8010d3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80108d:	83 ec 08             	sub    $0x8,%esp
  801090:	ff 75 0c             	pushl  0xc(%ebp)
  801093:	53                   	push   %ebx
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	ff d0                	call   *%eax
  801099:	83 c4 10             	add    $0x10,%esp
			break;
  80109c:	eb 35                	jmp    8010d3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80109e:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  8010a5:	eb 2c                	jmp    8010d3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010a7:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  8010ae:	eb 23                	jmp    8010d3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010b0:	83 ec 08             	sub    $0x8,%esp
  8010b3:	ff 75 0c             	pushl  0xc(%ebp)
  8010b6:	6a 25                	push   $0x25
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	ff d0                	call   *%eax
  8010bd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010c0:	ff 4d 10             	decl   0x10(%ebp)
  8010c3:	eb 03                	jmp    8010c8 <vprintfmt+0x3c3>
  8010c5:	ff 4d 10             	decl   0x10(%ebp)
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	48                   	dec    %eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	3c 25                	cmp    $0x25,%al
  8010d0:	75 f3                	jne    8010c5 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010d2:	90                   	nop
		}
	}
  8010d3:	e9 35 fc ff ff       	jmp    800d0d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010d8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010dc:	5b                   	pop    %ebx
  8010dd:	5e                   	pop    %esi
  8010de:	5d                   	pop    %ebp
  8010df:	c3                   	ret    

008010e0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010e6:	8d 45 10             	lea    0x10(%ebp),%eax
  8010e9:	83 c0 04             	add    $0x4,%eax
  8010ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f5:	50                   	push   %eax
  8010f6:	ff 75 0c             	pushl  0xc(%ebp)
  8010f9:	ff 75 08             	pushl  0x8(%ebp)
  8010fc:	e8 04 fc ff ff       	call   800d05 <vprintfmt>
  801101:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801104:	90                   	nop
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	8b 40 08             	mov    0x8(%eax),%eax
  801110:	8d 50 01             	lea    0x1(%eax),%edx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	8b 10                	mov    (%eax),%edx
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	8b 40 04             	mov    0x4(%eax),%eax
  801124:	39 c2                	cmp    %eax,%edx
  801126:	73 12                	jae    80113a <sprintputch+0x33>
		*b->buf++ = ch;
  801128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112b:	8b 00                	mov    (%eax),%eax
  80112d:	8d 48 01             	lea    0x1(%eax),%ecx
  801130:	8b 55 0c             	mov    0xc(%ebp),%edx
  801133:	89 0a                	mov    %ecx,(%edx)
  801135:	8b 55 08             	mov    0x8(%ebp),%edx
  801138:	88 10                	mov    %dl,(%eax)
}
  80113a:	90                   	nop
  80113b:	5d                   	pop    %ebp
  80113c:	c3                   	ret    

0080113d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	01 d0                	add    %edx,%eax
  801154:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801157:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80115e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801162:	74 06                	je     80116a <vsnprintf+0x2d>
  801164:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801168:	7f 07                	jg     801171 <vsnprintf+0x34>
		return -E_INVAL;
  80116a:	b8 03 00 00 00       	mov    $0x3,%eax
  80116f:	eb 20                	jmp    801191 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801171:	ff 75 14             	pushl  0x14(%ebp)
  801174:	ff 75 10             	pushl  0x10(%ebp)
  801177:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80117a:	50                   	push   %eax
  80117b:	68 07 11 80 00       	push   $0x801107
  801180:	e8 80 fb ff ff       	call   800d05 <vprintfmt>
  801185:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801188:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80118b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80118e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801191:	c9                   	leave  
  801192:	c3                   	ret    

00801193 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801199:	8d 45 10             	lea    0x10(%ebp),%eax
  80119c:	83 c0 04             	add    $0x4,%eax
  80119f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a8:	50                   	push   %eax
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	ff 75 08             	pushl  0x8(%ebp)
  8011af:	e8 89 ff ff ff       	call   80113d <vsnprintf>
  8011b4:	83 c4 10             	add    $0x10,%esp
  8011b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8011c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c9:	74 13                	je     8011de <readline+0x1f>
		cprintf("%s", prompt);
  8011cb:	83 ec 08             	sub    $0x8,%esp
  8011ce:	ff 75 08             	pushl  0x8(%ebp)
  8011d1:	68 28 2c 80 00       	push   $0x802c28
  8011d6:	e8 50 f9 ff ff       	call   800b2b <cprintf>
  8011db:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011e5:	83 ec 0c             	sub    $0xc,%esp
  8011e8:	6a 00                	push   $0x0
  8011ea:	e8 3e f5 ff ff       	call   80072d <iscons>
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011f5:	e8 20 f5 ff ff       	call   80071a <getchar>
  8011fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801201:	79 22                	jns    801225 <readline+0x66>
			if (c != -E_EOF)
  801203:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801207:	0f 84 ad 00 00 00    	je     8012ba <readline+0xfb>
				cprintf("read error: %e\n", c);
  80120d:	83 ec 08             	sub    $0x8,%esp
  801210:	ff 75 ec             	pushl  -0x14(%ebp)
  801213:	68 2b 2c 80 00       	push   $0x802c2b
  801218:	e8 0e f9 ff ff       	call   800b2b <cprintf>
  80121d:	83 c4 10             	add    $0x10,%esp
			break;
  801220:	e9 95 00 00 00       	jmp    8012ba <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801225:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801229:	7e 34                	jle    80125f <readline+0xa0>
  80122b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801232:	7f 2b                	jg     80125f <readline+0xa0>
			if (echoing)
  801234:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801238:	74 0e                	je     801248 <readline+0x89>
				cputchar(c);
  80123a:	83 ec 0c             	sub    $0xc,%esp
  80123d:	ff 75 ec             	pushl  -0x14(%ebp)
  801240:	e8 b6 f4 ff ff       	call   8006fb <cputchar>
  801245:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124b:	8d 50 01             	lea    0x1(%eax),%edx
  80124e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801251:	89 c2                	mov    %eax,%edx
  801253:	8b 45 0c             	mov    0xc(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80125b:	88 10                	mov    %dl,(%eax)
  80125d:	eb 56                	jmp    8012b5 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  80125f:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801263:	75 1f                	jne    801284 <readline+0xc5>
  801265:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801269:	7e 19                	jle    801284 <readline+0xc5>
			if (echoing)
  80126b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126f:	74 0e                	je     80127f <readline+0xc0>
				cputchar(c);
  801271:	83 ec 0c             	sub    $0xc,%esp
  801274:	ff 75 ec             	pushl  -0x14(%ebp)
  801277:	e8 7f f4 ff ff       	call   8006fb <cputchar>
  80127c:	83 c4 10             	add    $0x10,%esp

			i--;
  80127f:	ff 4d f4             	decl   -0xc(%ebp)
  801282:	eb 31                	jmp    8012b5 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801284:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801288:	74 0a                	je     801294 <readline+0xd5>
  80128a:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80128e:	0f 85 61 ff ff ff    	jne    8011f5 <readline+0x36>
			if (echoing)
  801294:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801298:	74 0e                	je     8012a8 <readline+0xe9>
				cputchar(c);
  80129a:	83 ec 0c             	sub    $0xc,%esp
  80129d:	ff 75 ec             	pushl  -0x14(%ebp)
  8012a0:	e8 56 f4 ff ff       	call   8006fb <cputchar>
  8012a5:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8012b3:	eb 06                	jmp    8012bb <readline+0xfc>
		}
	}
  8012b5:	e9 3b ff ff ff       	jmp    8011f5 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8012ba:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8012bb:	90                   	nop
  8012bc:	c9                   	leave  
  8012bd:	c3                   	ret    

008012be <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8012c4:	e8 9b 09 00 00       	call   801c64 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012cd:	74 13                	je     8012e2 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012cf:	83 ec 08             	sub    $0x8,%esp
  8012d2:	ff 75 08             	pushl  0x8(%ebp)
  8012d5:	68 28 2c 80 00       	push   $0x802c28
  8012da:	e8 4c f8 ff ff       	call   800b2b <cprintf>
  8012df:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8012e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	6a 00                	push   $0x0
  8012ee:	e8 3a f4 ff ff       	call   80072d <iscons>
  8012f3:	83 c4 10             	add    $0x10,%esp
  8012f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8012f9:	e8 1c f4 ff ff       	call   80071a <getchar>
  8012fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801301:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801305:	79 22                	jns    801329 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801307:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80130b:	0f 84 ad 00 00 00    	je     8013be <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801311:	83 ec 08             	sub    $0x8,%esp
  801314:	ff 75 ec             	pushl  -0x14(%ebp)
  801317:	68 2b 2c 80 00       	push   $0x802c2b
  80131c:	e8 0a f8 ff ff       	call   800b2b <cprintf>
  801321:	83 c4 10             	add    $0x10,%esp
				break;
  801324:	e9 95 00 00 00       	jmp    8013be <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801329:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80132d:	7e 34                	jle    801363 <atomic_readline+0xa5>
  80132f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801336:	7f 2b                	jg     801363 <atomic_readline+0xa5>
				if (echoing)
  801338:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80133c:	74 0e                	je     80134c <atomic_readline+0x8e>
					cputchar(c);
  80133e:	83 ec 0c             	sub    $0xc,%esp
  801341:	ff 75 ec             	pushl  -0x14(%ebp)
  801344:	e8 b2 f3 ff ff       	call   8006fb <cputchar>
  801349:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80134c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134f:	8d 50 01             	lea    0x1(%eax),%edx
  801352:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801355:	89 c2                	mov    %eax,%edx
  801357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135a:	01 d0                	add    %edx,%eax
  80135c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80135f:	88 10                	mov    %dl,(%eax)
  801361:	eb 56                	jmp    8013b9 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801363:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801367:	75 1f                	jne    801388 <atomic_readline+0xca>
  801369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80136d:	7e 19                	jle    801388 <atomic_readline+0xca>
				if (echoing)
  80136f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801373:	74 0e                	je     801383 <atomic_readline+0xc5>
					cputchar(c);
  801375:	83 ec 0c             	sub    $0xc,%esp
  801378:	ff 75 ec             	pushl  -0x14(%ebp)
  80137b:	e8 7b f3 ff ff       	call   8006fb <cputchar>
  801380:	83 c4 10             	add    $0x10,%esp
				i--;
  801383:	ff 4d f4             	decl   -0xc(%ebp)
  801386:	eb 31                	jmp    8013b9 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801388:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80138c:	74 0a                	je     801398 <atomic_readline+0xda>
  80138e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801392:	0f 85 61 ff ff ff    	jne    8012f9 <atomic_readline+0x3b>
				if (echoing)
  801398:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80139c:	74 0e                	je     8013ac <atomic_readline+0xee>
					cputchar(c);
  80139e:	83 ec 0c             	sub    $0xc,%esp
  8013a1:	ff 75 ec             	pushl  -0x14(%ebp)
  8013a4:	e8 52 f3 ff ff       	call   8006fb <cputchar>
  8013a9:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8013ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b2:	01 d0                	add    %edx,%eax
  8013b4:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8013b7:	eb 06                	jmp    8013bf <atomic_readline+0x101>
			}
		}
  8013b9:	e9 3b ff ff ff       	jmp    8012f9 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8013be:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8013bf:	e8 ba 08 00 00       	call   801c7e <sys_unlock_cons>
}
  8013c4:	90                   	nop
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013d4:	eb 06                	jmp    8013dc <strlen+0x15>
		n++;
  8013d6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013d9:	ff 45 08             	incl   0x8(%ebp)
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	84 c0                	test   %al,%al
  8013e3:	75 f1                	jne    8013d6 <strlen+0xf>
		n++;
	return n;
  8013e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f7:	eb 09                	jmp    801402 <strnlen+0x18>
		n++;
  8013f9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013fc:	ff 45 08             	incl   0x8(%ebp)
  8013ff:	ff 4d 0c             	decl   0xc(%ebp)
  801402:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801406:	74 09                	je     801411 <strnlen+0x27>
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	84 c0                	test   %al,%al
  80140f:	75 e8                	jne    8013f9 <strnlen+0xf>
		n++;
	return n;
  801411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801414:	c9                   	leave  
  801415:	c3                   	ret    

00801416 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801422:	90                   	nop
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8d 50 01             	lea    0x1(%eax),%edx
  801429:	89 55 08             	mov    %edx,0x8(%ebp)
  80142c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801432:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801435:	8a 12                	mov    (%edx),%dl
  801437:	88 10                	mov    %dl,(%eax)
  801439:	8a 00                	mov    (%eax),%al
  80143b:	84 c0                	test   %al,%al
  80143d:	75 e4                	jne    801423 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80143f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801450:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801457:	eb 1f                	jmp    801478 <strncpy+0x34>
		*dst++ = *src;
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8d 50 01             	lea    0x1(%eax),%edx
  80145f:	89 55 08             	mov    %edx,0x8(%ebp)
  801462:	8b 55 0c             	mov    0xc(%ebp),%edx
  801465:	8a 12                	mov    (%edx),%dl
  801467:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	84 c0                	test   %al,%al
  801470:	74 03                	je     801475 <strncpy+0x31>
			src++;
  801472:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801475:	ff 45 fc             	incl   -0x4(%ebp)
  801478:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80147b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80147e:	72 d9                	jb     801459 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801480:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801491:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801495:	74 30                	je     8014c7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801497:	eb 16                	jmp    8014af <strlcpy+0x2a>
			*dst++ = *src++;
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8d 50 01             	lea    0x1(%eax),%edx
  80149f:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014ab:	8a 12                	mov    (%edx),%dl
  8014ad:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014af:	ff 4d 10             	decl   0x10(%ebp)
  8014b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b6:	74 09                	je     8014c1 <strlcpy+0x3c>
  8014b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bb:	8a 00                	mov    (%eax),%al
  8014bd:	84 c0                	test   %al,%al
  8014bf:	75 d8                	jne    801499 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cd:	29 c2                	sub    %eax,%edx
  8014cf:	89 d0                	mov    %edx,%eax
}
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014d6:	eb 06                	jmp    8014de <strcmp+0xb>
		p++, q++;
  8014d8:	ff 45 08             	incl   0x8(%ebp)
  8014db:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	84 c0                	test   %al,%al
  8014e5:	74 0e                	je     8014f5 <strcmp+0x22>
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 10                	mov    (%eax),%dl
  8014ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	38 c2                	cmp    %al,%dl
  8014f3:	74 e3                	je     8014d8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	8a 00                	mov    (%eax),%al
  8014fa:	0f b6 d0             	movzbl %al,%edx
  8014fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	0f b6 c0             	movzbl %al,%eax
  801505:	29 c2                	sub    %eax,%edx
  801507:	89 d0                	mov    %edx,%eax
}
  801509:	5d                   	pop    %ebp
  80150a:	c3                   	ret    

0080150b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80150e:	eb 09                	jmp    801519 <strncmp+0xe>
		n--, p++, q++;
  801510:	ff 4d 10             	decl   0x10(%ebp)
  801513:	ff 45 08             	incl   0x8(%ebp)
  801516:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801519:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80151d:	74 17                	je     801536 <strncmp+0x2b>
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8a 00                	mov    (%eax),%al
  801524:	84 c0                	test   %al,%al
  801526:	74 0e                	je     801536 <strncmp+0x2b>
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	8a 10                	mov    (%eax),%dl
  80152d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	38 c2                	cmp    %al,%dl
  801534:	74 da                	je     801510 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801536:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80153a:	75 07                	jne    801543 <strncmp+0x38>
		return 0;
  80153c:	b8 00 00 00 00       	mov    $0x0,%eax
  801541:	eb 14                	jmp    801557 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	0f b6 d0             	movzbl %al,%edx
  80154b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154e:	8a 00                	mov    (%eax),%al
  801550:	0f b6 c0             	movzbl %al,%eax
  801553:	29 c2                	sub    %eax,%edx
  801555:	89 d0                	mov    %edx,%eax
}
  801557:	5d                   	pop    %ebp
  801558:	c3                   	ret    

00801559 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	83 ec 04             	sub    $0x4,%esp
  80155f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801562:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801565:	eb 12                	jmp    801579 <strchr+0x20>
		if (*s == c)
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	8a 00                	mov    (%eax),%al
  80156c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80156f:	75 05                	jne    801576 <strchr+0x1d>
			return (char *) s;
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	eb 11                	jmp    801587 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801576:	ff 45 08             	incl   0x8(%ebp)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	84 c0                	test   %al,%al
  801580:	75 e5                	jne    801567 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801582:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 04             	sub    $0x4,%esp
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801595:	eb 0d                	jmp    8015a4 <strfind+0x1b>
		if (*s == c)
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80159f:	74 0e                	je     8015af <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015a1:	ff 45 08             	incl   0x8(%ebp)
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	8a 00                	mov    (%eax),%al
  8015a9:	84 c0                	test   %al,%al
  8015ab:	75 ea                	jne    801597 <strfind+0xe>
  8015ad:	eb 01                	jmp    8015b0 <strfind+0x27>
		if (*s == c)
			break;
  8015af:	90                   	nop
	return (char *) s;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015c7:	eb 0e                	jmp    8015d7 <memset+0x22>
		*p++ = c;
  8015c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015cc:	8d 50 01             	lea    0x1(%eax),%edx
  8015cf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015d7:	ff 4d f8             	decl   -0x8(%ebp)
  8015da:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015de:	79 e9                	jns    8015c9 <memset+0x14>
		*p++ = c;

	return v;
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8015f7:	eb 16                	jmp    80160f <memcpy+0x2a>
		*d++ = *s++;
  8015f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fc:	8d 50 01             	lea    0x1(%eax),%edx
  8015ff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801602:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801605:	8d 4a 01             	lea    0x1(%edx),%ecx
  801608:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80160b:	8a 12                	mov    (%edx),%dl
  80160d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80160f:	8b 45 10             	mov    0x10(%ebp),%eax
  801612:	8d 50 ff             	lea    -0x1(%eax),%edx
  801615:	89 55 10             	mov    %edx,0x10(%ebp)
  801618:	85 c0                	test   %eax,%eax
  80161a:	75 dd                	jne    8015f9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801633:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801636:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801639:	73 50                	jae    80168b <memmove+0x6a>
  80163b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80163e:	8b 45 10             	mov    0x10(%ebp),%eax
  801641:	01 d0                	add    %edx,%eax
  801643:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801646:	76 43                	jbe    80168b <memmove+0x6a>
		s += n;
  801648:	8b 45 10             	mov    0x10(%ebp),%eax
  80164b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80164e:	8b 45 10             	mov    0x10(%ebp),%eax
  801651:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801654:	eb 10                	jmp    801666 <memmove+0x45>
			*--d = *--s;
  801656:	ff 4d f8             	decl   -0x8(%ebp)
  801659:	ff 4d fc             	decl   -0x4(%ebp)
  80165c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80165f:	8a 10                	mov    (%eax),%dl
  801661:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801664:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801666:	8b 45 10             	mov    0x10(%ebp),%eax
  801669:	8d 50 ff             	lea    -0x1(%eax),%edx
  80166c:	89 55 10             	mov    %edx,0x10(%ebp)
  80166f:	85 c0                	test   %eax,%eax
  801671:	75 e3                	jne    801656 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801673:	eb 23                	jmp    801698 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801675:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801678:	8d 50 01             	lea    0x1(%eax),%edx
  80167b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80167e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801681:	8d 4a 01             	lea    0x1(%edx),%ecx
  801684:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801687:	8a 12                	mov    (%edx),%dl
  801689:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80168b:	8b 45 10             	mov    0x10(%ebp),%eax
  80168e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801691:	89 55 10             	mov    %edx,0x10(%ebp)
  801694:	85 c0                	test   %eax,%eax
  801696:	75 dd                	jne    801675 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ac:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016af:	eb 2a                	jmp    8016db <memcmp+0x3e>
		if (*s1 != *s2)
  8016b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016b4:	8a 10                	mov    (%eax),%dl
  8016b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b9:	8a 00                	mov    (%eax),%al
  8016bb:	38 c2                	cmp    %al,%dl
  8016bd:	74 16                	je     8016d5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c2:	8a 00                	mov    (%eax),%al
  8016c4:	0f b6 d0             	movzbl %al,%edx
  8016c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ca:	8a 00                	mov    (%eax),%al
  8016cc:	0f b6 c0             	movzbl %al,%eax
  8016cf:	29 c2                	sub    %eax,%edx
  8016d1:	89 d0                	mov    %edx,%eax
  8016d3:	eb 18                	jmp    8016ed <memcmp+0x50>
		s1++, s2++;
  8016d5:	ff 45 fc             	incl   -0x4(%ebp)
  8016d8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	75 c9                	jne    8016b1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fb:	01 d0                	add    %edx,%eax
  8016fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801700:	eb 15                	jmp    801717 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	0f b6 d0             	movzbl %al,%edx
  80170a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170d:	0f b6 c0             	movzbl %al,%eax
  801710:	39 c2                	cmp    %eax,%edx
  801712:	74 0d                	je     801721 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801714:	ff 45 08             	incl   0x8(%ebp)
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80171d:	72 e3                	jb     801702 <memfind+0x13>
  80171f:	eb 01                	jmp    801722 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801721:	90                   	nop
	return (void *) s;
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80172d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801734:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80173b:	eb 03                	jmp    801740 <strtol+0x19>
		s++;
  80173d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	8a 00                	mov    (%eax),%al
  801745:	3c 20                	cmp    $0x20,%al
  801747:	74 f4                	je     80173d <strtol+0x16>
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8a 00                	mov    (%eax),%al
  80174e:	3c 09                	cmp    $0x9,%al
  801750:	74 eb                	je     80173d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	3c 2b                	cmp    $0x2b,%al
  801759:	75 05                	jne    801760 <strtol+0x39>
		s++;
  80175b:	ff 45 08             	incl   0x8(%ebp)
  80175e:	eb 13                	jmp    801773 <strtol+0x4c>
	else if (*s == '-')
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	3c 2d                	cmp    $0x2d,%al
  801767:	75 0a                	jne    801773 <strtol+0x4c>
		s++, neg = 1;
  801769:	ff 45 08             	incl   0x8(%ebp)
  80176c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801773:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801777:	74 06                	je     80177f <strtol+0x58>
  801779:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80177d:	75 20                	jne    80179f <strtol+0x78>
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8a 00                	mov    (%eax),%al
  801784:	3c 30                	cmp    $0x30,%al
  801786:	75 17                	jne    80179f <strtol+0x78>
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	40                   	inc    %eax
  80178c:	8a 00                	mov    (%eax),%al
  80178e:	3c 78                	cmp    $0x78,%al
  801790:	75 0d                	jne    80179f <strtol+0x78>
		s += 2, base = 16;
  801792:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801796:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80179d:	eb 28                	jmp    8017c7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80179f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017a3:	75 15                	jne    8017ba <strtol+0x93>
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	8a 00                	mov    (%eax),%al
  8017aa:	3c 30                	cmp    $0x30,%al
  8017ac:	75 0c                	jne    8017ba <strtol+0x93>
		s++, base = 8;
  8017ae:	ff 45 08             	incl   0x8(%ebp)
  8017b1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017b8:	eb 0d                	jmp    8017c7 <strtol+0xa0>
	else if (base == 0)
  8017ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017be:	75 07                	jne    8017c7 <strtol+0xa0>
		base = 10;
  8017c0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ca:	8a 00                	mov    (%eax),%al
  8017cc:	3c 2f                	cmp    $0x2f,%al
  8017ce:	7e 19                	jle    8017e9 <strtol+0xc2>
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	8a 00                	mov    (%eax),%al
  8017d5:	3c 39                	cmp    $0x39,%al
  8017d7:	7f 10                	jg     8017e9 <strtol+0xc2>
			dig = *s - '0';
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8a 00                	mov    (%eax),%al
  8017de:	0f be c0             	movsbl %al,%eax
  8017e1:	83 e8 30             	sub    $0x30,%eax
  8017e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017e7:	eb 42                	jmp    80182b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	8a 00                	mov    (%eax),%al
  8017ee:	3c 60                	cmp    $0x60,%al
  8017f0:	7e 19                	jle    80180b <strtol+0xe4>
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	8a 00                	mov    (%eax),%al
  8017f7:	3c 7a                	cmp    $0x7a,%al
  8017f9:	7f 10                	jg     80180b <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8a 00                	mov    (%eax),%al
  801800:	0f be c0             	movsbl %al,%eax
  801803:	83 e8 57             	sub    $0x57,%eax
  801806:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801809:	eb 20                	jmp    80182b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	8a 00                	mov    (%eax),%al
  801810:	3c 40                	cmp    $0x40,%al
  801812:	7e 39                	jle    80184d <strtol+0x126>
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	8a 00                	mov    (%eax),%al
  801819:	3c 5a                	cmp    $0x5a,%al
  80181b:	7f 30                	jg     80184d <strtol+0x126>
			dig = *s - 'A' + 10;
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	8a 00                	mov    (%eax),%al
  801822:	0f be c0             	movsbl %al,%eax
  801825:	83 e8 37             	sub    $0x37,%eax
  801828:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80182b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801831:	7d 19                	jge    80184c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801833:	ff 45 08             	incl   0x8(%ebp)
  801836:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801839:	0f af 45 10          	imul   0x10(%ebp),%eax
  80183d:	89 c2                	mov    %eax,%edx
  80183f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801842:	01 d0                	add    %edx,%eax
  801844:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801847:	e9 7b ff ff ff       	jmp    8017c7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80184c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80184d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801851:	74 08                	je     80185b <strtol+0x134>
		*endptr = (char *) s;
  801853:	8b 45 0c             	mov    0xc(%ebp),%eax
  801856:	8b 55 08             	mov    0x8(%ebp),%edx
  801859:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80185b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80185f:	74 07                	je     801868 <strtol+0x141>
  801861:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801864:	f7 d8                	neg    %eax
  801866:	eb 03                	jmp    80186b <strtol+0x144>
  801868:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <ltostr>:

void
ltostr(long value, char *str)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801873:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80187a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801881:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801885:	79 13                	jns    80189a <ltostr+0x2d>
	{
		neg = 1;
  801887:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80188e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801891:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801894:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801897:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018a2:	99                   	cltd   
  8018a3:	f7 f9                	idiv   %ecx
  8018a5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ab:	8d 50 01             	lea    0x1(%eax),%edx
  8018ae:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018b1:	89 c2                	mov    %eax,%edx
  8018b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b6:	01 d0                	add    %edx,%eax
  8018b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018bb:	83 c2 30             	add    $0x30,%edx
  8018be:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018c8:	f7 e9                	imul   %ecx
  8018ca:	c1 fa 02             	sar    $0x2,%edx
  8018cd:	89 c8                	mov    %ecx,%eax
  8018cf:	c1 f8 1f             	sar    $0x1f,%eax
  8018d2:	29 c2                	sub    %eax,%edx
  8018d4:	89 d0                	mov    %edx,%eax
  8018d6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018dd:	75 bb                	jne    80189a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e9:	48                   	dec    %eax
  8018ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018f1:	74 3d                	je     801930 <ltostr+0xc3>
		start = 1 ;
  8018f3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018fa:	eb 34                	jmp    801930 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	01 d0                	add    %edx,%eax
  801904:	8a 00                	mov    (%eax),%al
  801906:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801909:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80190c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190f:	01 c2                	add    %eax,%edx
  801911:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801914:	8b 45 0c             	mov    0xc(%ebp),%eax
  801917:	01 c8                	add    %ecx,%eax
  801919:	8a 00                	mov    (%eax),%al
  80191b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80191d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801920:	8b 45 0c             	mov    0xc(%ebp),%eax
  801923:	01 c2                	add    %eax,%edx
  801925:	8a 45 eb             	mov    -0x15(%ebp),%al
  801928:	88 02                	mov    %al,(%edx)
		start++ ;
  80192a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80192d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801933:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801936:	7c c4                	jl     8018fc <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801938:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80193b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193e:	01 d0                	add    %edx,%eax
  801940:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801943:	90                   	nop
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80194c:	ff 75 08             	pushl  0x8(%ebp)
  80194f:	e8 73 fa ff ff       	call   8013c7 <strlen>
  801954:	83 c4 04             	add    $0x4,%esp
  801957:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80195a:	ff 75 0c             	pushl  0xc(%ebp)
  80195d:	e8 65 fa ff ff       	call   8013c7 <strlen>
  801962:	83 c4 04             	add    $0x4,%esp
  801965:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801968:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80196f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801976:	eb 17                	jmp    80198f <strcconcat+0x49>
		final[s] = str1[s] ;
  801978:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80197b:	8b 45 10             	mov    0x10(%ebp),%eax
  80197e:	01 c2                	add    %eax,%edx
  801980:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	01 c8                	add    %ecx,%eax
  801988:	8a 00                	mov    (%eax),%al
  80198a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80198c:	ff 45 fc             	incl   -0x4(%ebp)
  80198f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801992:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801995:	7c e1                	jl     801978 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801997:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80199e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019a5:	eb 1f                	jmp    8019c6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019aa:	8d 50 01             	lea    0x1(%eax),%edx
  8019ad:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019b0:	89 c2                	mov    %eax,%edx
  8019b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b5:	01 c2                	add    %eax,%edx
  8019b7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bd:	01 c8                	add    %ecx,%eax
  8019bf:	8a 00                	mov    (%eax),%al
  8019c1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019c3:	ff 45 f8             	incl   -0x8(%ebp)
  8019c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019cc:	7c d9                	jl     8019a7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d4:	01 d0                	add    %edx,%eax
  8019d6:	c6 00 00             	movb   $0x0,(%eax)
}
  8019d9:	90                   	nop
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019df:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019eb:	8b 00                	mov    (%eax),%eax
  8019ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f7:	01 d0                	add    %edx,%eax
  8019f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019ff:	eb 0c                	jmp    801a0d <strsplit+0x31>
			*string++ = 0;
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8d 50 01             	lea    0x1(%eax),%edx
  801a07:	89 55 08             	mov    %edx,0x8(%ebp)
  801a0a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	8a 00                	mov    (%eax),%al
  801a12:	84 c0                	test   %al,%al
  801a14:	74 18                	je     801a2e <strsplit+0x52>
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8a 00                	mov    (%eax),%al
  801a1b:	0f be c0             	movsbl %al,%eax
  801a1e:	50                   	push   %eax
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	e8 32 fb ff ff       	call   801559 <strchr>
  801a27:	83 c4 08             	add    $0x8,%esp
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	75 d3                	jne    801a01 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	8a 00                	mov    (%eax),%al
  801a33:	84 c0                	test   %al,%al
  801a35:	74 5a                	je     801a91 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a37:	8b 45 14             	mov    0x14(%ebp),%eax
  801a3a:	8b 00                	mov    (%eax),%eax
  801a3c:	83 f8 0f             	cmp    $0xf,%eax
  801a3f:	75 07                	jne    801a48 <strsplit+0x6c>
		{
			return 0;
  801a41:	b8 00 00 00 00       	mov    $0x0,%eax
  801a46:	eb 66                	jmp    801aae <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a48:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4b:	8b 00                	mov    (%eax),%eax
  801a4d:	8d 48 01             	lea    0x1(%eax),%ecx
  801a50:	8b 55 14             	mov    0x14(%ebp),%edx
  801a53:	89 0a                	mov    %ecx,(%edx)
  801a55:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5f:	01 c2                	add    %eax,%edx
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a66:	eb 03                	jmp    801a6b <strsplit+0x8f>
			string++;
  801a68:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	8a 00                	mov    (%eax),%al
  801a70:	84 c0                	test   %al,%al
  801a72:	74 8b                	je     8019ff <strsplit+0x23>
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	8a 00                	mov    (%eax),%al
  801a79:	0f be c0             	movsbl %al,%eax
  801a7c:	50                   	push   %eax
  801a7d:	ff 75 0c             	pushl  0xc(%ebp)
  801a80:	e8 d4 fa ff ff       	call   801559 <strchr>
  801a85:	83 c4 08             	add    $0x8,%esp
  801a88:	85 c0                	test   %eax,%eax
  801a8a:	74 dc                	je     801a68 <strsplit+0x8c>
			string++;
	}
  801a8c:	e9 6e ff ff ff       	jmp    8019ff <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a91:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a92:	8b 45 14             	mov    0x14(%ebp),%eax
  801a95:	8b 00                	mov    (%eax),%eax
  801a97:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa1:	01 d0                	add    %edx,%eax
  801aa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801aa9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801ab6:	83 ec 04             	sub    $0x4,%esp
  801ab9:	68 3c 2c 80 00       	push   $0x802c3c
  801abe:	68 3f 01 00 00       	push   $0x13f
  801ac3:	68 5e 2c 80 00       	push   $0x802c5e
  801ac8:	e8 a1 ed ff ff       	call   80086e <_panic>

00801acd <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801ad3:	83 ec 0c             	sub    $0xc,%esp
  801ad6:	ff 75 08             	pushl  0x8(%ebp)
  801ad9:	e8 ef 06 00 00       	call   8021cd <sys_sbrk>
  801ade:	83 c4 10             	add    $0x10,%esp
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801ae9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801aed:	75 07                	jne    801af6 <malloc+0x13>
  801aef:	b8 00 00 00 00       	mov    $0x0,%eax
  801af4:	eb 14                	jmp    801b0a <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801af6:	83 ec 04             	sub    $0x4,%esp
  801af9:	68 6c 2c 80 00       	push   $0x802c6c
  801afe:	6a 1b                	push   $0x1b
  801b00:	68 91 2c 80 00       	push   $0x802c91
  801b05:	e8 64 ed ff ff       	call   80086e <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801b12:	83 ec 04             	sub    $0x4,%esp
  801b15:	68 a0 2c 80 00       	push   $0x802ca0
  801b1a:	6a 29                	push   $0x29
  801b1c:	68 91 2c 80 00       	push   $0x802c91
  801b21:	e8 48 ed ff ff       	call   80086e <_panic>

00801b26 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 18             	sub    $0x18,%esp
  801b2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b36:	75 07                	jne    801b3f <smalloc+0x19>
  801b38:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3d:	eb 14                	jmp    801b53 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801b3f:	83 ec 04             	sub    $0x4,%esp
  801b42:	68 c4 2c 80 00       	push   $0x802cc4
  801b47:	6a 38                	push   $0x38
  801b49:	68 91 2c 80 00       	push   $0x802c91
  801b4e:	e8 1b ed ff ff       	call   80086e <_panic>
	return NULL;
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801b5b:	83 ec 04             	sub    $0x4,%esp
  801b5e:	68 ec 2c 80 00       	push   $0x802cec
  801b63:	6a 43                	push   $0x43
  801b65:	68 91 2c 80 00       	push   $0x802c91
  801b6a:	e8 ff ec ff ff       	call   80086e <_panic>

00801b6f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b75:	83 ec 04             	sub    $0x4,%esp
  801b78:	68 10 2d 80 00       	push   $0x802d10
  801b7d:	6a 5b                	push   $0x5b
  801b7f:	68 91 2c 80 00       	push   $0x802c91
  801b84:	e8 e5 ec ff ff       	call   80086e <_panic>

00801b89 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b8f:	83 ec 04             	sub    $0x4,%esp
  801b92:	68 34 2d 80 00       	push   $0x802d34
  801b97:	6a 72                	push   $0x72
  801b99:	68 91 2c 80 00       	push   $0x802c91
  801b9e:	e8 cb ec ff ff       	call   80086e <_panic>

00801ba3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ba9:	83 ec 04             	sub    $0x4,%esp
  801bac:	68 5a 2d 80 00       	push   $0x802d5a
  801bb1:	6a 7e                	push   $0x7e
  801bb3:	68 91 2c 80 00       	push   $0x802c91
  801bb8:	e8 b1 ec ff ff       	call   80086e <_panic>

00801bbd <shrink>:

}
void shrink(uint32 newSize)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bc3:	83 ec 04             	sub    $0x4,%esp
  801bc6:	68 5a 2d 80 00       	push   $0x802d5a
  801bcb:	68 83 00 00 00       	push   $0x83
  801bd0:	68 91 2c 80 00       	push   $0x802c91
  801bd5:	e8 94 ec ff ff       	call   80086e <_panic>

00801bda <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801be0:	83 ec 04             	sub    $0x4,%esp
  801be3:	68 5a 2d 80 00       	push   $0x802d5a
  801be8:	68 88 00 00 00       	push   $0x88
  801bed:	68 91 2c 80 00       	push   $0x802c91
  801bf2:	e8 77 ec ff ff       	call   80086e <_panic>

00801bf7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	57                   	push   %edi
  801bfb:	56                   	push   %esi
  801bfc:	53                   	push   %ebx
  801bfd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c06:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c09:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c0c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c0f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c12:	cd 30                	int    $0x30
  801c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c1a:	83 c4 10             	add    $0x10,%esp
  801c1d:	5b                   	pop    %ebx
  801c1e:	5e                   	pop    %esi
  801c1f:	5f                   	pop    %edi
  801c20:	5d                   	pop    %ebp
  801c21:	c3                   	ret    

00801c22 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 04             	sub    $0x4,%esp
  801c28:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c2e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	52                   	push   %edx
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	50                   	push   %eax
  801c3e:	6a 00                	push   $0x0
  801c40:	e8 b2 ff ff ff       	call   801bf7 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	90                   	nop
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_cgetc>:

int
sys_cgetc(void)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 02                	push   $0x2
  801c5a:	e8 98 ff ff ff       	call   801bf7 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 03                	push   $0x3
  801c73:	e8 7f ff ff ff       	call   801bf7 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	90                   	nop
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 04                	push   $0x4
  801c8d:	e8 65 ff ff ff       	call   801bf7 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	90                   	nop
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	52                   	push   %edx
  801ca8:	50                   	push   %eax
  801ca9:	6a 08                	push   $0x8
  801cab:	e8 47 ff ff ff       	call   801bf7 <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	56                   	push   %esi
  801cb9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cba:	8b 75 18             	mov    0x18(%ebp),%esi
  801cbd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cc0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	56                   	push   %esi
  801cca:	53                   	push   %ebx
  801ccb:	51                   	push   %ecx
  801ccc:	52                   	push   %edx
  801ccd:	50                   	push   %eax
  801cce:	6a 09                	push   $0x9
  801cd0:	e8 22 ff ff ff       	call   801bf7 <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cdb:	5b                   	pop    %ebx
  801cdc:	5e                   	pop    %esi
  801cdd:	5d                   	pop    %ebp
  801cde:	c3                   	ret    

00801cdf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	52                   	push   %edx
  801cef:	50                   	push   %eax
  801cf0:	6a 0a                	push   $0xa
  801cf2:	e8 00 ff ff ff       	call   801bf7 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	ff 75 0c             	pushl  0xc(%ebp)
  801d08:	ff 75 08             	pushl  0x8(%ebp)
  801d0b:	6a 0b                	push   $0xb
  801d0d:	e8 e5 fe ff ff       	call   801bf7 <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 0c                	push   $0xc
  801d26:	e8 cc fe ff ff       	call   801bf7 <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 0d                	push   $0xd
  801d3f:	e8 b3 fe ff ff       	call   801bf7 <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 0e                	push   $0xe
  801d58:	e8 9a fe ff ff       	call   801bf7 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 0f                	push   $0xf
  801d71:	e8 81 fe ff ff       	call   801bf7 <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	ff 75 08             	pushl  0x8(%ebp)
  801d89:	6a 10                	push   $0x10
  801d8b:	e8 67 fe ff ff       	call   801bf7 <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 11                	push   $0x11
  801da4:	e8 4e fe ff ff       	call   801bf7 <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
}
  801dac:	90                   	nop
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_cputc>:

void
sys_cputc(const char c)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	83 ec 04             	sub    $0x4,%esp
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801dbb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	50                   	push   %eax
  801dc8:	6a 01                	push   $0x1
  801dca:	e8 28 fe ff ff       	call   801bf7 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
}
  801dd2:	90                   	nop
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 14                	push   $0x14
  801de4:	e8 0e fe ff ff       	call   801bf7 <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
}
  801dec:	90                   	nop
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 04             	sub    $0x4,%esp
  801df5:	8b 45 10             	mov    0x10(%ebp),%eax
  801df8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dfb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dfe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e02:	8b 45 08             	mov    0x8(%ebp),%eax
  801e05:	6a 00                	push   $0x0
  801e07:	51                   	push   %ecx
  801e08:	52                   	push   %edx
  801e09:	ff 75 0c             	pushl  0xc(%ebp)
  801e0c:	50                   	push   %eax
  801e0d:	6a 15                	push   $0x15
  801e0f:	e8 e3 fd ff ff       	call   801bf7 <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	52                   	push   %edx
  801e29:	50                   	push   %eax
  801e2a:	6a 16                	push   $0x16
  801e2c:	e8 c6 fd ff ff       	call   801bf7 <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	51                   	push   %ecx
  801e47:	52                   	push   %edx
  801e48:	50                   	push   %eax
  801e49:	6a 17                	push   $0x17
  801e4b:	e8 a7 fd ff ff       	call   801bf7 <syscall>
  801e50:	83 c4 18             	add    $0x18,%esp
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	52                   	push   %edx
  801e65:	50                   	push   %eax
  801e66:	6a 18                	push   $0x18
  801e68:	e8 8a fd ff ff       	call   801bf7 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	6a 00                	push   $0x0
  801e7a:	ff 75 14             	pushl  0x14(%ebp)
  801e7d:	ff 75 10             	pushl  0x10(%ebp)
  801e80:	ff 75 0c             	pushl  0xc(%ebp)
  801e83:	50                   	push   %eax
  801e84:	6a 19                	push   $0x19
  801e86:	e8 6c fd ff ff       	call   801bf7 <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	50                   	push   %eax
  801e9f:	6a 1a                	push   $0x1a
  801ea1:	e8 51 fd ff ff       	call   801bf7 <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
}
  801ea9:	90                   	nop
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	50                   	push   %eax
  801ebb:	6a 1b                	push   $0x1b
  801ebd:	e8 35 fd ff ff       	call   801bf7 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 05                	push   $0x5
  801ed6:	e8 1c fd ff ff       	call   801bf7 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 06                	push   $0x6
  801eef:	e8 03 fd ff ff       	call   801bf7 <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 07                	push   $0x7
  801f08:	e8 ea fc ff ff       	call   801bf7 <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_exit_env>:


void sys_exit_env(void)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 1c                	push   $0x1c
  801f21:	e8 d1 fc ff ff       	call   801bf7 <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
}
  801f29:	90                   	nop
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f32:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f35:	8d 50 04             	lea    0x4(%eax),%edx
  801f38:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	52                   	push   %edx
  801f42:	50                   	push   %eax
  801f43:	6a 1d                	push   $0x1d
  801f45:	e8 ad fc ff ff       	call   801bf7 <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
	return result;
  801f4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f56:	89 01                	mov    %eax,(%ecx)
  801f58:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	c9                   	leave  
  801f5f:	c2 04 00             	ret    $0x4

00801f62 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	ff 75 10             	pushl  0x10(%ebp)
  801f6c:	ff 75 0c             	pushl  0xc(%ebp)
  801f6f:	ff 75 08             	pushl  0x8(%ebp)
  801f72:	6a 13                	push   $0x13
  801f74:	e8 7e fc ff ff       	call   801bf7 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7c:	90                   	nop
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <sys_rcr2>:
uint32 sys_rcr2()
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 1e                	push   $0x1e
  801f8e:	e8 64 fc ff ff       	call   801bf7 <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 04             	sub    $0x4,%esp
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fa4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	50                   	push   %eax
  801fb1:	6a 1f                	push   $0x1f
  801fb3:	e8 3f fc ff ff       	call   801bf7 <syscall>
  801fb8:	83 c4 18             	add    $0x18,%esp
	return ;
  801fbb:	90                   	nop
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <rsttst>:
void rsttst()
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 21                	push   $0x21
  801fcd:	e8 25 fc ff ff       	call   801bf7 <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd5:	90                   	nop
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 04             	sub    $0x4,%esp
  801fde:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fe4:	8b 55 18             	mov    0x18(%ebp),%edx
  801fe7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801feb:	52                   	push   %edx
  801fec:	50                   	push   %eax
  801fed:	ff 75 10             	pushl  0x10(%ebp)
  801ff0:	ff 75 0c             	pushl  0xc(%ebp)
  801ff3:	ff 75 08             	pushl  0x8(%ebp)
  801ff6:	6a 20                	push   $0x20
  801ff8:	e8 fa fb ff ff       	call   801bf7 <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
	return ;
  802000:	90                   	nop
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <chktst>:
void chktst(uint32 n)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	ff 75 08             	pushl  0x8(%ebp)
  802011:	6a 22                	push   $0x22
  802013:	e8 df fb ff ff       	call   801bf7 <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
	return ;
  80201b:	90                   	nop
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <inctst>:

void inctst()
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 23                	push   $0x23
  80202d:	e8 c5 fb ff ff       	call   801bf7 <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
	return ;
  802035:	90                   	nop
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <gettst>:
uint32 gettst()
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 24                	push   $0x24
  802047:	e8 ab fb ff ff       	call   801bf7 <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 25                	push   $0x25
  802063:	e8 8f fb ff ff       	call   801bf7 <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
  80206b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80206e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802072:	75 07                	jne    80207b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802074:	b8 01 00 00 00       	mov    $0x1,%eax
  802079:	eb 05                	jmp    802080 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80207b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 25                	push   $0x25
  802094:	e8 5e fb ff ff       	call   801bf7 <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
  80209c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80209f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020a3:	75 07                	jne    8020ac <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8020aa:	eb 05                	jmp    8020b1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 25                	push   $0x25
  8020c5:	e8 2d fb ff ff       	call   801bf7 <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
  8020cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020d0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020d4:	75 07                	jne    8020dd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020db:	eb 05                	jmp    8020e2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 25                	push   $0x25
  8020f6:	e8 fc fa ff ff       	call   801bf7 <syscall>
  8020fb:	83 c4 18             	add    $0x18,%esp
  8020fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802101:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802105:	75 07                	jne    80210e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802107:	b8 01 00 00 00       	mov    $0x1,%eax
  80210c:	eb 05                	jmp    802113 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80210e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	ff 75 08             	pushl  0x8(%ebp)
  802123:	6a 26                	push   $0x26
  802125:	e8 cd fa ff ff       	call   801bf7 <syscall>
  80212a:	83 c4 18             	add    $0x18,%esp
	return ;
  80212d:	90                   	nop
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802134:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802137:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80213a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	6a 00                	push   $0x0
  802142:	53                   	push   %ebx
  802143:	51                   	push   %ecx
  802144:	52                   	push   %edx
  802145:	50                   	push   %eax
  802146:	6a 27                	push   $0x27
  802148:	e8 aa fa ff ff       	call   801bf7 <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
}
  802150:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802158:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	52                   	push   %edx
  802165:	50                   	push   %eax
  802166:	6a 28                	push   $0x28
  802168:	e8 8a fa ff ff       	call   801bf7 <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802175:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802178:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	6a 00                	push   $0x0
  802180:	51                   	push   %ecx
  802181:	ff 75 10             	pushl  0x10(%ebp)
  802184:	52                   	push   %edx
  802185:	50                   	push   %eax
  802186:	6a 29                	push   $0x29
  802188:	e8 6a fa ff ff       	call   801bf7 <syscall>
  80218d:	83 c4 18             	add    $0x18,%esp
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	ff 75 10             	pushl  0x10(%ebp)
  80219c:	ff 75 0c             	pushl  0xc(%ebp)
  80219f:	ff 75 08             	pushl  0x8(%ebp)
  8021a2:	6a 12                	push   $0x12
  8021a4:	e8 4e fa ff ff       	call   801bf7 <syscall>
  8021a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ac:	90                   	nop
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8021b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	52                   	push   %edx
  8021bf:	50                   	push   %eax
  8021c0:	6a 2a                	push   $0x2a
  8021c2:	e8 30 fa ff ff       	call   801bf7 <syscall>
  8021c7:	83 c4 18             	add    $0x18,%esp
	return;
  8021ca:	90                   	nop
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	50                   	push   %eax
  8021dc:	6a 2b                	push   $0x2b
  8021de:	e8 14 fa ff ff       	call   801bf7 <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	ff 75 0c             	pushl  0xc(%ebp)
  8021f4:	ff 75 08             	pushl  0x8(%ebp)
  8021f7:	6a 2c                	push   $0x2c
  8021f9:	e8 f9 f9 ff ff       	call   801bf7 <syscall>
  8021fe:	83 c4 18             	add    $0x18,%esp
	return;
  802201:	90                   	nop
}
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	ff 75 0c             	pushl  0xc(%ebp)
  802210:	ff 75 08             	pushl  0x8(%ebp)
  802213:	6a 2d                	push   $0x2d
  802215:	e8 dd f9 ff ff       	call   801bf7 <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
	return;
  80221d:	90                   	nop
}
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <__udivdi3>:
  802220:	55                   	push   %ebp
  802221:	57                   	push   %edi
  802222:	56                   	push   %esi
  802223:	53                   	push   %ebx
  802224:	83 ec 1c             	sub    $0x1c,%esp
  802227:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80222b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80222f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802233:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802237:	89 ca                	mov    %ecx,%edx
  802239:	89 f8                	mov    %edi,%eax
  80223b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80223f:	85 f6                	test   %esi,%esi
  802241:	75 2d                	jne    802270 <__udivdi3+0x50>
  802243:	39 cf                	cmp    %ecx,%edi
  802245:	77 65                	ja     8022ac <__udivdi3+0x8c>
  802247:	89 fd                	mov    %edi,%ebp
  802249:	85 ff                	test   %edi,%edi
  80224b:	75 0b                	jne    802258 <__udivdi3+0x38>
  80224d:	b8 01 00 00 00       	mov    $0x1,%eax
  802252:	31 d2                	xor    %edx,%edx
  802254:	f7 f7                	div    %edi
  802256:	89 c5                	mov    %eax,%ebp
  802258:	31 d2                	xor    %edx,%edx
  80225a:	89 c8                	mov    %ecx,%eax
  80225c:	f7 f5                	div    %ebp
  80225e:	89 c1                	mov    %eax,%ecx
  802260:	89 d8                	mov    %ebx,%eax
  802262:	f7 f5                	div    %ebp
  802264:	89 cf                	mov    %ecx,%edi
  802266:	89 fa                	mov    %edi,%edx
  802268:	83 c4 1c             	add    $0x1c,%esp
  80226b:	5b                   	pop    %ebx
  80226c:	5e                   	pop    %esi
  80226d:	5f                   	pop    %edi
  80226e:	5d                   	pop    %ebp
  80226f:	c3                   	ret    
  802270:	39 ce                	cmp    %ecx,%esi
  802272:	77 28                	ja     80229c <__udivdi3+0x7c>
  802274:	0f bd fe             	bsr    %esi,%edi
  802277:	83 f7 1f             	xor    $0x1f,%edi
  80227a:	75 40                	jne    8022bc <__udivdi3+0x9c>
  80227c:	39 ce                	cmp    %ecx,%esi
  80227e:	72 0a                	jb     80228a <__udivdi3+0x6a>
  802280:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802284:	0f 87 9e 00 00 00    	ja     802328 <__udivdi3+0x108>
  80228a:	b8 01 00 00 00       	mov    $0x1,%eax
  80228f:	89 fa                	mov    %edi,%edx
  802291:	83 c4 1c             	add    $0x1c,%esp
  802294:	5b                   	pop    %ebx
  802295:	5e                   	pop    %esi
  802296:	5f                   	pop    %edi
  802297:	5d                   	pop    %ebp
  802298:	c3                   	ret    
  802299:	8d 76 00             	lea    0x0(%esi),%esi
  80229c:	31 ff                	xor    %edi,%edi
  80229e:	31 c0                	xor    %eax,%eax
  8022a0:	89 fa                	mov    %edi,%edx
  8022a2:	83 c4 1c             	add    $0x1c,%esp
  8022a5:	5b                   	pop    %ebx
  8022a6:	5e                   	pop    %esi
  8022a7:	5f                   	pop    %edi
  8022a8:	5d                   	pop    %ebp
  8022a9:	c3                   	ret    
  8022aa:	66 90                	xchg   %ax,%ax
  8022ac:	89 d8                	mov    %ebx,%eax
  8022ae:	f7 f7                	div    %edi
  8022b0:	31 ff                	xor    %edi,%edi
  8022b2:	89 fa                	mov    %edi,%edx
  8022b4:	83 c4 1c             	add    $0x1c,%esp
  8022b7:	5b                   	pop    %ebx
  8022b8:	5e                   	pop    %esi
  8022b9:	5f                   	pop    %edi
  8022ba:	5d                   	pop    %ebp
  8022bb:	c3                   	ret    
  8022bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8022c1:	89 eb                	mov    %ebp,%ebx
  8022c3:	29 fb                	sub    %edi,%ebx
  8022c5:	89 f9                	mov    %edi,%ecx
  8022c7:	d3 e6                	shl    %cl,%esi
  8022c9:	89 c5                	mov    %eax,%ebp
  8022cb:	88 d9                	mov    %bl,%cl
  8022cd:	d3 ed                	shr    %cl,%ebp
  8022cf:	89 e9                	mov    %ebp,%ecx
  8022d1:	09 f1                	or     %esi,%ecx
  8022d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8022d7:	89 f9                	mov    %edi,%ecx
  8022d9:	d3 e0                	shl    %cl,%eax
  8022db:	89 c5                	mov    %eax,%ebp
  8022dd:	89 d6                	mov    %edx,%esi
  8022df:	88 d9                	mov    %bl,%cl
  8022e1:	d3 ee                	shr    %cl,%esi
  8022e3:	89 f9                	mov    %edi,%ecx
  8022e5:	d3 e2                	shl    %cl,%edx
  8022e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022eb:	88 d9                	mov    %bl,%cl
  8022ed:	d3 e8                	shr    %cl,%eax
  8022ef:	09 c2                	or     %eax,%edx
  8022f1:	89 d0                	mov    %edx,%eax
  8022f3:	89 f2                	mov    %esi,%edx
  8022f5:	f7 74 24 0c          	divl   0xc(%esp)
  8022f9:	89 d6                	mov    %edx,%esi
  8022fb:	89 c3                	mov    %eax,%ebx
  8022fd:	f7 e5                	mul    %ebp
  8022ff:	39 d6                	cmp    %edx,%esi
  802301:	72 19                	jb     80231c <__udivdi3+0xfc>
  802303:	74 0b                	je     802310 <__udivdi3+0xf0>
  802305:	89 d8                	mov    %ebx,%eax
  802307:	31 ff                	xor    %edi,%edi
  802309:	e9 58 ff ff ff       	jmp    802266 <__udivdi3+0x46>
  80230e:	66 90                	xchg   %ax,%ax
  802310:	8b 54 24 08          	mov    0x8(%esp),%edx
  802314:	89 f9                	mov    %edi,%ecx
  802316:	d3 e2                	shl    %cl,%edx
  802318:	39 c2                	cmp    %eax,%edx
  80231a:	73 e9                	jae    802305 <__udivdi3+0xe5>
  80231c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80231f:	31 ff                	xor    %edi,%edi
  802321:	e9 40 ff ff ff       	jmp    802266 <__udivdi3+0x46>
  802326:	66 90                	xchg   %ax,%ax
  802328:	31 c0                	xor    %eax,%eax
  80232a:	e9 37 ff ff ff       	jmp    802266 <__udivdi3+0x46>
  80232f:	90                   	nop

00802330 <__umoddi3>:
  802330:	55                   	push   %ebp
  802331:	57                   	push   %edi
  802332:	56                   	push   %esi
  802333:	53                   	push   %ebx
  802334:	83 ec 1c             	sub    $0x1c,%esp
  802337:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80233b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80233f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802343:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802347:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80234b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80234f:	89 f3                	mov    %esi,%ebx
  802351:	89 fa                	mov    %edi,%edx
  802353:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802357:	89 34 24             	mov    %esi,(%esp)
  80235a:	85 c0                	test   %eax,%eax
  80235c:	75 1a                	jne    802378 <__umoddi3+0x48>
  80235e:	39 f7                	cmp    %esi,%edi
  802360:	0f 86 a2 00 00 00    	jbe    802408 <__umoddi3+0xd8>
  802366:	89 c8                	mov    %ecx,%eax
  802368:	89 f2                	mov    %esi,%edx
  80236a:	f7 f7                	div    %edi
  80236c:	89 d0                	mov    %edx,%eax
  80236e:	31 d2                	xor    %edx,%edx
  802370:	83 c4 1c             	add    $0x1c,%esp
  802373:	5b                   	pop    %ebx
  802374:	5e                   	pop    %esi
  802375:	5f                   	pop    %edi
  802376:	5d                   	pop    %ebp
  802377:	c3                   	ret    
  802378:	39 f0                	cmp    %esi,%eax
  80237a:	0f 87 ac 00 00 00    	ja     80242c <__umoddi3+0xfc>
  802380:	0f bd e8             	bsr    %eax,%ebp
  802383:	83 f5 1f             	xor    $0x1f,%ebp
  802386:	0f 84 ac 00 00 00    	je     802438 <__umoddi3+0x108>
  80238c:	bf 20 00 00 00       	mov    $0x20,%edi
  802391:	29 ef                	sub    %ebp,%edi
  802393:	89 fe                	mov    %edi,%esi
  802395:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802399:	89 e9                	mov    %ebp,%ecx
  80239b:	d3 e0                	shl    %cl,%eax
  80239d:	89 d7                	mov    %edx,%edi
  80239f:	89 f1                	mov    %esi,%ecx
  8023a1:	d3 ef                	shr    %cl,%edi
  8023a3:	09 c7                	or     %eax,%edi
  8023a5:	89 e9                	mov    %ebp,%ecx
  8023a7:	d3 e2                	shl    %cl,%edx
  8023a9:	89 14 24             	mov    %edx,(%esp)
  8023ac:	89 d8                	mov    %ebx,%eax
  8023ae:	d3 e0                	shl    %cl,%eax
  8023b0:	89 c2                	mov    %eax,%edx
  8023b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023b6:	d3 e0                	shl    %cl,%eax
  8023b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023c0:	89 f1                	mov    %esi,%ecx
  8023c2:	d3 e8                	shr    %cl,%eax
  8023c4:	09 d0                	or     %edx,%eax
  8023c6:	d3 eb                	shr    %cl,%ebx
  8023c8:	89 da                	mov    %ebx,%edx
  8023ca:	f7 f7                	div    %edi
  8023cc:	89 d3                	mov    %edx,%ebx
  8023ce:	f7 24 24             	mull   (%esp)
  8023d1:	89 c6                	mov    %eax,%esi
  8023d3:	89 d1                	mov    %edx,%ecx
  8023d5:	39 d3                	cmp    %edx,%ebx
  8023d7:	0f 82 87 00 00 00    	jb     802464 <__umoddi3+0x134>
  8023dd:	0f 84 91 00 00 00    	je     802474 <__umoddi3+0x144>
  8023e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023e7:	29 f2                	sub    %esi,%edx
  8023e9:	19 cb                	sbb    %ecx,%ebx
  8023eb:	89 d8                	mov    %ebx,%eax
  8023ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8023f1:	d3 e0                	shl    %cl,%eax
  8023f3:	89 e9                	mov    %ebp,%ecx
  8023f5:	d3 ea                	shr    %cl,%edx
  8023f7:	09 d0                	or     %edx,%eax
  8023f9:	89 e9                	mov    %ebp,%ecx
  8023fb:	d3 eb                	shr    %cl,%ebx
  8023fd:	89 da                	mov    %ebx,%edx
  8023ff:	83 c4 1c             	add    $0x1c,%esp
  802402:	5b                   	pop    %ebx
  802403:	5e                   	pop    %esi
  802404:	5f                   	pop    %edi
  802405:	5d                   	pop    %ebp
  802406:	c3                   	ret    
  802407:	90                   	nop
  802408:	89 fd                	mov    %edi,%ebp
  80240a:	85 ff                	test   %edi,%edi
  80240c:	75 0b                	jne    802419 <__umoddi3+0xe9>
  80240e:	b8 01 00 00 00       	mov    $0x1,%eax
  802413:	31 d2                	xor    %edx,%edx
  802415:	f7 f7                	div    %edi
  802417:	89 c5                	mov    %eax,%ebp
  802419:	89 f0                	mov    %esi,%eax
  80241b:	31 d2                	xor    %edx,%edx
  80241d:	f7 f5                	div    %ebp
  80241f:	89 c8                	mov    %ecx,%eax
  802421:	f7 f5                	div    %ebp
  802423:	89 d0                	mov    %edx,%eax
  802425:	e9 44 ff ff ff       	jmp    80236e <__umoddi3+0x3e>
  80242a:	66 90                	xchg   %ax,%ax
  80242c:	89 c8                	mov    %ecx,%eax
  80242e:	89 f2                	mov    %esi,%edx
  802430:	83 c4 1c             	add    $0x1c,%esp
  802433:	5b                   	pop    %ebx
  802434:	5e                   	pop    %esi
  802435:	5f                   	pop    %edi
  802436:	5d                   	pop    %ebp
  802437:	c3                   	ret    
  802438:	3b 04 24             	cmp    (%esp),%eax
  80243b:	72 06                	jb     802443 <__umoddi3+0x113>
  80243d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802441:	77 0f                	ja     802452 <__umoddi3+0x122>
  802443:	89 f2                	mov    %esi,%edx
  802445:	29 f9                	sub    %edi,%ecx
  802447:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80244b:	89 14 24             	mov    %edx,(%esp)
  80244e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802452:	8b 44 24 04          	mov    0x4(%esp),%eax
  802456:	8b 14 24             	mov    (%esp),%edx
  802459:	83 c4 1c             	add    $0x1c,%esp
  80245c:	5b                   	pop    %ebx
  80245d:	5e                   	pop    %esi
  80245e:	5f                   	pop    %edi
  80245f:	5d                   	pop    %ebp
  802460:	c3                   	ret    
  802461:	8d 76 00             	lea    0x0(%esi),%esi
  802464:	2b 04 24             	sub    (%esp),%eax
  802467:	19 fa                	sbb    %edi,%edx
  802469:	89 d1                	mov    %edx,%ecx
  80246b:	89 c6                	mov    %eax,%esi
  80246d:	e9 71 ff ff ff       	jmp    8023e3 <__umoddi3+0xb3>
  802472:	66 90                	xchg   %ax,%ax
  802474:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802478:	72 ea                	jb     802464 <__umoddi3+0x134>
  80247a:	89 d9                	mov    %ebx,%ecx
  80247c:	e9 62 ff ff ff       	jmp    8023e3 <__umoddi3+0xb3>
