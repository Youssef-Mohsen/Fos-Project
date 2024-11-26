
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
  800041:	e8 41 20 00 00       	call   802087 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 43 80 00       	push   $0x804340
  80004e:	e8 e0 0a 00 00       	call   800b33 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 43 80 00       	push   $0x804342
  80005e:	e8 d0 0a 00 00       	call   800b33 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 58 43 80 00       	push   $0x804358
  80006e:	e8 c0 0a 00 00       	call   800b33 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 43 80 00       	push   $0x804342
  80007e:	e8 b0 0a 00 00       	call   800b33 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 43 80 00       	push   $0x804340
  80008e:	e8 a0 0a 00 00       	call   800b33 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 70 43 80 00       	push   $0x804370
  8000a5:	e8 1d 11 00 00       	call   8011c7 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 6f 16 00 00       	call   80172f <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 16 1a 00 00       	call   801aeb <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 90 43 80 00       	push   $0x804390
  8000e3:	e8 4b 0a 00 00       	call   800b33 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 b2 43 80 00       	push   $0x8043b2
  8000f3:	e8 3b 0a 00 00       	call   800b33 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 c0 43 80 00       	push   $0x8043c0
  800103:	e8 2b 0a 00 00       	call   800b33 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 cf 43 80 00       	push   $0x8043cf
  800113:	e8 1b 0a 00 00       	call   800b33 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 df 43 80 00       	push   $0x8043df
  800123:	e8 0b 0a 00 00       	call   800b33 <cprintf>
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
  800162:	e8 3a 1f 00 00       	call   8020a1 <sys_unlock_cons>
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
  8001d7:	e8 ab 1e 00 00       	call   802087 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 e8 43 80 00       	push   $0x8043e8
  8001e4:	e8 4a 09 00 00       	call   800b33 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
			//PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ec:	e8 b0 1e 00 00       	call   8020a1 <sys_unlock_cons>
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
  80020e:	68 1c 44 80 00       	push   $0x80441c
  800213:	6a 51                	push   $0x51
  800215:	68 3e 44 80 00       	push   $0x80443e
  80021a:	e8 57 06 00 00       	call   800876 <_panic>
		else
		{
//			sys_lock_cons();
			sys_lock_cons();
  80021f:	e8 63 1e 00 00       	call   802087 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 58 44 80 00       	push   $0x804458
  80022c:	e8 02 09 00 00       	call   800b33 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 8c 44 80 00       	push   $0x80448c
  80023c:	e8 f2 08 00 00       	call   800b33 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 c0 44 80 00       	push   $0x8044c0
  80024c:	e8 e2 08 00 00       	call   800b33 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800254:	e8 48 1e 00 00       	call   8020a1 <sys_unlock_cons>
		}

		//free(Elements) ;

//		sys_lock_cons();
		sys_lock_cons();
  800259:	e8 29 1e 00 00       	call   802087 <sys_lock_cons>
		{
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 f2 44 80 00       	push   $0x8044f2
  80026c:	e8 c2 08 00 00       	call   800b33 <cprintf>
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
  8002b2:	e8 ea 1d 00 00       	call   8020a1 <sys_unlock_cons>
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
  800446:	68 40 43 80 00       	push   $0x804340
  80044b:	e8 e3 06 00 00       	call   800b33 <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 10 45 80 00       	push   $0x804510
  80046d:	e8 c1 06 00 00       	call   800b33 <cprintf>
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
  800496:	68 15 45 80 00       	push   $0x804515
  80049b:	e8 93 06 00 00       	call   800b33 <cprintf>
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
  80053c:	e8 aa 15 00 00       	call   801aeb <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 95 15 00 00       	call   801aeb <malloc>
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
  80070f:	e8 be 1a 00 00       	call   8021d2 <sys_cputc>
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
  800720:	e8 49 19 00 00       	call   80206e <sys_cgetc>
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
  80073d:	e8 c1 1b 00 00       	call   802303 <sys_getenvindex>
  800742:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800745:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800748:	89 d0                	mov    %edx,%eax
  80074a:	c1 e0 03             	shl    $0x3,%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800756:	01 c8                	add    %ecx,%eax
  800758:	01 c0                	add    %eax,%eax
  80075a:	01 d0                	add    %edx,%eax
  80075c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800763:	01 c8                	add    %ecx,%eax
  800765:	01 d0                	add    %edx,%eax
  800767:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80076c:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800771:	a1 24 50 80 00       	mov    0x805024,%eax
  800776:	8a 40 20             	mov    0x20(%eax),%al
  800779:	84 c0                	test   %al,%al
  80077b:	74 0d                	je     80078a <libmain+0x53>
		binaryname = myEnv->prog_name;
  80077d:	a1 24 50 80 00       	mov    0x805024,%eax
  800782:	83 c0 20             	add    $0x20,%eax
  800785:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80078a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80078e:	7e 0a                	jle    80079a <libmain+0x63>
		binaryname = argv[0];
  800790:	8b 45 0c             	mov    0xc(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	ff 75 08             	pushl  0x8(%ebp)
  8007a3:	e8 90 f8 ff ff       	call   800038 <_main>
  8007a8:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8007ab:	e8 d7 18 00 00       	call   802087 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8007b0:	83 ec 0c             	sub    $0xc,%esp
  8007b3:	68 34 45 80 00       	push   $0x804534
  8007b8:	e8 76 03 00 00       	call   800b33 <cprintf>
  8007bd:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007c0:	a1 24 50 80 00       	mov    0x805024,%eax
  8007c5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8007cb:	a1 24 50 80 00       	mov    0x805024,%eax
  8007d0:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8007d6:	83 ec 04             	sub    $0x4,%esp
  8007d9:	52                   	push   %edx
  8007da:	50                   	push   %eax
  8007db:	68 5c 45 80 00       	push   $0x80455c
  8007e0:	e8 4e 03 00 00       	call   800b33 <cprintf>
  8007e5:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007e8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007ed:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8007f3:	a1 24 50 80 00       	mov    0x805024,%eax
  8007f8:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8007fe:	a1 24 50 80 00       	mov    0x805024,%eax
  800803:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800809:	51                   	push   %ecx
  80080a:	52                   	push   %edx
  80080b:	50                   	push   %eax
  80080c:	68 84 45 80 00       	push   $0x804584
  800811:	e8 1d 03 00 00       	call   800b33 <cprintf>
  800816:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800819:	a1 24 50 80 00       	mov    0x805024,%eax
  80081e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	50                   	push   %eax
  800828:	68 dc 45 80 00       	push   $0x8045dc
  80082d:	e8 01 03 00 00       	call   800b33 <cprintf>
  800832:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800835:	83 ec 0c             	sub    $0xc,%esp
  800838:	68 34 45 80 00       	push   $0x804534
  80083d:	e8 f1 02 00 00       	call   800b33 <cprintf>
  800842:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800845:	e8 57 18 00 00       	call   8020a1 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80084a:	e8 19 00 00 00       	call   800868 <exit>
}
  80084f:	90                   	nop
  800850:	c9                   	leave  
  800851:	c3                   	ret    

00800852 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800858:	83 ec 0c             	sub    $0xc,%esp
  80085b:	6a 00                	push   $0x0
  80085d:	e8 6d 1a 00 00       	call   8022cf <sys_destroy_env>
  800862:	83 c4 10             	add    $0x10,%esp
}
  800865:	90                   	nop
  800866:	c9                   	leave  
  800867:	c3                   	ret    

00800868 <exit>:

void
exit(void)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80086e:	e8 c2 1a 00 00       	call   802335 <sys_exit_env>
}
  800873:	90                   	nop
  800874:	c9                   	leave  
  800875:	c3                   	ret    

00800876 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80087c:	8d 45 10             	lea    0x10(%ebp),%eax
  80087f:	83 c0 04             	add    $0x4,%eax
  800882:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800885:	a1 50 50 80 00       	mov    0x805050,%eax
  80088a:	85 c0                	test   %eax,%eax
  80088c:	74 16                	je     8008a4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80088e:	a1 50 50 80 00       	mov    0x805050,%eax
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	50                   	push   %eax
  800897:	68 f0 45 80 00       	push   $0x8045f0
  80089c:	e8 92 02 00 00       	call   800b33 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008a4:	a1 00 50 80 00       	mov    0x805000,%eax
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	ff 75 08             	pushl  0x8(%ebp)
  8008af:	50                   	push   %eax
  8008b0:	68 f5 45 80 00       	push   $0x8045f5
  8008b5:	e8 79 02 00 00       	call   800b33 <cprintf>
  8008ba:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c6:	50                   	push   %eax
  8008c7:	e8 fc 01 00 00       	call   800ac8 <vcprintf>
  8008cc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008cf:	83 ec 08             	sub    $0x8,%esp
  8008d2:	6a 00                	push   $0x0
  8008d4:	68 11 46 80 00       	push   $0x804611
  8008d9:	e8 ea 01 00 00       	call   800ac8 <vcprintf>
  8008de:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008e1:	e8 82 ff ff ff       	call   800868 <exit>

	// should not return here
	while (1) ;
  8008e6:	eb fe                	jmp    8008e6 <_panic+0x70>

008008e8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8008f3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8008f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fc:	39 c2                	cmp    %eax,%edx
  8008fe:	74 14                	je     800914 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800900:	83 ec 04             	sub    $0x4,%esp
  800903:	68 14 46 80 00       	push   $0x804614
  800908:	6a 26                	push   $0x26
  80090a:	68 60 46 80 00       	push   $0x804660
  80090f:	e8 62 ff ff ff       	call   800876 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800914:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80091b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800922:	e9 c5 00 00 00       	jmp    8009ec <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	01 d0                	add    %edx,%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	85 c0                	test   %eax,%eax
  80093a:	75 08                	jne    800944 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80093c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80093f:	e9 a5 00 00 00       	jmp    8009e9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800944:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80094b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800952:	eb 69                	jmp    8009bd <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800954:	a1 24 50 80 00       	mov    0x805024,%eax
  800959:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80095f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800962:	89 d0                	mov    %edx,%eax
  800964:	01 c0                	add    %eax,%eax
  800966:	01 d0                	add    %edx,%eax
  800968:	c1 e0 03             	shl    $0x3,%eax
  80096b:	01 c8                	add    %ecx,%eax
  80096d:	8a 40 04             	mov    0x4(%eax),%al
  800970:	84 c0                	test   %al,%al
  800972:	75 46                	jne    8009ba <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800974:	a1 24 50 80 00       	mov    0x805024,%eax
  800979:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80097f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800982:	89 d0                	mov    %edx,%eax
  800984:	01 c0                	add    %eax,%eax
  800986:	01 d0                	add    %edx,%eax
  800988:	c1 e0 03             	shl    $0x3,%eax
  80098b:	01 c8                	add    %ecx,%eax
  80098d:	8b 00                	mov    (%eax),%eax
  80098f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800992:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800995:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80099a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80099c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	01 c8                	add    %ecx,%eax
  8009ab:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ad:	39 c2                	cmp    %eax,%edx
  8009af:	75 09                	jne    8009ba <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8009b1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009b8:	eb 15                	jmp    8009cf <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009ba:	ff 45 e8             	incl   -0x18(%ebp)
  8009bd:	a1 24 50 80 00       	mov    0x805024,%eax
  8009c2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8009c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009cb:	39 c2                	cmp    %eax,%edx
  8009cd:	77 85                	ja     800954 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009d3:	75 14                	jne    8009e9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8009d5:	83 ec 04             	sub    $0x4,%esp
  8009d8:	68 6c 46 80 00       	push   $0x80466c
  8009dd:	6a 3a                	push   $0x3a
  8009df:	68 60 46 80 00       	push   $0x804660
  8009e4:	e8 8d fe ff ff       	call   800876 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009e9:	ff 45 f0             	incl   -0x10(%ebp)
  8009ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009f2:	0f 8c 2f ff ff ff    	jl     800927 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a06:	eb 26                	jmp    800a2e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a08:	a1 24 50 80 00       	mov    0x805024,%eax
  800a0d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800a13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a16:	89 d0                	mov    %edx,%eax
  800a18:	01 c0                	add    %eax,%eax
  800a1a:	01 d0                	add    %edx,%eax
  800a1c:	c1 e0 03             	shl    $0x3,%eax
  800a1f:	01 c8                	add    %ecx,%eax
  800a21:	8a 40 04             	mov    0x4(%eax),%al
  800a24:	3c 01                	cmp    $0x1,%al
  800a26:	75 03                	jne    800a2b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a28:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a2b:	ff 45 e0             	incl   -0x20(%ebp)
  800a2e:	a1 24 50 80 00       	mov    0x805024,%eax
  800a33:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800a39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3c:	39 c2                	cmp    %eax,%edx
  800a3e:	77 c8                	ja     800a08 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a43:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a46:	74 14                	je     800a5c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800a48:	83 ec 04             	sub    $0x4,%esp
  800a4b:	68 c0 46 80 00       	push   $0x8046c0
  800a50:	6a 44                	push   $0x44
  800a52:	68 60 46 80 00       	push   $0x804660
  800a57:	e8 1a fe ff ff       	call   800876 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a5c:	90                   	nop
  800a5d:	c9                   	leave  
  800a5e:	c3                   	ret    

00800a5f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a68:	8b 00                	mov    (%eax),%eax
  800a6a:	8d 48 01             	lea    0x1(%eax),%ecx
  800a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a70:	89 0a                	mov    %ecx,(%edx)
  800a72:	8b 55 08             	mov    0x8(%ebp),%edx
  800a75:	88 d1                	mov    %dl,%cl
  800a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a88:	75 2c                	jne    800ab6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a8a:	a0 2c 50 80 00       	mov    0x80502c,%al
  800a8f:	0f b6 c0             	movzbl %al,%eax
  800a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a95:	8b 12                	mov    (%edx),%edx
  800a97:	89 d1                	mov    %edx,%ecx
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	83 c2 08             	add    $0x8,%edx
  800a9f:	83 ec 04             	sub    $0x4,%esp
  800aa2:	50                   	push   %eax
  800aa3:	51                   	push   %ecx
  800aa4:	52                   	push   %edx
  800aa5:	e8 9b 15 00 00       	call   802045 <sys_cputs>
  800aaa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab9:	8b 40 04             	mov    0x4(%eax),%eax
  800abc:	8d 50 01             	lea    0x1(%eax),%edx
  800abf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac2:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ac5:	90                   	nop
  800ac6:	c9                   	leave  
  800ac7:	c3                   	ret    

00800ac8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ad1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ad8:	00 00 00 
	b.cnt = 0;
  800adb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ae2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	ff 75 08             	pushl  0x8(%ebp)
  800aeb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800af1:	50                   	push   %eax
  800af2:	68 5f 0a 80 00       	push   $0x800a5f
  800af7:	e8 11 02 00 00       	call   800d0d <vprintfmt>
  800afc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800aff:	a0 2c 50 80 00       	mov    0x80502c,%al
  800b04:	0f b6 c0             	movzbl %al,%eax
  800b07:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b0d:	83 ec 04             	sub    $0x4,%esp
  800b10:	50                   	push   %eax
  800b11:	52                   	push   %edx
  800b12:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b18:	83 c0 08             	add    $0x8,%eax
  800b1b:	50                   	push   %eax
  800b1c:	e8 24 15 00 00       	call   802045 <sys_cputs>
  800b21:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b24:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
	return b.cnt;
  800b2b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b31:	c9                   	leave  
  800b32:	c3                   	ret    

00800b33 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b39:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
	va_start(ap, fmt);
  800b40:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b4f:	50                   	push   %eax
  800b50:	e8 73 ff ff ff       	call   800ac8 <vcprintf>
  800b55:	83 c4 10             	add    $0x10,%esp
  800b58:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b5e:	c9                   	leave  
  800b5f:	c3                   	ret    

00800b60 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800b66:	e8 1c 15 00 00       	call   802087 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800b6b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	83 ec 08             	sub    $0x8,%esp
  800b77:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7a:	50                   	push   %eax
  800b7b:	e8 48 ff ff ff       	call   800ac8 <vcprintf>
  800b80:	83 c4 10             	add    $0x10,%esp
  800b83:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800b86:	e8 16 15 00 00       	call   8020a1 <sys_unlock_cons>
	return cnt;
  800b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b8e:	c9                   	leave  
  800b8f:	c3                   	ret    

00800b90 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	53                   	push   %ebx
  800b94:	83 ec 14             	sub    $0x14,%esp
  800b97:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ba3:	8b 45 18             	mov    0x18(%ebp),%eax
  800ba6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bab:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bae:	77 55                	ja     800c05 <printnum+0x75>
  800bb0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bb3:	72 05                	jb     800bba <printnum+0x2a>
  800bb5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bb8:	77 4b                	ja     800c05 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bba:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bbd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bc0:	8b 45 18             	mov    0x18(%ebp),%eax
  800bc3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc8:	52                   	push   %edx
  800bc9:	50                   	push   %eax
  800bca:	ff 75 f4             	pushl  -0xc(%ebp)
  800bcd:	ff 75 f0             	pushl  -0x10(%ebp)
  800bd0:	e8 07 35 00 00       	call   8040dc <__udivdi3>
  800bd5:	83 c4 10             	add    $0x10,%esp
  800bd8:	83 ec 04             	sub    $0x4,%esp
  800bdb:	ff 75 20             	pushl  0x20(%ebp)
  800bde:	53                   	push   %ebx
  800bdf:	ff 75 18             	pushl  0x18(%ebp)
  800be2:	52                   	push   %edx
  800be3:	50                   	push   %eax
  800be4:	ff 75 0c             	pushl  0xc(%ebp)
  800be7:	ff 75 08             	pushl  0x8(%ebp)
  800bea:	e8 a1 ff ff ff       	call   800b90 <printnum>
  800bef:	83 c4 20             	add    $0x20,%esp
  800bf2:	eb 1a                	jmp    800c0e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bf4:	83 ec 08             	sub    $0x8,%esp
  800bf7:	ff 75 0c             	pushl  0xc(%ebp)
  800bfa:	ff 75 20             	pushl  0x20(%ebp)
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	ff d0                	call   *%eax
  800c02:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c05:	ff 4d 1c             	decl   0x1c(%ebp)
  800c08:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c0c:	7f e6                	jg     800bf4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c0e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c11:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1c:	53                   	push   %ebx
  800c1d:	51                   	push   %ecx
  800c1e:	52                   	push   %edx
  800c1f:	50                   	push   %eax
  800c20:	e8 c7 35 00 00       	call   8041ec <__umoddi3>
  800c25:	83 c4 10             	add    $0x10,%esp
  800c28:	05 34 49 80 00       	add    $0x804934,%eax
  800c2d:	8a 00                	mov    (%eax),%al
  800c2f:	0f be c0             	movsbl %al,%eax
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	50                   	push   %eax
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	ff d0                	call   *%eax
  800c3e:	83 c4 10             	add    $0x10,%esp
}
  800c41:	90                   	nop
  800c42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c45:	c9                   	leave  
  800c46:	c3                   	ret    

00800c47 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c4a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c4e:	7e 1c                	jle    800c6c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	8b 00                	mov    (%eax),%eax
  800c55:	8d 50 08             	lea    0x8(%eax),%edx
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	89 10                	mov    %edx,(%eax)
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	8b 00                	mov    (%eax),%eax
  800c62:	83 e8 08             	sub    $0x8,%eax
  800c65:	8b 50 04             	mov    0x4(%eax),%edx
  800c68:	8b 00                	mov    (%eax),%eax
  800c6a:	eb 40                	jmp    800cac <getuint+0x65>
	else if (lflag)
  800c6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c70:	74 1e                	je     800c90 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 00                	mov    (%eax),%eax
  800c77:	8d 50 04             	lea    0x4(%eax),%edx
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	89 10                	mov    %edx,(%eax)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8b 00                	mov    (%eax),%eax
  800c84:	83 e8 04             	sub    $0x4,%eax
  800c87:	8b 00                	mov    (%eax),%eax
  800c89:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8e:	eb 1c                	jmp    800cac <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	8d 50 04             	lea    0x4(%eax),%edx
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	89 10                	mov    %edx,(%eax)
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8b 00                	mov    (%eax),%eax
  800ca2:	83 e8 04             	sub    $0x4,%eax
  800ca5:	8b 00                	mov    (%eax),%eax
  800ca7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    

00800cae <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cb1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cb5:	7e 1c                	jle    800cd3 <getint+0x25>
		return va_arg(*ap, long long);
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	8b 00                	mov    (%eax),%eax
  800cbc:	8d 50 08             	lea    0x8(%eax),%edx
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	89 10                	mov    %edx,(%eax)
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8b 00                	mov    (%eax),%eax
  800cc9:	83 e8 08             	sub    $0x8,%eax
  800ccc:	8b 50 04             	mov    0x4(%eax),%edx
  800ccf:	8b 00                	mov    (%eax),%eax
  800cd1:	eb 38                	jmp    800d0b <getint+0x5d>
	else if (lflag)
  800cd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd7:	74 1a                	je     800cf3 <getint+0x45>
		return va_arg(*ap, long);
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8b 00                	mov    (%eax),%eax
  800cde:	8d 50 04             	lea    0x4(%eax),%edx
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	89 10                	mov    %edx,(%eax)
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8b 00                	mov    (%eax),%eax
  800ceb:	83 e8 04             	sub    $0x4,%eax
  800cee:	8b 00                	mov    (%eax),%eax
  800cf0:	99                   	cltd   
  800cf1:	eb 18                	jmp    800d0b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8b 00                	mov    (%eax),%eax
  800cf8:	8d 50 04             	lea    0x4(%eax),%edx
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	89 10                	mov    %edx,(%eax)
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8b 00                	mov    (%eax),%eax
  800d05:	83 e8 04             	sub    $0x4,%eax
  800d08:	8b 00                	mov    (%eax),%eax
  800d0a:	99                   	cltd   
}
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    

