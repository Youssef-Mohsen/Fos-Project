
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
  800041:	e8 34 1c 00 00       	call   801c7a <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 24 80 00       	push   $0x8024a0
  80004e:	e8 ee 0a 00 00       	call   800b41 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 24 80 00       	push   $0x8024a2
  80005e:	e8 de 0a 00 00       	call   800b41 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 b8 24 80 00       	push   $0x8024b8
  80006e:	e8 ce 0a 00 00       	call   800b41 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 24 80 00       	push   $0x8024a2
  80007e:	e8 be 0a 00 00       	call   800b41 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 24 80 00       	push   $0x8024a0
  80008e:	e8 ae 0a 00 00       	call   800b41 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d0 24 80 00       	push   $0x8024d0
  8000a5:	e8 2b 11 00 00       	call   8011d5 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 7d 16 00 00       	call   80173d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 24 1a 00 00       	call   801af9 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 f0 24 80 00       	push   $0x8024f0
  8000e3:	e8 59 0a 00 00       	call   800b41 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 12 25 80 00       	push   $0x802512
  8000f3:	e8 49 0a 00 00       	call   800b41 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 20 25 80 00       	push   $0x802520
  800103:	e8 39 0a 00 00       	call   800b41 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 2f 25 80 00       	push   $0x80252f
  800113:	e8 29 0a 00 00       	call   800b41 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 3f 25 80 00       	push   $0x80253f
  800123:	e8 19 0a 00 00       	call   800b41 <cprintf>
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
  800162:	e8 2d 1b 00 00       	call   801c94 <sys_unlock_cons>
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
  8001d7:	e8 9e 1a 00 00       	call   801c7a <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 48 25 80 00       	push   $0x802548
  8001e4:	e8 58 09 00 00       	call   800b41 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
			//PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ec:	e8 a3 1a 00 00       	call   801c94 <sys_unlock_cons>
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
  80021a:	e8 65 06 00 00       	call   800884 <_panic>
		else
		{
//			sys_lock_cons();
			sys_lock_cons();
  80021f:	e8 56 1a 00 00       	call   801c7a <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 b8 25 80 00       	push   $0x8025b8
  80022c:	e8 10 09 00 00       	call   800b41 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 ec 25 80 00       	push   $0x8025ec
  80023c:	e8 00 09 00 00       	call   800b41 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 20 26 80 00       	push   $0x802620
  80024c:	e8 f0 08 00 00       	call   800b41 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800254:	e8 3b 1a 00 00       	call   801c94 <sys_unlock_cons>
		}

		//free(Elements) ;

//		sys_lock_cons();
		sys_lock_cons();
  800259:	e8 1c 1a 00 00       	call   801c7a <sys_lock_cons>
		{
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 52 26 80 00       	push   $0x802652
  80026c:	e8 d0 08 00 00       	call   800b41 <cprintf>
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
  8002b2:	e8 dd 19 00 00       	call   801c94 <sys_unlock_cons>
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
  80044b:	e8 f1 06 00 00       	call   800b41 <cprintf>
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
  80046d:	e8 cf 06 00 00       	call   800b41 <cprintf>
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
  80049b:	e8 a1 06 00 00       	call   800b41 <cprintf>
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
  80053c:	e8 b8 15 00 00       	call   801af9 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 a3 15 00 00       	call   801af9 <malloc>
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
  80070f:	e8 b1 16 00 00       	call   801dc5 <sys_cputc>
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
  800720:	e8 3c 15 00 00       	call   801c61 <sys_cgetc>
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
  80073d:	e8 b4 17 00 00       	call   801ef6 <sys_getenvindex>
  800742:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800745:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800748:	89 d0                	mov    %edx,%eax
  80074a:	c1 e0 06             	shl    $0x6,%eax
  80074d:	29 d0                	sub    %edx,%eax
  80074f:	c1 e0 02             	shl    $0x2,%eax
  800752:	01 d0                	add    %edx,%eax
  800754:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80075b:	01 c8                	add    %ecx,%eax
  80075d:	c1 e0 03             	shl    $0x3,%eax
  800760:	01 d0                	add    %edx,%eax
  800762:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800769:	29 c2                	sub    %eax,%edx
  80076b:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800772:	89 c2                	mov    %eax,%edx
  800774:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80077a:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80077f:	a1 08 30 80 00       	mov    0x803008,%eax
  800784:	8a 40 20             	mov    0x20(%eax),%al
  800787:	84 c0                	test   %al,%al
  800789:	74 0d                	je     800798 <libmain+0x61>
		binaryname = myEnv->prog_name;
  80078b:	a1 08 30 80 00       	mov    0x803008,%eax
  800790:	83 c0 20             	add    $0x20,%eax
  800793:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800798:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80079c:	7e 0a                	jle    8007a8 <libmain+0x71>
		binaryname = argv[0];
  80079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 0c             	pushl  0xc(%ebp)
  8007ae:	ff 75 08             	pushl  0x8(%ebp)
  8007b1:	e8 82 f8 ff ff       	call   800038 <_main>
  8007b6:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8007b9:	e8 bc 14 00 00       	call   801c7a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8007be:	83 ec 0c             	sub    $0xc,%esp
  8007c1:	68 94 26 80 00       	push   $0x802694
  8007c6:	e8 76 03 00 00       	call   800b41 <cprintf>
  8007cb:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007ce:	a1 08 30 80 00       	mov    0x803008,%eax
  8007d3:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8007d9:	a1 08 30 80 00       	mov    0x803008,%eax
  8007de:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	52                   	push   %edx
  8007e8:	50                   	push   %eax
  8007e9:	68 bc 26 80 00       	push   $0x8026bc
  8007ee:	e8 4e 03 00 00       	call   800b41 <cprintf>
  8007f3:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007f6:	a1 08 30 80 00       	mov    0x803008,%eax
  8007fb:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800801:	a1 08 30 80 00       	mov    0x803008,%eax
  800806:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80080c:	a1 08 30 80 00       	mov    0x803008,%eax
  800811:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800817:	51                   	push   %ecx
  800818:	52                   	push   %edx
  800819:	50                   	push   %eax
  80081a:	68 e4 26 80 00       	push   $0x8026e4
  80081f:	e8 1d 03 00 00       	call   800b41 <cprintf>
  800824:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800827:	a1 08 30 80 00       	mov    0x803008,%eax
  80082c:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	50                   	push   %eax
  800836:	68 3c 27 80 00       	push   $0x80273c
  80083b:	e8 01 03 00 00       	call   800b41 <cprintf>
  800840:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800843:	83 ec 0c             	sub    $0xc,%esp
  800846:	68 94 26 80 00       	push   $0x802694
  80084b:	e8 f1 02 00 00       	call   800b41 <cprintf>
  800850:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800853:	e8 3c 14 00 00       	call   801c94 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800858:	e8 19 00 00 00       	call   800876 <exit>
}
  80085d:	90                   	nop
  80085e:	c9                   	leave  
  80085f:	c3                   	ret    

00800860 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800866:	83 ec 0c             	sub    $0xc,%esp
  800869:	6a 00                	push   $0x0
  80086b:	e8 52 16 00 00       	call   801ec2 <sys_destroy_env>
  800870:	83 c4 10             	add    $0x10,%esp
}
  800873:	90                   	nop
  800874:	c9                   	leave  
  800875:	c3                   	ret    

00800876 <exit>:

void
exit(void)
{
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80087c:	e8 a7 16 00 00       	call   801f28 <sys_exit_env>
}
  800881:	90                   	nop
  800882:	c9                   	leave  
  800883:	c3                   	ret    

00800884 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80088a:	8d 45 10             	lea    0x10(%ebp),%eax
  80088d:	83 c0 04             	add    $0x4,%eax
  800890:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800893:	a1 28 30 80 00       	mov    0x803028,%eax
  800898:	85 c0                	test   %eax,%eax
  80089a:	74 16                	je     8008b2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80089c:	a1 28 30 80 00       	mov    0x803028,%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	50                   	push   %eax
  8008a5:	68 50 27 80 00       	push   $0x802750
  8008aa:	e8 92 02 00 00       	call   800b41 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008b2:	a1 00 30 80 00       	mov    0x803000,%eax
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	ff 75 08             	pushl  0x8(%ebp)
  8008bd:	50                   	push   %eax
  8008be:	68 55 27 80 00       	push   $0x802755
  8008c3:	e8 79 02 00 00       	call   800b41 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d4:	50                   	push   %eax
  8008d5:	e8 fc 01 00 00       	call   800ad6 <vcprintf>
  8008da:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	6a 00                	push   $0x0
  8008e2:	68 71 27 80 00       	push   $0x802771
  8008e7:	e8 ea 01 00 00       	call   800ad6 <vcprintf>
  8008ec:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008ef:	e8 82 ff ff ff       	call   800876 <exit>

	// should not return here
	while (1) ;
  8008f4:	eb fe                	jmp    8008f4 <_panic+0x70>

008008f6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008fc:	a1 08 30 80 00       	mov    0x803008,%eax
  800901:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800907:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090a:	39 c2                	cmp    %eax,%edx
  80090c:	74 14                	je     800922 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80090e:	83 ec 04             	sub    $0x4,%esp
  800911:	68 74 27 80 00       	push   $0x802774
  800916:	6a 26                	push   $0x26
  800918:	68 c0 27 80 00       	push   $0x8027c0
  80091d:	e8 62 ff ff ff       	call   800884 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800929:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800930:	e9 c5 00 00 00       	jmp    8009fa <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800935:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800938:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	01 d0                	add    %edx,%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	85 c0                	test   %eax,%eax
  800948:	75 08                	jne    800952 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80094a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80094d:	e9 a5 00 00 00       	jmp    8009f7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800952:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800959:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800960:	eb 69                	jmp    8009cb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800962:	a1 08 30 80 00       	mov    0x803008,%eax
  800967:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80096d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800970:	89 d0                	mov    %edx,%eax
  800972:	01 c0                	add    %eax,%eax
  800974:	01 d0                	add    %edx,%eax
  800976:	c1 e0 03             	shl    $0x3,%eax
  800979:	01 c8                	add    %ecx,%eax
  80097b:	8a 40 04             	mov    0x4(%eax),%al
  80097e:	84 c0                	test   %al,%al
  800980:	75 46                	jne    8009c8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800982:	a1 08 30 80 00       	mov    0x803008,%eax
  800987:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80098d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800990:	89 d0                	mov    %edx,%eax
  800992:	01 c0                	add    %eax,%eax
  800994:	01 d0                	add    %edx,%eax
  800996:	c1 e0 03             	shl    $0x3,%eax
  800999:	01 c8                	add    %ecx,%eax
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009a8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	01 c8                	add    %ecx,%eax
  8009b9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009bb:	39 c2                	cmp    %eax,%edx
  8009bd:	75 09                	jne    8009c8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8009bf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009c6:	eb 15                	jmp    8009dd <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c8:	ff 45 e8             	incl   -0x18(%ebp)
  8009cb:	a1 08 30 80 00       	mov    0x803008,%eax
  8009d0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009d9:	39 c2                	cmp    %eax,%edx
  8009db:	77 85                	ja     800962 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009e1:	75 14                	jne    8009f7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8009e3:	83 ec 04             	sub    $0x4,%esp
  8009e6:	68 cc 27 80 00       	push   $0x8027cc
  8009eb:	6a 3a                	push   $0x3a
  8009ed:	68 c0 27 80 00       	push   $0x8027c0
  8009f2:	e8 8d fe ff ff       	call   800884 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009f7:	ff 45 f0             	incl   -0x10(%ebp)
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a00:	0f 8c 2f ff ff ff    	jl     800935 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a06:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a0d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a14:	eb 26                	jmp    800a3c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a16:	a1 08 30 80 00       	mov    0x803008,%eax
  800a1b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800a21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a24:	89 d0                	mov    %edx,%eax
  800a26:	01 c0                	add    %eax,%eax
  800a28:	01 d0                	add    %edx,%eax
  800a2a:	c1 e0 03             	shl    $0x3,%eax
  800a2d:	01 c8                	add    %ecx,%eax
  800a2f:	8a 40 04             	mov    0x4(%eax),%al
  800a32:	3c 01                	cmp    $0x1,%al
  800a34:	75 03                	jne    800a39 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a36:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a39:	ff 45 e0             	incl   -0x20(%ebp)
  800a3c:	a1 08 30 80 00       	mov    0x803008,%eax
  800a41:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a4a:	39 c2                	cmp    %eax,%edx
  800a4c:	77 c8                	ja     800a16 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a51:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a54:	74 14                	je     800a6a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a56:	83 ec 04             	sub    $0x4,%esp
  800a59:	68 20 28 80 00       	push   $0x802820
  800a5e:	6a 44                	push   $0x44
  800a60:	68 c0 27 80 00       	push   $0x8027c0
  800a65:	e8 1a fe ff ff       	call   800884 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a6a:	90                   	nop
  800a6b:	c9                   	leave  
  800a6c:	c3                   	ret    

