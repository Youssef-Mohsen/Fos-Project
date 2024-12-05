
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
  800041:	e8 2f 20 00 00       	call   802075 <sys_lock_cons>
		{
			cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 43 80 00       	push   $0x804300
  80004e:	e8 e0 0a 00 00       	call   800b33 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 43 80 00       	push   $0x804302
  80005e:	e8 d0 0a 00 00       	call   800b33 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 18 43 80 00       	push   $0x804318
  80006e:	e8 c0 0a 00 00       	call   800b33 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
			cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 43 80 00       	push   $0x804302
  80007e:	e8 b0 0a 00 00       	call   800b33 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
			cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 43 80 00       	push   $0x804300
  80008e:	e8 a0 0a 00 00       	call   800b33 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
			readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 30 43 80 00       	push   $0x804330
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
  8000de:	68 50 43 80 00       	push   $0x804350
  8000e3:	e8 4b 0a 00 00       	call   800b33 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 72 43 80 00       	push   $0x804372
  8000f3:	e8 3b 0a 00 00       	call   800b33 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 80 43 80 00       	push   $0x804380
  800103:	e8 2b 0a 00 00       	call   800b33 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 8f 43 80 00       	push   $0x80438f
  800113:	e8 1b 0a 00 00       	call   800b33 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 9f 43 80 00       	push   $0x80439f
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
  800162:	e8 28 1f 00 00       	call   80208f <sys_unlock_cons>
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
  8001d7:	e8 99 1e 00 00       	call   802075 <sys_lock_cons>
		{
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 a8 43 80 00       	push   $0x8043a8
  8001e4:	e8 4a 09 00 00       	call   800b33 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
			//PrintElements(Elements, NumOfElements);
		}
		sys_unlock_cons();
  8001ec:	e8 9e 1e 00 00       	call   80208f <sys_unlock_cons>
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
  80020e:	68 dc 43 80 00       	push   $0x8043dc
  800213:	6a 51                	push   $0x51
  800215:	68 fe 43 80 00       	push   $0x8043fe
  80021a:	e8 57 06 00 00       	call   800876 <_panic>
		else
		{
//			sys_lock_cons();
			sys_lock_cons();
  80021f:	e8 51 1e 00 00       	call   802075 <sys_lock_cons>
			{
				cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 18 44 80 00       	push   $0x804418
  80022c:	e8 02 09 00 00       	call   800b33 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 4c 44 80 00       	push   $0x80444c
  80023c:	e8 f2 08 00 00       	call   800b33 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 80 44 80 00       	push   $0x804480
  80024c:	e8 e2 08 00 00       	call   800b33 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			}
			sys_unlock_cons();
  800254:	e8 36 1e 00 00       	call   80208f <sys_unlock_cons>
		}

		//free(Elements) ;

//		sys_lock_cons();
		sys_lock_cons();
  800259:	e8 17 1e 00 00       	call   802075 <sys_lock_cons>
		{
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 b2 44 80 00       	push   $0x8044b2
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
  8002b2:	e8 d8 1d 00 00       	call   80208f <sys_unlock_cons>
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
  800446:	68 00 43 80 00       	push   $0x804300
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
  800468:	68 d0 44 80 00       	push   $0x8044d0
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
  800496:	68 d5 44 80 00       	push   $0x8044d5
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
  80070f:	e8 ac 1a 00 00       	call   8021c0 <sys_cputc>
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
  800720:	e8 37 19 00 00       	call   80205c <sys_cgetc>
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
  80073d:	e8 af 1b 00 00       	call   8022f1 <sys_getenvindex>
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
  8007ab:	e8 c5 18 00 00       	call   802075 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8007b0:	83 ec 0c             	sub    $0xc,%esp
  8007b3:	68 f4 44 80 00       	push   $0x8044f4
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
  8007db:	68 1c 45 80 00       	push   $0x80451c
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
  80080c:	68 44 45 80 00       	push   $0x804544
  800811:	e8 1d 03 00 00       	call   800b33 <cprintf>
  800816:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800819:	a1 24 50 80 00       	mov    0x805024,%eax
  80081e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	50                   	push   %eax
  800828:	68 9c 45 80 00       	push   $0x80459c
  80082d:	e8 01 03 00 00       	call   800b33 <cprintf>
  800832:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800835:	83 ec 0c             	sub    $0xc,%esp
  800838:	68 f4 44 80 00       	push   $0x8044f4
  80083d:	e8 f1 02 00 00       	call   800b33 <cprintf>
  800842:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800845:	e8 45 18 00 00       	call   80208f <sys_unlock_cons>
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
  80085d:	e8 5b 1a 00 00       	call   8022bd <sys_destroy_env>
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
  80086e:	e8 b0 1a 00 00       	call   802323 <sys_exit_env>
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
  800897:	68 b0 45 80 00       	push   $0x8045b0
  80089c:	e8 92 02 00 00       	call   800b33 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008a4:	a1 00 50 80 00       	mov    0x805000,%eax
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	ff 75 08             	pushl  0x8(%ebp)
  8008af:	50                   	push   %eax
  8008b0:	68 b5 45 80 00       	push   $0x8045b5
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
  8008d4:	68 d1 45 80 00       	push   $0x8045d1
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
  800903:	68 d4 45 80 00       	push   $0x8045d4
  800908:	6a 26                	push   $0x26
  80090a:	68 20 46 80 00       	push   $0x804620
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
  8009d8:	68 2c 46 80 00       	push   $0x80462c
  8009dd:	6a 3a                	push   $0x3a
  8009df:	68 20 46 80 00       	push   $0x804620
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
  800a4b:	68 80 46 80 00       	push   $0x804680
  800a50:	6a 44                	push   $0x44
  800a52:	68 20 46 80 00       	push   $0x804620
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
  800aa5:	e8 89 15 00 00       	call   802033 <sys_cputs>
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
  800b1c:	e8 12 15 00 00       	call   802033 <sys_cputs>
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
  800b66:	e8 0a 15 00 00       	call   802075 <sys_lock_cons>
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
  800b86:	e8 04 15 00 00       	call   80208f <sys_unlock_cons>
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
  800bd0:	e8 c3 34 00 00       	call   804098 <__udivdi3>
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
  800c20:	e8 83 35 00 00       	call   8041a8 <__umoddi3>
  800c25:	83 c4 10             	add    $0x10,%esp
  800c28:	05 f4 48 80 00       	add    $0x8048f4,%eax
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
  800d7b:	8b 04 85 18 49 80 00 	mov    0x804918(,%eax,4),%eax
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
  800e5c:	8b 34 9d 60 47 80 00 	mov    0x804760(,%ebx,4),%esi
  800e63:	85 f6                	test   %esi,%esi
  800e65:	75 19                	jne    800e80 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e67:	53                   	push   %ebx
  800e68:	68 05 49 80 00       	push   $0x804905
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
  800e81:	68 0e 49 80 00       	push   $0x80490e
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
  800eae:	be 11 49 80 00       	mov    $0x804911,%esi
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
  8011d9:	68 88 4a 80 00       	push   $0x804a88
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
  80121b:	68 8b 4a 80 00       	push   $0x804a8b
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
  8012cc:	e8 a4 0d 00 00       	call   802075 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  8012d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d5:	74 13                	je     8012ea <atomic_readline+0x24>
			cprintf("%s", prompt);
  8012d7:	83 ec 08             	sub    $0x8,%esp
  8012da:	ff 75 08             	pushl  0x8(%ebp)
  8012dd:	68 88 4a 80 00       	push   $0x804a88
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
  80131f:	68 8b 4a 80 00       	push   $0x804a8b
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
  8013c7:	e8 c3 0c 00 00       	call   80208f <sys_unlock_cons>
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
  801ac1:	68 9c 4a 80 00       	push   $0x804a9c
  801ac6:	68 3f 01 00 00       	push   $0x13f
  801acb:	68 be 4a 80 00       	push   $0x804abe
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
  801ae1:	e8 f8 0a 00 00       	call   8025de <sys_sbrk>
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
  801b5c:	e8 01 09 00 00       	call   802462 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b61:	85 c0                	test   %eax,%eax
  801b63:	74 16                	je     801b7b <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801b65:	83 ec 0c             	sub    $0xc,%esp
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	e8 41 0e 00 00       	call   8029b1 <alloc_block_FF>
  801b70:	83 c4 10             	add    $0x10,%esp
  801b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b76:	e9 8a 01 00 00       	jmp    801d05 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801b7b:	e8 13 09 00 00       	call   802493 <sys_isUHeapPlacementStrategyBESTFIT>
  801b80:	85 c0                	test   %eax,%eax
  801b82:	0f 84 7d 01 00 00    	je     801d05 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801b88:	83 ec 0c             	sub    $0xc,%esp
  801b8b:	ff 75 08             	pushl  0x8(%ebp)
  801b8e:	e8 da 12 00 00       	call   802e6d <alloc_block_BF>
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf0:	05 00 10 00 00       	add    $0x1000,%eax
  801bf5:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801bf8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
				

			}
			sayed:
			if(ok) break;
  801c98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c9c:	75 16                	jne    801cb4 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801c9e:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801ca5:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801cac:	0f 86 15 ff ff ff    	jbe    801bc7 <malloc+0xdc>
  801cb2:	eb 01                	jmp    801cb5 <malloc+0x1ca>
				}
				

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
  801cf4:	e8 1c 09 00 00       	call   802615 <sys_allocate_user_mem>
  801cf9:	83 c4 10             	add    $0x10,%esp
  801cfc:	eb 07                	jmp    801d05 <malloc+0x21a>
		
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
  801d3c:	e8 f0 08 00 00       	call   802631 <get_block_size>
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	ff 75 08             	pushl  0x8(%ebp)
  801d4d:	e8 00 1b 00 00       	call   803852 <free_block>
  801d52:	83 c4 10             	add    $0x10,%esp
		}

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
  801da1:	eb 42                	jmp    801de5 <free+0xdb>
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
			sys_free_user_mem((uint32)va, k);
  801dcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	83 ec 08             	sub    $0x8,%esp
  801dd8:	52                   	push   %edx
  801dd9:	50                   	push   %eax
  801dda:	e8 1a 08 00 00       	call   8025f9 <sys_free_user_mem>
  801ddf:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801de2:	ff 45 f4             	incl   -0xc(%ebp)
  801de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801deb:	72 b6                	jb     801da3 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801ded:	eb 17                	jmp    801e06 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801def:	83 ec 04             	sub    $0x4,%esp
  801df2:	68 cc 4a 80 00       	push   $0x804acc
  801df7:	68 87 00 00 00       	push   $0x87
  801dfc:	68 f6 4a 80 00       	push   $0x804af6
  801e01:	e8 70 ea ff ff       	call   800876 <_panic>
	}
}
  801e06:	90                   	nop
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 28             	sub    $0x28,%esp
  801e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e12:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801e15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e19:	75 0a                	jne    801e25 <smalloc+0x1c>
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e20:	e9 87 00 00 00       	jmp    801eac <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e2b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e38:	39 d0                	cmp    %edx,%eax
  801e3a:	73 02                	jae    801e3e <smalloc+0x35>
  801e3c:	89 d0                	mov    %edx,%eax
  801e3e:	83 ec 0c             	sub    $0xc,%esp
  801e41:	50                   	push   %eax
  801e42:	e8 a4 fc ff ff       	call   801aeb <malloc>
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801e4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e51:	75 07                	jne    801e5a <smalloc+0x51>
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
  801e58:	eb 52                	jmp    801eac <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801e5a:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e5e:	ff 75 ec             	pushl  -0x14(%ebp)
  801e61:	50                   	push   %eax
  801e62:	ff 75 0c             	pushl  0xc(%ebp)
  801e65:	ff 75 08             	pushl  0x8(%ebp)
  801e68:	e8 93 03 00 00       	call   802200 <sys_createSharedObject>
  801e6d:	83 c4 10             	add    $0x10,%esp
  801e70:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801e73:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e77:	74 06                	je     801e7f <smalloc+0x76>
  801e79:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e7d:	75 07                	jne    801e86 <smalloc+0x7d>
  801e7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e84:	eb 26                	jmp    801eac <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801e86:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e89:	a1 24 50 80 00       	mov    0x805024,%eax
  801e8e:	8b 40 78             	mov    0x78(%eax),%eax
  801e91:	29 c2                	sub    %eax,%edx
  801e93:	89 d0                	mov    %edx,%eax
  801e95:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e9a:	c1 e8 0c             	shr    $0xc,%eax
  801e9d:	89 c2                	mov    %eax,%edx
  801e9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ea2:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801eb4:	83 ec 08             	sub    $0x8,%esp
  801eb7:	ff 75 0c             	pushl  0xc(%ebp)
  801eba:	ff 75 08             	pushl  0x8(%ebp)
  801ebd:	e8 68 03 00 00       	call   80222a <sys_getSizeOfSharedObject>
  801ec2:	83 c4 10             	add    $0x10,%esp
  801ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801ec8:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801ecc:	75 07                	jne    801ed5 <sget+0x27>
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed3:	eb 7f                	jmp    801f54 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801edb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ee2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee8:	39 d0                	cmp    %edx,%eax
  801eea:	73 02                	jae    801eee <sget+0x40>
  801eec:	89 d0                	mov    %edx,%eax
  801eee:	83 ec 0c             	sub    $0xc,%esp
  801ef1:	50                   	push   %eax
  801ef2:	e8 f4 fb ff ff       	call   801aeb <malloc>
  801ef7:	83 c4 10             	add    $0x10,%esp
  801efa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801efd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f01:	75 07                	jne    801f0a <sget+0x5c>
  801f03:	b8 00 00 00 00       	mov    $0x0,%eax
  801f08:	eb 4a                	jmp    801f54 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801f0a:	83 ec 04             	sub    $0x4,%esp
  801f0d:	ff 75 e8             	pushl  -0x18(%ebp)
  801f10:	ff 75 0c             	pushl  0xc(%ebp)
  801f13:	ff 75 08             	pushl  0x8(%ebp)
  801f16:	e8 2c 03 00 00       	call   802247 <sys_getSharedObject>
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801f21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801f24:	a1 24 50 80 00       	mov    0x805024,%eax
  801f29:	8b 40 78             	mov    0x78(%eax),%eax
  801f2c:	29 c2                	sub    %eax,%edx
  801f2e:	89 d0                	mov    %edx,%eax
  801f30:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f35:	c1 e8 0c             	shr    $0xc,%eax
  801f38:	89 c2                	mov    %eax,%edx
  801f3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f3d:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801f44:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801f48:	75 07                	jne    801f51 <sget+0xa3>
  801f4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4f:	eb 03                	jmp    801f54 <sget+0xa6>
	return ptr;
  801f51:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801f5c:	8b 55 08             	mov    0x8(%ebp),%edx
  801f5f:	a1 24 50 80 00       	mov    0x805024,%eax
  801f64:	8b 40 78             	mov    0x78(%eax),%eax
  801f67:	29 c2                	sub    %eax,%edx
  801f69:	89 d0                	mov    %edx,%eax
  801f6b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f70:	c1 e8 0c             	shr    $0xc,%eax
  801f73:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801f7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801f7d:	83 ec 08             	sub    $0x8,%esp
  801f80:	ff 75 08             	pushl  0x8(%ebp)
  801f83:	ff 75 f4             	pushl  -0xc(%ebp)
  801f86:	e8 db 02 00 00       	call   802266 <sys_freeSharedObject>
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801f91:	90                   	nop
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f9a:	83 ec 04             	sub    $0x4,%esp
  801f9d:	68 04 4b 80 00       	push   $0x804b04
  801fa2:	68 e4 00 00 00       	push   $0xe4
  801fa7:	68 f6 4a 80 00       	push   $0x804af6
  801fac:	e8 c5 e8 ff ff       	call   800876 <_panic>

00801fb1 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fb7:	83 ec 04             	sub    $0x4,%esp
  801fba:	68 2a 4b 80 00       	push   $0x804b2a
  801fbf:	68 f0 00 00 00       	push   $0xf0
  801fc4:	68 f6 4a 80 00       	push   $0x804af6
  801fc9:	e8 a8 e8 ff ff       	call   800876 <_panic>

00801fce <shrink>:

}
void shrink(uint32 newSize)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fd4:	83 ec 04             	sub    $0x4,%esp
  801fd7:	68 2a 4b 80 00       	push   $0x804b2a
  801fdc:	68 f5 00 00 00       	push   $0xf5
  801fe1:	68 f6 4a 80 00       	push   $0x804af6
  801fe6:	e8 8b e8 ff ff       	call   800876 <_panic>

00801feb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ff1:	83 ec 04             	sub    $0x4,%esp
  801ff4:	68 2a 4b 80 00       	push   $0x804b2a
  801ff9:	68 fa 00 00 00       	push   $0xfa
  801ffe:	68 f6 4a 80 00       	push   $0x804af6
  802003:	e8 6e e8 ff ff       	call   800876 <_panic>

00802008 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	57                   	push   %edi
  80200c:	56                   	push   %esi
  80200d:	53                   	push   %ebx
  80200e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	8b 55 0c             	mov    0xc(%ebp),%edx
  802017:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80201a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80201d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802020:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802023:	cd 30                	int    $0x30
  802025:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802028:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80202b:	83 c4 10             	add    $0x10,%esp
  80202e:	5b                   	pop    %ebx
  80202f:	5e                   	pop    %esi
  802030:	5f                   	pop    %edi
  802031:	5d                   	pop    %ebp
  802032:	c3                   	ret    