00800d0d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	56                   	push   %esi
  800d11:	53                   	push   %ebx
  800d12:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d15:	eb 17                	jmp    800d2e <vprintfmt+0x21>
			if (ch == '\0')
  800d17:	85 db                	test   %ebx,%ebx
  800d19:	0f 84 c1 03 00 00    	je     8010e0 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800d1f:	83 ec 08             	sub    $0x8,%esp
  800d22:	ff 75 0c             	pushl  0xc(%ebp)
  800d25:	53                   	push   %ebx
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	ff d0                	call   *%eax
  800d2b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d31:	8d 50 01             	lea    0x1(%eax),%edx
  800d34:	89 55 10             	mov    %edx,0x10(%ebp)
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f b6 d8             	movzbl %al,%ebx
  800d3c:	83 fb 25             	cmp    $0x25,%ebx
  800d3f:	75 d6                	jne    800d17 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d41:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d45:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d4c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d53:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d5a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d61:	8b 45 10             	mov    0x10(%ebp),%eax
  800d64:	8d 50 01             	lea    0x1(%eax),%edx
  800d67:	89 55 10             	mov    %edx,0x10(%ebp)
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	0f b6 d8             	movzbl %al,%ebx
  800d6f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d72:	83 f8 5b             	cmp    $0x5b,%eax
  800d75:	0f 87 3d 03 00 00    	ja     8010b8 <vprintfmt+0x3ab>
  800d7b:	8b 04 85 58 49 80 00 	mov    0x804958(,%eax,4),%eax
  800d82:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d84:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d88:	eb d7                	jmp    800d61 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d8a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d8e:	eb d1                	jmp    800d61 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d90:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d97:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d9a:	89 d0                	mov    %edx,%eax
  800d9c:	c1 e0 02             	shl    $0x2,%eax
  800d9f:	01 d0                	add    %edx,%eax
  800da1:	01 c0                	add    %eax,%eax
  800da3:	01 d8                	add    %ebx,%eax
  800da5:	83 e8 30             	sub    $0x30,%eax
  800da8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dab:	8b 45 10             	mov    0x10(%ebp),%eax
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800db3:	83 fb 2f             	cmp    $0x2f,%ebx
  800db6:	7e 3e                	jle    800df6 <vprintfmt+0xe9>
  800db8:	83 fb 39             	cmp    $0x39,%ebx
  800dbb:	7f 39                	jg     800df6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dbd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dc0:	eb d5                	jmp    800d97 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800dc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc5:	83 c0 04             	add    $0x4,%eax
  800dc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800dcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dce:	83 e8 04             	sub    $0x4,%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800dd6:	eb 1f                	jmp    800df7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800dd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ddc:	79 83                	jns    800d61 <vprintfmt+0x54>
				width = 0;
  800dde:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800de5:	e9 77 ff ff ff       	jmp    800d61 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800dea:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800df1:	e9 6b ff ff ff       	jmp    800d61 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800df6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800df7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfb:	0f 89 60 ff ff ff    	jns    800d61 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e07:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e0e:	e9 4e ff ff ff       	jmp    800d61 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e13:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e16:	e9 46 ff ff ff       	jmp    800d61 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1e:	83 c0 04             	add    $0x4,%eax
  800e21:	89 45 14             	mov    %eax,0x14(%ebp)
  800e24:	8b 45 14             	mov    0x14(%ebp),%eax
  800e27:	83 e8 04             	sub    $0x4,%eax
  800e2a:	8b 00                	mov    (%eax),%eax
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	50                   	push   %eax
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	ff d0                	call   *%eax
  800e38:	83 c4 10             	add    $0x10,%esp
			break;
  800e3b:	e9 9b 02 00 00       	jmp    8010db <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e40:	8b 45 14             	mov    0x14(%ebp),%eax
  800e43:	83 c0 04             	add    $0x4,%eax
  800e46:	89 45 14             	mov    %eax,0x14(%ebp)
  800e49:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4c:	83 e8 04             	sub    $0x4,%eax
  800e4f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e51:	85 db                	test   %ebx,%ebx
  800e53:	79 02                	jns    800e57 <vprintfmt+0x14a>
				err = -err;
  800e55:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e57:	83 fb 64             	cmp    $0x64,%ebx
  800e5a:	7f 0b                	jg     800e67 <vprintfmt+0x15a>
  800e5c:	8b 34 9d a0 47 80 00 	mov    0x8047a0(,%ebx,4),%esi
  800e63:	85 f6                	test   %esi,%esi
  800e65:	75 19                	jne    800e80 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e67:	53                   	push   %ebx
  800e68:	68 45 49 80 00       	push   $0x804945
  800e6d:	ff 75 0c             	pushl  0xc(%ebp)
  800e70:	ff 75 08             	pushl  0x8(%ebp)
  800e73:	e8 70 02 00 00       	call   8010e8 <printfmt>
  800e78:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e7b:	e9 5b 02 00 00       	jmp    8010db <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e80:	56                   	push   %esi
  800e81:	68 4e 49 80 00       	push   $0x80494e
  800e86:	ff 75 0c             	pushl  0xc(%ebp)
  800e89:	ff 75 08             	pushl  0x8(%ebp)
  800e8c:	e8 57 02 00 00       	call   8010e8 <printfmt>
  800e91:	83 c4 10             	add    $0x10,%esp
			break;
  800e94:	e9 42 02 00 00       	jmp    8010db <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e99:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9c:	83 c0 04             	add    $0x4,%eax
  800e9f:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea5:	83 e8 04             	sub    $0x4,%eax
  800ea8:	8b 30                	mov    (%eax),%esi
  800eaa:	85 f6                	test   %esi,%esi
  800eac:	75 05                	jne    800eb3 <vprintfmt+0x1a6>
				p = "(null)";
  800eae:	be 51 49 80 00       	mov    $0x804951,%esi
			if (width > 0 && padc != '-')
  800eb3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eb7:	7e 6d                	jle    800f26 <vprintfmt+0x219>
  800eb9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ebd:	74 67                	je     800f26 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	50                   	push   %eax
  800ec6:	56                   	push   %esi
  800ec7:	e8 26 05 00 00       	call   8013f2 <strnlen>
  800ecc:	83 c4 10             	add    $0x10,%esp
  800ecf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ed2:	eb 16                	jmp    800eea <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ed4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ed8:	83 ec 08             	sub    $0x8,%esp
  800edb:	ff 75 0c             	pushl  0xc(%ebp)
  800ede:	50                   	push   %eax
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	ff d0                	call   *%eax
  800ee4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ee7:	ff 4d e4             	decl   -0x1c(%ebp)
  800eea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eee:	7f e4                	jg     800ed4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ef0:	eb 34                	jmp    800f26 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ef2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ef6:	74 1c                	je     800f14 <vprintfmt+0x207>
  800ef8:	83 fb 1f             	cmp    $0x1f,%ebx
  800efb:	7e 05                	jle    800f02 <vprintfmt+0x1f5>
  800efd:	83 fb 7e             	cmp    $0x7e,%ebx
  800f00:	7e 12                	jle    800f14 <vprintfmt+0x207>
					putch('?', putdat);
  800f02:	83 ec 08             	sub    $0x8,%esp
  800f05:	ff 75 0c             	pushl  0xc(%ebp)
  800f08:	6a 3f                	push   $0x3f
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	ff d0                	call   *%eax
  800f0f:	83 c4 10             	add    $0x10,%esp
  800f12:	eb 0f                	jmp    800f23 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	ff 75 0c             	pushl  0xc(%ebp)
  800f1a:	53                   	push   %ebx
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	ff d0                	call   *%eax
  800f20:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f23:	ff 4d e4             	decl   -0x1c(%ebp)
  800f26:	89 f0                	mov    %esi,%eax
  800f28:	8d 70 01             	lea    0x1(%eax),%esi
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	0f be d8             	movsbl %al,%ebx
  800f30:	85 db                	test   %ebx,%ebx
  800f32:	74 24                	je     800f58 <vprintfmt+0x24b>
  800f34:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f38:	78 b8                	js     800ef2 <vprintfmt+0x1e5>
  800f3a:	ff 4d e0             	decl   -0x20(%ebp)
  800f3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f41:	79 af                	jns    800ef2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f43:	eb 13                	jmp    800f58 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f45:	83 ec 08             	sub    $0x8,%esp
  800f48:	ff 75 0c             	pushl  0xc(%ebp)
  800f4b:	6a 20                	push   $0x20
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	ff d0                	call   *%eax
  800f52:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f55:	ff 4d e4             	decl   -0x1c(%ebp)
  800f58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f5c:	7f e7                	jg     800f45 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f5e:	e9 78 01 00 00       	jmp    8010db <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 e8             	pushl  -0x18(%ebp)
  800f69:	8d 45 14             	lea    0x14(%ebp),%eax
  800f6c:	50                   	push   %eax
  800f6d:	e8 3c fd ff ff       	call   800cae <getint>
  800f72:	83 c4 10             	add    $0x10,%esp
  800f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f78:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f81:	85 d2                	test   %edx,%edx
  800f83:	79 23                	jns    800fa8 <vprintfmt+0x29b>
				putch('-', putdat);
  800f85:	83 ec 08             	sub    $0x8,%esp
  800f88:	ff 75 0c             	pushl  0xc(%ebp)
  800f8b:	6a 2d                	push   $0x2d
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	ff d0                	call   *%eax
  800f92:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9b:	f7 d8                	neg    %eax
  800f9d:	83 d2 00             	adc    $0x0,%edx
  800fa0:	f7 da                	neg    %edx
  800fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fa8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800faf:	e9 bc 00 00 00       	jmp    801070 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fb4:	83 ec 08             	sub    $0x8,%esp
  800fb7:	ff 75 e8             	pushl  -0x18(%ebp)
  800fba:	8d 45 14             	lea    0x14(%ebp),%eax
  800fbd:	50                   	push   %eax
  800fbe:	e8 84 fc ff ff       	call   800c47 <getuint>
  800fc3:	83 c4 10             	add    $0x10,%esp
  800fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fcc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fd3:	e9 98 00 00 00       	jmp    801070 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800fd8:	83 ec 08             	sub    $0x8,%esp
  800fdb:	ff 75 0c             	pushl  0xc(%ebp)
  800fde:	6a 58                	push   $0x58
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	ff d0                	call   *%eax
  800fe5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fe8:	83 ec 08             	sub    $0x8,%esp
  800feb:	ff 75 0c             	pushl  0xc(%ebp)
  800fee:	6a 58                	push   $0x58
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	ff d0                	call   *%eax
  800ff5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ff8:	83 ec 08             	sub    $0x8,%esp
  800ffb:	ff 75 0c             	pushl  0xc(%ebp)
  800ffe:	6a 58                	push   $0x58
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	ff d0                	call   *%eax
  801005:	83 c4 10             	add    $0x10,%esp
			break;
  801008:	e9 ce 00 00 00       	jmp    8010db <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80100d:	83 ec 08             	sub    $0x8,%esp
  801010:	ff 75 0c             	pushl  0xc(%ebp)
  801013:	6a 30                	push   $0x30
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	ff d0                	call   *%eax
  80101a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80101d:	83 ec 08             	sub    $0x8,%esp
  801020:	ff 75 0c             	pushl  0xc(%ebp)
  801023:	6a 78                	push   $0x78
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	ff d0                	call   *%eax
  80102a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80102d:	8b 45 14             	mov    0x14(%ebp),%eax
  801030:	83 c0 04             	add    $0x4,%eax
  801033:	89 45 14             	mov    %eax,0x14(%ebp)
  801036:	8b 45 14             	mov    0x14(%ebp),%eax
  801039:	83 e8 04             	sub    $0x4,%eax
  80103c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80103e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801048:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80104f:	eb 1f                	jmp    801070 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801051:	83 ec 08             	sub    $0x8,%esp
  801054:	ff 75 e8             	pushl  -0x18(%ebp)
  801057:	8d 45 14             	lea    0x14(%ebp),%eax
  80105a:	50                   	push   %eax
  80105b:	e8 e7 fb ff ff       	call   800c47 <getuint>
  801060:	83 c4 10             	add    $0x10,%esp
  801063:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801066:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801069:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801070:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801074:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801077:	83 ec 04             	sub    $0x4,%esp
  80107a:	52                   	push   %edx
  80107b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80107e:	50                   	push   %eax
  80107f:	ff 75 f4             	pushl  -0xc(%ebp)
  801082:	ff 75 f0             	pushl  -0x10(%ebp)
  801085:	ff 75 0c             	pushl  0xc(%ebp)
  801088:	ff 75 08             	pushl  0x8(%ebp)
  80108b:	e8 00 fb ff ff       	call   800b90 <printnum>
  801090:	83 c4 20             	add    $0x20,%esp
			break;
  801093:	eb 46                	jmp    8010db <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801095:	83 ec 08             	sub    $0x8,%esp
  801098:	ff 75 0c             	pushl  0xc(%ebp)
  80109b:	53                   	push   %ebx
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	ff d0                	call   *%eax
  8010a1:	83 c4 10             	add    $0x10,%esp
			break;
  8010a4:	eb 35                	jmp    8010db <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8010a6:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  8010ad:	eb 2c                	jmp    8010db <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8010af:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
			break;
  8010b6:	eb 23                	jmp    8010db <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010b8:	83 ec 08             	sub    $0x8,%esp
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	6a 25                	push   $0x25
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	ff d0                	call   *%eax
  8010c5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010c8:	ff 4d 10             	decl   0x10(%ebp)
  8010cb:	eb 03                	jmp    8010d0 <vprintfmt+0x3c3>
  8010cd:	ff 4d 10             	decl   0x10(%ebp)
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	48                   	dec    %eax
  8010d4:	8a 00                	mov    (%eax),%al
  8010d6:	3c 25                	cmp    $0x25,%al
  8010d8:	75 f3                	jne    8010cd <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8010da:	90                   	nop
		}
	}
  8010db:	e9 35 fc ff ff       	jmp    800d15 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010e0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010e4:	5b                   	pop    %ebx
  8010e5:	5e                   	pop    %esi
  8010e6:	5d                   	pop    %ebp
  8010e7:	c3                   	ret    

008010e8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010ee:	8d 45 10             	lea    0x10(%ebp),%eax
  8010f1:	83 c0 04             	add    $0x4,%eax
  8010f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8010fd:	50                   	push   %eax
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	ff 75 08             	pushl  0x8(%ebp)
  801104:	e8 04 fc ff ff       	call   800d0d <vprintfmt>
  801109:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80110c:	90                   	nop
  80110d:	c9                   	leave  
  80110e:	c3                   	ret    

0080110f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	8b 40 08             	mov    0x8(%eax),%eax
  801118:	8d 50 01             	lea    0x1(%eax),%edx
  80111b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801121:	8b 45 0c             	mov    0xc(%ebp),%eax
  801124:	8b 10                	mov    (%eax),%edx
  801126:	8b 45 0c             	mov    0xc(%ebp),%eax
  801129:	8b 40 04             	mov    0x4(%eax),%eax
  80112c:	39 c2                	cmp    %eax,%edx
  80112e:	73 12                	jae    801142 <sprintputch+0x33>
		*b->buf++ = ch;
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	8b 00                	mov    (%eax),%eax
  801135:	8d 48 01             	lea    0x1(%eax),%ecx
  801138:	8b 55 0c             	mov    0xc(%ebp),%edx
  80113b:	89 0a                	mov    %ecx,(%edx)
  80113d:	8b 55 08             	mov    0x8(%ebp),%edx
  801140:	88 10                	mov    %dl,(%eax)
}
  801142:	90                   	nop
  801143:	5d                   	pop    %ebp
  801144:	c3                   	ret    

00801145 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801151:	8b 45 0c             	mov    0xc(%ebp),%eax
  801154:	8d 50 ff             	lea    -0x1(%eax),%edx
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	01 d0                	add    %edx,%eax
  80115c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80115f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801166:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80116a:	74 06                	je     801172 <vsnprintf+0x2d>
  80116c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801170:	7f 07                	jg     801179 <vsnprintf+0x34>
		return -E_INVAL;
  801172:	b8 03 00 00 00       	mov    $0x3,%eax
  801177:	eb 20                	jmp    801199 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801179:	ff 75 14             	pushl  0x14(%ebp)
  80117c:	ff 75 10             	pushl  0x10(%ebp)
  80117f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801182:	50                   	push   %eax
  801183:	68 0f 11 80 00       	push   $0x80110f
  801188:	e8 80 fb ff ff       	call   800d0d <vprintfmt>
  80118d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801190:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801193:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801196:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8011a4:	83 c0 04             	add    $0x4,%eax
  8011a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b0:	50                   	push   %eax
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	ff 75 08             	pushl  0x8(%ebp)
  8011b7:	e8 89 ff ff ff       	call   801145 <vsnprintf>
  8011bc:	83 c4 10             	add    $0x10,%esp
  8011bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8011cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d1:	74 13                	je     8011e6 <readline+0x1f>
		cprintf("%s", prompt);
  8011d3:	83 ec 08             	sub    $0x8,%esp
  8011d6:	ff 75 08             	pushl  0x8(%ebp)
  8011d9:	68 c8 4a 80 00       	push   $0x804ac8
  8011de:	e8 50 f9 ff ff       	call   800b33 <cprintf>
  8011e3:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011ed:	83 ec 0c             	sub    $0xc,%esp
  8011f0:	6a 00                	push   $0x0
  8011f2:	e8 36 f5 ff ff       	call   80072d <iscons>
  8011f7:	83 c4 10             	add    $0x10,%esp
  8011fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011fd:	e8 18 f5 ff ff       	call   80071a <getchar>
  801202:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801205:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801209:	79 22                	jns    80122d <readline+0x66>
			if (c != -E_EOF)
  80120b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80120f:	0f 84 ad 00 00 00    	je     8012c2 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801215:	83 ec 08             	sub    $0x8,%esp
  801218:	ff 75 ec             	pushl  -0x14(%ebp)
  80121b:	68 cb 4a 80 00       	push   $0x804acb
  801220:	e8 0e f9 ff ff       	call   800b33 <cprintf>
  801225:	83 c4 10             	add    $0x10,%esp
			break;
  801228:	e9 95 00 00 00       	jmp    8012c2 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80122d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801231:	7e 34                	jle    801267 <readline+0xa0>
  801233:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80123a:	7f 2b                	jg     801267 <readline+0xa0>
			if (echoing)
  80123c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801240:	74 0e                	je     801250 <readline+0x89>
				cputchar(c);
  801242:	83 ec 0c             	sub    $0xc,%esp
  801245:	ff 75 ec             	pushl  -0x14(%ebp)
  801248:	e8 ae f4 ff ff       	call   8006fb <cputchar>
  80124d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801253:	8d 50 01             	lea    0x1(%eax),%edx
  801256:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801259:	89 c2                	mov    %eax,%edx
  80125b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125e:	01 d0                	add    %edx,%eax
  801260:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801263:	88 10                	mov    %dl,(%eax)
  801265:	eb 56                	jmp    8012bd <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801267:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80126b:	75 1f                	jne    80128c <readline+0xc5>
  80126d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801271:	7e 19                	jle    80128c <readline+0xc5>
			if (echoing)
  801273:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801277:	74 0e                	je     801287 <readline+0xc0>
				cputchar(c);
  801279:	83 ec 0c             	sub    $0xc,%esp
  80127c:	ff 75 ec             	pushl  -0x14(%ebp)
  80127f:	e8 77 f4 ff ff       	call   8006fb <cputchar>
  801284:	83 c4 10             	add    $0x10,%esp

			i--;
  801287:	ff 4d f4             	decl   -0xc(%ebp)
  80128a:	eb 31                	jmp    8012bd <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80128c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801290:	74 0a                	je     80129c <readline+0xd5>
  801292:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801296:	0f 85 61 ff ff ff    	jne    8011fd <readline+0x36>
			if (echoing)
  80129c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a0:	74 0e                	je     8012b0 <readline+0xe9>
				cputchar(c);
  8012a2:	83 ec 0c             	sub    $0xc,%esp
  8012a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012a8:	e8 4e f4 ff ff       	call   8006fb <cputchar>
  8012ad:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b6:	01 d0                	add    %edx,%eax
  8012b8:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8012bb:	eb 06                	jmp    8012c3 <readline+0xfc>
		}
	}
  8012bd:	e9 3b ff ff ff       	jmp    8011fd <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8012c2:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8012c3:	90                   	nop
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    

008012c6 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8012cc:	e8 b6 0d 00 00       	call   802087 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d5:	74 13                	je     8012ea <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012d7:	83 ec 08             	sub    $0x8,%esp
  8012da:	ff 75 08             	pushl  0x8(%ebp)
  8012dd:	68 c8 4a 80 00       	push   $0x804ac8
  8012e2:	e8 4c f8 ff ff       	call   800b33 <cprintf>
  8012e7:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8012ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8012f1:	83 ec 0c             	sub    $0xc,%esp
  8012f4:	6a 00                	push   $0x0
  8012f6:	e8 32 f4 ff ff       	call   80072d <iscons>
  8012fb:	83 c4 10             	add    $0x10,%esp
  8012fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801301:	e8 14 f4 ff ff       	call   80071a <getchar>
  801306:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801309:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80130d:	79 22                	jns    801331 <atomic_readline+0x6b>
				if (c != -E_EOF)
  80130f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801313:	0f 84 ad 00 00 00    	je     8013c6 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801319:	83 ec 08             	sub    $0x8,%esp
  80131c:	ff 75 ec             	pushl  -0x14(%ebp)
  80131f:	68 cb 4a 80 00       	push   $0x804acb
  801324:	e8 0a f8 ff ff       	call   800b33 <cprintf>
  801329:	83 c4 10             	add    $0x10,%esp
				break;
  80132c:	e9 95 00 00 00       	jmp    8013c6 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801331:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801335:	7e 34                	jle    80136b <atomic_readline+0xa5>
  801337:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80133e:	7f 2b                	jg     80136b <atomic_readline+0xa5>
				if (echoing)
  801340:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801344:	74 0e                	je     801354 <atomic_readline+0x8e>
					cputchar(c);
  801346:	83 ec 0c             	sub    $0xc,%esp
  801349:	ff 75 ec             	pushl  -0x14(%ebp)
  80134c:	e8 aa f3 ff ff       	call   8006fb <cputchar>
  801351:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801357:	8d 50 01             	lea    0x1(%eax),%edx
  80135a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80135d:	89 c2                	mov    %eax,%edx
  80135f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801362:	01 d0                	add    %edx,%eax
  801364:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801367:	88 10                	mov    %dl,(%eax)
  801369:	eb 56                	jmp    8013c1 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80136b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80136f:	75 1f                	jne    801390 <atomic_readline+0xca>
  801371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801375:	7e 19                	jle    801390 <atomic_readline+0xca>
				if (echoing)
  801377:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80137b:	74 0e                	je     80138b <atomic_readline+0xc5>
					cputchar(c);
  80137d:	83 ec 0c             	sub    $0xc,%esp
  801380:	ff 75 ec             	pushl  -0x14(%ebp)
  801383:	e8 73 f3 ff ff       	call   8006fb <cputchar>
  801388:	83 c4 10             	add    $0x10,%esp
				i--;
  80138b:	ff 4d f4             	decl   -0xc(%ebp)
  80138e:	eb 31                	jmp    8013c1 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801390:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801394:	74 0a                	je     8013a0 <atomic_readline+0xda>
  801396:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80139a:	0f 85 61 ff ff ff    	jne    801301 <atomic_readline+0x3b>
				if (echoing)
  8013a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013a4:	74 0e                	je     8013b4 <atomic_readline+0xee>
					cputchar(c);
  8013a6:	83 ec 0c             	sub    $0xc,%esp
  8013a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8013ac:	e8 4a f3 ff ff       	call   8006fb <cputchar>
  8013b1:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8013b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ba:	01 d0                	add    %edx,%eax
  8013bc:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8013bf:	eb 06                	jmp    8013c7 <atomic_readline+0x101>
			}
		}
  8013c1:	e9 3b ff ff ff       	jmp    801301 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8013c6:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8013c7:	e8 d5 0c 00 00       	call   8020a1 <sys_unlock_cons>
}
  8013cc:	90                   	nop
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013dc:	eb 06                	jmp    8013e4 <strlen+0x15>
		n++;
  8013de:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013e1:	ff 45 08             	incl   0x8(%ebp)
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	84 c0                	test   %al,%al
  8013eb:	75 f1                	jne    8013de <strlen+0xf>
		n++;
	return n;
  8013ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ff:	eb 09                	jmp    80140a <strnlen+0x18>
		n++;
  801401:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801404:	ff 45 08             	incl   0x8(%ebp)
  801407:	ff 4d 0c             	decl   0xc(%ebp)
  80140a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80140e:	74 09                	je     801419 <strnlen+0x27>
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	8a 00                	mov    (%eax),%al
  801415:	84 c0                	test   %al,%al
  801417:	75 e8                	jne    801401 <strnlen+0xf>
		n++;
	return n;
  801419:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80142a:	90                   	nop
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	8d 50 01             	lea    0x1(%eax),%edx
  801431:	89 55 08             	mov    %edx,0x8(%ebp)
  801434:	8b 55 0c             	mov    0xc(%ebp),%edx
  801437:	8d 4a 01             	lea    0x1(%edx),%ecx
  80143a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80143d:	8a 12                	mov    (%edx),%dl
  80143f:	88 10                	mov    %dl,(%eax)
  801441:	8a 00                	mov    (%eax),%al
  801443:	84 c0                	test   %al,%al
  801445:	75 e4                	jne    80142b <strcpy+0xd>
		/* do nothing */;
	return ret;
  801447:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80145f:	eb 1f                	jmp    801480 <strncpy+0x34>
		*dst++ = *src;
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	8d 50 01             	lea    0x1(%eax),%edx
  801467:	89 55 08             	mov    %edx,0x8(%ebp)
  80146a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146d:	8a 12                	mov    (%edx),%dl
  80146f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801471:	8b 45 0c             	mov    0xc(%ebp),%eax
  801474:	8a 00                	mov    (%eax),%al
  801476:	84 c0                	test   %al,%al
  801478:	74 03                	je     80147d <strncpy+0x31>
			src++;
  80147a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80147d:	ff 45 fc             	incl   -0x4(%ebp)
  801480:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801483:	3b 45 10             	cmp    0x10(%ebp),%eax
  801486:	72 d9                	jb     801461 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801488:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801499:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80149d:	74 30                	je     8014cf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80149f:	eb 16                	jmp    8014b7 <strlcpy+0x2a>
			*dst++ = *src++;
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8d 50 01             	lea    0x1(%eax),%edx
  8014a7:	89 55 08             	mov    %edx,0x8(%ebp)
  8014aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ad:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014b0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014b3:	8a 12                	mov    (%edx),%dl
  8014b5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014b7:	ff 4d 10             	decl   0x10(%ebp)
  8014ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014be:	74 09                	je     8014c9 <strlcpy+0x3c>
  8014c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c3:	8a 00                	mov    (%eax),%al
  8014c5:	84 c0                	test   %al,%al
  8014c7:	75 d8                	jne    8014a1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d5:	29 c2                	sub    %eax,%edx
  8014d7:	89 d0                	mov    %edx,%eax
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014de:	eb 06                	jmp    8014e6 <strcmp+0xb>
		p++, q++;
  8014e0:	ff 45 08             	incl   0x8(%ebp)
  8014e3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	8a 00                	mov    (%eax),%al
  8014eb:	84 c0                	test   %al,%al
  8014ed:	74 0e                	je     8014fd <strcmp+0x22>
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	8a 10                	mov    (%eax),%dl
  8014f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	38 c2                	cmp    %al,%dl
  8014fb:	74 e3                	je     8014e0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	0f b6 d0             	movzbl %al,%edx
  801505:	8b 45 0c             	mov    0xc(%ebp),%eax
  801508:	8a 00                	mov    (%eax),%al
  80150a:	0f b6 c0             	movzbl %al,%eax
  80150d:	29 c2                	sub    %eax,%edx
  80150f:	89 d0                	mov    %edx,%eax
}
  801511:	5d                   	pop    %ebp
  801512:	c3                   	ret    

00801513 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801516:	eb 09                	jmp    801521 <strncmp+0xe>
		n--, p++, q++;
  801518:	ff 4d 10             	decl   0x10(%ebp)
  80151b:	ff 45 08             	incl   0x8(%ebp)
  80151e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801521:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801525:	74 17                	je     80153e <strncmp+0x2b>
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8a 00                	mov    (%eax),%al
  80152c:	84 c0                	test   %al,%al
  80152e:	74 0e                	je     80153e <strncmp+0x2b>
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	8a 10                	mov    (%eax),%dl
  801535:	8b 45 0c             	mov    0xc(%ebp),%eax
  801538:	8a 00                	mov    (%eax),%al
  80153a:	38 c2                	cmp    %al,%dl
  80153c:	74 da                	je     801518 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80153e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801542:	75 07                	jne    80154b <strncmp+0x38>
		return 0;
  801544:	b8 00 00 00 00       	mov    $0x0,%eax
  801549:	eb 14                	jmp    80155f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	8a 00                	mov    (%eax),%al
  801550:	0f b6 d0             	movzbl %al,%edx
  801553:	8b 45 0c             	mov    0xc(%ebp),%eax
  801556:	8a 00                	mov    (%eax),%al
  801558:	0f b6 c0             	movzbl %al,%eax
  80155b:	29 c2                	sub    %eax,%edx
  80155d:	89 d0                	mov    %edx,%eax
}
  80155f:	5d                   	pop    %ebp
  801560:	c3                   	ret    