00800a6d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a76:	8b 00                	mov    (%eax),%eax
  800a78:	8d 48 01             	lea    0x1(%eax),%ecx
  800a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7e:	89 0a                	mov    %ecx,(%edx)
  800a80:	8b 55 08             	mov    0x8(%ebp),%edx
  800a83:	88 d1                	mov    %dl,%cl
  800a85:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a88:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8f:	8b 00                	mov    (%eax),%eax
  800a91:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a96:	75 2c                	jne    800ac4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a98:	a0 0c 30 80 00       	mov    0x80300c,%al
  800a9d:	0f b6 c0             	movzbl %al,%eax
  800aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa3:	8b 12                	mov    (%edx),%edx
  800aa5:	89 d1                	mov    %edx,%ecx
  800aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aaa:	83 c2 08             	add    $0x8,%edx
  800aad:	83 ec 04             	sub    $0x4,%esp
  800ab0:	50                   	push   %eax
  800ab1:	51                   	push   %ecx
  800ab2:	52                   	push   %edx
  800ab3:	e8 80 11 00 00       	call   801c38 <sys_cputs>
  800ab8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac7:	8b 40 04             	mov    0x4(%eax),%eax
  800aca:	8d 50 01             	lea    0x1(%eax),%edx
  800acd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad0:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ad3:	90                   	nop
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800adf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ae6:	00 00 00 
	b.cnt = 0;
  800ae9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800af0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800af3:	ff 75 0c             	pushl  0xc(%ebp)
  800af6:	ff 75 08             	pushl  0x8(%ebp)
  800af9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800aff:	50                   	push   %eax
  800b00:	68 6d 0a 80 00       	push   $0x800a6d
  800b05:	e8 11 02 00 00       	call   800d1b <vprintfmt>
  800b0a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b0d:	a0 0c 30 80 00       	mov    0x80300c,%al
  800b12:	0f b6 c0             	movzbl %al,%eax
  800b15:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b1b:	83 ec 04             	sub    $0x4,%esp
  800b1e:	50                   	push   %eax
  800b1f:	52                   	push   %edx
  800b20:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b26:	83 c0 08             	add    $0x8,%eax
  800b29:	50                   	push   %eax
  800b2a:	e8 09 11 00 00       	call   801c38 <sys_cputs>
  800b2f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b32:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800b39:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b3f:	c9                   	leave  
  800b40:	c3                   	ret    

00800b41 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b47:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800b4e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	83 ec 08             	sub    $0x8,%esp
  800b5a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5d:	50                   	push   %eax
  800b5e:	e8 73 ff ff ff       	call   800ad6 <vcprintf>
  800b63:	83 c4 10             	add    $0x10,%esp
  800b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b74:	e8 01 11 00 00       	call   801c7a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b79:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 f4             	pushl  -0xc(%ebp)
  800b88:	50                   	push   %eax
  800b89:	e8 48 ff ff ff       	call   800ad6 <vcprintf>
  800b8e:	83 c4 10             	add    $0x10,%esp
  800b91:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b94:	e8 fb 10 00 00       	call   801c94 <sys_unlock_cons>
	return cnt;
  800b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b9c:	c9                   	leave  
  800b9d:	c3                   	ret    

00800b9e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	53                   	push   %ebx
  800ba2:	83 ec 14             	sub    $0x14,%esp
  800ba5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bab:	8b 45 14             	mov    0x14(%ebp),%eax
  800bae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bb1:	8b 45 18             	mov    0x18(%ebp),%eax
  800bb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bbc:	77 55                	ja     800c13 <printnum+0x75>
  800bbe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bc1:	72 05                	jb     800bc8 <printnum+0x2a>
  800bc3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bc6:	77 4b                	ja     800c13 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bc8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bcb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bce:	8b 45 18             	mov    0x18(%ebp),%eax
  800bd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd6:	52                   	push   %edx
  800bd7:	50                   	push   %eax
  800bd8:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdb:	ff 75 f0             	pushl  -0x10(%ebp)
  800bde:	e8 59 16 00 00       	call   80223c <__udivdi3>
  800be3:	83 c4 10             	add    $0x10,%esp
  800be6:	83 ec 04             	sub    $0x4,%esp
  800be9:	ff 75 20             	pushl  0x20(%ebp)
  800bec:	53                   	push   %ebx
  800bed:	ff 75 18             	pushl  0x18(%ebp)
  800bf0:	52                   	push   %edx
  800bf1:	50                   	push   %eax
  800bf2:	ff 75 0c             	pushl  0xc(%ebp)
  800bf5:	ff 75 08             	pushl  0x8(%ebp)
  800bf8:	e8 a1 ff ff ff       	call   800b9e <printnum>
  800bfd:	83 c4 20             	add    $0x20,%esp
  800c00:	eb 1a                	jmp    800c1c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	ff 75 20             	pushl  0x20(%ebp)
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	ff d0                	call   *%eax
  800c10:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c13:	ff 4d 1c             	decl   0x1c(%ebp)
  800c16:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c1a:	7f e6                	jg     800c02 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c1c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c2a:	53                   	push   %ebx
  800c2b:	51                   	push   %ecx
  800c2c:	52                   	push   %edx
  800c2d:	50                   	push   %eax
  800c2e:	e8 19 17 00 00       	call   80234c <__umoddi3>
  800c33:	83 c4 10             	add    $0x10,%esp
  800c36:	05 94 2a 80 00       	add    $0x802a94,%eax
  800c3b:	8a 00                	mov    (%eax),%al
  800c3d:	0f be c0             	movsbl %al,%eax
  800c40:	83 ec 08             	sub    $0x8,%esp
  800c43:	ff 75 0c             	pushl  0xc(%ebp)
  800c46:	50                   	push   %eax
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
}
  800c4f:	90                   	nop
  800c50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c53:	c9                   	leave  
  800c54:	c3                   	ret    