00802033 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 04             	sub    $0x4,%esp
  802039:	8b 45 10             	mov    0x10(%ebp),%eax
  80203c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80203f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	52                   	push   %edx
  80204b:	ff 75 0c             	pushl  0xc(%ebp)
  80204e:	50                   	push   %eax
  80204f:	6a 00                	push   $0x0
  802051:	e8 b2 ff ff ff       	call   802008 <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
}
  802059:	90                   	nop
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <sys_cgetc>:

int
sys_cgetc(void)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 02                	push   $0x2
  80206b:	e8 98 ff ff ff       	call   802008 <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 03                	push   $0x3
  802084:	e8 7f ff ff ff       	call   802008 <syscall>
  802089:	83 c4 18             	add    $0x18,%esp
}
  80208c:	90                   	nop
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 04                	push   $0x4
  80209e:	e8 65 ff ff ff       	call   802008 <syscall>
  8020a3:	83 c4 18             	add    $0x18,%esp
}
  8020a6:	90                   	nop
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	52                   	push   %edx
  8020b9:	50                   	push   %eax
  8020ba:	6a 08                	push   $0x8
  8020bc:	e8 47 ff ff ff       	call   802008 <syscall>
  8020c1:	83 c4 18             	add    $0x18,%esp
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	56                   	push   %esi
  8020ca:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020cb:	8b 75 18             	mov    0x18(%ebp),%esi
  8020ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	56                   	push   %esi
  8020db:	53                   	push   %ebx
  8020dc:	51                   	push   %ecx
  8020dd:	52                   	push   %edx
  8020de:	50                   	push   %eax
  8020df:	6a 09                	push   $0x9
  8020e1:	e8 22 ff ff ff       	call   802008 <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ec:	5b                   	pop    %ebx
  8020ed:	5e                   	pop    %esi
  8020ee:	5d                   	pop    %ebp
  8020ef:	c3                   	ret    

008020f0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	52                   	push   %edx
  802100:	50                   	push   %eax
  802101:	6a 0a                	push   $0xa
  802103:	e8 00 ff ff ff       	call   802008 <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	ff 75 0c             	pushl  0xc(%ebp)
  802119:	ff 75 08             	pushl  0x8(%ebp)
  80211c:	6a 0b                	push   $0xb
  80211e:	e8 e5 fe ff ff       	call   802008 <syscall>
  802123:	83 c4 18             	add    $0x18,%esp
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 0c                	push   $0xc
  802137:	e8 cc fe ff ff       	call   802008 <syscall>
  80213c:	83 c4 18             	add    $0x18,%esp
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 0d                	push   $0xd
  802150:	e8 b3 fe ff ff       	call   802008 <syscall>
  802155:	83 c4 18             	add    $0x18,%esp
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 0e                	push   $0xe
  802169:	e8 9a fe ff ff       	call   802008 <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 0f                	push   $0xf
  802182:	e8 81 fe ff ff       	call   802008 <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	ff 75 08             	pushl  0x8(%ebp)
  80219a:	6a 10                	push   $0x10
  80219c:	e8 67 fe ff ff       	call   802008 <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 11                	push   $0x11
  8021b5:	e8 4e fe ff ff       	call   802008 <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
}
  8021bd:	90                   	nop
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <sys_cputc>:

void
sys_cputc(const char c)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	83 ec 04             	sub    $0x4,%esp
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021cc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	50                   	push   %eax
  8021d9:	6a 01                	push   $0x1
  8021db:	e8 28 fe ff ff       	call   802008 <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
}
  8021e3:	90                   	nop
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 14                	push   $0x14
  8021f5:	e8 0e fe ff ff       	call   802008 <syscall>
  8021fa:	83 c4 18             	add    $0x18,%esp
}
  8021fd:	90                   	nop
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 04             	sub    $0x4,%esp
  802206:	8b 45 10             	mov    0x10(%ebp),%eax
  802209:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80220c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80220f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	6a 00                	push   $0x0
  802218:	51                   	push   %ecx
  802219:	52                   	push   %edx
  80221a:	ff 75 0c             	pushl  0xc(%ebp)
  80221d:	50                   	push   %eax
  80221e:	6a 15                	push   $0x15
  802220:	e8 e3 fd ff ff       	call   802008 <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80222d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	52                   	push   %edx
  80223a:	50                   	push   %eax
  80223b:	6a 16                	push   $0x16
  80223d:	e8 c6 fd ff ff       	call   802008 <syscall>
  802242:	83 c4 18             	add    $0x18,%esp
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80224a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80224d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	51                   	push   %ecx
  802258:	52                   	push   %edx
  802259:	50                   	push   %eax
  80225a:	6a 17                	push   $0x17
  80225c:	e8 a7 fd ff ff       	call   802008 <syscall>
  802261:	83 c4 18             	add    $0x18,%esp
}
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802269:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	52                   	push   %edx
  802276:	50                   	push   %eax
  802277:	6a 18                	push   $0x18
  802279:	e8 8a fd ff ff       	call   802008 <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	6a 00                	push   $0x0
  80228b:	ff 75 14             	pushl  0x14(%ebp)
  80228e:	ff 75 10             	pushl  0x10(%ebp)
  802291:	ff 75 0c             	pushl  0xc(%ebp)
  802294:	50                   	push   %eax
  802295:	6a 19                	push   $0x19
  802297:	e8 6c fd ff ff       	call   802008 <syscall>
  80229c:	83 c4 18             	add    $0x18,%esp
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	50                   	push   %eax
  8022b0:	6a 1a                	push   $0x1a
  8022b2:	e8 51 fd ff ff       	call   802008 <syscall>
  8022b7:	83 c4 18             	add    $0x18,%esp
}
  8022ba:	90                   	nop
  8022bb:	c9                   	leave  
  8022bc:	c3                   	ret    

008022bd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022bd:	55                   	push   %ebp
  8022be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	50                   	push   %eax
  8022cc:	6a 1b                	push   $0x1b
  8022ce:	e8 35 fd ff ff       	call   802008 <syscall>
  8022d3:	83 c4 18             	add    $0x18,%esp
}
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 05                	push   $0x5
  8022e7:	e8 1c fd ff ff       	call   802008 <syscall>
  8022ec:	83 c4 18             	add    $0x18,%esp
}
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    

008022f1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 06                	push   $0x6
  802300:	e8 03 fd ff ff       	call   802008 <syscall>
  802305:	83 c4 18             	add    $0x18,%esp
}
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 07                	push   $0x7
  802319:	e8 ea fc ff ff       	call   802008 <syscall>
  80231e:	83 c4 18             	add    $0x18,%esp
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <sys_exit_env>:


void sys_exit_env(void)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 1c                	push   $0x1c
  802332:	e8 d1 fc ff ff       	call   802008 <syscall>
  802337:	83 c4 18             	add    $0x18,%esp
}
  80233a:	90                   	nop
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
  802340:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802343:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802346:	8d 50 04             	lea    0x4(%eax),%edx
  802349:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	52                   	push   %edx
  802353:	50                   	push   %eax
  802354:	6a 1d                	push   $0x1d
  802356:	e8 ad fc ff ff       	call   802008 <syscall>
  80235b:	83 c4 18             	add    $0x18,%esp
	return result;
  80235e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802364:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802367:	89 01                	mov    %eax,(%ecx)
  802369:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	c9                   	leave  
  802370:	c2 04 00             	ret    $0x4

00802373 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	ff 75 10             	pushl  0x10(%ebp)
  80237d:	ff 75 0c             	pushl  0xc(%ebp)
  802380:	ff 75 08             	pushl  0x8(%ebp)
  802383:	6a 13                	push   $0x13
  802385:	e8 7e fc ff ff       	call   802008 <syscall>
  80238a:	83 c4 18             	add    $0x18,%esp
	return ;
  80238d:	90                   	nop
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <sys_rcr2>:
uint32 sys_rcr2()
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 1e                	push   $0x1e
  80239f:	e8 64 fc ff ff       	call   802008 <syscall>
  8023a4:	83 c4 18             	add    $0x18,%esp
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	83 ec 04             	sub    $0x4,%esp
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023b5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	50                   	push   %eax
  8023c2:	6a 1f                	push   $0x1f
  8023c4:	e8 3f fc ff ff       	call   802008 <syscall>
  8023c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8023cc:	90                   	nop
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <rsttst>:
void rsttst()
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 21                	push   $0x21
  8023de:	e8 25 fc ff ff       	call   802008 <syscall>
  8023e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e6:	90                   	nop
}
  8023e7:	c9                   	leave  
  8023e8:	c3                   	ret    

008023e9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
  8023ec:	83 ec 04             	sub    $0x4,%esp
  8023ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023f5:	8b 55 18             	mov    0x18(%ebp),%edx
  8023f8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023fc:	52                   	push   %edx
  8023fd:	50                   	push   %eax
  8023fe:	ff 75 10             	pushl  0x10(%ebp)
  802401:	ff 75 0c             	pushl  0xc(%ebp)
  802404:	ff 75 08             	pushl  0x8(%ebp)
  802407:	6a 20                	push   $0x20
  802409:	e8 fa fb ff ff       	call   802008 <syscall>
  80240e:	83 c4 18             	add    $0x18,%esp
	return ;
  802411:	90                   	nop
}
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <chktst>:
void chktst(uint32 n)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	ff 75 08             	pushl  0x8(%ebp)
  802422:	6a 22                	push   $0x22
  802424:	e8 df fb ff ff       	call   802008 <syscall>
  802429:	83 c4 18             	add    $0x18,%esp
	return ;
  80242c:	90                   	nop
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <inctst>:

void inctst()
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 23                	push   $0x23
  80243e:	e8 c5 fb ff ff       	call   802008 <syscall>
  802443:	83 c4 18             	add    $0x18,%esp
	return ;
  802446:	90                   	nop
}
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <gettst>:
uint32 gettst()
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 24                	push   $0x24
  802458:	e8 ab fb ff ff       	call   802008 <syscall>
  80245d:	83 c4 18             	add    $0x18,%esp
}
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
  802465:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 25                	push   $0x25
  802474:	e8 8f fb ff ff       	call   802008 <syscall>
  802479:	83 c4 18             	add    $0x18,%esp
  80247c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80247f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802483:	75 07                	jne    80248c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802485:	b8 01 00 00 00       	mov    $0x1,%eax
  80248a:	eb 05                	jmp    802491 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80248c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
  802496:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 25                	push   $0x25
  8024a5:	e8 5e fb ff ff       	call   802008 <syscall>
  8024aa:	83 c4 18             	add    $0x18,%esp
  8024ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024b0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024b4:	75 07                	jne    8024bd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024bb:	eb 05                	jmp    8024c2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 25                	push   $0x25
  8024d6:	e8 2d fb ff ff       	call   802008 <syscall>
  8024db:	83 c4 18             	add    $0x18,%esp
  8024de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024e1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024e5:	75 07                	jne    8024ee <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ec:	eb 05                	jmp    8024f3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f3:	c9                   	leave  
  8024f4:	c3                   	ret    

008024f5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
  8024f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 25                	push   $0x25
  802507:	e8 fc fa ff ff       	call   802008 <syscall>
  80250c:	83 c4 18             	add    $0x18,%esp
  80250f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802512:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802516:	75 07                	jne    80251f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802518:	b8 01 00 00 00       	mov    $0x1,%eax
  80251d:	eb 05                	jmp    802524 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80251f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	ff 75 08             	pushl  0x8(%ebp)
  802534:	6a 26                	push   $0x26
  802536:	e8 cd fa ff ff       	call   802008 <syscall>
  80253b:	83 c4 18             	add    $0x18,%esp
	return ;
  80253e:	90                   	nop
}
  80253f:	c9                   	leave  
  802540:	c3                   	ret    

00802541 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
  802544:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802545:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802548:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80254b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	6a 00                	push   $0x0
  802553:	53                   	push   %ebx
  802554:	51                   	push   %ecx
  802555:	52                   	push   %edx
  802556:	50                   	push   %eax
  802557:	6a 27                	push   $0x27
  802559:	e8 aa fa ff ff       	call   802008 <syscall>
  80255e:	83 c4 18             	add    $0x18,%esp
}
  802561:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802569:	8b 55 0c             	mov    0xc(%ebp),%edx
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	52                   	push   %edx
  802576:	50                   	push   %eax
  802577:	6a 28                	push   $0x28
  802579:	e8 8a fa ff ff       	call   802008 <syscall>
  80257e:	83 c4 18             	add    $0x18,%esp
}
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802586:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802589:	8b 55 0c             	mov    0xc(%ebp),%edx
  80258c:	8b 45 08             	mov    0x8(%ebp),%eax
  80258f:	6a 00                	push   $0x0
  802591:	51                   	push   %ecx
  802592:	ff 75 10             	pushl  0x10(%ebp)
  802595:	52                   	push   %edx
  802596:	50                   	push   %eax
  802597:	6a 29                	push   $0x29
  802599:	e8 6a fa ff ff       	call   802008 <syscall>
  80259e:	83 c4 18             	add    $0x18,%esp
}
  8025a1:	c9                   	leave  
  8025a2:	c3                   	ret    

008025a3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8025a3:	55                   	push   %ebp
  8025a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	ff 75 10             	pushl  0x10(%ebp)
  8025ad:	ff 75 0c             	pushl  0xc(%ebp)
  8025b0:	ff 75 08             	pushl  0x8(%ebp)
  8025b3:	6a 12                	push   $0x12
  8025b5:	e8 4e fa ff ff       	call   802008 <syscall>
  8025ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8025bd:	90                   	nop
}
  8025be:	c9                   	leave  
  8025bf:	c3                   	ret    

008025c0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8025c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	52                   	push   %edx
  8025d0:	50                   	push   %eax
  8025d1:	6a 2a                	push   $0x2a
  8025d3:	e8 30 fa ff ff       	call   802008 <syscall>
  8025d8:	83 c4 18             	add    $0x18,%esp
	return;
  8025db:	90                   	nop
}
  8025dc:	c9                   	leave  
  8025dd:	c3                   	ret    

008025de <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8025de:	55                   	push   %ebp
  8025df:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8025e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	50                   	push   %eax
  8025ed:	6a 2b                	push   $0x2b
  8025ef:	e8 14 fa ff ff       	call   802008 <syscall>
  8025f4:	83 c4 18             	add    $0x18,%esp
}
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	ff 75 0c             	pushl  0xc(%ebp)
  802605:	ff 75 08             	pushl  0x8(%ebp)
  802608:	6a 2c                	push   $0x2c
  80260a:	e8 f9 f9 ff ff       	call   802008 <syscall>
  80260f:	83 c4 18             	add    $0x18,%esp
	return;
  802612:	90                   	nop
}
  802613:	c9                   	leave  
  802614:	c3                   	ret    

00802615 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802615:	55                   	push   %ebp
  802616:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	ff 75 0c             	pushl  0xc(%ebp)
  802621:	ff 75 08             	pushl  0x8(%ebp)
  802624:	6a 2d                	push   $0x2d
  802626:	e8 dd f9 ff ff       	call   802008 <syscall>
  80262b:	83 c4 18             	add    $0x18,%esp
	return;
  80262e:	90                   	nop
}
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
  802634:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802637:	8b 45 08             	mov    0x8(%ebp),%eax
  80263a:	83 e8 04             	sub    $0x4,%eax
  80263d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802640:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802643:	8b 00                	mov    (%eax),%eax
  802645:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
  80264d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802650:	8b 45 08             	mov    0x8(%ebp),%eax
  802653:	83 e8 04             	sub    $0x4,%eax
  802656:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802659:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80265c:	8b 00                	mov    (%eax),%eax
  80265e:	83 e0 01             	and    $0x1,%eax
  802661:	85 c0                	test   %eax,%eax
  802663:	0f 94 c0             	sete   %al
}
  802666:	c9                   	leave  
  802667:	c3                   	ret    