00801561 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 04             	sub    $0x4,%esp
  801567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80156d:	eb 12                	jmp    801581 <strchr+0x20>
		if (*s == c)
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	8a 00                	mov    (%eax),%al
  801574:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801577:	75 05                	jne    80157e <strchr+0x1d>
			return (char *) s;
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	eb 11                	jmp    80158f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80157e:	ff 45 08             	incl   0x8(%ebp)
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	8a 00                	mov    (%eax),%al
  801586:	84 c0                	test   %al,%al
  801588:	75 e5                	jne    80156f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80158a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80159d:	eb 0d                	jmp    8015ac <strfind+0x1b>
		if (*s == c)
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	8a 00                	mov    (%eax),%al
  8015a4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015a7:	74 0e                	je     8015b7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015a9:	ff 45 08             	incl   0x8(%ebp)
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	8a 00                	mov    (%eax),%al
  8015b1:	84 c0                	test   %al,%al
  8015b3:	75 ea                	jne    80159f <strfind+0xe>
  8015b5:	eb 01                	jmp    8015b8 <strfind+0x27>
		if (*s == c)
			break;
  8015b7:	90                   	nop
	return (char *) s;
  8015b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015cf:	eb 0e                	jmp    8015df <memset+0x22>
		*p++ = c;
  8015d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d4:	8d 50 01             	lea    0x1(%eax),%edx
  8015d7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015dd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015df:	ff 4d f8             	decl   -0x8(%ebp)
  8015e2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015e6:	79 e9                	jns    8015d1 <memset+0x14>
		*p++ = c;

	return v;
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8015ff:	eb 16                	jmp    801617 <memcpy+0x2a>
		*d++ = *s++;
  801601:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801604:	8d 50 01             	lea    0x1(%eax),%edx
  801607:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80160a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801610:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801613:	8a 12                	mov    (%edx),%dl
  801615:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801617:	8b 45 10             	mov    0x10(%ebp),%eax
  80161a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80161d:	89 55 10             	mov    %edx,0x10(%ebp)
  801620:	85 c0                	test   %eax,%eax
  801622:	75 dd                	jne    801601 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80162f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801632:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80163b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801641:	73 50                	jae    801693 <memmove+0x6a>
  801643:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801646:	8b 45 10             	mov    0x10(%ebp),%eax
  801649:	01 d0                	add    %edx,%eax
  80164b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80164e:	76 43                	jbe    801693 <memmove+0x6a>
		s += n;
  801650:	8b 45 10             	mov    0x10(%ebp),%eax
  801653:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801656:	8b 45 10             	mov    0x10(%ebp),%eax
  801659:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80165c:	eb 10                	jmp    80166e <memmove+0x45>
			*--d = *--s;
  80165e:	ff 4d f8             	decl   -0x8(%ebp)
  801661:	ff 4d fc             	decl   -0x4(%ebp)
  801664:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801667:	8a 10                	mov    (%eax),%dl
  801669:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80166c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80166e:	8b 45 10             	mov    0x10(%ebp),%eax
  801671:	8d 50 ff             	lea    -0x1(%eax),%edx
  801674:	89 55 10             	mov    %edx,0x10(%ebp)
  801677:	85 c0                	test   %eax,%eax
  801679:	75 e3                	jne    80165e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80167b:	eb 23                	jmp    8016a0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80167d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801680:	8d 50 01             	lea    0x1(%eax),%edx
  801683:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801686:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801689:	8d 4a 01             	lea    0x1(%edx),%ecx
  80168c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80168f:	8a 12                	mov    (%edx),%dl
  801691:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801693:	8b 45 10             	mov    0x10(%ebp),%eax
  801696:	8d 50 ff             	lea    -0x1(%eax),%edx
  801699:	89 55 10             	mov    %edx,0x10(%ebp)
  80169c:	85 c0                	test   %eax,%eax
  80169e:	75 dd                	jne    80167d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016b7:	eb 2a                	jmp    8016e3 <memcmp+0x3e>
		if (*s1 != *s2)
  8016b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bc:	8a 10                	mov    (%eax),%dl
  8016be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c1:	8a 00                	mov    (%eax),%al
  8016c3:	38 c2                	cmp    %al,%dl
  8016c5:	74 16                	je     8016dd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ca:	8a 00                	mov    (%eax),%al
  8016cc:	0f b6 d0             	movzbl %al,%edx
  8016cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	0f b6 c0             	movzbl %al,%eax
  8016d7:	29 c2                	sub    %eax,%edx
  8016d9:	89 d0                	mov    %edx,%eax
  8016db:	eb 18                	jmp    8016f5 <memcmp+0x50>
		s1++, s2++;
  8016dd:	ff 45 fc             	incl   -0x4(%ebp)
  8016e0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	75 c9                	jne    8016b9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801700:	8b 45 10             	mov    0x10(%ebp),%eax
  801703:	01 d0                	add    %edx,%eax
  801705:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801708:	eb 15                	jmp    80171f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	8a 00                	mov    (%eax),%al
  80170f:	0f b6 d0             	movzbl %al,%edx
  801712:	8b 45 0c             	mov    0xc(%ebp),%eax
  801715:	0f b6 c0             	movzbl %al,%eax
  801718:	39 c2                	cmp    %eax,%edx
  80171a:	74 0d                	je     801729 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80171c:	ff 45 08             	incl   0x8(%ebp)
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801725:	72 e3                	jb     80170a <memfind+0x13>
  801727:	eb 01                	jmp    80172a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801729:	90                   	nop
	return (void *) s;
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801735:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80173c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801743:	eb 03                	jmp    801748 <strtol+0x19>
		s++;
  801745:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	8a 00                	mov    (%eax),%al
  80174d:	3c 20                	cmp    $0x20,%al
  80174f:	74 f4                	je     801745 <strtol+0x16>
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	8a 00                	mov    (%eax),%al
  801756:	3c 09                	cmp    $0x9,%al
  801758:	74 eb                	je     801745 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	8a 00                	mov    (%eax),%al
  80175f:	3c 2b                	cmp    $0x2b,%al
  801761:	75 05                	jne    801768 <strtol+0x39>
		s++;
  801763:	ff 45 08             	incl   0x8(%ebp)
  801766:	eb 13                	jmp    80177b <strtol+0x4c>
	else if (*s == '-')
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	8a 00                	mov    (%eax),%al
  80176d:	3c 2d                	cmp    $0x2d,%al
  80176f:	75 0a                	jne    80177b <strtol+0x4c>
		s++, neg = 1;
  801771:	ff 45 08             	incl   0x8(%ebp)
  801774:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80177b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80177f:	74 06                	je     801787 <strtol+0x58>
  801781:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801785:	75 20                	jne    8017a7 <strtol+0x78>
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	8a 00                	mov    (%eax),%al
  80178c:	3c 30                	cmp    $0x30,%al
  80178e:	75 17                	jne    8017a7 <strtol+0x78>
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	40                   	inc    %eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	3c 78                	cmp    $0x78,%al
  801798:	75 0d                	jne    8017a7 <strtol+0x78>
		s += 2, base = 16;
  80179a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80179e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017a5:	eb 28                	jmp    8017cf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ab:	75 15                	jne    8017c2 <strtol+0x93>
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 30                	cmp    $0x30,%al
  8017b4:	75 0c                	jne    8017c2 <strtol+0x93>
		s++, base = 8;
  8017b6:	ff 45 08             	incl   0x8(%ebp)
  8017b9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017c0:	eb 0d                	jmp    8017cf <strtol+0xa0>
	else if (base == 0)
  8017c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c6:	75 07                	jne    8017cf <strtol+0xa0>
		base = 10;
  8017c8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	8a 00                	mov    (%eax),%al
  8017d4:	3c 2f                	cmp    $0x2f,%al
  8017d6:	7e 19                	jle    8017f1 <strtol+0xc2>
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	8a 00                	mov    (%eax),%al
  8017dd:	3c 39                	cmp    $0x39,%al
  8017df:	7f 10                	jg     8017f1 <strtol+0xc2>
			dig = *s - '0';
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	8a 00                	mov    (%eax),%al
  8017e6:	0f be c0             	movsbl %al,%eax
  8017e9:	83 e8 30             	sub    $0x30,%eax
  8017ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017ef:	eb 42                	jmp    801833 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	8a 00                	mov    (%eax),%al
  8017f6:	3c 60                	cmp    $0x60,%al
  8017f8:	7e 19                	jle    801813 <strtol+0xe4>
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8a 00                	mov    (%eax),%al
  8017ff:	3c 7a                	cmp    $0x7a,%al
  801801:	7f 10                	jg     801813 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	8a 00                	mov    (%eax),%al
  801808:	0f be c0             	movsbl %al,%eax
  80180b:	83 e8 57             	sub    $0x57,%eax
  80180e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801811:	eb 20                	jmp    801833 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8a 00                	mov    (%eax),%al
  801818:	3c 40                	cmp    $0x40,%al
  80181a:	7e 39                	jle    801855 <strtol+0x126>
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8a 00                	mov    (%eax),%al
  801821:	3c 5a                	cmp    $0x5a,%al
  801823:	7f 30                	jg     801855 <strtol+0x126>
			dig = *s - 'A' + 10;
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8a 00                	mov    (%eax),%al
  80182a:	0f be c0             	movsbl %al,%eax
  80182d:	83 e8 37             	sub    $0x37,%eax
  801830:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801836:	3b 45 10             	cmp    0x10(%ebp),%eax
  801839:	7d 19                	jge    801854 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80183b:	ff 45 08             	incl   0x8(%ebp)
  80183e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801841:	0f af 45 10          	imul   0x10(%ebp),%eax
  801845:	89 c2                	mov    %eax,%edx
  801847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184a:	01 d0                	add    %edx,%eax
  80184c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80184f:	e9 7b ff ff ff       	jmp    8017cf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801854:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801855:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801859:	74 08                	je     801863 <strtol+0x134>
		*endptr = (char *) s;
  80185b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185e:	8b 55 08             	mov    0x8(%ebp),%edx
  801861:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801863:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801867:	74 07                	je     801870 <strtol+0x141>
  801869:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186c:	f7 d8                	neg    %eax
  80186e:	eb 03                	jmp    801873 <strtol+0x144>
  801870:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <ltostr>:

void
ltostr(long value, char *str)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80187b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801882:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801889:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80188d:	79 13                	jns    8018a2 <ltostr+0x2d>
	{
		neg = 1;
  80188f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801896:	8b 45 0c             	mov    0xc(%ebp),%eax
  801899:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80189c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80189f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018aa:	99                   	cltd   
  8018ab:	f7 f9                	idiv   %ecx
  8018ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b3:	8d 50 01             	lea    0x1(%eax),%edx
  8018b6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018b9:	89 c2                	mov    %eax,%edx
  8018bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018be:	01 d0                	add    %edx,%eax
  8018c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018c3:	83 c2 30             	add    $0x30,%edx
  8018c6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018cb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018d0:	f7 e9                	imul   %ecx
  8018d2:	c1 fa 02             	sar    $0x2,%edx
  8018d5:	89 c8                	mov    %ecx,%eax
  8018d7:	c1 f8 1f             	sar    $0x1f,%eax
  8018da:	29 c2                	sub    %eax,%edx
  8018dc:	89 d0                	mov    %edx,%eax
  8018de:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018e5:	75 bb                	jne    8018a2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f1:	48                   	dec    %eax
  8018f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018f9:	74 3d                	je     801938 <ltostr+0xc3>
		start = 1 ;
  8018fb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801902:	eb 34                	jmp    801938 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801904:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801907:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190a:	01 d0                	add    %edx,%eax
  80190c:	8a 00                	mov    (%eax),%al
  80190e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801911:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801914:	8b 45 0c             	mov    0xc(%ebp),%eax
  801917:	01 c2                	add    %eax,%edx
  801919:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80191c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191f:	01 c8                	add    %ecx,%eax
  801921:	8a 00                	mov    (%eax),%al
  801923:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801925:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801928:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192b:	01 c2                	add    %eax,%edx
  80192d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801930:	88 02                	mov    %al,(%edx)
		start++ ;
  801932:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801935:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80193e:	7c c4                	jl     801904 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801940:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801943:	8b 45 0c             	mov    0xc(%ebp),%eax
  801946:	01 d0                	add    %edx,%eax
  801948:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80194b:	90                   	nop
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801954:	ff 75 08             	pushl  0x8(%ebp)
  801957:	e8 73 fa ff ff       	call   8013cf <strlen>
  80195c:	83 c4 04             	add    $0x4,%esp
  80195f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801962:	ff 75 0c             	pushl  0xc(%ebp)
  801965:	e8 65 fa ff ff       	call   8013cf <strlen>
  80196a:	83 c4 04             	add    $0x4,%esp
  80196d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801970:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801977:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80197e:	eb 17                	jmp    801997 <strcconcat+0x49>
		final[s] = str1[s] ;
  801980:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801983:	8b 45 10             	mov    0x10(%ebp),%eax
  801986:	01 c2                	add    %eax,%edx
  801988:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	01 c8                	add    %ecx,%eax
  801990:	8a 00                	mov    (%eax),%al
  801992:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801994:	ff 45 fc             	incl   -0x4(%ebp)
  801997:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80199a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80199d:	7c e1                	jl     801980 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80199f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019ad:	eb 1f                	jmp    8019ce <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019b2:	8d 50 01             	lea    0x1(%eax),%edx
  8019b5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019b8:	89 c2                	mov    %eax,%edx
  8019ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bd:	01 c2                	add    %eax,%edx
  8019bf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c5:	01 c8                	add    %ecx,%eax
  8019c7:	8a 00                	mov    (%eax),%al
  8019c9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019cb:	ff 45 f8             	incl   -0x8(%ebp)
  8019ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019d4:	7c d9                	jl     8019af <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019dc:	01 d0                	add    %edx,%eax
  8019de:	c6 00 00             	movb   $0x0,(%eax)
}
  8019e1:	90                   	nop
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f3:	8b 00                	mov    (%eax),%eax
  8019f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ff:	01 d0                	add    %edx,%eax
  801a01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a07:	eb 0c                	jmp    801a15 <strsplit+0x31>
			*string++ = 0;
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	8d 50 01             	lea    0x1(%eax),%edx
  801a0f:	89 55 08             	mov    %edx,0x8(%ebp)
  801a12:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	8a 00                	mov    (%eax),%al
  801a1a:	84 c0                	test   %al,%al
  801a1c:	74 18                	je     801a36 <strsplit+0x52>
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	8a 00                	mov    (%eax),%al
  801a23:	0f be c0             	movsbl %al,%eax
  801a26:	50                   	push   %eax
  801a27:	ff 75 0c             	pushl  0xc(%ebp)
  801a2a:	e8 32 fb ff ff       	call   801561 <strchr>
  801a2f:	83 c4 08             	add    $0x8,%esp
  801a32:	85 c0                	test   %eax,%eax
  801a34:	75 d3                	jne    801a09 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8a 00                	mov    (%eax),%al
  801a3b:	84 c0                	test   %al,%al
  801a3d:	74 5a                	je     801a99 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  801a42:	8b 00                	mov    (%eax),%eax
  801a44:	83 f8 0f             	cmp    $0xf,%eax
  801a47:	75 07                	jne    801a50 <strsplit+0x6c>
		{
			return 0;
  801a49:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4e:	eb 66                	jmp    801ab6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a50:	8b 45 14             	mov    0x14(%ebp),%eax
  801a53:	8b 00                	mov    (%eax),%eax
  801a55:	8d 48 01             	lea    0x1(%eax),%ecx
  801a58:	8b 55 14             	mov    0x14(%ebp),%edx
  801a5b:	89 0a                	mov    %ecx,(%edx)
  801a5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a64:	8b 45 10             	mov    0x10(%ebp),%eax
  801a67:	01 c2                	add    %eax,%edx
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a6e:	eb 03                	jmp    801a73 <strsplit+0x8f>
			string++;
  801a70:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	8a 00                	mov    (%eax),%al
  801a78:	84 c0                	test   %al,%al
  801a7a:	74 8b                	je     801a07 <strsplit+0x23>
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	8a 00                	mov    (%eax),%al
  801a81:	0f be c0             	movsbl %al,%eax
  801a84:	50                   	push   %eax
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	e8 d4 fa ff ff       	call   801561 <strchr>
  801a8d:	83 c4 08             	add    $0x8,%esp
  801a90:	85 c0                	test   %eax,%eax
  801a92:	74 dc                	je     801a70 <strsplit+0x8c>
			string++;
	}
  801a94:	e9 6e ff ff ff       	jmp    801a07 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a99:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a9a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a9d:	8b 00                	mov    (%eax),%eax
  801a9f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aa6:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa9:	01 d0                	add    %edx,%eax
  801aab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ab1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801abe:	83 ec 04             	sub    $0x4,%esp
  801ac1:	68 dc 4a 80 00       	push   $0x804adc
  801ac6:	68 3f 01 00 00       	push   $0x13f
  801acb:	68 fe 4a 80 00       	push   $0x804afe
  801ad0:	e8 a1 ed ff ff       	call   800876 <_panic>

00801ad5 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801adb:	83 ec 0c             	sub    $0xc,%esp
  801ade:	ff 75 08             	pushl  0x8(%ebp)
  801ae1:	e8 0a 0b 00 00       	call   8025f0 <sys_sbrk>
  801ae6:	83 c4 10             	add    $0x10,%esp
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801af1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801af5:	75 0a                	jne    801b01 <malloc+0x16>
  801af7:	b8 00 00 00 00       	mov    $0x0,%eax
  801afc:	e9 07 02 00 00       	jmp    801d08 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801b01:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801b08:	8b 55 08             	mov    0x8(%ebp),%edx
  801b0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b0e:	01 d0                	add    %edx,%eax
  801b10:	48                   	dec    %eax
  801b11:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b14:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b17:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1c:	f7 75 dc             	divl   -0x24(%ebp)
  801b1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b22:	29 d0                	sub    %edx,%eax
  801b24:	c1 e8 0c             	shr    $0xc,%eax
  801b27:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801b2a:	a1 24 50 80 00       	mov    0x805024,%eax
  801b2f:	8b 40 78             	mov    0x78(%eax),%eax
  801b32:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801b37:	29 c2                	sub    %eax,%edx
  801b39:	89 d0                	mov    %edx,%eax
  801b3b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b41:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b46:	c1 e8 0c             	shr    $0xc,%eax
  801b49:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801b4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801b53:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801b5a:	77 42                	ja     801b9e <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801b5c:	e8 13 09 00 00       	call   802474 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b61:	85 c0                	test   %eax,%eax
  801b63:	74 16                	je     801b7b <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801b65:	83 ec 0c             	sub    $0xc,%esp
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	e8 53 0e 00 00       	call   8029c3 <alloc_block_FF>
  801b70:	83 c4 10             	add    $0x10,%esp
  801b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b76:	e9 8a 01 00 00       	jmp    801d05 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b7b:	e8 25 09 00 00       	call   8024a5 <sys_isUHeapPlacementStrategyBESTFIT>
  801b80:	85 c0                	test   %eax,%eax
  801b82:	0f 84 7d 01 00 00    	je     801d05 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b88:	83 ec 0c             	sub    $0xc,%esp
  801b8b:	ff 75 08             	pushl  0x8(%ebp)
  801b8e:	e8 ec 12 00 00       	call   802e7f <alloc_block_BF>
  801b93:	83 c4 10             	add    $0x10,%esp
  801b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b99:	e9 67 01 00 00       	jmp    801d05 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801b9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ba1:	48                   	dec    %eax
  801ba2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ba5:	0f 86 53 01 00 00    	jbe    801cfe <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801bab:	a1 24 50 80 00       	mov    0x805024,%eax
  801bb0:	8b 40 78             	mov    0x78(%eax),%eax
  801bb3:	05 00 10 00 00       	add    $0x1000,%eax
  801bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801bbb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801bc2:	e9 de 00 00 00       	jmp    801ca5 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801bc7:	a1 24 50 80 00       	mov    0x805024,%eax
  801bcc:	8b 40 78             	mov    0x78(%eax),%eax
  801bcf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bd2:	29 c2                	sub    %eax,%edx
  801bd4:	89 d0                	mov    %edx,%eax
  801bd6:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bdb:	c1 e8 0c             	shr    $0xc,%eax
  801bde:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801be5:	85 c0                	test   %eax,%eax
  801be7:	0f 85 ab 00 00 00    	jne    801c98 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf0:	05 00 10 00 00       	add    $0x1000,%eax
  801bf5:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801bf8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801bff:	eb 47                	jmp    801c48 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801c01:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801c08:	76 0a                	jbe    801c14 <malloc+0x129>
  801c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0f:	e9 f4 00 00 00       	jmp    801d08 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801c14:	a1 24 50 80 00       	mov    0x805024,%eax
  801c19:	8b 40 78             	mov    0x78(%eax),%eax
  801c1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c1f:	29 c2                	sub    %eax,%edx
  801c21:	89 d0                	mov    %edx,%eax
  801c23:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c28:	c1 e8 0c             	shr    $0xc,%eax
  801c2b:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801c32:	85 c0                	test   %eax,%eax
  801c34:	74 08                	je     801c3e <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  801c36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801c3c:	eb 5a                	jmp    801c98 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801c3e:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801c45:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801c48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c4b:	48                   	dec    %eax
  801c4c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c4f:	77 b0                	ja     801c01 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801c51:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801c58:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c5f:	eb 2f                	jmp    801c90 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c64:	c1 e0 0c             	shl    $0xc,%eax
  801c67:	89 c2                	mov    %eax,%edx
  801c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6c:	01 c2                	add    %eax,%edx
  801c6e:	a1 24 50 80 00       	mov    0x805024,%eax
  801c73:	8b 40 78             	mov    0x78(%eax),%eax
  801c76:	29 c2                	sub    %eax,%edx
  801c78:	89 d0                	mov    %edx,%eax
  801c7a:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c7f:	c1 e8 0c             	shr    $0xc,%eax
  801c82:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  801c89:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801c8d:	ff 45 e0             	incl   -0x20(%ebp)
  801c90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c93:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801c96:	72 c9                	jb     801c61 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801c98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c9c:	75 16                	jne    801cb4 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801c9e:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801ca5:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801cac:	0f 86 15 ff ff ff    	jbe    801bc7 <malloc+0xdc>
  801cb2:	eb 01                	jmp    801cb5 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801cb4:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801cb5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cb9:	75 07                	jne    801cc2 <malloc+0x1d7>
  801cbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc0:	eb 46                	jmp    801d08 <malloc+0x21d>
		ptr = (void*)i;
  801cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801cc8:	a1 24 50 80 00       	mov    0x805024,%eax
  801ccd:	8b 40 78             	mov    0x78(%eax),%eax
  801cd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cd3:	29 c2                	sub    %eax,%edx
  801cd5:	89 d0                	mov    %edx,%eax
  801cd7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cdc:	c1 e8 0c             	shr    $0xc,%eax
  801cdf:	89 c2                	mov    %eax,%edx
  801ce1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ce4:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801ceb:	83 ec 08             	sub    $0x8,%esp
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	ff 75 f0             	pushl  -0x10(%ebp)
  801cf4:	e8 2e 09 00 00       	call   802627 <sys_allocate_user_mem>
  801cf9:	83 c4 10             	add    $0x10,%esp
  801cfc:	eb 07                	jmp    801d05 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801d03:	eb 03                	jmp    801d08 <malloc+0x21d>
	}
	return ptr;
  801d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801d10:	a1 24 50 80 00       	mov    0x805024,%eax
  801d15:	8b 40 78             	mov    0x78(%eax),%eax
  801d18:	05 00 10 00 00       	add    $0x1000,%eax
  801d1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801d20:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801d27:	a1 24 50 80 00       	mov    0x805024,%eax
  801d2c:	8b 50 78             	mov    0x78(%eax),%edx
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	39 c2                	cmp    %eax,%edx
  801d34:	76 24                	jbe    801d5a <free+0x50>
		size = get_block_size(va);
  801d36:	83 ec 0c             	sub    $0xc,%esp
  801d39:	ff 75 08             	pushl  0x8(%ebp)
  801d3c:	e8 02 09 00 00       	call   802643 <get_block_size>
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	ff 75 08             	pushl  0x8(%ebp)
  801d4d:	e8 35 1b 00 00       	call   803887 <free_block>
  801d52:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801d55:	e9 ac 00 00 00       	jmp    801e06 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d60:	0f 82 89 00 00 00    	jb     801def <free+0xe5>
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801d6e:	77 7f                	ja     801def <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801d70:	8b 55 08             	mov    0x8(%ebp),%edx
  801d73:	a1 24 50 80 00       	mov    0x805024,%eax
  801d78:	8b 40 78             	mov    0x78(%eax),%eax
  801d7b:	29 c2                	sub    %eax,%edx
  801d7d:	89 d0                	mov    %edx,%eax
  801d7f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d84:	c1 e8 0c             	shr    $0xc,%eax
  801d87:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801d8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801d91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d94:	c1 e0 0c             	shl    $0xc,%eax
  801d97:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801d9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801da1:	eb 2f                	jmp    801dd2 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da6:	c1 e0 0c             	shl    $0xc,%eax
  801da9:	89 c2                	mov    %eax,%edx
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	01 c2                	add    %eax,%edx
  801db0:	a1 24 50 80 00       	mov    0x805024,%eax
  801db5:	8b 40 78             	mov    0x78(%eax),%eax
  801db8:	29 c2                	sub    %eax,%edx
  801dba:	89 d0                	mov    %edx,%eax
  801dbc:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dc1:	c1 e8 0c             	shr    $0xc,%eax
  801dc4:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801dcb:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801dcf:	ff 45 f4             	incl   -0xc(%ebp)
  801dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801dd8:	72 c9                	jb     801da3 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	83 ec 08             	sub    $0x8,%esp
  801de0:	ff 75 ec             	pushl  -0x14(%ebp)
  801de3:	50                   	push   %eax
  801de4:	e8 22 08 00 00       	call   80260b <sys_free_user_mem>
  801de9:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801dec:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801ded:	eb 17                	jmp    801e06 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801def:	83 ec 04             	sub    $0x4,%esp
  801df2:	68 0c 4b 80 00       	push   $0x804b0c
  801df7:	68 85 00 00 00       	push   $0x85
  801dfc:	68 36 4b 80 00       	push   $0x804b36
  801e01:	e8 70 ea ff ff       	call   800876 <_panic>
	}
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 28             	sub    $0x28,%esp
  801e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e11:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801e14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e18:	75 0a                	jne    801e24 <smalloc+0x1c>
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1f:	e9 9a 00 00 00       	jmp    801ebe <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e2a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e37:	39 d0                	cmp    %edx,%eax
  801e39:	73 02                	jae    801e3d <smalloc+0x35>
  801e3b:	89 d0                	mov    %edx,%eax
  801e3d:	83 ec 0c             	sub    $0xc,%esp
  801e40:	50                   	push   %eax
  801e41:	e8 a5 fc ff ff       	call   801aeb <malloc>
  801e46:	83 c4 10             	add    $0x10,%esp
  801e49:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801e4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e50:	75 07                	jne    801e59 <smalloc+0x51>
  801e52:	b8 00 00 00 00       	mov    $0x0,%eax
  801e57:	eb 65                	jmp    801ebe <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e59:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e5d:	ff 75 ec             	pushl  -0x14(%ebp)
  801e60:	50                   	push   %eax
  801e61:	ff 75 0c             	pushl  0xc(%ebp)
  801e64:	ff 75 08             	pushl  0x8(%ebp)
  801e67:	e8 a6 03 00 00       	call   802212 <sys_createSharedObject>
  801e6c:	83 c4 10             	add    $0x10,%esp
  801e6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e72:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e76:	74 06                	je     801e7e <smalloc+0x76>
  801e78:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e7c:	75 07                	jne    801e85 <smalloc+0x7d>
  801e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e83:	eb 39                	jmp    801ebe <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801e85:	83 ec 08             	sub    $0x8,%esp
  801e88:	ff 75 ec             	pushl  -0x14(%ebp)
  801e8b:	68 42 4b 80 00       	push   $0x804b42
  801e90:	e8 9e ec ff ff       	call   800b33 <cprintf>
  801e95:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801e98:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e9b:	a1 24 50 80 00       	mov    0x805024,%eax
  801ea0:	8b 40 78             	mov    0x78(%eax),%eax
  801ea3:	29 c2                	sub    %eax,%edx
  801ea5:	89 d0                	mov    %edx,%eax
  801ea7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801eac:	c1 e8 0c             	shr    $0xc,%eax
  801eaf:	89 c2                	mov    %eax,%edx
  801eb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801eb4:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801ebb:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ec6:	83 ec 08             	sub    $0x8,%esp
  801ec9:	ff 75 0c             	pushl  0xc(%ebp)
  801ecc:	ff 75 08             	pushl  0x8(%ebp)
  801ecf:	e8 68 03 00 00       	call   80223c <sys_getSizeOfSharedObject>
  801ed4:	83 c4 10             	add    $0x10,%esp
  801ed7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801eda:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801ede:	75 07                	jne    801ee7 <sget+0x27>
  801ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee5:	eb 7f                	jmp    801f66 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801eed:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ef4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efa:	39 d0                	cmp    %edx,%eax
  801efc:	7d 02                	jge    801f00 <sget+0x40>
  801efe:	89 d0                	mov    %edx,%eax
  801f00:	83 ec 0c             	sub    $0xc,%esp
  801f03:	50                   	push   %eax
  801f04:	e8 e2 fb ff ff       	call   801aeb <malloc>
  801f09:	83 c4 10             	add    $0x10,%esp
  801f0c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801f0f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f13:	75 07                	jne    801f1c <sget+0x5c>
  801f15:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1a:	eb 4a                	jmp    801f66 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801f1c:	83 ec 04             	sub    $0x4,%esp
  801f1f:	ff 75 e8             	pushl  -0x18(%ebp)
  801f22:	ff 75 0c             	pushl  0xc(%ebp)
  801f25:	ff 75 08             	pushl  0x8(%ebp)
  801f28:	e8 2c 03 00 00       	call   802259 <sys_getSharedObject>
  801f2d:	83 c4 10             	add    $0x10,%esp
  801f30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801f33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f36:	a1 24 50 80 00       	mov    0x805024,%eax
  801f3b:	8b 40 78             	mov    0x78(%eax),%eax
  801f3e:	29 c2                	sub    %eax,%edx
  801f40:	89 d0                	mov    %edx,%eax
  801f42:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f47:	c1 e8 0c             	shr    $0xc,%eax
  801f4a:	89 c2                	mov    %eax,%edx
  801f4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f4f:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801f56:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801f5a:	75 07                	jne    801f63 <sget+0xa3>
  801f5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f61:	eb 03                	jmp    801f66 <sget+0xa6>
	return ptr;
  801f63:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f71:	a1 24 50 80 00       	mov    0x805024,%eax
  801f76:	8b 40 78             	mov    0x78(%eax),%eax
  801f79:	29 c2                	sub    %eax,%edx
  801f7b:	89 d0                	mov    %edx,%eax
  801f7d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f82:	c1 e8 0c             	shr    $0xc,%eax
  801f85:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801f8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801f8f:	83 ec 08             	sub    $0x8,%esp
  801f92:	ff 75 08             	pushl  0x8(%ebp)
  801f95:	ff 75 f4             	pushl  -0xc(%ebp)
  801f98:	e8 db 02 00 00       	call   802278 <sys_freeSharedObject>
  801f9d:	83 c4 10             	add    $0x10,%esp
  801fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801fa3:	90                   	nop
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fac:	83 ec 04             	sub    $0x4,%esp
  801faf:	68 54 4b 80 00       	push   $0x804b54
  801fb4:	68 de 00 00 00       	push   $0xde
  801fb9:	68 36 4b 80 00       	push   $0x804b36
  801fbe:	e8 b3 e8 ff ff       	call   800876 <_panic>