00800c55 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c58:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c5c:	7e 1c                	jle    800c7a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8b 00                	mov    (%eax),%eax
  800c63:	8d 50 08             	lea    0x8(%eax),%edx
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	89 10                	mov    %edx,(%eax)
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8b 00                	mov    (%eax),%eax
  800c70:	83 e8 08             	sub    $0x8,%eax
  800c73:	8b 50 04             	mov    0x4(%eax),%edx
  800c76:	8b 00                	mov    (%eax),%eax
  800c78:	eb 40                	jmp    800cba <getuint+0x65>
	else if (lflag)
  800c7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7e:	74 1e                	je     800c9e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8b 00                	mov    (%eax),%eax
  800c85:	8d 50 04             	lea    0x4(%eax),%edx
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	89 10                	mov    %edx,(%eax)
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8b 00                	mov    (%eax),%eax
  800c92:	83 e8 04             	sub    $0x4,%eax
  800c95:	8b 00                	mov    (%eax),%eax
  800c97:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9c:	eb 1c                	jmp    800cba <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	8b 00                	mov    (%eax),%eax
  800ca3:	8d 50 04             	lea    0x4(%eax),%edx
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	89 10                	mov    %edx,(%eax)
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8b 00                	mov    (%eax),%eax
  800cb0:	83 e8 04             	sub    $0x4,%eax
  800cb3:	8b 00                	mov    (%eax),%eax
  800cb5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cbf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cc3:	7e 1c                	jle    800ce1 <getint+0x25>
		return va_arg(*ap, long long);
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8b 00                	mov    (%eax),%eax
  800cca:	8d 50 08             	lea    0x8(%eax),%edx
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	89 10                	mov    %edx,(%eax)
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8b 00                	mov    (%eax),%eax
  800cd7:	83 e8 08             	sub    $0x8,%eax
  800cda:	8b 50 04             	mov    0x4(%eax),%edx
  800cdd:	8b 00                	mov    (%eax),%eax
  800cdf:	eb 38                	jmp    800d19 <getint+0x5d>
	else if (lflag)
  800ce1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce5:	74 1a                	je     800d01 <getint+0x45>
		return va_arg(*ap, long);
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8b 00                	mov    (%eax),%eax
  800cec:	8d 50 04             	lea    0x4(%eax),%edx
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	89 10                	mov    %edx,(%eax)
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8b 00                	mov    (%eax),%eax
  800cf9:	83 e8 04             	sub    $0x4,%eax
  800cfc:	8b 00                	mov    (%eax),%eax
  800cfe:	99                   	cltd   
  800cff:	eb 18                	jmp    800d19 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	8d 50 04             	lea    0x4(%eax),%edx
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	89 10                	mov    %edx,(%eax)
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8b 00                	mov    (%eax),%eax
  800d13:	83 e8 04             	sub    $0x4,%eax
  800d16:	8b 00                	mov    (%eax),%eax
  800d18:	99                   	cltd   
}
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	56                   	push   %esi
  800d1f:	53                   	push   %ebx
  800d20:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d23:	eb 17                	jmp    800d3c <vprintfmt+0x21>
			if (ch == '\0')
  800d25:	85 db                	test   %ebx,%ebx
  800d27:	0f 84 c1 03 00 00    	je     8010ee <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d2d:	83 ec 08             	sub    $0x8,%esp
  800d30:	ff 75 0c             	pushl  0xc(%ebp)
  800d33:	53                   	push   %ebx
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	ff d0                	call   *%eax
  800d39:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	8d 50 01             	lea    0x1(%eax),%edx
  800d42:	89 55 10             	mov    %edx,0x10(%ebp)
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	0f b6 d8             	movzbl %al,%ebx
  800d4a:	83 fb 25             	cmp    $0x25,%ebx
  800d4d:	75 d6                	jne    800d25 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d4f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d53:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d5a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d61:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d68:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	8d 50 01             	lea    0x1(%eax),%edx
  800d75:	89 55 10             	mov    %edx,0x10(%ebp)
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	0f b6 d8             	movzbl %al,%ebx
  800d7d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d80:	83 f8 5b             	cmp    $0x5b,%eax
  800d83:	0f 87 3d 03 00 00    	ja     8010c6 <vprintfmt+0x3ab>
  800d89:	8b 04 85 b8 2a 80 00 	mov    0x802ab8(,%eax,4),%eax
  800d90:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d92:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d96:	eb d7                	jmp    800d6f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d98:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d9c:	eb d1                	jmp    800d6f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d9e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800da5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800da8:	89 d0                	mov    %edx,%eax
  800daa:	c1 e0 02             	shl    $0x2,%eax
  800dad:	01 d0                	add    %edx,%eax
  800daf:	01 c0                	add    %eax,%eax
  800db1:	01 d8                	add    %ebx,%eax
  800db3:	83 e8 30             	sub    $0x30,%eax
  800db6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dc1:	83 fb 2f             	cmp    $0x2f,%ebx
  800dc4:	7e 3e                	jle    800e04 <vprintfmt+0xe9>
  800dc6:	83 fb 39             	cmp    $0x39,%ebx
  800dc9:	7f 39                	jg     800e04 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dcb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dce:	eb d5                	jmp    800da5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800dd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd3:	83 c0 04             	add    $0x4,%eax
  800dd6:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddc:	83 e8 04             	sub    $0x4,%eax
  800ddf:	8b 00                	mov    (%eax),%eax
  800de1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800de4:	eb 1f                	jmp    800e05 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800de6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dea:	79 83                	jns    800d6f <vprintfmt+0x54>
				width = 0;
  800dec:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800df3:	e9 77 ff ff ff       	jmp    800d6f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800df8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800dff:	e9 6b ff ff ff       	jmp    800d6f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e04:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e09:	0f 89 60 ff ff ff    	jns    800d6f <vprintfmt+0x54>
				width = precision, precision = -1;
  800e0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e15:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e1c:	e9 4e ff ff ff       	jmp    800d6f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e21:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e24:	e9 46 ff ff ff       	jmp    800d6f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e29:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2c:	83 c0 04             	add    $0x4,%eax
  800e2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e32:	8b 45 14             	mov    0x14(%ebp),%eax
  800e35:	83 e8 04             	sub    $0x4,%eax
  800e38:	8b 00                	mov    (%eax),%eax
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	ff 75 0c             	pushl  0xc(%ebp)
  800e40:	50                   	push   %eax
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	ff d0                	call   *%eax
  800e46:	83 c4 10             	add    $0x10,%esp
			break;
  800e49:	e9 9b 02 00 00       	jmp    8010e9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e51:	83 c0 04             	add    $0x4,%eax
  800e54:	89 45 14             	mov    %eax,0x14(%ebp)
  800e57:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5a:	83 e8 04             	sub    $0x4,%eax
  800e5d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e5f:	85 db                	test   %ebx,%ebx
  800e61:	79 02                	jns    800e65 <vprintfmt+0x14a>
				err = -err;
  800e63:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e65:	83 fb 64             	cmp    $0x64,%ebx
  800e68:	7f 0b                	jg     800e75 <vprintfmt+0x15a>
  800e6a:	8b 34 9d 00 29 80 00 	mov    0x802900(,%ebx,4),%esi
  800e71:	85 f6                	test   %esi,%esi
  800e73:	75 19                	jne    800e8e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e75:	53                   	push   %ebx
  800e76:	68 a5 2a 80 00       	push   $0x802aa5
  800e7b:	ff 75 0c             	pushl  0xc(%ebp)
  800e7e:	ff 75 08             	pushl  0x8(%ebp)
  800e81:	e8 70 02 00 00       	call   8010f6 <printfmt>
  800e86:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e89:	e9 5b 02 00 00       	jmp    8010e9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e8e:	56                   	push   %esi
  800e8f:	68 ae 2a 80 00       	push   $0x802aae
  800e94:	ff 75 0c             	pushl  0xc(%ebp)
  800e97:	ff 75 08             	pushl  0x8(%ebp)
  800e9a:	e8 57 02 00 00       	call   8010f6 <printfmt>
  800e9f:	83 c4 10             	add    $0x10,%esp
			break;
  800ea2:	e9 42 02 00 00       	jmp    8010e9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ea7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eaa:	83 c0 04             	add    $0x4,%eax
  800ead:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb3:	83 e8 04             	sub    $0x4,%eax
  800eb6:	8b 30                	mov    (%eax),%esi
  800eb8:	85 f6                	test   %esi,%esi
  800eba:	75 05                	jne    800ec1 <vprintfmt+0x1a6>
				p = "(null)";
  800ebc:	be b1 2a 80 00       	mov    $0x802ab1,%esi
			if (width > 0 && padc != '-')
  800ec1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ec5:	7e 6d                	jle    800f34 <vprintfmt+0x219>
  800ec7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ecb:	74 67                	je     800f34 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ecd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	50                   	push   %eax
  800ed4:	56                   	push   %esi
  800ed5:	e8 26 05 00 00       	call   801400 <strnlen>
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ee0:	eb 16                	jmp    800ef8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ee2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ee6:	83 ec 08             	sub    $0x8,%esp
  800ee9:	ff 75 0c             	pushl  0xc(%ebp)
  800eec:	50                   	push   %eax
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	ff d0                	call   *%eax
  800ef2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ef5:	ff 4d e4             	decl   -0x1c(%ebp)
  800ef8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800efc:	7f e4                	jg     800ee2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800efe:	eb 34                	jmp    800f34 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f00:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f04:	74 1c                	je     800f22 <vprintfmt+0x207>
  800f06:	83 fb 1f             	cmp    $0x1f,%ebx
  800f09:	7e 05                	jle    800f10 <vprintfmt+0x1f5>
  800f0b:	83 fb 7e             	cmp    $0x7e,%ebx
  800f0e:	7e 12                	jle    800f22 <vprintfmt+0x207>
					putch('?', putdat);
  800f10:	83 ec 08             	sub    $0x8,%esp
  800f13:	ff 75 0c             	pushl  0xc(%ebp)
  800f16:	6a 3f                	push   $0x3f
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	ff d0                	call   *%eax
  800f1d:	83 c4 10             	add    $0x10,%esp
  800f20:	eb 0f                	jmp    800f31 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f22:	83 ec 08             	sub    $0x8,%esp
  800f25:	ff 75 0c             	pushl  0xc(%ebp)
  800f28:	53                   	push   %ebx
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	ff d0                	call   *%eax
  800f2e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f31:	ff 4d e4             	decl   -0x1c(%ebp)
  800f34:	89 f0                	mov    %esi,%eax
  800f36:	8d 70 01             	lea    0x1(%eax),%esi
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	0f be d8             	movsbl %al,%ebx
  800f3e:	85 db                	test   %ebx,%ebx
  800f40:	74 24                	je     800f66 <vprintfmt+0x24b>
  800f42:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f46:	78 b8                	js     800f00 <vprintfmt+0x1e5>
  800f48:	ff 4d e0             	decl   -0x20(%ebp)
  800f4b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f4f:	79 af                	jns    800f00 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f51:	eb 13                	jmp    800f66 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f53:	83 ec 08             	sub    $0x8,%esp
  800f56:	ff 75 0c             	pushl  0xc(%ebp)
  800f59:	6a 20                	push   $0x20
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	ff d0                	call   *%eax
  800f60:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f63:	ff 4d e4             	decl   -0x1c(%ebp)
  800f66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f6a:	7f e7                	jg     800f53 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f6c:	e9 78 01 00 00       	jmp    8010e9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f71:	83 ec 08             	sub    $0x8,%esp
  800f74:	ff 75 e8             	pushl  -0x18(%ebp)
  800f77:	8d 45 14             	lea    0x14(%ebp),%eax
  800f7a:	50                   	push   %eax
  800f7b:	e8 3c fd ff ff       	call   800cbc <getint>
  800f80:	83 c4 10             	add    $0x10,%esp
  800f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f86:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f8f:	85 d2                	test   %edx,%edx
  800f91:	79 23                	jns    800fb6 <vprintfmt+0x29b>
				putch('-', putdat);
  800f93:	83 ec 08             	sub    $0x8,%esp
  800f96:	ff 75 0c             	pushl  0xc(%ebp)
  800f99:	6a 2d                	push   $0x2d
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	ff d0                	call   *%eax
  800fa0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa9:	f7 d8                	neg    %eax
  800fab:	83 d2 00             	adc    $0x0,%edx
  800fae:	f7 da                	neg    %edx
  800fb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fb6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fbd:	e9 bc 00 00 00       	jmp    80107e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fc2:	83 ec 08             	sub    $0x8,%esp
  800fc5:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc8:	8d 45 14             	lea    0x14(%ebp),%eax
  800fcb:	50                   	push   %eax
  800fcc:	e8 84 fc ff ff       	call   800c55 <getuint>
  800fd1:	83 c4 10             	add    $0x10,%esp
  800fd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fda:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fe1:	e9 98 00 00 00       	jmp    80107e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fe6:	83 ec 08             	sub    $0x8,%esp
  800fe9:	ff 75 0c             	pushl  0xc(%ebp)
  800fec:	6a 58                	push   $0x58
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	ff d0                	call   *%eax
  800ff3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ff6:	83 ec 08             	sub    $0x8,%esp
  800ff9:	ff 75 0c             	pushl  0xc(%ebp)
  800ffc:	6a 58                	push   $0x58
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	6a 58                	push   $0x58
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	ff d0                	call   *%eax
  801013:	83 c4 10             	add    $0x10,%esp
			break;
  801016:	e9 ce 00 00 00       	jmp    8010e9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80101b:	83 ec 08             	sub    $0x8,%esp
  80101e:	ff 75 0c             	pushl  0xc(%ebp)
  801021:	6a 30                	push   $0x30
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	ff d0                	call   *%eax
  801028:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	6a 78                	push   $0x78
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	ff d0                	call   *%eax
  801038:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80103b:	8b 45 14             	mov    0x14(%ebp),%eax
  80103e:	83 c0 04             	add    $0x4,%eax
  801041:	89 45 14             	mov    %eax,0x14(%ebp)
  801044:	8b 45 14             	mov    0x14(%ebp),%eax
  801047:	83 e8 04             	sub    $0x4,%eax
  80104a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80104c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801056:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80105d:	eb 1f                	jmp    80107e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80105f:	83 ec 08             	sub    $0x8,%esp
  801062:	ff 75 e8             	pushl  -0x18(%ebp)
  801065:	8d 45 14             	lea    0x14(%ebp),%eax
  801068:	50                   	push   %eax
  801069:	e8 e7 fb ff ff       	call   800c55 <getuint>
  80106e:	83 c4 10             	add    $0x10,%esp
  801071:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801074:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801077:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80107e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801082:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801085:	83 ec 04             	sub    $0x4,%esp
  801088:	52                   	push   %edx
  801089:	ff 75 e4             	pushl  -0x1c(%ebp)
  80108c:	50                   	push   %eax
  80108d:	ff 75 f4             	pushl  -0xc(%ebp)
  801090:	ff 75 f0             	pushl  -0x10(%ebp)
  801093:	ff 75 0c             	pushl  0xc(%ebp)
  801096:	ff 75 08             	pushl  0x8(%ebp)
  801099:	e8 00 fb ff ff       	call   800b9e <printnum>
  80109e:	83 c4 20             	add    $0x20,%esp
			break;
  8010a1:	eb 46                	jmp    8010e9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010a3:	83 ec 08             	sub    $0x8,%esp
  8010a6:	ff 75 0c             	pushl  0xc(%ebp)
  8010a9:	53                   	push   %ebx
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	ff d0                	call   *%eax
  8010af:	83 c4 10             	add    $0x10,%esp
			break;
  8010b2:	eb 35                	jmp    8010e9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010b4:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  8010bb:	eb 2c                	jmp    8010e9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010bd:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  8010c4:	eb 23                	jmp    8010e9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010c6:	83 ec 08             	sub    $0x8,%esp
  8010c9:	ff 75 0c             	pushl  0xc(%ebp)
  8010cc:	6a 25                	push   $0x25
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	ff d0                	call   *%eax
  8010d3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010d6:	ff 4d 10             	decl   0x10(%ebp)
  8010d9:	eb 03                	jmp    8010de <vprintfmt+0x3c3>
  8010db:	ff 4d 10             	decl   0x10(%ebp)
  8010de:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e1:	48                   	dec    %eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	3c 25                	cmp    $0x25,%al
  8010e6:	75 f3                	jne    8010db <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010e8:	90                   	nop
		}
	}
  8010e9:	e9 35 fc ff ff       	jmp    800d23 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010ee:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f2:	5b                   	pop    %ebx
  8010f3:	5e                   	pop    %esi
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    

008010f6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010fc:	8d 45 10             	lea    0x10(%ebp),%eax
  8010ff:	83 c0 04             	add    $0x4,%eax
  801102:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	ff 75 f4             	pushl  -0xc(%ebp)
  80110b:	50                   	push   %eax
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	ff 75 08             	pushl  0x8(%ebp)
  801112:	e8 04 fc ff ff       	call   800d1b <vprintfmt>
  801117:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80111a:	90                   	nop
  80111b:	c9                   	leave  
  80111c:	c3                   	ret    

0080111d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	8b 40 08             	mov    0x8(%eax),%eax
  801126:	8d 50 01             	lea    0x1(%eax),%edx
  801129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80112f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801132:	8b 10                	mov    (%eax),%edx
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	8b 40 04             	mov    0x4(%eax),%eax
  80113a:	39 c2                	cmp    %eax,%edx
  80113c:	73 12                	jae    801150 <sprintputch+0x33>
		*b->buf++ = ch;
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	8b 00                	mov    (%eax),%eax
  801143:	8d 48 01             	lea    0x1(%eax),%ecx
  801146:	8b 55 0c             	mov    0xc(%ebp),%edx
  801149:	89 0a                	mov    %ecx,(%edx)
  80114b:	8b 55 08             	mov    0x8(%ebp),%edx
  80114e:	88 10                	mov    %dl,(%eax)
}
  801150:	90                   	nop
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    