00802668 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802668:	55                   	push   %ebp
  802669:	89 e5                	mov    %esp,%ebp
  80266b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80266e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802675:	8b 45 0c             	mov    0xc(%ebp),%eax
  802678:	83 f8 02             	cmp    $0x2,%eax
  80267b:	74 2b                	je     8026a8 <alloc_block+0x40>
  80267d:	83 f8 02             	cmp    $0x2,%eax
  802680:	7f 07                	jg     802689 <alloc_block+0x21>
  802682:	83 f8 01             	cmp    $0x1,%eax
  802685:	74 0e                	je     802695 <alloc_block+0x2d>
  802687:	eb 58                	jmp    8026e1 <alloc_block+0x79>
  802689:	83 f8 03             	cmp    $0x3,%eax
  80268c:	74 2d                	je     8026bb <alloc_block+0x53>
  80268e:	83 f8 04             	cmp    $0x4,%eax
  802691:	74 3b                	je     8026ce <alloc_block+0x66>
  802693:	eb 4c                	jmp    8026e1 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802695:	83 ec 0c             	sub    $0xc,%esp
  802698:	ff 75 08             	pushl  0x8(%ebp)
  80269b:	e8 11 03 00 00       	call   8029b1 <alloc_block_FF>
  8026a0:	83 c4 10             	add    $0x10,%esp
  8026a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026a6:	eb 4a                	jmp    8026f2 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8026a8:	83 ec 0c             	sub    $0xc,%esp
  8026ab:	ff 75 08             	pushl  0x8(%ebp)
  8026ae:	e8 c7 19 00 00       	call   80407a <alloc_block_NF>
  8026b3:	83 c4 10             	add    $0x10,%esp
  8026b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026b9:	eb 37                	jmp    8026f2 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8026bb:	83 ec 0c             	sub    $0xc,%esp
  8026be:	ff 75 08             	pushl  0x8(%ebp)
  8026c1:	e8 a7 07 00 00       	call   802e6d <alloc_block_BF>
  8026c6:	83 c4 10             	add    $0x10,%esp
  8026c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026cc:	eb 24                	jmp    8026f2 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8026ce:	83 ec 0c             	sub    $0xc,%esp
  8026d1:	ff 75 08             	pushl  0x8(%ebp)
  8026d4:	e8 84 19 00 00       	call   80405d <alloc_block_WF>
  8026d9:	83 c4 10             	add    $0x10,%esp
  8026dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8026df:	eb 11                	jmp    8026f2 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8026e1:	83 ec 0c             	sub    $0xc,%esp
  8026e4:	68 3c 4b 80 00       	push   $0x804b3c
  8026e9:	e8 45 e4 ff ff       	call   800b33 <cprintf>
  8026ee:	83 c4 10             	add    $0x10,%esp
		break;
  8026f1:	90                   	nop
	}
	return va;
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8026f5:	c9                   	leave  
  8026f6:	c3                   	ret    

008026f7 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
  8026fa:	53                   	push   %ebx
  8026fb:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8026fe:	83 ec 0c             	sub    $0xc,%esp
  802701:	68 5c 4b 80 00       	push   $0x804b5c
  802706:	e8 28 e4 ff ff       	call   800b33 <cprintf>
  80270b:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80270e:	83 ec 0c             	sub    $0xc,%esp
  802711:	68 87 4b 80 00       	push   $0x804b87
  802716:	e8 18 e4 ff ff       	call   800b33 <cprintf>
  80271b:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802724:	eb 37                	jmp    80275d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802726:	83 ec 0c             	sub    $0xc,%esp
  802729:	ff 75 f4             	pushl  -0xc(%ebp)
  80272c:	e8 19 ff ff ff       	call   80264a <is_free_block>
  802731:	83 c4 10             	add    $0x10,%esp
  802734:	0f be d8             	movsbl %al,%ebx
  802737:	83 ec 0c             	sub    $0xc,%esp
  80273a:	ff 75 f4             	pushl  -0xc(%ebp)
  80273d:	e8 ef fe ff ff       	call   802631 <get_block_size>
  802742:	83 c4 10             	add    $0x10,%esp
  802745:	83 ec 04             	sub    $0x4,%esp
  802748:	53                   	push   %ebx
  802749:	50                   	push   %eax
  80274a:	68 9f 4b 80 00       	push   $0x804b9f
  80274f:	e8 df e3 ff ff       	call   800b33 <cprintf>
  802754:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802757:	8b 45 10             	mov    0x10(%ebp),%eax
  80275a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802761:	74 07                	je     80276a <print_blocks_list+0x73>
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 00                	mov    (%eax),%eax
  802768:	eb 05                	jmp    80276f <print_blocks_list+0x78>
  80276a:	b8 00 00 00 00       	mov    $0x0,%eax
  80276f:	89 45 10             	mov    %eax,0x10(%ebp)
  802772:	8b 45 10             	mov    0x10(%ebp),%eax
  802775:	85 c0                	test   %eax,%eax
  802777:	75 ad                	jne    802726 <print_blocks_list+0x2f>
  802779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277d:	75 a7                	jne    802726 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80277f:	83 ec 0c             	sub    $0xc,%esp
  802782:	68 5c 4b 80 00       	push   $0x804b5c
  802787:	e8 a7 e3 ff ff       	call   800b33 <cprintf>
  80278c:	83 c4 10             	add    $0x10,%esp

}
  80278f:	90                   	nop
  802790:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802793:	c9                   	leave  
  802794:	c3                   	ret    

00802795 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802795:	55                   	push   %ebp
  802796:	89 e5                	mov    %esp,%ebp
  802798:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80279b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80279e:	83 e0 01             	and    $0x1,%eax
  8027a1:	85 c0                	test   %eax,%eax
  8027a3:	74 03                	je     8027a8 <initialize_dynamic_allocator+0x13>
  8027a5:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8027a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027ac:	0f 84 c7 01 00 00    	je     802979 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8027b2:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8027b9:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8027bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8027bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c2:	01 d0                	add    %edx,%eax
  8027c4:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8027c9:	0f 87 ad 01 00 00    	ja     80297c <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	85 c0                	test   %eax,%eax
  8027d4:	0f 89 a5 01 00 00    	jns    80297f <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8027da:	8b 55 08             	mov    0x8(%ebp),%edx
  8027dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027e0:	01 d0                	add    %edx,%eax
  8027e2:	83 e8 04             	sub    $0x4,%eax
  8027e5:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  8027ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8027f1:	a1 30 50 80 00       	mov    0x805030,%eax
  8027f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f9:	e9 87 00 00 00       	jmp    802885 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8027fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802802:	75 14                	jne    802818 <initialize_dynamic_allocator+0x83>
  802804:	83 ec 04             	sub    $0x4,%esp
  802807:	68 b7 4b 80 00       	push   $0x804bb7
  80280c:	6a 79                	push   $0x79
  80280e:	68 d5 4b 80 00       	push   $0x804bd5
  802813:	e8 5e e0 ff ff       	call   800876 <_panic>
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	85 c0                	test   %eax,%eax
  80281f:	74 10                	je     802831 <initialize_dynamic_allocator+0x9c>
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	8b 00                	mov    (%eax),%eax
  802826:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802829:	8b 52 04             	mov    0x4(%edx),%edx
  80282c:	89 50 04             	mov    %edx,0x4(%eax)
  80282f:	eb 0b                	jmp    80283c <initialize_dynamic_allocator+0xa7>
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	8b 40 04             	mov    0x4(%eax),%eax
  802837:	a3 34 50 80 00       	mov    %eax,0x805034
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 04             	mov    0x4(%eax),%eax
  802842:	85 c0                	test   %eax,%eax
  802844:	74 0f                	je     802855 <initialize_dynamic_allocator+0xc0>
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 40 04             	mov    0x4(%eax),%eax
  80284c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284f:	8b 12                	mov    (%edx),%edx
  802851:	89 10                	mov    %edx,(%eax)
  802853:	eb 0a                	jmp    80285f <initialize_dynamic_allocator+0xca>
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	8b 00                	mov    (%eax),%eax
  80285a:	a3 30 50 80 00       	mov    %eax,0x805030
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802872:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802877:	48                   	dec    %eax
  802878:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80287d:	a1 38 50 80 00       	mov    0x805038,%eax
  802882:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802889:	74 07                	je     802892 <initialize_dynamic_allocator+0xfd>
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 00                	mov    (%eax),%eax
  802890:	eb 05                	jmp    802897 <initialize_dynamic_allocator+0x102>
  802892:	b8 00 00 00 00       	mov    $0x0,%eax
  802897:	a3 38 50 80 00       	mov    %eax,0x805038
  80289c:	a1 38 50 80 00       	mov    0x805038,%eax
  8028a1:	85 c0                	test   %eax,%eax
  8028a3:	0f 85 55 ff ff ff    	jne    8027fe <initialize_dynamic_allocator+0x69>
  8028a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ad:	0f 85 4b ff ff ff    	jne    8027fe <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8028b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8028c2:	a1 48 50 80 00       	mov    0x805048,%eax
  8028c7:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  8028cc:	a1 44 50 80 00       	mov    0x805044,%eax
  8028d1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8028d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028da:	83 c0 08             	add    $0x8,%eax
  8028dd:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	83 c0 04             	add    $0x4,%eax
  8028e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e9:	83 ea 08             	sub    $0x8,%edx
  8028ec:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8028ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	01 d0                	add    %edx,%eax
  8028f6:	83 e8 08             	sub    $0x8,%eax
  8028f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028fc:	83 ea 08             	sub    $0x8,%edx
  8028ff:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802901:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802904:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80290a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802914:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802918:	75 17                	jne    802931 <initialize_dynamic_allocator+0x19c>
  80291a:	83 ec 04             	sub    $0x4,%esp
  80291d:	68 f0 4b 80 00       	push   $0x804bf0
  802922:	68 90 00 00 00       	push   $0x90
  802927:	68 d5 4b 80 00       	push   $0x804bd5
  80292c:	e8 45 df ff ff       	call   800876 <_panic>
  802931:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802937:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293a:	89 10                	mov    %edx,(%eax)
  80293c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293f:	8b 00                	mov    (%eax),%eax
  802941:	85 c0                	test   %eax,%eax
  802943:	74 0d                	je     802952 <initialize_dynamic_allocator+0x1bd>
  802945:	a1 30 50 80 00       	mov    0x805030,%eax
  80294a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80294d:	89 50 04             	mov    %edx,0x4(%eax)
  802950:	eb 08                	jmp    80295a <initialize_dynamic_allocator+0x1c5>
  802952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802955:	a3 34 50 80 00       	mov    %eax,0x805034
  80295a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295d:	a3 30 50 80 00       	mov    %eax,0x805030
  802962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802965:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802971:	40                   	inc    %eax
  802972:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802977:	eb 07                	jmp    802980 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802979:	90                   	nop
  80297a:	eb 04                	jmp    802980 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80297c:	90                   	nop
  80297d:	eb 01                	jmp    802980 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80297f:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802980:	c9                   	leave  
  802981:	c3                   	ret    

00802982 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802982:	55                   	push   %ebp
  802983:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802985:	8b 45 10             	mov    0x10(%ebp),%eax
  802988:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802991:	8b 45 0c             	mov    0xc(%ebp),%eax
  802994:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802996:	8b 45 08             	mov    0x8(%ebp),%eax
  802999:	83 e8 04             	sub    $0x4,%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	83 e0 fe             	and    $0xfffffffe,%eax
  8029a1:	8d 50 f8             	lea    -0x8(%eax),%edx
  8029a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a7:	01 c2                	add    %eax,%edx
  8029a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ac:	89 02                	mov    %eax,(%edx)
}
  8029ae:	90                   	nop
  8029af:	5d                   	pop    %ebp
  8029b0:	c3                   	ret    