00801fc3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fc9:	83 ec 04             	sub    $0x4,%esp
  801fcc:	68 7a 4b 80 00       	push   $0x804b7a
  801fd1:	68 ea 00 00 00       	push   $0xea
  801fd6:	68 36 4b 80 00       	push   $0x804b36
  801fdb:	e8 96 e8 ff ff       	call   800876 <_panic>

00801fe0 <shrink>:

}
void shrink(uint32 newSize)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fe6:	83 ec 04             	sub    $0x4,%esp
  801fe9:	68 7a 4b 80 00       	push   $0x804b7a
  801fee:	68 ef 00 00 00       	push   $0xef
  801ff3:	68 36 4b 80 00       	push   $0x804b36
  801ff8:	e8 79 e8 ff ff       	call   800876 <_panic>

00801ffd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802003:	83 ec 04             	sub    $0x4,%esp
  802006:	68 7a 4b 80 00       	push   $0x804b7a
  80200b:	68 f4 00 00 00       	push   $0xf4
  802010:	68 36 4b 80 00       	push   $0x804b36
  802015:	e8 5c e8 ff ff       	call   800876 <_panic>

0080201a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	57                   	push   %edi
  80201e:	56                   	push   %esi
  80201f:	53                   	push   %ebx
  802020:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	8b 55 0c             	mov    0xc(%ebp),%edx
  802029:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80202f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802032:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802035:	cd 30                	int    $0x30
  802037:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80203a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	5b                   	pop    %ebx
  802041:	5e                   	pop    %esi
  802042:	5f                   	pop    %edi
  802043:	5d                   	pop    %ebp
  802044:	c3                   	ret    

00802045 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 04             	sub    $0x4,%esp
  80204b:	8b 45 10             	mov    0x10(%ebp),%eax
  80204e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802051:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	52                   	push   %edx
  80205d:	ff 75 0c             	pushl  0xc(%ebp)
  802060:	50                   	push   %eax
  802061:	6a 00                	push   $0x0
  802063:	e8 b2 ff ff ff       	call   80201a <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
}
  80206b:	90                   	nop
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <sys_cgetc>:

int
sys_cgetc(void)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 02                	push   $0x2
  80207d:	e8 98 ff ff ff       	call   80201a <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 03                	push   $0x3
  802096:	e8 7f ff ff ff       	call   80201a <syscall>
  80209b:	83 c4 18             	add    $0x18,%esp
}
  80209e:	90                   	nop
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 04                	push   $0x4
  8020b0:	e8 65 ff ff ff       	call   80201a <syscall>
  8020b5:	83 c4 18             	add    $0x18,%esp
}
  8020b8:	90                   	nop
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	52                   	push   %edx
  8020cb:	50                   	push   %eax
  8020cc:	6a 08                	push   $0x8
  8020ce:	e8 47 ff ff ff       	call   80201a <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	56                   	push   %esi
  8020dc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020dd:	8b 75 18             	mov    0x18(%ebp),%esi
  8020e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	56                   	push   %esi
  8020ed:	53                   	push   %ebx
  8020ee:	51                   	push   %ecx
  8020ef:	52                   	push   %edx
  8020f0:	50                   	push   %eax
  8020f1:	6a 09                	push   $0x9
  8020f3:	e8 22 ff ff ff       	call   80201a <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
}
  8020fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020fe:	5b                   	pop    %ebx
  8020ff:	5e                   	pop    %esi
  802100:	5d                   	pop    %ebp
  802101:	c3                   	ret    

00802102 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802105:	8b 55 0c             	mov    0xc(%ebp),%edx
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	52                   	push   %edx
  802112:	50                   	push   %eax
  802113:	6a 0a                	push   $0xa
  802115:	e8 00 ff ff ff       	call   80201a <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	ff 75 0c             	pushl  0xc(%ebp)
  80212b:	ff 75 08             	pushl  0x8(%ebp)
  80212e:	6a 0b                	push   $0xb
  802130:	e8 e5 fe ff ff       	call   80201a <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 0c                	push   $0xc
  802149:	e8 cc fe ff ff       	call   80201a <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 0d                	push   $0xd
  802162:	e8 b3 fe ff ff       	call   80201a <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 0e                	push   $0xe
  80217b:	e8 9a fe ff ff       	call   80201a <syscall>
  802180:	83 c4 18             	add    $0x18,%esp
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 0f                	push   $0xf
  802194:	e8 81 fe ff ff       	call   80201a <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	ff 75 08             	pushl  0x8(%ebp)
  8021ac:	6a 10                	push   $0x10
  8021ae:	e8 67 fe ff ff       	call   80201a <syscall>
  8021b3:	83 c4 18             	add    $0x18,%esp
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 11                	push   $0x11
  8021c7:	e8 4e fe ff ff       	call   80201a <syscall>
  8021cc:	83 c4 18             	add    $0x18,%esp
}
  8021cf:	90                   	nop
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <sys_cputc>:

void
sys_cputc(const char c)
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 04             	sub    $0x4,%esp
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021de:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	50                   	push   %eax
  8021eb:	6a 01                	push   $0x1
  8021ed:	e8 28 fe ff ff       	call   80201a <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
}
  8021f5:	90                   	nop
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 14                	push   $0x14
  802207:	e8 0e fe ff ff       	call   80201a <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	90                   	nop
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 04             	sub    $0x4,%esp
  802218:	8b 45 10             	mov    0x10(%ebp),%eax
  80221b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80221e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802221:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	6a 00                	push   $0x0
  80222a:	51                   	push   %ecx
  80222b:	52                   	push   %edx
  80222c:	ff 75 0c             	pushl  0xc(%ebp)
  80222f:	50                   	push   %eax
  802230:	6a 15                	push   $0x15
  802232:	e8 e3 fd ff ff       	call   80201a <syscall>
  802237:	83 c4 18             	add    $0x18,%esp
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80223f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	52                   	push   %edx
  80224c:	50                   	push   %eax
  80224d:	6a 16                	push   $0x16
  80224f:	e8 c6 fd ff ff       	call   80201a <syscall>
  802254:	83 c4 18             	add    $0x18,%esp
}
  802257:	c9                   	leave  
  802258:	c3                   	ret    

00802259 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80225c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80225f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	51                   	push   %ecx
  80226a:	52                   	push   %edx
  80226b:	50                   	push   %eax
  80226c:	6a 17                	push   $0x17
  80226e:	e8 a7 fd ff ff       	call   80201a <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
}
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80227b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	52                   	push   %edx
  802288:	50                   	push   %eax
  802289:	6a 18                	push   $0x18
  80228b:	e8 8a fd ff ff       	call   80201a <syscall>
  802290:	83 c4 18             	add    $0x18,%esp
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	6a 00                	push   $0x0
  80229d:	ff 75 14             	pushl  0x14(%ebp)
  8022a0:	ff 75 10             	pushl  0x10(%ebp)
  8022a3:	ff 75 0c             	pushl  0xc(%ebp)
  8022a6:	50                   	push   %eax
  8022a7:	6a 19                	push   $0x19
  8022a9:	e8 6c fd ff ff       	call   80201a <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	50                   	push   %eax
  8022c2:	6a 1a                	push   $0x1a
  8022c4:	e8 51 fd ff ff       	call   80201a <syscall>
  8022c9:	83 c4 18             	add    $0x18,%esp
}
  8022cc:	90                   	nop
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	50                   	push   %eax
  8022de:	6a 1b                	push   $0x1b
  8022e0:	e8 35 fd ff ff       	call   80201a <syscall>
  8022e5:	83 c4 18             	add    $0x18,%esp
}
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 05                	push   $0x5
  8022f9:	e8 1c fd ff ff       	call   80201a <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
}
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 06                	push   $0x6
  802312:	e8 03 fd ff ff       	call   80201a <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 07                	push   $0x7
  80232b:	e8 ea fc ff ff       	call   80201a <syscall>
  802330:	83 c4 18             	add    $0x18,%esp
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <sys_exit_env>:


void sys_exit_env(void)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 1c                	push   $0x1c
  802344:	e8 d1 fc ff ff       	call   80201a <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
}
  80234c:	90                   	nop
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
  802352:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802355:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802358:	8d 50 04             	lea    0x4(%eax),%edx
  80235b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	52                   	push   %edx
  802365:	50                   	push   %eax
  802366:	6a 1d                	push   $0x1d
  802368:	e8 ad fc ff ff       	call   80201a <syscall>
  80236d:	83 c4 18             	add    $0x18,%esp
	return result;
  802370:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802373:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802376:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802379:	89 01                	mov    %eax,(%ecx)
  80237b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	c9                   	leave  
  802382:	c2 04 00             	ret    $0x4

00802385 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	ff 75 10             	pushl  0x10(%ebp)
  80238f:	ff 75 0c             	pushl  0xc(%ebp)
  802392:	ff 75 08             	pushl  0x8(%ebp)
  802395:	6a 13                	push   $0x13
  802397:	e8 7e fc ff ff       	call   80201a <syscall>
  80239c:	83 c4 18             	add    $0x18,%esp
	return ;
  80239f:	90                   	nop
}
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 1e                	push   $0x1e
  8023b1:	e8 64 fc ff ff       	call   80201a <syscall>
  8023b6:	83 c4 18             	add    $0x18,%esp
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	83 ec 04             	sub    $0x4,%esp
  8023c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023c7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	50                   	push   %eax
  8023d4:	6a 1f                	push   $0x1f
  8023d6:	e8 3f fc ff ff       	call   80201a <syscall>
  8023db:	83 c4 18             	add    $0x18,%esp
	return ;
  8023de:	90                   	nop
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <rsttst>:
void rsttst()
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 21                	push   $0x21
  8023f0:	e8 25 fc ff ff       	call   80201a <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f8:	90                   	nop
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	83 ec 04             	sub    $0x4,%esp
  802401:	8b 45 14             	mov    0x14(%ebp),%eax
  802404:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802407:	8b 55 18             	mov    0x18(%ebp),%edx
  80240a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80240e:	52                   	push   %edx
  80240f:	50                   	push   %eax
  802410:	ff 75 10             	pushl  0x10(%ebp)
  802413:	ff 75 0c             	pushl  0xc(%ebp)
  802416:	ff 75 08             	pushl  0x8(%ebp)
  802419:	6a 20                	push   $0x20
  80241b:	e8 fa fb ff ff       	call   80201a <syscall>
  802420:	83 c4 18             	add    $0x18,%esp
	return ;
  802423:	90                   	nop
}
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <chktst>:
void chktst(uint32 n)
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	ff 75 08             	pushl  0x8(%ebp)
  802434:	6a 22                	push   $0x22
  802436:	e8 df fb ff ff       	call   80201a <syscall>
  80243b:	83 c4 18             	add    $0x18,%esp
	return ;
  80243e:	90                   	nop
}
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <inctst>:

void inctst()
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 23                	push   $0x23
  802450:	e8 c5 fb ff ff       	call   80201a <syscall>
  802455:	83 c4 18             	add    $0x18,%esp
	return ;
  802458:	90                   	nop
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <gettst>:
uint32 gettst()
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 24                	push   $0x24
  80246a:	e8 ab fb ff ff       	call   80201a <syscall>
  80246f:	83 c4 18             	add    $0x18,%esp
}
  802472:	c9                   	leave  
  802473:	c3                   	ret    

00802474 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
  802477:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 25                	push   $0x25
  802486:	e8 8f fb ff ff       	call   80201a <syscall>
  80248b:	83 c4 18             	add    $0x18,%esp
  80248e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802491:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802495:	75 07                	jne    80249e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802497:	b8 01 00 00 00       	mov    $0x1,%eax
  80249c:	eb 05                	jmp    8024a3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80249e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
  8024a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 25                	push   $0x25
  8024b7:	e8 5e fb ff ff       	call   80201a <syscall>
  8024bc:	83 c4 18             	add    $0x18,%esp
  8024bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024c2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024c6:	75 07                	jne    8024cf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8024cd:	eb 05                	jmp    8024d4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 25                	push   $0x25
  8024e8:	e8 2d fb ff ff       	call   80201a <syscall>
  8024ed:	83 c4 18             	add    $0x18,%esp
  8024f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024f3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024f7:	75 07                	jne    802500 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024fe:	eb 05                	jmp    802505 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802500:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 25                	push   $0x25
  802519:	e8 fc fa ff ff       	call   80201a <syscall>
  80251e:	83 c4 18             	add    $0x18,%esp
  802521:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802524:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802528:	75 07                	jne    802531 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80252a:	b8 01 00 00 00       	mov    $0x1,%eax
  80252f:	eb 05                	jmp    802536 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802531:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	ff 75 08             	pushl  0x8(%ebp)
  802546:	6a 26                	push   $0x26
  802548:	e8 cd fa ff ff       	call   80201a <syscall>
  80254d:	83 c4 18             	add    $0x18,%esp
	return ;
  802550:	90                   	nop
}
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
  802556:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802557:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80255a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80255d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802560:	8b 45 08             	mov    0x8(%ebp),%eax
  802563:	6a 00                	push   $0x0
  802565:	53                   	push   %ebx
  802566:	51                   	push   %ecx
  802567:	52                   	push   %edx
  802568:	50                   	push   %eax
  802569:	6a 27                	push   $0x27
  80256b:	e8 aa fa ff ff       	call   80201a <syscall>
  802570:	83 c4 18             	add    $0x18,%esp
}
  802573:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80257b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	52                   	push   %edx
  802588:	50                   	push   %eax
  802589:	6a 28                	push   $0x28
  80258b:	e8 8a fa ff ff       	call   80201a <syscall>
  802590:	83 c4 18             	add    $0x18,%esp
}
  802593:	c9                   	leave  
  802594:	c3                   	ret    

00802595 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802598:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80259b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259e:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a1:	6a 00                	push   $0x0
  8025a3:	51                   	push   %ecx
  8025a4:	ff 75 10             	pushl  0x10(%ebp)
  8025a7:	52                   	push   %edx
  8025a8:	50                   	push   %eax
  8025a9:	6a 29                	push   $0x29
  8025ab:	e8 6a fa ff ff       	call   80201a <syscall>
  8025b0:	83 c4 18             	add    $0x18,%esp
}
  8025b3:	c9                   	leave  
  8025b4:	c3                   	ret    

008025b5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	ff 75 10             	pushl  0x10(%ebp)
  8025bf:	ff 75 0c             	pushl  0xc(%ebp)
  8025c2:	ff 75 08             	pushl  0x8(%ebp)
  8025c5:	6a 12                	push   $0x12
  8025c7:	e8 4e fa ff ff       	call   80201a <syscall>
  8025cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8025cf:	90                   	nop
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    

008025d2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8025d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	52                   	push   %edx
  8025e2:	50                   	push   %eax
  8025e3:	6a 2a                	push   $0x2a
  8025e5:	e8 30 fa ff ff       	call   80201a <syscall>
  8025ea:	83 c4 18             	add    $0x18,%esp
	return;
  8025ed:	90                   	nop
}
  8025ee:	c9                   	leave  
  8025ef:	c3                   	ret    

008025f0 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8025f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	50                   	push   %eax
  8025ff:	6a 2b                	push   $0x2b
  802601:	e8 14 fa ff ff       	call   80201a <syscall>
  802606:	83 c4 18             	add    $0x18,%esp
}
  802609:	c9                   	leave  
  80260a:	c3                   	ret    

0080260b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	ff 75 0c             	pushl  0xc(%ebp)
  802617:	ff 75 08             	pushl  0x8(%ebp)
  80261a:	6a 2c                	push   $0x2c
  80261c:	e8 f9 f9 ff ff       	call   80201a <syscall>
  802621:	83 c4 18             	add    $0x18,%esp
	return;
  802624:	90                   	nop
}
  802625:	c9                   	leave  
  802626:	c3                   	ret    

00802627 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802627:	55                   	push   %ebp
  802628:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	ff 75 0c             	pushl  0xc(%ebp)
  802633:	ff 75 08             	pushl  0x8(%ebp)
  802636:	6a 2d                	push   $0x2d
  802638:	e8 dd f9 ff ff       	call   80201a <syscall>
  80263d:	83 c4 18             	add    $0x18,%esp
	return;
  802640:	90                   	nop
}
  802641:	c9                   	leave  
  802642:	c3                   	ret    

00802643 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
  802646:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	83 e8 04             	sub    $0x4,%eax
  80264f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802652:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80265a:	c9                   	leave  
  80265b:	c3                   	ret    

0080265c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
  80265f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802662:	8b 45 08             	mov    0x8(%ebp),%eax
  802665:	83 e8 04             	sub    $0x4,%eax
  802668:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80266b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80266e:	8b 00                	mov    (%eax),%eax
  802670:	83 e0 01             	and    $0x1,%eax
  802673:	85 c0                	test   %eax,%eax
  802675:	0f 94 c0             	sete   %al
}
  802678:	c9                   	leave  
  802679:	c3                   	ret    

0080267a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80267a:	55                   	push   %ebp
  80267b:	89 e5                	mov    %esp,%ebp
  80267d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802680:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80268a:	83 f8 02             	cmp    $0x2,%eax
  80268d:	74 2b                	je     8026ba <alloc_block+0x40>
  80268f:	83 f8 02             	cmp    $0x2,%eax
  802692:	7f 07                	jg     80269b <alloc_block+0x21>
  802694:	83 f8 01             	cmp    $0x1,%eax
  802697:	74 0e                	je     8026a7 <alloc_block+0x2d>
  802699:	eb 58                	jmp    8026f3 <alloc_block+0x79>
  80269b:	83 f8 03             	cmp    $0x3,%eax
  80269e:	74 2d                	je     8026cd <alloc_block+0x53>
  8026a0:	83 f8 04             	cmp    $0x4,%eax
  8026a3:	74 3b                	je     8026e0 <alloc_block+0x66>
  8026a5:	eb 4c                	jmp    8026f3 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8026a7:	83 ec 0c             	sub    $0xc,%esp
  8026aa:	ff 75 08             	pushl  0x8(%ebp)
  8026ad:	e8 11 03 00 00       	call   8029c3 <alloc_block_FF>
  8026b2:	83 c4 10             	add    $0x10,%esp
  8026b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026b8:	eb 4a                	jmp    802704 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8026ba:	83 ec 0c             	sub    $0xc,%esp
  8026bd:	ff 75 08             	pushl  0x8(%ebp)
  8026c0:	e8 fa 19 00 00       	call   8040bf <alloc_block_NF>
  8026c5:	83 c4 10             	add    $0x10,%esp
  8026c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026cb:	eb 37                	jmp    802704 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8026cd:	83 ec 0c             	sub    $0xc,%esp
  8026d0:	ff 75 08             	pushl  0x8(%ebp)
  8026d3:	e8 a7 07 00 00       	call   802e7f <alloc_block_BF>
  8026d8:	83 c4 10             	add    $0x10,%esp
  8026db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026de:	eb 24                	jmp    802704 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8026e0:	83 ec 0c             	sub    $0xc,%esp
  8026e3:	ff 75 08             	pushl  0x8(%ebp)
  8026e6:	e8 b7 19 00 00       	call   8040a2 <alloc_block_WF>
  8026eb:	83 c4 10             	add    $0x10,%esp
  8026ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026f1:	eb 11                	jmp    802704 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8026f3:	83 ec 0c             	sub    $0xc,%esp
  8026f6:	68 8c 4b 80 00       	push   $0x804b8c
  8026fb:	e8 33 e4 ff ff       	call   800b33 <cprintf>
  802700:	83 c4 10             	add    $0x10,%esp
		break;
  802703:	90                   	nop
	}
	return va;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802707:	c9                   	leave  
  802708:	c3                   	ret    