00801153 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	8d 50 ff             	lea    -0x1(%eax),%edx
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	01 d0                	add    %edx,%eax
  80116a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801174:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801178:	74 06                	je     801180 <vsnprintf+0x2d>
  80117a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80117e:	7f 07                	jg     801187 <vsnprintf+0x34>
		return -E_INVAL;
  801180:	b8 03 00 00 00       	mov    $0x3,%eax
  801185:	eb 20                	jmp    8011a7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801187:	ff 75 14             	pushl  0x14(%ebp)
  80118a:	ff 75 10             	pushl  0x10(%ebp)
  80118d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801190:	50                   	push   %eax
  801191:	68 1d 11 80 00       	push   $0x80111d
  801196:	e8 80 fb ff ff       	call   800d1b <vprintfmt>
  80119b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80119e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011a1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011a7:	c9                   	leave  
  8011a8:	c3                   	ret    

008011a9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011af:	8d 45 10             	lea    0x10(%ebp),%eax
  8011b2:	83 c0 04             	add    $0x4,%eax
  8011b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8011be:	50                   	push   %eax
  8011bf:	ff 75 0c             	pushl  0xc(%ebp)
  8011c2:	ff 75 08             	pushl  0x8(%ebp)
  8011c5:	e8 89 ff ff ff       	call   801153 <vsnprintf>
  8011ca:	83 c4 10             	add    $0x10,%esp
  8011cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d3:	c9                   	leave  
  8011d4:	c3                   	ret    

008011d5 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8011db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011df:	74 13                	je     8011f4 <readline+0x1f>
		cprintf("%s", prompt);
  8011e1:	83 ec 08             	sub    $0x8,%esp
  8011e4:	ff 75 08             	pushl  0x8(%ebp)
  8011e7:	68 28 2c 80 00       	push   $0x802c28
  8011ec:	e8 50 f9 ff ff       	call   800b41 <cprintf>
  8011f1:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011fb:	83 ec 0c             	sub    $0xc,%esp
  8011fe:	6a 00                	push   $0x0
  801200:	e8 28 f5 ff ff       	call   80072d <iscons>
  801205:	83 c4 10             	add    $0x10,%esp
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80120b:	e8 0a f5 ff ff       	call   80071a <getchar>
  801210:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801213:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801217:	79 22                	jns    80123b <readline+0x66>
			if (c != -E_EOF)
  801219:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80121d:	0f 84 ad 00 00 00    	je     8012d0 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801223:	83 ec 08             	sub    $0x8,%esp
  801226:	ff 75 ec             	pushl  -0x14(%ebp)
  801229:	68 2b 2c 80 00       	push   $0x802c2b
  80122e:	e8 0e f9 ff ff       	call   800b41 <cprintf>
  801233:	83 c4 10             	add    $0x10,%esp
			break;
  801236:	e9 95 00 00 00       	jmp    8012d0 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80123b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80123f:	7e 34                	jle    801275 <readline+0xa0>
  801241:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801248:	7f 2b                	jg     801275 <readline+0xa0>
			if (echoing)
  80124a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80124e:	74 0e                	je     80125e <readline+0x89>
				cputchar(c);
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	ff 75 ec             	pushl  -0x14(%ebp)
  801256:	e8 a0 f4 ff ff       	call   8006fb <cputchar>
  80125b:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80125e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801261:	8d 50 01             	lea    0x1(%eax),%edx
  801264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801267:	89 c2                	mov    %eax,%edx
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801271:	88 10                	mov    %dl,(%eax)
  801273:	eb 56                	jmp    8012cb <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801275:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801279:	75 1f                	jne    80129a <readline+0xc5>
  80127b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80127f:	7e 19                	jle    80129a <readline+0xc5>
			if (echoing)
  801281:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801285:	74 0e                	je     801295 <readline+0xc0>
				cputchar(c);
  801287:	83 ec 0c             	sub    $0xc,%esp
  80128a:	ff 75 ec             	pushl  -0x14(%ebp)
  80128d:	e8 69 f4 ff ff       	call   8006fb <cputchar>
  801292:	83 c4 10             	add    $0x10,%esp

			i--;
  801295:	ff 4d f4             	decl   -0xc(%ebp)
  801298:	eb 31                	jmp    8012cb <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80129a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80129e:	74 0a                	je     8012aa <readline+0xd5>
  8012a0:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012a4:	0f 85 61 ff ff ff    	jne    80120b <readline+0x36>
			if (echoing)
  8012aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ae:	74 0e                	je     8012be <readline+0xe9>
				cputchar(c);
  8012b0:	83 ec 0c             	sub    $0xc,%esp
  8012b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b6:	e8 40 f4 ff ff       	call   8006fb <cputchar>
  8012bb:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	01 d0                	add    %edx,%eax
  8012c6:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8012c9:	eb 06                	jmp    8012d1 <readline+0xfc>
		}
	}
  8012cb:	e9 3b ff ff ff       	jmp    80120b <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8012d0:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8012d1:	90                   	nop
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8012da:	e8 9b 09 00 00       	call   801c7a <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e3:	74 13                	je     8012f8 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012e5:	83 ec 08             	sub    $0x8,%esp
  8012e8:	ff 75 08             	pushl  0x8(%ebp)
  8012eb:	68 28 2c 80 00       	push   $0x802c28
  8012f0:	e8 4c f8 ff ff       	call   800b41 <cprintf>
  8012f5:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8012f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8012ff:	83 ec 0c             	sub    $0xc,%esp
  801302:	6a 00                	push   $0x0
  801304:	e8 24 f4 ff ff       	call   80072d <iscons>
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  80130f:	e8 06 f4 ff ff       	call   80071a <getchar>
  801314:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801317:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80131b:	79 22                	jns    80133f <atomic_readline+0x6b>
				if (c != -E_EOF)
  80131d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801321:	0f 84 ad 00 00 00    	je     8013d4 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801327:	83 ec 08             	sub    $0x8,%esp
  80132a:	ff 75 ec             	pushl  -0x14(%ebp)
  80132d:	68 2b 2c 80 00       	push   $0x802c2b
  801332:	e8 0a f8 ff ff       	call   800b41 <cprintf>
  801337:	83 c4 10             	add    $0x10,%esp
				break;
  80133a:	e9 95 00 00 00       	jmp    8013d4 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  80133f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801343:	7e 34                	jle    801379 <atomic_readline+0xa5>
  801345:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134c:	7f 2b                	jg     801379 <atomic_readline+0xa5>
				if (echoing)
  80134e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801352:	74 0e                	je     801362 <atomic_readline+0x8e>
					cputchar(c);
  801354:	83 ec 0c             	sub    $0xc,%esp
  801357:	ff 75 ec             	pushl  -0x14(%ebp)
  80135a:	e8 9c f3 ff ff       	call   8006fb <cputchar>
  80135f:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801365:	8d 50 01             	lea    0x1(%eax),%edx
  801368:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80136b:	89 c2                	mov    %eax,%edx
  80136d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801370:	01 d0                	add    %edx,%eax
  801372:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801375:	88 10                	mov    %dl,(%eax)
  801377:	eb 56                	jmp    8013cf <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801379:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137d:	75 1f                	jne    80139e <atomic_readline+0xca>
  80137f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801383:	7e 19                	jle    80139e <atomic_readline+0xca>
				if (echoing)
  801385:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801389:	74 0e                	je     801399 <atomic_readline+0xc5>
					cputchar(c);
  80138b:	83 ec 0c             	sub    $0xc,%esp
  80138e:	ff 75 ec             	pushl  -0x14(%ebp)
  801391:	e8 65 f3 ff ff       	call   8006fb <cputchar>
  801396:	83 c4 10             	add    $0x10,%esp
				i--;
  801399:	ff 4d f4             	decl   -0xc(%ebp)
  80139c:	eb 31                	jmp    8013cf <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80139e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a2:	74 0a                	je     8013ae <atomic_readline+0xda>
  8013a4:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a8:	0f 85 61 ff ff ff    	jne    80130f <atomic_readline+0x3b>
				if (echoing)
  8013ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b2:	74 0e                	je     8013c2 <atomic_readline+0xee>
					cputchar(c);
  8013b4:	83 ec 0c             	sub    $0xc,%esp
  8013b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8013ba:	e8 3c f3 ff ff       	call   8006fb <cputchar>
  8013bf:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8013c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c8:	01 d0                	add    %edx,%eax
  8013ca:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8013cd:	eb 06                	jmp    8013d5 <atomic_readline+0x101>
			}
		}
  8013cf:	e9 3b ff ff ff       	jmp    80130f <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8013d4:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8013d5:	e8 ba 08 00 00       	call   801c94 <sys_unlock_cons>
}
  8013da:	90                   	nop
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ea:	eb 06                	jmp    8013f2 <strlen+0x15>
		n++;
  8013ec:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013ef:	ff 45 08             	incl   0x8(%ebp)
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	84 c0                	test   %al,%al
  8013f9:	75 f1                	jne    8013ec <strlen+0xf>
		n++;
	return n;
  8013fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013fe:	c9                   	leave  
  8013ff:	c3                   	ret    

00801400 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801406:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80140d:	eb 09                	jmp    801418 <strnlen+0x18>
		n++;
  80140f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801412:	ff 45 08             	incl   0x8(%ebp)
  801415:	ff 4d 0c             	decl   0xc(%ebp)
  801418:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80141c:	74 09                	je     801427 <strnlen+0x27>
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	8a 00                	mov    (%eax),%al
  801423:	84 c0                	test   %al,%al
  801425:	75 e8                	jne    80140f <strnlen+0xf>
		n++;
	return n;
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    

0080142c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801438:	90                   	nop
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8d 50 01             	lea    0x1(%eax),%edx
  80143f:	89 55 08             	mov    %edx,0x8(%ebp)
  801442:	8b 55 0c             	mov    0xc(%ebp),%edx
  801445:	8d 4a 01             	lea    0x1(%edx),%ecx
  801448:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80144b:	8a 12                	mov    (%edx),%dl
  80144d:	88 10                	mov    %dl,(%eax)
  80144f:	8a 00                	mov    (%eax),%al
  801451:	84 c0                	test   %al,%al
  801453:	75 e4                	jne    801439 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801455:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801466:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80146d:	eb 1f                	jmp    80148e <strncpy+0x34>
		*dst++ = *src;
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8d 50 01             	lea    0x1(%eax),%edx
  801475:	89 55 08             	mov    %edx,0x8(%ebp)
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	8a 12                	mov    (%edx),%dl
  80147d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80147f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	84 c0                	test   %al,%al
  801486:	74 03                	je     80148b <strncpy+0x31>
			src++;
  801488:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80148b:	ff 45 fc             	incl   -0x4(%ebp)
  80148e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801491:	3b 45 10             	cmp    0x10(%ebp),%eax
  801494:	72 d9                	jb     80146f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801496:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ab:	74 30                	je     8014dd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014ad:	eb 16                	jmp    8014c5 <strlcpy+0x2a>
			*dst++ = *src++;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8d 50 01             	lea    0x1(%eax),%edx
  8014b5:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014bb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014be:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014c1:	8a 12                	mov    (%edx),%dl
  8014c3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014c5:	ff 4d 10             	decl   0x10(%ebp)
  8014c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014cc:	74 09                	je     8014d7 <strlcpy+0x3c>
  8014ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d1:	8a 00                	mov    (%eax),%al
  8014d3:	84 c0                	test   %al,%al
  8014d5:	75 d8                	jne    8014af <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e3:	29 c2                	sub    %eax,%edx
  8014e5:	89 d0                	mov    %edx,%eax
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014ec:	eb 06                	jmp    8014f4 <strcmp+0xb>
		p++, q++;
  8014ee:	ff 45 08             	incl   0x8(%ebp)
  8014f1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	84 c0                	test   %al,%al
  8014fb:	74 0e                	je     80150b <strcmp+0x22>
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 10                	mov    (%eax),%dl
  801502:	8b 45 0c             	mov    0xc(%ebp),%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	38 c2                	cmp    %al,%dl
  801509:	74 e3                	je     8014ee <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8a 00                	mov    (%eax),%al
  801510:	0f b6 d0             	movzbl %al,%edx
  801513:	8b 45 0c             	mov    0xc(%ebp),%eax
  801516:	8a 00                	mov    (%eax),%al
  801518:	0f b6 c0             	movzbl %al,%eax
  80151b:	29 c2                	sub    %eax,%edx
  80151d:	89 d0                	mov    %edx,%eax
}
  80151f:	5d                   	pop    %ebp
  801520:	c3                   	ret    