008029b1 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8029b1:	55                   	push   %ebp
  8029b2:	89 e5                	mov    %esp,%ebp
  8029b4:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	83 e0 01             	and    $0x1,%eax
  8029bd:	85 c0                	test   %eax,%eax
  8029bf:	74 03                	je     8029c4 <alloc_block_FF+0x13>
  8029c1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8029c4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8029c8:	77 07                	ja     8029d1 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8029ca:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8029d1:	a1 28 50 80 00       	mov    0x805028,%eax
  8029d6:	85 c0                	test   %eax,%eax
  8029d8:	75 73                	jne    802a4d <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	83 c0 10             	add    $0x10,%eax
  8029e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8029e3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8029ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f0:	01 d0                	add    %edx,%eax
  8029f2:	48                   	dec    %eax
  8029f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8029f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8029fe:	f7 75 ec             	divl   -0x14(%ebp)
  802a01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a04:	29 d0                	sub    %edx,%eax
  802a06:	c1 e8 0c             	shr    $0xc,%eax
  802a09:	83 ec 0c             	sub    $0xc,%esp
  802a0c:	50                   	push   %eax
  802a0d:	e8 c3 f0 ff ff       	call   801ad5 <sbrk>
  802a12:	83 c4 10             	add    $0x10,%esp
  802a15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a18:	83 ec 0c             	sub    $0xc,%esp
  802a1b:	6a 00                	push   $0x0
  802a1d:	e8 b3 f0 ff ff       	call   801ad5 <sbrk>
  802a22:	83 c4 10             	add    $0x10,%esp
  802a25:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a2b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802a2e:	83 ec 08             	sub    $0x8,%esp
  802a31:	50                   	push   %eax
  802a32:	ff 75 e4             	pushl  -0x1c(%ebp)
  802a35:	e8 5b fd ff ff       	call   802795 <initialize_dynamic_allocator>
  802a3a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802a3d:	83 ec 0c             	sub    $0xc,%esp
  802a40:	68 13 4c 80 00       	push   $0x804c13
  802a45:	e8 e9 e0 ff ff       	call   800b33 <cprintf>
  802a4a:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802a4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a51:	75 0a                	jne    802a5d <alloc_block_FF+0xac>
	        return NULL;
  802a53:	b8 00 00 00 00       	mov    $0x0,%eax
  802a58:	e9 0e 04 00 00       	jmp    802e6b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802a5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802a64:	a1 30 50 80 00       	mov    0x805030,%eax
  802a69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a6c:	e9 f3 02 00 00       	jmp    802d64 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802a77:	83 ec 0c             	sub    $0xc,%esp
  802a7a:	ff 75 bc             	pushl  -0x44(%ebp)
  802a7d:	e8 af fb ff ff       	call   802631 <get_block_size>
  802a82:	83 c4 10             	add    $0x10,%esp
  802a85:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	83 c0 08             	add    $0x8,%eax
  802a8e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802a91:	0f 87 c5 02 00 00    	ja     802d5c <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	83 c0 18             	add    $0x18,%eax
  802a9d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802aa0:	0f 87 19 02 00 00    	ja     802cbf <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802aa6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802aa9:	2b 45 08             	sub    0x8(%ebp),%eax
  802aac:	83 e8 08             	sub    $0x8,%eax
  802aaf:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	8d 50 08             	lea    0x8(%eax),%edx
  802ab8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802abb:	01 d0                	add    %edx,%eax
  802abd:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac3:	83 c0 08             	add    $0x8,%eax
  802ac6:	83 ec 04             	sub    $0x4,%esp
  802ac9:	6a 01                	push   $0x1
  802acb:	50                   	push   %eax
  802acc:	ff 75 bc             	pushl  -0x44(%ebp)
  802acf:	e8 ae fe ff ff       	call   802982 <set_block_data>
  802ad4:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 40 04             	mov    0x4(%eax),%eax
  802add:	85 c0                	test   %eax,%eax
  802adf:	75 68                	jne    802b49 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ae1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802ae5:	75 17                	jne    802afe <alloc_block_FF+0x14d>
  802ae7:	83 ec 04             	sub    $0x4,%esp
  802aea:	68 f0 4b 80 00       	push   $0x804bf0
  802aef:	68 d7 00 00 00       	push   $0xd7
  802af4:	68 d5 4b 80 00       	push   $0x804bd5
  802af9:	e8 78 dd ff ff       	call   800876 <_panic>
  802afe:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802b04:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b07:	89 10                	mov    %edx,(%eax)
  802b09:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b0c:	8b 00                	mov    (%eax),%eax
  802b0e:	85 c0                	test   %eax,%eax
  802b10:	74 0d                	je     802b1f <alloc_block_FF+0x16e>
  802b12:	a1 30 50 80 00       	mov    0x805030,%eax
  802b17:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b1a:	89 50 04             	mov    %edx,0x4(%eax)
  802b1d:	eb 08                	jmp    802b27 <alloc_block_FF+0x176>
  802b1f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b22:	a3 34 50 80 00       	mov    %eax,0x805034
  802b27:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b2a:	a3 30 50 80 00       	mov    %eax,0x805030
  802b2f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b39:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b3e:	40                   	inc    %eax
  802b3f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b44:	e9 dc 00 00 00       	jmp    802c25 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	85 c0                	test   %eax,%eax
  802b50:	75 65                	jne    802bb7 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b52:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802b56:	75 17                	jne    802b6f <alloc_block_FF+0x1be>
  802b58:	83 ec 04             	sub    $0x4,%esp
  802b5b:	68 24 4c 80 00       	push   $0x804c24
  802b60:	68 db 00 00 00       	push   $0xdb
  802b65:	68 d5 4b 80 00       	push   $0x804bd5
  802b6a:	e8 07 dd ff ff       	call   800876 <_panic>
  802b6f:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802b75:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b78:	89 50 04             	mov    %edx,0x4(%eax)
  802b7b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b7e:	8b 40 04             	mov    0x4(%eax),%eax
  802b81:	85 c0                	test   %eax,%eax
  802b83:	74 0c                	je     802b91 <alloc_block_FF+0x1e0>
  802b85:	a1 34 50 80 00       	mov    0x805034,%eax
  802b8a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b8d:	89 10                	mov    %edx,(%eax)
  802b8f:	eb 08                	jmp    802b99 <alloc_block_FF+0x1e8>
  802b91:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b94:	a3 30 50 80 00       	mov    %eax,0x805030
  802b99:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b9c:	a3 34 50 80 00       	mov    %eax,0x805034
  802ba1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802baa:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802baf:	40                   	inc    %eax
  802bb0:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802bb5:	eb 6e                	jmp    802c25 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802bb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbb:	74 06                	je     802bc3 <alloc_block_FF+0x212>
  802bbd:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802bc1:	75 17                	jne    802bda <alloc_block_FF+0x229>
  802bc3:	83 ec 04             	sub    $0x4,%esp
  802bc6:	68 48 4c 80 00       	push   $0x804c48
  802bcb:	68 df 00 00 00       	push   $0xdf
  802bd0:	68 d5 4b 80 00       	push   $0x804bd5
  802bd5:	e8 9c dc ff ff       	call   800876 <_panic>
  802bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdd:	8b 10                	mov    (%eax),%edx
  802bdf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802be2:	89 10                	mov    %edx,(%eax)
  802be4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802be7:	8b 00                	mov    (%eax),%eax
  802be9:	85 c0                	test   %eax,%eax
  802beb:	74 0b                	je     802bf8 <alloc_block_FF+0x247>
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 00                	mov    (%eax),%eax
  802bf2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bf5:	89 50 04             	mov    %edx,0x4(%eax)
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802bfe:	89 10                	mov    %edx,(%eax)
  802c00:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c06:	89 50 04             	mov    %edx,0x4(%eax)
  802c09:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	75 08                	jne    802c1a <alloc_block_FF+0x269>
  802c12:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c15:	a3 34 50 80 00       	mov    %eax,0x805034
  802c1a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c1f:	40                   	inc    %eax
  802c20:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802c25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c29:	75 17                	jne    802c42 <alloc_block_FF+0x291>
  802c2b:	83 ec 04             	sub    $0x4,%esp
  802c2e:	68 b7 4b 80 00       	push   $0x804bb7
  802c33:	68 e1 00 00 00       	push   $0xe1
  802c38:	68 d5 4b 80 00       	push   $0x804bd5
  802c3d:	e8 34 dc ff ff       	call   800876 <_panic>
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	8b 00                	mov    (%eax),%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	74 10                	je     802c5b <alloc_block_FF+0x2aa>
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c53:	8b 52 04             	mov    0x4(%edx),%edx
  802c56:	89 50 04             	mov    %edx,0x4(%eax)
  802c59:	eb 0b                	jmp    802c66 <alloc_block_FF+0x2b5>
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	8b 40 04             	mov    0x4(%eax),%eax
  802c61:	a3 34 50 80 00       	mov    %eax,0x805034
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 40 04             	mov    0x4(%eax),%eax
  802c6c:	85 c0                	test   %eax,%eax
  802c6e:	74 0f                	je     802c7f <alloc_block_FF+0x2ce>
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 40 04             	mov    0x4(%eax),%eax
  802c76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c79:	8b 12                	mov    (%edx),%edx
  802c7b:	89 10                	mov    %edx,(%eax)
  802c7d:	eb 0a                	jmp    802c89 <alloc_block_FF+0x2d8>
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	8b 00                	mov    (%eax),%eax
  802c84:	a3 30 50 80 00       	mov    %eax,0x805030
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ca1:	48                   	dec    %eax
  802ca2:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802ca7:	83 ec 04             	sub    $0x4,%esp
  802caa:	6a 00                	push   $0x0
  802cac:	ff 75 b4             	pushl  -0x4c(%ebp)
  802caf:	ff 75 b0             	pushl  -0x50(%ebp)
  802cb2:	e8 cb fc ff ff       	call   802982 <set_block_data>
  802cb7:	83 c4 10             	add    $0x10,%esp
  802cba:	e9 95 00 00 00       	jmp    802d54 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802cbf:	83 ec 04             	sub    $0x4,%esp
  802cc2:	6a 01                	push   $0x1
  802cc4:	ff 75 b8             	pushl  -0x48(%ebp)
  802cc7:	ff 75 bc             	pushl  -0x44(%ebp)
  802cca:	e8 b3 fc ff ff       	call   802982 <set_block_data>
  802ccf:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802cd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd6:	75 17                	jne    802cef <alloc_block_FF+0x33e>
  802cd8:	83 ec 04             	sub    $0x4,%esp
  802cdb:	68 b7 4b 80 00       	push   $0x804bb7
  802ce0:	68 e8 00 00 00       	push   $0xe8
  802ce5:	68 d5 4b 80 00       	push   $0x804bd5
  802cea:	e8 87 db ff ff       	call   800876 <_panic>
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 00                	mov    (%eax),%eax
  802cf4:	85 c0                	test   %eax,%eax
  802cf6:	74 10                	je     802d08 <alloc_block_FF+0x357>
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 00                	mov    (%eax),%eax
  802cfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d00:	8b 52 04             	mov    0x4(%edx),%edx
  802d03:	89 50 04             	mov    %edx,0x4(%eax)
  802d06:	eb 0b                	jmp    802d13 <alloc_block_FF+0x362>
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	8b 40 04             	mov    0x4(%eax),%eax
  802d0e:	a3 34 50 80 00       	mov    %eax,0x805034
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	8b 40 04             	mov    0x4(%eax),%eax
  802d19:	85 c0                	test   %eax,%eax
  802d1b:	74 0f                	je     802d2c <alloc_block_FF+0x37b>
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	8b 40 04             	mov    0x4(%eax),%eax
  802d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d26:	8b 12                	mov    (%edx),%edx
  802d28:	89 10                	mov    %edx,(%eax)
  802d2a:	eb 0a                	jmp    802d36 <alloc_block_FF+0x385>
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	a3 30 50 80 00       	mov    %eax,0x805030
  802d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d49:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d4e:	48                   	dec    %eax
  802d4f:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802d54:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d57:	e9 0f 01 00 00       	jmp    802e6b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802d5c:	a1 38 50 80 00       	mov    0x805038,%eax
  802d61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d68:	74 07                	je     802d71 <alloc_block_FF+0x3c0>
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	eb 05                	jmp    802d76 <alloc_block_FF+0x3c5>
  802d71:	b8 00 00 00 00       	mov    $0x0,%eax
  802d76:	a3 38 50 80 00       	mov    %eax,0x805038
  802d7b:	a1 38 50 80 00       	mov    0x805038,%eax
  802d80:	85 c0                	test   %eax,%eax
  802d82:	0f 85 e9 fc ff ff    	jne    802a71 <alloc_block_FF+0xc0>
  802d88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8c:	0f 85 df fc ff ff    	jne    802a71 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	83 c0 08             	add    $0x8,%eax
  802d98:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802d9b:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802da2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802da5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802da8:	01 d0                	add    %edx,%eax
  802daa:	48                   	dec    %eax
  802dab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802dae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802db1:	ba 00 00 00 00       	mov    $0x0,%edx
  802db6:	f7 75 d8             	divl   -0x28(%ebp)
  802db9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dbc:	29 d0                	sub    %edx,%eax
  802dbe:	c1 e8 0c             	shr    $0xc,%eax
  802dc1:	83 ec 0c             	sub    $0xc,%esp
  802dc4:	50                   	push   %eax
  802dc5:	e8 0b ed ff ff       	call   801ad5 <sbrk>
  802dca:	83 c4 10             	add    $0x10,%esp
  802dcd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802dd0:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802dd4:	75 0a                	jne    802de0 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ddb:	e9 8b 00 00 00       	jmp    802e6b <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802de0:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802de7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ded:	01 d0                	add    %edx,%eax
  802def:	48                   	dec    %eax
  802df0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802df3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802df6:	ba 00 00 00 00       	mov    $0x0,%edx
  802dfb:	f7 75 cc             	divl   -0x34(%ebp)
  802dfe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802e01:	29 d0                	sub    %edx,%eax
  802e03:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e09:	01 d0                	add    %edx,%eax
  802e0b:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802e10:	a1 44 50 80 00       	mov    0x805044,%eax
  802e15:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e1b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802e22:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e25:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802e28:	01 d0                	add    %edx,%eax
  802e2a:	48                   	dec    %eax
  802e2b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e2e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e31:	ba 00 00 00 00       	mov    $0x0,%edx
  802e36:	f7 75 c4             	divl   -0x3c(%ebp)
  802e39:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e3c:	29 d0                	sub    %edx,%eax
  802e3e:	83 ec 04             	sub    $0x4,%esp
  802e41:	6a 01                	push   $0x1
  802e43:	50                   	push   %eax
  802e44:	ff 75 d0             	pushl  -0x30(%ebp)
  802e47:	e8 36 fb ff ff       	call   802982 <set_block_data>
  802e4c:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802e4f:	83 ec 0c             	sub    $0xc,%esp
  802e52:	ff 75 d0             	pushl  -0x30(%ebp)
  802e55:	e8 f8 09 00 00       	call   803852 <free_block>
  802e5a:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802e5d:	83 ec 0c             	sub    $0xc,%esp
  802e60:	ff 75 08             	pushl  0x8(%ebp)
  802e63:	e8 49 fb ff ff       	call   8029b1 <alloc_block_FF>
  802e68:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802e6b:	c9                   	leave  
  802e6c:	c3                   	ret    