00802709 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
  80270c:	53                   	push   %ebx
  80270d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802710:	83 ec 0c             	sub    $0xc,%esp
  802713:	68 ac 4b 80 00       	push   $0x804bac
  802718:	e8 16 e4 ff ff       	call   800b33 <cprintf>
  80271d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802720:	83 ec 0c             	sub    $0xc,%esp
  802723:	68 d7 4b 80 00       	push   $0x804bd7
  802728:	e8 06 e4 ff ff       	call   800b33 <cprintf>
  80272d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802730:	8b 45 08             	mov    0x8(%ebp),%eax
  802733:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802736:	eb 37                	jmp    80276f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802738:	83 ec 0c             	sub    $0xc,%esp
  80273b:	ff 75 f4             	pushl  -0xc(%ebp)
  80273e:	e8 19 ff ff ff       	call   80265c <is_free_block>
  802743:	83 c4 10             	add    $0x10,%esp
  802746:	0f be d8             	movsbl %al,%ebx
  802749:	83 ec 0c             	sub    $0xc,%esp
  80274c:	ff 75 f4             	pushl  -0xc(%ebp)
  80274f:	e8 ef fe ff ff       	call   802643 <get_block_size>
  802754:	83 c4 10             	add    $0x10,%esp
  802757:	83 ec 04             	sub    $0x4,%esp
  80275a:	53                   	push   %ebx
  80275b:	50                   	push   %eax
  80275c:	68 ef 4b 80 00       	push   $0x804bef
  802761:	e8 cd e3 ff ff       	call   800b33 <cprintf>
  802766:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802769:	8b 45 10             	mov    0x10(%ebp),%eax
  80276c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802773:	74 07                	je     80277c <print_blocks_list+0x73>
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	8b 00                	mov    (%eax),%eax
  80277a:	eb 05                	jmp    802781 <print_blocks_list+0x78>
  80277c:	b8 00 00 00 00       	mov    $0x0,%eax
  802781:	89 45 10             	mov    %eax,0x10(%ebp)
  802784:	8b 45 10             	mov    0x10(%ebp),%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	75 ad                	jne    802738 <print_blocks_list+0x2f>
  80278b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278f:	75 a7                	jne    802738 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802791:	83 ec 0c             	sub    $0xc,%esp
  802794:	68 ac 4b 80 00       	push   $0x804bac
  802799:	e8 95 e3 ff ff       	call   800b33 <cprintf>
  80279e:	83 c4 10             	add    $0x10,%esp

}
  8027a1:	90                   	nop
  8027a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    

008027a7 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
  8027aa:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8027ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b0:	83 e0 01             	and    $0x1,%eax
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	74 03                	je     8027ba <initialize_dynamic_allocator+0x13>
  8027b7:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8027ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027be:	0f 84 c7 01 00 00    	je     80298b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8027c4:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8027cb:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8027ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027d4:	01 d0                	add    %edx,%eax
  8027d6:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8027db:	0f 87 ad 01 00 00    	ja     80298e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8027e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	0f 89 a5 01 00 00    	jns    802991 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8027ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f2:	01 d0                	add    %edx,%eax
  8027f4:	83 e8 04             	sub    $0x4,%eax
  8027f7:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8027fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802803:	a1 30 50 80 00       	mov    0x805030,%eax
  802808:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280b:	e9 87 00 00 00       	jmp    802897 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802810:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802814:	75 14                	jne    80282a <initialize_dynamic_allocator+0x83>
  802816:	83 ec 04             	sub    $0x4,%esp
  802819:	68 07 4c 80 00       	push   $0x804c07
  80281e:	6a 79                	push   $0x79
  802820:	68 25 4c 80 00       	push   $0x804c25
  802825:	e8 4c e0 ff ff       	call   800876 <_panic>
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	8b 00                	mov    (%eax),%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	74 10                	je     802843 <initialize_dynamic_allocator+0x9c>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283b:	8b 52 04             	mov    0x4(%edx),%edx
  80283e:	89 50 04             	mov    %edx,0x4(%eax)
  802841:	eb 0b                	jmp    80284e <initialize_dynamic_allocator+0xa7>
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 40 04             	mov    0x4(%eax),%eax
  802849:	a3 34 50 80 00       	mov    %eax,0x805034
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 40 04             	mov    0x4(%eax),%eax
  802854:	85 c0                	test   %eax,%eax
  802856:	74 0f                	je     802867 <initialize_dynamic_allocator+0xc0>
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 40 04             	mov    0x4(%eax),%eax
  80285e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802861:	8b 12                	mov    (%edx),%edx
  802863:	89 10                	mov    %edx,(%eax)
  802865:	eb 0a                	jmp    802871 <initialize_dynamic_allocator+0xca>
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 00                	mov    (%eax),%eax
  80286c:	a3 30 50 80 00       	mov    %eax,0x805030
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802884:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802889:	48                   	dec    %eax
  80288a:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80288f:	a1 38 50 80 00       	mov    0x805038,%eax
  802894:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802897:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289b:	74 07                	je     8028a4 <initialize_dynamic_allocator+0xfd>
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	eb 05                	jmp    8028a9 <initialize_dynamic_allocator+0x102>
  8028a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a9:	a3 38 50 80 00       	mov    %eax,0x805038
  8028ae:	a1 38 50 80 00       	mov    0x805038,%eax
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	0f 85 55 ff ff ff    	jne    802810 <initialize_dynamic_allocator+0x69>
  8028bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bf:	0f 85 4b ff ff ff    	jne    802810 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8028cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ce:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8028d4:	a1 48 50 80 00       	mov    0x805048,%eax
  8028d9:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8028de:	a1 44 50 80 00       	mov    0x805044,%eax
  8028e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ec:	83 c0 08             	add    $0x8,%eax
  8028ef:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8028f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f5:	83 c0 04             	add    $0x4,%eax
  8028f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028fb:	83 ea 08             	sub    $0x8,%edx
  8028fe:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802900:	8b 55 0c             	mov    0xc(%ebp),%edx
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	01 d0                	add    %edx,%eax
  802908:	83 e8 08             	sub    $0x8,%eax
  80290b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80290e:	83 ea 08             	sub    $0x8,%edx
  802911:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802913:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802916:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80291c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802926:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80292a:	75 17                	jne    802943 <initialize_dynamic_allocator+0x19c>
  80292c:	83 ec 04             	sub    $0x4,%esp
  80292f:	68 40 4c 80 00       	push   $0x804c40
  802934:	68 90 00 00 00       	push   $0x90
  802939:	68 25 4c 80 00       	push   $0x804c25
  80293e:	e8 33 df ff ff       	call   800876 <_panic>
  802943:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802949:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294c:	89 10                	mov    %edx,(%eax)
  80294e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802951:	8b 00                	mov    (%eax),%eax
  802953:	85 c0                	test   %eax,%eax
  802955:	74 0d                	je     802964 <initialize_dynamic_allocator+0x1bd>
  802957:	a1 30 50 80 00       	mov    0x805030,%eax
  80295c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80295f:	89 50 04             	mov    %edx,0x4(%eax)
  802962:	eb 08                	jmp    80296c <initialize_dynamic_allocator+0x1c5>
  802964:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802967:	a3 34 50 80 00       	mov    %eax,0x805034
  80296c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296f:	a3 30 50 80 00       	mov    %eax,0x805030
  802974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802977:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802983:	40                   	inc    %eax
  802984:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802989:	eb 07                	jmp    802992 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80298b:	90                   	nop
  80298c:	eb 04                	jmp    802992 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80298e:	90                   	nop
  80298f:	eb 01                	jmp    802992 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802991:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802992:	c9                   	leave  
  802993:	c3                   	ret    

00802994 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802994:	55                   	push   %ebp
  802995:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802997:	8b 45 10             	mov    0x10(%ebp),%eax
  80299a:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80299d:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a0:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029a6:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	83 e8 04             	sub    $0x4,%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	83 e0 fe             	and    $0xfffffffe,%eax
  8029b3:	8d 50 f8             	lea    -0x8(%eax),%edx
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	01 c2                	add    %eax,%edx
  8029bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029be:	89 02                	mov    %eax,(%edx)
}
  8029c0:	90                   	nop
  8029c1:	5d                   	pop    %ebp
  8029c2:	c3                   	ret    

008029c3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8029c3:	55                   	push   %ebp
  8029c4:	89 e5                	mov    %esp,%ebp
  8029c6:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cc:	83 e0 01             	and    $0x1,%eax
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	74 03                	je     8029d6 <alloc_block_FF+0x13>
  8029d3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8029d6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8029da:	77 07                	ja     8029e3 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8029dc:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8029e3:	a1 28 50 80 00       	mov    0x805028,%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	75 73                	jne    802a5f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8029ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ef:	83 c0 10             	add    $0x10,%eax
  8029f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8029f5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8029fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a02:	01 d0                	add    %edx,%eax
  802a04:	48                   	dec    %eax
  802a05:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0b:	ba 00 00 00 00       	mov    $0x0,%edx
  802a10:	f7 75 ec             	divl   -0x14(%ebp)
  802a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a16:	29 d0                	sub    %edx,%eax
  802a18:	c1 e8 0c             	shr    $0xc,%eax
  802a1b:	83 ec 0c             	sub    $0xc,%esp
  802a1e:	50                   	push   %eax
  802a1f:	e8 b1 f0 ff ff       	call   801ad5 <sbrk>
  802a24:	83 c4 10             	add    $0x10,%esp
  802a27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a2a:	83 ec 0c             	sub    $0xc,%esp
  802a2d:	6a 00                	push   $0x0
  802a2f:	e8 a1 f0 ff ff       	call   801ad5 <sbrk>
  802a34:	83 c4 10             	add    $0x10,%esp
  802a37:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a3d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802a40:	83 ec 08             	sub    $0x8,%esp
  802a43:	50                   	push   %eax
  802a44:	ff 75 e4             	pushl  -0x1c(%ebp)
  802a47:	e8 5b fd ff ff       	call   8027a7 <initialize_dynamic_allocator>
  802a4c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802a4f:	83 ec 0c             	sub    $0xc,%esp
  802a52:	68 63 4c 80 00       	push   $0x804c63
  802a57:	e8 d7 e0 ff ff       	call   800b33 <cprintf>
  802a5c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802a5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a63:	75 0a                	jne    802a6f <alloc_block_FF+0xac>
	        return NULL;
  802a65:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6a:	e9 0e 04 00 00       	jmp    802e7d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802a6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a76:	a1 30 50 80 00       	mov    0x805030,%eax
  802a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a7e:	e9 f3 02 00 00       	jmp    802d76 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802a89:	83 ec 0c             	sub    $0xc,%esp
  802a8c:	ff 75 bc             	pushl  -0x44(%ebp)
  802a8f:	e8 af fb ff ff       	call   802643 <get_block_size>
  802a94:	83 c4 10             	add    $0x10,%esp
  802a97:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	83 c0 08             	add    $0x8,%eax
  802aa0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802aa3:	0f 87 c5 02 00 00    	ja     802d6e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	83 c0 18             	add    $0x18,%eax
  802aaf:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802ab2:	0f 87 19 02 00 00    	ja     802cd1 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802ab8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802abb:	2b 45 08             	sub    0x8(%ebp),%eax
  802abe:	83 e8 08             	sub    $0x8,%eax
  802ac1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	8d 50 08             	lea    0x8(%eax),%edx
  802aca:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802acd:	01 d0                	add    %edx,%eax
  802acf:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	83 c0 08             	add    $0x8,%eax
  802ad8:	83 ec 04             	sub    $0x4,%esp
  802adb:	6a 01                	push   $0x1
  802add:	50                   	push   %eax
  802ade:	ff 75 bc             	pushl  -0x44(%ebp)
  802ae1:	e8 ae fe ff ff       	call   802994 <set_block_data>
  802ae6:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 40 04             	mov    0x4(%eax),%eax
  802aef:	85 c0                	test   %eax,%eax
  802af1:	75 68                	jne    802b5b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802af3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802af7:	75 17                	jne    802b10 <alloc_block_FF+0x14d>
  802af9:	83 ec 04             	sub    $0x4,%esp
  802afc:	68 40 4c 80 00       	push   $0x804c40
  802b01:	68 d7 00 00 00       	push   $0xd7
  802b06:	68 25 4c 80 00       	push   $0x804c25
  802b0b:	e8 66 dd ff ff       	call   800876 <_panic>
  802b10:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b16:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b19:	89 10                	mov    %edx,(%eax)
  802b1b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b1e:	8b 00                	mov    (%eax),%eax
  802b20:	85 c0                	test   %eax,%eax
  802b22:	74 0d                	je     802b31 <alloc_block_FF+0x16e>
  802b24:	a1 30 50 80 00       	mov    0x805030,%eax
  802b29:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b2c:	89 50 04             	mov    %edx,0x4(%eax)
  802b2f:	eb 08                	jmp    802b39 <alloc_block_FF+0x176>
  802b31:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b34:	a3 34 50 80 00       	mov    %eax,0x805034
  802b39:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b3c:	a3 30 50 80 00       	mov    %eax,0x805030
  802b41:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b50:	40                   	inc    %eax
  802b51:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b56:	e9 dc 00 00 00       	jmp    802c37 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 00                	mov    (%eax),%eax
  802b60:	85 c0                	test   %eax,%eax
  802b62:	75 65                	jne    802bc9 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b64:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b68:	75 17                	jne    802b81 <alloc_block_FF+0x1be>
  802b6a:	83 ec 04             	sub    $0x4,%esp
  802b6d:	68 74 4c 80 00       	push   $0x804c74
  802b72:	68 db 00 00 00       	push   $0xdb
  802b77:	68 25 4c 80 00       	push   $0x804c25
  802b7c:	e8 f5 dc ff ff       	call   800876 <_panic>
  802b81:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802b87:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b8a:	89 50 04             	mov    %edx,0x4(%eax)
  802b8d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b90:	8b 40 04             	mov    0x4(%eax),%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	74 0c                	je     802ba3 <alloc_block_FF+0x1e0>
  802b97:	a1 34 50 80 00       	mov    0x805034,%eax
  802b9c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b9f:	89 10                	mov    %edx,(%eax)
  802ba1:	eb 08                	jmp    802bab <alloc_block_FF+0x1e8>
  802ba3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba6:	a3 30 50 80 00       	mov    %eax,0x805030
  802bab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bae:	a3 34 50 80 00       	mov    %eax,0x805034
  802bb3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bc1:	40                   	inc    %eax
  802bc2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802bc7:	eb 6e                	jmp    802c37 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802bc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcd:	74 06                	je     802bd5 <alloc_block_FF+0x212>
  802bcf:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802bd3:	75 17                	jne    802bec <alloc_block_FF+0x229>
  802bd5:	83 ec 04             	sub    $0x4,%esp
  802bd8:	68 98 4c 80 00       	push   $0x804c98
  802bdd:	68 df 00 00 00       	push   $0xdf
  802be2:	68 25 4c 80 00       	push   $0x804c25
  802be7:	e8 8a dc ff ff       	call   800876 <_panic>
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 10                	mov    (%eax),%edx
  802bf1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bf4:	89 10                	mov    %edx,(%eax)
  802bf6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bf9:	8b 00                	mov    (%eax),%eax
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	74 0b                	je     802c0a <alloc_block_FF+0x247>
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	8b 00                	mov    (%eax),%eax
  802c04:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c07:	89 50 04             	mov    %edx,0x4(%eax)
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802c10:	89 10                	mov    %edx,(%eax)
  802c12:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c18:	89 50 04             	mov    %edx,0x4(%eax)
  802c1b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c1e:	8b 00                	mov    (%eax),%eax
  802c20:	85 c0                	test   %eax,%eax
  802c22:	75 08                	jne    802c2c <alloc_block_FF+0x269>
  802c24:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c27:	a3 34 50 80 00       	mov    %eax,0x805034
  802c2c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c31:	40                   	inc    %eax
  802c32:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802c37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3b:	75 17                	jne    802c54 <alloc_block_FF+0x291>
  802c3d:	83 ec 04             	sub    $0x4,%esp
  802c40:	68 07 4c 80 00       	push   $0x804c07
  802c45:	68 e1 00 00 00       	push   $0xe1
  802c4a:	68 25 4c 80 00       	push   $0x804c25
  802c4f:	e8 22 dc ff ff       	call   800876 <_panic>
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	85 c0                	test   %eax,%eax
  802c5b:	74 10                	je     802c6d <alloc_block_FF+0x2aa>
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 00                	mov    (%eax),%eax
  802c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c65:	8b 52 04             	mov    0x4(%edx),%edx
  802c68:	89 50 04             	mov    %edx,0x4(%eax)
  802c6b:	eb 0b                	jmp    802c78 <alloc_block_FF+0x2b5>
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 40 04             	mov    0x4(%eax),%eax
  802c73:	a3 34 50 80 00       	mov    %eax,0x805034
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 40 04             	mov    0x4(%eax),%eax
  802c7e:	85 c0                	test   %eax,%eax
  802c80:	74 0f                	je     802c91 <alloc_block_FF+0x2ce>
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	8b 40 04             	mov    0x4(%eax),%eax
  802c88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8b:	8b 12                	mov    (%edx),%edx
  802c8d:	89 10                	mov    %edx,(%eax)
  802c8f:	eb 0a                	jmp    802c9b <alloc_block_FF+0x2d8>
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 00                	mov    (%eax),%eax
  802c96:	a3 30 50 80 00       	mov    %eax,0x805030
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cae:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cb3:	48                   	dec    %eax
  802cb4:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802cb9:	83 ec 04             	sub    $0x4,%esp
  802cbc:	6a 00                	push   $0x0
  802cbe:	ff 75 b4             	pushl  -0x4c(%ebp)
  802cc1:	ff 75 b0             	pushl  -0x50(%ebp)
  802cc4:	e8 cb fc ff ff       	call   802994 <set_block_data>
  802cc9:	83 c4 10             	add    $0x10,%esp
  802ccc:	e9 95 00 00 00       	jmp    802d66 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802cd1:	83 ec 04             	sub    $0x4,%esp
  802cd4:	6a 01                	push   $0x1
  802cd6:	ff 75 b8             	pushl  -0x48(%ebp)
  802cd9:	ff 75 bc             	pushl  -0x44(%ebp)
  802cdc:	e8 b3 fc ff ff       	call   802994 <set_block_data>
  802ce1:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802ce4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce8:	75 17                	jne    802d01 <alloc_block_FF+0x33e>
  802cea:	83 ec 04             	sub    $0x4,%esp
  802ced:	68 07 4c 80 00       	push   $0x804c07
  802cf2:	68 e8 00 00 00       	push   $0xe8
  802cf7:	68 25 4c 80 00       	push   $0x804c25
  802cfc:	e8 75 db ff ff       	call   800876 <_panic>
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	8b 00                	mov    (%eax),%eax
  802d06:	85 c0                	test   %eax,%eax
  802d08:	74 10                	je     802d1a <alloc_block_FF+0x357>
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 00                	mov    (%eax),%eax
  802d0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d12:	8b 52 04             	mov    0x4(%edx),%edx
  802d15:	89 50 04             	mov    %edx,0x4(%eax)
  802d18:	eb 0b                	jmp    802d25 <alloc_block_FF+0x362>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 40 04             	mov    0x4(%eax),%eax
  802d20:	a3 34 50 80 00       	mov    %eax,0x805034
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	8b 40 04             	mov    0x4(%eax),%eax
  802d2b:	85 c0                	test   %eax,%eax
  802d2d:	74 0f                	je     802d3e <alloc_block_FF+0x37b>
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	8b 40 04             	mov    0x4(%eax),%eax
  802d35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d38:	8b 12                	mov    (%edx),%edx
  802d3a:	89 10                	mov    %edx,(%eax)
  802d3c:	eb 0a                	jmp    802d48 <alloc_block_FF+0x385>
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	8b 00                	mov    (%eax),%eax
  802d43:	a3 30 50 80 00       	mov    %eax,0x805030
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d60:	48                   	dec    %eax
  802d61:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802d66:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d69:	e9 0f 01 00 00       	jmp    802e7d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802d6e:	a1 38 50 80 00       	mov    0x805038,%eax
  802d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7a:	74 07                	je     802d83 <alloc_block_FF+0x3c0>
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	8b 00                	mov    (%eax),%eax
  802d81:	eb 05                	jmp    802d88 <alloc_block_FF+0x3c5>
  802d83:	b8 00 00 00 00       	mov    $0x0,%eax
  802d88:	a3 38 50 80 00       	mov    %eax,0x805038
  802d8d:	a1 38 50 80 00       	mov    0x805038,%eax
  802d92:	85 c0                	test   %eax,%eax
  802d94:	0f 85 e9 fc ff ff    	jne    802a83 <alloc_block_FF+0xc0>
  802d9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9e:	0f 85 df fc ff ff    	jne    802a83 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	83 c0 08             	add    $0x8,%eax
  802daa:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802dad:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802db4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802db7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802dba:	01 d0                	add    %edx,%eax
  802dbc:	48                   	dec    %eax
  802dbd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802dc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dc3:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc8:	f7 75 d8             	divl   -0x28(%ebp)
  802dcb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dce:	29 d0                	sub    %edx,%eax
  802dd0:	c1 e8 0c             	shr    $0xc,%eax
  802dd3:	83 ec 0c             	sub    $0xc,%esp
  802dd6:	50                   	push   %eax
  802dd7:	e8 f9 ec ff ff       	call   801ad5 <sbrk>
  802ddc:	83 c4 10             	add    $0x10,%esp
  802ddf:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802de2:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802de6:	75 0a                	jne    802df2 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802de8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ded:	e9 8b 00 00 00       	jmp    802e7d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802df2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802df9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dfc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802dff:	01 d0                	add    %edx,%eax
  802e01:	48                   	dec    %eax
  802e02:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802e05:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e08:	ba 00 00 00 00       	mov    $0x0,%edx
  802e0d:	f7 75 cc             	divl   -0x34(%ebp)
  802e10:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e13:	29 d0                	sub    %edx,%eax
  802e15:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e18:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e1b:	01 d0                	add    %edx,%eax
  802e1d:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802e22:	a1 44 50 80 00       	mov    0x805044,%eax
  802e27:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e2d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e34:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e37:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e3a:	01 d0                	add    %edx,%eax
  802e3c:	48                   	dec    %eax
  802e3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e40:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e43:	ba 00 00 00 00       	mov    $0x0,%edx
  802e48:	f7 75 c4             	divl   -0x3c(%ebp)
  802e4b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e4e:	29 d0                	sub    %edx,%eax
  802e50:	83 ec 04             	sub    $0x4,%esp
  802e53:	6a 01                	push   $0x1
  802e55:	50                   	push   %eax
  802e56:	ff 75 d0             	pushl  -0x30(%ebp)
  802e59:	e8 36 fb ff ff       	call   802994 <set_block_data>
  802e5e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802e61:	83 ec 0c             	sub    $0xc,%esp
  802e64:	ff 75 d0             	pushl  -0x30(%ebp)
  802e67:	e8 1b 0a 00 00       	call   803887 <free_block>
  802e6c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802e6f:	83 ec 0c             	sub    $0xc,%esp
  802e72:	ff 75 08             	pushl  0x8(%ebp)
  802e75:	e8 49 fb ff ff       	call   8029c3 <alloc_block_FF>
  802e7a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802e7d:	c9                   	leave  
  802e7e:	c3                   	ret    