00801521 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801524:	eb 09                	jmp    80152f <strncmp+0xe>
		n--, p++, q++;
  801526:	ff 4d 10             	decl   0x10(%ebp)
  801529:	ff 45 08             	incl   0x8(%ebp)
  80152c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80152f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801533:	74 17                	je     80154c <strncmp+0x2b>
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	8a 00                	mov    (%eax),%al
  80153a:	84 c0                	test   %al,%al
  80153c:	74 0e                	je     80154c <strncmp+0x2b>
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	8a 10                	mov    (%eax),%dl
  801543:	8b 45 0c             	mov    0xc(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	38 c2                	cmp    %al,%dl
  80154a:	74 da                	je     801526 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80154c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801550:	75 07                	jne    801559 <strncmp+0x38>
		return 0;
  801552:	b8 00 00 00 00       	mov    $0x0,%eax
  801557:	eb 14                	jmp    80156d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	0f b6 d0             	movzbl %al,%edx
  801561:	8b 45 0c             	mov    0xc(%ebp),%eax
  801564:	8a 00                	mov    (%eax),%al
  801566:	0f b6 c0             	movzbl %al,%eax
  801569:	29 c2                	sub    %eax,%edx
  80156b:	89 d0                	mov    %edx,%eax
}
  80156d:	5d                   	pop    %ebp
  80156e:	c3                   	ret    

0080156f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	83 ec 04             	sub    $0x4,%esp
  801575:	8b 45 0c             	mov    0xc(%ebp),%eax
  801578:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80157b:	eb 12                	jmp    80158f <strchr+0x20>
		if (*s == c)
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	8a 00                	mov    (%eax),%al
  801582:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801585:	75 05                	jne    80158c <strchr+0x1d>
			return (char *) s;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	eb 11                	jmp    80159d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80158c:	ff 45 08             	incl   0x8(%ebp)
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	84 c0                	test   %al,%al
  801596:	75 e5                	jne    80157d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801598:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 04             	sub    $0x4,%esp
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015ab:	eb 0d                	jmp    8015ba <strfind+0x1b>
		if (*s == c)
  8015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015b5:	74 0e                	je     8015c5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015b7:	ff 45 08             	incl   0x8(%ebp)
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	8a 00                	mov    (%eax),%al
  8015bf:	84 c0                	test   %al,%al
  8015c1:	75 ea                	jne    8015ad <strfind+0xe>
  8015c3:	eb 01                	jmp    8015c6 <strfind+0x27>
		if (*s == c)
			break;
  8015c5:	90                   	nop
	return (char *) s;
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015dd:	eb 0e                	jmp    8015ed <memset+0x22>
		*p++ = c;
  8015df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e2:	8d 50 01             	lea    0x1(%eax),%edx
  8015e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015eb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015ed:	ff 4d f8             	decl   -0x8(%ebp)
  8015f0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015f4:	79 e9                	jns    8015df <memset+0x14>
		*p++ = c;

	return v;
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80160d:	eb 16                	jmp    801625 <memcpy+0x2a>
		*d++ = *s++;
  80160f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801612:	8d 50 01             	lea    0x1(%eax),%edx
  801615:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801618:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801621:	8a 12                	mov    (%edx),%dl
  801623:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801625:	8b 45 10             	mov    0x10(%ebp),%eax
  801628:	8d 50 ff             	lea    -0x1(%eax),%edx
  80162b:	89 55 10             	mov    %edx,0x10(%ebp)
  80162e:	85 c0                	test   %eax,%eax
  801630:	75 dd                	jne    80160f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801649:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80164f:	73 50                	jae    8016a1 <memmove+0x6a>
  801651:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801654:	8b 45 10             	mov    0x10(%ebp),%eax
  801657:	01 d0                	add    %edx,%eax
  801659:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80165c:	76 43                	jbe    8016a1 <memmove+0x6a>
		s += n;
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801664:	8b 45 10             	mov    0x10(%ebp),%eax
  801667:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80166a:	eb 10                	jmp    80167c <memmove+0x45>
			*--d = *--s;
  80166c:	ff 4d f8             	decl   -0x8(%ebp)
  80166f:	ff 4d fc             	decl   -0x4(%ebp)
  801672:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801675:	8a 10                	mov    (%eax),%dl
  801677:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80167a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80167c:	8b 45 10             	mov    0x10(%ebp),%eax
  80167f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801682:	89 55 10             	mov    %edx,0x10(%ebp)
  801685:	85 c0                	test   %eax,%eax
  801687:	75 e3                	jne    80166c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801689:	eb 23                	jmp    8016ae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80168b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168e:	8d 50 01             	lea    0x1(%eax),%edx
  801691:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801694:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801697:	8d 4a 01             	lea    0x1(%edx),%ecx
  80169a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80169d:	8a 12                	mov    (%edx),%dl
  80169f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	75 dd                	jne    80168b <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016c5:	eb 2a                	jmp    8016f1 <memcmp+0x3e>
		if (*s1 != *s2)
  8016c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ca:	8a 10                	mov    (%eax),%dl
  8016cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cf:	8a 00                	mov    (%eax),%al
  8016d1:	38 c2                	cmp    %al,%dl
  8016d3:	74 16                	je     8016eb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d8:	8a 00                	mov    (%eax),%al
  8016da:	0f b6 d0             	movzbl %al,%edx
  8016dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016e0:	8a 00                	mov    (%eax),%al
  8016e2:	0f b6 c0             	movzbl %al,%eax
  8016e5:	29 c2                	sub    %eax,%edx
  8016e7:	89 d0                	mov    %edx,%eax
  8016e9:	eb 18                	jmp    801703 <memcmp+0x50>
		s1++, s2++;
  8016eb:	ff 45 fc             	incl   -0x4(%ebp)
  8016ee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8016fa:	85 c0                	test   %eax,%eax
  8016fc:	75 c9                	jne    8016c7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80170b:	8b 55 08             	mov    0x8(%ebp),%edx
  80170e:	8b 45 10             	mov    0x10(%ebp),%eax
  801711:	01 d0                	add    %edx,%eax
  801713:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801716:	eb 15                	jmp    80172d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	8a 00                	mov    (%eax),%al
  80171d:	0f b6 d0             	movzbl %al,%edx
  801720:	8b 45 0c             	mov    0xc(%ebp),%eax
  801723:	0f b6 c0             	movzbl %al,%eax
  801726:	39 c2                	cmp    %eax,%edx
  801728:	74 0d                	je     801737 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80172a:	ff 45 08             	incl   0x8(%ebp)
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801733:	72 e3                	jb     801718 <memfind+0x13>
  801735:	eb 01                	jmp    801738 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801737:	90                   	nop
	return (void *) s;
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801743:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80174a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801751:	eb 03                	jmp    801756 <strtol+0x19>
		s++;
  801753:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	8a 00                	mov    (%eax),%al
  80175b:	3c 20                	cmp    $0x20,%al
  80175d:	74 f4                	je     801753 <strtol+0x16>
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	8a 00                	mov    (%eax),%al
  801764:	3c 09                	cmp    $0x9,%al
  801766:	74 eb                	je     801753 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	8a 00                	mov    (%eax),%al
  80176d:	3c 2b                	cmp    $0x2b,%al
  80176f:	75 05                	jne    801776 <strtol+0x39>
		s++;
  801771:	ff 45 08             	incl   0x8(%ebp)
  801774:	eb 13                	jmp    801789 <strtol+0x4c>
	else if (*s == '-')
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8a 00                	mov    (%eax),%al
  80177b:	3c 2d                	cmp    $0x2d,%al
  80177d:	75 0a                	jne    801789 <strtol+0x4c>
		s++, neg = 1;
  80177f:	ff 45 08             	incl   0x8(%ebp)
  801782:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801789:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80178d:	74 06                	je     801795 <strtol+0x58>
  80178f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801793:	75 20                	jne    8017b5 <strtol+0x78>
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	8a 00                	mov    (%eax),%al
  80179a:	3c 30                	cmp    $0x30,%al
  80179c:	75 17                	jne    8017b5 <strtol+0x78>
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	40                   	inc    %eax
  8017a2:	8a 00                	mov    (%eax),%al
  8017a4:	3c 78                	cmp    $0x78,%al
  8017a6:	75 0d                	jne    8017b5 <strtol+0x78>
		s += 2, base = 16;
  8017a8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017ac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017b3:	eb 28                	jmp    8017dd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b9:	75 15                	jne    8017d0 <strtol+0x93>
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	3c 30                	cmp    $0x30,%al
  8017c2:	75 0c                	jne    8017d0 <strtol+0x93>
		s++, base = 8;
  8017c4:	ff 45 08             	incl   0x8(%ebp)
  8017c7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017ce:	eb 0d                	jmp    8017dd <strtol+0xa0>
	else if (base == 0)
  8017d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d4:	75 07                	jne    8017dd <strtol+0xa0>
		base = 10;
  8017d6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	8a 00                	mov    (%eax),%al
  8017e2:	3c 2f                	cmp    $0x2f,%al
  8017e4:	7e 19                	jle    8017ff <strtol+0xc2>
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	8a 00                	mov    (%eax),%al
  8017eb:	3c 39                	cmp    $0x39,%al
  8017ed:	7f 10                	jg     8017ff <strtol+0xc2>
			dig = *s - '0';
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	8a 00                	mov    (%eax),%al
  8017f4:	0f be c0             	movsbl %al,%eax
  8017f7:	83 e8 30             	sub    $0x30,%eax
  8017fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017fd:	eb 42                	jmp    801841 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	8a 00                	mov    (%eax),%al
  801804:	3c 60                	cmp    $0x60,%al
  801806:	7e 19                	jle    801821 <strtol+0xe4>
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	8a 00                	mov    (%eax),%al
  80180d:	3c 7a                	cmp    $0x7a,%al
  80180f:	7f 10                	jg     801821 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	8a 00                	mov    (%eax),%al
  801816:	0f be c0             	movsbl %al,%eax
  801819:	83 e8 57             	sub    $0x57,%eax
  80181c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80181f:	eb 20                	jmp    801841 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	8a 00                	mov    (%eax),%al
  801826:	3c 40                	cmp    $0x40,%al
  801828:	7e 39                	jle    801863 <strtol+0x126>
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	8a 00                	mov    (%eax),%al
  80182f:	3c 5a                	cmp    $0x5a,%al
  801831:	7f 30                	jg     801863 <strtol+0x126>
			dig = *s - 'A' + 10;
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	8a 00                	mov    (%eax),%al
  801838:	0f be c0             	movsbl %al,%eax
  80183b:	83 e8 37             	sub    $0x37,%eax
  80183e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801844:	3b 45 10             	cmp    0x10(%ebp),%eax
  801847:	7d 19                	jge    801862 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801849:	ff 45 08             	incl   0x8(%ebp)
  80184c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801853:	89 c2                	mov    %eax,%edx
  801855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801858:	01 d0                	add    %edx,%eax
  80185a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80185d:	e9 7b ff ff ff       	jmp    8017dd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801862:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801863:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801867:	74 08                	je     801871 <strtol+0x134>
		*endptr = (char *) s;
  801869:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186c:	8b 55 08             	mov    0x8(%ebp),%edx
  80186f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801871:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801875:	74 07                	je     80187e <strtol+0x141>
  801877:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187a:	f7 d8                	neg    %eax
  80187c:	eb 03                	jmp    801881 <strtol+0x144>
  80187e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <ltostr>:

void
ltostr(long value, char *str)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801889:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801890:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801897:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80189b:	79 13                	jns    8018b0 <ltostr+0x2d>
	{
		neg = 1;
  80189d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018aa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018ad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018b8:	99                   	cltd   
  8018b9:	f7 f9                	idiv   %ecx
  8018bb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c1:	8d 50 01             	lea    0x1(%eax),%edx
  8018c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018c7:	89 c2                	mov    %eax,%edx
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	01 d0                	add    %edx,%eax
  8018ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018d1:	83 c2 30             	add    $0x30,%edx
  8018d4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018de:	f7 e9                	imul   %ecx
  8018e0:	c1 fa 02             	sar    $0x2,%edx
  8018e3:	89 c8                	mov    %ecx,%eax
  8018e5:	c1 f8 1f             	sar    $0x1f,%eax
  8018e8:	29 c2                	sub    %eax,%edx
  8018ea:	89 d0                	mov    %edx,%eax
  8018ec:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018f3:	75 bb                	jne    8018b0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ff:	48                   	dec    %eax
  801900:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801903:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801907:	74 3d                	je     801946 <ltostr+0xc3>
		start = 1 ;
  801909:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801910:	eb 34                	jmp    801946 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801912:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801915:	8b 45 0c             	mov    0xc(%ebp),%eax
  801918:	01 d0                	add    %edx,%eax
  80191a:	8a 00                	mov    (%eax),%al
  80191c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80191f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801922:	8b 45 0c             	mov    0xc(%ebp),%eax
  801925:	01 c2                	add    %eax,%edx
  801927:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80192a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192d:	01 c8                	add    %ecx,%eax
  80192f:	8a 00                	mov    (%eax),%al
  801931:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801933:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801936:	8b 45 0c             	mov    0xc(%ebp),%eax
  801939:	01 c2                	add    %eax,%edx
  80193b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80193e:	88 02                	mov    %al,(%edx)
		start++ ;
  801940:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801943:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801949:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80194c:	7c c4                	jl     801912 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80194e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801951:	8b 45 0c             	mov    0xc(%ebp),%eax
  801954:	01 d0                	add    %edx,%eax
  801956:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801959:	90                   	nop
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801962:	ff 75 08             	pushl  0x8(%ebp)
  801965:	e8 73 fa ff ff       	call   8013dd <strlen>
  80196a:	83 c4 04             	add    $0x4,%esp
  80196d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801970:	ff 75 0c             	pushl  0xc(%ebp)
  801973:	e8 65 fa ff ff       	call   8013dd <strlen>
  801978:	83 c4 04             	add    $0x4,%esp
  80197b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80197e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801985:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80198c:	eb 17                	jmp    8019a5 <strcconcat+0x49>
		final[s] = str1[s] ;
  80198e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801991:	8b 45 10             	mov    0x10(%ebp),%eax
  801994:	01 c2                	add    %eax,%edx
  801996:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	01 c8                	add    %ecx,%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019a2:	ff 45 fc             	incl   -0x4(%ebp)
  8019a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019ab:	7c e1                	jl     80198e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019bb:	eb 1f                	jmp    8019dc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c0:	8d 50 01             	lea    0x1(%eax),%edx
  8019c3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019c6:	89 c2                	mov    %eax,%edx
  8019c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cb:	01 c2                	add    %eax,%edx
  8019cd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d3:	01 c8                	add    %ecx,%eax
  8019d5:	8a 00                	mov    (%eax),%al
  8019d7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019d9:	ff 45 f8             	incl   -0x8(%ebp)
  8019dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019e2:	7c d9                	jl     8019bd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ea:	01 d0                	add    %edx,%eax
  8019ec:	c6 00 00             	movb   $0x0,(%eax)
}
  8019ef:	90                   	nop
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801a01:	8b 00                	mov    (%eax),%eax
  801a03:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0d:	01 d0                	add    %edx,%eax
  801a0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a15:	eb 0c                	jmp    801a23 <strsplit+0x31>
			*string++ = 0;
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	8d 50 01             	lea    0x1(%eax),%edx
  801a1d:	89 55 08             	mov    %edx,0x8(%ebp)
  801a20:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	8a 00                	mov    (%eax),%al
  801a28:	84 c0                	test   %al,%al
  801a2a:	74 18                	je     801a44 <strsplit+0x52>
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	8a 00                	mov    (%eax),%al
  801a31:	0f be c0             	movsbl %al,%eax
  801a34:	50                   	push   %eax
  801a35:	ff 75 0c             	pushl  0xc(%ebp)
  801a38:	e8 32 fb ff ff       	call   80156f <strchr>
  801a3d:	83 c4 08             	add    $0x8,%esp
  801a40:	85 c0                	test   %eax,%eax
  801a42:	75 d3                	jne    801a17 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8a 00                	mov    (%eax),%al
  801a49:	84 c0                	test   %al,%al
  801a4b:	74 5a                	je     801aa7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a50:	8b 00                	mov    (%eax),%eax
  801a52:	83 f8 0f             	cmp    $0xf,%eax
  801a55:	75 07                	jne    801a5e <strsplit+0x6c>
		{
			return 0;
  801a57:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5c:	eb 66                	jmp    801ac4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a5e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a61:	8b 00                	mov    (%eax),%eax
  801a63:	8d 48 01             	lea    0x1(%eax),%ecx
  801a66:	8b 55 14             	mov    0x14(%ebp),%edx
  801a69:	89 0a                	mov    %ecx,(%edx)
  801a6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a72:	8b 45 10             	mov    0x10(%ebp),%eax
  801a75:	01 c2                	add    %eax,%edx
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a7c:	eb 03                	jmp    801a81 <strsplit+0x8f>
			string++;
  801a7e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	84 c0                	test   %al,%al
  801a88:	74 8b                	je     801a15 <strsplit+0x23>
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	8a 00                	mov    (%eax),%al
  801a8f:	0f be c0             	movsbl %al,%eax
  801a92:	50                   	push   %eax
  801a93:	ff 75 0c             	pushl  0xc(%ebp)
  801a96:	e8 d4 fa ff ff       	call   80156f <strchr>
  801a9b:	83 c4 08             	add    $0x8,%esp
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	74 dc                	je     801a7e <strsplit+0x8c>
			string++;
	}
  801aa2:	e9 6e ff ff ff       	jmp    801a15 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801aa7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801aa8:	8b 45 14             	mov    0x14(%ebp),%eax
  801aab:	8b 00                	mov    (%eax),%eax
  801aad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ab4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab7:	01 d0                	add    %edx,%eax
  801ab9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801abf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801acc:	83 ec 04             	sub    $0x4,%esp
  801acf:	68 3c 2c 80 00       	push   $0x802c3c
  801ad4:	68 3f 01 00 00       	push   $0x13f
  801ad9:	68 5e 2c 80 00       	push   $0x802c5e
  801ade:	e8 a1 ed ff ff       	call   800884 <_panic>

00801ae3 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801ae9:	83 ec 0c             	sub    $0xc,%esp
  801aec:	ff 75 08             	pushl  0x8(%ebp)
  801aef:	e8 ef 06 00 00       	call   8021e3 <sys_sbrk>
  801af4:	83 c4 10             	add    $0x10,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801aff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b03:	75 07                	jne    801b0c <malloc+0x13>
  801b05:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0a:	eb 14                	jmp    801b20 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801b0c:	83 ec 04             	sub    $0x4,%esp
  801b0f:	68 6c 2c 80 00       	push   $0x802c6c
  801b14:	6a 1b                	push   $0x1b
  801b16:	68 91 2c 80 00       	push   $0x802c91
  801b1b:	e8 64 ed ff ff       	call   800884 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801b28:	83 ec 04             	sub    $0x4,%esp
  801b2b:	68 a0 2c 80 00       	push   $0x802ca0
  801b30:	6a 29                	push   $0x29
  801b32:	68 91 2c 80 00       	push   $0x802c91
  801b37:	e8 48 ed ff ff       	call   800884 <_panic>

00801b3c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	83 ec 18             	sub    $0x18,%esp
  801b42:	8b 45 10             	mov    0x10(%ebp),%eax
  801b45:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801b48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b4c:	75 07                	jne    801b55 <smalloc+0x19>
  801b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b53:	eb 14                	jmp    801b69 <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801b55:	83 ec 04             	sub    $0x4,%esp
  801b58:	68 c4 2c 80 00       	push   $0x802cc4
  801b5d:	6a 38                	push   $0x38
  801b5f:	68 91 2c 80 00       	push   $0x802c91
  801b64:	e8 1b ed ff ff       	call   800884 <_panic>
	return NULL;
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801b71:	83 ec 04             	sub    $0x4,%esp
  801b74:	68 ec 2c 80 00       	push   $0x802cec
  801b79:	6a 43                	push   $0x43
  801b7b:	68 91 2c 80 00       	push   $0x802c91
  801b80:	e8 ff ec ff ff       	call   800884 <_panic>

00801b85 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b8b:	83 ec 04             	sub    $0x4,%esp
  801b8e:	68 10 2d 80 00       	push   $0x802d10
  801b93:	6a 5b                	push   $0x5b
  801b95:	68 91 2c 80 00       	push   $0x802c91
  801b9a:	e8 e5 ec ff ff       	call   800884 <_panic>

00801b9f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ba5:	83 ec 04             	sub    $0x4,%esp
  801ba8:	68 34 2d 80 00       	push   $0x802d34
  801bad:	6a 72                	push   $0x72
  801baf:	68 91 2c 80 00       	push   $0x802c91
  801bb4:	e8 cb ec ff ff       	call   800884 <_panic>

00801bb9 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bbf:	83 ec 04             	sub    $0x4,%esp
  801bc2:	68 5a 2d 80 00       	push   $0x802d5a
  801bc7:	6a 7e                	push   $0x7e
  801bc9:	68 91 2c 80 00       	push   $0x802c91
  801bce:	e8 b1 ec ff ff       	call   800884 <_panic>

00801bd3 <shrink>:

}
void shrink(uint32 newSize)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bd9:	83 ec 04             	sub    $0x4,%esp
  801bdc:	68 5a 2d 80 00       	push   $0x802d5a
  801be1:	68 83 00 00 00       	push   $0x83
  801be6:	68 91 2c 80 00       	push   $0x802c91
  801beb:	e8 94 ec ff ff       	call   800884 <_panic>

00801bf0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	68 5a 2d 80 00       	push   $0x802d5a
  801bfe:	68 88 00 00 00       	push   $0x88
  801c03:	68 91 2c 80 00       	push   $0x802c91
  801c08:	e8 77 ec ff ff       	call   800884 <_panic>

00801c0d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	57                   	push   %edi
  801c11:	56                   	push   %esi
  801c12:	53                   	push   %ebx
  801c13:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c22:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c25:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c28:	cd 30                	int    $0x30
  801c2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c30:	83 c4 10             	add    $0x10,%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5e                   	pop    %esi
  801c35:	5f                   	pop    %edi
  801c36:	5d                   	pop    %ebp
  801c37:	c3                   	ret    

00801c38 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 04             	sub    $0x4,%esp
  801c3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c41:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c44:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	52                   	push   %edx
  801c50:	ff 75 0c             	pushl  0xc(%ebp)
  801c53:	50                   	push   %eax
  801c54:	6a 00                	push   $0x0
  801c56:	e8 b2 ff ff ff       	call   801c0d <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	90                   	nop
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 02                	push   $0x2
  801c70:	e8 98 ff ff ff       	call   801c0d <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_lock_cons>:

void sys_lock_cons(void)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 03                	push   $0x3
  801c89:	e8 7f ff ff ff       	call   801c0d <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	90                   	nop
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 04                	push   $0x4
  801ca3:	e8 65 ff ff ff       	call   801c0d <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	90                   	nop
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	52                   	push   %edx
  801cbe:	50                   	push   %eax
  801cbf:	6a 08                	push   $0x8
  801cc1:	e8 47 ff ff ff       	call   801c0d <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	56                   	push   %esi
  801ccf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cd0:	8b 75 18             	mov    0x18(%ebp),%esi
  801cd3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	56                   	push   %esi
  801ce0:	53                   	push   %ebx
  801ce1:	51                   	push   %ecx
  801ce2:	52                   	push   %edx
  801ce3:	50                   	push   %eax
  801ce4:	6a 09                	push   $0x9
  801ce6:	e8 22 ff ff ff       	call   801c0d <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
}
  801cee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf1:	5b                   	pop    %ebx
  801cf2:	5e                   	pop    %esi
  801cf3:	5d                   	pop    %ebp
  801cf4:	c3                   	ret    