00802e6d <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e6d:	55                   	push   %ebp
  802e6e:	89 e5                	mov    %esp,%ebp
  802e70:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	83 e0 01             	and    $0x1,%eax
  802e79:	85 c0                	test   %eax,%eax
  802e7b:	74 03                	je     802e80 <alloc_block_BF+0x13>
  802e7d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802e80:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802e84:	77 07                	ja     802e8d <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802e86:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802e8d:	a1 28 50 80 00       	mov    0x805028,%eax
  802e92:	85 c0                	test   %eax,%eax
  802e94:	75 73                	jne    802f09 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	83 c0 10             	add    $0x10,%eax
  802e9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802e9f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802ea6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ea9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eac:	01 d0                	add    %edx,%eax
  802eae:	48                   	dec    %eax
  802eaf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802eb2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eb5:	ba 00 00 00 00       	mov    $0x0,%edx
  802eba:	f7 75 e0             	divl   -0x20(%ebp)
  802ebd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ec0:	29 d0                	sub    %edx,%eax
  802ec2:	c1 e8 0c             	shr    $0xc,%eax
  802ec5:	83 ec 0c             	sub    $0xc,%esp
  802ec8:	50                   	push   %eax
  802ec9:	e8 07 ec ff ff       	call   801ad5 <sbrk>
  802ece:	83 c4 10             	add    $0x10,%esp
  802ed1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802ed4:	83 ec 0c             	sub    $0xc,%esp
  802ed7:	6a 00                	push   $0x0
  802ed9:	e8 f7 eb ff ff       	call   801ad5 <sbrk>
  802ede:	83 c4 10             	add    $0x10,%esp
  802ee1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802ee4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ee7:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802eea:	83 ec 08             	sub    $0x8,%esp
  802eed:	50                   	push   %eax
  802eee:	ff 75 d8             	pushl  -0x28(%ebp)
  802ef1:	e8 9f f8 ff ff       	call   802795 <initialize_dynamic_allocator>
  802ef6:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802ef9:	83 ec 0c             	sub    $0xc,%esp
  802efc:	68 13 4c 80 00       	push   $0x804c13
  802f01:	e8 2d dc ff ff       	call   800b33 <cprintf>
  802f06:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802f09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802f10:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802f17:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802f1e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802f25:	a1 30 50 80 00       	mov    0x805030,%eax
  802f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2d:	e9 1d 01 00 00       	jmp    80304f <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802f38:	83 ec 0c             	sub    $0xc,%esp
  802f3b:	ff 75 a8             	pushl  -0x58(%ebp)
  802f3e:	e8 ee f6 ff ff       	call   802631 <get_block_size>
  802f43:	83 c4 10             	add    $0x10,%esp
  802f46:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	83 c0 08             	add    $0x8,%eax
  802f4f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f52:	0f 87 ef 00 00 00    	ja     803047 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	83 c0 18             	add    $0x18,%eax
  802f5e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f61:	77 1d                	ja     802f80 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802f63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f66:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f69:	0f 86 d8 00 00 00    	jbe    803047 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802f6f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f72:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802f75:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802f7b:	e9 c7 00 00 00       	jmp    803047 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	83 c0 08             	add    $0x8,%eax
  802f86:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f89:	0f 85 9d 00 00 00    	jne    80302c <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802f8f:	83 ec 04             	sub    $0x4,%esp
  802f92:	6a 01                	push   $0x1
  802f94:	ff 75 a4             	pushl  -0x5c(%ebp)
  802f97:	ff 75 a8             	pushl  -0x58(%ebp)
  802f9a:	e8 e3 f9 ff ff       	call   802982 <set_block_data>
  802f9f:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802fa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa6:	75 17                	jne    802fbf <alloc_block_BF+0x152>
  802fa8:	83 ec 04             	sub    $0x4,%esp
  802fab:	68 b7 4b 80 00       	push   $0x804bb7
  802fb0:	68 2c 01 00 00       	push   $0x12c
  802fb5:	68 d5 4b 80 00       	push   $0x804bd5
  802fba:	e8 b7 d8 ff ff       	call   800876 <_panic>
  802fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc2:	8b 00                	mov    (%eax),%eax
  802fc4:	85 c0                	test   %eax,%eax
  802fc6:	74 10                	je     802fd8 <alloc_block_BF+0x16b>
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 00                	mov    (%eax),%eax
  802fcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fd0:	8b 52 04             	mov    0x4(%edx),%edx
  802fd3:	89 50 04             	mov    %edx,0x4(%eax)
  802fd6:	eb 0b                	jmp    802fe3 <alloc_block_BF+0x176>
  802fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdb:	8b 40 04             	mov    0x4(%eax),%eax
  802fde:	a3 34 50 80 00       	mov    %eax,0x805034
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 40 04             	mov    0x4(%eax),%eax
  802fe9:	85 c0                	test   %eax,%eax
  802feb:	74 0f                	je     802ffc <alloc_block_BF+0x18f>
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	8b 40 04             	mov    0x4(%eax),%eax
  802ff3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff6:	8b 12                	mov    (%edx),%edx
  802ff8:	89 10                	mov    %edx,(%eax)
  802ffa:	eb 0a                	jmp    803006 <alloc_block_BF+0x199>
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	a3 30 50 80 00       	mov    %eax,0x805030
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803019:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80301e:	48                   	dec    %eax
  80301f:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  803024:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803027:	e9 01 04 00 00       	jmp    80342d <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  80302c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803032:	76 13                	jbe    803047 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803034:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80303b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80303e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803041:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803044:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803047:	a1 38 50 80 00       	mov    0x805038,%eax
  80304c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803053:	74 07                	je     80305c <alloc_block_BF+0x1ef>
  803055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803058:	8b 00                	mov    (%eax),%eax
  80305a:	eb 05                	jmp    803061 <alloc_block_BF+0x1f4>
  80305c:	b8 00 00 00 00       	mov    $0x0,%eax
  803061:	a3 38 50 80 00       	mov    %eax,0x805038
  803066:	a1 38 50 80 00       	mov    0x805038,%eax
  80306b:	85 c0                	test   %eax,%eax
  80306d:	0f 85 bf fe ff ff    	jne    802f32 <alloc_block_BF+0xc5>
  803073:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803077:	0f 85 b5 fe ff ff    	jne    802f32 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80307d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803081:	0f 84 26 02 00 00    	je     8032ad <alloc_block_BF+0x440>
  803087:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80308b:	0f 85 1c 02 00 00    	jne    8032ad <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803091:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803094:	2b 45 08             	sub    0x8(%ebp),%eax
  803097:	83 e8 08             	sub    $0x8,%eax
  80309a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	8d 50 08             	lea    0x8(%eax),%edx
  8030a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a6:	01 d0                	add    %edx,%eax
  8030a8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	83 c0 08             	add    $0x8,%eax
  8030b1:	83 ec 04             	sub    $0x4,%esp
  8030b4:	6a 01                	push   $0x1
  8030b6:	50                   	push   %eax
  8030b7:	ff 75 f0             	pushl  -0x10(%ebp)
  8030ba:	e8 c3 f8 ff ff       	call   802982 <set_block_data>
  8030bf:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8030c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c5:	8b 40 04             	mov    0x4(%eax),%eax
  8030c8:	85 c0                	test   %eax,%eax
  8030ca:	75 68                	jne    803134 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8030cc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030d0:	75 17                	jne    8030e9 <alloc_block_BF+0x27c>
  8030d2:	83 ec 04             	sub    $0x4,%esp
  8030d5:	68 f0 4b 80 00       	push   $0x804bf0
  8030da:	68 45 01 00 00       	push   $0x145
  8030df:	68 d5 4b 80 00       	push   $0x804bd5
  8030e4:	e8 8d d7 ff ff       	call   800876 <_panic>
  8030e9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f2:	89 10                	mov    %edx,(%eax)
  8030f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	85 c0                	test   %eax,%eax
  8030fb:	74 0d                	je     80310a <alloc_block_BF+0x29d>
  8030fd:	a1 30 50 80 00       	mov    0x805030,%eax
  803102:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803105:	89 50 04             	mov    %edx,0x4(%eax)
  803108:	eb 08                	jmp    803112 <alloc_block_BF+0x2a5>
  80310a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80310d:	a3 34 50 80 00       	mov    %eax,0x805034
  803112:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803115:	a3 30 50 80 00       	mov    %eax,0x805030
  80311a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80311d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803124:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803129:	40                   	inc    %eax
  80312a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80312f:	e9 dc 00 00 00       	jmp    803210 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803134:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803137:	8b 00                	mov    (%eax),%eax
  803139:	85 c0                	test   %eax,%eax
  80313b:	75 65                	jne    8031a2 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80313d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803141:	75 17                	jne    80315a <alloc_block_BF+0x2ed>
  803143:	83 ec 04             	sub    $0x4,%esp
  803146:	68 24 4c 80 00       	push   $0x804c24
  80314b:	68 4a 01 00 00       	push   $0x14a
  803150:	68 d5 4b 80 00       	push   $0x804bd5
  803155:	e8 1c d7 ff ff       	call   800876 <_panic>
  80315a:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803160:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803163:	89 50 04             	mov    %edx,0x4(%eax)
  803166:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803169:	8b 40 04             	mov    0x4(%eax),%eax
  80316c:	85 c0                	test   %eax,%eax
  80316e:	74 0c                	je     80317c <alloc_block_BF+0x30f>
  803170:	a1 34 50 80 00       	mov    0x805034,%eax
  803175:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803178:	89 10                	mov    %edx,(%eax)
  80317a:	eb 08                	jmp    803184 <alloc_block_BF+0x317>
  80317c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80317f:	a3 30 50 80 00       	mov    %eax,0x805030
  803184:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803187:	a3 34 50 80 00       	mov    %eax,0x805034
  80318c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80318f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803195:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80319a:	40                   	inc    %eax
  80319b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8031a0:	eb 6e                	jmp    803210 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8031a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031a6:	74 06                	je     8031ae <alloc_block_BF+0x341>
  8031a8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8031ac:	75 17                	jne    8031c5 <alloc_block_BF+0x358>
  8031ae:	83 ec 04             	sub    $0x4,%esp
  8031b1:	68 48 4c 80 00       	push   $0x804c48
  8031b6:	68 4f 01 00 00       	push   $0x14f
  8031bb:	68 d5 4b 80 00       	push   $0x804bd5
  8031c0:	e8 b1 d6 ff ff       	call   800876 <_panic>
  8031c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c8:	8b 10                	mov    (%eax),%edx
  8031ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031cd:	89 10                	mov    %edx,(%eax)
  8031cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031d2:	8b 00                	mov    (%eax),%eax
  8031d4:	85 c0                	test   %eax,%eax
  8031d6:	74 0b                	je     8031e3 <alloc_block_BF+0x376>
  8031d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031db:	8b 00                	mov    (%eax),%eax
  8031dd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031e0:	89 50 04             	mov    %edx,0x4(%eax)
  8031e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8031e9:	89 10                	mov    %edx,(%eax)
  8031eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031f1:	89 50 04             	mov    %edx,0x4(%eax)
  8031f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8031f7:	8b 00                	mov    (%eax),%eax
  8031f9:	85 c0                	test   %eax,%eax
  8031fb:	75 08                	jne    803205 <alloc_block_BF+0x398>
  8031fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803200:	a3 34 50 80 00       	mov    %eax,0x805034
  803205:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80320a:	40                   	inc    %eax
  80320b:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803210:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803214:	75 17                	jne    80322d <alloc_block_BF+0x3c0>
  803216:	83 ec 04             	sub    $0x4,%esp
  803219:	68 b7 4b 80 00       	push   $0x804bb7
  80321e:	68 51 01 00 00       	push   $0x151
  803223:	68 d5 4b 80 00       	push   $0x804bd5
  803228:	e8 49 d6 ff ff       	call   800876 <_panic>
  80322d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803230:	8b 00                	mov    (%eax),%eax
  803232:	85 c0                	test   %eax,%eax
  803234:	74 10                	je     803246 <alloc_block_BF+0x3d9>
  803236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803239:	8b 00                	mov    (%eax),%eax
  80323b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80323e:	8b 52 04             	mov    0x4(%edx),%edx
  803241:	89 50 04             	mov    %edx,0x4(%eax)
  803244:	eb 0b                	jmp    803251 <alloc_block_BF+0x3e4>
  803246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803249:	8b 40 04             	mov    0x4(%eax),%eax
  80324c:	a3 34 50 80 00       	mov    %eax,0x805034
  803251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803254:	8b 40 04             	mov    0x4(%eax),%eax
  803257:	85 c0                	test   %eax,%eax
  803259:	74 0f                	je     80326a <alloc_block_BF+0x3fd>
  80325b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325e:	8b 40 04             	mov    0x4(%eax),%eax
  803261:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803264:	8b 12                	mov    (%edx),%edx
  803266:	89 10                	mov    %edx,(%eax)
  803268:	eb 0a                	jmp    803274 <alloc_block_BF+0x407>
  80326a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326d:	8b 00                	mov    (%eax),%eax
  80326f:	a3 30 50 80 00       	mov    %eax,0x805030
  803274:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803277:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803280:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803287:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80328c:	48                   	dec    %eax
  80328d:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  803292:	83 ec 04             	sub    $0x4,%esp
  803295:	6a 00                	push   $0x0
  803297:	ff 75 d0             	pushl  -0x30(%ebp)
  80329a:	ff 75 cc             	pushl  -0x34(%ebp)
  80329d:	e8 e0 f6 ff ff       	call   802982 <set_block_data>
  8032a2:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8032a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a8:	e9 80 01 00 00       	jmp    80342d <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  8032ad:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8032b1:	0f 85 9d 00 00 00    	jne    803354 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8032b7:	83 ec 04             	sub    $0x4,%esp
  8032ba:	6a 01                	push   $0x1
  8032bc:	ff 75 ec             	pushl  -0x14(%ebp)
  8032bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8032c2:	e8 bb f6 ff ff       	call   802982 <set_block_data>
  8032c7:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8032ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032ce:	75 17                	jne    8032e7 <alloc_block_BF+0x47a>
  8032d0:	83 ec 04             	sub    $0x4,%esp
  8032d3:	68 b7 4b 80 00       	push   $0x804bb7
  8032d8:	68 58 01 00 00       	push   $0x158
  8032dd:	68 d5 4b 80 00       	push   $0x804bd5
  8032e2:	e8 8f d5 ff ff       	call   800876 <_panic>
  8032e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ea:	8b 00                	mov    (%eax),%eax
  8032ec:	85 c0                	test   %eax,%eax
  8032ee:	74 10                	je     803300 <alloc_block_BF+0x493>
  8032f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f3:	8b 00                	mov    (%eax),%eax
  8032f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032f8:	8b 52 04             	mov    0x4(%edx),%edx
  8032fb:	89 50 04             	mov    %edx,0x4(%eax)
  8032fe:	eb 0b                	jmp    80330b <alloc_block_BF+0x49e>
  803300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803303:	8b 40 04             	mov    0x4(%eax),%eax
  803306:	a3 34 50 80 00       	mov    %eax,0x805034
  80330b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330e:	8b 40 04             	mov    0x4(%eax),%eax
  803311:	85 c0                	test   %eax,%eax
  803313:	74 0f                	je     803324 <alloc_block_BF+0x4b7>
  803315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803318:	8b 40 04             	mov    0x4(%eax),%eax
  80331b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80331e:	8b 12                	mov    (%edx),%edx
  803320:	89 10                	mov    %edx,(%eax)
  803322:	eb 0a                	jmp    80332e <alloc_block_BF+0x4c1>
  803324:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803327:	8b 00                	mov    (%eax),%eax
  803329:	a3 30 50 80 00       	mov    %eax,0x805030
  80332e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803331:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803341:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803346:	48                   	dec    %eax
  803347:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  80334c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334f:	e9 d9 00 00 00       	jmp    80342d <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	83 c0 08             	add    $0x8,%eax
  80335a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80335d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803364:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803367:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80336a:	01 d0                	add    %edx,%eax
  80336c:	48                   	dec    %eax
  80336d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803370:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803373:	ba 00 00 00 00       	mov    $0x0,%edx
  803378:	f7 75 c4             	divl   -0x3c(%ebp)
  80337b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80337e:	29 d0                	sub    %edx,%eax
  803380:	c1 e8 0c             	shr    $0xc,%eax
  803383:	83 ec 0c             	sub    $0xc,%esp
  803386:	50                   	push   %eax
  803387:	e8 49 e7 ff ff       	call   801ad5 <sbrk>
  80338c:	83 c4 10             	add    $0x10,%esp
  80338f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803392:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803396:	75 0a                	jne    8033a2 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803398:	b8 00 00 00 00       	mov    $0x0,%eax
  80339d:	e9 8b 00 00 00       	jmp    80342d <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8033a2:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8033a9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033ac:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8033af:	01 d0                	add    %edx,%eax
  8033b1:	48                   	dec    %eax
  8033b2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8033b5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8033b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8033bd:	f7 75 b8             	divl   -0x48(%ebp)
  8033c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8033c3:	29 d0                	sub    %edx,%eax
  8033c5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8033c8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8033cb:	01 d0                	add    %edx,%eax
  8033cd:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  8033d2:	a1 44 50 80 00       	mov    0x805044,%eax
  8033d7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8033dd:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8033e4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8033ea:	01 d0                	add    %edx,%eax
  8033ec:	48                   	dec    %eax
  8033ed:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8033f0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8033f8:	f7 75 b0             	divl   -0x50(%ebp)
  8033fb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8033fe:	29 d0                	sub    %edx,%eax
  803400:	83 ec 04             	sub    $0x4,%esp
  803403:	6a 01                	push   $0x1
  803405:	50                   	push   %eax
  803406:	ff 75 bc             	pushl  -0x44(%ebp)
  803409:	e8 74 f5 ff ff       	call   802982 <set_block_data>
  80340e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803411:	83 ec 0c             	sub    $0xc,%esp
  803414:	ff 75 bc             	pushl  -0x44(%ebp)
  803417:	e8 36 04 00 00       	call   803852 <free_block>
  80341c:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80341f:	83 ec 0c             	sub    $0xc,%esp
  803422:	ff 75 08             	pushl  0x8(%ebp)
  803425:	e8 43 fa ff ff       	call   802e6d <alloc_block_BF>
  80342a:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80342d:	c9                   	leave  
  80342e:	c3                   	ret    