00802e7f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e7f:	55                   	push   %ebp
  802e80:	89 e5                	mov    %esp,%ebp
  802e82:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	83 e0 01             	and    $0x1,%eax
  802e8b:	85 c0                	test   %eax,%eax
  802e8d:	74 03                	je     802e92 <alloc_block_BF+0x13>
  802e8f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802e92:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802e96:	77 07                	ja     802e9f <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802e98:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802e9f:	a1 28 50 80 00       	mov    0x805028,%eax
  802ea4:	85 c0                	test   %eax,%eax
  802ea6:	75 73                	jne    802f1b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	83 c0 10             	add    $0x10,%eax
  802eae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802eb1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802eb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ebb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ebe:	01 d0                	add    %edx,%eax
  802ec0:	48                   	dec    %eax
  802ec1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ec4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ec7:	ba 00 00 00 00       	mov    $0x0,%edx
  802ecc:	f7 75 e0             	divl   -0x20(%ebp)
  802ecf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed2:	29 d0                	sub    %edx,%eax
  802ed4:	c1 e8 0c             	shr    $0xc,%eax
  802ed7:	83 ec 0c             	sub    $0xc,%esp
  802eda:	50                   	push   %eax
  802edb:	e8 f5 eb ff ff       	call   801ad5 <sbrk>
  802ee0:	83 c4 10             	add    $0x10,%esp
  802ee3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802ee6:	83 ec 0c             	sub    $0xc,%esp
  802ee9:	6a 00                	push   $0x0
  802eeb:	e8 e5 eb ff ff       	call   801ad5 <sbrk>
  802ef0:	83 c4 10             	add    $0x10,%esp
  802ef3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802ef6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ef9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802efc:	83 ec 08             	sub    $0x8,%esp
  802eff:	50                   	push   %eax
  802f00:	ff 75 d8             	pushl  -0x28(%ebp)
  802f03:	e8 9f f8 ff ff       	call   8027a7 <initialize_dynamic_allocator>
  802f08:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802f0b:	83 ec 0c             	sub    $0xc,%esp
  802f0e:	68 63 4c 80 00       	push   $0x804c63
  802f13:	e8 1b dc ff ff       	call   800b33 <cprintf>
  802f18:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802f1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802f22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802f29:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802f30:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802f37:	a1 30 50 80 00       	mov    0x805030,%eax
  802f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f3f:	e9 1d 01 00 00       	jmp    803061 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802f4a:	83 ec 0c             	sub    $0xc,%esp
  802f4d:	ff 75 a8             	pushl  -0x58(%ebp)
  802f50:	e8 ee f6 ff ff       	call   802643 <get_block_size>
  802f55:	83 c4 10             	add    $0x10,%esp
  802f58:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	83 c0 08             	add    $0x8,%eax
  802f61:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f64:	0f 87 ef 00 00 00    	ja     803059 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	83 c0 18             	add    $0x18,%eax
  802f70:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f73:	77 1d                	ja     802f92 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f78:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f7b:	0f 86 d8 00 00 00    	jbe    803059 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802f81:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f84:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802f87:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802f8d:	e9 c7 00 00 00       	jmp    803059 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	83 c0 08             	add    $0x8,%eax
  802f98:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f9b:	0f 85 9d 00 00 00    	jne    80303e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802fa1:	83 ec 04             	sub    $0x4,%esp
  802fa4:	6a 01                	push   $0x1
  802fa6:	ff 75 a4             	pushl  -0x5c(%ebp)
  802fa9:	ff 75 a8             	pushl  -0x58(%ebp)
  802fac:	e8 e3 f9 ff ff       	call   802994 <set_block_data>
  802fb1:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802fb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb8:	75 17                	jne    802fd1 <alloc_block_BF+0x152>
  802fba:	83 ec 04             	sub    $0x4,%esp
  802fbd:	68 07 4c 80 00       	push   $0x804c07
  802fc2:	68 2c 01 00 00       	push   $0x12c
  802fc7:	68 25 4c 80 00       	push   $0x804c25
  802fcc:	e8 a5 d8 ff ff       	call   800876 <_panic>
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	85 c0                	test   %eax,%eax
  802fd8:	74 10                	je     802fea <alloc_block_BF+0x16b>
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fe2:	8b 52 04             	mov    0x4(%edx),%edx
  802fe5:	89 50 04             	mov    %edx,0x4(%eax)
  802fe8:	eb 0b                	jmp    802ff5 <alloc_block_BF+0x176>
  802fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fed:	8b 40 04             	mov    0x4(%eax),%eax
  802ff0:	a3 34 50 80 00       	mov    %eax,0x805034
  802ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff8:	8b 40 04             	mov    0x4(%eax),%eax
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	74 0f                	je     80300e <alloc_block_BF+0x18f>
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	8b 40 04             	mov    0x4(%eax),%eax
  803005:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803008:	8b 12                	mov    (%edx),%edx
  80300a:	89 10                	mov    %edx,(%eax)
  80300c:	eb 0a                	jmp    803018 <alloc_block_BF+0x199>
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	8b 00                	mov    (%eax),%eax
  803013:	a3 30 50 80 00       	mov    %eax,0x805030
  803018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803024:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803030:	48                   	dec    %eax
  803031:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  803036:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803039:	e9 24 04 00 00       	jmp    803462 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80303e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803041:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803044:	76 13                	jbe    803059 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803046:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80304d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803050:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803053:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803056:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803059:	a1 38 50 80 00       	mov    0x805038,%eax
  80305e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803061:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803065:	74 07                	je     80306e <alloc_block_BF+0x1ef>
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	8b 00                	mov    (%eax),%eax
  80306c:	eb 05                	jmp    803073 <alloc_block_BF+0x1f4>
  80306e:	b8 00 00 00 00       	mov    $0x0,%eax
  803073:	a3 38 50 80 00       	mov    %eax,0x805038
  803078:	a1 38 50 80 00       	mov    0x805038,%eax
  80307d:	85 c0                	test   %eax,%eax
  80307f:	0f 85 bf fe ff ff    	jne    802f44 <alloc_block_BF+0xc5>
  803085:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803089:	0f 85 b5 fe ff ff    	jne    802f44 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80308f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803093:	0f 84 26 02 00 00    	je     8032bf <alloc_block_BF+0x440>
  803099:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80309d:	0f 85 1c 02 00 00    	jne    8032bf <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8030a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a6:	2b 45 08             	sub    0x8(%ebp),%eax
  8030a9:	83 e8 08             	sub    $0x8,%eax
  8030ac:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8030af:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b2:	8d 50 08             	lea    0x8(%eax),%edx
  8030b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b8:	01 d0                	add    %edx,%eax
  8030ba:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	83 c0 08             	add    $0x8,%eax
  8030c3:	83 ec 04             	sub    $0x4,%esp
  8030c6:	6a 01                	push   $0x1
  8030c8:	50                   	push   %eax
  8030c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8030cc:	e8 c3 f8 ff ff       	call   802994 <set_block_data>
  8030d1:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8030d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d7:	8b 40 04             	mov    0x4(%eax),%eax
  8030da:	85 c0                	test   %eax,%eax
  8030dc:	75 68                	jne    803146 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030de:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030e2:	75 17                	jne    8030fb <alloc_block_BF+0x27c>
  8030e4:	83 ec 04             	sub    $0x4,%esp
  8030e7:	68 40 4c 80 00       	push   $0x804c40
  8030ec:	68 45 01 00 00       	push   $0x145
  8030f1:	68 25 4c 80 00       	push   $0x804c25
  8030f6:	e8 7b d7 ff ff       	call   800876 <_panic>
  8030fb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803101:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803104:	89 10                	mov    %edx,(%eax)
  803106:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803109:	8b 00                	mov    (%eax),%eax
  80310b:	85 c0                	test   %eax,%eax
  80310d:	74 0d                	je     80311c <alloc_block_BF+0x29d>
  80310f:	a1 30 50 80 00       	mov    0x805030,%eax
  803114:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803117:	89 50 04             	mov    %edx,0x4(%eax)
  80311a:	eb 08                	jmp    803124 <alloc_block_BF+0x2a5>
  80311c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80311f:	a3 34 50 80 00       	mov    %eax,0x805034
  803124:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803127:	a3 30 50 80 00       	mov    %eax,0x805030
  80312c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80312f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803136:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80313b:	40                   	inc    %eax
  80313c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803141:	e9 dc 00 00 00       	jmp    803222 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803149:	8b 00                	mov    (%eax),%eax
  80314b:	85 c0                	test   %eax,%eax
  80314d:	75 65                	jne    8031b4 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80314f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803153:	75 17                	jne    80316c <alloc_block_BF+0x2ed>
  803155:	83 ec 04             	sub    $0x4,%esp
  803158:	68 74 4c 80 00       	push   $0x804c74
  80315d:	68 4a 01 00 00       	push   $0x14a
  803162:	68 25 4c 80 00       	push   $0x804c25
  803167:	e8 0a d7 ff ff       	call   800876 <_panic>
  80316c:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803172:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803175:	89 50 04             	mov    %edx,0x4(%eax)
  803178:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80317b:	8b 40 04             	mov    0x4(%eax),%eax
  80317e:	85 c0                	test   %eax,%eax
  803180:	74 0c                	je     80318e <alloc_block_BF+0x30f>
  803182:	a1 34 50 80 00       	mov    0x805034,%eax
  803187:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80318a:	89 10                	mov    %edx,(%eax)
  80318c:	eb 08                	jmp    803196 <alloc_block_BF+0x317>
  80318e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803191:	a3 30 50 80 00       	mov    %eax,0x805030
  803196:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803199:	a3 34 50 80 00       	mov    %eax,0x805034
  80319e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031ac:	40                   	inc    %eax
  8031ad:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8031b2:	eb 6e                	jmp    803222 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8031b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031b8:	74 06                	je     8031c0 <alloc_block_BF+0x341>
  8031ba:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031be:	75 17                	jne    8031d7 <alloc_block_BF+0x358>
  8031c0:	83 ec 04             	sub    $0x4,%esp
  8031c3:	68 98 4c 80 00       	push   $0x804c98
  8031c8:	68 4f 01 00 00       	push   $0x14f
  8031cd:	68 25 4c 80 00       	push   $0x804c25
  8031d2:	e8 9f d6 ff ff       	call   800876 <_panic>
  8031d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031da:	8b 10                	mov    (%eax),%edx
  8031dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031df:	89 10                	mov    %edx,(%eax)
  8031e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031e4:	8b 00                	mov    (%eax),%eax
  8031e6:	85 c0                	test   %eax,%eax
  8031e8:	74 0b                	je     8031f5 <alloc_block_BF+0x376>
  8031ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ed:	8b 00                	mov    (%eax),%eax
  8031ef:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031f2:	89 50 04             	mov    %edx,0x4(%eax)
  8031f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031fb:	89 10                	mov    %edx,(%eax)
  8031fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803200:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803203:	89 50 04             	mov    %edx,0x4(%eax)
  803206:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803209:	8b 00                	mov    (%eax),%eax
  80320b:	85 c0                	test   %eax,%eax
  80320d:	75 08                	jne    803217 <alloc_block_BF+0x398>
  80320f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803212:	a3 34 50 80 00       	mov    %eax,0x805034
  803217:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80321c:	40                   	inc    %eax
  80321d:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803222:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803226:	75 17                	jne    80323f <alloc_block_BF+0x3c0>
  803228:	83 ec 04             	sub    $0x4,%esp
  80322b:	68 07 4c 80 00       	push   $0x804c07
  803230:	68 51 01 00 00       	push   $0x151
  803235:	68 25 4c 80 00       	push   $0x804c25
  80323a:	e8 37 d6 ff ff       	call   800876 <_panic>
  80323f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803242:	8b 00                	mov    (%eax),%eax
  803244:	85 c0                	test   %eax,%eax
  803246:	74 10                	je     803258 <alloc_block_BF+0x3d9>
  803248:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324b:	8b 00                	mov    (%eax),%eax
  80324d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803250:	8b 52 04             	mov    0x4(%edx),%edx
  803253:	89 50 04             	mov    %edx,0x4(%eax)
  803256:	eb 0b                	jmp    803263 <alloc_block_BF+0x3e4>
  803258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325b:	8b 40 04             	mov    0x4(%eax),%eax
  80325e:	a3 34 50 80 00       	mov    %eax,0x805034
  803263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803266:	8b 40 04             	mov    0x4(%eax),%eax
  803269:	85 c0                	test   %eax,%eax
  80326b:	74 0f                	je     80327c <alloc_block_BF+0x3fd>
  80326d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803270:	8b 40 04             	mov    0x4(%eax),%eax
  803273:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803276:	8b 12                	mov    (%edx),%edx
  803278:	89 10                	mov    %edx,(%eax)
  80327a:	eb 0a                	jmp    803286 <alloc_block_BF+0x407>
  80327c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327f:	8b 00                	mov    (%eax),%eax
  803281:	a3 30 50 80 00       	mov    %eax,0x805030
  803286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803289:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80328f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803292:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803299:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80329e:	48                   	dec    %eax
  80329f:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  8032a4:	83 ec 04             	sub    $0x4,%esp
  8032a7:	6a 00                	push   $0x0
  8032a9:	ff 75 d0             	pushl  -0x30(%ebp)
  8032ac:	ff 75 cc             	pushl  -0x34(%ebp)
  8032af:	e8 e0 f6 ff ff       	call   802994 <set_block_data>
  8032b4:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8032b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ba:	e9 a3 01 00 00       	jmp    803462 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8032bf:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8032c3:	0f 85 9d 00 00 00    	jne    803366 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8032c9:	83 ec 04             	sub    $0x4,%esp
  8032cc:	6a 01                	push   $0x1
  8032ce:	ff 75 ec             	pushl  -0x14(%ebp)
  8032d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8032d4:	e8 bb f6 ff ff       	call   802994 <set_block_data>
  8032d9:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8032dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032e0:	75 17                	jne    8032f9 <alloc_block_BF+0x47a>
  8032e2:	83 ec 04             	sub    $0x4,%esp
  8032e5:	68 07 4c 80 00       	push   $0x804c07
  8032ea:	68 58 01 00 00       	push   $0x158
  8032ef:	68 25 4c 80 00       	push   $0x804c25
  8032f4:	e8 7d d5 ff ff       	call   800876 <_panic>
  8032f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fc:	8b 00                	mov    (%eax),%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	74 10                	je     803312 <alloc_block_BF+0x493>
  803302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803305:	8b 00                	mov    (%eax),%eax
  803307:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80330a:	8b 52 04             	mov    0x4(%edx),%edx
  80330d:	89 50 04             	mov    %edx,0x4(%eax)
  803310:	eb 0b                	jmp    80331d <alloc_block_BF+0x49e>
  803312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803315:	8b 40 04             	mov    0x4(%eax),%eax
  803318:	a3 34 50 80 00       	mov    %eax,0x805034
  80331d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803320:	8b 40 04             	mov    0x4(%eax),%eax
  803323:	85 c0                	test   %eax,%eax
  803325:	74 0f                	je     803336 <alloc_block_BF+0x4b7>
  803327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332a:	8b 40 04             	mov    0x4(%eax),%eax
  80332d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803330:	8b 12                	mov    (%edx),%edx
  803332:	89 10                	mov    %edx,(%eax)
  803334:	eb 0a                	jmp    803340 <alloc_block_BF+0x4c1>
  803336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	a3 30 50 80 00       	mov    %eax,0x805030
  803340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803343:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803353:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803358:	48                   	dec    %eax
  803359:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  80335e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803361:	e9 fc 00 00 00       	jmp    803462 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	83 c0 08             	add    $0x8,%eax
  80336c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80336f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803376:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803379:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80337c:	01 d0                	add    %edx,%eax
  80337e:	48                   	dec    %eax
  80337f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803382:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803385:	ba 00 00 00 00       	mov    $0x0,%edx
  80338a:	f7 75 c4             	divl   -0x3c(%ebp)
  80338d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803390:	29 d0                	sub    %edx,%eax
  803392:	c1 e8 0c             	shr    $0xc,%eax
  803395:	83 ec 0c             	sub    $0xc,%esp
  803398:	50                   	push   %eax
  803399:	e8 37 e7 ff ff       	call   801ad5 <sbrk>
  80339e:	83 c4 10             	add    $0x10,%esp
  8033a1:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8033a4:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8033a8:	75 0a                	jne    8033b4 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8033aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8033af:	e9 ae 00 00 00       	jmp    803462 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8033b4:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8033bb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033be:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8033c1:	01 d0                	add    %edx,%eax
  8033c3:	48                   	dec    %eax
  8033c4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8033c7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8033ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8033cf:	f7 75 b8             	divl   -0x48(%ebp)
  8033d2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8033d5:	29 d0                	sub    %edx,%eax
  8033d7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8033da:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8033dd:	01 d0                	add    %edx,%eax
  8033df:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  8033e4:	a1 44 50 80 00       	mov    0x805044,%eax
  8033e9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8033ef:	83 ec 0c             	sub    $0xc,%esp
  8033f2:	68 cc 4c 80 00       	push   $0x804ccc
  8033f7:	e8 37 d7 ff ff       	call   800b33 <cprintf>
  8033fc:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8033ff:	83 ec 08             	sub    $0x8,%esp
  803402:	ff 75 bc             	pushl  -0x44(%ebp)
  803405:	68 d1 4c 80 00       	push   $0x804cd1
  80340a:	e8 24 d7 ff ff       	call   800b33 <cprintf>
  80340f:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803412:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803419:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80341c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80341f:	01 d0                	add    %edx,%eax
  803421:	48                   	dec    %eax
  803422:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803425:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803428:	ba 00 00 00 00       	mov    $0x0,%edx
  80342d:	f7 75 b0             	divl   -0x50(%ebp)
  803430:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803433:	29 d0                	sub    %edx,%eax
  803435:	83 ec 04             	sub    $0x4,%esp
  803438:	6a 01                	push   $0x1
  80343a:	50                   	push   %eax
  80343b:	ff 75 bc             	pushl  -0x44(%ebp)
  80343e:	e8 51 f5 ff ff       	call   802994 <set_block_data>
  803443:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803446:	83 ec 0c             	sub    $0xc,%esp
  803449:	ff 75 bc             	pushl  -0x44(%ebp)
  80344c:	e8 36 04 00 00       	call   803887 <free_block>
  803451:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803454:	83 ec 0c             	sub    $0xc,%esp
  803457:	ff 75 08             	pushl  0x8(%ebp)
  80345a:	e8 20 fa ff ff       	call   802e7f <alloc_block_BF>
  80345f:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803462:	c9                   	leave  
  803463:	c3                   	ret    

00803464 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803464:	55                   	push   %ebp
  803465:	89 e5                	mov    %esp,%ebp
  803467:	53                   	push   %ebx
  803468:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80346b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803479:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80347d:	74 1e                	je     80349d <merging+0x39>
  80347f:	ff 75 08             	pushl  0x8(%ebp)
  803482:	e8 bc f1 ff ff       	call   802643 <get_block_size>
  803487:	83 c4 04             	add    $0x4,%esp
  80348a:	89 c2                	mov    %eax,%edx
  80348c:	8b 45 08             	mov    0x8(%ebp),%eax
  80348f:	01 d0                	add    %edx,%eax
  803491:	3b 45 10             	cmp    0x10(%ebp),%eax
  803494:	75 07                	jne    80349d <merging+0x39>
		prev_is_free = 1;
  803496:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  80349d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034a1:	74 1e                	je     8034c1 <merging+0x5d>
  8034a3:	ff 75 10             	pushl  0x10(%ebp)
  8034a6:	e8 98 f1 ff ff       	call   802643 <get_block_size>
  8034ab:	83 c4 04             	add    $0x4,%esp
  8034ae:	89 c2                	mov    %eax,%edx
  8034b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8034b3:	01 d0                	add    %edx,%eax
  8034b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034b8:	75 07                	jne    8034c1 <merging+0x5d>
		next_is_free = 1;
  8034ba:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8034c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c5:	0f 84 cc 00 00 00    	je     803597 <merging+0x133>
  8034cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034cf:	0f 84 c2 00 00 00    	je     803597 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8034d5:	ff 75 08             	pushl  0x8(%ebp)
  8034d8:	e8 66 f1 ff ff       	call   802643 <get_block_size>
  8034dd:	83 c4 04             	add    $0x4,%esp
  8034e0:	89 c3                	mov    %eax,%ebx
  8034e2:	ff 75 10             	pushl  0x10(%ebp)
  8034e5:	e8 59 f1 ff ff       	call   802643 <get_block_size>
  8034ea:	83 c4 04             	add    $0x4,%esp
  8034ed:	01 c3                	add    %eax,%ebx
  8034ef:	ff 75 0c             	pushl  0xc(%ebp)
  8034f2:	e8 4c f1 ff ff       	call   802643 <get_block_size>
  8034f7:	83 c4 04             	add    $0x4,%esp
  8034fa:	01 d8                	add    %ebx,%eax
  8034fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8034ff:	6a 00                	push   $0x0
  803501:	ff 75 ec             	pushl  -0x14(%ebp)
  803504:	ff 75 08             	pushl  0x8(%ebp)
  803507:	e8 88 f4 ff ff       	call   802994 <set_block_data>
  80350c:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80350f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803513:	75 17                	jne    80352c <merging+0xc8>
  803515:	83 ec 04             	sub    $0x4,%esp
  803518:	68 07 4c 80 00       	push   $0x804c07
  80351d:	68 7d 01 00 00       	push   $0x17d
  803522:	68 25 4c 80 00       	push   $0x804c25
  803527:	e8 4a d3 ff ff       	call   800876 <_panic>
  80352c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352f:	8b 00                	mov    (%eax),%eax
  803531:	85 c0                	test   %eax,%eax
  803533:	74 10                	je     803545 <merging+0xe1>
  803535:	8b 45 0c             	mov    0xc(%ebp),%eax
  803538:	8b 00                	mov    (%eax),%eax
  80353a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80353d:	8b 52 04             	mov    0x4(%edx),%edx
  803540:	89 50 04             	mov    %edx,0x4(%eax)
  803543:	eb 0b                	jmp    803550 <merging+0xec>
  803545:	8b 45 0c             	mov    0xc(%ebp),%eax
  803548:	8b 40 04             	mov    0x4(%eax),%eax
  80354b:	a3 34 50 80 00       	mov    %eax,0x805034
  803550:	8b 45 0c             	mov    0xc(%ebp),%eax
  803553:	8b 40 04             	mov    0x4(%eax),%eax
  803556:	85 c0                	test   %eax,%eax
  803558:	74 0f                	je     803569 <merging+0x105>
  80355a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80355d:	8b 40 04             	mov    0x4(%eax),%eax
  803560:	8b 55 0c             	mov    0xc(%ebp),%edx
  803563:	8b 12                	mov    (%edx),%edx
  803565:	89 10                	mov    %edx,(%eax)
  803567:	eb 0a                	jmp    803573 <merging+0x10f>
  803569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80356c:	8b 00                	mov    (%eax),%eax
  80356e:	a3 30 50 80 00       	mov    %eax,0x805030
  803573:	8b 45 0c             	mov    0xc(%ebp),%eax
  803576:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80357f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803586:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80358b:	48                   	dec    %eax
  80358c:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803591:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803592:	e9 ea 02 00 00       	jmp    803881 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80359b:	74 3b                	je     8035d8 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80359d:	83 ec 0c             	sub    $0xc,%esp
  8035a0:	ff 75 08             	pushl  0x8(%ebp)
  8035a3:	e8 9b f0 ff ff       	call   802643 <get_block_size>
  8035a8:	83 c4 10             	add    $0x10,%esp
  8035ab:	89 c3                	mov    %eax,%ebx
  8035ad:	83 ec 0c             	sub    $0xc,%esp
  8035b0:	ff 75 10             	pushl  0x10(%ebp)
  8035b3:	e8 8b f0 ff ff       	call   802643 <get_block_size>
  8035b8:	83 c4 10             	add    $0x10,%esp
  8035bb:	01 d8                	add    %ebx,%eax
  8035bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8035c0:	83 ec 04             	sub    $0x4,%esp
  8035c3:	6a 00                	push   $0x0
  8035c5:	ff 75 e8             	pushl  -0x18(%ebp)
  8035c8:	ff 75 08             	pushl  0x8(%ebp)
  8035cb:	e8 c4 f3 ff ff       	call   802994 <set_block_data>
  8035d0:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8035d3:	e9 a9 02 00 00       	jmp    803881 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8035d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035dc:	0f 84 2d 01 00 00    	je     80370f <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8035e2:	83 ec 0c             	sub    $0xc,%esp
  8035e5:	ff 75 10             	pushl  0x10(%ebp)
  8035e8:	e8 56 f0 ff ff       	call   802643 <get_block_size>
  8035ed:	83 c4 10             	add    $0x10,%esp
  8035f0:	89 c3                	mov    %eax,%ebx
  8035f2:	83 ec 0c             	sub    $0xc,%esp
  8035f5:	ff 75 0c             	pushl  0xc(%ebp)
  8035f8:	e8 46 f0 ff ff       	call   802643 <get_block_size>
  8035fd:	83 c4 10             	add    $0x10,%esp
  803600:	01 d8                	add    %ebx,%eax
  803602:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803605:	83 ec 04             	sub    $0x4,%esp
  803608:	6a 00                	push   $0x0
  80360a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80360d:	ff 75 10             	pushl  0x10(%ebp)
  803610:	e8 7f f3 ff ff       	call   802994 <set_block_data>
  803615:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803618:	8b 45 10             	mov    0x10(%ebp),%eax
  80361b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80361e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803622:	74 06                	je     80362a <merging+0x1c6>
  803624:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803628:	75 17                	jne    803641 <merging+0x1dd>
  80362a:	83 ec 04             	sub    $0x4,%esp
  80362d:	68 e0 4c 80 00       	push   $0x804ce0
  803632:	68 8d 01 00 00       	push   $0x18d
  803637:	68 25 4c 80 00       	push   $0x804c25
  80363c:	e8 35 d2 ff ff       	call   800876 <_panic>
  803641:	8b 45 0c             	mov    0xc(%ebp),%eax
  803644:	8b 50 04             	mov    0x4(%eax),%edx
  803647:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80364a:	89 50 04             	mov    %edx,0x4(%eax)
  80364d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803650:	8b 55 0c             	mov    0xc(%ebp),%edx
  803653:	89 10                	mov    %edx,(%eax)
  803655:	8b 45 0c             	mov    0xc(%ebp),%eax
  803658:	8b 40 04             	mov    0x4(%eax),%eax
  80365b:	85 c0                	test   %eax,%eax
  80365d:	74 0d                	je     80366c <merging+0x208>
  80365f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803662:	8b 40 04             	mov    0x4(%eax),%eax
  803665:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803668:	89 10                	mov    %edx,(%eax)
  80366a:	eb 08                	jmp    803674 <merging+0x210>
  80366c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80366f:	a3 30 50 80 00       	mov    %eax,0x805030
  803674:	8b 45 0c             	mov    0xc(%ebp),%eax
  803677:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80367a:	89 50 04             	mov    %edx,0x4(%eax)
  80367d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803682:	40                   	inc    %eax
  803683:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  803688:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80368c:	75 17                	jne    8036a5 <merging+0x241>
  80368e:	83 ec 04             	sub    $0x4,%esp
  803691:	68 07 4c 80 00       	push   $0x804c07
  803696:	68 8e 01 00 00       	push   $0x18e
  80369b:	68 25 4c 80 00       	push   $0x804c25
  8036a0:	e8 d1 d1 ff ff       	call   800876 <_panic>
  8036a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a8:	8b 00                	mov    (%eax),%eax
  8036aa:	85 c0                	test   %eax,%eax
  8036ac:	74 10                	je     8036be <merging+0x25a>
  8036ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b1:	8b 00                	mov    (%eax),%eax
  8036b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036b6:	8b 52 04             	mov    0x4(%edx),%edx
  8036b9:	89 50 04             	mov    %edx,0x4(%eax)
  8036bc:	eb 0b                	jmp    8036c9 <merging+0x265>
  8036be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c1:	8b 40 04             	mov    0x4(%eax),%eax
  8036c4:	a3 34 50 80 00       	mov    %eax,0x805034
  8036c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036cc:	8b 40 04             	mov    0x4(%eax),%eax
  8036cf:	85 c0                	test   %eax,%eax
  8036d1:	74 0f                	je     8036e2 <merging+0x27e>
  8036d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d6:	8b 40 04             	mov    0x4(%eax),%eax
  8036d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036dc:	8b 12                	mov    (%edx),%edx
  8036de:	89 10                	mov    %edx,(%eax)
  8036e0:	eb 0a                	jmp    8036ec <merging+0x288>
  8036e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036e5:	8b 00                	mov    (%eax),%eax
  8036e7:	a3 30 50 80 00       	mov    %eax,0x805030
  8036ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ff:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803704:	48                   	dec    %eax
  803705:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80370a:	e9 72 01 00 00       	jmp    803881 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80370f:	8b 45 10             	mov    0x10(%ebp),%eax
  803712:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803715:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803719:	74 79                	je     803794 <merging+0x330>
  80371b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80371f:	74 73                	je     803794 <merging+0x330>
  803721:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803725:	74 06                	je     80372d <merging+0x2c9>
  803727:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80372b:	75 17                	jne    803744 <merging+0x2e0>
  80372d:	83 ec 04             	sub    $0x4,%esp
  803730:	68 98 4c 80 00       	push   $0x804c98
  803735:	68 94 01 00 00       	push   $0x194
  80373a:	68 25 4c 80 00       	push   $0x804c25
  80373f:	e8 32 d1 ff ff       	call   800876 <_panic>
  803744:	8b 45 08             	mov    0x8(%ebp),%eax
  803747:	8b 10                	mov    (%eax),%edx
  803749:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80374c:	89 10                	mov    %edx,(%eax)
  80374e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803751:	8b 00                	mov    (%eax),%eax
  803753:	85 c0                	test   %eax,%eax
  803755:	74 0b                	je     803762 <merging+0x2fe>
  803757:	8b 45 08             	mov    0x8(%ebp),%eax
  80375a:	8b 00                	mov    (%eax),%eax
  80375c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80375f:	89 50 04             	mov    %edx,0x4(%eax)
  803762:	8b 45 08             	mov    0x8(%ebp),%eax
  803765:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803768:	89 10                	mov    %edx,(%eax)
  80376a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80376d:	8b 55 08             	mov    0x8(%ebp),%edx
  803770:	89 50 04             	mov    %edx,0x4(%eax)
  803773:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803776:	8b 00                	mov    (%eax),%eax
  803778:	85 c0                	test   %eax,%eax
  80377a:	75 08                	jne    803784 <merging+0x320>
  80377c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80377f:	a3 34 50 80 00       	mov    %eax,0x805034
  803784:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803789:	40                   	inc    %eax
  80378a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80378f:	e9 ce 00 00 00       	jmp    803862 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803794:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803798:	74 65                	je     8037ff <merging+0x39b>
  80379a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80379e:	75 17                	jne    8037b7 <merging+0x353>
  8037a0:	83 ec 04             	sub    $0x4,%esp
  8037a3:	68 74 4c 80 00       	push   $0x804c74
  8037a8:	68 95 01 00 00       	push   $0x195
  8037ad:	68 25 4c 80 00       	push   $0x804c25
  8037b2:	e8 bf d0 ff ff       	call   800876 <_panic>
  8037b7:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8037bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c0:	89 50 04             	mov    %edx,0x4(%eax)
  8037c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c6:	8b 40 04             	mov    0x4(%eax),%eax
  8037c9:	85 c0                	test   %eax,%eax
  8037cb:	74 0c                	je     8037d9 <merging+0x375>
  8037cd:	a1 34 50 80 00       	mov    0x805034,%eax
  8037d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037d5:	89 10                	mov    %edx,(%eax)
  8037d7:	eb 08                	jmp    8037e1 <merging+0x37d>
  8037d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037dc:	a3 30 50 80 00       	mov    %eax,0x805030
  8037e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037e4:	a3 34 50 80 00       	mov    %eax,0x805034
  8037e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037f2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037f7:	40                   	inc    %eax
  8037f8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8037fd:	eb 63                	jmp    803862 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8037ff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803803:	75 17                	jne    80381c <merging+0x3b8>
  803805:	83 ec 04             	sub    $0x4,%esp
  803808:	68 40 4c 80 00       	push   $0x804c40
  80380d:	68 98 01 00 00       	push   $0x198
  803812:	68 25 4c 80 00       	push   $0x804c25
  803817:	e8 5a d0 ff ff       	call   800876 <_panic>
  80381c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803822:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803825:	89 10                	mov    %edx,(%eax)
  803827:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80382a:	8b 00                	mov    (%eax),%eax
  80382c:	85 c0                	test   %eax,%eax
  80382e:	74 0d                	je     80383d <merging+0x3d9>
  803830:	a1 30 50 80 00       	mov    0x805030,%eax
  803835:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803838:	89 50 04             	mov    %edx,0x4(%eax)
  80383b:	eb 08                	jmp    803845 <merging+0x3e1>
  80383d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803840:	a3 34 50 80 00       	mov    %eax,0x805034
  803845:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803848:	a3 30 50 80 00       	mov    %eax,0x805030
  80384d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803850:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803857:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80385c:	40                   	inc    %eax
  80385d:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803862:	83 ec 0c             	sub    $0xc,%esp
  803865:	ff 75 10             	pushl  0x10(%ebp)
  803868:	e8 d6 ed ff ff       	call   802643 <get_block_size>
  80386d:	83 c4 10             	add    $0x10,%esp
  803870:	83 ec 04             	sub    $0x4,%esp
  803873:	6a 00                	push   $0x0
  803875:	50                   	push   %eax
  803876:	ff 75 10             	pushl  0x10(%ebp)
  803879:	e8 16 f1 ff ff       	call   802994 <set_block_data>
  80387e:	83 c4 10             	add    $0x10,%esp
	}
}
  803881:	90                   	nop
  803882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803885:	c9                   	leave  
  803886:	c3                   	ret    