00801cf5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	52                   	push   %edx
  801d05:	50                   	push   %eax
  801d06:	6a 0a                	push   $0xa
  801d08:	e8 00 ff ff ff       	call   801c0d <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	ff 75 0c             	pushl  0xc(%ebp)
  801d1e:	ff 75 08             	pushl  0x8(%ebp)
  801d21:	6a 0b                	push   $0xb
  801d23:	e8 e5 fe ff ff       	call   801c0d <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 0c                	push   $0xc
  801d3c:	e8 cc fe ff ff       	call   801c0d <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 0d                	push   $0xd
  801d55:	e8 b3 fe ff ff       	call   801c0d <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 0e                	push   $0xe
  801d6e:	e8 9a fe ff ff       	call   801c0d <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 0f                	push   $0xf
  801d87:	e8 81 fe ff ff       	call   801c0d <syscall>
  801d8c:	83 c4 18             	add    $0x18,%esp
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	6a 10                	push   $0x10
  801da1:	e8 67 fe ff ff       	call   801c0d <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_scarce_memory>:

void sys_scarce_memory()
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 11                	push   $0x11
  801dba:	e8 4e fe ff ff       	call   801c0d <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
}
  801dc2:	90                   	nop
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <sys_cputc>:

void
sys_cputc(const char c)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	83 ec 04             	sub    $0x4,%esp
  801dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801dd1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	50                   	push   %eax
  801dde:	6a 01                	push   $0x1
  801de0:	e8 28 fe ff ff       	call   801c0d <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
}
  801de8:	90                   	nop
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 14                	push   $0x14
  801dfa:	e8 0e fe ff ff       	call   801c0d <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	90                   	nop
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 04             	sub    $0x4,%esp
  801e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e11:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e14:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	6a 00                	push   $0x0
  801e1d:	51                   	push   %ecx
  801e1e:	52                   	push   %edx
  801e1f:	ff 75 0c             	pushl  0xc(%ebp)
  801e22:	50                   	push   %eax
  801e23:	6a 15                	push   $0x15
  801e25:	e8 e3 fd ff ff       	call   801c0d <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	52                   	push   %edx
  801e3f:	50                   	push   %eax
  801e40:	6a 16                	push   $0x16
  801e42:	e8 c6 fd ff ff       	call   801c0d <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	51                   	push   %ecx
  801e5d:	52                   	push   %edx
  801e5e:	50                   	push   %eax
  801e5f:	6a 17                	push   $0x17
  801e61:	e8 a7 fd ff ff       	call   801c0d <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	52                   	push   %edx
  801e7b:	50                   	push   %eax
  801e7c:	6a 18                	push   $0x18
  801e7e:	e8 8a fd ff ff       	call   801c0d <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	6a 00                	push   $0x0
  801e90:	ff 75 14             	pushl  0x14(%ebp)
  801e93:	ff 75 10             	pushl  0x10(%ebp)
  801e96:	ff 75 0c             	pushl  0xc(%ebp)
  801e99:	50                   	push   %eax
  801e9a:	6a 19                	push   $0x19
  801e9c:	e8 6c fd ff ff       	call   801c0d <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	50                   	push   %eax
  801eb5:	6a 1a                	push   $0x1a
  801eb7:	e8 51 fd ff ff       	call   801c0d <syscall>
  801ebc:	83 c4 18             	add    $0x18,%esp
}
  801ebf:	90                   	nop
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	50                   	push   %eax
  801ed1:	6a 1b                	push   $0x1b
  801ed3:	e8 35 fd ff ff       	call   801c0d <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sys_getenvid>:

int32 sys_getenvid(void)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 05                	push   $0x5
  801eec:	e8 1c fd ff ff       	call   801c0d <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 06                	push   $0x6
  801f05:	e8 03 fd ff ff       	call   801c0d <syscall>
  801f0a:	83 c4 18             	add    $0x18,%esp
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 07                	push   $0x7
  801f1e:	e8 ea fc ff ff       	call   801c0d <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <sys_exit_env>:


void sys_exit_env(void)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 1c                	push   $0x1c
  801f37:	e8 d1 fc ff ff       	call   801c0d <syscall>
  801f3c:	83 c4 18             	add    $0x18,%esp
}
  801f3f:	90                   	nop
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f48:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f4b:	8d 50 04             	lea    0x4(%eax),%edx
  801f4e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	52                   	push   %edx
  801f58:	50                   	push   %eax
  801f59:	6a 1d                	push   $0x1d
  801f5b:	e8 ad fc ff ff       	call   801c0d <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
	return result;
  801f63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f69:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f6c:	89 01                	mov    %eax,(%ecx)
  801f6e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	c9                   	leave  
  801f75:	c2 04 00             	ret    $0x4

00801f78 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	ff 75 10             	pushl  0x10(%ebp)
  801f82:	ff 75 0c             	pushl  0xc(%ebp)
  801f85:	ff 75 08             	pushl  0x8(%ebp)
  801f88:	6a 13                	push   $0x13
  801f8a:	e8 7e fc ff ff       	call   801c0d <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f92:	90                   	nop
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 1e                	push   $0x1e
  801fa4:	e8 64 fc ff ff       	call   801c0d <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 04             	sub    $0x4,%esp
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fba:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	50                   	push   %eax
  801fc7:	6a 1f                	push   $0x1f
  801fc9:	e8 3f fc ff ff       	call   801c0d <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd1:	90                   	nop
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <rsttst>:
void rsttst()
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 21                	push   $0x21
  801fe3:	e8 25 fc ff ff       	call   801c0d <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
	return ;
  801feb:	90                   	nop
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 04             	sub    $0x4,%esp
  801ff4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ffa:	8b 55 18             	mov    0x18(%ebp),%edx
  801ffd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802001:	52                   	push   %edx
  802002:	50                   	push   %eax
  802003:	ff 75 10             	pushl  0x10(%ebp)
  802006:	ff 75 0c             	pushl  0xc(%ebp)
  802009:	ff 75 08             	pushl  0x8(%ebp)
  80200c:	6a 20                	push   $0x20
  80200e:	e8 fa fb ff ff       	call   801c0d <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
	return ;
  802016:	90                   	nop
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <chktst>:
void chktst(uint32 n)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	ff 75 08             	pushl  0x8(%ebp)
  802027:	6a 22                	push   $0x22
  802029:	e8 df fb ff ff       	call   801c0d <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
	return ;
  802031:	90                   	nop
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <inctst>:

void inctst()
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 23                	push   $0x23
  802043:	e8 c5 fb ff ff       	call   801c0d <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
	return ;
  80204b:	90                   	nop
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <gettst>:
uint32 gettst()
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 24                	push   $0x24
  80205d:	e8 ab fb ff ff       	call   801c0d <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 25                	push   $0x25
  802079:	e8 8f fb ff ff       	call   801c0d <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
  802081:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802084:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802088:	75 07                	jne    802091 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80208a:	b8 01 00 00 00       	mov    $0x1,%eax
  80208f:	eb 05                	jmp    802096 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802091:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 25                	push   $0x25
  8020aa:	e8 5e fb ff ff       	call   801c0d <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
  8020b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020b5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020b9:	75 07                	jne    8020c2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c0:	eb 05                	jmp    8020c7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 25                	push   $0x25
  8020db:	e8 2d fb ff ff       	call   801c0d <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
  8020e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020e6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020ea:	75 07                	jne    8020f3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f1:	eb 05                	jmp    8020f8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 25                	push   $0x25
  80210c:	e8 fc fa ff ff       	call   801c0d <syscall>
  802111:	83 c4 18             	add    $0x18,%esp
  802114:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802117:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80211b:	75 07                	jne    802124 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80211d:	b8 01 00 00 00       	mov    $0x1,%eax
  802122:	eb 05                	jmp    802129 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802124:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	ff 75 08             	pushl  0x8(%ebp)
  802139:	6a 26                	push   $0x26
  80213b:	e8 cd fa ff ff       	call   801c0d <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
	return ;
  802143:	90                   	nop
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80214a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80214d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802150:	8b 55 0c             	mov    0xc(%ebp),%edx
  802153:	8b 45 08             	mov    0x8(%ebp),%eax
  802156:	6a 00                	push   $0x0
  802158:	53                   	push   %ebx
  802159:	51                   	push   %ecx
  80215a:	52                   	push   %edx
  80215b:	50                   	push   %eax
  80215c:	6a 27                	push   $0x27
  80215e:	e8 aa fa ff ff       	call   801c0d <syscall>
  802163:	83 c4 18             	add    $0x18,%esp
}
  802166:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80216e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	52                   	push   %edx
  80217b:	50                   	push   %eax
  80217c:	6a 28                	push   $0x28
  80217e:	e8 8a fa ff ff       	call   801c0d <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80218b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80218e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	6a 00                	push   $0x0
  802196:	51                   	push   %ecx
  802197:	ff 75 10             	pushl  0x10(%ebp)
  80219a:	52                   	push   %edx
  80219b:	50                   	push   %eax
  80219c:	6a 29                	push   $0x29
  80219e:	e8 6a fa ff ff       	call   801c0d <syscall>
  8021a3:	83 c4 18             	add    $0x18,%esp
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	ff 75 10             	pushl  0x10(%ebp)
  8021b2:	ff 75 0c             	pushl  0xc(%ebp)
  8021b5:	ff 75 08             	pushl  0x8(%ebp)
  8021b8:	6a 12                	push   $0x12
  8021ba:	e8 4e fa ff ff       	call   801c0d <syscall>
  8021bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c2:	90                   	nop
}
  8021c3:	c9                   	leave  
  8021c4:	c3                   	ret    

008021c5 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8021c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	52                   	push   %edx
  8021d5:	50                   	push   %eax
  8021d6:	6a 2a                	push   $0x2a
  8021d8:	e8 30 fa ff ff       	call   801c0d <syscall>
  8021dd:	83 c4 18             	add    $0x18,%esp
	return;
  8021e0:	90                   	nop
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8021e9:	83 ec 04             	sub    $0x4,%esp
  8021ec:	68 6a 2d 80 00       	push   $0x802d6a
  8021f1:	68 2e 01 00 00       	push   $0x12e
  8021f6:	68 7e 2d 80 00       	push   $0x802d7e
  8021fb:	e8 84 e6 ff ff       	call   800884 <_panic>

00802200 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802206:	83 ec 04             	sub    $0x4,%esp
  802209:	68 6a 2d 80 00       	push   $0x802d6a
  80220e:	68 35 01 00 00       	push   $0x135
  802213:	68 7e 2d 80 00       	push   $0x802d7e
  802218:	e8 67 e6 ff ff       	call   800884 <_panic>

0080221d <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
  802220:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802223:	83 ec 04             	sub    $0x4,%esp
  802226:	68 6a 2d 80 00       	push   $0x802d6a
  80222b:	68 3b 01 00 00       	push   $0x13b
  802230:	68 7e 2d 80 00       	push   $0x802d7e
  802235:	e8 4a e6 ff ff       	call   800884 <_panic>
  80223a:	66 90                	xchg   %ax,%ax