0080342f <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80342f:	55                   	push   %ebp
  803430:	89 e5                	mov    %esp,%ebp
  803432:	53                   	push   %ebx
  803433:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803436:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80343d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803444:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803448:	74 1e                	je     803468 <merging+0x39>
  80344a:	ff 75 08             	pushl  0x8(%ebp)
  80344d:	e8 df f1 ff ff       	call   802631 <get_block_size>
  803452:	83 c4 04             	add    $0x4,%esp
  803455:	89 c2                	mov    %eax,%edx
  803457:	8b 45 08             	mov    0x8(%ebp),%eax
  80345a:	01 d0                	add    %edx,%eax
  80345c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80345f:	75 07                	jne    803468 <merging+0x39>
		prev_is_free = 1;
  803461:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803468:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80346c:	74 1e                	je     80348c <merging+0x5d>
  80346e:	ff 75 10             	pushl  0x10(%ebp)
  803471:	e8 bb f1 ff ff       	call   802631 <get_block_size>
  803476:	83 c4 04             	add    $0x4,%esp
  803479:	89 c2                	mov    %eax,%edx
  80347b:	8b 45 10             	mov    0x10(%ebp),%eax
  80347e:	01 d0                	add    %edx,%eax
  803480:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803483:	75 07                	jne    80348c <merging+0x5d>
		next_is_free = 1;
  803485:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80348c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803490:	0f 84 cc 00 00 00    	je     803562 <merging+0x133>
  803496:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80349a:	0f 84 c2 00 00 00    	je     803562 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8034a0:	ff 75 08             	pushl  0x8(%ebp)
  8034a3:	e8 89 f1 ff ff       	call   802631 <get_block_size>
  8034a8:	83 c4 04             	add    $0x4,%esp
  8034ab:	89 c3                	mov    %eax,%ebx
  8034ad:	ff 75 10             	pushl  0x10(%ebp)
  8034b0:	e8 7c f1 ff ff       	call   802631 <get_block_size>
  8034b5:	83 c4 04             	add    $0x4,%esp
  8034b8:	01 c3                	add    %eax,%ebx
  8034ba:	ff 75 0c             	pushl  0xc(%ebp)
  8034bd:	e8 6f f1 ff ff       	call   802631 <get_block_size>
  8034c2:	83 c4 04             	add    $0x4,%esp
  8034c5:	01 d8                	add    %ebx,%eax
  8034c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8034ca:	6a 00                	push   $0x0
  8034cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8034cf:	ff 75 08             	pushl  0x8(%ebp)
  8034d2:	e8 ab f4 ff ff       	call   802982 <set_block_data>
  8034d7:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8034da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034de:	75 17                	jne    8034f7 <merging+0xc8>
  8034e0:	83 ec 04             	sub    $0x4,%esp
  8034e3:	68 b7 4b 80 00       	push   $0x804bb7
  8034e8:	68 7d 01 00 00       	push   $0x17d
  8034ed:	68 d5 4b 80 00       	push   $0x804bd5
  8034f2:	e8 7f d3 ff ff       	call   800876 <_panic>
  8034f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034fa:	8b 00                	mov    (%eax),%eax
  8034fc:	85 c0                	test   %eax,%eax
  8034fe:	74 10                	je     803510 <merging+0xe1>
  803500:	8b 45 0c             	mov    0xc(%ebp),%eax
  803503:	8b 00                	mov    (%eax),%eax
  803505:	8b 55 0c             	mov    0xc(%ebp),%edx
  803508:	8b 52 04             	mov    0x4(%edx),%edx
  80350b:	89 50 04             	mov    %edx,0x4(%eax)
  80350e:	eb 0b                	jmp    80351b <merging+0xec>
  803510:	8b 45 0c             	mov    0xc(%ebp),%eax
  803513:	8b 40 04             	mov    0x4(%eax),%eax
  803516:	a3 34 50 80 00       	mov    %eax,0x805034
  80351b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80351e:	8b 40 04             	mov    0x4(%eax),%eax
  803521:	85 c0                	test   %eax,%eax
  803523:	74 0f                	je     803534 <merging+0x105>
  803525:	8b 45 0c             	mov    0xc(%ebp),%eax
  803528:	8b 40 04             	mov    0x4(%eax),%eax
  80352b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80352e:	8b 12                	mov    (%edx),%edx
  803530:	89 10                	mov    %edx,(%eax)
  803532:	eb 0a                	jmp    80353e <merging+0x10f>
  803534:	8b 45 0c             	mov    0xc(%ebp),%eax
  803537:	8b 00                	mov    (%eax),%eax
  803539:	a3 30 50 80 00       	mov    %eax,0x805030
  80353e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803541:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80354a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803551:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803556:	48                   	dec    %eax
  803557:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80355c:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80355d:	e9 ea 02 00 00       	jmp    80384c <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803566:	74 3b                	je     8035a3 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  803568:	83 ec 0c             	sub    $0xc,%esp
  80356b:	ff 75 08             	pushl  0x8(%ebp)
  80356e:	e8 be f0 ff ff       	call   802631 <get_block_size>
  803573:	83 c4 10             	add    $0x10,%esp
  803576:	89 c3                	mov    %eax,%ebx
  803578:	83 ec 0c             	sub    $0xc,%esp
  80357b:	ff 75 10             	pushl  0x10(%ebp)
  80357e:	e8 ae f0 ff ff       	call   802631 <get_block_size>
  803583:	83 c4 10             	add    $0x10,%esp
  803586:	01 d8                	add    %ebx,%eax
  803588:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80358b:	83 ec 04             	sub    $0x4,%esp
  80358e:	6a 00                	push   $0x0
  803590:	ff 75 e8             	pushl  -0x18(%ebp)
  803593:	ff 75 08             	pushl  0x8(%ebp)
  803596:	e8 e7 f3 ff ff       	call   802982 <set_block_data>
  80359b:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80359e:	e9 a9 02 00 00       	jmp    80384c <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8035a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035a7:	0f 84 2d 01 00 00    	je     8036da <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8035ad:	83 ec 0c             	sub    $0xc,%esp
  8035b0:	ff 75 10             	pushl  0x10(%ebp)
  8035b3:	e8 79 f0 ff ff       	call   802631 <get_block_size>
  8035b8:	83 c4 10             	add    $0x10,%esp
  8035bb:	89 c3                	mov    %eax,%ebx
  8035bd:	83 ec 0c             	sub    $0xc,%esp
  8035c0:	ff 75 0c             	pushl  0xc(%ebp)
  8035c3:	e8 69 f0 ff ff       	call   802631 <get_block_size>
  8035c8:	83 c4 10             	add    $0x10,%esp
  8035cb:	01 d8                	add    %ebx,%eax
  8035cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8035d0:	83 ec 04             	sub    $0x4,%esp
  8035d3:	6a 00                	push   $0x0
  8035d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035d8:	ff 75 10             	pushl  0x10(%ebp)
  8035db:	e8 a2 f3 ff ff       	call   802982 <set_block_data>
  8035e0:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8035e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8035e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8035e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035ed:	74 06                	je     8035f5 <merging+0x1c6>
  8035ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8035f3:	75 17                	jne    80360c <merging+0x1dd>
  8035f5:	83 ec 04             	sub    $0x4,%esp
  8035f8:	68 7c 4c 80 00       	push   $0x804c7c
  8035fd:	68 8d 01 00 00       	push   $0x18d
  803602:	68 d5 4b 80 00       	push   $0x804bd5
  803607:	e8 6a d2 ff ff       	call   800876 <_panic>
  80360c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80360f:	8b 50 04             	mov    0x4(%eax),%edx
  803612:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803615:	89 50 04             	mov    %edx,0x4(%eax)
  803618:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80361b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80361e:	89 10                	mov    %edx,(%eax)
  803620:	8b 45 0c             	mov    0xc(%ebp),%eax
  803623:	8b 40 04             	mov    0x4(%eax),%eax
  803626:	85 c0                	test   %eax,%eax
  803628:	74 0d                	je     803637 <merging+0x208>
  80362a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362d:	8b 40 04             	mov    0x4(%eax),%eax
  803630:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803633:	89 10                	mov    %edx,(%eax)
  803635:	eb 08                	jmp    80363f <merging+0x210>
  803637:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80363a:	a3 30 50 80 00       	mov    %eax,0x805030
  80363f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803642:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803645:	89 50 04             	mov    %edx,0x4(%eax)
  803648:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80364d:	40                   	inc    %eax
  80364e:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  803653:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803657:	75 17                	jne    803670 <merging+0x241>
  803659:	83 ec 04             	sub    $0x4,%esp
  80365c:	68 b7 4b 80 00       	push   $0x804bb7
  803661:	68 8e 01 00 00       	push   $0x18e
  803666:	68 d5 4b 80 00       	push   $0x804bd5
  80366b:	e8 06 d2 ff ff       	call   800876 <_panic>
  803670:	8b 45 0c             	mov    0xc(%ebp),%eax
  803673:	8b 00                	mov    (%eax),%eax
  803675:	85 c0                	test   %eax,%eax
  803677:	74 10                	je     803689 <merging+0x25a>
  803679:	8b 45 0c             	mov    0xc(%ebp),%eax
  80367c:	8b 00                	mov    (%eax),%eax
  80367e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803681:	8b 52 04             	mov    0x4(%edx),%edx
  803684:	89 50 04             	mov    %edx,0x4(%eax)
  803687:	eb 0b                	jmp    803694 <merging+0x265>
  803689:	8b 45 0c             	mov    0xc(%ebp),%eax
  80368c:	8b 40 04             	mov    0x4(%eax),%eax
  80368f:	a3 34 50 80 00       	mov    %eax,0x805034
  803694:	8b 45 0c             	mov    0xc(%ebp),%eax
  803697:	8b 40 04             	mov    0x4(%eax),%eax
  80369a:	85 c0                	test   %eax,%eax
  80369c:	74 0f                	je     8036ad <merging+0x27e>
  80369e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a1:	8b 40 04             	mov    0x4(%eax),%eax
  8036a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036a7:	8b 12                	mov    (%edx),%edx
  8036a9:	89 10                	mov    %edx,(%eax)
  8036ab:	eb 0a                	jmp    8036b7 <merging+0x288>
  8036ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b0:	8b 00                	mov    (%eax),%eax
  8036b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8036b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ca:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036cf:	48                   	dec    %eax
  8036d0:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8036d5:	e9 72 01 00 00       	jmp    80384c <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8036da:	8b 45 10             	mov    0x10(%ebp),%eax
  8036dd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8036e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e4:	74 79                	je     80375f <merging+0x330>
  8036e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036ea:	74 73                	je     80375f <merging+0x330>
  8036ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f0:	74 06                	je     8036f8 <merging+0x2c9>
  8036f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036f6:	75 17                	jne    80370f <merging+0x2e0>
  8036f8:	83 ec 04             	sub    $0x4,%esp
  8036fb:	68 48 4c 80 00       	push   $0x804c48
  803700:	68 94 01 00 00       	push   $0x194
  803705:	68 d5 4b 80 00       	push   $0x804bd5
  80370a:	e8 67 d1 ff ff       	call   800876 <_panic>
  80370f:	8b 45 08             	mov    0x8(%ebp),%eax
  803712:	8b 10                	mov    (%eax),%edx
  803714:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803717:	89 10                	mov    %edx,(%eax)
  803719:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80371c:	8b 00                	mov    (%eax),%eax
  80371e:	85 c0                	test   %eax,%eax
  803720:	74 0b                	je     80372d <merging+0x2fe>
  803722:	8b 45 08             	mov    0x8(%ebp),%eax
  803725:	8b 00                	mov    (%eax),%eax
  803727:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80372a:	89 50 04             	mov    %edx,0x4(%eax)
  80372d:	8b 45 08             	mov    0x8(%ebp),%eax
  803730:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803733:	89 10                	mov    %edx,(%eax)
  803735:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803738:	8b 55 08             	mov    0x8(%ebp),%edx
  80373b:	89 50 04             	mov    %edx,0x4(%eax)
  80373e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803741:	8b 00                	mov    (%eax),%eax
  803743:	85 c0                	test   %eax,%eax
  803745:	75 08                	jne    80374f <merging+0x320>
  803747:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80374a:	a3 34 50 80 00       	mov    %eax,0x805034
  80374f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803754:	40                   	inc    %eax
  803755:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80375a:	e9 ce 00 00 00       	jmp    80382d <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80375f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803763:	74 65                	je     8037ca <merging+0x39b>
  803765:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803769:	75 17                	jne    803782 <merging+0x353>
  80376b:	83 ec 04             	sub    $0x4,%esp
  80376e:	68 24 4c 80 00       	push   $0x804c24
  803773:	68 95 01 00 00       	push   $0x195
  803778:	68 d5 4b 80 00       	push   $0x804bd5
  80377d:	e8 f4 d0 ff ff       	call   800876 <_panic>
  803782:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803788:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80378b:	89 50 04             	mov    %edx,0x4(%eax)
  80378e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803791:	8b 40 04             	mov    0x4(%eax),%eax
  803794:	85 c0                	test   %eax,%eax
  803796:	74 0c                	je     8037a4 <merging+0x375>
  803798:	a1 34 50 80 00       	mov    0x805034,%eax
  80379d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037a0:	89 10                	mov    %edx,(%eax)
  8037a2:	eb 08                	jmp    8037ac <merging+0x37d>
  8037a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037a7:	a3 30 50 80 00       	mov    %eax,0x805030
  8037ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037af:	a3 34 50 80 00       	mov    %eax,0x805034
  8037b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037bd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8037c2:	40                   	inc    %eax
  8037c3:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8037c8:	eb 63                	jmp    80382d <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8037ca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8037ce:	75 17                	jne    8037e7 <merging+0x3b8>
  8037d0:	83 ec 04             	sub    $0x4,%esp
  8037d3:	68 f0 4b 80 00       	push   $0x804bf0
  8037d8:	68 98 01 00 00       	push   $0x198
  8037dd:	68 d5 4b 80 00       	push   $0x804bd5
  8037e2:	e8 8f d0 ff ff       	call   800876 <_panic>
  8037e7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8037ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f0:	89 10                	mov    %edx,(%eax)
  8037f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037f5:	8b 00                	mov    (%eax),%eax
  8037f7:	85 c0                	test   %eax,%eax
  8037f9:	74 0d                	je     803808 <merging+0x3d9>
  8037fb:	a1 30 50 80 00       	mov    0x805030,%eax
  803800:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803803:	89 50 04             	mov    %edx,0x4(%eax)
  803806:	eb 08                	jmp    803810 <merging+0x3e1>
  803808:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80380b:	a3 34 50 80 00       	mov    %eax,0x805034
  803810:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803813:	a3 30 50 80 00       	mov    %eax,0x805030
  803818:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80381b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803822:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803827:	40                   	inc    %eax
  803828:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  80382d:	83 ec 0c             	sub    $0xc,%esp
  803830:	ff 75 10             	pushl  0x10(%ebp)
  803833:	e8 f9 ed ff ff       	call   802631 <get_block_size>
  803838:	83 c4 10             	add    $0x10,%esp
  80383b:	83 ec 04             	sub    $0x4,%esp
  80383e:	6a 00                	push   $0x0
  803840:	50                   	push   %eax
  803841:	ff 75 10             	pushl  0x10(%ebp)
  803844:	e8 39 f1 ff ff       	call   802982 <set_block_data>
  803849:	83 c4 10             	add    $0x10,%esp
	}
}
  80384c:	90                   	nop
  80384d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803850:	c9                   	leave  
  803851:	c3                   	ret    

00803852 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803852:	55                   	push   %ebp
  803853:	89 e5                	mov    %esp,%ebp
  803855:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803858:	a1 30 50 80 00       	mov    0x805030,%eax
  80385d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803860:	a1 34 50 80 00       	mov    0x805034,%eax
  803865:	3b 45 08             	cmp    0x8(%ebp),%eax
  803868:	73 1b                	jae    803885 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80386a:	a1 34 50 80 00       	mov    0x805034,%eax
  80386f:	83 ec 04             	sub    $0x4,%esp
  803872:	ff 75 08             	pushl  0x8(%ebp)
  803875:	6a 00                	push   $0x0
  803877:	50                   	push   %eax
  803878:	e8 b2 fb ff ff       	call   80342f <merging>
  80387d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803880:	e9 8b 00 00 00       	jmp    803910 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803885:	a1 30 50 80 00       	mov    0x805030,%eax
  80388a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80388d:	76 18                	jbe    8038a7 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80388f:	a1 30 50 80 00       	mov    0x805030,%eax
  803894:	83 ec 04             	sub    $0x4,%esp
  803897:	ff 75 08             	pushl  0x8(%ebp)
  80389a:	50                   	push   %eax
  80389b:	6a 00                	push   $0x0
  80389d:	e8 8d fb ff ff       	call   80342f <merging>
  8038a2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8038a5:	eb 69                	jmp    803910 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8038a7:	a1 30 50 80 00       	mov    0x805030,%eax
  8038ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038af:	eb 39                	jmp    8038ea <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8038b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038b7:	73 29                	jae    8038e2 <free_block+0x90>
  8038b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bc:	8b 00                	mov    (%eax),%eax
  8038be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038c1:	76 1f                	jbe    8038e2 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8038c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c6:	8b 00                	mov    (%eax),%eax
  8038c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8038cb:	83 ec 04             	sub    $0x4,%esp
  8038ce:	ff 75 08             	pushl  0x8(%ebp)
  8038d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8038d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8038d7:	e8 53 fb ff ff       	call   80342f <merging>
  8038dc:	83 c4 10             	add    $0x10,%esp
			break;
  8038df:	90                   	nop
		}
	}
}
  8038e0:	eb 2e                	jmp    803910 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8038e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8038e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038ee:	74 07                	je     8038f7 <free_block+0xa5>
  8038f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f3:	8b 00                	mov    (%eax),%eax
  8038f5:	eb 05                	jmp    8038fc <free_block+0xaa>
  8038f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038fc:	a3 38 50 80 00       	mov    %eax,0x805038
  803901:	a1 38 50 80 00       	mov    0x805038,%eax
  803906:	85 c0                	test   %eax,%eax
  803908:	75 a7                	jne    8038b1 <free_block+0x5f>
  80390a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80390e:	75 a1                	jne    8038b1 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803910:	90                   	nop
  803911:	c9                   	leave  
  803912:	c3                   	ret    

00803913 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803913:	55                   	push   %ebp
  803914:	89 e5                	mov    %esp,%ebp
  803916:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803919:	ff 75 08             	pushl  0x8(%ebp)
  80391c:	e8 10 ed ff ff       	call   802631 <get_block_size>
  803921:	83 c4 04             	add    $0x4,%esp
  803924:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803927:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80392e:	eb 17                	jmp    803947 <copy_data+0x34>
  803930:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803933:	8b 45 0c             	mov    0xc(%ebp),%eax
  803936:	01 c2                	add    %eax,%edx
  803938:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80393b:	8b 45 08             	mov    0x8(%ebp),%eax
  80393e:	01 c8                	add    %ecx,%eax
  803940:	8a 00                	mov    (%eax),%al
  803942:	88 02                	mov    %al,(%edx)
  803944:	ff 45 fc             	incl   -0x4(%ebp)
  803947:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80394a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80394d:	72 e1                	jb     803930 <copy_data+0x1d>
}
  80394f:	90                   	nop
  803950:	c9                   	leave  
  803951:	c3                   	ret    