00803887 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803887:	55                   	push   %ebp
  803888:	89 e5                	mov    %esp,%ebp
  80388a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80388d:	a1 30 50 80 00       	mov    0x805030,%eax
  803892:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803895:	a1 34 50 80 00       	mov    0x805034,%eax
  80389a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80389d:	73 1b                	jae    8038ba <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80389f:	a1 34 50 80 00       	mov    0x805034,%eax
  8038a4:	83 ec 04             	sub    $0x4,%esp
  8038a7:	ff 75 08             	pushl  0x8(%ebp)
  8038aa:	6a 00                	push   $0x0
  8038ac:	50                   	push   %eax
  8038ad:	e8 b2 fb ff ff       	call   803464 <merging>
  8038b2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038b5:	e9 8b 00 00 00       	jmp    803945 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8038ba:	a1 30 50 80 00       	mov    0x805030,%eax
  8038bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038c2:	76 18                	jbe    8038dc <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8038c4:	a1 30 50 80 00       	mov    0x805030,%eax
  8038c9:	83 ec 04             	sub    $0x4,%esp
  8038cc:	ff 75 08             	pushl  0x8(%ebp)
  8038cf:	50                   	push   %eax
  8038d0:	6a 00                	push   $0x0
  8038d2:	e8 8d fb ff ff       	call   803464 <merging>
  8038d7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038da:	eb 69                	jmp    803945 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8038dc:	a1 30 50 80 00       	mov    0x805030,%eax
  8038e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038e4:	eb 39                	jmp    80391f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8038e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038ec:	73 29                	jae    803917 <free_block+0x90>
  8038ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f1:	8b 00                	mov    (%eax),%eax
  8038f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038f6:	76 1f                	jbe    803917 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8038f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fb:	8b 00                	mov    (%eax),%eax
  8038fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803900:	83 ec 04             	sub    $0x4,%esp
  803903:	ff 75 08             	pushl  0x8(%ebp)
  803906:	ff 75 f0             	pushl  -0x10(%ebp)
  803909:	ff 75 f4             	pushl  -0xc(%ebp)
  80390c:	e8 53 fb ff ff       	call   803464 <merging>
  803911:	83 c4 10             	add    $0x10,%esp
			break;
  803914:	90                   	nop
		}
	}
}
  803915:	eb 2e                	jmp    803945 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803917:	a1 38 50 80 00       	mov    0x805038,%eax
  80391c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80391f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803923:	74 07                	je     80392c <free_block+0xa5>
  803925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803928:	8b 00                	mov    (%eax),%eax
  80392a:	eb 05                	jmp    803931 <free_block+0xaa>
  80392c:	b8 00 00 00 00       	mov    $0x0,%eax
  803931:	a3 38 50 80 00       	mov    %eax,0x805038
  803936:	a1 38 50 80 00       	mov    0x805038,%eax
  80393b:	85 c0                	test   %eax,%eax
  80393d:	75 a7                	jne    8038e6 <free_block+0x5f>
  80393f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803943:	75 a1                	jne    8038e6 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803945:	90                   	nop
  803946:	c9                   	leave  
  803947:	c3                   	ret    

00803948 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803948:	55                   	push   %ebp
  803949:	89 e5                	mov    %esp,%ebp
  80394b:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80394e:	ff 75 08             	pushl  0x8(%ebp)
  803951:	e8 ed ec ff ff       	call   802643 <get_block_size>
  803956:	83 c4 04             	add    $0x4,%esp
  803959:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80395c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803963:	eb 17                	jmp    80397c <copy_data+0x34>
  803965:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80396b:	01 c2                	add    %eax,%edx
  80396d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803970:	8b 45 08             	mov    0x8(%ebp),%eax
  803973:	01 c8                	add    %ecx,%eax
  803975:	8a 00                	mov    (%eax),%al
  803977:	88 02                	mov    %al,(%edx)
  803979:	ff 45 fc             	incl   -0x4(%ebp)
  80397c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80397f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803982:	72 e1                	jb     803965 <copy_data+0x1d>
}
  803984:	90                   	nop
  803985:	c9                   	leave  
  803986:	c3                   	ret    