0080223c <__udivdi3>:
  80223c:	55                   	push   %ebp
  80223d:	57                   	push   %edi
  80223e:	56                   	push   %esi
  80223f:	53                   	push   %ebx
  802240:	83 ec 1c             	sub    $0x1c,%esp
  802243:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802247:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80224b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80224f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802253:	89 ca                	mov    %ecx,%edx
  802255:	89 f8                	mov    %edi,%eax
  802257:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80225b:	85 f6                	test   %esi,%esi
  80225d:	75 2d                	jne    80228c <__udivdi3+0x50>
  80225f:	39 cf                	cmp    %ecx,%edi
  802261:	77 65                	ja     8022c8 <__udivdi3+0x8c>
  802263:	89 fd                	mov    %edi,%ebp
  802265:	85 ff                	test   %edi,%edi
  802267:	75 0b                	jne    802274 <__udivdi3+0x38>
  802269:	b8 01 00 00 00       	mov    $0x1,%eax
  80226e:	31 d2                	xor    %edx,%edx
  802270:	f7 f7                	div    %edi
  802272:	89 c5                	mov    %eax,%ebp
  802274:	31 d2                	xor    %edx,%edx
  802276:	89 c8                	mov    %ecx,%eax
  802278:	f7 f5                	div    %ebp
  80227a:	89 c1                	mov    %eax,%ecx
  80227c:	89 d8                	mov    %ebx,%eax
  80227e:	f7 f5                	div    %ebp
  802280:	89 cf                	mov    %ecx,%edi
  802282:	89 fa                	mov    %edi,%edx
  802284:	83 c4 1c             	add    $0x1c,%esp
  802287:	5b                   	pop    %ebx
  802288:	5e                   	pop    %esi
  802289:	5f                   	pop    %edi
  80228a:	5d                   	pop    %ebp
  80228b:	c3                   	ret    
  80228c:	39 ce                	cmp    %ecx,%esi
  80228e:	77 28                	ja     8022b8 <__udivdi3+0x7c>
  802290:	0f bd fe             	bsr    %esi,%edi
  802293:	83 f7 1f             	xor    $0x1f,%edi
  802296:	75 40                	jne    8022d8 <__udivdi3+0x9c>
  802298:	39 ce                	cmp    %ecx,%esi
  80229a:	72 0a                	jb     8022a6 <__udivdi3+0x6a>
  80229c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8022a0:	0f 87 9e 00 00 00    	ja     802344 <__udivdi3+0x108>
  8022a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ab:	89 fa                	mov    %edi,%edx
  8022ad:	83 c4 1c             	add    $0x1c,%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5e                   	pop    %esi
  8022b2:	5f                   	pop    %edi
  8022b3:	5d                   	pop    %ebp
  8022b4:	c3                   	ret    
  8022b5:	8d 76 00             	lea    0x0(%esi),%esi
  8022b8:	31 ff                	xor    %edi,%edi
  8022ba:	31 c0                	xor    %eax,%eax
  8022bc:	89 fa                	mov    %edi,%edx
  8022be:	83 c4 1c             	add    $0x1c,%esp
  8022c1:	5b                   	pop    %ebx
  8022c2:	5e                   	pop    %esi
  8022c3:	5f                   	pop    %edi
  8022c4:	5d                   	pop    %ebp
  8022c5:	c3                   	ret    
  8022c6:	66 90                	xchg   %ax,%ax
  8022c8:	89 d8                	mov    %ebx,%eax
  8022ca:	f7 f7                	div    %edi
  8022cc:	31 ff                	xor    %edi,%edi
  8022ce:	89 fa                	mov    %edi,%edx
  8022d0:	83 c4 1c             	add    $0x1c,%esp
  8022d3:	5b                   	pop    %ebx
  8022d4:	5e                   	pop    %esi
  8022d5:	5f                   	pop    %edi
  8022d6:	5d                   	pop    %ebp
  8022d7:	c3                   	ret    
  8022d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8022dd:	89 eb                	mov    %ebp,%ebx
  8022df:	29 fb                	sub    %edi,%ebx
  8022e1:	89 f9                	mov    %edi,%ecx
  8022e3:	d3 e6                	shl    %cl,%esi
  8022e5:	89 c5                	mov    %eax,%ebp
  8022e7:	88 d9                	mov    %bl,%cl
  8022e9:	d3 ed                	shr    %cl,%ebp
  8022eb:	89 e9                	mov    %ebp,%ecx
  8022ed:	09 f1                	or     %esi,%ecx
  8022ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8022f3:	89 f9                	mov    %edi,%ecx
  8022f5:	d3 e0                	shl    %cl,%eax
  8022f7:	89 c5                	mov    %eax,%ebp
  8022f9:	89 d6                	mov    %edx,%esi
  8022fb:	88 d9                	mov    %bl,%cl
  8022fd:	d3 ee                	shr    %cl,%esi
  8022ff:	89 f9                	mov    %edi,%ecx
  802301:	d3 e2                	shl    %cl,%edx
  802303:	8b 44 24 08          	mov    0x8(%esp),%eax
  802307:	88 d9                	mov    %bl,%cl
  802309:	d3 e8                	shr    %cl,%eax
  80230b:	09 c2                	or     %eax,%edx
  80230d:	89 d0                	mov    %edx,%eax
  80230f:	89 f2                	mov    %esi,%edx
  802311:	f7 74 24 0c          	divl   0xc(%esp)
  802315:	89 d6                	mov    %edx,%esi
  802317:	89 c3                	mov    %eax,%ebx
  802319:	f7 e5                	mul    %ebp
  80231b:	39 d6                	cmp    %edx,%esi
  80231d:	72 19                	jb     802338 <__udivdi3+0xfc>
  80231f:	74 0b                	je     80232c <__udivdi3+0xf0>
  802321:	89 d8                	mov    %ebx,%eax
  802323:	31 ff                	xor    %edi,%edi
  802325:	e9 58 ff ff ff       	jmp    802282 <__udivdi3+0x46>
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802330:	89 f9                	mov    %edi,%ecx
  802332:	d3 e2                	shl    %cl,%edx
  802334:	39 c2                	cmp    %eax,%edx
  802336:	73 e9                	jae    802321 <__udivdi3+0xe5>
  802338:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80233b:	31 ff                	xor    %edi,%edi
  80233d:	e9 40 ff ff ff       	jmp    802282 <__udivdi3+0x46>
  802342:	66 90                	xchg   %ax,%ax
  802344:	31 c0                	xor    %eax,%eax
  802346:	e9 37 ff ff ff       	jmp    802282 <__udivdi3+0x46>
  80234b:	90                   	nop

0080234c <__umoddi3>:
  80234c:	55                   	push   %ebp
  80234d:	57                   	push   %edi
  80234e:	56                   	push   %esi
  80234f:	53                   	push   %ebx
  802350:	83 ec 1c             	sub    $0x1c,%esp
  802353:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802357:	8b 74 24 34          	mov    0x34(%esp),%esi
  80235b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80235f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802363:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802367:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80236b:	89 f3                	mov    %esi,%ebx
  80236d:	89 fa                	mov    %edi,%edx
  80236f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802373:	89 34 24             	mov    %esi,(%esp)
  802376:	85 c0                	test   %eax,%eax
  802378:	75 1a                	jne    802394 <__umoddi3+0x48>
  80237a:	39 f7                	cmp    %esi,%edi
  80237c:	0f 86 a2 00 00 00    	jbe    802424 <__umoddi3+0xd8>
  802382:	89 c8                	mov    %ecx,%eax
  802384:	89 f2                	mov    %esi,%edx
  802386:	f7 f7                	div    %edi
  802388:	89 d0                	mov    %edx,%eax
  80238a:	31 d2                	xor    %edx,%edx
  80238c:	83 c4 1c             	add    $0x1c,%esp
  80238f:	5b                   	pop    %ebx
  802390:	5e                   	pop    %esi
  802391:	5f                   	pop    %edi
  802392:	5d                   	pop    %ebp
  802393:	c3                   	ret    
  802394:	39 f0                	cmp    %esi,%eax
  802396:	0f 87 ac 00 00 00    	ja     802448 <__umoddi3+0xfc>
  80239c:	0f bd e8             	bsr    %eax,%ebp
  80239f:	83 f5 1f             	xor    $0x1f,%ebp
  8023a2:	0f 84 ac 00 00 00    	je     802454 <__umoddi3+0x108>
  8023a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8023ad:	29 ef                	sub    %ebp,%edi
  8023af:	89 fe                	mov    %edi,%esi
  8023b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023b5:	89 e9                	mov    %ebp,%ecx
  8023b7:	d3 e0                	shl    %cl,%eax
  8023b9:	89 d7                	mov    %edx,%edi
  8023bb:	89 f1                	mov    %esi,%ecx
  8023bd:	d3 ef                	shr    %cl,%edi
  8023bf:	09 c7                	or     %eax,%edi
  8023c1:	89 e9                	mov    %ebp,%ecx
  8023c3:	d3 e2                	shl    %cl,%edx
  8023c5:	89 14 24             	mov    %edx,(%esp)
  8023c8:	89 d8                	mov    %ebx,%eax
  8023ca:	d3 e0                	shl    %cl,%eax
  8023cc:	89 c2                	mov    %eax,%edx
  8023ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023d2:	d3 e0                	shl    %cl,%eax
  8023d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023dc:	89 f1                	mov    %esi,%ecx
  8023de:	d3 e8                	shr    %cl,%eax
  8023e0:	09 d0                	or     %edx,%eax
  8023e2:	d3 eb                	shr    %cl,%ebx
  8023e4:	89 da                	mov    %ebx,%edx
  8023e6:	f7 f7                	div    %edi
  8023e8:	89 d3                	mov    %edx,%ebx
  8023ea:	f7 24 24             	mull   (%esp)
  8023ed:	89 c6                	mov    %eax,%esi
  8023ef:	89 d1                	mov    %edx,%ecx
  8023f1:	39 d3                	cmp    %edx,%ebx
  8023f3:	0f 82 87 00 00 00    	jb     802480 <__umoddi3+0x134>
  8023f9:	0f 84 91 00 00 00    	je     802490 <__umoddi3+0x144>
  8023ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  802403:	29 f2                	sub    %esi,%edx
  802405:	19 cb                	sbb    %ecx,%ebx
  802407:	89 d8                	mov    %ebx,%eax
  802409:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80240d:	d3 e0                	shl    %cl,%eax
  80240f:	89 e9                	mov    %ebp,%ecx
  802411:	d3 ea                	shr    %cl,%edx
  802413:	09 d0                	or     %edx,%eax
  802415:	89 e9                	mov    %ebp,%ecx
  802417:	d3 eb                	shr    %cl,%ebx
  802419:	89 da                	mov    %ebx,%edx
  80241b:	83 c4 1c             	add    $0x1c,%esp
  80241e:	5b                   	pop    %ebx
  80241f:	5e                   	pop    %esi
  802420:	5f                   	pop    %edi
  802421:	5d                   	pop    %ebp
  802422:	c3                   	ret    
  802423:	90                   	nop
  802424:	89 fd                	mov    %edi,%ebp
  802426:	85 ff                	test   %edi,%edi
  802428:	75 0b                	jne    802435 <__umoddi3+0xe9>
  80242a:	b8 01 00 00 00       	mov    $0x1,%eax
  80242f:	31 d2                	xor    %edx,%edx
  802431:	f7 f7                	div    %edi
  802433:	89 c5                	mov    %eax,%ebp
  802435:	89 f0                	mov    %esi,%eax
  802437:	31 d2                	xor    %edx,%edx
  802439:	f7 f5                	div    %ebp
  80243b:	89 c8                	mov    %ecx,%eax
  80243d:	f7 f5                	div    %ebp
  80243f:	89 d0                	mov    %edx,%eax
  802441:	e9 44 ff ff ff       	jmp    80238a <__umoddi3+0x3e>
  802446:	66 90                	xchg   %ax,%ax
  802448:	89 c8                	mov    %ecx,%eax
  80244a:	89 f2                	mov    %esi,%edx
  80244c:	83 c4 1c             	add    $0x1c,%esp
  80244f:	5b                   	pop    %ebx
  802450:	5e                   	pop    %esi
  802451:	5f                   	pop    %edi
  802452:	5d                   	pop    %ebp
  802453:	c3                   	ret    
  802454:	3b 04 24             	cmp    (%esp),%eax
  802457:	72 06                	jb     80245f <__umoddi3+0x113>
  802459:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80245d:	77 0f                	ja     80246e <__umoddi3+0x122>
  80245f:	89 f2                	mov    %esi,%edx
  802461:	29 f9                	sub    %edi,%ecx
  802463:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802467:	89 14 24             	mov    %edx,(%esp)
  80246a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80246e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802472:	8b 14 24             	mov    (%esp),%edx
  802475:	83 c4 1c             	add    $0x1c,%esp
  802478:	5b                   	pop    %ebx
  802479:	5e                   	pop    %esi
  80247a:	5f                   	pop    %edi
  80247b:	5d                   	pop    %ebp
  80247c:	c3                   	ret    
  80247d:	8d 76 00             	lea    0x0(%esi),%esi
  802480:	2b 04 24             	sub    (%esp),%eax
  802483:	19 fa                	sbb    %edi,%edx
  802485:	89 d1                	mov    %edx,%ecx
  802487:	89 c6                	mov    %eax,%esi
  802489:	e9 71 ff ff ff       	jmp    8023ff <__umoddi3+0xb3>
  80248e:	66 90                	xchg   %ax,%ax
  802490:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802494:	72 ea                	jb     802480 <__umoddi3+0x134>
  802496:	89 d9                	mov    %ebx,%ecx
  802498:	e9 62 ff ff ff       	jmp    8023ff <__umoddi3+0xb3>