00803952 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803952:	55                   	push   %ebp
  803953:	89 e5                	mov    %esp,%ebp
  803955:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803958:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80395c:	75 23                	jne    803981 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80395e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803962:	74 13                	je     803977 <realloc_block_FF+0x25>
  803964:	83 ec 0c             	sub    $0xc,%esp
  803967:	ff 75 0c             	pushl  0xc(%ebp)
  80396a:	e8 42 f0 ff ff       	call   8029b1 <alloc_block_FF>
  80396f:	83 c4 10             	add    $0x10,%esp
  803972:	e9 e4 06 00 00       	jmp    80405b <realloc_block_FF+0x709>
		return NULL;
  803977:	b8 00 00 00 00       	mov    $0x0,%eax
  80397c:	e9 da 06 00 00       	jmp    80405b <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803981:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803985:	75 18                	jne    80399f <realloc_block_FF+0x4d>
	{
		free_block(va);
  803987:	83 ec 0c             	sub    $0xc,%esp
  80398a:	ff 75 08             	pushl  0x8(%ebp)
  80398d:	e8 c0 fe ff ff       	call   803852 <free_block>
  803992:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803995:	b8 00 00 00 00       	mov    $0x0,%eax
  80399a:	e9 bc 06 00 00       	jmp    80405b <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  80399f:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8039a3:	77 07                	ja     8039ac <realloc_block_FF+0x5a>
  8039a5:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8039ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039af:	83 e0 01             	and    $0x1,%eax
  8039b2:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8039b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039b8:	83 c0 08             	add    $0x8,%eax
  8039bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8039be:	83 ec 0c             	sub    $0xc,%esp
  8039c1:	ff 75 08             	pushl  0x8(%ebp)
  8039c4:	e8 68 ec ff ff       	call   802631 <get_block_size>
  8039c9:	83 c4 10             	add    $0x10,%esp
  8039cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8039cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039d2:	83 e8 08             	sub    $0x8,%eax
  8039d5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8039d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039db:	83 e8 04             	sub    $0x4,%eax
  8039de:	8b 00                	mov    (%eax),%eax
  8039e0:	83 e0 fe             	and    $0xfffffffe,%eax
  8039e3:	89 c2                	mov    %eax,%edx
  8039e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e8:	01 d0                	add    %edx,%eax
  8039ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8039ed:	83 ec 0c             	sub    $0xc,%esp
  8039f0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8039f3:	e8 39 ec ff ff       	call   802631 <get_block_size>
  8039f8:	83 c4 10             	add    $0x10,%esp
  8039fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8039fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a01:	83 e8 08             	sub    $0x8,%eax
  803a04:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a0a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a0d:	75 08                	jne    803a17 <realloc_block_FF+0xc5>
	{
		 return va;
  803a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a12:	e9 44 06 00 00       	jmp    80405b <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a1a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803a1d:	0f 83 d5 03 00 00    	jae    803df8 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a26:	2b 45 0c             	sub    0xc(%ebp),%eax
  803a29:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803a2c:	83 ec 0c             	sub    $0xc,%esp
  803a2f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803a32:	e8 13 ec ff ff       	call   80264a <is_free_block>
  803a37:	83 c4 10             	add    $0x10,%esp
  803a3a:	84 c0                	test   %al,%al
  803a3c:	0f 84 3b 01 00 00    	je     803b7d <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803a42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a45:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a48:	01 d0                	add    %edx,%eax
  803a4a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803a4d:	83 ec 04             	sub    $0x4,%esp
  803a50:	6a 01                	push   $0x1
  803a52:	ff 75 f0             	pushl  -0x10(%ebp)
  803a55:	ff 75 08             	pushl  0x8(%ebp)
  803a58:	e8 25 ef ff ff       	call   802982 <set_block_data>
  803a5d:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803a60:	8b 45 08             	mov    0x8(%ebp),%eax
  803a63:	83 e8 04             	sub    $0x4,%eax
  803a66:	8b 00                	mov    (%eax),%eax
  803a68:	83 e0 fe             	and    $0xfffffffe,%eax
  803a6b:	89 c2                	mov    %eax,%edx
  803a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a70:	01 d0                	add    %edx,%eax
  803a72:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803a75:	83 ec 04             	sub    $0x4,%esp
  803a78:	6a 00                	push   $0x0
  803a7a:	ff 75 cc             	pushl  -0x34(%ebp)
  803a7d:	ff 75 c8             	pushl  -0x38(%ebp)
  803a80:	e8 fd ee ff ff       	call   802982 <set_block_data>
  803a85:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a8c:	74 06                	je     803a94 <realloc_block_FF+0x142>
  803a8e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803a92:	75 17                	jne    803aab <realloc_block_FF+0x159>
  803a94:	83 ec 04             	sub    $0x4,%esp
  803a97:	68 48 4c 80 00       	push   $0x804c48
  803a9c:	68 f6 01 00 00       	push   $0x1f6
  803aa1:	68 d5 4b 80 00       	push   $0x804bd5
  803aa6:	e8 cb cd ff ff       	call   800876 <_panic>
  803aab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aae:	8b 10                	mov    (%eax),%edx
  803ab0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ab3:	89 10                	mov    %edx,(%eax)
  803ab5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ab8:	8b 00                	mov    (%eax),%eax
  803aba:	85 c0                	test   %eax,%eax
  803abc:	74 0b                	je     803ac9 <realloc_block_FF+0x177>
  803abe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac1:	8b 00                	mov    (%eax),%eax
  803ac3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ac6:	89 50 04             	mov    %edx,0x4(%eax)
  803ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803acc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803acf:	89 10                	mov    %edx,(%eax)
  803ad1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ad4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ad7:	89 50 04             	mov    %edx,0x4(%eax)
  803ada:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803add:	8b 00                	mov    (%eax),%eax
  803adf:	85 c0                	test   %eax,%eax
  803ae1:	75 08                	jne    803aeb <realloc_block_FF+0x199>
  803ae3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803ae6:	a3 34 50 80 00       	mov    %eax,0x805034
  803aeb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803af0:	40                   	inc    %eax
  803af1:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803af6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803afa:	75 17                	jne    803b13 <realloc_block_FF+0x1c1>
  803afc:	83 ec 04             	sub    $0x4,%esp
  803aff:	68 b7 4b 80 00       	push   $0x804bb7
  803b04:	68 f7 01 00 00       	push   $0x1f7
  803b09:	68 d5 4b 80 00       	push   $0x804bd5
  803b0e:	e8 63 cd ff ff       	call   800876 <_panic>
  803b13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b16:	8b 00                	mov    (%eax),%eax
  803b18:	85 c0                	test   %eax,%eax
  803b1a:	74 10                	je     803b2c <realloc_block_FF+0x1da>
  803b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1f:	8b 00                	mov    (%eax),%eax
  803b21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b24:	8b 52 04             	mov    0x4(%edx),%edx
  803b27:	89 50 04             	mov    %edx,0x4(%eax)
  803b2a:	eb 0b                	jmp    803b37 <realloc_block_FF+0x1e5>
  803b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b2f:	8b 40 04             	mov    0x4(%eax),%eax
  803b32:	a3 34 50 80 00       	mov    %eax,0x805034
  803b37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b3a:	8b 40 04             	mov    0x4(%eax),%eax
  803b3d:	85 c0                	test   %eax,%eax
  803b3f:	74 0f                	je     803b50 <realloc_block_FF+0x1fe>
  803b41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b44:	8b 40 04             	mov    0x4(%eax),%eax
  803b47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b4a:	8b 12                	mov    (%edx),%edx
  803b4c:	89 10                	mov    %edx,(%eax)
  803b4e:	eb 0a                	jmp    803b5a <realloc_block_FF+0x208>
  803b50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b53:	8b 00                	mov    (%eax),%eax
  803b55:	a3 30 50 80 00       	mov    %eax,0x805030
  803b5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b6d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b72:	48                   	dec    %eax
  803b73:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b78:	e9 73 02 00 00       	jmp    803df0 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803b7d:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803b81:	0f 86 69 02 00 00    	jbe    803df0 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803b87:	83 ec 04             	sub    $0x4,%esp
  803b8a:	6a 01                	push   $0x1
  803b8c:	ff 75 f0             	pushl  -0x10(%ebp)
  803b8f:	ff 75 08             	pushl  0x8(%ebp)
  803b92:	e8 eb ed ff ff       	call   802982 <set_block_data>
  803b97:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9d:	83 e8 04             	sub    $0x4,%eax
  803ba0:	8b 00                	mov    (%eax),%eax
  803ba2:	83 e0 fe             	and    $0xfffffffe,%eax
  803ba5:	89 c2                	mov    %eax,%edx
  803ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  803baa:	01 d0                	add    %edx,%eax
  803bac:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803baf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bb4:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803bb7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803bbb:	75 68                	jne    803c25 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803bbd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bc1:	75 17                	jne    803bda <realloc_block_FF+0x288>
  803bc3:	83 ec 04             	sub    $0x4,%esp
  803bc6:	68 f0 4b 80 00       	push   $0x804bf0
  803bcb:	68 06 02 00 00       	push   $0x206
  803bd0:	68 d5 4b 80 00       	push   $0x804bd5
  803bd5:	e8 9c cc ff ff       	call   800876 <_panic>
  803bda:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be3:	89 10                	mov    %edx,(%eax)
  803be5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803be8:	8b 00                	mov    (%eax),%eax
  803bea:	85 c0                	test   %eax,%eax
  803bec:	74 0d                	je     803bfb <realloc_block_FF+0x2a9>
  803bee:	a1 30 50 80 00       	mov    0x805030,%eax
  803bf3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bf6:	89 50 04             	mov    %edx,0x4(%eax)
  803bf9:	eb 08                	jmp    803c03 <realloc_block_FF+0x2b1>
  803bfb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bfe:	a3 34 50 80 00       	mov    %eax,0x805034
  803c03:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c06:	a3 30 50 80 00       	mov    %eax,0x805030
  803c0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c15:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c1a:	40                   	inc    %eax
  803c1b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c20:	e9 b0 01 00 00       	jmp    803dd5 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803c25:	a1 30 50 80 00       	mov    0x805030,%eax
  803c2a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c2d:	76 68                	jbe    803c97 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803c2f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c33:	75 17                	jne    803c4c <realloc_block_FF+0x2fa>
  803c35:	83 ec 04             	sub    $0x4,%esp
  803c38:	68 f0 4b 80 00       	push   $0x804bf0
  803c3d:	68 0b 02 00 00       	push   $0x20b
  803c42:	68 d5 4b 80 00       	push   $0x804bd5
  803c47:	e8 2a cc ff ff       	call   800876 <_panic>
  803c4c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803c52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c55:	89 10                	mov    %edx,(%eax)
  803c57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c5a:	8b 00                	mov    (%eax),%eax
  803c5c:	85 c0                	test   %eax,%eax
  803c5e:	74 0d                	je     803c6d <realloc_block_FF+0x31b>
  803c60:	a1 30 50 80 00       	mov    0x805030,%eax
  803c65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c68:	89 50 04             	mov    %edx,0x4(%eax)
  803c6b:	eb 08                	jmp    803c75 <realloc_block_FF+0x323>
  803c6d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c70:	a3 34 50 80 00       	mov    %eax,0x805034
  803c75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c78:	a3 30 50 80 00       	mov    %eax,0x805030
  803c7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c87:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c8c:	40                   	inc    %eax
  803c8d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c92:	e9 3e 01 00 00       	jmp    803dd5 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803c97:	a1 30 50 80 00       	mov    0x805030,%eax
  803c9c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c9f:	73 68                	jae    803d09 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803ca1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803ca5:	75 17                	jne    803cbe <realloc_block_FF+0x36c>
  803ca7:	83 ec 04             	sub    $0x4,%esp
  803caa:	68 24 4c 80 00       	push   $0x804c24
  803caf:	68 10 02 00 00       	push   $0x210
  803cb4:	68 d5 4b 80 00       	push   $0x804bd5
  803cb9:	e8 b8 cb ff ff       	call   800876 <_panic>
  803cbe:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803cc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc7:	89 50 04             	mov    %edx,0x4(%eax)
  803cca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ccd:	8b 40 04             	mov    0x4(%eax),%eax
  803cd0:	85 c0                	test   %eax,%eax
  803cd2:	74 0c                	je     803ce0 <realloc_block_FF+0x38e>
  803cd4:	a1 34 50 80 00       	mov    0x805034,%eax
  803cd9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cdc:	89 10                	mov    %edx,(%eax)
  803cde:	eb 08                	jmp    803ce8 <realloc_block_FF+0x396>
  803ce0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ce3:	a3 30 50 80 00       	mov    %eax,0x805030
  803ce8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ceb:	a3 34 50 80 00       	mov    %eax,0x805034
  803cf0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cf3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cf9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803cfe:	40                   	inc    %eax
  803cff:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803d04:	e9 cc 00 00 00       	jmp    803dd5 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803d09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803d10:	a1 30 50 80 00       	mov    0x805030,%eax
  803d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d18:	e9 8a 00 00 00       	jmp    803da7 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d20:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d23:	73 7a                	jae    803d9f <realloc_block_FF+0x44d>
  803d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d28:	8b 00                	mov    (%eax),%eax
  803d2a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803d2d:	73 70                	jae    803d9f <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803d2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d33:	74 06                	je     803d3b <realloc_block_FF+0x3e9>
  803d35:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803d39:	75 17                	jne    803d52 <realloc_block_FF+0x400>
  803d3b:	83 ec 04             	sub    $0x4,%esp
  803d3e:	68 48 4c 80 00       	push   $0x804c48
  803d43:	68 1a 02 00 00       	push   $0x21a
  803d48:	68 d5 4b 80 00       	push   $0x804bd5
  803d4d:	e8 24 cb ff ff       	call   800876 <_panic>
  803d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d55:	8b 10                	mov    (%eax),%edx
  803d57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d5a:	89 10                	mov    %edx,(%eax)
  803d5c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d5f:	8b 00                	mov    (%eax),%eax
  803d61:	85 c0                	test   %eax,%eax
  803d63:	74 0b                	je     803d70 <realloc_block_FF+0x41e>
  803d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d68:	8b 00                	mov    (%eax),%eax
  803d6a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d6d:	89 50 04             	mov    %edx,0x4(%eax)
  803d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d73:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d76:	89 10                	mov    %edx,(%eax)
  803d78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d7e:	89 50 04             	mov    %edx,0x4(%eax)
  803d81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d84:	8b 00                	mov    (%eax),%eax
  803d86:	85 c0                	test   %eax,%eax
  803d88:	75 08                	jne    803d92 <realloc_block_FF+0x440>
  803d8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d8d:	a3 34 50 80 00       	mov    %eax,0x805034
  803d92:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803d97:	40                   	inc    %eax
  803d98:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803d9d:	eb 36                	jmp    803dd5 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803d9f:	a1 38 50 80 00       	mov    0x805038,%eax
  803da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803da7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dab:	74 07                	je     803db4 <realloc_block_FF+0x462>
  803dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db0:	8b 00                	mov    (%eax),%eax
  803db2:	eb 05                	jmp    803db9 <realloc_block_FF+0x467>
  803db4:	b8 00 00 00 00       	mov    $0x0,%eax
  803db9:	a3 38 50 80 00       	mov    %eax,0x805038
  803dbe:	a1 38 50 80 00       	mov    0x805038,%eax
  803dc3:	85 c0                	test   %eax,%eax
  803dc5:	0f 85 52 ff ff ff    	jne    803d1d <realloc_block_FF+0x3cb>
  803dcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dcf:	0f 85 48 ff ff ff    	jne    803d1d <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803dd5:	83 ec 04             	sub    $0x4,%esp
  803dd8:	6a 00                	push   $0x0
  803dda:	ff 75 d8             	pushl  -0x28(%ebp)
  803ddd:	ff 75 d4             	pushl  -0x2c(%ebp)
  803de0:	e8 9d eb ff ff       	call   802982 <set_block_data>
  803de5:	83 c4 10             	add    $0x10,%esp
				return va;
  803de8:	8b 45 08             	mov    0x8(%ebp),%eax
  803deb:	e9 6b 02 00 00       	jmp    80405b <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803df0:	8b 45 08             	mov    0x8(%ebp),%eax
  803df3:	e9 63 02 00 00       	jmp    80405b <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803dfb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803dfe:	0f 86 4d 02 00 00    	jbe    804051 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803e04:	83 ec 0c             	sub    $0xc,%esp
  803e07:	ff 75 e4             	pushl  -0x1c(%ebp)
  803e0a:	e8 3b e8 ff ff       	call   80264a <is_free_block>
  803e0f:	83 c4 10             	add    $0x10,%esp
  803e12:	84 c0                	test   %al,%al
  803e14:	0f 84 37 02 00 00    	je     804051 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e1d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803e20:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803e23:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e26:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803e29:	76 38                	jbe    803e63 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803e2b:	83 ec 0c             	sub    $0xc,%esp
  803e2e:	ff 75 0c             	pushl  0xc(%ebp)
  803e31:	e8 7b eb ff ff       	call   8029b1 <alloc_block_FF>
  803e36:	83 c4 10             	add    $0x10,%esp
  803e39:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803e3c:	83 ec 08             	sub    $0x8,%esp
  803e3f:	ff 75 c0             	pushl  -0x40(%ebp)
  803e42:	ff 75 08             	pushl  0x8(%ebp)
  803e45:	e8 c9 fa ff ff       	call   803913 <copy_data>
  803e4a:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803e4d:	83 ec 0c             	sub    $0xc,%esp
  803e50:	ff 75 08             	pushl  0x8(%ebp)
  803e53:	e8 fa f9 ff ff       	call   803852 <free_block>
  803e58:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803e5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803e5e:	e9 f8 01 00 00       	jmp    80405b <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803e63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e66:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803e69:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803e6c:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803e70:	0f 87 a0 00 00 00    	ja     803f16 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803e76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e7a:	75 17                	jne    803e93 <realloc_block_FF+0x541>
  803e7c:	83 ec 04             	sub    $0x4,%esp
  803e7f:	68 b7 4b 80 00       	push   $0x804bb7
  803e84:	68 38 02 00 00       	push   $0x238
  803e89:	68 d5 4b 80 00       	push   $0x804bd5
  803e8e:	e8 e3 c9 ff ff       	call   800876 <_panic>
  803e93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e96:	8b 00                	mov    (%eax),%eax
  803e98:	85 c0                	test   %eax,%eax
  803e9a:	74 10                	je     803eac <realloc_block_FF+0x55a>
  803e9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e9f:	8b 00                	mov    (%eax),%eax
  803ea1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ea4:	8b 52 04             	mov    0x4(%edx),%edx
  803ea7:	89 50 04             	mov    %edx,0x4(%eax)
  803eaa:	eb 0b                	jmp    803eb7 <realloc_block_FF+0x565>
  803eac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eaf:	8b 40 04             	mov    0x4(%eax),%eax
  803eb2:	a3 34 50 80 00       	mov    %eax,0x805034
  803eb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eba:	8b 40 04             	mov    0x4(%eax),%eax
  803ebd:	85 c0                	test   %eax,%eax
  803ebf:	74 0f                	je     803ed0 <realloc_block_FF+0x57e>
  803ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec4:	8b 40 04             	mov    0x4(%eax),%eax
  803ec7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803eca:	8b 12                	mov    (%edx),%edx
  803ecc:	89 10                	mov    %edx,(%eax)
  803ece:	eb 0a                	jmp    803eda <realloc_block_FF+0x588>
  803ed0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed3:	8b 00                	mov    (%eax),%eax
  803ed5:	a3 30 50 80 00       	mov    %eax,0x805030
  803eda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803edd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ee3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803eed:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ef2:	48                   	dec    %eax
  803ef3:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803ef8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803efb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803efe:	01 d0                	add    %edx,%eax
  803f00:	83 ec 04             	sub    $0x4,%esp
  803f03:	6a 01                	push   $0x1
  803f05:	50                   	push   %eax
  803f06:	ff 75 08             	pushl  0x8(%ebp)
  803f09:	e8 74 ea ff ff       	call   802982 <set_block_data>
  803f0e:	83 c4 10             	add    $0x10,%esp
  803f11:	e9 36 01 00 00       	jmp    80404c <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803f16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f1c:	01 d0                	add    %edx,%eax
  803f1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803f21:	83 ec 04             	sub    $0x4,%esp
  803f24:	6a 01                	push   $0x1
  803f26:	ff 75 f0             	pushl  -0x10(%ebp)
  803f29:	ff 75 08             	pushl  0x8(%ebp)
  803f2c:	e8 51 ea ff ff       	call   802982 <set_block_data>
  803f31:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803f34:	8b 45 08             	mov    0x8(%ebp),%eax
  803f37:	83 e8 04             	sub    $0x4,%eax
  803f3a:	8b 00                	mov    (%eax),%eax
  803f3c:	83 e0 fe             	and    $0xfffffffe,%eax
  803f3f:	89 c2                	mov    %eax,%edx
  803f41:	8b 45 08             	mov    0x8(%ebp),%eax
  803f44:	01 d0                	add    %edx,%eax
  803f46:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803f49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f4d:	74 06                	je     803f55 <realloc_block_FF+0x603>
  803f4f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803f53:	75 17                	jne    803f6c <realloc_block_FF+0x61a>
  803f55:	83 ec 04             	sub    $0x4,%esp
  803f58:	68 48 4c 80 00       	push   $0x804c48
  803f5d:	68 44 02 00 00       	push   $0x244
  803f62:	68 d5 4b 80 00       	push   $0x804bd5
  803f67:	e8 0a c9 ff ff       	call   800876 <_panic>
  803f6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f6f:	8b 10                	mov    (%eax),%edx
  803f71:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f74:	89 10                	mov    %edx,(%eax)
  803f76:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f79:	8b 00                	mov    (%eax),%eax
  803f7b:	85 c0                	test   %eax,%eax
  803f7d:	74 0b                	je     803f8a <realloc_block_FF+0x638>
  803f7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f82:	8b 00                	mov    (%eax),%eax
  803f84:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f87:	89 50 04             	mov    %edx,0x4(%eax)
  803f8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f8d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803f90:	89 10                	mov    %edx,(%eax)
  803f92:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f98:	89 50 04             	mov    %edx,0x4(%eax)
  803f9b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f9e:	8b 00                	mov    (%eax),%eax
  803fa0:	85 c0                	test   %eax,%eax
  803fa2:	75 08                	jne    803fac <realloc_block_FF+0x65a>
  803fa4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fa7:	a3 34 50 80 00       	mov    %eax,0x805034
  803fac:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803fb1:	40                   	inc    %eax
  803fb2:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803fb7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fbb:	75 17                	jne    803fd4 <realloc_block_FF+0x682>
  803fbd:	83 ec 04             	sub    $0x4,%esp
  803fc0:	68 b7 4b 80 00       	push   $0x804bb7
  803fc5:	68 45 02 00 00       	push   $0x245
  803fca:	68 d5 4b 80 00       	push   $0x804bd5
  803fcf:	e8 a2 c8 ff ff       	call   800876 <_panic>
  803fd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd7:	8b 00                	mov    (%eax),%eax
  803fd9:	85 c0                	test   %eax,%eax
  803fdb:	74 10                	je     803fed <realloc_block_FF+0x69b>
  803fdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fe0:	8b 00                	mov    (%eax),%eax
  803fe2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803fe5:	8b 52 04             	mov    0x4(%edx),%edx
  803fe8:	89 50 04             	mov    %edx,0x4(%eax)
  803feb:	eb 0b                	jmp    803ff8 <realloc_block_FF+0x6a6>
  803fed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff0:	8b 40 04             	mov    0x4(%eax),%eax
  803ff3:	a3 34 50 80 00       	mov    %eax,0x805034
  803ff8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ffb:	8b 40 04             	mov    0x4(%eax),%eax
  803ffe:	85 c0                	test   %eax,%eax
  804000:	74 0f                	je     804011 <realloc_block_FF+0x6bf>
  804002:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804005:	8b 40 04             	mov    0x4(%eax),%eax
  804008:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80400b:	8b 12                	mov    (%edx),%edx
  80400d:	89 10                	mov    %edx,(%eax)
  80400f:	eb 0a                	jmp    80401b <realloc_block_FF+0x6c9>
  804011:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804014:	8b 00                	mov    (%eax),%eax
  804016:	a3 30 50 80 00       	mov    %eax,0x805030
  80401b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80401e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804024:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804027:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80402e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  804033:	48                   	dec    %eax
  804034:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  804039:	83 ec 04             	sub    $0x4,%esp
  80403c:	6a 00                	push   $0x0
  80403e:	ff 75 bc             	pushl  -0x44(%ebp)
  804041:	ff 75 b8             	pushl  -0x48(%ebp)
  804044:	e8 39 e9 ff ff       	call   802982 <set_block_data>
  804049:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80404c:	8b 45 08             	mov    0x8(%ebp),%eax
  80404f:	eb 0a                	jmp    80405b <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804051:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804058:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80405b:	c9                   	leave  
  80405c:	c3                   	ret    

0080405d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80405d:	55                   	push   %ebp
  80405e:	89 e5                	mov    %esp,%ebp
  804060:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804063:	83 ec 04             	sub    $0x4,%esp
  804066:	68 b4 4c 80 00       	push   $0x804cb4
  80406b:	68 58 02 00 00       	push   $0x258
  804070:	68 d5 4b 80 00       	push   $0x804bd5
  804075:	e8 fc c7 ff ff       	call   800876 <_panic>

0080407a <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80407a:	55                   	push   %ebp
  80407b:	89 e5                	mov    %esp,%ebp
  80407d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804080:	83 ec 04             	sub    $0x4,%esp
  804083:	68 dc 4c 80 00       	push   $0x804cdc
  804088:	68 61 02 00 00       	push   $0x261
  80408d:	68 d5 4b 80 00       	push   $0x804bd5
  804092:	e8 df c7 ff ff       	call   800876 <_panic>
  804097:	90                   	nop

00804098 <__udivdi3>:
  804098:	55                   	push   %ebp
  804099:	57                   	push   %edi
  80409a:	56                   	push   %esi
  80409b:	53                   	push   %ebx
  80409c:	83 ec 1c             	sub    $0x1c,%esp
  80409f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8040a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8040a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040af:	89 ca                	mov    %ecx,%edx
  8040b1:	89 f8                	mov    %edi,%eax
  8040b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8040b7:	85 f6                	test   %esi,%esi
  8040b9:	75 2d                	jne    8040e8 <__udivdi3+0x50>
  8040bb:	39 cf                	cmp    %ecx,%edi
  8040bd:	77 65                	ja     804124 <__udivdi3+0x8c>
  8040bf:	89 fd                	mov    %edi,%ebp
  8040c1:	85 ff                	test   %edi,%edi
  8040c3:	75 0b                	jne    8040d0 <__udivdi3+0x38>
  8040c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8040ca:	31 d2                	xor    %edx,%edx
  8040cc:	f7 f7                	div    %edi
  8040ce:	89 c5                	mov    %eax,%ebp
  8040d0:	31 d2                	xor    %edx,%edx
  8040d2:	89 c8                	mov    %ecx,%eax
  8040d4:	f7 f5                	div    %ebp
  8040d6:	89 c1                	mov    %eax,%ecx
  8040d8:	89 d8                	mov    %ebx,%eax
  8040da:	f7 f5                	div    %ebp
  8040dc:	89 cf                	mov    %ecx,%edi
  8040de:	89 fa                	mov    %edi,%edx
  8040e0:	83 c4 1c             	add    $0x1c,%esp
  8040e3:	5b                   	pop    %ebx
  8040e4:	5e                   	pop    %esi
  8040e5:	5f                   	pop    %edi
  8040e6:	5d                   	pop    %ebp
  8040e7:	c3                   	ret    
  8040e8:	39 ce                	cmp    %ecx,%esi
  8040ea:	77 28                	ja     804114 <__udivdi3+0x7c>
  8040ec:	0f bd fe             	bsr    %esi,%edi
  8040ef:	83 f7 1f             	xor    $0x1f,%edi
  8040f2:	75 40                	jne    804134 <__udivdi3+0x9c>
  8040f4:	39 ce                	cmp    %ecx,%esi
  8040f6:	72 0a                	jb     804102 <__udivdi3+0x6a>
  8040f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040fc:	0f 87 9e 00 00 00    	ja     8041a0 <__udivdi3+0x108>
  804102:	b8 01 00 00 00       	mov    $0x1,%eax
  804107:	89 fa                	mov    %edi,%edx
  804109:	83 c4 1c             	add    $0x1c,%esp
  80410c:	5b                   	pop    %ebx
  80410d:	5e                   	pop    %esi
  80410e:	5f                   	pop    %edi
  80410f:	5d                   	pop    %ebp
  804110:	c3                   	ret    
  804111:	8d 76 00             	lea    0x0(%esi),%esi
  804114:	31 ff                	xor    %edi,%edi
  804116:	31 c0                	xor    %eax,%eax
  804118:	89 fa                	mov    %edi,%edx
  80411a:	83 c4 1c             	add    $0x1c,%esp
  80411d:	5b                   	pop    %ebx
  80411e:	5e                   	pop    %esi
  80411f:	5f                   	pop    %edi
  804120:	5d                   	pop    %ebp
  804121:	c3                   	ret    
  804122:	66 90                	xchg   %ax,%ax
  804124:	89 d8                	mov    %ebx,%eax
  804126:	f7 f7                	div    %edi
  804128:	31 ff                	xor    %edi,%edi
  80412a:	89 fa                	mov    %edi,%edx
  80412c:	83 c4 1c             	add    $0x1c,%esp
  80412f:	5b                   	pop    %ebx
  804130:	5e                   	pop    %esi
  804131:	5f                   	pop    %edi
  804132:	5d                   	pop    %ebp
  804133:	c3                   	ret    
  804134:	bd 20 00 00 00       	mov    $0x20,%ebp
  804139:	89 eb                	mov    %ebp,%ebx
  80413b:	29 fb                	sub    %edi,%ebx
  80413d:	89 f9                	mov    %edi,%ecx
  80413f:	d3 e6                	shl    %cl,%esi
  804141:	89 c5                	mov    %eax,%ebp
  804143:	88 d9                	mov    %bl,%cl
  804145:	d3 ed                	shr    %cl,%ebp
  804147:	89 e9                	mov    %ebp,%ecx
  804149:	09 f1                	or     %esi,%ecx
  80414b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80414f:	89 f9                	mov    %edi,%ecx
  804151:	d3 e0                	shl    %cl,%eax
  804153:	89 c5                	mov    %eax,%ebp
  804155:	89 d6                	mov    %edx,%esi
  804157:	88 d9                	mov    %bl,%cl
  804159:	d3 ee                	shr    %cl,%esi
  80415b:	89 f9                	mov    %edi,%ecx
  80415d:	d3 e2                	shl    %cl,%edx
  80415f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804163:	88 d9                	mov    %bl,%cl
  804165:	d3 e8                	shr    %cl,%eax
  804167:	09 c2                	or     %eax,%edx
  804169:	89 d0                	mov    %edx,%eax
  80416b:	89 f2                	mov    %esi,%edx
  80416d:	f7 74 24 0c          	divl   0xc(%esp)
  804171:	89 d6                	mov    %edx,%esi
  804173:	89 c3                	mov    %eax,%ebx
  804175:	f7 e5                	mul    %ebp
  804177:	39 d6                	cmp    %edx,%esi
  804179:	72 19                	jb     804194 <__udivdi3+0xfc>
  80417b:	74 0b                	je     804188 <__udivdi3+0xf0>
  80417d:	89 d8                	mov    %ebx,%eax
  80417f:	31 ff                	xor    %edi,%edi
  804181:	e9 58 ff ff ff       	jmp    8040de <__udivdi3+0x46>
  804186:	66 90                	xchg   %ax,%ax
  804188:	8b 54 24 08          	mov    0x8(%esp),%edx
  80418c:	89 f9                	mov    %edi,%ecx
  80418e:	d3 e2                	shl    %cl,%edx
  804190:	39 c2                	cmp    %eax,%edx
  804192:	73 e9                	jae    80417d <__udivdi3+0xe5>
  804194:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804197:	31 ff                	xor    %edi,%edi
  804199:	e9 40 ff ff ff       	jmp    8040de <__udivdi3+0x46>
  80419e:	66 90                	xchg   %ax,%ax
  8041a0:	31 c0                	xor    %eax,%eax
  8041a2:	e9 37 ff ff ff       	jmp    8040de <__udivdi3+0x46>
  8041a7:	90                   	nop

008041a8 <__umoddi3>:
  8041a8:	55                   	push   %ebp
  8041a9:	57                   	push   %edi
  8041aa:	56                   	push   %esi
  8041ab:	53                   	push   %ebx
  8041ac:	83 ec 1c             	sub    $0x1c,%esp
  8041af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8041b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8041b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8041bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8041c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8041c7:	89 f3                	mov    %esi,%ebx
  8041c9:	89 fa                	mov    %edi,%edx
  8041cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8041cf:	89 34 24             	mov    %esi,(%esp)
  8041d2:	85 c0                	test   %eax,%eax
  8041d4:	75 1a                	jne    8041f0 <__umoddi3+0x48>
  8041d6:	39 f7                	cmp    %esi,%edi
  8041d8:	0f 86 a2 00 00 00    	jbe    804280 <__umoddi3+0xd8>
  8041de:	89 c8                	mov    %ecx,%eax
  8041e0:	89 f2                	mov    %esi,%edx
  8041e2:	f7 f7                	div    %edi
  8041e4:	89 d0                	mov    %edx,%eax
  8041e6:	31 d2                	xor    %edx,%edx
  8041e8:	83 c4 1c             	add    $0x1c,%esp
  8041eb:	5b                   	pop    %ebx
  8041ec:	5e                   	pop    %esi
  8041ed:	5f                   	pop    %edi
  8041ee:	5d                   	pop    %ebp
  8041ef:	c3                   	ret    
  8041f0:	39 f0                	cmp    %esi,%eax
  8041f2:	0f 87 ac 00 00 00    	ja     8042a4 <__umoddi3+0xfc>
  8041f8:	0f bd e8             	bsr    %eax,%ebp
  8041fb:	83 f5 1f             	xor    $0x1f,%ebp
  8041fe:	0f 84 ac 00 00 00    	je     8042b0 <__umoddi3+0x108>
  804204:	bf 20 00 00 00       	mov    $0x20,%edi
  804209:	29 ef                	sub    %ebp,%edi
  80420b:	89 fe                	mov    %edi,%esi
  80420d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804211:	89 e9                	mov    %ebp,%ecx
  804213:	d3 e0                	shl    %cl,%eax
  804215:	89 d7                	mov    %edx,%edi
  804217:	89 f1                	mov    %esi,%ecx
  804219:	d3 ef                	shr    %cl,%edi
  80421b:	09 c7                	or     %eax,%edi
  80421d:	89 e9                	mov    %ebp,%ecx
  80421f:	d3 e2                	shl    %cl,%edx
  804221:	89 14 24             	mov    %edx,(%esp)
  804224:	89 d8                	mov    %ebx,%eax
  804226:	d3 e0                	shl    %cl,%eax
  804228:	89 c2                	mov    %eax,%edx
  80422a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80422e:	d3 e0                	shl    %cl,%eax
  804230:	89 44 24 04          	mov    %eax,0x4(%esp)
  804234:	8b 44 24 08          	mov    0x8(%esp),%eax
  804238:	89 f1                	mov    %esi,%ecx
  80423a:	d3 e8                	shr    %cl,%eax
  80423c:	09 d0                	or     %edx,%eax
  80423e:	d3 eb                	shr    %cl,%ebx
  804240:	89 da                	mov    %ebx,%edx
  804242:	f7 f7                	div    %edi
  804244:	89 d3                	mov    %edx,%ebx
  804246:	f7 24 24             	mull   (%esp)
  804249:	89 c6                	mov    %eax,%esi
  80424b:	89 d1                	mov    %edx,%ecx
  80424d:	39 d3                	cmp    %edx,%ebx
  80424f:	0f 82 87 00 00 00    	jb     8042dc <__umoddi3+0x134>
  804255:	0f 84 91 00 00 00    	je     8042ec <__umoddi3+0x144>
  80425b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80425f:	29 f2                	sub    %esi,%edx
  804261:	19 cb                	sbb    %ecx,%ebx
  804263:	89 d8                	mov    %ebx,%eax
  804265:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804269:	d3 e0                	shl    %cl,%eax
  80426b:	89 e9                	mov    %ebp,%ecx
  80426d:	d3 ea                	shr    %cl,%edx
  80426f:	09 d0                	or     %edx,%eax
  804271:	89 e9                	mov    %ebp,%ecx
  804273:	d3 eb                	shr    %cl,%ebx
  804275:	89 da                	mov    %ebx,%edx
  804277:	83 c4 1c             	add    $0x1c,%esp
  80427a:	5b                   	pop    %ebx
  80427b:	5e                   	pop    %esi
  80427c:	5f                   	pop    %edi
  80427d:	5d                   	pop    %ebp
  80427e:	c3                   	ret    
  80427f:	90                   	nop
  804280:	89 fd                	mov    %edi,%ebp
  804282:	85 ff                	test   %edi,%edi
  804284:	75 0b                	jne    804291 <__umoddi3+0xe9>
  804286:	b8 01 00 00 00       	mov    $0x1,%eax
  80428b:	31 d2                	xor    %edx,%edx
  80428d:	f7 f7                	div    %edi
  80428f:	89 c5                	mov    %eax,%ebp
  804291:	89 f0                	mov    %esi,%eax
  804293:	31 d2                	xor    %edx,%edx
  804295:	f7 f5                	div    %ebp
  804297:	89 c8                	mov    %ecx,%eax
  804299:	f7 f5                	div    %ebp
  80429b:	89 d0                	mov    %edx,%eax
  80429d:	e9 44 ff ff ff       	jmp    8041e6 <__umoddi3+0x3e>
  8042a2:	66 90                	xchg   %ax,%ax
  8042a4:	89 c8                	mov    %ecx,%eax
  8042a6:	89 f2                	mov    %esi,%edx
  8042a8:	83 c4 1c             	add    $0x1c,%esp
  8042ab:	5b                   	pop    %ebx
  8042ac:	5e                   	pop    %esi
  8042ad:	5f                   	pop    %edi
  8042ae:	5d                   	pop    %ebp
  8042af:	c3                   	ret    
  8042b0:	3b 04 24             	cmp    (%esp),%eax
  8042b3:	72 06                	jb     8042bb <__umoddi3+0x113>
  8042b5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8042b9:	77 0f                	ja     8042ca <__umoddi3+0x122>
  8042bb:	89 f2                	mov    %esi,%edx
  8042bd:	29 f9                	sub    %edi,%ecx
  8042bf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8042c3:	89 14 24             	mov    %edx,(%esp)
  8042c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8042ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  8042ce:	8b 14 24             	mov    (%esp),%edx
  8042d1:	83 c4 1c             	add    $0x1c,%esp
  8042d4:	5b                   	pop    %ebx
  8042d5:	5e                   	pop    %esi
  8042d6:	5f                   	pop    %edi
  8042d7:	5d                   	pop    %ebp
  8042d8:	c3                   	ret    
  8042d9:	8d 76 00             	lea    0x0(%esi),%esi
  8042dc:	2b 04 24             	sub    (%esp),%eax
  8042df:	19 fa                	sbb    %edi,%edx
  8042e1:	89 d1                	mov    %edx,%ecx
  8042e3:	89 c6                	mov    %eax,%esi
  8042e5:	e9 71 ff ff ff       	jmp    80425b <__umoddi3+0xb3>
  8042ea:	66 90                	xchg   %ax,%ax
  8042ec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042f0:	72 ea                	jb     8042dc <__umoddi3+0x134>
  8042f2:	89 d9                	mov    %ebx,%ecx
  8042f4:	e9 62 ff ff ff       	jmp    80425b <__umoddi3+0xb3>