00803987 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803987:	55                   	push   %ebp
  803988:	89 e5                	mov    %esp,%ebp
  80398a:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80398d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803991:	75 23                	jne    8039b6 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803993:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803997:	74 13                	je     8039ac <realloc_block_FF+0x25>
  803999:	83 ec 0c             	sub    $0xc,%esp
  80399c:	ff 75 0c             	pushl  0xc(%ebp)
  80399f:	e8 1f f0 ff ff       	call   8029c3 <alloc_block_FF>
  8039a4:	83 c4 10             	add    $0x10,%esp
  8039a7:	e9 f4 06 00 00       	jmp    8040a0 <realloc_block_FF+0x719>
		return NULL;
  8039ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b1:	e9 ea 06 00 00       	jmp    8040a0 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8039b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8039ba:	75 18                	jne    8039d4 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8039bc:	83 ec 0c             	sub    $0xc,%esp
  8039bf:	ff 75 08             	pushl  0x8(%ebp)
  8039c2:	e8 c0 fe ff ff       	call   803887 <free_block>
  8039c7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8039ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8039cf:	e9 cc 06 00 00       	jmp    8040a0 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8039d4:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8039d8:	77 07                	ja     8039e1 <realloc_block_FF+0x5a>
  8039da:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8039e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e4:	83 e0 01             	and    $0x1,%eax
  8039e7:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8039ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039ed:	83 c0 08             	add    $0x8,%eax
  8039f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8039f3:	83 ec 0c             	sub    $0xc,%esp
  8039f6:	ff 75 08             	pushl  0x8(%ebp)
  8039f9:	e8 45 ec ff ff       	call   802643 <get_block_size>
  8039fe:	83 c4 10             	add    $0x10,%esp
  803a01:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a07:	83 e8 08             	sub    $0x8,%eax
  803a0a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a10:	83 e8 04             	sub    $0x4,%eax
  803a13:	8b 00                	mov    (%eax),%eax
  803a15:	83 e0 fe             	and    $0xfffffffe,%eax
  803a18:	89 c2                	mov    %eax,%edx
  803a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1d:	01 d0                	add    %edx,%eax
  803a1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803a22:	83 ec 0c             	sub    $0xc,%esp
  803a25:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a28:	e8 16 ec ff ff       	call   802643 <get_block_size>
  803a2d:	83 c4 10             	add    $0x10,%esp
  803a30:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803a33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a36:	83 e8 08             	sub    $0x8,%eax
  803a39:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a3f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a42:	75 08                	jne    803a4c <realloc_block_FF+0xc5>
	{
		 return va;
  803a44:	8b 45 08             	mov    0x8(%ebp),%eax
  803a47:	e9 54 06 00 00       	jmp    8040a0 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a4f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a52:	0f 83 e5 03 00 00    	jae    803e3d <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803a58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a5b:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803a61:	83 ec 0c             	sub    $0xc,%esp
  803a64:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a67:	e8 f0 eb ff ff       	call   80265c <is_free_block>
  803a6c:	83 c4 10             	add    $0x10,%esp
  803a6f:	84 c0                	test   %al,%al
  803a71:	0f 84 3b 01 00 00    	je     803bb2 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803a77:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a7a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a7d:	01 d0                	add    %edx,%eax
  803a7f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803a82:	83 ec 04             	sub    $0x4,%esp
  803a85:	6a 01                	push   $0x1
  803a87:	ff 75 f0             	pushl  -0x10(%ebp)
  803a8a:	ff 75 08             	pushl  0x8(%ebp)
  803a8d:	e8 02 ef ff ff       	call   802994 <set_block_data>
  803a92:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803a95:	8b 45 08             	mov    0x8(%ebp),%eax
  803a98:	83 e8 04             	sub    $0x4,%eax
  803a9b:	8b 00                	mov    (%eax),%eax
  803a9d:	83 e0 fe             	and    $0xfffffffe,%eax
  803aa0:	89 c2                	mov    %eax,%edx
  803aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa5:	01 d0                	add    %edx,%eax
  803aa7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803aaa:	83 ec 04             	sub    $0x4,%esp
  803aad:	6a 00                	push   $0x0
  803aaf:	ff 75 cc             	pushl  -0x34(%ebp)
  803ab2:	ff 75 c8             	pushl  -0x38(%ebp)
  803ab5:	e8 da ee ff ff       	call   802994 <set_block_data>
  803aba:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803abd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ac1:	74 06                	je     803ac9 <realloc_block_FF+0x142>
  803ac3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803ac7:	75 17                	jne    803ae0 <realloc_block_FF+0x159>
  803ac9:	83 ec 04             	sub    $0x4,%esp
  803acc:	68 98 4c 80 00       	push   $0x804c98
  803ad1:	68 f6 01 00 00       	push   $0x1f6
  803ad6:	68 25 4c 80 00       	push   $0x804c25
  803adb:	e8 96 cd ff ff       	call   800876 <_panic>
  803ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae3:	8b 10                	mov    (%eax),%edx
  803ae5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ae8:	89 10                	mov    %edx,(%eax)
  803aea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803aed:	8b 00                	mov    (%eax),%eax
  803aef:	85 c0                	test   %eax,%eax
  803af1:	74 0b                	je     803afe <realloc_block_FF+0x177>
  803af3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af6:	8b 00                	mov    (%eax),%eax
  803af8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803afb:	89 50 04             	mov    %edx,0x4(%eax)
  803afe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b01:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803b04:	89 10                	mov    %edx,(%eax)
  803b06:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b0c:	89 50 04             	mov    %edx,0x4(%eax)
  803b0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b12:	8b 00                	mov    (%eax),%eax
  803b14:	85 c0                	test   %eax,%eax
  803b16:	75 08                	jne    803b20 <realloc_block_FF+0x199>
  803b18:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b1b:	a3 34 50 80 00       	mov    %eax,0x805034
  803b20:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b25:	40                   	inc    %eax
  803b26:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803b2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b2f:	75 17                	jne    803b48 <realloc_block_FF+0x1c1>
  803b31:	83 ec 04             	sub    $0x4,%esp
  803b34:	68 07 4c 80 00       	push   $0x804c07
  803b39:	68 f7 01 00 00       	push   $0x1f7
  803b3e:	68 25 4c 80 00       	push   $0x804c25
  803b43:	e8 2e cd ff ff       	call   800876 <_panic>
  803b48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b4b:	8b 00                	mov    (%eax),%eax
  803b4d:	85 c0                	test   %eax,%eax
  803b4f:	74 10                	je     803b61 <realloc_block_FF+0x1da>
  803b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b54:	8b 00                	mov    (%eax),%eax
  803b56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b59:	8b 52 04             	mov    0x4(%edx),%edx
  803b5c:	89 50 04             	mov    %edx,0x4(%eax)
  803b5f:	eb 0b                	jmp    803b6c <realloc_block_FF+0x1e5>
  803b61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b64:	8b 40 04             	mov    0x4(%eax),%eax
  803b67:	a3 34 50 80 00       	mov    %eax,0x805034
  803b6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b6f:	8b 40 04             	mov    0x4(%eax),%eax
  803b72:	85 c0                	test   %eax,%eax
  803b74:	74 0f                	je     803b85 <realloc_block_FF+0x1fe>
  803b76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b79:	8b 40 04             	mov    0x4(%eax),%eax
  803b7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b7f:	8b 12                	mov    (%edx),%edx
  803b81:	89 10                	mov    %edx,(%eax)
  803b83:	eb 0a                	jmp    803b8f <realloc_block_FF+0x208>
  803b85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b88:	8b 00                	mov    (%eax),%eax
  803b8a:	a3 30 50 80 00       	mov    %eax,0x805030
  803b8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ba2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ba7:	48                   	dec    %eax
  803ba8:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803bad:	e9 83 02 00 00       	jmp    803e35 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803bb2:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803bb6:	0f 86 69 02 00 00    	jbe    803e25 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803bbc:	83 ec 04             	sub    $0x4,%esp
  803bbf:	6a 01                	push   $0x1
  803bc1:	ff 75 f0             	pushl  -0x10(%ebp)
  803bc4:	ff 75 08             	pushl  0x8(%ebp)
  803bc7:	e8 c8 ed ff ff       	call   802994 <set_block_data>
  803bcc:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd2:	83 e8 04             	sub    $0x4,%eax
  803bd5:	8b 00                	mov    (%eax),%eax
  803bd7:	83 e0 fe             	and    $0xfffffffe,%eax
  803bda:	89 c2                	mov    %eax,%edx
  803bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  803bdf:	01 d0                	add    %edx,%eax
  803be1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803be4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803be9:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803bec:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803bf0:	75 68                	jne    803c5a <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803bf2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bf6:	75 17                	jne    803c0f <realloc_block_FF+0x288>
  803bf8:	83 ec 04             	sub    $0x4,%esp
  803bfb:	68 40 4c 80 00       	push   $0x804c40
  803c00:	68 06 02 00 00       	push   $0x206
  803c05:	68 25 4c 80 00       	push   $0x804c25
  803c0a:	e8 67 cc ff ff       	call   800876 <_panic>
  803c0f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803c15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c18:	89 10                	mov    %edx,(%eax)
  803c1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c1d:	8b 00                	mov    (%eax),%eax
  803c1f:	85 c0                	test   %eax,%eax
  803c21:	74 0d                	je     803c30 <realloc_block_FF+0x2a9>
  803c23:	a1 30 50 80 00       	mov    0x805030,%eax
  803c28:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c2b:	89 50 04             	mov    %edx,0x4(%eax)
  803c2e:	eb 08                	jmp    803c38 <realloc_block_FF+0x2b1>
  803c30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c33:	a3 34 50 80 00       	mov    %eax,0x805034
  803c38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c3b:	a3 30 50 80 00       	mov    %eax,0x805030
  803c40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c4a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c4f:	40                   	inc    %eax
  803c50:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c55:	e9 b0 01 00 00       	jmp    803e0a <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803c5a:	a1 30 50 80 00       	mov    0x805030,%eax
  803c5f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c62:	76 68                	jbe    803ccc <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c64:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c68:	75 17                	jne    803c81 <realloc_block_FF+0x2fa>
  803c6a:	83 ec 04             	sub    $0x4,%esp
  803c6d:	68 40 4c 80 00       	push   $0x804c40
  803c72:	68 0b 02 00 00       	push   $0x20b
  803c77:	68 25 4c 80 00       	push   $0x804c25
  803c7c:	e8 f5 cb ff ff       	call   800876 <_panic>
  803c81:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803c87:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c8a:	89 10                	mov    %edx,(%eax)
  803c8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c8f:	8b 00                	mov    (%eax),%eax
  803c91:	85 c0                	test   %eax,%eax
  803c93:	74 0d                	je     803ca2 <realloc_block_FF+0x31b>
  803c95:	a1 30 50 80 00       	mov    0x805030,%eax
  803c9a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c9d:	89 50 04             	mov    %edx,0x4(%eax)
  803ca0:	eb 08                	jmp    803caa <realloc_block_FF+0x323>
  803ca2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca5:	a3 34 50 80 00       	mov    %eax,0x805034
  803caa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cad:	a3 30 50 80 00       	mov    %eax,0x805030
  803cb2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cbc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803cc1:	40                   	inc    %eax
  803cc2:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803cc7:	e9 3e 01 00 00       	jmp    803e0a <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803ccc:	a1 30 50 80 00       	mov    0x805030,%eax
  803cd1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803cd4:	73 68                	jae    803d3e <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803cd6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cda:	75 17                	jne    803cf3 <realloc_block_FF+0x36c>
  803cdc:	83 ec 04             	sub    $0x4,%esp
  803cdf:	68 74 4c 80 00       	push   $0x804c74
  803ce4:	68 10 02 00 00       	push   $0x210
  803ce9:	68 25 4c 80 00       	push   $0x804c25
  803cee:	e8 83 cb ff ff       	call   800876 <_panic>
  803cf3:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803cf9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cfc:	89 50 04             	mov    %edx,0x4(%eax)
  803cff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d02:	8b 40 04             	mov    0x4(%eax),%eax
  803d05:	85 c0                	test   %eax,%eax
  803d07:	74 0c                	je     803d15 <realloc_block_FF+0x38e>
  803d09:	a1 34 50 80 00       	mov    0x805034,%eax
  803d0e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d11:	89 10                	mov    %edx,(%eax)
  803d13:	eb 08                	jmp    803d1d <realloc_block_FF+0x396>
  803d15:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d18:	a3 30 50 80 00       	mov    %eax,0x805030
  803d1d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d20:	a3 34 50 80 00       	mov    %eax,0x805034
  803d25:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d2e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d33:	40                   	inc    %eax
  803d34:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803d39:	e9 cc 00 00 00       	jmp    803e0a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803d3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803d45:	a1 30 50 80 00       	mov    0x805030,%eax
  803d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d4d:	e9 8a 00 00 00       	jmp    803ddc <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d55:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d58:	73 7a                	jae    803dd4 <realloc_block_FF+0x44d>
  803d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5d:	8b 00                	mov    (%eax),%eax
  803d5f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d62:	73 70                	jae    803dd4 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803d64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d68:	74 06                	je     803d70 <realloc_block_FF+0x3e9>
  803d6a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d6e:	75 17                	jne    803d87 <realloc_block_FF+0x400>
  803d70:	83 ec 04             	sub    $0x4,%esp
  803d73:	68 98 4c 80 00       	push   $0x804c98
  803d78:	68 1a 02 00 00       	push   $0x21a
  803d7d:	68 25 4c 80 00       	push   $0x804c25
  803d82:	e8 ef ca ff ff       	call   800876 <_panic>
  803d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d8a:	8b 10                	mov    (%eax),%edx
  803d8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d8f:	89 10                	mov    %edx,(%eax)
  803d91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d94:	8b 00                	mov    (%eax),%eax
  803d96:	85 c0                	test   %eax,%eax
  803d98:	74 0b                	je     803da5 <realloc_block_FF+0x41e>
  803d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d9d:	8b 00                	mov    (%eax),%eax
  803d9f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803da2:	89 50 04             	mov    %edx,0x4(%eax)
  803da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803dab:	89 10                	mov    %edx,(%eax)
  803dad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803db0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803db3:	89 50 04             	mov    %edx,0x4(%eax)
  803db6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803db9:	8b 00                	mov    (%eax),%eax
  803dbb:	85 c0                	test   %eax,%eax
  803dbd:	75 08                	jne    803dc7 <realloc_block_FF+0x440>
  803dbf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803dc2:	a3 34 50 80 00       	mov    %eax,0x805034
  803dc7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803dcc:	40                   	inc    %eax
  803dcd:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803dd2:	eb 36                	jmp    803e0a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803dd4:	a1 38 50 80 00       	mov    0x805038,%eax
  803dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ddc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803de0:	74 07                	je     803de9 <realloc_block_FF+0x462>
  803de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de5:	8b 00                	mov    (%eax),%eax
  803de7:	eb 05                	jmp    803dee <realloc_block_FF+0x467>
  803de9:	b8 00 00 00 00       	mov    $0x0,%eax
  803dee:	a3 38 50 80 00       	mov    %eax,0x805038
  803df3:	a1 38 50 80 00       	mov    0x805038,%eax
  803df8:	85 c0                	test   %eax,%eax
  803dfa:	0f 85 52 ff ff ff    	jne    803d52 <realloc_block_FF+0x3cb>
  803e00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e04:	0f 85 48 ff ff ff    	jne    803d52 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803e0a:	83 ec 04             	sub    $0x4,%esp
  803e0d:	6a 00                	push   $0x0
  803e0f:	ff 75 d8             	pushl  -0x28(%ebp)
  803e12:	ff 75 d4             	pushl  -0x2c(%ebp)
  803e15:	e8 7a eb ff ff       	call   802994 <set_block_data>
  803e1a:	83 c4 10             	add    $0x10,%esp
				return va;
  803e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803e20:	e9 7b 02 00 00       	jmp    8040a0 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803e25:	83 ec 0c             	sub    $0xc,%esp
  803e28:	68 15 4d 80 00       	push   $0x804d15
  803e2d:	e8 01 cd ff ff       	call   800b33 <cprintf>
  803e32:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803e35:	8b 45 08             	mov    0x8(%ebp),%eax
  803e38:	e9 63 02 00 00       	jmp    8040a0 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e40:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803e43:	0f 86 4d 02 00 00    	jbe    804096 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803e49:	83 ec 0c             	sub    $0xc,%esp
  803e4c:	ff 75 e4             	pushl  -0x1c(%ebp)
  803e4f:	e8 08 e8 ff ff       	call   80265c <is_free_block>
  803e54:	83 c4 10             	add    $0x10,%esp
  803e57:	84 c0                	test   %al,%al
  803e59:	0f 84 37 02 00 00    	je     804096 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e62:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803e65:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803e68:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e6b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e6e:	76 38                	jbe    803ea8 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803e70:	83 ec 0c             	sub    $0xc,%esp
  803e73:	ff 75 08             	pushl  0x8(%ebp)
  803e76:	e8 0c fa ff ff       	call   803887 <free_block>
  803e7b:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803e7e:	83 ec 0c             	sub    $0xc,%esp
  803e81:	ff 75 0c             	pushl  0xc(%ebp)
  803e84:	e8 3a eb ff ff       	call   8029c3 <alloc_block_FF>
  803e89:	83 c4 10             	add    $0x10,%esp
  803e8c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803e8f:	83 ec 08             	sub    $0x8,%esp
  803e92:	ff 75 c0             	pushl  -0x40(%ebp)
  803e95:	ff 75 08             	pushl  0x8(%ebp)
  803e98:	e8 ab fa ff ff       	call   803948 <copy_data>
  803e9d:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803ea0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803ea3:	e9 f8 01 00 00       	jmp    8040a0 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803ea8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803eab:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803eae:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803eb1:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803eb5:	0f 87 a0 00 00 00    	ja     803f5b <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803ebb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ebf:	75 17                	jne    803ed8 <realloc_block_FF+0x551>
  803ec1:	83 ec 04             	sub    $0x4,%esp
  803ec4:	68 07 4c 80 00       	push   $0x804c07
  803ec9:	68 38 02 00 00       	push   $0x238
  803ece:	68 25 4c 80 00       	push   $0x804c25
  803ed3:	e8 9e c9 ff ff       	call   800876 <_panic>
  803ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803edb:	8b 00                	mov    (%eax),%eax
  803edd:	85 c0                	test   %eax,%eax
  803edf:	74 10                	je     803ef1 <realloc_block_FF+0x56a>
  803ee1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee4:	8b 00                	mov    (%eax),%eax
  803ee6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ee9:	8b 52 04             	mov    0x4(%edx),%edx
  803eec:	89 50 04             	mov    %edx,0x4(%eax)
  803eef:	eb 0b                	jmp    803efc <realloc_block_FF+0x575>
  803ef1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ef4:	8b 40 04             	mov    0x4(%eax),%eax
  803ef7:	a3 34 50 80 00       	mov    %eax,0x805034
  803efc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eff:	8b 40 04             	mov    0x4(%eax),%eax
  803f02:	85 c0                	test   %eax,%eax
  803f04:	74 0f                	je     803f15 <realloc_block_FF+0x58e>
  803f06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f09:	8b 40 04             	mov    0x4(%eax),%eax
  803f0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f0f:	8b 12                	mov    (%edx),%edx
  803f11:	89 10                	mov    %edx,(%eax)
  803f13:	eb 0a                	jmp    803f1f <realloc_block_FF+0x598>
  803f15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f18:	8b 00                	mov    (%eax),%eax
  803f1a:	a3 30 50 80 00       	mov    %eax,0x805030
  803f1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f32:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f37:	48                   	dec    %eax
  803f38:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803f3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f43:	01 d0                	add    %edx,%eax
  803f45:	83 ec 04             	sub    $0x4,%esp
  803f48:	6a 01                	push   $0x1
  803f4a:	50                   	push   %eax
  803f4b:	ff 75 08             	pushl  0x8(%ebp)
  803f4e:	e8 41 ea ff ff       	call   802994 <set_block_data>
  803f53:	83 c4 10             	add    $0x10,%esp
  803f56:	e9 36 01 00 00       	jmp    804091 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803f5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f5e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f61:	01 d0                	add    %edx,%eax
  803f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803f66:	83 ec 04             	sub    $0x4,%esp
  803f69:	6a 01                	push   $0x1
  803f6b:	ff 75 f0             	pushl  -0x10(%ebp)
  803f6e:	ff 75 08             	pushl  0x8(%ebp)
  803f71:	e8 1e ea ff ff       	call   802994 <set_block_data>
  803f76:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803f79:	8b 45 08             	mov    0x8(%ebp),%eax
  803f7c:	83 e8 04             	sub    $0x4,%eax
  803f7f:	8b 00                	mov    (%eax),%eax
  803f81:	83 e0 fe             	and    $0xfffffffe,%eax
  803f84:	89 c2                	mov    %eax,%edx
  803f86:	8b 45 08             	mov    0x8(%ebp),%eax
  803f89:	01 d0                	add    %edx,%eax
  803f8b:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803f8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f92:	74 06                	je     803f9a <realloc_block_FF+0x613>
  803f94:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803f98:	75 17                	jne    803fb1 <realloc_block_FF+0x62a>
  803f9a:	83 ec 04             	sub    $0x4,%esp
  803f9d:	68 98 4c 80 00       	push   $0x804c98
  803fa2:	68 44 02 00 00       	push   $0x244
  803fa7:	68 25 4c 80 00       	push   $0x804c25
  803fac:	e8 c5 c8 ff ff       	call   800876 <_panic>
  803fb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fb4:	8b 10                	mov    (%eax),%edx
  803fb6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fb9:	89 10                	mov    %edx,(%eax)
  803fbb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fbe:	8b 00                	mov    (%eax),%eax
  803fc0:	85 c0                	test   %eax,%eax
  803fc2:	74 0b                	je     803fcf <realloc_block_FF+0x648>
  803fc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fc7:	8b 00                	mov    (%eax),%eax
  803fc9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803fcc:	89 50 04             	mov    %edx,0x4(%eax)
  803fcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803fd5:	89 10                	mov    %edx,(%eax)
  803fd7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fdd:	89 50 04             	mov    %edx,0x4(%eax)
  803fe0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fe3:	8b 00                	mov    (%eax),%eax
  803fe5:	85 c0                	test   %eax,%eax
  803fe7:	75 08                	jne    803ff1 <realloc_block_FF+0x66a>
  803fe9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fec:	a3 34 50 80 00       	mov    %eax,0x805034
  803ff1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ff6:	40                   	inc    %eax
  803ff7:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ffc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804000:	75 17                	jne    804019 <realloc_block_FF+0x692>
  804002:	83 ec 04             	sub    $0x4,%esp
  804005:	68 07 4c 80 00       	push   $0x804c07
  80400a:	68 45 02 00 00       	push   $0x245
  80400f:	68 25 4c 80 00       	push   $0x804c25
  804014:	e8 5d c8 ff ff       	call   800876 <_panic>
  804019:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80401c:	8b 00                	mov    (%eax),%eax
  80401e:	85 c0                	test   %eax,%eax
  804020:	74 10                	je     804032 <realloc_block_FF+0x6ab>
  804022:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804025:	8b 00                	mov    (%eax),%eax
  804027:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80402a:	8b 52 04             	mov    0x4(%edx),%edx
  80402d:	89 50 04             	mov    %edx,0x4(%eax)
  804030:	eb 0b                	jmp    80403d <realloc_block_FF+0x6b6>
  804032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804035:	8b 40 04             	mov    0x4(%eax),%eax
  804038:	a3 34 50 80 00       	mov    %eax,0x805034
  80403d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804040:	8b 40 04             	mov    0x4(%eax),%eax
  804043:	85 c0                	test   %eax,%eax
  804045:	74 0f                	je     804056 <realloc_block_FF+0x6cf>
  804047:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80404a:	8b 40 04             	mov    0x4(%eax),%eax
  80404d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804050:	8b 12                	mov    (%edx),%edx
  804052:	89 10                	mov    %edx,(%eax)
  804054:	eb 0a                	jmp    804060 <realloc_block_FF+0x6d9>
  804056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804059:	8b 00                	mov    (%eax),%eax
  80405b:	a3 30 50 80 00       	mov    %eax,0x805030
  804060:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804063:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804069:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80406c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804073:	a1 3c 50 80 00       	mov    0x80503c,%eax
  804078:	48                   	dec    %eax
  804079:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  80407e:	83 ec 04             	sub    $0x4,%esp
  804081:	6a 00                	push   $0x0
  804083:	ff 75 bc             	pushl  -0x44(%ebp)
  804086:	ff 75 b8             	pushl  -0x48(%ebp)
  804089:	e8 06 e9 ff ff       	call   802994 <set_block_data>
  80408e:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804091:	8b 45 08             	mov    0x8(%ebp),%eax
  804094:	eb 0a                	jmp    8040a0 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804096:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80409d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8040a0:	c9                   	leave  
  8040a1:	c3                   	ret    

008040a2 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8040a2:	55                   	push   %ebp
  8040a3:	89 e5                	mov    %esp,%ebp
  8040a5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8040a8:	83 ec 04             	sub    $0x4,%esp
  8040ab:	68 1c 4d 80 00       	push   $0x804d1c
  8040b0:	68 58 02 00 00       	push   $0x258
  8040b5:	68 25 4c 80 00       	push   $0x804c25
  8040ba:	e8 b7 c7 ff ff       	call   800876 <_panic>

008040bf <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8040bf:	55                   	push   %ebp
  8040c0:	89 e5                	mov    %esp,%ebp
  8040c2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8040c5:	83 ec 04             	sub    $0x4,%esp
  8040c8:	68 44 4d 80 00       	push   $0x804d44
  8040cd:	68 61 02 00 00       	push   $0x261
  8040d2:	68 25 4c 80 00       	push   $0x804c25
  8040d7:	e8 9a c7 ff ff       	call   800876 <_panic>

008040dc <__udivdi3>:
  8040dc:	55                   	push   %ebp
  8040dd:	57                   	push   %edi
  8040de:	56                   	push   %esi
  8040df:	53                   	push   %ebx
  8040e0:	83 ec 1c             	sub    $0x1c,%esp
  8040e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8040e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8040eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040f3:	89 ca                	mov    %ecx,%edx
  8040f5:	89 f8                	mov    %edi,%eax
  8040f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040fb:	85 f6                	test   %esi,%esi
  8040fd:	75 2d                	jne    80412c <__udivdi3+0x50>
  8040ff:	39 cf                	cmp    %ecx,%edi
  804101:	77 65                	ja     804168 <__udivdi3+0x8c>
  804103:	89 fd                	mov    %edi,%ebp
  804105:	85 ff                	test   %edi,%edi
  804107:	75 0b                	jne    804114 <__udivdi3+0x38>
  804109:	b8 01 00 00 00       	mov    $0x1,%eax
  80410e:	31 d2                	xor    %edx,%edx
  804110:	f7 f7                	div    %edi
  804112:	89 c5                	mov    %eax,%ebp
  804114:	31 d2                	xor    %edx,%edx
  804116:	89 c8                	mov    %ecx,%eax
  804118:	f7 f5                	div    %ebp
  80411a:	89 c1                	mov    %eax,%ecx
  80411c:	89 d8                	mov    %ebx,%eax
  80411e:	f7 f5                	div    %ebp
  804120:	89 cf                	mov    %ecx,%edi
  804122:	89 fa                	mov    %edi,%edx
  804124:	83 c4 1c             	add    $0x1c,%esp
  804127:	5b                   	pop    %ebx
  804128:	5e                   	pop    %esi
  804129:	5f                   	pop    %edi
  80412a:	5d                   	pop    %ebp
  80412b:	c3                   	ret    
  80412c:	39 ce                	cmp    %ecx,%esi
  80412e:	77 28                	ja     804158 <__udivdi3+0x7c>
  804130:	0f bd fe             	bsr    %esi,%edi
  804133:	83 f7 1f             	xor    $0x1f,%edi
  804136:	75 40                	jne    804178 <__udivdi3+0x9c>
  804138:	39 ce                	cmp    %ecx,%esi
  80413a:	72 0a                	jb     804146 <__udivdi3+0x6a>
  80413c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804140:	0f 87 9e 00 00 00    	ja     8041e4 <__udivdi3+0x108>
  804146:	b8 01 00 00 00       	mov    $0x1,%eax
  80414b:	89 fa                	mov    %edi,%edx
  80414d:	83 c4 1c             	add    $0x1c,%esp
  804150:	5b                   	pop    %ebx
  804151:	5e                   	pop    %esi
  804152:	5f                   	pop    %edi
  804153:	5d                   	pop    %ebp
  804154:	c3                   	ret    
  804155:	8d 76 00             	lea    0x0(%esi),%esi
  804158:	31 ff                	xor    %edi,%edi
  80415a:	31 c0                	xor    %eax,%eax
  80415c:	89 fa                	mov    %edi,%edx
  80415e:	83 c4 1c             	add    $0x1c,%esp
  804161:	5b                   	pop    %ebx
  804162:	5e                   	pop    %esi
  804163:	5f                   	pop    %edi
  804164:	5d                   	pop    %ebp
  804165:	c3                   	ret    
  804166:	66 90                	xchg   %ax,%ax
  804168:	89 d8                	mov    %ebx,%eax
  80416a:	f7 f7                	div    %edi
  80416c:	31 ff                	xor    %edi,%edi
  80416e:	89 fa                	mov    %edi,%edx
  804170:	83 c4 1c             	add    $0x1c,%esp
  804173:	5b                   	pop    %ebx
  804174:	5e                   	pop    %esi
  804175:	5f                   	pop    %edi
  804176:	5d                   	pop    %ebp
  804177:	c3                   	ret    
  804178:	bd 20 00 00 00       	mov    $0x20,%ebp
  80417d:	89 eb                	mov    %ebp,%ebx
  80417f:	29 fb                	sub    %edi,%ebx
  804181:	89 f9                	mov    %edi,%ecx
  804183:	d3 e6                	shl    %cl,%esi
  804185:	89 c5                	mov    %eax,%ebp
  804187:	88 d9                	mov    %bl,%cl
  804189:	d3 ed                	shr    %cl,%ebp
  80418b:	89 e9                	mov    %ebp,%ecx
  80418d:	09 f1                	or     %esi,%ecx
  80418f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804193:	89 f9                	mov    %edi,%ecx
  804195:	d3 e0                	shl    %cl,%eax
  804197:	89 c5                	mov    %eax,%ebp
  804199:	89 d6                	mov    %edx,%esi
  80419b:	88 d9                	mov    %bl,%cl
  80419d:	d3 ee                	shr    %cl,%esi
  80419f:	89 f9                	mov    %edi,%ecx
  8041a1:	d3 e2                	shl    %cl,%edx
  8041a3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041a7:	88 d9                	mov    %bl,%cl
  8041a9:	d3 e8                	shr    %cl,%eax
  8041ab:	09 c2                	or     %eax,%edx
  8041ad:	89 d0                	mov    %edx,%eax
  8041af:	89 f2                	mov    %esi,%edx
  8041b1:	f7 74 24 0c          	divl   0xc(%esp)
  8041b5:	89 d6                	mov    %edx,%esi
  8041b7:	89 c3                	mov    %eax,%ebx
  8041b9:	f7 e5                	mul    %ebp
  8041bb:	39 d6                	cmp    %edx,%esi
  8041bd:	72 19                	jb     8041d8 <__udivdi3+0xfc>
  8041bf:	74 0b                	je     8041cc <__udivdi3+0xf0>
  8041c1:	89 d8                	mov    %ebx,%eax
  8041c3:	31 ff                	xor    %edi,%edi
  8041c5:	e9 58 ff ff ff       	jmp    804122 <__udivdi3+0x46>
  8041ca:	66 90                	xchg   %ax,%ax
  8041cc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8041d0:	89 f9                	mov    %edi,%ecx
  8041d2:	d3 e2                	shl    %cl,%edx
  8041d4:	39 c2                	cmp    %eax,%edx
  8041d6:	73 e9                	jae    8041c1 <__udivdi3+0xe5>
  8041d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8041db:	31 ff                	xor    %edi,%edi
  8041dd:	e9 40 ff ff ff       	jmp    804122 <__udivdi3+0x46>
  8041e2:	66 90                	xchg   %ax,%ax
  8041e4:	31 c0                	xor    %eax,%eax
  8041e6:	e9 37 ff ff ff       	jmp    804122 <__udivdi3+0x46>
  8041eb:	90                   	nop

008041ec <__umoddi3>:
  8041ec:	55                   	push   %ebp
  8041ed:	57                   	push   %edi
  8041ee:	56                   	push   %esi
  8041ef:	53                   	push   %ebx
  8041f0:	83 ec 1c             	sub    $0x1c,%esp
  8041f3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041f7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041ff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804203:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804207:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80420b:	89 f3                	mov    %esi,%ebx
  80420d:	89 fa                	mov    %edi,%edx
  80420f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804213:	89 34 24             	mov    %esi,(%esp)
  804216:	85 c0                	test   %eax,%eax
  804218:	75 1a                	jne    804234 <__umoddi3+0x48>
  80421a:	39 f7                	cmp    %esi,%edi
  80421c:	0f 86 a2 00 00 00    	jbe    8042c4 <__umoddi3+0xd8>
  804222:	89 c8                	mov    %ecx,%eax
  804224:	89 f2                	mov    %esi,%edx
  804226:	f7 f7                	div    %edi
  804228:	89 d0                	mov    %edx,%eax
  80422a:	31 d2                	xor    %edx,%edx
  80422c:	83 c4 1c             	add    $0x1c,%esp
  80422f:	5b                   	pop    %ebx
  804230:	5e                   	pop    %esi
  804231:	5f                   	pop    %edi
  804232:	5d                   	pop    %ebp
  804233:	c3                   	ret    
  804234:	39 f0                	cmp    %esi,%eax
  804236:	0f 87 ac 00 00 00    	ja     8042e8 <__umoddi3+0xfc>
  80423c:	0f bd e8             	bsr    %eax,%ebp
  80423f:	83 f5 1f             	xor    $0x1f,%ebp
  804242:	0f 84 ac 00 00 00    	je     8042f4 <__umoddi3+0x108>
  804248:	bf 20 00 00 00       	mov    $0x20,%edi
  80424d:	29 ef                	sub    %ebp,%edi
  80424f:	89 fe                	mov    %edi,%esi
  804251:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804255:	89 e9                	mov    %ebp,%ecx
  804257:	d3 e0                	shl    %cl,%eax
  804259:	89 d7                	mov    %edx,%edi
  80425b:	89 f1                	mov    %esi,%ecx
  80425d:	d3 ef                	shr    %cl,%edi
  80425f:	09 c7                	or     %eax,%edi
  804261:	89 e9                	mov    %ebp,%ecx
  804263:	d3 e2                	shl    %cl,%edx
  804265:	89 14 24             	mov    %edx,(%esp)
  804268:	89 d8                	mov    %ebx,%eax
  80426a:	d3 e0                	shl    %cl,%eax
  80426c:	89 c2                	mov    %eax,%edx
  80426e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804272:	d3 e0                	shl    %cl,%eax
  804274:	89 44 24 04          	mov    %eax,0x4(%esp)
  804278:	8b 44 24 08          	mov    0x8(%esp),%eax
  80427c:	89 f1                	mov    %esi,%ecx
  80427e:	d3 e8                	shr    %cl,%eax
  804280:	09 d0                	or     %edx,%eax
  804282:	d3 eb                	shr    %cl,%ebx
  804284:	89 da                	mov    %ebx,%edx
  804286:	f7 f7                	div    %edi
  804288:	89 d3                	mov    %edx,%ebx
  80428a:	f7 24 24             	mull   (%esp)
  80428d:	89 c6                	mov    %eax,%esi
  80428f:	89 d1                	mov    %edx,%ecx
  804291:	39 d3                	cmp    %edx,%ebx
  804293:	0f 82 87 00 00 00    	jb     804320 <__umoddi3+0x134>
  804299:	0f 84 91 00 00 00    	je     804330 <__umoddi3+0x144>
  80429f:	8b 54 24 04          	mov    0x4(%esp),%edx
  8042a3:	29 f2                	sub    %esi,%edx
  8042a5:	19 cb                	sbb    %ecx,%ebx
  8042a7:	89 d8                	mov    %ebx,%eax
  8042a9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8042ad:	d3 e0                	shl    %cl,%eax
  8042af:	89 e9                	mov    %ebp,%ecx
  8042b1:	d3 ea                	shr    %cl,%edx
  8042b3:	09 d0                	or     %edx,%eax
  8042b5:	89 e9                	mov    %ebp,%ecx
  8042b7:	d3 eb                	shr    %cl,%ebx
  8042b9:	89 da                	mov    %ebx,%edx
  8042bb:	83 c4 1c             	add    $0x1c,%esp
  8042be:	5b                   	pop    %ebx
  8042bf:	5e                   	pop    %esi
  8042c0:	5f                   	pop    %edi
  8042c1:	5d                   	pop    %ebp
  8042c2:	c3                   	ret    
  8042c3:	90                   	nop
  8042c4:	89 fd                	mov    %edi,%ebp
  8042c6:	85 ff                	test   %edi,%edi
  8042c8:	75 0b                	jne    8042d5 <__umoddi3+0xe9>
  8042ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8042cf:	31 d2                	xor    %edx,%edx
  8042d1:	f7 f7                	div    %edi
  8042d3:	89 c5                	mov    %eax,%ebp
  8042d5:	89 f0                	mov    %esi,%eax
  8042d7:	31 d2                	xor    %edx,%edx
  8042d9:	f7 f5                	div    %ebp
  8042db:	89 c8                	mov    %ecx,%eax
  8042dd:	f7 f5                	div    %ebp
  8042df:	89 d0                	mov    %edx,%eax
  8042e1:	e9 44 ff ff ff       	jmp    80422a <__umoddi3+0x3e>
  8042e6:	66 90                	xchg   %ax,%ax
  8042e8:	89 c8                	mov    %ecx,%eax
  8042ea:	89 f2                	mov    %esi,%edx
  8042ec:	83 c4 1c             	add    $0x1c,%esp
  8042ef:	5b                   	pop    %ebx
  8042f0:	5e                   	pop    %esi
  8042f1:	5f                   	pop    %edi
  8042f2:	5d                   	pop    %ebp
  8042f3:	c3                   	ret    
  8042f4:	3b 04 24             	cmp    (%esp),%eax
  8042f7:	72 06                	jb     8042ff <__umoddi3+0x113>
  8042f9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042fd:	77 0f                	ja     80430e <__umoddi3+0x122>
  8042ff:	89 f2                	mov    %esi,%edx
  804301:	29 f9                	sub    %edi,%ecx
  804303:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804307:	89 14 24             	mov    %edx,(%esp)
  80430a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80430e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804312:	8b 14 24             	mov    (%esp),%edx
  804315:	83 c4 1c             	add    $0x1c,%esp
  804318:	5b                   	pop    %ebx
  804319:	5e                   	pop    %esi
  80431a:	5f                   	pop    %edi
  80431b:	5d                   	pop    %ebp
  80431c:	c3                   	ret    
  80431d:	8d 76 00             	lea    0x0(%esi),%esi
  804320:	2b 04 24             	sub    (%esp),%eax
  804323:	19 fa                	sbb    %edi,%edx
  804325:	89 d1                	mov    %edx,%ecx
  804327:	89 c6                	mov    %eax,%esi
  804329:	e9 71 ff ff ff       	jmp    80429f <__umoddi3+0xb3>
  80432e:	66 90                	xchg   %ax,%ax
  804330:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804334:	72 ea                	jb     804320 <__umoddi3+0x134>
  804336:	89 d9                	mov    %ebx,%ecx
  804338:	e9 62 ff ff ff       	jmp    80429f <__umoddi3+0xb3>
